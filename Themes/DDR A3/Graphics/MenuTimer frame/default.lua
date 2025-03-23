local times = {
	ScreenSelectMusic = 90,
	ScreenSelectLanguage = 20,
	ScreenSelectStyle = 20,
	ScreenSelectProfile = 20,
	ScreenEvaluationNormal = 20,
	ScreenEvaluationSummary = 20,
	ScreenDataSaveSummary = 20,
}

t = Def.ActorFrame{}
local screen = nil

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:sleep(0.1):queuecommand("FindScreen")
	end,
	FindScreenCommand=function(self)
		if not SCREENMAN:GetTopScreen() then
			lua.ReportScriptError("Didn't find a valid screen, where are you?")
		else
			screen = SCREENMAN:GetTopScreen():GetName()
		end
		self:queuecommand("StartTicking")
	end,
	StartTickingCommand=function(self)
		local time = times[screen]
		if not GAMESTATE:IsEventMode() and time then
			self:SetUpdateFunction(function(self, delta)
				if time >= 0 then
					time = time - delta
					if time <= 10 then
						self:queuemessage("LowTime")
					end
				end
			end)
		end
	end
}

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:x(4.5);
		self:y(18);
		self:zoom(0.627)
	end;
	LowTimeMessageCommand=function(self)
		self:diffuse(Color.Red)
	end;
	LoadActor(Model().."base")..{
		OffCommand=cmd(linear,0.25;diffusealpha,0);
	};
	LoadActor(Model().."line")..{
		InitCommand=function(s) s:xy(2,-1) end,
		OnCommand=cmd(playcommand,"Animate");
		AnimateCommand=function(s)
			if GAMESTATE:IsEventMode() then
				s:visible(false)
			else
				s:visible(true)
			end
			s:zoom(0.75):diffusealpha(1):linear(0.2):zoom(1):diffusealpha(1):linear(0.2):diffusealpha(0):sleep(0.6):queuecommand("Animate");
		end,
		OffCommand=cmd(stoptweening,linear,0.25;zoom,1.15;diffusealpha,0);
	};
}

return t;