local grade = Def.ActorFrame{};
local cleared = Def.ActorFrame{};
local cursor = Def.ActorFrame{};
local diff = Def.ActorFrame{};

cleared[#cleared+1] = Def.ActorFrame{
	Name="Clear Bases",
	Def.Sprite{
		Texture=THEME:GetPathG("MusicWheelItem Song","NormalPart/cleared"),
		InitCommand=function(s) s:xy(-320,-18):zoomy(1.2) end,
	};
};

cleared[#cleared+1] = Def.ActorFrame{
	Name="Clear Bases",
	Def.Sprite{
		Texture=THEME:GetPathG("MusicWheelItem Song","NormalPart/cleared"),
		InitCommand=function(s) s:xy(320,-18):zoomy(1.2) end,
	};
};

for i,pn in pairs(GAMESTATE:GetEnabledPlayers()) do 
	diff[#diff+1] = loadfile(THEME:GetPathG("MusicWheelItem","Course NormalPart/diff.lua"))(pn)..{
		InitCommand=function(s) s:xy(pn == PLAYER_1 and -335 or 335,-90) end,
	};

	cleared[#cleared+1] = loadfile(THEME:GetPathG("MusicWheelItem","Course NormalPart/grade.lua"))(pn)..{
		InitCommand=function(s) s:xy(pn == PLAYER_1 and -37 or 44,-17):zoomtoheight(1.35) end,
		OnCommand=function(s)
			if #GAMESTATE:GetEnabledPlayers() == 1 then
				s:zoomtowidth(1.145)
				s:addx(39)
			end
		end
	};
end

return Def.ActorFrame{
	SetMessageCommand=function(self, params)
		if params.Index ~= nil then
			self:zoom( params.HasFocus and 1.15 or 1);
		end
	end;
	OnCommand=function(self)
		self:diffusealpha(0):sleep(0.3):linear(0.05):diffusealpha(0.75):linear(0.1):diffusealpha(0.25):linear(0.1):diffusealpha(1)
	end;
	OffCommand=function(self)
		self:diffusealpha(0)
	end;
	Def.Banner {
		Name="SongBanner";
		InitCommand=function(s) s:xy(-3,-23):scaletoclipped(620,132) end,
		SetMessageCommand=function(self,params)
			if params.Type == "Course" then
				self:LoadFromCourse(params.Course);
			end
		end;
	};
	Def.Sprite{
		Texture=Model().."card",
		InitCommand=function(s,p) s:zoom(1.15) end,
	};
	Def.ActorFrame{
		Name="Highlights",
		SetMessageCommand=function(self, params)
			if params.Index ~= nil then
				self:visible( params.HasFocus );
			end
		end;
		Def.Sprite{
			Texture="thick_high",
			InitCommand=function(s) s:zoom(1.15)
				s:diffuseramp():effectcolor1(color("1,1,1,0.2")):effectcolor2(color("1,1,1,1")):effectperiod(0.5)
			end,
		};
		Def.ActorFrame{
			InitCommand=function(s) s:diffuseramp():effectcolor1(color("1,1,1,0")):effectcolor2(color("1,1,1,1")):effectperiod(0.5) end,
			Def.Sprite{
				Texture="high",
				InitCommand=function(s) s:zoom(1.15)
					s:thump(1):effectmagnitude(1.1,1,0):effectperiod(0.5) 
				end,
			};
		};
	};
	Def.BitmapText{
		Font="_wheelnames 28px",
		InitCommand=function(s) s:y(71):zoom(0.6):maxwidth(260) end,
		SetMessageCommand=function(s,params)
			local course = params.Course
			if course then
				s:settext(course:GetDisplayFullTitle())
				s:strokecolor(color("0.15,0.15,0.0,0.9"))
			end
		end,
	};
	cleared;
	grade;
	diff;
	cursor;
};
