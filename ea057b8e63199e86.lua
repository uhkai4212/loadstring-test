local OrionLibV2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/OrionLibV2/refs/heads/main/OrionLibV2.lua"))()
local window = OrionLibV2:MakeWindow({
    Title = "Rain hub | Flee The Facility",
    SubTitle = "by zaque_blox"
})

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Função auxiliar para verificar se um modelo é válido (tem Humanoid e HumanoidRootPart)
local function isValidModel(obj)
    return obj:IsA("Model") and obj:FindFirstChildWhichIsA("Humanoid") and obj:FindFirstChild("HumanoidRootPart")
end

-- ======================
-- ABA INFO
-- ======================
local InfoTab = window:MakeTab({ Name = "Info" })
local SectionInfo = InfoTab:AddSection({ Name = "Info" })
InfoTab:AddLabel({
    Name = "Bem vindo(a) " .. LocalPlayer.Name .. "!",
    Content = "obrigado por usar o Rain hub :D"
})

-- ======================
-- ABA MAIN
-- ======================
local MainTab = window:MakeTab({ Name = "Main" })

-- Seções (pode adicionar mais seções futuramente)
MainTab:AddSection({ Name = "Survivor ( próximo update )" })
MainTab:AddSection({ Name = "Beast" })

-- Função KillAll (ataca o jogador mais próximo e tenta colocá-lo num FreezePod livre)
local function KillAll()
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent", 5)
    if not remote then return end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local originalPosition = character.HumanoidRootPart.Position

    -- Encontra o jogador mais próximo
    local closestPlayer, closestDistance = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and isValidModel(plr.Character) then
            local distance = (character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestPlayer = plr
                closestDistance = distance
            end
        end
    end

    if not closestPlayer then return end

    -- Teleporta até o jogador e dispara ataque
    character.HumanoidRootPart.CFrame = closestPlayer.Character.HumanoidRootPart.CFrame
    task.wait(0.1)
    remote:FireServer("Input", "Attack", true)
    task.wait(0.1)

    -- Encontra o FreezePod mais próximo e livre
    local nearestPod, nearestDistance = nil, math.huge
    for _, pod in ipairs(Workspace:GetDescendants()) do
        if pod.Name == "FreezePod" and pod:IsA("BasePart") then
            local isOccupied = false
            local podPos = pod.Position
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and isValidModel(plr.Character) then
                    local distance = (podPos - plr.Character.HumanoidRootPart.Position).Magnitude
                    if distance < 5 then
                        isOccupied = true
                        break
                    end
                end
            end
            if not isOccupied then
                local distance = (character.HumanoidRootPart.Position - podPos).Magnitude
                if distance < nearestDistance then
                    nearestPod = pod
                    nearestDistance = distance
                end
            end
        end
    end

    if not nearestPod then
        -- Se não houver pod livre, volta à posição original
        character.HumanoidRootPart.Position = originalPosition
        return
    end

    -- Teleporta até o pod livre e dispara ação para trancar
    character.HumanoidRootPart.CFrame = CFrame.new(nearestPod.Position)
    task.wait(0.1)
    remote:FireServer("Input", "Action", true)
    task.wait(0.1)

    -- Volta à posição original
    character.HumanoidRootPart.Position = originalPosition
end

-- Botão Kill All (beta, incompleto)
MainTab:AddButton({
    Name = "Kill all ( beta ) - ( bug ) - incompleto )",
    Callback = KillAll
})

-- ======================
-- AUTO KILL ALL
-- ======================
_G.AutoKillAllEvent = _G.AutoKillAllEvent or Instance.new("BindableEvent")
_G.AutoKillAllCount = _G.AutoKillAllCount or 0
local autoKillAllRunning = false

-- Loop que fica verificando e atacando o jogador mais próximo e usando pods
local function AutoKillAllLoop()
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent", 5)
    if not remote then return end

    while _G.AutoKillAllCount > 0 do
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local originalPosition = character.HumanoidRootPart.Position

            -- Encontra o jogador mais próximo
            local closestPlayer, closestDistance = nil, math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and isValidModel(plr.Character) then
                    local distance = (character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestPlayer = plr
                        closestDistance = distance
                    end
                end
            end

            if closestPlayer then
                -- Teleporta até o jogador e ataca
                character.HumanoidRootPart.CFrame = closestPlayer.Character.HumanoidRootPart.CFrame
                task.wait(0.1)
                remote:FireServer("Input", "Attack", true)
                task.wait(0.1)

                -- Encontra FreezePod livre mais próximo
                local nearestPod, nearestDistance = nil, math.huge
                for _, pod in ipairs(Workspace:GetDescendants()) do
                    if pod.Name == "FreezePod" and pod:IsA("BasePart") then
                        local isOccupied = false
                        local podPos = pod.Position
                        for _, plr2 in ipairs(Players:GetPlayers()) do
                            if plr2 ~= LocalPlayer and plr2.Character and isValidModel(plr2.Character) then
                                local distance2 = (podPos - plr2.Character.HumanoidRootPart.Position).Magnitude
                                if distance2 < 5 then
                                    isOccupied = true
                                    break
                                end
                            end
                        end
                        if not isOccupied then
                            local distance3 = (character.HumanoidRootPart.Position - podPos).Magnitude
                            if distance3 < nearestDistance then
                                nearestPod = pod
                                nearestDistance = distance3
                            end
                        end
                    end
                end

                if nearestPod then
                    -- Teleporta até o pod e tranca
                    character.HumanoidRootPart.CFrame = CFrame.new(nearestPod.Position)
                    task.wait(0.1)
                    remote:FireServer("Input", "Action", true)
                    task.wait(0.1)
                end

                -- Volta à posição original
                character.HumanoidRootPart.Position = originalPosition
            end

            task.wait(0.5)
        else
            task.wait(1)
        end
    end
end

-- Função que liga/desliga o Auto Kill All
local function ToggleAutoKillAll(val)
    _G.AutoKillAllCount += val and 1 or -1
    _G.AutoKillAllCount = math.max(0, _G.AutoKillAllCount)
    _G.AutoKillAllEvent:Fire(_G.AutoKillAllCount > 0)

    if _G.AutoKillAllCount > 0 and not autoKillAllRunning then
        autoKillAllRunning = true
        task.spawn(AutoKillAllLoop)
    else
        autoKillAllRunning = false
    end
end

-- Toggle na interface para Auto Kill All
local toggleAutoKillAll = MainTab:AddToggle({
    Name = "Auto Kill all ( beta ) - ( bug ) - incompleto )",
    Description = "mate todos se for a besta",
    Default = false,
    Callback = ToggleAutoKillAll
})

_G.AutoKillAllEvent.Event:Connect(function(state)
    if toggleAutoKillAll:Get() ~= state then
        toggleAutoKillAll:Set(state)
    end
end)

-- ======================
-- ABA ESP
-- ======================
local EspTab = window:MakeTab({ Name = "esp" })
EspTab:AddSection({ Name = "esp" })

-- ---------
-- COMPUTERS ESP
-- ---------
_G.ComputersEspEvent = _G.ComputersEspEvent or Instance.new("BindableEvent")
_G.ComputersEspCount = _G.ComputersEspCount or 0
local computerHighlights = {}

local function UpdateComputerHighlights()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "ComputerTable" then
            if not computerHighlights[obj] then
                local screen = obj:FindFirstChild("Screen")
                if screen and screen:IsA("BasePart") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ComputerESP"
                    hl.Adornee = obj
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = obj
                    computerHighlights[obj] = hl
                end
            end

            local screen = obj:FindFirstChild("Screen")
            if screen and computerHighlights[obj] then
                local hl = computerHighlights[obj]
                hl.FillColor = screen.Color
                hl.OutlineColor = screen.Color
            end
        end
    end

    for obj, hl in pairs(computerHighlights) do
        if not obj:IsDescendantOf(Workspace) then
            hl:Destroy()
            computerHighlights[obj] = nil
        end
    end
end

local computersRunning = false
local function ToggleComputersESP(val)
    _G.ComputersEspCount += val and 1 or -1
    _G.ComputersEspCount = math.max(0, _G.ComputersEspCount)
    _G.ComputersEspEvent:Fire(_G.ComputersEspCount > 0)

    if _G.ComputersEspCount > 0 and not computersRunning then
        computersRunning = true
        task.spawn(function()
            while _G.ComputersEspCount > 0 do
                UpdateComputerHighlights()
                task.wait(0.5)
            end
            for _, hl in pairs(computerHighlights) do
                hl:Destroy()
            end
            table.clear(computerHighlights)
            computersRunning = false
        end)
    end
end

local toggleComputers = EspTab:AddToggle({
    Name = "computers",
    Description = "destaca os computadores",
    Default = false,
    Callback = ToggleComputersESP
})
_G.ComputersEspEvent.Event:Connect(function(state)
    if toggleComputers:Get() ~= state then
        toggleComputers:Set(state)
    end
end)

-- ---------
-- FREEZER ESP
-- ---------
_G.FreezerEspEvent = _G.FreezerEspEvent or Instance.new("BindableEvent")
_G.FreezerEspCount = _G.FreezerEspCount or 0
local freezerHighlights = {}

local function UpdateFreezerHighlights()
    for _, pod in ipairs(Workspace:GetDescendants()) do
        if pod.Name == "FreezePod" and pod:IsA("BasePart") then
            if not freezerHighlights[pod] then
                local hl = Instance.new("Highlight")
                hl.Name = "FreezerESP"
                hl.Adornee = pod
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = pod
                freezerHighlights[pod] = hl
            end

            -- Verifica ocupação pelo jogador (distância < 5)
            local occupied = false
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and isValidModel(plr.Character) then
                    local dist = (pod.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 5 then
                        occupied = true
                        break
                    end
                end
            end

            local hl = freezerHighlights[pod]
            if occupied then
                hl.FillColor = Color3.fromRGB(255, 0, 0)    -- vermelho se ocupado
                hl.OutlineColor = Color3.fromRGB(255, 0, 0)
            else
                hl.FillColor = Color3.fromRGB(0, 255, 0)    -- verde se livre
                hl.OutlineColor = Color3.fromRGB(0, 255, 0)
            end
        end
    end

    for pod, hl in pairs(freezerHighlights) do
        if not pod:IsDescendantOf(Workspace) then
            hl:Destroy()
            freezerHighlights[pod] = nil
        end
    end
end

local freezerRunning = false
local function ToggleFreezerESP(val)
    _G.FreezerEspCount += val and 1 or -1
    _G.FreezerEspCount = math.max(0, _G.FreezerEspCount)
    _G.FreezerEspEvent:Fire(_G.FreezerEspCount > 0)

    if _G.FreezerEspCount > 0 and not freezerRunning then
        freezerRunning = true
        task.spawn(function()
            while _G.FreezerEspCount > 0 do
                UpdateFreezerHighlights()
                task.wait(0.5)
            end
            for _, hl in pairs(freezerHighlights) do
                hl:Destroy()
            end
            table.clear(freezerHighlights)
            freezerRunning = false
        end)
    end
end

local toggleFreezer = EspTab:AddToggle({
    Name = "Freezer",
    Description = "destaca os pods de congelamento",
    Default = false,
    Callback = ToggleFreezerESP
})
_G.FreezerEspEvent.Event:Connect(function(state)
    if toggleFreezer:Get() ~= state then
        toggleFreezer:Set(state)
    end
end)

-- ---------
-- EXIT DOORS ESP
-- ---------
_G.ExitEspEvent = _G.ExitEspEvent or Instance.new("BindableEvent")
_G.ExitEspCount = _G.ExitEspCount or 0
local exitHighlights = {}

local function UpdateExitHighlights()
    for _, door in ipairs(Workspace:GetDescendants()) do
        if door.Name == "ExitDoor" and door:IsA("BasePart") then
            if not exitHighlights[door] then
                local hl = Instance.new("Highlight")
                hl.Name = "ExitDoorESP"
                hl.Adornee = door
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillColor = Color3.fromRGB(0, 255, 0)   -- verde para portas
                hl.OutlineColor = Color3.fromRGB(0, 255, 0)
                hl.Parent = door
                exitHighlights[door] = hl
            end
        end
    end

    for door, hl in pairs(exitHighlights) do
        if not door:IsDescendantOf(Workspace) then
            hl:Destroy()
            exitHighlights[door] = nil
        end
    end
end

local exitRunning = false
local function ToggleExitESP(val)
    _G.ExitEspCount += val and 1 or -1
    _G.ExitEspCount = math.max(0, _G.ExitEspCount)
    _G.ExitEspEvent:Fire(_G.ExitEspCount > 0)

    if _G.ExitEspCount > 0 and not exitRunning then
        exitRunning = true
        task.spawn(function()
            while _G.ExitEspCount > 0 do
                UpdateExitHighlights()
                task.wait(0.5)
            end
            for _, hl in pairs(exitHighlights) do
                hl:Destroy()
            end
            table.clear(exitHighlights)
            exitRunning = false
        end)
    end
end

local toggleExit = EspTab:AddToggle({
    Name = "Exit Doors",
    Description = "destaca as portas de saída",
    Default = false,
    Callback = ToggleExitESP
})
_G.ExitEspEvent.Event:Connect(function(state)
    if toggleExit:Get() ~= state then
        toggleExit:Set(state)
    end
end)

-- ---------
-- PLAYERS ESP
-- ---------
_G.PlayersEspEvent = _G.PlayersEspEvent or Instance.new("BindableEvent")
_G.PlayersEspCount = _G.PlayersEspCount or 0
local playerHighlights = {}

-- Função para verificar se jogador está segurando martelo (Hammer)
local function HasHammer(player)
    local char = Workspace:FindFirstChild(player.Name)
    return char and char:FindFirstChild("Hammer") ~= nil
end

local function UpdatePlayerHighlights()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = Workspace:FindFirstChild(plr.Name)
            if char and isValidModel(char) then
                if not playerHighlights[plr] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "PlayerESP"
                    hl.Adornee = char
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = char
                    playerHighlights[plr] = hl
                else
                    playerHighlights[plr].Adornee = char
                end

                -- Se o jogador tiver Hammer, vermelho; senão verde
                local color = HasHammer(plr) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                local hl = playerHighlights[plr]
                hl.FillColor = color
                hl.OutlineColor = color
            end
        end
    end

    for plr, hl in pairs(playerHighlights) do
        if not Players:FindFirstChild(plr.Name) or not Workspace:FindFirstChild(plr.Name) then
            hl:Destroy()
            playerHighlights[plr] = nil
        end
    end
end

local playerEspRunning = false
local function TogglePlayersESP(val)
    _G.PlayersEspCount += val and 1 or -1
    _G.PlayersEspCount = math.max(0, _G.PlayersEspCount)
    _G.PlayersEspEvent:Fire(_G.PlayersEspCount > 0)

    if _G.PlayersEspCount > 0 and not playerEspRunning then
        playerEspRunning = true
        task.spawn(function()
            while _G.PlayersEspCount > 0 do
                UpdatePlayerHighlights()
                task.wait(0.3)
            end
            for _, hl in pairs(playerHighlights) do
                hl:Destroy()
            end
            table.clear(playerHighlights)
            playerEspRunning = false
        end)
    end
end

local togglePlayers = EspTab:AddToggle({
    Name = "Players",
    Description = "destaca os players ( beast ) - ( survivors )",
    Default = false,
    Callback = TogglePlayersESP
})
_G.PlayersEspEvent.Event:Connect(function(state)
    if togglePlayers:Get() ~= state then
        togglePlayers:Set(state)
    end
end)

-- ======================
-- ABA TOOLS
-- ======================
local ToolsTab = window:MakeTab({ Name = "Tools" })
ToolsTab:AddSection({ Name = "survivor" })

-- ---------
-- ANTI FAIL
-- ---------
_G.AntiFailEvent = _G.AntiFailEvent or Instance.new("BindableEvent")
_G.AntiFailCount = _G.AntiFailCount or 0
local antiFailRunning = false

local function NoFailLoop()
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent", 5)
    if not remote then return end
    while _G.AntiFailCount > 0 do
        local args = { "SetPlayerMinigameResult", true }
        remote:FireServer(unpack(args))
        task.wait(0.1)
    end
end

local function ToggleAntiFail(val)
    _G.AntiFailCount += val and 1 or -1
    _G.AntiFailCount = math.max(0, _G.AntiFailCount)
    _G.AntiFailEvent:Fire(_G.AntiFailCount > 0)

    if _G.AntiFailCount > 0 and not antiFailRunning then
        antiFailRunning = true
        task.spawn(NoFailLoop)
    else
        antiFailRunning = false
    end
end

local toggleAntiFail = ToolsTab:AddToggle({
    Name = "Anti Fail",
    Description = "Não falhe em computadores mas aperte o botão \"e\"",
    Default = false,
    Callback = ToggleAntiFail
})

_G.AntiFailEvent.Event:Connect(function(state)
    if toggleAntiFail:Get() ~= state then
        toggleAntiFail:Set(state)
    end
end)

-- -------------
-- AUTO INTERACT
-- -------------
_G.AutoInteractEvent = _G.AutoInteractEvent or Instance.new("BindableEvent")
_G.AutoInteractCount = _G.AutoInteractCount or 0
local autoInteractRunning = false

local function AutoInteractLoop()
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent", 5)
    if not remote then return end
    while _G.AutoInteractCount > 0 do
        local args = { "Input", "Action", true }
        remote:FireServer(unpack(args))
        task.wait(0.1)
    end
end

local function ToggleAutoInteract(val)
    _G.AutoInteractCount += val and 1 or -1
    _G.AutoInteractCount = math.max(0, _G.AutoInteractCount)
    _G.AutoInteractEvent:Fire(_G.AutoInteractCount > 0)

    if _G.AutoInteractCount > 0 and not autoInteractRunning then
        autoInteractRunning = true
        task.spawn(AutoInteractLoop)
    else
        autoInteractRunning = false
    end
end

local toggleAutoInteract = ToolsTab:AddToggle({
    Name = "Auto Interact",
    Description = "interação automática",
    Default = false,
    Callback = ToggleAutoInteract
})

_G.AutoInteractEvent.Event:Connect(function(state)
    if toggleAutoInteract:Get() ~= state then
        toggleAutoInteract:Set(state)
    end
end)