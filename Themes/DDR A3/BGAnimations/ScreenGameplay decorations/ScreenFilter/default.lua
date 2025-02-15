local pn = ...
local ScreenFilter = FilterReadPref(pn);
local combo = {[PLAYER_1]=0,[PLAYER_2]=0}
local judgedMines = {[PLAYER_1]=0,[PLAYER_2]=0}

local Filter
if GAMESTATE:GetCurrentStyle():GetStepsType() == 'StepsType_Dance_Double' then
	Filter = THEME:GetPathB("ScreenGameplay","decorations/ScreenFilter/double")
else
	Filter = THEME:GetPathB("ScreenGameplay","decorations/ScreenFilter/single")
end

local Position
if PREFSMAN:GetPreference('Center1Player') and GAMESTATE:GetNumPlayersEnabled() == 1 and GAMESTATE:GetNumSidesJoined() == 1 then 
	Position = _screen.cx
elseif GAMESTATE:GetCurrentStyle():GetStepsType() == 'StepsType_Dance_Double' then
	Position = _screen.cx
else
	Position = pn == PLAYER_1 and ScreenGameplay_P1X() or ScreenGameplay_P2X()
end

local Darkness
	if ScreenFilter == "Off"	 	then Darkness = 0
elseif ScreenFilter == "Dark"	 	then Darkness = 0.35
elseif ScreenFilter == "Darker"	 	then Darkness = 0.65
elseif ScreenFilter == "Darkest"	then Darkness = 0.95					
else 									 Darkness = 0.65					
end

if GAMESTATE:IsDemonstration()  then Darkness = 0.65 end

local function GetTotalSteps(pn)
    if GAMESTATE:IsCourseMode() then steps_or_trail = GAMESTATE:GetCurrentTrail(pn) else steps_or_trail = GAMESTATE:GetCurrentSteps(pn) end
	assert(steps_or_trail)
    return steps_or_trail:GetRadarValues(pn):GetValue('RadarCategory_TapsAndHolds') + steps_or_trail:GetRadarValues(pn):GetValue('RadarCategory_Holds') + math.floor(steps_or_trail:GetRadarValues(pn):GetValue('RadarCategory_Mines') / 4)
end

return Def.ActorFrame {
	InitCommand=function(s) 
		s:xy(Position,_screen.cy):diffusealpha(0)
		local pName = ToEnumShortString(pn)
		setenv("OptionRowGuideLines"..pName, "false")
		THEME:ReloadMetrics()
	end,
	JudgmentMessageCommand=function(self, params)
		-- Add a small delay to ensure the combo and Full Combo state are updated
		local pn = params.Player
		self:sleep(0.01) -- 10ms delay (adjust as needed)

		if params.HoldNoteScore or params.TapNoteScore then
			if params.TapNoteScore == "TapNoteScore_AvoidMine" then
				judgedMines[pn] = judgedMines[pn]  + 1
				if judgedMines[pn] == 4 then
					combo[pn] = combo[pn] + 1
					judgedMines[pn] = 0
				end
			else
				if params.TapNoteScore == "TapNoteScore_HitMine" then
					judgedMines[pn] = judgedMines[pn]  + 1
					if judgedMines[pn] == 4 then
						combo[pn] = combo[pn] + 1
						judgedMines[pn] = 0
					end
				else
					judgedMines[pn]  = 0
					combo[pn] = combo[pn] + 1
				end
			end
		end
		self:queuecommand("CheckAllJudged")
	end,
	CheckAllJudgedCommand=function(self)
		if combo[pn] == GetTotalSteps(pn) then
			self:diffusealpha(0)
			local pName = ToEnumShortString(pn)
			if GetUserPref("OptionRowGuideLinesEnabled"..pName) == 'true' then
				setenv("OptionRowGuideLines"..pName, "false")
				THEME:ReloadMetrics()
			end
		end
	end,
	CurrentSongChangedMessageCommand=function(s) s:sleep(BeginReadyDelay()+SongMeasureSec()):diffusealpha(Darkness):queuecommand("Guidelines") end,
	ChangeCourseSongInMessageCommand=function(s) s:playcommand('FilterOff') end,
	GuidelinesCommand=function(s)
		local pName = ToEnumShortString(pn)
		if GetUserPref("OptionRowGuideLinesEnabled"..pName) == 'true' then
			setenv("OptionRowGuideLines"..pName, "true")
			THEME:ReloadMetrics()
		end
	end,
	Def.Sprite { 
		InitCommand=function(s) s:zoom(0.67):Load(Filter) end, 
	};
};