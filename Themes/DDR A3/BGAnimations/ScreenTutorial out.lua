return Def.ActorFrame{
    OnCommand=function(self)
        lua.ReportScriptError("Screen ended!")
    end,
}