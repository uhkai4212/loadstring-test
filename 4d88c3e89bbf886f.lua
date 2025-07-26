setclipboard("https://discord.gg/WA2XTGMM")
spawn(function()
    if syn and syn.request then
        syn.request({Url = "http://www.roblox.com/games/place?id=" .. game.PlaceId .. "&linkId=" .. HttpService:GenerateGUID(false), Method = "GET"})
    else
        game:HttpGet("https://discord.gg/WA2XTGMM")
    end
end)
OrionLib:MakeNotification({
    Name = "Discord Link",
    Content = "Discord link copied to clipboard and opened!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

local Window = OrionLib:MakeWindow({
    Name = "Steal A BloxFruit",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    IntroText = "Loading Script..."
})

OrionLib:MakeNotification({
    Name = "Logged In!",
    Content = "Enjoy " .. Player.Name .. "!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Visuals Tab Enhancements
local playerHighlights = {}
local playerNameGuis = {}
local espEnabled = false
local nameEnabled = false
local baseLockEnabled = false
local autoLockEnabled = false
local baseLockGui = nil

local function addHighlight(player)
    if player ~= Player and player.Character then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.new(0, 0, 1) -- Blue
        highlight.OutlineColor = Color3.new(0, 0, 1)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
        playerHighlights[player] = highlight
    end
end

local function removeHighlight(player)
    if playerHighlights[player] then
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end
end

local function addNameGui(player)
    if player ~= Player and player.Character then
        local head = player.Character:WaitForChild("Head")
        local billboard = Instance.new("BillboardGui")
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Adornee = head
        local textLabel = Instance.new("TextLabel", billboard)
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextScaled = true
        billboard.Parent = head
        playerNameGuis[player] = billboard
    end
end

local function removeNameGui(player)
    if playerNameGuis[player] then
        playerNameGuis[player]:Destroy()
        playerNameGuis[player] = nil
    end
end

local function findBaseTextLabel()
    local playerName = Player.Name
    local targetText = playerName .. "'s Studio"
    
    local function searchForTextLabel(parent)
        for _, descendant in pairs(parent:GetDescendants()) do
            if descendant:IsA("TextLabel") and descendant.Text == targetText then
                return descendant
            end
        end
        return nil
    end
    
    local textLabel = searchForTextLabel(Workspace)
    return textLabel
end

local function updateBaseLockVisual()
    if baseLockEnabled and baseLockGui then
        local textLabel = findBaseTextLabel()
        if textLabel then
            local lockPurchase = textLabel.Parent.Parent.Parent:FindFirstChild("LockPurchase")
            if lockPurchase then
                local hitbox = lockPurchase:FindFirstChild("Hitbox")
                if hitbox and hitbox:FindFirstChild("BillboardGui") then
                    local remainingTimeText = hitbox.BillboardGui:FindFirstChild("TimeLeft")
                    if remainingTimeText and remainingTimeText:IsA("TextLabel") then
                        baseLockGui.TextLabel.Text = "Studio Unlocks In: " .. remainingTimeText.Text
                    else
                        baseLockGui.TextLabel.Text = "Studio Unlocks In: No Remaining Time"
                    end
                else
                    baseLockGui.TextLabel.Text = "Studio Unlocks In: No BillboardGui"
                end
            else
                baseLockGui.TextLabel.Text = "Studio Unlocks In: No LockPurchase"
            end
        else
            baseLockGui.TextLabel.Text = "Studio Unlocks In: No Studio Found"
        end
    end
end