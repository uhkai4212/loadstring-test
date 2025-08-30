playSound()

local Main = MakeTab({Name = "Welcome"})

-- Create a label to show the number of players
local playerCountLabel = AddTextLabel(Main, "Jogadores No Servidor: " .. #game.Players:GetPlayers())

-- Função para atualizar o número de jogadores quando alguém entra ou sai
local function updatePlayerCount()
    playerCountLabel.Text = "Jogadores No Servidor: " .. #game.Players:GetPlayers()
end

-- Conecta a função ao evento de entrada de novos jogadores
game.Players.PlayerAdded:Connect(updatePlayerCount)

-- Conecta a função ao evento de saída de jogadores
game.Players.PlayerRemoving:Connect(updatePlayerCount)