Callback = function()
    end
})
game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Keybind: RightShift",
    Icon = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Image = "rbxthumb://type=Asset&id=106019376492019&w=420&h=420"
getgenv().ToggleUI = "LeftControl"

task.spawn(function()
    if not getgenv().LoadedMobileUI then
        getgenv().LoadedMobileUI = true
        local OpenUI = Instance.new("ScreenGui")
        local ImageButton = Instance.new("ImageButton")
        local UICorner = Instance.new("UICorner")
        OpenUI.Name = "OpenUI"
        OpenUI.Parent = game:GetService("CoreGui")
        OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ImageButton.Parent = OpenUI
        ImageButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
        ImageButton.BackgroundTransparency = 0.8
        ImageButton.Position = UDim2.new(0, 20, 0, 25)
        ImageButton.Size = UDim2.new(0, 50, 0, 50)
        ImageButton.Image = getgenv().Image
        ImageButton.Draggable = true
        ImageButton.Transparency = 1
        UICorner.CornerRadius = UDim.new(0,13)
        UICorner.Parent = ImageButton
        ImageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, getgenv().ToggleUI, false, game)
        end)
    end
end)
local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = `Aura Hub | {Library.Version}`,
    SubTitle = "by Ziugpro",
    TabWidth = 160,
    Size = UDim2.fromOffset(530, 380),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "house"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}
local Options = Library.Options
function ForceTeleport(cf, holdTime)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    local t0 = tick()
    while tick() - t0 < (holdTime or 0.75) do
        root.CFrame = cf
        root.Velocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        task.wait()
    end
end
local Main = Tabs.Main:AddSection("Farm")

local speed = 500
local SpeedInput = Tabs.Main:CreateInput("SpeedInput", {
    Title = "Speed",
    Default = "500",
    Placeholder = "Enter speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        speed = tonumber(Value) or 500
    end
})
local Paragraph = Tabs.Main:CreateParagraph("ErrorNotify", {
    Title = "Please adjust the speed below 510 to avoid error",
    Content = ""
})
local FlyToggleVar = Tabs.Main:CreateToggle("FlyToggle", {Title = "Auto Win", Default = false})

FlyToggleVar:OnChanged(function(state)
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")
    local TweenService = game:GetService("TweenService")
    local targetCFrame = CFrame.new(3.372170925140381, 6.251251220703125, 38088.98046875)

    local ScreenGui, FullBlack, Image, Version

    if state then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "KaitunUI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.DisplayOrder = 99
        ScreenGui.Parent = PlayerGui

        FullBlack = Instance.new("Frame")
        FullBlack.Size = UDim2.new(1, 0, 1, 36)
        FullBlack.Position = UDim2.new(0, 0, -0.03, 0)
        FullBlack.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        FullBlack.BorderSizePixel = 0
        FullBlack.ZIndex = 19999999
        FullBlack.BackgroundTransparency = 0.4
        FullBlack.Parent = ScreenGui

        Image = Instance.new("ImageLabel")
        Image.Size = UDim2.new(0, 100, 0, 100)
        Image.Position = UDim2.new(0.5, -50, 0.5, -90)
        Image.BackgroundTransparency = 1
        Image.Image = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420"
        Image.ZIndex = 29999999
        Image.Parent = ScreenGui

        Version = Instance.new("TextLabel")
        Version.AnchorPoint = Vector2.new(0.5, 0.5)
        Version.Position = UDim2.new(0.5, 0, 0.5, 40)
        Version.Size = UDim2.new(0, 600, 0, 50)
        Version.BackgroundTransparency = 1
        Version.Text = "Aura Hub"
        Version.Font = Enum.Font.PermanentMarker
        Version.TextSize = 55
        Version.TextColor3 = Color3.fromRGB(255, 255, 255)
        Version.ZIndex = 39999999
        Version.Parent = ScreenGui

        local char = Player.Character or Player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        local function fly()
            local distance = (hrp.Position - targetCFrame.Position).Magnitude
            local tweenTime = distance / speed
            local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
        end

        fly()
    else
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end
end)
local Main = Tabs.Main:AddSection("Item")
Tabs.Main:AddButton({
    Title = "Bring Items",
    Callback = function()
        local lp = game.Players.LocalPlayer
        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
        local root = lp.Character.HumanoidRootPart

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") == nil and obj:FindFirstChild("Handle") then
                obj:SetPrimaryPartCFrame(CFrame.new(root.Position + root.CFrame.LookVector * 5))
            end
        end
    end
})
local Main = Tabs.Main:AddSection("Player")
local SuperSpeed = Tabs.Main:CreateToggle("SuperSpeed", {Title = "Supper Speed", Default = false})
SuperSpeed:OnChanged(function(state)
    local lp = game.Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if state then
            lp.Character.Humanoid.WalkSpeed = 100
        else
            lp.Character.Humanoid.WalkSpeed = 16
        end
    end
end)
Options.SuperSpeed:SetValue(false)
local SpeedFuck = Tabs.Main:CreateToggle("SpeedFuck", {Title = "Speed 10000", Default = false})
SpeedFuck:OnChanged(function(state)
    local lp = game.Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if state then
            lp.Character.Humanoid.WalkSpeed = 10000
        else
            lp.Character.Humanoid.WalkSpeed = 16
        end
    end
end)
Options.SpeedFuck:SetValue(false)

local SuperJump = Tabs.Main:CreateToggle("SuperJump", {Title = "Super Jump", Default = false})
SuperJump:OnChanged(function(state)
    local lp = game.Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if state then
            lp.Character.Humanoid.JumpPower = 150
        else
            lp.Character.Humanoid.JumpPower = 50
        end
    end
end)
Options.SuperJump:SetValue(false)
local Main = Tabs.Main:AddSection("Kill Aura")
local KillAura = Tabs.Main:CreateToggle("KillAura", {Title = "Kill Aura", Default = false})
local kaConnection

KillAura:OnChanged(function(state)
    if kaConnection then
        kaConnection:Disconnect()
        kaConnection = nil
    end

    if state then
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local DamageEvent = ReplicatedStorage:WaitForChild("attack")

        kaConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local root = char.HumanoidRootPart

            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                    if obj ~= char and not Players:GetPlayerFromCharacter(obj) then
                        local dist = (obj.HumanoidRootPart.Position - root.Position).Magnitude
                        if dist <= 150 then
                            DamageEvent:FireServer(obj, 50)
                        end
                    end
                end
            end
        end)
    end
end)

Options.KillAura:SetValue(false)
Tabs.Main:AddButton({
    Title = "Clear Mobs",
    Callback = function()
        local Players = game:GetService("Players")
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(obj) then
                    obj:Destroy()
                end
            end
        end
    end
})
local Main = Tabs.Main:AddSection("Esp")
local MobESP = Tabs.Main:CreateToggle("MobESP", {Title = "ESP Mob", Default = false })
local mobConnections = {}

MobESP:OnChanged(function(state)
    for _, c in pairs(mobConnections) do
        c:Disconnect()
    end
    mobConnections = {}

    if state then
        local function addESP(model)
            if not model:FindFirstChild("Head") or not model:FindFirstChild("Humanoid") then return end
            local head = model.Head
            if head:FindFirstChild("MobESP_Name") then return end

            local bb = Instance.new("BillboardGui")
            bb.Name = "MobESP_Name"
            bb.Size = UDim2.new(0, 140, 0, 35)
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.AlwaysOnTop = true
            bb.MaxDistance = 500
            bb.Parent = head

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
            frame.BackgroundTransparency = 0.3
            frame.BorderSizePixel = 0
            frame.Parent = bb

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame

            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, -4, 1, -4)
            text.Position = UDim2.new(0, 2, 0, 2)
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.fromRGB(255, 100, 100)
            text.TextStrokeTransparency = 0.2
            text.Font = Enum.Font.GothamBold
            text.TextScaled = true
            text.Parent = frame

            local run = game:GetService("RunService").RenderStepped:Connect(function()
                if model.Parent and model:FindFirstChild("HumanoidRootPart") then
                    local root = model.HumanoidRootPart
                    local localPlr = game.Players.LocalPlayer
                    if localPlr.Character and localPlr.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (root.Position - localPlr.Character.HumanoidRootPart.Position).Magnitude
                        text.Text = model.Name .. " (" .. math.floor(dist) .. "m)"
                    end
                end
            end)
            table.insert(mobConnections, run)
        end

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
                if not game.Players:GetPlayerFromCharacter(obj) then
                    addESP(obj)
                end
            end
        end

        table.insert(mobConnections, workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
                if not game.Players:GetPlayerFromCharacter(obj) then
                    addESP(obj)
                end
            end
        end))
    else
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Head") then
                local bb = obj.Head:FindFirstChild("MobESP_Name")
                if bb then bb:Destroy() end
            end
        end
    end
end)

Options.MobESP:SetValue(false)

local PlayerESP = Tabs.Main:CreateToggle("PlayerESP", {Title = "ESP Player", Default = false })
local connections = {}

PlayerESP:OnChanged(function(state)
    for _, c in pairs(connections) do
        c:Disconnect()
    end
    connections = {}

    if state then
        local function addESP(plr)
            local function setupChar(char)
                local head = char:WaitForChild("Head", 5)
                if not head then return end
                if head:FindFirstChild("PlayerESP_Name") then return end

                local bb = Instance.new("BillboardGui")
                bb.Name = "PlayerESP_Name"
                bb.Size = UDim2.new(0, 140, 0, 35)
                bb.StudsOffset = Vector3.new(0, 2, 0)
                bb.AlwaysOnTop = true
                bb.MaxDistance = 500
                bb.Parent = head

                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame.BackgroundTransparency = 0.3
                frame.BorderSizePixel = 0
                frame.Parent = bb

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = frame

                local text = Instance.new("TextLabel")
                text.Size = UDim2.new(1, -4, 1, -4)
                text.Position = UDim2.new(0, 2, 0, 2)
                text.BackgroundTransparency = 1
                text.TextColor3 = Color3.fromRGB(255, 255, 255)
                text.TextStrokeTransparency = 0.2
                text.Font = Enum.Font.GothamBold
                text.TextScaled = true
                text.Parent = frame

                local run = game:GetService("RunService").RenderStepped:Connect(function()
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local root = plr.Character.HumanoidRootPart
                        local localPlr = game.Players.LocalPlayer
                        if localPlr.Character and localPlr.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (root.Position - localPlr.Character.HumanoidRootPart.Position).Magnitude
                            text.Text = plr.Name .. " (" .. math.floor(dist) .. "m)"
                        end
                    end
                end)
                table.insert(connections, run)
            end

            if plr.Character then setupChar(plr.Character) end
            table.insert(connections, plr.CharacterAdded:Connect(setupChar))
        end

        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                addESP(plr)
            end
        end

        table.insert(connections, game.Players.PlayerAdded:Connect(function(plr)
            if plr ~= game.Players.LocalPlayer then
                addESP(plr)
            end
        end))
    else
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                local billboard = head:FindFirstChild("PlayerESP_Name")
                if billboard then billboard:Destroy() end
            end
        end
    end
end)

Options.PlayerESP:SetValue(false)

local Main = Tabs.Main:AddSection("Teleport")
local positions = {
    ["Starting"] = CFrame.new(-20.54305648803711, 4.689598560333252, -47.02955627441406),
    ["Military Base"] = CFrame.new(251.45944213867188, 4.509633541107178, 5475.53759765625)
}

local PostionSelect = Tabs.Main:CreateDropdown("PostionSelect", {
    Title = "Select Postion",
    Values = {"Starting", "Military Base"},
    Multi = false,
    Default = 1,
})

PostionSelect:SetValue("Starting")

Tabs.Main:AddButton({
    Title = "Teleport To Postion",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local target = positions[PostionSelect:GetValue()]
            if target then
                character.HumanoidRootPart.CFrame = target
            end
        end
    end
})
local Paragraph = Tabs.Main:CreateParagraph("Paragraph", {
    Title = "Use teleport below if above error",
    Content = ""
})
Tabs.Main:AddButton({
  Title = "Teleport To Car",
  Callback = function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local function findBasePartRecursive(model)
        if model:IsA("BasePart") then
            return model
        elseif model:IsA("Model") then
            if model.PrimaryPart then
                return model.PrimaryPart
            end
            for _, child in pairs(model:GetChildren()) do
                local part = findBasePartRecursive(child)
                if part then
                    return part
                end
            end
        end
        return nil
    end

    local function findTrain()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:lower():find("car_truck") then
                local basePart = findBasePartRecursive(v)
                if basePart then
                    return basePart
                end
            end
        end
        return nil
    end

    local function findNearestChair(position)
        local nearestSeat = nil
        local nearestDist = math.huge
        for _, seat in pairs(workspace:GetDescendants()) do
            if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
                local dist = (seat.Position - position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestSeat = seat
                end
            end
        end
        return nearestSeat
    end

    local targetPart = findTrain()
    if targetPart then
        character:MoveTo(targetPart.Position + Vector3.new(0, 5, 0))
        wait(0.5)
        local chair = findNearestChair(targetPart.Position)
        if chair then
            chair:Sit(character:FindFirstChildOfClass("Humanoid"))
        else
            warn("Không tìm thấy ghế gần Train.")
        end
    else
        warn("Không tìm thấy BasePart trong model chứa 'Train'.")
    end            
  end
})
Tabs.Main:AddButton({
    Title = "Teleport To Starting",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(-20.54305648803711, 4.689598560333252, -47.02955627441406)
        end
    end
})
Tabs.Main:AddButton({
    Title = "Teleport To Military Base",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(251.45944213867188, 4.509633541107178, 5475.53759765625)
        end
    end
})
local Paragraph = Tabs.Main:CreateParagraph("Tween", {
    Title = "Tween",
    Content = ""
})
local TweenService = game:GetService("TweenService")

Tabs.Main:AddButton({
    Title = "Tween To Military Base",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local targetCFrame = CFrame.new(251.45944213867188, 4.509633541107178, 5475.53759765625)
            local distance = (hrp.Position - targetCFrame.Position).Magnitude
            local time = distance / 500
            local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
        end
    end
})
--{ Lưu Conifg }--
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()