local t = Def.ActorFrame {};

local function SelectedStyleBeforeJoin()
	local envs = {
		["Single"] = getenv("SelSing"),
		["Double"] = getenv("SelDoub"),
		["Versus"] = getenv("SelVers")
	}

	for k,v in pairs(envs) do
		if v == 1 then
			return k
		end
	end
end

for i=1,2 do
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(s) s:xy(i==1 and SCREEN_LEFT-1 or SCREEN_RIGHT+1,SCREEN_BOTTOM-53):zoom(0.667):sleep(2):queuecommand("Comment") end,
		OffCommand=function(s) s:smooth(0.2):diffusealpha(0) end,
		CommentCommand=function(s)
			local players = GAMESTATE:GetNumSidesJoined()

			if i == 1 then
				if players == 1 then
					SOUND:PlayAnnouncer("style single")
				else
					SOUND:PlayAnnouncer("style versus")
				end
			end
		end,
		PlayerJoinedMessageCommand=function(s,p)
			if p.Player then
				s:queuecommand("Off")
			end
		end,
		Def.Sprite{
			Texture="Frame";
			InitCommand=function(s) s:rotationy(i==1 and 180 or 0):halign(1) end,
			OnCommand=function(s) s:diffusealpha(0):zoomy(0):linear(0.3):zoomy(1):diffusealpha(1) end,
		};
		Def.Sprite{
			Texture=THEME:GetPathB("ScreenSelectStyle","overlay/"..i.."P");
			InitCommand=function(s) s:xy(i==1 and 105 or -105,-23) end,
			OnCommand=function(s) s:diffusealpha(0):rotationz(45):sleep(0.3):linear(0.3):rotationz(0):diffusealpha(1) end,
		};
		Def.Sprite{
			InitCommand=function(s) s:xy(i==1 and 260 or -260,2):queuecommand("Set"):queuecommand("Update") end,
			OnCommand=function(s) s:diffusealpha(0):sleep(0.3):linear(0.3):diffusealpha(1) end,
			CoinInsertedMessageCommand=function(s) s:queuecommand("Set") end,
			UpdateCommand=function(s)
				s:sleep(0.1):queuecommand("Set"):queuecommand("Init")
			end,
			SetCommand=function(s)
				local GetP1 = GAMESTATE:IsPlayerEnabled(PLAYER_1)
				local GetP2 = GAMESTATE:IsPlayerEnabled(PLAYER_2)
				local masterPlayer = GAMESTATE:GetMasterPlayerNumber()

				if i == 1 then
					if GetP1 == true and GAMESTATE:GetNumPlayersEnabled() == 1 and SelectedStyleBeforeJoin() ~= "Versus" then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Model()..Language().."1p_start"));
					elseif SelectedStyleBeforeJoin() == "Versus" and GetP2 == false then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Language().."single_cantplay"));
					elseif SelectedStyleBeforeJoin() == "Double" and GAMESTATE:GetNumPlayersEnabled() == 2 then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Language().."couple_cantplay"));
					elseif GetP1 == false and GAMESTATE:PlayersCanJoin() and GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Model()..Language().."1p_join"));
					elseif GAMESTATE:GetNumPlayersEnabled() == 2 then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Model()..Language().."1p_join"));
					elseif IsFreePlay() or IsHome() then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Model()..Language().."1p_join"));
					else
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Language().."insertmorecoins"));
					end;
				elseif i == 2 then
					if GetP2 == true and GAMESTATE:GetNumPlayersEnabled() == 1 then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Model()..Language().."2p_start"));
					elseif SelectedStyleBeforeJoin() == "Versus" and GetP1 == false then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Language().."single_cantplay"));
					elseif SelectedStyleBeforeJoin() == "Double" and GAMESTATE:GetNumPlayersEnabled() == 2 then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Language().."couple_cantplay"));
					elseif GetP2 == false and GAMESTATE:GetMasterPlayerNumber() == PLAYER_1 and GAMESTATE:EnoughCreditsToJoin() then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Model()..Language().."2p_join"));
					elseif GAMESTATE:GetNumPlayersEnabled() == 2 then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Model()..Language().."2p_join"));
					elseif IsFreePlay() or IsHome() then
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Model()..Language().."2p_join"));
					else
						s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/"..Language().."insertmorecoins"));
					end
				end
			end,
		};
		Def.BitmapText{
			Font="_avenirnext lt pro bold Bold 20px";
			InitCommand=function(s)
				if i == 1 then
					s:xy(220, -20)
					if Language() == "jp_" then
						s:addx(100)
					elseif Language() == "kor_" then
						s:addx(-50)
					end
				elseif i == 2 then
					s:xy(-300, -20)
					if Language() == "jp_" then
						s:addx(100)
					elseif Language() == "kor_" then
						s:addx(-50)
					end
				end
				s:diffuse(color("#ff00ff"))
				s:zoom(1.3)
				s:queuecommand("Set")
			end;
			OnCommand=function(s) s:diffusealpha(0):sleep(0.3):linear(0.3):diffusealpha(1) end,
			SetCommand=function(s)
				s:settext(GAMESTATE:GetCoinsNeededToJoin() - GAMESTATE:GetCoins())
				if GAMESTATE:IsEventMode() then
					s:diffusealpha(0)
				elseif GAMESTATE:GetCoinMode() == "CoinMode_Free" or GAMESTATE:GetCoinMode() == "CoinMode_Home" then
					s:diffusealpha(0)
				elseif GAMESTATE:IsSideJoined(PLAYER_1) and i == 1 then
					s:diffusealpha(0)
				elseif GAMESTATE:IsSideJoined(PLAYER_2) and i == 2 then
					s:diffusealpha(0)
				elseif math.floor(GAMESTATE:GetCoins() / PREFSMAN:GetPreference('CoinsPerCredit')) >= 1 then
					s:diffusealpha(0)
				end
			end;
			CoinInsertedMessageCommand=function(s) s:queuecommand("Set") end,
		};
	};
end

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(draworder,200;xy,SCREEN_CENTER_X,SCREEN_CENTER_Y+129.5;zoom,0.67);
	Def.ActorFrame{
		InitCommand=cmd(x,-263;diffusealpha,0);
		OnCommand=cmd(smooth,0.3;diffusealpha,1;);
		OffCommand=cmd(smooth,0.2;addx,50;diffusealpha,0;);			
		LoadActor(THEME:GetPathB("ScreenSelectStyle","overlay/arrow_green")) .. {
			MenuLeftP1MessageCommand=cmd(smooth,0.1;addx,-20;smooth,0.1;addx,20;);
			MenuLeftP2MessageCommand=cmd(smooth,0.1;addx,-20;smooth,0.1;addx,20;);
		};
		LoadActor(THEME:GetPathB("ScreenSelectStyle","overlay/arrow_red")) .. {
			OnCommand=cmd(diffusealpha,0;);
			MenuLeftP1MessageCommand=cmd(diffusealpha,1;smooth,0.1;addx,-20;smooth,0.1;addx,20;diffusealpha,0);
			MenuLeftP2MessageCommand=cmd(diffusealpha,1;smooth,0.1;addx,-20;smooth,0.1;addx,20;diffusealpha,0);
		};
	};
	Def.ActorFrame{
		InitCommand=cmd(x,263;zoomx,-0.5;zoomy,0.5;diffusealpha,0);
		OnCommand=cmd(smooth,0.3;zoomx,-1;zoomy,1;diffusealpha,1;);
		OffCommand=cmd(smooth,0.2;addx,50;diffusealpha,0;);	
		LoadActor(THEME:GetPathB("ScreenSelectStyle","overlay/arrow_green")) .. {
			MenuRightP1MessageCommand=cmd(smooth,0.1;addx,-20;smooth,0.1;addx,20;);
			MenuRightP2MessageCommand=cmd(smooth,0.1;addx,-20;smooth,0.1;addx,20;);
		};
		LoadActor(THEME:GetPathB("ScreenSelectStyle","overlay/arrow_red")) .. {
			OnCommand=cmd(diffusealpha,0);
			MenuRightP1MessageCommand=cmd(diffusealpha,1;smooth,0.1;addx,-20;smooth,0.1;addx,20;diffusealpha,0);
			MenuRightP2MessageCommand=cmd(diffusealpha,1;smooth,0.1;addx,-20;smooth,0.1;addx,20;diffusealpha,0);
		};
	};
};

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.Sprite{
		Texture=Model().."button",
		InitCommand=function(s) 
			s:xy(pn==PLAYER_1 and SCREEN_LEFT+160 or SCREEN_RIGHT-160,_screen.cy+110):diffusealpha(0) 
		end,
		OnCommand=function(s) 
			s:zoom(0):rotationz(-720):linear(0.35):rotationz(720):diffusealpha(1):zoom(0.67):playcommand("Animate") 
		end;
		AnimateCommand=function(s)
			if SelectedStyleBeforeJoin() == "Versus" and GAMESTATE:GetNumPlayersEnabled() == 1 then
				s:stoptweening():linear(0.25):zoomy(0):diffusealpha(0):queuecommand("On")
			elseif SelectedStyleBeforeJoin() == "Double" and GAMESTATE:GetNumPlayersEnabled() == 2 then
				s:stoptweening():linear(0.25):zoomy(0):diffusealpha(0):queuecommand("On")
			else
				s:zoomy(0.67):linear(0.25):zoomx(0.67):linear(0.25):zoomx(0.72):queuecommand("Animate")
			end
		end,
		OffCommand=function(s) 
			s:stoptweening():linear(0.25):zoomy(0):diffusealpha(0) 
		end,
	};
end

t[#t+1] = Def.Actor{
	PlayerJoinedMessageCommand=function(self)
		self:queuecommand("Delay1")
	end;
	Delay1Command=function(self)
		self:sleep(2)
		self:queuecommand("SetScreen")
	end;
	SetScreenCommand=function(self)
		SCREENMAN:GetTopScreen():SetNextScreenName("ScreenProfileLoad"):StartTransitioningScreen("SM_GoToNextScreen")
	end;
};


return t;
