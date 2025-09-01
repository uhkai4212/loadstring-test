local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0.5, -125, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 0, 40)
label.Position = UDim2.new(0, 10, 0, 5)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 80, 80)
label.TextScaled = true
label.Font = Enum.Font.SourceSansBold
label.Text = "YOU NEED TO LAUNCH BEFORE CLICKING TELEPORT, OR ELSE IT WONT WORK"
label.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.6, 0, 0, 40)
button.Position = UDim2.new(0.2, 0, 0.6, 0)
button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.Text = "Teleport"
button.Parent = frame

button.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(Vector3.new(0, 10, -100000000000))
end)

setclipboard("https://discord.gg/TR3quUFgT6")