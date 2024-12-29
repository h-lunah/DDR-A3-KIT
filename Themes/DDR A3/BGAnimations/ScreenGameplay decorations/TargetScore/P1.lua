-- TargetScore (A3)
-- Sourced from https://josevarela.net/SMArchive/Themes/ThemePreview.php?Category=StepMania%205&ID=DDR2013
-- Modified for DDR A3 theme with realistic behavior

-- Player variables
local player = PLAYER_1;

-- Target score
local ts = 0;

-- Is this a mine?
local isMine = false;

-- How many mines in this shock arrows were judged?
local minesJudged = 0;

-- Did the player fail?
local playerFailed = false;

local t = Def.ActorFrame {};

-- Determine scoring system
local data_source = "AScoring"

if IsEXScore(player) then
    data_source = "EXScore"
end

-- Turn off Target Score when not playing a normal song in-game. Courses and Demonstration will turn it off.
if not GAMESTATE:IsDemonstration() and not GAMESTATE:IsCourseMode() and GAMESTATE:GetPlayMode() == 'PlayMode_Regular' and ReadPrefFromFile("OptionRowTargetScore"..ToEnumShortString(player)) == "On" then
	-- Current song's chart
	local steps = GAMESTATE:GetCurrentSteps(player);
	-- Radar values of the current chart
	local rv = steps:GetRadarValues(player);
	-- Current song
	local song = GAMESTATE:GetCurrentSong()
	-- Max amount of steps in the current chart
	local maxsteps = math.max(rv:GetValue('RadarCategory_TapsAndHolds')
	+rv:GetValue('RadarCategory_Holds')
	+math.floor(rv:GetValue('RadarCategory_Mines')/4),1);

	-- Max obtainable EX Score in the current chart
	local maxex = math.max(rv:GetValue('RadarCategory_TapsAndHolds')*3
	+rv:GetValue('RadarCategory_Holds')*3
	+math.floor(rv:GetValue('RadarCategory_Mines')/4)*3,1);

	-- Determine the profile to use
	if PROFILEMAN:IsPersistentProfile(player) then
		profile = PROFILEMAN:GetProfile(player)
	else
		profile = PROFILEMAN:GetMachineProfile()
	end

	-- Get scores for this profile
	scorelist = profile:GetHighScoreList(song,steps)
	local scores = scorelist:GetHighScores()

	-- Get score to beat
	local topscore = 0

	if scores[1] and data_source ~= "EXScore" then
		topscore = scores[1]:GetScore()
	elseif scores[1] and data_source == "EXScore" then
		topscore = math.floor(maxex*(scores[1]:GetScore()/1000000)+0.5)
	end;

	-- Validate the score is valid
	assert(topscore);
	
	-- Determine points per step
	local moto=topscore/maxsteps;

	-- Initialize visual element
	t[#t+1] = Def.ActorFrame {
		LoadFont("TargetScore numbers") .. {
			-- Position the score correctly
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X-190, SCREEN_CENTER_Y-60);
				self:zoom(0.5);
				-- Align the score based on its length
				(cmd(horizalign,right;strokecolor,color("#000000")))(self)

				-- Hide Target Score if there is no score to beat or the max score has been reached
				if topscore == 0 or topscore == 1000000 or topscore == maxex then
					self:visible(false)
				end
			end;
			-- Fix position in Double play styles
			OnCommand=function(self)
				if GAMESTATE:GetCurrentStyle():GetName() == "double" then
					self:x(SCREEN_CENTER_X+55)
				end
			end;
			-- Determine if we failed the song and hide the Target Score
			LifeChangedMessageCommand=function(self,params)
				if params.Player ~= PLAYER_1 then return end
				if params.LifeMeter:GetLife() == 0 or params.LivesLeft == 0 then
					self:visible(false)
					playerFailed = true
				end
			end;
			-- Track shock arrows to ensure the score doesn't go way off
			JudgmentMessageCommand=function(self,params)
				if params.TapNoteScore == "TapNoteScore_AvoidMine" then
					isMine = true
					minesJudged = minesJudged + 1;
				else
					isMine = false
					minesJudged = 0
				end
			end;
			-- Track your Target Score
			AfterStatsEngineMessageCommand=function(self,params)
				-- If we failed do not run this code.
				if GAMESTATE:GetPlayerState(PLAYER_1):GetHealthState() == "HealthState_Dead" then return end
				-- If the player object doesn't match or is nil, do not run this code.
				if params.Player ~= player then return end;
				-- The Target Score can change unexpectedly after the song has ended so don't run this code after the song is over.
				if (GAMESTATE:GetSongBeat() >= GAMESTATE:GetCurrentSong():GetLastBeat()) then return end
				-- Prevent tween overflows
				self:finishtweening();

				-- Obtain current score
				ret=params.Data[data_source].Score

				-- Grant score according to DDR Shock Arrow rules
				if isMine and minesJudged == 4 then
					ts = ts + moto
					minesJudged = 0
				elseif not isMine then
					ts = ts + moto
				end

				-- Determine the difference and its snapping threshold
				local last = nil
				local snapTo = nil

				if data_source == "EXScore" then
					last = math.round((ret-ts));
					snapTo = 1
				else
					last = math.round((ret-ts)*0.1);
					snapTo = 10
				end

				-- Display the difference
				if last > 0 then
					self:diffuse(color("#766fbd"));
					self:settext("+"..last*snapTo);
				elseif last < 0 then
					self:diffuse(color("#bd727f"));
					self:settext(last*snapTo);
				else
					self:diffuse(color("#ffffff"));
					self:settext("±0");
				end;
			end;
		};
	};
end;

return t;
