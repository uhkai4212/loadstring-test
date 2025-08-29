local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local WeaponHitEvent = ReplicatedStorage:WaitForChild("WeaponsSystem"):WaitForChild("Network"):WaitForChild("WeaponHit")
local currentCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
LocalPlayer.CharacterAdded:Connect(function(char)
    currentCharacter = char
end)

local SoundId = "rbxassetid://110168723447153"
local soundTemplate = Instance.new("Sound")
soundTemplate.SoundId = SoundId
soundTemplate.Volume = 5

local SoundEnabled = true

local function monitorHumanoid(humanoid)
    local lastHealth = humanoid.Health
    humanoid.HealthChanged:Connect(function(newHealth)
        if newHealth < lastHealth and SoundEnabled then
            local parentPart = humanoid.Parent and humanoid.Parent:FindFirstChild("HumanoidRootPart") or workspace
            if parentPart then
                local sound = soundTemplate:Clone()
                sound.Parent = parentPart
                sound:Play()
                sound.Ended:Connect(function()
                    sound:Destroy()
                end)
            end
        end
        lastHealth = newHealth
    end)
end

local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    monitorHumanoid(humanoid)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        setupCharacter(player.Character)
    end
    player.CharacterAdded:Connect(setupCharacter)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(setupCharacter)
end)

local AutoFireConnection

local function GetWeapon()
    if not currentCharacter then return nil end
    return currentCharacter:FindFirstChild("AR")
end

local function GetClosestPlayer()
    local closestPlayer, closestDist = nil, math.huge
    local hrp = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                local leftArm = char:FindFirstChild("LeftUpperArm")
                if humanoid and humanoid.Health > 0 and leftArm then
                    local dist = (leftArm.Position - hrp.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function createBeam(fromPart, toPart)
    if not fromPart or not toPart then return end

    local attachment0 = Instance.new("Attachment")
    attachment0.Name = "BeamAttachment0"
    attachment0.Parent = fromPart
    attachment0.Position = Vector3.new(0, 0, 0)

    local attachment1 = Instance.new("Attachment")
    attachment1.Name = "BeamAttachment1"
    attachment1.Parent = toPart
    attachment1.Position = Vector3.new(0, 0, 0)

    local beam = Instance.new("Beam")
    beam.Name = "BulletBeam"
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.FaceCamera = true
    beam.Width0 = 0.1
    beam.Width1 = 0.1
    beam.Color = ColorSequence.new(Color3.new(1, 0, 0)) 
    beam.Transparency = NumberSequence.new(0) 
    beam.LightEmission = 1
    beam.Parent = fromPart

    local tweenTime = 0.15
    local steps = 30
    local stepTime = tweenTime / steps
    local currentStep = 0

    local heartbeatConnection
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        currentStep = currentStep + 1
        local alpha = currentStep / steps
        beam.Transparency = NumberSequence.new(alpha)
        if currentStep >= steps then
            heartbeatConnection:Disconnect()
            beam:Destroy()
            if attachment0 then attachment0:Destroy() end
            if attachment1 then attachment1:Destroy() end
        end
    end)
end

local function StartAutoFire()
    if AutoFireConnection then return end
    AutoFireConnection = RunService.RenderStepped:Connect(function()
        local weapon = GetWeapon()
        if not weapon then return end

        local targetPlayer = GetClosestPlayer()
        if not targetPlayer then return end
        local targetChar = targetPlayer.Character
        if not targetChar then return end

        local leftArm = targetChar:FindFirstChild("LeftUpperArm")
        local humanoid = targetChar:FindFirstChild("Humanoid")
        local hrp = currentCharacter:FindFirstChild("HumanoidRootPart")

        if not leftArm or not humanoid or not hrp then return end

        local weaponPos = weapon:IsA("BasePart") and weapon.Position or (weapon:FindFirstChild("Handle") and weapon.Handle.Position) or hrp.Position
        local direction = (leftArm.Position - weaponPos).Unit
        local dist = (leftArm.Position - weaponPos).Magnitude

        local args = {
            weapon,
            {
                p = vector.create(weaponPos.X, weaponPos.Y, weaponPos.Z),
                pid = 1,
                part = leftArm,
                d = dist,
                maxDist = dist,
                h = humanoid,
                m = Enum.Material.Plastic,
                n = vector.create(direction.X, direction.Y, direction.Z),
                t = 0.12,
                sid = 6
            }
        }

        WeaponHitEvent:FireServer(unpack(args))

        local gunHandle = weapon:IsA("BasePart") and weapon or weapon:FindFirstChild("Handle")
        if gunHandle then
            createBeam(gunHandle, leftArm)
        end
    end)
end

StartAutoFire()