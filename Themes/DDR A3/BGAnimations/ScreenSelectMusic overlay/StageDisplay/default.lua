local sStage = GAMESTATE:GetCurrentStage();
local tRemap = {
	Stage_1st		= 1,
	Stage_2nd		= 2,
	Stage_3rd		= 3,
	Stage_4th		= 4,
	Stage_5th		= 5,
	Stage_6th		= 6,
};

local numToStage = {"Stage_1st", "Stage_2nd", "Stage_3rd", "Stage_4th", "Stage_Final"}

if tRemap[sStage] == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
elseif GAMESTATE:IsCourseMode() then
	sStage = "Stage_1st"
elseif GAMESTATE:IsEventMode() then
	if songsPlayedThisGame >= 4 then
		sStage = "Stage_Final"
	else
		sStage = numToStage[songsPlayedThisGame+1]
	end
end;

return Def.ActorFrame {
	Def.Sprite{
		Texture=Model().."bg",
		InitCommand=function(s) s:xy(SCREEN_LEFT+116,SCREEN_TOP+43) end,
	};
	Def.Sprite{
		Texture=THEME:GetPathG("", "_shared/Style"),
		InitCommand=function(s) s:xy(146,66):pause():queuecommand("Update") end,
		UpdateCommand=function(s)
			s:sleep(0.1)
			s:queuecommand("Set")
		end,
		SetCommand=function(s)
			local style = GAMESTATE:GetCurrentStyle()
			if style:GetStyleType() == "StyleType_OnePlayerOneSide" then
				s:setstate(0);
			elseif style:GetStyleType() == "StyleType_TwoPlayersTwoSides" then
				s:setstate(1);
			elseif style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
				s:setstate(2);
			end;
			s:queuecommand("Update")
		end,
	};
	Def.Sprite{
		Texture=Model()..ToEnumShortString(sStage),
		InitCommand=function(s) s:xy(96,30.5) end,
	};
};
