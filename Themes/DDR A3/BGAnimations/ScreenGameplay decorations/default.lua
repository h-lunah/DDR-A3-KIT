local t = LoadFallbackB()
local playersFailed = {[PLAYER_1] = false, [PLAYER_2] = false}
local failedCount = 0

EveryoneFailed = false

if songsPlayedThisGame ~= nil then
	songsPlayedThisGame = songsPlayedThisGame + 1
end

t[#t+1] = StatsEngine()

t[#t+1] = Def.Actor{
	OffCommand=function(s)
		if not GAMESTATE:IsCourseMode() and (GAMESTATE:GetSongBeat() >= GAMESTATE:GetCurrentSong():GetLastBeat()) then
			-- This stage has ended. Grant Extra Stage stars now.
			AddExtraStageStars(STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber()):GetGrade(), GAMESTATE:GetMasterPlayerNumber())
		end
	end
}

-- Fail out in Event Mode by ending the current stage
t[#t+1] = Def.Actor {
	LifeChangedMessageCommand=function(s, p)
		-- Note: This will jump to the next song if you are currently playing a non-Dan course.
		if GAMESTATE:IsCourseMode() then return end

		local chartP1 = GAMESTATE:GetCurrentSteps(PLAYER_1) or GAMESTATE:GetCurrentTrail(PLAYER_1)
		local chartP2 = GAMESTATE:GetCurrentSteps(PLAYER_2) or GAMESTATE:GetCurrentTrail(PLAYER_2)

		for pn, v in pairs(playersFailed) do
			if pn == p.Player and p.LifeMeter:GetLife() == 0 and not v then
				playersFailed[pn] = true
				failedCount = failedCount + 1
			end

			if GAMESTATE:GetNumPlayersEnabled() == 1 and failedCount == 1 then
				EveryoneFailed = true
			elseif GAMESTATE:GetNumPlayersEnabled() == 2 and failedCount == 2 then
				EveryoneFailed = true
			else
				EveryoneFailed = false
			end
		end
				
		if p.Player == PLAYER_1 and GAMESTATE:IsSideJoined(PLAYER_1) and not GAMESTATE:IsSideJoined(PLAYER_2) and STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetCurrentMissCombo() >= 5 * chartP1:GetMeter() + 25 and p.LifeMeter:GetLife() == 0 then
			SCREENMAN:GetTopScreen():PostScreenMessage("SM_NotesEnded", 0)
		elseif p.Player == PLAYER_2 and GAMESTATE:IsSideJoined(PLAYER_2) and not GAMESTATE:IsSideJoined(PLAYER_1) and STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetCurrentMissCombo() >= 5 * chartP2:GetMeter() + 25 and p.LifeMeter:GetLife() == 0 then
			SCREENMAN:GetTopScreen():PostScreenMessage("SM_NotesEnded", 0)
		else
			if STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetCurrentMissCombo() >= 5 * chartP1:GetMeter() + 25 and
			   STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetCurrentMissCombo() >= 5 * chartP2:GetMeter() + 25 and
			    p.LifeMeter:GetLife() == 0 then
					SCREENMAN:GetTopScreen():PostScreenMessage("SM_NotesEnded", 0) 
			end
		end
	end
}


t[#t+1] = Def.Actor{
    AfterStatsEngineMessageCommand = function(self, params)
        local pn = params.Player
        local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)

        local aScore = params.Data.AScoring
        pss:SetScore(aScore.Score)
        pss:SetCurMaxScore(aScore.MaxScore)

        local fast, slow = 0, 0

        local fastSlow = params.Data.FastSlowRecord
        if fastSlow then
            fast = fastSlow.Fast
            slow = fastSlow.Slow
        end

        local short = ToEnumShortString(pn)
        setenv("numFast"..short, fast)
        setenv("numSlow"..short, slow)

	end;
};

if not GAMESTATE:IsDemonstration() then
	if ShowCutIns() then
		if GetUserPref("OptionRowGameplayBackground")=='DanceStages' then
			t[#t+1] = LoadActor("Cut-In/DanceStages")
		elseif GetUserPref("OptionRowGameplayBackground")=='SNCharacters' then
			t[#t+1] = LoadActor("Cut-In/SNCharacters")
		end
	end
end

for _, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do	
	t[#t+1] = LoadActor("ScreenFilter",pn);	
end;

t[#t+1] = LoadActor("ScreenGameplay Danger");
t[#t+1] = LoadActor("Speed-Appearance")..{ InitCommand=function(s) s:draworder(1) end, };
t[#t+1] = LoadActor("StageFrame")..{ InitCommand=function(s) s:draworder(1) end, };

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("lifeframe",pn);
	t[#t+1] = LoadActor(THEME:GetPathG("","OptionIcon"),pn)..{
		InitCommand=function(s) 
			s:zoomx(0.64):zoomy(0.63):draworder(1):x(pn==PLAYER_1 and _screen.cx-296 or _screen.cx+318)
			s:y(IsReverse(pn) and _screen.cy-178 or _screen.cy+161)
		end,
	};
end

t[#t+1] = LoadActor("ScoreFrame")..{ InitCommand=function(s) s:draworder(99) end, };
t[#t+1] = LoadActor("message")..{ InitCommand=function(s) s:draworder(99) end, };

if not GAMESTATE:IsDemonstration() then
	t[#t+1] = LoadActor("doors")..{ InitCommand=function(s) s:draworder(99) end, };
	t[#t+1] = LoadActor("AnnouncerEngine");
end

if GAMESTATE:IsCourseMode() then
	local BreakTime = IsDanCourse() and 60 or 0
	shouldDo = false
	t[#t+1] = Def.ActorFrame {
		OnCommand=function(s)
			if shouldDo then
				s:AddChildFromPath(THEME:GetPathB("ScreenGameplay", "decorations/Doors/default.lua"))
				local sound = THEME:GetPathS("","DoorOpen")
				SOUND:PlayOnce(StreamingSound(sound)) 
				shouldDo = false
			end;
		end;
		CurrentSongChangedMessageCommand=function(s)
			local mpStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
			local songsPlayed = mpStats:GetSongsPlayed()

			-- Only proceed if at least 2 songs have been played
			if songsPlayed < 2 then return end

			s:sleep(4.6 + BreakTime)
			shouldDo = true
			s:queuecommand("On")
		end;
	}
end


t[#t+1] = Def.ActorFrame {
	Condition=not GAMESTATE:IsDemonstration(),
	InitCommand=function(s) s:x(_screen.cx):y(_screen.cy+12):draworder(99) end,
	OnCommand=function(s) s:sleep(BeginReadyDelay()):linear(0.06):zoom(1.5):diffusealpha(0) end,
	Def.Sprite {
		OnCommand=function(s)
		local song = GAMESTATE:GetCurrentSong()
		if song then
			s:Load(GetJacketPath(song))
		end;
		s:setsize(300,300)
		end,
	};
};

if GAMESTATE:IsSideJoined(PLAYER_1) then
	t[#t+1] = LoadActor("TargetScore/P1")..{ InitCommand=function(s) s:draworder(OptionRowComboUnderField() and 1 or 0) end, };
	t[#t+1] = LoadActor("SpeedChange/P1");
	t[#t+1] = LoadActor("Constant/P1");
	t[#t+1] = LoadActor(THEME:GetPathG("", "Player ShockArrow judgment/P1"))..{ InitCommand=function(s) s:draworder(OptionRowComboUnderField() and 1 or 0) end, };
	if GAMESTATE:GetCurrentStyle():GetName() ~= "double" then
		t[#t+1] = LoadActor(THEME:GetPathG("", "HoldJudgment label 1x2/CustomHold/P1"))..{ InitCommand=function(s) s:draworder(OptionRowComboUnderField() and 1 or 0) end, };
	else
		t[#t+1] = LoadActor(THEME:GetPathG("", "HoldJudgment label 1x2/CustomHold/Double"))..{ InitCommand=function(s) s:draworder(OptionRowComboUnderField() and 1 or 0) end, };
	end
end

if GAMESTATE:IsSideJoined(PLAYER_2) then
	t[#t+1] = LoadActor("TargetScore/P2")..{ InitCommand=function(s) s:draworder(OptionRowComboUnderField() and 1 or 0) end, };
	t[#t+1] = LoadActor("SpeedChange/P2");
	t[#t+1] = LoadActor("Constant/P2");
	t[#t+1] = LoadActor(THEME:GetPathG("", "Player ShockArrow judgment/P2"))..{ InitCommand=function(s) s:draworder(OptionRowComboUnderField() and 1 or 0) end, };
	if GAMESTATE:GetCurrentStyle():GetName() ~= "double" then
		t[#t+1] = LoadActor(THEME:GetPathG("", "HoldJudgment label 1x2/CustomHold/P2"))..{ InitCommand=function(s) s:draworder(OptionRowComboUnderField() and 1 or 0) end, };
	else
		t[#t+1] = LoadActor(THEME:GetPathG("", "HoldJudgment label 1x2/CustomHold/Double"))..{ InitCommand=function(s) s:draworder(OptionRowComboUnderField() and 1 or 0) end, };
	end
end

return t
