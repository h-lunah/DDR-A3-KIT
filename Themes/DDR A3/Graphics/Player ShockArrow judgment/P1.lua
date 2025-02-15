local currentEvent = nil
local previousEvent = nil
local isAnimating = false
local isNGEffectActive = false -- Flag to track if NG is in effect

return Def.ActorFrame {
    LoadActor(THEME:GetPathG("","HoldJudgment label 1x2/Shock"))..{
        InitCommand=function(s) s:diffusealpha(0):animate(false):xy(SCREEN_LEFT+185, SCREEN_CENTER_Y-75) end,
        OnCommand=function(s)
            -- Fix position when playing Double Style
            if GAMESTATE:GetCurrentStyle():GetName() == "double" then
                s:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-75)
            end

            local options = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptionsString("ModsLevel_Preferred")

            if options:find("Reverse") then
                s:addy(145)
            end
        end,
        JudgmentMessageCommand=function(self, params)
            if params.Player ~= PLAYER_1 then return end;

            -- Only process AvoidMine and HitMine events
            if params.TapNoteScore == 'TapNoteScore_AvoidMine' 
                or params.TapNoteScore == 'TapNoteScore_HitMine'
            then
                -- Prioritize HitMine (NG) over AvoidMine (OK)
                if params.TapNoteScore == 'TapNoteScore_HitMine' then
                    currentEvent = 'TapNoteScore_HitMine'
                    isNGEffectActive = true -- Set NG effect flag
                elseif currentEvent ~= 'TapNoteScore_HitMine' and not isNGEffectActive then
                    currentEvent = params.TapNoteScore
                end

                -- Only start the animation if not already animating
                if not isAnimating then
                    self:queuecommand("Animate")
                end
            else
                -- Hide the actor for any other judgment
                self:stoptweening() -- Stop any ongoing animation
                self:diffusealpha(0) -- Hide immediately
                currentEvent = nil -- Reset current event
                isAnimating = false -- Reset animation state
                isNGEffectActive = false -- Reset NG effect flag
            end
        end;
        AnimateCommand=function(self)
            isAnimating = true
            self:finishtweening()

            -- NG
            if currentEvent == 'TapNoteScore_HitMine' then
                self:setstate(1) -- Show NG state
            -- OK
            elseif currentEvent == 'TapNoteScore_AvoidMine' and previousEvent ~= 'TapNoteScore_HitMine' then
                self:setstate(0) -- Show OK state
            -- OK after NG
            else
                self:setstate(0) -- Default to OK state
            end

            self:diffusealpha(1)
            self:zoom(0.28 * 1.5)
            self:sleep(0.5)
            self:diffusealpha(0)

            -- Update previousEvent and reset currentEvent after animation
            previousEvent = currentEvent
            currentEvent = nil
            isAnimating = false
            isNGEffectActive = false -- Reset NG effect flag after animation
        end,
    }
}