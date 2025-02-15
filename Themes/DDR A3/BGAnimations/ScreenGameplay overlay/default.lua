local t = Def.ActorFrame{};

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = LoadActor("FullCombo",pn);
end;

t[#t+1] = LoadActor("GameOver");

if not GAMESTATE:IsCourseMode() then
	if GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "LET'S CHECK YOUR LEVEL!" then
		t[#t+1] = LoadActor("LET'S CHECK YOUR LEVEL!");
	elseif GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Steps to the Star" then
		t[#t+1] = LoadActor("LET'S CHECK YOUR LEVEL! (World)");
	elseif GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Lesson by DJ" then
		t[#t+1] = LoadActor("Lesson by DJ");
	end;
end

if GAMESTATE:IsCourseMode() then
	t[#t+1] = LoadActor("CourseTransition");
end

return t;