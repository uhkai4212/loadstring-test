local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local hitRemote1 = Net:WaitForChild("RE/BeachShovelHit")
local hitRemote2 = Net:WaitForChild("RE/panHit")
local hitRemote3 = Net:WaitForChild("RE/pinkStopSignalHit")
local hitRemote4 = Net:WaitForChild("RE/baseballBatHit")
local stompEvent = ReplicatedStorage:WaitForChild("STOMPEVENT")

local function buyTool(toolName, buttonName)
	if Backpack:FindFirstChild(toolName) or Character:FindFirstChild(toolName) then return end

	local button = workspace:FindFirstChild(buttonName, true)
	if not button then return end

	Character:PivotTo(button.CFrame + Vector3.new(0, 2, 0))

	local prompt = button:FindFirstChildWhichIsA("ProximityPrompt", true)
	if not prompt then return end

	while not (Backpack:FindFirstChild(toolName) or Character:FindFirstChild(toolName)) do
		fireproximityprompt(prompt)
		task.wait()
	end
end

buyTool("Pan", "Pan Buy button")
buyTool("BeachShovel", "botonComprarShovel")

local slayTarget = nil
local isSlaying = false

local function fireHits()
	pcall(function()
		hitRemote1:FireServer(1)
	end)
	pcall(function()
		hitRemote2:FireServer(1)
	end)
	pcall(function()
		hitRemote3:FireServer(1)
	end)
	pcall(function()
		hitRemote4:FireServer(1)
	end)
end

local function teleportToSky(character)
	local root = character:FindFirstChild("HumanoidRootPart")
	if root then
		root.CFrame = CFrame.new(0, 1000, 0)
	end
end

local function fireSlay()
	pcall(function()
		stompEvent:FireServer()
	end)
end

local function moveNearbyPlayers(localRoot)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local char = player.Character
			local humanoid = char and char:FindFirstChild("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")

			if humanoid and (humanoid.Health ~= 1 or humanoid.Health ~= 2 or humanoid.Health ~= 3) and root then

				root.CanCollide = false
				root.Size = Vector3.new(20, 20, 20)
				root.CFrame = localRoot.CFrame * CFrame.new(0, 0, -10)

			end
		end
	end
end

task.spawn(function()
	while true do
		local foundTarget = nil
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local char = player.Character
				local humanoid = char and char:FindFirstChild("Humanoid")
				local torso = char and char:FindFirstChild("UpperTorso")

				if humanoid and (humanoid.Health == 1 or humanoid.Health == 2 or humanoid.Health == 3) and torso then
					foundTarget = player
					break
				end
			end
		end

		slayTarget = foundTarget
		isSlaying = foundTarget ~= nil
		task.wait(1)
	end
end)

RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if not char or not root then return end

	if isSlaying and slayTarget and slayTarget.Character then
		local targetTorso = slayTarget.Character:FindFirstChild("UpperTorso")
		if targetTorso then
			root.CFrame = CFrame.new(targetTorso.Position) * CFrame.new(0, 2.5, 0)
			fireSlay()
		end
	else
		fireHits()
		teleportToSky(char)
		moveNearbyPlayers(root)
	end
end)

for i = 1, 80 do
	pcall(function()
		ReplicatedStorage.Modules.Net["RF/SalonPunch"]:InvokeServer()
	end)
end