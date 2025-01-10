return Def.Quad {
    InitCommand=function(s)
        s:diffuse(Color.White):FullScreen():diffusealpha(1)
    end;
    OnCommand=function(s)
        s:linear(0.5):diffusealpha(0)
    end;
}