local t = Def.ActorFrame{};

local OptionsP1P = GAMESTATE:GetPlayerState('PlayerNumber_P1'):GetPlayerOptionsString('ModsLevel_Preferred');
local OptionsP2P = GAMESTATE:GetPlayerState('PlayerNumber_P2'):GetPlayerOptionsString('ModsLevel_Preferred');
local OptionsP1S = GAMESTATE:GetPlayerState('PlayerNumber_P1'):GetPlayerOptionsString('ModsLevel_Song');
local OptionsP2S = GAMESTATE:GetPlayerState('PlayerNumber_P2'):GetPlayerOptionsString('ModsLevel_Song');


local numPlayers = GAMESTATE:GetNumPlayersEnabled()
local center1P = PREFSMAN:GetPreference("Center1Player")
local style = GAMESTATE:GetCurrentStyle();
local styleType = ToEnumShortString(style:GetStyleType());

local SingleGraphic = Model().."single"
local DoubleGraphic = Model().."double"

function retrieveMeterType()
	if true then
		if GAMESTATE:IsExtraStage() then
			OptionsP1P = OptionsP1P..',battery,4 lives,failimmediate';
			OptionsP2P = OptionsP2P..',battery,4 lives,failimmediate';
		elseif GAMESTATE:IsExtraStage2() then
			OptionsP1P = OptionsP1P..',battery,1 lives,failimmediate';
			OptionsP2P = OptionsP2P..',battery,1 lives,failimmediate';
		else
			if string.find(OptionsP1P,"1Lives") then
				OptionsP1P = string.gsub(OptionsP1P, "(battery,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(1Lives,)", "");
				OptionsP1P = OptionsP1P..",battery, 1 Lives,failimmediate";
			elseif string.find(OptionsP1P,"2Lives") then
				OptionsP1P = string.gsub(OptionsP1P, "(battery,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(2Lives,)", "");
				OptionsP1P = OptionsP1P..",battery, 2 Lives,failimmediate";
			elseif string.find(OptionsP1P,"3Lives") then
				OptionsP1P = string.gsub(OptionsP1P, "(battery,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(3Lives,)", "");
				OptionsP1P = OptionsP1P..",battery, 3 Lives,failimmediate";
			elseif string.find(OptionsP1P,"4Lives") then
				OptionsP1P = string.gsub(OptionsP1P, "(battery,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(4Lives,)", "");
				OptionsP1P = OptionsP1P..",battery, 4 Lives,failimmediate";
			elseif string.find(OptionsP1P,"Flare1") then
				OptionsP1P = string.gsub(OptionsP1P, "(bar,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(Flare1,)", "");
				OptionsP1P = OptionsP1P..",bar,flare-1,failimmediate";
			elseif string.find(OptionsP1P,"Flare2") then
				OptionsP1P = string.gsub(OptionsP1P, "(bar,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(Flare2,)", "");
				OptionsP1P = OptionsP1P..",bar,flare-2,failimmediate";
			elseif string.find(OptionsP1P,"Flare3") then
				OptionsP1P = string.gsub(OptionsP1P, "(bar,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(Flare3,)", "");
				OptionsP1P = OptionsP1P..",bar,flare-3,failimmediate";
			elseif string.find(OptionsP1P,"Flare4") then
				OptionsP1P = string.gsub(OptionsP1P, "(bar,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(Flare4,)", "");
				OptionsP1P = OptionsP1P..",bar,flare-4,failimmediate";
			elseif string.find(OptionsP1P,"Flare5") then
				OptionsP1P = string.gsub(OptionsP1P, "(bar,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(Flare5,)", "");
				OptionsP1P = OptionsP1P..",bar,flare-5,failimmediate";
			elseif string.find(OptionsP1P,"Flare6") then
				OptionsP1P = string.gsub(OptionsP1P, "(bar,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(Flare6,)", "");
				OptionsP1P = OptionsP1P..",bar,flare-6,failimmediate";
			elseif string.find(OptionsP1P,"Flare7") then
				OptionsP1P = string.gsub(OptionsP1P, "(bar,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(Flare7,)", "");
				OptionsP1P = OptionsP1P..",bar,flare-7,failimmediate";
			elseif string.find(OptionsP1P,"Flare8") then
				OptionsP1P = string.gsub(OptionsP1P, "(bar,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(Flare8,)", "");
				OptionsP1P = OptionsP1P..",bar,flare-8,failimmediate";
			elseif string.find(OptionsP1P,"Flare9") then
				OptionsP1P = string.gsub(OptionsP1P, "(bar,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(Flare9,)", "");
				OptionsP1P = OptionsP1P..",bar,flare-9,failimmediate";
			elseif string.find(OptionsP1P,"FlareEX") then
				OptionsP1P = string.gsub(OptionsP1P, "(bar,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(FlareEX,)", "");
				OptionsP1P = OptionsP1P..",bar,flare-ex,failimmediate";
			elseif string.find(OptionsP1P,"FloatingFlare") then
				OptionsP1P = string.gsub(OptionsP1P, "(bar,)", "");
				OptionsP1P = string.gsub(OptionsP1P, "(FloatingFlare,)", "");
				OptionsP1P = OptionsP1P..",bar,floating-flare,failimmediate";
			else
				OptionsP1P = string.gsub(OptionsP1P, "(battery,)", "");
			end
			
			if string.find(OptionsP2P,"1Lives") then
				OptionsP2P = string.gsub(OptionsP2P, "(battery,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(1Lives,)", "");
				OptionsP2P = OptionsP2P..",battery, 1 Lives,failimmediate";
			elseif string.find(OptionsP2P,"2Lives") then
				OptionsP2P = string.gsub(OptionsP2P, "(battery,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(2Lives,)", "");
				OptionsP2P = OptionsP2P..",battery, 2 Lives,failimmediate";
			elseif string.find(OptionsP2P,"3Lives") then
				OptionsP2P = string.gsub(OptionsP2P, "(battery,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(3Lives,)", "");
				OptionsP2P = OptionsP2P..",battery, 3 Lives,failimmediate";
			elseif string.find(OptionsP2P,"4Lives") then
				OptionsP2P = string.gsub(OptionsP2P, "(battery,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(4Lives,)", "");
				OptionsP2P = OptionsP2P..",battery, 4 Lives,failimmediate";
			elseif string.find(OptionsP2P,"Flare1") then
				OptionsP2P = string.gsub(OptionsP2P, "(bar,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(Flare1,)", "");
				OptionsP2P = OptionsP2P..",bar,flare-1,failimmediate";
			elseif string.find(OptionsP2P,"Flare2") then
				OptionsP2P = string.gsub(OptionsP2P, "(bar,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(Flare2,)", "");
				OptionsP2P = OptionsP2P..",bar,flare-2,failimmediate";
			elseif string.find(OptionsP2P,"Flare3") then
				OptionsP2P = string.gsub(OptionsP2P, "(bar,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(Flare3,)", "");
				OptionsP2P = OptionsP2P..",bar,flare-3,failimmediate";
			elseif string.find(OptionsP2P,"Flare4") then
				OptionsP2P = string.gsub(OptionsP2P, "(bar,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(Flare4,)", "");
				OptionsP2P = OptionsP2P..",bar,flare-4,failimmediate";
			elseif string.find(OptionsP2P,"Flare5") then
				OptionsP2P = string.gsub(OptionsP2P, "(bar,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(Flare5,)", "");
				OptionsP2P = OptionsP2P..",bar,flare-5,failimmediate";
			elseif string.find(OptionsP2P,"Flare6") then
				OptionsP2P = string.gsub(OptionsP2P, "(bar,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(Flare6,)", "");
				OptionsP2P = OptionsP2P..",bar,flare-6,failimmediate";
			elseif string.find(OptionsP2P,"Flare7") then
				OptionsP2P = string.gsub(OptionsP2P, "(bar,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(Flare7,)", "");
				OptionsP2P = OptionsP2P..",bar,flare-7,failimmediate";
			elseif string.find(OptionsP2P,"Flare8") then
				OptionsP2P = string.gsub(OptionsP2P, "(bar,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(Flare8,)", "");
				OptionsP2P = OptionsP2P..",bar,flare-8,failimmediate";
			elseif string.find(OptionsP2P,"Flare9") then
				OptionsP2P = string.gsub(OptionsP2P, "(bar,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(Flare9,)", "");
				OptionsP2P = OptionsP2P..",bar,flare-9,failimmediate";
			elseif string.find(OptionsP2P,"FlareEX") then
				OptionsP2P = string.gsub(OptionsP2P, "(bar,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(FlareEX,)", "");
				OptionsP2P = OptionsP2P..",bar,flare-ex,failimmediate";
			elseif string.find(OptionsP2P,"FloatingFlare") then
				OptionsP2P = string.gsub(OptionsP2P, "(bar,)", "");
				OptionsP2P = string.gsub(OptionsP2P, "(FloatingFlare,)", "");
				OptionsP2P = OptionsP2P..",bar,floating-flare,failimmediate";
			else
				OptionsP2P = string.gsub(OptionsP2P, "(battery,)", "");
			end
		end;
		
		GAMESTATE:SetFailTypeExplicitlySet();
	 end;
	 
end


function RecordGameplayMeterType(player)
	if GAMESTATE:IsCourseMode() == false and GAMESTATE:IsExtraStage()==false and GAMESTATE:IsExtraStage2() ==false then
		local PlayerUID = PROFILEMAN:GetProfile(player):GetGUID(); 
		local Options = "";
		if player=="PlayerNumber_P1" then
			Options= OptionsP1P;
		else
			Options= OptionsP2P;
		end
		
		if string.find(Options,"battery") then
			if string.find(Options,"1Lives") or string.find(Options,"1 Lives")  then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"1 Lives");
			elseif string.find(Options,"2Lives") or string.find(Options,"2 Lives")  then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"2 Lives");
			elseif string.find(Options,"3Lives") or string.find(Options,"3 Lives")  then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"3 Lives");
			elseif string.find(Options,"4Lives") or string.find(Options,"4 Lives")  then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"4 Lives");
			end
		else
			if string.find(Options,"Flare1") then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"Flare1");
			elseif string.find(Options,"Flare2") then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"Flare2");
			elseif string.find(Options,"Flare3") then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"Flare3");
			elseif string.find(Options,"Flare4") then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"Flare4");
			elseif string.find(Options,"Flare5") then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"Flare5");
			elseif string.find(Options,"Flare6") then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"Flare6");
			elseif string.find(Options,"Flare7") then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"Flare7");
			elseif string.find(Options,"Flare8") then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"Flare8");
			elseif string.find(Options,"Flare9") then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"Flare9");
			elseif string.find(Options,"FlareEX") then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"FlareEX");
			elseif string.find(Options,"FloatingFlare") then
				SaveGameplayMeterTypeForPlayer(PlayerUID,"FloatingFlare");
			else
				SaveGameplayMeterTypeForPlayer(PlayerUID,"Normal");
			end
		end
	end
end

function SetGameplayMeterType(player)
	if GAMESTATE:IsCourseMode() == false and GAMESTATE:IsExtraStage()==false and GAMESTATE:IsExtraStage2() ==false then
		local PlayerUID = PROFILEMAN:GetProfile(player):GetGUID();
		local val;		
		local Options = "";
		local OptionsP1P = GAMESTATE:GetPlayerState('PlayerNumber_P1'):GetPlayerOptionsString('ModsLevel_Preferred');
		local OptionsP2P = GAMESTATE:GetPlayerState('PlayerNumber_P2'):GetPlayerOptionsString('ModsLevel_Preferred');
		
		if player=="PlayerNumber_P1" then
			Options= OptionsP1P;
		else
			Options= OptionsP2P;
		end
		
		val= ReadOrCreateGameplayMeterTypeForPlayer(PlayerUID,val);
		
		if val == "1 Lives" then
			Options = string.gsub(Options, "(battery,)", "");
			Options = string.gsub(Options, "(1Lives,)", "");
			Options = Options..",battery, 1 Lives,failimmediate";
		elseif val == "2 Lives" then
			Options = string.gsub(Options, "(battery,)", "");
			Options = string.gsub(Options, "(2Lives,)", "");
			Options = Options..",battery, 2 Lives,failimmediate";
		elseif val == "3 Lives" then
			Options = string.gsub(Options, "(battery,)", "");
			Options = string.gsub(Options, "(3Lives,)", "");
			Options = Options..",battery, 3 Lives,failimmediate";
		elseif val == "4 Lives" then
			Options = string.gsub(Options, "(battery,)", "");
			Options = string.gsub(Options, "(4Lives,)", "");
			Options = Options..",battery, 4 Lives,failimmediate";
		elseif val == "Flare1" then
			Options = string.gsub(Options, "(bar,)", "");
			Options = string.gsub(Options, "(Flare1,)", "");
			Options = Options..",bar,Flare1,failimmediate";
		elseif val == "Flare2" then
			Options = string.gsub(Options, "(bar,)", "");
			Options = string.gsub(Options, "(Flare2,)", "");
			Options = Options..",bar,Flare2,failimmediate";
		elseif val == "Flare3" then
			Options = string.gsub(Options, "(bar,)", "");
			Options = string.gsub(Options, "(Flare3,)", "");
			Options = Options..",bar,Flare3,failimmediate";
		elseif val == "Flare4" then
			Options = string.gsub(Options, "(bar,)", "");
			Options = string.gsub(Options, "(Flare4,)", "");
			Options = Options..",bar,Flare4,failimmediate";
		elseif val == "Flare5" then
			Options = string.gsub(Options, "(bar,)", "");
			Options = string.gsub(Options, "(Flare5,)", "");
			Options = Options..",bar,Flare5,failimmediate";
		elseif val == "Flare6" then
			Options = string.gsub(Options, "(bar,)", "");
			Options = string.gsub(Options, "(Flare6,)", "");
			Options = Options..",bar,Flare6,failimmediate";
		elseif val == "Flare7" then
			Options = string.gsub(Options, "(bar,)", "");
			Options = string.gsub(Options, "(Flare7,)", "");
			Options = Options..",bar,Flare7,failimmediate";
		elseif val == "Flare8" then
			Options = string.gsub(Options, "(bar,)", "");
			Options = string.gsub(Options, "(Flare8,)", "");
			Options = Options..",bar,Flare8,failimmediate";
		elseif val == "Flare9" then
			Options = string.gsub(Options, "(bar,)", "");
			Options = string.gsub(Options, "(Flare9,)", "");
			Options = Options..",bar,Flare9,failimmediate";
		elseif val == "FlareEX" then
			Options = string.gsub(Options, "(bar,)", "");
			Options = string.gsub(Options, "(FlareEX,)", "");
			Options = Options..",bar,FlareEX,failimmediate";
		elseif val == "FloatingFlare" then
			Options = string.gsub(Options, "(bar,)", "");
			Options = string.gsub(Options, "(FloatingFlare,)", "");
			Options = Options..",bar,FloatingFlare,failimmediate";
		else
			Options = string.gsub(Options, "(battery,)", "");
		end;
		
		if player=="PlayerNumber_P1" then
			GAMESTATE:GetPlayerState('PlayerNumber_P1'):SetPlayerOptions('ModsLevel_Preferred',Options);
		else
			GAMESTATE:GetPlayerState('PlayerNumber_P2'):SetPlayerOptions('ModsLevel_Preferred',Options);
		end
		
	end
end


 function ReadOrCreateGameplayMeterTypeForPlayer(PlayerUID, MyValue)
	local File = RageFileUtil:CreateRageFile()
	if File:Open("Save/GameplayMeterType/"..PlayerUID..".txt",1) then
		local str = File:Read();
		MyValue =str;
	else
		File:Open("Save/GameplayMeterType/"..PlayerUID..".txt",2);
		File:Write("Normal");
		MyValue="Normal";
	end
	File:Close();
	return MyValue;
end

function SaveGameplayMeterTypeForPlayer( PlayerUID, MyValue)
	local File = RageFileUtil:CreateRageFile();
	File:Open("Save/GameplayMeterType/"..PlayerUID..".txt",2);
	File:Write(tostring(MyValue));
	File:Close();
end

function SaveAppearancePluShowForPlayer( PlayerUID, MyValue)

	local AppearancePlusShowFile = RageFileUtil:CreateRageFile();
	AppearancePlusShowFile:Open("Save/AppearancePlusShow/"..PlayerUID..".txt",2);
	AppearancePlusShowFile:Write(tostring(MyValue));
	AppearancePlusShowFile:Close();
end

function ReadOrCreateAppearancePluShowForPlayer(PlayerUID, MyValue)
	local AppearancePlusShowFile = RageFileUtil:CreateRageFile()
	if AppearancePlusShowFile:Open("Save/AppearancePlusShow/"..PlayerUID..".txt",1) then 
		local str = AppearancePlusShowFile:Read();
		MyValue =str;
	else
		AppearancePlusShowFile:Open("Save/AppearancePlusShow/"..PlayerUID..".txt",2);
		AppearancePlusShowFile:Write("Show");
		MyValue="Show";
	end
	AppearancePlusShowFile:Close();
	return MyValue;
end


function ReadOrCreateAppearancePlusCoverPosForPlayer(PlayerUID, MyValue)
	local AppearancePlusCoverPosFile = RageFileUtil:CreateRageFile()
	if AppearancePlusCoverPosFile:Open("Save/AppearancePlusCoverPos/"..PlayerUID..".txt",1) then 
		local str = AppearancePlusCoverPosFile:Read();
		MyValue =str;
	else
		AppearancePlusCoverPosFile:Open("Save/AppearancePlusCoverPos/"..PlayerUID..".txt",2);
		AppearancePlusCoverPosFile:Write("0");
		MyValue="0";
	end
	AppearancePlusCoverPosFile:Close();
	return MyValue;
end

function SaveAppearancePlusCoverPosForPlayer( PlayerUID, MyValue)

	local AppearancePlusCoverPosFile = RageFileUtil:CreateRageFile();
	AppearancePlusCoverPosFile:Open("Save/AppearancePlusCoverPos/"..PlayerUID..".txt",2);
	AppearancePlusCoverPosFile:Write(tostring(MyValue));
	AppearancePlusCoverPosFile:Close();
end

function InitCoverPos(self, player, CoverPosition, pos, Mode, TwoCoverMode)
	if not GAMESTATE:IsCourseMode() then
		local PlayerUID = PROFILEMAN:GetProfile(player):GetGUID(); 
		(cmd(zoom,0.667;x,pos;y,SCREEN_CENTER_Y;))(self);
		local selfy = tonumber(ReadOrCreateAppearancePlusCoverPosForPlayer(PlayerUID,CoverPosition));
		
		if TwoCoverMode then --Hidden+&Sudden+
			if selfy > 0 then
				selfy = 0;
			end
		end
		
		local CourseSongTrailHasReverse = false; --If Course Song Has Reverse Modifier
		if GAMESTATE:IsCourseMode() then
			local EntryModifierString = GAMESTATE:GetCurrentTrail(player):GetTrailEntry(GAMESTATE:GetCourseSongIndex()):GetNormalModifiers();
			if string.find(string.lower(EntryModifierString),"reverse") then
				CourseSongTrailHasReverse = true;
			end
		end
		
		local OptionString = "";
		if player=="PlayerNumber_P1" then
			OptionString = OptionsP1P;
		else
			OptionString = OptionsP2P;
		end
		
		if string.find(string.lower(OptionString),"reverse") or CourseSongTrailHasReverse then
			
			if Mode == "Hidden+" then
				self:y(SCREEN_CENTER_Y+SCREEN_HEIGHT/2-32-selfy)
			elseif Mode == "Sudden+" then
				self:y(SCREEN_CENTER_Y-SCREEN_HEIGHT/2+selfy)
			end
		else
			self:zoomy(0.667);
			if Mode == "Hidden+" then
				self:y(SCREEN_CENTER_Y-SCREEN_HEIGHT/2+selfy)
			elseif Mode == "Sudden+" then
				self:y(SCREEN_CENTER_Y+SCREEN_HEIGHT/2-32-selfy)
			end
		end;
	end;
end

function ControlCoverPos(self, params, player, CoverPosition, Mode, TwoCoverMode)
	if params.PlayerNumber == player then
		local PlayerUID = PROFILEMAN:GetProfile(player):GetGUID(); 
		
		
		if string.find(params.Name,"AppearancePlusShow") then
			local MyValue= "Show";
			MyValue = ReadOrCreateAppearancePluShowForPlayer(PlayerUID, MyValue);
			
			if TwoCoverMode then --TwoCoverMode with 2-step handle.
				if MyValue == "Show" then
					self:diffusealpha(0);
					MyValue = "Show-1";
				elseif  MyValue == "Show-1" then
					self:diffusealpha(0);
					MyValue = "Hidden";
				elseif MyValue == "Hidden" then
					MyValue= "Hidden-1";
					self:diffusealpha(1);
				elseif MyValue == "Hidden-1" then
					MyValue= "Show";
					self:diffusealpha(1);
				end;
			else
				if MyValue == "Show" or MyValue == "Show-1" then
					self:diffusealpha(0);
					MyValue = "Hidden";
				elseif MyValue == "Hidden" or MyValue == "Hidden-1" then
					MyValue= "Show";
					self:diffusealpha(1);
				end;
			end
				
			SaveAppearancePluShowForPlayer( PlayerUID, MyValue);
			return;
		end;
		
		local yDelta = 0;
		if TwoCoverMode then --Hidden+&Sudden+
			if params.Name == "AppearancePlusHarsher" then
				yDelta = 5;
			elseif params.Name == "AppearancePlusEasier" then
				yDelta = -5;
			elseif params.Name == "AppearancePlusHarsherMore" then
				yDelta = 25;	
			elseif params.Name == "AppearancePlusEasierMore" then
				yDelta = -25;	
			end;

		else
			if params.Name == "AppearancePlusHarsher" then
				yDelta = 10;
			elseif params.Name == "AppearancePlusEasier" then
				yDelta = -10;
			elseif params.Name == "AppearancePlusHarsherMore" then
				yDelta = 50;	
			elseif params.Name == "AppearancePlusEasierMore" then
				yDelta = -50;	
			end;
		end
		
		self:diffusealpha(1);
		
		local selfy = tonumber(ReadOrCreateAppearancePlusCoverPosForPlayer(PlayerUID,CoverPosition));
		selfy = selfy+yDelta;
		
		if TwoCoverMode then --Hidden+&Sudden+
			if selfy >0 then 
				selfy = 0
			elseif selfy < -SCREEN_HEIGHT/2 then
				selfy = -SCREEN_HEIGHT/2
			end;
		else
			if selfy >SCREEN_HEIGHT/2 then 
				selfy = SCREEN_HEIGHT/2
			elseif selfy < -SCREEN_HEIGHT/2 then
				selfy = -SCREEN_HEIGHT/2
			end;
		end	
		self:linear(0.1);
		
		
		local CourseSongTrailHasReverse = false; --If Course Song Has Reverse Modifier
		if GAMESTATE:IsCourseMode() then
			local EntryModifierString = GAMESTATE:GetCurrentTrail(player):GetTrailEntry(GAMESTATE:GetCourseSongIndex()):GetNormalModifiers();
			if string.find(string.lower(EntryModifierString),"reverse") then
				CourseSongTrailHasReverse = true;
			end
		end
		
		local OptionString = "";
		if player=="PlayerNumber_P1" then
			OptionString = OptionsP1P;
		else
			OptionString = OptionsP2P;
		end
		
		if string.find(string.lower(OptionString),"reverse") or CourseSongTrailHasReverse then
			if Mode == "Hidden+" then
				self:y(SCREEN_HEIGHT-32-selfy);
			elseif Mode == "Sudden+" then
				self:y(selfy);
			end
		else
			if Mode == "Hidden+" then
				self:y(selfy);
			elseif Mode == "Sudden+" then
				self:y(SCREEN_HEIGHT-32-selfy);
			end
		end;
		SaveAppearancePlusCoverPosForPlayer(PlayerUID,selfy)
	end;
end

function SongChangeCoverPos(self, player, CoverPosition, pos, Mode, TwoCoverMode, FileName)
	if GAMESTATE:IsCourseMode() then
		local PlayerUID = PROFILEMAN:GetProfile(player):GetGUID(); 
		(cmd(zoom,0.667;x,pos;y,SCREEN_CENTER_Y))(self);
		local selfy = tonumber(ReadOrCreateAppearancePlusCoverPosForPlayer(PlayerUID,CoverPosition));
		
		if TwoCoverMode then --Hidden+&Sudden+
			if selfy > 0 then
				selfy = 0;
			end
		end
		
		local CourseSongTrailHasReverse = false; --If Course Song Has Reverse Modifier
		if GAMESTATE:IsCourseMode() then
			local EntryModifierString = GAMESTATE:GetCurrentTrail(player):GetTrailEntry(GAMESTATE:GetCourseSongIndex()):GetNormalModifiers();
			if string.find(string.lower(EntryModifierString),"reverse") then
				CourseSongTrailHasReverse = true;
			end
		end
		
		local OptionString = "";
		if player=="PlayerNumber_P1" then
			OptionString = OptionsP1P;
		else
			OptionString = OptionsP2P;
		end
	
	
		if string.find(string.lower(OptionString),"reverse") or CourseSongTrailHasReverse then
			
			if Mode == "Hidden+" then
				self:y(SCREEN_CENTER_Y+SCREEN_HEIGHT/2-32-selfy)
			elseif Mode == "Sudden+" then
				self:y(SCREEN_CENTER_Y-SCREEN_HEIGHT/2+selfy)
			end
		else
			self:zoomy(0.667);
			if Mode == "Hidden+" then
				self:y(SCREEN_CENTER_Y-SCREEN_HEIGHT/2+selfy)
			elseif Mode == "Sudden+" then
				self:y(SCREEN_CENTER_Y+SCREEN_HEIGHT/2-32-selfy)
			end
		end;
	end;
end


function AddCoverLayer(FileName, player, CoverPosition, pos, Mode, TwoCoverMode)
	t[#t+1] = LoadActor(FileName)..{
		InitCommand=function(self)
			InitCoverPos(self, player, CoverPosition, pos, Mode, TwoCoverMode);
		end;
		CodeMessageCommand = function(self, params)
			retrieveMeterType();
			SetGameplayMeterType(player);
			ControlCoverPos(self, params, player, CoverPosition, Mode, TwoCoverMode);
		end;
		CurrentSongChangedMessageCommand=function(self)
			SongChangeCoverPos(self, player, CoverPosition, pos, Mode, TwoCoverMode, FileName);
		end;
		
		OffCommand=function(self) end;
		
		HealthStateChangedMessageCommand=function(self, param)
			if param.PlayerNumber == player then
				if param.HealthState == "HealthState_Dead" then
					self:visible(false);
				else
					self:visible(true);
				end
			end;
		end;
	};
end

function AppearancePlusMain(pn)
	local player = pn;
	local pNum = (player == PLAYER_1) and 1 or 2
	local OptionString = (player == PLAYER_1)  and OptionsP1P or OptionsP2P;
	local PlayerUID = PROFILEMAN:GetProfile(player):GetGUID()  
	local CoverPosition = 0;
	
	local pos = SCREEN_CENTER_X;
	if center1P then
		pos = SCREEN_CENTER_X
	else
		local metricName = string.format("PlayerP%i%sX",pNum,styleType)
		pos = THEME:GetMetric("ScreenGameplay",metricName)
	end
	
	local MyValue = ReadOrCreateAppearancePlusValueForPlayer(PlayerUID,MyValue);
	
	if MyValue == "Hidden" then
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Stealth,)", "");
		OptionString = string.gsub(OptionString, "(SuddenOffset,)", "");
		OptionString = OptionString..', Hidden,';
	elseif MyValue == "Sudden" then	
		OptionString = string.gsub(OptionString, "(Stealth,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		OptionString = string.gsub(OptionString, "(SuddenOffset,)", "");
		OptionString = OptionString..', Sudden,';
	elseif MyValue == "Stealth" then
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		OptionString = string.gsub(OptionString, "(SuddenOffset,)", "");
		OptionString = OptionString..', Stealth,';
	elseif MyValue == "Constant" then
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		OptionString = string.gsub(OptionString, "(SuddenOffset,)", "");
		OptionString = OptionString..', Sudden,100% SuddenOffset';
	elseif MyValue == "Hidden+" then
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Stealth,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		OptionString = string.gsub(OptionString, "(SuddenOffset,)", "");
		if GAMESTATE:GetCurrentStyle():GetStepsType()=="StepsType_Dance_Single" then
			if not GAMESTATE:PlayerIsUsingModifier(player,'reverse') then
				AddCoverLayer(SingleGraphic, player, CoverPosition, pos, "Hidden+",false);
			else
				AddCoverLayer(SingleGraphic, player, CoverPosition, pos, "Hidden+",false);
			end
		elseif GAMESTATE:GetCurrentStyle():GetStepsType()=="StepsType_Dance_Double" then
			if not GAMESTATE:PlayerIsUsingModifier(player,'reverse') then
				AddCoverLayer(DoubleGraphic, player, CoverPosition, pos, "Hidden+",false);
			else
				AddCoverLayer(DoubleGraphic, player, CoverPosition, pos, "Hidden+",false);
			end
		end
	elseif MyValue == "Sudden+" then
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Stealth,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		OptionString = string.gsub(OptionString, "(SuddenOffset,)", "");
		if GAMESTATE:GetCurrentStyle():GetStepsType()=="StepsType_Dance_Single" then
			if not GAMESTATE:PlayerIsUsingModifier(player,'reverse') then
				AddCoverLayer(SingleGraphic, player, CoverPosition, pos, "Sudden+",false);
			else
				AddCoverLayer(SingleGraphic, player, CoverPosition, pos, "Sudden+",false);
			end
		elseif GAMESTATE:GetCurrentStyle():GetStepsType()=="StepsType_Dance_Double" then
			if not GAMESTATE:PlayerIsUsingModifier(player,'reverse') then
				AddCoverLayer(DoubleGraphic, player, CoverPosition, pos, "Sudden+",false);
			else
				AddCoverLayer(DoubleGraphic, player, CoverPosition, pos, "Sudden+",false);
			end
		end
	elseif MyValue == "Hidden+&Sudden+" then
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Stealth,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		if GAMESTATE:GetCurrentStyle():GetStepsType()=="StepsType_Dance_Single" then
			if not GAMESTATE:PlayerIsUsingModifier(player,'reverse') then
				AddCoverLayer(SingleGraphic, player, CoverPosition, pos, "Hidden+",true);
				CoverPosition = 0;
				AddCoverLayer(SingleGraphic, player, CoverPosition, pos, "Sudden+",true);
			else
				AddCoverLayer(SingleGraphic, player, CoverPosition, pos, "Sudden+",true);
				CoverPosition = 0;
				AddCoverLayer(SingleGraphic, player, CoverPosition, pos, "Hidden+",true);
			end
		elseif GAMESTATE:GetCurrentStyle():GetStepsType()=="StepsType_Dance_Double" then
			if not GAMESTATE:PlayerIsUsingModifier(player,'reverse') then
				AddCoverLayer(DoubleGraphic, player, CoverPosition, pos, "Hidden+",true);
				CoverPosition = 0;
				AddCoverLayer(DoubleGraphic, player, CoverPosition, pos, "Sudden+",true);
			else
				AddCoverLayer(DoubleGraphic, player, CoverPosition, pos, "Sudden+",true);
				CoverPosition = 0;
				AddCoverLayer(DoubleGraphic, player, CoverPosition, pos, "Hidden+",true);
			end
		end
	else
		OptionString = string.gsub(OptionString, "(Sudden,)", "");
		OptionString = string.gsub(OptionString, "(Stealth,)", "");
		OptionString = string.gsub(OptionString, "(Hidden,)", "");
		OptionString = string.gsub(OptionString, "(SuddenOffset,)", "");
	end
	return OptionString;
	
end;

local button = {}
local function AppearancePlusSound(event)
	local pn= event.PlayerNumber
	if event.type ~= "InputEventType_FirstPress" then return end
	if button[event.button] and GAMESTATE:IsPlayerEnabled(pn) then
		button[event.button]:play()
	end
end

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local PlayerUID = PROFILEMAN:GetProfile(pn):GetGUID()
	local MyValue = ReadOrCreateAppearancePlusValueForPlayer(PlayerUID,MyValue);
		if MyValue == "Hidden+" or MyValue == "Sudden+" or MyValue == "Hidden+&Sudden+" then
			t[#t+1] = Def.ActorFrame{
			Def.Sound{
				File = THEME:GetPathS("","HiddenPlusShow"), InitCommand = function(self)
					button.Start = self
				end
			},
			Def.ActorFrame{
				OnCommand= function(self)
					SCREENMAN:GetTopScreen():AddInputCallback(AppearancePlusSound)
				end
			}
		};
	end;
end;


retrieveMeterType();
 
--Lock SpeedMod when Oni Course has SpeepMod in course file
if GAMESTATE:GetPlayMode()=="PlayMode_Oni" then
	local curTrailP1 = {}
	local curTrailP2 = {}
	local trailHasSpeedMod = false;
	local trailHasAppearanceMode = false;
	
	if  GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
		curTrailP1 = GAMESTATE:GetCurrentTrail('PlayerNumber_P1'):GetTrailEntries();
		local temp=#curTrailP1;
		
		if curTrailP1[1] then
			for i=1,temp do
				local modString = curTrailP1[temp]:GetNormalModifiers();
				if string.find(modString,"x") or string.find(modString,"X") then
					trailHasSpeedMod = true;
				end
				if string.find(modString,"Hidden") or string.find(modString,"Sudden")  or string.find(modString,"Stealth") then
					trailHasAppearanceMode = true;
				end
			end
		end
	end
	if  GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
		curTrailP1 = GAMESTATE:GetCurrentTrail('PlayerNumber_P2'):GetTrailEntries();
		local temp=#curTrailP2;
		
		if curTrailP2[1] then
			for i=1,temp do
				local modString = curTrailP2[temp]:GetNormalModifiers();
				if string.find(modString,"x") or string.find(modString,"X") then
					trailHasSpeedMod = true;
				end
				if string.find(modString,"Hidden") or string.find(modString,"Sudden")  or string.find(modString,"Stealth") then
					trailHasAppearanceMode = true;
				end
			end
		end
	end
	
	if not trailHasAppearanceMode then
		if	GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
			OptionsP1P = AppearancePlusMain('PlayerNumber_P1');
		end
		if	GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
			OptionsP2P = AppearancePlusMain('PlayerNumber_P2');
		end
	end	

else

	if	GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
		OptionsP1P = AppearancePlusMain('PlayerNumber_P1');
		RecordGameplayMeterType('PlayerNumber_P1')
	end
	if	GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
		OptionsP2P = AppearancePlusMain('PlayerNumber_P2');
		RecordGameplayMeterType('PlayerNumber_P2')
	end

end

--local OptionsP1Song = GAMESTATE:GetPlayerState('PlayerNumber_P1'):GetPlayerOptionsString('ModsLevel_Song');

  --Options Hack
  

if GAMESTATE:GetPlayMode()=="PlayMode_Oni" then
	
	if	GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
		if GAMESTATE:GetCurrentTrail('PlayerNumber_P1'):GetDifficulty() == "Difficulty_Hard" then
			OptionsP1P = OptionsP1P..',battery,4 lives,failimmediate';
		else
			OptionsP1P = OptionsP1P..',battery,8 lives,failimmediate';
		end
	end
	
	if	GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
		if GAMESTATE:GetCurrentTrail('PlayerNumber_P2'):GetDifficulty() == "Difficulty_Hard" then
			OptionsP2P = OptionsP2P..',battery,4 lives,failimmediate';
		else
			OptionsP2P = OptionsP2P..',battery,8 lives,failimmediate';
		end
	end
	
	GAMESTATE:SetFailTypeExplicitlySet();
 end

--ApplyOptions

-- LET'S CHECK YOUR LEVEL! has its own "lifebar" that doesn't decrease.
if not GAMESTATE:IsCourseMode() then
	if GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "LET'S CHECK YOUR LEVEL!" or
	GAMESTATE:GetCurrentSong():GetDisplayFullTitle() == "Steps to the Star" then
		GAMESTATE:GetPlayerState('PlayerNumber_P1'):SetPlayerOptions('ModsLevel_Preferred',OptionsP1P..",1x,bar,lets-check-your-level,failoff");
		GAMESTATE:GetPlayerState('PlayerNumber_P2'):SetPlayerOptions('ModsLevel_Preferred',OptionsP2P..",1x,bar,lets-check-your-level,failoff");
	else
		GAMESTATE:GetPlayerState('PlayerNumber_P1'):SetPlayerOptions('ModsLevel_Preferred',OptionsP1P);
		GAMESTATE:GetPlayerState('PlayerNumber_P2'):SetPlayerOptions('ModsLevel_Preferred',OptionsP2P);
	end
end

-- Dan courses use their own lifebar.
-- It appears to be buggy. Only O.K. recover life, Goods reduce life (I didn't think I coded it like FLARE?)
if GAMESTATE:IsCourseMode() then
	if string.find(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle():lower(), "dan") or 
	   string.find(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle():lower(), "kaiden") or
	   string.find(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle(), "段") or
	   string.find(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle(), "皆伝") then
		GAMESTATE:GetPlayerState('PlayerNumber_P1'):SetPlayerOptions('ModsLevel_Preferred',OptionsP1P..",bar,class,failimmediate");
		GAMESTATE:GetPlayerState('PlayerNumber_P2'):SetPlayerOptions('ModsLevel_Preferred',OptionsP1P..",bar,class,failimmediate");
	else
		GAMESTATE:GetPlayerState('PlayerNumber_P1'):SetPlayerOptions('ModsLevel_Preferred',OptionsP1P..",bar,normal-drain,failimmediate");
		GAMESTATE:GetPlayerState('PlayerNumber_P2'):SetPlayerOptions('ModsLevel_Preferred',OptionsP1P..",bar,normal-drain,failimmediate");
	end
end

return t;
