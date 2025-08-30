local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local slapbattles = 6403373529
local slapbattles2 = 124596094333302
local slapbattles3 = 9015014224
local slapbattlesks = 11520107397
local evilbarzil = 80420091630966
local slaproyale = 9431156611
local slaproyalewaiting = 9426795465
local eternalbob = 13833961666

local currentPlaceId = game.PlaceId

local function notify(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration or 3
		})
	end)
end

if currentPlaceId == slapbattles or currentPlaceId == slapbattles2 or currentPlaceId == slapbattles3 then

local ui = loadstring(game:HttpGet("https://pastebin.com/raw/PQBu5K3w"))()

local win = ui:Create({
    Name = "Celeron's GUI (Slap Battles)",
    ThemeColor = Color3.fromRGB(14, 14, 14),
    StartupSound = "rbxassetid://6958727243",
    ThemeFont = Enum.Font.FredokaOne
})

local maintab = win:Tab("Main")
local antitab = win:Tab("Protection")
local exptab = win:Tab("Exploits")
local farmtab = win:Tab("Farms")
local teletab = win:Tab("Map")
local funtab = win:Tab("Fun")
local modetab = win:Tab("Modes")
local misctab = win:Tab("Others")
local helptab = win:Tab("Info")

maintab:Label("Script Made By Celeron + Daffy!")
exptab:Label("This Section Contains Useful / Game-Breaking Scripts.")
antitab:Label("Protection Settings May Be Blatant.")
helptab:Label("GUI Controls Are Below, Script Credits Are At The Bottom!")
helptab:Label("Show / Hide GUI: Right Alt")

misctab:Button("Infinite Yield", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

misctab:Button("Nameless Admin", function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
end)

misctab:Button("Rejoin Server", function()
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local jobId = game.JobId
local player = Players.LocalPlayer or Players:GetPlayers()[1]

if typeof(placeId) == "number" and typeof(jobId) == "string" and player then
    print("Rejoining current server...")
    print("PlaceId:", placeId)
    print("JobId:", jobId)
    TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
else
    print("Failed to get current server info or player.")
end
end)

misctab:Button("Switch Servers", function()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local currentJobId = game.JobId
local player = Players.LocalPlayer or Players:GetPlayers()[1]

local function findDifferentServer()
    local cursor = nil

    while true do
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local success, response = pcall(function()
            return http_request({
                Url = url,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0"
                }
            })
        end)

        if not success or not response or not response.Body then
            print("Request failed. Retrying...")
            task.wait(2)
            continue
        end

        if string.find(response.Body, "Too many requests") then
            print("Rate limited. Waiting...")
            task.wait(3)
            continue
        end

        local successDecode, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not successDecode or not data or not data.data then
            print("Failed to decode. Retrying...")
            task.wait(2)
            continue
        end

        for _, server in pairs(data.data) do
            if server.id ~= currentJobId and server.playing < server.maxPlayers then
                print("Found different server:", server.id)
                return server.id
            end
        end

        cursor = data.nextPageCursor
        task.wait(1)

        if not cursor then break end
    end

    return nil
end

local newJobId = findDifferentServer()
if newJobId and player then
    print("Teleporting to different server...")
    TeleportService:TeleportToPlaceInstance(placeId, newJobId, player)
else
    print("No different server found or player missing.")
end
end)

misctab:Button("Join Small Server (MAY GET RATE LIMITED!)", function()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

_G.extracted1 = game.PlaceId
_G.extracted2 = nil

local userAgents = {
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    "Mozilla/5.0 (X11; Linux x86_64)",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)",
    "Mozilla/5.0 (Android 11; Mobile; rv:89.0)",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0)",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/109.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/605.1.15 (KHTML, like Gecko)",
    "Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko)",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/114.0.0.0 Safari/537.36"
}

local function fetchSmartServer()
    local cursor = nil
    local smallestServer = nil
    local minPlayers = math.huge
    local retryCount = 0

    while true do
        local baseUrl = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", _G.extracted1)
        local url = baseUrl
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local headers = {
            ["User-Agent"] = userAgents[math.random(1, #userAgents)],
            ["X-Requested-With"] = "XMLHttpRequest"
        }

        local success, response = pcall(function()
            return http_request({
                Url = url,
                Method = "GET",
                Headers = headers
            })
        end)

        if not success or not response or not response.Body then
            print("Request failed. Retrying...")
            retryCount += 1
            task.wait(math.random(2, 4) + retryCount)
            continue
        end

        if string.find(response.Body, "Too many requests") then
            print("Rate limited. Backing off...")
            retryCount += 1
            task.wait(math.random(3, 6) + retryCount)
            continue
        end

        local successDecode, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not successDecode or not data or not data.data then
            print("Failed to decode server data. Retrying...")
            retryCount += 1
            task.wait(math.random(2, 5) + retryCount)
            continue
        end

        retryCount = 0

        for _, server in pairs(data.data) do
            print("Checking server:", server.id, "Players:", server.playing, "/", server.maxPlayers)

            if server.playing >= 1 and server.playing <= 2 and server.playing < server.maxPlayers then
                print("Found ideal server with 1–2 players. Joining now.")
                return server
            end

            if server.playing < minPlayers and server.playing < server.maxPlayers then
                minPlayers = server.playing
                smallestServer = server
            end
        end

        cursor = data.nextPageCursor
        task.wait(math.random(1, 2))

        if not cursor then break end
    end

    return smallestServer
end

local server = fetchSmartServer()
if server then
    _G.extracted2 = server.id
    print("Extracted PlaceId:", _G.extracted1)
    print("Extracted JobId:", _G.extracted2)

    local player = Players.LocalPlayer or Players:GetPlayers()[1]

    if typeof(_G.extracted1) == "number" and typeof(_G.extracted2) == "string" and player then
        print("Teleporting to server...")
        TeleportService:TeleportToPlaceInstance(_G.extracted1, _G.extracted2, player)
    else
        print("Invalid data or player not found.")
    end
else
    print("No suitable server found.")
end
end)

misctab:Button("Destroy GUI", function()
    win:Exit()
end)


misctab:Button("Leave Game", function()
    game:Shutdown()
end)

modetab:Label("These Places Can Be Joined Instantly!")

local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer

local function teleportTo(placeId)
    TeleportService:Teleport(placeId, LocalPlayer)
end

modetab:Button("Main Game", function()
    teleportTo(6403373529)
end)

modetab:Button("Killstreak Only", function()
    teleportTo(11520107397)
end)

modetab:Button("No One Shot Gloves", function()
    teleportTo(9015014224)
end)

modetab:Button("Slap Royale Matchmaking", function()
    teleportTo(9426795465)
end)

modetab:Button("Normal Barzil", function()
    teleportTo(7234087065)
end)

misctab:Button("Slap League (Functional, Needs Another Player.)", function()
    teleportTo(18698003301)
end)

modetab:Button("Tower Of Hell (TOH)", function()
    teleportTo(115782629143468)
end)

modetab:Button("Day in the Life of a Small Game Dev", function()
	queueonteleport([[
    print("ez pz!")

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local function find(parent, name)
        local t, s = 2.5, tick()
        repeat
            local c = parent:FindFirstChild(name)
            if c then return c end
            task.wait(0.1)
        until tick() - s > t
        return nil
    end

    local hrp = find(character, "HumanoidRootPart")
    local trigger = find(find(find(find(workspace, "Buildings"), "wizard twoer 2"), "Model"), "Trigger")

    if hrp and trigger and trigger:FindFirstChild("TouchInterest") then
        firetouchinterest(hrp, trigger, 0)
        firetouchinterest(hrp, trigger, 1)
    end
]])
teleportTo(7234087065)
end)

modetab:Button("Custom Glove Customizer", function()
    teleportTo(9068206286)
end)

modetab:Button("Soft Update Waiting Place", function()
    teleportTo(12712288037)
end)

modetab:Button("?", function()
    teleportTo(12845859004)
end)

modetab:Label("Warning: The Below Places Can't Be Joined Directly.")

modetab:Button("Testing Place", function()
    teleportTo(9020359053)
end)

modetab:Button("Tower Defense", function()
    teleportTo(15228348051)
end)

modetab:Button("Christmas Eve", function()
    teleportTo(15507333474)
end)

modetab:Button("Null Zone", function()
    teleportTo(14422118326)
end)

modetab:Button("Staff Application", function()
    teleportTo(16034567693)
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local lastSliderSet = nil
local humanoidConnection = nil

local function applySpeed(humanoid)
	if not humanoid or not lastSliderSet then return end
	if humanoid.WalkSpeed ~= lastSliderSet then
		humanoid.WalkSpeed = lastSliderSet
	end

	if humanoidConnection then
		humanoidConnection:Disconnect()
	end

	humanoidConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if humanoid.WalkSpeed ~= lastSliderSet then
			humanoid.WalkSpeed = lastSliderSet
		end
	end)
end

maintab:Slider("Player Speed", 19.5, 5, 85, function(v)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	lastSliderSet = (v == 8) and 16 or v
	applySpeed(humanoid)
end)

LocalPlayer.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid"):GetPropertyChangedSignal("Parent"):Connect(function()
		local newHumanoid = character:FindFirstChildOfClass("Humanoid")
		if newHumanoid then
			applySpeed(newHumanoid)
		end
	end)

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		applySpeed(humanoid)
	end
end)

funtab:Label("Some Fun Features I Made.")

funtab:Button("OP Avatar GUI", function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

task.spawn(function()
	while true do
		task.wait(1)
		local land = Workspace:FindFirstChild(LocalPlayer.Name .. "'s avatar_land")
		local generator = land and land:FindFirstChild("Generator")
		local broken = generator and generator:FindFirstChild("broken")
		local prompt = broken and broken:FindFirstChild("prompt")
		if prompt then
			prompt.HoldDuration = 0
		end
	end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AvatarGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 216, 0, 412)
frame.Position = UDim2.new(0.5, -108, 0.5, -206)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local function createLabel(text, positionY, color)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 27)
	label.Position = UDim2.new(0, 0, 0, positionY)
	label.BackgroundTransparency = 1
	label.TextColor3 = color
	label.Font = Enum.Font.Gotham
	label.TextSize = 21
	label.Text = text
	label.TextScaled = false
	label.Parent = frame
	return label
end

local title = createLabel("Avatar GUI", 0, Color3.fromRGB(255, 255, 255))
title.Size = UDim2.new(1, 0, 0, 41)
title.Font = Enum.Font.GothamBold
title.TextSize = 24

local infoBar = createLabel("Loading...", 41, Color3.fromRGB(200, 200, 200))
local statusBar = createLabel("Checking...", 68, Color3.fromRGB(180, 255, 180))
local godModeBar = createLabel("God Mode: Unknown", 95, Color3.fromRGB(255, 200, 200))

local godModeEnabled = nil

local function createButton(name, index, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -24, 0, 34)
	button.Position = UDim2.new(0, 12, 0, 129 + (index - 1) * 38)
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.Gotham
	button.TextSize = 13
	button.Text = name
	button.BorderSizePixel = 0
	button.Parent = frame
	button.MouseButton1Click:Connect(callback)
	return button
end

createButton("God Mode (Use In Hatch)", 1, function()
	godModeEnabled = true
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local land = Workspace:FindFirstChild(LocalPlayer.Name .. "'s avatar_land")
	local hatch = land and land:FindFirstChild("AvatarLand") and land.AvatarLand:FindFirstChild("hatch") and land.AvatarLand.hatch:FindFirstChild("hatch")
	if hatch and hatch:IsA("BasePart") then
		root.CFrame = hatch.CFrame + Vector3.new(0, 5, 0)
	end
end)

createButton("Disable God Mode", 2, function()
	godModeEnabled = false
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local basement = Workspace:FindFirstChild("BasementFolder") and Workspace.BasementFolder:FindFirstChild(LocalPlayer.Name .. "'s Basement")
	local exit = basement and basement:FindFirstChild("Exit")
	if exit and exit:IsA("BasePart") then
	end
end)

createButton("Enter Hatch", 3, function()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local land = Workspace:FindFirstChild(LocalPlayer.Name .. "'s avatar_land")
	local hatch = land and land:FindFirstChild("AvatarLand") and land.AvatarLand:FindFirstChild("hatch") and land.AvatarLand.hatch:FindFirstChild("hatch")
	if hatch and hatch:IsA("BasePart") then
		root.CFrame = hatch.CFrame + Vector3.new(0, 5, 0)
	end
	task.wait(0.3)
	local main = land and land:FindFirstChild("main")
	local prompt = main and main:FindFirstChildOfClass("ProximityPrompt")
	if prompt then
	end
end)

createButton("Enter Hatch (Use If God Mode)", 4, function()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local basement = Workspace:FindFirstChild("BasementFolder") and Workspace.BasementFolder:FindFirstChild(LocalPlayer.Name .. "'s Basement")
	if basement then
		for _, child in ipairs(basement:GetChildren()) do
			if child:IsA("BasePart") then
				root.CFrame = child.CFrame + Vector3.new(0, 5, 0)
				break
			end
		end
	end
end)

createButton("Fix Generator", 5, function()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	local land = Workspace:FindFirstChild(LocalPlayer.Name .. "'s avatar_land")
	local generator = land and land:FindFirstChild("Generator")
	local broken = generator and generator:FindFirstChild("broken")
	local prompt = broken and broken:FindFirstChildOfClass("ProximityPrompt")
	if prompt then
		local originalCFrame = root.CFrame
		root.CFrame = generator.CFrame + Vector3.new(0, -5, 0)
		task.wait(0.25)
		root.CFrame = originalCFrame
	end
end)

local viewingHatch = false
local originalCameraSubject = Camera.CameraSubject
local originalCameraType = Camera.CameraType

local function toggleHatchView()
	local land = Workspace:FindFirstChild(LocalPlayer.Name .. "'s avatar_land")
	local hatch = land and land:FindFirstChild("AvatarLand") and land.AvatarLand:FindFirstChild("hatch") and land.AvatarLand.hatch:FindFirstChild("hatch")
	if not hatch or not hatch:IsA("BasePart") then return end
	if viewingHatch then
		Camera.CameraType = originalCameraType
		Camera.CameraSubject = originalCameraSubject
	else
		Camera.CameraType = Enum.CameraType.Scriptable
		local camPos = hatch.Position + Vector3.new(0, 25, 20)
		Camera.CFrame = CFrame.new(camPos, hatch.Position)
	end
	viewingHatch = not viewingHatch
end

createButton("Toggle View Hatch", 6, toggleHatchView)
createButton("Close GUI", 7, function() screenGui:Destroy() end)

task.spawn(function()
	local function monitorDeathAndExit()
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local root = character:WaitForChild("HumanoidRootPart")

		if humanoid then
			humanoid.Died:Connect(function()
				godModeEnabled = false
			end)
		end

		local basement = Workspace:FindFirstChild("BasementFolder") and Workspace.BasementFolder:FindFirstChild(LocalPlayer.Name .. "'s Basement")
		local exit = basement and basement:FindFirstChild("Exit")
		if exit and exit:IsA("BasePart") then
			exit.Touched:Connect(function(hit)
				if hit == root then
					godModeEnabled = false
				end
			end)
		end
	end

	monitorDeathAndExit()
	LocalPlayer.CharacterAdded:Connect(monitorDeathAndExit)

	while screenGui.Parent do
		local sourceLabel = PlayerGui:FindFirstChild("screen3") and PlayerGui.screen3:FindFirstChild("Bar") and PlayerGui.screen3.Bar:FindFirstChild("TextLabel")
		infoBar.Text = sourceLabel and sourceLabel.Text or "No Basement."

		local genLabel = Workspace:FindFirstChild("BasementFolder")
			and Workspace.BasementFolder:FindFirstChild(LocalPlayer.Name .. "'s Basement")
			and Workspace.BasementFolder[LocalPlayer.Name .. "'s Basement"]
			and Workspace.BasementFolder[LocalPlayer.Name .. "'s Basement"]:FindFirstChild("gen_status")
			and Workspace.BasementFolder[LocalPlayer.Name .. "'s Basement"].gen_status:FindFirstChild("Screen")
			and Workspace.BasementFolder[LocalPlayer.Name .. "'s Basement"].gen_status.Screen:FindFirstChild("SurfaceGui")
			and Workspace.BasementFolder[LocalPlayer.Name .. "'s Basement"].gen_status.Screen.SurfaceGui:FindFirstChild("TextLabel")

		if genLabel and typeof(genLabel.Text) == "string" then
			local cleaned = string.gsub(genLabel.Text, "Generator", "")
			statusBar.Text = cleaned
		else
			statusBar.Text = "Status: N/A"
		end

		if godModeEnabled == true then
			godModeBar.Text = "God Mode: On"
		elseif godModeEnabled == false then
			godModeBar.Text = "God Mode: Off"
		else
			godModeBar.Text = "God Mode: N/A"
		end

		task.wait(0.2)
	end
end)
end)

funtab:Label("Use Below Features At Your Own Risk, Not Made By Me.")

funtab:Button("FLOWERS Glove (Glove Ability: Crash Server)", function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/Umbrella-Scripter/Slap-Battles/refs/heads/main/F.L.O.W.E.R.lua'))()
end)

maintab:Button("Remove Cooldown", function()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local tool = character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
while character.Humanoid.Health ~= 0 do
local localscript = tool:FindFirstChildOfClass("LocalScript")
local localscriptclone = localscript:Clone()
localscriptclone = localscript:Clone()
localscriptclone:Clone()
localscript:Destroy()
localscriptclone.Parent = tool
wait(0.1)
end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local root = nil
local auraEnabled = false
local cachedRemotes = {}
local KSHitRemote = ReplicatedStorage:FindFirstChild("KSHit")
local auraConnection
local lastFireTime = 0

local function notify(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration or 3
		})
	end)
end

local function updateRoot()
	local character = LocalPlayer.Character
	if character then
		root = character:FindFirstChild("HumanoidRootPart")
	end
end

LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	updateRoot()
end)

if LocalPlayer.Character then
	updateRoot()
end

local function findEquippedGlove()
	local character = LocalPlayer.Character
	if not character then return nil end
	for _, tool in ipairs(character:GetChildren()) do
		if tool:IsA("Tool") then
			return tool
		end
	end
end

local function getClosestPlayer()
	local closest = nil
	local minDist = math.huge
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
			if distance < minDist then
				minDist = distance
				closest = player
			end
		end
	end
	return closest
end

local function findRelevantHitRemotes(gloveName)
	if cachedRemotes[gloveName] then return cachedRemotes[gloveName] end
	local nameLower = string.lower(gloveName or "")
	local hits = {}
	for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
		if obj:IsA("RemoteEvent") then
			local remoteLower = string.lower(obj.Name)
			if remoteLower == nameLower .. "hi" or (remoteLower:find(nameLower) and remoteLower:find("hit")) then
				table.insert(hits, obj)
			end
		end
	end
	cachedRemotes[gloveName] = hits
	return hits
end

maintab:Button("Slap Aura", function()
	auraEnabled = not auraEnabled
	notify("Slap Aura", auraEnabled and "Enabled." or "Disabled.")
	if auraEnabled then
		if auraConnection then
			auraConnection:Disconnect()
			auraConnection = nil
		end
		auraConnection = RunService.Heartbeat:Connect(function()
			local currentTime = os.clock()
			if currentTime - lastFireTime < 0.7 then return end
			lastFireTime = currentTime

			if not root then return end
			local target = getClosestPlayer()
			if not target or not target.Character then return end
			local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
			if not targetRoot then return end

			local glove = findEquippedGlove()
			local remotes = {}

			if glove then
				local foundRemotes = findRelevantHitRemotes(glove.Name)
				if foundRemotes and #foundRemotes > 0 then
					remotes = foundRemotes
				end
			end

			if #remotes == 0 then
				if KSHitRemote then
					table.insert(remotes, KSHitRemote)
				end
				for _, fallback in ipairs({"GeneralHit", "b"}) do
					local remote = ReplicatedStorage:FindFirstChild(fallback)
					if remote then
						table.insert(remotes, remote)
					end
				end
			end

			for _, remote in ipairs(remotes) do
				remote:FireServer(targetRoot)
			end
		end)
	else
		if auraConnection then
			auraConnection:Disconnect()
			auraConnection = nil
		end
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local range = 15
local cooldown = 1.450
local lastClick = 0
local enabled = false

local function emulateClick()
	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
end

RunService.RenderStepped:Connect(function()
	if not enabled then return end

	local now = tick()
	if now - lastClick < cooldown then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local targetHRP = player.Character.HumanoidRootPart
			local dist = (HumanoidRootPart.Position - targetHRP.Position).Magnitude

			if dist <= range then
				emulateClick()
				lastClick = now
				break
			end
		end
	end
end)

maintab:Button("Glove Triggerbot", function()
    enabled = not enabled

    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCore("SendNotification", {
        Title = "Glove Triggerbot",
        Text = enabled and "Enabled." or "Disabled.",
        Duration = 2
    })
end)

maintab:Button("Spam Quake (Equip Quake)", function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("QuakeQuake")

for i = 1, 250 do
    remote:FireServer({ start = true })
    remote:FireServer({ finished = true })
    task.wait() 
end
end)

maintab:Button("Bind Rhythm (Binds To E, Equip Rhythm.)", function()
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:WaitForChild("rhythmevent")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        local args = {
            [1] = "AoeExplosion",
            [2] = 90
        }
        remote:FireServer(unpack(args))
    end
end)
end)

maintab:Button("Bind Kinetic (Binds To R, Equip Kinetic.)", function()
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.R then
        local player = Players.LocalPlayer
        local glove = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Glove")

        if glove and glove.Value == "Kinetic" then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local OGL = character.HumanoidRootPart.CFrame
                for i = 1, 100 do
                    ReplicatedStorage.SelfKnockback:FireServer({
                        ["Force"] = 0,
                        ["Direction"] = Vector3.new(0, 0.01, 0)
                    })
                    task.wait(0.05)
                end
            end
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Wrong Glove",
                Text = "Equip Kinetic Glove.",
                Duration = 10
            })
        end
    end
end)
end)

maintab:Button("Kick Leashed Player (Req. Leash + Swapper)", function()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

pcall(function()
	local brazil = Workspace.Lobby.brazil
	if brazil then
		brazil:Destroy()
	end
end)

local localPlayer = Players.LocalPlayer
local slocEvent = ReplicatedStorage:WaitForChild("SLOC")

local CLICK_TARGET = Workspace:WaitForChild("Lobby"):WaitForChild("Swapper")
local TELEPORT_PAD = Workspace:WaitForChild("Lobby"):WaitForChild("Teleport1")

local TWEEN_POSITION = Vector3.new(-441, 133, -21)
local TARGET_POSITION = Vector3.new(-439, 66, -14)

local function moveToPosition(hrp, targetPos, duration)
	local startPos = hrp.Position
	local startTime = tick()
	local endTime = startTime + duration

	while tick() < endTime do
		local alpha = math.clamp((tick() - startTime) / duration, 0, 1)
		local newPos = startPos:Lerp(targetPos, alpha)
		hrp.CFrame = CFrame.new(newPos)
		task.wait(0.03)
	end

	hrp.CFrame = CFrame.new(targetPos)
	hrp.Velocity = Vector3.zero
end

local function fireClickDetector(part)
	local clickDetector = part:FindFirstChildOfClass("ClickDetector")
	if clickDetector then
		fireclickdetector(clickDetector)
	end
end

local function walkInto(part)
	local character = localPlayer.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local goalPos = part.Position + Vector3.new(0, 3, 0)
	hrp.CFrame = CFrame.new(goalPos)

	while (hrp.Position - part.Position).Magnitude > 5 do
		task.wait(0.05)
	end
end

local function onRespawn(character)
	local hrp = character:WaitForChild("HumanoidRootPart")

	fireClickDetector(CLICK_TARGET)
	walkInto(TELEPORT_PAD)
	task.wait(0.5)
	hrp.CFrame = CFrame.new(TARGET_POSITION)
	task.wait(0.3)
	slocEvent:FireServer()
    wait(1)

    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")

    local placeId = game.PlaceId
    local jobId = game.JobId
    local player = Players.LocalPlayer or Players:GetPlayers()[1]

    if typeof(placeId) == "number" and typeof(jobId) == "string" and player then
        print("PlaceId:", placeId)
        print("JobId:", jobId)
        TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
end
end

local function startSequence()
	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	moveToPosition(hrp, TWEEN_POSITION, 3.5)

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Health = 0
	end
end

    localPlayer.CharacterAdded:Connect(onRespawn)
    startSequence()
end)

maintab:Button("Auto-Click Tycoon (MUST BE NEAR)", function()
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

local function getClickPart()
    local player = Players.LocalPlayer
    local helper = Workspace:FindFirstChild("ÅTycoon" .. player.Name)
    if helper then
        return helper:FindFirstChild("Click")
    end
    return nil
end

local function simulateClick(part)
    local screenPoint = Camera:WorldToViewportPoint(part.Position)
    VirtualInputManager:SendMouseButtonEvent(screenPoint.X, screenPoint.Y, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(screenPoint.X, screenPoint.Y, 0, false, game, 0)
end

local connection
connection = RunService.RenderStepped:Connect(function()
    local clickPart = getClickPart()
    if not clickPart then
        connection:Disconnect()
        return
    end

    simulateClick(clickPart)
end)
end)

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local playerName = LocalPlayer.Name

local root = nil
local slappedValue = nil
local ragdolledValue = Instance.new("BoolValue")
ragdolledValue.Name = "Ragdolled"
ragdolledValue.Value = false
ragdolledValue.Parent = LocalPlayer

local antiFlingEnabled = false

local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title;
			Text = text;
			Duration = 3,
		})
	end)
end

local function freezePlayer(source)
	if not antiFlingEnabled or not root then return end

	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	root.Anchored = true

	task.delay(2, function()
		if root then
			root.Anchored = false
		end
	end)
end

RunService.Heartbeat:Connect(function()
	if antiFlingEnabled and ragdolledValue and ragdolledValue.Value == true then
		freezePlayer("Ragdolled")
	end
end)

local function setupCharacter(character)
	root = character:WaitForChild("HumanoidRootPart")

	local localFolder = Workspace:FindFirstChild(playerName)
	if localFolder then
		slappedValue = localFolder:FindFirstChild("LastSlappedBy")
		ragdolledValue = localFolder:FindFirstChild("Ragdolled") or ragdolledValue
	end

	if slappedValue then
		slappedValue.Changed:Connect(function(newValue)
			if antiFlingEnabled and newValue and newValue ~= "" then
				freezePlayer("Slapped")
			end
		end)
	end
end

if LocalPlayer.Character then
	setupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)

antitab:Button("Anti-Knockback", function()
	antiFlingEnabled = not antiFlingEnabled
	local status = antiFlingEnabled and "Enabled." or "Disabled."
	notify("Anti-Knockback", status)
end)

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local dangerousTools = {
    ["Error"] = true,
    ["OVERKILL"] = true,
    ["The Flex"] = true,
    ["rob"] = true,
    ["Leash"] = true
}

local function hasDangerousTool(player)
    local backpack = player:FindFirstChildOfClass("Backpack")
    local character = player.Character
    if not backpack and not character then return false end

    for _, tool in ipairs(backpack:GetChildren()) do
        if dangerousTools[tool.Name] then return true end
    end
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") and dangerousTools[tool.Name] then return true end
        end
    end
    return false
end

local antiOneShotEnabled = false
local connection
antitab:Button("Anti-OneShot", function()
    antiOneShotEnabled = not antiOneShotEnabled

    StarterGui:SetCore("SendNotification", {
        Title = "Anti-OneShot",
        Text = antiOneShotEnabled and "Enabled." or "Disabled.",
        Duration = 3
    })

    if antiOneShotEnabled then
        connection = RunService.RenderStepped:Connect(function()
            local myCharacter = LocalPlayer.Character
            if not myCharacter then return end

            local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and hasDangerousTool(player) then
                    local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if theirRoot then
                        local offset = myRoot.Position - theirRoot.Position
                        local distance = offset.Magnitude
                        local minDistance = 22

                        if distance < minDistance then
                            local repelDir = offset.Unit
                            local targetPosition = theirRoot.Position + repelDir * minDistance
                            local upwardBias = Vector3.new(0, 0.5, 0)
                            local correctedPosition = targetPosition + upwardBias

                            myRoot.CFrame = CFrame.new(correctedPosition)
                            break
                        end
                    end
                end
            end
        end)
    elseif connection then
        connection:Disconnect()
        connection = nil
    end
end)

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local sbeveShieldEnabled = false
local sbeveDetectionRadius = 15
local sbevePushDistance = 22
local sbeveConnection

antitab:Button("Anti-Sbeve", function()
    sbeveShieldEnabled = not sbeveShieldEnabled

    StarterGui:SetCore("SendNotification", {
        Title = "Anti-Sbeve",
        Text = sbeveShieldEnabled and "Enabled." or "Disabled.",
        Duration = 3
    })

    if sbeveShieldEnabled then
        sbeveConnection = RunService.RenderStepped:Connect(function()
            local myCharacter = LocalPlayer.Character
            if not myCharacter then return end

            local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            local closestThreat = nil
            local closestDistance = math.huge

            for _, model in ipairs(Workspace:GetChildren()) do
                if model:IsA("Model") and model ~= myCharacter then
                    local stevebody = model:FindFirstChild("stevebody")
                    if stevebody and stevebody:IsA("BasePart") then
                        local distance = (stevebody.Position - myRoot.Position).Magnitude
                        if distance < sbeveDetectionRadius and distance < closestDistance then
                            closestThreat = stevebody
                            closestDistance = distance
                        end
                    end
                end
            end

            if closestThreat then
                local offset = myRoot.Position - closestThreat.Position
                local repelDir = offset.Unit
                local targetPosition = closestThreat.Position + repelDir * sbevePushDistance
                local upwardBias = Vector3.new(0, 0.5, 0)
                local correctedPosition = targetPosition + upwardBias

                -- Smooth movement using Lerp toward safe position
                local currentPosition = myRoot.Position
                local newPosition = currentPosition:Lerp(correctedPosition, 0.1) -- smaller factor = smoother

                myRoot.CFrame = CFrame.new(newPosition)
            end
        end)
    elseif sbeveConnection then
        sbeveConnection:Disconnect()
        sbeveConnection = nil
    end
end)

local running = false
antitab:Button("Anti-MegaRock", function()
    running = not running
    getgenv().antimegarocksb = running

    StarterGui:SetCore("SendNotification", {
        Title = "Anti-MegaRock",
        Text = running and "Enabled." or "Disabled.",
        Duration = 3
    })

    if running then
        task.spawn(function()
            while getgenv().antimegarocksb do
                for _, player in ipairs(game.Players:GetPlayers()) do
                    local char = player.Character
                    if char then
                        local rock = char:FindFirstChild("rock")
                        if rock then
                            rock.CanTouch = false
                            rock.CanQuery = false
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

exptab:Button("Get All Badge Gloves (INSTANT)", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/IncognitoScripts/SlapBattles/refs/heads/main/InstantGloves"))()
end)

antitab:Button("Anti-Void (Teleport Method, Rejoin To Disable.)", function()
local lp = game.Players.LocalPlayer
local lastGroundedPos = nil

local baseplate = Instance.new("Part")
baseplate.Size = Vector3.new(99999, 1, 99999)
baseplate.Position = Vector3.new(-30, -30, -30)
baseplate.Anchored = true
baseplate.CanCollide = true
baseplate.Transparency = 0.9
baseplate.Name = "VoidProtection"
baseplate.Parent = workspace

game:GetService("RunService").Heartbeat:Connect(function()
    local char = lp.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local rayOrigin = hrp.Position
    local rayDirection = Vector3.new(0, -50, 0)

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char, baseplate}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.IgnoreWater = true

    local result = workspace:Raycast(rayOrigin, rayDirection, params)

    if result and result.Instance and result.Instance.CanCollide then
        lastGroundedPos = hrp.Position
    elseif hrp.Position.Y < -24 and lastGroundedPos then
        hrp.CFrame = CFrame.new(lastGroundedPos + Vector3.new(0, 5, 0))
    end
end)

baseplate.Touched:Connect(function(hit)
    local char = lp.Character
    if not char then return end
    if hit:IsDescendantOf(char) and lastGroundedPos then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(lastGroundedPos + Vector3.new(0, 5, 0))
        end
    end
end)
end)

antitab:Button("Anti-Void (Baseplate Method)", function()
local Workspace = game:GetService("Workspace")

local baseplate = Instance.new("Part")
baseplate.Name = "VoidProtection"
baseplate.Size = Vector3.new(25000, 1, 25000)
baseplate.Position = Vector3.new(15, -10, 6)
baseplate.Anchored = true
baseplate.Material = Enum.Material.Grass
baseplate.Transparency = 0.75
baseplate.Color = Color3.fromRGB(0, 255, 45)
baseplate.CastShadow = false 
baseplate.Parent = workspace
end)

antitab:Button("Remove Anti-Void", function()
local function removeVoidProtections(parent)
	for _, obj in ipairs(parent:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "VoidProtection" then
			obj:Destroy()
		end
	end
end

removeVoidProtections(game)
end)

teletab:Button("Main Island", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3, -5, 16)
end)

teletab:Button("Moyai Island", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(229, -16, -12)
end)

teletab:Button("Slapple Island", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-381, 51, -12)
end)

teletab:Button("Castle", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(250, 34, 189)
end)

teletab:Button("The Plate", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Arena.Plate.CFrame
end)

teletab:Button("Retro Obby", function()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local mapPath = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Retro"):WaitForChild("Map"):WaitForChild("RetroObbyMap")
local mapName = "RetroObbyMap"

local existingMap = Workspace:FindFirstChild(mapName)
if not existingMap then
    local clonedMap = mapPath:Clone()
    clonedMap.Parent = Workspace
    existingMap = clonedMap
end

local targetPosition = CFrame.new(-16873, -1, 4775)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

hrp.CFrame = targetPosition
end)

teletab:Button("Baseplate", function()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local baseplateName = "_TargetBaseplate"
local targetPosition = Vector3.new(5000, 228, 5000)
local baseplateSize = Vector3.new(512, 20, 512)

local function ensureBaseplate()
	local existing = Workspace:FindFirstChild(baseplateName)
	if not existing then
		local part = Instance.new("Part")
		part.Name = baseplateName
		part.Size = baseplateSize
		part.Position = targetPosition
		part.Anchored = true
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		part.Material = Enum.Material.SmoothPlastic
		part.Color = Color3.fromRGB(163, 162, 165)
		part.Parent = Workspace
	end
end

local function teleportToBaseplate()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	root.CFrame = CFrame.new(targetPosition + Vector3.new(0, baseplateSize.Y / 2 + 5, 0))
end

ensureBaseplate()
teleportToBaseplate()
end)

farmtab:Label("Slap Farming: Recommended To Teleport To Baseplate.")

farmtab:Button("Slap Farm Info", function()
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Slap Farm";
	Text = "Dual: 5K/hour\nDual + 2X: 11K/hour\nDual + 2X + VIP: 22K/hour";
	Duration = 10;
})
end)

farmtab:Textbox("Slap Farm (Set Username To Alt.)", function(v)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local GeneralRemote = ReplicatedStorage:WaitForChild("GeneralHit")

local targetPosition = Vector3.new(6500, 760, 4785)
local root = nil

local function updateRoot()
	local character = LocalPlayer.Character
	if character then
		root = character:FindFirstChild("HumanoidRootPart")
	end
end

LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	updateRoot()
end)

if LocalPlayer.Character then
	updateRoot()
end

local function getClosestPlayer()
	local closest = nil
	local minDist = math.huge

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude
			if distance < minDist then
				minDist = distance
				closest = player
			end
		end
	end

	return closest
end

RunService.Heartbeat:Connect(function()
	if root then
		root.CFrame = CFrame.new(targetPosition)
	end
end)

task.spawn(function()
	while true do
		if root then
			local target = getClosestPlayer()
			if target and target.Character then
				GeneralRemote:FireServer(target.Character:FindFirstChild("HumanoidRootPart"))
			end
		end
		task.wait(1.25)
	end
end)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local character = nil
local root = nil
local floating = false
local targetName = nil

local function floatEffect()
	if root then
		root.Anchored = false
		root.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
		root.AssemblyLinearVelocity = Vector3.zero
	end
end

local function teleportInFront()
	if not floating or not targetName then return end

	local targetPlayer = Players:FindFirstChild(targetName)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local targetRoot = targetPlayer.Character.HumanoidRootPart
		local offset = targetRoot.CFrame.LookVector.Unit * 4
		local newPos = targetRoot.Position + offset + Vector3.new(0, 2, 0)
		root.CFrame = CFrame.new(newPos, targetRoot.Position)
		floatEffect()
	end
end

RunService.Heartbeat:Connect(function()
	if floating then
		teleportInFront()
	end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	character = char
	root = character:WaitForChild("HumanoidRootPart")
end)

if LocalPlayer.Character then
	character = LocalPlayer.Character
	root = character:WaitForChild("HumanoidRootPart")
end

farmtab:Textbox("Slap Farm (Set Username To Main.)", function(v)
	targetName = v
	floating = true
end)

farmtab:Label("Kill Farm: Recommended To Teleport Main To Baseplate.")

farmtab:Textbox("Kill Farm (Set Username To Main.)", function(v)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local function onCharacterSpawn(character)
	local rootPart = character:WaitForChild("HumanoidRootPart")

	local teleportPart = Workspace:WaitForChild("Lobby"):WaitForChild("Teleport1")
	rootPart.CFrame = teleportPart.CFrame + Vector3.new(0, 1, 0)
	firetouchinterest(rootPart, teleportPart, 0)
	task.wait(0.1)
	firetouchinterest(rootPart, teleportPart, 1)

	task.wait(0.7)

	local target = Players:FindFirstChild(v)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local targetRoot = target.Character.HumanoidRootPart
		local offset = targetRoot.CFrame.LookVector.Unit * 5
		local destination = targetRoot.Position + offset + Vector3.new(0, 1, 0)

		for i = 1, 25 do
			rootPart.CFrame = CFrame.new(destination, targetRoot.Position)
			task.wait(0.05)
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Health = 0
	end
end

LocalPlayer.CharacterAdded:Connect(onCharacterSpawn)

if LocalPlayer.Character then
	onCharacterSpawn(LocalPlayer.Character)
end
end)

farmtab:Label("Rob Farm: Silent, No Recommendations.")

farmtab:Button("Rob Absorb Farm (Use On Main, Rejoin To Disable.)", function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local targetPosition = Vector3.new(5000, 241, 4999)
local remote = ReplicatedStorage:WaitForChild("rob")
local args = { false }

task.spawn(function()
    while true do
        remote:FireServer(unpack(args))
        task.wait(3)
    end
end)

RunService.Heartbeat:Connect(function()
    local character = player.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.zero
            root.CFrame = CFrame.new(targetPosition)
        end
    end
end)
end)

farmtab:Textbox("Rob Absorb Farm (Set Username To Main, Semi-Blatant.)", function(v)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local function onCharacterSpawn(character)
	local rootPart = character:WaitForChild("HumanoidRootPart")

	local teleportPart = Workspace:WaitForChild("Lobby"):WaitForChild("Teleport1")
	rootPart.CFrame = teleportPart.CFrame + Vector3.new(0, 1, 0)
	firetouchinterest(rootPart, teleportPart, 0)
	task.wait(0.1)
	firetouchinterest(rootPart, teleportPart, 1)

	task.wait(0.7)

	local target = Players:FindFirstChild(v)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local targetRoot = target.Character.HumanoidRootPart
		local offset = targetRoot.CFrame.LookVector.Unit * 5
		local destination = targetRoot.Position + offset + Vector3.new(0, 1, 0)

		for i = 1, 25 do
			rootPart.CFrame = CFrame.new(destination, targetRoot.Position)
			task.wait(0.05)
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Health = 0
	end
end

LocalPlayer.CharacterAdded:Connect(onCharacterSpawn)

if LocalPlayer.Character then
	onCharacterSpawn(LocalPlayer.Character)
end
end)

farmtab:Label("Moyai Farm: Recommended To Join Small Servers.")

farmtab:Button("Moyai Farm Quest #1 (Use On Main, Rejoin To Disable.)", function()
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local targetPosition = Vector3.new(280.659210, 21.155642, 240.360291)
local lookDirection = Vector3.new(0.989398, 0.000000, -0.145231)
local targetCFrame = CFrame.new(targetPosition, targetPosition + lookDirection)

root.CFrame = targetCFrame

task.wait(0.15)
VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
task.wait(0.05)
VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
task.wait(0.2)
VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
task.wait(0.05)
VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local targetPosition = Vector3.new(272.066437, 13.453131, 245.083008)
local lookDirection = Vector3.new(0.185743, -0.000000, -0.982598)
local targetCFrame = CFrame.new(targetPosition, targetPosition + lookDirection)

root.CFrame = targetCFrame

local VirtualInputManager = game:GetService("VirtualInputManager")

while true do
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    task.wait(2.3)
end
end)

farmtab:Button("Moyai Farm Quest #1 (Use On Alt.)", function()
while true do game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(273, 14, 241) task.wait(0.05) end
end)

farmtab:Label("Brick Farm: Silent, No Recommendations.")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage:WaitForChild("lbrick")
local StarterGui = game:GetService("StarterGui")

local brickloop = false
local interval = 0.1
local loopThread

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3
        })
    end)
end

farmtab:Button("Spam Brick (Use On Main, For Use With Multi-Farm.)", function()
    brickloop = not brickloop

    if brickloop and not loopThread then
        notify("Brick Spam", "Enabled.")
        loopThread = coroutine.create(function()
            while brickloop do
                pcall(function()
                    Remote:FireServer()
                end)
                task.wait(interval)
            end
            loopThread = nil
        end)
        coroutine.resume(loopThread)
    else
        notify("Brick Spam", "Disabled.")
    end
end)

farmtab:Button("Brick Multi-Farm (Use On Main.)", function(v)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local targetPosition = Vector3.new(5000, 228, 5000)

RunService.Heartbeat:Connect(function()
    local character = player.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(targetPosition)
        end
    end
end)

local VirtualInputManager = game:GetService("VirtualInputManager")

while true do
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.075)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    task.wait(0.075)
end
end)

farmtab:Button("Brick Multi-Farm (Use On Alt.)", function(v)
local Workspace = game:GetService("Workspace")

local baseplate = Instance.new("Part")
baseplate.Size = Vector3.new(100, 1, 100)
baseplate.Position = Vector3.new(5002, 209, 4996)
baseplate.Anchored = true
baseplate.Name = "tpbaseplate"
baseplate.Parent = Workspace

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local targetPosition = Vector3.new(5002, 214, 4996)

RunService.Heartbeat:Connect(function()
    local character = player.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(targetPosition)
        end
    end
end)
end)

farmtab:Label("Glovel Farm: Recommended To Join Small Servers.")

farmtab:Button("Glovel Instant Quest #1 (Use On Main.)", function()
local GlovelFunc = game:GetService("ReplicatedStorage"):WaitForChild("GlovelFunc")
local RunService = game:GetService("RunService")

local startTime = os.clock()
local duration = 3
local connections = {}

for i = 1, 10 do
    task.spawn(function()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if os.clock() - startTime > duration then
                conn:Disconnect()
                return
            end
            GlovelFunc:InvokeServer()
        end)
        table.insert(connections, conn)
    end)
end
end)

helptab:Button("Copy Owner Discord Username", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Username",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("ghostofcelleron")
end)

helptab:Button("Copy Discord Server Invite", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Invite",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("https://discord.gg/8stFYxJv4R")
end)

elseif currentPlaceId == evilbarzil then

local ui = loadstring(game:HttpGet("https://pastebin.com/raw/PQBu5K3w"))()

local win = ui:Create({
    Name = "Celeron's GUI (SB: Evil Barzil)",
    ThemeColor = Color3.fromRGB(14, 14, 14),
    StartupSound = "rbxassetid://6958727243",
    ThemeFont = Enum.Font.FredokaOne
})

local maintab = win:Tab("Main")
local steptab = win:Tab("Steps")
local tooltab = win:Tab("Tools")
local modetab = win:Tab("Modes")
local misctab = win:Tab("Others")
local helptab = win:Tab("Info")

maintab:Label("Script Made By Celeron + Daffy!")
steptab:Label("Click The Steps In Order!")
helptab:Label("GUI Controls Are Below, Script Credits Are At The Bottom!")
helptab:Label("Show / Hide GUI: Right Alt")
modetab:Label("These Places Can Be Joined Instantly!")

local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer

local function teleportTo(placeId)
    TeleportService:Teleport(placeId, LocalPlayer)
end

modetab:Button("Main Game", function()
    teleportTo(6403373529)
end)

modetab:Button("Killstreak Only", function()
    teleportTo(11520107397)
end)

modetab:Button("No One Shot Gloves", function()
    teleportTo(9015014224)
end)

modetab:Button("Slap Royale Matchmaking", function()
    teleportTo(9426795465)
end)

modetab:Button("Normal Barzil", function()
    teleportTo(7234087065)
end)

modetab:Button("Tower Of Hell (TOH)", function()
    teleportTo(115782629143468)
end)

modetab:Button("Day in the Life of a Small Game Dev", function()
	queueonteleport([[
    print("ez pz!")

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local function find(parent, name)
        local t, s = 2.5, tick()
        repeat
            local c = parent:FindFirstChild(name)
            if c then return c end
            task.wait(0.5)
        until tick() - s > t
        return nil
    end

    local hrp = find(character, "HumanoidRootPart")
    local trigger = find(find(find(find(workspace, "Buildings"), "wizard twoer 2"), "Model"), "Trigger")

    if hrp and trigger and trigger:FindFirstChild("TouchInterest") then
        firetouchinterest(hrp, trigger, 0)
        firetouchinterest(hrp, trigger, 1)
    end
]])
teleportTo(7234087065)
end)

modetab:Button("Custom Glove Customizer", function()
    teleportTo(9068206286)
end)

modetab:Button("Slap League", function()
    teleportTo(18698003301)
end)

modetab:Button("Soft Update Waiting Place", function()
    teleportTo(12712288037)
end)

modetab:Button("?", function()
    teleportTo(12845859004)
end)

modetab:Label("Warning: The Below Places Can't Be Joined Directly.")

modetab:Button("Testing Place", function()
    teleportTo(9020359053)
end)

modetab:Button("Tower Defense", function()
    teleportTo(15228348051)
end)

modetab:Button("Christmas Eve", function()
    teleportTo(15507333474)
end)

modetab:Button("Null Zone", function()
    teleportTo(14422118326)
end)

steptab:Button("Grab Key", function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local function hasLocalScript(tool)
    for _, child in ipairs(tool:GetDescendants()) do
        if child:IsA("LocalScript") then
            return true
        end
    end
    return false
end

local targetTool = nil
for _, obj in ipairs(Workspace:GetDescendants()) do
    if obj:IsA("Tool") and obj.Name == "Key" and hasLocalScript(obj) then
        targetTool = obj
        break
    end
end

if not targetTool then return end

local targetPart = targetTool:FindFirstChild("Handle")
if not targetPart then
    for _, child in ipairs(targetTool:GetChildren()) do
        if child:IsA("BasePart") then
            targetPart = child
            break
        end
    end
end

if not targetPart then return end

HRP.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
end)

steptab:Button("Unlock Fence", function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local target = Workspace:WaitForChild("GateMechanism"):WaitForChild("Touchpad")
HRP.CFrame = target.CFrame + Vector3.new(0, 3, 0)
end)

steptab:Button("Skip Obby", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(530, 35, -5)
end)

steptab:Button("Skip Fire", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(844, 58, -78)
end)

steptab:Button("Enter Tower", function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
Character:WaitForChild("HumanoidRootPart")

local targetPart = Workspace:WaitForChild("TheOutside"):WaitForChild("TowerENT1"):WaitForChild("finish_zone")

Character:SetPrimaryPartCFrame(targetPart.CFrame + Vector3.new(0, 3, 0))
end)

steptab:Button("Skip Tower Steps (Get First Item In Tools!)", function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Backpack = LocalPlayer:WaitForChild("Backpack")

local screwdriver = Backpack:FindFirstChild("Screwdriver") or Character:FindFirstChild("Screwdriver")
if screwdriver and screwdriver:IsA("Tool") then
    Character:WaitForChild("Humanoid"):EquipTool(screwdriver)
end

Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2202, 73, 41)

local target = Workspace:WaitForChild("Clickable"):WaitForChild("boltClick")
local screenPos = Camera:WorldToScreenPoint(target.Position)

VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
wait(0.5)
Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2203, 61, 40)
end)

steptab:Button("Break Window (Get Second Item In Tools)", function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local targetPos = Vector3.new(4772, 5321, -351)
local lookAt = Workspace.TheOffice.HallwaySection3.BreakableWindow1.Frame.Position

HRP.CFrame = CFrame.new(targetPos, lookAt)

task.wait(1)

local screenPos = Workspace.CurrentCamera:WorldToScreenPoint(targetPos)
VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
end)

steptab:Button("Enter Boss Fight Area", function()
game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4754, 5549, -306)
end)

tooltab:Button("Screwdriver", function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local screwdriver = Workspace:FindFirstChild("Screwdriver")
if not screwdriver then
    return
end

HRP.CFrame = screwdriver.CFrame + Vector3.new(0, 3, 0)

local prompt = screwdriver:FindFirstChildOfClass("ProximityPrompt")
if prompt then
    fireproximityprompt(prompt)
else
end
end)

tooltab:Button("Large Hammer", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4974, 5321, -194)
fireproximityprompt(workspace.TheOffice.HallwaySection3.LargeHammerBox1["Large Hammer"].ProximityPrompt)
end)

tooltab:Button("Grappling Hook (Optional, If Legit Grinding)", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4975, 5321, -560)
fireproximityprompt(workspace.TheOffice.HallwaySection3:GetChildren()[7].Hook.ProximityPrompt)
end)

maintab:Button("Auto Slap Hand", function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local target = Workspace:WaitForChild("bossStorage"):WaitForChild("leftHand"):WaitForChild("PointerMimic")
local TOUCH_DISTANCE = 20
local CLICK_COOLDOWN = 0.5

local enabled = not _G.autoSlapEnabled
_G.autoSlapEnabled = enabled

StarterGui:SetCore("SendNotification", {
    Title = "Auto Slap Hand",
    Text = enabled and "Enabled." or "Disabled.",
    Duration = 2
})

local function getClosestDistance(modelA, modelB)
    local minDistance = math.huge
    for _, partA in ipairs(modelA:GetDescendants()) do
        if partA:IsA("BasePart") then
            for _, partB in ipairs(modelB:GetDescendants()) do
                if partB:IsA("BasePart") then
                    local dist = (partA.Position - partB.Position).Magnitude
                    if dist < minDistance then
                        minDistance = dist
                    end
                end
            end
        end
    end
    return minDistance
end

if enabled then
    task.spawn(function()
        while _G.autoSlapEnabled do
            local distance = getClosestDistance(Character, target)
            if distance <= TOUCH_DISTANCE then
                local screenPos = Camera:WorldToScreenPoint(target.Position)
                VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
                task.wait(CLICK_COOLDOWN)
            else
                task.wait(0.1)
            end
        end
    end)
end
end)

_G.autoSlapEnabled = disabled

maintab:Button("Closest Nail", function()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local nailFolder = Workspace:WaitForChild("bossStorage"):WaitForChild("nail")
local closestObject = nil
local minDist = math.huge

for _, obj in ipairs(nailFolder:GetChildren()) do
    if obj:IsA("BasePart") then
        local dist = (obj.Position - HRP.Position).Magnitude
        if dist < minDist then
            minDist = dist
            closestObject = obj
        end
    end
end

if closestObject then
    HRP.CFrame = CFrame.new(closestObject.Position)
end
end)

misctab:Button("Infinite Yield", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

misctab:Button("Nameless Admin", function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
end)

misctab:Button("Rejoin Server", function()
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local jobId = game.JobId
local player = Players.LocalPlayer or Players:GetPlayers()[1]

if typeof(placeId) == "number" and typeof(jobId) == "string" and player then
    print("Rejoining current server...")
    print("PlaceId:", placeId)
    print("JobId:", jobId)
    TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
else
    print("Failed to get current server info or player.")
end
end)

misctab:Button("Switch Servers", function()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local currentJobId = game.JobId
local player = Players.LocalPlayer or Players:GetPlayers()[1]

local function findDifferentServer()
    local cursor = nil

    while true do
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local success, response = pcall(function()
            return http_request({
                Url = url,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0"
                }
            })
        end)

        if not success or not response or not response.Body then
            print("Request failed. Retrying...")
            task.wait(2)
            continue
        end

        if string.find(response.Body, "Too many requests") then
            print("Rate limited. Waiting...")
            task.wait(3)
            continue
        end

        local successDecode, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not successDecode or not data or not data.data then
            print("Failed to decode. Retrying...")
            task.wait(2)
            continue
        end

        for _, server in pairs(data.data) do
            if server.id ~= currentJobId and server.playing < server.maxPlayers then
                print("Found different server:", server.id)
                return server.id
            end
        end

        cursor = data.nextPageCursor
        task.wait(1)

        if not cursor then break end
    end

    return nil
end

local newJobId = findDifferentServer()
if newJobId and player then
    print("Teleporting to different server...")
    TeleportService:TeleportToPlaceInstance(placeId, newJobId, player)
else
    print("No different server found or player missing.")
end
end)

misctab:Button("Join Small Server (MAY GET RATE LIMITED!)", function()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

_G.extracted1 = game.PlaceId
_G.extracted2 = nil

local userAgents = {
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    "Mozilla/5.0 (X11; Linux x86_64)",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)",
    "Mozilla/5.0 (Android 11; Mobile; rv:89.0)",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0)",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/109.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/605.1.15 (KHTML, like Gecko)",
    "Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko)",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/114.0.0.0 Safari/537.36"
}

local function fetchSmartServer()
    local cursor = nil
    local smallestServer = nil
    local minPlayers = math.huge
    local retryCount = 0

    while true do
        local baseUrl = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", _G.extracted1)
        local url = baseUrl
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local headers = {
            ["User-Agent"] = userAgents[math.random(1, #userAgents)],
            ["X-Requested-With"] = "XMLHttpRequest"
        }

        local success, response = pcall(function()
            return http_request({
                Url = url,
                Method = "GET",
                Headers = headers
            })
        end)

        if not success or not response or not response.Body then
            print("Request failed. Retrying...")
            retryCount += 1
            task.wait(math.random(2, 4) + retryCount)
            continue
        end

        if string.find(response.Body, "Too many requests") then
            print("Rate limited. Backing off...")
            retryCount += 1
            task.wait(math.random(3, 6) + retryCount)
            continue
        end

        local successDecode, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not successDecode or not data or not data.data then
            print("Failed to decode server data. Retrying...")
            retryCount += 1
            task.wait(math.random(2, 5) + retryCount)
            continue
        end

        retryCount = 0

        for _, server in pairs(data.data) do
            print("Checking server:", server.id, "Players:", server.playing, "/", server.maxPlayers)

            if server.playing >= 1 and server.playing <= 2 and server.playing < server.maxPlayers then
                print("Found ideal server with 1–2 players. Joining now.")
                return server
            end

            if server.playing < minPlayers and server.playing < server.maxPlayers then
                minPlayers = server.playing
                smallestServer = server
            end
        end

        cursor = data.nextPageCursor
        task.wait(math.random(1, 2))

        if not cursor then break end
    end

    return smallestServer
end

local server = fetchSmartServer()
if server then
    _G.extracted2 = server.id
    print("Extracted PlaceId:", _G.extracted1)
    print("Extracted JobId:", _G.extracted2)

    local player = Players.LocalPlayer or Players:GetPlayers()[1]

    if typeof(_G.extracted1) == "number" and typeof(_G.extracted2) == "string" and player then
        print("Teleporting to server...")
        TeleportService:TeleportToPlaceInstance(_G.extracted1, _G.extracted2, player)
    else
        print("Invalid data or player not found.")
    end
else
    print("No suitable server found.")
end
end)

misctab:Button("Destroy GUI", function()
    win:Exit()
end)

misctab:Button("Leave Game", function()
    game:Shutdown()
end)

helptab:Button("Copy Owner Discord Username", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Username",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("ghostofcelleron")
end)

helptab:Button("Copy Discord Server Invite", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Invite",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("https://discord.gg/8stFYxJv4R")
end)

elseif currentPlaceId == slaproyale then

for _, obj in ipairs(game:GetDescendants()) do
	if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
		obj:Destroy()
	end
end

local ui = loadstring(game:HttpGet("https://pastebin.com/raw/PQBu5K3w"))()

local win = ui:Create({
    Name = "Celeron's GUI (Slap Royale)",
    ThemeColor = Color3.fromRGB(14, 14, 14),
    StartupSound = "rbxassetid://6958727243",
    ThemeFont = Enum.Font.FredokaOne
})

local maintab = win:Tab("Main")
local itemtab = win:Tab("Items")
local antitab = win:Tab("Protection")
local modetab = win:Tab("Modes")
local misctab = win:Tab("Others")
local helptab = win:Tab("Info")

maintab:Label("Script Made By Celeron + Daffy!")
helptab:Label("GUI Controls Are Below, Script Credits Are At The Bottom!")
helptab:Label("Show / Hide GUI: Right Alt")
modetab:Label("These Places Can Be Joined Instantly!")

local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer

local function teleportTo(placeId)
    TeleportService:Teleport(placeId, LocalPlayer)
end

modetab:Button("Main Game", function()
    teleportTo(6403373529)
end)

modetab:Button("Killstreak Only", function()
    teleportTo(11520107397)
end)

modetab:Button("No One Shot Gloves", function()
    teleportTo(9015014224)
end)

modetab:Button("Slap Royale Matchmaking", function()
    teleportTo(9426795465)
end)

modetab:Button("Normal Barzil", function()
    teleportTo(7234087065)
end)

modetab:Button("Tower Of Hell (TOH)", function()
    teleportTo(115782629143468)
end)

modetab:Button("Day in the Life of a Small Game Dev", function()
	queueonteleport([[
    print("ez pz!")

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local function find(parent, name)
        local t, s = 2.5, tick()
        repeat
            local c = parent:FindFirstChild(name)
            if c then return c end
            task.wait(0.1)
        until tick() - s > t
        return nil
    end

    local hrp = find(character, "HumanoidRootPart")
    local trigger = find(find(find(find(workspace, "Buildings"), "wizard twoer 2"), "Model"), "Trigger")

    if hrp and trigger and trigger:FindFirstChild("TouchInterest") then
        firetouchinterest(hrp, trigger, 0)
        firetouchinterest(hrp, trigger, 1)
    end
]])
teleportTo(7234087065)
end)

modetab:Button("Custom Glove Customizer", function()
    teleportTo(9068206286)
end)

modetab:Button("Slap League (Functional, Needs Another Player.)", function()
    teleportTo(18698003301)
end)

modetab:Button("Soft Update Waiting Place", function()
    teleportTo(12712288037)
end)

modetab:Button("?", function()
    teleportTo(12845859004)
end)

modetab:Label("Warning: The Below Places Can't Be Joined Directly.")

modetab:Button("Testing Place", function()
    teleportTo(9020359053)
end)

modetab:Button("Tower Defense", function()
    teleportTo(15228348051)
end)

modetab:Button("Christmas Eve", function()
    teleportTo(15507333474)
end)

modetab:Button("Null Zone", function()
    teleportTo(14422118326)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local lastSliderSet = nil
local velocityConn = nil

local function applyVelocityControl(humanoid)
	if not humanoid or not lastSliderSet then return end

	local character = humanoid.Parent
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if velocityConn then
		velocityConn:Disconnect()
	end

	velocityConn = RunService.Heartbeat:Connect(function()
		local moveDirection = humanoid.MoveDirection
		local currentVelocity = hrp.Velocity

		if moveDirection.Magnitude > 0 then
			local horizontalVelocity = moveDirection.Unit * lastSliderSet
			hrp.Velocity = Vector3.new(horizontalVelocity.X, currentVelocity.Y, horizontalVelocity.Z)
		else
			hrp.Velocity = Vector3.new(0, currentVelocity.Y, 0)
		end
	end)
end

maintab:Slider("Velocity Speed", 19.5, 5, 85, function(v)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	lastSliderSet = (v == 8) and 16 or v
	applyVelocityControl(humanoid)
end)

LocalPlayer.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid"):GetPropertyChangedSignal("Parent"):Connect(function()
		local newHumanoid = character:FindFirstChildOfClass("Humanoid")
		if newHumanoid then
			applyVelocityControl(newHumanoid)
		end
	end)

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		applyVelocityControl(humanoid)
	end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local SlapRemote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Slap")

local enabled = false
local heartbeatConn

local function getClosestPlayer(radius)
	local myChar = LocalPlayer.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myRoot then return nil end

	local closest, dist = nil, radius
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local mag = (targetRoot.Position - myRoot.Position).Magnitude
				if mag < dist then
					dist = mag
					closest = player
				end
			end
		end
	end
	return closest
end

maintab:Button("Slap Aura", function()
	enabled = not enabled

	if enabled and not heartbeatConn then
		heartbeatConn = RunService.Heartbeat:Connect(function()
			local targetPlayer = getClosestPlayer(50)
			if targetPlayer and targetPlayer.Character then
				local limb = targetPlayer.Character:FindFirstChild("Right Leg")
					or targetPlayer.Character:FindFirstChild("HumanoidRootPart")

				if limb then
					SlapRemote:FireServer(limb)
				end
			end
		end)
	elseif not enabled and heartbeatConn then
		heartbeatConn:Disconnect()
		heartbeatConn = nil
	end

	StarterGui:SetCore("SendNotification", {
		Title = "Slap Aura",
		Text = enabled and "Enabled." or "Disabled.",
		Duration = 3
	})
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local range = 15
local cooldown = 0.1
local lastClick = 0
local enabled = false

local function emulateClick()
	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
end

RunService.RenderStepped:Connect(function()
	if not enabled then return end

	local now = tick()
	if now - lastClick < cooldown then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local targetHRP = player.Character.HumanoidRootPart
			local dist = (HumanoidRootPart.Position - targetHRP.Position).Magnitude

			if dist <= range then
				emulateClick()
				lastClick = now
				break
			end
		end
	end
end)

maintab:Button("Glove Triggerbot", function()
    enabled = not enabled

    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCore("SendNotification", {
        Title = "Glove Triggerbot",
        Text = enabled and "Enabled." or "Disabled.",
        Duration = 2
    })
end)

maintab:Button("Highlight Votekick Risks (Darker Color = Risky)", function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local HIGHLIGHT_TAG = "HighSlapHighlight"

local function getHighlightColor(slapCount)
	if slapCount >= 25001 then
		return Color3.fromRGB(128, 0, 128)
	elseif slapCount >= 17501 then
		return Color3.fromRGB(255, 85, 0)
	elseif slapCount >= 10001 then
		return Color3.fromRGB(255, 165, 0)
	elseif slapCount >= 7501 then
		return Color3.fromRGB(255, 255, 0)
	elseif slapCount >= 5000 then
		return Color3.fromRGB(0, 255, 0)
	else
		return nil
	end
end

local function applyHighlight(character, color)
	if not character or not color then return end

	local existing = character:FindFirstChild(HIGHLIGHT_TAG)
	if existing then
		existing.FillColor = color
		existing.OutlineColor = color
		return
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = HIGHLIGHT_TAG
	highlight.FillColor = color
	highlight.OutlineColor = color
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Adornee = character
	highlight.Parent = character
end

local function removeHighlight(character)
	if not character then return end
	local existing = character:FindFirstChild(HIGHLIGHT_TAG)
	if existing then
		existing:Destroy()
	end
end

local function updateHighlights()
	for _, player in ipairs(Players:GetPlayers()) do
		local slaps = player:FindFirstChild("Slaps")
		local character = player.Character

		if slaps and slaps:IsA("IntValue") and character then
			local color = getHighlightColor(slaps.Value)
			if color then
				applyHighlight(character, color)
			else
				removeHighlight(character)
			end
		else
			removeHighlight(character)
		end
	end
end

RunService.Heartbeat:Connect(function()
	updateHighlights()
end)
end)

maintab:Button("Exit Bus", function()
game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("BusJumping"):FireServer()
end)

itemtab:Button("Remove Bunker (Use If Grabbing Items.)", function()
local itemsFolder = workspace:WaitForChild("Items")
local mapOffice = workspace:WaitForChild("Map"):WaitForChild("OriginOffice")

local originParts = {}
for _, descendant in ipairs(mapOffice:GetDescendants()) do
    if descendant:IsA("BasePart") then
        table.insert(originParts, descendant.Position)
    end
end

for _, item in ipairs(itemsFolder:GetChildren()) do
    if item:IsA("Tool") and item:FindFirstChild("Handle") then
        local handle = item.Handle
        for _, originPos in ipairs(originParts) do
            if (handle.Position - originPos).Magnitude <= 20 then
                item:Destroy()
                break
            end
        end
    end
end

mapOffice:Destroy()
end)

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager") or getvirtualinputmanager()
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local itemsFolder = workspace:WaitForChild("Items")

local moveDelay = 0.425
local pauseTime = 0.1

local function matches(name, keyword)
	return string.find(string.lower(name), string.lower(keyword), 1, true)
end

local function moveTo(part)
	local direction = (part.Position - hrp.Position).Unit
	local targetPos = part.Position - direction * 3
	hrp.CFrame = CFrame.new(targetPos)
	task.wait(moveDelay)
end

local function faceTarget(part)
	local lookVector = (part.Position - hrp.Position).Unit
	local yaw = math.atan2(lookVector.X, lookVector.Z)
	hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yaw, 0)
end

local function rotateCameraTo(part)
	camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position)
end

local function sendFKey()
	for _ = 1, 3 do
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
		task.wait(0.05)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
		task.wait(0.05)
	end
end

itemtab:Textbox("Get Item", function(v)
	for _, tool in ipairs(itemsFolder:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Handle") and matches(tool.Name, v) then
			local handle = tool.Handle
			moveTo(handle)
			task.wait(pauseTime)
			faceTarget(handle)
			rotateCameraTo(handle)
			task.wait(pauseTime)
			sendFKey()
		end
	end
end)

itemtab:Button("Grab Strength Items", function()
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager") or getvirtualinputmanager()
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local itemsFolder = workspace:WaitForChild("Items")

local moveDelay = 0.425
local pauseTime = 0.1

local priorityOrder = {
	"true power",
	"cube of ice",
	"bull's essence",
    "sphere of fury",
    "potion of strength"
}

local function matches(name, target)
	return string.find(string.lower(name), string.lower(target), 1, true)
end

local function moveTo(part)
	local direction = (part.Position - hrp.Position).Unit
	local targetPos = part.Position - direction * 3
	hrp.CFrame = CFrame.new(targetPos)
	task.wait(moveDelay)
end

local function faceTarget(part)
	local lookVector = (part.Position - hrp.Position).Unit
	local yaw = math.atan2(lookVector.X, lookVector.Z)
	hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yaw, 0)
end

local function rotateCameraTo(part)
	camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position)
end

local function sendFKey()
	for _ = 1, 3 do
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
		task.wait(0.05)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
		task.wait(0.05)
	end
end

local visited = {}

for _, targetName in ipairs(priorityOrder) do
	for _, tool in ipairs(itemsFolder:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Handle") and matches(tool.Name, targetName) and not visited[tool] then
			visited[tool] = true
			local handle = tool.Handle
			moveTo(handle)
			task.wait(pauseTime)
			faceTarget(handle)
			rotateCameraTo(handle)
			task.wait(pauseTime)
			sendFKey()
		end
	end
end
end)

itemtab:Button("Grab Health Items", function()
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager") or getvirtualinputmanager()
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local itemsFolder = workspace:WaitForChild("Items")

local moveDelay = 0.425
local pauseTime = 0.1

local priorityOrder = {
	"apple",
    "first aid kit",
    "bandage"
}

local function matches(name, target)
	return string.find(string.lower(name), string.lower(target), 1, true)
end

local function moveTo(part)
	local direction = (part.Position - hrp.Position).Unit
	local targetPos = part.Position - direction * 3
	hrp.CFrame = CFrame.new(targetPos)
	task.wait(moveDelay)
end

local function faceTarget(part)
	local lookVector = (part.Position - hrp.Position).Unit
	local yaw = math.atan2(lookVector.X, lookVector.Z)
	hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yaw, 0)
end

local function rotateCameraTo(part)
	camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position)
end

local function sendFKey()
	for _ = 1, 3 do
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
		task.wait(0.05)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
		task.wait(0.05)
	end
end

local visited = {}

for _, targetName in ipairs(priorityOrder) do
	for _, tool in ipairs(itemsFolder:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Handle") and matches(tool.Name, targetName) and not visited[tool] then
			visited[tool] = true
			local handle = tool.Handle
			moveTo(handle)
			task.wait(pauseTime)
			faceTarget(handle)
			rotateCameraTo(handle)
			task.wait(pauseTime)
			sendFKey()
		end
	end
end
end)

itemtab:Button("Use PVP Items", function()
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager") or getvirtualinputmanager()
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local delayBetweenTools = 0.175
local clicksPerTool = 1
local clickDelay = 0.05

local keywords = {
	"cube of ice",
	"bull's essence"
}

local function matches(name)
	local lower = string.lower(name)
	for _, keyword in ipairs(keywords) do
		if string.find(lower, keyword, 1, true) then
			return true
		end
	end
	return false
end

local function equipAndClick(tool)
	if not tool or not tool:IsDescendantOf(Backpack) then return end

	tool.Parent = Character
	task.wait(0.2)

	for _ = 1, clicksPerTool do
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
		task.wait(clickDelay)
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
		task.wait(clickDelay)
	end

end

local matchingTools = {}
for _, tool in ipairs(Backpack:GetChildren()) do
	if tool:IsA("Tool") and matches(tool.Name) then
		table.insert(matchingTools, tool)
	end
end

for _, tool in ipairs(matchingTools) do
	equipAndClick(tool)
	task.wait(delayBetweenTools)
end
end)

itemtab:Button("Grab All Items (Possible To Use In Lobby, May Get Kicked.)", function()

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager") or getvirtualinputmanager()
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local itemsFolder = workspace:WaitForChild("Items")

local moveDelay = 0.425
local pauseTime = 0.15

local function moveTo(part)
	local direction = (part.Position - hrp.Position).Unit
	local targetPos = part.Position - direction * 3
	local targetCF = CFrame.new(targetPos)
	hrp.CFrame = targetCF
	task.wait(moveDelay)
end

local function faceTarget(part)
	local lookVector = (part.Position - hrp.Position).Unit
	local yaw = math.atan2(lookVector.X, lookVector.Z)
	hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yaw, 0)
end

local function rotateCameraTo(part)
	local camPos = camera.CFrame.Position
	local lookAt = part.Position
	camera.CFrame = CFrame.new(camPos, lookAt)
end

local function sendFKey()
	for _ = 1, 3 do
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
		task.wait(0.05)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
		task.wait(0.05)
	end
end

for _, tool in ipairs(itemsFolder:GetChildren()) do
	if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
		local handle = tool.Handle
		moveTo(handle)
		task.wait(pauseTime)
		faceTarget(handle)
		rotateCameraTo(handle)
		task.wait(pauseTime)
		sendFKey()
	end
end
end)


local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local playerName = LocalPlayer.Name

local root = nil
local slappedValue = nil
local ragdolledValue = Instance.new("BoolValue")
ragdolledValue.Name = "Ragdolled"
ragdolledValue.Value = false
ragdolledValue.Parent = LocalPlayer

local antiFlingEnabled = false

local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title;
			Text = text;
			Duration = 3,
		})
	end)
end

local function freezePlayer(source)
	if not antiFlingEnabled or not root then return end

	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	root.Anchored = true

	task.delay(2, function()
		if root then
			root.Anchored = false
		end
	end)
end

RunService.Heartbeat:Connect(function()
	if antiFlingEnabled and ragdolledValue and ragdolledValue.Value == true then
		freezePlayer("Ragdolled")
	end
end)

local function setupCharacter(character)
	root = character:WaitForChild("HumanoidRootPart")

	local localFolder = Workspace:FindFirstChild(playerName)
	if localFolder then
		slappedValue = localFolder:FindFirstChild("LastSlappedBy")
		ragdolledValue = localFolder:FindFirstChild("Ragdolled") or ragdolledValue
	end

	if slappedValue then
		slappedValue.Changed:Connect(function(newValue)
			if antiFlingEnabled and newValue and newValue ~= "" then
				freezePlayer("Slapped")
			end
		end)
	end
end

if LocalPlayer.Character then
	setupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)

antitab:Button("Anti-Knockback", function()
	antiFlingEnabled = not antiFlingEnabled
	local status = antiFlingEnabled and "Enabled." or "Disabled."
	notify("Anti-Knockback", status)
end)

antitab:Button("Anti-Exploiter (Not Very Reliable)", function()
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local detectionInterval = 1
local speedThreshold = 90
local flightHeightThreshold = 35
local teleportDistanceThreshold = 200
local teleportTimeWindow = 0.5
local flightTimeThreshold = 2.5

local lastPositions = {}
local lastTimestamps = {}
local airborneTimers = {}

local function notifyCheat(player, reason)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Exploit Detected",
            Text = player.Name .. " suspected of " .. reason,
            Duration = 5
        })
    end)
end

local function getGroundY(pos)
    local ray = Ray.new(pos, Vector3.new(0, -500, 0))
    local part, hitPos = Workspace:FindPartOnRay(ray)
    return hitPos and hitPos.Y or pos.Y
end

local function hasGliderEquipped(character)
    if not character then return false end
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") and item.Name:lower():find("glider") then
            return true
        end
    end
    return false
end

local function isRagdolled(player)
    local folder = Workspace:FindFirstChild(player.Name)
    local ragdollFlag = folder and folder:FindFirstChild("Ragdolled")
    return ragdollFlag and ragdollFlag.Value == true
end

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local currentPos = root.Position
            local lastPos = lastPositions[player] or currentPos
            local delta = (currentPos - lastPos).Magnitude
            local speed = delta / detectionInterval

            if speed > speedThreshold then
                notifyCheat(player, "Speed Hacks (" .. math.floor(speed) .. " studs/sec)")
            end

            local currentTime = tick()
            local lastTime = lastTimestamps[player] or currentTime
            local timeDelta = currentTime - lastTime

            if timeDelta <= teleportTimeWindow and delta > teleportDistanceThreshold then
                notifyCheat(player, "Teleporting (" .. math.floor(delta) .. " studs in " .. string.format("%.2f", timeDelta) .. "s)")
            end

            lastTimestamps[player] = currentTime

            local groundY = getGroundY(currentPos)
            local heightAboveGround = currentPos.Y - groundY
            local verticalVelocity = root.Velocity.Y
            local hasGlider = hasGliderEquipped(player.Character)
            local ragdolled = isRagdolled(player)

            if not hasGlider and not ragdolled and heightAboveGround > flightHeightThreshold then
                airborneTimers[player] = (airborneTimers[player] or 0) + detectionInterval

                if airborneTimers[player] >= flightTimeThreshold and math.abs(verticalVelocity) < 2 then
                    notifyCheat(player, "Flight Cheats (hovering " .. math.floor(heightAboveGround) .. " studs)")
                    airborneTimers[player] = 0
                end
            else
                airborneTimers[player] = 0
            end

            lastPositions[player] = currentPos
        end
    end
end)
end)

antitab:Button("Anti Lava/Acid", function()
local function createBaseplate(name, size, position)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Position = position
	part.Anchored = true
	part.Material = Enum.Material.SmoothPlastic
	part.Color = Color3.fromRGB(163, 162, 165)
	part.Transparency = 0.7
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = workspace
end

createBaseplate("Baseplate_512x512", Vector3.new(512, 1, 512), Vector3.new(-289, -29, 439))
createBaseplate("Baseplate_100x100", Vector3.new(256, 1, 256), Vector3.new(-55, 3, -719))
end)

misctab:Button("Infinite Yield", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

misctab:Button("Nameless Admin", function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
end)

misctab:Button("Rejoin Server", function()
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local jobId = game.JobId
local player = Players.LocalPlayer or Players:GetPlayers()[1]

if typeof(placeId) == "number" and typeof(jobId) == "string" and player then
    print("Rejoining current server...")
    print("PlaceId:", placeId)
    print("JobId:", jobId)
    TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
else
    print("Failed to get current server info or player.")
end
end)

misctab:Button("Switch Servers", function()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local currentJobId = game.JobId
local player = Players.LocalPlayer or Players:GetPlayers()[1]

local function findDifferentServer()
    local cursor = nil

    while true do
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local success, response = pcall(function()
            return http_request({
                Url = url,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0"
                }
            })
        end)

        if not success or not response or not response.Body then
            print("Request failed. Retrying...")
            task.wait(2)
            continue
        end

        if string.find(response.Body, "Too many requests") then
            print("Rate limited. Waiting...")
            task.wait(3)
            continue
        end

        local successDecode, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not successDecode or not data or not data.data then
            print("Failed to decode. Retrying...")
            task.wait(2)
            continue
        end

        for _, server in pairs(data.data) do
            if server.id ~= currentJobId and server.playing < server.maxPlayers then
                print("Found different server:", server.id)
                return server.id
            end
        end

        cursor = data.nextPageCursor
        task.wait(1)

        if not cursor then break end
    end

    return nil
end

local newJobId = findDifferentServer()
if newJobId and player then
    print("Teleporting to different server...")
    TeleportService:TeleportToPlaceInstance(placeId, newJobId, player)
else
    print("No different server found or player missing.")
end
end)

misctab:Button("Join Small Server (MAY GET RATE LIMITED!)", function()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

_G.extracted1 = game.PlaceId
_G.extracted2 = nil

local userAgents = {
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    "Mozilla/5.0 (X11; Linux x86_64)",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)",
    "Mozilla/5.0 (Android 11; Mobile; rv:89.0)",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0)",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/109.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/605.1.15 (KHTML, like Gecko)",
    "Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko)",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/114.0.0.0 Safari/537.36"
}

local function fetchSmartServer()
    local cursor = nil
    local smallestServer = nil
    local minPlayers = math.huge
    local retryCount = 0

    while true do
        local baseUrl = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", _G.extracted1)
        local url = baseUrl
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local headers = {
            ["User-Agent"] = userAgents[math.random(1, #userAgents)],
            ["X-Requested-With"] = "XMLHttpRequest"
        }

        local success, response = pcall(function()
            return http_request({
                Url = url,
                Method = "GET",
                Headers = headers
            })
        end)

        if not success or not response or not response.Body then
            print("Request failed. Retrying...")
            retryCount += 1
            task.wait(math.random(2, 4) + retryCount)
            continue
        end

        if string.find(response.Body, "Too many requests") then
            print("Rate limited. Backing off...")
            retryCount += 1
            task.wait(math.random(3, 6) + retryCount)
            continue
        end

        local successDecode, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not successDecode or not data or not data.data then
            print("Failed to decode server data. Retrying...")
            retryCount += 1
            task.wait(math.random(2, 5) + retryCount)
            continue
        end

        retryCount = 0

        for _, server in pairs(data.data) do
            print("Checking server:", server.id, "Players:", server.playing, "/", server.maxPlayers)

            if server.playing >= 1 and server.playing <= 2 and server.playing < server.maxPlayers then
                print("Found ideal server with 1–2 players. Joining now.")
                return server
            end

            if server.playing < minPlayers and server.playing < server.maxPlayers then
                minPlayers = server.playing
                smallestServer = server
            end
        end

        cursor = data.nextPageCursor
        task.wait(math.random(1, 2))

        if not cursor then break end
    end

    return smallestServer
end

local server = fetchSmartServer()
if server then
    _G.extracted2 = server.id
    print("Extracted PlaceId:", _G.extracted1)
    print("Extracted JobId:", _G.extracted2)

    local player = Players.LocalPlayer or Players:GetPlayers()[1]

    if typeof(_G.extracted1) == "number" and typeof(_G.extracted2) == "string" and player then
        print("Teleporting to server...")
        TeleportService:TeleportToPlaceInstance(_G.extracted1, _G.extracted2, player)
    else
        print("Invalid data or player not found.")
    end
else
    print("No suitable server found.")
end
end)

misctab:Button("Destroy GUI", function()
    win:Exit()
end)


misctab:Button("Leave Game", function()
    game:Shutdown()
end)

helptab:Button("Copy Owner Discord Username", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Username",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("ghostofcelleron")
end)

helptab:Button("Copy Discord Server Invite", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Invite",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("https://discord.gg/8stFYxJv4R")
end)
elseif currentPlaceId == eternalbob then
local ui = loadstring(game:HttpGet("https://pastebin.com/raw/PQBu5K3w"))()

local win = ui:Create({
    Name = "Celeron's GUI (Eternal Bob)",
    ThemeColor = Color3.fromRGB(14, 14, 14),
    StartupSound = "rbxassetid://6958727243",
    ThemeFont = Enum.Font.FredokaOne
})

local maintab = win:Tab("Main")
local antitab = win:Tab("Protection")
local modetab = win:Tab("Modes")
local misctab = win:Tab("Others")
local helptab = win:Tab("Info")

maintab:Label("Script Made By Celeron + Daffy!")
antitab:Label("Protection Settings May Be Blatant.")
helptab:Label("GUI Controls Are Below, Script Credits Are At The Bottom!")
helptab:Label("Show / Hide GUI: Right Alt")

misctab:Button("Infinite Yield", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

misctab:Button("Nameless Admin", function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
end)

misctab:Button("Rejoin Server", function()
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local jobId = game.JobId
local player = Players.LocalPlayer or Players:GetPlayers()[1]

if typeof(placeId) == "number" and typeof(jobId) == "string" and player then
    print("Rejoining current server...")
    print("PlaceId:", placeId)
    print("JobId:", jobId)
    TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
else
    print("Failed to get current server info or player.")
end
end)

misctab:Button("Switch Servers", function()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local currentJobId = game.JobId
local player = Players.LocalPlayer or Players:GetPlayers()[1]

local function findDifferentServer()
    local cursor = nil

    while true do
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local success, response = pcall(function()
            return http_request({
                Url = url,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0"
                }
            })
        end)

        if not success or not response or not response.Body then
            print("Request failed. Retrying...")
            task.wait(2)
            continue
        end

        if string.find(response.Body, "Too many requests") then
            print("Rate limited. Waiting...")
            task.wait(3)
            continue
        end

        local successDecode, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not successDecode or not data or not data.data then
            print("Failed to decode. Retrying...")
            task.wait(2)
            continue
        end

        for _, server in pairs(data.data) do
            if server.id ~= currentJobId and server.playing < server.maxPlayers then
                print("Found different server:", server.id)
                return server.id
            end
        end

        cursor = data.nextPageCursor
        task.wait(1)

        if not cursor then break end
    end

    return nil
end

local newJobId = findDifferentServer()
if newJobId and player then
    print("Teleporting to different server...")
    TeleportService:TeleportToPlaceInstance(placeId, newJobId, player)
else
    print("No different server found or player missing.")
end
end)

misctab:Button("Join Small Server (MAY GET RATE LIMITED!)", function()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

_G.extracted1 = game.PlaceId
_G.extracted2 = nil

local userAgents = {
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    "Mozilla/5.0 (X11; Linux x86_64)",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)",
    "Mozilla/5.0 (Android 11; Mobile; rv:89.0)",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0)",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/109.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/605.1.15 (KHTML, like Gecko)",
    "Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko)",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/114.0.0.0 Safari/537.36"
}

local function fetchSmartServer()
    local cursor = nil
    local smallestServer = nil
    local minPlayers = math.huge
    local retryCount = 0

    while true do
        local baseUrl = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", _G.extracted1)
        local url = baseUrl
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local headers = {
            ["User-Agent"] = userAgents[math.random(1, #userAgents)],
            ["X-Requested-With"] = "XMLHttpRequest"
        }

        local success, response = pcall(function()
            return http_request({
                Url = url,
                Method = "GET",
                Headers = headers
            })
        end)

        if not success or not response or not response.Body then
            print("Request failed. Retrying...")
            retryCount += 1
            task.wait(math.random(2, 4) + retryCount)
            continue
        end

        if string.find(response.Body, "Too many requests") then
            print("Rate limited. Backing off...")
            retryCount += 1
            task.wait(math.random(3, 6) + retryCount)
            continue
        end

        local successDecode, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not successDecode or not data or not data.data then
            print("Failed to decode server data. Retrying...")
            retryCount += 1
            task.wait(math.random(2, 5) + retryCount)
            continue
        end

        retryCount = 0

        for _, server in pairs(data.data) do
            print("Checking server:", server.id, "Players:", server.playing, "/", server.maxPlayers)

            if server.playing >= 1 and server.playing <= 2 and server.playing < server.maxPlayers then
                print("Found ideal server with 1–2 players. Joining now.")
                return server
            end

            if server.playing < minPlayers and server.playing < server.maxPlayers then
                minPlayers = server.playing
                smallestServer = server
            end
        end

        cursor = data.nextPageCursor
        task.wait(math.random(1, 2))

        if not cursor then break end
    end

    return smallestServer
end

local server = fetchSmartServer()
if server then
    _G.extracted2 = server.id
    print("Extracted PlaceId:", _G.extracted1)
    print("Extracted JobId:", _G.extracted2)

    local player = Players.LocalPlayer or Players:GetPlayers()[1]

    if typeof(_G.extracted1) == "number" and typeof(_G.extracted2) == "string" and player then
        print("Teleporting to server...")
        TeleportService:TeleportToPlaceInstance(_G.extracted1, _G.extracted2, player)
    else
        print("Invalid data or player not found.")
    end
else
    print("No suitable server found.")
end
end)

misctab:Button("Destroy GUI", function()
    win:Exit()
end)


misctab:Button("Leave Game", function()
    game:Shutdown()
end)

modetab:Label("These Places Can Be Joined Instantly!")

local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer

local function teleportTo(placeId)
    TeleportService:Teleport(placeId, LocalPlayer)
end

modetab:Button("Main Game", function()
    teleportTo(6403373529)
end)

modetab:Button("Killstreak Only", function()
    teleportTo(11520107397)
end)

modetab:Button("No One Shot Gloves", function()
    teleportTo(9015014224)
end)

modetab:Button("Slap Royale Matchmaking", function()
    teleportTo(9426795465)
end)

modetab:Button("Normal Barzil", function()
    teleportTo(7234087065)
end)

misctab:Button("Slap League (Functional, Needs Another Player.)", function()
    teleportTo(18698003301)
end)

modetab:Button("Tower Of Hell (TOH)", function()
    teleportTo(115782629143468)
end)

modetab:Button("Day in the Life of a Small Game Dev", function()
	queueonteleport([[
    print("ez pz!")

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local function find(parent, name)
        local t, s = 2.5, tick()
        repeat
            local c = parent:FindFirstChild(name)
            if c then return c end
            task.wait(0.1)
        until tick() - s > t
        return nil
    end

    local hrp = find(character, "HumanoidRootPart")
    local trigger = find(find(find(find(workspace, "Buildings"), "wizard twoer 2"), "Model"), "Trigger")

    if hrp and trigger and trigger:FindFirstChild("TouchInterest") then
        firetouchinterest(hrp, trigger, 0)
        firetouchinterest(hrp, trigger, 1)
    end
]])
teleportTo(7234087065)
end)

modetab:Button("Custom Glove Customizer", function()
    teleportTo(9068206286)
end)

modetab:Button("Soft Update Waiting Place", function()
    teleportTo(12712288037)
end)

modetab:Button("?", function()
    teleportTo(12845859004)
end)

modetab:Label("Warning: The Below Places Can't Be Joined Directly.")

modetab:Button("Testing Place", function()
    teleportTo(9020359053)
end)

modetab:Button("Tower Defense", function()
    teleportTo(15228348051)
end)

modetab:Button("Christmas Eve", function()
    teleportTo(15507333474)
end)

modetab:Button("Null Zone", function()
    teleportTo(14422118326)
end)

modetab:Button("Staff Application", function()
    teleportTo(16034567693)
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local lastSliderSet = nil
local humanoidConnection = nil

local function applySpeed(humanoid)
	if not humanoid or not lastSliderSet then return end
	if humanoid.WalkSpeed ~= lastSliderSet then
		humanoid.WalkSpeed = lastSliderSet
	end

	if humanoidConnection then
		humanoidConnection:Disconnect()
	end

	humanoidConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if humanoid.WalkSpeed ~= lastSliderSet then
			humanoid.WalkSpeed = lastSliderSet
		end
	end)
end

maintab:Slider("Player Speed", 19.5, 5, 85, function(v)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	lastSliderSet = (v == 8) and 16 or v
	applySpeed(humanoid)
end)

LocalPlayer.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid"):GetPropertyChangedSignal("Parent"):Connect(function()
		local newHumanoid = character:FindFirstChildOfClass("Humanoid")
		if newHumanoid then
			applySpeed(newHumanoid)
		end
	end)

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		applySpeed(humanoid)
	end
end)

local autoSlapBob = false
local slapLoop = nil

local autoSlapBob = false
local slapLoop = nil

maintab:Button("Auto Slap Bob", function()
    autoSlapBob = not autoSlapBob

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Auto Slap Bob",
        Text = autoSlapBob and "Enabled." or "Disabled.",
        Duration = 5
    })

    if autoSlapBob then
        slapLoop = task.spawn(function()
            while autoSlapBob do
                local boss = workspace:FindFirstChild("bobBoss")
                if boss then
                    local damageEvent = boss:FindFirstChild("DamageEvent")
                    if damageEvent then
                        damageEvent:FireServer()
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        if slapLoop then
            task.cancel(slapLoop)
            slapLoop = nil
        end
    end
end)

local autoAttackBob = false
local attackLoop = nil

maintab:Button("Slap Aura (Players / Mini Bob)", function()
    autoAttackBob = not autoAttackBob

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Slap Aura",
        Text = autoAttackBob and "Enabled." or "Disabled.",
        Duration = 5
    })

    if autoAttackBob then
        attackLoop = task.spawn(function()
            while autoAttackBob do
                local glove = game.Players.LocalPlayer.leaderstats.Glove.Value
                if glove == "Reaper" then
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v.Name == "BobClone" then
                            game:GetService("ReplicatedStorage").ReaperHit:FireServer(v:FindFirstChild("HumanoidRootPart"))
                        end
                    end
                elseif glove == "Killstreak" then
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v.Name == "BobClone" then
                            game:GetService("ReplicatedStorage").KSHit:FireServer(v:FindFirstChild("HumanoidRootPart"))
                        end
                    end
                elseif glove == "God's Hand" then
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v.Name == "BobClone" then
                            game:GetService("ReplicatedStorage").Godshand:FireServer(v:FindFirstChild("HumanoidRootPart"))
                        end
                    end
                elseif glove == "Tycoon" then
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v.Name == "BobClone" then
                            game:GetService("ReplicatedStorage").GeneralHit:FireServer(v:FindFirstChild("HumanoidRootPart"))
                        end
                    end
                elseif glove == "Default" then
                    for _, v in ipairs(game.Players:GetPlayers()) do
                        if v ~= game.Players.LocalPlayer and v.Character then
                            if v.Character:FindFirstChild("Ragdolled") and v.Character.Ragdolled.Value == false then
                                game:GetService("ReplicatedStorage").b:FireServer(v.Character:FindFirstChild("HumanoidRootPart"))
                            end
                        end
                    end
                end
                task.wait(0.25)
            end
        end)
    else
        if attackLoop then
            task.cancel(attackLoop)
            attackLoop = nil
        end
    end
end)

local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local spamClick = false
local clickLoop = nil

maintab:Button("Auto Tycoon", function()
    spamClick = not spamClick

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Auto Tycoon",
        Text = spamClick and "Enabled." or "Disabled.",
        Duration = 5
    })

    if spamClick then
        if clickLoop then
            task.cancel(clickLoop)
            clickLoop = nil
        end

        clickLoop = task.spawn(function()
            while spamClick do
                for _, player in ipairs(Players:GetPlayers()) do
                    local tycoonName = "ÅTycoon" .. player.Name
                    local tycoonModel = Workspace:FindFirstChild(tycoonName)

                    if tycoonModel and tycoonModel:FindFirstChild("Click") then
                        local clickDetector = tycoonModel.Click:FindFirstChildOfClass("ClickDetector")
                        if clickDetector and clickDetector.Parent:IsA("BasePart") then
                            local screenPos = Workspace.CurrentCamera:WorldToViewportPoint(clickDetector.Parent.Position)
                            VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
                            VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    else
        if clickLoop then
            task.cancel(clickLoop)
            clickLoop = nil
        end
    end
end)

antitab:Button("Remove Screenshake", function()
local player = game:GetService("Players").LocalPlayer
local screenshake = player:WaitForChild("PlayerScripts"):FindFirstChild("Screenshake")

if screenshake then
    screenshake:Destroy()
else
    warn("screenshake already removed")
end
end)

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local playerName = LocalPlayer.Name

local root = nil
local slappedValue = nil
local ragdolledValue = Instance.new("BoolValue")
ragdolledValue.Name = "Ragdolled"
ragdolledValue.Value = false
ragdolledValue.Parent = LocalPlayer

local antiFlingEnabled = false

local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title;
			Text = text;
			Duration = 3,
		})
	end)
end

local function freezePlayer(source)
	if not antiFlingEnabled or not root then return end

	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	root.Anchored = true

	task.delay(2, function()
		if root then
			root.Anchored = false
		end
	end)
end

RunService.Heartbeat:Connect(function()
	if antiFlingEnabled and ragdolledValue and ragdolledValue.Value == true then
		freezePlayer("Ragdolled")
	end
end)

local function setupCharacter(character)
	root = character:WaitForChild("HumanoidRootPart")

	local localFolder = Workspace:FindFirstChild(playerName)
	if localFolder then
		slappedValue = localFolder:FindFirstChild("LastSlappedBy")
		ragdolledValue = localFolder:FindFirstChild("Ragdolled") or ragdolledValue
	end

	if slappedValue then
		slappedValue.Changed:Connect(function(newValue)
			if antiFlingEnabled and newValue and newValue ~= "" then
				freezePlayer("Slapped")
			end
		end)
	end
end

if LocalPlayer.Character then
	setupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)

antitab:Button("Anti-Knockback", function()
	antiFlingEnabled = not antiFlingEnabled
	local status = antiFlingEnabled and "Enabled." or "Disabled."
	notify("Anti-Knockback", status)
end)

helptab:Button("Copy Owner Discord Username", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Username",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("ghostofcelleron")
end)

helptab:Button("Copy Discord Server Invite", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Invite",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("https://discord.gg/8stFYxJv4R")
end)

elseif currentPlaceId == slapbattlesks then
local ui = loadstring(game:HttpGet("https://pastebin.com/raw/PQBu5K3w"))()

local win = ui:Create({
    Name = "Celeron's GUI (Slap Battles)",
    ThemeColor = Color3.fromRGB(14, 14, 14),
    StartupSound = "rbxassetid://6958727243",
    ThemeFont = Enum.Font.FredokaOne
})

local maintab = win:Tab("Main")
local antitab = win:Tab("Protection")
local teletab = win:Tab("Map")
local modetab = win:Tab("Modes")
local misctab = win:Tab("Others")
local helptab = win:Tab("Info")

maintab:Label("Script Made By Celeron + Daffy!")
antitab:Label("Protection Settings May Be Blatant.")
helptab:Label("GUI Controls Are Below, Script Credits Are At The Bottom!")
helptab:Label("Show / Hide GUI: Right Alt")

misctab:Button("Infinite Yield", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

misctab:Button("Nameless Admin", function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
end)

misctab:Button("Rejoin Server", function()
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local jobId = game.JobId
local player = Players.LocalPlayer or Players:GetPlayers()[1]

if typeof(placeId) == "number" and typeof(jobId) == "string" and player then
    print("Rejoining current server...")
    print("PlaceId:", placeId)
    print("JobId:", jobId)
    TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
else
    print("Failed to get current server info or player.")
end
end)

misctab:Button("Switch Servers", function()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = game.PlaceId
local currentJobId = game.JobId
local player = Players.LocalPlayer or Players:GetPlayers()[1]

local function findDifferentServer()
    local cursor = nil

    while true do
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local success, response = pcall(function()
            return http_request({
                Url = url,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0"
                }
            })
        end)

        if not success or not response or not response.Body then
            print("Request failed. Retrying...")
            task.wait(2)
            continue
        end

        if string.find(response.Body, "Too many requests") then
            print("Rate limited. Waiting...")
            task.wait(3)
            continue
        end

        local successDecode, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not successDecode or not data or not data.data then
            print("Failed to decode. Retrying...")
            task.wait(2)
            continue
        end

        for _, server in pairs(data.data) do
            if server.id ~= currentJobId and server.playing < server.maxPlayers then
                print("Found different server:", server.id)
                return server.id
            end
        end

        cursor = data.nextPageCursor
        task.wait(1)

        if not cursor then break end
    end

    return nil
end

local newJobId = findDifferentServer()
if newJobId and player then
    print("Teleporting to different server...")
    TeleportService:TeleportToPlaceInstance(placeId, newJobId, player)
else
    print("No different server found or player missing.")
end
end)

misctab:Button("Join Small Server (MAY GET RATE LIMITED!)", function()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

_G.extracted1 = game.PlaceId
_G.extracted2 = nil

local userAgents = {
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    "Mozilla/5.0 (X11; Linux x86_64)",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)",
    "Mozilla/5.0 (Android 11; Mobile; rv:89.0)",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0)",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/109.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/605.1.15 (KHTML, like Gecko)",
    "Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko)",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/114.0.0.0 Safari/537.36"
}

local function fetchSmartServer()
    local cursor = nil
    local smallestServer = nil
    local minPlayers = math.huge
    local retryCount = 0

    while true do
        local baseUrl = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", _G.extracted1)
        local url = baseUrl
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local headers = {
            ["User-Agent"] = userAgents[math.random(1, #userAgents)],
            ["X-Requested-With"] = "XMLHttpRequest"
        }

        local success, response = pcall(function()
            return http_request({
                Url = url,
                Method = "GET",
                Headers = headers
            })
        end)

        if not success or not response or not response.Body then
            print("Request failed. Retrying...")
            retryCount += 1
            task.wait(math.random(2, 4) + retryCount)
            continue
        end

        if string.find(response.Body, "Too many requests") then
            print("Rate limited. Backing off...")
            retryCount += 1
            task.wait(math.random(3, 6) + retryCount)
            continue
        end

        local successDecode, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not successDecode or not data or not data.data then
            print("Failed to decode server data. Retrying...")
            retryCount += 1
            task.wait(math.random(2, 5) + retryCount)
            continue
        end

        retryCount = 0

        for _, server in pairs(data.data) do
            print("Checking server:", server.id, "Players:", server.playing, "/", server.maxPlayers)

            if server.playing >= 1 and server.playing <= 2 and server.playing < server.maxPlayers then
                print("Found ideal server with 1–2 players. Joining now.")
                return server
            end

            if server.playing < minPlayers and server.playing < server.maxPlayers then
                minPlayers = server.playing
                smallestServer = server
            end
        end

        cursor = data.nextPageCursor
        task.wait(math.random(1, 2))

        if not cursor then break end
    end

    return smallestServer
end

local server = fetchSmartServer()
if server then
    _G.extracted2 = server.id
    print("Extracted PlaceId:", _G.extracted1)
    print("Extracted JobId:", _G.extracted2)

    local player = Players.LocalPlayer or Players:GetPlayers()[1]

    if typeof(_G.extracted1) == "number" and typeof(_G.extracted2) == "string" and player then
        print("Teleporting to server...")
        TeleportService:TeleportToPlaceInstance(_G.extracted1, _G.extracted2, player)
    else
        print("Invalid data or player not found.")
    end
else
    print("No suitable server found.")
end
end)

misctab:Button("Destroy GUI", function()
    win:Exit()
end)


misctab:Button("Leave Game", function()
    game:Shutdown()
end)

modetab:Label("These Places Can Be Joined Instantly!")

local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer

local function teleportTo(placeId)
    TeleportService:Teleport(placeId, LocalPlayer)
end

modetab:Button("Main Game", function()
    teleportTo(6403373529)
end)

modetab:Button("Killstreak Only", function()
    teleportTo(11520107397)
end)

modetab:Button("No One Shot Gloves", function()
    teleportTo(9015014224)
end)

modetab:Button("Slap Royale Matchmaking", function()
    teleportTo(9426795465)
end)

modetab:Button("Normal Barzil", function()
    teleportTo(7234087065)
end)

misctab:Button("Slap League (Functional, Needs Another Player.)", function()
    teleportTo(18698003301)
end)

modetab:Button("Tower Of Hell (TOH)", function()
    teleportTo(115782629143468)
end)

modetab:Button("Day in the Life of a Small Game Dev", function()
	queueonteleport([[
    print("ez pz!")

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local function find(parent, name)
        local t, s = 2.5, tick()
        repeat
            local c = parent:FindFirstChild(name)
            if c then return c end
            task.wait(0.1)
        until tick() - s > t
        return nil
    end

    local hrp = find(character, "HumanoidRootPart")
    local trigger = find(find(find(find(workspace, "Buildings"), "wizard twoer 2"), "Model"), "Trigger")

    if hrp and trigger and trigger:FindFirstChild("TouchInterest") then
        firetouchinterest(hrp, trigger, 0)
        firetouchinterest(hrp, trigger, 1)
    end
]])
teleportTo(7234087065)
end)

modetab:Button("Custom Glove Customizer", function()
    teleportTo(9068206286)
end)

modetab:Button("Soft Update Waiting Place", function()
    teleportTo(12712288037)
end)

modetab:Button("?", function()
    teleportTo(12845859004)
end)

modetab:Label("Warning: The Below Places Can't Be Joined Directly.")

modetab:Button("Testing Place", function()
    teleportTo(9020359053)
end)

modetab:Button("Tower Defense", function()
    teleportTo(15228348051)
end)

modetab:Button("Christmas Eve", function()
    teleportTo(15507333474)
end)

modetab:Button("Null Zone", function()
    teleportTo(14422118326)
end)

modetab:Button("Staff Application", function()
    teleportTo(16034567693)
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local lastSliderSet = nil
local humanoidConnection = nil

local function applySpeed(humanoid)
	if not humanoid or not lastSliderSet then return end
	if humanoid.WalkSpeed ~= lastSliderSet then
		humanoid.WalkSpeed = lastSliderSet
	end

	if humanoidConnection then
		humanoidConnection:Disconnect()
	end

	humanoidConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if humanoid.WalkSpeed ~= lastSliderSet then
			humanoid.WalkSpeed = lastSliderSet
		end
	end)
end

maintab:Slider("Player Speed", 19.5, 5, 85, function(v)
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	lastSliderSet = (v == 8) and 16 or v
	applySpeed(humanoid)
end)

LocalPlayer.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid"):GetPropertyChangedSignal("Parent"):Connect(function()
		local newHumanoid = character:FindFirstChildOfClass("Humanoid")
		if newHumanoid then
			applySpeed(newHumanoid)
		end
	end)

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		applySpeed(humanoid)
	end
end)

maintab:Button("Remove Cooldown", function()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local tool = character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
while character.Humanoid.Health ~= 0 do
local localscript = tool:FindFirstChildOfClass("LocalScript")
local localscriptclone = localscript:Clone()
localscriptclone = localscript:Clone()
localscriptclone:Clone()
localscript:Destroy()
localscriptclone.Parent = tool
wait(0.1)
end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local root = nil
local auraEnabled = false
local cachedRemotes = {}
local heartbeatConn
local lastFireTime = 0

local function notify(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration or 3
		})
	end)
end

local function updateRoot()
	local character = LocalPlayer.Character
	if character then
		root = character:FindFirstChild("HumanoidRootPart")
	end
end

LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	updateRoot()
end)

if LocalPlayer.Character then
	updateRoot()
end

local function findEquippedGlove()
	local character = LocalPlayer.Character
	if not character then return nil end
	for _, tool in ipairs(character:GetChildren()) do
		if tool:IsA("Tool") then
			return tool
		end
	end
end

local function getClosestPlayer()
	local myRoot = root
	if not myRoot then return nil end

	local closest, dist = nil, math.huge
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local mag = (targetRoot.Position - myRoot.Position).Magnitude
				if mag < dist then
					dist = mag
					closest = player
				end
			end
		end
	end
	return closest
end

local function findRelevantHitRemotes(gloveName)
	if cachedRemotes[gloveName] then return cachedRemotes[gloveName] end

	local nameLower = string.lower(gloveName or "")
	local hits = {}

	for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
		if obj:IsA("RemoteEvent") then
			local remoteLower = string.lower(obj.Name)
			if remoteLower == nameLower .. "hi"
			or (remoteLower:find(nameLower) and remoteLower:find("hit"))
			or remoteLower:find("zh")
			or remoteLower:find("slap")
			or remoteLower:find("hi")
			or remoteLower:find("hit") then
				table.insert(hits, obj)
			end
		end
	end

	cachedRemotes[gloveName] = hits
	return hits
end

maintab:Button("Slap Aura", function()
	auraEnabled = not auraEnabled

	if auraEnabled and not heartbeatConn then
		heartbeatConn = RunService.Heartbeat:Connect(function()
			local currentTime = os.clock()
			if currentTime - lastFireTime < 0.5 then return end

			local glove = findEquippedGlove()
			local targetPlayer = getClosestPlayer()

			if targetPlayer and targetPlayer.Character then
				local torso = targetPlayer.Character:FindFirstChild("Torso")
					or targetPlayer.Character:FindFirstChild("UpperTorso")
					or targetPlayer.Character:FindFirstChild("HumanoidRootPart")

				if torso then
					local remotes = {}

					if glove then
						local foundRemotes = findRelevantHitRemotes(glove.Name)
						if foundRemotes and #foundRemotes > 0 then
							remotes = foundRemotes
						end
					end

					if #remotes == 0 then
						for _, fallbackName in ipairs({"GeneralHit", "b", "KSHit"}) do
							local remote = ReplicatedStorage:FindFirstChild(fallbackName)
							if remote then
								table.insert(remotes, remote)
							end
						end
					end

					for _, remote in ipairs(remotes) do
						remote:FireServer(torso)
					end

					lastFireTime = currentTime
				end
			end
		end)
	elseif not auraEnabled and heartbeatConn then
		heartbeatConn:Disconnect()
		heartbeatConn = nil
	end

	notify("Slap Aura", auraEnabled and "Enabled." or "Disabled.")
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local range = 15
local cooldown = 1
local lastClick = 0
local enabled = false

local function emulateClick()
	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
end

RunService.RenderStepped:Connect(function()
	if not enabled then return end

	local now = tick()
	if now - lastClick < cooldown then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local targetHRP = player.Character.HumanoidRootPart
			local dist = (HumanoidRootPart.Position - targetHRP.Position).Magnitude

			if dist <= range then
				emulateClick()
				lastClick = now
				break
			end
		end
	end
end)

maintab:Button("Glove Triggerbot", function()
    enabled = not enabled

    local StarterGui = game:GetService("StarterGui")
    StarterGui:SetCore("SendNotification", {
        Title = "Glove Triggerbot",
        Text = enabled and "Enabled." or "Disabled.",
        Duration = 2
    })
end)

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local playerName = LocalPlayer.Name

local root = nil
local slappedValue = nil
local ragdolledValue = Instance.new("BoolValue")
ragdolledValue.Name = "Ragdolled"
ragdolledValue.Value = false
ragdolledValue.Parent = LocalPlayer

local antiFlingEnabled = false

local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title;
			Text = text;
			Duration = 3,
		})
	end)
end

local function freezePlayer(source)
	if not antiFlingEnabled or not root then return end

	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	root.Anchored = true

	task.delay(2, function()
		if root then
			root.Anchored = false
		end
	end)
end

RunService.Heartbeat:Connect(function()
	if antiFlingEnabled and ragdolledValue and ragdolledValue.Value == true then
		freezePlayer("Ragdolled")
	end
end)

local function setupCharacter(character)
	root = character:WaitForChild("HumanoidRootPart")

	local localFolder = Workspace:FindFirstChild(playerName)
	if localFolder then
		slappedValue = localFolder:FindFirstChild("LastSlappedBy")
		ragdolledValue = localFolder:FindFirstChild("Ragdolled") or ragdolledValue
	end

	if slappedValue then
		slappedValue.Changed:Connect(function(newValue)
			if antiFlingEnabled and newValue and newValue ~= "" then
				freezePlayer("Slapped")
			end
		end)
	end
end

if LocalPlayer.Character then
	setupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)

antitab:Button("Anti-Knockback", function()
	antiFlingEnabled = not antiFlingEnabled
	local status = antiFlingEnabled and "Enabled." or "Disabled."
	notify("Anti-Knockback", status)
end)

antitab:Button("Anti-Void (Teleport Method, Rejoin To Disable.)", function()
local lp = game.Players.LocalPlayer
local lastGroundedPos = nil

local baseplate = Instance.new("Part")
baseplate.Size = Vector3.new(99999, 1, 99999)
baseplate.Position = Vector3.new(-30, -30, -30)
baseplate.Anchored = true
baseplate.CanCollide = true
baseplate.Transparency = 0.9
baseplate.Name = "VoidProtection"
baseplate.Parent = workspace

game:GetService("RunService").Heartbeat:Connect(function()
    local char = lp.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local rayOrigin = hrp.Position
    local rayDirection = Vector3.new(0, -50, 0)

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char, baseplate}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.IgnoreWater = true

    local result = workspace:Raycast(rayOrigin, rayDirection, params)

    if result and result.Instance and result.Instance.CanCollide then
        lastGroundedPos = hrp.Position
    elseif hrp.Position.Y < -24 and lastGroundedPos then
        hrp.CFrame = CFrame.new(lastGroundedPos + Vector3.new(0, 5, 0))
    end
end)

baseplate.Touched:Connect(function(hit)
    local char = lp.Character
    if not char then return end
    if hit:IsDescendantOf(char) and lastGroundedPos then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(lastGroundedPos + Vector3.new(0, 5, 0))
        end
    end
end)
end)

antitab:Button("Anti-Void (Baseplate Method)", function()
local Workspace = game:GetService("Workspace")

local baseplate = Instance.new("Part")
baseplate.Name = "VoidProtection"
baseplate.Size = Vector3.new(25000, 1, 25000)
baseplate.Position = Vector3.new(15, -10, 6)
baseplate.Anchored = true
baseplate.Material = Enum.Material.Grass
baseplate.Transparency = 0.75
baseplate.Color = Color3.fromRGB(0, 255, 45)
baseplate.CastShadow = false 
baseplate.Parent = workspace
end)

antitab:Button("Remove Anti-Void", function()
local function removeVoidProtections(parent)
	for _, obj in ipairs(parent:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "VoidProtection" then
			obj:Destroy()
		end
	end
end

removeVoidProtections(game)
end)

teletab:Button("Main Island", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3, -5, 16)
end)

teletab:Button("Moyai Island", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(229, -16, -12)
end)

teletab:Button("Slapple Island", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-381, 51, -12)
end)

teletab:Button("Castle", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(250, 34, 189)
end)

teletab:Button("The Plate", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Arena.Plate.CFrame
end)

teletab:Button("Retro Obby", function()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local mapPath = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Retro"):WaitForChild("Map"):WaitForChild("RetroObbyMap")
local mapName = "RetroObbyMap"

local existingMap = Workspace:FindFirstChild(mapName)
if not existingMap then
    local clonedMap = mapPath:Clone()
    clonedMap.Parent = Workspace
    existingMap = clonedMap
end

local targetPosition = CFrame.new(-16873, -1, 4775)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

hrp.CFrame = targetPosition
end)

teletab:Button("Baseplate", function()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local baseplateName = "_TargetBaseplate"
local targetPosition = Vector3.new(5000, 228, 5000)
local baseplateSize = Vector3.new(512, 20, 512)

local function ensureBaseplate()
	local existing = Workspace:FindFirstChild(baseplateName)
	if not existing then
		local part = Instance.new("Part")
		part.Name = baseplateName
		part.Size = baseplateSize
		part.Position = targetPosition
		part.Anchored = true
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		part.Material = Enum.Material.SmoothPlastic
		part.Color = Color3.fromRGB(163, 162, 165)
		part.Parent = Workspace
	end
end

local function teleportToBaseplate()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")
	root.CFrame = CFrame.new(targetPosition + Vector3.new(0, baseplateSize.Y / 2 + 5, 0))
end

ensureBaseplate()
teleportToBaseplate()
end)

helptab:Button("Copy Owner Discord Username", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Username",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("ghostofcelleron")
end)

helptab:Button("Copy Discord Server Invite", function()
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Discord Invite",
    Text = "Copied to your clipboard!",
    Duration = 3,
    Button1 = "alright fella",
})
setclipboard("https://discord.gg/8stFYxJv4R")
end)
elseif currentPlaceId == slaproyalewaiting then
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Execute In Match",
    Text = "Execute the script when the match starts.",
    Duration = 3,
    Button1 = "alright fella",
})
else
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Not Supported",
    Text = "This Game / Mode Is Not Supported, Please Try Again Later.",
    Duration = 3,
    Button1 = "alright fella",
})
end