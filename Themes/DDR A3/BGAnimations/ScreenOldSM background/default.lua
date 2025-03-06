return Def.ActorFrame {
	Def.Quad{
		InitCommand=function(s) 
			s:diffuse(color("#000000"))
			 :FullScreen() 
		end
	},
	
	Def.BitmapText {
		Font="_service";
		InitCommand=function(s)
			s:uppercase(true)
			 :settext(GetBuild())
			 :xy(100, 30)
			 :zoom(0.7)
		end
	},
	
	Def.Quad{
		InitCommand=function(s)
			s:diffuse(color("#ff0000"))
			 :Center()
			 :setsize(400/2, 500/2)
		end
	},
	
	Def.Quad{
		InitCommand=function(s) 
			s:diffuse(color("#000000"))
			 :xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-93)
			 :setsize(400/2-10, 120/2-10)
		end
	},
	
	Def.Quad{
		InitCommand=function(s)
			s:diffuse(color("#000000"))
			 :xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+30)
			 :setsize(400/2-10, 380/2-10)
		end
	},
	
	Def.BitmapText{
		Font="_service",
		InitCommand=function(s)
			s:xy(SCREEN_CENTER_X-10, SCREEN_CENTER_Y-105)
			 :zoom(0.5)
			 :settext("UNSUPPORTED STEPMANIA ERROR")
		end
	},
	
	Def.BitmapText{
		Font="_service",
		InitCommand=function(s)
			s:xy(SCREEN_CENTER_X-30, SCREEN_CENTER_Y-85)
			 :zoom(0.5)
			 :settext("5-0000-0000")
			 :horizalign(right)
		end
	},

	Def.BitmapText{
		Font="_service",
		InitCommand=function(s)
			s:xy(SCREEN_CENTER_X-90, SCREEN_CENTER_Y-20)
			 :zoom(0.5)
			 :settext("Please obtain a new version of StepMania 5.\n"..
			 	"https://github.com/h-lunah/stepmania-ddr\n"..
			 	"Detected: "..ProductID()..
			 	" ("..tonumber(VersionDate())..")\n"..
			 	"Expected: OpenDDR 5.1 (>=20241009)"
			 )
			 :horizalign(left)
		end
	},

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
		end
	}
};
