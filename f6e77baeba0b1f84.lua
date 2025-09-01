local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()


local Window = WindUI:CreateWindow({
    Title = "Steal a object show | Mia hub",
    Icon = "door-open",
    Author = "MiaHub",
    Folder = "MiaHub",
})


local StealTab = Window:Tab({
    Title = "Stealing Tab",
    Icon = "bird",
    Locked = false,
})

local Button = StealTab:Button({
    Title = "Teleport to Plot",
    Desc = "teleports to your plot",
    Locked = false,
    Callback = function()
        local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Wait until the character and plot are loaded
local function teleportToOwnPlot()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local plotsFolder = workspace:WaitForChild("Plots")
    local plot = plotsFolder:FindFirstChild(player.Name)

    if plot and plot:IsA("BasePart") then
        -- Plot is a Part
        hrp.CFrame = plot.CFrame + Vector3.new(0, 5, 0)
    elseif plot and plot:IsA("Model") and plot.PrimaryPart then
        -- Plot is a Model with a PrimaryPart set
        hrp.CFrame = plot.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
    else
        warn("Plot for player not found or improperly set up.")
    end
end

-- Call function
teleportToOwnPlot()
    end
})


local Button = StealTab:Button({
    Title = "Instant  prompt",
    Desc = "no matter if the promp has cd.. its instant ",
    Locked = false,
    Callback = function()
        -- Instant ProximityPrompt
game:GetService("RunService").RenderStepped:Connect(function()
    for _, prompt in ipairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.HoldDuration = 0
        end
    end
end)

    end
})


local PlayerTab = Window:Tab({
    Title = "Player Tab",
    Icon = "bird",
    Locked = false,
})


local noclipConnection
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local Toggle = PlayerTab:Toggle({
    Title = "Noclip",
    Desc = "oo u can now noclip through walls i see",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        if state then
            -- Enable noclip
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end)
        else
            -- Disable noclip
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            -- Restore collisions
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
})