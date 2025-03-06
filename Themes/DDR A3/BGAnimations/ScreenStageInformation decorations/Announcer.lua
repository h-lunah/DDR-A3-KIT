local Announcer
local previousCourse = nil

if GAMESTATE:IsCourseMode() then
	local mpStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( GAMESTATE:GetMasterPlayerNumber() )
	local songsPlayed = mpStats:GetSongsPlayed() ~= 0 and mpStats:GetSongsPlayed() or 1

	local currentCourse = GAMESTATE:GetCurrentCourse()
	
	if currentCourse ~= previousCourse then
        sStage = "Stage_1st"
        songsPlayed = 1
		previousCourse = currentCourse
    end

	if songsPlayed >= GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() then
		Announcer = "stage 1"
	else
		Announcer = "stage "..songsPlayed
	end


elseif (GAMESTATE:GetCurrentStage() == 'Stage_1st') and not GAMESTATE:IsCourseMode() then
	Announcer = "stage 1"
elseif (GAMESTATE:GetCurrentStage() == 'Stage_2nd') and not GAMESTATE:IsCourseMode() then
	Announcer = "stage 2"
elseif (GAMESTATE:GetCurrentStage() == 'Stage_3rd') and not GAMESTATE:IsCourseMode() then
	Announcer = "stage 3"
elseif (GAMESTATE:GetCurrentStage() == 'Stage_4th') and not GAMESTATE:IsCourseMode() then
	Announcer = "stage 4"
elseif (GAMESTATE:GetCurrentStage() == 'Stage_Final') and not GAMESTATE:IsCourseMode() then
	Announcer = "stage final"
elseif (GAMESTATE:IsExtraStage()) and not GAMESTATE:IsCourseMode() then
	Announcer = "stage extra1"
elseif (GAMESTATE:IsExtraStage2()) and not GAMESTATE:IsCourseMode() then
	Announcer = "stage extra2"
elseif (GAMESTATE:IsEventMode()) and not GAMESTATE:IsCourseMode() then
	if songsPlayedThisGame < 4 then
		Announcer = "stage "..songsPlayedThisGame+1
	else
		Announcer = "stage final"
	end
end

return Def.ActorFrame{
	SOUND:PlayAnnouncer("stage sound X");
	SOUND:PlayAnnouncer(Announcer);
};