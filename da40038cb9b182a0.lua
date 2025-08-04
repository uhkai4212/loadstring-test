local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoAimPlus"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 190)
frame.Position = UDim2.new(0.5, -90, 0.5, -95)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 2
frame.Parent = gui

-- Make draggable
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "Auto Aim Plus"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 20)
status.Position = UDim2.new(0, 5, 0, 30)
status.Text = "Ready"
status.TextColor3 = Color3.new(0, 1, 0)
status.TextScaled = true
status.BackgroundTransparency = 1
status.Parent = frame

-- Mode label
local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, -10, 0, 20)
modeLabel.Position = UDim2.new(0, 5, 0, 55)
modeLabel.Text = "Mode: Stay in Place"
modeLabel.TextColor3 = Color3.new(1, 1, 0)
modeLabel.TextScaled = true
modeLabel.BackgroundTransparency = 1
modeLabel.Parent = frame

-- Variables
local aiming = false
local aimConnection = nil
local currentFishIndex = 1
local followMode = false
local noclipConnection = nil

-- Boss names mapping
local bossNames = {
    ["SFish3"] = "Sea Elf",
    ["SFish"] = "Loch Ness",
    ["SFish1"] = "Loch Ness",
    ["SFish2"] = "Skeleton",
    ["SFish4"] = "Godzilla"
}

-- Enable noclip
local function enableNoclip()
    if noclipConnection then return end
    
    noclipConnection = runService.Stepped:Connect(function()
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- Disable noclip
local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

-- Get fish from FishModelList only
local function getRealFish()
    local fishList = workspace:FindFirstChild("FishModelList")
    if not fishList then return {} end
    
    local fish = {}
    local bosses = {}
    
    for _, obj in pairs(fishList:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local humanoid = obj:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if bossNames[obj.Name] then
                    -- It's a boss!
                    table.insert(bosses, obj)
                else
                    table.insert(fish, obj)
                end
            end
        end
    end
    
    -- If boss exists, prioritize it
    if #bosses > 0 then
        return bosses
    end
    
    -- Sort by distance if in follow mode
    if followMode and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local playerPos = player.Character.HumanoidRootPart.Position
        table.sort(fish, function(a, b)
            local distA = (a:GetModelCFrame().p - playerPos).Magnitude
            local distB = (b:GetModelCFrame().p - playerPos).Magnitude
            return distA < distB
        end)
    end
    
    return fish
end

-- Aim at specific fish
local function aimAtFish(fish)
    if not fish or not fish.Parent then return end
    
    local fishPos = fish:GetModelCFrame().p
    
    -- Aim character
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        
        if followMode then
            -- Teleport to fishing area boundary near fish
            -- Keep within fishing zone limits
            local fishingCenter = Vector3.new(-75, 82, -100)
            local maxDistance = 50 -- Maximum distance from center
            
            local directionToFish = (fishPos - fishingCenter).Unit
            local distanceToFish = (fishPos - fishingCenter).Magnitude
            
            if distanceToFish > maxDistance then
                -- Fish is outside zone, position at edge looking at it
                local edgePos = fishingCenter + (directionToFish * (maxDistance - 5))
                rootPart.CFrame = CFrame.new(edgePos, fishPos)
            else
                -- Fish is in zone, get close
                local offset = Vector3.new(5, 3, 5)
                rootPart.CFrame = CFrame.new(fishPos + offset, fishPos)
            end
        else
            -- Just aim
            rootPart.CFrame = CFrame.lookAt(rootPart.Position, fishPos)
        end
    end
    
    -- Aim camera
    if camera then
        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, fishPos)
    end
end

-- Start auto aiming
local function startAiming()
    aiming = true
    status.Text = "Aiming..."
    
    if followMode then
        enableNoclip()
    end
    
    -- Different logic for follow mode
    if followMode then
        -- Follow mode: Stay with each fish until dead
        spawn(function()
            while aiming do
                local allFish = getRealFish()
                
                if #allFish == 0 then
                    status.Text = "No fish found!"
                    wait(2)
                else
                    for _, fish in pairs(allFish) do
                        if not aiming then break end
                        
                        local humanoid = fish:FindFirstChild("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            local displayName = bossNames[fish.Name] and ("BOSS: " .. bossNames[fish.Name]) or fish.Name
                            status.Text = "Following: " .. displayName
                            if bossNames[fish.Name] then
                                status.TextColor3 = Color3.new(1, 0, 0)
                            else
                                status.TextColor3 = Color3.new(0, 1, 0)
                            end
                            
                            -- Stay with this fish until dead
                            while humanoid.Health > 0 and aiming and fish.Parent do
                                aimAtFish(fish)
                                wait(0.1)
                            end
                            
                            wait(0.2) -- Brief pause before next fish
                        end
                    end
                end
            end
        end)
    else
        -- Stay mode: Rapid aim switching
        aimConnection = runService.Heartbeat:Connect(function()
            if not aiming then return end
            
            local allFish = getRealFish()
            
            if #allFish == 0 then
                status.Text = "No fish found!"
                return
            end
            
            -- Cycle through fish
            if currentFishIndex > #allFish then
                currentFishIndex = 1
            end
            
            local targetFish = allFish[currentFishIndex]
            
            if targetFish and targetFish.Parent then
                aimAtFish(targetFish)
                local displayName = bossNames[targetFish.Name] and ("BOSS: " .. bossNames[targetFish.Name]) or targetFish.Name
                status.Text = "Aiming: " .. displayName
                if bossNames[targetFish.Name] then
                    status.TextColor3 = Color3.new(1, 0, 0)
                else
                    status.TextColor3 = Color3.new(0, 1, 0)
                end
            end
            
            -- Move to next fish
            wait(0.2)
            currentFishIndex = currentFishIndex + 1
        end)
    end
end

-- Stop aiming
local function stopAiming()
    aiming = false
    if aimConnection then
        aimConnection:Disconnect()
        aimConnection = nil
    end
    disableNoclip()
    status.Text = "Stopped"
end

-- Mode toggle button
local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(1, -10, 0, 30)
modeBtn.Position = UDim2.new(0, 5, 0, 80)
modeBtn.Text = "Toggle Mode"
modeBtn.TextColor3 = Color3.new(1, 1, 1)
modeBtn.TextScaled = true
modeBtn.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
modeBtn.Parent = frame

modeBtn.MouseButton1Click:Connect(function()
    followMode = not followMode
    if followMode then
        modeLabel.Text = "Mode: Follow Fish"
        modeLabel.TextColor3 = Color3.new(1, 0.5, 0)
    else
        modeLabel.Text = "Mode: Stay in Place"
        modeLabel.TextColor3 = Color3.new(1, 1, 0)
    end
    
    -- Restart if currently aiming
    if aiming then
        stopAiming()
        wait(0.1)
        startAiming()
    end
end)

-- Teleport to Fish button
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, -10, 0, 25)
tpBtn.Position = UDim2.new(0, 5, 0, 115)
tpBtn.Text = "TP to Fish Area"
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.TextScaled = true
tpBtn.BackgroundColor3 = Color3.new(0, 0.5, 0.8)
tpBtn.Parent = frame

tpBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Teleport to center of fishing area
        player.Character.HumanoidRootPart.CFrame = CFrame.new(-75, 82, -100)
        tpBtn.Text = "Teleported!"
        tpBtn.BackgroundColor3 = Color3.new(0, 0.8, 0)
        wait(1)
        tpBtn.Text = "TP to Fish Area"
        tpBtn.BackgroundColor3 = Color3.new(0, 0.5, 0.8)
    end
end)

-- Start/Stop button
local aimBtn = Instance.new("TextButton")
aimBtn.Size = UDim2.new(1, -10, 0, 30)
aimBtn.Position = UDim2.new(0, 5, 0, 145)
aimBtn.Text = "START AIM"
aimBtn.TextColor3 = Color3.new(1, 1, 1)
aimBtn.TextScaled = true
aimBtn.BackgroundColor3 = Color3.new(0, 0.7, 0)
aimBtn.Parent = frame

aimBtn.MouseButton1Click:Connect(function()
    if aiming then
        stopAiming()
        aimBtn.Text = "START AIM"
        aimBtn.BackgroundColor3 = Color3.new(0, 0.7, 0)
    else
        startAiming()
        aimBtn.Text = "STOP"
        aimBtn.BackgroundColor3 = Color3.new(0.8, 0, 0)
    end
end)

-- Minimize button
local minimized = false
local originalSize = frame.Size

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0.15, 0, 0, 20)
minBtn.Position = UDim2.new(0.55, -5, 0, 5)
minBtn.Text = "_"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
minBtn.Parent = frame

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame.Size = UDim2.new(0, 180, 0, 25)
        minBtn.Text = "+"
        for _, child in pairs(frame:GetChildren()) do
            if child ~= title and child ~= minBtn and child ~= closeBtn then
                child.Visible = false
            end
        end
    else
        frame.Size = originalSize
        minBtn.Text = "_"
        for _, child in pairs(frame:GetChildren()) do
            child.Visible = true
        end
    end
end)

-- Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.15, 0, 0, 20)
closeBtn.Position = UDim2.new(0.7, -5, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.new(0.8, 0, 0)
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    stopAiming()
    gui:Destroy()
end)

print("Auto Aim Plus loaded! Toggle between Stay and Follow modes.")