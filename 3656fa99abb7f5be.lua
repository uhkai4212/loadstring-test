local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")

local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer

local HRP, Character, Humanoid

local function refreshCharacter()

    Character = LP.Character or LP.CharacterAdded:Wait()

    HRP = Character:WaitForChild("HumanoidRootPart")

    Humanoid = Character:WaitForChild("Humanoid")

end

refreshCharacter()

LP.CharacterAdded:Connect(refreshCharacter)

local AutoEquipOnce = false

local AutoUpgradeBow = false

local AutoUpgradeSword = false

local AutoPlaceBlocks = false

local AutoPlaceFurniture = false

local TeleportAll = false

local ESPSkeleton = false

local AutoDay = false

local AutoNight = false

local AutoDamageAll = false

local InfJump = false

local Noclip = false

local HasEquipped = false

local ESPObjects = {}

local function GetValidTargets()

    local targets = {}

    for _, player in pairs(Players:GetPlayers()) do

        if player ~= LP and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then

            table.insert(targets, player.Character)

        end

    end

    if Workspace:FindFirstChild("Monsters") then

        for _, monster in pairs(Workspace.Monsters:GetChildren()) do

            if monster:FindFirstChild("Humanoid") and monster:FindFirstChild("HumanoidRootPart") then

                table.insert(targets, monster)

            end

        end

    end

    return targets

end

local function BuildHouse()

    local basePos = HRP.Position + Vector3.new(0, 0, 10)

    local blockRemote = ReplicatedStorage.Networker.Remotes:FindFirstChild("BlockReliable")

    if blockRemote then

        for x = -2, 2 do

            for z = -2, 2 do

                for y = 0, 2 do

                    if y == 2 and (x > -2 and x < 2 and z > -2 and z < 2) then

                        continue

                    end

                    if x == -2 or x == 2 or z == -2 or z == 2 or y == 0 then

                        pcall(function()

                            blockRemote:FireServer(

                                {

                                    rotation = 0,

                                    selectedBlock = {

                                        order = 1,

                                        model = game:GetService("ReplicatedStorage").Components.Blocks["Light Gray"],

                                        category = "block"

                                    },

                                    gridPosition = Vector3.new(basePos.X + x * 4, basePos.Y + y * 4, basePos.Z + z * 4)

                                },

                                "Place"

                            )

                        end)

                    end

                end

            end

        end

    end

end

local function PlaceFurniture()

    local basePos = HRP.Position + Vector3.new(0, 0, 10)

    local blockRemote = ReplicatedStorage.Networker.Remotes:FindFirstChild("BlockReliable")

    if blockRemote then

        local positions = {

            Vector3.new(basePos.X - 4, basePos.Y, basePos.Z - 4),

            Vector3.new(basePos.X + 4, basePos.Y, basePos.Z - 4),

            Vector3.new(basePos.X - 4, basePos.Y, basePos.Z + 4),

            Vector3.new(basePos.X + 4, basePos.Y, basePos.Z + 4)

        }

        for _, pos in ipairs(positions) do

            pcall(function()

                blockRemote:FireServer(

                    {

                        rotation = 270,

                        selectedBlock = {

                            order = 13,

                            model = game:GetService("ReplicatedStorage").Components.Blocks.Drawer,

                            category = "furniture"

                        },

                        gridPosition = pos

                    },

                    "Place"

                )

            end)

        end

    end

end

local function CreateESP(character)

    if ESPObjects[character] then

        return

    end

    local espHolder = Instance.new("Folder")

    espHolder.Name = "ESP_" .. character.Name

    espHolder.Parent = character

    local billboard = Instance.new("BillboardGui")

    billboard.Name = "ESPBillboard"

    billboard.Adornee = character:FindFirstChild("HumanoidRootPart")

    billboard.Size = UDim2.new(0, 100, 0, 50)

    billboard.StudsOffset = Vector3.new(0, 3, 0)

    billboard.AlwaysOnTop = true

    billboard.Parent = espHolder

    local nameLabel = Instance.new("TextLabel")

    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)

    nameLabel.BackgroundTransparency = 1

    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    nameLabel.TextStrokeTransparency = 0

    nameLabel.Text = character.Name

    nameLabel.TextScaled = true

    nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")

    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)

    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)

    distanceLabel.BackgroundTransparency = 1

    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    distanceLabel.TextStrokeTransparency = 0

    distanceLabel.Text = "0 studs"

    distanceLabel.TextScaled = true

    distanceLabel.Parent = billboard

    local lines = {}

    local function addLine(fromPart, toPart, color)

        local line = Instance.new("LineHandleAdornment")

        line.Name = fromPart.Name .. "To" .. toPart.Name

        line.Adornee = fromPart

        line.Color3 = color

        line.Thickness = 2

        line.Length = (fromPart.Position - toPart.Position).Magnitude

        line.CFrame = CFrame.new(Vector3.new(0, 0, 0), toPart.Position - fromPart.Position)

        line.Parent = espHolder

        return line

    end

    if character:FindFirstChild("Head") and character:FindFirstChild("Torso") then

        table.insert(lines, addLine(character.Head, character.Torso, Color3.fromRGB(0, 255, 0)))

    end

    if character:FindFirstChild("Torso") and character:FindFirstChild("Left Arm") then

        table.insert(lines, addLine(character.Torso, character["Left Arm"], Color3.fromRGB(0, 255, 0)))

    end

    if character:FindFirstChild("Torso") and character:FindFirstChild("Right Arm") then

        table.insert(lines, addLine(character.Torso, character["Right Arm"], Color3.fromRGB(0, 255, 0)))

    end

    if character:FindFirstChild("Torso") and character:FindFirstChild("Left Leg") then

        table.insert(lines, addLine(character.Torso, character["Left Leg"], Color3.fromRGB(0, 255, 0)))

    end

    if character:FindFirstChild("Torso") and character:FindFirstChild("Right Leg") then

        table.insert(lines, addLine(character.Torso, character["Right Leg"], Color3.fromRGB(0, 255, 0)))

    end

    ESPObjects[character] = {Holder = espHolder, DistanceLabel = distanceLabel, Lines = lines}

end

local function RemoveESP(character)

    if ESPObjects[character] then

        ESPObjects[character].Holder:Destroy()

        ESPObjects[character] = nil

    end

end

local function UpdateESP()

    if not ESPSkeleton then

        for character, _ in pairs(ESPObjects) do

            RemoveESP(character)

        end

        return

    end

    for _, character in pairs(GetValidTargets()) do

        if not ESPObjects[character] then

            CreateESP(character)

        end

        if ESPObjects[character] and HRP then

            local distance = (HRP.Position - character.HumanoidRootPart.Position).Magnitude

            ESPObjects[character].DistanceLabel.Text = math.floor(distance) .. " studs"

            for _, line in ipairs(ESPObjects[character].Lines) do

                local fromPart = character:FindFirstChild(line.Name:match("^(.*)To"))

                local toPart = character:FindFirstChild(line.Name:match("To(.*)$"))

                if fromPart and toPart then

                    line.Length = (fromPart.Position - toPart.Position).Magnitude

                    line.CFrame = CFrame.new(Vector3.new(0, 0, 0), toPart.Position - fromPart.Position)

                end

            end

        end

    end

    for character, _ in pairs(ESPObjects) do

        if not table.find(GetValidTargets(), character) then

            RemoveESP(character)

        end

    end

end

local ReGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/main/ReGui.lua"))()

local UI = ReGui:TabsWindow({

    Title = "Game Tools",

    Size = UDim2.fromOffset(250, 200),

    Position = UDim2.fromOffset(30, 30),

})

local TabMain = UI:CreateTab({ Name = "Main" })

local TabMovement = UI:CreateTab({ Name = "Movement" })

local TabVisual = UI:CreateTab({ Name = "Visual" })

local mainHeader = TabMain:CollapsingHeader({ Title = "Main" })

mainHeader:Checkbox({

    Label = "Auto Equip Once",

    Value = false,

    Callback = function(_, v)

        AutoEquipOnce = v

        HasEquipped = false

    end

})

mainHeader:Checkbox({

    Label = "Auto Upgrade Bow",

    Value = false,

    Callback = function(_, v)

        AutoUpgradeBow = v

    end

})

mainHeader:Checkbox({

    Label = "Auto Upgrade Sword",

    Value = false,

    Callback = function(_, v)

        AutoUpgradeSword = v

    end

})

mainHeader:Checkbox({

    Label = "Auto Place Blocks",

    Value = false,

    Callback = function(_, v)

        AutoPlaceBlocks = v

        if v then

            BuildHouse()

        end

    end

})

mainHeader:Checkbox({

    Label = "Auto Place Furniture",

    Value = false,

    Callback = function(_, v)

        AutoPlaceFurniture = v

        if v then

            PlaceFurniture()

        end

    end

})

mainHeader:Checkbox({

    Label = "Teleport All Players and Monsters",

    Value = false,

    Callback = function(_, v)

        TeleportAll = v

    end

})

mainHeader:Checkbox({

    Label = "Auto Day",

    Value = false,

    Callback = function(_, v)

        AutoDay = v

        if v then

            AutoNight = false

        end

    end

})

mainHeader:Checkbox({

    Label = "Auto Night",

    Value = false,

    Callback = function(_, v)

        AutoNight = v

        if v then

            AutoDay = false

        end

    end

})

mainHeader:Checkbox({

    Label = "Auto Damage All",

    Value = false,

    Callback = function(_, v)

        AutoDamageAll = v

    end

})

local visualHeader = TabVisual:CollapsingHeader({ Title = "Visual" })

visualHeader:Checkbox({

    Label = "ESP Skeleton",

    Value = false,

    Callback = function(_, v)

        ESPSkeleton = v

        if not v then

            for character, _ in pairs(ESPObjects) do

                RemoveESP(character)

            end

        end

    end

})

local moveHeader = TabMovement:CollapsingHeader({ Title = "Movement" })

moveHeader:SliderFloat({

    Label = "WalkSpeed",

    Minimum = 16,

    Maximum = 200,

    Value = 16,

    Callback = function(_, v)

        if Humanoid then

            Humanoid.WalkSpeed = v

        end

    end

})

moveHeader:SliderFloat({

    Label = "JumpPower",

    Minimum = 50,

    Maximum = 300,

    Value = 50,

    Callback = function(_, v)

        if Humanoid then

            Humanoid.JumpPower = v

        end

    end

})

moveHeader:Checkbox({

    Label = "Inf Jump",

    Value = false,

    Callback = function(_, v)

        InfJump = v

    end

})

moveHeader:Checkbox({

    Label = "Noclip",

    Value = false,

    Callback = function(_, v)

        Noclip = v

    end

})

RunService.Heartbeat:Connect(function()

    if AutoEquipOnce and not HasEquipped and ReplicatedStorage:FindFirstChild("Networker") then

        local hotbarRemote = ReplicatedStorage.Networker.Remotes:FindFirstChild("HotbarRemote")

        if hotbarRemote then

            pcall(function()

                hotbarRemote:FireServer("Sword", "PlayerEquip")

            end)

            HasEquipped = true

        end

    end

    if AutoUpgradeBow and ReplicatedStorage:FindFirstChild("Networker") then

        local upgradeRemote = ReplicatedStorage.Networker.Remotes:FindFirstChild("Upgrade")

        if upgradeRemote then

            pcall(function()

                upgradeRemote:FireServer("Bow", "Update")

            end)

        end

    end

    if AutoUpgradeSword and ReplicatedStorage:FindFirstChild("Networker") then

        local upgradeRemote = ReplicatedStorage.Networker.Remotes:FindFirstChild("Upgrade")

        if upgradeRemote then

            pcall(function()

                upgradeRemote:FireServer("Sword", "Update")

            end)

        end

    end

    if TeleportAll and Character and HRP then

        for _, target in pairs(GetValidTargets()) do

            local targetHRP = target:FindFirstChild("HumanoidRootPart")

            if targetHRP then

                targetHRP.CFrame = HRP.CFrame * CFrame.new(0, 0, -5)

            end

        end

    end

    if AutoDay and ReplicatedStorage:FindFirstChild("Networker") then

        local cycleRemote = ReplicatedStorage.Networker.Remotes:FindFirstChild("DayNightCycle")

        if cycleRemote then

            pcall(function()

                firesignal(cycleRemote.OnClientEvent, {

                    nightTime = 180,

                    startTick = tick(),

                    spawnCooldown = 5,

                    cycleTime = 360,

                    dayTime = 360,

                    cycleType = "Day"

                }, "SetCycleData")

            end)

        end

    end

    if AutoNight and ReplicatedStorage:FindFirstChild("Networker") then

        local cycleRemote = ReplicatedStorage.Networker.Remotes:FindFirstChild("DayNightCycle")

        if cycleRemote then

            pcall(function()

                firesignal(cycleRemote.OnClientEvent, {

                    nightTime = 360,

                    startTick = tick(),

                    spawnCooldown = 5,

                    cycleTime = 360,

                    dayTime = 180,

                    cycleType = "Night"

                }, "SetCycleData")

            end)

        end

    end

    if AutoDamageAll and ReplicatedStorage:FindFirstChild("Networker") then

        local bowRemote = ReplicatedStorage.Networker.Remotes:FindFirstChild("Bow")

        if bowRemote then

            for _, target in pairs(GetValidTargets()) do

                local targetHumanoid = target:FindFirstChild("Humanoid")

                if targetHumanoid then

                    pcall(function()

                        bowRemote:FireServer(

                            {

                                humanoid = targetHumanoid,

                                damage = 999

                            },

                            "DamageHumanoid"

                        )

                    end)

                end

            end

        end

    end

    if Noclip and Character then

        for _, part in pairs(Character:GetDescendants()) do

            if part:IsA("BasePart") then

                part.CanCollide = false

            end

        end

    end

    if ESPSkeleton then

        UpdateESP()

    end

end)

UserInputService.JumpRequest:Connect(function()

    if InfJump and Humanoid then

        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

    end

end)

game.StarterGui:SetCore("SendNotification", {

    Title = "Game Tools",

    Text = "Loaded!",

    Duration = 5

})