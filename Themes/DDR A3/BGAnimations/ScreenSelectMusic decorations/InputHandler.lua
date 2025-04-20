mwState = {
  tweened = false,
  inMusicSelect = false
}

local function WheelMove(mov)
  local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel");
  mw:Move(mov)
end

local function UpdateMusicWheel()
  local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
  if mw and not mwState.tweened and mwState.inMusicSelect then
      mw:linear(0.2):diffusealpha(1):effectcolor2(color("#ffffff"))
      mwState.tweened = true
  end
end

local function InputHandler(event)
  local player = event.PlayerNumber
  local MusicWheel = SCREENMAN:GetTopScreen("ScreenSelectMusic"):GetChild("MusicWheel");
  if event.type == "InputEventType_Release" then return false end
  if MusicWheel ~= nil then
    if event.GameButton == "MenuLeft" and GAMESTATE:IsPlayerEnabled(player) then
      SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
    end
    if event.GameButton == "MenuRight" and GAMESTATE:IsPlayerEnabled(player) then
      SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
    end
    if event.GameButton == "Select" and GAMESTATE:IsPlayerEnabled(player) then
      MusicWheel:diffuseramp():effectcolor1(color("#ffffff")):effectcolor2(color("#000000")):effectperiod(0.1):sleep(0.1):diffusealpha(0)
      mwState.inMusicSelect = false
      mwState.tweened = false
    end
    if event.GameButton == "MenuDown" and GAMESTATE:IsPlayerEnabled(player) and PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then
      if MusicWheel:GetSelectedType() == 'WheelItemDataType_Song' then
        WheelMove(3)
        if MusicWheel:GetSelectedType() ~= 'WheelItemDataType_Song' then
          WheelMove(-2)
          if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
            WheelMove(2)
            if MusicWheel:GetSelectedType() ~= "WheelItemDataType_Song" then
              WheelMove(-1)
              if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
                WheelMove(1)
              end
            end
          end
        end
    else
      MusicWheel:Move(1)
    end
    MusicWheel:Move(0)
    SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
    end
    if event.GameButton == "MenuUp" and GAMESTATE:IsPlayerEnabled(player) and PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then
      if MusicWheel:GetSelectedType() == 'WheelItemDataType_Song' then
        WheelMove(-3)
        if MusicWheel:GetSelectedType() ~= 'WheelItemDataType_Song' then
          WheelMove(2)
          if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
            WheelMove(-2)
            if MusicWheel:GetSelectedType() ~= "WheelItemDataType_Song" then
              WheelMove(1)
              if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
                WheelMove(-1)
              end
            end
          end
        end
      else
        WheelMove(-1)
      end
      WheelMove(0)
      SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
    end
  end
end

return Def.ActorFrame{
  OnCommand=function(self) 
      SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
      self:SetUpdateFunction(UpdateMusicWheel)
    end;
  OffCommand=function(self) SCREENMAN:GetTopScreen():RemoveInputCallback(InputHandler) end,
  SongChosenMessageCommand=function(self) self:playcommand("Off") end;
  SongUnchosenMessageCommand=function(self)
    self:sleep(0.5):queuecommand("On");
  end;
};