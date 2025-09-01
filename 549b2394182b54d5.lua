local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GiveMoney = ReplicatedStorage.Events.GiveMoney

GiveMoney:FireServer(
    9e500
)
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local player = players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteLoopUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(260, 120)
frame.Position = UDim2.new(0.5, -130, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 24)
title.Position = UDim2.fromOffset(10, 8)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)
title.Text = "remote loop"
title.Parent = frame

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(24, 24)
minimize.Position = UDim2.new(1, -28, 0, 8)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.SourceSansBold
minimize.TextSize = 20
minimize.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.fromOffset(10, 36)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 16
statusLabel.TextColor3 = Color3.new(1,1,1)
statusLabel.Text = "idle"
statusLabel.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 44)
button.Position = UDim2.fromOffset(10, 66)
button.Text = "start loop"
button.Font = Enum.Font.SourceSansSemibold
button.TextSize = 18
button.BackgroundColor3 = Color3.fromRGB(70,70,70)
button.TextColor3 = Color3.new(1,1,1)
button.Parent = frame

local minimizedBtn = Instance.new("TextButton")
minimizedBtn.Size = UDim2.fromOffset(30, 30)
minimizedBtn.Position = UDim2.new(0, 20, 0, 200)
minimizedBtn.Text = "-"
minimizedBtn.Font = Enum.Font.SourceSansBold
minimizedBtn.TextSize = 24
minimizedBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimizedBtn.TextColor3 = Color3.new(1,1,1)
minimizedBtn.Visible = false
minimizedBtn.Parent = screenGui

local items = {
    "Rocket Booster","Firework Accelerator","Fuel Generator","Best Engine",
    "Monster Wheel","Best Fuel","Strong Block","Strong Slab","Better Engine",
    "Fast Wheel","Better Fuel","Engine","Seat","Wheel","Fuel Can","Block","Slab"
}

local buyRemote
local eventsFolder = replicatedStorage:FindFirstChild("Events")
if eventsFolder then
    buyRemote = eventsFolder:FindFirstChild("Buy")
end

local looping = false
local function startLoop()
    if looping then return end
    looping = true
    button.Text = "stop loop"
    statusLabel.Text = "running ("..#items.." items)"
    task.spawn(function()
        while looping do
            for _, name in ipairs(items) do
                if not looping then break end
                if buyRemote then
                    buyRemote:FireServer(name)
                end
                task.wait(0.01)
            end
        end
        statusLabel.Text = "stopped"
    end)
end

local function stopLoop()
    looping = false
    button.Text = "start loop"
end

button.MouseButton1Click:Connect(function()
    if looping then stopLoop() else startLoop() end
end)

minimize.MouseButton1Click:Connect(function()
    frame.Visible = false
    minimizedBtn.Visible = true
end)

minimizedBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    minimizedBtn.Visible = false
end)
setclipboard("https://discord.gg/TR3quUFgT6")