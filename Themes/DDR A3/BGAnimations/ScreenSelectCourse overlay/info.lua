return Def.ActorFrame{
	InitCommand=cmd(xy,_screen.cx,_screen.cy-274);
	CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	Def.ActorFrame{
		InitCommand=cmd(xy,-90,-7);
		LoadActor(THEME:GetPathB("ScreenSelectMusic","Overlay/Info/"..Model().."info"))..{ 
			InitCommand=function(s) s:x(12):y(23) end, 
		};
		LoadFont("_swis721 blk bt 28px")..{
			InitCommand=cmd(xy,-235,-1;zoom,0.8;halign,0;maxwidth,560;diffuse,color("White"));
			SetCommand=function(s) 
				s:settext(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle()) 
			end,
		};
	};
	Def.ActorFrame{
		InitCommand=cmd(xy,-20,44);
		LoadActor(THEME:GetPathB("ScreenSelectMusic","Overlay/Info/BPM"))..{ InitCommand=function(s) s:xy(91,9):zoom(1) end, };
		Def.Sprite{
			Texture=THEME:GetPathB("ScreenSelectMusic","Overlay/Info/_meter 2x2.png");
			InitCommand=cmd(xy,64,16;effectclock,'beatnooffset';SetAllStateDelays,1;zoomx,1.5;skewx,-0.25);
		};
		Def.BitmapText{
			Font="_dfghsgothic-w9 20px";
			InitCommand=cmd(zoomy,0.9;zoomx,0.8;xy,105,0);
			SetCommand = function(self)
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber());
			
				if trail then
					local lowestBPM, highestBPM;
					lowestBPM = math.huge; -- Start with a very high number for lowest BPM
					highestBPM = 0;        -- Start with 0 for highest BPM
					local spaces;
					
			
					-- Iterate through all songs in the trail
					for _, entry in ipairs(trail:GetTrailEntries()) do
						local song = entry:GetSong();
						if song then
							local bpmtext = song:GetDisplayBpms();
							if bpmtext[1] and bpmtext[2] then
								lowestBPM = math.min(lowestBPM, bpmtext[1]);
								highestBPM = math.max(highestBPM, bpmtext[2]);
								if #tostring(lowestBPM) == 2 then
									spaces = "   "
									self:x(112);
								else
									spaces = "  "
									self:x(109);
								end
							end
						end
					end
			
					if lowestBPM ~= math.huge and highestBPM ~= 0 then
						local bpmtext;
						if lowestBPM == highestBPM then
							bpmtext = round(lowestBPM);
							self:x(120);
						else
							bpmtext = string.format(spaces.."%d\n~%3d", round(lowestBPM, 0), round(highestBPM, 0));
							self:x(112);
						end
						self:horizalign(left);
						self:vertalign(top);
						self:settext(bpmtext);
						self:visible(true);
					else
						self:visible(false);
					end
				else
					self:visible(false);
				end
			end,
			SetSecretCommand=function(s)
				if not GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber()):IsSecret() then return end
				if secretNumber == nil then
					secretNumber = 0
				end
				secretNumber = secretNumber + 1
				secretNumber = secretNumber % 10
				s:settextf("%d%d%d", secretNumber, secretNumber, secretNumber)
			end,
			CurrentCourseChangedMessageCommand = function(s) s:queuecommand("Set") end,
			ChangedLanguageDisplayMessageCommand = function(s) s:queuecommand("Set") end,
		};
	};
};