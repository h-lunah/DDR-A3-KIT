local t = Def.ActorFrame {};
local netConnected = IsNetConnected();

local function effectColor()
	if Model() == "blue_" then
		return "#b4ff01"
	elseif Model() == "gold_" then
		return "#ffea00"
	else
		return nil
	end
end

t[#t+1] = Def.ActorFrame {
	Def.Sprite{
		Texture="icon",
		InitCommand=function(s) s:zoom(0.68):x(SCREEN_RIGHT-29.3):y(SCREEN_TOP+113) end,
	};
}

if not netConnected then
	t[#t+1] = Def.ActorFrame {
		Def.Sprite{
			Texture=Language().."localmode",
			InitCommand=function(s) s:zoom(0.33):xy(SCREEN_LEFT+120, SCREEN_BOTTOM-50) end,
		};
	};
end

if GAMESTATE:GetCoinMode() == 'CoinMode_Free' then
	t[#t+1] = Def.ActorFrame {
		Def.Sprite{
			Texture=Language().."paseli_unavailable.png",
			InitCommand=function(s) 
				s:zoom(0.667):xy(_screen.cx+355,IsTitleMenu() and _screen.cy+135 or _screen.cy+201)
				if not netConnected then
					s:diffusealpha(0)
				end
			end,
		};
		LoadActor(Model().."base")..{
			InitCommand=function(s) s:diffusealpha(IsTitleMenu() and 0 or 1):xy(_screen.cx,_screen.cy+200):setsize(392,66) end,
		};
	};
else
	t[#t+1] = Def.ActorFrame {
		Def.Sprite{
			Texture="paseli_icon",
			InitCommand=function(s) s:zoom(0.667):x(SCREEN_RIGHT-29.3):y(SCREEN_TOP+168) end,
		};
		Def.Sprite{
			Texture=Language().."paseli.png",
			InitCommand=function(s) s:zoom(0.667):xy(_screen.cx+355,IsTitleMenu() and _screen.cy+135 or _screen.cy+201) end,
		};
		LoadActor(Model().."base")..{
			InitCommand=function(s) s:diffusealpha(IsTitleMenu() and 0 or 1):xy(_screen.cx,_screen.cy+200):setsize(392,66) end,
		};
	};
end
	
if not IsTitleMenu() then
	if netConnected then
		t[#t+1] = Def.Sprite{
			InitCommand=function(s) s:zoom(0.6):xy(_screen.cx,_screen.cy+200):queuecommand("Set") end,
			CoinInsertedMessageCommand=function(s) s:queuecommand("Set") end,
			SetCommand=function(s)
				if GAMESTATE:GetCoinMode() == 'CoinMode_Free' then
					s:Load(THEME:GetPathG("","ArcadeDecorations/"..Model()..Language().."start"))
					s:diffusealpha(1):diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5):sleep(2.5):diffusealpha(0):sleep(2.5):queuecommand("Set")
				elseif GAMESTATE:GetCoinMode() == "CoinMode_Home" then
					s:Load(THEME:GetPathG("","ArcadeDecorations/"..Model()..Language().."start"))
					s:diffusealpha(1):diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5):sleep(2.5):diffusealpha(0):sleep(2.5):queuecommand("Set")    
				else
					if GAMESTATE:EnoughCreditsToJoin() == true then
						s:Load(THEME:GetPathG("","ArcadeDecorations/"..Model()..Language().."start"))
						s:diffusealpha(1):diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5):sleep(2.5):diffusealpha(0):sleep(2.5):queuecommand("Set")     
					else
						s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."coin"))
						s:diffusealpha(1):diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5):sleep(2.5):diffusealpha(0):sleep(2.5):queuecommand("Set")   
					end
				end
			end
		};
		if GetCurrentModel() == "Gold" then
			t[#t+1] = Def.Sprite{
				InitCommand=function(s) s:zoom(0.6):xy(_screen.cx,_screen.cy+200):queuecommand("Set") end,
				CoinInsertedMessageCommand=function(s) s:queuecommand("Set") end,
				SetCommand=function(s)
					if GAMESTATE:GetCoinMode() == 'CoinMode_Free' then
						s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."button"))
						s:diffusealpha(1):sleep(2.5):diffusealpha(0):sleep(2.5):queuecommand("Set") 
					elseif GAMESTATE:GetCoinMode() == "CoinMode_Home" then
						s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."button"))
						s:diffusealpha(1):sleep(2.5):diffusealpha(0):sleep(2.5):queuecommand("Set") 
					else
						if GAMESTATE:EnoughCreditsToJoin() == true then
							s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."button"))
							s:diffusealpha(1):sleep(2.5):diffusealpha(0):sleep(2.5):queuecommand("Set") 
						end
					end
				end
			};
		end
	else
		t[#t+1] = Def.Sprite{
			InitCommand=function(s) s:zoom(0.6):xy(_screen.cx,_screen.cy+200):queuecommand("Set") end,
			CoinInsertedMessageCommand=function(s) s:queuecommand("Set") end,
			SetCommand=function(s)
				if GAMESTATE:GetCoinMode() == 'CoinMode_Free' then
					s:Load(THEME:GetPathG("","ArcadeDecorations/"..Model()..Language().."start"))
					s:diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5)  
				elseif GAMESTATE:GetCoinMode() == "CoinMode_Home" then
					s:Load(THEME:GetPathG("","ArcadeDecorations/"..Model()..Language().."start"))
					s:diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5)  
				else
					if GAMESTATE:EnoughCreditsToJoin() == true then
						s:Load(THEME:GetPathG("","ArcadeDecorations/"..Model()..Language().."start"))
						s:diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5)  
					else
						s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."coin"))
						s:diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5)
					end
				end
			end
		};
		if GetCurrentModel() == "Gold" then
			t[#t+1] = Def.Sprite{
				InitCommand=function(s) s:zoom(0.6):xy(_screen.cx,_screen.cy+200):queuecommand("Set") end,
				CoinInsertedMessageCommand=function(s) s:queuecommand("Set") end,
				SetCommand=function(s)
					if GAMESTATE:GetCoinMode() == 'CoinMode_Free' then
						s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."button"))
					elseif GAMESTATE:GetCoinMode() == "CoinMode_Home" then
						s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."button"))
					else
						if GAMESTATE:EnoughCreditsToJoin() == true then
							s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."button"))
						end
					end
				end
			};
		end
	end

	if netConnected then
		t[#t+1] = Def.Sprite{
			InitCommand=function(s) s:zoom(0.6):xy(_screen.cx,_screen.cy+200):queuecommand("Set") end,
			CoinInsertedMessageCommand=function(s) s:queuecommand("Set") end,
			SetCommand=function(s)
				if GAMESTATE:GetCoinMode() == 'CoinMode_Free' then
					s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."eamuse"))
					s:diffusealpha(0):zoomx(0.58):sleep(2.5):diffusealpha(1):diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5):sleep(2.5):diffusealpha(0):queuecommand("Set") 
				elseif GAMESTATE:GetCoinMode() == "CoinMode_Home" then
					s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."eamuse"))
					s:diffusealpha(0):zoomx(0.58):sleep(2.5):diffusealpha(1):diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5):sleep(2.5):diffusealpha(0):queuecommand("Set")    
				else
					if GAMESTATE:EnoughCreditsToJoin() == true then
						s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."eamuse"))
						s:diffusealpha(0):zoomx(0.58):sleep(2.5):diffusealpha(1):diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5):sleep(2.5):diffusealpha(0):queuecommand("Set")     
					else
						s:Load(THEME:GetPathG("","ArcadeDecorations/"..Language().."eamuse"))
						s:diffusealpha(0):zoomx(0.58):sleep(2.5):diffusealpha(1):diffuseshift():effectcolor1(color("##ffffff")):effectcolor2(color(effectColor())):effectperiod(2.5):sleep(2.5):diffusealpha(0):queuecommand("Set")   
					end
				end
			end
		};
	end
end 

return t