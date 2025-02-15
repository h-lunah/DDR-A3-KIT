local t = Def.ActorFrame {};
local Style = Var("GameCommand"):GetName();
local pn = {PLAYER_1, PLAYER_2}
--------------------------------------
t[#t+1] = Def.ActorFrame {
    LoadActor(Style) .. {
		InitCommand=cmd(zoom,0.667;xy,142,80);
	};
};

return t;
