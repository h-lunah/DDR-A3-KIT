

return Def.ActorFrame {
	Def.Actor{
		OnCommand=function(self)
		Language()
		Model()
		MenuTimer()
		SelectMusicBGM()
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
		end;
	};
};