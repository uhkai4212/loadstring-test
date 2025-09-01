local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Decayparttwo"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui


local mainFrame = Instance.new("Frame")
mainFrame.Name = "Part2DecayGuiExploit"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui


local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame


local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0.2, 0.2, 0.2)),
    ColorSequenceKeypoint.new(1, Color3.new(0.1, 0.1, 0.1))
})
frameGradient.Rotation = 90
frameGradient.Parent = mainFrame


local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Decay Part 2 Script"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame


local tpButton = Instance.new("TextButton")
tpButton.Name = "TPButton"
tpButton.Size = UDim2.new(0, 200, 0, 40)
tpButton.Position = UDim2.new(0.5, -100, 0, 80)
tpButton.BackgroundColor3 = Color3.new(0.2, 0.4, 0.8)
tpButton.BorderSizePixel = 0
tpButton.Text = "TP To Jungle Gym Chase"
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.TextSize = 14
tpButton.Font = Enum.Font.SourceSans
tpButton.Parent = mainFrame


local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 6)
tpCorner.Parent = tpButton


local tpGradient = Instance.new("UIGradient")
tpGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0.3, 0.5, 1)),
    ColorSequenceKeypoint.new(1, Color3.new(0.1, 0.3, 0.7))
})
tpGradient.Rotation = 45
tpGradient.Parent = tpButton


local mansionChaseButton = Instance.new("TextButton")
mansionChaseButton.Name = "MansionChaseButton"
mansionChaseButton.Size = UDim2.new(0, 200, 0, 40)
mansionChaseButton.Position = UDim2.new(0.5, -100, 0, 130)
mansionChaseButton.BackgroundColor3 = Color3.new(0.8, 0.4, 0.2)
mansionChaseButton.BorderSizePixel = 0
mansionChaseButton.Text = "TP to Mansion Chase"
mansionChaseButton.TextColor3 = Color3.new(1, 1, 1)
mansionChaseButton.TextSize = 14
mansionChaseButton.Font = Enum.Font.SourceSans
mansionChaseButton.Parent = mainFrame


local mansionChaseCorner = Instance.new("UICorner")
mansionChaseCorner.CornerRadius = UDim.new(0, 6)
mansionChaseCorner.Parent = mansionChaseButton


local mansionChaseGradient = Instance.new("UIGradient")
mansionChaseGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1, 0.5, 0.3)),
    ColorSequenceKeypoint.new(1, Color3.new(0.6, 0.3, 0.1))
})
mansionChaseGradient.Rotation = 45
mansionChaseGradient.Parent = mansionChaseButton


local endButton = Instance.new("TextButton")
endButton.Name = "EndButton"
endButton.Size = UDim2.new(0, 200, 0, 40)
endButton.Position = UDim2.new(0.5, -100, 0, 180)
endButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.8)
endButton.BorderSizePixel = 0
endButton.Text = "TP to End"
endButton.TextColor3 = Color3.new(1, 1, 1)
endButton.TextSize = 14
endButton.Font = Enum.Font.SourceSans
endButton.Parent = mainFrame


local endCorner = Instance.new("UICorner")
endCorner.CornerRadius = UDim.new(0, 6)
endCorner.Parent = endButton


local endGradient = Instance.new("UIGradient")
endGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1, 0.3, 1)),
    ColorSequenceKeypoint.new(1, Color3.new(0.6, 0.1, 0.6))
})
endGradient.Rotation = 45
endGradient.Parent = endButton


local creditLabel = Instance.new("TextLabel")
creditLabel.Name = "i made this"
creditLabel.Size = UDim2.new(1, 0, 0, 30)
creditLabel.Position = UDim2.new(0, 0, 1, -30)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "Script by esacoolscriptssuperc on scriptblox"
creditLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
creditLabel.TextSize = 10
creditLabel.Font = Enum.Font.SourceSans
creditLabel.Parent = mainFrame


local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 80, 0, 30)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.BackgroundColor3 = Color3.new(0, 0.8, 0)
openButton.BorderSizePixel = 0
openButton.Text = "Open"
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.TextSize = 14
openButton.Font = Enum.Font.SourceSans
openButton.Parent = screenGui


local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 6)
openCorner.Parent = openButton


local openGradient = Instance.new("UIGradient")
openGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0, 1, 0)),
    ColorSequenceKeypoint.new(1, Color3.new(0, 0.6, 0))
})
openGradient.Rotation = 45
openGradient.Parent = openButton


local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 80, 0, 30)
closeButton.Position = UDim2.new(0, 110, 0, 20)
closeButton.BackgroundColor3 = Color3.new(0.8, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.SourceSans
closeButton.Parent = screenGui


local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton


local closeGradient = Instance.new("UIGradient")
closeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.new(0.6, 0, 0))
})
closeGradient.Rotation = 45
closeGradient.Parent = closeButton


local fadeInTween = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 400, 0, 300)}
)

local fadeOutTween = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 0, 0, 0)}
)


openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    fadeInTween:Play()
end)

closeButton.MouseButton1Click:Connect(function()
    fadeOutTween:Play()
    fadeOutTween.Completed:Wait()
    mainFrame.Visible = false


local function createHoverEffect(button, hoverColor, normalColor)
    local hoverTween = TweenService:Create(
        button,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = hoverColor}
    )
    
    local normalTween = TweenService:Create(
        button,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = normalColor}
    )
    
    button.MouseEnter:Connect(function()
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        normalTween:Play()
    end)
end


createHoverEffect(openButton, Color3.new(0, 1, 0), Color3.new(0, 0.8, 0))
createHoverEffect(closeButton, Color3.new(1, 0, 0), Color3.new(0.8, 0, 0))
createHoverEffect(tpButton, Color3.new(0.3, 0.5, 1), Color3.new(0.2, 0.4, 0.8))
createHoverEffect(mansionChaseButton, Color3.new(1, 0.5, 0.3), Color3.new(0.8, 0.4, 0.2))
createHoverEffect(endButton, Color3.new(1, 0.3, 1), Color3.new(0.8, 0.2, 0.8))


tpButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local targetPart = workspace:FindFirstChild("JungleGymChase3", true)
        if targetPart then
            character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
            print("Teleported to JungleGymChase3!")
        else
            warn("JungleGymChase3 part not found in workspace!")
        end
    else
        warn("Character or HumanoidRootPart not found!")
    end
end)


mansionChaseButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local targetPart = workspace:FindFirstChild("HandChase6", true)
        if targetPart then
            character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
            print("have fun with scary red bunny chase")
        else
            warn("mate this isint the right game")
        end
    else
        warn("no character?🥺")
    end
end)


endButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local targetModel = workspace:FindFirstChild("FallingBridge", true)
        if targetModel then
            -- For models, teleport to the model's primary part or first part
            local targetPart = targetModel.PrimaryPart or targetModel:FindFirstChildWhichIsA("BasePart")
            if targetPart then
                character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
                print("i dont think you can actually beat it if you get to the end this way but whatever")
            else
                warn("mate this isint the right game")
            end
        else
            warn("mate this isint the right game")
        end
    else
        warn("no character?🥺")
    end
end)

print("cha ching loaded")