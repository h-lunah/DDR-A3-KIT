PressedStart = false

local function GetInput(event)
    if event.type == "InputEventType_Release" then return end

    if event.GameButton == "Start" then
        PressedStart = true
    end
end

t = Def.ActorFrame {
    OnCommand=function(s) 
        SCREENMAN:GetTopScreen():AddInputCallback(GetInput)
    end;
}

t[#t+1] = Def.Quad {
    InitCommand=function(s) s:FullScreen():diffusealpha(0) end,
    OffCommand=function(s) 
        if PressedStart then return end
        s:linear(0.15):diffusealpha(1) end,
}


t[#t+1] = Def.ActorFrame {
    LoadActor("_doors close muted")..{
        OffCommand=function(s)
            if not PressedStart then
                s:visible(false)
            else
                SOUND:PlayOnce(THEME:GetPathS("","DoorClose"))
            end
        end;
    }
}

return t;