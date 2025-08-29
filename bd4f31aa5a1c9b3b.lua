local player = game:GetService("Players").LocalPlayer
local SPEED_VALUE = 2500

-- Recursive function to find the Speed NumberValue anywhere in workspace
local function findSpeedValue(parent)
    for _, child in ipairs(parent:GetDescendants()) do
        if child.Name == "Speed" and child:IsA("NumberValue") then
            return child
        end
    end
    return nil
end

-- Function to safely set the flight speed
local function setFlightSpeed()
    -- Try to find the speed value
    local speedValue = findSpeedValue(workspace)
    
    if not speedValue then
        -- Alternative check for common locations
        speedValue = workspace:FindFirstChild("monkey_bannaann", true)
                      and workspace.monkey_bannaann:FindFirstChild("Flight", true)
                      and workspace.monkey_bannaann.Flight:FindFirstChild("Speed", true)
        
        if not speedValue then
            warn(" Could not find Speed NumberValue anywhere in workspace")
            return false
        end
    end

    -- Set the value
    local success, err = pcall(function()
        speedValue.Value = SPEED_VALUE
    end)
    
    if success then
        print(" Successfully set flight speed to:", SPEED_VALUE)
        return true
    else
        warn(" Failed to set speed value:", err)
        return false
    end
end

-- Main character handler with retry logic
local function onCharacterAdded(character)
    -- Wait for humanoid
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Initial speed set with retry
    local attempts = 0
    local maxAttempts = 5
    
    while attempts < maxAttempts and not setFlightSpeed() do
        attempts += 1
        task.wait(1)
    end
    
    -- Set up death connection
    humanoid.Died:Connect(function()
        -- Wait for respawn
        player.CharacterAdded:Wait()
        task.wait(0.5) -- Buffer time
        
        -- Retry setting speed
        setFlightSpeed()
    end)
end

-- Initial setup
if player.Character then
    onCharacterAdded(player.Character)
end

-- Connect future character changes
player.CharacterAdded:Connect(onCharacterAdded)

-- Periodic check in case value is added later
task.spawn(function()
    while task.wait(5) do
        if not setFlightSpeed() then
            warn(" Periodic check: Speed value still not found")
        end
    end
end)