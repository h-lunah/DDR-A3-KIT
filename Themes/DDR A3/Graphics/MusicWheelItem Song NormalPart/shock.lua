local pn = ...
local t = Def.ActorFrame{}

t[#t+1] = Def.ActorFrame{
    LoadActor(THEME:GetPathB("ScreenSelectMusic", "overlay/ShockArrows/shock")),
    LoadActor(THEME:GetPathB("ScreenSelectMusic", "overlay/ShockArrows/effect"))..{
        InitCommand=function(s)
            s:diffuseshift()
            s:effectcolor1(color("1,1,1,1")):effectcolor2(color("1,1,1,0.8"))
            s:effectperiod(0.2)
        end,
    },
    InitCommand=function(self)
        self:visible(false) end,
    SetCommand=function(self, param)
        if GAMESTATE:IsCourseMode() then 
            return end

        local steps = GAMESTATE:GetCurrentSteps(pn)
        local mines = 0
        
        if steps then
            mines = steps:GetRadarValues(pn):GetValue("RadarCategory_Mines")
        end

        if param.Song == GAMESTATE:GetCurrentSong() then
            self:visible(mines > 0)
        end 
    end,
    CurrentStepsP1ChangedMessageCommand=function(self)
        self:queuecommand("Set") end,
    CurrentStepsP2ChangedMessageCommand=function(self)
        self:queuecommand("Set") end,
    CurrentSongChangedMessageCommand=function(self)
        self:queuecommand("Set") end,
}

return t;
