local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Remotes
local Rebirth = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Rebirth")
local Ascend = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Ascend")
local GiveOutReward = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Roulette"):WaitForChild("GiveOutReward")
local LayerChanged = ReplicatedStorage:WaitForChild("Events"):WaitForChild("LayerChanged")

-- Flags
local rebirthEnabled = false
local sacrificeEnabled = false
local moneyEnabled = false
local trophiesEnabled = false
local moneyPotionEnabled = false
local luckPotionEnabled = false
local chewingPotionEnabled = false
local jumpPotionEnabled = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChocolatewaterGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main panel frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 350)
mainFrame.Position = UDim2.new(0, 20, 0, 60)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Title bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 320, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Chocolatewater - Bubble gum Jumping"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = screenGui

-- Minimize/Show Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 150, 0, 30)
toggleButton.Position = UDim2.new(0, 340, 0, 5)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Hide Controls"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 16
toggleButton.Parent = screenGui

local isMinimized = false
toggleButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    mainFrame.Visible = not isMinimized
    toggleButton.Text = isMinimized and "Show Controls" or "Hide Controls"
end)

-- Button Factory
local function createToggleButton(name, yOffset, toggleCallback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 280, 0, 35)
    button.Position = UDim2.new(0, 20, 0, yOffset)
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name .. ": OFF"
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Parent = mainFrame

    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = name .. ": " .. (state and "ON" or "OFF")
        toggleCallback(state)
    end)
end

-- Create Toggle Buttons
createToggleButton("Rebirth", 50, function(on) rebirthEnabled = on end)
createToggleButton("Sacrifice", 90, function(on) sacrificeEnabled = on end)
createToggleButton("Infinite Money", 130, function(on) moneyEnabled = on end)
createToggleButton("Infinite Trophies", 170, function(on) trophiesEnabled = on end)
createToggleButton("Money Potion", 210, function(on) moneyPotionEnabled = on end)
createToggleButton("Luck Potion", 250, function(on) luckPotionEnabled = on end)
createToggleButton("Chewing Power Potion", 290, function(on) chewingPotionEnabled = on end)
createToggleButton("Jump Power Potion", 330, function(on) jumpPotionEnabled = on end)

-- Main loop
RunService.RenderStepped:Connect(function()
    if rebirthEnabled then
        Rebirth:FireServer()
    end
    if sacrificeEnabled then
        Ascend:FireServer()
    end
    if moneyEnabled then
        GiveOutReward:FireServer({
            value = 9e999999999999,
            type = "Money",
            chance = 0.3
        })
    end
    if trophiesEnabled then
        local args = {
            [1] = "Layer6"
        }
        LayerChanged:FireServer(unpack(args))
    end
    if moneyPotionEnabled then
        local args = {
            [1] = {
                chance = 0.15,
                type = "Potion",
                name = "Money"
            }
        }
        GiveOutReward:FireServer(unpack(args))
    end
    if luckPotionEnabled then
        local args = {
            [1] = {
                chance = 0.15,
                type = "Potion",
                name = "Luck"
            }
        }
        GiveOutReward:FireServer(unpack(args))
    end
    if chewingPotionEnabled then
        local args = {
            [1] = {
                chance = 0.15,
                type = "Potion",
                name = "ChewingPower"
            }
        }
        GiveOutReward:FireServer(unpack(args))
    end
    if jumpPotionEnabled then
        local args = {
            [1] = {
                chance = 0.15,
                type = "Potion",
                name = "JumpPower"
            }
        }
        GiveOutReward:FireServer(unpack(args))
    end
end)