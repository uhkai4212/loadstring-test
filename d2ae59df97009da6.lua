while true do
task.wait()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end
      
   end,
})



local SecondTab = Window:CreateTab("Grinding", 4483362458) -- Title, Image

local Button = SecondTab:CreateButton({
   Name = "auto walk",
   Callback = function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local function startWalking(character)
	local humanoid = character:WaitForChild("Humanoid")
	local hrp = character:WaitForChild("HumanoidRootPart")

	-- Ensure WalkSpeed is normal or higher
	humanoid.WalkSpeed = 16

	-- Continuously move forward
	RunService.RenderStepped:Connect(function()
		if humanoid and humanoid.Health > 0 then
			local forward = hrp.CFrame.LookVector
			humanoid:Move(forward, false)
		end
	end)
end

-- Start on initial spawn
if player.Character then
	startWalking(player.Character)
end

-- Also start on future spawns
player.CharacterAdded:Connect(startWalking)

   end,
})

local Button = SecondTab:CreateButton({

   Name = "TP 1",

   Callback = function()local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

rootPart.CFrame = CFrame.new(68, -19.5219894, -394.006989, 1, 0, 0, 0, 1, 0, 0, 0, 1)

-- teleport

   -- The function that takes place when the button is pressed

   end,

})

local Button = SecondTab:CreateButton({

   Name = "TP 2",

   Callback = function()local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

rootPart.CFrame = CFrame.new(68, 28.4788758, -738.014099, 1, 0, 0, 0, 1, 0, 0, 0, 1)

-- teleport

   -- The function that takes place when the button is pressed

   end,

})

local Button = SecondTab:CreateButton({

   Name = "TP 3",

   Callback = function()local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

rootPart.CFrame = CFrame.new(68.5570679, 57.9785156, -1291.98267, 1, 0, 0, 0, 1, 0, 0, 0, 1)

-- teleport

   -- The function that takes place when the button is pressed

   end,

})

local Button = SecondTab:CreateButton({

   Name = "TP 4",

   Callback = function()local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

rootPart.CFrame = CFrame.new(108.499634, -60.2310905, -2094.00952, 0.999920607, 0, 0.0126027633, 0, 1, 0, -0.0126027633, 0, 0.999920607)

-- teleport

   -- The function that takes place when the button is pressed

   end,

})

local Button = SecondTab:CreateButton({

   Name = "TP 5",

   Callback = function()local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

rootPart.CFrame = CFrame.new(68.5570679, -44.0209961, -2591.95825, 1, 0, 0, 0, 1, 0, 0, 0, 1)

-- teleport

   -- The function that takes place when the button is pressed

   end,

})

local Button = SecondTab:CreateButton({

   Name = "TP 6",

   Callback = function()local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

rootPart.CFrame = CFrame.new(108.499626, -60.2306137, -3649.97461, 0.999920607, 0, 0.0126027633, 0, 1, 0, -0.0126027633, 0, 0.999920607)

-- teleport

   -- The function that takes place when the button is pressed

   end,

})

local Button = SecondTab:CreateButton({

   Name = "TP 7",

   Callback = function()local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

rootPart.CFrame = CFrame.new(-9.5, 32.9799039, -4003.979, 1, 0, 0, 0, 1, 0, 0, 0, 1)

-- teleport

   -- The function that takes place when the button is pressed

   end,

})

local Button = SecondTab:CreateButton({

   Name = "TP 8",

   Callback = function()local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

rootPart.CFrame = CFrame.new(68.5570679, 8.97898865, -4655.97119, 1, 0, 0, 0, 1, 0, 0, 0, 1)

-- teleport

   -- The function that takes place when the button is pressed

   end,

})

local Button = SecondTab:CreateButton({

   Name = "TP 9",

   Callback = function()local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

rootPart.CFrame = CFrame.new(68.5570679, 1508.979, -5127.47168, 1, 0, 0, 0, 1, 0, 0, 0, 1)

-- teleport

   -- The function that takes place when the button is pressed

   end,

})

local Button = SecondTab:CreateButton({

   Name = "Tp Finish",

   Callback = function()local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart

rootPart.CFrame = CFrame.new(68, 1508.979, -8521.04395, 1, 0, 0, 0, 1, 0, 0, 0, 1)

-- teleport

   -- The function that takes place when the button is pressed

   end,

})