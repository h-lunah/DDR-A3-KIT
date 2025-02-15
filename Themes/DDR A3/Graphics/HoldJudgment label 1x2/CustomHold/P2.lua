-- DDR hold judgment system (arcade style)
-- This code has been written collaboratively by Claude and DeepSeek R1.
-- Please do not consider this code production ready.

t = Def.ActorFrame {}

local spacing = 64
local pn = PLAYER_2
local halign = 480
local valign = GAMESTATE:PlayerIsUsingModifier(pn, "Reverse") and 225 or 0

-- Create a buffer for each jump combination
local jumpBuffers = {
    ld = {count = 0, lastTime = 0},    -- left-down
    ur = {count = 0, lastTime = 0},    -- up-right
    du = {count = 0, lastTime = 0},    -- down-up
    lr = {count = 0, lastTime = 0},    -- left-right
    lu = {count = 0, lastTime = 0},    -- left-up
    rd = {count = 0, lastTime = 0}     -- right-down
}

-- Configuration
local BUFFER_WINDOW = 1 / 60    -- 30ms window to detect simultaneous holds
local DISPLAY_TIME = 0.5         -- How long to show the judgment
local RESET_DELAY = 1 / 60      -- How long to wait before resetting (1 frame at 60fps)

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
        buffer.judgments = { judgment }
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
                elseif j == "HoldNoteScore_MissedHold" then
                    return
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

-- Create individual hold judgments
for i=1,4,1 do
    t[#t+1] = Def.Sprite {
        Texture=THEME:GetPathG("", "HoldJudgment label 1x2/Hold"),
        InitCommand=function(s)
            s:diffusealpha(0)
            s:x(i * spacing)
            s:pause()
            s:addy(125)
            s:addx(27)
            s:addx(halign)
            s:addy(valign)
            s:zoom(0.25)
        end,
        JudgmentMessageCommand=function(s, p)
            if p.Player == pn and p.HoldNoteScore and p.FirstTrack + 1 == i then
                HoldNoteScore = p.HoldNoteScore
                local currentTime = GetTimeSinceStart()
   
                -- Reset counter if we're in a new frame
                if (currentTime - lastFrameTime) > RESET_DELAY then
                    judgmentsThisFrame = 0
                    lastFrameTime = currentTime
                end
   
                -- Increment counter for this frame
                judgmentsThisFrame = judgmentsThisFrame + 1
   
                -- Schedule a check after RESET_DELAY to see if more judgments came
                s:sleep(RESET_DELAY)
                s:queuecommand("CheckJudgments")
            end
        end,
        CheckJudgmentsCommand=function(s)
            -- If only one judgment occurred in this frame, show it
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
            -- Reset the counter for the next frame
            judgmentsThisFrame = 0
            HoldNoteScore = nil
        end
    }
end

-- Create jump combinations
local jumpCombos = {
    {name = "ld", cols = {1, 2}, x = 100},    -- left-down
    {name = "lr", cols = {1, 4}, x = 160},    -- left-right
    {name = "du", cols = {2, 3}, x = 160},    -- down-up
    {name = "ur", cols = {3, 4}, x = 220},    -- up-right
    {name = "rd", cols = {2, 4}, x = 190},    -- right-down
    {name = "lu", cols = {1, 3}, x = 130}     -- left-up
}

for _, combo in ipairs(jumpCombos) do
    t[#t+1] = Def.Sprite {
        Texture=THEME:GetPathG("", "HoldJudgment label 1x2/Hold"),
        InitCommand=function(s)
            s:diffusealpha(0)
            s:x(combo.x)
            s:pause()
            s:addy(125)
            s:addx(27)
            s:addx(halign)
            s:addy(valign)
            s:zoom(0.25)
        end,
        JudgmentMessageCommand=function(s, p)
            if p.Player == pn and p.HoldNoteScore then

                local track = p.FirstTrack + 1
                if track == combo.cols[1] or track == combo.cols[2] then
                    handleJumpDetection(jumpBuffers[combo.name], s, p.TapNoteScore, p.HoldNoteScore)
                end
            end
        end
    }
end

return t;