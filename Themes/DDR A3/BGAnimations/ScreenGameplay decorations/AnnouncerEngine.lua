local t = Def.ActorFrame {}

local soundPlaying = false
local lastSoundPlayedTime = 0 -- Track the last time a sound was played
local globalCooldown = 3 * #GAMESTATE:GetEnabledPlayers()-- Global cooldown period in seconds

local firstBPMComboPlayed = false -- Flag to ensure the first BPM-based milestone is a combo
local firstStepMade = false -- Flag to check if the first step is made

local alternateSoundIndex = 0 -- Index to alternate between combo and cheering

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
    local baseCheeringThreshold = 75

    if bpm >= 200 then
        baseCheeringThreshold = 45
    elseif bpm >= 180 then
        baseCheeringThreshold = 50
    elseif bpm >= 160 then
        baseCheeringThreshold = 60
    elseif bpm >= 140 then
        baseCheeringThreshold = 70
    elseif bpm >= 120 then
        baseCheeringThreshold = 75
    else
        baseCheeringThreshold = 85
    end

    for i = baseCheeringThreshold, 1000, baseCheeringThreshold do
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
        if GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "LET'S CHECK YOUR LEVEL!" or GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Steps to the Star" then return end
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
        if GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "LET'S CHECK YOUR LEVEL!" or GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Steps to the Star" then return end

        -- Handle special milestones for 100 - 1000 combos (always play these)
        if playerCombos[pn] > 1000 and playerCombos[pn] % 100 == 0 and playerLastComboMilestonePlayed[pn] ~= playerCombos[pn] and playerCombos[PLAYER_1] ~= playerCombos[PLAYER_2] and GAMESTATE:GetPlayerState(pn):GetPlayerController() ~= "PlayerController_Autoplay" then
            SOUND:PlayAnnouncer("combo overflow ac")
            playerLastComboMilestonePlayed[pn] = playerCombos[pn]
            lastSoundPlayedTime = currentTime
        return end

        if playerCombos[pn] > 0 and playerCombos[pn] % 100 == 0 and playerLastComboMilestonePlayed[pn] ~= playerCombos[pn] and playerCombos[PLAYER_1] ~= playerCombos[PLAYER_2] and GAMESTATE:GetPlayerState(pn):GetPlayerController() ~= "PlayerController_Autoplay" then
            SOUND:PlayAnnouncer("combo " .. playerCombos[pn] .. " ac")
            playerLastComboMilestonePlayed[pn] = playerCombos[pn]
            lastSoundPlayedTime = currentTime
        return end

        if playerCombos[pn] > 0 or playerMissCombos[pn] > 0 then
            if playerCombos[pn] == 0 and playerMissCombos[pn] > 0 then
                playerCombos[pn] = playerCombos[pn]
            end

            -- Play timed announcer lines to make sure the announcer isn't completely quiet during very easy songs
            for i = 1, #timeThresholds do
                local time = timeThresholds[i]
                local nextTime = timeThresholds[i + 1]

                local currentPosition = GAMESTATE:GetPlayerState(pn):GetSongPosition():GetMusicSeconds()
            
                if currentPosition >= time and (not nextTime or currentPosition < nextTime) and playerLastTimeMilestonePlayed[pn] ~= time and not soundPlaying and (currentTime - lastSoundPlayedTime) >= globalCooldown then
                    local randomCheer = math.random(0, 1)

                    if randomCheer == 0 then
                        if everyoneIsInDanger() then
                            SOUND:PlayAnnouncer("booing normal ac")
                        else
                            SOUND:PlayAnnouncer("cheering normal ac")
                        end
                    else
                        if everyoneIsInDanger() then
                            SOUND:PlayAnnouncer("combo 50 danger ac")
                        else
                            SOUND:PlayAnnouncer("combo 50 ac")
                        end
                    end
                    
                    playerLastTimeMilestonePlayed[pn] = time
                    soundPlaying = true
                    lastSoundPlayedTime = currentTime
                    self:sleep(globalCooldown):queuecommand("ResetSoundFlag")
                end
            end

            -- Check fixed 50 combo milestones first (not divisible by 100)
            if playerCombos[pn] % 50 == 0 and playerCombos[pn] % 100 ~= 0 and playerLastFixedComboMilestonePlayed[pn] ~= playerCombos[pn] and (playerCombos[pn] - playerLastComboMilestonePlayed[pn]) >= minMilestoneDistance and (currentTime - lastSoundPlayedTime) >= globalCooldown then
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
            return end

            -- Check BPM-based combo milestones
            if not soundPlaying then
                for _, milestone in ipairs(comboThresholds) do
                    if playerCombos[pn] == milestone and playerLastComboMilestonePlayed[pn] ~= playerCombos[pn] and (playerCombos[pn] - playerLastComboMilestonePlayed[pn]) >= minMilestoneDistance and (currentTime - lastSoundPlayedTime) >= globalCooldown then
                        if playerCombos[pn] % 100 ~= 0 and playerCombos[pn] % 50 ~= 0 then -- Skip special milestones and fixed 50 milestones
                            if not firstBPMComboPlayed then
                                if everyoneIsInDanger() then
                                    SOUND:PlayAnnouncer("combo 50 danger ac")
                                else
                                    SOUND:PlayAnnouncer("combo 50 ac")
                                end
                                firstBPMComboPlayed = true
                            else
                                -- Alternate between combo_50 and cheering
                                if alternateSoundIndex == 0 then
                                    if everyoneIsInDanger() then
                                        SOUND:PlayAnnouncer("combo 50 danger ac")
                                    else
                                        SOUND:PlayAnnouncer("combo 50 ac")
                                    end
                                else
                                    if everyoneIsInDanger() then
                                        SOUND:PlayAnnouncer("booing normal ac")
                                    else
                                        SOUND:PlayAnnouncer("cheering normal ac")
                                    end
                                end
                                alternateSoundIndex = (alternateSoundIndex + 1) % 2 -- Cycle through 0, 1
                            end
                        end
                        playerLastComboMilestonePlayed[pn] = playerCombos[pn]
                        lastSoundPlayedTime = currentTime
                        soundPlaying = true
                        self:sleep(globalCooldown):queuecommand("ResetSoundFlag")
                    return end
                end

                -- Check cheering milestones if no combo milestone was played
                for _, milestone in ipairs(cheeringThresholds) do
                    if playerCombos[pn] == milestone and playerLastCheeringComboPlayed[pn] ~= playerCombos[pn] and (playerCombos[pn] - playerLastCheeringComboPlayed[pn]) >= minMilestoneDistance and (currentTime - lastSoundPlayedTime) >= globalCooldown then
                        if everyoneIsInDanger() then
                            SOUND:PlayAnnouncer("booing normal ac")
                        else
                            SOUND:PlayAnnouncer("cheering normal ac")
                        end
                        playerLastCheeringComboPlayed[pn] = playerCombos[pn]
                        lastSoundPlayedTime = currentTime
                        soundPlaying = true
                        self:sleep(globalCooldown):queuecommand("ResetSoundFlag")
                    return end
                end
            end

            -- Handle combo break and ensure fixed 50 combo milestone still goes off
            if playerCombos[pn] == 0 and not soundPlaying then
                if playerCombos[pn] > 0 and playerCombos[pn] < 50 then
                    if everyoneIsInDanger() then
                        SOUND:PlayAnnouncer("combo 50 danger ac")
                    else
                        SOUND:PlayAnnouncer("combo 50 ac")
                    end
                    soundPlaying = true
                    self:sleep(globalCooldown):queuecommand("ResetSoundFlag")
                return end

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