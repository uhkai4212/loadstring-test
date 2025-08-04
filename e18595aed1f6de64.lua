local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Spotlight.gg",
    SubTitle = "V1",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local InsertService = game:GetService("InsertService")
local player = Players.LocalPlayer

local speed = 80
local smoothness = 0.2
local tiltAmount = math.rad(45)
local currentVelocity = Vector3.zero
local targetVelocity = Vector3.zero
local droneAccessoryID = 0
local allowedAnimationId = "rbxassetid://0"
local flightConnection = nil
local animationConnection = nil

local function getInputDirection()
	local dir = Vector3.zero
	if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Vector3.new(0, 0, -1) end
	if UIS:IsKeyDown(Enum.KeyCode.S) then dir += Vector3.new(0, 0, 1) end
	if UIS:IsKeyDown(Enum.KeyCode.A) then dir += Vector3.new(-1, 0, 0) end
	if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Vector3.new(1, 0, 0) end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
	if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir += Vector3.new(0, -1, 0) end
	return dir.Magnitude > 0 and dir.Unit or Vector3.zero
end

local function enableFlight(character)
	local root = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")
	local camera = workspace.CurrentCamera
	humanoid.PlatformStand = true
	currentVelocity = Vector3.zero
	targetVelocity = Vector3.zero
	for _, p in pairs(character:GetDescendants()) do
		if p:IsA("BasePart") then p.CanCollide = false end
	end
	flightConnection = RunService.RenderStepped:Connect(function()
		local input = getInputDirection()
		local worldDir = camera.CFrame:VectorToWorldSpace(input)
		targetVelocity = worldDir * speed
		currentVelocity = currentVelocity:Lerp(targetVelocity, smoothness)
		root.Velocity = currentVelocity
		root.AssemblyAngularVelocity = Vector3.zero

		local forwardTilt = input.Z * tiltAmount
		local sideTilt = -input.X * tiltAmount
		local yaw = math.atan2(-camera.CFrame.LookVector.X, -camera.CFrame.LookVector.Z)

		local goal = CFrame.new(root.Position)
			* CFrame.Angles(0, yaw, 0)
			* CFrame.Angles(forwardTilt, 0, sideTilt)
		root.CFrame = root.CFrame:Lerp(goal, 0.2)
	end)
end

local function disableFlight(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if humanoid then humanoid.PlatformStand = false end
	for _, p in pairs(character:GetDescendants()) do
		if p:IsA("BasePart") then p.CanCollide = true end
	end
	if flightConnection then flightConnection:Disconnect() flightConnection = nil end
end

local function setupAnimationBlocking(character)
	local humanoid = character:WaitForChild("Humanoid")
	local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
	local anim = Instance.new("Animation")
	anim.AnimationId = allowedAnimationId
	local track = animator:LoadAnimation(anim)
	track:Play()
	task.wait()
	track.TimePosition = 2.1
	track:AdjustSpeed(0)
	animationConnection = humanoid.AnimationPlayed:Connect(function(track)
		if track.Animation and track.Animation.AnimationId ~= allowedAnimationId then
			print("Blocked animation:", track.Animation.AnimationId)
			track:Stop()
			track:Destroy()
		end
	end)
end

local function teardownAnimationBlocking()
	if animationConnection then animationConnection:Disconnect() animationConnection = nil end
end

local Toggle = Tabs.Main:AddToggle("FlightToggle", {Title = "Flight", Default = false})
Toggle:OnChanged(function()
	local char = player.Character
	if Toggle.Value and char then
		enableFlight(char)
		setupAnimationBlocking(char)
	else
		if char then
			disableFlight(char)
			teardownAnimationBlocking()
		end
	end
end)

player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid")
	char:WaitForChild("HumanoidRootPart")
	if Toggle.Value then
		enableFlight(char)
		setupAnimationBlocking(char)
	end
end)

local tpWalkEnabled = false
local tpWalkConnection = nil
local keysDown = {}
local tpSpeed = 5
local tpInterval = 0.03
local hrp

UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A 
	or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
		keysDown[input.KeyCode] = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A 
	or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
		keysDown[input.KeyCode] = nil
	end
end)

local function startTPWalk()
	tpWalkEnabled = true
	local char = player.Character or player.CharacterAdded:Wait()
	hrp = char:WaitForChild("HumanoidRootPart")

	tpWalkConnection = RunService.RenderStepped:Connect(function()
		if not tpWalkEnabled or not hrp then return end
		if next(keysDown) ~= nil then
			local direction = Vector3.zero

			if keysDown[Enum.KeyCode.W] then
				direction += hrp.CFrame.LookVector
			end
			if keysDown[Enum.KeyCode.S] then
				direction -= hrp.CFrame.LookVector
			end
			if keysDown[Enum.KeyCode.A] then
				direction -= hrp.CFrame.RightVector
			end
			if keysDown[Enum.KeyCode.D] then
				direction += hrp.CFrame.RightVector
			end

			direction = direction.Unit
			hrp.CFrame = hrp.CFrame + direction * tpSpeed
		end
	end)
end

local function stopTPWalk()
	tpWalkEnabled = false
	if tpWalkConnection then
		tpWalkConnection:Disconnect()
		tpWalkConnection = nil
	end
end

local SpeedToggle = Tabs.Main:AddToggle("SpeedToggle", { Title = "Speed Toggle", Default = false })
SpeedToggle:OnChanged(function(val)
	if val then
		startTPWalk()
	else
		stopTPWalk()
	end
end)

local SpeedSlider = Tabs.Main:AddSlider("SpeedSlider", {
	Title = "Speed",
	Description = "Adjust speed multiplier",
	Default = 100,
	Min = 1,
	Max = 100,
	Rounding = 0,
	Callback = function(val)
		speed = val 
		tpSpeed = val 

		local s = player:FindFirstChild("SpeedMult")
		if s and s:IsA("IntValue") then s.Value = val end
	end
})
SpeedSlider:OnChanged(function(val)
	speed = val
	tpSpeed = val

	local s = player:FindFirstChild("SpeedMult")
	if s and s:IsA("IntValue") then s.Value = val end
end)

local autokillEnabled = false
local autokillThread = nil

local function getCharacter(name)
	local chars = workspace:FindFirstChild("Characters")
	if chars then
		return chars:FindFirstChild(name)
	end
end

local function startAutokill()
	autokillEnabled = true
	autokillThread = task.spawn(function()
		while autokillEnabled do
			local myChar = getCharacter(player.Name)
			if not myChar then
				Fluent:Notify({
					Title = "Autokill Error",
					Content = "Could not find your character in workspace.Characters.",
					Duration = 4
				})
				task.wait(2)
				continue
			end

			local myPoints = myChar:FindFirstChild("highestpoints")
			if not myPoints or not myPoints:IsA("IntValue") then
				Fluent:Notify({
					Title = "Autokill Error",
					Content = "'highestpoints' IntValue is missing from your character.",
					Duration = 4
				})
				task.wait(2)
				continue
			end

			local bestTarget = nil
			local bestPoints = -math.huge

			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= player then
					local char = getCharacter(plr.Name)
					if char then
						local points = char:FindFirstChild("highestpoints")
						if points and points:IsA("IntValue") then
							if points.Value < myPoints.Value and points.Value > bestPoints then
								bestPoints = points.Value
								bestTarget = char
							end
						end
					end
				end
			end

			if not bestTarget then
				Fluent:Notify({
					Title = "Autokill Info",
					Content = "No player found with lower points than you.",
					Duration = 4
				})
				task.wait(5)
				continue
			end

			local myHRP = myChar:FindFirstChild("HumanoidRootPart")
			local targetHRP = bestTarget:FindFirstChild("HumanoidRootPart")

			if not myHRP or not targetHRP then
				Fluent:Notify({
					Title = "Autokill Error",
					Content = "Missing HumanoidRootPart on self or target.",
					Duration = 4
				})
				task.wait(2)
				continue
			end

			local originalCFrame = myHRP.CFrame
			myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 2, 0)

			Fluent:Notify({
				Title = "Autokill",
				Content = "Teleported to: " .. bestTarget.Name,
				Duration = 2
			})

			task.wait(0.5)
			myHRP.CFrame = originalCFrame
			task.wait(5)
		end
	end)
end



local function stopAutokill()
	autokillEnabled = false
	if autokillThread then
		task.cancel(autokillThread)
		autokillThread = nil
	end
end

local AutokillToggle = Tabs.Main:AddToggle("AutokillToggle", { Title = "Autokill", Default = false })
AutokillToggle:OnChanged(function(val)
	if val then
		startAutokill()
	else
		stopAutokill()
	end
end)

local autofarmEnabled = false
local autofarmConnection = nil
local TweenService = game:GetService("TweenService")

local function getFurthestOrb4(fromPosition)
	local furthest = nil
	local maxDistance = -math.huge

	for _, orb in pairs(workspace:WaitForChild("Orbs"):GetChildren()) do
		if orb:IsA("BasePart") and orb.Name == "4" then
			local distance = (orb.Position - fromPosition).Magnitude
			if distance > maxDistance then
				maxDistance = distance
				furthest = orb
			end
		end
	end

	return furthest
end

local currentTween = nil

local function cancelCurrentTween()
	if currentTween then
		currentTween:Cancel()
		currentTween = nil
	end
end

local function tweenToPosition(part, goalPos, time)
	cancelCurrentTween()
	local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
	local goal = { Position = goalPos }
	currentTween = TweenService:Create(part, tweenInfo, goal)
	currentTween:Play()

	local done = false
	currentTween.Completed:Connect(function()
		done = true
	end)

	while not done and autofarmEnabled do
		task.wait()
	end
end

local function startFastAutofarm()
	autofarmEnabled = true
	autofarmConnection = task.spawn(function()
		while autofarmEnabled do
			local char = player.Character
			if not char then task.wait(1) continue end

			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then
				Fluent:Notify({
					Title = "Fast Autofarm Error",
					Content = "HumanoidRootPart not found.",
					Duration = 4
				})
				task.wait(2)
				continue
			end

			local orb = getFurthestOrb4(hrp.Position)
			if not orb then
				Fluent:Notify({
					Title = "Fast Autofarm Info",
					Content = "No orb named '4' found in workspace.Orbs.",
					Duration = 3
				})
				task.wait(2)
				continue
			end

			local destination = Vector3.new(orb.Position.X, hrp.Position.Y, orb.Position.Z)
			local distance = (destination - hrp.Position).Magnitude
			local travelTime = distance / 100 -- You can adjust speed here

			tweenToPosition(hrp, destination, travelTime)

			task.wait(0.2) -- slight delay before next search
		end
	end)
end

local function stopFastAutofarm()
	autofarmEnabled = false
	cancelCurrentTween()
	if autofarmConnection then
		task.cancel(autofarmConnection)
		autofarmConnection = nil
	end
end

local AutofarmToggle = Tabs.Main:AddToggle("FastAutofarmToggle", {
	Title = "Fast Autofarm",
	Default = false
})
AutofarmToggle:OnChanged(function(val)
	if val then
		startFastAutofarm()
	else
		stopFastAutofarm()
	end
end)

local skins = {
	"Default", "Zombie", "Noob", "Cool", "Nerd", "Nature", "Robot", "Dino",
	"Pirate", "Reindeer", "Evil", "Cowboy", "Police", "Elegant", "Party",
	"Red Space", "Blue Space", "Purple Space", "Ninja", "Alien", "Burger",
	"Chicken", "Cursed", "Galaxy", "Bling", "Gold Space", "Gold", "King"
}
local SkinDropdown = Tabs.Main:AddDropdown("SkinDropdown", {
	Title = "Skin Selector",
	Description = "Choose a skin",
	Values = skins,
	Multi = false,
	Default = 1,
	Callback = function(val)
		local skin = player:FindFirstChild("EquippedSkin")
		if skin and skin:IsA("StringValue") then skin.Value = val end
	end
})
SkinDropdown:OnChanged(function(val)
	local skin = player:FindFirstChild("EquippedSkin")
	if skin and skin:IsA("StringValue") then skin.Value = val end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("SpotlightGG")
SaveManager:SetFolder("SpotlightGG/GameConfigs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
	Title = "Spotlight.gg",
	Content = "Script has been loaded successfully.",
	Duration = 6
})
SaveManager:LoadAutoloadConfig()