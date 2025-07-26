spawn(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local textLabel = findBaseTextLabel()
        if textLabel then
            local lockPurchase = textLabel.Parent.Parent.Parent:FindFirstChild("LockPurchase")
            if lockPurchase then
                local hitbox = lockPurchase:FindFirstChild("Hitbox")
                if hitbox and hitbox:IsA("BasePart") then
                    local targetCFrame = hitbox.CFrame + Vector3.new(0, 5, 0)
                    Player.Character.HumanoidRootPart.CFrame = targetCFrame
                    OrionLib:MakeNotification({
                        Name = "Initial Teleport",
                        Content = "Teleported to Hitbox for studio lock.",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                else
                    OrionLib:MakeNotification({
                        Name = "Hitbox Not Found",
                        Content = "Hitbox not found in LockPurchase.",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                end
            else
                OrionLib:MakeNotification({
                    Name = "LockPurchase Not Found",
                    Content = "LockPurchase not found in studio hierarchy.",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Studio Not Found",
                Content = "Could not find TextLabel with '" .. Player.Name .. "'s Studio'.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    else
        OrionLib:MakeNotification({
            Name = "Error",
            Content = "Character or HumanoidRootPart not found.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
end)

-- AutoLock toggle logic
local function autoLockFunction()
    if autoLockEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local textLabel = findBaseTextLabel()
        if textLabel then
            local lockPurchase = textLabel.Parent.Parent.Parent:FindFirstChild("LockPurchase")
            if lockPurchase then
                local hitbox = lockPurchase:FindFirstChild("Hitbox")
                if hitbox and hitbox:FindFirstChild("BillboardGui") then
                    local baseLockLabel = hitbox.BillboardGui:FindFirstChild("TimeLeft")
                    if baseLockLabel and baseLockLabel:IsA("TextLabel") then
                        if not baseLockLabel.Visible then
                            if hitbox and hitbox:IsA("BasePart") then
                                local targetCFrame = hitbox.CFrame + Vector3.new(0, 5, 0)
                                local success, err = pcall(function()
                                    Player.Character.HumanoidRootPart.CFrame = targetCFrame
                                end)
                                if success then
                                    task.wait(0.1) -- Brief pause to ensure interaction
                                    OrionLib:MakeNotification({
                                        Name = "AutoLock Teleport",
                                        Content = "Teleported to Hitbox (TimeLeft invisible).",
                                        Image = "rbxassetid://4483345998",
                                        Time = 3
                                    })
                                else
                                    OrionLib:MakeNotification({
                                        Name = "Teleport Error",
                                        Content = "Failed to teleport: " .. tostring(err),
                                        Image = "rbxassetid://4483345998",
                                        Time = 3
                                    })
                                end
                            else
                                OrionLib:MakeNotification({
                                    Name = "Teleport Error",
                                    Content = "Hitbox is not a BasePart or not found during teleport.",
                                    Image = "rbxassetid://4483345998",
                                    Time = 3
                                })
                            end
                        end
                    else
                        OrionLib:MakeNotification({
                            Name = "AutoLock Error",
                            Content = "TimeLeft label not found.",
                            Image = "rbxassetid://4483345998",
                            Time = 3
                        })
                    end
                else
                    OrionLib:MakeNotification({
                        Name = "AutoLock Error",
                        Content = "Hitbox or BillboardGui not found.",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                end
            else
                OrionLib:MakeNotification({
                    Name = "AutoLock Error",
                    Content = "LockPurchase not found.",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "AutoLock Error",
                Content = "Studio TextLabel not found.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
end

-- Run AutoLock check every 0.1 seconds
spawn(function()
    while true do
        if autoLockEnabled then
            autoLockFunction()
        end
        task.wait(0.1)
    end
end)

-- ======= MAIN TAB =======
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local GravityScale = 1
local WalkSpeed = 16 -- Default Roblox walkspeed
local JumpPower = 50 -- Default Roblox jump power
local selectedTool = nil
local flyEnabled = false
local noclipEnabled = false
local flySpeed = 50
local bodyVelocity
local bodyGyro

-- Gravity Scale Slider
MainTab:AddSlider({
    Name = "Gravity Scale",
    Min = 0,
    Max = 5,
    Default = 1,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    Callback = function(Value)
        GravityScale = Value
    end
})

-- WalkSpeed Slider
MainTab:AddSlider({
    Name = "WalkSpeed",
    Min = 0,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(Value)
        WalkSpeed = Value
    end
})

-- JumpPower Slider
MainTab:AddSlider({
    Name = "JumpPower",
    Min = 0,
    Max = 150,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(Value)
        JumpPower = Value
    end
})

-- Teleport to Studio
MainTab:AddButton({
    Name = "Teleport to Studio",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local textLabel = findBaseTextLabel()
            if textLabel then
                local basePart = textLabel.Parent.Parent.Parent.Sign
                if basePart:IsA("BasePart") or basePart:IsA("Model") then
                    local targetCFrame = basePart:IsA("BasePart") and basePart.CFrame + Vector3.new(0, 5, 0) or basePart:GetPrimaryPartCFrame() + Vector3.new(0, 5, 0)
                    local success, err = pcall(function()
                        Player.Character.HumanoidRootPart.CFrame = targetCFrame
                    end)
                    if success then
                        OrionLib:MakeNotification({
                            Name = "Teleport to Studio",
                            Content = "Teleported to your studio!",
                            Image = "rbxassetid://4483345998",
                            Time = 3
                        })
                    else
                        OrionLib:MakeNotification({
                            Name = "Teleport Error",
                            Content = "Failed to teleport: " .. tostring(err),
                            Image = "rbxassetid://4483345998",
                            Time = 3
                        })
                    end
                else
                    OrionLib:MakeNotification({
                        Name = "Studio Not Found",
                        Content = "Could not find a valid studio part.",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                end
            else
                OrionLib:MakeNotification({
                    Name = "Studio Not Found",
                    Content = "Could not find TextLabel with '" .. Player.Name .. "'s Studio'.",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Character or HumanoidRootPart not found.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- AutoLock Studio Toggle
MainTab:AddToggle({
    Name = "AutoLock Studio",
    Default = false,
    Callback = function(Value)
        autoLockEnabled = Value
        OrionLib:MakeNotification({
            Name = "AutoLock Studio",
            Content = "AutoLock Studio " .. (Value and "enabled (checking TimeLeft visibility every 0.1s)" or "disabled"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- Reset Character Button
MainTab:AddButton({
    Name = "Reset Character",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character:FindFirstChildOfClass("Humanoid").Health = 0
            OrionLib:MakeNotification({
                Name = "Character Reset",
                Content = "Your character has been reset.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Character or Humanoid not found.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Fly Mode Toggle
MainTab:AddToggle({
    Name = "Fly Mode",
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
        if flyEnabled and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = Player.Character.HumanoidRootPart
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = humanoidRootPart

            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.P = 10000
            bodyGyro.D = 1000
            bodyGyro.Parent = humanoidRootPart

            RunService.RenderStepped:Connect(function()
                if flyEnabled then
                    local moveDirection = Vector3.new(0, 0, 0)
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + humanoidRootPart.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - humanoidRootPart.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - humanoidRootPart.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + humanoidRootPart.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end

                    moveDirection = moveDirection.Unit * flySpeed
                    bodyVelocity.Velocity = Vector3.new(moveDirection.X, moveDirection.Y, moveDirection.Z)
                    bodyGyro.CFrame = humanoidRootPart.CFrame
                end
            end)
            OrionLib:MakeNotification({
                Name = "Fly Mode",
                Content = "Fly Mode enabled (WASD to move, Space to ascend, Ctrl to descend)",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            if bodyVelocity then bodyVelocity:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
            OrionLib:MakeNotification({
                Name = "Fly Mode",
                Content = "Fly Mode disabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Noclip Toggle
MainTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(Value)
        noclipEnabled = Value
        if noclipEnabled and Player.Character then
            RunService.Stepped:Connect(function()
                if noclipEnabled and Player.Character then
                    for _, part in pairs(Player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            OrionLib:MakeNotification({
                Name = "Noclip",
                Content = "Noclip enabled (pass through walls)",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            OrionLib:MakeNotification({
                Name = "Noclip",
                Content = "Noclip disabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Looped updates: Gravity, WalkSpeed, and JumpPower
RunService.RenderStepped:Connect(function()
    game.Workspace.Gravity = 196.2 * GravityScale
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        humanoid.WalkSpeed = WalkSpeed
        humanoid.JumpPower = JumpPower
    end
end)

-- ======= COMBAT TAB =======
local CombatTab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local SlapSpeed = 0.1
local AutoSlap = false

-- Supported combat tools (adjusted for Blox Fruits context)
local combatTools = {
    "Bat",
    "SuperBat",
}

CombatTab:AddToggle({
    Name = "Auto-Attack",
    Default = false,
    Callback = function(Value)
        AutoSlap = Value
        OrionLib:MakeNotification({
            Name = "Auto-Attack",
            Content = "Auto-Attack " .. (Value and "enabled" or "disabled"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- Auto-Attack Logic
task.spawn(function()
    while true do
        if AutoSlap and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChildOfClass("Humanoid") then
            local myRoot = Player.Character.HumanoidRootPart
            local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
            local foundTarget = false
            
            -- Check for nearby players
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local theirRoot = plr.Character.HumanoidRootPart
                    local dist = (myRoot.Position - theirRoot.Position).Magnitude
                    
                    -- Proximity check (10 studs)
                    if dist <= 10 then
                        foundTarget = true
                        local toolFound = false
                        
                        -- Check for any supported combat tool
                        for _, toolName in pairs(combatTools) do
                            local tool = Player.Backpack:FindFirstChild(toolName) or Player.Character:FindFirstChild(toolName)
                            if tool then
                                toolFound = true
                                if not Player.Character:FindFirstChild(toolName) then
                                    humanoid:EquipTool(tool)
                                    task.wait(0.1)
                                end
                                if tool:IsA("Tool") and tool.Parent == Player.Character then
                                    local success, err = pcall(function()
                                        tool:Activate()
                                    end)
                                    if not success then
                                        OrionLib:MakeNotification({
                                            Name = "Tool Activation Failed",
                                            Content = "Error: " .. tostring(err),
                                            Image = "rbxassetid://4483345998",
                                            Time = 3
                                        })
                                    end
                                end
                                break
                            end
                        end
                        
                        if not toolFound then
                            OrionLib:MakeNotification({
                                Name = "Tool Not Found",
                                Content = "No supported weapon (e.g., Cutlass, Katana) found.",
                                Image = "rbxassetid://4483345998",
                                Time = 3
                            })
                        end
                        break
                    end
                end
            end
        end
        task.wait(SlapSpeed)
    end
end)

-- ======= VISUAL TAB =======
local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

VisualTab:AddToggle({
    Name = "Players ESP",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    addHighlight(player)
                end
            end
        else
            for player, highlight in pairs(playerHighlights) do
                removeHighlight(player)
            end
        end
    end
})

VisualTab:AddToggle({
    Name = "Players Name",
    Default = false,
    Callback = function(Value)
        nameEnabled = Value
        if nameEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    addNameGui(player)
                end
            end
        else
            for player, gui in pairs(playerNameGuis) do
                removeNameGui(player)
            end
        end
    end
})

VisualTab:AddToggle({
    Name = "StudioLockVisual",
    Default = false,
    Callback = function(Value)
        baseLockEnabled = Value
        if baseLockEnabled and not baseLockGui then
            local screenGui = Instance.new("ScreenGui")
            local textLabel = Instance.new("TextLabel")
            screenGui.Parent = Player:WaitForChild("PlayerGui")
            textLabel.Parent = screenGui
            textLabel.Size = UDim2.new(0, 150, 0, 50)
            textLabel.Position = UDim2.new(1, -160, 1, -60)
            textLabel.BackgroundTransparency = 0.5
            textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextScaled = true
            textLabel.Text = "Studio Unlocks In: Loading..."
            baseLockGui = screenGui

            spawn(function()
                while baseLockEnabled do
                    updateBaseLockVisual()
                    task.wait(0.1)
                end
            end)
        elseif not baseLockEnabled and baseLockGui then
            baseLockGui:Destroy()
            baseLockGui = nil
        end
    end
})

-- Event Handling for Players
for _, player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        if espEnabled then
            addHighlight(player)
        end
        if nameEnabled then
            addNameGui(player)
        end
    end)
    player.CharacterRemoving:Connect(function()
        removeHighlight(player)
        removeNameGui(player)
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            addHighlight(player)
        end
        if nameEnabled then
            addNameGui(player)
        end
    end)
    player.CharacterRemoving:Connect(function()
        removeHighlight(player)
        removeNameGui(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
    removeNameGui(player)
end)

-- ======= MISC TAB =======
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local antiAFK = false
local fpsBoost = false
local spinBot = false

-- Auto Rejoin Button
MiscTab:AddButton({
    Name = "Auto Rejoin",
    Callback = function()
        local success, err = pcall(function()
            TeleportService:Teleport(game.PlaceId, Player)
        end)
        if success then
            OrionLib:MakeNotification({
                Name = "Rejoin",
                Content = "Attempting to rejoin the server...",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Rejoin Failed",
                Content = "Error: " .. tostring(err),
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Anti-AFK Toggle
MiscTab:AddToggle({
    Name = "Anti-AFK",
    Default = false,
    Callback = function(Value)
        antiAFK = Value
        if antiAFK then
            spawn(function()
                while antiAFK do
                    task.wait(30)
                    local virtualUser = game:GetService("VirtualUser")
                    virtualUser:CaptureController()
                    virtualUser:ClickButton2(Vector2.new())
                end
            end)
            OrionLib:MakeNotification({
                Name = "Anti-AFK",
                Content = "Anti-AFK enabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Anti-AFK",
                Content = "Anti-AFK disabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Server Hop Button
MiscTab:AddButton({
    Name = "Server Hop",
    Callback = function()
        local servers = {}
        local req = HttpService:GetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(req)
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, Player)
            OrionLib:MakeNotification({
                Name = "Server Hop",
                Content = "Hopping to a new server...",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Server Hop Failed",
                Content = "No available servers found.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- FPS Booster Toggle
MiscTab:AddToggle({
    Name = "FPS Booster",
    Default = false,
    Callback = function(Value)
        fpsBoost = Value
        if fpsBoost then
            settings().Rendering.QualityLevel = 1
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").FogEnd = 9e9
            OrionLib:MakeNotification({
                Name = "FPS Booster",
                Content = "FPS Booster enabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            settings().Rendering.QualityLevel = 6
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").FogEnd = 100000
            OrionLib:MakeNotification({
                Name = "FPS Booster",
                Content = "FPS Booster disabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Spin Bot Toggle
MiscTab:AddToggle({
    Name = "Spin Bot",
    Default = false,
    Callback = function(Value)
        spinBot = Value
        if spinBot and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            spawn(function()
                while spinBot do
                    local root = Player.Character.HumanoidRootPart
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(5), 0)
                    task.wait(0.01)
                end
            end)
            OrionLib:MakeNotification({
                Name = "Spin Bot",
                Content = "Spin Bot enabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Spin Bot",
                Content = "Spin Bot disabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- ======= SETTINGS TAB =======
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SettingsTab:AddButton({
    Name = "Save Settings",
    Callback = function()
        OrionLib:SaveConfig()
        OrionLib:MakeNotification({
            Name = "Settings Saved",
            Content = "Settings have been saved successfully!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

SettingsTab:AddButton({
    Name = "Load Settings",
    Callback = function()
        OrionLib:LoadConfig()
        print("Loaded config:", espEnabled, nameEnabled, baseLockEnabled, AutoSlap, antiAFK, fpsBoost, spinBot, flyEnabled, noclipEnabled, GravityScale, autoLockEnabled)
        OrionLib:MakeNotification({
            Name = "Settings Loaded",
            Content = "Settings have been loaded successfully!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

SettingsTab:AddButton({
    Name = "Reset to Default",
    Callback = function()
        espEnabled = false
        nameEnabled = false
        baseLockEnabled = false
        autoLockEnabled = false
        AutoSlap = false
        antiAFK = false
        fpsBoost = false
        spinBot = false
        flyEnabled = false
        noclipEnabled = false
        GravityScale = 1
        WalkSpeed = 16
        JumpPower = 50
        OrionLib:MakeNotification({
            Name = "Settings Reset",
            Content = "All settings have been reset to default!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- ======= CREDITS TAB =======
local CreditsTab = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
CreditsTab:AddLabel("Scripted by Javindra.")
CreditsTab:AddLabel("Founded by Crowned.")
CreditsTab:AddButton({
    Name = "Join Discord Server",
    Callback = function()
        setclipboard("https://discord.gg/WA2XTGMM")
        OrionLib:MakeNotification({
            Name = "Discord Link",
            Content = "Link copied to clipboard! Opening Discord invite...",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
        spawn(function()
            if syn and syn.request then
                syn.request({Url = "http://www.roblox.com/games/place?id=" .. game.PlaceId .. "&linkId=" .. HttpService:GenerateGUID(false), Method = "GET"})
            else
                game:HttpGet("https://discord.gg/WA2XTGMM")
            end
        end)
    end
})

OrionLib:Init()