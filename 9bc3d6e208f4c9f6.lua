local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local selectedTheme = "Default"
local Window = Rayfield:CreateWindow({
   Name = "Forsaken - Script By Iliankytb",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Forsaken",
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
local InfoTab = Window:CreateTab("Info")
local PlayerTab = Window:CreateTab("Player")
local EspTab = Window:CreateTab("Esp")
local DiscordTab = Window:CreateTab("Discord")
local SettingsTab = Window:CreateTab("Settings")
local ActiveSpeedBoost,ActiveAutoUseCoinFlip,ActiveEspSurvivors,ActiveNoStun,ActiveEspKillers,ActiveEspGenerator,ActiveEspItems,ActiveInfiniteStamina,ActiveEspRagdolls,ActiveAutoGenerator,AutoKillSurvivors = false,false,false,false,false,false,false,false,false,false

Rayfield:Notify({
   Title = "Cheat Version",
   Content = "V.0.28",
   Duration = 2.5,
   Image = "rewind",
})
local Paragraph1 = InfoTab:CreateParagraph({Title = "TP To Gen", Content = "This Function Work Now And If You Got Kicked I Guess Sorry!"})
local Paragraph2 = InfoTab:CreateParagraph({Title = "Fixed Full Bright(V.0.23)", Content = "Normally Full Bright Is Fixed Try It!"})
local Paragraph3 = InfoTab:CreateParagraph({Title = "Fixed Items(V.0.24)", Content = "Just Fixed Now!"})
local function CreateEsp(Char,Color,Text,Parent,number)
if Char and not Char:FindFirstChildOfClass("Highlight") and not Parent:FindFirstChildOfClass("BillboardGui") then
local NewHighlight = Instance.new("Highlight",Char)
NewHighlight.OutlineColor = Color 
NewHighlight.FillColor = Color
local billboard = Char:FindFirstChild("ESP") or Instance.new("BillboardGui")
	billboard.Name = "ESP"
	billboard.Size = UDim2.new(0, 50, 0, 25)
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, number, 0)
	billboard.Adornee = Parent
	billboard.Enabled = true
	billboard.Parent = Parent

	
	local label = billboard:FindFirstChildOfClass("TextLabel") or Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = Text
	label.TextColor3 = Color
	label.TextScaled = true
	label.Parent = billboard
end
end

local function KeepEsp(Char,parent)
if Char and Char:FindFirstChildOfClass("Highlight") and parent:FindFirstChildOfClass("BillboardGui") then
Char:FindFirstChildOfClass("Highlight"):Destroy()
parent:FindFirstChildOfClass("BillboardGui"):Destroy()
end
end

local EspSurvivorsToggle = EspTab:CreateToggle({
   Name = "Survivors Esp",
   CurrentValue = false,
   Flag = "EspSurvivors", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActiveEspSurvivors = Value task.spawn(function()
while ActiveEspSurvivors do task.spawn(function()
for _,Players in pairs(Game.Workspace.Players.Survivors:GetChildren()) do 
if Players:isA("Model") and Players:FindFirstChild("Head") and not Players:FindFirstChildOfClass("Highlight") and not Players.Head:FindFirstChildOfClass("BillboardGui") then
CreateEsp(Players,Color3.fromRGB(0,255,0),Players.Name,Players.Head,2)
end
end
end)
task.wait(0.1)
end for _,Players in pairs(Game.Workspace.Players.Survivors:GetChildren()) do 
if Players:isA("Model") and Players:FindFirstChild("Head") and Players:FindFirstChildOfClass("Highlight") and Players.Head:FindFirstChildOfClass("BillboardGui") then
KeepEsp(Players,Players.Head)
end
end 
 end)
end,
})

local EspKillersToggle = EspTab:CreateToggle({
   Name = "Killers Esp",
   CurrentValue = false,
   Flag = "EspKiller", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActiveEspKillers = Value task.spawn(function()
while ActiveEspKillers do task.spawn(function()
for _,Players in pairs(Game.Workspace.Players.Killers:GetChildren()) do 
if Players:isA("Model") and Players.Name == "1x1x1x1" and Players:FindFirstChild("Head") and Players:FindFirstChildOfClass("Highlight") and not Players.Head:FindFirstChildOfClass("BillboardGui") then
Players:FindFirstChildOfClass("Highlight"):Destroy()
end
if Players:isA("Model") and Players:FindFirstChild("Head") and not Players:FindFirstChildOfClass("Highlight") and not Players.Head:FindFirstChildOfClass("BillboardGui") then
CreateEsp(Players,Color3.fromRGB(255,0,0),Players.Name,Players.Head,2)
end
end
end)
task.wait(0.1)
end for _,Players in pairs(Game.Workspace.Players.Killers:GetChildren()) do 
if Players:isA("Model") and Players:FindFirstChild("Head") and Players:FindFirstChildOfClass("Highlight") and Players.Head:FindFirstChildOfClass("BillboardGui") then
KeepEsp(Players,Players.Head)
end
end 
 end)
end,
}) local EspGeneratorToggle = EspTab:CreateToggle({
   Name = "Generator Esp",
   CurrentValue = false,
   Flag = "EspGenerator", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActiveEspGenerator= Value task.spawn(function()
while ActiveEspGenerator do
if Game.Workspace.Map.Ingame:FindFirstChild("Map") then
for _,Players in pairs(Game.Workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
if Players:isA("Model") and Players.PrimaryPart and Players.name == "Generator" and not Players:FindFirstChildOfClass("Highlight") and not Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
CreateEsp(Players,Color3.fromRGB(255,255,0),"Generator",Players.PrimaryPart,-2)
end
end
end
task.wait(0.1) 
end
if Game.Workspace.Map.Ingame:FindFirstChild("Map") then
for _,Players in pairs(Game.Workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
if Players:isA("Model") and Players.PrimaryPart and Players.name == "Generator" and Players:FindFirstChildOfClass("Highlight") and Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
KeepEsp(Players)
end
end
end
 end)
end,
})
local EspItemsToggle = EspTab:CreateToggle({
   Name = "Items Esp",
   CurrentValue = false,
   Flag = "EspItems", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActiveEspItems = Value
task.spawn(function()
while ActiveEspItems do
for _,Players in pairs(Game.Workspace.Map.Ingame:GetChildren()) do 
if Players:isA("Tool") and Players.PrimaryPart and not Players:FindFirstChildOfClass("Highlight") and not Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
CreateEsp(Players,Color3.fromRGB(0,0,255),Players.Name,Players.PrimaryPart,-1)
end
end
if Game.Workspace.Map.Ingame:FindFirstChild("Map") then
for _,Players in pairs(Game.Workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
if Players:isA("Tool") and Players.PrimaryPart and not Players:FindFirstChildOfClass("Highlight") and not Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
CreateEsp(Players,Color3.fromRGB(0,0,255),Players.Name,Players.PrimaryPart,-1)
end
end
end
task.wait(0.1) end
for _,Players in pairs(Game.Workspace.Map.Ingame:GetChildren()) do 
if Players:isA("Tool") and Players.PrimaryPart  and  Players:FindFirstChildOfClass("Highlight") and Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
KeepEsp(Players,Players.PrimaryPart)
end
end
if Game.Workspace.Map.Ingame:FindFirstChild("Map") then
for _,Players in pairs(Game.Workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
if Players:isA("Tool") and Players.PrimaryPart  and  Players:FindFirstChildOfClass("Highlight") and Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
KeepEsp(Players,Players.PrimaryPart) 
end
end
end
 end)
end,
})

local ValueSpeed = 16
local PlayerSpeedSlider = PlayerTab:CreateSlider({
   Name = "Player Speed(max 25 for not be a exploiter) ",
   Range = {0, 25},
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
  ActiveSpeedBoost = Value 
task.spawn(function()
while ActiveSpeedBoost do 
task.spawn(function()
Game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = ValueSpeed 
Game.Players.LocalPlayer.Character.Humanoid:SetAttribute("BaseSpeed",ValueSpeed)
end)
task.wait(0.1)
end end)
end,
}) local function copyToClipboard(text)
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
local PlayerActiveAutoGeneratorToggle = PlayerTab:CreateToggle({
   Name = "Auto Generator(every 2.5 second)",
   CurrentValue = false,
   Flag = "ButtonAutoGen", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActiveAutoGenerator = Value task.spawn(function()
while ActiveAutoGenerator do task.spawn(function()
for _,Players in pairs(Game.Workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
if Players:isA("Model") and Players.name == "Generator"  then if Players:FindFirstChild("Remotes"):FindFirstChild("RE") then Players:FindFirstChild("Remotes"):FindFirstChild("RE"):FireServer() end
 end
end end)
task.wait(2.5)
end end)
end,
}) 

local PlayerActiveInfStaminaToggle = PlayerTab:CreateToggle({
   Name = "Infinite Stamina(Don't work!)",
   CurrentValue = false,
   Flag = "ButtonInfiniteStamina", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActiveInfiniteStamina = Value task.spawn(function()
while ActiveInfiniteStamina do task.spawn(function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UnreliableRemoteEvent = ReplicatedStorage.Modules.Network.UnreliableRemoteEvent
UnreliableRemoteEvent:FireServer("FootstepPlayed",100)
end)
task.wait(0.00000001)
end end)
end,
})
local PlayerNoStunToggle = PlayerTab:CreateToggle({
   Name = "No Stun",
   CurrentValue = false,
   Flag = "NoStunButton", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActiveNoStun = Value task.spawn(function()
while ActiveNoStun do task.spawn(function()
Game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
end)
task.wait(0.001)
end end)
end,
})
local PlayerAutoUseCoinFlipToggle = PlayerTab:CreateToggle({
   Name = "Auto Use Coin Flip",
   CurrentValue = false,
   Flag = "AutoUseCoinFlipbutton", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActiveAutoUseCoinFlip = Value task.spawn(function()
while ActiveAutoUseCoinFlip do task.spawn(function()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage.Modules.Network.RemoteEvent -- RemoteEvent 

RemoteEvent:FireServer(
    "UseActorAbility",
    "CoinFlip"
)

end)
task.wait(1)
end end)
end,
})

local PlayerActiveAutoKillSurvivorsToggle = PlayerTab:CreateToggle({
   Name = "Auto Kill Survivors(Unverified!)",
   CurrentValue = false,
   Flag = "ButtonAutoKillSurvivors", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
  ActiveAutoKillSurvivors = Value task.spawn(function()
while ActiveAutoKillSurvivors do 
task.spawn(function()
for _,Players in pairs(Game.Workspace.Players.Survivors:GetChildren()) do 
if Players:isA("Model") then
Game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Players.HumanoidRootPart.CFrame
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEvent = ReplicatedStorage.Modules.Network.RemoteEvent -- RemoteEvent 

RemoteEvent:FireServer(
    "UseActorAbility",
    "Slash"
)


end
end
end)
task.wait(0.05)
end end)
end,
})
local DropdownTpGen = PlayerTab:CreateDropdown({
   Name = "Dropdown TP To Generators",
   Options = {},
   CurrentOption = {"Nothings"},
   MultipleOptions = false,
   Flag = nil,
   Callback = function(Options)   task.spawn(function()
for _,Players in pairs(Game.Workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
if Players:isA("Model") and Players.name == "Generator"  then 
if Players:FindFirstChild("GeneratorTP") then 
if Players:FindFirstChild("GeneratorTP").Value == Options[1] then 
Game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Players.PrimaryPart.CFrame + Vector3.new(0,5,0)
end  end 
 end
end  end)
   end,
})
local PlayerRefreshGenButton = PlayerTab:CreateButton({
   Name = "Refresh Dropdown Generator",
   Callback = function(Value) local num = 1
task.spawn(function() local GenTable = {} for _,Players in pairs(Game.Workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
if Players:isA("Model") and Players.name == "Generator"  then table.insert(GenTable,"Generator ".. num) if not  Players:FindFirstChild("GeneratorTP") then task.spawn(function() local NewValue = Instance.new("StringValue",Players) NewValue.Name = "GeneratorTP" NewValue.Value = "Generator "..num end) end num = num +1
 end
end 
    DropdownTpGen:Refresh(GenTable)
end)
end,
})
local EspRagdollsToggle = EspTab:CreateToggle({
   Name = "Ragdolls & Enemy Rig Killer Esp",
   CurrentValue = false,
   Flag = "EspRagdolls", 
   Callback = function(Value)
  ActiveEspRagdolls = Value task.spawn(function()
while ActiveEspRagdolls do task.spawn(function()
for _,Players in pairs(Game.Workspace.Ragdolls:GetChildren()) do 
if Players:isA("Model") and Players.PrimaryPart and not Players:FindFirstChildOfClass("Highlight") and not Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
CreateEsp(Players,Color3.fromRGB(47,47,47),Players.Name,Players.PrimaryPart,-1)
end
end
end)
task.wait(0.1)
end for _,Players in pairs(Game.Workspace.Ragdolls:GetChildren()) do 
if Players:isA("Model") and Players.PrimaryPart and Players:FindFirstChildOfClass("Highlight") and Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
KeepEsp(Players,Players.PrimaryPart)
end
end 
 end)
end,
})
local ValueFieldOfView = 80
local PlayerFieldOfViewSlider = PlayerTab:CreateSlider({
   Name = "Field Of View (Coming Soon)",
   Range = {80, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 80,
   Flag = "FOV1",
   Callback = function(Value)
CurrentValue = Value
ValueFieldOfView = Value
end,  ValueFieldOfView = CurrentValue,
}) local ActiveModifiedFieldOfView = false local PlayerActiveModifyingFOVToggle = PlayerTab:CreateToggle({
   Name = "Active Modifying Player FOV(i will upgrade this function it work but the game reput the normal fov!)",
   CurrentValue = false,
   Flag = "ButtonFOV", 
   Callback = function(Value)
  ActiveModifiedFieldOfView = Value 
task.spawn(function()
while ActiveModifiedFieldOfView do 
task.spawn(function()
Game.Workspace.Camera.FieldOfView = ValueFieldOfView end)
task.wait(0.1)
end end)
end,
}) 
local ActiveFullBright = false
local PlayerFullBright = PlayerTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(Value)
ActiveFullBright = Value
task.spawn(function()
while ActiveFullBright do
if Game.Lighting then 
Game.Lighting.Brightness = 5
Game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
end  
wait(0.1) 
end 
end)
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