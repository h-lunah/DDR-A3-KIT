t = Def.ActorFrame{}

local BreakTime = IsDanCourse() and 60 or 0

if IsDanCourse() then
	t[#t+1] = Def.Quad {
		InitCommand=function(self)
			self:FullScreen():diffuse(color("1,1,1,1")):diffusealpha(0):draworder(1000)
		end,

		CurrentSongChangedMessageCommand=function(self)
			local mpStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
            local songsPlayed = mpStats:GetSongsPlayed()

            if songsPlayed > 1 then
				self:linear(1):diffusealpha(1):linear(0.25):diffusealpha(0)
			end
		end,
	}

    t[#t+1] = LoadActor("BreakTime");
end

t[#t+1] = Def.ActorFrame{
        CurrentSongChangedMessageCommand=function(s)
                IsTransitioning = true
                if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetName() == "ScreenGameplay" and GAMESTATE:IsCourseMode() then
                        s:visible(true)
                        SCREENMAN:GetTopScreen():PauseGame(true)
                        s:sleep(3.5 + BreakTime)
                        s:queuecommand("UnpauseGame")
                end
        end,

        UnpauseGameCommand=function(s)
                SCREENMAN:GetTopScreen():PauseGame(false)
                s:visible(false)
        end
}

t[#t+1] = Def.ActorFrame{
        OnCommand=function(s)
                local mpStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
                local songsPlayed = mpStats:GetSongsPlayed()

                if songsPlayed < 2 then return end

                if SCREENMAN:GetTopScreen():GetName() == "ScreenGameplay" and GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentSong() then
            s:AddChildFromPath(THEME:GetPathB("ScreenStageInformation", "decorations/default.lua"))
            s:queuecommand("PlaySounds")
                end
        end,

        PlaySoundsCommand=function(self)
                local StageSound = THEME:GetPathS("ScreenStageInformation", "StageSound")
                SOUND:PlayOnce(StreamingSound(StageSound))

                local mpStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( GAMESTATE:GetMasterPlayerNumber() )
                local songsPlayed = mpStats:GetSongsPlayed()
                if songsPlayed == GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() then
                        songsPlayed = "final"
                end

                SOUND:PlayAnnouncer("stage "..songsPlayed);

                self:sleep(0.3)
                self:queuecommand("PlayDoorSound")
        end,

        PlayDoorSoundCommand=function(self)
                local DoorSound = THEME:GetPathS("", "DoorClose")
                SOUND:PlayOnce(StreamingSound(DoorSound))

                self:sleep(1.35)
                self:queuecommand("PlayJacketSound")
        end,

        PlayJacketSoundCommand=function(self)
                local JacketSound = THEME:GetPathS("ScreenStageInformation", "JacketSound")
                SOUND:PlayOnce(StreamingSound(JacketSound))

                self:RunCommandsOnChildren(cmd(sleep,3;diffusealpha,0))
                self:sleep(3 + BreakTime)
        end,

        CurrentSongChangedMessageCommand=function(s)
                s:stoptweening()
                :sleep(BreakTime)
                :queuecommand("On")
        end,
}

return t;