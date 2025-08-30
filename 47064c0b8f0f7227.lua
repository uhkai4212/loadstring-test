if not game:IsLoaded() then
       game.Loaded:Wait()
end
local Fluent = loadstring(game:HttpGet("https://github.com/NoobHubV4/RobloxScripts/blob/main/Fluent/Lib?raw=true"))()
local Window = Fluent:CreateWindow({Title = "Anime Ball",SubTitle = "v1.2",TabWidth = 100,Size = UDim2.fromOffset(480, 300),Acrylic = false,Theme = "Amethyst",MinimizeKey = Enum.KeyCode.RightShift})
local Tabs = {Home = Window:AddTab({ Title = "Home", Icon = "" }),Combat = Window:AddTab({ Title = "Combat", Icon = "" }),}
local Player = game.Players.localPlayer
local VIM = game:GetService("VirtualInputManager") or game:FindFirstDescendant("VirtualInputManager")
local AutoMove = false
local AutoParry
local Cooldown
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Toggle = Instance.new("TextButton", ScreenGui)
local Toggle2 = Instance.new("TextButton", ScreenGui)
local UICorner = Instance.new("UICorner", Toggle2)
local SpamParry = false
local visual1
local visual2
local mesh1
local mesh2
local ParryDistance = 0
local showCircle
local bill
local frame
local TextLabel
local Stroke

ScreenGui.Name = "gui"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = true

Toggle.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
Toggle.BackgroundTransparency = 0
Toggle.Position = UDim2.new(0, 0, 0, 0)
Toggle.Size = UDim2.new(0, 180, 0, 40)
Toggle.Font = Enum.Font.SourceSans
Toggle.Text = "SpamParry [OFF]"
Toggle.TextColor3 = Color3.fromRGB(150, 100, 75)
Toggle.TextScaled = true
Toggle.TextSize = 15.000
Toggle.TextStrokeTransparency = 0.000
Toggle.TextWrapped = true
Toggle.Draggable = true
Toggle.Visible = false
local script = Instance.new("LocalScript", Toggle)
Toggle.MouseButton1Click:Connect(function()
     SpamParry = not SpamParry
     if SpamParry then
           script.Parent.Text = "SpamParry [ON]"
     elseif not SpamParry then
           script.Parent.Text = "SpamParry [OFF]"
     end
end)

Toggle2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Toggle2.BackgroundTransparency = 0
Toggle2.Position = UDim2.new(0, 10, 0.5, 0)
Toggle2.Size = UDim2.new(0, 70, 0, 30)
Toggle2.Font = Enum.Font.SourceSans
Toggle2.Text = "Toggle"
Toggle2.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle2.TextScaled = true
Toggle2.TextSize = 15.000
Toggle2.TextStrokeTransparency = 0.000
Toggle2.TextWrapped = true
Toggle2.Draggable = true
local script2 = Instance.new("LocalScript", Toggle2)
script2.Parent.MouseButton1Click:Connect(function()
     for i,v in next, game.CoreGui.ScreenGui:GetChildren() do
if v.Name == "Frame" and v.Position ~= UDim2.new(1, -30, 1, -30) then
v.Visible = not v.Visible
end
end
end)

UICorner.CornerRadius = UDim.new(0, 5)

function GetBall()
  for i,v in pairs(game.workspace.Balls:GetChildren()) do
    return v
  end
end

function GetRoot()
  for i,v in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if v:IsA("BasePart") and v.Name == "HumanoidRootPart" then
      return v
    end
  end
end

function t(Title, Text, Time)
    game:FindService("StarterGui"):SetCore("SendNotification",{Title=Title,Text=Text,Icon="",Duration=Time,})
end
function createCircle()
    visual1 = Instance.new("Part",workspace)
    visual2 = Instance.new("Part",workspace)
    mesh1 = Instance.new("SpecialMesh",visual1)
    mesh2 = Instance.new("SpecialMesh",visual2)
    visual1.Name = "Circle"
    visual1.Material = "Plastic"
    visual1.Transparency = 0.75
    visual1.Size = Vector3.new(10, 0.4, 10)
    visual1.CanCollide = false
    visual1.Anchored = true
    mesh1.MeshId = "rbxassetid://471124075"
    mesh1.MeshType = "FileMesh"
    mesh1.Scale = Vector3.new(0.05, 0.05, 0.05)
    visual2.Name = "CircleFollowBall"
    visual2.Material = "Plastic"
    visual2.Transparency = 0
    visual2.Size = Vector3.new(10, 0.4, 10)
    visual2.CanCollide = false
    visual2.Anchored = true
    mesh2.MeshId = "rbxassetid://471124075"
    mesh2.MeshType = "FileMesh"
    mesh2.Scale = Vector3.new(0.05, 0.05, 0.05)
end

function Notify(title, content, duration)
    duration = duration
    if not duration then
           duration = 3
    end
    Fluent:Notify({Title = title, Content = content, Duration = duration})
end

function createBallSpeed()
    bill = Instance.new("BillboardGui",Player.Character.Head)
    frame = Instance.new("Frame",bill)
    TextLabel = Instance.new("TextLabel",frame)
    Stroke = Instance.new("UIStroke",TextLabel)
    bill.Name = "speed"
    bill.Active = true
    bill.Enabled = true
    bill.ResetOnSpawn = true
    bill.AlwaysOnTop = false
    bill.DistanceLowerLimit = 0
    bill.DistanceStep = 0
    bill.DistanceUpperLimit = -1
    bill.LightInfluence = 1
    bill.MaxDistance = 100
    bill.Size = UDim2.new(6.25, 0, 2.875, 0)
    bill.StudsOffset = Vector3.new(0, 2, 0)
    bill.Brightness = 10
    bill.StudsOffsetWorldSpace = Vector3.new(0, 1.1, 0)
    bill.ZIndexBehavior = "Sibling"
    bill.ClipsDescendants = true
    frame.Active = false
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0.5, 0, 0.375, 0)
    frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1.25, 0, 0.75, 0)
    TextLabel.Active = false
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    TextLabel.Size = UDim2.new(1.15, 0, 1.25, 0)
    TextLabel.TextScaled = true
    TextLabel.TextSize = 25
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextStrokeTransparency = 1
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.Text = "0"
    Stroke.Thickness = 2
end

local Options = Fluent.Options
do
       Tabs.Home:AddParagraph({Title = "Credits",Content = "Credits by NoobHubV4"})
       Tabs.Home:AddButton({Title = "Copy Script",Description = "",Callback = function() setclipboard("https://github.com/NoobHubV4/RobloxScripts") end})
       local autoblock = Tabs.Combat:AddToggle("State1", {Title = "Auto Parry", Default = false })
       local manualspam = Tabs.Combat:AddToggle("State2", {Title = "Manual Spam", Default = false })
       local automove = Tabs.Combat:AddToggle("State3", {Title = "Follow Ball", Default = false })
       local parrydistance = Tabs.Combat:AddSlider("Slider", {Title = "Parry Distance Multiplier",Description = "",Default = 0.5,Min = 0.1,Max = 3,Rounding = 2})
       local Show = Tabs.Combat:AddToggle("State4", {Title = "Show Visualizer", Default = false })
       autoblock:OnChanged(function()
              AutoParry = Options.State1.Value; Notify('NoobHubV4 Hub', 'Auto Parry '..tostring(AutoParry))
       end)
       manualspam:OnChanged(function()
              Toggle.Visible = Options.State2.Value; Notify('NoobHubV4 Hub', 'Manual Spam '..tostring(Toggle.Visible))
       end)
       automove:OnChanged(function()
              AutoMove = Options.State3.Value; Notify('NoobHubV4 Hub', 'Auto Move '..tostring(AutoMove))
       end)
       parrydistance:OnChanged(function(value)
              ParryDistance = value
       end)
       Show:OnChanged(function()
              showCircle = Options.State4.Value; Notify('NoobHubV4 Hub', 'Show Visualizer '..tostring(showCircle))
       end)
end
workspace.Balls.ChildAdded:Connect(function(child)
       child:GetAttributeChangedSignal("Target"):Connect(function()
              Parried = false
       end)
end)
spawn(function()
    function work()
        local Ball, HRP, block = GetBall(), GetRoot(), ParryDistance
        if Ball:GetAttribute("Target") == Player.Name and not Parried and (HRP.Position - Ball.Position).Magnitude / Ball.LinearVelocity.VectorVelocity.Magnitude <= block and AutoParry then
            game.ReplicatedStorage.Framework.RemoteFunction:InvokeServer("SwordService","Block",{0})
            Parried = true; Cooldown = tick()
            while task.wait() do
                if not Parried then
                    break
                end
                if tick() - Cooldown >= 1 and Ball:GetAttribute("Target") == Player.Name then
                    Parried = false
                end
            end
        end
    end
    while task.wait() do
        pcall(work)
    end
end)
spawn(function()
    function task0()
        if showCircle and not visual1 and not visual2 then
            createCircle()
        elseif not showCircle and visual1 and visual2 then
            visual1:Destroy(); visual2:Destroy(); visual1 = nil; visual2 = nil
        end
    end
    while task.wait() do
        pcall(task0)
    end
end)
function step()
    if SpamParry then
        game.ReplicatedStorage.Framework.RemoteFunction:InvokeServer("SwordService","Block",{0})
    end
end
game.RunService.RenderStepped:Connect(step)
spawn(function()
     function task1()
         local Ball, humanoid = GetBall(), Player.Character.Humanoid
         if Ball and humanoid and AutoMove then
                humanoid:MoveTo(Ball.Position)
         end
         if visual1 and visual2 then
                visual1.Color = Color3.fromHSV(tick() % (10/1.5) / (10/1.5), 1, 1)
                visual2.Color = Color3.fromHSV(tick() % (10/1.5) / (10/1.5), 1, 1)
         end
     end
     while task.wait() do
         pcall(task1)
     end
end)
spawn(function()
     task2 = function()
         local Ball = GetBall()
         local speed = Ball.LinearVelocity.VectorVelocity.Magnitude / 500 * 3 * ParryDistance
         if speed and visual1 and visual2 and AutoParry then
                visual1.CFrame = GetRoot().CFrame
                visual2.CFrame = CFrame.new(GetRoot().Position, Ball.Position)
                mesh1.Scale = Vector3.new(speed, 0.05, speed)
                mesh2.Scale = Vector3.new(speed, 0.05, speed)
         end
         if bill and frame and TextLabel and Stroke then
                TextLabel.Text = math.round(Ball.LinearVelocity.VectorVelocity.Magnitude * ParryDistance)
                Stroke.Color = Color3.fromHSV(tick() % (10/2) / (10/2), 1, 1)
         end
         if not AutoParry and visual1 and visual2 then
           visual2.CFrame = GetRoot().CFrame
         end
     end
     while task.wait() do
         pcall(task2)
     end
end)
spawn(function()
      task3 = function()
           if visual1 and visual2 then
               visual1.CFrame = GetRoot().CFrame
           end
           if GetBall() and AutoParry and visual1 and visual2 then
               visual2.CFrame = CFrame.new(GetRoot().CFrame.p, GetBall().CFrame.p)
           end
           if not GetBall() and AutoParry and visual1 and visual2 then
               visual2.CFrame = GetRoot().CFrame
           end
      end
      while task.wait() do
           pcall(task3)
      end
end)
Player.CharacterAdded:Connect(function()
      createBallSpeed()
end)
createBallSpeed()
Notify("Anime Ball", 'Script Loaded', 10)
Window:SelectTab(1)