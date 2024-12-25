local positions = {-101, -76, -51, -26, 0, 25, 50, 75, 100}
local currentScreen = Var "LoadingScreen"

-- Determine star direction based on active player
local function GetStarPositions()
    if GAMESTATE:IsPlayerEnabled(PLAYER_2) and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then
        -- Reverse positions for PLAYER 2 only
        local reversed_positions = {}
        for i = #positions, 1, -1 do
            table.insert(reversed_positions, positions[i] * -1) -- Negate to align with PLAYER 2's side
        end
        return reversed_positions
    end
    -- Default to normal for PLAYER 1 or both players
    return positions
end

local starPositions = GetStarPositions()

t = Def.ActorFrame{
    Condition=not GAMESTATE:IsEventMode();
}

t[#t+1] = Def.ActorFrame {
    LoadActor(Model().."nine");
}

if currentScreen == "ScreenEvaluationNormal" and StarsActuallyAdded > 0 then
    for i=1,GetExtraStageStars()-GetRecentExtraStageStars() do
        t[#t+1] = Def.ActorFrame {
            InitCommand=function(s)
                s:diffuseblink()
                s:effectcolor1(color("#000000"))
                s:effectcolor2(color("#ffffff"))
                s:effectperiod(0.1)
                s:sleep(0.7)
                s:queuecommand("StopBlinking")            
            end;
            StopBlinkingCommand=function(s)
                s:effectcolor1(color("#ffffff"))
            end;
            LoadActor("star")..{
                InitCommand=function(s)
                    s:xy(starPositions[i], 1)
                end,
            };
            LoadActor("star")..{
                InitCommand=function(s)
                    s:blend(Blend.Add):diffusealpha(0):linear(0.01):smooth(0.3):diffusealpha(1)
                    s:diffuseramp():effectcolor1(color("1,1,1,0")):effectcolor2(color("1,1,1,1")):effectperiod(0.70)
                    s:xy(starPositions[i], 1)
                    s:sleep(2.5)
                    s:queuecommand("ExtraStage")
                end,

                ExtraStageCommand=function(s)
                    if GetExtraStageStars() == 9 and STATSMAN:GetCurStageStats():GetStage() == "Stage_Final" then
                        s:rainbow()
                    end
                end,
            };
        }
    end
else
    for i=1,GetExtraStageStars() do
        t[#t+1] = Def.ActorFrame {
            LoadActor("star")..{
                InitCommand=function(s)
                    s:xy(starPositions[i], 1)
                end,
            };
            LoadActor("star")..{
                InitCommand=function(s) 
                    s:blend(Blend.Add):diffusealpha(0):linear(0.01):smooth(0.3):diffusealpha(1)
                    s:diffuseramp():effectcolor1(color("1,1,1,0")):effectcolor2(color("1,1,1,1")):effectperiod(0.70)
                    s:xy(starPositions[i], 1)
                end,
            };
        }
    end
end

-- Animate incoming stars
if currentScreen == "ScreenEvaluationNormal" and StarsActuallyAdded > 0 then
    for i=(GetExtraStageStars()-GetRecentExtraStageStars())+1,GetExtraStageStars() do
        t[#t+1] = Def.ActorFrame {
            InitCommand=function(s)
                s:diffusealpha(0)
                s:addy(-50)
                s:sleep(1)
                if GetExtraStageStars()-GetRecentExtraStageStars() == 0 then
                    s:sleep(0.3*i)
                else
                    s:sleep(0.3*(i-GetRecentExtraStageStars()))
                end
                s:queuecommand("PlaySound")
                s:accelerate(0.3)
                s:diffusealpha(1)
                s:addy(50)
            end;
            PlaySoundCommand=function(s)
                SOUND:PlayOnce(THEME:GetPathS("", "ExtraStageStar gained.ogg"))
            end;
            LoadActor("star")..{
                InitCommand=function(s)
                    s:xy(starPositions[i], 1)
                end,
            };
            LoadActor("star")..{
                InitCommand=function(s) 
                    s:blend(Blend.Add):diffusealpha(0):linear(0.01):smooth(0.3):diffusealpha(1)
                    s:diffuseramp():effectcolor1(color("1,1,1,0")):effectcolor2(color("1,1,1,1")):effectperiod(0.70)
                    s:xy(starPositions[i], 1)
                    s:sleep(2.5)
                    s:queuecommand("ExtraStage")
                end,

                ExtraStageCommand=function(s)
                    if GetExtraStageStars() == 9 and STATSMAN:GetCurStageStats():GetStage() == "Stage_Final" then
                        s:rainbow()
                    end
                end,
            };
        }
    end
end

return t
