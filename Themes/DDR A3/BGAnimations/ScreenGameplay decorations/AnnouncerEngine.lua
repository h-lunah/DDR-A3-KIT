local t = Def.ActorFrame {}

local soundPlaying = false
local lastSoundPlayedTime = 0 -- Track the last time a sound was played
local globalCooldown = 7 * #GAMESTATE:GetEnabledPlayers() -- Global cooldown period in seconds

local firstBPMComboPlayed = false -- Flag to ensure the first BPM-based milestone is a combo
local firstStepMade = false -- Flag to check if the first step is made

local currentSong = GAMESTATE:GetCurrentSong() -- Current song
local bpm = 0 -- Current song speed
local songLength = 0 -- Current song length

local minMilestoneDistance = 10 -- How many combos must a next milestone be after the previous one

-- Separate combo tracking for each player
local playerCombos = {
    [PLAYER_1] = 0,
    [PLAYER_2] = 0
}

local playerMissCombos = {
    [PLAYER_1] = 0,
    [PLAYER_2] = 0
}

local playerJudgedMines = {
    [PLAYER_1] = 0,
    [PLAYER_2] = 0
}

local playerLastComboMilestonePlayed = {
    [PLAYER_1] = 0,
    [PLAYER_2] = 0
}

local playerLastCheeringComboPlayed = {
    [PLAYER_1] = 0,
    [PLAYER_2] = 0
}

local playerLastFixedComboMilestonePlayed = {
    [PLAYER_1] = 0,
    [PLAYER_2] = 0
}

local playerLastTimeMilestonePlayed = {
    [PLAYER_1] = 0,
    [PLAYER_2] = 0
}

local playerLastCrowdCuePlayed = {
    [PLAYER_1] = 0,
    [PLAYER_2] = 0
}

-- Functions to generate milestone thresholds based on bpm and song length:
local function getComboThresholds(bpm)
    local milestones = {}
    local baseThreshold = 50

    if bpm >= 200 then
        baseThreshold = 20
    elseif bpm >= 180 then
        baseThreshold = 25
    elseif bpm >= 160 then
        baseThreshold = 30
    elseif bpm >= 140 then
        baseThreshold = 35
    elseif bpm >= 120 then
        baseThreshold = 40
    else
        baseThreshold = 45
    end

    for i = baseThreshold, 1000, baseThreshold do
        table.insert(milestones, i)
    end

    -- Always include every 100 combos as special milestones
    for i = 100, 1000, 100 do
        table.insert(milestones, i)
    end

    return milestones
end

local function getCheeringThresholds(bpm)
    local milestones = {}
    local baseCheeringThreshold = 100

    if bpm >= 200 then
        baseCheeringThreshold = 70
    elseif bpm >= 180 then
        baseCheeringThreshold = 75
    elseif bpm >= 160 then
        baseCheeringThreshold = 80
    elseif bpm >= 140 then
        baseCheeringThreshold = 85
    elseif bpm >= 120 then
        baseCheeringThreshold = 90
    else
        baseCheeringThreshold = 95
    end

    for i = baseCheeringThreshold, 1000, baseCheeringThreshold do
        table.insert(milestones, i)
    end

    return milestones
end

local function getCrowdThresholds(bpm)
    local milestones = {}
    local baseCrowdThreshold = 90

    if bpm >= 200 then
        baseCrowdThreshold = 30
    elseif bpm >= 180 then
        baseCrowdThreshold = 40
    elseif bpm >= 160 then
        baseCrowdThreshold = 50
    elseif bpm >= 140 then
        baseCrowdThreshold = 60
    elseif bpm >= 120 then
        baseCrowdThreshold = 70
    else
        baseCrowdThreshold = 80
    end

    for i = baseCrowdThreshold, 1000, baseCrowdThreshold do
        table.insert(milestones, i)
    end

    return milestones
end

local function getTimeThresholds(songLength)
    local baseThreshold = 15
    local milestones = {}

    for i = 1, math.floor(songLength / baseThreshold) do
        local milestone = baseThreshold * i
        table.insert(milestones, milestone)
    end

    return milestones
end

local function updateSongInfo()
    currentSong = GAMESTATE:GetCurrentSong()
    if currentSong then
        bpm = currentSong:GetDisplayBpms()[2] or 0
        songLength = currentSong:GetLastSecond() or 0

        comboThresholds = getComboThresholds(bpm)
        cheeringThresholds = getCheeringThresholds(bpm)
        timeThresholds = getTimeThresholds(songLength)
        crowdThresholds = getCrowdThresholds(bpm)
    end
end

-- Ensure song info is populated when gameplay starts
t[#t+1] = Def.ActorFrame {
    OnCommand = function(self)
        self:sleep(0.5):queuecommand("UpdateSongInfo")
    end,
    CurrentSongChangedMessageCommand = function(self)
        self:sleep(0.5):queuecommand("UpdateSongInfo")
    end,
    UpdateSongInfoCommand = function(self)
        updateSongInfo()
    end,
}

local function everyoneIsInDanger()
    -- Check if all players are in danger
    local playersInDanger = {}

    for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
        if GAMESTATE:GetPlayerState(pn):GetHealthState() == "HealthState_Danger" then
            playersInDanger[pn] = true
        else
            playersInDanger[pn] = false
        end
    end

    for _, value in pairs(playersInDanger) do
        if value ~= true then
            return false
        end
    end
    return true
end

t[#t+1] = Def.ActorFrame {
    OnCommand=function(s)
        s:sleep(BeginReadyDelay())
        s:queuecommand("PlayReady")
    end;
    PlayReadyCommand=function(s)
        -- Announcer does not speak during "LET'S CHECK YOUR LEVEL!"
        if GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "LET'S CHECK YOUR LEVEL!" or 
           GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Steps to the Star" then return end
        SOUND:PlayAnnouncer("gameplay ready ac")
    end
}

t[#t+1] = Def.ActorFrame{
    JudgmentMessageCommand=function(self, params)
        local pn = params.Player
        if params.TapNoteScore == "TapNoteScore_Miss" or params.TapNoteScore == "TapNoteScore_HitMine" or params.HoldNoteScore == "HoldNoteScore_LetGo" then
            if params.HoldNoteScore == "HoldNoteScore_MissedHold" then return end
            playerJudgedMines[pn] = 0
            playerCombos[pn] = 0
            playerMissCombos[pn] = playerMissCombos[pn] + 1
        elseif params.TapNoteScore == "TapNoteScore_AvoidMine" then
            playerJudgedMines[pn] = playerJudgedMines[pn] + 1
            if playerJudgedMines[pn] >= 4 then
                playerJudgedMines[pn] = 0
                playerCombos[pn] = playerCombos[pn] + 1
            end
            playerMissCombos[pn] = 0
        else
            if params.HoldNoteScore == "HoldNoteScore_Held" then return end
            playerJudgedMines[pn] = 0
            playerCombos[pn] = playerCombos[pn] + 1
            playerMissCombos[pn] = 0
        end

        local songPosition = GAMESTATE:GetSongPosition()
        local currentTime = songPosition:GetMusicSeconds()

        -- Check if the first step is made
        if playerCombos[pn] > 0 or playerMissCombos[pn] > 0 then
            firstStepMade = true
        end

        -- Prevent announcer from playing before the first step is made
        if not firstStepMade then return end

        -- Announcer does not speak during "LET'S CHECK YOUR LEVEL!"
        if GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "LET'S CHECK YOUR LEVEL!" or 
           GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Steps to the Star" then return end

        -- Special milestones for 100 - 1000 combos (always play these)
        if playerCombos[pn] > 1000 and playerCombos[pn] % 100 == 0 and 
           playerLastComboMilestonePlayed[pn] ~= playerCombos[pn] and 
           playerCombos[PLAYER_1] ~= playerCombos[PLAYER_2] and 
           GAMESTATE:GetPlayerState(pn):GetPlayerController() ~= "PlayerController_Autoplay" then
            SOUND:PlayAnnouncer("combo overflow ac")
            playerLastComboMilestonePlayed[pn] = playerCombos[pn]
            lastSoundPlayedTime = currentTime
            return
        end

        if playerCombos[pn] > 0 and playerCombos[pn] % 100 == 0 and 
           playerLastComboMilestonePlayed[pn] ~= playerCombos[pn] and 
           playerCombos[PLAYER_1] ~= playerCombos[PLAYER_2] and 
           GAMESTATE:GetPlayerState(pn):GetPlayerController() ~= "PlayerController_Autoplay" then
            SOUND:PlayAnnouncer("combo " .. playerCombos[pn] .. " ac")
            playerLastComboMilestonePlayed[pn] = playerCombos[pn]
            lastSoundPlayedTime = currentTime
            return
        end

        if playerCombos[pn] > 0 or playerMissCombos[pn] > 0 then
            if playerCombos[pn] == 0 and playerMissCombos[pn] > 0 then
                playerCombos[pn] = playerCombos[pn]
            end

            -- Timed announcer lines (unchanged)
            for i = 1, #timeThresholds do
                local time = timeThresholds[i]
                local nextTime = timeThresholds[i + 1]
                local currentPosition = GAMESTATE:GetPlayerState(pn):GetSongPosition():GetMusicSeconds()
            
                if currentPosition >= time and (not nextTime or currentPosition < nextTime) and 
                   playerLastTimeMilestonePlayed[pn] ~= time and not soundPlaying and 
                   (currentTime - lastSoundPlayedTime) >= globalCooldown then
                    local randomCheer = math.random(1, 10)
                    if randomCheer == 1 and everyoneIsInDanger() then
                        SOUND:PlayAnnouncer("booing normal ac")
                        SOUND:PlayAnnouncer("crowd cues danger ac")
                    elseif randomCheer == 1 and not everyoneIsInDanger() then
                        SOUND:PlayAnnouncer("cheering normal ac")
                        SOUND:PlayAnnouncer("crowd cues ac")
                    elseif randomCheer ~= 1 and everyoneIsInDanger() then
                        SOUND:PlayAnnouncer("combo 50 danger ac")
                    elseif randomCheer ~= 1 and not everyoneIsInDanger() then
                        SOUND:PlayAnnouncer("combo 50 ac")
                    end
                    playerLastTimeMilestonePlayed[pn] = time
                    soundPlaying = true
                    lastSoundPlayedTime = currentTime
                    self:sleep(globalCooldown):queuecommand("ResetSoundFlag")
                    return
                end
            end

            -- Fixed 50 combo milestone (unchanged)
            if playerCombos[pn] % 50 == 0 and playerCombos[pn] % 100 ~= 0 and 
               playerLastFixedComboMilestonePlayed[pn] ~= playerCombos[pn] and 
               (playerCombos[pn] - playerLastComboMilestonePlayed[pn]) >= minMilestoneDistance and 
               (currentTime - lastSoundPlayedTime) >= globalCooldown then
                if everyoneIsInDanger() then
                    SOUND:PlayAnnouncer("combo 50 danger ac")
                else
                    SOUND:PlayAnnouncer("combo 50 ac")
                end
                playerLastFixedComboMilestonePlayed[pn] = playerCombos[pn]
                playerLastComboMilestonePlayed[pn] = playerCombos[pn]
                lastSoundPlayedTime = currentTime
                soundPlaying = true
                self:sleep(globalCooldown):queuecommand("ResetSoundFlag")
                return
            end

            -- BPM-based combo milestones (modified to play both sounds together)
            if not soundPlaying then
                for _, milestone in ipairs(comboThresholds) do
                    if playerCombos[pn] == milestone and 
                       playerLastComboMilestonePlayed[pn] ~= playerCombos[pn] and 
                       (playerCombos[pn] - playerLastComboMilestonePlayed[pn]) >= minMilestoneDistance and 
                       (currentTime - lastSoundPlayedTime) >= globalCooldown then
                        -- Play both the combo cheering and crowd cues together
                        if everyoneIsInDanger() then
                            SOUND:PlayAnnouncer("combo booing ac")
                            SOUND:PlayAnnouncer("crowd cues danger ac")
                        else
                            SOUND:PlayAnnouncer("combo cheering ac")
                            SOUND:PlayAnnouncer("crowd cues ac")
                        end
                        playerLastComboMilestonePlayed[pn] = playerCombos[pn]
                        lastSoundPlayedTime = currentTime
                        soundPlaying = true
                        self:sleep(globalCooldown):queuecommand("ResetSoundFlag")
                        return
                    end
                end
            end

            -- Cheering thresholds branch (unchanged)
            for _, milestone in ipairs(cheeringThresholds) do
                if playerCombos[pn] == milestone and 
                   playerLastCheeringComboPlayed[pn] ~= playerCombos[pn] and 
                   (playerCombos[pn] - playerLastCheeringComboPlayed[pn]) >= minMilestoneDistance and 
                   (currentTime - lastSoundPlayedTime) >= globalCooldown then
                    if everyoneIsInDanger() then
                        SOUND:PlayAnnouncer("booing normal ac")
                    else
                        SOUND:PlayAnnouncer("cheering normal ac")
                    end
                    playerLastCheeringComboPlayed[pn] = playerCombos[pn]
                    lastSoundPlayedTime = currentTime
                    soundPlaying = true
                    self:sleep(globalCooldown):queuecommand("ResetSoundFlag")
                    return
                end
            end

            if playerCombos[pn] == 0 and not soundPlaying then
                if playerCombos[pn] > 0 and playerCombos[pn] < 50 then
                    if everyoneIsInDanger() then
                        SOUND:PlayAnnouncer("combo 50 danger ac")
                    else
                        SOUND:PlayAnnouncer("combo 50 ac")
                    end
                    soundPlaying = true
                    self:sleep(globalCooldown):queuecommand("ResetSoundFlag")
                    return
                end

                playerLastComboMilestonePlayed[pn] = 0
                playerLastCheeringComboPlayed[pn] = 0
                playerLastFixedComboMilestonePlayed[pn] = 0
            end
        end
    end,

    ResetSoundFlagCommand=function(self)
        soundPlaying = false
    end,
}

return t
