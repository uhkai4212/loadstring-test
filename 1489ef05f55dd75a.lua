local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Window = Fluent:CreateWindow({
    Title = "Murder Mystery 2 Menu",
    SubTitle = "by Goiaba.lua",
    TabWidth = 100,
    Size = UDim2.fromOffset(670, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local ESPSection = Tabs.Main:AddSection("ESP")

local Options = Fluent.Options

local function createToggle(tab, name, callback, description)
    local toggle = tab:AddToggle(name, {
        Title = name,
        Description = description or "",
        Default = false,
        Callback = function(state)
            callback(state)
        end
    })
    return toggle
end

local playerHighlights = {}  
local coinHighlights = {}

local murdererESPEnabled = false
local sheriffESPEnabled = false
local innocentESPEnabled = false
local coinESPEnabled = false

local function updateESPForPlayer(player)
    if not player.Character then
        if playerHighlights[player] then
            playerHighlights[player]:Destroy()
            playerHighlights[player] = nil
        end
        return
    end

    local character = player.Character

    local function hasTool(toolName)
        local found = false
        if player:FindFirstChild("Backpack") then
            for _, tool in ipairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == toolName then
                    found = true
                    break
                end
            end
        end
        if not found then
            for _, item in ipairs(character:GetChildren()) do
                if item:IsA("Tool") and item.Name == toolName then
                    found = true
                    break
                end
            end
        end
        return found
    end

    local isMurderer = hasTool("Knife")
    local isSheriff = (not isMurderer) and hasTool("Gun")
    local isInnocent = (not isMurderer and not isSheriff)

    local desiredColor
    if isMurderer and murdererESPEnabled then
        desiredColor = Color3.new(1, 0, 0)
    elseif isSheriff and sheriffESPEnabled then
        desiredColor = Color3.new(0, 0, 1)
    elseif isInnocent and innocentESPEnabled then
        desiredColor = Color3.new(0, 1, 0)
    end

    if desiredColor then
        if not playerHighlights[player] then
            local h = Instance.new("Highlight")
            h.Name = "ESPHighlight"
            h.FillTransparency = 0.5
            h.OutlineTransparency = 1
            h.Adornee = character
            h.FillColor = desiredColor
            h.Parent = character
            playerHighlights[player] = h
        else
            playerHighlights[player].FillColor = desiredColor
            if playerHighlights[player].Adornee ~= character then
                playerHighlights[player].Adornee = character
            end
        end
    else
        if playerHighlights[player] then
            playerHighlights[player]:Destroy()
            playerHighlights[player] = nil
        end
    end
end

createToggle(Tabs.Main, "Murderer ESP", function(state)
    murdererESPEnabled = state
    if state then
        spawn(function()
            while murdererESPEnabled do
                local success, err = pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            updateESPForPlayer(player)
                        end
                    end
                end)
                if not success then
                end
                wait(1)
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and playerHighlights[player] then
                    playerHighlights[player]:Destroy()
                    playerHighlights[player] = nil
                end
            end
        end)
    end
end, "Highlight the murderer in red.")

createToggle(Tabs.Main, "Sheriff ESP", function(state)
    sheriffESPEnabled = state
    if state then
        spawn(function()
            while sheriffESPEnabled do
                local success, err = pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            updateESPForPlayer(player)
                        end
                    end
                end)
                if not success then
                end
                wait(1)
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and playerHighlights[player] then
                    playerHighlights[player]:Destroy()
                    playerHighlights[player] = nil
                end
            end
        end)
    end
end, "Highlight the sheriff in blue.")

createToggle(Tabs.Main, "Innocent ESP", function(state)
    innocentESPEnabled = state
    if state then
        spawn(function()
            while innocentESPEnabled do
                local success, err = pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            updateESPForPlayer(player)
                        end
                    end
                end)
                if not success then
                end
                wait(1)
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and playerHighlights[player] then
                    playerHighlights[player]:Destroy()
                    playerHighlights[player] = nil
                end
            end
        end)
    end
end, "Highlight players who are innocent in green.")

createToggle(Tabs.Main, "Coin ESP", function(state)
    coinESPEnabled = state
    if state then
        spawn(function()
            while coinESPEnabled do
                local success, err = pcall(function()
                    for _, container in ipairs(workspace:GetDescendants()) do
                        if container:IsA("Model") and container.Name == "CoinContainer" then
                            for _, coinServer in ipairs(container:GetChildren()) do
                                if coinServer.Name == "Coin_Server" then
                                    local coinVisual = coinServer:FindFirstChild("CoinVisual")
                                    if coinVisual then
                                        local mainCoin = coinVisual:FindFirstChild("MainCoin")
                                        if mainCoin and mainCoin:IsA("MeshPart") then
                                            if not coinHighlights[mainCoin] then
                                                local h = Instance.new("Highlight")
                                                h.Name = "CoinESPHighlight"
                                                h.FillColor = Color3.fromRGB(0, 255, 255)
                                                h.FillTransparency = 0.5
                                                h.OutlineTransparency = 1
                                                h.Adornee = mainCoin
                                                h.Parent = mainCoin
                                                coinHighlights[mainCoin] = h
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                if not success then
                end
                wait(0.1)
            end
            for coinObj, h in pairs(coinHighlights) do
                if h then
                    h:Destroy()
                end
            end
            coinHighlights = {}
        end)
    end
end, "Highlight all coins in yellow.")

local gunESPEnabled = false
local gunHighlight = nil

createToggle(Tabs.Main, "Gun ESP", function(state)
    gunESPEnabled = state
    if state then
        spawn(function()
            while gunESPEnabled do
                local success, err = pcall(function()
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj.Name == "GunDrop" then
                            if not gunHighlight then
                                local h = Instance.new("Highlight")
                                h.Name = "GunESPHighlight"
                                h.FillColor = Color3.fromRGB(255, 255, 0)
                                h.FillTransparency = 0.5
                                h.OutlineTransparency = 1
                                h.Adornee = obj
                                h.Parent = obj
                                gunHighlight = h
                            elseif gunHighlight.Adornee ~= obj then
                                gunHighlight.Adornee = obj
                            end
                        end
                    end
                end)
                if not success then end
                task.wait(0.1)
            end
            if gunHighlight then
                gunHighlight:Destroy()
                gunHighlight = nil
            end
        end)
    else
        if gunHighlight then
            gunHighlight:Destroy()
            gunHighlight = nil
        end
    end
end, "Highlight the GunDrop in yellow.")

local InnocentSection = Tabs.Main:AddSection("Innocent")

Tabs.Main:AddButton({
    Title = "TP to Gun (If Spawned)",
    Description = "Teleports to the Gun if it's dropped on the map.",
    Callback = function()
        local gun = nil

        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "GunDrop" and v:IsA("BasePart") then
                gun = v
                break
            end
        end

        if gun then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.CFrame = gun.CFrame + Vector3.new(0, 5, 0)
            Fluent:Notify({
                Title = "Gun Found",
                Content = "Teleported to the Gun!",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Gun Not Found",
                Content = "No GunDrop found in the map!",
                Duration = 3
            })
        end
    end
})

Tabs.Main:AddParagraph({
    Title = "TP to Gun (If Spawned) 'X'",
    Content = "KeyBind: 'X'."
})

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(0.5)
        if murdererESPEnabled or sheriffESPEnabled or innocentESPEnabled then
            updateESPForPlayer(player)
        end
    end)
end)

--local UIS = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    -- 🔫 TP to Gun - Tecla "X"
    if input.KeyCode == Enum.KeyCode.X then
        local gun = nil
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "GunDrop" and v:IsA("BasePart") then
                gun = v
                break
            end
        end

        if gun then
            local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.CFrame = gun.CFrame + Vector3.new(0, 5, 0)
            Fluent:Notify({
                Title = "Gun Found",
                Content = "Teleported to the Gun!",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Gun Not Found",
                Content = "No GunDrop found in the map!",
                Duration = 3
            })
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- 🔫 Shoot Murder - Tecla "Z"
    if input.KeyCode == Enum.KeyCode.Z then
        -- Executa a função do Shoot Murder
        -- 🔍 Detectar quem tem Knife (Backpack ou Mão)
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local hasKnife = false

                if player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife") then
                    hasKnife = true
                end

                if player.Character and player.Character:FindFirstChild("Knife") then
                    hasKnife = true
                end

                if hasKnife then
                    murder = player
                    break
                end
            end
        end

        if murder and murder.Character and murder.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = murder.Character.HumanoidRootPart
            local murderPos = hrp.Position

            -- 🎯 Lead Shot baseado no ping real e velocidade do murder
            local velocity = hrp.Velocity

            -- Obter o ping atual (em segundos)
            local pingMs = 0
            local stats = game:GetService("Stats")
            if stats:FindFirstChild("Network") and stats.Network:FindFirstChild("ServerStatsItem") then
                local pingStat = stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
                if pingStat then
                    pingMs = pingStat:GetValue()
                end
            end
            local pingSec = math.clamp(pingMs / 1000, 0, 1) -- limite máximo 1s

            -- Calcular offset
            local leadOffset = velocity * pingSec

            -- Se o murder estiver parado, sem offset
            if velocity.Magnitude < 2 then
                leadOffset = Vector3.new(0, 0, 0)
            end

            local targetPos = murderPos + leadOffset

            local args = {
                1,
                Vector3.new(targetPos.X, targetPos.Y, targetPos.Z),
                "AH2"
            }

            game:GetService("Players").LocalPlayer.Character:WaitForChild("Gun"):WaitForChild("KnifeLocal"):WaitForChild("CreateBeam"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))

            Fluent:Notify({
                Title = "Shot Fired",
                Content = "Fired ahead of " .. murder.Name,
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "No player holding Knife found!",
                Duration = 3
            })
        end
    end
end)

local SheriffSection = Tabs.Main:AddSection("Sheriff")

local loopTPMurder = false
local loopShootMurder = false

createToggle(Tabs.Main, "Kill Murderer", function(state)
    loopTPMurder = state
    loopShootMurder = state

    if state then
        -- 🔗 Loop de Teleport
        task.spawn(function()
            while loopTPMurder do
                local murder = nil

                -- 🔍 Detectar quem tem Knife (Backpack ou Mão)
                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer then
                        local hasKnife = false

                        if player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife") then
                            hasKnife = true
                        end

                        if player.Character and player.Character:FindFirstChild("Knife") then
                            hasKnife = true
                        end

                        if hasKnife then
                            murder = player
                            break
                        end
                    end
                end

                if murder and murder.Character and murder.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = murder.Character.HumanoidRootPart

                    -- 🔗 TP pras COSTAS do Murder
                    local myChar = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                    local myHRP = myChar:WaitForChild("HumanoidRootPart")

                    local backCFrame = hrp.CFrame * CFrame.new(0, 0, 15)
                    myHRP.CFrame = backCFrame + Vector3.new(0, 0, 0)

                end

                task.wait(0) -- 🔁 Delay do TP (rápido)
            end
        end)

        -- 🔫 Loop de Shoot
        task.spawn(function()
            while loopShootMurder do
                local murder = nil

                -- 🔍 Detectar quem tem Knife (Backpack ou Mão)
                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer then
                        local hasKnife = false

                        if player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife") then
                            hasKnife = true
                        end

                        if player.Character and player.Character:FindFirstChild("Knife") then
                            hasKnife = true
                        end

                        if hasKnife then
                            murder = player
                            break
                        end
                    end
                end

                if murder and murder.Character and murder.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = murder.Character.HumanoidRootPart
                    local murderPos = hrp.Position

                    -- 🎯 Lead Shot baseado no ping real e velocidade do murder
                    local velocity = hrp.Velocity

                    -- Obter o ping atual (em segundos)
                    local pingMs = 0
                    local stats = game:GetService("Stats")
                    if stats:FindFirstChild("Network") and stats.Network:FindFirstChild("ServerStatsItem") then
                        local pingStat = stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
                        if pingStat then
                            pingMs = pingStat:GetValue()
                        end
                    end
                    local pingSec = math.clamp(pingMs / 1000, 0, 1) -- limite máximo 1s

                    -- Calcular offset
                    local leadOffset = velocity * pingSec

                    -- Se o murder estiver parado, sem offset
                    if velocity.Magnitude < 2 then
                        leadOffset = Vector3.new(0, 0, 0)
                    end

                    local targetPos = murderPos + leadOffset

                    local args = {
                        1,
                        Vector3.new(targetPos.X, targetPos.Y, targetPos.Z),
                        "AH2"
                    }

                    game:GetService("Players").LocalPlayer.Character:WaitForChild("Gun"):WaitForChild("KnifeLocal"):WaitForChild("CreateBeam"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))

                    Fluent:Notify({
                        Title = "Shot Fired",
                        Content = "Fired ahead of " .. murder.Name,
                        Duration = 3
                    })
                else
                    Fluent:Notify({
                        Title = "Error",
                        Content = "No player holding Knife found!",
                        Duration = 3
                    })
                end

                task.wait(0) -- 🔫 Delay do Shoot (Ajustável — 2 segundos padrão)
            end
        end)
    end
end, "TP to the Murderer, and shoot.")

Tabs.Main:AddParagraph({
    Title = "Shoot Murder 'Z'",
    Content = "KeyBind: 'Z'."
})

local MurdererSection = Tabs.Main:AddSection("Murderer")

local loopTPStab = false

createToggle(Tabs.Main, "Kill All", function(state)
    loopTPStab = state

    if state then
        task.spawn(function()
            while loopTPStab do
                local closestPlayer = nil
                local shortestDistance = math.huge

                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                        local hrp = char:WaitForChild("HumanoidRootPart")
                        local distance = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude

                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestPlayer = player
                        end
                    end
                end

                if closestPlayer then
                    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")
                    local targetHRP = closestPlayer.Character:WaitForChild("HumanoidRootPart")

                    -- Teleport até o player
                    hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 0, 0) -- Leve offset pra não bugar

                    -- Executar Stab
                    local knife = game.Players.LocalPlayer.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")
                    if knife then
                        knife:WaitForChild("Stab"):FireServer("Down")
                    end
                end

                task.wait(0) -- Delay entre cada tp/stab
            end
        end)
    end
end, "Teleport to nearest players and auto stab.")

local PlayerSection = Tabs.Movement:AddSection("Movement")

local WalkspeedSlider = Tabs.Movement:AddSlider("Walkspeed", {
    Title = "Walkspeed",
    Description = "Adjust your player's walkspeed.",
    Default = 16,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
        end
    end
})

local JumpPowerSlider = Tabs.Movement:AddSlider("JumpPower", {
    Title = "Jump Power",
    Description = "Adjust your player's jump power.",
    Default = 50,
    Min = 0,
    Max = 200,
    Increment = 1,
    Rounding = 0,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
        end
    end
})

local defaultGravity = workspace.Gravity

local GravitySlider = Tabs.Movement:AddSlider("Gravity", {
    Title = "Gravity",
    Description = "Adjust the game gravity.",
    Default = workspace.Gravity,
    Min = 0,
    Max = 999,
    Rounding = 0,
    Callback = function(Value)
        workspace.Gravity = Value
    end
})

local FOVSlider = Tabs.Movement:AddSlider("FOV", {
    Title = "Field of View",
    Description = "Adjust the camera's field of view.",
    Default = Camera.FieldOfView,
    Min = 20,
    Max = 120,
    Rounding = 1,
    Callback = function(Value)
        Camera.FieldOfView = Value
    end
})

local InfJumpToggle = Tabs.Movement:AddToggle("InfJump", {
    Title = "Infinite Jump",
    Default = false,
    Description = "Enable infinite jump."
})

local InfJumpEnabled = false
local InfJumpConnection

InfJumpToggle:OnChanged(function()
    InfJumpEnabled = InfJumpToggle.Value
    if InfJumpEnabled then
        InfJumpConnection = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if InfJumpConnection then
            InfJumpConnection:Disconnect()
        end
    end
end)

local NoclipToggle = Tabs.Movement:AddToggle("Noclip", {
    Title = "Noclip",
    Default = false,
    Description = "Enable noclip (walk through walls)."
})

local NoclipEnabled = false
NoclipToggle:OnChanged(function()
    NoclipEnabled = NoclipToggle.Value
end)

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local FlyToggle = Tabs.Movement:AddToggle("Fly", {
    Title = "Fly",
    Default = false,
    Description = "Enable flying mode."
})

local FlySpeedSlider = Tabs.Movement:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Description = "Adjust your fly speed.",
    Default = 50,
    Min = 10,
    Max = 999,
    Rounding = 0,
    Callback = function(Value)
    end
})

local FlyEnabled = false
local FlyBodyVelocity, FlyBodyGyro
local FlyConnection

FlyToggle:OnChanged(function()
    FlyEnabled = FlyToggle.Value
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")

    if FlyEnabled then
        FlyBodyVelocity = Instance.new("BodyVelocity")
        FlyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        FlyBodyVelocity.Parent = hrp

        FlyBodyGyro = Instance.new("BodyGyro")
        FlyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        FlyBodyGyro.CFrame = hrp.CFrame
        FlyBodyGyro.Parent = hrp

        FlyConnection = RunService.RenderStepped:Connect(function()
            local direction = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + (Camera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - (Camera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - (Camera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + (Camera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                direction = direction - Vector3.new(0, 1, 0)
            end

            FlyBodyVelocity.Velocity = direction * FlySpeedSlider.Value
            if direction.Magnitude > 0 then
                FlyBodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + direction)
            else
                FlyBodyGyro.CFrame = hrp.CFrame
            end
        end)
    else
        if FlyConnection then
            FlyConnection:Disconnect()
        end
        if FlyBodyVelocity then
            FlyBodyVelocity:Destroy()
        end
        if FlyBodyGyro then
            FlyBodyGyro:Destroy()
        end
    end
end)

Tabs.Movement:AddButton({
    Title = "Restore to Default",
    Description = "Reset to default values.",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
            WalkspeedSlider:SetValue(16)
            JumpPowerSlider:SetValue(50)
            workspace.Gravity = defaultGravity
            GravitySlider:SetValue(defaultGravity)
        end
    end
})

local TeleportSection = Tabs.Movement:AddSection("Player Teleport")

local playerAddedConnection, playerRemovedConnection

local function getPlayerNames()
    local names = {}
    local players = Players:GetPlayers()
    
    for _, player in ipairs(players) do
        if player ~= LocalPlayer and player:IsA("Player") then
            table.insert(names, player.Name)
        end
    end
    return names
end

local TeleportDropdown = Tabs.Movement:AddDropdown("TeleportToPlayer", {
    Title = "Teleport to Player",
    Description = "Select a player to teleport to their position.",
    Values = getPlayerNames(),
    Multi = false,
    Default = nil
})

TeleportDropdown:OnChanged(function(selected)
    if not selected or selected == "" then return end
    
    local target = Players:FindFirstChild(selected)
    if not target then
        Fluent:Notify({
            Title = "Teleport Failed",
            Content = "Player not found: " .. tostring(selected),
            Duration = 3
        })
        return
    end

    local success, err = pcall(function()
        local targetChar = target.Character or target.CharacterAdded:Wait()
        local targetHRP = targetChar:WaitForChild("HumanoidRootPart")
        
        local localChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local localHRP = localChar:WaitForChild("HumanoidRootPart")
        
        localHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 5, 0)
        
        Fluent:Notify({
            Title = "Teleport Success",
            Content = "Teleported to " .. target.Name,
            Duration = 3
        })
    end)
    
    if not success then
        Fluent:Notify({
            Title = "Teleport Error",
            Content = "Failed to teleport: " .. tostring(err),
            Duration = 5
        })
    end
end)

Tabs.Movement:AddButton({
    Title = "Refresh Player List",
    Description = "Update the teleport dropdown with current players.",
    Callback = function()
        TeleportDropdown:SetValues(getPlayerNames())
        Fluent:Notify({
            Title = "Player List",
            Content = "Player list has been updated",
            Duration = 2
        })
    end
})

local utilitiesSection = Tabs.Settings:AddSection("Utilities")

Tabs.Settings:AddButton({
    Title = "Rejoin",
    Description = "Rejoin the current server.",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

local function serverhop()
    local function tryHttpRequest(url)
        if syn and syn.request then
            local response = syn.request({
                Url = url,
                Method = "GET"
            })
            return true, HttpService:JSONDecode(response.Body)
        end
        if request then
            local response = request({
                Url = url,
                Method = "GET"
            })
            return true, HttpService:JSONDecode(response.Body)
        end
        if http and http.request then
            local response = http.request({
                Url = url,
                Method = "GET"
            })
            return true, HttpService:JSONDecode(response.Body)
        end
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if success then
            return true, response
        end
        return false, nil
    end

    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)
    local success, response = tryHttpRequest(url)

    if not success or not response or not response.data then
        Fluent:Notify({
            Title = "Serverhop",
            Content = "Failed to fetch server list. Your executor may not support HTTP requests.",
            Duration = 5
        })
        return
    end

    local servers = {}
    for _, v in ipairs(response.data) do
        if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
            table.insert(servers, v.id)
        end
    end

    if #servers > 0 then
        Fluent:Notify({
            Title = "Serverhop",
            Content = "Joining a new server...",
            Duration = 3
        })
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
    else
        Fluent:Notify({
            Title = "Serverhop",
            Content = "Couldn't find a server with available slots.",
            Duration = 5
        })
    end
end

Tabs.Settings:AddButton({
    Title = "Serverhop",
    Description = "Join a different server with available slots.",
    Callback = function()
        local success, err = pcall(serverhop)
        if not success then
            Fluent:Notify({
                Title = "Serverhop Error",
                Content = "An error occurred: " .. tostring(err),
                Duration = 5
            })
        end
    end
})

playerAddedConnection = Players.PlayerAdded:Connect(function(player)
    TeleportDropdown:SetValues(getPlayerNames())
end)

playerRemovedConnection = Players.PlayerRemoving:Connect(function(player)
    TeleportDropdown:SetValues(getPlayerNames())
end)

game:GetService("UserInputService").WindowFocused:Connect(function()
    if playerAddedConnection then
        playerAddedConnection:Disconnect()
    end
    if playerRemovedConnection then
        playerRemovedConnection:Disconnect()
    end
end)

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way: