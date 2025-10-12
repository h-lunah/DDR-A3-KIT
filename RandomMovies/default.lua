-- This file potentially may be unused. RandomMovies are not an actor on the background layer.
local t = Def.ActorFrame{}

local num = math.random(11,33);

t[#t+1] = LoadActor("Char"..num)..{
  InitCommand=function(self) self:FullScreen():play() end,
};
	
return t;
