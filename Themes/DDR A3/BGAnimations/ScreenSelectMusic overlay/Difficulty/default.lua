local pn = ...
local difficulties = {}

difficulties = {"Difficulty_Beginner", "Difficulty_Easy", "Difficulty_Medium", "Difficulty_Hard", "Difficulty_Challenge"}

local DiffList = Def.ActorFrame{}

for i, difficulty in ipairs(difficulties) do
  DiffList[#DiffList+1] = Def.ActorFrame{
    InitCommand=function(s)
      local steps = GAMESTATE:GetCurrentSteps(pn)
      local song = GAMESTATE:GetCurrentSong()

      if not song then return end
      local total_diffs = song:GetStepsByStepsType(GAMESTATE:GetCurrentStyle():GetStepsType())

      local current_diff = difficulty
      local current_diff_index = nil

      -- Single loop to find the current difficulty index
      for i, diff in ipairs(total_diffs) do
          if diff:GetDifficulty() == current_diff then
              current_diff_index = i
              break
          end
      end

      if current_diff_index == nil then 
        s:diffusealpha(0)
        return
      else
        s:diffusealpha(1)
      end

      s:y(((current_diff_index - 1) * 38) - 80)
    end,
    SetCommand=function(self)
      diff = difficulty;
      local st=GAMESTATE:GetCurrentStyle():GetStepsType()
      local song=GAMESTATE:GetCurrentSong()
      local steps = GAMESTATE:GetCurrentSteps(pn)

      if not song then self:diffusealpha(0) return else self:diffusealpha(1) end

      local total_diffs
      if song then
        total_diffs = song:GetStepsByStepsType(GAMESTATE:GetCurrentStyle():GetStepsType())
      else
        return
      end


      local current_diff = difficulty
      local current_diff_index = nil

      -- Single loop to find the current difficulty index
      for i, diff in ipairs(total_diffs) do
          if diff:GetDifficulty() == current_diff then
              current_diff_index = i
              break
          end
      end

      if current_diff_index == nil then
        self:diffusealpha(0)
        return
      else
        self:diffusealpha(1)
      end

      self:y(((current_diff_index - 1) * 38) - 80)
    end;
    Def.BitmapText{
      Font="_dispatrox 32px",
      Name="DiffLabel";
      InitCommand=function(self)
        self:halign(pn=='pnNumber_P2' and 1 or 0):draworder(99):diffuse(Color.White):zoomx(0.5):zoomy(0.6):maxwidth(150)
        self:x(-119)
        self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(difficulty)))
      end;
    };
    Def.ActorFrame{
      InitCommand=function(s) s:x(pn==pn_2 and 26 or -26) end,
      Def.Quad{
        InitCommand=function(s) s:setsize(26,25):diffuse(CustomDifficultyToColor(difficulty)) end,
      };
      Def.BitmapText{
        Font="_impact 32px",
        Name="Meter";
        InitCommand=function(s) s:draworder(99):strokecolor(Color.Black):zoom(0.75) end,
        SetCommand=function(self)
          self:settext("")
          local st=GAMESTATE:GetCurrentStyle():GetStepsType()
          local song=GAMESTATE:GetCurrentSong()
          if song then
            if song:HasStepsTypeAndDifficulty( st, diff ) then
              local steps = song:GetOneSteps( st, diff )
              self:settext( steps:GetMeter() )
            end
          end;
        end;
      };
    };
    Def.BitmapText{
      Font="_geo 957 Bold",
      Name="Score";
      InitCommand=function(s) s:draworder(5):diffuse(Color.White):xy(80,-1):zoom(1.1):halign(1):maxwidth(80) end,
      SetCommand=function(self)
        self:settext("")

        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        local song=GAMESTATE:GetCurrentSong()
        if song then
          if song:HasStepsTypeAndDifficulty(st,diff) then
            local steps = song:GetOneSteps(st,diff)

            if PROFILEMAN:IsPersistentProfile(pn) then
              profile = PROFILEMAN:GetProfile(pn)
            else
              profile = PROFILEMAN:GetMachineProfile()
            end;

            scorelist = profile:GetHighScoreList(song,steps)
            local scores = scorelist:GetHighScores()
            local topscore = 0

            if scores[1] then
                topscore = scores[1]:GetScore()
            end;
            self:diffusealpha(1)

            if topscore ~= 0 then
                self:settext(commify(topscore))
            end;
          end;
        end;
      end;
    };
  Def.ActorFrame{
    InitCommand=function(s) s:x(90) end,
    Def.Sprite{
      InitCommand=function(s) s:xy(27,2) end,
      SetCommand=function(self)
        local st = GAMESTATE:GetCurrentStyle():GetStepsType();
        local song = GAMESTATE:GetCurrentSong();
        local profile = MachineOrProfile(pn)
        if song then
          if song:HasStepsTypeAndDifficulty(st,diff) then
            local steps = song:GetOneSteps( st, diff );
            local scorelist = profile:GetHighScoreList(song,steps);
              assert(scorelist);
            local scores = scorelist:GetHighScores();
              assert(scores);
            if scores[1] then
              for _, topscore in ipairs(scores) do
                assert(topscore);
                local misses = topscore:GetTapNoteScore("TapNoteScore_Miss") + 
                                topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss") +
                                topscore:GetHoldNoteScore("HoldNoteScore_LetGo") +
                                topscore:GetTapNoteScore("TapNoteScore_HitMine")
                local goods = topscore:GetTapNoteScore("TapNoteScore_W4");
                local greats = topscore:GetTapNoteScore("TapNoteScore_W3");
                local perfects = topscore:GetTapNoteScore("TapNoteScore_W2");
                local marvelous = topscore:GetTapNoteScore("TapNoteScore_W1");
                if topscore:GetGrade() ~= "Grade_Failed" and (misses) == 0 and topscore:GetScore() > 0 and (marvelous+perfects)>0 then
                  if (greats+perfects) == 0 then
                    self:Load(THEME:GetPathG("","ScreenSelectMusic/MarvelousFullCombo_ring"))
                  elseif greats == 0 then
                    self:Load(THEME:GetPathG("","ScreenSelectMusic/PerfectFullCombo_ring"))
                  elseif (misses+goods) == 0 then
                    self:Load(THEME:GetPathG("","ScreenSelectMusic/GreatFullCombo_ring"))
                  elseif (misses) == 0 then
                    self:Load(THEME:GetPathG("","ScreenSelectMusic/GoodFullCombo_ring"))
                  end;
                  self:visible(true):zoom(0.66):spin():effectmagnitude(0,0,170)
                  break
                else
                  self:visible(false)
                end;
              end;
            else
              self:visible(false)
            end;
          else
            self:visible(false)
          end;
        else
          self:visible(false)
      end;
    end
      };
      Def.Quad{
        Name="Grade";
      InitCommand=function(s) s:draworder(5):visible(false):zoom(1.1):x(8) end,
      SetCommand=function(self)
        local st=GAMESTATE:GetCurrentStyle():GetStepsType();
        local song=GAMESTATE:GetCurrentSong();
        if song then
          if song:HasStepsTypeAndDifficulty(st,diff) then
            local steps = song:GetOneSteps(st, diff)
            if PROFILEMAN:IsPersistentProfile(pn) then
              profile = PROFILEMAN:GetProfile(pn)
            else
              profile = PROFILEMAN:GetMachineProfile()
            end

            scorelist = profile:GetHighScoreList(song,steps)
            local scores = scorelist:GetHighScores()

            local topscore=0
            if scores[1] then
              topscore = scores[1]:GetScore()
            end

            local topgrade
            if scores[1] then
              topgrade = scores[1]:GetGrade();
              assert(topgrade)
              local tier = topgrade
              if scores[1]:GetScore()>1  then
                if topgrade == 'Grade_Failed' then
                  self:LoadBackground(THEME:GetPathG("","ScreenSelectMusic/Grade Failed"));
                else
                  self:LoadBackground(THEME:GetPathG("ScreenSelectMusic/Grade",ToEnumShortString(tier)));
                end;
                self:visible(true)
              else
                self:visible(false)
              end;
            else
              self:visible(false)
            end;
          else
            self:visible(false)
          end;
        else
          self:visible(false)
        end;
      end;
      };
    };
  };
end

return Def.ActorFrame{
  CurrentSongChangedMessageCommand=function(s) s:finishtweening():queuecommand("Set") end,
    ["CurrentSteps" .. ToEnumShortString(pn) .. "ChangedMessageCommand"]=function(s) s:finishtweening():queuecommand("Set") end,
	Def.Sprite{
		Texture=Model().."frame",
		InitCommand=function(s) s:xy(pn==PLAYER_1 and 36 or -36,-17):rotationy(pn==PLAYER_1 and 0 or 180) end,
		OnCommand=function(s) s:diffusealpha(0):sleep(0.4):linear(0.05):diffusealpha(0.75):linear(0.1):diffusealpha(0.25):linear(0.1):diffusealpha(1) end,
	};
	Def.Sprite{
		Texture=Model()..Language().."text",
		InitCommand=function(s) s:xy(10,-112) end,
		OnCommand=function(s) s:diffusealpha(0):sleep(0.4):linear(0.05):diffusealpha(0.75):linear(0.1):diffusealpha(0.25):linear(0.1):diffusealpha(1) end,
	};
    DiffList..{
		InitCommand=function(s) s:x(pn==PLAYER_1 and 0 or -14) end,
      OnCommand=function(s) s:diffusealpha(0):sleep(0.4):linear(0.05):diffusealpha(0.75):linear(0.1):diffusealpha(0.25):linear(0.1):diffusealpha(1) end,
    };
	LoadActor(Model().."line")..{
		InitCommand=function(s) s:x(pn==PLAYER_1 and 0 or -9)
			s:setsize(246,25):diffusealpha(0)
			s:diffuseramp():effectcolor1(color("1,1,1,0.2")):effectcolor2(color("1,1,1,1")):effectperiod(0.8):visible(false) 
		end,
		OnCommand=function(s) 
      s:diffusealpha(0):sleep(0.8):diffusealpha(1) end,
      SetCommand = function(s)
        local song = GAMESTATE:GetCurrentSong()
        if song then
            s:visible(true)
            local steps = GAMESTATE:GetCurrentSteps(pn)

            local total_diffs = song:GetStepsByStepsType(GAMESTATE:GetCurrentStyle():GetStepsType())
            local current_diff = GAMESTATE:GetCurrentSteps(pn):GetDifficulty()
            local current_diff_index = nil
    
            -- Single loop to find the current difficulty index
            for i, diff in ipairs(total_diffs) do
                if diff:GetDifficulty() == current_diff then
                    current_diff_index = i
                    break
                end
            end
    
            if not current_diff_index then return end

            -- Calculate the position if current_diff_index is found
            s:y(((current_diff_index - 1) * 38) - 80)
        else
            s:visible(false)
        end
    end
	};
}
