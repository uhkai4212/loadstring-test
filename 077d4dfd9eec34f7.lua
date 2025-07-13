-- HOKALAZA Camlock GUI: Fog Color Picker, Ghost Rainbow, Weapon-Aim ESP, User TP, Single-Player Aim Viewer (Fixed), FPS Shower
-- Camlock, Speed (up to 1000), ESP, Fog Color/Distance, Ghost Rainbow, Weapon-Aim ESP (lines for weapon holders only)
-- User TP: Type username, click TP to teleport to that user
-- Aim Viewer: Only shows aim line for the username you type (if they have a weapon)
-- FPS Shower: Click button to show FPS

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer

-- List of weapon names for detection (customize as needed)
local weaponNames = {
    "Double-Barrel", "DB", "Rev", "Revolver", "Shotgun", "Pump", "AR", "SMG", "AK47", "Rifle", "LMG", "DrumGun",
    "Silencer", "Tactical", "P90", "Flamethrower", "Glock", "Uzi", "Mac", "SG", "MP5", "AUG", "Sniper", "RPG", "Grease Gun"
}

local function hasWeapon(plr)
    if not plr.Backpack then return false end
    for _,tool in ipairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            for _,w in ipairs(weaponNames) do
                if string.lower(tool.Name):find(string.lower(w)) then
                    return true
                end
            end
        end
    end
    if plr.Character then
        local tool = plr.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _,w in ipairs(weaponNames) do
                if string.lower(tool.Name):find(string.lower(w)) then
                    return true
                end
            end
        end
    end
    return false
end

-- FPS counter (for built-in FPS label and FPS shower)
local currentFps = 60
do
    local frames = 0
    local last = tick()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if tick() - last > 1 then
            currentFps = frames
            frames = 0
            last = tick()
        end
    end)
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HOKALAZA_CAMLOCK_GUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 256, 0, 440)
frame.Position = UDim2.new(0.5, -128, 0.5, -220)
frame.BackgroundColor3 = Color3.fromRGB(38, 50, 72)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -36, 0, 32)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "HOKALAZA Camlock"
title.TextColor3 = Color3.fromRGB(90, 180, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 80, 0, 20)
fpsLabel.Position = UDim2.new(1, -85, 0, 8)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 60"
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 16
fpsLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
fpsLabel.Parent = frame

RunService.RenderStepped:Connect(function()
    fpsLabel.Text = "FPS: " .. tostring(currentFps)
end)

-- FPS Shower Button and Label
local fpsShowerBtn = Instance.new("TextButton")
fpsShowerBtn.Size = UDim2.new(0, 94, 0, 26)
fpsShowerBtn.Position = UDim2.new(0.06, 0, 1, -34)
fpsShowerBtn.BackgroundColor3 = Color3.fromRGB(120, 180, 255)
fpsShowerBtn.Text = "Show FPS"
fpsShowerBtn.Font = Enum.Font.GothamBold
fpsShowerBtn.TextColor3 = Color3.fromRGB(46, 60, 90)
fpsShowerBtn.TextSize = 15
fpsShowerBtn.Parent = frame

local fpsShowerMsg = Instance.new("TextLabel")
fpsShowerMsg.Size = UDim2.new(0, 120, 0, 22)
fpsShowerMsg.Position = UDim2.new(0.45, 0, 1, -32)
fpsShowerMsg.BackgroundTransparency = 1
fpsShowerMsg.Text = ""
fpsShowerMsg.Font = Enum.Font.GothamBold
fpsShowerMsg.TextSize = 15
fpsShowerMsg.TextColor3 = Color3.fromRGB(200,255,140)
fpsShowerMsg.TextXAlignment = Enum.TextXAlignment.Left
fpsShowerMsg.Parent = frame

fpsShowerBtn.MouseButton1Click:Connect(function()
    fpsShowerMsg.Text = "Your FPS: " .. tostring(currentFps)
    wait(2)
    fpsShowerMsg.Text = ""
end)

-- Close/Open (X) button at top right
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 18
closeBtn.Parent = frame

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 40, 0, 32)
openBtn.Position = UDim2.new(0, 8, 0, 8)
openBtn.BackgroundColor3 = Color3.fromRGB(38, 120, 230)
openBtn.Text = "☰"
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.TextSize = 22
openBtn.Visible = false
openBtn.Parent = gui

local function setGUI(state)
    frame.Visible = state
    openBtn.Visible = not state
end

closeBtn.MouseButton1Click:Connect(function() setGUI(false) end)
openBtn.MouseButton1Click:Connect(function() setGUI(true) end)

-- Camlock
local camlockBtn = Instance.new("TextButton")
camlockBtn.Size = UDim2.new(0.85, 0, 0, 38)
camlockBtn.Position = UDim2.new(0.075, 0, 0, 44)
camlockBtn.BackgroundColor3 = Color3.fromRGB(38, 170, 255)
camlockBtn.Text = "Camlock"
camlockBtn.Font = Enum.Font.GothamBlack
camlockBtn.TextColor3 = Color3.fromRGB(255,255,255)
camlockBtn.TextSize = 18
camlockBtn.Parent = frame

local unlockBtn = Instance.new("TextButton")
unlockBtn.Size = UDim2.new(0.85, 0, 0, 28)
unlockBtn.Position = UDim2.new(0.075, 0, 0, 88)
unlockBtn.BackgroundColor3 = Color3.fromRGB(90, 110, 145)
unlockBtn.Text = "Unlock (Q/tap)"
unlockBtn.Font = Enum.Font.GothamBold
unlockBtn.TextColor3 = Color3.fromRGB(255,255,255)
unlockBtn.TextSize = 14
unlockBtn.Parent = frame

-- Speed (up to 1000)
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 80, 0, 20)
speedLabel.Position = UDim2.new(0.08, 0, 0, 128)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 16"
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextColor3 = Color3.fromRGB(180,230,255)
speedLabel.TextSize = 15
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = frame

local speedSlider = Instance.new("TextButton")
speedSlider.Size = UDim2.new(0, 120, 0, 20)
speedSlider.Position = UDim2.new(0.45, 0, 0, 128)
speedSlider.BackgroundColor3 = Color3.fromRGB(60,60,80)
speedSlider.Text = ""
speedSlider.AutoButtonColor = false
speedSlider.Parent = frame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(38,170,255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = speedSlider

local sliderCorner = Instance.new("UICorner", speedSlider)
sliderCorner.CornerRadius = UDim.new(0, 8)
local sliderFillCorner = Instance.new("UICorner", sliderFill)
sliderFillCorner.CornerRadius = UDim.new(0, 8)

local minSpeed, maxSpeed = 16, 1000
local walkspeed = 16

local draggingSlider = false
speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
        local function updateSlider(pos)
            local rel = math.clamp((pos.X - speedSlider.AbsolutePosition.X)/speedSlider.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(rel, 0, 1, 0)
            walkspeed = math.floor(minSpeed + (maxSpeed-minSpeed)*rel)
            speedLabel.Text = "Speed: "..walkspeed
        end
        updateSlider(UIS:GetMouseLocation())
        local moveConn, endConn
        moveConn = UIS.InputChanged:Connect(function(inp)
            if draggingSlider and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(inp.Position or UIS:GetMouseLocation())
            end
        end)
        endConn = UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
                moveConn:Disconnect() endConn:Disconnect()
            end
        end)
    end
end)
LP.CharacterAdded:Connect(function(char)
    repeat wait() until char:FindFirstChildOfClass("Humanoid")
    char:FindFirstChildOfClass("Humanoid").WalkSpeed = walkspeed
end)
RunService.Heartbeat:Connect(function()
    if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkspeed
    end
end)

-- ESP
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0.85, 0, 0, 30)
espBtn.Position = UDim2.new(0.075, 0, 0, 162)
espBtn.BackgroundColor3 = Color3.fromRGB(120, 245, 130)
espBtn.Text = "ESP: OFF"
espBtn.Font = Enum.Font.GothamBold
espBtn.TextColor3 = Color3.fromRGB(22,38,24)
espBtn.TextSize = 16
espBtn.Parent = frame

local espOn = false
local espBoxes = {}
function clearESP()
    for _,v in pairs(espBoxes) do if v and v.Adornee then v:Destroy() end end
    espBoxes = {}
end
function makeESP(plr)
    if plr == LP then return end
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "HOKALAZA_ESP"
    box.Adornee = plr.Character.HumanoidRootPart
    box.Color3 = Color3.fromRGB(38,170,255)
    box.AlwaysOnTop = true
    box.ZIndex = 8
    box.Size = Vector3.new(4,6,2)
    box.Transparency = 0.7
    box.Parent = plr.Character
    table.insert(espBoxes, box)
end
espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = espOn and "ESP: ON" or "ESP: OFF"
    espBtn.BackgroundColor3 = espOn and Color3.fromRGB(38,170,255) or Color3.fromRGB(120,245,130)
    if espOn then
        for _,plr in pairs(Players:GetPlayers()) do makeESP(plr) end
    else
        clearESP()
    end
end)
Players.PlayerAdded:Connect(function(plr)
    if espOn then
        plr.CharacterAdded:Connect(function()
            wait(1)
            makeESP(plr)
        end)
    end
end)
Players.PlayerRemoving:Connect(function(plr)
    for _,v in pairs(espBoxes) do
        if v.Adornee and v.Adornee.Parent and Players:GetPlayerFromCharacter(v.Adornee.Parent)==plr then
            v:Destroy()
        end
    end
end)

-- Fog Color Picker
local fogColorLabel = Instance.new("TextLabel")
fogColorLabel.Size = UDim2.new(0, 120, 0, 18)
fogColorLabel.Position = UDim2.new(0.08, 0, 0, 200)
fogColorLabel.BackgroundTransparency = 1
fogColorLabel.Text = "Fog Color"
fogColorLabel.Font = Enum.Font.Gotham
fogColorLabel.TextColor3 = Color3.fromRGB(200,220,255)
fogColorLabel.TextSize = 14
fogColorLabel.TextXAlignment = Enum.TextXAlignment.Left
fogColorLabel.Parent = frame

local fogColorBar = Instance.new("Frame")
fogColorBar.Size = UDim2.new(0, 90, 0, 18)
fogColorBar.Position = UDim2.new(0.53, 0, 0, 200)
fogColorBar.BackgroundColor3 = Color3.new(1,1,1)
fogColorBar.BorderSizePixel = 0
fogColorBar.Parent = frame

local fogColorBarCorner = Instance.new("UICorner", fogColorBar)
fogColorBarCorner.CornerRadius = UDim.new(0, 8)
local fogColorSlider = Instance.new("Frame")
fogColorSlider.Size = UDim2.new(0, 6, 1, 0)
fogColorSlider.Position = UDim2.new(0, 0, 0, 0)
fogColorSlider.BackgroundColor3 = Color3.fromRGB(0,0,0)
fogColorSlider.BorderSizePixel = 0
fogColorSlider.Parent = fogColorBar

local uiGradient = Instance.new("UIGradient", fogColorBar)
uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
    ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16,1,1)),
    ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33,1,1)),
    ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)),
    ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66,1,1)),
    ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83,1,1)),
    ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
}
uiGradient.Rotation = 0

local fogColorHSV = 0
local function updateFogColor()
    local color = Color3.fromHSV(fogColorHSV, 1, 1)
    Lighting.FogColor = color
    fogColorSlider.BackgroundColor3 = color
end

fogColorBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local function updateSlider(pos)
            local rel = math.clamp((pos.X - fogColorBar.AbsolutePosition.X)/fogColorBar.AbsoluteSize.X, 0, 1)
            fogColorHSV = rel
            fogColorSlider.Position = UDim2.new(rel, -3, 0, 0)
            updateFogColor()
        end
        updateSlider(UIS:GetMouseLocation())
        local moveConn, endConn
        moveConn = UIS.InputChanged:Connect(function(inp)
            if (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(inp.Position or UIS:GetMouseLocation())
            end
        end)
        endConn = UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                moveConn:Disconnect() endConn:Disconnect()
            end
        end)
    end
end)
updateFogColor()

-- Fog Distance Slider
local fogDistLabel = Instance.new("TextLabel")
fogDistLabel.Size = UDim2.new(0, 120, 0, 18)
fogDistLabel.Position = UDim2.new(0.08, 0, 0, 226)
fogDistLabel.BackgroundTransparency = 1
fogDistLabel.Text = "Fog End: "..tostring(Lighting.FogEnd)
fogDistLabel.Font = Enum.Font.Gotham
fogDistLabel.TextColor3 = Color3.fromRGB(200,220,255)
fogDistLabel.TextSize = 14
fogDistLabel.TextXAlignment = Enum.TextXAlignment.Left
fogDistLabel.Parent = frame

local fogSlider = Instance.new("TextButton")
fogSlider.Size = UDim2.new(0, 90, 0, 18)
fogSlider.Position = UDim2.new(0.53, 0, 0, 226)
fogSlider.BackgroundColor3 = Color3.fromRGB(60,60,80)
fogSlider.Text = ""
fogSlider.AutoButtonColor = false
fogSlider.Parent = frame

local fogFill = Instance.new("Frame")
fogFill.Size = UDim2.new(0, 60, 1, 0)
fogFill.BackgroundColor3 = Color3.fromRGB(170,170,255)
fogFill.BorderSizePixel = 0
fogFill.Parent = fogSlider

local fogCorner = Instance.new("UICorner", fogSlider)
fogCorner.CornerRadius = UDim.new(0, 8)
local fogFillCorner = Instance.new("UICorner", fogFill)
fogFillCorner.CornerRadius = UDim.new(0, 8)

local minFog, maxFog = 100, 2000
local draggingFog = false
fogSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFog = true
        local function updateSlider(pos)
            local rel = math.clamp((pos.X - fogSlider.AbsolutePosition.X)/fogSlider.AbsoluteSize.X, 0, 1)
            fogFill.Size = UDim2.new(rel, 0, 1, 0)
            local fogVal = math.floor(minFog + (maxFog-minFog)*rel)
            Lighting.FogEnd = fogVal
            fogDistLabel.Text = "Fog End: "..fogVal
        end
        updateSlider(UIS:GetMouseLocation())
        local moveConn, endConn
        moveConn = UIS.InputChanged:Connect(function(inp)
            if draggingFog and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(inp.Position or UIS:GetMouseLocation())
            end
        end)
        endConn = UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                draggingFog = false
                moveConn:Disconnect() endConn:Disconnect()
            end
        end)
    end
end)

-- Ghost Rainbow Character
local rainbowBtn = Instance.new("TextButton")
rainbowBtn.Size = UDim2.new(0.85, 0, 0, 28)
rainbowBtn.Position = UDim2.new(0.075, 0, 0, 256)
rainbowBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 220)
rainbowBtn.Text = "Ghost Rainbow: OFF"
rainbowBtn.Font = Enum.Font.GothamBold
rainbowBtn.TextColor3 = Color3.new(1,1,1)
rainbowBtn.TextSize = 14
rainbowBtn.Parent = frame

local rainbowOn = false
local rainbowConn
rainbowBtn.MouseButton1Click:Connect(function()
    rainbowOn = not rainbowOn
    rainbowBtn.Text = rainbowOn and "Ghost Rainbow: ON" or "Ghost Rainbow: OFF"
    rainbowBtn.BackgroundColor3 = rainbowOn and Color3.fromRGB(120,255,220) or Color3.fromRGB(255,120,220)
    if rainbowConn then rainbowConn:Disconnect() rainbowConn = nil end
    if rainbowOn then
        rainbowConn = RunService.RenderStepped:Connect(function()
            if LP.Character then
                local t = tick()*1.5
                local color = Color3.fromHSV((t%5)/5,1,1)
                for _,v in pairs(LP.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                        v.Color = color
                        v.Material = Enum.Material.ForceField
                        v.Transparency = 0.6
                        v.CanCollide = false
                    end
                    if v:IsA("Accessory") and v:FindFirstChild("Handle") then
                        v.Handle.Color = color
                        v.Handle.Material = Enum.Material.ForceField
                        v.Handle.Transparency = 0.6
                        v.Handle.CanCollide = false
                    end
                end
                -- Make humanoid root part invisible for better ghost effect
                local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Transparency = 1 end
            end
        end)
    else
        -- Restore original on toggle-off
        if LP.Character then
            for _,v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                    v.Transparency = 0
                    v.CanCollide = true
                end
                if v:IsA("Accessory") and v:FindFirstChild("Handle") then
                    v.Handle.Material = Enum.Material.Plastic
                    v.Handle.Transparency = 0
                    v.Handle.CanCollide = true
                end
            end
        end
    end
end)
LP.CharacterAdded:Connect(function()
    if rainbowOn and rainbowConn then
        rainbowConn:Disconnect()
        rainbowConn = RunService.RenderStepped:Connect(function()
            if LP.Character then
                local t = tick()*1.5
                local color = Color3.fromHSV((t%5)/5,1,1)
                for _,v in pairs(LP.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                        v.Color = color
                        v.Material = Enum.Material.ForceField
                        v.Transparency = 0.6
                        v.CanCollide = false
                    end
                    if v:IsA("Accessory") and v:FindFirstChild("Handle") then
                        v.Handle.Color = color
                        v.Handle.Material = Enum.Material.ForceField
                        v.Handle.Transparency = 0.6
                        v.Handle.CanCollide = false
                    end
                end
                local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Transparency = 1 end
            end
        end)
    else
        if LP.Character then
            for _,v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                    v.Transparency = 0
                    v.CanCollide = true
                end
                if v:IsA("Accessory") and v:FindFirstChild("Handle") then
                    v.Handle.Material = Enum.Material.Plastic
                    v.Handle.Transparency = 0
                    v.Handle.CanCollide = true
                end
            end
        end
    end
end)

-- === USER TP FEATURE ===
local userBox = Instance.new("TextBox")
userBox.Size = UDim2.new(0, 110, 0, 26)
userBox.Position = UDim2.new(0.05, 0, 1, -66)
userBox.PlaceholderText = "Username"
userBox.Text = ""
userBox.BackgroundColor3 = Color3.fromRGB(45, 55, 80)
userBox.TextColor3 = Color3.fromRGB(180,180,255)
userBox.Font = Enum.Font.GothamBold
userBox.TextSize = 15
userBox.Parent = frame

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0, 60, 0, 26)
tpBtn.Position = UDim2.new(0.52, 0, 1, -66)
tpBtn.BackgroundColor3 = Color3.fromRGB(100,255,180)
tpBtn.Text = "TP"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextColor3 = Color3.fromRGB(30,80,30)
tpBtn.TextSize = 15
tpBtn.Parent = frame

-- Helper: Find player by partial or full username, case-insensitive
local function findPlayerByInput(str)
    if not str or str == "" then return nil end
    str = str:lower()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower():sub(1, #str) == str then
            return plr
        end
        if plr.DisplayName:lower():find(str, 1, true) then
            return plr
        end
    end
    return nil
end

tpBtn.MouseButton1Click:Connect(function()
    local typed = userBox.Text
    local target = findPlayerByInput(typed)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        tpBtn.Text = "Not found"
        wait(1.2)
        tpBtn.Text = "TP"
        return
    end
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    end
    tpBtn.Text = "TP'd!"
    wait(1.2)
    tpBtn.Text = "TP"
end)

-- AIM VIEWER FOR ONE USER ONLY: Toggle, shows aim line for the username in userBox only (if has weapon)
local aimViewerBtn = Instance.new("TextButton")
aimViewerBtn.Size = UDim2.new(0, 80, 0, 26)
aimViewerBtn.Position = UDim2.new(0.79, 0, 1, -66)
aimViewerBtn.BackgroundColor3 = Color3.fromRGB(220, 200, 80)
aimViewerBtn.Text = "Aim Viewer: OFF"
aimViewerBtn.Font = Enum.Font.GothamBold
aimViewerBtn.TextColor3 = Color3.fromRGB(50, 40, 10)
aimViewerBtn.TextSize = 13
aimViewerBtn.Parent = frame

local aimViewerOn = false
aimViewerBtn.MouseButton1Click:Connect(function()
    aimViewerOn = not aimViewerOn
    aimViewerBtn.Text = aimViewerOn and "Aim Viewer: ON" or "Aim Viewer: OFF"
    aimViewerBtn.BackgroundColor3 = aimViewerOn and Color3.fromRGB(120,255,120) or Color3.fromRGB(220,200,80)
end)

local aimArrow = nil
local lastViewedPlayer = nil
local function clearAimArrow()
    if aimArrow and (aimArrow.Remove or aimArrow.Destroy) then
        if aimArrow.Remove then aimArrow:Remove() else aimArrow:Destroy() end
    end
    aimArrow = nil
    lastViewedPlayer = nil
end

local function updateAimArrow()
    if not aimViewerOn then clearAimArrow() return end
    local cam = workspace.CurrentCamera
    local username = userBox.Text
    local plr = findPlayerByInput(username)
    if not plr or not plr.Character or not plr.Character:FindFirstChild("Head") or not plr.Character:FindFirstChild("HumanoidRootPart") or not plr.Character:FindFirstChildOfClass("Humanoid") or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 or not hasWeapon(plr) then
        clearAimArrow()
        return
    end
    local head = plr.Character.Head
    local hrp = plr.Character.HumanoidRootPart
    local lookVector = hrp.CFrame.LookVector
    local aimPos = head.Position + lookVector * 35
    local screenFrom, onScreenFrom = cam:WorldToViewportPoint(head.Position)
    local screenTo, onScreenTo = cam:WorldToViewportPoint(aimPos)
    if onScreenFrom and onScreenTo then
        if not aimArrow and Drawing and Drawing.new then
            aimArrow = Drawing.new("Line")
            aimArrow.Thickness = 3
            aimArrow.Color = Color3.fromRGB(255,230,60)
        end
        if aimArrow then
            aimArrow.From = Vector2.new(screenFrom.X, screenFrom.Y)
            aimArrow.To = Vector2.new(screenTo.X, screenTo.Y)
            aimArrow.Visible = true
        end
        lastViewedPlayer = plr
    else
        clearAimArrow()
    end
end

RunService.RenderStepped:Connect(function()
    updateAimArrow()
end)

-- Camlock (auto-lock on nearest to crosshair)
local lockedPlayer = nil
local function getClosestPlayerToCrosshair()
    local cam = workspace.CurrentCamera
    local closest, minDist = nil, math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos, onScreen = cam:WorldToViewportPoint(plr.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end
camlockBtn.MouseButton1Click:Connect(function()
    lockedPlayer = getClosestPlayerToCrosshair()
    if lockedPlayer then
        camlockBtn.Text = "Camlocked: "..lockedPlayer.DisplayName
        camlockBtn.BackgroundColor3 = Color3.fromRGB(38,170,255)
    else
        camlockBtn.Text = "No Players"
        wait(0.7)
        camlockBtn.Text = "Camlock"
    end
end)
unlockBtn.MouseButton1Click:Connect(function()
    lockedPlayer = nil
    camlockBtn.Text = "Camlock"
    camlockBtn.BackgroundColor3 = Color3.fromRGB(38,170,255)
end)
UIS.InputBegan:Connect(function(input,gp)
    if input.KeyCode == Enum.KeyCode.Q and lockedPlayer then
        lockedPlayer = nil
        camlockBtn.Text = "Camlock"
        camlockBtn.BackgroundColor3 = Color3.fromRGB(38,170,255)
    end
end)
RunService.RenderStepped:Connect(function()
    if lockedPlayer and lockedPlayer.Character and lockedPlayer.Character:FindFirstChild("Head") and LP.Character then
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, lockedPlayer.Character.Head.Position)
    end
end)
    else
        textbox.Text = ""
        textbox.PlaceholderText = "❌ Wrong Key! Try Again"
    end
end)

discordBtn.MouseButton1Click:Connect(function()
    setclipboard(DiscordLink)
    discordBtn.Text = "Copied!"
    task.delay(2, function()
        discordBtn.Text = "Get Key (Discord)"
    end)
end)