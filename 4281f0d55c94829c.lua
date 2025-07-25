local rs = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "YourJourneyScript"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Frame btw
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 500, 0, 300)
Frame.Position = UDim2.new(0.5, -250, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = gui

-- Close and Toggle GUI Buttons
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Close.TextColor3 = Color3.new(1, 1, 1)
Close.Parent = Frame

local ToggleGUI = Instance.new("TextButton")
ToggleGUI.Size = UDim2.new(0, 100, 0, 40)
ToggleGUI.Position = UDim2.new(0, 10, 0, 10)
ToggleGUI.Text = "Open GUI"
ToggleGUI.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
ToggleGUI.TextColor3 = Color3.new(1, 1, 1)
ToggleGUI.Visible = false
ToggleGUI.Parent = gui

Close.MouseButton1Click:Connect(function()
    Frame.Visible = false
    ToggleGUI.Visible = true
end)

ToggleGUI.MouseButton1Click:Connect(function()
    Frame.Visible = true
    ToggleGUI.Visible = false
end)

-- Give Item
local itemNameInput = Instance.new("TextBox")
itemNameInput.Size = UDim2.new(0.5, -20, 0, 40)
itemNameInput.Position = UDim2.new(0, 10, 0, 50)
itemNameInput.PlaceholderText = "Enter item name"
itemNameInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
itemNameInput.TextColor3 = Color3.new(0, 0, 0)
itemNameInput.ClearTextOnFocus = false
itemNameInput.Parent = Frame

local giveItemBtn = Instance.new("TextButton")
giveItemBtn.Size = UDim2.new(0.5, -20, 0, 40)
giveItemBtn.Position = UDim2.new(0.5, 10, 0, 50)
giveItemBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
giveItemBtn.Text = "Give Item"
giveItemBtn.TextColor3 = Color3.new(1, 1, 1)
giveItemBtn.Font = Enum.Font.SourceSansBold
giveItemBtn.TextSize = 20
giveItemBtn.Parent = Frame

giveItemBtn.MouseButton1Click:Connect(function()
	local itemName = itemNameInput.Text
	if itemName and itemName ~= "" then
		rs.AddItem:FireServer(itemName, 9999999999)
	end
end)

-- Toggle builder
local function createToggle(label, color, position, onToggle)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.45, -20, 0, 40)
	btn.Position = position
	btn.BackgroundColor3 = color
	btn.Text = label .. " (OFF)"
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 20
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Parent = Frame

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = label .. (state and " (ON)" or " (OFF)")
		onToggle(state)
	end)

	return function()
		return state
	end
end

-- Stamina
local staminaToggle
staminaToggle = createToggle("Stamina", Color3.fromRGB(50, 50, 200), UDim2.new(0, 10, 0, 100), function(state)
	if state then
		task.spawn(function()
			while staminaToggle() do
				rs.UpdateStamina:FireServer(100000)
				task.wait(0.2)
			end
		end)
	end
end)

-- Reputation
local repToggle
repToggle = createToggle("Reputation", Color3.fromRGB(200, 150, 30), UDim2.new(0.5, 10, 0, 100), function(state)
	if state then
		task.spawn(function()
			while repToggle() do
				rs.UpdateReputation:FireServer(100000)
				task.wait(0.2)
			end
		end)
	end
end)

-- Money
local moneyToggle
moneyToggle = createToggle("Money", Color3.fromRGB(120, 120, 30), UDim2.new(0, 10, 0, 150), function(state)
	if state then
		task.spawn(function()
			while moneyToggle() do
				rs.UpdateStamina:FireServer(-0.1)
				rs.UpdateGold:FireServer(100000)
				task.wait(0.2)
			end
		end)
	end
end)

-- Auto Quest
local questToggle
questToggle = createToggle("Auto Quest", Color3.fromRGB(200, 80, 150), UDim2.new(0.5, 10, 0, 150), function(state)
	if state then
		task.spawn(function()
			while questToggle() do
				rs.TakeJobRequest:FireServer()
				rs.CompleteQuestRequest:FireServer()
				task.wait(1)
			end
		end)
	end
end)

-- Gifted
local gifted = Instance.new("TextButton")
gifted.Size = UDim2.new(1, -20, 0, 40)
gifted.Position = UDim2.new(0, 10, 0, 200)
gifted.BackgroundColor3 = Color3.fromRGB(90, 200, 90)
gifted.Text = "Gifted"
gifted.Font = Enum.Font.SourceSansBold
gifted.TextSize = 20
gifted.TextColor3 = Color3.new(1, 1, 1)
gifted.Parent = Frame

gifted.MouseButton1Click:Connect(function()
	rs.UpdateChapter:FireServer(2)
	for _ = 1, 1000 do
		rs.PerformStatAction:FireServer("GreetGuardButton")
		rs.PerformStatAction:FireServer("NameBeastButton")
		rs.PerformStatAction:FireServer("LiftLogButton")
	end
end)