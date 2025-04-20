function ThemeManager:GetAbsolutePath(sPath, optional)
	local sFinPath = self:GetCurrentThemeDirectory().."/"..sPath
	if not optional then
		assert(FILEMAN:DoesFileExist(sFinPath), "the theme element "..sPath.." is missing")
	end
	return sFinPath
end

function GetJacketPath(item, fallback) 
	if item:HasJacket() then
		return item:GetJacketPath()
	elseif item:HasBackground() then
		return item:GetBackgroundPath()
	elseif item:HasBanner() then
		return item:GetBannerPath()
	else
		return fallback or THEME:GetPathG("Common","fallback jacket")
	end
end

function Sprite:_LoadSCJacket(...)
	return self:Load(GetJacketPath(...))
end

function SameDiffSteps(song, pn)
    if song then
		local diff = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
		local st = GAMESTATE:GetCurrentStyle():GetStepsType();
		return song:GetOneSteps(st, diff);
	end;
end;

function MachineOrProfile(pn)
	if PROFILEMAN:IsPersistentProfile(pn) then
		return PROFILEMAN:GetProfile(pn)
	else
		return PROFILEMAN:GetMachineProfile()
	end
end

function ReadOrCreateAppearancePlusValueForPlayer(PlayerUID, MyValue)
	local AppearancePlusFile = RageFileUtil:CreateRageFile()
	if AppearancePlusFile:Open("Save/AppearancePlus/"..PlayerUID..".txt",1) then 
		local str = AppearancePlusFile:Read();
		MyValue =str;
	else
		AppearancePlusFile:Open("Save/AppearancePlus/"..PlayerUID..".txt",2);
		AppearancePlusFile:Write("Visible");
		MyValue="Visible";
	end
	AppearancePlusFile:Close();
	return MyValue;
end

function SaveAppearancePlusValueForPlayer( PlayerUID, MyValue)
	local AppearancePlusFile2 = RageFileUtil:CreateRageFile();
	AppearancePlusFile2:Open("Save/AppearancePlus/"..PlayerUID..".txt",2);
	AppearancePlusFile2:Write(tostring(MyValue));
	AppearancePlusFile2:Close();
end

function ScreenGameplay_P1X()
	local st = GAMESTATE:GetCurrentStyle():GetStepsType();
	if st == "StepsType_Dance_Solo" then
		return SCREEN_CENTER_X;
	elseif st == "StepsType_Dance_Couple" then
		return WideScale(SCREEN_CENTER_X-180,SCREEN_CENTER_X-160);
	else
		return WideScale(SCREEN_CENTER_X-180,SCREEN_CENTER_X-240);
	end
end
function ScreenGameplay_P2X()
	local st = GAMESTATE:GetCurrentStyle():GetStepsType();
	if st == "StepsType_Dance_Solo" then
		return SCREEN_CENTER_X;
	elseif st == "StepsType_Dance_Couple" then
		return WideScale(SCREEN_CENTER_X+180,SCREEN_CENTER_X+160);
	else
		return WideScale(SCREEN_CENTER_X+180,SCREEN_CENTER_X+240);
	end
end

function GetSongName(item)
	local name = Basename(item:GetSongDir())
	--DDR 5thMIX
	if name == "MATSURI JAPAN" then
		return "祭 JAPAN"
	--DDRMAX
	elseif name == "Healing Vision~Angelic mix~"
		or name == "Healing Vision (Angelic mix)" then
		return "Healing Vision ～Angelic mix～"
	elseif name == "ORION.78(civilization mix)" then
		return "ORION.78～civilization mix～"
	--DDRMAX2
	elseif name == "MATSURI JAPAN (FROM NONSTOP MEGAMIX)" then
		return "祭 JAPAN (FROM NONSTOP MEGAMIX)"
	elseif name == "MATSURI JAPAN (K.O.G REMIX)" then
		return "祭 JAPAN (K.O.G REMIX)"
	elseif name == "BREAK DOWN!" then
		return "BRE∀K DOWN！"
	elseif name == "BURNING HEAT! (3 Option MIX)" then
		return "BURNING HEAT！（3 Option MIX）"
	--DDR EXTREME
	elseif name == "AM-3P (303 BASS MIX)" then
		return "AM-3P -303 BASS MIX-"
	elseif name == "Colors (for EXTREME)" then
		return "Colors ～for EXTREME～"
	elseif name == "Frozen Ray(for EXTREME)" then
		return "Frozen Ray ～for EXTREME～"
	elseif name == "SENORITA(Speedy Mix)" then
		return "SENORITA(Speedy Mix)"
	--DDR SuperNOVA
	elseif name == "MATSURI (J-SUMMER MIX)" then
		return "祭 (J-SUMMER MIX)"
	elseif name == "Fascination -eternal love mix-" then
		return "Fascination ～eternal love mix～"
	--DDR SuperNOVA2
	elseif name == "PARANOiA (HADES)" then
		return "PARANOiA ～HADES～"
	--DDR X
	elseif name == "Beautiful Inside (Cube Hard Mix)" then
		return "Beautiful Inside (Cube∷Hard Mix)"
	elseif name == "SABER WING (AKIRA ISHIHARA Headshot mix)" then
		return "SABER WING (Akira Ishihara Headshot mix)"
	--DDR X2
	elseif name == "IF YOU WERE HERE (L.E.D.-G STYLE REMIX)" then
		return "IF YOU WERE HERE(L.E.D.-G STYLE REMIX)"
	elseif name == "Poseidon (kors k mix)" then
		return "Poseidon(kors k mix)"
	elseif name == "roppongi EVOLVED ver. A" then
		return "roppongi EVOLVED ver.A"
	elseif name == "roppongi EVOLVED ver. B" then
		return "roppongi EVOLVED ver.B"
	elseif name == "roppongi EVOLVED ver. C" then
		return "roppongi EVOLVED ver.C"
	elseif name == "roppongi EVOLVED ver. D" then
		return "roppongi EVOLVED ver.D"
	--DDR X3 VS 2ndMIX
	elseif name == "London EVOLVED Ver.A" then
		return "London EVOLVED ver.A"
	elseif name == "London EVOLVED Ver.B" then
		return "London EVOLVED ver.B"
	elseif name == "London EVOLVED Ver.C" then
		return "London EVOLVED ver.C"
	--DDR A
	elseif name == "OurMemories" then
		return "#OurMemories"
	--DDR A3
	elseif name == "DIABLOSIS Naga" then
		return "DIABLOSIS∷Nāga"
	elseif name == "memory DATAMOSHER" then
		return "ｍｅｍｏｒｙ／／ＤＡＴＡＭＯＳＨＥＲ"
	--DDR XX -STARLiGHT-
	elseif name == "digicerata ~mushisareru koto no utsukushisa~" then
		return "digicerata ～無視されることの美しさ～"
	elseif name == "Mermaid girl -Akiba Koubou MIX-" then
		return "Mermaid girl-秋葉工房 MIX-"
	elseif name == "Poseidon (kors k mix)(XX-Special)" then
		return "Poseidon(kors k mix)(XX-Special)"
	--beatmania IIDX
	elseif name == "CMFLG" then
		return "#CMFLG"
	elseif name == "MAGiCVLGiRL_TRVP_B3VTZ" then
		return "#MAGiCVLGiRL_TRVP_B3VTZ"
	elseif name == "Misogi"
		and item:GetDisplayArtist() == "Nhato" then
		return "禊"
	elseif name == "The_Relentless" then
		return "#The_Relentless"
	--SOUND VOLTEX
	elseif name == "apollioth" then
		return "apo:llioth"
	elseif name == "archive zip" then
		return "archive∷zip"
	elseif name == "EmoCloche" then
		return "#EmoCloche"
	elseif name == "Endroll"
		and item:GetDisplayArtist() == "uno & D.watt (IOSYS TRAX)" then
		return "#Endroll"
	elseif name == "Fairy_dancing_in_lake" then
		return "#Fairy_dancing_in_lake"
	elseif name == "FairyJoke #SDVX_Edit"
		or name == "FairyJoke SDVX_Edit" then
		return "#FairyJoke #SDVX_Edit"
	elseif name == "Namescapes" then
		return "#Namescapes"
	elseif name == "SpeedyCats"
		and item:GetDisplayArtist() == "RoughSketch a.k.a. uno(IOSYS)" then
		return "#SpeedyCats"
	--maimai
	elseif name == "Kurutta minzoku 2 PRAVARGYAZOOQA" then
		return "#狂った民族２ PRAVARGYAZOOQA"
	elseif name == "REINCARNATED DRAGNER" then
		return "RE:INCARNATED DRAGNER"
	--CHUNITHM
	elseif name == "FairyJoke" then
		return "#FairyJoke"
	elseif name == "SUP3RORBITAL" then
		return "#SUP3RORBITAL"
	else
		return item:GetDisplayMainTitle()
	end
end

function GetArtistName(item)
	if item:GetDisplayArtist() == "Unknown artist"
		or item:GetDisplayArtist() == "♪♪♪♪"
		or item:GetDisplayArtist() == "Various artists" then
		return ""
	elseif item:GetDisplayFullTitle() == "VIVID DEBUT!"
		or item:GetDisplayFullTitle() == "EmoCloche"
		or item:GetDisplayFullTitle() == "#EmoCloche"
		or item:GetDisplayFullTitle() == "＃EmoCloche"
		or item:GetDisplayFullTitle() == "Going My Future!"
		or item:GetDisplayFullTitle() == "MiRÀi"
		or item:GetDisplayFullTitle() == "Never Ending Future"
		or item:GetDisplayArtist() == "＃EmoCosine" then
		return "#EmoCosine"
	elseif item:GetDisplayArtist() == "Namescapes"
		or item:GetDisplayArtist() == "＃Namescapes" then
		return "#Namescapes"
	elseif item:GetDisplayArtist() == "NuLogic"
		or item:GetDisplayArtist() == "Nu：Logic" then
		return "Nu:Logic"
	elseif item:GetDisplayArtist() == "工藤吉三 (ベイシスケイプ)" then
		return "工藤吉三（ベイシスケイプ）"
	--DDR EXTREME + DDR X
	elseif item:GetDisplayFullTitle() == "The legend of MAX"
		or item:GetDisplayFullTitle() == "The legend of MAX(X-Special)"
		or item:GetDisplayFullTitle() == "The legend of MAX (X-Special)" then				--Added variant with a space before the subtitle
		return "ZZ"
	--DDR SuperNOVA
	elseif item:GetDisplayFullTitle() == "Under the Sky" then
		return "南さやか（BeForU）with platoniX"
	elseif item:GetDisplayFullTitle() == "You gotta move it (feat. Julie Rugaard)" then
		return "Yuzo Koshiro"
	--DDR A
	elseif item:GetDisplayFullTitle() == "IN BETWEEN" then
		return "BEMANI Sound Team \"L.E.D.-G\" feat. Mayumi Morinaga"
	--DDR WORLD
	elseif item:GetDisplayFullTitle() == "Couleur=Blanche" then
		return "#FFFFFF"
	else
		return item:GetDisplayArtist()
	end
end

--Conditionals

function ComboUnderField()
	if ReadPrefFromFile("OptionRowComboUnderField") ~= nil then
		if GetUserPref("OptionRowComboUnderField") == 'false' then
			return false
		else
			return true
		end
	else
		return true
	end
end

function ShockArrows()
	if GetUserPref("OptionRowShockArrows") == 'true' then
		return true
	else
		return false
	end
end

function GuideLinesP1()
	if getenv("OptionRowGuideLines"..ToEnumShortString(PLAYER_1)) == 'false' then
		return false
	else
		return true
	end
end

function GuideLinesP2()
	if getenv("OptionRowGuideLines"..ToEnumShortString(PLAYER_2)) == 'false' then
		return false
	else
		return true
	end
end

function ShowFastSlow(pn)
	if ReadPrefFromFile("OptionRowFastSlow"..ToEnumShortString(pn)) ~= nil then
		if GetUserPref("OptionRowFastSlow"..ToEnumShortString(pn)) == 'Off' then
			return false
		else
			return true
		end
	else
		return true
	end
end

function SpeedDisplay()
	if ReadPrefFromFile("OptionRowSpeedDisplay") ~= nil then
		if GetUserPref("OptionRowSpeedDisplay")=='On' then
			return true
		else
			return false
		end
	else
		return false
	end
end

function IsEXScore(pn)
	if GetUserPref("OptionRowEXScore"..ToEnumShortString(pn)) == 'On' then
		if GAMESTATE:IsDemonstration() then
			return false
		else
			return true
		end
	else
		return false
	end
end

function IsGoldenLeague()
	if (GoldenLeague() == "Bronze" or GoldenLeague() == "Silver" or GoldenLeague() == "Gold") then
		return true
	else
		return false
	end
end

function ShowBPMDisplay()
	if GetUserPref("OptionRowBPM")=='BPM' then
		if GAMESTATE:IsDemonstration() then
			return false
		else
			return true
		end
	else
		return false
	end
end

--Conditionals

--Screens

function IsTitleMenu()
	local curScreen = Var "LoadingScreen"
	return curScreen == "ScreenTitleMenu"
end

function IsTitleJoin()
	local curScreen = Var "LoadingScreen"
	return curScreen == "ScreenTitleJoin"
end

function IsHowToPlay()
	local curScreen = Var "LoadingScreen"
	return curScreen == "ScreenHowToPlay"
end

function IsLogo()
	local curScreen = Var "LoadingScreen"
	return curScreen == "ScreenLogo"
end

function IsOptionService()
	local curScreen = Var "LoadingScreen"
	return curScreen == "ScreenOptionsService"
end

function IsOptionManageProfiles()
	local curScreen = Var "LoadingScreen"
	return curScreen == "ScreenOptionsManageProfiles"
end

function IsCustomOptions()
	local curScreen = Var "LoadingScreen"
	return curScreen == "ScreenCustomOptions"
end

function IsDataSaveSummary()
	local curScreen = Var "LoadingScreen"
	return curScreen == "ScreenDataSaveSummary"
end

--Screens

--OutFox Fixes

function IsReverse(pn)
	return GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Current'):Reverse() == 1
end

--OutFox Fixes

--Theme Stuff

function Language()
	if GetUserPref("OptionRowLanguage")=='jp' then
		return "jp_"
	elseif GetUserPref("OptionRowLanguage")=='en' then
		return "en_"
	elseif GetUserPref("OptionRowLanguage")=='kor' then
		return "kor_"
	elseif GetUserPref("OptionRowLanguage")=='default' then
		return "jp_"
	end
end

function GetCurrentLanguage()
	if Language() == "jp_" then
		return "Japanese"
	elseif Language() == "en_" then
		return "English"
	elseif Language() == "kor_" then
		return "Korean"
	else
		return "English"
	end
end

function Model()
	if ReadPrefFromFile("OptionRowModel") ~= nil then
		if GetUserPref("OptionRowModel")=='Gold' then
			return "gold_"
		elseif GetUserPref("OptionRowModel")=='White' then
			return "blue_"
		else
			return "gold_"
		end
	else
		return "gold_"
	end
end

function Region()
    if ReadPrefFromFile("OptionRowRegion") ~= nil then
        return GetUserPref("OptionRowRegion")
    else
        return "World"
    end
end

function GetCurrentModel()
	if Model() == "gold_" then
		return "Gold"
	elseif Model() == "blue_" then
		return "Blue"
	else
		return "Gold"
	end
end

function League(pn)
	pName = ToEnumShortString(pn)
	if ReadPrefFromFile("OptionRowGoldenLeague"..pName) ~= nil then
		if GetUserPref("OptionRowGoldenLeague"..pName)=='Bronze' then
			return "brn_" 
		elseif GetUserPref("OptionRowGoldenLeague"..pName)=='Silver' then
			return "slv_"
		elseif GetUserPref("OptionRowGoldenLeague"..pName)=='Gold' then
			return "gld_"
		end
	end
end

function GoldenLeague(pn)
    if not pn then
        -- Define the leagues and their values
        local leagues = {
            ["brn_"] = 1,
            ["slv_"] = 2,
            ["gld_"] = 3
        }

        -- Initialize variables to track the highest value and its corresponding player
        local maxPlayer = PLAYER_1
        local maxLeague = nil
        local maxValue = -math.huge  -- Start with the smallest possible number

        -- Iterate through all enabled players
        for _, player in ipairs(GAMESTATE:GetEnabledPlayers()) do
            -- Get the league for the current player
            local league = League(player)
            
            -- Get the league value from the leagues table
            local leagueValue = leagues[league]

            -- Check if this league value is the highest so far
            if leagueValue and leagueValue > maxValue then
                maxValue = leagueValue
                maxLeague = league
                maxPlayer = player
            end
        end

        -- If a player with the highest league is found, use that player
        if maxPlayer then
            pn = maxPlayer
        else
            return ""
        end
    end

    -- Return the league name based on the player's league
    if League(pn) == "brn_" then
        return "Bronze"
    elseif League(pn) == "slv_" then
        return "Silver"
    elseif League(pn) == "gld_" then
        return "Gold"
	end
end

function DanCourse(pn)
	pName = ToEnumShortString(pn)
	if ReadPrefFromFile("OptionRowDanCourse"..pName) ~= nil then
		if GetUserPref("OptionRowDanCourse"..pName)=='None' then
			return "None" 
		elseif GetUserPref("OptionRowDanCourse"..pName)=='1st' then
			return "Dan 01"
		elseif GetUserPref("OptionRowDanCourse"..pName)=='2nd' then
			return "Dan 02"
		elseif GetUserPref("OptionRowDanCourse"..pName)=='3rd' then
			return "Dan 03"
		elseif GetUserPref("OptionRowDanCourse"..pName)=='4th' then
			return "Dan 04"
		elseif GetUserPref("OptionRowDanCourse"..pName)=='5th' then
			return "Dan 05"
		elseif GetUserPref("OptionRowDanCourse"..pName)=='6th' then
			return "Dan 06"
		elseif GetUserPref("OptionRowDanCourse"..pName)=='7th' then
			return "Dan 07"
		elseif GetUserPref("OptionRowDanCourse"..pName)=='8th' then
			return "Dan 08"
		elseif GetUserPref("OptionRowDanCourse"..pName)=='9th' then
			return "Dan 09"
		elseif GetUserPref("OptionRowDanCourse"..pName)=='10th' then
			return "Dan 10"
		elseif GetUserPref("OptionRowDanCourse")..pName=='Kaiden' then
			return "Kaiden"
		else
			return "None"
		end
	else
		return "None"
	end
end

--Theme Stuff

--Player Options

function OptionNumber()
	if GetUserPref("OptionRowGameplayBackground")=='DanceStages' then
		if GetUserPref("NTOption")=='On' then
			return "Speed,Accel,Appearance,Turn,Hide,Scroll,NoteSkins,Cut,Freeze,Jump,ArrowType,SelectStage,TargetScore,Risky"
		else
			return "Speed,Accel,Appearance,Turn,Hide,Scroll,NoteSkins,Cut,Freeze,Jump,SelectStage,TargetScore,Risky"
		end
	elseif GetUserPref("OptionRowGameplayBackground")=='SNCharacters' then
		if GetUserPref("NTOption")=='On' then
			return "Speed,Accel,Appearance,Turn,Hide,Scroll,NoteSkins,Cut,Freeze,Jump,ArrowType,Characters,TargetScore,Risky"
		else
			return "Speed,Accel,Appearance,Turn,Hide,Scroll,NoteSkins,Cut,Freeze,Jump,Characters,TargetScore,Risky"
		end
	else
		if GetUserPref("NTOption")=='On' then
			return "Speed,Accel,Appearance,Turn,Hide,Scroll,NoteSkins,Cut,Freeze,Jump,ArrowType,TargetScore,Risky"
		else
			return "Speed,Accel,Appearance,Turn,Hide,Scroll,NoteSkins,Cut,Freeze,Jump,TargetScore,Risky"
		end
	end
end

function GetNoteSkinType(pn)
	local Type = ReadPrefFromFile("OptionRowArrowType"..ToEnumShortString(pn)); 
		if Type == "Normal" 			then return "SCH-NORMAL-"
	elseif Type == "Classic" 			then return "SCH-CLASSIC-"
	elseif Type == "Cyber" 				then return "SCH-CYBER-"
	elseif Type == "X" 					then return "SCH-X-"
	elseif Type == "Medium" 			then return "SCH-MEDIUM-"
	elseif Type == "Small" 				then return "SCH-SMALL-"
	elseif Type == "Dot" 				then return "SCH-DOT-"
	else									 return "SCH-NORMAL-"
	end
end

function GetArrowColor(pn)
	local Color = ReadPrefFromFile("OptionRowArrowColor"..ToEnumShortString(pn)); 
		if Color == "Rainbow" 			then return "RAINBOW"
	elseif Color == "Note" 				then return "NOTE"
	elseif Color == "Vivid" 			then return "VIVID"
	elseif Color == "Flat" 				then return "FLAT"
	elseif Color == "SMNote" 			then return "SMNOTE"
	else									 return "RAINBOW"
	end
end

function GetPlayerNoteSkin(pn)
	GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin(GetNoteSkinType(pn)..GetArrowColor(pn))
end

function NoteSkinOption()
	if GetUserPref("NTOption")=='On' then
		return "lua,OptionRowArrowColor()"
	else
		return "list,NoteSkins"
	end
end

function UseStaticBackground()
	if ReadPrefFromFile("OptionRowGameplayBackground") ~= nil then
		if GetUserPref("OptionRowGameplayBackground")=='DanceStages' then
			return false
		else
			return true
		end
	else
		return true
	end
end

--Player Options

function ClearedToLoad()
	if GAMESTATE:GetCurrentSong() == nil then return "CLEARED" end
	local GetSong = GAMESTATE:GetCurrentSong():GetDisplayFullTitle()
	if GetSong == "Tohoku EVOLVED"
	or GetSong == "COVID"
	or GetSong == "Outbreak"
	and GAMESTATE:GetCurrentSong():GetDisplayArtist() == "RG+Ice" then 
		return "PRAY"
	elseif GetSong == "Lesson by DJ"
	or GetSong == "LET'S CHECK YOUR LEVEL!"
	or GetSong == "Steps to the Star" then
		return "ENJOY"
	else
		return "CLEARED"
	end
end

function FilterReadPref(pn) 
	return ReadPrefFromFile("OptionRowScreenFilter"..ToEnumShortString(pn)); 
end

function StreamingMode()
	if GetUserPref("OptionRowBGM")=='Off' then
		return true
	end
end

function StreamingSound(item)
	if GetUserPref("OptionRowBGM")=='Off' then
		return THEME:GetPathS("","_silent")
	else
		return item
	end 
end

function JudgmentZoom()
	if GetUserPref("OptionRowJudgementAnimation")=='Simple' then
		return 0.34
	else
		return 0.37
	end
end

function JudgmentYP()
	if GetUserPref("OptionRowJudgementAnimation")=='Simple' then
		return 0
	else
		return 2
	end
end

function JudgmentYM()
	if GetUserPref("OptionRowJudgementAnimation")=='Simple' then
		return 0
	else
		return -2
	end
end

function ComboAnim()
	if GetUserPref("OptionRowJudgementAnimation")=='Simple' then
		return 1
	else
		return 1.297
	end
end

function MenuTimer()
	local TimerNumbers = THEME:GetAbsolutePath("Fonts/MenuTimer numbers.redir")
	local file = RageFileUtil.CreateRageFile()

	if GetCurrentModel() == "Blue" then
		file:Open(TimerNumbers,2)
		file:Write("BlueTimerNumbers")
		file:Close()
		file:destroy()
	else
		file:Open(TimerNumbers,2)
		file:Write("GoldTimerNumbers")
		file:Close()
		file:destroy()
	end
end

function SelectMusicBGM()
	local Music = THEME:GetAbsolutePath("Sounds/ScreenSelectMusic music (loop).redir")
	local file = RageFileUtil.CreateRageFile()

	
	if GetUserPref("OptionRowBGM")=='Off' then
		file:Open(Music,2)
		file:Write("_silent")
		file:Close()
		file:destroy()
	else
		file:Open(Music,2)
		file:Write("02 - SelectMusic (loop)")
		file:Close()
		file:destroy()
	end
end

function BackgroundInit()
	if GetCurrentModel() == "Blue" then
		return THEME:GetPathG("","_doors/init_green")
	else
		return THEME:GetPathG("","_doors/init_purple")
	end
end

function BackgroundEntry()
	if GetCurrentModel() == "Blue" then
		return THEME:GetPathG("","_doors/background_green")
	else
		return THEME:GetPathG("","_doors/background_purple")
	end
end

function BackgroundCleared()
	if GetCurrentModel() == "Blue" then
		return THEME:GetPathG("","_doors/cleared_green")
	else
		return THEME:GetPathG("","_doors/cleared_blue")
	end
end


GoldenLeagueSong = {
	--DDR A20
	["Avenger"] = "league"; 								--1st 
	["New Era"] = "league";									--2nd
	["Give Me"] = "league";									--3rd
	["Ace out"] = "league"; 								--4th
	["The World Ends Now"] = "league";						--5th
	["Rampage Hero"] = "league";							--6th
	["ALPACORE"] = "league";								--7th
	["Starlight in the Snow"] = "league";					--8th
	["Glitch Angel"] = "league";							--9th
	["Golden Arrow"] = "league";							--10th
	["CyberConnect"] = "league";							--11th
	--DDR A20 PLUS
	["DIGITALIZER"] = "league";								--1st
	["Draw the Savage"] = "league";							--2nd
	["MUTEKI BUFFALO"] = "league";							--3rd
	["Going Hypersonic"] = "league";						--4th
	["Lightspeed"] = "league";								--5th
	["Run The Show"] = "league";							--6th
	["Yuni's Nocturnal Days"] = "league";					--7th
	["Good Looking"] = "league";							--8th
	["Step This Way"] = "league";							--9th
	["Come Back To Me"] = "league";							--10th
	["actualization of self (weaponized)"] = "league";		--11th
	["Better Than Me"] = "league";							--12th
	["DDR TAGMIX -LAST DanceR-"] = "league";				--13th
	["THIS IS MY LAST RESORT"] = "league";					--14th
	--DDR A3
	["STAY GOLD"] = "league";								--1st
	["Teleportation"] = "league";							--2nd
	["Environ [De-SYNC] (feat. lythe)"] = "league";			--3rd
	["Let Me Know"] = "league";								--4th
	["Let Me Show You"] = "league";							--5th
	["Go To The Oasis"] = "league";							--6th
	["TAKE ME HIGHER"] = "league";							--7th
	["Lose Your Sense"] = "league";							--8th
	["Sector"] = "league";									--9th
	["Ability"] = "league";									--10th
	["SURVIVAL AT THE END OF THE UNIVERSE"] = "league";		--11th
	["Jungle Dance"] = "league";							--12th
	["Rave in the Shell"] = "league";						--13th
	["Not Alone"] = "league";								--14th
	["GROOVE 04"] = "league";								--15th
	["Euphoric Fragmentation"] = "league";					--16th
	["Continue to the real world?"] = "league";				--17th
	["9th Outburst"] = "league";							--18th
	["My Drama"] = "league";								--19th
	--DDR WORLD
	["Time to HYPERDRIVE"] = "league";						--1st
	["Is this dance a Hakken?"] = "league";					--2nd
	["access super [hyper] focus"] = "league";				--3rd
	["STOMP!!"] = "league";									--4th
	["まにぃまにあ××"] = "league";								--5th
};

NewSong = {
	-- insert new songs here
}

function IsNewSong(song)
	for ns, _ in pairs(NewSong) do
		if song:GetDisplayFullTitle() == ns then
			return true
		end
	end
	return false
end

function AttackPerfectFullCombo()
	if GAMESTATE:IsExtraStage2() then
		return "TapNoteScore_W2"
	else
		return "TapNoteScore_W4"
	end
end

function JudgmentTransformCommand( self, params )
	local x = 0
	local y = -76
	if params.bReverse then y = 67 end
	self:x( x )
	self:y( y )
end

function ComboTransformCommand( self, params )
	local x = 0
	local y = 38
	if params.bReverse then y = -23 end
	self:x( x )
	self:y( y )
end

function SongMeterDisplayX(pn)
	if Center1Player() then
		return SCREEN_CENTER_X
	else
		return pn == PLAYER_1 and SCREEN_LEFT+16 or SCREEN_RIGHT-16
	end
end

function SongMeterDisplayY(pn)
	return Center1Player() and SCREEN_TOP+50 or SCREEN_CENTER_Y
end

function SongMeterDisplayCommand(pn)
	if Center1Player() then
		return cmd(draworder,50;zoom,0;y,SCREEN_TOP-24;sleep,1.5;decelerate,0.5;zoom,1;y,SCREEN_TOP+50)
	else
		local xAdd = (pn == PLAYER_1) and -24 or 24
		return cmd(draworder,5;rotationz,-90;zoom,0;addx,xAdd;sleep,1.5;decelerate,0.5;zoom,1;addx,xAdd*-1)
	end
end

function IsPlayingWorkout()
	return GAMESTATE:GetEnv("Workout") == "1"
end
	
function WorkoutResetStageStats()
	STATSMAN:Reset()
end

function WorkoutGetProfileGoalType( pn )
	return PROFILEMAN:GetProfile(pn):GetGoalType()
end

function WorkoutGetStageCalories( pn )
	return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetCaloriesBurned()
end

function WorkoutGetTotalCalories( pn )
	return STATSMAN:GetAccumStageStats():GetPlayerStageStats(pn):GetCaloriesBurned()
end

function WorkoutGetTotalSeconds( pn )
	return STATSMAN:GetAccumStageStats():GetGameplaySeconds()
end

function WorkoutGetGoalCalories( pn )
	return PROFILEMAN:GetProfile(pn):GetGoalCalories()
end

function WorkoutGetGoalSeconds( pn )
	return PROFILEMAN:GetProfile(pn):GetGoalSeconds()
end

function WorkoutGetPercentCompleteCalories( pn )
	return WorkoutGetTotalCalories(pn) / WorkoutGetGoalCalories(pn)
end

function WorkoutGetPercentCompleteSeconds( pn )
	return WorkoutGetTotalSeconds(pn) / WorkoutGetGoalSeconds(pn)
end

local numbered_stages= {
	Stage_1st= true,
	Stage_2nd= true,
	Stage_3rd= true,
	Stage_4th= true,
	Stage_5th= true,
	Stage_6th= true,
	Stage_Next= true,
}

function thified_curstage_index(on_eval)
	local cur_stage= GAMESTATE:GetCurrentStage()
	local adjust= 1
	-- hack: ScreenEvaluation shows the current stage, but it needs to show
	-- the last stage instead.  Adjust the amount.
	if on_eval then
		adjust= 0
	end
	if numbered_stages[cur_stage] then
		return FormatNumberAndSuffix(GAMESTATE:GetCurrentStageIndex() + adjust)
	else
		return ToEnumShortString(cur_stage)
	end
end

--Loads the file at path and runs it in the specified environment,
--or an empty one if no environment is provided. Catches any errors that occur.
--Returns false if the called function failed, true and anything else the function returned if it worked
function dofile_safer(path, env)
    env = env or {}
    if not FILEMAN:DoesFileExist(path) then
        --the file doesn't exist
        return false
    end
    local handle = RageFileUtil.CreateRageFile()
    handle:Open(path, 1)
    local code = loadstring(handle:Read(), path)
    handle:Close()
    handle:destroy()
    if not code then
        --an error occurred while compiling the file
        return false
    end
    setfenv(code, env)
    return pcall(code)
end

function CourseModeName()
	if GAMESTATE:GetCurrentStage() > "Stage_1st" and not GAMESTATE:IsEventMode() then
		return ""
	elseif GAMESTATE:IsEventMode() and songsPlayedThisGame > 1 then
		return ""
	else
		return "Course"
	end
end

function CourseModeCommand()
	if GAMESTATE:GetCurrentStage() > "Stage_1st" and not GAMESTATE:IsEventMode() then
		return ""
	elseif GAMESTATE:IsEventMode() and songsPlayedThisGame > 1 then
		return ""
	else
		return "playmode,nonstop;screen,ScreenSelectCourse;setenv,sMode,Extended"
	end
end

function IsDanCourse()
	if GAMESTATE:IsCourseMode() then
		if string.find(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle():lower(), "dan") or 
		string.find(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle():lower(), "kaiden") or
		string.find(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle(), "段") or
		string.find(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle(), "皆伝") then
			return true
		else
			return false
		end
	else
		return false
	end
end

function TimerShift1()
	if GAMESTATE:IsEventMode() then
		return 0
	else
		return 20
	end
end

function TimerShift2()
	if GAMESTATE:IsEventMode() then
		return 0
	else
		return -11
	end
end

function TimerPos1()
	if GAMESTATE:IsEventMode() then
		return 20
	else
		return 0
	end
end

function TimerPos2()
	if GAMESTATE:IsEventMode() then
		return -10
	else
		return 0
	end
end

function LoginTimerPos()
	if GAMESTATE:GetMasterPlayerNumber() == PLAYER_1 then
		return 0
	else
		return 430
	end
end
