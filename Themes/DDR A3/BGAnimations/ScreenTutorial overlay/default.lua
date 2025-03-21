local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
    LoadActor(Language()..Model().."howtoplay")..{
        InitCommand=function(self)
            self:Center()
            self:FullScreen()
        end,
        OnCommand=function(self)
            self:play():loop(false)
        end,
    },

    LoadActor(Language().."music")..{
        OnCommand=function(self)
            self:play()
        end,    
    },

	LoadActor(THEME:GetPathS("", "DoorClose"))..{
        OnCommand=function(self)
            self:sleep(102):queuecommand("Play"):sleep(5):queuecommand("GoNext")
        end,
        PlayCommand=function(s)
            SOUND:PlayAnnouncer("cheering normal ac")
            s:play()
        end,
        GoNextCommand=function(s)
            SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectMusic"):StartTransitioningScreen("SM_GoToNextScreen")
        end,
    },
}

t[#t+1] = Def.Quad{
    InitCommand=function(s) s:diffuse(color("#ffffff")):FullScreen():diffusealpha(1) end,
    OnCommand=function(s) s:sleep(0.01):linear(0.25):diffusealpha(0) end,
};

return t
