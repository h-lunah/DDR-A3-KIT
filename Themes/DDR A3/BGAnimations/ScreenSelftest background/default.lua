local t = Def.ActorFrame {}

t[#t+1] = Def.Quad {
    InitCommand=function(s)
        s:diffuse(color("#000000"))
         :FullScreen()
    end;
}

t[#t+1] = Def.Actor {
    OnCommand=function(s)
        WritePrefToFile("OptionRowLanguage", 'default')
        GAMESTATE:InsertCoin(-GAMESTATE:GetCoins())
        s:sleep(8)
         :queuecommand("StartAttract")
    end,
    
    StartAttractCommand=function(s)
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
    end
}

t[#t+1] = Def.BitmapText {
    Font="_service";
    InitCommand=function(s)
        s:uppercase(true)
         :settext(GetBuild())
         :xy(100, 30)
         :zoom(0.7)
    end
}

t[#t+1] = Def.BitmapText {
    Font="_service";
    InitCommand=function(s)
        s:uppercase(true)
         :settext("CHECKING")
         :xy(SCREEN_CENTER_X, 50)
         :zoom(0.7)
    end
}

local checks = {
    {label = "I/O", y = -75, done = false, uppercase = true},
    {label = "SECURITY", y = -55, done = false, uppercase = true},
    {label = "TESTMODE", y = -35, done = false, uppercase = true},
    {label = "BOOKKEEPING", y = -15, done = false, uppercase = true},
    {label = "CALIBRATION", y = 5, done = false, uppercase = true},
    {label = "CLOCK", y = 25, done = false, uppercase = true},
    {label = "DATA1", y = 45, done = false, uppercase = true},
    {label = "e-amusement", y = 65, done = false, uppercase = false},
}

for i, check in ipairs(checks) do
    t[#t+1] = Def.ActorFrame {
        InitCommand=function(s)
            s:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
        end,

        Def.BitmapText {
            Font="_service";
            InitCommand=function(s)
                s:uppercase(check.uppercase)
                 :horizalign(left)
                 :settext(check.label)
                 :xy(-100, check.y)
                 :zoom(0.5)
            end
        },

        Def.BitmapText {
            Font="_service";
            InitCommand=function(s)
                s.dotCount = 1

                s:uppercase(true)
                 :horizalign(left)
                 :xy(100, check.y)
                 :zoom(0.5)
                 :queuecommand("Update")
            end,

            UpdateCommand=function(self)
                -- Increment dot count and cycle every 0.5 seconds
                self.dotCount = (self.dotCount + 1) % 4
                if self.dotCount == 0 then
                    self.dotCount = 1
                end

                if check.done then
                    self:diffuse(color("#00ff00"))
                    self:settext("OK")
                return end

                self:settext(string.rep(".", self.dotCount % 4))

                self:sleep(0.2):queuecommand("Update")
            end
        }
    }
end

t[#t+1] = Def.Actor {
    InitCommand=function(s)
        for i, check in ipairs(checks) do
            s:sleep(0.2)
             :queuecommand("DoneChecking"..i)
        end
    end,

    DoneChecking1Command=function(s)
        checks[1].done = true
    end,

    DoneChecking2Command=function(s)
        checks[2].done = true
    end,

    DoneChecking3Command=function(s)
        checks[3].done = true
    end,

    DoneChecking4Command=function(s)
        checks[4].done = true
    end,

    DoneChecking5Command=function(s)
        checks[5].done = true
    end,

    DoneChecking6Command=function(s)
        checks[6].done = true
    end,

    DoneChecking7Command=function(s)
        checks[7].done = true
    end,

    DoneChecking8Command=function(s)
        checks[8].done = true
    end
}

t[#t+1] = Def.BitmapText {
    Font="_service";
    InitCommand=function(s)
        s:uppercase(true)
         :horizalign(left)
         :settext("COMPLETE.")
         :xy(SCREEN_CENTER_X+100, SCREEN_CENTER_Y+90)
         :diffuse(color("#00ff00"))
         :zoom(0.5)
         :diffusealpha(0)
         :sleep(1.8)
         :queuecommand("Show")
    end,

    ShowCommand=function(s)
        s:diffusealpha(1)
    end
}

t[#t+1] = Def.ActorFrame {
    Def.Quad{
        InitCommand=function(s)
            s:diffuse(color("#000000"))
             :FullScreen()
             :diffusealpha(0)
             :sleep(3)
             :queuecommand("Show")
        end,

        ShowCommand=function(s)
            s:diffusealpha(1)
        end
    };

    Def.BitmapText {
        Font="_service";
        InitCommand=function(s)
            s:settext("please wait")
             :diffusealpha(0)
             :xy(30, 10)
             :zoom(0.5)
             :sleep(4)
             :queuecommand("Show")
        end,

        ShowCommand=function(s)
        	s:linear(0.25)
             :diffusealpha(1)
             :sleep(1)
             :settext("please wait.")
             :sleep(1)
             :settext("please wait..")
             :sleep(1)
             :settext("please wait...")
        end
    }
}

return t
