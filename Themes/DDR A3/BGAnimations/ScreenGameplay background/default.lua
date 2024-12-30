local loader
if GetUserPref("OptionRowGameplayBackground")=='DanceStages' then
	loader = "DanceStages"
elseif GetUserPref("OptionRowGameplayBackground")=='SNCharacters' then
	loader = "SNCharacters"
else
	loader = "Background"
end;

t = Def.ActorFrame{};

t[#t+1] = LoadActor(loader);


t[#t+1] = Def.Quad {
	InitCommand=function(s)
		s:zoomto(10000, 10000):Center():diffuse(color("#000000")):visible(HasVideo())
	end;
	CurrentSongChangedMessageCommand=function(s)
		s:visible(HasVideo())
	end;
}


return t;