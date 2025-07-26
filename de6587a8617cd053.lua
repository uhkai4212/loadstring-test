local exec_name, exec_version = identifyexecutor()

if exec_name ~= "Cloudy" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/refs/heads/main/Source.lua"))()
    -- Obrigado Pixeluted
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Aviso",
        Text = "Este script pode estar bugaddo no seu executor. Use outro.",
        Duration = 5
    })
	
end

-- Anticheat Starter
local starterCharacterScripts = game:GetService("StarterPlayer"):FindFirstChild("StarterCharacterScripts")
if starterCharacterScripts then
	local anticheatScript = starterCharacterScripts:FindFirstChild("AnticheatMaxSpeedUpdate")
	if anticheatScript then
		anticheatScript:Destroy()
	end
end

local starterPlayerScripts = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
if starterPlayerScripts then
	local noclipScript = starterPlayerScripts:FindFirstChild("NoClip")
	if noclipScript then
		noclipScript:Destroy()
	end
end

-- Anticheat no personagem do jogador
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local charAnticheat = character:FindFirstChild("AnticheatMaxSpeedUpdate")
if charAnticheat then
	charAnticheat:Destroy()
end

local charNoclip = player.PlayerScripts:FindFirstChild("NoClip")
if charNoclip then
	charNoclip:Destroy()
end


local studios = game.Workspace:WaitForChild("Studios")
local children = studios:GetChildren()

local lockedStudio = nil

for index, studio in ipairs(children) do
	local lock = studio:FindFirstChild("LockOneMin")
	if lock then
		local hitbox = lock:FindFirstChild("Hitbox")
		if hitbox then
			local touch = hitbox:FindFirstChildWhichIsA("TouchTransmitter")
			if touch then
				lockedStudio = studio
				break 
			end
		end
	end
end



local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Steal a Character - hub.facil.wtf",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Steal a Character",
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
 Name = "Teleport to Studio(Bugged/Bugado)",
   Callback = function()
   character.HumanoidRootPart.CFrame = lockedStudio.LockOneMin.Hitbox.CFrame + Vector3.new(0, 3, 0)
   end,
})

local autolockvalue
local autolocktoggle = tabbase:CreateToggle({
   Name = "AutoLock",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   autolockvalue = Value
   while autolockvalue do
   firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, lockedStudio.LockOneMin.Hitbox, 0)
   firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, lockedStudio.LockOneMin.Hitbox, 1)
   wait(0.2)
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
   Name = "Complete Steal/Completar Roubo(Bugged/Bugado)",
   Callback = function()
   local positionsign = lockedStudio.CompletePurchaseSign.Position
   character.HumanoidRootPart.CFrame = CFrame.new(positionsign + Vector3.new(0, 10, 0))
   firetouchinterest(character.HumanoidRootPart, lockedStudio.CompletePurchaseZone, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.CompletePurchaseZone, 1)
   end,
})

local instantConn
local ToggleInstant = tabautosteal:CreateToggle({ -- Créditos ao Sw1ft,
   Name = "Instant  ProximityPrompt(Credits: Sw1ft Sync Discord @_oreofday12)",
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
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms.Platform.Collect, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms.Platform.Collect, 1)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[2].Collect, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[2].Collect, 1)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[3].Collect, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[3].Collect, 1)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[4].Collect, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[4].Collect, 1)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[5].Collect, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[5].Collect, 1)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[6].Collect, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[6].Collect, 1)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[7].Collect, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[7].Collect, 1)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[8].Collect, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[8].Collect, 1)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[9].Collect, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[9].Collect, 1)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[10].Collect, 0)
   firetouchinterest(character.HumanoidRootPart, lockedStudio.Platforms:GetChildren()[10].Collect, 1)
   wait(0.5)
   end
   end,
})