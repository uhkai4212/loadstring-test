local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystemGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Key System"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Key Input
local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Size = UDim2.new(0.8, 0, 0, 36)
KeyBox.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyBox.PlaceholderText = "Enter Key"
KeyBox.Text = ""
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 16
KeyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local KeyBoxCorner = Instance.new("UICorner", KeyBox)
KeyBoxCorner.CornerRadius = UDim.new(0, 8)

-- Submit Button
local Submit = Instance.new("TextButton", Frame)
Submit.Size = UDim2.new(0.8, 0, 0, 36)
Submit.Position = UDim2.new(0.1, 0, 0.55, 0)
Submit.Text = "Submit"
Submit.Font = Enum.Font.GothamBold
Submit.TextSize = 18
Submit.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
Submit.TextColor3 = Color3.fromRGB(255, 255, 255)

local SubmitCorner = Instance.new("UICorner", Submit)
SubmitCorner.CornerRadius = UDim.new(0, 8)

-- Get Key Button
local GetKey = Instance.new("TextButton", Frame)
GetKey.Size = UDim2.new(0.8, 0, 0, 36)
GetKey.Position = UDim2.new(0.1, 0, 0.75, 0)
GetKey.Text = "Get Key (Discord)"
GetKey.Font = Enum.Font.Gotham
GetKey.TextSize = 16
GetKey.BackgroundColor3 = Color3.fromRGB(40, 130, 255)
GetKey.TextColor3 = Color3.fromRGB(255, 255, 255)

local GetKeyCorner = Instance.new("UICorner", GetKey)
GetKeyCorner.CornerRadius = UDim.new(0, 8)

-- Key Check
local correctKey = "CRAZYSLAP"

Submit.MouseButton1Click:Connect(function()
    if KeyBox.Text == correctKey then
        Frame:Destroy()
       --[[
    Moveable & Toggleable Slap Tower GUI
    Features:
      - "Close GUI" button at the bottom: hides the GUI when clicked.
      - "Open GUI" button at the top-right of the screen: shows the GUI when clicked (only visible when GUI is hidden).
      - GUI is draggable by clicking anywhere on the main frame.
      - All original buttons and features preserved.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernSlapTowerGui"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 360)
MainFrame.Position = UDim2.new(0.35, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 14)

-- Title Section
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, -70, 0, 42)
TitleLabel.Position = UDim2.new(0, 60, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "Slap Tower Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 30
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local AuthorLabel = Instance.new("TextLabel", MainFrame)
AuthorLabel.Size = UDim2.new(0, 180, 0, 20)
AuthorLabel.Position = UDim2.new(0, 60, 0, 40)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Font = Enum.Font.Gotham
AuthorLabel.Text = "by CRAZY"
AuthorLabel.TextColor3 = Color3.fromRGB(170, 170, 255)
AuthorLabel.TextSize = 14
AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left

-- User Avatar
local Avatar = Instance.new("ImageLabel", MainFrame)
Avatar.Size = UDim2.new(0, 52, 0, 52)
Avatar.Position = UDim2.new(0, 0, 0, 0)
Avatar.BackgroundTransparency = 1

local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, _ = Players:GetUserThumbnailAsync(LocalPlayer.UserId, thumbType, thumbSize)
Avatar.Image = content

-- Welcome text
local WelcomeLabel = Instance.new("TextLabel", MainFrame)
WelcomeLabel.Size = UDim2.new(0, 180, 0, 24)
WelcomeLabel.Position = UDim2.new(0, 60, 0, 60)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Font = Enum.Font.Gotham
WelcomeLabel.Text = "Welcome, " .. LocalPlayer.Name .. "!"
WelcomeLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
WelcomeLabel.TextSize = 14
WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Button template function
local function createButton(text, callback)
    local button = Instance.new("TextButton", MainFrame)
    button.Size = UDim2.new(0.29, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(63, 72, 204)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 16
    button.Text = text
    button.AutoButtonColor = true

    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 9)

    button.MouseButton1Click:Connect(callback)
    return button
end

-- Button Actions
local positions = {
    Vector3.new(-10.94, -10.70, 107.81),
    Vector3.new(-21.23, -10.70, 19.53),
    Vector3.new(183.88, -10.70, 80.83),
    Vector3.new(-180.55, 769.30, 53.09),
    Vector3.new(-185.15, 769.30, 68.09),
    Vector3.new(-48.21, -3.70, 19.33)
}
local platPositions = {
    Vector3.new(33.47, 166.20, 32.44),
    Vector3.new(33.36, 166.98, 45.94),
    Vector3.new(34.47, 166.15, 59.85),
    Vector3.new(38.54, 170.56, 86.89)
}
local platToggle = false

-- Button placement grid (3 columns)
local buttonData = {
    {"Get All Slap", function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        for _, pos in ipairs(positions) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                hrp.CFrame = CFrame.new(pos)
            end
            wait(1)
        end
    end},
    {"Troll Part 1", function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(34.26, 169.30, 20.66)
    end},
    {"Troll Part 2", function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(31.93, 169.30, 94.45)
    end},
    {"Make Platforms Disappear", function(btn)
        platToggle = not platToggle
        local platBtn = btn or MainFrame:FindFirstChild("Make Platforms Disappear")
        if platToggle then
            platBtn.Text = "Platforms: ON"
            platBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            spawn(function()
                while platToggle do
                    for _, pos in ipairs(platPositions) do
                        if not platToggle then break end
                        hrp.CFrame = CFrame.new(pos)
                        wait(0.1)
                    end
                end
            end)
        else
            platBtn.Text = "Platforms: OFF"
            platBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        end
    end},
    {"Go to End", function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(31.93, 169.30, 94.45)
    end},
    {"Load Infinite Yield", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end},
    {"Speed 50", function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.WalkSpeed = 50
    end},
    {"Fake Wall Hop", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/refs/heads/main/Roblox%20WallHop%20V3%20script"))()
    end}
}

-- Place buttons in a 3-column grid
for i, data in ipairs(buttonData) do
    local btn = createButton(data[1], function()
        data[2](btn)
    end)
    btn.Name = data[1]
    btn.Position = UDim2.new(0, 16 + ((i-1)%3)*128, 0, 110 + math.floor((i-1)/3)*48)
end

-- Close GUI Button (bottom center)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Text = "Close GUI"
CloseBtn.Size = UDim2.new(0.4, 0, 0, 36)
CloseBtn.Position = UDim2.new(0.3, 0, 1, -44)
CloseBtn.AnchorPoint = Vector2.new(0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = MainFrame
local CloseBtnCorner = Instance.new("UICorner", CloseBtn)
CloseBtnCorner.CornerRadius = UDim.new(0, 10)

-- Open GUI Button (top right, floating, only visible when GUI is closed)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Text = "Open GUI"
OpenBtn.Size = UDim2.new(0, 120, 0, 36)
OpenBtn.Position = UDim2.new(1, -140, 0, 12)
OpenBtn.AnchorPoint = Vector2.new(0, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 18
OpenBtn.Parent = ScreenGui
OpenBtn.Visible = false
local OpenBtnCorner = Instance.new("UICorner", OpenBtn)
OpenBtnCorner.CornerRadius = UDim.new(0, 10)

-- Make MainFrame draggable
do
    local dragging, dragInput, dragStart, startPos

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end

        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                           startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Show/hide logic for close/open buttons
local function setGuiOpen(open)
    MainFrame.Visible = open
    OpenBtn.Visible = not open
end

CloseBtn.MouseButton1Click:Connect(function()
    setGuiOpen(false)
end)

OpenBtn.MouseButton1Click:Connect(function()
    setGuiOpen(true)
end)

-- Optional: Allow toggling GUI with RightShift as well (optional, remove if not desired)
local isOpen = true
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        isOpen = not isOpen
        setGuiOpen(isOpen)
    end
end)

-- Start with GUI open
setGuiOpen(true)
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Wrong Key! Try Again"
    end
end)

-- Open Discord Link
GetKey.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/4myWDtW8yj")
end)