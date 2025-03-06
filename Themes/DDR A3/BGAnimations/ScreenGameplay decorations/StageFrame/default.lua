function CourseStageIndex(currentStage, maxStage)
    if currentStage == maxStage then
        return "FINAL", ""
    else
        local suffix
        if currentStage % 10 == 1 and currentStage % 100 ~= 11 then
            suffix = "st"
        elseif currentStage % 10 == 2 and currentStage % 100 ~= 12 then
            suffix = "nd"
        elseif currentStage % 10 == 3 and currentStage % 100 ~= 13 then
            suffix = "rd"
        else
            suffix = "th"
        end
        return tostring(currentStage), suffix
    end
end

return Def.ActorFrame {
    LoadActor(Model().."frame")..{
        InitCommand=function(s) s:x(SCREEN_CENTER_X):y(SCREEN_TOP+27):zoom(0.667) end,
    };
    Def.ActorFrame {
        -- Main Number Actor
        LoadFont("_helvetica-compressed 32px") .. {
            Name="MainNumber";
            InitCommand=cmd(playcommand,"Set");
            CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
            CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
            CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
            CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
            CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
            CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
            SetCommand=function(self)
				if not self:GetParent():GetChild("Suffix") then return end
                if GAMESTATE:IsCourseMode() then
                    if not STATSMAN:GetCurStageStats() then return end
                    local mpStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( GAMESTATE:GetMasterPlayerNumber() )
                    local songsPlayed = mpStats:GetSongsPlayed()
                    stage, suffix = CourseStageIndex(songsPlayed, GAMESTATE:GetCurrentCourse():GetEstimatedNumStages())
                    self:settext(stage)
                    self:GetParent():GetChild("Suffix"):settext(suffix)
                else
                    if GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "LET'S CHECK YOUR LEVEL!" or GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Steps to the Star" then
                        self:settext("CHECKING")
                        suffix = ""
                        self:GetParent():GetChild("Suffix"):settext("")
                    elseif GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Lesson by DJ" then
                        self:settext("HOW TO PLAY")
                        suffix = ""
                        self:GetParent():GetChild("Suffix"):settext("")
                    elseif GAMESTATE:IsDemonstration() and not GAMESTATE:IsCourseMode() then
                        self:settext("1")
						suffix = "st"
                        self:GetParent():GetChild("Suffix"):settext("st")
                    elseif GAMESTATE:IsEventMode() then
                        local songsPlayed
                        if songsPlayedThisGame ~= nil then
                            songsPlayed = songsPlayedThisGame
                        else
                            songsPlayed = 1
                        end

                        if songsPlayed >= 5 then
                            self:settext("FINAL")
                        else
                            self:settext(songsPlayed)
                        end
                        
                        if songsPlayed % 10 == 1 and songsPlayed % 100 ~= 11 then
                            suffix = "st"
                        elseif songsPlayed % 10 == 2 and songsPlayed % 100 ~= 12 then
                            suffix = "nd"
                        elseif songsPlayed % 10 == 3 and songsPlayed % 100 ~= 13 then
                            suffix = "rd"
                        elseif songsPlayedThisGame >= 5 then
                            suffix = ""
                        else
                            suffix = "th"
                        end
                        if songsPlayed < 5 then
                            self:GetParent():GetChild("Suffix"):settext(suffix)
                        else
                            self:GetParent():GetChild("Suffix"):settext("")
                        end
                    else
                        local thed_stage = thified_curstage_index(false)
                        
                        if thed_stage == "Extra1" then
                            thed_stage = "EXTRA"
                        elseif thed_stage == "Extra2" then
                            thed_stage = "ENCORE EXTRA"
                        end
                        if string.len(thed_stage) >= 5 then
                            thed_stage = string.upper(thed_stage)
                        end

                        suffix = thed_stage:sub(-2)

						if suffix == "st" or suffix == "nd" or suffix == "rd" or suffix == "th" then
							self:settext(thed_stage:sub(1, -3))
							self:GetParent():GetChild("Suffix"):settext(suffix)
						else
							suffix = ""
							self:settext(thed_stage)
							self:GetParent():GetChild("Suffix"):settext("")
						end
                    end
                end
                -- Adjust suffix position based on main number width
                local mainNumberWidth = self:GetZoomedWidth()
				if suffix == "" then
					self:x(_screen.cx):y(SCREEN_TOP+35):zoom(0.45):diffuse(color("1,1,1,1"))
					self:GetParent():GetChild("Suffix"):visible(false) -- Hide suffix
				else
					self:zoom(0.45):maxwidth(135):x(_screen.cx - mainNumberWidth / 3):y(SCREEN_TOP+35):diffuse(color("1,1,1,1")):addx(-1)
					self:GetParent():GetChild("Suffix"):x(_screen.cx + mainNumberWidth / 3):y(SCREEN_TOP+35):halign(0.25):valign(0.25)
				end
            end;
        };
        -- Suffix Actor
        LoadFont("_helvetica-compressed 32px") .. {
            Name="Suffix";
            InitCommand=cmd(playcommand,"Set");
            CurrentSongChangedMessageCommand=cmd(playcommand,"Set");
            CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
            CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Set");
            CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Set");
            CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
            CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");
            SetCommand=function(self)
                self:zoom(0.3):diffuse(color("1,1,1,1"))
            end;
        };
    };
};