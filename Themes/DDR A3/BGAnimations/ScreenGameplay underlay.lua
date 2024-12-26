local SBG = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred")

return Def.ActorFrame {
	InitCommand=function(s)
		SBG:RandomBGOnly(false)
		if HasVideo() then
			PREFSMAN:SetPreference("SongBackgrounds", true)
		else
			PREFSMAN:SetPreference("SongBackgrounds", false)
		end
	end,
	CurrentSongChangedMessageCommand=function(s)
		SBG:RandomBGOnly(false)
		if HasVideo() then
			PREFSMAN:SetPreference("SongBackgrounds", true)
		else
			PREFSMAN:SetPreference("SongBackgrounds", false)
		end
	end;
};
