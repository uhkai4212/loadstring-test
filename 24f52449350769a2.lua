local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Plane X Script",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Kavin",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Hmm Hub"
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

local Tab = Window:CreateTab("Gamepass", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Section Example")

local Button = Tab:CreateButton({
   Name = "A10 Thunderbolt II",
   Callback = function()
   local args = {
    [1] = "A10 Thunderbolt II"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "B-2 Stealth Bomber",
   Callback = function()
   local args = {
    [1] = "B-2 Stealth Bomber"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Lockheed AC-130",
   Callback = function()
   local args = {
    [1] = "Lockheed AC-130"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Lockheed SR-71 Blackbird",
   Callback = function()
   local args = {
    [1] = "Lockheed SR-71 Blackbird"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Lockheed SR-72 Darkstar",
   Callback = function()
   local args = {
    [1] = "Lockheed SR-72 Darkstar"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "X-15",
   Callback = function()
   local args = {
    [1] = "X-15"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Tab = Window:CreateTab("Planes", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Section Example")

local Button = Tab:CreateButton({
   Name = "Titan",
   Callback = function()
   local args = {
    [1] = "Titan"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "A320neo",
   Callback = function()
   local args = {
    [1] = "A320neo"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "F-15 Nuke",
   Callback = function()
   local args = {
    [1] = "F-15 Nuke"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})


local Button = Tab:CreateButton({
   Name = "Widewing Turbo",
   Callback = function()
   local args = {
    [1] = "Widewing Turbo"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Tourfly A2",
   Callback = function()
   local args = {
    [1] = "Tourfly A2"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})


local Button = Tab:CreateButton({
   Name = "Thunderfly L-7",
   Callback = function()
   local args = {
    [1] = "Thunderfly L-7"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Thunder bird B-5",
   Callback = function()
   local args = {
    [1] = "Thunder bird B-5"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "TT-2 Evil-Gingerbread",
   Callback = function()
   local args = {
    [1] = "TT-2 Evil-Gingerbread"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Spikefly Evil-Gingerbread",
   Callback = function()
   local args = {
    [1] = "Spikefly Evil-Gingerbread"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Spikefly B-1",
   Callback = function()
   local args = {
    [1] = "Spikefly B-1"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Private Jet AIR",
   Callback = function()
   local args = {
    [1] = "Private Jet AIR"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})


local Button = Tab:CreateButton({
   Name = "Spikefly B-1",
   Callback = function()
   local args = {
    [1] = "Spikefly B-1"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "LongFly A6",
   Callback = function()
   local args = {
    [1] = "LongFly A6"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})


local Button = Tab:CreateButton({
   Name = "Late eagle TT",
   Callback = function()
   local args = {
    [1] = "Late eagle TT"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Knight B-2",
   Callback = function()
   local args = {
    [1] = "Knight B-2"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Kawa D-3",
   Callback = function()
   local args = {
    [1] = "Kawa D-3"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "KR-1",
   Callback = function()
   local args = {
    [1] = "KR-1"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "KR-2",
   Callback = function()
   local args = {
    [1] = "KR-2"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Green F2",
   Callback = function()
   local args = {
    [1] = "Green F2"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "KB-80",
   Callback = function()
   local args = {
    [1] = "KB-80"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Globemaster C-17",
   Callback = function()
   local args = {
    [1] = "Globemaster C-17"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Fighter G-9",
   Callback = function()
   local args = {
    [1] = "Fighter G-9"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "F-15",
   Callback = function()
   local args = {
    [1] = "F-15"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "DC-10",
   Callback = function()
   local args = {
    [1] = "DC-10"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Concorde",
   Callback = function()
   local args = {
    [1] = "Concorde"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Company e7",
   Callback = function()
   local args = {
    [1] = "Company e7"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Company Longbird",
   Callback = function()
   local args = {
    [1] = "Company Longbird"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Boeing 747-8",
   Callback = function()
   local args = {
    [1] = "Boeing 747-8"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "Boeing 747-400",
   Callback = function()
   local args = {
    [1] = "Boeing 747-400"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "AP-P1",
   Callback = function()
   local args = {
    [1] = "AP-P1"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "AP-DP-7",
   Callback = function()
   local args = {
    [1] = "AP-DP-7"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "AG-7 Flying orchestra",
   Callback = function()
   local args = {
    [1] = "AG-7 Flying orchestra"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "AF6 Redberry Fly",
   Callback = function()
   local args = {
    [1] = "AF6 Redberry Fly"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "AF5 CloudFly",
   Callback = function()
   local args = {
    [1] = "AF5 CloudFly"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "A380 Global",
   Callback = function()
   local args = {
    [1] = "A380 Global"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "A380",
   Callback = function()
   local args = {
    [1] = "A380"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Tab = Window:CreateTab("Helicopter", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Section Example")

local Button = Tab:CreateButton({
   Name = "AH-64",
   Callback = function()
   local args = {
    [1] = "AH-64"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})

local Button = Tab:CreateButton({
   Name = "UH-32",
   Callback = function()
   local args = {
    [1] = "UH-32"
}
game:GetService("ReplicatedStorage").SpawnCar:FireServer(unpack(args))
   end,
})