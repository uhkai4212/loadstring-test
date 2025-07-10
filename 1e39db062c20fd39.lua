local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Traduções
local languages = {
	en = {
		open = "Open View Hub",
		title = "View Hub",
		money = "9.000Q easy",
		reset = "Reset Cash",
		resetMsg = "When you click OK, go to the cash machine and take the money to reset your money.",
		ok = "OK",
		close = "Close"
	},
	pt = {
		open = "Abrir View Hub",
		title = "Central de Visão",
		money = "9.000Q fácil",
		reset = "Redefinir Dinheiro",
		resetMsg = "Quando você clicar em OK, vá até o caixa eletrônico e pegue o dinheiro para redefinir seu dinheiro.",
		ok = "OK",
		close = "Fechar"
	}
}
local currentLang = "en"

-- Função de rotação animada
local function makeWobble(button)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {Rotation = 8}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {Rotation = 0}):Play()
	end)
	button.TouchTap:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.1), {Rotation = 0}):Play()
	end)
end

-- GUI principal
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ViewHubGUI"
gui.ResetOnSpawn = false

-- Botão de abrir
local openButton = Instance.new("TextButton", gui)
openButton.Size = UDim2.new(0, 140, 0, 40)
openButton.Position = UDim2.new(0, 10, 0, 10)
openButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
openButton.TextColor3 = Color3.new(1,1,1)
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 14
makeWobble(openButton)

-- Botões de idioma
local enBtn = Instance.new("TextButton", gui)
enBtn.Size = UDim2.new(0, 80, 0, 30)
enBtn.Position = UDim2.new(0, 10, 0, 60)
enBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
enBtn.Text = "English"
enBtn.TextColor3 = Color3.new(1,1,1)
enBtn.Font = Enum.Font.GothamBold
enBtn.TextSize = 14
makeWobble(enBtn)

local ptBtn = Instance.new("TextButton", gui)
ptBtn.Size = UDim2.new(0, 80, 0, 30)
ptBtn.Position = UDim2.new(0, 100, 0, 60)
ptBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
ptBtn.Text = "Português"
ptBtn.TextColor3 = Color3.new(1,1,1)
ptBtn.Font = Enum.Font.GothamBold
ptBtn.TextSize = 14
makeWobble(ptBtn)

-- Frame principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.Visible = false
frame.Active = true

local border = Instance.new("UIStroke", frame)
border.Thickness = 3
border.Color = Color3.fromRGB(128, 0, 255)

task.spawn(function()
	while true do
		for i = 0, 1, 0.01 do border.Transparency = i task.wait(0.01) end
		for i = 1, 0, -0.01 do border.Transparency = i task.wait(0.01) end
	end
end)

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

-- Botão fechar [X]
local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(30, 0, 40)
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
makeWobble(closeButton)

-- Botão 9.000Q
local moneyButton = Instance.new("TextButton", frame)
moneyButton.Size = UDim2.new(0.8, 0, 0, 40)
moneyButton.Position = UDim2.new(0.1, 0, 0.3, 0)
moneyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
moneyButton.TextColor3 = Color3.new(1,1,1)
moneyButton.Font = Enum.Font.GothamBold
moneyButton.TextSize = 16
makeWobble(moneyButton)

-- Botão reset
local resetButton = Instance.new("TextButton", frame)
resetButton.Size = UDim2.new(0.8, 0, 0, 40)
resetButton.Position = UDim2.new(0.1, 0, 0.6, 0)
resetButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
resetButton.TextColor3 = Color3.new(1,1,1)
resetButton.Font = Enum.Font.GothamBold
resetButton.TextSize = 16
makeWobble(resetButton)

-- Caixa de mensagem
local msgFrame = Instance.new("Frame", gui)
msgFrame.Size = UDim2.new(0, 300, 0, 150)
msgFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
msgFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
msgFrame.Visible = false

local msgBorder = Instance.new("UIStroke", msgFrame)
msgBorder.Thickness = 3
msgBorder.Color = Color3.fromRGB(128, 0, 255)

task.spawn(function()
	while true do
		for i = 0, 1, 0.01 do msgBorder.Transparency = i task.wait(0.01) end
		for i = 1, 0, -0.01 do msgBorder.Transparency = i task.wait(0.01) end
	end
end)

local msgText = Instance.new("TextLabel", msgFrame)
msgText.Size = UDim2.new(1, -20, 0.6, 0)
msgText.Position = UDim2.new(0, 10, 0, 10)
msgText.BackgroundTransparency = 1
msgText.TextColor3 = Color3.new(1, 1, 1)
msgText.Font = Enum.Font.Gotham
msgText.TextWrapped = true
msgText.TextSize = 14

local okBtn = Instance.new("TextButton", msgFrame)
okBtn.Size = UDim2.new(0, 100, 0, 30)
okBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
okBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
okBtn.TextColor3 = Color3.new(1, 1, 1)
okBtn.Font = Enum.Font.GothamBold
okBtn.TextSize = 14
makeWobble(okBtn)

local closeBtn = Instance.new("TextButton", msgFrame)
closeBtn.Size = UDim2.new(0, 100, 0, 30)
closeBtn.Position = UDim2.new(0.6, 0, 0.7, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
makeWobble(closeBtn)

-- Função de tradução
local function updateLanguage()
	local lang = languages[currentLang]
	openButton.Text = lang.open
	title.Text = lang.title
	moneyButton.Text = lang.money
	resetButton.Text = lang.reset
	closeButton.Text = lang.close
	okBtn.Text = lang.ok
	closeBtn.Text = lang.close
	msgText.Text = lang.resetMsg
end

-- Eventos
openButton.MouseButton1Click:Connect(function()
	frame.Visible = true
end)

closeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

moneyButton.MouseButton1Click:Connect(function()
	local args = {[1] = 9000000000000000000}
	game:GetService("ReplicatedStorage").fewjnfejwb3:FireServer(unpack(args))
end)

resetButton.MouseButton1Click:Connect(function()
	updateLanguage()
	msgFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
	msgFrame.Visible = false
end)

okBtn.MouseButton1Click:Connect(function()
	msgFrame.Visible = false
	local args = {[1] = 1000000000000000000000}
	game:GetService("ReplicatedStorage").fewjnfejwb3:FireServer(unpack(args))
end)

enBtn.MouseButton1Click:Connect(function()
	currentLang = "en"
	updateLanguage()
end)

ptBtn.MouseButton1Click:Connect(function()
	currentLang = "pt"
	updateLanguage()
end)

-- Mover o menu
local dragging, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true dragStart = input.Position startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		update(input)
	end
end)

-- Atualiza idioma inicial
updateLanguage()