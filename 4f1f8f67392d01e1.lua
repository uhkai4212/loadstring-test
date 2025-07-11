local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "HOKALAZA Suite",
    SubTitle = "Parry Automation",
    TabWidth = 180,
    Size = UDim2.fromOffset(560, 440),
    Acrylic = true,
    Theme = "Light",
    Accent = Color3.fromRGB(80, 200, 120), -- Mint green accent
    MinimizeKey = Enum.KeyCode.F4
})

local Tabs = {
    Overview = Window:AddTab({ Title = "Overview", Icon = "layout" }),
    Automation = Window:AddTab({ Title = "Automation", Icon = "zap" }),
    Visual = Window:AddTab({ Title = "Visuals", Icon = "monitor" }),
    Tweaks = Window:AddTab({ Title = "Tweaks", Icon = "wrench" }),
    Community = Window:AddTab({ Title = "Community", Icon = "heart" })
}

-- Community Tab
Tabs.Community:AddParagraph({
    Title = "💬 Discord Community",
    Content = "Join for support and updates:\n\nhttps://discord.gg/utz7mspGVf"
})
Tabs.Community:AddButton({
    Title = "Copy Discord Link",
    Description = "Copies invite to clipboard",
    Callback = function()
        setclipboard("https://discord.gg/utz7mspGVf")
        Fluent:Notify({
            Title = "Copied!",
            Content = "Discord invite copied.",
            Duration = 2
        })
    end
})

Fluent:Notify({
    Title = "Join Us 💬",
    Content = "https://discord.gg/utz7mspGVf",
    Duration = 0
})

-- Roblox Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local MousePosition = Vector2.new(0, 0)
local autoParryEnabled = false
local rageModeEnabled = false
local parryDistanceThreshold = 40
local parryConn, parryChildConn
local ballData = {}

-- Anti-AFK
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

-- Mod Detector
local modList = { "AdminName1", "Moderator", "ModNameHere" }
Players.PlayerAdded:Connect(function(plr)
    for _, modName in ipairs(modList) do
        if plr.Name:lower() == modName:lower() then
            Player:Kick("Mod Detected: " .. plr.Name)
        end
    end
end)

-- Debug Overlay Setup (customized)
local function createDebugOverlay()
    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "ParryDebug"
    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(0, 350, 0, 26)
    label.Position = UDim2.new(1, -370, 0, 18)
    label.BackgroundTransparency = 0.2
    label.BackgroundColor3 = Color3.fromRGB(190, 230, 200)
    label.TextColor3 = Color3.fromRGB(30, 90, 60)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = "HOKALAZA: Ready"
    return label
end
local debugLabel = createDebugOverlay()

-- Ball logic
local function GetBall()
    local folder = workspace:FindFirstChild("Balls")
    if folder then
        for _, b in ipairs(folder:GetChildren()) do
            if b:GetAttribute("realBall") then
                return b
            end
        end
    end
    return nil
end

local function ResetParry()
    if parryConn then parryConn:Disconnect() end
    if parryChildConn then parryChildConn:Disconnect() end
    for _, data in pairs(ballData) do
        if data.parryConnAttr then data.parryConnAttr:Disconnect() end
    end
    ballData = {}
end

local function bindParryAttr(ball)
    if not ballData[ball] then
        ballData[ball] = { IsParried = false, Cooldown = 0, TimeToHit = math.huge, parryConnAttr = nil }
    end
    if ballData[ball].parryConnAttr then
        ballData[ball].parryConnAttr:Disconnect()
    end
    ballData[ball].parryConnAttr = ball:GetAttributeChangedSignal("target"):Connect(function()
        ballData[ball].IsParried = false
        ballData[ball].Cooldown = 0
        ballData[ball].TimeToHit = math.huge
    end)
end

local function setupParry()
    ResetParry()
    local ball = GetBall()
    if ball then
        bindParryAttr(ball)
    end

    parryChildConn = workspace.Balls.ChildAdded:Connect(function(child)
        if autoParryEnabled and child:GetAttribute("realBall") then
            bindParryAttr(child)
        end
    end)

    parryConn = RunService.Heartbeat:Connect(function()
        if not autoParryEnabled then return end
        local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local ball = GetBall()
        if not ball or not ball:FindFirstChild("zoomies") or ball.Anchored then
            debugLabel.Text = "No ball detected"
            return
        end

        bindParryAttr(ball)
        local data = ballData[ball]
        local pos = ball.Position
        local vel = ball.zoomies.VectorVelocity
        local dist = (hrp.Position - pos).Magnitude

        if vel.Magnitude >= 0.5 and dist <= parryDistanceThreshold then
            local forwardDist = (hrp.Position - pos):Dot(vel.Unit)
            local tth = forwardDist / vel.Magnitude
            data.TimeToHit = tth

            local baseSpeed = 50
            local baseLower = 0.1
            local baseUpper = 0.8
            local speedFactor = baseSpeed / math.max(vel.Magnitude, baseSpeed)
            local lowerTTH = baseLower * speedFactor
            local upperTTH = baseUpper * speedFactor

            if ball:GetAttribute("target") == Player.Name and (not data.IsParried) and tth >= lowerTTH and tth <= upperTTH then
                VirtualInputManager:SendMouseButtonEvent(MousePosition.X, MousePosition.Y, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(MousePosition.X, MousePosition.Y, 0, false, game, 0)
                data.IsParried = true
                data.Cooldown = tick()
                debugLabel.Text = "🎯 Parried: " .. ball.Name
            end
        else
            debugLabel.Text = "No threat detected"
        end

        for _, d in pairs(ballData) do
            if tick() - d.Cooldown >= 0.3 then
                d.IsParried = false
            end
        end

        if rageModeEnabled then
            local ball = GetBall()
            if ball and ball:FindFirstChild("zoomies") and (not ballData[ball].IsParried) then
                local pos = ball.Position
                local vel = ball.zoomies.VectorVelocity
                local dist = (hrp.Position - pos).Magnitude
                if vel.Magnitude >= 50 and dist <= 15 and ball:GetAttribute("target") == Player.Name then
                    VirtualInputManager:SendMouseButtonEvent(MousePosition.X, MousePosition.Y, 0, true, game, 0)
                    VirtualInputManager:SendMouseButtonEvent(MousePosition.X, MousePosition.Y, 0, false, game, 0)
                    ballData[ball].IsParried = true
                    ballData[ball].Cooldown = tick()
                    debugLabel.Text = "💢 Rage Parry: " .. ball.Name
                end
            end
        end
    end)
end

UserInputService.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement then
        MousePosition = i.Position
    end
end)

-- Overview Tab
Tabs.Overview:AddParagraph({
    Title = "Welcome to HOKALAZA Suite!",
    Content = "Easily configure your AutoParry, visuals, and performance tweaks."
})

-- Automation Tab controls
Tabs.Automation:AddSection("Automation Controls")
Tabs.Automation:AddToggle("AutoParry", {
    Title = "Enable Auto Parry",
    Default = false
}):OnChanged(function(val)
    autoParryEnabled = val
    if val then
        setupParry()
    else
        ResetParry()
        debugLabel.Text = "AutoParry Disabled"
    end
end)
Tabs.Automation:AddToggle("RageMode", {
    Title = "💢 Rage Mode",
    Default = false
}):OnChanged(function(val)
    rageModeEnabled = val
    debugLabel.Text = val and "Rage Mode Enabled" or "Rage Mode Disabled"
end)
Tabs.Automation:AddSlider("ParryDistance", {
    Title = "Parry Distance (Studs)",
    Description = "Auto parry only within this distance.",
    Default = parryDistanceThreshold,
    Min = 10,
    Max = 100,
    Rounding = 0
}):OnChanged(function(val)
    parryDistanceThreshold = val
    debugLabel.Text = "Parry Distance set to " .. val
end)

-- Visual Tab controls
Tabs.Visual:AddSection("Performance & Overlays")
Tabs.Visual:AddToggle("FPSBooster", {
    Title = "FPS Booster",
    Default = false
}):OnChanged(function(val)
    if val then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            if Lighting then
                Lighting.GlobalShadows = false
                Lighting.Technology = Enum.Technology.Compatibility
            end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") then
                    obj.Enabled = false
                end
            end
            debugLabel.Text = "FPS Booster Activated"
        end)
    else
        debugLabel.Text = "FPS Booster Disabled"
    end
end)

local SHOW_FPS = false
local SHOW_BALL_SPEED = false
Tabs.Visual:AddToggle("ShowFPS", {
    Title = "Show FPS",
    Default = false
}):OnChanged(function(val) SHOW_FPS = val end)
Tabs.Visual:AddToggle("ShowBallSpeed", {
    Title = "Show Ball Speed",
    Default = false
}):OnChanged(function(val) SHOW_BALL_SPEED = val end)

local perfGui = Instance.new("ScreenGui", CoreGui)
perfGui.Name = "PerfMetrics"
perfGui.Enabled = false

local fpsLabel = Instance.new("TextLabel", perfGui)
fpsLabel.Size = UDim2.new(0, 200, 0, 30)
fpsLabel.Position = UDim2.new(0, 10, 0, 10)
fpsLabel.BackgroundTransparency = 0.4
fpsLabel.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
fpsLabel.TextColor3 = Color3.new(1, 1, 1)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 20
fpsLabel.Text = "FPS: N/A"

local ballSpeedLabel = Instance.new("TextLabel", perfGui)
ballSpeedLabel.Size = UDim2.new(0, 300, 0, 30)
ballSpeedLabel.Position = UDim2.new(0, 10, 0, 50)
ballSpeedLabel.BackgroundTransparency = 0.4
ballSpeedLabel.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
ballSpeedLabel.TextColor3 = Color3.new(1, 1, 1)
ballSpeedLabel.Font = Enum.Font.GothamBold
ballSpeedLabel.TextSize = 20
ballSpeedLabel.Text = "Ball Speed: N/A"
perfGui.Parent = CoreGui

RunService.Heartbeat:Connect(function()
    perfGui.Enabled = SHOW_FPS or SHOW_BALL_SPEED
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    if SHOW_FPS then
        fpsLabel.Text = "FPS: " .. fps
    end
    if SHOW_BALL_SPEED then
        local ball = GetBall()
        local maxSpeed = 0
        if ball and ball:FindFirstChild("zoomies") then
            local spd = ball.zoomies.VectorVelocity.Magnitude
            maxSpeed = spd
        end
        ballSpeedLabel.Text = "Ball Speed: " .. string.format("%.2f", maxSpeed)
    end
end)

-- Tweaks & Settings
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("HOKALAZA")
SaveManager:SetFolder("HOKALAZA/Config")
InterfaceManager:BuildInterfaceSection(Tabs.Tweaks)
SaveManager:BuildConfigSection(Tabs.Tweaks)
Window:SelectTab(1)
Fluent:Notify({
    Title = "Loaded",
    Content = "AutoParry Suite Ready ✔️",
    Duration = 2.5
})
SaveManager:LoadAutoloadConfig()