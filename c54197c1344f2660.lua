local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    Workspace = game:GetService("Workspace")
}

local LocalPlayer = Services.Players.LocalPlayer
local Camera = Services.Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local aimbotLerpFactor = 0.1
local isEspEnabled = false
local isAimbotEnabled = false
local isInfiniteJumpEnabled = false
local playerSpeed = 28

-- Function to display error overlay
local function showErrorOverlay(errorMessage)
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "ErrorOverlay"
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 400, 0, 100)
    frame.Position = UDim2.new(0, 10, 1, -110)
    frame.BackgroundColor3 = Color3.fromRGB(170, 35, 35)
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, -20, 1, -20)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.TextSize = 18
    textLabel.TextWrapped = true
    textLabel.Text = ("Something seems off.\nDM leftpapi on Discord for help.\n\nError: %s"):format(tostring(errorMessage))
end

-- Function to display thank you message
local function showThankYouGui()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "ThankYouGui"
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 190, 0, 40)
    frame.Position = UDim2.new(0.5, 0, 0, 40)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(22, 34, 72)
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local iconFrame = Instance.new("Frame", frame)
    iconFrame.Size = UDim2.new(0, 30, 0, 30)
    iconFrame.Position = UDim2.new(0, 5, 0.5, -15)
    iconFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    iconFrame.BorderSizePixel = 0

    local iconCorner = Instance.new("UICorner", iconFrame)
    iconCorner.CornerRadius = UDim.new(1, 0)

    local iconLabel = Instance.new("TextLabel", iconFrame)
    iconLabel.Size = UDim2.new(1, 0, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "i"
    iconLabel.TextColor3 = Color3.new(0, 0, 0)
    iconLabel.Font = Enum.Font.FredokaOne
    iconLabel.TextSize = 20
    iconLabel.Rotation = 180

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, -45, 1, 0)
    textLabel.Position = UDim2.new(0, 40, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "ty for using left ink :)"
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.TextSize = 16
    textLabel.TextXAlignment = Enum.TextXAlignment.Left

    Services.TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    task.wait(3)
    Services.TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    screenGui:Destroy()
end

-- Function to create main GUI
local function createMainGui()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "LeftInkMainGui"
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 200, 0, 180)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(22, 34, 72)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 12)

    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Text = "Left Ink"
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    titleLabel.BackgroundColor3 = Color3.fromRGB(16, 24, 52)
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.TextSize = 20
    titleLabel.BorderSizePixel = 0

    local titleCorner = Instance.new("UICorner", titleLabel)
    titleCorner.CornerRadius = UDim.new(0, 12)

    -- Function to create toggle buttons
    local function createToggleButton(buttonText, yOffset)
        local button = Instance.new("TextButton", mainFrame)
        button.Size = UDim2.new(1, -20, 0, 28)
        button.Position = UDim2.new(0, 10, 0, yOffset)
        button.BackgroundColor3 = Color3.new(1, 1, 1)
        button.TextColor3 = Color3.new(0, 0, 0)
        button.Font = Enum.Font.FredokaOne
        button.TextSize = 16
        button.Text = buttonText .. " [OFF]"

        local buttonCorner = Instance.new("UICorner", button)
        buttonCorner.CornerRadius = UDim.new(0, 8)

        button.MouseButton1Click:Connect(function()
            local isOff = button.Text:find("OFF") ~= nil
            button.Text = buttonText .. (isOff and " [ON]" or " [OFF]")
            if buttonText == "Aimbot (Rebel)" then
                isAimbotEnabled = isOff
            elseif buttonText == "ESP (Rebel)" then
                isEspEnabled = isOff
                if not isEspEnabled then
                    for _, part in pairs(Services.Workspace:GetDescendants()) do
                        if part:IsA("BasePart") and part:FindFirstChild("ESP") then
                            part.ESP:Destroy()
                        end
                    end
                end
            elseif buttonText == "Infinite Jump" then
                isInfiniteJumpEnabled = isOff
            end
        end)

        return button
    end

    local aimbotButton = createToggleButton("Aimbot (Rebel)", 40)
    local espButton = createToggleButton("ESP (Rebel)", 75)
    local infiniteJumpButton = createToggleButton("Infinite Jump", 110)

    local speedLabel = Instance.new("TextLabel", mainFrame)
    speedLabel.Text = "Speed:"
    speedLabel.Size = UDim2.new(0, 50, 0, 28)
    speedLabel.Position = UDim2.new(0, 10, 0, 145)
    speedLabel.TextColor3 = Color3.new(1, 1, 1)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.FredokaOne
    speedLabel.TextSize = 16
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left

    local speedTextBox = Instance.new("TextBox", mainFrame)
    speedTextBox.Size = UDim2.new(1, -70, 0, 28)
    speedTextBox.Position = UDim2.new(0, 65, 0, 145)
    speedTextBox.Text = tostring(playerSpeed)
    speedTextBox.ClearTextOnFocus = false
    speedTextBox.TextColor3 = Color3.new(0, 0, 0)
    speedTextBox.BackgroundColor3 = Color3.new(1, 1, 1)
    speedTextBox.Font = Enum.Font.FredokaOne
    speedTextBox.TextSize = 16

    local speedCorner = Instance.new("UICorner", speedTextBox)
    speedCorner.CornerRadius = UDim.new(0, 8)

    speedTextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newSpeed = tonumber(speedTextBox.Text)
            if newSpeed then
                if newSpeed < 28 then newSpeed = 28 end
                if newSpeed > 100 then newSpeed = 100 end
                playerSpeed = newSpeed
                speedTextBox.Text = tostring(playerSpeed)
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = playerSpeed
                    end
                end
            else
                speedTextBox.Text = tostring(playerSpeed)
            end
        end
    end)

    Services.RunService.RenderStepped:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = playerSpeed
            end
        end
    end)

    local toggleGui = Instance.new("ScreenGui", PlayerGui)
    toggleGui.Name = "LeftInkToggleGui"
    toggleGui.ResetOnSpawn = false

    local toggleButton = Instance.new("ImageButton", toggleGui)
    toggleButton.Size = UDim2.new(0, 40, 0, 40)
    toggleButton.Position = UDim2.new(1, -60, 0, 20)
    toggleButton.BackgroundColor3 = Color3.fromRGB(22, 34, 72)
    toggleButton.BorderSizePixel = 0
    toggleButton.Image = "rbxassetid://118783379027658"

    local toggleCorner = Instance.new("UICorner", toggleButton)
    toggleCorner.CornerRadius = UDim.new(0, 10)

    toggleButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)
end

-- Function to show load prompt
local function showLoadPrompt()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "InkLoadPrompt"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 250, 0, 90)
    frame.Position = UDim2.new(1, -20, 1, -120)
    frame.AnchorPoint = Vector2.new(1, 1)
    frame.BackgroundColor3 = Color3.fromRGB(22, 34, 72)
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    local promptLabel = Instance.new("TextLabel", frame)
    promptLabel.Size = UDim2.new(1, -20, 0, 35)
    promptLabel.Position = UDim2.new(0, 10, 0, 10)
    promptLabel.BackgroundTransparency = 1
    promptLabel.Text = "Load Left Ink Script?"
    promptLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    promptLabel.Font = Enum.Font.FredokaOne
    promptLabel.TextSize = 22
    promptLabel.TextXAlignment = Enum.TextXAlignment.Center

    local yesButton = Instance.new("TextButton", frame)
    yesButton.Text = "Yes"
    yesButton.Size = UDim2.new(0, 90, 0, 30)
    yesButton.Position = UDim2.new(0, 40, 0, 55)
    yesButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    yesButton.TextColor3 = Color3.new(1, 1, 1)
    yesButton.Font = Enum.Font.FredokaOne
    yesButton.TextSize = 20

    local noButton = Instance.new("TextButton", frame)
    noButton.Text = "No"
    noButton.Size = UDim2.new(0, 90, 0, 30)
    noButton.Position = UDim2.new(0, 130, 0, 55)
    noButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    noButton.TextColor3 = Color3.new(1, 1, 1)
    noButton.Font = Enum.Font.FredokaOne
    noButton.TextSize = 20

    local yesCorner = Instance.new("UICorner", yesButton)
    yesCorner.CornerRadius = UDim.new(0, 12)

    local noCorner = Instance.new("UICorner", noButton)
    noCorner.CornerRadius = UDim.new(0, 12)

    local function hidePrompt()
        Services.TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, 300, 1, -120)}):Play()
        task.wait(0.3)
        screenGui:Destroy()
    end

    yesButton.MouseButton1Click:Connect(function()
        hidePrompt()
        local success, errorMsg = pcall(createMainGui)
        if not success then
            showErrorOverlay(errorMsg)
        else
            showThankYouGui()
        end
    end)

    noButton.MouseButton1Click:Connect(hidePrompt)

    task.delay(10, function()
        if screenGui and screenGui.Parent then
            hidePrompt()
        end
    end)
end

-- Aimbot and ESP logic
Services.RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local rootPart = character.HumanoidRootPart
    local nearestTarget = nil
    local nearestDistance = math.huge

    for _, model in ipairs(Services.Workspace:GetDescendants()) do
        if model:IsA("Model") and not model:IsDescendantOf(Services.Players) and not model:IsDescendantOf(character) then
            local modelName = model.Name:lower()
            if modelName:find("guard") or modelName:find("guy") or modelName:find("squid") then
                local part = model:FindFirstChildWhichIsA("BasePart")
                if part then
                    local distance = (part.Position - rootPart.Position).Magnitude
                    if distance < nearestDistance then
                        nearestTarget = model
                        nearestDistance = distance
                    end
                    if isEspEnabled and not part:FindFirstChild("ESP") then
                        local espBox = Instance.new("BoxHandleAdornment")
                        espBox.Name = "ESP"
                        espBox.Adornee = part
                        espBox.Size = part.Size
                        espBox.Color3 = Color3.fromRGB(255, 0, 0)
                        espBox.AlwaysOnTop = true
                        espBox.ZIndex = 10
                        espBox.Transparency = 0.25
                        espBox.AdornCullingMode = Enum.AdornCullingMode.Never
                        espBox.Parent = part
                    elseif not isEspEnabled and part:FindFirstChild("ESP") then
                        part.ESP:Destroy()
                    end
                end
            end
        end
    end

    if isAimbotEnabled and nearestTarget then
        local targetPart = nearestTarget:FindFirstChild("Head") or nearestTarget:FindFirstChild("Torso")
        if targetPart then
            local cameraPos = Camera.CFrame.Position
            local targetDir = (targetPart.Position - cameraPos).Unit
            local currentCFrame = Camera.CFrame
            local newCFrame = currentCFrame:Lerp(CFrame.new(cameraPos, targetPart.Position), aimbotLerpFactor)
            Camera.CFrame = newCFrame
        end
    end
end)

-- Infinite jump logic
Services.UserInputService.JumpRequest:Connect(function()
    if isInfiniteJumpEnabled then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)