local pn = ...;
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
local Combo = 	pss:MaxCombo();

local Marvelous = pss:GetTapNoteScores("TapNoteScore_W1");
local Perfect = pss:GetTapNoteScores("TapNoteScore_W2");
local Great = pss:GetTapNoteScores("TapNoteScore_W3");
local Good = pss:GetTapNoteScores("TapNoteScore_W4");
local Ok = pss:GetHoldNoteScores("HoldNoteScore_Held");
local Miss = pss:GetTapNoteScores("TapNoteScore_Miss") + pss:GetTapNoteScores("TapNoteScore_HitMine") + pss:GetHoldNoteScores("HoldNoteScore_LetGo")

local Fast=getenv("numFast"..ToEnumShortString(pn));
local Slow=getenv("numSlow"..ToEnumShortString(pn));

local Score = pss:GetScore();
local Radar = GAMESTATE:GetCurrentSteps(pn):GetRadarValues(pn)
					
local MaxEXScore = Radar:GetValue("RadarCategory_TapsAndHolds")*3 +
	Radar:GetValue("RadarCategory_Holds")*3 +
	math.floor(Radar:GetValue("RadarCategory_Mines")/4)*3

local EXScore = math.floor(MaxEXScore*(Score / 1000000)+0.5);


local Large = Def.BitmapText{
	Font="_itc avant garde pro bk 20px",
	InitCommand=function(s) s:zoom(1.2) end,
};

local Judge = Def.BitmapText{
	Font="_helveticaneuelt pro 55 roman 17px",
	InitCommand=function(s) s:zoom(1.3):halign(1)
		:DiffuseAndStroke(Color.Black,Color.White)
	end,
};

local base = "NORMAL"

if IsEXScore(pn) then
	base = "EX"
end

return Def.ActorFrame{
	LoadActor("BASE.PNG");
	LoadActor(base);
	Def.Sprite{
		Texture="FAST",
		InitCommand=function(s) s:visible(ShowFastSlow(pn)) end,
	};
	Large..{
		Name="MaxCombo",
		InitCommand=function(s)
			s:xy(90,-105):halign(1)
			:settextf(Combo)
		end,
	};
	Judge..{
		Name="Marvelous",
		InitCommand=function(s)
			s:xy(93,-76):halign(1)
			:settextf(Marvelous)
		end,
	};
	Judge..{
		Name="Perfect",
		InitCommand=function(s)
			s:xy(93,-45):halign(1)
			:settextf(Perfect)
		end,
	};
	Judge..{
		Name="Great",
		InitCommand=function(s)
			s:xy(93,-15):halign(1)
			:settextf(Great)
		end,
	};
	Judge..{
		Name="Good",
		InitCommand=function(s)
			s:xy(93,15):halign(1)
			:settextf(Good)
		end,
	};
	Judge..{
		Name="Ok",
		InitCommand=function(s)
			s:xy(93,45):halign(1)
			:settextf(Ok)
		end,
	};
	Judge..{
		Name="Miss",
		InitCommand=function(s)
			s:xy(93,75):halign(1)
			:settextf(Miss)
		end,
	};
	Large..{
		InitCommand=function(s) s:y(107):halign(1)
			if IsEXScore(pn) then
				s:x(133):settextf("%4d",Score)
			else
				s:x(93):settextf("%4d",EXScore)
			end
		end,
	};
	Def.ActorFrame{
	Condition=ShowFastSlow(pn);
		Judge..{
			Name="Fast",
			InitCommand=function(s) s:xy(205,11):halign(1):settextf(Fast) end,
		};
		Judge..{
			Name="Slow",
			InitCommand=function(s) s:xy(205,70):halign(1):settextf(Slow) end,
		};
	};
};