t = Def.ActorFrame {}

local cornerPositions = {
    {SCREEN_LEFT, SCREEN_TOP},
    {SCREEN_RIGHT, SCREEN_TOP},
    {SCREEN_LEFT, SCREEN_BOTTOM},
    {SCREEN_RIGHT, SCREEN_BOTTOM}
}

local shiftVals = {
    {420, 250},
    {-420, 250},
    {420,-250},
    {-420,-250}
}

local globalSleep = 2

-- Sound effect
t[#t+1] = Def.Actor{
    InitCommand=function(self)
        self:sleep(globalSleep)
        self:queuecommand("PlaySound")
    end,
    PlaySoundCommand=function(self)
        if STATSMAN:GetCurStageStats():AllFailed() then
            SOUND:PlayOnce(THEME:GetPathS("", "DanResult failed"))
        else
            SOUND:PlayOnce(THEME:GetPathS("", "DanResult cleared"))
        end
    end,
}

-- Pass/Fail up top of screen
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathB("","ScreenEvaluation decorations/DanResult/scre_grade_light01"),
    InitCommand=function(self)
        self:diffusealpha(0)
        self:sleep(globalSleep)
        self:diffusealpha(1)
        if STATSMAN:GetCurStageStats():AllFailed() then
            self:zoomto(900,200)
        else
            self:zoomto(500,200)
        end
        self:xy(SCREEN_CENTER_X, SCREEN_TOP+65)
        self:diffusealpha(0)
        self:sleep(3)
        self:diffusealpha(0.5)
        self:effectcolor1(color("#000000"))
        self:effectcolor2(color("#ffffff"))
        self:blend("BlendMode_Add")
        self:diffuseshift()
        self:effectperiod(3)
    end,
    OffCommand=function(self)
        self:linear(0.2)
        self:diffusealpha(0)
    end,
}

t[#t+1] = Def.Sprite{
    InitCommand=function(self)
        self:diffusealpha(0)
        self:sleep(globalSleep)
        self:diffusealpha(1)
        if STATSMAN:GetCurStageStats():AllFailed() then
            self:Load(THEME:GetPathB("","ScreenEvaluation decorations/DanResult/scre_grade_failed_m"))
        else
            self:Load(THEME:GetPathB("","ScreenEvaluation decorations/DanResult/scre_grade_cleared_m"))
        end
        self:xy(SCREEN_CENTER_X, SCREEN_TOP+65)
        self:zoom(0.75)
        self:diffusealpha(0)
        self:sleep(3)
        self:diffusealpha(1)
        self:zoomy(0)
        self:linear(0.1)
        self:zoomy(0.75)
    end,
    OffCommand=function(self)
        self:linear(0.2)
        self:diffusealpha(0)
    end,
}

-- Full screen reveal
t[#t+1] = Def.Quad{
    InitCommand=function(self)
        self:diffusealpha(0)
        self:sleep(globalSleep)
        self:diffusealpha(0.66)
        self:FullScreen()
        self:diffuse(color("#000000"))
        self:diffusealpha(0.66)
        self:sleep(3)
        self:linear(0.5)
        self:diffusealpha(0)
    end
}

for i=1,4,1 do 
    t[#t+1] = Def.Sprite{
        Texture=THEME:GetPathB("","ScreenEvaluation decorations/DanResult/scre_grade_light01"),
        InitCommand=function(self)
            self:diffusealpha(0)
            self:sleep(globalSleep)
            self:diffusealpha(1)
            self:xy(unpack(cornerPositions[i]));
            self:zoom(0.5);
            self:linear(0.75)
            self:addx(shiftVals[i][1])
            self:addy(shiftVals[i][2])
            self:sleep(0.01)
            self:diffusealpha(0)
        end,
    }
end

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathB("","ScreenEvaluation decorations/DanResult/scre_grade_light02"),
    InitCommand=function(self)
        self:diffusealpha(0)
        self:sleep(globalSleep)
        self:diffusealpha(1)
        self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
        self:zoom(0.5)
        self:zoomx(0.3) 
        self:diffusealpha(0)
        self:sleep(0.75)
        self:linear(0.5)
        self:diffusealpha(1)
        self:zoomx(0.5)
        self:linear(2)
        self:zoomx(0.7)
        self:diffusealpha(0)
    end
}

t[#t+1] = Def.Sprite{
    InitCommand=function(self)
        self:diffusealpha(0)
        self:sleep(globalSleep)
        self:diffusealpha(1)
        if STATSMAN:GetCurStageStats():AllFailed() then
            self:Load(THEME:GetPathB("","ScreenEvaluation decorations/DanResult/scre_grade_failed_base"))
        else
            self:Load(THEME:GetPathB("","ScreenEvaluation decorations/DanResult/scre_grade_cleared_base"))
        end
        self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
        self:zoom(0.5)
        self:diffusealpha(0)
        self:sleep(0.75)
        self:diffusealpha(1)
        self:linear(2)
        self:zoom(0.55)
        self:linear(0.2)
        self:zoom(1)
        self:diffusealpha(0)
    end
}

t[#t+1] = Def.Sprite{
    InitCommand=function(self)
        self:diffusealpha(0)
        self:sleep(globalSleep)
        self:diffusealpha(1)
        if STATSMAN:GetCurStageStats():AllFailed() then
            self:Load(THEME:GetPathB("","ScreenEvaluation decorations/DanResult/scre_grade_failed_base"))
        else
            self:Load(THEME:GetPathB("","ScreenEvaluation decorations/DanResult/scre_grade_cleared_base"))
        end
        self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
        self:zoom(0.5)
        self:diffusealpha(0)
        self:sleep(0.75)
        self:diffusealpha(1)
        self:linear(0.5)
        self:zoom(0.66)
        self:diffusealpha(0)
    end
}

return t;