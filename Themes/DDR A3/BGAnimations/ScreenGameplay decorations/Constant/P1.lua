InitialOptions = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptionsString("ModsLevel_Preferred")

function calculate_offset(bpm, bpm_min, bpm_max, offset_min, offset_max)
    -- Clamp the BPM to the valid range
    if bpm < bpm_min then bpm = bpm_min end
    if bpm > bpm_max then bpm = bpm_max end

    -- Imagine playing CURUS on CONSTANT without this. You would have a hard time. (184-188)
    local bpm_threshold = bpm_max / 2
    if math.abs(bpm_max - bpm_min) <= bpm_threshold then return 200 end

    -- Calculate the slope for linear interpolation
    local slope = (offset_max - offset_min) / (bpm_max - bpm_min)

    -- Calculate the offset and floor the result
    return math.floor(offset_min + slope * (bpm - bpm_min))
end

-- Apply CONSTANT sudden mode like in DDR WORLD
local function UpdateConstantMod()
    -- 100% SuddenOffset is the default CONSTANT value.
    if not string.find(InitialOptions, "SuddenOffset") then return end

    -- Get song and timing details
    local currentSong = GAMESTATE:GetCurrentSong()
    if not currentSong then return end

    local timingData = currentSong:GetTimingData()
    local currentBeat = GAMESTATE:GetSongBeat()

    -- Retrieve BPM information
    local displayBpms = currentSong:GetDisplayBpms()

    -- Calculate current BPM
    local currentBPM = timingData:GetBPMAtBeat(currentBeat)

    -- Don't divide by zero
    if currentBPM == 0 then return end

    -- Compute SuddenOffset as a percentage of base BPM
    local constantOffset = calculate_offset(currentBPM, displayBpms[1], displayBpms[2], -33, 200)

    -- Apply the dynamic modifier
    local playerState = GAMESTATE:GetPlayerState(PLAYER_1)
    local currentOptions = playerState:GetPlayerOptionsString("ModsLevel_Song")

    -- Avoid redundant replacements
    if not string.find(currentOptions, "Sudden," .. constantOffset .. "%% SuddenOffset") then
        -- Resolve Flare conflict dynamically
        local OptionsP1P = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptionsString('ModsLevel_Preferred')
        local flareModifiers = {
            Flare1 = ",bar,flare-1,failimmediate",
            Flare2 = ",bar,flare-2,failimmediate",
            Flare3 = ",bar,flare-3,failimmediate",
            Flare4 = ",bar,flare-4,failimmediate",
            Flare5 = ",bar,flare-5,failimmediate",
            Flare6 = ",bar,flare-6,failimmediate",
            Flare7 = ",bar,flare-7,failimmediate",
            Flare8 = ",bar,flare-8,failimmediate",
            Flare9 = ",bar,flare-9,failimmediate",
            FlareEX = ",bar,flare-ex,failimmediate",
            FloatingFlare = ",bar,floating-flare,failimmediate",
        }

        local flareModifier = ""
        for key, value in pairs(flareModifiers) do
            if string.find(OptionsP1P, key) then
                flareModifier = value
                break
            end
        end

        currentOptions = currentOptions:gsub("Stealth,", "")
        currentOptions = currentOptions:gsub("Hidden,", "")

        -- Apply updated options
        playerState:SetPlayerOptions("ModsLevel_Song", currentOptions .. ",Sudden," .. constantOffset .. "% SuddenOffset" .. flareModifier)
    end
end

return Def.ActorFrame{
    OnCommand=function(s)
        s:queuecommand("ApplyConstant")
    end,
    ApplyConstantCommand=function(s)
        s:sleep(1 / 60)
        UpdateConstantMod()
        s:queuecommand("On")
    end
}