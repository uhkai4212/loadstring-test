-- Key System Config
local CorrectKey = "CRAZYAIM"
local DiscordLink = "https://discord.gg/4myWDtW8yj"

-- Blur Effect
local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 25

-- Key UI
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "KeySystem"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 160)
frame.Position = UDim2.new(0.5, -160, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -36, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔑 HOKALAZA Key System"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local textbox = Instance.new("TextBox", frame)
textbox.Size = UDim2.new(0.85, 0, 0, 40)
textbox.Position = UDim2.new(0.075, 0, 0.35, 0)
textbox.PlaceholderText = "Enter Key Here"
textbox.Text = ""
textbox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 16

local submit = Instance.new("TextButton", frame)
submit.Size = UDim2.new(0.4, 0, 0, 35)
submit.Position = UDim2.new(0.3, 0, 0.68, 0)
submit.Text = "Unlock"
submit.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
submit.TextColor3 = Color3.new(1, 1, 1)
submit.Font = Enum.Font.Gotham
submit.TextSize = 16

local discordBtn = Instance.new("TextButton", frame)
discordBtn.Size = UDim2.new(0.85, 0, 0, 25)
discordBtn.Position = UDim2.new(0.075, 0, 0.9, 0)
discordBtn.Text = "Get Key (Discord)"
discordBtn.BackgroundColor3 = Color3.fromRGB(0, 136, 204)
discordBtn.TextColor3 = Color3.new(1, 1, 1)
discordBtn.Font = Enum.Font.Gotham
discordBtn.TextSize = 14

submit.MouseButton1Click:Connect(function()
    if textbox.Text == CorrectKey then
        blur:Destroy()
        gui:Destroy()