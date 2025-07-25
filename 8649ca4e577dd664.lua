local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Window
local Window = Rayfield:CreateWindow({
	Name = "RuneX hub | v1.0",
	LoadingTitle = "Loading....",
	LoadingSubtitle = "by jboskid",
	ShowText = "RX",
	Theme = "Ocean",
	ToggleUIKeybind = "K",
	ConfigurationSaving = {
		Enabled = true,
		FileName = "AbilityWarsTools"
	}
})

-- Tabs
local MainTab = Window:CreateTab("Main")
local CreditsTab = Window:CreateTab("Credits")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local defaultHitboxSize = Vector3.new(2, 2, 1)

-- ============================
-- 🛡️ Anti-Ragdoll (By JBOSKID)
-- ============================
local function removeRagdoll()
	local char = LocalPlayer.Character
	if not char then return end

	for _, v in pairs(char:GetDescendants()) do
		if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint") or v:IsA("Motor6D") then
			if v.Name == "RagdollConstraint" or v.Name:lower():find("ragdoll") then
				v:Destroy()
			end
		end
	end
end

-- Run on spawn
LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart", 5)
	task.wait(0.5)
	removeRagdoll()
end)

-- Run once on load
if LocalPlayer.Character then
	removeRagdoll()
end

-- Constantly remove ragdoll
RunService.Stepped:Connect(removeRagdoll)

-- ============================
-- 👀 Player ESP
-- ============================
MainTab:CreateToggle({
	Name = "Player ESP",
	CurrentValue = false,
	Callback = function(state)
		if state then
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local esp = Instance.new("BillboardGui", player.Character)
					esp.Name = "PlayerESP"
					esp.Adornee = player.Character.HumanoidRootPart
					esp.AlwaysOnTop = true
					esp.Size = UDim2.new(0, 100, 0, 40)
					esp.StudsOffset = Vector3.new(0, 3, 0)

					local label = Instance.new("TextLabel", esp)
					label.Size = UDim2.new(1, 0, 1, 0)
					label.BackgroundTransparency = 1
					label.Text = player.Name
					label.TextColor3 = Color3.fromRGB(255, 0, 0)
					label.TextScaled = true
					label.Font = Enum.Font.GothamBold
				end
			end
		else
			for _, player in pairs(Players:GetPlayers()) do
				if player.Character and player.Character:FindFirstChild("PlayerESP") then
					player.Character.PlayerESP:Destroy()
				end
			end
		end
	end
})

-- ============================
-- 💨 Speed Boost
-- ============================
MainTab:CreateToggle({
	Name = "Speed Boost",
	CurrentValue = false,
	Callback = function(val)
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
		if hum then
			hum.WalkSpeed = val and 80 or 16
		end
	end
})

-- ============================
-- ⚡ Infinite Jump
-- ============================
MainTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Callback = function(state)
		if state then
			_G.InfiniteJump = true
			UserInputService.JumpRequest:Connect(function()
				if _G.InfiniteJump then
					local char = LocalPlayer.Character
					if char and char:FindFirstChild("Humanoid") then
						char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end)
		else
			_G.InfiniteJump = false
		end
	end
})

-- ============================
-- 🔁 Reset Button
-- ============================
MainTab:CreateButton({
	Name = "Reset Character",
	Callback = function()
		local char = LocalPlayer.Character
		if char then
			char:BreakJoints()
		end
	end
})

-- ============================
-- 💥 Kill Aura + Hitbox Expander
-- ============================
local KillAuraEnabled = false
local HitboxSize = 20
local KillAuraRange = 25

MainTab:CreateSlider({
	Name = "Kill Aura Range + Hitbox",
	Range = {10, 30},
	Increment = 1,
	Suffix = "studs",
	CurrentValue = 20,
	Callback = function(value)
		HitboxSize = value
		KillAuraRange = value
	end
})

MainTab:CreateToggle({
	Name = "Kill Aura",
	CurrentValue = false,
	Callback = function(state)
		KillAuraEnabled = state

		if state then
			Rayfield:Notify({
				Title = "Kill Aura Enabled",
				Content = "Aura enabled...",
				Duration = 4
			})
		else
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local root = player.Character.HumanoidRootPart
					root.Size = defaultHitboxSize
					root.Transparency = 0
					root.Material = Enum.Material.Plastic
					root.Color = Color3.new(1, 1, 1)
					root.CanCollide = true
				end
			end
			Rayfield:Notify({
				Title = "Kill Aura Disabled",
				Content = "Hitboxes reset and attacking stopped.",
				Duration = 4
			})
		end
	end
})

-- Runtime Loop: Expand hitboxes + auto attack
RunService.RenderStepped:Connect(function()
	if KillAuraEnabled then
		-- Expand hitboxes
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local root = player.Character.HumanoidRootPart
				root.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
				root.Transparency = 0.6
				root.Color = Color3.new(1, 0, 0)
				root.Material = Enum.Material.ForceField
				root.CanCollide = false
			end
		end

		-- Punch closest player
		local char = LocalPlayer.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then return end

		local closest, dist = nil, KillAuraRange
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local mag = (char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
				if mag <= dist then
					dist = mag
					closest = player
				end
			end
		end

		if closest and closest.Character then
			mouse1click() -- Your executor must support this
		end
	end
end)

-- ============================
-- 🏷️ Credits Tab
-- ============================
CreditsTab:CreateButton({
	Name = "Credit to jboskid",
	Callback = function()
		Rayfield:Notify({
			Title = "Thanks!",
			Content = "Script made possible by: jboskid",
			Duration = 5
		})
	end
})