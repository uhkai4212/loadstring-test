local function implementPersistentScript()
    -- Step 1: Validate environment and prepare main folder
    if not isfolder(CONFIGURATION.FOLDER_NAME) then
        local success, errorMessage = pcall(makefolder, CONFIGURATION.FOLDER_NAME)
        
        if not success then
            warn("[ERROR] Failed to create main directory structure: " .. tostring(errorMessage))
            return false
        end
    end
    
    -- Create games folder if it doesn't exist
    local gamesFolder = CONFIGURATION.FOLDER_NAME .. "/games"
    if not isfolder(gamesFolder) then
        local success, errorMessage = pcall(makefolder, gamesFolder)
        
        if not success then
            warn("[ERROR] Failed to create games directory: " .. tostring(errorMessage))
            return false
        end
    end
    
    -- Step 2: Get current game name and ID
    local currentGameId = tostring(game.PlaceId)
    local currentGameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    
    -- Sanitize game name to be folder-friendly (remove special characters)
    local sanitizedGameName = currentGameName:gsub("[^%w%s_-]", ""):gsub("%s+", "_")
    
    -- Create game-specific folder using game name
    local gameSpecificFolder = gamesFolder .. "/" .. sanitizedGameName
    
    -- Create game-specific folder if it doesn't exist
    if not isfolder(gameSpecificFolder) then
        local success, errorMessage = pcall(makefolder, gameSpecificFolder)
        
        if not success then
            warn("[ERROR] Failed to create game-specific directory: " .. tostring(errorMessage))
            return false
        end
    end
    
    -- Step 3: Generate target filepath using game ID for the filename in the game name folder
    local targetFilePath = gameSpecificFolder .. "/" .. currentGameId .. CONFIGURATION.FILE_EXTENSION