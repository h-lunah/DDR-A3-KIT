return Def.Quad {
    InitCommand=function(s)
        s:diffuse(Color.White):FullScreen():diffusealpha(0)
    end;
    OnCommand=function(s)
        s:linear(1):diffusealpha(1)
    end;
}