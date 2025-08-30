updatePlayerCount()

-- Criando a TextLabel
local Label = AddTextLabel(Main, "")

-- Função para atualizar o tempo na TextLabel
local function updateTime(label)
    while true do
        local currentTime = os.date("%H:%M:%S")
        label.Text = "Hora atual: " .. currentTime
        wait(1)  -- Atualiza a cada segundo
    end
end

-- Iniciando a atualização da TextLabel
coroutine.wrap(updateTime)(Label)

local Label = AddTextLabel(Main,
{"Welcome To Shnmaxhub"})
local Label = AddTextLabel(Main,
{"Team | Shnmaxscripts"})
local Label = AddTextLabel(Main,
{"Script Development Helpers: XXXTENTACION The Lucca"})
local Label = AddTextLabel(Main,
{"Last Update to Hub: 19/Day/2024/Year/Jun/Month"})
local Label = AddTextLabel(Main,
{"Code Developed By: Shnmaxscripts Owner"})
local Label = AddTextLabel(Main,
{"Use Responsibly"})
local Label = AddTextLabel(Main,
{"Have a Great Experience!"})

local Main = MakeTab({Name = "Trolling"})

local Label = AddTextLabel(Main,
{"Aviso [!] Use Conforme Sua Responsabilidade"})

local section = AddSection(Main, {"Selecione um Método de Fling"})

-- Interface para Selecionar Método de Kill
local killMethodDropdown = AddDropdown(Main, {
    Name = "Selecionar Método De Kill",
    Default = "Couch",
    Options = {"Nenhum", "Couch"},
    Callback = function(value)
        if value == "Couch" then
            local args = {
                [1] = "PickingTools",
                [2] = "Couch"
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))
            print('Hello!')
        elseif value == "Nenhum" then
            -- Código a ser executado quando "Nenhum" for selecionado
            print("Nenhum método selecionado.")
        end
    end
})

local section = AddSection(Main, {"Matar Jogadores"})

-- Serviços necessários
local playerService = game:GetService('Players')
local runService = game:GetService('RunService')
local localPlayer = playerService.LocalPlayer
local backpack = localPlayer:FindFirstChildOfClass('Backpack')

-- Variáveis globais
local flingV14Toggle = false
local selectedFlingPlayerV14 = nil
local flingV14Connection
local playerSpawnedConnection
local spinFlingConnection
local bodyThrust

-- Função para obter a lista de jogadores
local function getPlayerList()
    local playerList = {}
    for _, player in ipairs(playerService:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

-- Função para atualizar o dropdown
local function updateDropdown(dropdown)
    UpdateDropdown(dropdown, getPlayerList())
end

-- Função para equipar o item "Couch"
local function equipCouch()
    print("Tentando equipar o sofá...")
    if backpack then
        local couchItem = backpack:FindFirstChild("Couch")
        if couchItem then
            couchItem.Parent = localPlayer.Character
            local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:EquipTool(couchItem)
                print("Sofá equipado.")
            else
                print("Humanoide não encontrado.")
            end
        else
            warn("Sofá não encontrado na mochila.")
        end
    else
        print("Mochila não encontrada.")
    end
end

-- Função para teleportar para a coordenada
local function teleportToCoordinate()
    print("Teleportando para a coordenada...")
    local teleportPosition = Vector3.new(198, 4, 234) -- Coordenada para onde você deseja teleportar
    localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
end

-- Função para flingar jogador (V14)
local function flingV14(targetPlayerName)
    local targetPlayer = playerService:FindFirstChild(targetPlayerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- Looping de teleportes no jogador selecionado
        flingV14Connection = runService.Heartbeat:Connect(function()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = targetPlayer.Character.HumanoidRootPart.CFrame
                      if toggle then
                    -- Teleportando uma unidade para cima
                    localPlayer.Character.HumanoidRootPart.CFrame = targetPosition * CFrame.new(0, 2, 0)
                else
                    -- Teleportando uma unidade para baixo
                    localPlayer.Character.HumanoidRootPart.CFrame = targetPosition * CFrame.new(0, -3, 0)
                    end
                toggle = not toggle
              end
              
            -- Verifica se o jogador sentou no 'SeatCouch' e realiza o teleporte para a coordenada
            if targetPlayer.Character:FindFirstChild("Humanoid") and targetPlayer.Character.Humanoid.SeatPart then
                teleportToCoordinate()
                flingV14Connection:Disconnect()
                flingV14Connection = nil
            end
        end)
    else
        print("Jogador alvo não encontrado ou inválido.")
    end
end

-- Função para detectar quando o jogador renasce
local function onPlayerRespawned(targetPlayer)
    if flingV14Toggle then
        -- Aguardar o renascimento do jogador
        playerSpawnedConnection = targetPlayer.CharacterAdded:Connect(function()
            wait(1) -- Tempo para garantir que o personagem foi totalmente carregado
            if flingV14Toggle then
                equipCouch() -- Equipar o sofá quando o jogador renasce
                flingV14(targetPlayer.Name)
            end
        end)
    end
end

-- Função para verificar e equipar o sofá caso não esteja equipado
local function ensureCouchEquipped()
    local character = localPlayer.Character
    if character then
        local equipped = false
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == "Couch" then
                equipped = true
                break
            end
        end
        if not equipped then
            equipCouch()
        end
    else
        print("Personagem não encontrado.")
    end
end

-- Função para desativar as colisões do personagem
local function disableCollisions(character)
    if character and character:FindFirstChild("Head") and character:FindFirstChild("UpperTorso") and character:FindFirstChild("LowerTorso") and character:FindFirstChild("HumanoidRootPart") then
        character.Head.CanCollide = false
        character.UpperTorso.CanCollide = false
        character.LowerTorso.CanCollide = false
        character.HumanoidRootPart.CanCollide = false
    else
        print("Parte do personagem não encontrada.")
    end
end

-- Função para reativar as colisões do personagem
local function resetCollisions(character)
    if character and character:FindFirstChild("Head") and character:FindFirstChild("UpperTorso") and character:FindFirstChild("LowerTorso") and character:FindFirstChild("HumanoidRootPart") then
        character.Head.CanCollide = true
        character.UpperTorso.CanCollide = true
        character.LowerTorso.CanCollide = true
        character.HumanoidRootPart.CanCollide = true
    end
end

-- Função para ativar o Spin Fling
local function activateSpinFling()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local power = 500 -- Pode ajustar isso para alterar a força do impulso

    -- Cria um novo BodyThrust
    bodyThrust = Instance.new("BodyThrust")
    bodyThrust.Parent = character.HumanoidRootPart
    bodyThrust.Force = Vector3.new(power, 500, power)
    bodyThrust.Location = character.HumanoidRootPart.Position

    -- Desativa as colisões
    spinFlingConnection = runService.Stepped:Connect(function()
        disableCollisions(character)
    end)

    print("Spin Fling ativado!")
end

-- Função para desativar o Spin Fling
local function deactivateSpinFling()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

    -- Desconecta a função de desativação de colisões
    if spinFlingConnection then
        spinFlingConnection:Disconnect()
        spinFlingConnection = nil
    end

    -- Remove o efeito de impulso do corpo
    if bodyThrust then
        bodyThrust:Destroy()
        bodyThrust = nil
    end

    -- Restaura as colisões do personagem
    resetCollisions(character)

    print("Spin Fling desativado!")
end

-- Função de callback para o toggle
local function onFlingV14Toggle(value)
    print("Toggle Fling V14:", value)
    flingV14Toggle = value
    if flingV14Toggle and selectedFlingPlayerV14 then
        local targetPlayer = playerService:FindFirstChild(selectedFlingPlayerV14)
        if targetPlayer then
            ensureCouchEquipped() -- Equipar o sofá ao ativar o toggle
            flingV14(targetPlayer.Name)
            onPlayerRespawned(targetPlayer)
            activateSpinFling() -- Ativar o Spin Fling quando o toggle é ativado
        end
    elseif not flingV14Toggle then
        -- Desconecta as conexões quando o toggle é desativado
        if flingV14Connection then
            flingV14Connection:Disconnect()
            flingV14Connection = nil
        end
        if playerSpawnedConnection then
            playerSpawnedConnection:Disconnect()
            playerSpawnedConnection = nil
        end
        deactivateSpinFling() -- Desativar o Spin Fling quando o toggle é desativado
    end
end

-- Adiciona o dropdown para selecionar o jogador
local playerDropdownV14Toggle = AddDropdown(Main, {
    Name = "Selecione o Jogador para Fling [V16]",
    Default = "",
    Options = getPlayerList(),
    Callback = function(playerName)
        selectedFlingPlayerV14 = playerName
        print("Jogador selecionado para Fling V16:", playerName)
    end
})

-- Atualiza a lista de jogadores quando os jogadores entram ou saem do jogo
playerService.PlayerAdded:Connect(function()
    print("Novo jogador adicionado. Atualizando a lista...")
    updateDropdown(playerDropdownV14Toggle)
end)

playerService.PlayerRemoving:Connect(function()
    print("Jogador saiu. Atualizando a lista...")
    updateDropdown(playerDropdownV14Toggle)
end)