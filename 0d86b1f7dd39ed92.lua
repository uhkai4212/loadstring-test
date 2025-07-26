local plots = game.workspace:WaitForChild("Plots")
local lockedStudio = nil


local player = game.Players.LocalPlayer
local character = player.Character 
player.PlayerGui.Main.Notification.Visible = false

for _, plot in pairs(plots:GetChildren()) do
	local plotSign = plot:FindFirstChild("PlotSign")
	if plotSign and plotSign:FindFirstChild("YourBase") then
		if plotSign.YourBase.Enabled then
			lockedStudio = plot
			break
		end
	end
end


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Steal a Brainrot MODDED - hub.facil.wtf",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Steal a Brainrot MODDED",
   LoadingSubtitle = "by facil.wtf",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
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

local tabbase = Window:CreateTab("Studio/Base", 4483362458)
local tabautosteal = Window:CreateTab("Steal", 4483362458)
local tabmisc = Window:CreateTab("Misc.", 4483362458)


local buttonbase = tabbase:CreateButton({
 Name = "Teleport to Base",
   Callback = function()
   character.HumanoidRootPart.CFrame = lockedStudio.DeliveryHitbox.CFrame + Vector3.new(0, 3, 0)
   end,
})

local autolockvalue
local autolocktoggle = tabbase:CreateToggle({
   Name = "AutoLock(Bugged/Bugado)",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   autolockvalue = Value
   while autolockvalue do

   firetouchinterest(character.HumanoidRootPart, lockedStudio.Purchases.PlotBlock.Hitbox, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Purchases.PlotBlock.Hitbox, 1)
   wait(1)
   end
   end,
})
   
local Button = tabmisc:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
   end,
})

local ButtonSteal = tabautosteal:CreateButton({
   Name = "Complete Steal/Completar Roubo",
   Callback = function()
   game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/StealService/DeliverySteal"):FireServer()
   end,
})

local instantConn
local ToggleInstant = tabautosteal:CreateToggle({ -- Créditos ao Sw1ft,
   Name = "Instant  ProximityPrompt",
   CurrentValue = false,
   Flag = "ToggleInstant",
   Callback = function(Value)
   instantConn = Value
   while instantConn do
   game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt) prompt.HoldDuration = 0 end)
   wait(1)
   end
   end,
})

local getmoneyvalue
local togglemoney = tabbase:CreateToggle({
   Name = "Auto Get Money",
   CurrentValue = false,
   Flag = "ToggleMoney",
   Callback = function(Value)
   getmoneyvalue = Value
   while getmoneyvalue do
   for i = 1, 20 do
            local args = { i }
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/PlotService/ClaimCoins"):FireServer(unpack(args))
         end
   wait(2)
   end
   end,
})