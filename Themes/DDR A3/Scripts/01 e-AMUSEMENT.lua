-- Should this theme act as if it is connected to e-AMUSEMENT or not?
function IsNetConnected()
    -- Change to `false` to "disconnect" from e-AMUSEMENT
    -- We cannot dynamically detect networking because `require` statements are not available.
    -- StepMania should consider upgrading to Lua 5.2.
    -- No, I'm not talking about OutFox, that is closed source.
    return true
end
