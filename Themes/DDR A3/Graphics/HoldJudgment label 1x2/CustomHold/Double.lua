-- DDR double hold judgment system (arcade style)
-- This code has been written collaboratively by Claude and DeepSeek R1.
-- Please do not consider this code production ready.

t = Def.ActorFrame {}

local spacing = 63
local pn = PLAYER_1
local valign = GAMESTATE:PlayerIsUsingModifier(pn, "Reverse") and 225 or 0

-- Create a buffer for each jump combination
local jumpBuffers = {
    ["12"] = {count = 0, lastTime = 0},    -- 1 and 2
    ["14"] = {count = 0, lastTime = 0},    -- 1 and 4
    ["23"] = {count = 0, lastTime = 0},    -- 2 and 3
    ["34"] = {count = 0, lastTime = 0},    -- 3 and 4
    ["24"] = {count = 0, lastTime = 0},    -- 2 and 4
    ["13"] = {count = 0, lastTime = 0},    -- 1 and 3
    ["15"] = {count = 0, lastTime = 0},    -- 1 and 5
    ["16"] = {count = 0, lastTime = 0},    -- 1 and 6
    ["17"] = {count = 0, lastTime = 0},    -- 1 and 7
    ["18"] = {count = 0, lastTime = 0},    -- 1 and 8
    ["25"] = {count = 0, lastTime = 0},    -- 2 and 5
    ["26"] = {count = 0, lastTime = 0},    -- 2 and 6
    ["27"] = {count = 0, lastTime = 0},    -- 2 and 7
    ["28"] = {count = 0, lastTime = 0},    -- 2 and 8
    ["35"]=  {count = 0, lastTime = 0},    -- 3 and 5
    ["36"] = {count = 0, lastTime = 0},    -- 3 and 6
    ["37"] = {count = 0, lastTime = 0},    -- 3 and 7
    ["38"] = {count = 0, lastTime = 0},    -- 3 and 8
    ["45"] = {count = 0, lastTime = 0},    -- 4 and 5
    ["46"] = {count = 0, lastTime = 0},    -- 4 and 6
    ["47"] = {count = 0, lastTime = 0},    -- 4 and 7
    ["48"] = {count = 0, lastTime = 0},    -- 4 and 8
    ["56"] = {count = 0, lastTime = 0},    -- 5 and 6
    ["57"] = {count = 0, lastTime = 0},    -- 5 and 7
    ["58"] = {count = 0, lastTime = 0},    -- 5 and 8
    ["67"] = {count = 0, lastTime = 0},    -- 6 and 7
    ["68"] = {count = 0, lastTime = 0},    -- 6 and 8
    ["78"] = {count = 0, lastTime = 0}     -- 7 and 8
}

-- Configuration
local BUFFER_WINDOW = 1 / 144    -- 30ms window to detect simultaneous holds
local DISPLAY_TIME = 0.5         -- How long to show the judgment
local RESET_DELAY = 1 / 144      -- How long to wait before resetting (1 frame at 60fps)

local HoldNoteScore = nil
local judgmentsThisFrame = 0
local lastFrameTime = 0

-- Helper function to check if a hold is within the buffer window
local function isWithinBufferWindow(lastTime)
    return (GetTimeSinceStart() - lastTime) <= BUFFER_WINDOW
end

-- Helper function to handle jump detection
local function handleJumpDetection(buffer, sprite, initialJudgment, judgment)
    if not initialJudgment and judgment then return end
    local currentTime = GetTimeSinceStart()
    
    if buffer.count == 0 or not isWithinBufferWindow(buffer.lastTime) then
        buffer.count = 1
        buffer.lastTime = currentTime
        buffer.judgments = {judgment}
    else
        buffer.count = buffer.count + 1
        buffer.judgments = buffer.judgments or {}
        table.insert(buffer.judgments, judgment)
        
        if buffer.count == 2 then
            -- Set state based on judgments
            local state = 0    -- Default OK state
            for _, j in ipairs(buffer.judgments) do
                if j == "HoldNoteScore_LetGo" then
                    state = 1    -- NG state if any judgment was NG
                    break
                end
            end
            
            sprite:setstate(state)
            sprite:diffusealpha(1)
            sprite:sleep(DISPLAY_TIME)
            sprite:diffusealpha(0)
            
            -- Reset after displaying
            buffer.count = 0
            buffer.lastTime = 0
            buffer.judgments = {}
        end
    end
end

-- Create individual hold judgments for 8 columns
for i = 1, 8, 1 do
    t[#t+1] = Def.Sprite {
        Texture = THEME:GetPathG("", "HoldJudgment label 1x2/Hold"),
        InitCommand = function(s)
            s:diffusealpha(0)
            s:x(i * spacing)
            s:pause()
            s:addy(125)
            s:addx(144)
            s:addy(valign)
            s:zoom(0.25)
        end,
        JudgmentMessageCommand = function(s, p)
            if p.HoldNoteScore and p.FirstTrack + 1 == i then
                HoldNoteScore = p.HoldNoteScore
                local currentTime = GetTimeSinceStart()
                
                if (currentTime - lastFrameTime) > RESET_DELAY then
                    judgmentsThisFrame = 0
                    lastFrameTime = currentTime
                end
                
                judgmentsThisFrame = judgmentsThisFrame + 1
                
                s:sleep(RESET_DELAY)
                s:queuecommand("CheckJudgments")
            end
        end,
        CheckJudgmentsCommand = function(s)
            if judgmentsThisFrame == 1 then
                s:diffusealpha(1)
                if HoldNoteScore == "HoldNoteScore_Held" then
                    s:setstate(0)
                elseif HoldNoteScore == "HoldNoteScore_LetGo" then
                    s:setstate(1)
                end
                s:sleep(DISPLAY_TIME)
                s:diffusealpha(0)
            end
            judgmentsThisFrame = 0
            HoldNoteScore = nil
        end
    }
end

-- Create jump combinations for 8 columns
local jumpCombos = {
    {name = "12", cols = {1, 2}, x = 210},     -- 1 and 2
    {name = "14", cols = {1, 4}, x = 270},     -- 1 and 4
    {name = "23", cols = {2, 3}, x = 270},     -- 2 and 3
    {name = "34", cols = {3, 4}, x = 330},     -- 3 and 4
    {name = "24", cols = {2, 4}, x = 305},     -- 2 and 4
    {name = "13", cols = {1, 3}, x = 240},     -- 1 and 3
    {name = "15", cols = {1, 5}, x = 350},     -- 1 and 5
    {name = "16", cols = {1, 6}, x = 305},     -- 1 and 6
    {name = "17", cols = {1, 7}, x = 380},     -- 1 and 7
    {name = "18", cols = {1, 8}, x = 400},     -- 1 and 8
    {name = "25", cols = {2, 5}, x = 335},     -- 2 and 5
    {name = "26", cols = {2, 6}, x = 370},     -- 2 and 6
    {name = "27", cols = {2, 7}, x = 400},     -- 2 and 7
    {name = "28", cols = {2, 8}, x = 435},     -- 2 and 8
    {name = "35", cols = {3, 5}, x = 370},     -- 3 and 5
    {name = "36", cols = {3, 6}, x = 400},     -- 3 and 6
    {name = "37", cols = {3, 7}, x = 435},     -- 3 and 7
    {name = "38", cols = {3, 8}, x = 465},     -- 3 and 8
    {name = "45", cols = {4, 5}, x = 400},     -- 4 and 5
    {name = "46", cols = {4, 6}, x = 435},     -- 4 and 6
    {name = "47", cols = {4, 7}, x = 500},     -- 4 and 7
    {name = "48", cols = {4, 8}, x = 500},     -- 4 and 8
    {name = "56", cols = {5, 6}, x = 465},     -- 5 and 6
    {name = "57", cols = {5, 7}, x = 500},     -- 5 and 7
    {name = "58", cols = {5, 8}, x = 500},     -- 5 and 8
    {name = "67", cols = {6, 7}, x = 530},     -- 6 and 7
    {name = "68", cols = {6, 8}, x = 560},     -- 6 and 8
    {name = "78", cols = {7, 8}, x = 590}      -- 7 and 8
}

for _, combo in ipairs(jumpCombos) do
    t[#t+1] = Def.Sprite {
        Texture = THEME:GetPathG("", "HoldJudgment label 1x2/Hold"),
        InitCommand = function(s)
            s:diffusealpha(0)
            s:x(combo.x)
            s:pause()
            s:addy(125)
            s:addx(27)
            s:addy(valign)
            s:zoom(0.25)
        end,
        JudgmentMessageCommand = function(s, p)
            if p.HoldNoteScore then
                local track = p.FirstTrack + 1
                if track == combo.cols[1] or track == combo.cols[2] then
                    handleJumpDetection(jumpBuffers[combo.name], s, p.HoldNoteScore)
                end
            end
        end
    }
end

return t