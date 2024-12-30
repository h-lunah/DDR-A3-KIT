

return Def.ActorFrame {
	Def.Actor{
		OnCommand=function(self)
		Language()
		Model()
		MenuTimer()
		SelectMusicBGM()
		local coins = GAMESTATE:GetCoins()
			if coins >= 1 then
				GAMESTATE:InsertCoin(-coins)
			end
			WritePrefToFile("OptionRowLanguage", 'default')
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
		end;
	};
};