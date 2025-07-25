local scriptContent = "loadstring(game:HttpGet(\"" .. CONFIGURATION.SCRIPT_URL .. "\"))()"
    
    -- Step 5: Write file with error handling
    local writeSuccess, writeError = pcall(function()
        writefile(targetFilePath, scriptContent)
    end)
    
    if not writeSuccess then
        warn("[ERROR] Failed to write script file: " .. tostring(writeError))
        return false
    end