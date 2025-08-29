local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")
local rootpart = character:WaitForChild("HumanoidRootPart")
local map = game.Workspace:FindFirstChild("Map")
local camp = map:WaitForChild("Campground")
local fire = camp:WaitForChild("MainFire")
local center = fire:WaitForChild("Center")
if camp and fire and map and rootpart and center then
  print("Found")
end

local characters = game.Workspace:WaitForChild("Characters")
local child = characters:WaitForChild("Lost Child")
local childroot = child:WaitForChild("HumanoidRootPart")


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "99 nights in the forest",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "hii",
   LoadingSubtitle = "by unknown",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
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


local MainTab = Window:CreateTab("Main", 4483362458) -- Title, Image

local Section = MainTab:CreateSection("Basics")

local Button = MainTab:CreateButton({
   Name = "Teleport to camp fire",
   Callback = function()
   local function teleport()
  local centerframe = center.CFrame
  if rootpart and centerframe then
    rootpart.CFrame = centerframe
  end
end
teleport()
   end,
})

local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")
local rootpart = character:WaitForChild("HumanoidRootPart")
local map = game.Workspace.Map
local landmarks = map.Landmarks
local trees = landmarks:WaitForChild("Small Tree")
local trunk = trees:WaitForChild("Trunk")

if landmarks and map and trees and trunk then
  print("Found!")
end

local Button = MainTab:CreateButton({
   Name = "tp to tree",
   Callback = function()
   local function telepprt()
  local trunkframe = trunk.CFrame
  if rootpart and trunkframe then
    rootpart.CFrame = trunkframe
  end
end
telepprt()
   end,
})

local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")
local rootpart = character:WaitForChild("HumanoidRootPart")




  
 local Button = MainTab:CreateButton({
   Name = "Tp to 1 lost child",
   Callback = function()
   local function go()
    local childframe = childroot.CFrame
    if rootpart and childroot then
      rootpart.CFrame = childframe
    else
      print("error")
    end
  end
  go()
   end,
})