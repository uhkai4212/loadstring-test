local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "S.E.W.H ⚡",
	LoadingTitle = "S.E.W.H GUI",
	LoadingSubtitle = "By Nathan + ChatGPT",
	ConfigurationSaving = { Enabled = false },
	KeySystem = false,
})

-- ✅ Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local AutoWinTab = Window:CreateTab("AutoWin", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- 🛡 Passive Adonis Anti-Cheat Bypass (always enabled)
local getinfo = getinfo or debug.getinfo
local DEBUG = false
local Hooked = {}
local Detected, Kill
if setthreadidentity then setthreadidentity(2) end
for i, v in getgc(true) do
    if typeof(v) == "table" then
        local DetectFunc = rawget(v, "Detected")
        local KillFunc = rawget(v, "Kill")
        if typeof(DetectFunc) == "function" and not Detected then
            Detected = DetectFunc
            hookfunction(Detected, function(Action, Info, NoCrash)
                if Action ~= "_" then
                    if DEBUG then warn("Adonis Flagged", Action, Info) end
                end
                return true
            end)
            table.insert(Hooked, Detected)
        end
        if rawget(v, "Variables") and rawget(v, "Process") and typeof(KillFunc) == "function" and not Kill then
            Kill = KillFunc
            hookfunction(Kill, function(Info)
                if DEBUG then warn("Adonis Kill", Info) end
            end)
            table.insert(Hooked, Kill)
        end
    end
end
hookfunction(getrenv().debug.info, newcclosure(function(...)
    local a, b = ...
    if Detected and a == Detected then
        if DEBUG then warn("Adonis bypassed") end
        return coroutine.yield(coroutine.running())
    end
    return debug.info(...)
end))
if setthreadidentity then setthreadidentity(7) end

-- ✅ MAIN TAB
-- Infinite Stamina
local aux = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/ohaux.lua"))()
local scriptPath = game:GetService("ReplicatedStorage").Resources.Client.SprintHandler
local closure1 = aux.searchClosure(scriptPath, "startSprint", 10, {
	[1] = "MoveDirection", [2] = "Magnitude", [3] = 0.2, [4] = "Play",
	[5] = "DestroyIdentifier", [6] = "BaseRegen"
})
local closure2 = aux.searchClosure(scriptPath, "startSprint", 4, {
	[1] = "MoveDirection", [2] = "Magnitude", [3] = 0.2, [4] = "Play",
	[5] = "DestroyIdentifier", [6] = "BaseRegen"
})

MainTab:CreateToggle({
	Name = "Infinite Stamina",
	CurrentValue = false,
	Flag = "InfStam",
	Callback = function(state)
		if closure1 then debug.getupvalue(closure1, 10)["MaxStamina"] = state and 1e308 or 100 end
		if closure2 then debug.setupvalue(closure2, 4, state and 1e308 or 100) end
	end
})

-- Semi God Mode (with Adonis bypass)
local semiGodActive = false
local semiGodHook
MainTab:CreateToggle({
	Name = "Semi God Mode",
	CurrentValue = false,
	Callback = function(state)
		if state and not semiGodActive then
			if hookmetamethod then
				semiGodHook = hookmetamethod(game, "__namecall", function(self, ...)
					local args = {...}
					local method = getnamecallmethod()
					if method == "FireServer" and self.Name == "Asynchronous" then
						if args[1] == "HurtSelf" then args[3] = 0.001 end
						if args[1] == "CharHit" then args[4] = "Humanoid" end
						return semiGodHook(self, unpack(args))
					end
					return semiGodHook(self, ...)
				end)
				semiGodActive = true
			else
				game:GetService("Players").LocalPlayer:Kick("Exploit not supported!")
			end
		elseif not state and semiGodActive then
			print("Rejoin to fully disable Semi God Mode.")
			semiGodActive = false
		end
	end
})

-- AntiVoid
MainTab:CreateButton({
	Name = "AntiVoid / AntiDrown",
	Callback = function()
		local part = Instance.new("Part")
		part.Size = Vector3.new(1000, 1, 1000)
		part.Position = Vector3.new(0, -10, 0)
		part.Anchored = true
		part.CanCollide = true
		part.Transparency = 0.4
		part.BrickColor = BrickColor.new("Lime green")
		part.Name = "AntiVoid"
		part.Parent = workspace
	end
})

-- Noclip
MainTab:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Callback = function(state)
		if state then
			_G.NoclipLoop = game:GetService("RunService").Stepped:Connect(function()
				local char = game.Players.LocalPlayer.Character
				if char then
					for _, part in pairs(char:GetDescendants()) do
						if part:IsA("BasePart") then part.CanCollide = false end
					end
				end
			end)
		else
			if _G.NoclipLoop then _G.NoclipLoop:Disconnect() end
		end
	end
})

-- ✅ AUTOWIN TAB
AutoWinTab:CreateButton({
	Name = "Camp Under Map (Deeper)",
	Callback = function()
		local platform = Instance.new("Part")
		platform.Size = Vector3.new(500, 1, 500)
		platform.Position = Vector3.new(0, -500, 0)
		platform.Anchored = true
		platform.CanCollide = true
		platform.Transparency = 0.7
		platform.Color = Color3.fromRGB(0, 255, 0)
		platform.Name = "AutoWinPlatform"
		platform.Parent = workspace
		local char = game.Players.LocalPlayer.Character
		if char then char:MoveTo(Vector3.new(0, -498, 0)) end
	end
})

-- ✅ MISC TAB
MiscTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Callback = function(enabled)
		if enabled then
			_G.InfiniteJumpEnabled = true
			game:GetService("UserInputService").JumpRequest:Connect(function()
				if _G.InfiniteJumpEnabled then
					local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
					if hum then hum:ChangeState("Jumping") end
				end
			end)
		else
			_G.InfiniteJumpEnabled = false
		end
	end
})

MiscTab:CreateToggle({
	Name = "JumpBoost",
	CurrentValue = false,
	Callback = function(enabled)
		if enabled then
			_G.JumpLoop = true
			while _G.JumpLoop do
				task.wait(0.1)
				local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				if hum then hum.JumpPower = _G.CustomJump or 80 end
			end
		else
			_G.JumpLoop = false
			local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.JumpPower = 50 end
		end
	end
})

MiscTab:CreateSlider({
	Name = "Set JumpPower",
	Range = {1, 1000},
	Increment = 1,
	Suffix = "Power",
	CurrentValue = 80,
	Callback = function(Value)
		_G.CustomJump = Value
	end
})