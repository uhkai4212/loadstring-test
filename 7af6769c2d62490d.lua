--loadstring(game:HttpGet("https://pastebin.com/raw/Zt4VD4yV"))()

local BlacklistedPlayers = {
    548245499,
    2318524722,
    3564923852
}

local player = game.Players.LocalPlayer
local userId = player.UserId

-- Check if the player's userId is in the BlacklistedPlayers table
for _, blacklistedId in ipairs(BlacklistedPlayers) do
    if userId == blacklistedId then
        player:Kick("You are blacklisted from using this script. wrdyz.94 On discord for appeal.")
        break
    end
end




local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Version = "Final"

-- ====== PERSISTENCE MECHANISM ======
local CONFIGURATION = {
    FOLDER_NAME = "CROW",
    SCRIPT_URL = "https://pastes.io/raw/arisescript",
    FILE_EXTENSION = ".lua"
}






if _G.Interface == nil then
_G.Interface = true



    
Fluent:Notify({
    Title = "Loading interface...",
    Content = "Interface is loading, please wait.",
    Duration = 5 -- Set to nil to make the notification not disappear
})



local Admins = {
    8205778977
}
local isAdmin = false
for _, adminId in ipairs(Admins) do
    if userId == adminId then
        isAdmin = true
        break
    end
end

local Window = Fluent:CreateWindow({
    Title = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." | "..Version,
    SubTitle = "(auto updt vers.) by wrdyz.94",
    TabWidth = 100,
    Size = UDim2.fromOffset(550, 400),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    Transparency = "false",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})



--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    World = Window:AddTab({ Title = "World", Icon = "compass" }),
    Autofarm = Window:AddTab({ Title = "Autofarm", Icon = "repeat" }),
    Servers = Window:AddTab({ Title = "Servers", Icon = "server" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "book" }),
    UpdateLogs = Window:AddTab({ Title = "Update Logs", Icon = "scroll" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

if isAdmin then
    Tabs.Admin = Window:AddTab({ Title = "Admin", Icon = "shield" })
end





    Tabs.Player:AddParagraph({
        Title = "Some features might not work together correctly.",
        Content = ""
    })



    
    

    local secplayer = Tabs.Player:AddSection("Player")

    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local basespeed = humanoid.WalkSpeed
    local basejump = humanoid.JumpPower


    -- WalkSpeed Slider
    local SliderWalk = secplayer:AddSlider("SliderWalk", {
        Title = "Walk Speed",
        Description = "",
        Default = basespeed,
        Min = basespeed,
        Max = 240,
        Rounding = 0,
        Callback = function(Value)
            humanoid.WalkSpeed = Value
        end
    })
    
    
    -- JumpPower Slider
    local SliderJump = secplayer:AddSlider("SliderJump", {
        Title = "Jump Power",
        Description = "",
        Default = basejump,
        Min = basejump,
        Max = basejump * 6,
        Rounding = 0,
        Callback = function(Value)
            humanoid.UseJumpPower = true
            humanoid.JumpPower = Value
        end
    })
    
    -- Ensure WalkSpeed stays set
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if humanoid.WalkSpeed ~= SliderWalk.Value then
            humanoid.WalkSpeed = SliderWalk.Value
        end
    end)
    -- Ensure this block is properly closed and does not interfere with subsequent code
    
    -- Ensure JumpPower stays set
    humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if humanoid.JumpPower ~= SliderJump.Value then
            humanoid.JumpPower = SliderJump.Value
        end
    end)
    
    -- Reset values when character respawns
    player.CharacterAdded:Connect(function(character)
        humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = SliderWalk.Value
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if humanoid.WalkSpeed ~= SliderWalk.Value then
                humanoid.WalkSpeed = SliderWalk.Value
            end
        end)
        humanoid.UseJumpPower = true
        humanoid.JumpPower = SliderJump.Value
    end)


    local secHitbox = Tabs.Player:AddSection("Enemy Hitbox")

local hitcolor = secHitbox:AddColorpicker("hitcolor", {
    Title = "Hitbox color",
    Transparency = 0,
    Default = Color3.fromRGB(255, 0, 0)
})

-- Table to store original Hitbox sizes
local OriginalSizes = {}

-- Function to safely get the default size of an enemy Hitbox
local function GetDefaultHitboxSize()
    local enemiesFolder = workspace.__Main.__Enemies.Client
    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") then
            local hitbox = enemy:FindFirstChild("Hitbox")
            if hitbox then
                return hitbox.Size.X
            end
        end
    end
    return 5 -- Fallback size
end

-- Set default size based on existing enemy (if available)
local DefaultHitboxSize = GetDefaultHitboxSize()
local HitboxSize = DefaultHitboxSize -- Current hitbox size (modifiable via slider)
local HitboxEnabled = false -- Track if hitbox resizing is enabled

-- Function to resize hitboxes for an enemy
local function ResizeHitboxForEnemy(enemy)
    if not HitboxEnabled then return end

    local hitbox = enemy:FindFirstChild("Hitbox")
    if hitbox then
        -- Store original size before resizing
        if not OriginalSizes[enemy] then
            OriginalSizes[enemy] = hitbox.Size
        end

        local newSize = Vector3.new(HitboxSize, HitboxSize, HitboxSize)

        hitbox.Size = newSize
        hitbox.Transparency = 1 -- Make it invisible

        -- Add visualizer if not already present
        local hitboxVisualizer = hitbox:FindFirstChild("HitboxVisualizer")
        if not hitboxVisualizer then
            hitboxVisualizer = Instance.new("SelectionBox")
            hitboxVisualizer.Name = "HitboxVisualizer"
            hitboxVisualizer.Adornee = hitbox
            hitboxVisualizer.Parent = hitbox

            -- Set initial color when visualizer is created
            local color = hitcolor.Value
            local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
            
            hitboxVisualizer.Color3 = Color3.fromRGB(r, g, b)
            hitboxVisualizer.SurfaceColor3 = Color3.fromRGB(r, g, b)
            
            hitboxVisualizer.SurfaceTransparency = 1 -- Outline only, matching player script
            hitboxVisualizer.LineThickness = 0.1
        end
    end
end

-- Function to reset hitbox to original size
local function RevertHitboxSize(enemy)
    local hitbox = enemy:FindFirstChild("Hitbox")
    if hitbox and OriginalSizes[enemy] then
        hitbox.Size = OriginalSizes[enemy] -- Reset size
        hitbox.Transparency = 1 -- Restore transparency
        
        -- Remove hitbox visualizer if it exists
        local hitboxVisualizer = hitbox:FindFirstChild("HitboxVisualizer")
        if hitboxVisualizer then
            hitboxVisualizer:Destroy()
        end
    end
end

-- Function to resize all enemies
local function ApplyHitboxResizing()
    local enemiesFolder = workspace.__Main.__Enemies.Client
    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") then
            ResizeHitboxForEnemy(enemy)
        end
    end
end

-- Function to update the color of the hitbox visualizer for all enemies
local function UpdateHitboxColor()
    local color = hitcolor.Value
    local r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)

    -- Iterate through all enemies and update their visualizers
    local enemiesFolder = workspace.__Main.__Enemies.Client
    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") then
            local hitbox = enemy:FindFirstChild("Hitbox")
            if hitbox then
                local hitboxVisualizer = hitbox:FindFirstChild("HitboxVisualizer")
                if hitboxVisualizer then
                    hitboxVisualizer.Color3 = Color3.fromRGB(r, g, b)
                    hitboxVisualizer.SurfaceColor3 = Color3.fromRGB(r, g, b)
                    hitboxVisualizer.Transparency = hitcolor.Transparency
                end
            end
        end
    end
end

-- Handle new enemies being added to the workspace
local enemiesFolder = workspace.__Main.__Enemies.Client
enemiesFolder.ChildAdded:Connect(function(enemy)
    task.wait(0.5) -- Give time for the enemy to fully load
    if HitboxEnabled and enemy:IsA("Model") then
        ResizeHitboxForEnemy(enemy)
    end
end)

-- UI Elements (Initialized AFTER variables are defined)
local SliderHitboxSize = secHitbox:AddSlider("SliderHitboxSize", {
    Title = "Enemy Hitbox Size",
    Description = "",
    Default = DefaultHitboxSize,
    Min = 10,  -- Minimum size, matching player script
    Max = 70, -- Maximum size, matching player script
    Rounding = 1,
    Callback = function(Value)
        if Value then
            HitboxSize = Value -- Update hitbox size
            if HitboxEnabled then
                ApplyHitboxResizing()
            end
        end
    end
})

-- Ensure slider starts at default size
SliderHitboxSize:SetValue(DefaultHitboxSize)

-- Toggle to enable/disable hitbox resizing
local ToggleHitboxResize = secHitbox:AddToggle("ToggleHitboxResize", {
    Title = "Enemy Hitbox Expander",
    Default = false
})

-- Toggle behavior
ToggleHitboxResize:OnChanged(function(Value)
    if Value == nil then return end -- Prevent nil value errors

    HitboxEnabled = Value

    if HitboxEnabled then
        ApplyHitboxResizing() -- Apply resizing if enabled
    else
        -- Revert all enemies to their original hitbox sizes
        local enemiesFolder = workspace.__Main.__Enemies.Client
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") then
                RevertHitboxSize(enemy)
            end
        end
        
        -- Clean up any orphaned visualizers
        for _, descendant in pairs(enemiesFolder:GetDescendants()) do
            if descendant.Name == "HitboxVisualizer" then
                descendant:Destroy()
            end
        end
    end
end)

-- Update color whenever the colorpicker value changes
hitcolor:OnChanged(function()
    UpdateHitboxColor()

end)
















local Teleport = Tabs.World:AddSection("World")

-- Function to populate dropdown with spawn point names and custom locations
local function PopulateSpawnDropdown()
    local spawnNames = {}

    -- Add your custom locations here
    table.insert(spawnNames, "Guild Hall")
    table.insert(spawnNames, "Jeju Island")

    -- Add spawn locations from the folder
    local spawnFolder = workspace:FindFirstChild("__Extra") and workspace.__Extra:FindFirstChild("__Spawns")
    if spawnFolder then
        for _, spawn in pairs(spawnFolder:GetChildren()) do
            if spawn:IsA("BasePart") then
                table.insert(spawnNames, spawn.Name)
            end
        end
    end

    return spawnNames
end

-- Create dropdown with initial values
local droptp = Teleport:AddDropdown("droptp", {
    Title = "Teleport to Spawn:",
    Values = PopulateSpawnDropdown(),
    Multi = false,
    Default = nil,
})

-- Instant teleport function (with retry in case of reset)
local function InstantTeleport(targetPosition)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    if hrp then
        local finalPos = targetPosition + Vector3.new(0, 5, 0)

        -- Initial teleport
        hrp.CFrame = CFrame.new(finalPos)

        -- Small delay, then ensure we didn't get snapped back
        task.wait(0.1)
        if (hrp.Position - finalPos).Magnitude > 10 then
            hrp.CFrame = CFrame.new(finalPos)
        end
    end
end

-- Dropdown selection event
-- Teleport handler for dropdown selection
droptp:OnChanged(function(Value)
    local mainWorld = workspace.__Main and workspace.__Main:FindFirstChild("__World")
    local extra = workspace:FindFirstChild("__Extra")

    -- Guild Hall teleportation via touch interest
    if Value == "Guild Hall" then
        local guildHall = mainWorld and mainWorld:FindFirstChild("GuildHall")
        if guildHall then
            -- Find the touch part in the expected path
            local touchPart = extra and 
                             extra:FindFirstChild("GuildTPs") and
                             extra.GuildTPs:FindFirstChild("Main")
            
            if touchPart then
                -- Execute touch sequence
                local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    firetouchinterest(hrp, touchPart, 0) -- Begin touch
                    task.wait(0.05)                      -- Minimal wait time
                    firetouchinterest(hrp, touchPart, 1) -- End touch
                end
            end
        end
        return
        
    -- Jeju Island direct teleportation
    elseif Value == "Jeju Island" then
        local jejuWorld = mainWorld and mainWorld:FindFirstChild("World Jeju")
        if jejuWorld then
            InstantTeleport(jejuWorld:GetPivot().Position)
        end
        return
    end

    -- Generic spawn folder location teleportation
    local spawnFolder = extra and extra:FindFirstChild("__Spawns")
    if spawnFolder then
        for _, spawn in pairs(spawnFolder:GetChildren()) do
            if spawn:IsA("BasePart") and spawn.Name == Value then
                InstantTeleport(spawn.Position)
                break
            end
        end
    end
end)

-- Auto-update dropdown if spawn points change
local function UpdateSpawnDropdown()
    droptp:SetValues(PopulateSpawnDropdown())
end

local spawnFolder = workspace:FindFirstChild("__Extra") and workspace.__Extra:FindFirstChild("__Spawns")
if spawnFolder then
    spawnFolder.ChildAdded:Connect(UpdateSpawnDropdown)
    spawnFolder.ChildRemoved:Connect(UpdateSpawnDropdown)
end





-- Function to populate dropdown with spawn point names and custom locations
local function PopulateSpawnDropdown()
    local spawnNames = {}
    -- Add spawn locations from the folder
    local spawnFolder = workspace:FindFirstChild("__Extra") and workspace.__Extra:FindFirstChild("__Spawns")
    if spawnFolder then
        for _, spawn in pairs(spawnFolder:GetChildren()) do
            if spawn:IsA("BasePart") then
                table.insert(spawnNames, spawn.Name)
            end
        end
    end

    return spawnNames
end




-- Create dropdown with initial values
local spawndrop = Teleport:AddDropdown("spawndrop", {
    Title = "Set Spawn:",
    Values = PopulateSpawnDropdown(),
    Multi = false,
    Default = nil,
})


spawndrop:OnChanged(function(Value)
    local args = {
        [1] = {
            [1] = {
                ["Event"] = "ChangeSpawn",
                ["Spawn"] = Value
            },
            [2] = "\n"
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
    
end)






































local secautogeneral = Tabs.Autofarm:AddSection("Global")

-- Auto Hit
local autohit = secautogeneral:AddToggle("autohit", {Title = "Auto Hit", Default = false})

autohit:OnChanged(function()
    if autohit.Value then
        -- Run in a separate task to prevent blocking
            while autohit.Value do
                -- Dynamically find the closest enemy
                local closestEnemy = nil
                local closestDistance = math.huge  -- Start with a large value for distance

                -- Get the player's character
                local player = game.Players.LocalPlayer
                local playerCharacter = player.Character or player.CharacterAdded:Wait()
                local playerPosition = playerCharacter:WaitForChild("HumanoidRootPart").Position

                -- Iterate through all enemies in the game
                for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                        -- Calculate the distance to the player
                        local enemyPosition = enemy:FindFirstChild("HumanoidRootPart").Position
                        local distance = (playerPosition - enemyPosition).magnitude

                        -- If this enemy is closer than the previous one, select it
                        if distance < closestDistance then
                            closestEnemy = enemy
                            closestDistance = distance
                        end
                    end
                end

                -- If we found a valid closest enemy, send the PunchAttack event
                if closestEnemy then
                    local args = {
                        [1] = {
                            [1] = {
                                ["Event"] = "PunchAttack",
                                ["Enemy"] = closestEnemy.Name  -- Use the dynamically found enemy's name
                            },
                            [2] = "\4"
                        }
                    }

                    -- Fire the event to hit the closest enemy
                    game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                end

                -- Wait before checking for the next enemy
                task.wait()
            end
    end
end)

-- Function to check if an enemy is valid (has health > 0)
local function isValidEnemy(enemy)
    local healthBar = enemy:FindFirstChild("HealthBar")
    local main = healthBar and healthBar:FindFirstChild("Main")
    local bar = main and main:FindFirstChild("Bar")
    local amount = bar and bar:FindFirstChild("Amount")

    if not amount or not amount:IsA("TextLabel") then return false end
    
    local hp = tonumber(string.match(amount.Text, "(%d+)"))
    return hp and hp > 0
end

-- Trigger the attack event to target any enemy
local function triggerAttack(enemy)
    local player = game.Players.LocalPlayer
    local userId = tostring(player.UserId)
    local userFolder = workspace.__Main.__Pets:FindFirstChild(userId)
    if not userFolder then return false end

    local currentPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
    if not currentPos then return false end

    local offset = 5

    -- Loop through all pets and fire one event per pet
    for _, pet in ipairs(userFolder:GetChildren()) do
        local petPos = {}

        -- Calculate pet position relative to the player's position
        petPos[pet.Name] = Vector3.new(
            currentPos.X + math.random(-offset, offset),
            currentPos.Y,
            currentPos.Z + math.random(-offset, offset)
        )

        -- Create the args for the specific pet
        local args = {
            [1] = {
                [1] = {
                    ["PetPos"] = petPos,  -- Position of the current pet
                    ["AttackType"] = "All",  -- Assuming attack type is "All"
                    ["Event"] = "Attack",
                    ["Enemy"] = enemy.Name  -- Target enemy
                },
                [2] = "\t"
            }
        }

        -- Send the event for the specific pet
        game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
        
        -- Wait a small amount of time before firing the next event
        task.wait(.8)
    end

    return true
end

-- Find and attack the closest valid enemy for global autofarm
local function attackClosestEnemyGlobal()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
    local playerPosition = humanoidRootPart.Position
    
    local closestEnemy = nil
    local closestDistance = math.huge
    
    -- Find the closest valid enemy (any enemy with health > 0)
    for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and isValidEnemy(enemy) then
            local distance = (enemy.HumanoidRootPart.Position - playerPosition).Magnitude
            
            if distance < closestDistance then
                closestDistance = distance
                closestEnemy = enemy
            end
        end
    end
    
    if closestEnemy then
        -- Teleport to the enemy
        char.HumanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(5, 0, 0)
        task.wait()
        char.HumanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(5, 0, 0)
        task.wait()
        char.HumanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(5, 0, 0)
        
        -- Attack the enemy
        triggerAttack(closestEnemy)
        
        while closestEnemy:FindFirstChild("HealthBar")  do
            local healthBar = closestEnemy.HealthBar:FindFirstChild("Main")
            local amount = healthBar and healthBar:FindFirstChild("Bar") and healthBar.Bar:FindFirstChild("Amount")
            
            if amount and amount:IsA("TextLabel") then
                local health = tonumber(string.match(amount.Text, "(%d+)"))
                if not health or health <= 0 then break end
            end
            
            task.wait()
        end
        
        return true
    end
    
    return false
end

-- Autofarm loop for global (any enemy)
local globalFarmRunning = false
local globalFarmThread = nil

local function runGlobalAutofarm()
    while globalFarmRunning do
        attackClosestEnemyGlobal()
        task.wait(0.5)
    end
end

-- Toggle to run global autofarm (any enemy)
local autoclose = secautogeneral:AddToggle("automob", {
    Title = "Autofarm Closest Mobs",
    Default = false
})

autoclose:OnChanged(function()
    if autoclose.Value then
        if globalFarmRunning then return end
        globalFarmRunning = true
        globalFarmThread = task.spawn(runGlobalAutofarm)
    else
        globalFarmRunning = false
        if globalFarmThread then
            task.cancel(globalFarmThread)
            globalFarmThread = nil
        end
    end
end)

-- Auto Arise
local autoarise = secautogeneral:AddToggle("autoarise", {Title = "Auto Arise", Default = false})

autoarise:OnChanged(function()
    if autoarise.Value then
        -- Run in a separate task to prevent blocking
            while autoarise.Value do
                -- Dynamically find the closest enemy with 0 HP
                local closestEnemy = nil
                local closestDistance = math.huge  -- Start with a large value for distance

                -- Get the player's character
                local player = game.Players.LocalPlayer
                local playerCharacter = player.Character or player.CharacterAdded:Wait()
                local playerPosition = playerCharacter:WaitForChild("HumanoidRootPart").Position

                -- Iterate through all enemies in the game
                for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                        local healthBar = enemy:FindFirstChild("HealthBar")
                        local main = healthBar and healthBar:FindFirstChild("Main")
                        local title = main and main:FindFirstChild("Title")
                        local bar = main and main:FindFirstChild("Bar")
                        local amount = bar and bar:FindFirstChild("Amount")

                        if title and amount and title:IsA("TextLabel") and amount:IsA("TextLabel") then
                            local hp = tonumber(string.match(amount.Text, "(%d+)"))
                            if hp and hp == 0 then  -- Only consider enemies with 0 HP
                                -- Calculate the distance to the player
                                local enemyPosition = enemy:FindFirstChild("HumanoidRootPart").Position
                                local distance = (playerPosition - enemyPosition).magnitude

                                -- If this enemy is closer than the previous one, select it
                                if distance < closestDistance then
                                    closestEnemy = enemy
                                    closestDistance = distance
                                end
                            end
                        end
                    end
                end

                -- If we found a valid closest enemy, send the capture event
                if closestEnemy then
                    local args = {
                        [1] = {
                            [1] = {
                                ["Event"] = "EnemyCapture",
                                ["Enemy"] = closestEnemy.Name  -- Use the dynamically found enemy's name
                            },
                            [2] = "\4"
                        }
                    }

                    -- Fire the event to capture the closest enemy with 0 HP
                    game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                end

                -- Wait before checking for the next enemy
                task.wait()
            end
    end
end)

-- Auto Destroy
local autodestroy = secautogeneral:AddToggle("autodestroy", {Title = "Auto Destroy", Default = false})

autodestroy:OnChanged(function()
    if autodestroy.Value then
        -- Run in a separate task to prevent blocking
            while autodestroy.Value do
                -- Dynamically find the closest enemy
                local closestEnemy = nil
                local closestDistance = math.huge  -- Start with a large value for distance

                -- Get the player's character
                local player = game.Players.LocalPlayer
                local playerCharacter = player.Character or player.CharacterAdded:Wait()
                local playerPosition = playerCharacter:WaitForChild("HumanoidRootPart").Position

                -- Iterate through all enemies in the game
                for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                        -- Calculate the distance to the player
                        local enemyPosition = enemy:FindFirstChild("HumanoidRootPart").Position
                        local distance = (playerPosition - enemyPosition).magnitude

                        -- If this enemy is closer than the previous one, select it
                        if distance < closestDistance then
                            closestEnemy = enemy
                            closestDistance = distance
                        end
                    end
                end

                -- If we found a valid closest enemy, send the EnemyDestroy event
                if closestEnemy then
                    local args = {
                        [1] = {
                            [1] = {
                                ["Event"] = "EnemyDestroy",
                                ["Enemy"] = closestEnemy.Name  -- Use the dynamically found enemy's name
                            },
                            [2] = "\4"
                        }
                    }

                    -- Fire the event to destroy the closest enemy
                    game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet2"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
                end

                -- Wait before checking for the next enemy
                task.wait()
            end
    end
end)

-- Dropdown UI setup for specific mob selection
local secautofarm = Tabs.Autofarm:AddSection("Mobs")

local selectedEnemies = {}
local currentMobGroups = {}
local detectionRange = 1000  -- Increased detection range significantly
local MobDrop = secautofarm:AddDropdown("MobDrop", {
    Title = "Choose Mobs to Farm",
    Values = {},
    Multi = true,
    Default = {},
})

-- Function to check if the enemy is a selected target
local function isValidTarget(enemy)
    local healthBar = enemy:FindFirstChild("HealthBar")
    local main = healthBar and healthBar:FindFirstChild("Main")
    local title = main and main:FindFirstChild("Title")
    local bar = main and main:FindFirstChild("Bar")
    local amount = bar and bar:FindFirstChild("Amount")
    local avatar = main and main:FindFirstChild("Avatar")
    local levelText = avatar and avatar:FindFirstChild("LevelText")

    if not (title and amount) then return false end
    if not amount:IsA("TextLabel") or not title:IsA("TextLabel") then return false end

    local hp = tonumber(string.match(amount.Text, "(%d+)"))
    if not (hp and hp > 0) then return false end
    
    -- Get enemy group key based only on name and level (ignoring health)
    local name = title.Text
    local level = levelText and levelText:IsA("TextLabel") and levelText.Text or "Unknown"
    local groupKey = name .. " [Lv." .. level .. "]"
    
    return table.find(selectedEnemies, groupKey)
end

-- Teleport the player to a randomly selected enemy from the selection list
local function teleportToRandomEnemy()
    local validEnemies = {}
    
    -- Collect all valid enemies in the expanded detection range
    for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local distance = (enemy.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            
            -- Check if enemy is within the detection range and is a selected target
            if distance <= detectionRange and isValidTarget(enemy) then
                table.insert(validEnemies, enemy)
            end
        end
    end

    if #validEnemies == 0 then return false end

    local targetEnemy = validEnemies[math.random(1, #validEnemies)]

    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
    local targetRootPart = targetEnemy:FindFirstChild("HumanoidRootPart")

    if targetRootPart then
        char.HumanoidRootPart.Anchored = true

        local targetPosition = targetRootPart.Position + Vector3.new(5, 0, 0)
        local currentPosition = humanoidRootPart.Position
        local lerpDuration = 1
        local startTime = tick()

        local function lerpToPosition()
            local elapsedTime = tick() - startTime
            local lerpFactor = math.min(elapsedTime / lerpDuration, 1)
            humanoidRootPart.CFrame = CFrame.new(currentPosition:Lerp(targetPosition, lerpFactor))

            if lerpFactor < 1 then
                task.wait(0.03)
                lerpToPosition()
            else
                char.HumanoidRootPart.Anchored = false
                triggerAttack(targetEnemy)
            end
        end

        lerpToPosition()

        while targetEnemy:FindFirstChild("HealthBar") and targetEnemy.HealthBar:FindFirstChild("Main") do
            local healthBar = targetEnemy.HealthBar.Main
            local amount = healthBar:FindFirstChild("Bar") and healthBar.Bar:FindFirstChild("Amount")

            if amount and amount:IsA("TextLabel") then
                local health = tonumber(string.match(amount.Text, "(%d+)"))
                if health and health <= 0 then break end
            end

            task.wait()
        end
    end

    return true
end

-- Autofarm loop for selected mobs
local selectedFarmRunning = false
local selectedFarmThread = nil

local function runSelectedAutofarm()
    while selectedFarmRunning do
        if #selectedEnemies > 0 then
            teleportToRandomEnemy()
            task.wait()
        else
            task.wait(1)
        end
    end
end

-- Function to get enemy level and name from health bar
local function getEnemyLevelAndName(enemy)
    local healthBar = enemy:FindFirstChild("HealthBar")
    local main = healthBar and healthBar:FindFirstChild("Main")
    local title = main and main:FindFirstChild("Title")
    local avatar = main and main:FindFirstChild("Avatar")
    local levelText = avatar and avatar:FindFirstChild("LevelText")
    
    if title and title:IsA("TextLabel") then
        local name = title.Text
        local level = "Unknown"
        
        if levelText and levelText:IsA("TextLabel") then
            level = levelText.Text
        end
        
        -- Create a group key based on the enemy name and level only
        local groupKey = name .. " [Lv." .. level .. "]"
        
        return {
            name = name,
            level = level,
            groupKey = groupKey
        }
    end
    
    return nil
end

-- Function to get all enemy types and update dropdown
local function updateMobDropdown()
    local enemyTypes = {}
    local seen = {}
    
    for _, enemy in ipairs(workspace.__Main.__Enemies.Client:GetChildren()) do
        if enemy:IsA("Model") then
            local enemyInfo = getEnemyLevelAndName(enemy)
            if enemyInfo and enemyInfo.groupKey then
                if not seen[enemyInfo.groupKey] then
                    table.insert(enemyTypes, enemyInfo.groupKey)
                    seen[enemyInfo.groupKey] = true
                end
            end
        end
    end
    
    table.sort(enemyTypes)
    currentMobGroups = enemyTypes
    
    -- Update the dropdown with the new values
    MobDrop:SetValues(currentMobGroups)
end



-- Dropdown change listener
MobDrop:OnChanged(function(valueTable)
    selectedEnemies = {}
    for value, isSelected in pairs(valueTable) do
        if isSelected then
            table.insert(selectedEnemies, value)
        end
    end
end)

secautofarm:AddButton({
    Title = "Refresh Enemy list",
    Callback = function()
        updateMobDropdown()
    end
})

-- Toggle to run selected mob autofarm
local automob = secautofarm:AddToggle("selectedmob", {
    Title = "Autofarm Selected Mobs",
    Default = false
})

automob:OnChanged(function()
    if automob.Value then
        if selectedFarmRunning then return end
        selectedFarmRunning = true
        selectedFarmThread = task.spawn(runSelectedAutofarm)
    else
        selectedFarmRunning = false
        if selectedFarmThread then
            task.cancel(selectedFarmThread)
            selectedFarmThread = nil
        end
    end
end)