local AnimationSleep = 1.35

local loader
local failed = EveryoneFailed

if IsGoldenLeague() then
    loader = "GoldenLeague"
else
    loader = "Normal"
end

return Def.ActorFrame{
    -- Actor to handle the failed state updates
    Def.Actor{
        OffCommand=function(s)
            s:sleep(0.1)
            s:queuecommand("UpdateFailedState")
        end,
        UpdateFailedStateCommand=function(s)
            -- Check the failed state
            failed = EveryoneFailed

            if failed == true then
				lua.ReportScriptError("You failed!")
                s:GetParent():GetChild("MessageSprite1"):Load(THEME:GetPathG("", "_shared/message/RED"))
                s:GetParent():GetChild("MessageSprite2"):Load(THEME:GetPathG("", "_shared/message/FAILED"))
                s:GetParent():GetChild("MessageSprite3"):Load(THEME:GetPathG("", "_shared/message/FAILED"))
            else
				s:queuecommand("On")
            end
        end
    };

    -- Sound effects for door closing
    Def.ActorFrame{
        StartTransitioningCommand=function(s) s:sleep(AnimationSleep+0.035):queuecommand("Play") end,
        PlayCommand=function(s) 
            local sound = THEME:GetPathS("", "DoorClose")
            SOUND:PlayOnce(StreamingSound(sound)) 
        end,
    };

    -- Announcer sounds for stage cleared or failed
    Def.ActorFrame{
        StartTransitioningCommand=function(s) s:sleep(AnimationSleep+0.035):queuecommand("Play") end,
        PlayCommand=function(s) 
            if failed == false then
                SOUND:PlayAnnouncer("cheering normal ac")
                SOUND:PlayAnnouncer("stage cleared")
            end
        end,
    };

    -- Load the appropriate loader (GoldenLeague or Normal)
    LoadActor(loader);

    -- Quad for timing purposes
    Def.Quad{
        InitCommand=function(s) s:diffusealpha(0) end,
        OnCommand=function(s) s:sleep(AnimationSleep+2.3) end,
    };

    -- Message sprites
    Def.Sprite{
        Name="MessageSprite1",
        Texture=THEME:GetPathG("", failed == false and "_shared/message/BLUE" or "_shared/message/RED"),
        InitCommand=function(s) s:Center():blend(('BlendMode_Add')) end,
        OnCommand=function(s) 
            s:diffusealpha(0):zoom(1)
            s:sleep(AnimationSleep+0.035):linear(0.264):diffusealpha(1):zoom(0.667)
        end,
    };
    Def.Sprite{
        Name="MessageSprite2",
        Texture=THEME:GetPathG("", failed == false and "_shared/message/"..ClearedToLoad() or "_shared/message/FAILED"),
        InitCommand=function(s) s:diffusealpha(0):Center() end,
        OnCommand=function(s) 
            s:sleep(AnimationSleep+0.035):diffusealpha(1):zoom(0)
            s:linear(0.1):zoom(0.418)
            s:linear(0.1):diffusealpha(1):zoomx(0.62):zoomy(0.64)
            s:linear(0.1):diffusealpha(1):zoomx(0.69):zoomy(0.71)
            s:linear(0.1):zoom(0.667)
        end,
    };
    Def.Sprite{
        Name="MessageSprite3",
        Texture=THEME:GetPathG("", failed == false and "_shared/message/"..ClearedToLoad() or "_shared/message/FAILED"),
        InitCommand=function(s) s:diffusealpha(0):Center() end,
        OnCommand=function(s) 
            s:sleep(AnimationSleep+0.035):diffusealpha(0):zoom(0)
            s:linear(0.1):zoom(1.2)
            s:linear(0.1):diffusealpha(0.5):zoomx(0.62):zoomy(0.64)
            s:linear(0.1):diffusealpha(0.5):zoomx(0.72):zoomy(0.74)
            s:linear(0.1):diffusealpha(0):zoom(0.92)
        end,
    };
};