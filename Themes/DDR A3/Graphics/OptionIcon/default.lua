local pn = ...
local player = ToEnumShortString(pn)

local gauge = GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):DrainSetting()

local gaugeP1 = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions('ModsLevel_Current'):DrainSetting()
local gaugeP2 = GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptions('ModsLevel_Current'):DrainSetting()

local flareData = {
    ["PlayerNumber_P1"] = {
        isFlare = false,
        currentFlare = 10,
        previousFlareLife = 1,
    },
    ["PlayerNumber_P2"] = {
        isFlare = false,
        currentFlare = 10,
        previousFlareLife = 1,
    }
}


if gaugeP1 == "DrainType_FloatingFlare" then
	flareData["PlayerNumber_P1"].isFlare = true;
end

if gaugeP2 == "DrainType_FloatingFlare" then
	flareData["PlayerNumber_P2"].isFlare = true;
end


return Def.ActorFrame {
	-- Speed
	Def.Sprite{
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:playcommand("On");
			end;
		end;
		CodeMessageCommand=function(self, params)
			if params.PlayerNumber == pn then
				self:queuecommand("On");
			end;
		end;
		OnCommand=function(self) self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Speed/x"..GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Song"):ScrollSpeed()..".png")):x(-186):queuecommand("Update") end,
		UpdateCommand=function(self) self:sleep(0.01):queuecommand("On") end
	};
	-- Boost
	Def.Sprite {
		InitCommand=function(self)
			self:x(-153);
			if GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):Boost() == 1 then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Boost/Boost.png"));
			elseif GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):Brake() == 1 then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Boost/Brake.png"));
			elseif GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):Wave() == 1 then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Boost/Wave.png"));
			end;
		end;
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:playcommand("Init");
			end;
		end;
	};
	-- Appearance
	Def.Sprite {
		InitCommand=function(self)
			self:x(-119);
			local PlayerUID = PROFILEMAN:GetProfile(pn):GetGUID()
			local MyValue = ReadOrCreateAppearancePlusValueForPlayer(PlayerUID,MyValue);
			if MyValue == "Visible" then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Off.png"));
			elseif MyValue == "Hidden" then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Appearance/Hidden.png"));
			elseif MyValue == "Sudden" then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Appearance/Sudden.png"));
			elseif MyValue == "Stealth" then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Appearance/Stealth.png"));
			elseif MyValue == "Hidden+" then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Appearance/HiddenPlus.png"));
			elseif MyValue == "Sudden+" then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Appearance/SuddenPlus.png"));
			elseif MyValue == "Hidden+&Sudden+" then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Appearance/HiddenSuddenPlus.png"));
			elseif MyValue == "Constant" then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Appearance/Sudden.png"));
			end;
		end;
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:playcommand("Init");
			end;
		end;
	};
	-- Turn
	Def.Sprite {
		InitCommand=function(self)
			self:x(-85);
			if GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):Mirror() then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Turn/Mirror.png"));
			elseif GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):Left() then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Turn/Left.png"));
			elseif GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):Right() then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Turn/Right.png"));
			elseif GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):Shuffle() then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Turn/Shuffle.png"));
			end;
		end;
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:playcommand("Init");
			end;
		end;
	};
	-- Dark
	Def.Sprite {
		InitCommand=function(self)
			self:x(-51);
			if GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):Dark() == 1 then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Dark/Off.png"));
			end;
		end;
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:playcommand("Init");
			end;
		end;
	};
	-- Scroll
	Def.Sprite {
		InitCommand=function(self)
			self:x(-18);
			if GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):Reverse() == 1 then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Scroll/Reverse.png"));
			end;
		end;
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:playcommand("Init");
			end;
		end;
	};
	-- Arrow
	Def.Sprite {
		InitCommand=function(self)
			self:x(16);
			if not GAMESTATE:IsDemonstration() then
				if GetUserPref("NTOption")=='On' then
					self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Arrow/"..GetArrowColor(pn)));
				else
					self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Arrow/Note"));
				end
			end
		end;
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:playcommand("Init");
			end;
		end;
	};
	-- Cut
	Def.Sprite {
		InitCommand=function(self)
			self:x(49);
			if GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):Little() then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Cut/On1.png"));
			end;
		end;
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:playcommand("Init");
			end;
		end;
	};
	-- Freeze arrow
	Def.Sprite {
		InitCommand=function(self)
			self:x(83);
			if GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):NoHolds() then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Freeze/Off.png"));
			end;
		end;
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:playcommand("Init");
			end;
		end;
	};
	-- Jump
	Def.Sprite {
		InitCommand=function(self)
			self:x(116);
			if GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):NoJumps() then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Jump/On2.png"));
			end;
		end;
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:playcommand("Init");
			end;
		end;
	};
	-- Risky
	Def.Sprite {
		InitCommand=function(self)
			self:x(151);
			if table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), 'Flare1') then	
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Flare1.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), 'Flare2') then	
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Flare2.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), 'Flare3') then	
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Flare3.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), 'Flare4') then	
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Flare4.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), 'Flare5') then	
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Flare5.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), 'Flare6') then	
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Flare6.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), 'Flare7') then	
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Flare7.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), 'Flare8') then	
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Flare8.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), 'Flare9') then	
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Flare9.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), 'FlareEX') then	
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/FlareEX.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), 'FloatingFlare') then
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/FlareEX.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), '4Lives') then			
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Life4.png"));
			elseif table.search(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred"), '1Lives') then			
				self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Risky.png"));                                			
			end;
		end;
		PlayerJoinedMessageCommand=function(self, params)
			if params.Player == pn then
				self:playcommand("Init");
			end;
		end;
		LifeChangedMessageCommand=function(self, param)
			if not flareData[pn].isFlare then return end
			if gauge == "DrainType_FloatingFlare" then
				if param.LifeMeter:GetLife() > flareData[pn].previousFlareLife and param.Player == pn then
					flareData[pn].currentFlare = flareData[pn].currentFlare - 1
					self:Load(THEME:GetPathG("","OptionIcon/"..player.."/Gauge/Flare"..flareData[pn].currentFlare..".png"));
					flareData[pn].previousFlareLife = param.LifeMeter:GetLife()
				elseif param.LifeMeter:GetLife() < 0.3 and param.Player == pn then
					flareData[pn].previousFlareLife = param.LifeMeter:GetLife()
				end
			end
		end,
	};
};
