local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "FollowGUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 350)
frame.Position = UDim2.new(0, 20, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Neon cyan border
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2.5
stroke.Color = Color3.fromRGB(0, 255, 255)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

-- Title bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "{ LUCENT HUB }"
title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local titleStroke = Instance.new("UIStroke", title)
titleStroke.Thickness = 1.5
titleStroke.Color = Color3.fromRGB(0, 200, 255)

-- Minimize Button
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 30, 0, 30)
minButton.Position = UDim2.new(1, -40, 0, 5)
minButton.BackgroundColor3 = Color3.fromRGB(20,20,30)
minButton.Text = "-"
minButton.TextColor3 = Color3.fromRGB(0,255,255)
minButton.Font = Enum.Font.GothamBold
minButton.TextSize = 22
minButton.Parent = frame
local minCorner = Instance.new("UICorner", minButton)
minCorner.CornerRadius = UDim.new(0,6)

-- Follow All Button
local allButton = Instance.new("TextButton")
allButton.Size = UDim2.new(1, -20, 0, 35)
allButton.Position = UDim2.new(0, 10, 0, 50)
allButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
allButton.TextColor3 = Color3.fromRGB(0, 255, 255)
allButton.Text = "FOLLOW ALL"
allButton.Font = Enum.Font.GothamBold
allButton.TextScaled = true
allButton.Parent = frame
local allCorner = Instance.new("UICorner", allButton)
allCorner.CornerRadius = UDim.new(0,8)
local allStroke = Instance.new("UIStroke", allButton)
allStroke.Color = Color3.fromRGB(0,255,255)
allStroke.Thickness = 1.5

-- ScrollingFrame for players
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -110)
scrollingFrame.Position = UDim2.new(0, 10, 0, 95)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(10,10,15)
scrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.Parent = frame

local scrollCorner = Instance.new("UICorner", scrollingFrame)
scrollCorner.CornerRadius = UDim.new(0,8)
local scrollStroke = Instance.new("UIStroke", scrollingFrame)
scrollStroke.Color = Color3.fromRGB(0,255,255)
scrollStroke.Thickness = 1

local listLayout = Instance.new("UIListLayout", scrollingFrame)
listLayout.Padding = UDim.new(0,6)