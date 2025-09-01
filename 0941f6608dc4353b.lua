local Rayfield = loadstring(game:HttpGet("sirius.menu/rayfield"))()
local LocalPlayer = game.Players.LocalPlayer
local PlayerScripts = LocalPlayer.PlayerScripts
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpeedController = require(PlayerScripts.Controllers.SpeedController)
local NewWalkSpeed = 31
local AutoCollect = false
local AutoLock = false
local InfJump
local Noclip
local TPSteal = false


local function FindBase() -- FIND PLAYERS BASE
	for _, base in pairs(workspace.Map.Bases:GetChildren()) do
		if base.Owner.SurfaceGui.TextLabel.Text == LocalPlayer.Name then
			return base
		end
	end
end


local Base = FindBase()

local Window = Rayfield:CreateWindow({
	Name = "RuHub Steal an MMA Fighter",
	Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "Steal an MMA fighter",
	LoadingSubtitle = "by rurur123 on discord!",
	ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
	Theme = "Ocean", -- Check https://docs.sirius.menu/rayfield/configuration/themes
	ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)
	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
	ConfigurationSaving = {
		Enabled = false,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "Big Hub"
	},
	Discord = {
		Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
		Invite = "T9baH5j9NU", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
		RememberJoins = false -- Set this to false to make them join the discord every time they load it up
	},
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Untitled",
		Subtitle = "Key System",
		Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
		FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = {
			"Hello"
		} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
})
local MainTab = Window:CreateTab("Main", 0)

MainTab:CreateSection("LocalPlayer")


SpeedController._GetCurrentWalkSpeed = function()
	return NewWalkSpeed
end

MainTab:CreateSlider({
	Name = "WalkSpeed",
	Range = {31, 500},
	Increment = 1,
	Suffix = "",
	CurrentValue = 31,
	Flag = "Slider1",
	Callback = function(V)
		NewWalkSpeed = V
	end
})

MainTab:CreateSlider({
	Name = "JumpPower",
	Range = {50, 150},
	Increment = 1,
	Suffix = "",
	CurrentValue = 50,
	Flag = "Slider1",
	Callback = function(V)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid.UseJumpPower = true
			LocalPlayer.Character.Humanoid.JumpPower = V
		end
	end
})


game:GetService("UserInputService").JumpRequest:Connect(function()
	if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

MainTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(V)
		InfJump = V
	end
})

local function SetNoclip(V)
	if LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = V
			end
		end
	end
end

game:GetService("RunService").Stepped:Connect(function()
	if Noclip then
		SetNoclip(false)
	else
		SetNoclip(true)
	end
end)

MainTab:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(V)
		Noclip = V
	end
})

MainTab:CreateToggle({
    Name = "Anti Void",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(V)
        game.Workspace.FallenPartsDestroyHeight = V and -10000 or -500
    end
})

MainTab:CreateSection("Stealing")

-- TELEPORT WHEN STOLEN START
local function StealCheck(C)
	local connection
	connection = CollectionService:GetInstanceAddedSignal("Stealing"):Connect(function(V)
		if V == C then
			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Base.FirstFloorDoor.Position)
		end
	end)
	return connection
end
local function StealCheckOff(connection)
	if connection then
		connection:Disconnect()
	end
end
LocalPlayer.CharacterAdded:Connect(function(char)
	if TPSteal then
		StealCheck(char)
	else
		StealCheckOff()
	end
end)
--END OF TELEPORT WHEN STOLEN

MainTab:CreateToggle({
	Name = "Teleport To Base When Stealing",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(V)
		TPSteal = V
		if V and LocalPlayer.Character then
			StealCheck(LocalPlayer.Character)
		else
			StealCheckOff()
		end
	end
})


MainTab:CreateToggle({
	Name = "MMA Fighter Esp",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(V)
		for _, base in pairs(workspace.Map.Bases:GetChildren()) do
			for _, stand in pairs(base:FindFirstChild("Stands"):GetChildren()) do
				if stand.Spawn and stand.Spawn:FindFirstChild("Attachment") and stand.Spawn.Attachment:FindFirstChild("NPCOverhead") then
					local NPCOH = stand.Spawn.Attachment.NPCOverhead
					NPCOH.AlwaysOnTop = V
					NPCOH.MaxDistance = V and 10000 or 60
					NPCOH.Size = V and UDim2.new(30, 0, 20, 0) or UDim2.new(15, 0, 5, 0)
				end
			end
		end
	end
})

MainTab:CreateToggle({
	Name = "Base Timer ESP",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(V)
		for _, base in pairs(workspace.Map.Bases:GetChildren()) do
			local BillBoard = base.LockButtons.Lock.BillboardGui
			if BillBoard:FindFirstChild("LockText") then
				BillBoard.LockText.Visible = not V and true or false
			end
			BillBoard.MaxDistance = V and 1000 or 105
			BillBoard.AlwaysOnTop = V
			BillBoard.Size = V and UDim2.new(50, 0, 50, 0) or UDim2.new(6, 0, 4, 0)
			BillBoard.Timer.TextScaled = V
		end
	end
})



MainTab:CreateSection("Money")

MainTab:CreateToggle({
	Name = "Auto Collect Money",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(V)
		AutoCollect = V
		while AutoCollect do
			for i = 1, #Base.Stands:GetChildren() do
				game:GetService("ReplicatedStorage").Packages.Knit.Services.AthleteService.RF._CollectStandMoney:InvokeServer(i)
			end
			wait()
		end
	end
})

MainTab:CreateToggle({
	Name = "Auto Lock Base",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(V)
		AutoLock = V
		while AutoLock do
			game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlotService"):WaitForChild("RF"):WaitForChild("_LockPlayerBase"):InvokeServer()
			wait()
		end
	end
})


MainTab:CreateSection("Other")

MainTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end,
})

MainTab:CreateButton({
	Name = "Show Glorious and Amazing king",
	Callback = function()
		local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = LocalPlayer.PlayerGui
		local ImageI = Instance.new("ImageLabel")
        ImageI.Parent = ScreenGui
		ImageI.Size = UDim2.new(1, 0, 1, 0)
		ImageI.Image = "rbxassetid://116567359225697"
		wait(5)
		ScreenGui:Destroy()
	end,
})

local CreditsTab = Window:CreateTab("Credits", 0)

CreditsTab:CreateLabel("Click On the Buttons to copy each thing!")

CreditsTab:CreateButton({
    Name = "Creator of script: rurur123 on discord",
    Callback = function()
        setclipboard("rurur123")
    end,
})

CreditsTab:CreateButton({
    Name = "My Roblox: stopbanforhydro",
    Callback = function()
        setclipboard("stopbanforhydro")
    end,
})