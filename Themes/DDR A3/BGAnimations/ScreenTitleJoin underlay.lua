return Def.ActorFrame {
    InitCommand=function(s)
        s.timer = 0
        s.delay = 10
        s:SetUpdateFunction(function(self, delta)
            self.timer = self.timer + delta
            if self.timer >= self.delay then
                self:queuecommand("GoBackToAttract")
                self.timer = -math.huge
            end
        end)
    end,

    GoBackToAttractCommand=function(s)
        SCREENMAN:GetTopScreen():SetNextScreenName("ScreenHowToPlay"):StartTransitioningScreen("SM_GoToNextScreen")
    end,
}