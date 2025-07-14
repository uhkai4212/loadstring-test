local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

-- Create the main GUI window
local gui = Instance.new("ScreenGui")
gui.Name = "TGMANKASKE"
gui.Parent = LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Parent = gui

-- Function to create a button
local function createButton(name, position, func)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 30)
    button.Position = position
    button.Text = name
    button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Parent = frame
    button.MouseButton1Click:Connect(func)
end

-- Button functionalities
local savedPosition = nil

-- Boost Speed
createButton("Boost Speed", UDim2.new(0, 10, 0, 10), function()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 40
        end
    end
end)

-- Boost Jump
createButton("Boost Jump", UDim2.new(0, 120, 0, 10), function()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = 70
        end
    end
end)

-- Save Base Position
createButton("Save Base Position", UDim2.new(0, 10, 0, 50), function()
    local character = LocalPlayer.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            savedPosition = rootPart.Position
        end
    end
end)

-- Go to Saved Position
createButton("Go to Saved Position", UDim2.new(0, 120, 0, 50), function()
    local character = LocalPlayer.Character
    if character and savedPosition then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = CFrame.new(savedPosition)})
            tween:Play()
        end
    end
end)

-- Server Hop
createButton("Server Hop", UDim2.new(0, 10, 0, 90), function()
    local placeId = game.PlaceId
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua"))()
    TeleportService:Teleport(placeId)
end)

-- Rejoin
createButton("Rejoin", UDim2.new(0, 120, 0, 90), function()
    TeleportService:Teleport(game.PlaceId)
end)

-- See my team
createButton("See my team", UDim2.new(0, 10, 0, 130), function()
    local team = LocalPlayer.Team
    print("Your team: " .. (team and team.Name or "No team"))
end)

-- Credits
createButton("Credits: TGMANKASKE", UDim2.new(0, 10, 0, 170), function()
    print("TGMANKASKE")
end)

createButton("Credits: Davitrolz", UDim2.new(0, 120, 0, 170), function()
    print("Davitrolz")
end)

-- Character added event to reset speed and jump power
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    RunService.RenderStepped:Connect(function()
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end)
end)

-- Ensure initial character settings
if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end