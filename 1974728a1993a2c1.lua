local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BronzeFieldGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 400, 0, 390) -- Yükseklik Auto Farm butonu için ayarlandı
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = mainFrame

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60,60,60))
}
uiGradient.Rotation = 90
uiGradient.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.Text = "BronzeField"
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.Text = "X"
closeButton.Parent = titleBar
closeButton.ZIndex = 2

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

local minimizeMaximizeButton = Instance.new("TextButton")
minimizeMaximizeButton.Size = UDim2.new(0, 30, 1, 0)
minimizeMaximizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeMaximizeButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
minimizeMaximizeButton.TextColor3 = Color3.fromRGB(255,255,255)
minimizeMaximizeButton.Font = Enum.Font.GothamBold
minimizeMaximizeButton.TextSize = 20
minimizeMaximizeButton.Text = "-"
minimizeMaximizeButton.Parent = titleBar
minimizeMaximizeButton.ZIndex = 2

local isMinimized = false
local originalSize = mainFrame.Size
local minimizedSize = UDim2.new(0, 200, 0, 30)

minimizeMaximizeButton.MouseButton1Click:Connect(function()
    if not isMinimized then
        originalSize = mainFrame.Size
        mainFrame:TweenSize(minimizedSize, "Out", "Quad", 0.3, true)
        minimizeMaximizeButton.Text = "+"
        isMinimized = true
    else
        mainFrame:TweenSize(originalSize, "Out", "Quad", 0.3, true)
        minimizeMaximizeButton.Text = "-"
        isMinimized = false
    end
end)

local UserInputService = game:GetService("UserInputService")
local isDragging = false
local dragStartPos
local frameStartPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPos = UserInputService:GetMouseLocation()
        frameStartPos = mainFrame.Position
        input.Handled = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = UserInputService:GetMouseLocation() - dragStartPos
        local newXOffset = frameStartPos.X.Offset + delta.X
        local newYOffset = frameStartPos.Y.Offset + delta.Y
        mainFrame.Position = UDim2.new(frameStartPos.X.Scale, newXOffset, frameStartPos.Y.Scale, newYOffset)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

local resizer = Instance.new("Frame")
resizer.Size = UDim2.new(0, 15, 0, 15)
resizer.Position = UDim2.new(1, -15, 1, -15)
resizer.BackgroundColor3 = Color3.fromRGB(100,100,100)
resizer.BackgroundTransparency = 0.5
resizer.Parent = mainFrame
resizer.ZIndex = 3

local isResizing = false
local resizeStartPos
local frameStartSize

resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isResizing = true
        resizeStartPos = UserInputService:GetMouseLocation()
        frameStartSize = mainFrame.Size
        input.Handled = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = UserInputService:GetMouseLocation() - resizeStartPos
        local newWidthOffset = frameStartSize.X.Offset + delta.X
        local newHeightOffset = frameStartSize.Y.Offset + delta.Y
        newWidthOffset = math.max(newWidthOffset, 200)
        newHeightOffset = math.max(newHeightOffset, 100)
        mainFrame.Size = UDim2.new(frameStartSize.X.Scale, newWidthOffset, frameStartSize.Y.Scale, newHeightOffset)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isResizing = false
    end
end)

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0, 80)
loadingText.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
loadingText.BackgroundTransparency = 1
loadingText.Text = "BronzeField"
loadingText.TextColor3 = Color3.fromRGB(255,255,255)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 48
loadingText.TextTransparency = 1
loadingText.Parent = screenGui

-- Buton oluşturma fonksiyonu
local function createButton(name, posY, parentFrame)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.BackgroundTransparency = 0.8
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 22
    btn.Text = name
    btn.AutoButtonColor = true
    btn.AnchorPoint = Vector2.new(0,0)
    btn.Parent = parentFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    return btn
end

local function createLabel(text, posY, parentFrame)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.8, 0, 0, 24)
    lbl.Position = UDim2.new(0.1, 0, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 18
    lbl.Text = text
    lbl.TextWrapped = true
    lbl.Parent = parentFrame
    return lbl
end

-- Quick Money butonu ve etiketi
local quickMoneyBtn = createButton("Quick Money", 40, mainFrame)
local quickMoneyLabel = createLabel("Activate Before Starting the plane", 85, mainFrame) -- Yeni eklenen not

quickMoneyBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.SeatPart then
        local seat = humanoid.SeatPart
        local forwardVec = seat.CFrame.LookVector
        seat.CFrame = seat.CFrame + forwardVec * 100000
        character:SetPrimaryPartCFrame(seat.CFrame)
    else
        warn("Önce bir araca binmelisin!")
    end
end)

-- Boost butonu ve etiketi
local boostBtn = createButton("Boost", 120, mainFrame)
local boostLabel = createLabel("Do it After u Started The Plane", 165, mainFrame)

local boostedSeats = {}

boostBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
        local seat = humanoid.SeatPart

        if boostedSeats[seat] then
            seat.MaxSpeed = boostedSeats[seat]
            boostedSeats[seat] = nil
            boostBtn.Text = "Boost"
        else
            if seat.MaxSpeed then
                boostedSeats[seat] = seat.MaxSpeed
                seat.MaxSpeed = 300
                boostBtn.Text = "Unboost"
            else
                warn("VehicleSeat üzerinde MaxSpeed bulunamadı!")
            end
        end
    else
        warn("Önce bir VehicleSeat'e binmelisin!")
    end
end)

-- Auto Farm butonu ve etiketi
local autoFarmBtn = createButton("Auto Farm", 200, mainFrame)
local autoFarmLabel = createLabel("This is On Development Use 'Tiny Task' For Now", 245, mainFrame)

local isAutoFarmActive = false
local farmConnection = nil

autoFarmBtn.MouseButton1Click:Connect(function()
    if not isAutoFarmActive then
        isAutoFarmActive = true
        autoFarmBtn.Text = "Auto Farm (ACTIVE)"
        autoFarmBtn.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
        
        -- Oyuncunun koltuğa oturduğu anı tespit et ve ışınla
        farmConnection = player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.Seated:Connect(function(isSeated, seatPart)
                if isSeated and seatPart then
                    local forwardVec = seatPart.CFrame.LookVector
                    seatPart.CFrame = seatPart.CFrame + forwardVec * 500000
                    character:SetPrimaryPartCFrame(seatPart.CFrame)
                end
            end)
        end)
        
        -- Halihazırda oturuyorsa ilk ışınlamayı yap
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.SeatPart then
                local seatPart = humanoid.SeatPart
                local forwardVec = seatPart.CFrame.LookVector
                seatPart.CFrame = seatPart.CFrame + forwardVec * 500000
                character:SetPrimaryPartCFrame(seatPart.CFrame)
            end
        end

    else
        isAutoFarmActive = false
        autoFarmBtn.Text = "Auto Farm"
        autoFarmBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end
    end
end)

-- Açılış animasyonu
local function fadeTextLabel(textLabel, fadeInTime, holdTime, fadeOutTime)
    for i = 0,1,0.03 do
        textLabel.TextTransparency = 1 - i
        task.wait(fadeInTime * 0.03)
    end
    task.wait(holdTime)
    for i=0,1,0.03 do
        textLabel.TextTransparency = i
        task.wait(fadeOutTime * 0.03)
    end
end

spawn(function()
    fadeTextLabel(loadingText, 0.03, 1.5, 0.03)
    loadingText.Visible = false
    mainFrame.Visible = true
end)