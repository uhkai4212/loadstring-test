button.MouseButton1Click:Connect(runBlockScript)
	
end
coroutine.wrap(PHFXBE_fake_script)()
local function HIFVFF_fake_script() -- TextButton_8.LocalScript 
	local script = Instance.new('LocalScript', TextButton_8)

	local button = script.Parent
	
	button.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end)
	
	
end
coroutine.wrap(HIFVFF_fake_script)()
local function QGKASIB_fake_script() -- TextButton_10.LocalScript 
	local script = Instance.new('LocalScript', TextButton_10)

	local button = script.Parent
	
	button.MouseButton1Click:Connect(function()
		--[[
		WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
	]]
		_G.Amount = 200
		loadstring(game:HttpGet("https://raw.githubusercontent.com/catblox1346/StensUIReMake/main/BabftRelated/SlotSpawner"))()
	end)
	
	
end
coroutine.wrap(QGKASIB_fake_script)()
local function WGDS_fake_script() -- ImageButton.LocalScript 
	local script = Instance.new('LocalScript', ImageButton)

	local button = script.Parent
	local screenGui = button:FindFirstAncestorOfClass("ScreenGui")
	
	button.MouseButton1Click:Connect(function()
		if screenGui then
			screenGui:Destroy()
		end
	end)
	
	
end
coroutine.wrap(WGDS_fake_script)()
local function QVSI_fake_script() -- TextButton_21.LocalScript 
	local script = Instance.new('LocalScript', TextButton_21)

	-- SETTINGS
	local button = script.Parent -- your TextButton/ImageButton
	local running = false
	local loopDelay = 3 -- seconds between chest purchases
	
	button.MouseButton1Click:Connect(function()
		running = not running -- toggle on/off
	
		if running then
			-- turn green
			button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	
			-- start loop
			task.spawn(function()
				while running do
					local args = {
						"Common Chest", -- chest name
						1               -- quantity
					}
					workspace:WaitForChild("ItemBoughtFromShop"):InvokeServer(unpack(args))
					task.wait(loopDelay)
				end
			end)
		else
			-- turn back to white
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		end
	end)
	
end
coroutine.wrap(QVSI_fake_script)()
local function MPGMB_fake_script() -- TextButton_22.LocalScript 
	local script = Instance.new('LocalScript', TextButton_22)

	-- SETTINGS
	local button = script.Parent -- your second TextButton/ImageButton
	local running = false
	local loopDelay = 3 -- seconds between chest purchases
	
	button.MouseButton1Click:Connect(function()
		running = not running -- toggle on/off
	
		if running then
			-- turn green
			button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	
			-- start loop
			task.spawn(function()
				while running do
					local args = {
						"Uncommon Chest", -- chest name
						1                  -- quantity
					}
					workspace:WaitForChild("ItemBoughtFromShop"):InvokeServer(unpack(args))
					task.wait(loopDelay)
				end
			end)
		else
			-- turn back to white
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		end
	end)
	
end
coroutine.wrap(MPGMB_fake_script)()
local function IOQASA_fake_script() -- TextButton_23.LocalScript 
	local script = Instance.new('LocalScript', TextButton_23)

	-- SETTINGS
	local button = script.Parent -- your Epic Chest button
	local running = false
	local loopDelay = 3 -- seconds between chest purchases
	
	button.MouseButton1Click:Connect(function()
		running = not running -- toggle on/off
	
		if running then
			-- turn green
			button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	
			-- start loop
			task.spawn(function()
				while running do
					local args = {
						"Epic Chest", -- chest name
						1              -- quantity
					}
					workspace:WaitForChild("ItemBoughtFromShop"):InvokeServer(unpack(args))
					task.wait(loopDelay)
				end
			end)
		else
			-- turn back to white
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		end
	end)
	
end
coroutine.wrap(IOQASA_fake_script)()
local function TRJYU_fake_script() -- TextButton_24.LocalScript 
	local script = Instance.new('LocalScript', TextButton_24)

	-- SETTINGS
	local button = script.Parent -- your Rare Chest button
	local running = false
	local loopDelay = 3 -- seconds between chest purchases
	
	button.MouseButton1Click:Connect(function()
		running = not running -- toggle on/off
	
		if running then
			-- turn green
			button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	
			-- start loop
			task.spawn(function()
				while running do
					local args = {
						"Rare Chest", -- chest name
						1              -- quantity
					}
					workspace:WaitForChild("ItemBoughtFromShop"):InvokeServer(unpack(args))
					task.wait(loopDelay)
				end
			end)
		else
			-- turn back to white
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		end
	end)
	
end
coroutine.wrap(TRJYU_fake_script)()
local function DGQPFIT_fake_script() -- TextButton_25.LocalScript 
	local script = Instance.new('LocalScript', TextButton_25)

	-- SETTINGS
	local button = script.Parent -- your Legendary Chest button
	local running = false
	local loopDelay = 3 -- seconds between chest purchases
	
	button.MouseButton1Click:Connect(function()
		running = not running -- toggle on/off
	
		if running then
			-- turn green
			button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	
			-- start loop
			task.spawn(function()
				while running do
					local args = {
						"Legendary Chest", -- chest name
						1                   -- quantity
					}
					workspace:WaitForChild("ItemBoughtFromShop"):InvokeServer(unpack(args))
					task.wait(loopDelay)
				end
			end)
		else
			-- turn back to white
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		end
	end)
	
end
coroutine.wrap(DGQPFIT_fake_script)()
local function XUPOAY_fake_script() -- TextButton_26.LocalScript 
	local script = Instance.new('LocalScript', TextButton_26)

	-- SETTINGS
	local button = script.Parent -- your PlasticBlock button
	local running = false
	local loopDelay = 3 -- seconds between purchases
	
	button.MouseButton1Click:Connect(function()
		running = not running -- toggle on/off
	
		if running then
			-- turn green
			button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	
			-- start loop
			task.spawn(function()
				while running do
					local args = {
						"PlasticBlock", -- item name
						1                -- quantity
					}
					workspace:WaitForChild("ItemBoughtFromShop"):InvokeServer(unpack(args))
					task.wait(loopDelay)
				end
			end)
		else
			-- turn back to white
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		end
	end)
	
end
coroutine.wrap(XUPOAY_fake_script)()
local function ETJF_fake_script() -- Main.LocalScript 
	local script = Instance.new('LocalScript', Main)

	local UserInputService = game:GetService("UserInputService")
	
	local gui = script.Parent
	
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	
	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
	
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end
coroutine.wrap(ETJF_fake_script)()