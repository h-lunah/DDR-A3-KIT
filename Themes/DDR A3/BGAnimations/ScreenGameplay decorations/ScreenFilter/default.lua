local pn = ({...})[1]
local ScreenFilter = FilterReadPref(pn);

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

return Def.ActorFrame {
	InitCommand=function(s) 
		s:xy(Position,_screen.cy):diffusealpha(0)
		setenv("OptionRowGuideLines", "false")
		THEME:ReloadMetrics()
	end,
	CurrentSongChangedMessageCommand=function(s) s:sleep(BeginReadyDelay()+SongMeasureSec()):diffusealpha(Darkness):queuecommand("Guidelines") end,
	ChangeCourseSongInMessageCommand=function(s) s:playcommand('FilterOff') end,
	OffCommand=function(s)
		s:diffusealpha(0)
		if GetUserPref("OptionRowGuideLinesEnabled") == 'true' then
			setenv("OptionRowGuideLines", "false")
			THEME:ReloadMetrics()
		end
	end,
	GuidelinesCommand=function(s)
		if GetUserPref("OptionRowGuideLinesEnabled") == 'true' then
			setenv("OptionRowGuideLines", "true")
			THEME:ReloadMetrics()
		end
	end,
	Def.Sprite { 
		InitCommand=function(s) s:zoom(0.67):Load(Filter) end, 
	};
};