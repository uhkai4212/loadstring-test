local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuyMoonItem = ReplicatedStorage:WaitForChild("BuyMoonItem")
local GiveMoonCoin = ReplicatedStorage:WaitForChild("GiveMoonCoin")
local Player = game:GetService("Players").LocalPlayer

local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
gui.Name = "MoonItemGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 330) 
frame.Position = UDim2.new(0.5, -150, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Moon Item Buyer"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position = UDim2.new(0, 10, 0, 45)
scroll.Size = UDim2.new(1, -20, 1, -105)
scroll.CanvasSize = UDim2.new(0, 0, 0, 620)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1

local items = {
	"StraightConveyor",
	"LeftConveyor",
	"RightConveyor",
	"RGBMachine",
	"Polisher",
	"Freezer",
	"Goldifier",
	"Soaker",
	"MossMachine",
	"Rainbowifier",
	"VoidMachine",
	"DarkmatterMachine",
	"Duplicator",
	"CosmicMachine",
	"BlackHoleMachine",
	"CometMachine"
}

local UIListLayout = Instance.new("UIListLayout", scroll)
UIListLayout.Padding = UDim.new(0, 6)

for _, itemName in ipairs(items) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Text = "Buy " .. itemName
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.Parent = scroll

	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)

	button.MouseButton1Click:Connect(function()
		if itemName == "StraightConveyor" then
			BuyMoonItem:FireServer(1, "StraightConveyor")
		elseif itemName == "LeftConveyor" then
			BuyMoonItem:FireServer(1, "LeftConveyor")
		elseif itemName == "RightConveyor" then
			BuyMoonItem:FireServer(1, "RightConveyor")
		elseif itemName == "RGBMachine" then
			BuyMoonItem:FireServer(1, "RGBMachine")
		elseif itemName == "Polisher" then
			BuyMoonItem:FireServer(1, "Polisher")
		elseif itemName == "Freezer" then
			BuyMoonItem:FireServer(1, "Freezer")
		elseif itemName == "Goldifier" then
			BuyMoonItem:FireServer(1, "Goldifier")
		elseif itemName == "Soaker" then
			BuyMoonItem:FireServer(1, "Soaker")
		elseif itemName == "MossMachine" then
			BuyMoonItem:FireServer(1, "MossMachine")
		elseif itemName == "Rainbowifier" then
			BuyMoonItem:FireServer(1, "Rainbowifier")
		elseif itemName == "VoidMachine" then
			BuyMoonItem:FireServer(1, "VoidMachine")
		elseif itemName == "DarkmatterMachine" then
			BuyMoonItem:FireServer(1, "DarkmatterMachine")
		elseif itemName == "Duplicator" then
			BuyMoonItem:FireServer(1, "Duplicator")
		elseif itemName == "CosmicMachine" then
			BuyMoonItem:FireServer(1, "CosmicMachine")
		elseif itemName == "BlackHoleMachine" then
			BuyMoonItem:FireServer(1, "BlackHoleMachine")
		elseif itemName == "CometMachine" then
			BuyMoonItem:FireServer(1, "CometMachine")
		end

		button.Text = "Bought " .. itemName .. "!"
		task.wait(1)
		button.Text = "Buy " .. itemName
	end)
end

local getCoinsButton = Instance.new("TextButton", frame)
getCoinsButton.Size = UDim2.new(1, -20, 0, 40)
getCoinsButton.Position = UDim2.new(0, 10, 1, -55)
getCoinsButton.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
getCoinsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getCoinsButton.Font = Enum.Font.GothamBold
getCoinsButton.TextSize = 16
getCoinsButton.Text = "Get 10k Moon Coins"

Instance.new("UICorner", getCoinsButton).CornerRadius = UDim.new(0, 6)

getCoinsButton.MouseButton1Click:Connect(function()
	getCoinsButton.Text = "Getting 10k Moon Coins..."
	getCoinsButton.Active = false
	getCoinsButton.AutoButtonColor = false
	getCoinsButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)

 for i = 1, 10000 do
		GiveMoonCoin:FireServer()
		task.wait(0.001)
	end

	getCoinsButton.Text = "Got 10k Moon Coins!"
	task.wait(2)
	getCoinsButton.Text = "Get 10k Moon Coins"
	getCoinsButton.Active = true
	getCoinsButton.AutoButtonColor = true
	getCoinsButton.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
end)