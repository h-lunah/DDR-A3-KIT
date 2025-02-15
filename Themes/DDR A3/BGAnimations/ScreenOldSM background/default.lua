return Def.ActorFrame {
	Def.Quad{
		InitCommand=function(s) s:diffuse(color("#000000")):FullScreen() end,
	};
	Def.BitmapText {
		Font="_service";
		InitCommand=function(s)
			s:uppercase(true)
			 :settext(GetBuild())
			 :xy(100, 30)
			 :zoom(0.7)
		end;
	};
	Def.Quad{
		InitCommand=function(s) s:diffuse(color("#ff0000")):Center():setsize(400/2, 500/2) end,
	};
	Def.Quad{
		InitCommand=function(s) s:diffuse(color("#000000")):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-93):setsize(400/2-10, 120/2-10) end,
	};
	Def.Quad{
		InitCommand=function(s) s:diffuse(color("#000000")):xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+30):setsize(400/2-10, 380/2-10) end,
	};
	Def.BitmapText{
		Font="_service",
		InitCommand=function(s)
			s:xy(SCREEN_CENTER_X-10, SCREEN_CENTER_Y-105)
			s:zoom(0.5)
			s:settext("UNSUPPORTED STEPMANIA ERROR")
		end,
	};
	Def.BitmapText{
		Font="_service",
		InitCommand=function(s)
			s:xy(SCREEN_CENTER_X-30, SCREEN_CENTER_Y-85)
			s:zoom(0.5)
			s:settext("5-0000-0000")
			s:horizalign(right)
		end,
	};

	Def.BitmapText{
		Font="_service",
		InitCommand=function(s)
			s:xy(SCREEN_CENTER_X-90, SCREEN_CENTER_Y-20)
			s:zoom(0.5)
			s:settext("Please obtain a new version of StepMania 5.\nhttps://github.com/h-lunah/stepmania-ddr\nDetected: "..ProductID().." ("..tonumber(VersionDate())..")".."\nExpected: OpenDDR 5.1 (>=20241009)")
			s:horizalign(left)
		end,
	};

	Def.BitmapText{
		Font="_service",
		InitCommand=function(s)
			local neededCoins = GAMESTATE:GetCoinsNeededToJoin() > 0 and GAMESTATE:GetCoinsNeededToJoin() or 1
			local credits = math.floor(GAMESTATE:GetCoins() / neededCoins)
			local coins = GAMESTATE:GetCoins() % neededCoins
			s:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+140)
			s:zoom(0.5)
			s:settext("CREDIT(S) ="..credits..", COIN(S) ="..coins)
		end,
		CoinInsertedMessageCommand=function(s)
			local neededCoins = GAMESTATE:GetCoinsNeededToJoin() > 0 and GAMESTATE:GetCoinsNeededToJoin() or 1
			local credits = math.floor(GAMESTATE:GetCoins() / neededCoins)
			local coins = GAMESTATE:GetCoins() % neededCoins
			s:settext("CREDIT(S) ="..credits..", COIN(S) ="..coins)
		end,
	};
};