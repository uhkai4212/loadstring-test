local rf = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local win = rf:CreateWindow({
    Name = "Money Hub",
    Icon = 0,
    LoadingTitle = "Loading Best OP Ninja Simulator Script",
    LoadingSubtitle = "by Money",
    Theme = "Default",
    ConfigurationSaving = {Enabled = true, FolderName = "Luau", FileName = "BigBro"},
    Discord = {Enabled = true, Invite = "KvvHREvB", RememberJoins = true},
    KeySystem = true,
    KeySettings = {
        Title = "Key System",
        Subtitle = "https://discord.gg/KvvHREvB",
        Note = "Join Discord to Get Key",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = true,
        Key = {"MoneyProYe"}
    }
})

-- Services & Local Player
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Players = game:GetService("Players")
local WS = game:GetService("Workspace")
local lp = Players.LocalPlayer

-- Consolidated state variables with extensive customization options
local state = {
    autoTrain = {
        enabled = false,
        conn = nil,
        ignoreList = {},
        delay = 0.1,  -- Delay (in seconds) between each tool activation
    },
    fastSlash = {
        enabled = false,
        conn = nil,
        delay = 0.05,  -- Delay between each slash activation
    },
    autoFarmHonorConn = nil,
    aimbot = {
         enabled = false,
         conn = nil,
         mode = "Lowest Health",          -- Options: "Lowest Health", "Closest Player"
         targetPart = "Head",               -- Options: "Head", "Torso", "HumanoidRootPart"
         smoothness = 0.5,                  -- Lerp factor (0.1 = snappy, 1 = smooth)
         instantSnap = false,               -- If true, bypass smoothing (instant snap)
         fov = 90,                        -- Field-of-View radius in pixels
         fovEnabled = false,                -- Enable FOV filtering
         healthCheck = true,                -- Only target enemies with lower health than yours
    },
    oldPos = nil,
    oldGravity = WS.Gravity,
    safeZonePart = nil,
    oldSafeZonePos = nil,
    farmMode = "Lowest Health",             -- For Auto Farm Honor mode
    teleportOffset = Vector3.new(0, -3.5, 0),
    smoothTeleport = false,
    teleportSpeed = 0.2,
    swordSize = Vector3.new(1, 1, 1)
}

-- Helper function to get the local character
local function getChar()
    return lp.Character or lp.CharacterAdded:Wait()
end

-- Unified teleport function (supports smooth teleporting if enabled)
local function teleport(part, targetCFrame)
    if not part then return end
    if state.smoothTeleport then
        local tween = TS:Create(part, TweenInfo.new(state.teleportSpeed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        tween:Play() 
        tween.Completed:Wait()
    else
        part.CFrame = targetCFrame
    end
end

-- Get Best Enemy for Auto Farm Honor (using chosen farmMode)
local function getBestEnemy()
    local char = getChar()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local myHum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not myHum then return end
    local best, bestVal1, bestVal2 = nil, math.huge, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Team and p.Team ~= lp.Team and p.Team.Name ~= "Neutral" then
            local eHum = p.Character:FindFirstChildOfClass("Humanoid")
            local eHrp = p.Character:FindFirstChild("HumanoidRootPart")
            if eHrp and eHum and eHum.Health > 0 and eHum.Health < myHum.Health then
                local dist = (hrp.Position - eHrp.Position).Magnitude
                if state.farmMode == "Closest Player" and dist < bestVal2 then
                    bestVal2, best = dist, p
                elseif state.farmMode == "Lowest Health" and eHum.Health < bestVal1 then
                    bestVal1, bestVal2, best = eHum.Health, dist, p
                end
            end
        end
    end
    return best
end

-- Get Aimbot Target with extra customization (FOV filtering, health check, etc.)
local function getAimbotTarget()
    local cam = WS.CurrentCamera
    local myChar = getChar()
    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if not cam or not hrp or not myHum then return end

    local best, bestScore = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Team and p.Team ~= lp.Team and p.Team.Name ~= "Neutral" then
            local eHum = p.Character:FindFirstChildOfClass("Humanoid")
            local eHrp = p.Character:FindFirstChild("HumanoidRootPart")
            if eHum and eHum.Health > 0 and eHrp then
                if state.aimbot.healthCheck and eHum.Health >= myHum.Health then
                    -- Skip enemy if health check fails
                else
                    local targetPart = p.Character:FindFirstChild(state.aimbot.targetPart) or eHrp
                    if targetPart then
                        if state.aimbot.fovEnabled then
                            local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                            if not onScreen then
                                -- Skip if offscreen
                            else
                                local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
                                local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                                if distFromCenter > state.aimbot.fov then
                                    -- Skip if outside desired FOV radius
                                else
                                    local score = (state.aimbot.mode == "Closest Player") and ((hrp.Position - eHrp.Position).Magnitude) or (eHum.Health)
                                    if score < bestScore then
                                        bestScore = score
                                        best = p
                                    end
                                end
                            end
                        else
                            local score = (state.aimbot.mode == "Closest Player") and ((hrp.Position - eHrp.Position).Magnitude) or (eHum.Health)
                            if score < bestScore then
                                bestScore = score
                                best = p
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

-- Update a tool's handle size if it exists
local function updateTool(tool)
    if tool:IsA("Tool") then
        local h = tool:FindFirstChild("Handle")
        if h then h.Size = state.swordSize end
    end
end

-- Update all tools (both in Backpack & Character)
local function updateAllTools()
    local char = getChar()
    for _, tool in ipairs(lp.Backpack:GetChildren()) do updateTool(tool) end
    for _, tool in ipairs(char:GetChildren()) do updateTool(tool) end
end

spawn(function() while wait(0.5) do updateAllTools() end end)
lp.Backpack.ChildAdded:Connect(updateTool)
lp.CharacterAdded:Connect(function(c) c.ChildAdded:Connect(updateTool); updateAllTools() end)

-- Utility: Returns a list of tool names from Backpack & Character (unique)
local function getToolNames()
    local names = {}
    local seen = {}
    local function addTool(tool)
        if tool:IsA("Tool") and not seen[tool.Name] then
            table.insert(names, tool.Name)
            seen[tool.Name] = true
        end
    end
    local char = getChar()
    for _, tool in ipairs(lp.Backpack:GetChildren()) do
        addTool(tool)
    end
    for _, tool in ipairs(char:GetChildren()) do
        addTool(tool)
    end
    return names
end

-- Create UI Tabs
local FarmTab = win:CreateTab("Farm", 4483362458)
local UtilTab = win:CreateTab("Utility", 4483362458)

--------------------------------------------------
-- Farm Tab: Toggles & Customizable Options
--------------------------------------------------

-- Auto Train Toggle with extra options
FarmTab:CreateToggle({
    Name = "Auto Train",
    CurrentValue = false,
    Flag = "Toggle_AutoTrain",
    Callback = function(enabled)
        state.autoTrain.enabled = enabled
        if enabled then
            state.autoTrain.conn = spawn(function()
                while state.autoTrain.enabled do
                    local char = getChar()
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            local ignore = false
                            for _, ignoreName in ipairs(state.autoTrain.ignoreList) do
                                if tool.Name:lower() == ignoreName:lower() then
                                    ignore = true
                                    break
                                end
                            end
                            if not ignore then
                                pcall(tool.Activate, tool)
                            end
                        end
                    end
                    wait(state.autoTrain.delay)
                end
            end)
        else
            state.autoTrain.conn = nil
        end
    end
})

-- Multi-select Dropdown for Auto Train Ignore Tools (lists tools in your Backpack & Character)
local autoTrainIgnoreDropdown = FarmTab:CreateDropdown({
    Name = "Auto Train Ignore Tools",
    Options = getToolNames(),
    Multi = true,
    CurrentOption = {},
    Flag = "Dropdown_AutoTrainIgnore",
    Callback = function(selected)
        state.autoTrain.ignoreList = selected or {}
    end
})

-- Button to refresh the list of available tools in the Auto Train dropdown
FarmTab:CreateButton({
    Name = "Refresh Auto Train Tools",
    Callback = function()
        local options = getToolNames()
        if autoTrainIgnoreDropdown and autoTrainIgnoreDropdown.SetOptions then
            autoTrainIgnoreDropdown:SetOptions(options)
        end
    end
})

-- Slider to adjust Auto Train delay
FarmTab:CreateSlider({
    Name = "Auto Train Delay",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = " sec",
    CurrentValue = state.autoTrain.delay,
    Flag = "Slider_AutoTrainDelay",
    Callback = function(val)
        state.autoTrain.delay = val
    end
})

-- Fast Slash Toggle with adjustable delay
FarmTab:CreateToggle({
    Name = "Fast Slash",
    CurrentValue = false,
    Flag = "Toggle_FastSlash",
    Callback = function(enabled)
        state.fastSlash.enabled = enabled
        if enabled then
            state.fastSlash.conn = spawn(function()
                while state.fastSlash.enabled do
                    local char = getChar()
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            pcall(function() tool.Enabled = true end)
                        end
                    end
                    wait(state.fastSlash.delay)
                end
            end)
        else
            state.fastSlash.conn = nil
        end
    end
})

-- Slider to adjust Fast Slash delay
FarmTab:CreateSlider({
    Name = "Fast Slash Delay",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = " sec",
    CurrentValue = state.fastSlash.delay,
    Flag = "Slider_FastSlashDelay",
    Callback = function(val)
        state.fastSlash.delay = val
    end
})

-- Auto Farm Honor Toggle (with gravity & PlatformStand handling)
FarmTab:CreateToggle({
    Name = "Auto Farm Honor",
    CurrentValue = false,
    Flag = "Toggle_AutoFarmHonor",
    Callback = function(enabled)
        local char = getChar()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if enabled then
            state.oldPos = hrp.Position
            state.oldGravity = WS.Gravity
            WS.Gravity = 0
            hum.PlatformStand = true
            state.autoFarmHonorConn = RS.RenderStepped:Connect(function()
                local target = getBestEnemy()
                if target and target.Character then
                    local eHrp = target.Character:FindFirstChild("HumanoidRootPart")
                    if eHrp then teleport(hrp, eHrp.CFrame * CFrame.new(state.teleportOffset)) end
                end
            end)
        else
            if state.autoFarmHonorConn then state.autoFarmHonorConn:Disconnect() end
            state.autoFarmHonorConn = nil
            WS.Gravity = state.oldGravity or 196.2
            hum.PlatformStand = false
            if state.oldPos then teleport(hrp, CFrame.new(state.oldPos)) end
        end
    end
})

-- Aimbot Toggle with extensive customization including "Instant Snap"
FarmTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Toggle_Aimbot",
    Callback = function(enabled)
        if enabled then
            state.aimbot.enabled = true
            state.aimbot.conn = RS.RenderStepped:Connect(function()
                local cam = WS.CurrentCamera
                if not cam then return end
                local target = getAimbotTarget()
                if target and target.Character then
                    local targetPart = target.Character:FindFirstChild(state.aimbot.targetPart) or target.Character:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        local desiredCFrame = CFrame.new(cam.CFrame.Position, targetPart.Position)
                        if state.aimbot.instantSnap then
                            cam.CFrame = desiredCFrame
                        else
                            cam.CFrame = cam.CFrame:Lerp(desiredCFrame, state.aimbot.smoothness)
                        end
                    end
                end
            end)
        else
            state.aimbot.enabled = false
            if state.aimbot.conn then
                state.aimbot.conn:Disconnect()
                state.aimbot.conn = nil
            end
        end
    end
})

-- Dropdown to choose Aimbot mode (Lowest Health / Closest Player)
FarmTab:CreateDropdown({
    Name = "Aimbot Mode",
    Options = {"Lowest Health", "Closest Player"},
    CurrentOption = state.aimbot.mode,
    Flag = "Dropdown_AimbotMode",
    Callback = function(option)
        state.aimbot.mode = option
    end
})

-- Dropdown to select the target part for Aimbot
FarmTab:CreateDropdown({
    Name = "Aimbot Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = state.aimbot.targetPart,
    Flag = "Dropdown_AimbotTargetPart",
    Callback = function(option)
        state.aimbot.targetPart = option
    end
})

-- Slider to adjust Aimbot smoothness
FarmTab:CreateSlider({
    Name = "Aimbot Smoothness",
    Range = {0.1, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = state.aimbot.smoothness,
    Flag = "Slider_AimbotSmoothness",
    Callback = function(val)
        state.aimbot.smoothness = val
    end
})

-- Toggle to instantly snap the Aimbot (bypasses smooth interpolation)
FarmTab:CreateToggle({
    Name = "Instant Aimbot Snap",
    CurrentValue = state.aimbot.instantSnap,
    Flag = "Toggle_AimbotInstantSnap",
    Callback = function(enabled)
        state.aimbot.instantSnap = enabled
    end
})

-- Toggle for Aimbot FOV filtering
FarmTab:CreateToggle({
    Name = "Aimbot FOV Enabled",
    CurrentValue = state.aimbot.fovEnabled,
    Flag = "Toggle_AimbotFOV",
    Callback = function(enabled)
        state.aimbot.fovEnabled = enabled
    end
})

-- Slider for setting Aimbot FOV radius (in pixels)
FarmTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {10, 300},
    Increment = 5,
    Suffix = " pixels",
    CurrentValue = state.aimbot.fov,
    Flag = "Slider_AimbotFOV",
    Callback = function(val)
        state.aimbot.fov = val
    end
})

-- Toggle for Aimbot Health Check (target only enemies with lower health than you)
FarmTab:CreateToggle({
    Name = "Aimbot Health Check (target only enemies with lower health than you)",
    CurrentValue = state.aimbot.healthCheck,
    Flag = "Toggle_AimbotHealthCheck",
    Callback = function(enabled)
        state.aimbot.healthCheck = enabled
    end
})

-- Dropdown to choose Farm Mode (for Auto Farm Honor)
FarmTab:CreateDropdown({
    Name = "Farm Mode",
    Options = {"Lowest Health", "Closest Player"},
    CurrentOption = state.farmMode,
    Flag = "Dropdown_FarmMode",
    Callback = function(option)
        state.farmMode = option
    end
})

-- Slider to adjust Teleport Offset Y
FarmTab:CreateSlider({
    Name = "Teleport Offset Y",
    Range = {-15, 10},
    Increment = 0.5,
    Suffix = " studs",
    CurrentValue = -15,
    Flag = "Slider_TeleportOffset",
    Callback = function(val)
        state.teleportOffset = Vector3.new(state.teleportOffset.X, val, state.teleportOffset.Z)
    end
})

-- Toggle for Smooth Teleport
FarmTab:CreateToggle({
    Name = "Smooth Teleport",
    CurrentValue = state.smoothTeleport,
    Flag = "Toggle_SmoothTeleport",
    Callback = function(enabled)
        state.smoothTeleport = enabled
    end
})

-- Slider to adjust Teleport Speed
FarmTab:CreateSlider({
    Name = "Teleport Speed",
    Range = {0.1, 2},
    Increment = 0.1,
    Suffix = " sec",
    CurrentValue = state.teleportSpeed,
    Flag = "Slider_TeleportSpeed",
    Callback = function(val)
        state.teleportSpeed = val
    end
})

-- Slider to adjust Sword Reach (handle size)
FarmTab:CreateSlider({
    Name = "Sword Reach",
    Range = {1, 90},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 15,
    Flag = "Slider_SwordReach",
    Callback = function(val)
        state.swordSize = Vector3.new(val, val, val)
        updateAllTools()
    end
})

--------------------------------------------------
-- Utility Tab: Additional Toggles
--------------------------------------------------

-- Safe Zone Toggle (moves you to a safe zone)
UtilTab:CreateToggle({
    Name = "Safe Zone",
    CurrentValue = false,
    Flag = "Toggle_SafeZone",
    Callback = function(enabled)
        local char = getChar()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if enabled then
            state.oldSafeZonePos = hrp.Position
            state.safeZonePart = Instance.new("Part")
            state.safeZonePart.Size = Vector3.new(50, 1, 50)
            state.safeZonePart.Anchored = true
            state.safeZonePart.CanCollide = true
            state.safeZonePart.Position = hrp.Position + Vector3.new(1000, 1000, 1000)
            state.safeZonePart.Parent = WS
            teleport(hrp, state.safeZonePart.CFrame + Vector3.new(0, 7, 0))
        else
            if state.oldSafeZonePos then teleport(hrp, CFrame.new(state.oldSafeZonePos)) end
            if state.safeZonePart then state.safeZonePart:Destroy() end
        end
    end
})