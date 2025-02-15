local grades = {
    { "AAA", 990000, "Grade_Tier02" },
    { "AA+", 950000, "Grade_Tier03" },
    { "AA", 900000, "Grade_Tier04" },
    { "AA-", 890000, "Grade_Tier05" },
    { "A+", 850000, "Grade_Tier06" },
    { "A", 800000, "Grade_Tier07" },
    { "A-", 790000, "Grade_Tier08" },
    { "B+", 750000, "Grade_Tier09" },
    { "B", 700000, "Grade_Tier10" },
    { "B-", 690000, "Grade_Tier11" },
    { "C+", 650000, "Grade_Tier12" },
    { "C", 600000, "Grade_Tier13" },
    { "C-", 590000, "Grade_Tier14" },
    { "D+", 550000, "Grade_Tier15" },
    { "D", 0, "Grade_Tier16" },
}

function GetGrade(pss, hs)
    local score = pss and pss:GetScore() or hs:GetScore()

    if pss and pss:GetFailed() or (not pss and hs:GetGrade() == "Grade_Failed") then
        return "Grade_Failed"
    end

    if pss and pss:GetScore() >= 990000 and HasEarnedArcadeExtraStage() then
        return "Grade_Tier01" -- AAA (extra stage)
    end

    if score == 0 then
        return "Grade_Tier17"
    end

    for _, grade in ipairs(grades) do
        if score >= grade[2] then
            return grade[3]
        end
    end
end
