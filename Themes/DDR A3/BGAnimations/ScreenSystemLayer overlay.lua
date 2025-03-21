local paseli = 57300
local extraPaseli = 0
local paseliCost = 100

local padding = 7
local textZoom = 0.4
local updateTime = 1/60

local function IsInGame()
	currentScreen = SCREENMAN:GetTopScreen()
	if currentScreen ~= nil then
		if currentScreen:GetName() == "ScreenSelectProfile" or
		currentScreen:GetName() == "ScreenSelectStyle" or
		currentScreen:GetName() == "ScreenCaution" or
		currentScreen:GetName() == "ScreenSelectMusic" or
		currentScreen:GetName() == "ScreenPlayerOptions" or
		currentScreen:GetName() == "ScreenStageInformation" or
		currentScreen:GetName() == "ScreenGameplay" or
		currentScreen:GetName() == "ScreenEvaluationNormal" or
		currentScreen:GetName() == "ScreenEvaluationSummary" or
		currentScreen:GetName() == "ScreenDataSaveSummary" or
		currentScreen:GetName() == "ScreenGameOver" then
			return true
		else
			return false
		end
	end
end

local function IsLoggedIn()
	return GAMESTATE:HaveProfileToSave()
end

local function ShouldHideBalance()
	currentScreen = SCREENMAN:GetTopScreen()
	if currentScreen ~= nil then
		if currentScreen:GetName() == "ScreenSelectProfile" or
		currentScreen:GetName() == "ScreenSelectStyle" then
			return false
		else
			return true
		end
	end
end


t = Def.ActorFrame {
	InitCommand=function(s)
		s:visible(false)
		s:queuecommand("Update")
	end;

	UpdateCommand=function(s)
		s:finishtweening()
		s:sleep(updateTime)
		s:queuecommand("UpdateVisibility")
	end;

	UpdateVisibilityCommand=function(s)
		local CurrentScreen = SCREENMAN:GetTopScreen()

		if CurrentScreen ~= nil then
			local VisibleMetric = THEME:GetMetric(CurrentScreen:GetName(), "ShowCreditDisplay")

			if VisibleMetric ~= nil then
				s:visible(VisibleMetric)
			else
				s:visible(true)
			end
		end

		s:queuecommand("Update")
	end;
}

t[#t+1] = Def.BitmapText {
	Font="_futura lt medium 24px";
	InitCommand=function(s)
		s:xy(SCREEN_CENTER_X, SCREEN_BOTTOM-padding)
		s:strokecolor(color("0,0,0,1"))
		s:zoom(textZoom)
		s:queuecommand("Update")
	end;

	UpdateCommand=function(s)
		s:sleep(updateTime)
		s:queuecommand("GetCredits")
	end;

	GetCreditsCommand=function(s)
		if GAMESTATE:GetCoinMode() == "CoinMode_Home" then
			s:settext("HOME MODE")
		elseif GAMESTATE:IsEventMode() then
			s:settext("EVENT MODE")
		elseif GAMESTATE:GetCoinMode() == "CoinMode_Free" then
			s:settext("FREE PLAY")
		else
			local credits = math.floor(GAMESTATE:GetCoins() / GAMESTATE:GetCoinsNeededToJoin())
			
			if credits > 1 then
				s:settext("CREDITS: "..credits)
			else
				s:settext("CREDIT: "..credits)
			end
		end
		s:queuecommand("Update")
	end;

	CoinInsertedMessageCommand=function(s)
		s:queuecommand("GetCredits")
	end;
}

t[#t+1] = Def.BitmapText {
	Font="_futura lt medium 24px";
	InitCommand=function(s)
		s:xy(SCREEN_CENTER_X+80, SCREEN_BOTTOM-padding)
		s:strokecolor(color("0,0,0,1"))
		s:zoom(textZoom)
		s:queuecommand("Update")
	end;

	UpdateCommand=function(s)
		s:sleep(updateTime)
		s:queuecommand("GetCoins")
	end;

	GetCoinsCommand=function(s)
		if GAMESTATE:GetCoinsNeededToJoin() < 2 then
			s:settext('')
		else
			local coins = GAMESTATE:GetCoins() % GAMESTATE:GetCoinsNeededToJoin()
			local coinsRequired = GAMESTATE:GetCoinsNeededToJoin()

			s:settext("COIN: "..coins.."/"..coinsRequired)
		end

		s:queuecommand("Update")
	end;

	CoinInsertedMessageCommand=function(s)
		s:queuecommand("GetCoins")
	end;
}

t[#t+1] = Def.BitmapText {
	Font="_futura lt medium 24px";

	InitCommand=function(s)
		s:xy(SCREEN_CENTER_X-190, SCREEN_BOTTOM-padding)
		s:strokecolor(color("0,0,0,1"))
		s:zoom(textZoom)
		s:queuecommand("Update")
	end;

	UpdateCommand=function(s)
		s:sleep(updateTime)
		s:queuecommand("GetOnline")
	end;

	GetOnlineCommand=function(s)
		if IsNetConnected() then
			s:settext('ONLINE')
			s:diffuse(color("#00ff00"))
		else
			s:settext('LOCAL MODE')
			s:diffuse(color("#888888"))
		end

		s:queuecommand("Update")
	end;
}

t[#t+1] = Def.BitmapText {
	Font="_futura lt medium 24px";

	InitCommand=function(s)
		s:xy(SCREEN_LEFT+padding, SCREEN_BOTTOM-padding)
		s:strokecolor(color("0,0,0,1"))
		s:horizalign(left)
		s:zoom(textZoom)
		s:queuecommand("Update")
	end;

	UpdateCommand=function(s)
		s:sleep(updateTime)
		s:queuecommand("GetPaseli")
	end;

	GetPaseliCommand=function(s)
		if not IsNetConnected() or GAMESTATE:GetCoinMode() == "CoinMode_Home" then
			s:settext('')
		elseif GAMESTATE:GetCoinMode() == "CoinMode_Free" or GAMESTATE:IsEventMode() then
			s:settext('PASELI: NOT AVAILABLE')
		elseif GAMESTATE:GetCoinMode() == "CoinMode_Pay" and not GAMESTATE:IsSideJoined(PLAYER_1) then
			s:settext('EXTRA PASELI: '..extraPaseli)
		elseif GAMESTATE:GetCoinMode() == "CoinMode_Pay" and GAMESTATE:IsSideJoined(PLAYER_1) and IsInGame() and IsLoggedIn() and not ShouldHideBalance() then
			s:settext('PASELI: '..paseli+extraPaseli)
		elseif GAMESTATE:GetCoinMode() == "CoinMode_Pay" and GAMESTATE:IsSideJoined(PLAYER_1) and IsInGame() and IsLoggedIn() and ShouldHideBalance() then
			if extraPaseli > 0 then
				-- Yes, KONAMI actually did that.
				-- https://www.youtube.com/watch?v=hnhNcsP2_Ms
				s:settext('PASELI: ****** + '..extraPaseli)
			else
				s:settext('PASELI: ******')
			end
		else
			s:settext('EXTRA PASELI: '..extraPaseli)
		end

		s:queuecommand("Update")
	end;

	PlayerJoinedMessageCommand=function(s)
		if IsLoggedIn() then
			paseli = paseli - paseliCost
		end
	end;
}

t[#t+1] = Def.BitmapText {
	Font="_futura lt medium 24px";

	InitCommand=function(s)
		s:xy(SCREEN_RIGHT-padding, SCREEN_BOTTOM-padding)
		s:strokecolor(color("0,0,0,1"))
		s:horizalign(right)
		s:zoom(textZoom)
		s:queuecommand("Update")
	end;

	UpdateCommand=function(s)
		s:sleep(updateTime)
		s:queuecommand("GetPaseli")
	end;

	GetPaseliCommand=function(s)
		if not IsNetConnected() or GAMESTATE:GetCoinMode() == "CoinMode_Home" then
			s:settext('')
		elseif GAMESTATE:GetCoinMode() == "CoinMode_Free" or GAMESTATE:IsEventMode() then
			s:settext('PASELI: NOT AVAILABLE')
		elseif GAMESTATE:GetCoinMode() == "CoinMode_Pay" and not GAMESTATE:IsSideJoined(PLAYER_2) then
			s:settext('EXTRA PASELI: '..extraPaseli)
		elseif GAMESTATE:GetCoinMode() == "CoinMode_Pay" and GAMESTATE:IsSideJoined(PLAYER_2) and IsInGame() and IsLoggedIn() and not ShouldHideBalance() then
			s:settext('PASELI: '..paseli+extraPaseli)
		elseif GAMESTATE:GetCoinMode() == "CoinMode_Pay" and GAMESTATE:IsSideJoined(PLAYER_2) and IsInGame() and IsLoggedIn() and ShouldHideBalance() then
			if extraPaseli > 0 then
				-- Yes, KONAMI actually did that.
				-- https://www.youtube.com/watch?v=hnhNcsP2_Ms
				s:settext('PASELI: ****** + '..extraPaseli)
			else
				s:settext('PASELI: ******')
			end
		else
			s:settext('EXTRA PASELI: '..extraPaseli)
		end

		s:queuecommand("Update")
	end;

	PlayerJoinedMessageCommand=function(s)
		if IsLoggedIn() then
			paseli = paseli - paseliCost
		end
	end;
}

return t;
