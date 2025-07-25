local Victims = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Teams = game:GetService("Teams")
local Camera = workspace.CurrentCamera
local LocalPlayer = Victims.LocalPlayer
local debugMode = true   -- ENABLE FOR MOBILE PORT | GIVES MOBILE GUI FOR PC
local fakeDead = false
local SheriffGunMeshIDs = {
    [13221690265] = true,
    [4651303552] = true
}
local KillerGunMeshIDs = {
    [450910072] = true,
    [12605873915] = true,
    [5594519425] = true,
    [18909786333] = true,
    [4479469250] = true
}
local InnocentItems = {
    --[212302951] = "Boombox",
    --[121944778] = "Knife",
}
local Settings = {
    espEnabled = true,
    fillTransparency = 0.5,
    outlineTransparency = 0.5,
    outlineColor = Color3.fromRGB(255, 255, 255),
    thickness = 0.8,
    teamColors = {
        ["TEAM1"] = Color3.fromRGB(255, 60, 60),
        ["TEAM2"] = Color3.fromRGB(60, 160, 255),
        ["Nuetral"] = Color3.fromRGB(200, 200, 200),
        Default = Color3.fromRGB(60, 255, 60),
        Killer = Color3.fromRGB(255, 60, 60),
        Sheriff = Color3.fromRGB(60, 160, 255),
        Other = Color3.fromRGB(60, 255, 60)
    },
    gui = {
        font = Enum.Font.SourceSansBold,
        titleColor = Color3.fromRGB(255, 255, 255),
        backgroundColor = Color3.fromRGB(50, 50, 50),
        buttonColor = Color3.fromRGB(60, 160, 255),
        textColor = Color3.new(1, 1, 1),
        cornerRadius = UDim.new(0, 5),
        padding = 5
    }
}
local TeamCache = {
    exists = false,
    lastCheck = 0
}
local function CheckTeamsExist()
    if os.clock() - TeamCache.lastCheck > 5 then
        TeamCache.exists = #Teams:GetTeams() > 1
        TeamCache.lastCheck = os.clock()
    end
    return TeamCache.exists
end
local function GetPlayerTeamColor(player)
    if not player.Team then return nil end
    local teamName = player.Team.Name
    return Settings.teamColors[teamName]
end
local function GetWeaponColor(player)
	local function scanPartsForWeapon(container)
		for _, part in ipairs(container:GetDescendants()) do
			if part:IsA("MeshPart") or part:IsA("SpecialMesh") then
				local meshId = part.MeshId and tonumber(part.MeshId:match("%d+"))
				if meshId then
					if SheriffGunMeshIDs[meshId] then
						return Settings.teamColors.Sheriff
					elseif KillerGunMeshIDs[meshId] then
						return Settings.teamColors.Killer
					end
				end
			end
		end
		return nil
	end
	if player.Character then
		local color = scanPartsForWeapon(player.Character)
		if color then return color end
	end
	if player:FindFirstChild("Backpack") then
		local color = scanPartsForWeapon(player.Backpack)
		if color then return color end
	end
	return Settings.teamColors.Default
end
-- Old method of checking
local function GetPlayerTools(player)
    local tools = {}
    if player.Character then
        for _, item in ipairs(player.Character:GetChildren()) do
            if item:IsA("Tool") then
                tools[item.Name] = true
            end
        end
    end
    if player.Backpack then
        for _, item in ipairs(player.Backpack:GetChildren()) do
            if item:IsA("Tool") then
                tools[item.Name] = true
            end
        end
    end
    return tools
end
local function GrabGun()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local gunModel = workspace:FindFirstChild("BaseGame")
		and workspace.BaseGame:FindFirstChild("GamemodeScript")
		and workspace.BaseGame.GamemodeScript:FindFirstChild("SheriffDeathScript")
		and workspace.BaseGame.GamemodeScript.SheriffDeathScript:FindFirstChild("Model")
	if not gunModel then return end
	local gunPart = gunModel:FindFirstChildWhichIsA("BasePart", true)
	if not gunPart then return end
	local originalCFrame = hrp.CFrame
	hrp.CFrame = gunPart.CFrame + Vector3.new(0, 2, 0)
	task.wait()
	hrp.CFrame = originalCFrame
end
local Highlights = {}
local function UpdateHighlight(player)
    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end
    local highlightColor = Settings.teamColors.Default
    local teamsExist = CheckTeamsExist()
    if teamsExist then
        highlightColor = GetPlayerTeamColor(player)
        if not highlightColor then
            highlightColor = Settings.teamColors.Default
        end
    else
        highlightColor = GetWeaponColor(player)
    end
    local highlight = Highlights[player]
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.OutlineColor = Settings.outlineColor
        highlight.FillTransparency = Settings.fillTransparency
        highlight.OutlineTransparency = Settings.outlineTransparency
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = CoreGui
        Highlights[player] = highlight
    end
    highlight.FillColor = highlightColor
    highlight.Adornee = character
end
local function CleanHighlights()
    for player, highlight in pairs(Highlights) do
        if not Victims:FindFirstChild(player.Name) or not player.Character or not Settings.espEnabled then
            highlight:Destroy()
            Highlights[player] = nil
        end
    end
end
if UserInputService.KeyboardEnabled then
    Settings.debugMode = true
end
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.KeypadOne then
        Settings.espEnabled = not Settings.espEnabled
        if not Settings.espEnabled then
            for _, h in pairs(Highlights) do h:Destroy() end
            Highlights = {}
        end
    elseif input.KeyCode == Enum.KeyCode.KeypadTwo then
        GrabGun()
    end
end)
RunService.RenderStepped:Connect(function()
    if not Settings.espEnabled then return end
    for _, player in ipairs(Victims:GetPlayers()) do
        if player ~= LocalPlayer then
            pcall(UpdateHighlight, player)
        end
    end
    CleanHighlights()
end)
if not UserInputService.TouchEnabled and not debugMode then
    return
end
GuiConfig = GuiConfig or {}
GuiConfig.gui = GuiConfig.gui or {
	backgroundColor = Color3.fromRGB(40, 40, 40),
	cornerRadius = UDim.new(0, 8),
	titleHeight = 30,
	titleColor = Color3.new(1, 1, 1),
	buttonHeight = 35,
	buttonColor = Color3.fromRGB(60, 60, 60),
	buttonHoverColor = Color3.fromRGB(80, 80, 80),
	textColor = Color3.new(1, 1, 1),
	espEnabled = false
}
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "MainGui"
MainGui.ResetOnSpawn = false
MainGui.Parent = CoreGui
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 220)
MainFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
MainFrame.BackgroundColor3 = GuiConfig.gui.backgroundColor
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui
Instance.new("UICorner", MainFrame).CornerRadius = GuiConfig.gui.cornerRadius
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(80, 80, 80)
stroke.Parent = MainFrame
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -40, 0, GuiConfig.gui.titleHeight)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = GuiConfig.gui.titleColor
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Text = "Blood Debt Mobile"
TitleLabel.Parent = MainFrame
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Position = UDim2.new(1, -30, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Text = "-"
MinimizeButton.AutoButtonColor = false
MinimizeButton.Parent = MainFrame
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(1, 0)
local function createButton(name, text, posY)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(1, -20, 0, GuiConfig.gui.buttonHeight)
	button.Position = UDim2.new(0, 10, 0, posY)
	button.BackgroundColor3 = GuiConfig.gui.buttonColor
	button.TextColor3 = GuiConfig.gui.textColor
	button.Font = Enum.Font.Gotham
	button.TextSize = 16
	button.Text = text
	button.AutoButtonColor = false
	button.ZIndex = 2
	button.Parent = MainFrame
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 100, 100)
	stroke.Thickness = 1
	stroke.Parent = button
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = GuiConfig.gui.buttonHoverColor
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = GuiConfig.gui.buttonColor
	end)
	return button
end

local GrabGunButton = createButton("GrabGunButton", "Grab Gun", 40)
GrabGunButton.MouseButton1Click:Connect(function()
	GrabGun()
end)

local FakeDeathButton = createButton("FakeDeathButton", "Fake Death: OFF", 90)
FakeDeathButton.MouseButton1Click:Connect(function()
	fakeDead = not fakeDead
	FakeDeathButton.Text = "Fake Death: " .. (fakeDead and "ON" or "OFF")
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	if fakeDead then
		for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
			track:Stop()
            humanoid.Health = 1
		end
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.Velocity = hrp.CFrame.LookVector * 30 + Vector3.new(0, -10, 0)
		end
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
			if part:IsA("BasePart") and part.Name == "Torso" and part ~= character:FindFirstChild("Torso") and not character:FindFirstChild("UpperTorso") then
				part:Destroy()
			end
		end
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
	else
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 50
	end
end)

local minimized = false
local originalHeight = 230
MinimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in MainFrame:GetChildren() do
		if child:IsA("GuiObject") and child ~= TitleLabel and child ~= MinimizeButton then
			child.Visible = not minimized
		end
	end
	local targetSize = UDim2.new(0, 220, 0, minimized and GuiConfig.gui.titleHeight + 10 or originalHeight)
	TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

local dragging, dragStart, startPos
TitleLabel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

TitleLabel.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end
end)