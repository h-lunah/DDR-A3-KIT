

--ReadPaneControl
function ReadOrCreatePaneControlForPlayerSide(PlayerUID)
	return "ClosePanes"
end


function ReadOrCreatePaneControlForAnotherSide(PlayerUID)
	return "ClosePanes"
end

----------------------------------------------------------------------------

local NoPane = Def.ActorFrame{};

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	NoPane[#NoPane+1] = loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/TargetScore/NoPane/default.lua"))(pn)..{
		InitCommand=function(s)
			s:xy(pn==PLAYER_1 and SCREEN_LEFT+73 or SCREEN_RIGHT-73,_screen.cy+167):zoom(0.533) end,
		OnCommand=function(s)
			if GAMESTATE:IsPlayerEnabled(pn) then
				local PlayerUID = PROFILEMAN:GetProfile(pn):GetGUID();
				if ReadOrCreatePaneControlForPlayerSide(PlayerUID)=="ClosePanes" then
					s:addx(pn==PLAYER_1 and -500 or 500):sleep(0.5):decelerate(0.5):addx(pn==PLAYER_1 and 500 or -500)
					s:linear(0.5);
					s:diffusealpha(1);
				elseif ReadOrCreatePaneControlForPlayerSide(PlayerUID)=="OpenPanes1" or ReadOrCreatePaneControlForPlayerSide(PlayerUID)=="OpenPanes3" then
					s:diffusealpha(0);
				end;
			end;
		end,
		CodeMessageCommand=function(self,params)
			local player = params.PlayerNumber
			if player == pn then
				if params.Name=="ChangeStyle" then
					style = GAMESTATE:GetCurrentStyle():GetName()
					course = GAMESTATE:GetCurrentCourse()

					if not course or IsSelecting then
						SCREENMAN:PlayInvalidSound()
					return end

					if style == "single" and course:IsPlayableIn("StepsType_Dance_Double") then
						SOUND:PlayOnce(THEME:GetPathS("ScreenSelectMusic", "difficulty harder"))
						GAMESTATE:SetCurrentStyle("double")
						for _, trail in pairs(course:GetAllTrails()) do
							if trail:GetStepsType() == "StepsType_Dance_Double" then
								GAMESTATE:SetCurrentTrail(pn, trail)
								break
							end
						end
						SOUND:PlayAnnouncer("style double")
					elseif style == "double" and course:IsPlayableIn("StepsType_Dance_Single") then
						SOUND:PlayOnce(THEME:GetPathS("ScreenSelectMusic", "difficulty harder"))
						GAMESTATE:SetCurrentStyle("single")
						for _, trail in pairs(course:GetAllTrails()) do
							if trail:GetStepsType() == "StepsType_Dance_Single" then
								GAMESTATE:SetCurrentTrail(pn, trail)
								break
							end
						end
						SOUND:PlayAnnouncer("style single")
					else
						SCREENMAN:PlayInvalidSound()
					end
				end;
			end
		end,
	};
end

return Def.ActorFrame{
	OffCommand=function(s) s:finishtweening() end,
	NoPane;
}