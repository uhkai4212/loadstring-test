local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Worlds Craziest Game",
   Icon = 0, 
   LoadingTitle = "Worlds Craziest Game",
   LoadingSubtitle = "by BROTHAISHACKIER",
   ShowText = "Rayfield", 
   Theme = "Default", 

   ToggleUIKeybind = "K", 

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, 
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = true, 
      Invite = "vrkC4NbVa9", 
      RememberJoins = true 
   },

   KeySystem = false, 
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", 
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false, 
      Key = {"Hello"} 
   }
})

local Tab = Window:CreateTab("Main", 4483362458) 

-- Function to clean kill dots etc.
local function cleanLevel(level)
    if level then
        for _, child in pairs(level:GetChildren()) do
            if child:IsA("Folder") then
                local name = child.Name
                local startsWithCoin = name:sub(1, 4) == "Coin"
                local endsWithDot = name:sub(-3) == "Dot"
                local endsWithDots = name:sub(-4) == "Dots"
                local endsWithTurrets = name:sub(-7) == "Turrets"

                if (endsWithDot or endsWithDots or endsWithTurrets) and not startsWithCoin then
                    child:Destroy()
                end
            end
        end
    end
end

local replicatedChallenges = game.ReplicatedStorage.Challenges
local currentStage = game.Workspace.CurrentStage

local function removeKillDots()
    for i = 1, 50 do
        local levelName = "Level" .. i

        cleanLevel(replicatedChallenges["1"]:FindFirstChild(levelName))
        cleanLevel(replicatedChallenges["2"]:FindFirstChild(levelName))
        cleanLevel(currentStage:FindFirstChild(levelName))
    end
end

Tab:CreateButton({
   Name = "Remove KillDots",
   Callback = removeKillDots,
})

-- Speed handling
local player = game.Players.LocalPlayer
local bruh = 7.0
local humanoid

local function updateHumanoid()
    local character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = bruh
end

updateHumanoid()

-- Set up once
player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = bruh
end)

-- Speed slider
local Slider = Tab:CreateSlider({
   Name = "Speed",
   Range = {0.1, 100},
   Increment = 0.1,
   Suffix = "Speed",
   CurrentValue = bruh,
   Flag = "Slider1",
   Callback = function(Value)
       bruh = Value
       if humanoid then
           humanoid.WalkSpeed = bruh
       end
   end,
})

-- Button Example (resets speed to default 7.0)
local Button = Tab:CreateButton({
   Name = "Button Example",
   Callback = function()
       bruh = 7.0
       Slider:Set(bruh)
       if humanoid then
           humanoid.WalkSpeed = bruh
       end
   end,
})

-- Reset Character
Tab:CreateButton({ 
    Name = "Disappeared? Click here to reset",
    Callback = function()
        if humanoid then
            humanoid.Health = 0
        end
    end,
})