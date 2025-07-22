pcall(function()

    local pg = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    if pg:FindFirstChild("EliteHubKeySystem") then pg.EliteHubKeySystem:Destroy() end

end)

local player = game.Players.LocalPlayer

local discordInvite = "https://discord.gg/vETE4JPbA3"

local correctKey = "GUNFIGHT"

local function copyToClipboard(text)

    if setclipboard then

        setclipboard(text)

    else

        game:GetService("StarterGui"):SetCore("SendNotification", {

            Title = "Clipboard",

            Text = "Clipboard not supported",

            Duration = 4

        })

    end

end

-- KEY SYSTEM GUI

local keyGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

keyGui.Name = "EliteHubKeySystem"

keyGui.ResetOnSpawn = false

local keyFrame = Instance.new("Frame", keyGui)

keyFrame.Size = UDim2.new(0, 400, 0, 180)

keyFrame.Position = UDim2.new(0.5, -200, 0.4, -90)

keyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

keyFrame.BorderSizePixel = 0

keyFrame.Active = true

keyFrame.Draggable = true

local keyTitle = Instance.new("TextLabel", keyFrame)

keyTitle.Size = UDim2.new(1, 0, 0, 35)

keyTitle.Position = UDim2.new(0, 0, 0, 0)

keyTitle.BackgroundColor3 = Color3.fromRGB(40, 0, 0)

keyTitle.Text = "Elite Hub | Key System"

keyTitle.TextColor3 = Color3.fromRGB(255, 0, 0)

keyTitle.Font = Enum.Font.SourceSansBold

keyTitle.TextSize = 22

keyTitle.BorderSizePixel = 0

local keyLabel = Instance.new("TextLabel", keyFrame)

keyLabel.Size = UDim2.new(0, 100, 0, 30)

keyLabel.Position = UDim2.new(0, 10, 0, 50)

keyLabel.BackgroundTransparency = 1

keyLabel.Text = "Insert Key:"

keyLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

keyLabel.Font = Enum.Font.SourceSansBold

keyLabel.TextSize = 18

keyLabel.TextXAlignment = Enum.TextXAlignment.Left

local keyTextBox = Instance.new("TextBox", keyFrame)

keyTextBox.Size = UDim2.new(0, 250, 0, 30)

keyTextBox.Position = UDim2.new(0, 120, 0, 50)

keyTextBox.BackgroundColor3 = Color3.fromRGB(30, 0, 0)

keyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)

keyTextBox.Font = Enum.Font.SourceSans

keyTextBox.TextSize = 18

keyTextBox.ClearTextOnFocus = false

keyTextBox.PlaceholderText = "Enter key here"

local joinDiscordButton = Instance.new("TextButton", keyFrame)

joinDiscordButton.Size = UDim2.new(0, 180, 0, 35)

joinDiscordButton.Position = UDim2.new(0, 10, 0, 100)

joinDiscordButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)

joinDiscordButton.TextColor3 = Color3.fromRGB(255, 0, 0)

joinDiscordButton.Font = Enum.Font.SourceSansBold

joinDiscordButton.TextSize = 20

joinDiscordButton.Text = "Join Discord"

local submitButton = Instance.new("TextButton", keyFrame)

submitButton.Size = UDim2.new(0, 180, 0, 35)

submitButton.Position = UDim2.new(0, 210, 0, 100)

submitButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)

submitButton.TextColor3 = Color3.fromRGB(255, 0, 0)

submitButton.Font = Enum.Font.SourceSansBold

submitButton.TextSize = 20

submitButton.Text = "Submit Key"

local keyErrorLabel = Instance.new("TextLabel", keyFrame)

keyErrorLabel.Size = UDim2.new(1, -20, 0, 25)

keyErrorLabel.Position = UDim2.new(0, 10, 0, 140)

keyErrorLabel.BackgroundTransparency = 1

keyErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)

keyErrorLabel.Font = Enum.Font.SourceSansBold

keyErrorLabel.TextSize = 16

keyErrorLabel.Text = ""

keyErrorLabel.TextWrapped = true

joinDiscordButton.MouseButton1Click:Connect(function()

    copyToClipboard(discordInvite)

    keyErrorLabel.Text = "Discord invite copied to clipboard!"

    wait(3)

    keyErrorLabel.Text = ""

end)