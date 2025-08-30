local key = "Jworldplane"
local discordLink = "https://discord.gg/euRtVBRPVb"

-- Make a basic key UI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Frame = Instance.new("Frame", ScreenGui)
local TextBox = Instance.new("TextBox", Frame)
local CheckButton = Instance.new("TextButton", Frame)
local GetKeyButton = Instance.new("TextButton", Frame)
local UICorner = Instance.new("UICorner", Frame)

ScreenGui.Name = "KeySystem"
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

UICorner.CornerRadius = UDim.new(0, 10)

TextBox.Size = UDim2.new(0.9, 0, 0.3, 0)
TextBox.Position = UDim2.new(0.05, 0, 0.15, 0)
TextBox.PlaceholderText = "Enter Key"
TextBox.Text = ""
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TextBox.TextColor3 = Color3.fromRGB(255,255,255)

CheckButton.Size = UDim2.new(0.4, 0, 0.25, 0)
CheckButton.Position = UDim2.new(0.05, 0, 0.55, 0)
CheckButton.Text = "Check Key"
CheckButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CheckButton.TextColor3 = Color3.fromRGB(255,255,255)

GetKeyButton.Size = UDim2.new(0.4, 0, 0.25, 0)
GetKeyButton.Position = UDim2.new(0.55, 0, 0.55, 0)
GetKeyButton.Text = "Get Key"
GetKeyButton.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
GetKeyButton.TextColor3 = Color3.fromRGB(255,255,255)

-- Button Functions
GetKeyButton.MouseButton1Click:Connect(function()
    setclipboard(discordLink)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Key System",
        Text = "Discord link copied!",
        Duration = 5
    })
end)

local keyAccepted = false
CheckButton.MouseButton1Click:Connect(function()
    if TextBox.Text == key then
        keyAccepted = true
        ScreenGui:Destroy()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Key System",
            Text = "Correct Key! Loading...",
            Duration = 5
        })
        wait(1)