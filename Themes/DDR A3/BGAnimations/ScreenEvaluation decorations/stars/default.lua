local positions = {-50, -25, 1}

t = Def.ActorFrame{
	Condition=not GAMESTATE:IsEventMode() and not GAMESTATE:IsCourseMode();
}

t[#t+1]	= LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/stars/"..Model().."base"))..{
	InitCommand=function(s) s:xy(-2.16,1) end,
};

for i=1,GetRecentExtraStageStars() do
	t[#t+1]	= Def.ActorFrame{
		LoadActor(THEME:GetPathG("", "_shared/stars/star")) ..{
			InitCommand=function(s)
				s:diffusealpha(1)
				s:xy(positions[i],0) 
			end,
		};
		LoadActor(THEME:GetPathG("", "_shared/stars/star"))..{
			InitCommand=function(s) 
			s:blend(Blend.Add):diffusealpha(0):linear(0.01):smooth(0.3):diffusealpha(1)
				s:diffuseramp():effectcolor1(color("1,1,1,0")):effectcolor2(color("1,1,1,1")):effectperiod(0.70)
				s:xy(positions[i],0) 
			end,
		};
	}
end

return t;
