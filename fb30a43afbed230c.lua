local TweenService, UIS, rs = game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

-- Modern, "cool" theme with vibrant neon, glass, and shadow
local Theme = {
    Background = Color3.fromRGB(18, 22, 28),
    Glass = Color3.fromRGB(36, 41, 56),
    Neon = Color3.fromRGB(0, 255, 200),
    NeonAlt = Color3.fromRGB(0, 175, 255),
    Button = Color3.fromRGB(36, 41, 56),
    ButtonHover = Color3.fromRGB(40, 80, 120),
    ButtonActive = Color3.fromRGB(0, 255, 200),
    Shadow = Color3.fromRGB(0, 0, 0),
    Text = Color3.fromRGB(240, 255, 255),
    Accent = Color3.fromRGB(0, 175, 255)
}

-- Clipboard copy function for Discord button
local function CopyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    elseif toclipboard then
        toclipboard(text)
        return true
    elseif syn and syn.clipboard then
        syn.clipboard.set(text)
        return true
    end
    return false
end

-- Main UI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "HOKALAZA_GUI"
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "HOKALAZA_MainFrame"
MainFrame.Size = UDim2.new(0, 430, 0, 280)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.15

-- Glass Layer
local Glass = Instance.new("Frame", MainFrame)
Glass.Size = UDim2.new(1, 0, 1, 0)
Glass.BackgroundColor3 = Theme.Glass
Glass.BackgroundTransparency = 0.25
Glass.ZIndex = 2
Instance.new("UICorner", Glass).CornerRadius = UDim.new(0, 22)

-- Frosted shadow effect
local Shadow = Instance.new("ImageLabel", MainFrame)
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Position = UDim2.new(0, -20, 0, -20)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217" -- Soft shadow
Shadow.ImageTransparency = 0.7
Shadow.ZIndex = 1

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 22)

-- Rainbow Neon Border
local NeonBorder = Instance.new("UIStroke", MainFrame)
NeonBorder.Thickness = 4
NeonBorder.Transparency = 0
NeonBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
NeonBorder.LineJoinMode = Enum.LineJoinMode.Round
local hue = 0
rs.RenderStepped:Connect(function()
    hue = (hue + 0.008) % 1
    NeonBorder.Color = Color3.fromHSV(hue, 1, 1)
end)

-- Animated Gradient Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Name = "HOKALAZA_Title"
Title.Text = "HOKALAZA"
Title.Size = UDim2.new(1, -40, 0, 42)
Title.Position = UDim2.new(0, 20, 0, 10)
Title.BackgroundTransparency = 1
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 32
Title.TextStrokeTransparency = 0.4
Title.TextStrokeColor3 = Theme.NeonAlt
Title.ZIndex = 10

-- Title Gradient
local TitleGradient = Instance.new("UIGradient", Title)
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Theme.Neon),
    ColorSequenceKeypoint.new(0.5, Theme.NeonAlt),
    ColorSequenceKeypoint.new(1, Theme.Neon)
}
TitleGradient.Rotation = 25

rs.RenderStepped:Connect(function()
    TitleGradient.Offset = Vector2.new(math.sin(tick()/2)*.15, 0)
end)

-- Tabs Frame
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Name = "HOKALAZA_TabsFrame"
TabsFrame.Size = UDim2.new(0, 110, 1, -64)
TabsFrame.Position = UDim2.new(0, 15, 0, 56)
TabsFrame.BackgroundColor3 = Theme.Button
TabsFrame.BackgroundTransparency = 0.16
TabsFrame.ZIndex = 5
Instance.new("UICorner", TabsFrame).CornerRadius = UDim.new(0, 14)

local TabsShadow = Shadow:Clone()
TabsShadow.Parent = TabsFrame
TabsShadow.ZIndex = 2
TabsShadow.ImageTransparency = 0.92

-- Tab Buttons
local Tabs = {}
local TabContentFrame = Instance.new("Frame", MainFrame)
TabContentFrame.Name = "HOKALAZA_TabContentFrame"
TabContentFrame.Size = UDim2.new(1, -145, 1, -68)
TabContentFrame.Position = UDim2.new(0, 130, 0, 54)
TabContentFrame.BackgroundColor3 = Theme.Background
TabContentFrame.BackgroundTransparency = 0.23
TabContentFrame.ClipsDescendants = true
TabContentFrame.ZIndex = 6
Instance.new("UICorner", TabContentFrame).CornerRadius = UDim.new(0, 14)

local TabContentShadow = Shadow:Clone()
TabContentShadow.Parent = TabContentFrame
TabContentShadow.ZIndex = 2
TabContentShadow.ImageTransparency = 0.93

local function CreateTab(tabName)
    local TabButton = Instance.new("TextButton", TabsFrame)
    TabButton.Name = "HOKALAZA_TabButton_"..tabName:gsub("%s+", "")
    TabButton.Text = tabName
    TabButton.Size = UDim2.new(1, -14, 0, 36)
    TabButton.Position = UDim2.new(0, 7, 0, (#Tabs * 42) + 10)
    TabButton.BackgroundColor3 = Theme.Button
    TabButton.BackgroundTransparency = 0.05
    TabButton.TextColor3 = Theme.Text
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 16
    TabButton.ZIndex = 10
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 10)
    TabButton.AutoButtonColor = false
    local neonLine = Instance.new("Frame", TabButton)
    neonLine.Size = UDim2.new(1, 0, 0, 3)
    neonLine.Position = UDim2.new(0, 0, 1, -3)
    neonLine.BorderSizePixel = 0
    neonLine.BackgroundColor3 = Theme.Neon
    neonLine.Visible = (#Tabs == 0)
    neonLine.ZIndex = 11
    local gradient = Instance.new("UIGradient", neonLine)
    gradient.Color = ColorSequence.new(Theme.Neon, Theme.NeonAlt)
    gradient.Rotation = 0

    local TabFrame = Instance.new("Frame", TabContentFrame)
    TabFrame.Name = "HOKALAZA_"..tabName:gsub("%s+", "").."Tab"
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = (#Tabs == 0)
    TabFrame.ZIndex = 20
    table.insert(Tabs, TabFrame)

    TabButton.MouseEnter:Connect(function()
        TabButton.BackgroundColor3 = Theme.ButtonHover
    end)
    TabButton.MouseLeave:Connect(function()
        if not TabFrame.Visible then
            TabButton.BackgroundColor3 = Theme.Button
        end
    end)
    TabButton.MouseButton1Click:Connect(function()
        for i, frame in pairs(Tabs) do
            frame.Visible = false
            TabsFrame:FindFirstChildOfClass("TextButton", true).BackgroundColor3 = Theme.Button
            TabsFrame:FindFirstChildOfClass("TextButton", true):FindFirstChildOfClass("Frame").Visible = false
        end
        TabFrame.Visible = true
        TabButton.BackgroundColor3 = Theme.ButtonActive
        neonLine.Visible = true
    end)
    return TabFrame
end

-- Button Template
local function CreateButton(parent, text, callback, position)
    local Button = Instance.new("TextButton", parent)
    Button.Name = "HOKALAZA_Button_"..text:gsub("%s+", "")
    Button.Text = text
    Button.Size = UDim2.new(0.7, 0, 0.13, 0)
    Button.Position = position
    Button.BackgroundColor3 = Theme.Button
    Button.BackgroundTransparency = 0.16
    Button.TextColor3 = Theme.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 18
    Button.ZIndex = 100
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    Button.AutoButtonColor = false

    -- Animated Neon Accent
    local Neon = Instance.new("Frame", Button)
    Neon.Size = UDim2.new(1, 0, 0, 3)
    Neon.Position = UDim2.new(0, 0, 1, -3)
    Neon.BackgroundColor3 = Theme.Neon
    Neon.BorderSizePixel = 0
    Neon.ZIndex = 101
    local gradient = Instance.new("UIGradient", Neon)
    gradient.Color = ColorSequence.new(Theme.Neon, Theme.NeonAlt)
    gradient.Rotation = 0

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Theme.ButtonHover
        Neon.BackgroundColor3 = Theme.NeonAlt
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Theme.Button
        Neon.BackgroundColor3 = Theme.Neon
    end)

    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ButtonActive}):Play()
        callback()
        wait(0.2)
        Button.BackgroundColor3 = Theme.Button
    end)
end

-- Main Tab for Teleports
local MainTab = CreateTab("Main")

CreateButton(MainTab, "TP to Train", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/train.github.io/refs/heads/main/train.lua'))()
end, UDim2.new(0.15, 0, 0.10, 0))

CreateButton(MainTab, "TP to Sterling", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/sterlingnotifcation.github.io/refs/heads/main/Sterling.lua'))()
end, UDim2.new(0.15, 0, 0.25, 0))

CreateButton(MainTab, "TP to TeslaLab", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/tptotesla.github.io/refs/heads/main/Tptotesla.lua'))()
end, UDim2.new(0.15, 0, 0.40, 0))

CreateButton(MainTab, "TP to Castle", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua"))()
end, UDim2.new(0.15, 0, 0.55, 0))

CreateButton(MainTab, "TP to Fort", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tpfort.github.io/refs/heads/main/Tpfort.lua"))()
end, UDim2.new(0.15, 0, 0.70, 0))

-- Discord Button (Super cool, glowy)
CreateButton(MainTab, "Join Discord", function()
    local success = CopyToClipboard("https://discord.gg/MFRtEsKm")
    Title.Text = success and "Discord link copied!" or "Copy failed! discord.gg/MFRtEsKm"
    wait(2)
    Title.Text = "HOKALAZA"
end, UDim2.new(0.15, 0, 0.85, 0))

-- Other Tab for Additional Features
local OtherTab = CreateTab("Other")

CreateButton(OtherTab, "TP to End", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hbjrev/tpend.github.io/refs/heads/main/ringta.lua"))()
end, UDim2.new(0.15, 0, 0.08, 0))

CreateButton(OtherTab, "TP to Bank", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tptobank.github.io/refs/heads/main/Banktp.lua"))()
end, UDim2.new(0.15, 0, 0.22, 0))

-- Gun Kill Aura Toggle
local gunKillAuraActive = false
CreateButton(OtherTab, "Gun Aura (Kill Mobs): OFF", function(selfButton)
    gunKillAuraActive = not gunKillAuraActive
    selfButton.Text = gunKillAuraActive and "Gun Aura (Kill Mobs): ON" or "Gun Aura (Kill Mobs): OFF"
    selfButton.BackgroundColor3 = gunKillAuraActive and Theme.ButtonActive or Theme.Button
    if gunKillAuraActive then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Aimbot.github.io/refs/heads/main/Kill.lua"))()
    end
end, UDim2.new(0.15, 0, 0.36, 0))

-- Noclip Toggle
local noclipConnection
CreateButton(OtherTab, "Noclip: OFF", function(selfButton)
    if not noclipConnection then
        noclipConnection = rs.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        selfButton.Text = "Noclip: ON"
        selfButton.BackgroundColor3 = Theme.ButtonActive
    else
        noclipConnection:Disconnect()
        noclipConnection = nil
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        selfButton.Text = "Noclip: OFF"
        selfButton.BackgroundColor3 = Theme.Button
    end
end, UDim2.new(0.15, 0, 0.50, 0))

-- Anti-Void Toggle
local antiVoidActive = false
local antiVoidConnection
CreateButton(OtherTab, "Anti-Void: OFF", function(selfButton)
    antiVoidActive = not antiVoidActive
    if antiVoidActive then
        antiVoidConnection = rs.Stepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                if rootPart.Position.Y < -1 then
                    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/train.github.io/refs/heads/main/train.lua'))()
                end
            end
        end)
        selfButton.Text = "Anti-Void: ON"
        selfButton.BackgroundColor3 = Theme.ButtonActive
    else
        if antiVoidConnection then
            antiVoidConnection:Disconnect()
            antiVoidConnection = nil
        end
        selfButton.Text = "Anti-Void: OFF"
        selfButton.BackgroundColor3 = Theme.Button
    end
end, UDim2.new(0.15, 0, 0.64, 0))

-- Towns Tab for Town Teleports
local TownsTab = CreateTab("Towns")

CreateButton(TownsTab, "Town 1", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringta9321/tptown1.github.io/refs/heads/main/town1.lua"))()
end, UDim2.new(0.15, 0, 0.08, 0))

CreateButton(TownsTab, "Town 2", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringta9321/tptown2.github.io/refs/heads/main/town2.lua"))()
end, UDim2.new(0.15, 0, 0.22, 0))

CreateButton(TownsTab, "Town 3", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringta9321/tptown3.github.io/refs/heads/main/town3.lua"))()
end, UDim2.new(0.15, 0, 0.36, 0))

CreateButton(TownsTab, "Town 4", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringta9321/tptown4.github.io/refs/heads/main/town4.lua"))()
end, UDim2.new(0.15, 0, 0.50, 0))

CreateButton(TownsTab, "Town 5", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringta9321/tptown5.github.io/refs/heads/main/town5.lua"))()
end, UDim2.new(0.15, 0, 0.64, 0))

CreateButton(TownsTab, "Town 6", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringta9321/tptown6.github.io/refs/heads/main/town6.lua"))()
end, UDim2.new(0.15, 0, 0.78, 0))

-- Minimize Button (Neon)
local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Name = "HOKALAZA_MinimizeButton"
MinimizeButton.Text = "—"
MinimizeButton.Size = UDim2.new(0, 38, 0, 38)
MinimizeButton.Position = UDim2.new(1, -46, 0, 10)
MinimizeButton.BackgroundColor3 = Theme.NeonAlt
MinimizeButton.TextColor3 = Theme.Background
MinimizeButton.Font = Enum.Font.GothamBlack
MinimizeButton.TextSize = 28
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 12)
MinimizeButton.ZIndex = 20

-- Reopen Button
local ReopenButton = Instance.new("TextButton", ScreenGui)
ReopenButton.Name = "HOKALAZA_ReopenButton"
ReopenButton.Text = "Open HOKALAZA"
ReopenButton.Size = UDim2.new(0, 192, 0, 40)
ReopenButton.Position = UDim2.new(0.5, 0, 0.02, 0)
ReopenButton.AnchorPoint = Vector2.new(0.5, 0)
ReopenButton.Visible = false
ReopenButton.BackgroundColor3 = Theme.Neon
ReopenButton.TextColor3 = Theme.Background
ReopenButton.Font = Enum.Font.GothamBlack
ReopenButton.TextSize = 22
Instance.new("UICorner", ReopenButton).CornerRadius = UDim.new(0, 12)
ReopenButton.ZIndex = 100

local isMinimized = false

MinimizeButton.MouseButton1Click:Connect(function()
    if not isMinimized then
        isMinimized = true
        TweenService:Create(MainFrame, TweenInfo.new(0.33, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, -0.7, 0),
            Size = UDim2.new(0, 230, 0, 60)
        }):Play()
        wait(0.35)
        MainFrame.Visible = false
        ReopenButton.Visible = true
    end
end)

ReopenButton.MouseButton1Click:Connect(function()
    if isMinimized then
        isMinimized = false
        ReopenButton.Visible = false
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.33, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 430, 0, 280)
        }):Play()
    end
end)

-- Cool: Drag support for both PC/Mobile
local dragToggle, dragStart, startPos, dragInput = false
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragToggle and input == dragInput then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)