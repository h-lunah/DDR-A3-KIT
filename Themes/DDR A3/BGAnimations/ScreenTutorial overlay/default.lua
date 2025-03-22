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

t[#t+1] = Def.ActorFrame {
    BeginCommand=function(self)
        SCREENMAN:GetTopScreen():AddInputCallback(function(event)
            if event.type == "InputEventType_Release" and event.button == "Start" then
                self:queuecommand("EndTutorial")
            end
        end)
    end,
    EndTutorialCommand=function(self)
        self:GetChild("Sound"):queuecommand("Animate")
        self:GetChild("ENJOY"):queuecommand("Animate")
        self:sleep(5):queuecommand("Transition")
    end,
    TransitionCommand=function(self)
        SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectMusic"):StartTransitioningScreen("SM_GoToNextScreen")
    end,

    Def.ActorFrame{
        Name="Sound",
        Def.ActorFrame{
            AnimateCommand=function(s) s:queuecommand("Play") end,
            PlayCommand=function(s)
                SOUND:PlayAnnouncer("cheering normal ac")
                SOUND:PlayOnce(THEME:GetPathS("","DoorClose")) 
            end,
        };
        LoadActor(THEME:GetPathG("","_doors/background_black"))..{
            InitCommand=function(s) s:FullScreen():diffusealpha(0) end,
            AnimateCommand=function(s) s:sleep(0.35):linear(0.1):diffusealpha(1) end,
        };
        Def.Sprite{
            Texture=BackgroundInit(),
            InitCommand=function(s) s:FullScreen():SetAllStateDelays(0.042):diffusealpha(0) end,
            AnimateCommand=function(s) s:sleep(0.6):linear(0.1):diffusealpha(1) end,
        };
        Def.Quad{
            InitCommand=function(s) s:FullScreen():diffuse(Color.Black):diffusealpha(0) end,
            AnimateCommand=function(s) s:sleep(0.6):linear(0.1):diffusealpha(0.2) end,
        };
        Def.Sprite{
            Texture=THEME:GetPathG("","_doors/lines"),
            InitCommand=function(s) s:FullScreen():blend(('BlendMode_Add')):diffusealpha(0) end,
            OnCommand=function(s) s:sleep(0.6):linear(0.1):diffusealpha(0.14) end,
        };
        LoadActor(THEME:GetPathG("","_doors/squares"))..{
            InitCommand=function(s) s:FullScreen():blend(('BlendMode_Add')):diffusealpha(0) end,
            AnimateCommand=function(s) s:sleep(0.6):linear(0.1):diffusealpha(0.14) end,
        };
        Def.Quad{
            InitCommand=cmd(diffusealpha,0);
            AnimateCommand=cmd(sleep,1.75);
        };
        Def.ActorFrame{
            InitCommand=function(s) s:x(_screen.cx) end,	
            LoadActor(THEME:GetPathG("","_doors/"..GetCurrentModel().."/door up"))..{ 
                InitCommand=function(s) s:zoom(0.667):y(SCREEN_TOP+30):diffusealpha(0) end,
                AnimateCommand=function(s) s:sleep(0.3):linear(0.1):y(SCREEN_TOP+63):diffusealpha(1) end, 
            }; 
            LoadActor(THEME:GetPathG("","_doors/"..GetCurrentModel().."/door down"))..{  
                InitCommand=function(s) s:zoom(0.667):y(SCREEN_BOTTOM-30):diffusealpha(0) end,
                AnimateCommand=function(s) s:sleep(0.3):linear(0.1):y(SCREEN_BOTTOM-63):diffusealpha(1) end, 
            }; 		
        };
    };
    LoadActor(THEME:GetPathG("", "_shared/message/ENJOY"))..{
        Name="ENJOY",
        InitCommand=function(self)
            self:Center():diffusealpha(0)
        end,
        AnimateCommand=function(s)
            s:sleep(0.035):diffusealpha(1):zoom(0)
            s:linear(0.1):zoom(0.418)
            s:linear(0.1):zoomx(0.62):zoomy(0.64)
            s:linear(0.1):zoomx(0.69):zoomy(0.71)
            s:linear(0.1):zoom(0.667)
        end
    }
}

return t
