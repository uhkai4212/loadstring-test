local Library = loadstring(game:HttpGet("https://pastefy.app/Rf8iYjYI/raw"))()

local Window = Library:CreateWindow("Dinas Hub")
local Tab1 = Window:AddTab("Game")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GiveOutReward = ReplicatedStorage.Remotes.Roulette.GiveOutReward

local rewardValue = 5000

Tab1:AddTextbox({
    Text = "Set Money (for infinity set 9e925) ",
    Placeholder = "Set your money...",
    Callback = function(Value)
        local numValue = tonumber(Value)
        if numValue and numValue > 0 then
            rewardValue = numValue
        else
        end
    end
})

Tab1:AddButton({
    Text = "Get Money",
    Callback = function()
        GiveOutReward:FireServer({
            value = rewardValue,
            type = "Money",
            chance = 0.45
        })
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LayerChanged = ReplicatedStorage.Events.LayerChanged

Tab1:AddButton({
    Text = "Inf Wins",
    Callback = function()
        LayerChanged:FireServer("Layer6")
    end
})

Tab1:AddLabel({
    Text = "Other",
    Size = 18,
    Color = Color3.new(1, 0.5, 0),
    Center = true,
    Stroke = true
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rebirth = ReplicatedStorage.Events.Rebirth

Tab1:AddButton({
    Text = "Auto Rebirth",
    Callback = function()
        Rebirth:FireServer()
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Bubble = ReplicatedStorage.Remotes.Bubble

local isRunning = false
local runningCoroutine

Tab1:AddButton({
    Text = "Auto Bubble",
    Callback = function()
        if isRunning then
            return
        end

        isRunning = true

        runningCoroutine = coroutine.create(function()
            while isRunning do
                Bubble:FireServer()
                wait()
            end
        end)

        coroutine.resume(runningCoroutine)
    end
})

Tab1:AddButton({
    Text = "Stop Auto Bubble",
    Callback = function()
        if not isRunning then
            return
        end

        isRunning = false
    end
})