local CoreGui = game:GetService("CoreGui")

local sagaGui = Instance.new("ScreenGui", CoreGui)
sagaGui.ResetOnSpawn = false

local sf = Instance.new("Frame", sagaGui)
sf.Size = UDim2.new(1,0,1,0)
sf.BackgroundColor3 = Color3.new(0,0,0)

local st = Instance.new("TextLabel", sf)
st.Size = UDim2.new(1,0,1,0)
st.BackgroundTransparency = 1
st.Text = "👁️  SAGA – SUBSCRIBE TO DARKDEX  👁️"
st.TextColor3 = Color3.new(1,0,0)
st.Font = Enum.Font.GothamBlack
st.TextScaled = true

for _ = 1,10 do
    st.Position = UDim2.new(0, math.random(-4,4), 0, math.random(-4,4))
    task.wait(0.05)
end
task.wait(1)
sagaGui:Destroy()

--[[  MADE BY DARKDEX splash (2 s)  ]]---------------------------------------
local splashGui = Instance.new("ScreenGui", CoreGui)
splashGui.ResetOnSpawn = false

local sF = Instance.new("Frame", splashGui)
sF.Size = UDim2.new(1,0,1,0)
sF.BackgroundColor3 = Color3.new(0,0,0)

local sT = Instance.new("TextLabel", sF)
sT.Size = UDim2.new(1,0,1,0)
sT.BackgroundTransparency = 1
sT.Text = "MADE BY DARKDEX"
sT.TextColor3 = Color3.fromRGB(255,215,0)
sT.Font = Enum.Font.GothamBlack
sT.TextScaled = true
sT.TextTransparency = 1

for i = 1,20 do
    sT.TextTransparency = 1 - i*0.05
    task.wait(0.05)
end
task.wait(2)
for i = 1,20 do
    sT.TextTransparency = i*0.05
    task.wait(0.05)
end
splashGui:Destroy()

--[[  GUI  ]]-----------------------------------------------------------------
local Players, RunService, UIS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService")
local lp, cam = Players.LocalPlayer, workspace.CurrentCamera

local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name, gui.ResetOnSpawn = "DarkDexGUI", false

local plusBtn = Instance.new("TextButton", gui)
plusBtn.Size, plusBtn.Position = UDim2.new(0,40,0,40), UDim2.new(0,10,0,10)
plusBtn.Text, plusBtn.Visible = "+", false
plusBtn.BackgroundColor3 = Color3.fromRGB(40,200,40)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.TextScaled = true

local main = Instance.new("Frame", gui)
main.Size, main.Position = UDim2.new(0,300,0,400), UDim2.new(0.5,-150,0.5,-200)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1,-50,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "DarkDex The Strongest Battlegrounds"
title.TextColor3 = Color3.fromRGB(255,215,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size, closeBtn.Position = UDim2.new(0,40,0,40), UDim2.new(1,-40,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
closeBtn.Text, closeBtn.Font, closeBtn.TextScaled = "X", Enum.Font.GothamBold, true
closeBtn.TextColor3 = Color3.new(1,1,1)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible, plusBtn.Visible = false, true
end)
plusBtn.MouseButton1Click:Connect(function()
    main.Visible, plusBtn.Visible = true, false
end)

local ugBtn = Instance.new("TextButton", main)
ugBtn.Size, ugBtn.Position = UDim2.new(0.9,0,0,50), UDim2.new(0.05,0,0,60)
ugBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ugBtn.Font = Enum.Font.GothamBold
ugBtn.TextColor3 = Color3.new(1,1,1)
ugBtn.TextScaled = true
ugBtn.Text = "Underground: OFF"

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size, scroll.Position = UDim2.new(0.9,0,0,280), UDim2.new(0.05,0,0,120)
scroll.BackgroundColor3 = Color3.fromRGB(30,30,30)
scroll.BorderSizePixel, scroll.ScrollBarThickness = 0, 6
local ll = Instance.new("UIListLayout", scroll)
ll.SortOrder = Enum.SortOrder.LayoutOrder

-- states
local underground, selName = false, nil
local yOffset, pred = Vector3.new(0,-5,0), 2

ugBtn.MouseButton1Click:Connect(function()
    underground = not underground
    ugBtn.Text = underground and "Underground: ON" or "Underground: OFF"
    if not underground and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame += Vector3.new(0,5,0)
    end
end)

local function selectPlayer(n)
    selName = n
    for _,b in pairs(scroll:GetChildren()) do
        if b:IsA("TextButton") then
            b.BackgroundColor3 = (b.Name==n) and Color3.fromRGB(70,70,70) or Color3.fromRGB(50,50,50)
        end
    end
end

local function addBtn(plr)
    if plr == lp then return end
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1,0,0,30)
    b.Name = plr.Name
    b.Text = plr.DisplayName.." ("..plr.Name..")"
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextScaled = true
    b.MouseButton1Click:Connect(function() selectPlayer(plr.Name) end)
end

local function refresh()
    for _,c in pairs(scroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _,p in pairs(Players:GetPlayers()) do addBtn(p) end
    scroll.CanvasSize = UDim2.new(0,0,0,ll.AbsoluteContentSize.Y)
end
Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
refresh()

-- drag
local dragging, dragInput, dragStart, startPos
local function update(i)
    local d = i.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
end
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, i.Position, main.Position
        i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
    end
end)
titleBar.InputChanged:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
        dragInput = i
    end
end)
UIS.InputChanged:Connect(function(i) if dragging and i==dragInput then update(i) end end)

RunService.Heartbeat:Connect(function()
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if underground and selName and hrp then
        local tgt = Players:FindFirstChild(selName)
        local thrp = tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart")
        if thrp then
            local v = thrp.Velocity
            local pos = thrp.Position + yOffset + ((v.Magnitude>2) and v.Unit*pred or Vector3.new())
            hrp.CFrame = CFrame.new(pos, pos + Vector3.new(0,1,0))
            cam.CameraSubject = tgt.Character:FindFirstChild("Humanoid")
        end
    else
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then cam.CameraSubject = hum end
    end
end)