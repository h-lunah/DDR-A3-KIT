

--ReadPaneControl
function ReadOrCreatePaneControlForPlayerSide(PlayerUID)
	return "ClosePanes"
end


function ReadOrCreatePaneControlForAnotherSide(PlayerUID)
	return "ClosePanes"
end

----------------------------------------------------------------------------

local NoPane = Def.ActorFrame{};

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	NoPane[#NoPane+1] = loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/TargetScore/NoPane/default.lua"))(pn)..{
		InitCommand=function(s)
			s:xy(pn==PLAYER_1 and SCREEN_LEFT+73 or SCREEN_RIGHT-73,_screen.cy+167):zoom(0.533) end,
		OnCommand=function(s)
			if GAMESTATE:IsPlayerEnabled(pn) then
				local PlayerUID = PROFILEMAN:GetProfile(pn):GetGUID();
				if ReadOrCreatePaneControlForPlayerSide(PlayerUID)=="ClosePanes" then
					s:addx(pn==PLAYER_1 and -500 or 500):sleep(0.5):decelerate(0.5):addx(pn==PLAYER_1 and 500 or -500)
					s:linear(0.5);
					s:diffusealpha(1);
				elseif ReadOrCreatePaneControlForPlayerSide(PlayerUID)=="OpenPanes1" or ReadOrCreatePaneControlForPlayerSide(PlayerUID)=="OpenPanes3" then
					s:diffusealpha(0);
				end;
			end;
		end,
	};
end

return Def.ActorFrame{
	OffCommand=function(s) s:finishtweening() end,
	NoPane;
}