local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Main GUI container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BeanHubMain"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Bean Hub button (middle-left)
local BeanHubButton = Instance.new("TextButton")
BeanHubButton.Size = UDim2.new(0, 100, 0, 40)
BeanHubButton.Position = UDim2.new(0, 0, 0.5, -20) -- middle left
BeanHubButton.BackgroundColor3 = Color3.fromRGB(102, 0, 153)
BeanHubButton.TextColor3 = Color3.new(1, 1, 1)
BeanHubButton.Font = Enum.Font.GothamBold
BeanHubButton.TextSize = 18
BeanHubButton.Text = "Bean Hub"
BeanHubButton.Parent = ScreenGui

-- Bean Hub (Heist Tycoon) UI frame (hidden by default)
local HubFrame = Instance.new("Frame")
HubFrame.Size = UDim2.new(0, 200, 0, 150)
HubFrame.Position = UDim2.new(0, 110, 0.5, -75) -- right next to button
HubFrame.BackgroundColor3 = Color3.fromRGB(204, 153, 255)
HubFrame.Visible = false
HubFrame.Parent = ScreenGui

-- Title label
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Bean Hub (Heist Tycoon)"
Title.TextColor3 = Color3.fromRGB(102, 0, 153)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = HubFrame

-- Inf Money button
local InfMoneyButton = Instance.new("TextButton")
InfMoneyButton.Size = UDim2.new(1, -20, 0, 40)
InfMoneyButton.Position = UDim2.new(0, 10, 0, 50)
InfMoneyButton.BackgroundColor3 = Color3.fromRGB(102, 0, 153)
InfMoneyButton.TextColor3 = Color3.new(1, 1, 1)
InfMoneyButton.Font = Enum.Font.Gotham
InfMoneyButton.TextSize = 16
InfMoneyButton.Text = "Inf Money"
InfMoneyButton.Parent = HubFrame

-- Toggle the hub frame visibility when clicking the Bean Hub button
BeanHubButton.MouseButton1Click:Connect(function()
	HubFrame.Visible = not HubFrame.Visible
end)

-- Infinite money loop control
local infMoneyConnection

InfMoneyButton.MouseButton1Click:Connect(function()
	if infMoneyConnection then
		-- Stop if already running
		infMoneyConnection:Disconnect()
		infMoneyConnection = nil
		InfMoneyButton.Text = "Inf Money"
		print("Infinite money stopped")
	else
		-- Start infinite money loop
		infMoneyConnection = RunService.Heartbeat:Connect(function()
			local args = {[1] = player}
			local success, err = pcall(function()
				game:GetService("ReplicatedStorage").Knit.Services.TycoonService.RF.PayIncome:InvokeServer(unpack(args))
			end)
			if not success then
				warn("Failed to invoke PayIncome:", err)
			end
		end)
		InfMoneyButton.Text = "Stop Inf Money"
		print("Infinite money started")
	end
end)