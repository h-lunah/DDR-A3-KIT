local function GetMusic()
    local eng_music = "Lesson by DJ (English).ogg"
    local jpn_music = "Lesson by DJ (Japanese).ogg"

    if Language() ~= "jp_" then
        return eng_music
    else
        return jpn_music
    end
end

return Def.ActorFrame{
    Def.Sound{
        File=GetMusic(),
        OnCommand=function(self)
            self:sleep(1/60):play()
        end,
    }
}