local identifier = "MDX"
local region = "J"
local type = "A"
local spec = "A"
local date = 20240522
local revision = 0

function GetBuild() 
	return identifier..":"..region..":"..type..":"..spec..":"..date..string.format("%02d", revision)
end