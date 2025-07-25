local v = require(game:GetService("StarterPlayer").StarterPlayerScripts["TSFL Client"].Modules.BallNetworking)
local x = require(game:GetService("Players").LocalPlayer.PlayerScripts["TSFL Client"].Modules.BallNetworking)

local oldfunction = x.IsDistanceTooBig
local oldfunction1 = v.IsDistanceTooBig
local function1 = x.VerifyHit
local function2 = v.VerifyHit
local another1 = x.IsBallBoundingHitbox
local another2 = v.IsBallBoundingHitbox

local function v1() return false end
local function v2() return true end

hookfunction(oldfunction, v1)
hookfunction(oldfunction1, v1)
hookfunction(function1, v1)
hookfunction(function2, v1)
hookfunction(another1, v2)
hookfunction(another2, v2)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Cracked by scriptblox CRACKL",
    SubTitle = "credits to Verified",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 400),
    Acrylic = true,
    Theme = "Light",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Reach", Icon = "circle" })
}

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Default reach distance
local reach = 10

-- Parts to apply the reach to
local partNames = {"Right Leg", "Left Leg", "Torso", "Head"}

-- Slider for reach
Tabs.Main:AddSlider("ReachSlider", {
    Title = "Reach Distance",
    Description = "Set the reach distance (default: 10)",
    Default = reach,
    Min = 1,
    Max = 15,
    Rounding = 1,
    Callback = function(Value)
        -- Ensure Value is a number to avoid string comparisons
        local num = tonumber(Value) or reach
        reach = num
        print("Reach set to: " .. reach)
    end
})

-- Utility functions
local function isUUID(str)
    return string.match(str, "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
end

local function pu()
    local ballsFolder = Workspace:FindFirstChild("Balls")
    if not ballsFolder then return nil end
    for _, part in pairs(ballsFolder:GetDescendants()) do
        if part:IsA("BasePart") and isUUID(part.Name) then
            return part
        end
    end
    return nil
end

getgenv().TPSBALL = pu()

local function getCurrentBalls()
    local currentBalls = {}
    local ballsFolder = Workspace:FindFirstChild("Balls")
    if ballsFolder then
        for _, descendant in pairs(ballsFolder:GetDescendants()) do
            if descendant:IsA("BasePart") and isUUID(descendant.Name) then
                table.insert(currentBalls, descendant)
            end
        end
    end
    return currentBalls
end

-- Input handler: quantum touch on listed parts
local function onQuantumInputBegan(input, gameProcessedEvent)
    local ignoredKeys = {
        [Enum.KeyCode.W] = true,
        [Enum.KeyCode.A] = true,
        [Enum.KeyCode.S] = true,
        [Enum.KeyCode.D] = true,
        [Enum.KeyCode.Space] = true,
        [Enum.KeyCode.Slash] = true,
        [Enum.KeyCode.Semicolon] = true
    }

    if ignoredKeys[input.KeyCode] or gameProcessedEvent then return end

    for _, partName in pairs(partNames) do
        local part = Player.Character and Player.Character:FindFirstChild(partName)
        if part then
            for _, v in pairs(part:GetDescendants()) do
                if v.Name == "TouchInterest" and v.Parent then
                    for _, e in pairs(getCurrentBalls()) do
                        if e and e.Position and part.Position and (e.Position - part.Position).Magnitude < reach then
                            pcall(function()
                                firetouchinterest(e, v.Parent, 0)
                                firetouchinterest(e, v.Parent, 1)
                            end)
                            return
                        end
                    end
                end
            end
        end
    end
end

UserInputService.InputBegan:Connect(onQuantumInputBegan)

-- Continual touch in RenderStepped
RunService.RenderStepped:Connect(function()
    for _, partName in pairs(partNames) do
        local part = Player.Character and Player.Character:FindFirstChild(partName)
        if part then
            for _, v in pairs(part:GetDescendants()) do
                if v.Name == "TouchInterest" and v.Parent then
                    for _, e in pairs(getCurrentBalls()) do
                        if e and e.Position and part.Position and (e.Position - part.Position).Magnitude < reach then
                            pcall(function()
                                firetouchinterest(e, v.Parent, 0)
                                firetouchinterest(e, v.Parent, 1)
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- Update genv ball pointer periodically
while wait(0.1) do
    getgenv().TPSBALL = pu()
end