local pn = PLAYER_1

return Def.Sprite{
    InitCommand = function(s)
        s:Load(THEME:GetPathG("", "_blank"))
        s:xy(300,145)
        s:zoom(0.6)
    end;
    
    OnCommand = function(s)
        local gauge = GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):DrainSetting()
        local loadPath = nil

        if gauge == "DrainType_FloatingFlare" then
            loadPath = (flareData[pn].currentFlare < 9) 
                and ("scre_flare_level_" .. (flareData[pn].currentFlare + 1)) 
                or "scre_flare_level_ex"
        else
            -- Lookup table for DrainType_Flare mappings
            local flareLevels = {
                DrainType_Flare1 = "scre_flare_level_1",
                DrainType_Flare2 = "scre_flare_level_2",
                DrainType_Flare3 = "scre_flare_level_3",
                DrainType_Flare4 = "scre_flare_level_4",
                DrainType_Flare5 = "scre_flare_level_5",
                DrainType_Flare6 = "scre_flare_level_6",
                DrainType_Flare7 = "scre_flare_level_7",
                DrainType_Flare8 = "scre_flare_level_8",
                DrainType_Flare9 = "scre_flare_level_9",
                DrainType_FlareEX = "scre_flare_level_ex",
            }

            loadPath = flareLevels[gauge]
        end

        -- Load the sprite only if loadPath is set
        if loadPath then
            s:Load(THEME:GetPathB("ScreenEvaluation","decorations/flare/"..loadPath))
        end
    end;

    OffCommand=function(s)
        s:linear(0.1)
        s:diffusealpha(0)
    end;
}
