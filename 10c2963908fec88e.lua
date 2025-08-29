if not game: IsLoaded() then game. Loaded:Wait() end

repeat task.wait() until game:GetService("Players")
repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService( "ReplicatedStorage")
repeat task.wait() until game:GetService( "ReplicatedFirst")
local lgh =  game:GetService("Lighting")
sethiddenproperty(lgh,"Technology",2)
lgh.FogStart = 1/0
lgh.FogEnd = 1/0

for i,v in ipairs(lgh:GetChildren()) do
    if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
        v.Enabled = false
    end
end

-- [Terrain]
local wsc = game:GetService("Workspace")
wsc.Terrain.CastShadow = false
wsc.Terrain.WaterReflectance = 0
wsc.Terrain.WaterWaveSize = 0
wsc.Terrain.WaterTransparency = 0
wsc.Terrain.WaterWaveSpeed = 0
sethiddenproperty(wsc, 'StreamingTargetRadius', 64)
sethiddenproperty(wsc, 'StreamingPauseMode', 2)
sethiddenproperty(wsc.Terrain, 'Decoration', false)

-- [Disabled]

local boostmap = function(v)
    if v:IsA("Shirt") or v:IsA("Pants") then
        v[v.ClassName.."Template"] = ""
    elseif v:IsA("MeshPart") then
        v.TextureID = ""
    elseif v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
        v.CastShadow = false
    elseif v:IsA("SpecialMesh") then
        v.TextureId = 0 
    elseif v:IsA("Texture") or v:IsA("Decal") then
        v.Texture = ""
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Enabled = false
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("PostEffect") then
        v.Enabled = false
    elseif v:IsA("ShirtGraphic") then
        v.Graphic = ''
    elseif v:IsA("Model") then
        sethiddenproperty(v, 'LevelOfDetail', 1)
    end
end
for i,v in pairs(wsc:GetDescendants()) do
    pcall(boostmap,v)
end
wsc.DescendantAdded:Connect(function(v)
    pcall(boostmap,v)
end)

-- [Settings]
--game:GetService("NetworkClient"):SetOutgoingKBPSLimit(100)
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
settings().Rendering.EagerBulkExecution = false

settings().Network.IncomingReplicationLag = -1000
settings().Physics.PhysicsEnvironmentalThrottle = 1

UserSettings():GetService("UserGameSettings").MasterVolume = 0
UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
local isEquipping = false -- ตัวแปรควบคุมสถานะ

local function AutoEquip()
    isEquipping = true -- เปิดใช้งานการ AutoEquip
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end
    local playerStats = game:GetService("ReplicatedStorage"):FindFirstChild("playerstats")
    if not playerStats then
        return
    end
    local rodsFolder = playerStats:FindFirstChild(player.Name)
    if not rodsFolder or not rodsFolder:FindFirstChild("Rods") then
        return
    end
    local RunService = game:GetService("RunService")
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not isEquipping then
            connection:Disconnect() -- หยุดการทำงานถ้าสถานะถูกปิด
            return
        end
        pcall(function()
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, rod in ipairs(rodsFolder.Rods:GetChildren()) do
                    local tool = backpack:FindFirstChild(rod.Name)
                    if tool and not character:FindFirstChild(tool.Name) then
                        humanoid:EquipTool(tool)
                    end
                end
            end
        end)
    end)
end

local function CancelEquip()
    isEquipping = false -- ปิดสถานะการ AutoEquip
end


local function AutoEquip2()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local playerStats = game:GetService("ReplicatedStorage"):FindFirstChild("playerstats")

    if not playerStats then
        warn("playerstats not found in ReplicatedStorage.")
        return
    end

    local rodsFolder = playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Rods")
    if not rodsFolder then return end

    for _, rod in ipairs(rodsFolder:GetChildren()) do
        local events = game:GetService("ReplicatedStorage"):WaitForChild("events")
        if rodsFolder:FindFirstChild("Carbon Rod") and not rodsFolder:FindFirstChild("Trident Rod") then
            events:WaitForChild("equiprod"):FireServer("Carbon Rod")
        elseif rodsFolder:FindFirstChild("Trident Rod") then
            events:WaitForChild("equiprod"):FireServer("Trident Rod")
        end
    end
end

local function UnEquipAll2()
    task.wait(120) -- รอ 2 นาที
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:UnequipTools() -- เลิกถือไอเทมทั้งหมด
    end
end


local function UnEquipAll()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:UnequipTools() -- เลิกถือไอเทมทั้งหมด
    end
end

local function Reset()
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(10, 100, 0, true, nil, 1)
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(10, 100, 0, false, nil, 1)
end


function Teleport(targetCFrame)
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart") -- รอ HumanoidRootPart
    
    local currentPosition = humanoidRootPart.Position
    local targetPosition = targetCFrame.Position
    local distance = (targetPosition - currentPosition).Magnitude
    local speed

    -- กำหนดความเร็วตามระยะทาง
    if distance > 1000 then
        speed = 335
    elseif distance > 500 then
        speed = 335
    elseif distance > 285 then
        speed = 750
    else
        speed = 335
    end

    -- ตรวจสอบระยะทางและเลือกวิธีการ Teleport
    if distance <= 10000 then
        -- ย้ายผู้เล่นโดยตรงเมื่ออยู่ใกล้
        humanoidRootPart.CFrame = targetCFrame
    else
        -- ใช้ TweenService ในการเคลื่อนที่อย่างนุ่มนวล
        if _G.Tween then
            _G.Tween:Cancel() -- ยกเลิก Tween ก่อนสร้างใหม่
        end

        _G.Tween = game:GetService("TweenService"):Create(
            humanoidRootPart, 
            TweenInfo.new(distance / speed, Enum.EasingStyle.Linear), 
            {CFrame = targetCFrame}
        )
        _G.Tween:Play()
    end
end
local function interact1(path)
    if path then
        local guiService = game:GetService("GuiService")
        local virtualInputManager = game:GetService("VirtualInputManager")

        -- เลือกวัตถุใน GUI
        guiService.SelectedObject = path
        task.wait(0.01) -- รอเล็กน้อยให้ GUI ตอบสนอง

        -- ส่งการกดปุ่ม Return (Enter)
        virtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        virtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

        -- ยกเลิกการเลือกวัตถุ
        task.wait(0.01) -- รอเล็กน้อยก่อนรีเซ็ต
        guiService.SelectedObject = nil
    end
end

local function Autorobs()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = game.Players.LocalPlayer
    local playerName = player.Name
    local coins = tonumber(game:GetService("ReplicatedStorage").playerstats[playerName].Stats.coins.Value)
    local playerStats = ReplicatedStorage.playerstats[playerName]
    local hasCarbonRod, hasNocturnalRod = false, false

    for _, rod in pairs(game:GetService("ReplicatedStorage").playerstats[playerName].Rods:GetChildren()) do
        if rod.Name == "Carbon Rod" then
            hasCarbonRod = true
        elseif rod.Name == "Nocturnal Rod" then
            hasNocturnalRod = true
        elseif rod.Name == "Trident Rod" then
            hasTridentRod = true
        elseif rod.Name == "Kings Rod" then
            hasKingsRod = true
        elseif rod.Name == "Aurora Rod" then
            hasAuroraRod = true
        end
    end

    if not hasCarbonRod and coins >= 2000 then
        local prompt = player.PlayerGui:FindFirstChild("over") and player.PlayerGui.over:FindFirstChild("prompt")
        if prompt then
            interact1(prompt.confirm)
        else
            player.Character.HumanoidRootPart.CFrame = CFrame.new(449, 151, 226)
            fireproximityprompt(workspace.world.interactables["Carbon Rod"].purchaserompt)
            interact1(prompt.confirm)
        end
    end
    -- if not hasNocturnalRod and coins >= 12000 then
    --     local prompt = player.PlayerGui:FindFirstChild("over") and player.PlayerGui.over:FindFirstChild("prompt")
    --     if prompt then
    --         interact1(prompt.confirm)
    --     else
    --         player.Character.HumanoidRootPart.CFrame = CFrame.new(-144, -515, 1142)
    --         fireproximityprompt(workspace.world.interactables["Nocturnal Rod"].purchaserompt)
    --         interact1(prompt.confirm)
    --     end
    -- end
    if not hasKingsRod and coins >= 120000 and playerStats.Rods:FindFirstChild("Trident Rod") then
        local prompt = player.PlayerGui:FindFirstChild("over") and player.PlayerGui.over:FindFirstChild("prompt")
        if prompt then
            interact1(prompt.confirm)
        else
            player.Character.HumanoidRootPart.CFrame = CFrame.new(1378, -808, -300)
            fireproximityprompt(workspace.world.interactables["Kings Rod"].purchaserompt)
            interact1(prompt.confirm)
        end
    end
    if not hasTridentRod and coins >= 150000 then
        local prompt = player.PlayerGui:FindFirstChild("over") and player.PlayerGui.over:FindFirstChild("prompt")
        if prompt then
            interact1(prompt.confirm)
        else
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-1484, -226, -2200)
            fireproximityprompt(workspace.world.interactables["Trident Rod"].purchaserompt)
            interact1(prompt.confirm)
        end
    end
    if not hasAuroraRod and coins >= 90000 and playerStats.Rods:FindFirstChild("Trident Rod") and playerStats.Rods:FindFirstChild("Kings Rod") and game:GetService("ReplicatedStorage").world.cycle.Value == "Night" and game:GetService("ReplicatedStorage").world.weather.Value == "Aurora_Borealis"  then
        local prompt = player.PlayerGui:FindFirstChild("over") and player.PlayerGui.over:FindFirstChild("prompt")
        if prompt then
            interact1(prompt.confirm)
        else
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-145, -513, 1130)
            fireproximityprompt(workspace.world.interactables["Aurora Rod"].purchaserompt)
            interact1(prompt.confirm)
        end
    end
end

local function Click()
    local virtualInput = game:GetService("VirtualInputManager")
    virtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(0.05)
    virtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    wait(0.05)
end

local function interact(path)
    if path then
        local guiService = game:GetService("GuiService")
        local virtualInputManager = game:GetService("VirtualInputManager")

        -- เลือกวัตถุใน GUI
        guiService.SelectedObject = path
        task.wait(0.01) -- รอเล็กน้อยให้ GUI ตอบสนอง

        -- ส่งการกดปุ่ม Return (Enter)
        virtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        virtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)

        -- ยกเลิกการเลือกวัตถุ
        task.wait(0.01) -- รอเล็กน้อยก่อนรีเซ็ต
        guiService.SelectedObject = nil
    end
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

spawn(function()
    while wait(0.2) do
        pcall(function()
            local playerName = player.Name
            local coins = tonumber(ReplicatedStorage.playerstats[playerName].Stats.coins.Value)
            local playerStats = ReplicatedStorage.playerstats[playerName]
            local isShakeUI = playerGui:FindFirstChild("shakeui") ~= nil
            if game:GetService("Players").LocalPlayer.PlayerGui.loading.Enabled == false then
                for _, rod in pairs(workspace[playerName]:GetChildren()) do
                    if string.find(rod.Name,"Rod") then
                        local rodName = rod.Name
                        if coins <= 2000 and not playerStats.Rods:FindFirstChild("Carbon Rod") and not isShakeUI then
                            Teleport(CFrame.new(939.354431, -738.08197, 1457.44556, -0.991571009, -1.55779851e-08, 0.129564434, -1.45141978e-08, 1, 9.15472853e-09, -0.129564434, 7.19703941e-09, -0.991571009))
                        elseif not isShakeUI and playerStats.Rods:FindFirstChild("Carbon Rod") and not playerStats.Rods:FindFirstChild("Trident Rod") then
                            Teleport(CFrame.new(939.354431, -738.08197, 1457.44556, -0.991571009, -1.55779851e-08, 0.129564434, -1.45141978e-08, 1, 9.15472853e-09, -0.129564434, 7.19703941e-09, -0.991571009))
                        elseif not isShakeUI and playerStats.Rods:FindFirstChild("Carbon Rod") and playerStats.Rods:FindFirstChild("Trident Rod") then
                            Teleport(CFrame.new(939.354431, -738.08197, 1457.44556, -0.991571009, -1.55779851e-08, 0.129564434, -1.45141978e-08, 1, 9.15472853e-09, -0.129564434, 7.19703941e-09, -0.991571009))
                        end
                        if coins >= 2000 and not playerStats.Rods:FindFirstChild("Carbon Rod") and not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
                            Autorobs()
                            UnEquipAll()
                            if _G.Tween then
                                _G.Tween:Cancel()
                            end
                        -- elseif coins >= 12000 and not playerStats.Rods:FindFirstChild("Nocturnal Rod") then
                        --     Autorobs()
                        --     Reset()
                        --     if _G.Tween then
                        --         _G.Tween:Cancel()
                        --     end
                        elseif coins >= 150000 and not playerStats.Rods:FindFirstChild("Trident Rod") and not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
                            Autorobs()
                            UnEquipAll()
                            if _G.Tween then
                                _G.Tween:Cancel()
                            end
                        elseif coins >= 120000 and playerStats.Rods:FindFirstChild("Trident Rod") and not playerStats.Rods:FindFirstChild("Kings Rod") and not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
                            Autorobs()
                            UnEquipAll()
                            if _G.Tween then
                                _G.Tween:Cancel()
                            end
                        elseif coins >= 600000 
                            and not playerStats.Rods:FindFirstChild("Aurora Rod") 
                            and not game:GetService("Players")[playerName].Backpack:FindFirstChild("Aurora Totem") 
                            and game:GetService("ReplicatedStorage").world.cycle.Value == "Night" then
                            
                            -- Teleport ไปยังตำแหน่ง
                            Teleport(CFrame.new(-1811, -137, -3283))
                            
                            -- เรียกใช้งาน ProximityPrompt
                            local auroraTotem = workspace.world.interactables:FindFirstChild("Aurora Totem")
                            if auroraTotem then
                                fireproximityprompt(workspace.world.interactables["Aurora Totem"].purchaserompt)
                            end
                        
                            local prompt = player.PlayerGui:FindFirstChild("over") and player.PlayerGui.over:FindFirstChild("prompt")
                            if prompt then
                                interact1(prompt.confirm)
                            end
                        
                            -- Reset ตัวละคร
                            UnEquipAll()
                        
                            -- ยกเลิก Tween หากมี
                            if _G.Tween then
                                _G.Tween:Cancel()
                            end
                        elseif not playerStats.Rods:FindFirstChild("Aurora Rod") and game:GetService("Players")[playerName].Backpack:FindFirstChild("Aurora Totem") and game:GetService("ReplicatedStorage").world.cycle.Value == "Night" then
                            CancelEquip()
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Aurora Totem"))
                            wait(3)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(10, 100, 0, true, nil, 1)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(10, 100, 0, false, nil, 1)
                            if _G.Tween then
                                _G.Tween:Cancel()
                            end
                        elseif coins >= 90000 and playerStats.Rods:FindFirstChild("Trident Rod") and playerStats.Rods:FindFirstChild("Kings Rod") and game:GetService("ReplicatedStorage").world.cycle.Value == "Night" and game:GetService("ReplicatedStorage").world.weather.Value == "Aurora_Borealis" and not playerStats.Rods:FindFirstChild("Aurora Rod") then
                            Autorobs()
                            UnEquipAll()
                            if _G.Tween then
                                _G.Tween:Cancel()
                            end
                        end
                        if not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("shakeui") and workspace.world.npcs:FindFirstChild("Milo Merchant") then
                            local npc = workspace.world.npcs["Milo Merchant"]
                            if npc then
                                npc:SetPrimaryPartCFrame(CFrame.new(939.741516, -738.085693, 1458.93274))
                            end
                            Click()
                            if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Barreleye Fish") then
                                Click()
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Barreleye Fish"))
                                workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Milo Merchant"):WaitForChild("merchant"):WaitForChild("sell"):InvokeServer()
                            elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Sea Snake") then
                                Click()
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Sea Snake"))
                                workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Milo Merchant"):WaitForChild("merchant"):WaitForChild("sell"):InvokeServer()
                            elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Small Spine Chimera") then
                                Click()
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Small Spine Chimera"))
                                workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Milo Merchant"):WaitForChild("merchant"):WaitForChild("sell"):InvokeServer()
                            elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Nautilus") then
                                Click()
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Nautilus"))
                                workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Milo Merchant"):WaitForChild("merchant"):WaitForChild("sell"):InvokeServer()
                            elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Mutated Shark") then
                                Click()
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Mutated Shark"))
                                workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Milo Merchant"):WaitForChild("merchant"):WaitForChild("sell"):InvokeServer()
                            elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Ancient Eel") then
                                Click()
                                game.Players.LocalPlayer.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Ancient Eel"))
                                workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Milo Merchant"):WaitForChild("merchant"):WaitForChild("sell"):InvokeServer()
                            end
                            local virtualInput = game:GetService("VirtualInputManager")
                            virtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            wait(0.05)
                            virtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                            wait(0.05)
                            workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Milo Merchant"):WaitForChild("merchant"):WaitForChild("sellall"):InvokeServer()
                            if workspace.world.npcs:FindFirstChild("Milo Merchant") and not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
                                local args = {
                                    [1] = 100,
                                    [2] = 1
                                }
                                game:GetService("Players").LocalPlayer.Character:FindFirstChild(rodName).events.cast:FireServer(unpack(args))
                            end
                        end
                        if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("shakeui") and game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone.button:FindFirstChild("ripple") then
                            interact(game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone.button)
                        elseif game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("reel") then
                            game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100,true)
                        else
                            AutoEquip2()
                            game:GetService("Players").LocalPlayer.Character:FindFirstChild(rodName).events.cast:FireServer(100,1)
                        end
                    end
                end
            end
        end)
    end
end)


while wait(3) do
    pcall(function()
        if game:GetService("Players").LocalPlayer.PlayerGui.loading.Enabled == true then
            Wait(10)
            if game.PlaceId == 16732694052 then
                if game:GetService("Players").LocalPlayer.PlayerGui.loading.loading:FindFirstChild("skip") then
                    interact(game:GetService("Players").LocalPlayer.PlayerGui.loading.loading.skip)
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.loading.Enabled == true then
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(10, 100, 0, true, nil, 1)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(10, 100, 0, false, nil, 1)
                    return
                end
            end
        elseif game:GetService("Players").LocalPlayer.PlayerGui.loading.Enabled == false then
            AutoEquip()
            UnEquipAll2()
        end
    end)
end