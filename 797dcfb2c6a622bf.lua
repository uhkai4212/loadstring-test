local key = "123456789"
local discordLink = "https://discord.gg/9Byz7ZZxxN"
local autoFarming = false
local flySpeed = 390.45 -- Fly speed for 1400 km/h (updated speed)
local flyDuration = 21 -- Flying duration in seconds
local centerPosition = Vector3.new(0, 100, 0) -- Center of the map
local chestPosition = Vector3.new(15, -5, 9495) -- Chest position
local secondGui
local bodyVelocity -- Variable to manage flying
local player = game.Players.LocalPlayer
local totalCoins = 0 -- Coins counter
local enableExtraFeature = false -- Toggle variable for the new feature
local isSecondGuiVisible = false -- Track if the second GUI is visible or not
local antiAFKEnabled = false -- Anti-AFK toggle state
 
-- Create Main GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
 
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Text = "BABFT Auto Farm | Enter Key"
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
 
local KeyInput = Instance.new("TextBox", Frame)
KeyInput.PlaceholderText = "Enter Key Here"
KeyInput.Size = UDim2.new(0.8, 0, 0.2, 0)
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
 
local SubmitButton = Instance.new("TextButton", Frame)
SubmitButton.Text = "Submit Key"
SubmitButton.Size = UDim2.new(0.8, 0, 0.2, 0)
SubmitButton.Position = UDim2.new(0.1, 0, 0.8, 0)
SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
 
local DiscordButton = Instance.new("TextButton", Frame)
DiscordButton.Text = "Discord Link for Key"
DiscordButton.Size = UDim2.new(0.8, 0, 0.2, 0)
DiscordButton.Position = UDim2.new(0.1, 0, 0.6, 0)
DiscordButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
 
-- Update message added here
local UpdateMessage = Instance.new("TextLabel", Frame)
UpdateMessage.Size = UDim2.new(1, 0, 0.2, 0)
UpdateMessage.Position = UDim2.new(0, 0, 0.1, 0)
UpdateMessage.Text = "UPDATE 2 MADE BY KIRA"
UpdateMessage.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
UpdateMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
UpdateMessage.Font = Enum.Font.GothamBold
UpdateMessage.TextSize = 14
 
-- Copy Discord link functionality
DiscordButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(discordLink)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Discord Link Copied",
            Text = "Join the server for key!",
            Duration = 3
        })
    end
end)
 
-- Submit Key and trigger Auto Farm
SubmitButton.MouseButton1Click:Connect(function()
    if KeyInput.Text == key then
        Frame:Destroy()
        showAutoFarmGUI()
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Invalid Key",
            Text = "Try Again.",
            Duration = 3
        })
    end
end)
 
-- Auto Farm GUI
function showAutoFarmGUI()
    secondGui = Instance.new("ScreenGui", game.CoreGui)
    local Frame = Instance.new("Frame", secondGui)
    Frame.Size = UDim2.new(0, 300, 0, 250)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -125)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
 
    local ToggleButton = Instance.new("TextButton", Frame)
    ToggleButton.Text = "Start Auto Farm"
    ToggleButton.Size = UDim2.new(0.8, 0, 0.2, 0)
    ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
 
    -- Coins Counter Display
    local CoinsLabel = Instance.new("TextLabel", Frame)
    CoinsLabel.Size = UDim2.new(1, 0, 0.2, 0)
    CoinsLabel.Position = UDim2.new(0, 0, 0.1, 0)
    CoinsLabel.Text = "Coins: 0"
    CoinsLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CoinsLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    CoinsLabel.Font = Enum.Font.GothamBold
    CoinsLabel.TextSize = 16
 
    -- Toggle Button for Show/Hide Second GUI
    local HideShowButton = Instance.new("TextButton", Frame)
    HideShowButton.Text = "Hide GUI"
    HideShowButton.Size = UDim2.new(0.8, 0, 0.2, 0)
    HideShowButton.Position = UDim2.new(0.1, 0, 0.7, 0)
    HideShowButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    HideShowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
 
    -- Anti-AFK Button
    local AntiAFKButton = Instance.new("TextButton", Frame)
    AntiAFKButton.Text = "Enable Anti-AFK"
    AntiAFKButton.Size = UDim2.new(0.8, 0, 0.2, 0)
    AntiAFKButton.Position = UDim2.new(0.1, 0, 0.9, 0)
    AntiAFKButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    AntiAFKButton.TextColor3 = Color3.fromRGB(255, 255, 255)
 
    -- Toggle Anti-AFK Feature
    AntiAFKButton.MouseButton1Click:Connect(function()
        antiAFKEnabled = not antiAFKEnabled
        if antiAFKEnabled then
            AntiAFKButton.Text = "Disable Anti-AFK"
            -- Start the Anti-AFK function
            startAntiAFK()
        else
            AntiAFKButton.Text = "Enable Anti-AFK"
            -- Stop the Anti-AFK function
            stopAntiAFK()
        end
    end)
 
    -- Hide/Show the Second GUI
    HideShowButton.MouseButton1Click:Connect(function()
        isSecondGuiVisible = not isSecondGuiVisible
        if isSecondGuiVisible then
            secondGui.Enabled = true
            HideShowButton.Text = "Hide GUI"
        else
            secondGui.Enabled = false
            HideShowButton.Text = "Show GUI"
        end
    end)
 
    ToggleButton.MouseButton1Click:Connect(function()
        autoFarming = not autoFarming
        ToggleButton.Text = autoFarming and "Stop Auto Farm" or "Start Auto Farm"
        if autoFarming then
            startAutoFarm(CoinsLabel)
        else
            stopFlying()
            teleportToTeamBase()
        end
    end)
end
 
-- Anti-AFK Functionality
function startAntiAFK()
    spawn(function()
        while antiAFKEnabled do
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart")
 
            if hrp then
                -- Simulate movement to avoid AFK detection
                hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, math.random(-1, 1))
            end
            wait(2) -- Move every 2 seconds
        end
    end)
end
 
-- Stop Anti-AFK
function stopAntiAFK()
    -- This function doesn't need to do anything extra
    -- The movement stops automatically when antiAFKEnabled is set to false
end
 
-- Auto Farm Functionality
function startAutoFarm(CoinsLabel)
    spawn(function()
        while autoFarming do
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart")
 
            if hrp then
                -- Teleport to the center of the map
                hrp.CFrame = CFrame.new(centerPosition)
 
                -- Enable noclip
                enableNoclip(character)
 
                -- Fly with boosted speed
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                bodyVelocity.Velocity = Vector3.new(0, 0, flySpeed)
                bodyVelocity.Parent = hrp
 
                -- Allow flying for a fixed duration
                wait(flyDuration)
 
                -- Stop flying and destroy the velocity object
                if bodyVelocity then
                    bodyVelocity:Destroy()
                end
 
                -- Adjust position slightly and teleport to chest
                hrp.CFrame = CFrame.new(chestPosition)
 
                -- Kill the player to end the farm cycle
                character:BreakJoints()
 
                -- Increment coins after death
                if totalCoins < 10000000 then
                    totalCoins = totalCoins + 100
                    CoinsLabel.Text = "Coins: " .. totalCoins
                end
 
                -- Wait for the player to respawn before restarting the loop
                wait(9) -- Adjust respawn wait time as necessary
            end
        end
    end)
end
 
-- Stop flying (when Auto Farm is stopped)
function stopFlying()
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
end
 
-- Teleport to team base when Auto Farm is stopped
function teleportToTeamBase()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        -- Replace with your team base position
        local teamBasePosition = Vector3.new(0, 10, 0) -- Change to your desired coordinates
        hrp.CFrame = CFrame.new(teamBasePosition)
    end
end
 
-- Enable noclip (No Collision)
function enableNoclip(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end