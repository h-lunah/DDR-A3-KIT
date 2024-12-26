local pn = ...
local Risky = GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):LifeSetting() == 'LifeType_Battery'

local gauge = GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):DrainSetting()

local gaugeP1 = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions('ModsLevel_Current'):DrainSetting()
local gaugeP2 = GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptions('ModsLevel_Current'):DrainSetting()

local flareData = {
    ["PlayerNumber_P1"] = {
        isFlare = false,
        currentFlare = 9,
        previousFlareLife = 1,
    },
    ["PlayerNumber_P2"] = {
        isFlare = false,
        currentFlare = 9,
        previousFlareLife = 1,
    }
}

if gaugeP1 == "DrainType_FloatingFlare" then
	flareData["PlayerNumber_P1"].isFlare = true;
end

if gaugeP2 == "DrainType_FloatingFlare" then
	flareData["PlayerNumber_P2"].isFlare = true;
end

function GaugeTextureDanger(g)
	if string.find(g, "Flare") then
		return "FlareDanger"
	else
		return "danger_base"
	end
end


function GaugeTextureHot(g)
	if g == 'DrainType_Flare1' then
		return "Flare1"
	elseif g == 'DrainType_Flare2' then
		return "Flare2"
	elseif g == 'DrainType_Flare3' then
		return "Flare3"
	elseif g == 'DrainType_Flare4' then
		return "Flare4"
	elseif g == 'DrainType_Flare5' then
		return "Flare5"
	elseif g == 'DrainType_Flare6' then
		return "Flare6"
	elseif g == 'DrainType_Flare7' then
		return "Flare7"
	elseif g == 'DrainType_Flare8' then
		return "Flare8"
	elseif g == 'DrainType_Flare9' then
		return "Flare9"
	elseif g == 'DrainType_FlareEX' then
		return "FlareEX"
	elseif g == 'DrainType_FloatingFlare' then
		return "FlareEX"
	elseif g == "DrainType_Class" then
		return "grade"
	else
		return "full"
	end
end

function GaugeTexture(g)
	if g == 'DrainType_Flare1' then
		return "Flare1"
	elseif g == 'DrainType_Flare2' then
		return "Flare2"
	elseif g == 'DrainType_Flare3' then
		return "Flare3"
	elseif g == 'DrainType_Flare4' then
		return "Flare4"
	elseif g == 'DrainType_Flare5' then
		return "Flare5"
	elseif g == 'DrainType_Flare6' then
		return "Flare6"
	elseif g == 'DrainType_Flare7' then
		return "Flare7"
	elseif g == 'DrainType_Flare8' then
		return "Flare8"
	elseif g == 'DrainType_Flare9' then
		return "Flare9"
	elseif g == 'DrainType_FlareEX' then
		return "FlareEX"
	elseif g == 'DrainType_FloatingFlare' then
		return "FlareEX"
	elseif g == "DrainType_Class" then
		return "grade"
	else
		return "normal"
	end
end

function FloatingGaugeTexture(i)
	if i == 0 then
		return "Flare1"
	elseif i == 1 then
		return "Flare2"
	elseif i == 2 then
		return "Flare3"
	elseif i == 3 then
		return "Flare4"
	elseif i == 4 then
		return "Flare5"
	elseif i == 5 then
		return "Flare6"
	elseif i == 6 then
		return "Flare7"
	elseif i == 7 then
		return "Flare8"
	elseif i == 8 then
		return "Flare9"
	elseif i == 9 then
		return "FlareEX"
	else
		return "Flare1"
	end
end

function GaugeSpeed(g, s)
	if string.find(g, "Flare") then
		return pn==PLAYER_2 and 0.8 or -0.8
	elseif string.find(g, "Class") then
		return pn==PLAYER_2 and 0.6 or -0.6
	else
		return pn==PLAYER_2 and 0.6 or -0.6
	end
end

function GaugeSpeedNormal(g)
	if string.find(g, "Flare") then
		return pn==PLAYER_2 and 0.8 or -0.8
	elseif string.find(g, "Class") then
		return pn==PLAYER_2 and 0.6 or -0.6
	else
		return 0
	end
end


function GaugeSpeedDanger(g)
	if string.find(g, "Flare") then
		return pn==PLAYER_2 and 0.8 or -0.8
	else
		return pn==PLAYER_2 and 4 or -4
	end
end


return Def.ActorFrame{
    InitCommand=function(s)
        s:xy(pn==PLAYER_1 and _screen.cx-231 or _screen.cx+229,SCREEN_TOP+23):draworder(99)
    end,
    Name="LifeFrame",
	Def.Sprite{
        Texture=THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/base"),
		InitCommand=function(s) s:x(pn==PLAYER_1 and -7 or 9):zoomto(296,20):diffusealpha(Risky and 0 or 1) end,
	};
	Def.Sprite{
        Texture=THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/"..GaugeTexture(gauge)),
		InitCommand=function(s) s:x(pn==PLAYER_1 and -8 or 10) end,
        OnCommand=function(s) s:scaletoclipped(296,20)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail"):customtexturerect(0,0,1,1)
            :texcoordvelocity(GaugeSpeedNormal(gauge),0)
        end,
		-- FLOATING FLARE
		LifeChangedMessageCommand=function(self, param)
			if not flareData[pn].isFlare then return end
			if gauge == "DrainType_FloatingFlare" then
				-- Decrement FLOATING FLARE one FLARE GAUGE
				if param.LifeMeter:GetLife() > flareData[pn].previousFlareLife and param.Player == pn then
					flareData[pn].currentFlare = flareData[pn].currentFlare - 1
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/"..FloatingGaugeTexture(flareData[pn].currentFlare)))
					self:diffuse(color("#ffffff"))
					flareData[pn].previousFlareLife = param.LifeMeter:GetLife()
				-- Handle DANGER state
				elseif param.LifeMeter:GetLife() < 0.3 and param.Player == pn then
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/".."FlareDanger"))
					flareData[pn].previousFlareLife = param.LifeMeter:GetLife()
				end
			end
		end,
		-- NORMAL, CLASS, FLARE I through FLARE EX
        HealthStateChangedMessageCommand=function(self, param)
			if flareData[pn].isFlare then return end
			if param.PlayerNumber == pn then
				if param.HealthState == "HealthState_Danger" or param.HealthState == "HealthState_Danger_NoComment" then
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/"..GaugeTextureDanger(gauge)))
					self:texcoordvelocity(GaugeSpeedDanger(gauge),0)
				elseif param.HealthState == "HealthState_Hot" then
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/"..GaugeTextureHot(gauge)))
					self:texcoordvelocity(GaugeSpeed(gauge),0)
		  		else
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/"..GaugeTexture(gauge)))
					self:texcoordvelocity(GaugeSpeedNormal(gauge),0)
		  		end;
			end;
		end;
    };

	-- Slow white pulse effect in LET'S CHECK YOUR LEVEL
	Def.Quad{
		InitCommand=function(s) s:x(pn==PLAYER_1 and -8 or 10):diffusealpha(0) end,
		OnCommand=function(s)
			if GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "LET'S CHECK YOUR LEVEL!" or
			GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Steps to the Star" then
				s:scaletoclipped(296,20)
				:diffusealpha(1)
				:diffuseshift()
				:blend('BlendMode_Add')
				:effectcolor1(color("#000000"))
				:effectcolor2(color("#ffffff"))
				:effectperiod(5)
			end
		end
	};
	Def.Sprite{
		InitCommand=function(s) s:x(pn==PLAYER_1 and -8 or 10) end,
        OnCommand=function(s) s:scaletoclipped(296,20)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail"):customtexturerect(0,0,1,1)
            :texcoordvelocity(GaugeSpeedNormal(gauge),0)
			:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/".."danger_flash"))
			:blend('BlendMode_Add')
			:diffusealpha(0.6)
			:texcoordvelocity(4,0)
			:visible(false)
        end,
		-- NORMAL, CLASS, FLARE I through FLARE EX
        HealthStateChangedMessageCommand=function(self, param)
			if string.find(gauge, "Flare") then return end
			if param.PlayerNumber == pn then
				if param.HealthState == "HealthState_Danger" or param.HealthState == "HealthState_Danger_NoComment" then
					self:visible(true)
				else
					self:visible(false)
				end
			end;
		end;
    };
	Def.Sprite{
        Name="LifeFrame"..pn,
        InitCommand=function(s) s:x(pn==PLAYER_1 and -3.97 or 6):zoom(0.667):rotationy(pn==PLAYER_2 and 180 or 0):y(-0.5) end,
        BeginCommand=function(self)
			if Risky then
				self:Load(THEME:GetPathB("ScreenGameplay","decorations/lifeframe/"..Model().."life"))  
			else
				self:Load(THEME:GetPathB("ScreenGameplay","decorations/lifeframe/"..Model().."normal"))
			end;
        end
    };
};
