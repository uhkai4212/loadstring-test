local ui = loadstring(game:HttpGet("https://pastebin.com/raw/wk7ZrGyr"))()

local win = ui:Create({
    Name = "Celeron's GUI (Flee The Facility)",
    ThemeColor = Color3.fromRGB(255, 124, 100),
    StartupSound = "rbxassetid://6958727243",
    ThemeFont = Enum.Font.FredokaOne
})

local maintab = win:Tab("Main")
local tpstab = win:Tab("Areas")
local funtab = win:Tab("Misc")
local helptab = win:Tab("Info")

maintab:Label("Script Made By Celeron + Daffy!")
helptab:Label("GUI Controls Are Below, Script Credits Are At The Bottom!")
helptab:Label("Show / Hide GUI: Right Alt")

local player = game:GetService("Players").LocalPlayer
local humanoid = player and player.Character and player.Character:FindFirstChild("Humanoid")
local runService = game:GetService("RunService")
local currentSpeed = 18
local connection

if humanoid then
    if connection then connection:Disconnect() end
    connection = runService.Heartbeat:Connect(function()
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end)
end

maintab:Slider("Walkspeed", 18, 5, 32, function(v)
    currentSpeed = v
end)

maintab:Button("Automatic Hacking", function()
_G.AutomaticHackingEnabled = not _G.AutomaticHackingEnabled

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Automatic Hacking";
    Text = _G.AutomaticHackingEnabled and "Enabled." or "Disabled.";
    Duration = 3;
})

while _G.AutomaticHackingEnabled do
    wait(0.25)
    local args = {
        "SetPlayerMinigameResult",
        true
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end
end)

maintab:Button("Anti-Freezer (USE AS SOON AS ROPED)", function()
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local targetCFrame = CFrame.new(111.20410919189453, 8.207777976989746, -413.4593811035156)

if character and character.PrimaryPart then
    for i = 1, 240 do
        character:SetPrimaryPartCFrame(targetCFrame)
        task.wait(0.05)
    end
end
end)

maintab:Button("Self-Revive (LAST RESORT, USE IN FREEZER)", function()
local player = game:GetService("Players").LocalPlayer
local character = player.Character

if character then
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Alert";
    Text = "You can no longer hack computers! You can still escape however.";
    Duration = 3;
})
end)

maintab:Button("Join Mid-Game", function()
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function findOBSpawnPadInParent()
    for _, model in pairs(game.Workspace:GetChildren()) do
        if model:IsA("Model") then
            local computerTable = model:FindFirstChild("ComputerTable")
            if computerTable and computerTable:IsA("Model") then
                local spawnPad = model:FindFirstChild("OBSpawnPad")
                if spawnPad and spawnPad:IsA("BasePart") then
                    return spawnPad
                end
            end
        end
    end
    return nil
end

local targetSpawnPad = findOBSpawnPadInParent()

if targetSpawnPad then
    character:SetPrimaryPartCFrame(targetSpawnPad.CFrame + Vector3.new(0, 5, 0))
end
end)

maintab:Button("Random Computer TP", function()
local function findAllPartsByName(parent, name)
    local parts = {}
    for _, obj in pairs(parent:GetChildren()) do
        if obj.Name == name and obj:IsA("Model") then
            table.insert(parts, obj)
        end
        if #obj:GetChildren() > 0 then
            local foundParts = findAllPartsByName(obj, name)
            for _, found in pairs(foundParts) do
                table.insert(parts, found)
            end
        end
    end
    return parts
end

local recentComputers = {}

local function getRandomComputer()
    local computerTableModels = findAllPartsByName(game.Workspace, "ComputerTable")

    if #computerTableModels > 0 then
        local validComputers = {}

        for _, computer in pairs(computerTableModels) do
            if not table.find(recentComputers, computer) then
                table.insert(validComputers, computer)
            end
        end

        if #validComputers == 0 then
            recentComputers = {}
            validComputers = computerTableModels
        end

        local randomIndex = math.random(1, #validComputers)
        return validComputers[randomIndex]
    end
    return nil
end

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local chosenComputer = getRandomComputer()

if chosenComputer and chosenComputer.PrimaryPart then
    local targetPosition = chosenComputer.PrimaryPart.Position + Vector3.new(0, 5, 0)
    rootPart.CFrame = CFrame.new(targetPosition)

    table.insert(recentComputers, chosenComputer)
    if #recentComputers > 3 then
        table.remove(recentComputers, 1)
    end
end
end)

maintab:Button("Random Exit TP", function()
local function findAllModelsByName(parent, name)
    local models = {}
    for _, obj in pairs(parent:GetChildren()) do
        if obj.Name == name and obj:IsA("Model") then
            table.insert(models, obj)
        end
        if #obj:GetChildren() > 0 then
            local foundModels = findAllModelsByName(obj, name)
            for _, found in pairs(foundModels) do
                table.insert(models, found)
            end
        end
    end
    return models
end

local exitDoorModels = findAllModelsByName(game.Workspace, "ExitDoor")

if #exitDoorModels > 0 then
    local randomIndex = math.random(1, #exitDoorModels)
    local exitDoor = exitDoorModels[randomIndex]

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    local pivotCFrame = exitDoor:GetPivot()
    local behindDoorCFrame = pivotCFrame * CFrame.new(0, 0, -5)
    rootPart.CFrame = behindDoorCFrame
end
end)

maintab:Button("Random Freezer TP", function()
local function findAllPartsByName(parent, name)
    local parts = {}
    for _, obj in pairs(parent:GetChildren()) do
        if obj.Name == name and obj:IsA("Model") then
            table.insert(parts, obj)
        end
        if #obj:GetChildren() > 0 then
            local foundParts = findAllPartsByName(obj, name)
            for _, found in pairs(foundParts) do
                table.insert(parts, found)
            end
        end
    end
    return parts
end

local freezePodModels = findAllPartsByName(game.Workspace, "FreezePod")

if #freezePodModels > 0 then
    local randomIndex = math.random(1, #freezePodModels)
    local randomFreezePod = freezePodModels[randomIndex]

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    if randomFreezePod.PrimaryPart then
        local targetPosition = randomFreezePod.PrimaryPart.Position + Vector3.new(0, 5, 0)
        rootPart.CFrame = CFrame.new(targetPosition)
    end
end
end)

maintab:Button("Player ESP", function()
local function highlightTorso(player)
    if player ~= game.Players.LocalPlayer then
        local character = player.Character
        if character then
            local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
            if torso then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = torso
                highlight.FillColor = Color3.new(1, 0, 0) -- Red fill
                highlight.OutlineColor = Color3.new(1, 1, 1) -- White outline
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = torso
            end
        end
    end
end

for _, player in pairs(game.Players:GetPlayers()) do
    highlightTorso(player)
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        highlightTorso(player)
    end)
end)
end)

maintab:Button("Computer ESP", function()
local function findModelsByName(parent, name)
    local models = {}
    for _, obj in pairs(parent:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == name then
            table.insert(models, obj)
        end
    end
    return models
end

local function findScreenColor(model)
    for _, obj in pairs(model:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Screen" then
            return obj.Color
        end
    end
    return Color3.fromRGB(255, 255, 255) 
end

local function createESPEffect(model, color)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = model
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model
end

local computerTables = findModelsByName(game.Workspace, "ComputerTable")

for _, computerTable in pairs(computerTables) do
    local screenColor = findScreenColor(computerTable)
    createESPEffect(computerTable, screenColor)
end
end)

maintab:Button("Exit-Door ESP", function()
local function findAllPartsByName(parent, name)
    local parts = {}
    for _, obj in pairs(parent:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == name then
            table.insert(parts, obj)
        end
    end
    return parts
end

local function highlightLight(part)
    if part then
        for _, obj in pairs(part:GetChildren()) do
            if obj:IsA("Highlight") then
                obj:Destroy()
            end
        end

        local highlight = Instance.new("Highlight")
        highlight.Adornee = part
        highlight.FillColor = Color3.new(1, 1, 0)
        highlight.OutlineTransparency = 1
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.5
        highlight.Parent = part
    end
end

local exitDoorModels = findAllPartsByName(game.Workspace, "ExitDoor")

for _, exitDoor in pairs(exitDoorModels) do
    local lightPart = exitDoor:FindFirstChild("Light")
    if lightPart then
        highlightLight(lightPart)
    end
end
end)
funtab:Button("FE Audio Control", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/3dWP6BW4"))()
end)
tpstab:Button("Spawn", function()
    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(111.20410919189453, 8.207777976989746, -413.4593811035156))
end)
tpstab:Button("Map Voting", function()
    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(147.83396911621094, 5.999999523162842, -349.55047607421875))
end)
tpstab:Button("Cave", function()
    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(279.4504089355469, -11.000000953674316, -366.7091369628906))
end)
tpstab:Button("Under Spawn", function()
    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(107, -6, -423))
end)
tpstab:Button("Trading Servers (Min. Level 6)", function()
    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(64.84588623046875, 3.999999761581421, -306.64068603515625))
end)
funtab:Button("Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
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