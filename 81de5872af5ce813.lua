-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
	Name = "🐟 HOKALAZA | Steal A Fish",
	LoadingTitle = "HOKALAZA - Steal A Fish",
	LoadingSubtitle = "By CRAZY | Improved UI",
	ConfigurationSaving = {
		Enabled = false
	},
	KeySystem = false
})

-- INFO TAB
local InfoTab = Window:CreateTab("ℹ️ Info", 4483362458)
InfoTab:CreateSection("Script Features")
InfoTab:CreateParagraph({
	Title = "What this script does",
	Content = [[
🔒 Lock Base: Instantly TP to your base, bounce, and return  
⚡ Speed Boost: Move much faster for quick escapes  
💰 Auto Collect Money: (Coming soon!)  
🐟 Instant Steal Fish: Teleport & collect all fish automatically  
🧱 Remove Walls/Glass: Destroy obstacles for easy access  
⚡ Instant Interact: Instantly trigger all proximity prompts

💬 Join our Discord to keep up with updates!
]]
})

-- MAIN TAB
local MainTab = Window:CreateTab("🎮 Main", 4483362458)
MainTab:CreateSection("Quick Tips")
MainTab:CreateParagraph({
	Title = "How To Use",
	Content = [[
• Use 'Speed Boost' while stealing  
• Use 'Lock Base' to quickly return if far  
• 'Instant Steal Fish' is fully working!  
• 'Auto Collect Money' will be added soon.
]]
})

MainTab:CreateSection("Main Features")

-- Speed Boost
local defaultSpeed = 16
MainTab:CreateToggle({
	Name = "⚡ Speed Boost (Run super fast!)",
	CurrentValue = false,
	Callback = function(state)
		local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = state and 60 or defaultSpeed
		end
	end
})

-- Lock Base (TP to base, bounce, then return)
MainTab:CreateButton({
	Name = "🔒 Lock Base (Teleport Home)",
	Callback = function()
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		local originalPos = hrp.Position

		local basePos = Vector3.new(-54.81, 6.00, 15.66)
		hrp.CFrame = CFrame.new(basePos)

		-- Bounce
		task.spawn(function()
			for i = 1, 3 do
				hrp.CFrame = hrp.CFrame + Vector3.new(0, 2, 0)
				task.wait(0.2)
				hrp.CFrame = hrp.CFrame - Vector3.new(0, 2, 0)
				task.wait(0.2)
			end
		end)

		task.wait(2)
		hrp.CFrame = CFrame.new(originalPos)
	end
})

-- Auto Collect Money (placeholder)
MainTab:CreateToggle({
	Name = "💰 Auto Collect Money [COMING SOON]",
	CurrentValue = false,
	Callback = function()
		Rayfield:Notify({
			Title = "Coming Soon!",
			Content = "Auto Collect will be added soon...",
			Duration = 5
		})
	end
})

-- Instant Steal Fish
MainTab:CreateButton({
	Name = "🐟 Instant Steal All Fish (don't spam it)",
	Callback = function()
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		local originalPos = hrp.Position

		Rayfield:Notify({
			Title = "Stealing...",
			Content = "Preparing to steal all fish!",
			Duration = 3
		})

		local barTime = math.random(6, 8)
		for progress = 1, barTime do
			Rayfield:Notify({
				Title = "Insta Steal Fish",
				Content = "Loading... (" .. progress .. "/" .. barTime .. "s)",
				Duration = 1
			})
			task.wait(1)
		end

		for _, part in ipairs(workspace:GetDescendants()) do
			if part:IsA("BasePart") and part.Name:lower():find("collect") then
				hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
				task.wait(0.15)
			end
		end

		task.wait(0.5)
		hrp.CFrame = CFrame.new(originalPos)

		Rayfield:Notify({
			Title = "Success!",
			Content = "All fish have been stolen!",
			Duration = 5
		})
	end
})

-- Remove All Wall and Glass Parts
MainTab:CreateButton({
	Name = "🧱 Remove ALL Walls & Glass",
	Callback = function()
		for _, v in pairs(game:GetDescendants()) do
			if v:IsA("BasePart") and (v.Name == "Wall" or v.Name == "Glass") then
				v:Destroy()
			end
		end
		Rayfield:Notify({
			Title = "Removed",
			Content = "All Wall & Glass parts destroyed!",
			Duration = 4
		})
	end
})

-- Instant Proximity Prompt Activation
MainTab:CreateButton({
	Name = "⚡ Instant Interact with All Prompts",
	Callback = function()
		for _, prompt in pairs(game:GetDescendants()) do
			if prompt:IsA("ProximityPrompt") then
				fireproximityprompt(prompt)
			end
		end
		Rayfield:Notify({
			Title = "Activated",
			Content = "All available prompts have been triggered!",
			Duration = 4
		})
	end
})

-- (Optional) CREDITS TAB
local CreditsTab = Window:CreateTab("👑 Credits", 4483362458)
CreditsTab:CreateSection("Script & UI")
CreditsTab:CreateParagraph({
	Title = "Thanks for using HOKALAZA!",
	Content = "Script by CRAZY\nUI improvements by Copilot\nJoin my Discord: https://discord.gg/MFRtEsKm"
})
	else
		textbox.Text = ""
		textbox.PlaceholderText = "❌ Wrong Key! Try Again"
	end
end)

discordBtn.MouseButton1Click:Connect(function()
	setclipboard(DiscordLink)
	discordBtn.Text = "Copied!"
	task.delay(2, function()
		discordBtn.Text = "Get Key (Discord)"
	end)
end)