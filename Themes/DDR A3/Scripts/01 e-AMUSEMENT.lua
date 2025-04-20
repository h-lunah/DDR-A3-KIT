local lastChecked = 0
local checkInterval = 5
local cachedResult = false
local completed = false

function IsNetConnected()
    local now = GetTimeSinceStart()
    if now - lastChecked < checkInterval then
        return cachedResult
    end
    
    lastChecked = now
    
    -- This package may not always be available.
    if type(io) ~= "table" or type(io.popen) ~= "function" then
        lua.ReportScriptError("expected to find io, got "..type(io))
        cachedResult = true
        return cachedResult
    elseif type(package) ~= "table" then
        lua.ReportScriptError("expected to find package, got "..type(package))
        cachedResult = true
        return cachedResult
    end

    local isWindows = package.config:sub(1,1) == "\\"
    local pingCommand = isWindows and "ping -n 1 1.1.1.1 >nul 2>&1" or "ping -c 1 1.1.1.1 >/dev/null 2>&1"
    
    if isWindows and completed then return cachedResult end

    local p = assert(io.popen("command"))
    local out = p:read("*a")
    p:close()

    local lines = {}
    for line in out:gmatch("[^\r\n+]") do
        table.insert(lines, line)
    end

    local ret = tonumber(lines[#lines])

    if type(ret) == "number" then
        cachedResult = (ret == 0)
        if not cachedResult then
            lua.ReportScriptError("exit code "..ret.." during network check")
        end
    else
        cachedResult = true
    end
    
    completed = true
    return cachedResult
end
