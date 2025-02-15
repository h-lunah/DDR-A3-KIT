local t = Def.ActorFrame{}

t[#t+1] = Def.ActorFrame{
    CurrentSongChangedMessageCommand=function(s)
        local mpStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
        local songsPlayed = mpStats:GetSongsPlayed()

        if IsDanCourse() and songsPlayed > 1 then
            local ct = 61
            local deltas = 0
            local lastDisplayedTime = math.floor(ct)
			local lastTickTime = ct

            local breakTimeLeft = s:GetChild("BreakTimeLeft")
            local breakTimeHeader = s:GetChild("BreakTimeHeader")
            local breakTimeFooter = s:GetChild("BreakTimeFooter")
            local breakTimeBack = s:GetChild("BreakTimeBack")
            local breakTimeUp = s:GetChild("BreakTimeUp")
            local breakTimeDown = s:GetChild("BreakTimeDown")

            local breakTimeMusic = s:GetChild("BreakTimeMusic")

            local refreshRate = DISPLAY:GetDisplaySpecs()[1]:GetCurrentMode():GetRefreshRate()

            s:SetUpdateFunction(function(self, delta)
                deltas = deltas + 1

                -- HACK: To count 1 second in a function using deltas you need to ensure that the amount of deltas is equal to the frame rate.
                -- Frame-based programming is wonky.
                if deltas == refreshRate then
                    breakTimeLeft:visible(true)
                    breakTimeHeader:visible(true)
                    breakTimeFooter:visible(true)
                    breakTimeBack:visible(true)
                    breakTimeUp:visible(true)
                    breakTimeDown:visible(true)

                    breakTimeMusic:play()
                end

                ct = math.max(0, ct - delta)

                local currentTime = math.floor(ct)
                if currentTime ~= lastDisplayedTime then
                    breakTimeLeft:settext(string.format("%02d", currentTime))

                    breakTimeLeft:finishtweening()
                    breakTimeLeft:zoom(0.5)
                    breakTimeLeft:accelerate(0.2):zoom(2)
                    breakTimeLeft:accelerate(0.05):zoomx(2.5)
                    breakTimeLeft:accelerate(0.05):zoomx(2)

                    lastDisplayedTime = currentTime
                end

                -- Since the timer ends at 0, the timer being at 5 happens at a value of 6
				if ct <= 6 then
                    breakTimeLeft:blend("BlendMode_Add")
				    breakTimeLeft:diffuse(color("1,0,0,1"))
				
					if math.floor(ct) ~= lastTickTime then
						SOUND:PlayOnce(THEME:GetPathS("", "MenuTimer tick"))
						lastTickTime = math.floor(ct)
					end
                else
                    breakTimeLeft:diffuse(color("1,1,1,1"))
				end

                if ct == 0 then
                    breakTimeLeft:visible(false)
                    breakTimeHeader:visible(false)
                    breakTimeFooter:visible(false)
                    breakTimeBack:visible(false)
                    breakTimeUp:visible(false)
                    breakTimeDown:visible(false)
                elseif ct < 1 then
                    breakTimeMusic:stop()
                end
            end)
            ct = 61
        end
    end,

    LoadFont("BreakTime Numbers") .. {
        Name = "BreakTimeLeft",
        InitCommand = function(self)
            self:Center()
            self:settext("")
            self:draworder(999)
            self:visible(false)
        end,
    },

    LoadActor("back") .. {
        Name="BreakTimeBack",
        InitCommand = function(self)
            self:visible(false)
            self:draworder(998)
            self:FullScreen()
        end,
    },

    LoadActor("updown") .. {
        Name = "BreakTimeUp",
        InitCommand = function(self)
            self:visible(false)
            self:draworder(998)
            self:xy(SCREEN_CENTER_X, self:GetHeight()/3) -- Position at the top center of the screen
            self:zoomx(SCREEN_WIDTH / self:GetWidth()) -- Zoom to fill the screen width
            self:zoomy(1) -- Keep the original height
        end,
    },

    LoadActor("updown") .. {
        Name = "BreakTimeDown",
        InitCommand = function(self)
            self:visible(false)
            self:draworder(998)
            self:xy(SCREEN_CENTER_X, SCREEN_HEIGHT - self:GetHeight()/3) -- Position at the bottom center of the screen
            self:zoomx(SCREEN_WIDTH / self:GetWidth()) -- Zoom to fill the screen width
            self:zoomy(-1) -- Keep the original height
        end,
    },

    LoadActor("header") .. {
        Name="BreakTimeHeader",
        InitCommand = function(self)
            self:Center()
            self:y(SCREEN_TOP+100)
            self:draworder(999)
            self:visible(false)
        end,
    },

    LoadActor(THEME:GetPathG("ScreenWithMenuElements", "footer"))..{
        Name="BreakTimeFooter",
        InitCommand=function(self)
            self:Center()
            self:y(SCREEN_BOTTOM-50)
            self:draworder(999)
            self:visible(false)
        end,
    },

    LoadActor(THEME:GetPathS("", "BreakTime/BreakTime Music "..math.random(1,7)))..{
        Name="BreakTimeMusic",
        InitCommand=function(self)
            self:stop()
        end,
    },

    LoadActor(THEME:GetPathB("ScreenWithMenuElements","background/"..Model().."background"))..{
        InitCommand=function(self)
            self:FullScreen():diffusealpha(0)
        end,
        
        CurrentSongChangedMessageCommand=function(self)
            local mpStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
            local songsPlayed = mpStats:GetSongsPlayed()

            if songsPlayed > 1 then
                self:linear(0.5):diffusealpha(1):sleep(60):diffusealpha(0)
            end
        end
    }
}

return t;
