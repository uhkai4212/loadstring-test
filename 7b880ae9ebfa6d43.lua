local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "KEYLESS",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "KEYLESS",
   LoadingSubtitle = "by BROTHAISHACKIER",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
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
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "vrkC4NbVa9", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = false -- Set this to false to make them join the discord every time they load it up
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

local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Info: This script is local so it will only work for you")

local Button = Tab:CreateButton({
   Name = "Remove kill bricks",
   Callback = function()
   local kill = game.Workspace.Obby_Geometry:FindFirstChild("Obby_KillParts")
if kill then
    kill:Destroy()
end

   end,
})

local speed1 = 2

local Slider = Tab:CreateSlider({
   Name = "Tp speed",
   Range = {0.5, 10},
   Increment = 0.1,
   Suffix = "Speed",
   CurrentValue = 2,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   speed1 = Value
   end,
})

local Button = Tab:CreateButton({
   Name = "Tp to Checkpoints",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local checkpointsFolder = game.Workspace.Obby_Geometry.Obby_Checkpoints

for i = 0, 120 do
    local checkpointModel = checkpointsFolder:FindFirstChild("Checkpoint_" .. i)
    if checkpointModel then
        local checkpointMain = checkpointModel:FindFirstChild("CheckpointMain")
        if checkpointMain then
            -- Teleport the player to the checkpoint
            humanoidRootPart.CFrame = checkpointMain.CFrame + Vector3.new(0, 5, 0) -- Offset to avoid being stuck in the part
            task.wait(speed1) -- Wait half a second before going to the next checkpoint
        end
    end
end

   end,
})