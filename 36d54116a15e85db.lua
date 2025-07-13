local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local mouse = Players.LocalPlayer:GetMouse()
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua"))()
local window = ui.new({text="booga booga :flushed:", size=Vector2.new(400, 300)})
local mainTab = window.new({text="main"})
local combatTab = window.new({text="combat"})
local autofarmTab = window.new({text="autofarm"})
local killauraToggle = combatTab.new("Switch", {text="kill aura"})
local autohealToggle = combatTab.new("Switch", {text="auto heal"})
local autohealSlider = combatTab.new("Slider", {text="auto heal health", min=1, max=99, value=30})
local breakauraToggle = mainTab.new("Switch", {text="mine aura"})
local pickupToggle = mainTab.new("Switch", {text="auto pickup"})
local autofarmToggle = autofarmTab.new("Switch", {text="everything autofarm"})
mainTab.new("Label", {text="fly will freeze you when you run it"})
local flyToggle = mainTab.new("Switch", {text="fly"})
local autoPlant = autofarmTab.new("Switch", {text="auto plant fruit"})
local autoharvest = autofarmTab.new("Switch", {text="auto harvest fruit"})
local chosenFruit = "Bloodfruit"
local fruits = {
    "Bloodfruit",
    "Sunfruit",
    "Bluefruit",
    "Berry"
}
local autoplantDropdown = autofarmTab.new("Dropdown", {text="fruits"})
local plantButton = autofarmTab.new("Button", {text=" plant 5 boxes "})
plantButton.event:Connect(function()
    for i = 1, 5 do
        local ohString1 = "Plant Box"
        local ohCFrame2 = CFrame.new(Players.LocalPlayer.Character.HumanoidRootPart.Position.X,Players.LocalPlayer.Character.HumanoidRootPart.Position.Y-3,Players.LocalPlayer.Character.HumanoidRootPart.Position.Z+i, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        local ohNumber3 = 0
        game:GetService("ReplicatedStorage").Events.PlaceStructure:FireServer(ohString1, ohCFrame2, ohNumber3)
    end
end)
for i,v in pairs(fruits) do
    autoplantDropdown.new(v)
end
autoplantDropdown.event:Connect(function(v)
    chosenFruit = v
end)




FLYING = false
iyflyspeed = 0.25
vehicleflyspeed = 0.25