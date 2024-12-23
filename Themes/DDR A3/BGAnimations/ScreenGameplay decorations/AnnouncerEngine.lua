-- DDR A announcer engine (StepMania 5)
-- Announcer talks like he does in DDR.

local t = Def.ActorFrame {}

local soundPlaying = false

local lastComboMilestonePlayed = 0
local lastCheeringComboPlayed = 0
local lastTimeMilestonePlayed = 0
local lastFixedComboMilestonePlayed = 0 -- Track the last fixed 50 combo milestone played

local judgedNotes = 0 -- Count judged notes instead of combos

local comboCooldown = 5 -- Cooldown period for combo milestones
local cheeringCooldown = 5 -- Cooldown period for cheering

local firstBPMComboPlayed = false -- Flag to ensure the first BPM-based milestone is a combo
local firstStepMade = false -- Flag to check if the first step is made

local alternateSoundIndex = 0 -- Index to alternate between combo and cheering

local currentSong = nil
local bpm = 0
local songLength = 0

local function updateSongInfo()
    currentSong = GAMESTATE:GetCurrentSong()
    if currentSong then
        bpm = currentSong:GetDisplayBpms()[2] or 0
        songLength = currentSong:GetLastSecond() or 0
    end
end

-- Ensure song info is populated when gameplay starts
t[#t+1] = Def.ActorFrame {
    OnCommand = function(self)
		if not GAMESTATE:GetCurrentSong() then
        	self:sleep(0.5):queuecommand("UpdateSongInfo")
		end
    end,
    UpdateSongInfoCommand = function(self)
        updateSongInfo()
    end,
}

local function everyoneIsInDanger()
	-- A similar function exists in the StepMania engine internally, but hasn't been exposed to Lua.
	playersInDanger = {}

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

local comboThresholds = getComboThresholds(bpm)

-- Function to determine cheering thresholds based on BPM
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

local cheeringThresholds = getCheeringThresholds(bpm)

-- Function to determine time thresholds based on song length
local function getTimeThresholds(songLength)
	local baseThreshold = 30
	local milestones = {}

	for i = 1, math.floor(songLength / baseThreshold) do
		local milestone = baseThreshold * i
		table.insert(milestones, milestone)
	end

	return milestones
end

local timeThresholds = getTimeThresholds(songLength)

t[#t+1] = Def.ActorFrame {
	OnCommand=function(s)
		s:sleep(BeginReadyDelay())
		s:queuecommand("PlayReady")
	end;
	PlayReadyCommand=function(s)
		SOUND:PlayAnnouncer("gameplay ready ac")
	end
}

t[#t+1] = Def.ActorFrame{
	ComboChangedMessageCommand=function(self, params)
		local combo = params.PlayerStageStats:GetCurrentCombo()
		local missCombo = params.PlayerStageStats:GetCurrentMissCombo()
		
		local maxCombo = params.PlayerStageStats.GetMaxCombo and params.PlayerStageStats:GetMaxCombo() or 0
		local songPosition = GAMESTATE:GetSongPosition()
		local currentTime = songPosition:GetMusicSeconds()

		-- Check if the first step is made
		if combo > 0 or missCombo > 0 then
			firstStepMade = true
		end

		-- Prevent announcer from playing before the first step is made
		if not firstStepMade then return end

		-- Announcer does not speak during "LET'S CHECK YOUR LEVEL!"
		if GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "LET'S CHECK YOUR LEVEL!" or GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Steps to the Star" then return end

		-- Handle special milestones for 100 - 1000 combos (always play these)
		if combo > 1000 and combo % 100 == 0 and lastComboMilestonePlayed ~= combo then
			SOUND:PlayAnnouncer("combo overflow ac")
			lastComboMilestonePlayed = combo
		return end

		if combo > 0 and combo % 100 == 0 and lastComboMilestonePlayed ~= combo then
			SOUND:PlayAnnouncer("combo " .. combo .. " ac")
			lastComboMilestonePlayed = combo
		return end
		

		if combo > 0 or missCombo > 0 then
			if combo == 0 and missCombo > 0 then
				combo = missCombo
			end

			-- Check fixed 50 combo milestones first (not divisible by 100)
			if combo % 50 == 0 and combo % 100 ~= 0 and lastFixedComboMilestonePlayed ~= combo then
				if everyoneIsInDanger() then
					SOUND:PlayAnnouncer("combo 50 danger ac")
				else
					SOUND:PlayAnnouncer("combo 50 ac")
				end
				lastFixedComboMilestonePlayed = combo
				soundPlaying = true
				self:sleep(comboCooldown):queuecommand("ResetSoundFlag")
			return end

			-- Check BPM-based combo milestones
			if not soundPlaying then
				for _, milestone in ipairs(comboThresholds) do
					if combo == milestone and lastComboMilestonePlayed ~= combo then
						if combo % 100 ~= 0 and combo % 50 ~= 0 then -- Skip special milestones and fixed 50 milestones
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
					lastComboMilestonePlayed = combo
					soundPlaying = true
					self:sleep(comboCooldown):queuecommand("ResetSoundFlag")
					return end
				end

				-- Check cheering milestones if no combo milestone was played
				for _, milestone in ipairs(cheeringThresholds) do
					if combo == milestone and lastCheeringComboPlayed ~= combo then
						if everyoneIsInDanger() then
							SOUND:PlayAnnouncer("booing normal ac")
						else
							SOUND:PlayAnnouncer("cheering normal ac")
						end
						lastCheeringComboPlayed = combo
						soundPlaying = true
						self:sleep(cheeringCooldown):queuecommand("ResetSoundFlag")
					return end
				end
			end

			-- Handle combo break and ensure fixed 50 combo milestone still goes off
			if combo == 0 and not soundPlaying then
				if maxCombo > 0 and maxCombo < 50 then
					if everyoneIsInDanger() then
						SOUND:PlayAnnouncer("combo 50 danger ac")
					else
						SOUND:PlayAnnouncer("combo 50 ac")
					end
					soundPlaying = true
					self:sleep(comboCooldown):queuecommand("ResetSoundFlag")
				return end

				lastComboMilestonePlayed = 0
				lastCheeringComboPlayed = 0
				lastFixedComboMilestonePlayed = 0

				-- Adjust for song length if combo is broken before 50 combos
				if maxCombo < 50 then
					local elapsedTimeRatio = maxCombo / 50
					local expectedMilestoneTime = songLength * elapsedTimeRatio
					if currentTime >= expectedMilestoneTime then
						if everyoneIsInDanger() then
							SOUND:PlayAnnouncer("combo 50 danger ac")
						else
							SOUND:PlayAnnouncer("combo 50 ac")
						end
					soundPlaying = true
					self:sleep(comboCooldown):queuecommand("ResetSoundFlag")
				return end
			end	
		end

		-- Make the announcer catch up based on song timing
		for _, milestone in ipairs(timeThresholds) do
			if math.floor(currentTime) == milestone and lastTimeMilestonePlayed ~= milestone and not soundPlaying then
				if everyoneIsInDanger() then
					SOUND:PlayAnnouncer("combo 50 danger ac")
				else
					SOUND:PlayAnnouncer("combo 50 ac")
				end
				lastTimeMilestonePlayed = milestone
				soundPlaying = true
				self:sleep(comboCooldown):queuecommand("ResetSoundFlag")
				return end
			end
		end
	end,

	ResetSoundFlagCommand=function(self)
		soundPlaying = false
	end,
}

return t
