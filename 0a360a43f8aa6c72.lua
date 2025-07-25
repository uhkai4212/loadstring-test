local teleportScript = [[
        -- Wait for game to load properly
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        
        -- Small delay to ensure services are available
        task.wait(1)