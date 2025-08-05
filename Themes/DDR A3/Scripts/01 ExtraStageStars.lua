-- 01 ExtraStageStars.lua
-- Recreate the extra stage conditions of arcade versions of DDR (DDR A and newer).

ExtraStageStars = 0
StarsAddedRecently = 0
StarsActuallyAdded = 0

-- How many Extra Stage stars do we have?
function GetExtraStageStars()
    return ExtraStageStars
end

-- How many Extra Stage stars we got this stage?
function GetRecentExtraStageStars()
    return StarsAddedRecently
end

-- Did we get a full combo?
local function IsFullCombo(pn)
    return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):FullComboOfScore("TapNoteScore_W4")
end

-- Are we using a LIFE4 or RISKY bar? These bars are strict.
local function IsRiskyOrLife4(pn)
    local options = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred")
    return table.search(options, '4Lives') or table.search(options, '1Lives')
end

-- Are we in the Final Stage?
local function IsFinalStage()
    return STATSMAN:GetCurStageStats():GetStage() == "Stage_Final"
end

-- Are Extra Stages enabled?
local function IsExtraStageEnabled()
    return PREFSMAN:GetPreference("AllowExtraStage")
end

-- Are we in Event Mode?
local function IsEventMode()
    return GAMESTATE:IsEventMode()
end

-- Are we in an Extra Stage?
local function IsExtraStage()
    -- You cannot play an Encore Extra Stage, but we account for it either way.
    return GAMESTATE:IsExtraStage()
end

local function DidPassSong(rank)
    return rank <= "Grade_Tier16"
end

-- Grant Extra Stage stars.
-- If we got 9 stars, an extra stage will be unlocked.
function AddExtraStageStars(rank, pn)
    -- Extra Stage is turned off in Event Mode
    if IsEventMode() then return end

    -- We cannot grant Extra Stage stars in an Extra Stage.
    if IsExtraStage() then return end

    -- Don't grant stars if the player failed
    if not DidPassSong(rank) then return 0 end

    local starsToAdd = 0

    -- AAA
    -- Tier01 is reserved for gatekeeping from obtaining an Extra Stage if we did not get enough stars.
    if rank == "Grade_Tier02" then
        starsToAdd = 3
    -- AA
    elseif rank == "Grade_Tier03" or rank == "Grade_Tier04" or rank == "Grade_Tier05" then
        starsToAdd = 2
    -- A
    elseif rank >= "Grade_Tier06" then
        starsToAdd = 1
    end

	-- Did the player full combo the song?
    if IsFullCombo(pn) then
        starsToAdd = starsToAdd + 1
    end

    -- Is the player playing on LIFE4 or RISKY?
    if IsRiskyOrLife4(pn) then
        starsToAdd = starsToAdd + 1
    end

    -- You cannot add more than 3 stars per stage.
   	starsToAdd = math.min(starsToAdd, 3)

    -- This value is saved so we know how many stars we got for this stage.
    StarsAddedRecently = starsToAdd

    -- Ensure we don't exceed 9 stars if the adding would result in >=10 stars.
    starsToAdd = math.min(starsToAdd, 9 - ExtraStageStars)

    ExtraStageStars = math.min(ExtraStageStars + starsToAdd, 9)

    StarsActuallyAdded = starsToAdd

    -- Make sure the Extra Stage is unlocked if you met the Extra Stage requirements.
    -- The necessary logic uses an impossible rank in the theme metrics.
    THEME:ReloadMetrics()

    return starsToAdd
end

-- Determine if we can enter the Extra Stage.
-- We do not want an Extra Stage to begin with <9 stars.
function HasEarnedArcadeExtraStage()
    if ExtraStageStars == 9 and IsFinalStage() and IsExtraStageEnabled() and not IsEventMode() then
        return "Grade_Tier16"
    else
        return "Grade_Tier01"
    end
end
