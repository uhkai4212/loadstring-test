loadstring(game:HttpGet("]] .. CONFIGURATION.SCRIPT_URL .. [["))()
        
        -- Re-queue for future teleports
        queue_on_teleport([=[
            loadstring(game:HttpGet("]] .. CONFIGURATION.SCRIPT_URL .. [["))()
            loadstring(readfile("]=] .. targetFilePath .. [=["))()
        ]=])
    ]]