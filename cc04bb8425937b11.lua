local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local selectedTheme = "Default"
local Window = Rayfield:CreateWindow({
   Name = "Rainbow Friends 2 - Script By Iliankytb",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rainbow Friends 2",
   LoadingSubtitle = "Script By Iliankytb",
   Theme = selectedTheme, -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "saver", -- Create a custom folder for your hub/game
      FileName = "K"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})
local PlayerTab = Window:CreateTab("Player")
local EspTab = Window:CreateTab("Esp")
local DiscordTab = Window:CreateTab("Discord")
local SettingsTab = Window:CreateTab("Settings")
local ActiveEspItems,ActiveEspMonsters,ActiveAutoPickupItems = false,false,false

Rayfield:Notify({
   Title = "Cheat Version",
   Content = "V.0.12",
   Duration = 2.5,
   Image = "rewind",
})

local function CreateEsp(Char,Color,Text,Parent)
if Char then
local NewHighlight = Instance.new("Highlight",Char)
NewHighlight.OutlineColor = Color NewHighlight.FillColor = Color
end
end

local function KeepEsp(Char)
if Char and Char:FindFirstChildOfClass("Highlight") then
Char:FindFirstChildOfClass("Highlight"):Destroy()
end
end

local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    else
        warn("setclipboard is not supported in this environment.")
    end
end
local DiscordLink = DiscordTab:CreateButton({
   Name = "Discord Link",
   Callback = function()
copyToClipboard("https://discord.gg/E2TqYRsRP4")
end,
})

local EspItemsToggle = EspTab:CreateToggle({
   Name = "Items Esp",
   CurrentValue = false,
   Flag = "EspItems",
   Callback = function(Value)
  ActiveEspItems = Value task.spawn(function()
while ActiveEspItems do task.spawn(function()
 for _,Light in pairs(Game.Workspace:GetChildren()) do if (Light.name == "LightBulb"or Light.name == "GasCanister" or Light.name == "CakeMix") and not Light:FindFirstChildOfClass("Highlight") then
CreateEsp(Light,Color3.fromRGB(0,255,0)) end end
end)
task.spawn(function()
 for _,Light in pairs(Game.Workspace.ignore:GetChildren()) do if Light.name == "Looky" and not Light:FindFirstChildOfClass("Highlight") then
CreateEsp(Light.PrimaryPart,Color3.fromRGB(0,255,0)) end end
end)
task.wait(0.1)
end for _,Light in pairs(Game.Workspace:GetChildren()) do if (Light.name == "LightBulb"or Light.name == "GasCanister" or Light.name == "CakeMix") and Light:FindFirstChildOfClass("Highlight") then
KeepEsp(Light) end end
 task.spawn(function()
 for _,Light in pairs(Game.Workspace.ignore:GetChildren()) do if Light.name == "Looky" and not Light:FindFirstChildOfClass("Highlight") then
KeepEsp(Light.PrimaryPart) end end
end)
end)
end,
})local EspMonstersToggle = EspTab:CreateToggle({
   Name = "Monsters Esp",
   CurrentValue = false,
   Flag = "EspMonsters",
   Callback = function(Value)
  ActiveEspMonsters = Value task.spawn(function()
while ActiveEspMonsters do task.spawn(function()
 for _,Light in pairs(Game.Workspace.Monsters:GetChildren()) do if Light and not Light:FindFirstChildOfClass("Highlight") then
CreateEsp(Light,Color3.fromRGB(255,0,0)) end end
end)
task.wait(0.1)
end for _,Light in pairs(Game.Workspace.Monsters:GetChildren()) do if Light and Light:FindFirstChildOfClass("Highlight") then
KeepEsp(Light) end end
 end)
end,
})
local AutoPickupItemsToggle = PlayerTab:CreateToggle({
   Name = "Auto Pickup Items",
   CurrentValue = false,
   Flag = "AutoPickupItems",
   Callback = function(Value)
  ActiveAutoPickupItems = Value 
task.spawn(function()
while ActiveAutoPickupItems do

 for _,Light in pairs(Game.Workspace:GetChildren()) do 
if Light and Light:isA("Model") and (Light.name == "LightBulb"or Light.name == "GasCanister" or Light.name == "CakeMix")   then
Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Light.PrimaryPart.CFrame
wait(0.15)
Game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
57.9840851, 137.597931, -8.2745142, -0.0595626235, -1.30958966e-07, 0.998224556, -5.83236304e-09, 1, 1.30843873e-07, -0.998224556, 1.97139616e-09, -0.0595626235
)
end 
end

 for _,Light in pairs(Game.Workspace.ignore:GetChildren()) do 
if Light and Light:isA("Model") and Light.name == "Looky" then 
Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Light.PrimaryPart.CFrame
wait(0.15)
Game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
57.9840851, 137.597931, -8.2745142, -0.0595626235, -1.30958966e-07, 0.998224556, -5.83236304e-09, 1, 1.30843873e-07, -0.998224556, 1.97139616e-09, -0.0595626235
)
end end
task.wait(0.1)
end 
 end)
end,
})
local PickupItems = PlayerTab:CreateButton({
   Name = "Pickup Random Item",
   Callback = function(Value)
  task.spawn(function()
 for _,Light in pairs(Game.Workspace:GetChildren()) do 
if Light and Light:isA("Model") and (Light.name == "LightBulb"or Light.name == "GasCanister" or Light.name == "CakeMix")   then 
Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Light.PrimaryPart.CFrame
 end end 
 end)
task.spawn(function()
 for _,Light in pairs(Game.Workspace.ignore:GetChildren()) do if Light and Light:isA("Model") and Light.name == "Looky" then Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Light.PrimaryPart.CFrame
 end end
end)
end,
})
local ValueSpeed = 16
local PlayerSpeedSlider = PlayerTab:CreateSlider({
   Name = "Player Speed(max 21 for not be a exploiter) ",
   Range = {0, 21},
   Increment = 1,
   Suffix = "Speeds",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
CurrentValue = Value
ValueSpeed = Value
end,  ValueSpeed = CurrentValue,
})

local PlayerActiveModifyingSpeedToggle = PlayerTab:CreateToggle({
   Name = "Active Modifying Player Speed",
   CurrentValue = false,
   Flag = "ButtonSpeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActiveSpeedBoost = Value task.spawn(function()
while ActiveSpeedBoost do
Game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = ValueSpeed
task.wait(0.1)
end end)
end,
})
local ButtonUnloadCheat = SettingsTab:CreateButton({
   Name = "Unload Cheat",
   Callback = function()
  Rayfield:Destroy()
end,
})
local Themes = {
   ["Default"] = "Default",
   ["Amber Glow"] = "AmberGlow",
   ["Amethyst"] = "Amethyst",
   ["Bloom"] = "Bloom",
   ["Dark Blue"] = "DarkBlue",
   ["Green"] = "Green",
   ["Light"] = "Light",
   ["Ocean"] = "Ocean",
   ["Serenity"] = "Serenity"
}

local Dropdown = SettingsTab:CreateDropdown({
   Name = "Change Theme",
   Options = {"Default", "Amber Glow", "Amethyst", "Bloom", "Dark Blue", "Green", "Light", "Ocean", "Serenity"},
   CurrentOption = selectedTheme,  -- pour afficher ce qui est réellement chargé
   Flag = "ThemeSelection",
   Callback = function(Selected)
      local ident = Themes[Selected[1]]
      Window.ModifyTheme(ident)  -- <— Applique le thème en direct
   end, 
})
Rayfield:LoadConfiguration()