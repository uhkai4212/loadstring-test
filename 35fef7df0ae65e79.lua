local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FakeLagGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.35, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🌀 Fake Lag - synt.t"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromHSV(0,1,1)
title.BackgroundTransparency = 1
spawn(function() while wait() do title.TextColor3 = Color3.fromHSV(tick()%5/5,1,1) end end)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 40)
toggleBtn.Text = "Fake Lag: OFF"
toggleBtn.Font = Enum.Font.Gotham
toggleBtn.TextSize = 14
toggleBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
toggleBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.9, 0, 0, 25)
box.Position = UDim2.new(0.05, 0, 0, 80)
box.PlaceholderText = "Speed (e.g. 2 for slowmo, 0.3 for hyper)"
box.Text = ""
box.BackgroundColor3 = Color3.fromRGB(45,45,45)
box.TextColor3 = Color3.new(1,1,1)
box.Font = Enum.Font.Gotham
box.TextSize = 13
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

local fakeLag = false
local delayValue = 2

toggleBtn.MouseButton1Click:Connect(function()
	fakeLag = not fakeLag
	toggleBtn.Text = "Fake Lag: "..(fakeLag and "ON" or "OFF")
	if fakeLag then
		delayValue = tonumber(box.Text) or 2
		spawn(function()
			while fakeLag do
				if char:FindFirstChild("HumanoidRootPart") then
					char.HumanoidRootPart.Anchored = true
					wait(delayValue)
					char.HumanoidRootPart.Anchored = false
				end
				wait(0.05)
			end
		end)
	end
end)