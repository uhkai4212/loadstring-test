local game = game
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players honom
local HttpService = game:GetService("HttpService")

-- Завантаження бібліотеки GUI (імітація wizard)
local wizard = loadstring(HttpService:HttpGet("https://raw.githubusercontent.com/blodbal/-back-ups-for-libs/main/wizard"))()

-- Створення GUI
local window = wizard.NewWindow("Credits: TGMANKASKE")
local boostSection = window.NewSection("Boosts")
local teleportSection = window.NewSection("Teleports")
local espSection = window.NewSection("ESP")
local extraSection = window.NewSection("Extras")

-- Змінні для збереження позиції
local savedPosition = nil

-- Функція для отримання Humanoid і HumanoidRootPart
local function getCharacter()
    return LocalPlayer.Character, LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- Boost Speed
boostSection.CreateButton("Boost Speed (updating)", function()
    local character, humanoidRootPart = getCharacter()
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 40 -- Збільшення швидкості
        end
    end
end)

-- Boost Jump
boostSection.CreateButton("Boost Jump", function()
    local character, humanoidRootPart = getCharacter()
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 100 -- Збільшення висоти стрибка
        end
    end
end)

-- Air Jump
boostSection.CreateButton("Air Jump", function()
    local character, humanoidRootPart = getCharacter()
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- Save Base Position
teleportSection.CreateButton("Save Base Position", function()
    local character, humanoidRootPart = getCharacter()
    if humanoidRootPart then
        savedPosition = humanoidRootPart.Position
    end
end)

-- Go to Saved Position
teleportSection.CreateButton("Go to Saved Position", function()
    local character, humanoidRootPart = getCharacter()
    if humanoidRootPart and savedPosition then
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(savedPosition)})
        tween:Play()
    end
end)

-- ESP (Wallhacks)
espSection.CreateButton("ESP", function()
    loadstring(HttpService:HttpGet("https://raw.githubusercontent.com/Blisful492/ESPs/main/UniversalSkeleton.lua"))()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                local drawing = Drawing.new("Text")
                drawing.Text = player.Name
                drawing.Visible = true
                drawing.Size = 20
                drawing.Center = true
                drawing.Position = Vector2.new(0, 0) -- Оновлюється через RenderStepped
                RunService.RenderStepped:Connect(function()
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local screenPos, visible = game.Workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                        drawing.Position = Vector2.new(screenPos.X, screenPos.Y)
                        drawing.Visible = visible
                    else
                        drawing.Visible = false
                    end
                end)
                humanoid.HealthChanged:Connect(function()
                    if humanoid.Health <= 0 then
                        drawing.Visible = false
                    end
                end)
            end
        end
    end
end)

-- WalkFling
espSection.CreateButton("WalkFling", function()
    local character, humanoidRootPart = getCharacter()
    if humanoidRootPart then
        RunService.RenderStepped:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetHrp and (targetHrp.Position - humanoidRootPart.Position).Magnitude < 10 then
                        targetHrp.Velocity = Vector3.new(100, 100, 100) -- Штовхає гравця
                    end
                end
            end
        end)
    end
end)

-- Server Hop
extraSection.CreateButton("Server Hop", function()
    loadstring(HttpService:HttpGet("https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua"))()
end)

-- Rejoin
extraSection.CreateButton("Rejoin", function()
    TeleportService:Teleport(game.PlaceId)
end)

-- See My Team
extraSection.CreateButton("See my team", function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Team == LocalPlayer.Team then
            print(player.Name)
        end
    end
end)

-- Друк авторів
print("tgmankaske")
print("Davitrolz")