local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AddValueEvent = ReplicatedStorage.Remotes.AddValueEvent

AddValueEvent:FireServer(
    "Cash",
    9e45
)

setclipboard("https://discord.gg/TR3quUFgT6")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GemEvent = ReplicatedStorage.Remotes.GemEvent 

GemEvent:FireServer(
    9e45
)