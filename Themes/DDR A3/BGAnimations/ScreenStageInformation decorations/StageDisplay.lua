local sStage = GAMESTATE:GetCurrentStage();
local tRemap = {
	Stage_1st		= 1,
	Stage_2nd		= 2,
	Stage_3rd		= 3,
	Stage_4th		= 4,
	Stage_5th		= 5,
	Stage_6th		= 6,
	Stage_None		= 0,
};
local previousCourse = nil

if tRemap[sStage] == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
elseif GAMESTATE:IsEventMode() and not GAMESTATE:IsCourseMode() then
	sStage = "Stage_1st";
elseif GAMESTATE:IsCourseMode() then
	local currentCourse = GAMESTATE:GetCurrentCourse()
	
	if currentCourse ~= previousCourse then
        sStage = "Stage_1st"
        songsPlayed = 1
		previousCourse = currentCourse
    end

	if songsPlayed >= GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() then
		sStage = "Stage_1st"
		songsPlayed = 1
	end

	local mpStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( GAMESTATE:GetMasterPlayerNumber() )

	local songsPlayed = mpStats:GetSongsPlayed() ~= 0 and mpStats:GetSongsPlayed() or 1

	if songsPlayed == 1 then
		suffix = "st"
	elseif songsPlayed == 2 then
		suffix = "nd"
	elseif songsPlayed == 3 then
		suffix = "rd"
	else
		suffix = "th"
	end

	if IsTransitioning then
		if songsPlayed < GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() and songsPlayed < 5 then
			sStage = "Stage_"..songsPlayed..suffix
		elseif songsPlayed < GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() and songsPlayed >= 4 then
			sStage = "Stage_None"
		elseif songsPlayed > GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() then
			sStage = "Stage_1st"
		else
			sStage = "Stage_Final"
		end
		IsTransitioning = false
	end
end;

if sStage == "Stage_Extra1" then
	ExtraStageStars = 0
end
----------------------------------------------------------------------------
return Def.ActorFrame {
	--InitCommand=function(s) s:zoom(0.667)
	Def.Sprite{
		Texture=THEME:GetPathG("","_shared/message/BLUE"),
		InitCommand=function(s) s:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y+10):zoom(1) end,
		OnCommand=function(self)	
			self:diffusealpha(1);
			self:zoomx(1);
			self:zoomy(1);
			self:linear(0.1);
			self:diffusealpha(1);
			self:zoomx(1.2);
			self:zoomy(1.2);
			self:linear(0.1);
			self:diffusealpha(1);
			self:zoomx(1.1);
			self:zoomy(1.1);
			self:sleep(0.3);
			self:sleep(0.1);
			self:linear(0.1);
			self:zoomx(1);
			self:zoomy(1);
			self:sleep(0.85);
			self:linear(0.04);
			self:diffusealpha(0);
			self:zoomx(0.8*1.2);
			self:zoomy(0);
		end;
	};
	Def.Sprite{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+5;zoom,1);
	OnCommand=function(self)
	if sStage ~= "Stage_None"	then
		self:Load(THEME:GetPathG("","_shared/message/"..ToEnumShortString(sStage) ));
	else
		self:Load(THEME:GetPathG("","_shared/message/None"));
	end
	self:diffusealpha(1):linear(0.1):diffusealpha(1)
	:zoomx(1.1):zoomy(1.2):linear(0.1)
	:zoomx(1.2):zoomy(1.1):linear(0.15)
	:zoomx(1.15):zoomy(1.1):sleep(0.3):linear(0.1)
	:zoomx(1):zoomy(1)
	:sleep(0.8):linear(0.04):diffusealpha(0.2):zoomx(1.8*2):zoomy(0);
	end;
	};
	Def.Sprite{
	InitCommand=cmd(x,SCREEN_CENTER_X-0;y,SCREEN_CENTER_Y;zoom,0.9;blend,Blend.Add);
	OnCommand=function(self)
	self:Load(THEME:GetPathG("","_shared/message/"..ToEnumShortString(sStage) ));
	self:diffusealpha(0.5):zoom(1.5):linear(0.1):diffusealpha(0.5)
	:zoomx(1.1):zoomy(1.2):linear(0.15)
	:zoomx(1.5):zoomy(1.8):linear(0.15)
	:zoomx(2):zoomy(2.1):diffusealpha(0);
	end;
	};
};