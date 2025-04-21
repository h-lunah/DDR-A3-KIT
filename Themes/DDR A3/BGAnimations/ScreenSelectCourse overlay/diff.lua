local pn = ...
local yspacing = 39
local DiffList = Def.ActorFrame{};

function CalculateHardestDifficulty(course, difficulty)
    if not course then return '' end
    
    local hardestDifficulty = -1  -- Initialize to a value lower than any possible difficulty
    -- Get the course entries (songs and steps)
    local entries = course:GetAllTrails()

    -- Iterate through each entry
    for _, entry in ipairs(entries) do
        if entry:GetDifficulty() == difficulty and entry:GetStepsType() == GAMESTATE:GetCurrentStyle():GetStepsType() then
            hardestDifficulty = entry:GetMeter()
        end
    end

    if hardestDifficulty == -1 then return '' end  -- No matching difficulties found

    return hardestDifficulty
end

local difficulties = {"Difficulty_Beginner", "Difficulty_Easy", "Difficulty_Medium", "Difficulty_Hard", "Difficulty_Challenge"}
for _, diff in ipairs(difficulties) do
    DiffList[#DiffList+1] = Def.ActorFrame{
        InitCommand=function(s)
            entry = Difficulty:Reverse()[diff]

            for j, difficulty_name in ipairs(difficulties) do
                if difficulty_name == diff then
                  entry = j
                end
            end

            s:xy(pn==PLAYER_1 and -3 or 3, (entry * yspacing) - 120)
        end,
        SetCommand=function(self)
            local st = GAMESTATE:GetCurrentStyle():GetStepsType()
            local song = GAMESTATE:GetCurrentCourse()
            local steps = GAMESTATE:GetCurrentTrail(pn)

            local all_trails = GAMESTATE:GetCurrentCourse():GetAllTrails()
            local available_difficulties = {}
            local exists = false

            for _, trail in ipairs(all_trails) do
                table.insert(available_difficulties, trail:GetDifficulty())
            end

            if song then
                for _, adiff in ipairs(available_difficulties) do
                    if adiff == diff then
                        exists = true
                        break
                    end
                end

                if exists then
                    self:visible(true)
                else
                    self:visible(false)
                end
            else
                self:visible(false)
            end
        end,
        Def.BitmapText{
            Font="_itc machine std 20px",
            InitCommand=function(self)
                self:halign(pn=='pnNumber_P2' and 1 or 0):draworder(99):diffuse(Color.White):maxwidth(150)
                self:x(-119)
                self:settext(THEME:GetString("CustomDifficulty", ToEnumShortString(diff)))
            end
        },
        Def.ActorFrame{
            InitCommand=function(s) s:x(pn==pn_2 and 26 or -26) end,
            Def.Quad{
                InitCommand=function(s) s:setsize(26, 25):diffuse(CustomDifficultyToColor(diff)) end
            },
            Def.BitmapText{
                Font="_helvetica-compressed 32px",
                Name="Meter",
                InitCommand=function(s)
                    s:draworder(99):strokecolor(Color.Black):zoom(0.75)
                    s:settext(CalculateHardestDifficulty(GAMESTATE:GetCurrentCourse(), diff))
                end,
                CurrentCourseChangedMessageCommand=function(s)
                    s:settext(CalculateHardestDifficulty(GAMESTATE:GetCurrentCourse(), diff))
                end
            },
            Def.BitmapText{
                Font="_geo 957 Bold",
                Name="Score",
                InitCommand=function(s)
                    s:draworder(5):diffuse(Color.White):xy(105, -1):zoom(1.1):halign(1):maxwidth(80):queuecommand("Set")
                end,
                SetCommand=function(self)
                    local course = GAMESTATE:GetCurrentCourse()

                    if course and diff then
                        if PROFILEMAN:IsPersistentProfile(pn) then
                            profile = PROFILEMAN:GetProfile(pn)
                        else
                            profile = PROFILEMAN:GetMachineProfile()
                        end

                        -- Find the trail that matches the current difficulty
                        local all_trails = course:GetAllTrails()
                        local trail = nil
                        for _, t in ipairs(all_trails) do
                            if t:GetDifficulty() == diff then
                                trail = t
                                break
                            end
                        end

                        if trail then
                            -- Fetch the high score list for the current course and trail
                            local scorelist = profile:GetHighScoreList(course, trail)
                            local scores = scorelist:GetHighScores()

                            -- Display the score if it exists
                            if scores[1] then
                                self:settext(commify(scores[1]:GetScore()))
                            else
                                self:settext("")  -- Hide the score if there's no score for this difficulty
                            end
                        else
                            self:settext("")  -- Hide the score if there's no trail for this difficulty
                        end
                    else
                        self:settext("")  -- Hide the score if there's no course or difficulty
                    end
                end
            },
            Def.ActorFrame{
                InitCommand=function(s) s:x(115):queuecommand("Set") end,
                Def.Sprite{
                    InitCommand=function(s) s:xy(27, 2) end,
                    SetCommand=function(self)
                        local course = GAMESTATE:GetCurrentCourse()

                        if course and diff then
                            if PROFILEMAN:IsPersistentProfile(pn) then
                                profile = PROFILEMAN:GetProfile(pn)
                            else
                                profile = PROFILEMAN:GetMachineProfile()
                            end

                            -- Find the trail that matches the current difficulty
                            local all_trails = course:GetAllTrails()
                            local trail = nil
                            for _, t in ipairs(all_trails) do
                                if t:GetDifficulty() == diff then
                                    trail = t
                                    break
                                end
                            end

                            if trail then
                                -- Fetch the high score list for the current course and trail
                                local scorelist = profile:GetHighScoreList(course, trail)
                                local scores = scorelist:GetHighScores()

                                if scores[1] then
                                    for _, topscore in ipairs(scores) do
                                        assert(topscore)
                                        local misses = topscore:GetTapNoteScore("TapNoteScore_Miss") +
                                            topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss") +
                                            topscore:GetHoldNoteScore("HoldNoteScore_LetGo") +
                                            topscore:GetTapNoteScore("TapNoteScore_HitMine")
                                        local goods = topscore:GetTapNoteScore("TapNoteScore_W4")
                                        local greats = topscore:GetTapNoteScore("TapNoteScore_W3")
                                        local perfects = topscore:GetTapNoteScore("TapNoteScore_W2")
                                        local marvelous = topscore:GetTapNoteScore("TapNoteScore_W1")

                                        if misses == 0 and topscore:GetScore() > 0 and (marvelous + perfects) > 0 then
                                            if (greats + perfects) == 0 then
                                                self:Load(THEME:GetPathG("", "ScreenSelectMusic/MarvelousFullCombo_ring"))
                                            elseif greats == 0 then
                                                self:Load(THEME:GetPathG("", "ScreenSelectMusic/PerfectFullCombo_ring"))
                                            elseif (misses + goods) == 0 then
                                                self:Load(THEME:GetPathG("", "ScreenSelectMusic/GreatFullCombo_ring"))
                                            elseif misses == 0 then
                                                self:Load(THEME:GetPathG("", "ScreenSelectMusic/GoodFullCombo_ring"))
                                            end
                                            self:visible(true):zoom(0.66):spin():effectmagnitude(0, 0, 170)
                                            break
                                        else
                                            self:visible(false)
                                        end
									end
								else
									self:visible(false)
                                end
                            end
                        end
                    end
                },
                Def.Quad{
                    Name="Grade",
                    InitCommand=function(s) s:draworder(5):visible(false):zoom(1.1):x(8):queuecommand("Set") end,
                    SetCommand=function(self)
                        local course = GAMESTATE:GetCurrentCourse()

                        if course and diff then
                            if PROFILEMAN:IsPersistentProfile(pn) then
                                profile = PROFILEMAN:GetProfile(pn)
                            else
                                profile = PROFILEMAN:GetMachineProfile()
                            end

                            -- Find the trail that matches the current difficulty
                            local all_trails = course:GetAllTrails()
                            local trail = nil
                            for _, t in ipairs(all_trails) do
                                if t:GetDifficulty() == diff then
                                    trail = t
                                    break
                                end
                            end

                            if trail then
                                -- Fetch the high score list for the current course and trail
                                local scorelist = profile:GetHighScoreList(course, trail)
                                local scores = scorelist:GetHighScores()
                                local topscore = 0

                                if scores[1] then
                                    topscore = scores[1]:GetScore()
                                end

                                local topgrade
                                if scores[1] then
                                    topgrade = GetGrade(nil, scores[1])
                                    assert(topgrade)
                                    local tier = topgrade
                                    if scores[1]:GetScore() > 1 then
                                        if topgrade == 'Grade_Failed' then
                                            self:LoadBackground(THEME:GetPathG("", "ScreenSelectMusic/Grade Failed"))
                                        else
                                            self:LoadBackground(THEME:GetPathG("ScreenSelectMusic/Grade", ToEnumShortString(tier)))
                                        end
                                        self:visible(true)
                                    else
                                        self:visible(false)
                                    end
								else
									self:visible(false)
                                end
                            end
                        end
                    end
                }
            }
        }
    }
end

local TwoPart = Def.ActorFrame{
	StartSelectingStepsMessageCommand=function(s) s:AddChildFromPath(THEME:GetPathB("ScreenSelectMusic","overlay/TwoPartDiff")) end,
	SongUnchosenMessageCommand=function(s) 
		s:sleep(0.2):queuecommand("Remove")
	end,
	RemoveCommand=function(s) s:RemoveChild("TwoPartDiff") end,
};

return Def.ActorFrame{
	InitCommand=function(s) s:finishtweening():queuecommand("Set") end,
	CurrentCourseChangedMessageCommand=function(s) s:finishtweening():queuecommand("Set") end,
	["CurrentTrail" .. ToEnumShortString(pn) .. "ChangedMessageCommand"]=function(s) s:finishtweening():queuecommand("Set") end,
	Def.Sprite{
		Texture=THEME:GetPathB("ScreenSelectMusic","overlay/Difficulty/"..Model().."frame"),
		InitCommand=function(s) s:xy(pn==PLAYER_1 and 36 or -36,-17):rotationy(pn==PLAYER_1 and 0 or 180) end,
		OnCommand=function(s) s:diffusealpha(0):sleep(0.4):linear(0.05):diffusealpha(0.75):linear(0.1):diffusealpha(0.25):linear(0.1):diffusealpha(1) end,
	};
	Def.Sprite{
		Texture=THEME:GetPathB("ScreenSelectMusic","overlay/Difficulty/"..Model()..Language().."text"),
		InitCommand=function(s) s:xy(20,-112) end,
		OnCommand=function(s) s:diffusealpha(0):sleep(0.4):linear(0.05):diffusealpha(0.75):linear(0.1):diffusealpha(0.25):linear(0.1):diffusealpha(1) end,
	};
    DiffList..{
		InitCommand=function(s) s:x(pn==PLAYER_1 and 0 or -14) end,
		OnCommand=function(s) s:diffusealpha(0):sleep(0.4):linear(0.05):diffusealpha(0.75):linear(0.1):diffusealpha(0.25):linear(0.1):diffusealpha(1) end,
    };
	Def.Quad{
    InitCommand=function(s) s:x(pn==PLAYER_1 and 0 or -9)
		s:setsize(246,25):diffusealpha(0)
		s:diffuseramp():effectcolor1(color("0,1,1,0.2")):effectcolor2(color("0,1,1,1")):effectperiod(0.8):visible(false) 
	end,
	OnCommand=function(s) s:diffusealpha(0):sleep(0.8):diffusealpha(1) end,
	["CurrentTrail" .. ToEnumShortString(pn) .. "ChangedMessageCommand"]=function(s)
		local song=GAMESTATE:GetCurrentCourse()
		if song then
			s:visible(true)
			local steps = GAMESTATE:GetCurrentTrail(pn)

			if steps then
				local diff = steps:GetDifficulty();
				local st=GAMESTATE:GetCurrentStyle():GetStepsType();
				entry = Difficulty:Reverse()[diff]

                for j, difficulty_name in ipairs(difficulties) do
                    if difficulty_name == diff then
                    entry = j
                    end
                end
                
                s:xy(pn==PLAYER_1 and 0 or -8, (entry * yspacing) - 120)
			else
				s:visible(false)
			end;
		end;
    end,
	};
}
