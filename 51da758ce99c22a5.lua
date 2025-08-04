local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Locals
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local CoreGui = game:GetService("CoreGui")

function gradient(text, startColor, endColor)
    local result = ""
    local length = #text

    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)

        local char = text:sub(i, i)
        result = result .. "<font color=\"rgb(" .. r ..", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
    end

    return result
end

local Confirmed = false

WindUI:Popup({
    Title = gradient("PRIVATE SCRIPT", Color3.fromHex("#eb1010"), Color3.fromHex("#1023eb")),
    Icon = "info",
    Content = gradient("This script made by", Color3.fromHex("#10eb3c"), Color3.fromHex("#67c97a")) .. gradient(" SnowT", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Buttons = {
        {
            Title = gradient("Cancel", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
            Callback = function() end,
            Variant = "Tertiary", -- Primary, Secondary, Tertiary
        },
        {
            Title = gradient("Load", Color3.fromHex("#90f09e"), Color3.fromHex("#13ed34")),
            Callback = function() Confirmed = true end,
            Variant = "Secondary", -- Primary, Secondary, Tertiary
        }
    }
})

repeat task.wait() until Confirmed

WindUI:Notify({
    Title = gradient("SCRIPT SYSTEM", Color3.fromHex("#eb1010"), Color3.fromHex("#1023eb")),
    Content = "Script succesful loaded",
    Icon = "check-circle",
    Duration = 3,
})

-- Window
local Window = WindUI:CreateWindow({
    Title = gradient("PRIVATE SCRIPT", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Icon = "infinity",
    Author = gradient("MurderersVsSheriffs", Color3.fromHex("#1bf2b2"), Color3.fromHex("#1bcbf2")),
    Folder = "WindUI",
    Size = UDim2.fromOffset(300, 270),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    UserEnabled = true,
    HasOutline = true,
})

-- Open Button
Window:EditOpenButton({
    Title = "Open UI",
    Icon = "monitor",
    CornerRadius = UDim.new(2, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("1E213D"),
        Color3.fromHex("1F75FE")
    ),
    Draggable = true,
})

-- Tabs
local Tabs = {
    MainTab = Window:Tab({ Title = gradient("MAIN", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "terminal" }),
    CharacterTab = Window:Tab({ Title = gradient("CHARACTER", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "file-cog" }),
    TeleportTab = Window:Tab({ Title = gradient("TELEPORT", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "user" }),
    EspTab = Window:Tab({ Title = gradient("ESP", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "eye" }),
    AimbotTab = Window:Tab({ Title = gradient("AIMBOT", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "arrow-right" }),
    HitboxTab = Window:Tab({ Title = gradient("HITBOXES", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "user"}),
}

-- Character
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local CharacterSettings = {
    WalkSpeed = {Value = 16, Default = 16, Locked = false},
    JumpPower = {Value = 50, Default = 50, Locked = false}
}

local function updateCharacter()
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if not CharacterSettings.WalkSpeed.Locked then
            humanoid.WalkSpeed = CharacterSettings.WalkSpeed.Value
        end
        if not CharacterSettings.JumpPower.Locked then
            humanoid.JumpPower = CharacterSettings.JumpPower.Value
        end
    end
end
Tabs.CharacterTab:Section({Title = gradient("Walkspeed", Color3.fromHex("#ff0000"), Color3.fromHex("#300000"))})

Tabs.CharacterTab:Slider({
    Title = "Walkspeed",
    Value = {Min = 0, Max = 200, Default = 16},
    Callback = function(value)
        CharacterSettings.WalkSpeed.Value = value
        updateCharacter()
    end
})

Tabs.CharacterTab:Button({
    Title = "Reset walkspeed",
    Callback = function()
        CharacterSettings.WalkSpeed.Value = CharacterSettings.WalkSpeed.Default
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Block walkspeed",
    Default = false,
    Callback = function(state)
        CharacterSettings.WalkSpeed.Locked = state
        updateCharacter()
    end
})

Tabs.CharacterTab:Section({Title = gradient("JumpPower", Color3.fromHex("#001aff"), Color3.fromHex("#020524"))})

Tabs.CharacterTab:Slider({
    Title = "Jumppower",
    Value = {Min = 0, Max = 200, Default = 50},
    Callback = function(value)
        CharacterSettings.JumpPower.Value = value
        updateCharacter()
    end
})


Tabs.CharacterTab:Button({
    Title = "Reset jumppower",
    Callback = function()
        CharacterSettings.JumpPower.Value = CharacterSettings.JumpPower.Default
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Block jumppower",
    Default = false,
    Callback = function(state)
        CharacterSettings.JumpPower.Locked = state
        updateCharacter()
    end
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Teleport
Tabs.TeleportTab:Section({Title = gradient("Teleport to players", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))})

local teleportTarget = nil
local teleportDropdown = nil

local function updateTeleportPlayers()
    local playersList = {"Select Player"}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playersList, player.Name)
        end
    end
    return playersList
end

local function initializeTeleportDropdown()
    teleportDropdown = Tabs.TeleportTab:Dropdown({
        Title = "Players",
        Values = updateTeleportPlayers(),
        Value = "Select Player",
        Callback = function(selected)
            if selected ~= "Select Player" then
                teleportTarget = Players:FindFirstChild(selected)
            else
                teleportTarget = nil
            end
        end
    })
end

-- Вместо старого кода инициализации телепорта вызываем:
initializeTeleportDropdown()

-- Обновляем обработчики событий игроков:
Players.PlayerAdded:Connect(function(player)
    task.wait(1) -- Даем время на инициализацию игрока
    if teleportDropdown then
        teleportDropdown:Refresh(updateTeleportPlayers())
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if teleportDropdown then
        teleportDropdown:Refresh(updateTeleportPlayers())
    end
end)

local function teleportToPlayer()
    if teleportTarget and teleportTarget.Character then
        local targetRoot = teleportTarget.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and localRoot then
            localRoot.CFrame = targetRoot.CFrame
            WindUI:Notify({
                Title = "Teleport system",
                Content = "Teleport to "..teleportTarget.Name,
                Icon = "check-circle",
                Duration = 3
            })
        end
    else
        WindUI:Notify({
            Title = "Error",
            Content = "Target not found",
            Icon = "x-circle",
            Duration = 3
        })
    end
end

Tabs.TeleportTab:Button({
    Title = "Teleport to player",
    Callback = teleportToPlayer
})

Tabs.TeleportTab:Button({
    Title = "Update players list",
    Callback = function()
        teleportDropdown:Refresh(updateTeleportPlayers())
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local espSettings = {
    MaxDistance = 150,
    HighlightColor = Color3.fromRGB(255, 0, 0),
    NameColor = Color3.fromRGB(255, 255, 255),
    ShowNames = true,
    ShowDistance = true,
    HighlightEnabled = false,
    HighlightTransparency = 0.5,
    NameSize = 15,
    DistanceSize = 15,
    DistanceColor = Color3.fromRGB(255, 255, 255)
}

local espElements = {}

local function isPlayerAlive(player)
    local character = player.Character
    if not character then return false end
    local humanoid = character:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function getPlayerDistance(player)
    if not player.Character or not LocalPlayer.Character then return math.huge end
    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not localRoot then return math.huge end
    return (targetRoot.Position - localRoot.Position).Magnitude
end

local function updateEspElements()
    for player, elements in pairs(espElements) do
        if elements.Highlight then
            elements.Highlight.Enabled = espSettings.HighlightEnabled
            elements.Highlight.FillColor = espSettings.HighlightColor
            elements.Highlight.FillTransparency = espSettings.HighlightTransparency
            elements.Highlight.OutlineColor = espSettings.HighlightColor
        end
        
        if elements.Billboard then
            for _, child in ipairs(elements.Billboard:GetChildren()) do
                if child:IsA("TextLabel") then
                    if string.find(child.Text, player.Name) then -- Name label
                        child.TextSize = espSettings.NameSize
                        child.TextColor3 = espSettings.NameColor
                        child.Visible = espSettings.ShowNames
                    else -- Distance label
                        child.TextSize = espSettings.DistanceSize
                        child.TextColor3 = espSettings.DistanceColor
                        child.Visible = espSettings.ShowDistance
                    end
                end
            end
        end
    end
end

local function createEsp(player)
    if player == LocalPlayer or not isPlayerAlive(player) then
        if espElements[player] then
            espElements[player].Highlight:Destroy()
            if espElements[player].Billboard then
                espElements[player].Billboard:Destroy()
            end
            espElements[player] = nil
        end
        return
    end

    local distance = getPlayerDistance(player)
    if distance > espSettings.MaxDistance then
        if espElements[player] then
            espElements[player].Highlight:Destroy()
            if espElements[player].Billboard then
                espElements[player].Billboard:Destroy()
            end
            espElements[player] = nil
        end
        return
    end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    if not espElements[player] then
        espElements[player] = {}

        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.FillColor = espSettings.HighlightColor
        highlight.FillTransparency = espSettings.HighlightTransparency
        highlight.OutlineColor = espSettings.HighlightColor
        highlight.OutlineTransparency = 0
        highlight.Enabled = espSettings.HighlightEnabled
        highlight.Parent = CoreGui
        espElements[player].Highlight = highlight

        if espSettings.ShowNames or espSettings.ShowDistance then
            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = character:FindFirstChild("HumanoidRootPart")
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = CoreGui
            espElements[player].Billboard = billboard

            if espSettings.ShowNames then
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0, 25)
                nameLabel.Position = UDim2.new(0, 0, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = espSettings.NameColor
                nameLabel.TextSize = espSettings.NameSize
                nameLabel.Font = Enum.Font.SourceSansBold
                nameLabel.TextStrokeTransparency = 0.5
                nameLabel.Visible = espSettings.ShowNames
                nameLabel.Parent = billboard
            end

            if espSettings.ShowDistance then
                local offset = espSettings.ShowNames and 25 or 0
                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.Size = UDim2.new(1, 0, 0, 25)
                distanceLabel.Position = UDim2.new(0, 0, 0, offset)
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.Text = ""
                distanceLabel.TextColor3 = espSettings.DistanceColor
                distanceLabel.TextSize = espSettings.DistanceSize
                distanceLabel.Font = Enum.Font.SourceSansBold
                distanceLabel.TextStrokeTransparency = 0.5
                distanceLabel.Visible = espSettings.ShowDistance
                distanceLabel.Parent = billboard
                espElements[player].DistanceLabel = distanceLabel
            end
        end
    end

    if espElements[player] and espElements[player].DistanceLabel then
        espElements[player].DistanceLabel.Text = math.floor(distance) .. " studs"
    end
end

-- Highlight Settings
Tabs.EspTab:Section({
    Title = gradient("Highlight Settings", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9"))
})

Tabs.EspTab:Toggle({
    Title = gradient("Enable Highlight", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Default = false,
    Callback = function(state)
        espSettings.HighlightEnabled = state
        updateEspElements()
    end
})

Tabs.EspTab:Slider({
    Title = gradient("Highlight Transparency", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        espSettings.HighlightTransparency = value
        updateEspElements()
    end
})

Tabs.EspTab:Colorpicker({
    Title = gradient("Highlight Color", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0,
    Callback = function(color)
        espSettings.HighlightColor = color
        updateEspElements()
    end
})

-- Name ESP Settings
Tabs.EspTab:Section({
    Title = gradient("Name ESP Settings", Color3.fromHex("#e80909"), Color3.fromHex("#630404"))
})

Tabs.EspTab:Toggle({
    Title = gradient("Enable Names", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Default = false,
    Callback = function(state)
        espSettings.ShowNames = state
        updateEspElements()
    end
})

Tabs.EspTab:Slider({
    Title = gradient("Name Size", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Value = {Min = 5, Max = 25, Default = 15},
    Callback = function(value)
        espSettings.NameSize = value
        updateEspElements()
    end
})

Tabs.EspTab:Colorpicker({
    Title = gradient("Name Color", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0,
    Callback = function(color)
        espSettings.NameColor = color
        updateEspElements()
    end
})

-- Distance ESP Settings
Tabs.EspTab:Section({
    Title = gradient("Distance ESP Settings", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c"))
})

Tabs.EspTab:Toggle({
    Title = gradient("Enable Distance", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c")),
    Default = false,
    Callback = function(state)
        espSettings.ShowDistance = state
        updateEspElements()
    end
})

Tabs.EspTab:Slider({
    Title = gradient("Distance Size", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c")),
    Value = {Min = 5, Max = 25, Default = 15},
    Callback = function(value)
        espSettings.DistanceSize = value
        updateEspElements()
    end
})

Tabs.EspTab:Colorpicker({
    Title = gradient("Distance Color", Color3.fromHex("#0ff707"), Color3.fromHex("#1e690c")),
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0,
    Callback = function(color)
        espSettings.DistanceColor = color
        updateEspElements()
    end
})

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        createEsp(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if espElements[player] then
        espElements[player].Highlight:Destroy()
        if espElements[player].Billboard then
            espElements[player].Billboard:Destroy()
        end
        espElements[player] = nil
    end
end)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- Aimbot
local aimbotSettings = {
    Enabled = false,
    Smoothness = 30, -- Максимальная фиксация
    WallCheck = true,
    TargetPart = "Head",
    MaxDistance = 150,
    TeamCheck = true,
    FOVEnabled = false,
    FOVSize = 60, -- Размер в пикселях
    FOVColor = Color3.fromRGB(255, 0, 0),
    FOVTransparency = 0.7,
    ShowFOV = true,
    LockInFOV = true
}

local targetPartOptions = {"Head", "HumanoidRootPart", "UpperTorso"}
local fovCircle = nil

-- Создаем 2D FOV круг на экране
local function createFOVCircle()
    if fovCircle then fovCircle:Destroy() end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "AimbotFOV"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui
    
    fovCircle = Instance.new("Frame")
    fovCircle.Name = "FOVCircle"
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    fovCircle.Size = UDim2.new(0, aimbotSettings.FOVSize*2, 0, aimbotSettings.FOVSize*2)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Parent = gui
    
    local circle = Instance.new("UICorner")
    circle.CornerRadius = UDim.new(1, 0)
    circle.Parent = fovCircle
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = aimbotSettings.FOVColor
    stroke.Transparency = aimbotSettings.FOVTransparency
    stroke.Thickness = 1
    stroke.Parent = fovCircle
    
    fovCircle.Visible = aimbotSettings.ShowFOV and aimbotSettings.FOVEnabled
end

-- Функция для определения команды игрока
local function getPlayerTeam(player)
    local quillGreyChannel = game:GetService("TextChatService").TextChannels:FindFirstChild("RBXTeamQuill grey")
    if quillGreyChannel and quillGreyChannel:FindFirstChild(player.Name) then
        return "Quill grey"
    end
    
    local lilyWhiteChannel = game:GetService("TextChatService").TextChannels:FindFirstChild("RBXTeamLily white")
    if lilyWhiteChannel and lilyWhiteChannel:FindFirstChild(player.Name) then
        return "Lily white"
    end
    
    return nil
end

local function isEnemy(player)
    if not aimbotSettings.TeamCheck then return true end
    
    local localTeam = getPlayerTeam(LocalPlayer)
    local playerTeam = getPlayerTeam(player)
    
    if not localTeam or not playerTeam then return true end
    return localTeam ~= playerTeam
end

local function isInFOV(targetPosition)
    if not aimbotSettings.FOVEnabled or not aimbotSettings.LockInFOV then return true end
    
    local camera = Workspace.CurrentCamera
    local viewportSize = camera.ViewportSize
    local screenPoint = camera:WorldToViewportPoint(targetPosition)
    local center = Vector2.new(viewportSize.X/2, viewportSize.Y/2)
    local point = Vector2.new(screenPoint.X, screenPoint.Y)
    
    local distance = (point - center).Magnitude
    return distance <= aimbotSettings.FOVSize
end

local function getClosestEnemy()
    local closestPlayer = nil
    local closestDistance = aimbotSettings.MaxDistance
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isPlayerAlive(player) and isEnemy(player) then
            local distance = getPlayerDistance(player)
            if distance < closestDistance then
                local character = player.Character
                if character then
                    local targetPart = character:FindFirstChild(aimbotSettings.TargetPart)
                    if targetPart then
                        if not isInFOV(targetPart.Position) then continue end
                        
                        if aimbotSettings.WallCheck then
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
                            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                            
                            local origin = CurrentCamera.CFrame.Position
                            local direction = (targetPart.Position - origin).Unit
                            local raycastResult = Workspace:Raycast(origin, direction * distance, raycastParams)
                            
                            if not raycastResult then
                                closestPlayer = player
                                closestDistance = distance
                            end
                        else
                            closestPlayer = player
                            closestDistance = distance
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAtTarget(target)
    if not target or not target.Character then return end
    
    local targetPart = target.Character:FindFirstChild(aimbotSettings.TargetPart)
    if not targetPart then return end
    
    local camera = Workspace.CurrentCamera
    local cameraPosition = camera.CFrame.Position
    local targetPosition = targetPart.Position
    
    if aimbotSettings.TargetPart == "Head" then
        targetPosition = targetPosition + Vector3.new(0, 0.2, 0)
    end
    
    local direction = (targetPosition - cameraPosition).Unit
    -- Почти мгновенная фиксация
    local newCFrame = CFrame.new(cameraPosition, cameraPosition + direction)
    
    camera.CFrame = camera.CFrame:Lerp(newCFrame, 0.9) -- Сильная фиксация
end

-- Aimbot Tab
Tabs.AimbotTab:Section({
    Title = gradient("Aimbot", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))
})

Tabs.AimbotTab:Toggle({
    Title = "AimLock",
    Default = false,
    Callback = function(state)
        aimbotSettings.Enabled = state
    end
})

Tabs.AimbotTab:Toggle({
    Title = "FOV Circle",
    Default = false,
    Callback = function(state)
        aimbotSettings.FOVEnabled = state
        if state then
            createFOVCircle()
        elseif fovCircle then
            fovCircle.Parent:Destroy()
            fovCircle = nil
        end
    end
})

Tabs.AimbotTab:Section({
    Title = gradient("Aimbot Settings", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))
})

Tabs.AimbotTab:Slider({
    Title = "FOV Size",
    Step = 5,
    Value = {Min = 30, Max = 200, Default = 60},
    Callback = function(value)
        aimbotSettings.FOVSize = value
        if fovCircle then
            fovCircle.Size = UDim2.new(0, value*2, 0, value*2)
        end
    end
})

Tabs.AimbotTab:Toggle({
    Title = "Lock In FOV",
    Default = true,
    Callback = function(state)
        aimbotSettings.LockInFOV = state
    end
})

Tabs.AimbotTab:Toggle({
    Title = "Show FOV",
    Default = true,
    Callback = function(state)
        aimbotSettings.ShowFOV = state
        if fovCircle then
            fovCircle.Visible = state and aimbotSettings.FOVEnabled
        end
    end
})

Tabs.AimbotTab:Colorpicker({
    Title = "FOV Color",
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0.7,
    Callback = function(color, transparency)
        aimbotSettings.FOVColor = color
        aimbotSettings.FOVTransparency = transparency
        if fovCircle then
            fovCircle.UIStroke.Color = color
            fovCircle.UIStroke.Transparency = transparency
        end
    end
})

Tabs.AimbotTab:Toggle({
    Title = "Wall Check",
    Default = true,
    Callback = function(state)
        aimbotSettings.WallCheck = state
    end
})

Tabs.AimbotTab:Toggle({
    Title = "Team Check",
    Default = true,
    Callback = function(state)
        aimbotSettings.TeamCheck = state
    end
})

Tabs.AimbotTab:Slider({
    Title = "Max Distance",
    Step = 10,
    Value = {Min = 50, Max = 500, Default = 150},
    Callback = function(value)
        aimbotSettings.MaxDistance = value
    end
})

Tabs.AimbotTab:Dropdown({
    Title = "Target part",
    Values = targetPartOptions,
    Value = "Head",
    Callback = function(option)
        aimbotSettings.TargetPart = option
    end
})

print("Loaded")

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    if aimbotSettings.Enabled and LocalPlayer.Character then
        local target = getClosestEnemy()
        if target then
            aimAtTarget(target)
        end
    end
end)

print("Loaded")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Local player
local Player = Players.LocalPlayer

-- Hitbox settings
local HB_Settings = {
    Enabled = false,
    ShowHitboxes = false,
    Size = 5,
    Color = Color3.fromRGB(255, 0, 0),
    Transparency = 0.5
}

-- Store original properties for reverting
local originalProperties = {}

-- Function to apply hitbox changes
local function applyHitboxChanges()
    while HB_Settings.Enabled do
        wait(0.1)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Team ~= Player.Team then
                local character = plr.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        -- Store original properties if not already stored
                        if not originalProperties[plr] then
                            originalProperties[plr] = {
                                Size = hrp.Size,
                                Transparency = hrp.Transparency,
                                Color = hrp.Color
                            }
                        end
                        -- Apply hitbox settings
                        hrp.Size = Vector3.new(HB_Settings.Size, HB_Settings.Size, HB_Settings.Size)
                        hrp.CanCollide = false
                        hrp.Transparency = HB_Settings.ShowHitboxes and HB_Settings.Transparency or 1
                        hrp.Color = HB_Settings.Color
                    end
                end
            end
        end
    end

    -- Revert changes when disabled
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Team ~= Player.Team then
            local character = plr.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp and originalProperties[plr] then
                    hrp.Size = originalProperties[plr].Size
                    hrp.Transparency = originalProperties[plr].Transparency
                    hrp.Color = originalProperties[plr].Color
                    hrp.CanCollide = false
                end
            end
        end
    end
    -- Clear stored properties
    originalProperties = {}
end

-- Function to handle player and character addition
local function setupPlayer(player)
    player.CharacterAdded:Connect(function(character)
        if HB_Settings.Enabled then
            -- Apply hitbox changes to new character
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp and player ~= Player and player.Team ~= Player.Team then
                originalProperties[player] = {
                    Size = hrp.Size,
                    Transparency = hrp.Transparency,
                    Color = hrp.Color
                }
                hrp.Size = Vector3.new(HB_Settings.Size, HB_Settings.Size, HB_Settings.Size)
                hrp.CanCollide = false
                hrp.Transparency = HB_Settings.ShowHitboxes and HB_Settings.Transparency or 1
                hrp.Color = HB_Settings.Color
            end
        end
    end)
end

-- Initialize UI
Tabs.HitboxTab:Section({
    Title = gradient("Hitboxes", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))
})

Tabs.HitboxTab:Toggle({
    Title = "Enable Hitbox",
    Default = false,
    Callback = function(state)
        HB_Settings.Enabled = state
        if state then
            -- Start hitbox changes and connect players
            for _, plr in ipairs(Players:GetPlayers()) do
                setupPlayer(plr)
            end
            Players.PlayerAdded:Connect(setupPlayer)
            spawn(applyHitboxChanges)
        else
            -- Revert changes will be handled by applyHitboxChanges
            originalProperties = {}
        end
    end
})

Tabs.HitboxTab:Section({
    Title = gradient("Hitbox Settings", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))
})

Tabs.HitboxTab:Toggle({
    Title = "Show hitboxes",
    Default = false,
    Callback = function(state)
        HB_Settings.ShowHitboxes = state
        -- Update transparency for all affected players
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Team ~= Player.Team then
                local character = plr.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Transparency = state and HB_Settings.Transparency or 1
                    end
                end
            end
        end
    end
})

Tabs.HitboxTab:Slider({
    Title = "Hitbox Size",
    Value = {Min = 1, Max = 250, Default = 5, Step = 0.1},
    Callback = function(value)
        HB_Settings.Size = value
        -- Update size for all affected players
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Team ~= Player.Team then
                local character = plr.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(value, value, value)
                    end
                end
            end
        end
    end
})

Tabs.HitboxTab:Colorpicker({
    Title = "Hitbox Color",
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0.5,
    Callback = function(color, transparency)
        HB_Settings.Color = color
        HB_Settings.Transparency = transparency
        -- Update color and transparency for all affected players
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Team ~= Player.Team then
                local character = plr.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Color = color
                        hrp.Transparency = HB_Settings.ShowHitboxes and transparency or 1
                    end
                end
            end
        end
    end
})

Tabs.HitboxTab:Slider({
    Title = "Hitbox Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        HB_Settings.Transparency = value
        -- Update transparency for all affected players
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Team ~= Player.Team then
                local character = plr.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Transparency = HB_Settings.ShowHitboxes and value or 1
                    end
                end
            end
        end
    end
})