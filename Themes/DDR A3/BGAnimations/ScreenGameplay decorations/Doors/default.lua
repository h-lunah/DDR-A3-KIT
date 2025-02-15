local loader
if IsGoldenLeague() then
	loader = "GoldenLeague"
else
	loader = "Normal"
end

local mpStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( GAMESTATE:GetMasterPlayerNumber() )
local songsPlayed = mpStats:GetSongsPlayed()

if GAMESTATE:IsCourseMode() then
	if songsPlayed > GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() then
		songsPlayed = 1
	end
end

return Def.ActorFrame{ 
	Def.ActorFrame{
		OnCommand=function(s) s:queuecommand("Play") end,
		PlayCommand=function(s)
			if GAMESTATE:IsCourseMode() and not IsTransitioning then return end

			local sound = THEME:GetPathS("","DoorOpen")
			SOUND:PlayOnce(StreamingSound(sound)) 
		end,
	};
	LoadActor(loader); 
}