local identifier = "MDX"
local region = "J"
local type = "A"
local spec = "A"
local date = "20240522"
local revision = "00"

return Def.BitmapText{
    Font="_futura pt medium 30px";
    InitCommand=function(s)  
		--         MDX:A:A:A:Year/Month/Day/00
		s:settext(identifier..":"..region..":"..type..":"..spec..":"..date..revision)
		s:xy(SCREEN_LEFT+64.2,SCREEN_TOP+8.5)
		s:zoomx(0.42)
		s:zoomy(0.4)
		s:strokecolor(color("0,0,0,0.5")) 
	end,
};
