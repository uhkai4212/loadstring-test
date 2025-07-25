local queueSuccess, queueError = pcall(function()
        queue_on_teleport(teleportScript)
    end)
    
    if not queueSuccess then
        warn("[ERROR] Failed to queue script for teleport: " .. tostring(queueError))
        return false
    end
    
    -- Step 8: Return operation results
    return {
        success = true,
        filePath = targetFilePath,
        gameId = currentGameId,
        gameName = currentGameName,
        gameFolder = gameSpecificFolder,
        message = "Script successfully saved and queued for teleport persistence"
    }
end

-- ====== UI CONFIGURATION SECTION ======
-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way: