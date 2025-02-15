-- DDR A evaluation announcer engine
-- Announcer only speaks out the highest rank or award.

local Grades = {}
local Awards = {}
local isSoundPlaying = false  -- Flag to track if a sound is currently playing

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
    Awards[pn] = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetStageAward()
    Grades[pn] = GetGrade(STATSMAN:GetCurStageStats():GetPlayerStageStats(pn), nil)
end

function PlaySound(sound)
    if not isSoundPlaying then
        isSoundPlaying = true
        SOUND:PlayAnnouncer(sound)
    end
end

t = Def.ActorFrame {
    OnCommand=function(s)
        local hasAward = false
        local highestGrade = nil
        local gradeOrder = {
            "Grade_Tier01", "Grade_Tier02", "Grade_Tier03", "Grade_Tier04", "Grade_Tier05", "Grade_Tier06",
            "Grade_Tier07", "Grade_Tier08", "Grade_Tier09", "Grade_Tier10", "Grade_Tier11",
            "Grade_Tier12", "Grade_Tier13", "Grade_Tier14", "Grade_Tier15", "Grade_Tier16", 
            "Grade_Tier17", "Grade_Failed"
        }

        for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
            local award = Awards[pn]
            if award and (string.find(award, "FullCombo") or string.find(award, "SingleDigit") or string.find(award, "One")) then
                hasAward = true
                if string.find(award, "W2") or string.find(award, "W1") then
                    PlaySound("evaluation perfect full combo")
                else
                    PlaySound("evaluation full combo")
                end
                break
            end

            local grade = Grades[pn]
            if grade then
                for _, gradeTier in ipairs(gradeOrder) do
                    if grade == gradeTier then
                        if not highestGrade or table.find(gradeOrder, grade) < table.find(gradeOrder, highestGrade) then
                            highestGrade = grade
                        end
                        break
                    end
                end
            end
        end

        if not hasAward and highestGrade then
            local gradeSounds = {
                Grade_Tier01 = "evaluation aaa ac",
                Grade_Tier02 = "evaluation aaa ac",
                Grade_Tier03 = "evaluation aa+ ac",
                Grade_Tier04 = "evaluation aa ac",
                Grade_Tier05 = "evaluation aa- ac",
                Grade_Tier06 = "evaluation a+ ac",
                Grade_Tier07 = "evaluation a ac",
                Grade_Tier08 = "evaluation a- ac",
                Grade_Tier09 = "evaluation b+ ac",
                Grade_Tier10 = "evaluation b ac",
                Grade_Tier11 = "evaluation b- ac",
                Grade_Tier12 = "evaluation c+ ac",
                Grade_Tier13 = "evaluation c ac",
                Grade_Tier14 = "evaluation c- ac",
                Grade_Tier15 = "evaluation d+ ac",
                Grade_Tier16 = "evaluation d ac",
                Grade_Tier17 = "evaluation failed ac",
                Grade_Failed = "evaluation failed ac"
            }

            local soundToPlay = gradeSounds[highestGrade]
            if soundToPlay then
                PlaySound(soundToPlay)
            end
        end
    end;
}

return t
