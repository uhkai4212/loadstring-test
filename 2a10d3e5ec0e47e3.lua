-- loadstring(game:HttpGet("https://raw.githubusercontent.com/TokkenDev/clock.lua-v2/refs/heads/main/133781619558477"))()

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TokkenDev/clock.lua-v2/refs/heads/main/XSX%20Library%20Fixed"))()
library:Watermark("clock.lua | SaKPDH | v2.0.0 | " .. library:GetUsername())
local Notifications = library:InitNotifications()
library.title = "clock.lua"
local Init = library:Init()
local StealTab = Init:NewTab("Steal")
local BaseTab = Init:NewTab("Base")
local CharTab = Init:NewTab("Character")
local MiscTab = Init:NewTab("Misc")
local UITab = Init:NewTab("UI")

-- Init --
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local bases = workspace.Map.Bases
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local Char = LPlayer.Character
local HRP = Char.HumanoidRootPart

LPlayer.CharacterAdded:Connect(function(char)
    Char = LPlayer.Character
    HRP = Char.HumanoidRootPart
end)

-- Variables --
local sellAfter = true
local lockBool = true
local lockThread = nil
local collectBool = true
local collectThread = nil
local trapsBool = true
local trapsThread = nil
local noClipRunning = nil
local anyStealRunning = false
local specificKPDH = "Rainbow Derpy Tiger"
local specificPlayer = nil

if not getgenv().desiredWalkSpeed then
    getgenv().desiredWalkSpeed = 30

    RunService.Heartbeat:Connect(function()
        pcall(function()
            if LPlayer.Character and LPlayer.Character.Humanoid then
                LPlayer.Character.Humanoid.WalkSpeed = getgenv().desiredWalkSpeed
            end
        end)
    end)
end

if not getgenv().lolxdteleportyes then
    getgenv().lolxdteleportyes = true

    LPlayer.OnTeleport:Connect(function()
        if queue_on_teleport then
            queue_on_teleport("task.wait(1.5) loadstring(game:HttpGet('https://raw.githubusercontent.com/TokkenDev/clock.lua-v2/refs/heads/main/133781619558477'))()")
        end
    end)
end

-- Functions --
local function getBase(playername)
    local result

    if Players:FindFirstChild(playername) then
        for _, base in ipairs(bases:GetChildren()) do
            local signtext = base.Important.Sign.SignPart.SurfaceGui.TextLabel.Text
            if string.find(signtext, playername, 1, true) then
                result = base.Name
                break
            end
        end
    end

    return result
end

local function getAllShits(basenumber)
    local shitstable = {}

    for _, chars in ipairs(workspace.Map.Bases[basenumber].Important.NPCPads:GetChildren()) do
        local charModel = chars:FindFirstChild("Character")
        if charModel and charModel:FindFirstChild("Head") then
            local attach = charModel.Head:FindFirstChild("OverHeadAttachment")
            if attach and attach:FindFirstChild("CharacterInfo") then
                local frame = attach.CharacterInfo:FindFirstChild("Frame")
                if frame and frame:FindFirstChild("UnitName") and frame:FindFirstChild("Price") then
                    table.insert(shitstable, {
                        object = chars,
                        name = frame.UnitName.Text,
                        price = frame.Price.Text
                    })
                end
            end
        end
    end

    return shitstable
end

local function stealFunction(shits, ownbase, stolecount)
    local shitcollect = shits.object.Collect
    local stealattempts = 0
    local maxstealattempts = 2

    task.spawn(function() 
        while stealattempts <= maxstealattempts do
            stealattempts = stealattempts + 1
            task.wait(1)
        end
    end)
    repeat
        HRP.CFrame = CFrame.new(shitcollect.Position + Vector3.new(0, 3, 0))
        task.wait()
        if shits.object:FindFirstChild("Character") and not shits.object.Part:FindFirstChild("ProximityPrompt") then
            fireproximityprompt(shits.object.Character.HumanoidRootPart:WaitForChild("SlotPrompt"))
        end
    until shits.object.Part:FindFirstChild("ProximityPrompt") or not shits.object:FindFirstChild("Character") or stealattempts >= maxstealattempts

    HRP.CFrame = bases[ownbase].Important.RobberyDeposit.CFrame
    stolecount = stolecount + 1
    return stolecount
end

local function stealSearchShit(shitsname)
    local ownbase = getBase(LPlayer.Name)
    local stolecount = 0

    for _, fplayers in pairs(Players:GetChildren()) do
        if fplayers ~= LPlayer then
            local currenttarget = getBase(fplayers.Name)
            if currenttarget then
                for _, shits in pairs(getAllShits(currenttarget)) do
                    if shits.name == shitsname then
                        stolecount = stealFunction(shits, ownbase, stolecount)
                        task.wait(0.1)
                    end
                end
            end
        end
    end

    return stolecount > 0, stolecount
end

local function stealAllShits(playername)
    local target = getBase(playername)
    local ownbase = getBase(LPlayer.Name)

    if target then
        for _, shits in getAllShits(target) do
            if Players:FindFirstChild(playername) then
                stealFunction(shits, ownbase, 0)
                task.wait(0.1)
            else
                continue
            end
        end
    end
end

local function sellAllPlayerShits()
    for _, shits in pairs(getAllShits(getBase(LPlayer.Name))) do
        local shitcollect = shits.object.Collect

        repeat
            task.wait()
            HRP.CFrame = CFrame.new(shitcollect.Position + Vector3.new(0, 3, 0))
            if shits.object:FindFirstChild("Character") and shits.object.Character.HumanoidRootPart:FindFirstChild("SlotPrompt") and not shits.object.Part:FindFirstChild("ProximityPrompt") then
                fireproximityprompt(shits.object.Character.HumanoidRootPart.SlotPrompt)
            end
        until not shits.object:FindFirstChild("Character") or shits.object.Part:FindFirstChild("ProximityPrompt")
    end
end

local function lockBase()
    while lockBool do task.wait()
        local playerbase = workspace.Map.Bases[getBase(LPlayer.Name)]
        local lockbutton = playerbase.Important.LockButton
        if lockbutton.BillboardAttachment.LockGui.ActionLabel.Visible then
            firetouchinterest(lockbutton,HRP,0)
            task.wait(0.05)
            firetouchinterest(lockbutton,HRP,1)
        end
    end
end

local function stealAll()
    for _, players in pairs(Players:GetChildren()) do
        if players.Name ~= LPlayer.Name then
            stealAllShits(players.Name)
            if sellAfter then
                sellAllPlayerShits()
            end
        end
    end
end

local function DisableTraps()
    while trapsBool do
        for _, traps in workspace:GetChildren() do task.wait()
            if traps.Name == "Trap" then
                traps.HitBox.TouchInterest:Destroy()
                traps.Name = "TrapL"
            end
        end
    end
end

local function autoCollectCash()
    while collectBool do
        for _, npcpad in pairs(workspace.Map.Bases[getBase(LPlayer.Name)].Important.NPCPads:GetChildren()) do task.wait()
            firetouchinterest(npcpad.Collect,HRP,0)
            task.wait(0.05)
            firetouchinterest(npcpad.Collect,HRP,1)
        end
    end
end

local function addSpacesToName(name)
    if not name or name == "" then
        return name
    end
    local result = ""
    for i = 1, #name do
        local char = name:sub(i, i)
        if i > 1 and char:match("%u") then
            result = result .. " "
        end
        result = result .. char
    end
    return result
end

local function getKPDH()
    local kpdhtable = {}

    for _, kpdh in pairs(ReplicatedStorage.Assets.Characters:GetChildren()) do
        table.insert(kpdhtable, addSpacesToName(kpdh.Name))
    end

    table.sort(kpdhtable)
    return kpdhtable
end

-- Tab Elements --

-- StealTab --
StealTab:NewButton("Steal all KPDH", function()
    if not anyStealRunning then
        anyStealRunning = true
        stealAll()
        anyStealRunning = false
    else
        Notifications:Notify("Wait until the previous steal is finished.", 3, "information")
    end
end)

StealTab:NewToggle("Sell after stealing all", true, function(bool)
    sellAfter = bool
    Notifications:Notify("Selling after stealing all is now "..(bool and "enabled" or "disabled"), 3, (bool and "success" or "error"))
end)

StealTab:NewSelector("Select KPDH", "Rainbow Derpy Tiger", getKPDH(), function(Value)
    specificKPDH = Value
end)

StealTab:NewButton("Steal specific KPDH ^", function()
    if not anyStealRunning then
        anyStealRunning = true
        local feedback, stolecount = stealSearchShit(specificKPDH)
        if feedback then
            Notifications:Notify("Stolen "..stolecount.." of "..specificKPDH, 3, "success")
        else
            Notifications:Notify("No "..specificKPDH.." found.", 3, "error")
        end
        anyStealRunning = false
    else
        Notifications:Notify("Wait until the previous steal is finished.", 3, "information")
    end
end)

local PlayerSelector = StealTab:NewSelector("Select player", nil, {}, function(Value)
    specificPlayer = Value
end)

StealTab:NewButton("Steal from player ^", function()
    if not anyStealRunning then
        anyStealRunning = true
        if specificPlayer then
            stealAllShits(specificPlayer)
        end
        anyStealRunning = false
    else
        Notifications:Notify("Wait until the previous steal is finished.", 3, "information")
    end
end)

StealTab:NewButton("Refresh player selector ^^", function()
    local currentPlayers = Players:GetChildren()
    local currentSelectorPlayers = PlayerSelector:GetOptions()
    local currentPlayersAmount = 0
    local currentSelectorPlayersAmount = 0

    for _, selPlayer in currentSelectorPlayers do
        PlayerSelector:RemoveOption(selPlayer)
    end

    for _, curPlayer in currentPlayers do
        PlayerSelector:AddOption(tostring(curPlayer))
    end
end)

-- BaseTab --

BaseTab:NewButton("Sell all KPDH", function()
    sellAllPlayerShits()
end)

BaseTab:NewToggle("Auto lock base", true, function(bool)
    lockBool = bool
    Notifications:Notify("Auto locking is now "..(bool and "enabled." or "disabled."), 3, (bool and "success" or "error"))
    if lockBool then
        lockThread = task.spawn(lockBase)
    else
        if lockThread then
            task.cancel(lockThread)
            lockThread = nil
        end
    end
end)

BaseTab:NewToggle("Auto collect cash", true, function(bool)
    collectBool = bool
    Notifications:Notify("Auto collect cash is now "..(bool and "enabled." or "disabled."), 3, (bool and "success" or "error"))
    if collectBool then
        collectThread = task.spawn(autoCollectCash)
    else
        if collectThread then
            task.cancel(collectThread)
            collectThread = nil
        end
    end
end)

BaseTab:NewToggle("Auto disable traps", true, function(bool)
    trapsBool = bool
    Notifications:Notify("Auto disable traps is now "..(bool and "enabled." or "disabled."), 3, (bool and "success" or "error"))
    if trapsBool then
        trapsThread = task.spawn(DisableTraps)
    else
        if trapsThread then
            task.cancel(trapsThread)
            trapsThread = nil
        end
    end
end)

-- CharTab --
CharTab:NewSlider("WalkSpeed", "", true, "/", {min = 16, max = 200, default = 30}, function(value)
    getgenv().desiredWalkSpeed = value
end)

CharTab:NewToggle("No clip", false, function(bool)
    Notifications:Notify("No clip "..(bool and "enabled." or "disabled."), 3, (bool and "success" or "error"))
    if bool then
        local function NoclipLoop()
            if LPlayer.Character ~= nil then
                for _, child in pairs(LPlayer.Character:GetDescendants()) do
                    if child:IsA("BasePart") and child.CanCollide == true then
                        child.CanCollide = false
                    end
                end
            end
        end
        noClipRunning = RunService.Stepped:Connect(NoclipLoop)
    else
        if noClipRunning then
            noClipRunning:Disconnect()
        end
    end
end)

-- MiscTab --
MiscTab:NewLabel("Made with <3 by tokkendev", "center")


MiscTab:NewToggle("Instant proximity prompt", true, function(bool)
    Notifications:Notify((bool and "Enabled" or "Disabled").." instant proximity prompt.", 3, (bool and "success" or "error"))
    if bool then
        if fireproximityprompt then
            PromptButtonHoldBegan = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                fireproximityprompt(prompt)
            end)
        else
            Notifications:Notify("Your exploit is incompatible with fireproximityprompt.", 3, "error")
        end
    else
        if PromptButtonHoldBegan then
            PromptButtonHoldBegan:Disconnect()
            PromptButtonHoldBegan = nil
        end
    end
end)

MiscTab:NewButton("Remove fog", function()
	Lighting.FogEnd = 10000
	for i,v in pairs(Lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			v:Destroy()
		end
	end
end)

MiscTab:NewButton("Server hop", function()
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
    local body = HttpService:JSONDecode(req)

    if body and body.data then
        for i, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, 1, v.id)
            end
        end
    end

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
    end
end)

MiscTab:NewToggle("Disable notifications and SFX", true, function(bool)
    Notifications:Notify((bool and "Disabled" or "Enabled").." notifications and SFX.", 3, (bool and "success" or "error"))
    LPlayer.PlayerGui.MainHud.Notifications.Visible = not bool
    LPlayer.PlayerScripts.SFX.Enabled = not bool
end)

-- UITab --
UITab:NewButton("Destroy UI", function()
    library:Remove()
end)

UITab:NewLabel("working on modifying the library for more ui functions", "center")