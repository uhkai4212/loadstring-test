local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Remote references
local loaderRemote = ReplicatedStorage.RestartRemotes.Loader
local redRemote = ReplicatedStorage.Frontman_Remotes.red
local greenRemote = ReplicatedStorage.Frontman_Remotes.green
local farmRemote = ReplicatedStorage.Spin_Remotes.QuintoPremio
local GiveReward = ReplicatedStorage:WaitForChild("CratesUtilities"):WaitForChild("Remotes"):WaitForChild("GiveReward")

-- Reward categories for admin panel
local rewardCategories = {
    Basic = ReplicatedStorage:WaitForChild("CratesUtilities"):WaitForChild("Itens"):WaitForChild("Basic"):GetChildren(),
    Lucky = ReplicatedStorage:WaitForChild("CratesUtilities"):WaitForChild("Itens"):WaitForChild("Lucky"):GetChildren(),
    Epic = ReplicatedStorage:WaitForChild("CratesUtilities"):WaitForChild("Itens"):WaitForChild("Epic"):GetChildren(),
    Robux = ReplicatedStorage:WaitForChild("CratesUtilities"):WaitForChild("Itens"):WaitForChild("Robux"):GetChildren()
}

-- Theme settings
local currentTheme = "Light"
local themes = {
    Dark = {
        frameBg = Color3.fromRGB(30, 30, 30),
        frameTransparency = 0.3,
        frameStroke = Color3.fromRGB(255, 255, 255),
        buttonBg = Color3.fromRGB(0, 0, 0),
        buttonTransparency = 0.5,
        buttonStroke = Color3.fromRGB(255, 255, 255),
        textColor = Color3.fromRGB(255, 255, 255),
        gradientStart = Color3.fromRGB(40, 40, 40),
        gradientEnd = Color3.fromRGB(20, 20, 20)
    },
    Light = {
        frameBg = Color3.fromRGB(220, 220, 220),
        frameTransparency = 0.3,
        frameStroke = Color3.fromRGB(0, 0, 0),
        buttonBg = Color3.fromRGB(255, 255, 255),
        buttonTransparency = 0.5,
        buttonStroke = Color3.fromRGB(0, 0, 0),
        textColor = Color3.fromRGB(0, 0, 0),
        gradientStart = Color3.fromRGB(240, 240, 240),
        gradientEnd = Color3.fromRGB(200, 200, 200)
    }
}

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "CombinedUI"
mainFrame.Parent = PlayerGui:WaitForChild("HUD")
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Size = UDim2.new(0.25, 0, 0.4, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Selectable = true
mainFrame.Visible = true

-- UI Improvements
local uiCornerFrame = Instance.new("UICorner")
uiCornerFrame.CornerRadius = UDim.new(0, 12)
uiCornerFrame.Parent = mainFrame

local uiStrokeFrame = Instance.new("UIStroke")
uiStrokeFrame.Thickness = 2
uiStrokeFrame.Transparency = 0.4
uiStrokeFrame.Parent = mainFrame

local uiGradient = Instance.new("UIGradient")
uiGradient.Rotation = 90
uiGradient.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Exploit Panel"
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.Cartoon
titleLabel.Parent = mainFrame

-- Main Scrolling Frame (for exploit controls)
local mainScrollingFrame = Instance.new("ScrollingFrame")
mainScrollingFrame.Name = "MainScrollingFrame"
mainScrollingFrame.Size = UDim2.new(1, 0, 0.9, 0)
mainScrollingFrame.Position = UDim2.new(0, 0, 0.1, 0)
mainScrollingFrame.BackgroundTransparency = 1
mainScrollingFrame.BorderSizePixel = 0
mainScrollingFrame.ScrollBarThickness = 4
mainScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
mainScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
mainScrollingFrame.Parent = mainFrame
mainScrollingFrame.Visible = true

local mainListLayout = Instance.new("UIListLayout")
mainListLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainListLayout.Padding = UDim.new(0, 10)
mainListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
mainListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
mainListLayout.Parent = mainScrollingFrame

local mainPadding = Instance.new("UIPadding")
mainPadding.PaddingTop = UDim.new(0, 10)
mainPadding.PaddingBottom = UDim.new(0, 10)
mainPadding.PaddingLeft = UDim.new(0, 10)
mainPadding.PaddingRight = UDim.new(0, 10)
mainPadding.Parent = mainScrollingFrame

-- Admin Panel Scrolling Frame (for reward controls)
local adminScrollingFrame = Instance.new("ScrollingFrame")
adminScrollingFrame.Name = "AdminScrollingFrame"
adminScrollingFrame.Size = UDim2.new(1, 0, 0.9, 0)
adminScrollingFrame.Position = UDim2.new(0, 0, 0.1, 0)
adminScrollingFrame.BackgroundTransparency = 1
adminScrollingFrame.BorderSizePixel = 0
adminScrollingFrame.ScrollBarThickness = 4
adminScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
adminScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
adminScrollingFrame.Parent = mainFrame
adminScrollingFrame.Visible = false

local adminListLayout = Instance.new("UIListLayout")
adminListLayout.SortOrder = Enum.SortOrder.LayoutOrder
adminListLayout.Padding = UDim.new(0, 10)
adminListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
adminListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
adminListLayout.Parent = adminScrollingFrame

local adminPadding = Instance.new("UIPadding")
adminPadding.PaddingTop = UDim.new(0, 10)
adminPadding.PaddingBottom = UDim.new(0, 10)
adminPadding.PaddingLeft = UDim.new(0, 10)
adminPadding.PaddingRight = UDim.new(0, 10)
adminPadding.Parent = adminScrollingFrame

-- Reopen Button
local reopenButton = Instance.new("TextButton")
reopenButton.Name = "ReopenUI"
reopenButton.Parent = PlayerGui:WaitForChild("HUD")
reopenButton.Size = UDim2.new(0.05, 0, 0.05, 0)
reopenButton.Position = UDim2.new(0.95, 0, 0.95, 0)
reopenButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
reopenButton.Text = "Open"
reopenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenButton.Visible = false

local uiCornerReopen = Instance.new("UICorner")
uiCornerReopen.CornerRadius = UDim.new(0, 6)
uiCornerReopen.Parent = reopenButton

reopenButton.Activated:Connect(function()
    mainFrame.Visible = true
    reopenButton.Visible = false
end)

-- Function to apply theme
local function applyTheme()
    local theme = themes[currentTheme]
    mainFrame.BackgroundColor3 = theme.frameBg
    mainFrame.BackgroundTransparency = theme.frameTransparency
    uiStrokeFrame.Color = theme.frameStroke
    titleLabel.TextColor3 = theme.textColor
    uiGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, theme.gradientStart),
        ColorSequenceKeypoint.new(1, theme.gradientEnd)
    }
    -- Apply to main scrolling frame buttons
    for _, child in ipairs(mainScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = theme.buttonBg
            child.BackgroundTransparency = theme.buttonTransparency
            child.TextColor3 = theme.textColor
            local stroke = child:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Color = theme.buttonStroke
            end
            local gradient = child:FindFirstChildOfClass("UIGradient")
            if gradient then
                gradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, theme.gradientStart),
                    ColorSequenceKeypoint.new(1, theme.gradientEnd)
                }
            end
        end
    end
    -- Apply to admin scrolling frame buttons
    for _, child in ipairs(adminScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = theme.buttonBg
            child.BackgroundTransparency = theme.buttonTransparency
            child.TextColor3 = theme.textColor
            local stroke = child:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Color = theme.buttonStroke
            end
            local gradient = child:FindFirstChildOfClass("UIGradient")
            if gradient then
                gradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, theme.gradientStart),
                    ColorSequenceKeypoint.new(1, theme.gradientEnd)
                }
            end
        end
    end
    -- Apply to reopen button
    reopenButton.BackgroundColor3 = theme.buttonBg
    reopenButton.TextColor3 = theme.textColor
end

-- Function to create a styled button
local function createButton(parent, text, onClick)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.95, 0, 0, 50)
    button.BorderSizePixel = 0
    button.Parent = parent
    button.Text = text
    button.TextSize = 18
    button.Font = Enum.Font.Cartoon

    local uiCornerButton = Instance.new("UICorner")
    uiCornerButton.CornerRadius = UDim.new(0, 10)
    uiCornerButton.Parent = button

    local uiStrokeButton = Instance.new("UIStroke")
    uiStrokeButton.Thickness = 1.5
    uiStrokeButton.Transparency = 0.3
    uiStrokeButton.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uiStrokeButton.Parent = button

    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, tweenInfo, {
            Size = UDim2.new(1, 0, 0, 54),
            BackgroundTransparency = themes[currentTheme].buttonTransparency - 0.1
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, tweenInfo, {
            Size = UDim2.new(0.95, 0, 0, 50),
            BackgroundTransparency = themes[currentTheme].buttonTransparency
        }):Play()
    end)
    button.Activated:Connect(function()
        local originalColor = button.BackgroundColor3
        local originalTransparency = button.BackgroundTransparency
        TweenService:Create(button, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            BackgroundTransparency = 0
        }):Play()
        wait(0.1)
        TweenService:Create(button, tweenInfo, {
            BackgroundColor3 = originalColor,
            BackgroundTransparency = originalTransparency
        }):Play()
        onClick()
    end)
    
    return button
end

-- Create main UI buttons
createButton(mainScrollingFrame, "Claim 10000", function()
    loaderRemote:FireServer(false)
    print("Gave 10000")
end)

createButton(mainScrollingFrame, "Kill All", function()
    redRemote:FireServer()
    print("Killed All")
end)

-- Rope Loop (Green Remote)
local isRopeRunning = false
local ropeLoopCoroutine = nil

local function startRopeLoop()
    if not isRopeRunning then
        isRopeRunning = true
        ropeLoopCoroutine = coroutine.create(function()
            while isRopeRunning do
                greenRemote:FireServer()
                print("Fired Green Remote (Rope)")
                wait(1)
            end
        end)
        coroutine.resume(ropeLoopCoroutine)
    end
end

local function stopRopeLoop()
    if isRopeRunning then
        isRopeRunning = false
        if ropeLoopCoroutine then
            coroutine.close(ropeLoopCoroutine)
            ropeLoopCoroutine = nil
        end
    end
end

createButton(mainScrollingFrame, "Stop Rope", startRopeLoop)
createButton(mainScrollingFrame, "Start Rope", stopRopeLoop)

-- Farm Loop
local isFarmRunning = false
local farmLoopCoroutine = nil

local function startFarmLoop()
    if not isFarmRunning then
        isFarmRunning = true
        farmLoopCoroutine = coroutine.create(function()
            while isFarmRunning do
                GiveReward:FireServer("1000000")
                print("Fired Farm Remote")
                wait(0.1)
            end
        end)
        coroutine.resume(farmLoopCoroutine)
    end
end

local function stopFarmLoop()
    if isFarmRunning then
        isFarmRunning = false
        if farmLoopCoroutine then
            coroutine.close(farmLoopCoroutine)
            farmLoopCoroutine = nil
        end
    end
end

createButton(mainScrollingFrame, "Start Cash Farm", startFarmLoop)
createButton(mainScrollingFrame, "Stop Cash Farm", stopFarmLoop)

-- Button to toggle Admin Panel
createButton(mainScrollingFrame, "Show Reward Panel", function()
    mainScrollingFrame.Visible = false
    adminScrollingFrame.Visible = true
    titleLabel.Text = "Reward Giver Panel"
    print("Switched to Reward Panel")
end)

-- Theme Toggle Button (main UI)
createButton(mainScrollingFrame, "Toggle Theme", function()
    currentTheme = currentTheme == "Dark" and "Light" or "Dark"
    applyTheme()
    print("Theme changed to " .. currentTheme)
end)

-- Close Button (main UI)
createButton(mainScrollingFrame, "Close UI", function()
    mainFrame.Visible = false
    reopenButton.Visible = true
    print("UI Closed")
end)

-- Create admin panel buttons
for category, items in pairs(rewardCategories) do
    for _, item in ipairs(items) do
        createButton(adminScrollingFrame, string.format("%s: %s", category, item.Name), function()
            GiveReward:FireServer(item.Name)
            print(string.format("Awarded %s from %s to %s", item.Name, category, LocalPlayer.Name))
        end)
    end
end

-- Back Button (admin panel)
createButton(adminScrollingFrame, "Back to Main", function()
    adminScrollingFrame.Visible = false
    mainScrollingFrame.Visible = true
    titleLabel.Text = "Exploit Panel"
    print("Switched to Main Panel")
end)

-- Theme Toggle Button (admin panel)
createButton(adminScrollingFrame, "Toggle Theme", function()
    currentTheme = currentTheme == "Dark" and "Light" or "Dark"
    applyTheme()
    print("Theme changed to " .. currentTheme)
end)

-- Close Button (admin panel)
createButton(adminScrollingFrame, "Close UI", function()
    mainFrame.Visible = false
    reopenButton.Visible = true
    print("UI Closed")
end)

-- Initial theme apply
applyTheme()

-- Fade-in animation for main frame
mainFrame.BackgroundTransparency = 1
TweenService:Create(mainFrame, TweenInfo.new(0.5), {BackgroundTransparency = themes[currentTheme].frameTransparency}):Play()