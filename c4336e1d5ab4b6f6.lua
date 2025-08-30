local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({

    Title = "Incomum Hub",

    Icon = "door-open",

    Author = "by vc777",

    Folder = "MySuperHub",

    Size = UDim2.fromOffset(300, 200),

    Transparent = true,

    Theme = "Red",

    Resizable = true,

    SideBarWidth = 200,

    BackgroundImageTransparency = 0.42,

    HideSearchBar = true,

    ScrollBarEnabled = false,

    User = {

        Enabled = true,

        xxxhey_lorenzo1 = true,

        Callback = function()

            print("clicked")

        end,

    },

    KeySystem = { 

        Key = { "1234", "5678" },

        Note = "Key: 1234",

        Thumbnail = {

            Image = "rbxassetid://",

            Title = "Incomum Hub",

        },

        URL = "YOUR LINK TO GET KEY (Discord, Linkvertise, Pastebin, etc.)",

        SaveKey = false,

    },

})

local Tab = Window:Tab({

    Title = "Farm",

    Icon = "People",

    Locked = false,

})

local Button = Tab:Button({

    Title = "Plataform",

    Desc = "ao ativar isso o seu personagem cria uma plataforma que consegue te fazer voar muito OP confia no vc777 o mais lindo!",

    Locked = false,

    Callback = function()

        local Players = game:GetService("Players")

        local RunService = game:GetService("RunService")

        local UserInputService = game:GetService("UserInputService")

        local TweenService = game:GetService("TweenService")

        local player = Players.LocalPlayer

        local playerGui = player:WaitForChild("PlayerGui")

        local platform = nil

        local isActive = false

        local currentHeight = 0

        local elevationSpeed = 0.02

        local baseHeight = 0.5

        local platformSize = Vector3.new(8, 0.5, 8)

        local elevationConnection = nil

        local function createGUI()

            local screenGui = Instance.new("ScreenGui")

            screenGui.Name = "PlatformToggleGUI"

            screenGui.ResetOnSpawn = false

            screenGui.Parent = playerGui

            local mainFrame = Instance.new("Frame")

            mainFrame.Name = "MainFrame"

            mainFrame.Size = UDim2.new(0, 200, 0, 100)

            mainFrame.Position = UDim2.new(0, 20, 0, 20)

            mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)

            mainFrame.BorderSizePixel = 0

            mainFrame.Parent = screenGui

            local corner = Instance.new("UICorner")

            corner.CornerRadius = UDim.new(0, 10)

            corner.Parent = mainFrame

            local titleLabel = Instance.new("TextLabel")

            titleLabel.Name = "TitleLabel"

            titleLabel.Size = UDim2.new(1, 0, 0, 30)

            titleLabel.Position = UDim2.new(0, 0, 0, 0)

            titleLabel.BackgroundTransparency = 1

            titleLabel.Text = "Plataforma Elevadora"

            titleLabel.TextColor3 = Color3.new(1, 1, 1)

            titleLabel.TextScaled = true

            titleLabel.Font = Enum.Font.GothamBold

            titleLabel.Parent = mainFrame

            local toggleButton = Instance.new("TextButton")

            toggleButton.Name = "ToggleButton"

            toggleButton.Size = UDim2.new(0.8, 0, 0, 40)

            toggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)

            toggleButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)

            toggleButton.Text = "OFF"

            toggleButton.TextColor3 = Color3.new(1, 1, 1)

            toggleButton.TextScaled = true

            toggleButton.Font = Enum.Font.GothamBold

            toggleButton.Parent = mainFrame

            local buttonCorner = Instance.new("UICorner")

            buttonCorner.CornerRadius = UDim.new(0, 8)

            buttonCorner.Parent = toggleButton

            local statusLabel = Instance.new("TextLabel")

            statusLabel.Name = "StatusLabel"

            statusLabel.Size = UDim2.new(1, 0, 0, 20)

            statusLabel.Position = UDim2.new(0, 0, 0.8, 0)

            statusLabel.BackgroundTransparency = 1

            statusLabel.Text = "Altura: 0 studs"

            statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)

            statusLabel.TextScaled = true

            statusLabel.Font = Enum.Font.Gotham

            statusLabel.Parent = mainFrame

            return toggleButton, statusLabel

        end

        local function createPlatform()

            if platform then

                platform:Destroy()

            end

            local character = player.Character

            if not character or not character:FindFirstChild("HumanoidRootPart") then

                return

            end

            local rootPart = character.HumanoidRootPart

            local position = rootPart.Position

            platform = Instance.new("Part")

            platform.Name = "ElevatorPlatform"

            platform.Size = platformSize

            platform.Material = Enum.Material.Neon

            platform.BrickColor = BrickColor.new("Bright blue")

            platform.Anchored = true

            platform.CanCollide = true

            platform.Shape = Enum.PartType.Block

            platform.Position = Vector3.new(

                position.X,

                position.Y - (character.Humanoid.HipHeight + baseHeight + platformSize.Y/2),

                position.Z

            )

            platform.Parent = workspace

            currentHeight = 0

        end

        local function removePlatform()

            if platform then

                local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                local tween = TweenService:Create(platform, tweenInfo, {

                    Transparency = 1,

                    Size = Vector3.new(0.1, 0.1, 0.1)

                })

                tween:Play()

                tween.Completed:Connect(function()

                    platform:Destroy()

                    platform = nil

                end)

            end

            currentHeight = 0

        end

        local function updatePlatform()

            if platform and platform.Parent then

                local character = player.Character

                if character and character:FindFirstChild("HumanoidRootPart") then

                    local rootPart = character.HumanoidRootPart

                    local playerPos = rootPart.Position

                    currentHeight = currentHeight + elevationSpeed

                    local baseY = playerPos.Y - (character.Humanoid.HipHeight + baseHeight + platformSize.Y/2)

                    local newY = baseY + currentHeight

                    platform.Position = Vector3.new(

                        playerPos.X,

                        newY,

                        playerPos.Z

                    )

                end

            end

        end

        local function togglePlatform(button, statusLabel)

            isActive = not isActive

            if isActive then

                button.Text = "ON"

                button.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)

                createPlatform()

                elevationConnection = RunService.Heartbeat:Connect(function()

                    updatePlatform()

                    statusLabel.Text = string.format("Altura: %.1f studs", currentHeight)

                end)

            else

                button.Text = "OFF"

                button.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)

                if elevationConnection then

                    elevationConnection:Disconnect()

                    elevationConnection = nil

                end

                removePlatform()

                statusLabel.Text = "Altura: 0 studs"

            end

        end

        local function main()

            if not player.Character then

                player.CharacterAdded:Wait()

            end

            local toggleButton, statusLabel = createGUI()

            toggleButton.MouseButton1Click:Connect(function()

                togglePlatform(toggleButton, statusLabel)

            end)

            player.CharacterRemoving:Connect(function()

                if elevationConnection then

                    elevationConnection:Disconnect()

                    elevationConnection = nil

                end

                removePlatform()

                isActive = false

            end)

            player.CharacterAdded:Connect(function()

                wait(1)

                if isActive then

                    createPlatform()

                end

            end)

        end

        main()

        print("Script da Plataforma Elevadora com Seguimento carregado com sucesso!")

        print("okok")

    end

})

local Button = Tab:Button({

    Title = "Float",

    Desc = "te ajuda no steal a faz crianças chorar recomendo demais!",

    Locked = false,

    Callback = function()

        local player = game.Players.LocalPlayer

        local character = player.Character or player.CharacterAdded:Wait()

        local humanoid = character:WaitForChild("Humanoid")

        local rootPart = character:WaitForChild("HumanoidRootPart")

        local forwardSpeed = 55

        local gravityScale = 0.1

        local floatDuration = 7

        local walkSpeed = 32

        local isFloating = false

        local bodyVelocity = nil

        local originalHeight = 0

        local screenGui = Instance.new("ScreenGui")

        screenGui.Parent = player:WaitForChild("PlayerGui")

        screenGui.Name = "FloatUI"

        local floatButton = Instance.new("TextButton")

        floatButton.Size = UDim2.new(0, 100, 0, 50)

        floatButton.Position = UDim2.new(0.5, -50, 0.8, -25)

        floatButton.Text = "Float"

        floatButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

        floatButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        floatButton.Parent = screenGui

        local function applyFloat()

            if humanoid and rootPart and not isFloating then

                isFloating = true

                floatButton.Text = "Floating..."

                floatButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)

                originalHeight = rootPart.Position.Y

                game.Workspace.Gravity = 196.2 * gravityScale

                bodyVelocity = Instance.new("BodyVelocity")

                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

                bodyVelocity.Velocity = rootPart.CFrame.LookVector * forwardSpeed + Vector3.new(0, 0, 0)

                bodyVelocity.Parent = rootPart

                local bodyGyro = Instance.new("BodyGyro")

                bodyGyro.MaxTorque = Vector3.new(4000, 0, 4000)

                bodyGyro.CFrame = rootPart.CFrame

                bodyGyro.Parent = rootPart

                humanoid.WalkSpeed = walkSpeed

                wait(floatDuration)

                if bodyVelocity then

                    bodyVelocity:Destroy()

                    bodyVelocity = nil

                end

                if bodyGyro then

                    bodyGyro:Destroy()

                end

                game.Workspace.Gravity = 196.2

                humanoid.WalkSpeed = 16

                isFloating = false

                floatButton.Text = "Float"

                floatButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

            end

        end

        floatButton.MouseButton1Click:Connect(applyFloat)

        player.CharacterAdded:Connect(function(newCharacter)

            character = newCharacter

            humanoid = character:WaitForChild("Humanoid")

            rootPart = character:WaitForChild("HumanoidRootPart")

        end)

        print("clicked")

    end

})

-- Variável para armazenar o jogador selecionado

local selectedPlayerName = nil

-- Adicionando o Dropdown na aba "Farm"

local Dropdown = Tab:Dropdown({

    Title = "Selecionar Jogador",

    Desc = "Escolha um jogador da lista para interagir!",

    Locked = false,

    Options = {}, -- Inicialmente vazio, será preenchido com os jogadores

    Callback = function(selected)

        selectedPlayerName = selected

        print("Jogador selecionado: " .. selected)

    end

})

-- Função para atualizar a lista de jogadores no Dropdown

local function updatePlayerList()

    local players = game.Players:GetPlayers()

    local playerNames = {}

    for _, player in ipairs(players) do

        table.insert(playerNames, player.Name)

    end

    Dropdown:UpdateOptions(playerNames)

end

-- Atualizar a lista inicialmente

updatePlayerList()

-- Atualizar a lista quando um jogador entrar ou sair

game.Players.PlayerAdded:Connect(updatePlayerList)

game.Players.PlayerRemoving:Connect(updatePlayerList)

-- Adicionando o botão de teleporte

local TeleportButton = Tab:Button({

    Title = "Teleportar",

    Desc = "se você usar uma alt para ficar na frente da sua base e auto areal!!",

    Locked = false,

    Callback = function()

        local Players = game:GetService("Players")

        local localPlayer = Players.LocalPlayer

        local character = localPlayer.Character

        if not character or not character:FindFirstChild("HumanoidRootPart") then

            print("Erro: Personagem do jogador local não encontrado!")

            return

        end

        local localRootPart = character.HumanoidRootPart

        if not selectedPlayerName then

            print("Erro: Nenhum jogador selecionado no dropdown!")

            return

        end

        local targetPlayer = Players:FindFirstChild(selectedPlayerName)

        if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then

            print("Erro: Jogador selecionado não encontrado ou sem personagem!")

            return

        end

        local targetRootPart = targetPlayer.Character.HumanoidRootPart

        localRootPart.CFrame = targetRootPart.CFrame * CFrame.new(0, 0, -2) -- Teleporta para trás do jogador alvo

        print("Teleportado para: " .. selectedPlayerName)

    end

})

-- Adicionando o Toggle para ESP

local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local espEnabled = false

local espHighlights = {} -- Tabela para armazenar os Highlights de cada jogador

-- Função para adicionar ESP a um jogador

local function addESP(player)

    if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then

        local highlight = Instance.new("Highlight")

        highlight.Name = "ESPHighlight"

        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Cor do preenchimento (vermelho)

        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Cor do contorno (branco)

        highlight.FillTransparency = 0.7 -- Transparência do preenchimento

        highlight.OutlineTransparency = 0 -- Contorno opaco

        highlight.Adornee = player.Character

        highlight.Parent = player.Character

        espHighlights[player] = highlight

    end

end

-- Função para remover ESP de um jogador

local function removeESP(player)

    if espHighlights[player] then

        espHighlights[player]:Destroy()

        espHighlights[player] = nil

    end

end

-- Função para ativar/desativar ESP para todos os jogadores

local function toggleESP(value)

    espEnabled = value

    if espEnabled then

        -- Ativar ESP para todos os jogadores atuais

        for _, player in ipairs(Players:GetPlayers()) do

            addESP(player)

        end

        print("ESP ativado para todos os jogadores!")

    else

        -- Desativar ESP para todos os jogadores

        for player, _ in pairs(espHighlights) do

            removeESP(player)

        end

        print("ESP desativado!")

    end

end

-- Criar o Toggle para ESP

local ESPToggle = Tab:Toggle({

    Title = "ESP para Todos",

    Desc = "Ativa/desativa ESP para todos os jogadores!",

    Locked = false,

    Default = false,

    Callback = function(value)

        toggleESP(value)

    end

})

-- Atualizar ESP quando um jogador entra

Players.PlayerAdded:Connect(function(player)

    updatePlayerList() -- Atualizar o Dropdown

    if espEnabled then

        player.CharacterAdded:Connect(function()

            addESP(player)

        end)

    end

end)

-- Remover ESP quando um jogador sai

Players.PlayerRemoving:Connect(function(player)

    updatePlayerList() -- Atualizar o Dropdown

    removeESP(player)

end)

-- Atualizar ESP quando o personagem de um jogador é recarregado

for _, player in ipairs(Players:GetPlayers()) do

    if player ~= localPlayer then

        player.CharacterAdded:Connect(function()

            if espEnabled then

                addESP(player)

            end

        end)

    end

end