updateDropdown(playerDropdownV14Toggle)

-- Variável para armazenar o estado da proteção
local voidProtectionEnabled = false

-- Função para ativar a proteção contra o vazio
local function ActivateVoidProtection()
    voidProtectionEnabled = true
    -- Definindo FallenPartsDestroyHeight para NaN para prevenir a destruição
    game.Workspace.FallenPartsDestroyHeight = 0/0
end

-- Função para desativar a proteção contra o vazio
local function DeactivateVoidProtection()
    voidProtectionEnabled = false
    -- Definindo FallenPartsDestroyHeight para um valor que permite destruição
    game.Workspace.FallenPartsDestroyHeight = -9999999999999 -- Ajuste este valor conforme necessário
end

-- Adiciona o Toggle e define o callback para ativar/desativar a proteção contra o vazio e a função original
AddToggle(Main, {
    Name = "Fling [V16]",
    Default = false,
    Callback = function(value)
        -- Mantém a funcionalidade original do Toggle
        onFlingV14Toggle(value)

        -- Ativa ou desativa a proteção contra o vazio
        if value then
            ActivateVoidProtection()
            print("Void protection activated.")
        else
            DeactivateVoidProtection()
            print("Void protection deactivated.")
        end

        -- Imprime o estado atual do Toggle
        print("Toggle de Fling [V16] foi alterado para:", value)
    end
})

local section = AddSection(Main, {"View"})

-- Função para enviar notificações
function MakeNotifi(notification)
    game.StarterGui:SetCore("SendNotification", {
        Title = notification.Title;
        Text = notification.Text;
        Duration = notification.Time;
    })
end

-- Variáveis e funções para a visualização dos jogadores
local viewEnabled = false
local selectedViewPlayer = nil
local characterAddedConnection = nil

local function toggleView(enabled)
    if enabled then
        if selectedViewPlayer then
            local player = selectedViewPlayer
            if player then
                game.Workspace.CurrentCamera.CameraSubject = player.Character
                if characterAddedConnection then
                    characterAddedConnection:Disconnect()
                end
                characterAddedConnection = player.CharacterAdded:Connect(function(character)
                    game.Workspace.CurrentCamera.CameraSubject = character
                end)
                MakeNotifi({
                    Title = "Visualizando " .. player.Name,
                    Text = "Você está visualizando o jogador: " .. player.Name,
                    Time = 6
                })
            else
                print("Jogador não encontrado.")
                viewEnabled = false
            end
        else
            print("Nenhum jogador selecionado para a visualização.")
            viewEnabled = false
        end
    else
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
            characterAddedConnection = nil
        end
        game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
    end
end

local value = "" -- Variável para armazenar o nome digitado

local function findPlayerByPartialNameOrNickname(partialName)
    value = partialName -- Atualiza a variável com o nome digitado completo
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Name:lower():find(partialName:lower(), 1, true) or (player.DisplayName and player.DisplayName:lower():find(partialName:lower(), 1, true)) then
            return player
        end
    end
    return nil
end

-- Adicionando a caixa de texto para entrada do nome ou apelido do jogador
AddTextBox(Main, {
    Name = "Digite o Nome ou Apelido do Jogador",
    Default = "",
    PlaceholderText = "Digite aqui para view",
    ClearText = true,
    Callback = function(value)
        if value == "" then
            MakeNotifi({
                Title = "Erro",
                Text = "Nome do jogador não foi digitado.",
                Time = 5
            })
            if viewEnabled then
                toggleView(false)
            end
            return
        end

        selectedViewPlayer = findPlayerByPartialNameOrNickname(value)
        if selectedViewPlayer then
            print("Jogador encontrado: " .. selectedViewPlayer.Name)
            if viewEnabled then
                toggleView(false)
                toggleView(true)
            end
        else
            MakeNotifi({
                Title = "Erro",
                Text = "Nenhum jogador encontrado com esse nome ou apelido.",
                Time = 7
            })
            if viewEnabled then
                toggleView(false)
            end
        end
    end
})

-- Adicionando o toggle para ativar/desativar a visualização
AddToggle(Main, {
    Name = "View",
    Default = false,
    Callback = function(enabled)
        viewEnabled = enabled
        toggleView(enabled)
    end
})

-- Conectando eventos de jogador 
game.Players.PlayerRemoving:Connect(function(player)
    if selectedViewPlayer == player then
        selectedViewPlayer = nil
        if viewEnabled then
            toggleView(false)
            MakeNotifi({
                Title = "Jogador Saiu",
                Text = player.Name .. " saiu do jogo. Visualização desativada.",
                Time = 5
            })
        end
    end
end)

-- Função para manter a câmera no jogador selecionado
local function maintainView()
    while wait() do
        if viewEnabled and selectedViewPlayer then
            local player = selectedViewPlayer
            if player and game.Workspace.CurrentCamera.CameraSubject ~= player.Character then
                game.Workspace.CurrentCamera.CameraSubject = player.Character
            end
        end
    end
end

-- Iniciando a função de manutenção da câmera
spawn(maintainView)

local section = AddSection(Main, {"Flings Spins | Avatar"})

AddButton(Main, {
  Name = "Ficar Super Pequeno",
     Callback = function()
        -- Cria os argumentos para diminuir o tamanho do personagem
        local args = {
            [1] = "CharacterSizeDown",
            [2] = 4
        }
        -- Envia um pedido ao servidor para diminuir o tamanho do personagem
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clothe1s"):FireServer(unpack(args))
    end
})

-- Serviço necessário para manipular as atualizações de tempo
local runService = game:GetService('RunService')
-- Referência ao jogador local
local player = game.Players.LocalPlayer
-- Variáveis para a conexão e o efeito de impulso do corpo
local connection
local bodyThrust

-- Função para desativar as colisões do personagem
local function disableCollisions(character)
    if character and character:FindFirstChild("Head") and character:FindFirstChild("UpperTorso") and character:FindFirstChild("LowerTorso") and character:FindFirstChild("HumanoidRootPart") then
        character.Head.CanCollide = false
        character.UpperTorso.CanCollide = false
        character.LowerTorso.CanCollide = false
        character.HumanoidRootPart.CanCollide = false
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

-- Função chamada quando o personagem é adicionado
local function onCharacterAdded(character)
    -- Desconecta qualquer conexão existente
    if connection then
        connection:Disconnect()
    end

    -- Conecta-se ao evento Stepped para desativar as colisões continuamente
    connection = runService.Stepped:Connect(function()
        disableCollisions(character)
    end)
end

-- Conecta a função onCharacterAdded ao evento CharacterAdded
player.CharacterAdded:Connect(onCharacterAdded)
-- Se o personagem já estiver presente, executa onCharacterAdded imediatamente
if player.Character then
    onCharacterAdded(player.Character)
end

-- Função para ativar o Spin Fling
local function activateSpinFling()
    local character = player.Character or player.CharacterAdded:Wait()
    local power = 280 -- Pode ajustar isso para alterar a força do impulso

    -- Cria um novo BodyThrust
    bodyThrust = Instance.new("BodyThrust")
    bodyThrust.Parent = character.HumanoidRootPart
    bodyThrust.Force = Vector3.new(power, 280, power)
    bodyThrust.Location = character.HumanoidRootPart.Position

    -- Desativa as colisões
    connection = runService.Stepped:Connect(function()
        disableCollisions(character)
    end)

    print("Spin Fling V4 ativado!")
end

-- Função para desativar o Spin Fling
local function deactivateSpinFling()
    local character = player.Character or player.CharacterAdded:Wait()

    -- Desconecta a função de desativação de colisões
    if connection then
        connection:Disconnect()
        connection = nil
    end

    -- Remove o efeito de impulso do corpo
    if bodyThrust then
        bodyThrust:Destroy()
        bodyThrust = nil
    end

    -- Restaura as colisões do personagem
    resetCollisions(character)

    print("Spin Fling V5 desativado!")
end

-- Adiciona um Toggle para ativar/desativar o Spin Fling na aba principal
AddToggle(Main, {
  Name = "Spin Fling [V6]",
  Default = false,
  Callback = function(Value)
    if Value then
        activateSpinFling()
    else
        deactivateSpinFling()
    end
  end
})

-- Serviço necessário para manipular as atualizações de tempo
local runService = game:GetService('RunService')
-- Referência ao jogador local
local player = game.Players.LocalPlayer
-- Variáveis para a conexão e o efeito de impulso do corpo
local connection
local bodyThrust

-- Função para desativar as colisões do personagem
local function disableCollisions(character)
    if character and character:FindFirstChild("Head") and character:FindFirstChild("UpperTorso") and character:FindFirstChild("LowerTorso") and character:FindFirstChild("HumanoidRootPart") then
        character.Head.CanCollide = false
        character.UpperTorso.CanCollide = false
        character.LowerTorso.CanCollide = false
        character.HumanoidRootPart.CanCollide = false
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

-- Função chamada quando o personagem é adicionado
local function onCharacterAdded(character)
    -- Desconecta qualquer conexão existente
    if connection then
        connection:Disconnect()
    end

    -- Conecta-se ao evento Stepped para desativar as colisões continuamente
    connection = runService.Stepped:Connect(function()
        disableCollisions(character)
    end)
end

-- Conecta a função onCharacterAdded ao evento CharacterAdded
player.CharacterAdded:Connect(onCharacterAdded)
-- Se o personagem já estiver presente, executa onCharacterAdded imediatamente
if player.Character then
    onCharacterAdded(player.Character)
end

-- Função para ativar o Spin Fling
local function activateSpinFling()
    local character = player.Character or player.CharacterAdded:Wait()
    local power = 350 -- Pode ajustar isso para alterar a força do impulso

    -- Cria um novo BodyThrust
    bodyThrust = Instance.new("BodyThrust")
    bodyThrust.Parent = character.HumanoidRootPart
    bodyThrust.Force = Vector3.new(power, 350, power)
    bodyThrust.Location = character.HumanoidRootPart.Position

    -- Desativa as colisões
    connection = runService.Stepped:Connect(function()
        disableCollisions(character)
    end)

    print("Spin Fling V4 ativado!")
end

-- Função para desativar o Spin Fling
local function deactivateSpinFling()
    local character = player.Character or player.CharacterAdded:Wait()

    -- Desconecta a função de desativação de colisões
    if connection then
        connection:Disconnect()
        connection = nil
    end

    -- Remove o efeito de impulso do corpo
    if bodyThrust then
        bodyThrust:Destroy()
        bodyThrust = nil
    end

    -- Restaura as colisões do personagem
    resetCollisions(character)

    print("Spin Fling V5 desativado!")
end

-- Adiciona um Toggle para ativar/desativar o Spin Fling na aba principal
AddToggle(Main, {
  Name = "Spin Fling [V7]",
  Default = false,
  Callback = function(Value)
    if Value then
        activateSpinFling()
    else
        deactivateSpinFling()
    end
  end
})

-- Variável para controlar o estado do toggle
local isToggleActive = false

-- Função para encontrar e equipar/desequipar o item "Couch" no inventário
local function toggleEquipCouch(enable)
    isToggleActive = enable  -- Atualiza o estado do toggle
    
    while isToggleActive do
        -- Iterar sobre os itens do jogador no inventário (Backpack)
        for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            -- Verificar se o nome do item contém "Couch"
            if string.find(item.Name:lower(), "couch") then
                -- Equipar o item movendo-o para o personagem
                item.Parent = game.Players.LocalPlayer.Character
            end
        end
        
        -- Aguardar um curto período de tempo antes de desequipar novamente
        wait(0.0)  -- Ajuste o tempo conforme necessário para controlar a velocidade
        
        -- Iterar novamente para desequipar o item "Couch"
        for _, item in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if string.find(item.Name:lower(), "couch") then
                -- Desequipar o item movendo-o para o inventário
                item.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        
        -- Aguardar novamente antes da próxima iteração
        wait(0.0)  -- Ajuste o tempo conforme necessário para controlar a velocidade
    end
end

-- Adicionando o Toggle no Roblox (assumindo que AddToggle seja uma função válida)
local Toggle = AddToggle(Main, {
    Name = "Equipar/Desequipar Couch [V2]",
    Default = false,
    Callback = function(Value)
        if Value then
            -- Quando o toggle é ativado, iniciar o loop de equipar/desequipar
            toggleEquipCouch(true)
        else
            -- Quando o toggle é desativado, parar o loop de equipar/desequipar
            isToggleActive = false
        end
    end
})

local section = AddSection(Main, {"Fling [V13] Old"})

-- Serviços necessários
local playerService = game:GetService('Players')
local runService = game:GetService('RunService')
local player = playerService.LocalPlayer

-- Variáveis globais
local selectedPlayer = nil
local selectedKillAdvancedPlayer = nil
local couchEquipped = false
local playerDropdownV13

-- Função para obter a lista de jogadores
local function getPlayerList()
    local playerList = {}
    for _, player in ipairs(playerService:GetPlayers()) do
        if player ~= playerService.LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

-- Função para atualizar o dropdown
local function updateDropdown(dropdown)
    UpdateDropdown(dropdown, getPlayerList())
end

-- Função para encontrar jogador por nome
local function gplr(String)
    local strl = String:lower()
    local Found = {}
    for _, v in pairs(playerService:GetPlayers()) do
        if v.Name:lower():sub(1, #strl) == strl then
            table.insert(Found, v)
        end
    end
    return Found
end

-- Função para flingar jogador (V13)
local function flingPlayer(targetName)
    local Target = gplr(targetName)
    if Target[1] then
        Target = Target[1]
        
        local Thrust = Instance.new('BodyThrust', player.Character.HumanoidRootPart)
        Thrust.Force = Vector3.new(999, 999, 999)
        Thrust.Name = "FlingForce"
        repeat
            player.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
            Thrust.Location = Target.Character.HumanoidRootPart.Position
            runService.Heartbeat:Wait()
        until not Target.Character:FindFirstChild("Head")
    end
end

-- Interface para Fling V13
playerDropdownV13 = AddDropdown(Main, {
    Name = "Selecione o Jogador para Fling [V13]",
    Default = "",
    Options = getPlayerList(),
    Callback = function(value)
        selectedPlayer = value
    end
})

AddButton(Main, {
    Name = "Fling [V13]",
    Callback = function()
        if selectedPlayer then
            flingPlayer(selectedPlayer)
        end
    end
})

-- Atualiza a lista de jogadores quando os jogadores entram ou saem do jogo
playerService.PlayerAdded:Connect(function()
    updateDropdown(playerDropdownV13)
end)

playerService.PlayerRemoving:Connect(function()
    updateDropdown(playerDropdownV13)
end)