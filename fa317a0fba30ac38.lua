local Players = game:GetService('Players')
local StarterGui = game:GetService('StarterGui')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local RunService = game:GetService('RunService')
local lp = Players.LocalPlayer
local UIS = game:GetService('UserInputService')

--==================================================
-- Notifications
--==================================================
local function Notify(text, duration)
    pcall(function()
        StarterGui:SetCore('SendNotification', {
            Title = 'Gun Armory Tycoon by ntjustin on discord',
            Text = tostring(text or ''),
            Duration = duration or 4,
        })
    end)
end

--==================================================
-- UI Loader (Rain-Design) + Fallback
--==================================================
local function tryLoadLibrary()
    local ok, lib = pcall(function()
        return loadstring(
            game:HttpGet(
                'https://raw.githubusercontent.com/Rain-Design/Unnamed/main/Library.lua'
            )
        )()
    end)
    if not ok or type(lib) ~= 'table' or type(lib.Window) ~= 'function' then
        return nil
    end
    return lib
end

local function buildFallbackUI()
    local sg = Instance.new('ScreenGui')
    sg.Name = 'UnFairHub_Fallback'
    sg.ResetOnSpawn = false
    sg.Parent = lp:WaitForChild('PlayerGui')

    local frame = Instance.new('Frame')
    frame.Size = UDim2.fromOffset(360, 520)
    frame.Position = UDim2.new(0, 20, 0.5, -260)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Parent = sg
    Instance.new('UICorner', frame).CornerRadius = UDim.new(0, 10)

    local title = Instance.new('TextLabel')
    title.Size = UDim2.new(1, -10, 0, 28)
    title.Position = UDim2.new(0, 10, 0, 8)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = 'Gun Armory Tycoon by ntjustin on discord (Fallback)'
    title.Parent = frame

    local content = Instance.new('Frame')
    content.Size = UDim2.new(1, -20, 1, -50)
    content.Position = UDim2.new(0, 10, 0, 42)
    content.BackgroundTransparency = 1
    content.Parent = frame

    local list = Instance.new('UIListLayout')
    list.Padding = UDim.new(0, 8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Left
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = content

    local function makeToggle(labelText, callback)
        local btn = Instance.new('TextButton')
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Text = labelText .. ': OFF'
        btn.Parent = content
        Instance.new('UICorner', btn).CornerRadius = UDim.new(0, 6)
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = labelText .. ': ' .. (state and 'ON' or 'OFF')
            callback(state)
        end)
    end

    local function makeButton(labelText, callback)
        local btn = Instance.new('TextButton')
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Text = labelText
        btn.Parent = content
        Instance.new('UICorner', btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            callback()
        end)
    end

    return {
        AddToggle = makeToggle,
        AddButton = makeButton,
        Notify = Notify,
        Destroy = function()
            sg:Destroy()
        end,
    }
end

--==================================================
-- Tycoon Helpers
--==================================================
local function tycoonsFolder()
    local t = workspace:FindFirstChild('Tycoons')
    if not t then
        return nil
    end
    return t:FindFirstChild('Tycoons') or t
end

local function ownerMatchesLocal(ownerVal)
    if not ownerVal then
        return false
    end
    if typeof(ownerVal) == 'Instance' then
        return ownerVal:IsA('Player') and ownerVal.Name == lp.Name
    elseif typeof(ownerVal) == 'string' then
        return ownerVal == lp.Name
    end
    return false
end

local function modelIsMyTycoon(m)
    if not m or not m:IsA('Model') then
        return false
    end
    local owner = m:FindFirstChild('Owner')
        or m:FindFirstChild('owner')
        or m:FindFirstChild('OWNER')
    if owner then
        if
            owner:IsA('ObjectValue')
            and owner.Value
            and owner.Value:IsA('Player')
        then
            if owner.Value.Name == lp.Name then
                return true
            end
        elseif owner:IsA('StringValue') then
            if owner.Value == lp.Name then
                return true
            end
        end
    end
    for _, d in ipairs(m:GetDescendants()) do
        if d.Name:lower() == 'owner' then
            if
                d:IsA('ObjectValue')
                and d.Value
                and d.Value:IsA('Player')
                and d.Value.Name == lp.Name
            then
                return true
            elseif d:IsA('StringValue') and d.Value == lp.Name then
                return true
            end
        end
    end
    return false
end

local lastTycoonName
local function getMyTycoon()
    local root = tycoonsFolder()
    if not root then
        return nil
    end
    if lastTycoonName then
        local t = root:FindFirstChild(lastTycoonName)
        if modelIsMyTycoon(t) then
            return t
        end
    end
    for _, m in ipairs(root:GetChildren()) do
        if modelIsMyTycoon(m) then
            lastTycoonName = m.Name
            return m
        end
    end
    return nil
end

--==================================================
-- Part Storage / Collector / Upgraders
--==================================================
local function getNil(name, class)
    local result
    pcall(function()
        for _, v in next, getnilinstances() do
            if v.ClassName == class and v.Name == name then
                result = v
                break
            end
        end
    end)
    return result
end

local function getPartContainers(myTycoon)
    local containers = {}
    if not myTycoon then
        return containers
    end
    local ps = myTycoon:FindFirstChild('PartStorage')
    if ps then
        table.insert(containers, ps)
    end
    for _, d in ipairs(myTycoon:GetDescendants()) do
        if d:IsA('Folder') or d:IsA('Model') then
            local n = d.Name:lower()
            if
                n:find('partstorage')
                or n:find('parts')
                or n:find('ore')
                or n:find('blocks')
                or n:find('drop')
            then
                table.insert(containers, d)
            end
        end
    end
    return containers
end

local function partBelongsToMe(part, myTycoon)
    if not (part and part:IsA('BasePart')) then
        return false
    end
    if myTycoon and part:IsDescendantOf(myTycoon) then
        return true
    end
    if part.GetAttribute then
        local nm = part:GetAttribute('Owner')
        if ownerMatchesLocal(nm) then
            return true
        end
        local tyName = part:GetAttribute('TycoonName')
        if tyName and myTycoon and tyName == myTycoon.Name then
            return true
        end
    end
    local own = part:FindFirstChild('Owner')
    if own then
        if own:IsA('StringValue') and own.Value == lp.Name then
            return true
        end
        if
            own:IsA('ObjectValue')
            and own.Value
            and own.Value:IsA('Player')
            and own.Value.Name == lp.Name
        then
            return true
        end
    end
    return false
end

local function getUpgraders(myTycoon)
    local list = {}
    local purchased = myTycoon and myTycoon:FindFirstChild('PurchasedObjects')
    if not purchased then
        return list
    end
    for i = 1, 8 do
        local holder = purchased:FindFirstChild('Upgrader' .. i)
        if holder then
            local up = holder:FindFirstChild('Upgrader')
                or holder:FindFirstChildWhichIsA('BasePart', true)
            if up and up:IsA('BasePart') then
                table.insert(list, up)
            end
        end
    end
    for _, d in ipairs(purchased:GetDescendants()) do
        if d:IsA('BasePart') and d.Name:lower() == 'upgrader' then
            table.insert(list, d)
        end
    end
    return list
end

-- Uses explicit path: workspace.Tycoons.Tycoons.<Local Tycoon Name>.Essentials:GetChildren()[5]
local function getCollectorPart(myTycoon)
    if not myTycoon then
        return nil
    end

    -- Resolve explicit path pieces safely
    local tycoonsRoot = workspace:FindFirstChild('Tycoons')
    if not tycoonsRoot then
        return nil
    end
    local innerTycoons = tycoonsRoot:FindFirstChild('Tycoons') or tycoonsRoot
    local tycoonModel = innerTycoons:FindFirstChild(myTycoon.Name)
    if not tycoonModel then
        return nil
    end

    local essentials = tycoonModel:FindFirstChild('Essentials')
    if not essentials then
        return nil
    end

    -- Primary: strictly take the 5th child if it's a BasePart with touch
    local ok, fifth = pcall(function()
        return essentials:GetChildren()[5]
    end)
    if ok and fifth and fifth:IsA('BasePart') then
        if
            fifth:FindFirstChild('TouchInterest')
            or fifth:FindFirstChildOfClass('TouchTransmitter')
        then
            return fifth
        end
    end

    -- Fallbacks if the strict index doesn't have a touchable BasePart:
    for _, d in ipairs(essentials:GetDescendants()) do
        if d:IsA('TouchTransmitter') or d.Name == 'TouchInterest' then
            local p = d.Parent
            if p and p:IsA('BasePart') then
                return p
            end
        end
    end
    local pc = essentials:FindFirstChild('PartCollector')
    if pc and pc:IsA('BasePart') then
        return pc
    end
    return nil
end

--==================================================
-- Rockey Ridge
--==================================================
local function getRockeyRidgeModel()
    return workspace:FindFirstChild('Rockey Ridge')
end
local function getRockeyZone()
    local rr = getRockeyRidgeModel()
    if not rr then
        return nil
    end
    local z = rr:FindFirstChild('Zone')
    if z and z:IsA('BasePart') then
        return z
    end
    for _, d in ipairs(rr:GetDescendants()) do
        if d:IsA('BasePart') and d.Name:lower() == 'zone' then
            return d
        end
    end
    return nil
end
local function getRockeyBase()
    local rr = getRockeyRidgeModel()
    if not rr then
        return nil
    end
    local base = rr:FindFirstChild('Base')
    if base and base:IsA('BasePart') then
        return base
    end
    for _, d in ipairs(rr:GetDescendants()) do
        if d:IsA('BasePart') and d.Name == 'Base' then
            return d
        end
    end
    return getRockeyZone() or nil
end
local function isInsideZone(part, worldPos)
    if not (part and part:IsA('BasePart')) then
        return false
    end
    local localPos = part.CFrame:PointToObjectSpace(worldPos)
    local a, b, c = part.Size.X * 0.5, part.Size.Y * 0.5, part.Size.Z * 0.5
    if a <= 0 or b <= 0 or c <= 0 then
        return false
    end
    local nx, ny, nz = localPos.X / a, localPos.Y / b, localPos.Z / c
    return (nx * nx + ny * ny + nz * nz) <= 1.0005
end
local function tpToBase()
    local target = getRockeyBase()
    if not target then
        return Notify('Rockey Ridge: Base/Zone not found.', 4)
    end
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char and char:FindFirstChild('HumanoidRootPart')
    if not hrp then
        return Notify('No HumanoidRootPart.', 3)
    end
    pcall(function()
        local height = (target.Size and target.Size.Y or 12)
        hrp.CFrame = target.CFrame + Vector3.new(0, height * 0.5 + 6, 0)
        RunService.Heartbeat:Wait()
        firetouchinterest(hrp, target, 0)
        firetouchinterest(hrp, target, 1)
    end)
    Notify('Teleported to Rockey Ridge.', 3)
end
local function checkPlayersInZone()
    local zone = getRockeyZone()
    if not zone then
        return Notify("Zone not found inside workspace['Rockey Ridge'].", 4)
    end
    local inside = {}
    for _, p in ipairs(Players:GetPlayers()) do
        local hrp = p.Character
            and p.Character:FindFirstChild('HumanoidRootPart')
        if hrp and isInsideZone(zone, hrp.Position) then
            table.insert(inside, p.Name)
        end
    end
    if #inside == 0 then
        Notify('No players inside the Rockey Ridge zone.', 4)
    else
        local msg = 'In zone: ' .. table.concat(inside, ', ')
        Notify(msg, math.min(10, 3 + #inside))
        print(msg)
    end
end

--==================================================
-- TP to My Tycoon
--==================================================
local function getTycoonTeleportCFrame(tycoon)
    if not tycoon then
        return nil
    end
    local essentials = tycoon:FindFirstChild('Essentials')
    if essentials then
        local prefer = essentials:FindFirstChild('Giver')
            or essentials:FindFirstChild('PartCollector')
        if prefer then
            local p = prefer:IsA('BasePart') and prefer
                or prefer:FindFirstChildWhichIsA('BasePart', true)
            if p then
                return p.CFrame
            end
        end
    end
    local purchased = tycoon:FindFirstChild('PurchasedObjects')
    if purchased then
        local any = purchased:FindFirstChild('Dropper0')
            or purchased:FindFirstChildWhichIsA('BasePart', true)
        if any then
            local p = any:IsA('BasePart') and any
                or any:FindFirstChildWhichIsA('BasePart', true)
            if p then
                return p.CFrame
            end
        end
    end
    local cf = select(1, tycoon:GetBoundingBox())
    return cf
end
local function tpToMyTycoon()
    local myTycoon = getMyTycoon()
    if not myTycoon then
        return Notify('Your tycoon was not found.', 4)
    end
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char and char:FindFirstChild('HumanoidRootPart')
    if not hrp then
        return Notify('No HumanoidRootPart.', 3)
    end
    local tcf = getTycoonTeleportCFrame(myTycoon)
    if not tcf then
        return Notify("Couldn't locate a safe spot in your tycoon.", 4)
    end
    pcall(function()
        hrp.CFrame = tcf + Vector3.new(0, 5, 0)
    end)
    Notify('Teleported to your tycoon.', 3)
end

--==================================================
-- Armor Helpers
--==================================================
local function getAccessoryEquipPart(myTycoon, armorFolderName)
    if not myTycoon then
        return nil
    end
    local po = myTycoon:FindFirstChild('PurchasedObjects')
    if not po then
        return nil
    end
    local armorFolder = po:FindFirstChild(armorFolderName)
    if not armorFolder then
        return nil
    end
    local model = armorFolder:FindFirstChild('Model')
        or armorFolder:FindFirstChildWhichIsA('Model')
    if not model then
        return nil
    end
    local equip = model:FindFirstChild('Accessory Equip')
    if equip and equip:IsA('BasePart') then
        return equip
    end
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA('BasePart') and d.Name == 'Accessory Equip' then
            return d
        end
    end
    return nil
end
local function pulseTouchHRP(targetPart, pulses, gap)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char and char:FindFirstChild('HumanoidRootPart')
    if not (hrp and targetPart) then
        return false
    end
    pulses = pulses or 12
    gap = gap or 0.02
    for _ = 1, pulses do
        pcall(function()
            firetouchinterest(hrp, targetPart, 0)
            firetouchinterest(hrp, targetPart, 1)
        end)
        task.wait(gap)
    end
    return true
end
local function equipArmor(armorFolderName, prettyName)
    local myTycoon = getMyTycoon()
    if not myTycoon then
        return Notify('Could not find your tycoon.', 4)
    end
    local pad = getAccessoryEquipPart(myTycoon, armorFolderName)
    if not pad then
        return Notify(prettyName .. ' equip pad not found (buy it first).', 4)
    end
    if pulseTouchHRP(pad, 12, 0.02) then
        Notify('Tried to equip ' .. prettyName .. '.', 3)
    end
end
local function equipLightArmor()
    equipArmor('LightArmor', 'Light Armor')
end
local function equipStandardArmor()
    equipArmor('StandardArmor', 'Standard Armor')
end

--==================================================
-- Desired states
--==================================================
local wantClick, wantPut, wantPutUp, wantCollect, wantBuy =
    false, false, false, false, false

--==================================================
-- Auto Click Dropper
--==================================================
local autoClick, clickThread = false, nil
local function setAutoClick(state)
    wantClick = state
    autoClick = state
    if autoClick then
        local myTycoon = getMyTycoon()
        if not myTycoon then
            return Notify('No tycoon', 3)
        end
        local clicker = myTycoon
            :WaitForChild('PurchasedObjects')
            :WaitForChild('Dropper0')
            :WaitForChild('Clicker')
            :WaitForChild('ClickDetector')
        clickThread = task.spawn(function()
            while autoClick and task.wait(0.1) do
                pcall(function()
                    fireclickdetector(clicker)
                end)
            end
        end)
        Notify('Auto Click Dropper: ON', 3)
    else
        if clickThread then
            task.cancel(clickThread)
            clickThread = nil
        end
        Notify('Auto Click Dropper: OFF', 3)
    end
end

--==================================================
-- Auto Put Parts
--==================================================
local autoPut, putThread = false, nil
local function setAutoPut(state)
    wantPut = state
    autoPut = state
    if autoPut then
        local myTycoon = getMyTycoon()
        if not myTycoon then
            return Notify('No tycoon', 3)
        end
        local collectorPart = getCollectorPart(myTycoon)
        if not collectorPart then
            return Notify('Collector Touch not found in Essentials.', 4)
        end
        local containers = getPartContainers(myTycoon)
        putThread = task.spawn(function()
            while autoPut do
                for _, cont in ipairs(containers) do
                    if not autoPut then
                        break
                    end
                    local children
                    pcall(function()
                        children = cont:GetChildren()
                    end)
                    if children then
                        for _, part in ipairs(children) do
                            if not autoPut then
                                break
                            end
                            if
                                part:IsA('BasePart')
                                and partBelongsToMe(part, myTycoon)
                            then
                                pcall(function()
                                    firetouchinterest(part, collectorPart, 0)
                                    firetouchinterest(part, collectorPart, 1)
                                end)
                                RunService.Heartbeat:Wait()
                            end
                        end
                    end
                end
                local ghost = getNil('Part', 'Part')
                if
                    ghost
                    and ghost:IsA('BasePart')
                    and partBelongsToMe(ghost, myTycoon)
                then
                    pcall(function()
                        firetouchinterest(ghost, collectorPart, 0)
                        firetouchinterest(ghost, collectorPart, 1)
                    end)
                end
                task.wait(0.05)
            end
        end)
        Notify('Auto Put Parts: ON', 3)
    else
        if putThread then
            task.cancel(putThread)
            putThread = nil
        end
        Notify('Auto Put Parts: OFF', 3)
    end
end

--==================================================
-- Auto Put Parts+ (Upgraders -> Collector)
--==================================================
local autoPutUp, putUpThread = false, nil
local function setAutoPutUp(state)
    wantPutUp = state
    autoPutUp = state
    if autoPutUp then
        local myTycoon = getMyTycoon()
        if not myTycoon then
            return Notify('No tycoon', 3)
        end
        local collectorPart = getCollectorPart(myTycoon)
        if not collectorPart then
            return Notify('Collector Touch not found in Essentials.', 4)
        end
        local containers = getPartContainers(myTycoon)
        Notify('Routing your parts through upgraders, then collector.', 4)
        putUpThread = task.spawn(function()
            local cachedUps, lastRefresh = {}, 0
            local function refresh()
                local now = os.clock()
                if now - lastRefresh > 0.5 or #cachedUps == 0 then
                    cachedUps = getUpgraders(myTycoon)
                    lastRefresh = now
                end
            end
            while autoPutUp do
                refresh()
                for _, cont in ipairs(containers) do
                    if not autoPutUp then
                        break
                    end
                    local children
                    pcall(function()
                        children = cont:GetChildren()
                    end)
                    if children then
                        for _, part in ipairs(children) do
                            if not autoPutUp then
                                break
                            end
                            if
                                part:IsA('BasePart')
                                and partBelongsToMe(part, myTycoon)
                            then
                                for _, up in ipairs(cachedUps) do
                                    pcall(function()
                                        firetouchinterest(part, up, 0)
                                        firetouchinterest(part, up, 1)
                                    end)
                                    RunService.Heartbeat:Wait()
                                end
                                pcall(function()
                                    firetouchinterest(part, collectorPart, 0)
                                    firetouchinterest(part, collectorPart, 1)
                                end)
                            end
                        end
                    end
                end
                local ghost = getNil('Part', 'Part')
                if
                    ghost
                    and ghost:IsA('BasePart')
                    and partBelongsToMe(ghost, myTycoon)
                then
                    for _, up in ipairs(cachedUps) do
                        pcall(function()
                            firetouchinterest(ghost, up, 0)
                            firetouchinterest(ghost, up, 1)
                        end)
                        RunService.Heartbeat:Wait()
                    end
                    pcall(function()
                        firetouchinterest(ghost, collectorPart, 0)
                        firetouchinterest(ghost, collectorPart, 1)
                    end)
                end
                task.wait(0.05)
            end
        end)
    else
        if putUpThread then
            task.cancel(putUpThread)
            putUpThread = nil
        end
        Notify('Auto Put Parts+: OFF', 3)
    end
end

--==================================================
-- Auto Collect Cash
--==================================================
local autoCollect, collectThread = false, nil
local function setAutoCollect(state)
    wantCollect = state
    autoCollect = state
    if autoCollect then
        local myTycoon = getMyTycoon()
        if not myTycoon then
            return Notify('No tycoon', 3)
        end
        local giver = myTycoon:WaitForChild('Essentials'):WaitForChild('Giver')
        collectThread = task.spawn(function()
            while autoCollect and task.wait(1) do
                pcall(function()
                    local hrp = lp.Character
                        and lp.Character:FindFirstChild('HumanoidRootPart')
                    local touch = giver:FindFirstChildOfClass(
                        'TouchTransmitter'
                    ) or giver:FindFirstChild(
                        'TouchInterest'
                    )
                    if hrp and (touch or giver:IsA('BasePart')) then
                        firetouchinterest(hrp, giver, 0)
                        firetouchinterest(hrp, giver, 1)
                    end
                end)
            end
        end)
        Notify('Auto Collect Cash: ON', 3)
    else
        if collectThread then
            task.cancel(collectThread)
            collectThread = nil
        end
        Notify('Auto Collect Cash: OFF', 3)
    end
end

--==================================================
-- Auto Buy
--==================================================
local function isGamepassButton(btn)
    local n = string.lower(btn.Name or '')
    if
        (n:find('2x') and n:find('cash')) or (n:find('3x') and n:find('cash'))
    then
        return true
    end
    if n:find('gamepass') or n:find('vip') then
        return true
    end
    if n:find('inf') and n:find('cash') then
        return true
    end
    if
        btn:FindFirstChild('Gamepass')
        or btn:FindFirstChild('Pass')
        or btn:FindFirstChild('PassId')
        or btn:FindFirstChild('GamepassID')
        or btn:FindFirstChild('DevProduct')
    then
        return true
    end
    if
        btn.GetAttribute
        and (btn:GetAttribute('Gamepass') or btn:GetAttribute('DevProduct'))
    then
        return true
    end
    return false
end
local function getButtonPart(obj)
    if obj:IsA('BasePart') then
        return obj
    end
    if obj.PrimaryPart then
        return obj.PrimaryPart
    end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA('BasePart') then
            return d
        end
    end
end
local autoBuy, buyThread = false, nil
local function tryBuyButton(hrp, btn)
    local part = getButtonPart(btn)
    if not part then
        return
    end
    local touched = false
    local function touch(p)
        pcall(function()
            firetouchinterest(hrp, p, 0)
            firetouchinterest(hrp, p, 1)
            touched = true
        end)
    end
    local ti = part:FindFirstChildOfClass('TouchTransmitter')
    if ti then
        touch(part)
    end
    if not touched then
        for _, d in ipairs(part:GetDescendants()) do
            if d:IsA('TouchTransmitter') then
                touch(d.Parent)
                break
            end
        end
    end
    if not touched then
        for _, d in ipairs(part:GetDescendants()) do
            if d:IsA('ProximityPrompt') then
                pcall(function()
                    fireproximityprompt(d)
                end)
                touched = true
            end
        end
    end
    if not touched then
        local old = hrp.CFrame
        pcall(function()
            hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
            RunService.Heartbeat:Wait()
            firetouchinterest(hrp, part, 0)
            firetouchinterest(hrp, part, 1)
            RunService.Heartbeat:Wait()
            hrp.CFrame = old
        end)
    end
end
local function setAutoBuy(state)
    wantBuy = state
    autoBuy = state
    if autoBuy then
        local myTycoon = getMyTycoon()
        if not myTycoon then
            return Notify('No tycoon', 3)
        end
        local buttons = myTycoon:WaitForChild('Buttons')
        buyThread = task.spawn(function()
            while autoBuy and task.wait(0.3) do
                local hrp = lp.Character
                    and lp.Character:FindFirstChild('HumanoidRootPart')
                if not hrp then
                    lp.CharacterAdded:Wait()
                    task.wait(0.2)
                    hrp = lp.Character
                        and lp.Character:FindFirstChild('HumanoidRootPart')
                end
                if not hrp then
                    break
                end
                for _, btn in ipairs(buttons:GetChildren()) do
                    if not autoBuy then
                        break
                    end
                    if not isGamepassButton(btn) then
                        pcall(function()
                            tryBuyButton(hrp, btn)
                        end)
                        task.wait(0.08)
                    end
                end
            end
        end)
        Notify('Auto Buy: ON', 3)
    else
        if buyThread then
            task.cancel(buyThread)
            buyThread = nil
        end
        Notify('Auto Buy: OFF', 3)
    end
end

--==================================================
-- Insta-press Interactables
--==================================================
local function pressNearbyInteractables(radius)
    radius = radius or 40
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char and char:FindFirstChild('HumanoidRootPart')
    if not hrp then
        return Notify('No HumanoidRootPart.', 3)
    end
    local count = 0
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA('ProximityPrompt') and d.Enabled then
            local p = d.Parent
            local base = (p and p:IsA('BasePart')) and p
                or (p and p:FindFirstChildWhichIsA('BasePart', true))
            if base then
                local dist = (base.Position - hrp.Position).Magnitude
                if dist <= radius then
                    pcall(function()
                        fireproximityprompt(d)
                    end)
                    count += 1
                end
            end
        end
    end
    Notify(
        ('Pressed %d interactables within %d studs.'):format(count, radius),
        4
    )
end

--==================================================
-- Rebirth (Auto-Claim)
--==================================================
local rebirthEvent =
    ReplicatedStorage:WaitForChild("RebirthEvent (Don't Move)", 5)
local function getClaimHead(ty)
    if not ty then
        return nil
    end
    local ent = ty:FindFirstChild('Entrance')
    if not ent then
        for _, d in ipairs(ty:GetDescendants()) do
            if d:IsA('Folder') and d.Name:lower():find('entrance') then
                ent = d
                break
            end
        end
    end
    if not ent then
        return nil
    end
    local claimFolder = ent:FindFirstChild('Touch to claim!')
        or ent:FindFirstChildWhichIsA('Folder')
    if claimFolder then
        local head = claimFolder:FindFirstChild('Head')
            or claimFolder:FindFirstChildWhichIsA('BasePart', true)
        if head and head:IsA('BasePart') then
            return head
        end
    end
    for _, d in ipairs(ent:GetDescendants()) do
        if d:IsA('TouchTransmitter') then
            local p = d.Parent
            if p and p:IsA('BasePart') then
                return p
            end
        end
    end
    return nil
end

local function findUnownedTycoon()
    local root = tycoonsFolder()
    if not root then
        return nil
    end
    for _, ty in ipairs(root:GetChildren()) do
        local owner = ty:FindFirstChild('Owner')
            or ty:FindFirstChild('owner')
            or ty:FindFirstChild('OWNER')
        local has = false
        if owner then
            if owner:IsA('ObjectValue') then
                has = owner.Value ~= nil
            elseif owner:IsA('StringValue') then
                has = (owner.Value or '') ~= ''
            end
        end
        if not has then
            return ty
        end
    end
    return nil
end

local function rebirthAndClaim()
    if not rebirthEvent then
        return Notify('Rebirth remote not found.', 4)
    end
    pcall(function()
        rebirthEvent:FireServer()
    end)
    Notify('Rebirth sent…', 2)
    task.wait(2)
    local root = tycoonsFolder()
    local targetTycoon = (
        root
        and lastTycoonName
        and root:FindFirstChild(lastTycoonName)
    ) or findUnownedTycoon()
    if not targetTycoon then
        return Notify('No available tycoon to claim.', 4)
    end
    local claimPart = getClaimHead(targetTycoon)
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char and char:FindFirstChild('HumanoidRootPart')
    if hrp and claimPart then
        pcall(function()
            firetouchinterest(hrp, claimPart, 0)
            firetouchinterest(hrp, claimPart, 1)
        end)
        Notify('Rebirthed & Claimed Tycoon!', 4)
    else
        Notify('Failed to auto-claim (no claim part or HRP).', 4)
    end
end
if rebirthEvent then
    rebirthEvent.OnClientEvent:Connect(function(requiredCash)
        Notify(
            'You need a total of '
                .. tostring(requiredCash)
                .. ' cash to Rebirth.',
            4
        )
    end)
end

--==================================================
-- INF AMMO (Combat patch) — OOB-safe
--==================================================
local function applyInfAmmoPatch()
    if getgenv and getgenv()._UF_INF_AMMO_DONE then
        return Notify('INF AMMO already applied.', 3)
    end
    if
        not (debug and debug.getinfo and debug.getupvalue and debug.setupvalue)
    then
        return Notify('Executor lacks debug library; INF AMMO unavailable.', 5)
    end
    if not getgc then
        return Notify('Executor lacks getgc; INF AMMO unavailable.', 5)
    end
    local function _safe_getup(fn, i)
        local ok, a, b = pcall(debug.getupvalue, fn, i)
        if not ok then
            return nil
        end
        return (b ~= nil) and b or a
    end
    local function _safe_setup(fn, i, v)
        pcall(debug.setupvalue, fn, i, v)
    end
    local function _is_lclosure(fn)
        if islclosure then
            local ok, r = pcall(islclosure, fn)
            return ok and r == true
        end
        return type(fn) == 'function'
    end
    local funcs
    do
        local ok, r = pcall(function()
            return getgc(true)
        end)
        if ok and type(r) == 'table' then
            funcs = r
        else
            local ok2, r2 = pcall(function()
                return getgc()
            end)
            funcs = (ok2 and type(r2) == 'table') and r2 or {}
        end
    end
    local patched = false
    for _, func in ipairs(funcs) do
        if type(func) == 'function' and _is_lclosure(func) then
            local info = debug.getinfo(func)
            if info and info.name == 'Shoot' then
                for i = 1, 15 do
                    local upv = _safe_getup(func, i)
                    if type(upv) == 'number' then
                        _safe_setup(func, i, math.huge)
                    end
                end
                if hookfunction then
                    local old
                    old = hookfunction(func, function(...)
                        for i = 1, 15 do
                            local upv = _safe_getup(func, i)
                            if type(upv) == 'number' then
                                _safe_setup(func, i, math.huge)
                            end
                        end
                        return old(...)
                    end)
                elseif replaceclosure and newcclosure then
                    local original = func
                    pcall(function()
                        replaceclosure(
                            original,
                            newcclosure(function(...)
                                for i = 1, 15 do
                                    local upv = _safe_getup(original, i)
                                    if type(upv) == 'number' then
                                        _safe_setup(original, i, math.huge)
                                    end
                                end
                                return original(...)
                            end)
                        )
                    end)
                end
                patched = true
                warn('✅ Shoot patched with infinite ammo')
                break
            end
        end
    end
    if patched and getgenv then
        getgenv()._UF_INF_AMMO_DONE = true
    end
    if not patched then
        Notify('Could not find Shoot() in getgc.', 4)
    end
end

--==================================================
-- ESP (Roblox-native, toggleable)
--==================================================
local espEnabled = false
local wantESP = false
local espStore = {} -- [Player] = {highlight=..., billboard=..., label=..., conns={...}}
local espConns = {} -- Player-added/removing watchers
local ESP_COLOR = Color3.fromRGB(0, 255, 0)

local function _destroyESPEntry(entry)
    if not entry then
        return
    end
    if entry.conns then
        for _, c in ipairs(entry.conns) do
            if typeof(c) == 'RBXScriptConnection' then
                pcall(function()
                    c:Disconnect()
                end)
            end
        end
    end
    pcall(function()
        if entry.highlight then
            entry.highlight:Destroy()
        end
    end)
    pcall(function()
        if entry.billboard then
            entry.billboard:Destroy()
        end
    end)
end

local function _cleanupAllESP()
    for plr, entry in pairs(espStore) do
        _destroyESPEntry(entry)
        espStore[plr] = nil
    end
    for _, c in ipairs(espConns) do
        if typeof(c) == 'RBXScriptConnection' then
            pcall(function()
                c:Disconnect()
            end)
        end
    end
    table.clear(espConns)
end

local function _attachESPToCharacter(plr, char)
    if not espEnabled or not plr or not char or plr == lp then
        return
    end

    if espStore[plr] then
        _destroyESPEntry(espStore[plr])
    end
    local entry = { conns = {} }
    espStore[plr] = entry

    local highlight = Instance.new('Highlight')
    highlight.Name = 'UF_ESP_Highlight'
    highlight.FillColor = ESP_COLOR
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.FillTransparency = 0.75
    highlight.OutlineTransparency = 0
    highlight.Adornee = char
    highlight.Parent = char
    entry.highlight = highlight

    local adorneePart = char:FindFirstChild('Head')
        or char:FindFirstChild('HumanoidRootPart')
    local billboard = Instance.new('BillboardGui')
    billboard.Name = 'UF_ESP_Tag'
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 34)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.Adornee = adorneePart
    billboard.Parent = char

    local label = Instance.new('TextLabel')
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextColor3 = ESP_COLOR
    label.TextStrokeTransparency = 0.3
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Text = ''
    label.Parent = billboard

    entry.billboard = billboard
    entry.label = label

    local rsConn = RunService.RenderStepped:Connect(function()
        if not espEnabled then
            return
        end
        local myHRP = lp.Character
            and lp.Character:FindFirstChild('HumanoidRootPart')
        local theirHRP = char and char:FindFirstChild('HumanoidRootPart')
        if myHRP and theirHRP and label then
            local d = (myHRP.Position - theirHRP.Position).Magnitude
            label.Text = string.format('%s [%d Studs]', plr.Name, math.floor(d))
        end
    end)
    table.insert(entry.conns, rsConn)
end

local function _attachESPToPlayer(plr)
    if not espEnabled or not plr or plr == lp then
        return
    end
    local char = plr.Character
    if char then
        _attachESPToCharacter(plr, char)
    end
    table.insert(
        espConns,
        plr.CharacterAdded:Connect(function(c)
            task.wait(0.1)
            if espEnabled then
                _attachESPToCharacter(plr, c)
            end
        end)
    )
    table.insert(
        espConns,
        plr.CharacterRemoving:Connect(function()
            if espStore[plr] then
                _destroyESPEntry(espStore[plr])
                espStore[plr] = nil
            end
        end)
    )
end

local function setESPEnabled(state)
    espEnabled = state
    if not state then
        _cleanupAllESP()
        Notify('ESP: OFF', 3)
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp then
            _attachESPToPlayer(p)
        end
    end
    table.insert(
        espConns,
        Players.PlayerAdded:Connect(function(p)
            if espEnabled then
                _attachESPToPlayer(p)
            end
        end)
    )
    table.insert(
        espConns,
        Players.PlayerRemoving:Connect(function(p)
            if espStore[p] then
                _destroyESPEntry(espStore[p])
                espStore[p] = nil
            end
        end)
    )
    Notify('ESP: ON', 3)
end

--==================================================
-- Restart handling (respawn/rebirth)
--==================================================
local function stopAll()
    autoClick = false
    if clickThread then
        task.cancel(clickThread)
        clickThread = nil
    end
    autoPut = false
    if putThread then
        task.cancel(putThread)
        putThread = nil
    end
    autoPutUp = false
    if putUpThread then
        task.cancel(putUpThread)
        putUpThread = nil
    end
    autoCollect = false
    if collectThread then
        task.cancel(collectThread)
        collectThread = nil
    end
    autoBuy = false
    if buyThread then
        task.cancel(buyThread)
        buyThread = nil
    end
end
local function restartDesired(afterDelay)
    task.delay(afterDelay or 1.2, function()
        if wantClick then
            setAutoClick(true)
        end
        if wantPut then
            setAutoPut(true)
        end
        if wantPutUp then
            setAutoPutUp(true)
        end
        if wantCollect then
            setAutoCollect(true)
        end
        if wantBuy then
            setAutoBuy(true)
        end
        if wantESP then
            setESPEnabled(true)
        end
    end)
end

task.spawn(function()
    local ls = lp:WaitForChild('leaderstats', 10)
    local reb = ls and ls:WaitForChild('Rebirths', 10)
    if reb then
        reb:GetPropertyChangedSignal('Value'):Connect(function()
            Notify('Rebirthed! Restarting features…', 4)
            stopAll()
            local t = getMyTycoon()
            if t then
                lastTycoonName = t.Name
            end
            restartDesired(2.0)
        end)
    end
end)

lp.CharacterAdded:Connect(function()
    local t = getMyTycoon()
    if t then
        lastTycoonName = t.Name
    end
    restartDesired(1.2)
end)

--==================================================
-- UI Build
--==================================================
local Library = tryLoadLibrary()
if Library then
    Library.Theme = 'Dark'
    local Window =
        Library:Window({ Text = 'Gun Armory Tycoon by ntjustin on discord' })
    local Flags = Library.Flags

    -- Combat Tab
    local CombatTab = Window:Tab({ Text = 'Combat' })

    -- INF AMMO section
    local AmmoSection = CombatTab:Section({ Text = 'INF AMMO' })
    AmmoSection:Button({
        Text = 'INF AMMO',
        Callback = function()
            applyInfAmmoPatch()
        end,
    })

    -- Silent aim section (button present; no cheat loaded)
    local SilentSection = CombatTab:Section({ Text = 'Silent aim' })
    SilentSection:Button({
        Text = 'Silent Aim',
        Callback = function()
            loadstring(
                game:HttpGet(
                    'https://raw.githubusercontent.com/Averiias/Universal-SilentAim/refs/heads/main/main.lua',
                    true
                )
            )()
        end,
    })

    -- ESP section
    local ESPSection = CombatTab:Section({ Text = 'ESP' })
    ESPSection:Toggle({
        Text = 'ESP (players)',
        Callback = function(state)
            wantESP = state
            setESPEnabled(state)
        end,
    })

    ----------------------------------------------------------------
    -- Player tab with Fly + Noclip (speed slider)  [ADDED AS-IS]
    ----------------------------------------------------------------
    local PlayerTab = Window:Tab({ Text = 'Player' })
    local MoveSection = PlayerTab:Section({ Text = 'Movement' })

    -- =========================
    -- Fly / Noclip internals
    -- =========================
    local flyEnabled = false
    local noclipEnabled = false
    local flySpeed = 80

    local inputState =
        { W = false, A = false, S = false, D = false, Up = false, Down = false }
    local inputConns = {}
    local flyConn, noclipConn
    local gyro, vel

    local function getHRP()
        local char = lp.Character or lp.CharacterAdded:Wait()
        return char:FindFirstChild('HumanoidRootPart'),
            char:FindFirstChildOfClass('Humanoid'),
            char
    end

    local function bindInputs()
        if next(inputConns) ~= nil then
            return
        end
        inputConns.Began = UIS.InputBegan:Connect(function(io, gp)
            if gp then
                return
            end
            local k = io.KeyCode
            if k == Enum.KeyCode.W then
                inputState.W = true
            elseif k == Enum.KeyCode.S then
                inputState.S = true
            elseif k == Enum.KeyCode.A then
                inputState.A = true
            elseif k == Enum.KeyCode.D then
                inputState.D = true
            elseif k == Enum.KeyCode.Space then
                inputState.Up = true
            elseif
                k == Enum.KeyCode.LeftControl or k == Enum.KeyCode.LeftShift
            then
                inputState.Down = true
            end
        end)
        inputConns.Ended = UIS.InputEnded:Connect(function(io, gp)
            if gp then
                return
            end
            local k = io.KeyCode
            if k == Enum.KeyCode.W then
                inputState.W = false
            elseif k == Enum.KeyCode.S then
                inputState.S = false
            elseif k == Enum.KeyCode.A then
                inputState.A = false
            elseif k == Enum.KeyCode.D then
                inputState.D = false
            elseif k == Enum.KeyCode.Space then
                inputState.Up = false
            elseif
                k == Enum.KeyCode.LeftControl or k == Enum.KeyCode.LeftShift
            then
                inputState.Down = false
            end
        end)
    end

    local function unbindInputs()
        for _, c in pairs(inputConns) do
            pcall(function()
                c:Disconnect()
            end)
        end
        table.clear(inputConns)
        for k in pairs(inputState) do
            inputState[k] = false
        end
    end

    local function stopFly()
        flyEnabled = false
        if flyConn then
            flyConn:Disconnect()
            flyConn = nil
        end
        if vel then
            pcall(function()
                vel:Destroy()
            end)
            vel = nil
        end
        if gyro then
            pcall(function()
                gyro:Destroy()
            end)
            gyro = nil
        end
        local _, hum = getHRP()
        if hum then
            hum.PlatformStand = false
        end
        unbindInputs()
    end

    local function startFly()
        if flyEnabled then
            return
        end
        local hrp, hum = getHRP()
        if not (hrp and hum) then
            return
        end

        flyEnabled = true
        hum.PlatformStand = true

        gyro = Instance.new('BodyGyro')
        gyro.P = 9e4
        gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        gyro.CFrame = workspace.CurrentCamera.CFrame
        gyro.Parent = hrp

        vel = Instance.new('BodyVelocity')
        vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        vel.Velocity = Vector3.zero
        vel.Parent = hrp

        bindInputs()

        flyConn = RunService.RenderStepped:Connect(function(dt)
            if not flyEnabled then
                return
            end
            local cam = workspace.CurrentCamera
            local cf = cam.CFrame

            -- read current speed (slider might be moving)
            local s = flySpeed
            if Flags and Flags['Fly Speed'] then
                s = tonumber(Flags['Fly Speed']) or s
            end

            local dir = Vector3.zero
            if inputState.W then
                dir += cf.LookVector
            end
            if inputState.S then
                dir -= cf.LookVector
            end
            if inputState.A then
                dir -= cf.RightVector
            end
            if inputState.D then
                dir += cf.RightVector
            end
            if inputState.Up then
                dir += Vector3.new(0, 1, 0)
            end
            if inputState.Down then
                dir -= Vector3.new(0, 1, 0)
            end

            if dir.Magnitude > 0 then
                dir = dir.Unit
                vel.Velocity = dir * s
            else
                vel.Velocity = Vector3.zero
            end

            gyro.CFrame = CFrame.new(hrp.Position, hrp.Position + cf.LookVector)
        end)
    end

    local function setFly(on)
        if on then
            startFly()
        else
            stopFly()
        end
    end

    local function setNoclip(on)
        noclipEnabled = on
        if on then
            if noclipConn then
                noclipConn:Disconnect()
            end
            noclipConn = RunService.Stepped:Connect(function()
                local _, _, char = getHRP()
                if not char then
                    return
                end
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA('BasePart') then
                        p.CanCollide = false
                    end
                end
            end)
        else
            if noclipConn then
                noclipConn:Disconnect()
                noclipConn = nil
            end
            local _, _, char = getHRP()
            if char then
                local restore = {
                    'Head',
                    'Torso',
                    'UpperTorso',
                    'LowerTorso',
                    'HumanoidRootPart',
                    'LeftUpperLeg',
                    'RightUpperLeg',
                    'LeftLowerLeg',
                    'RightLowerLeg',
                    'LeftFoot',
                    'RightFoot',
                    'LeftUpperArm',
                    'RightUpperArm',
                    'LeftLowerArm',
                    'RightLowerArm',
                    'LeftHand',
                    'RightHand',
                }
                for _, name in ipairs(restore) do
                    local part = char:FindFirstChild(name, true)
                    if part and part:IsA('BasePart') then
                        part.CanCollide = true
                    end
                end
            end
        end
    end

    -- Re-apply on respawn if toggles are still on
    lp.CharacterAdded:Connect(function()
        if flyEnabled then
            task.defer(startFly)
        end
        if noclipEnabled and not noclipConn then
            task.defer(function()
                setNoclip(true)
            end)
        end
    end)

    -- =========================
    -- UI wiring
    -- =========================
    MoveSection:Toggle({
        Text = 'Fly',
        Callback = function(state)
            setFly(state)
        end,
    })

    MoveSection:Toggle({
        Text = 'Noclip',
        Callback = function(state)
            setNoclip(state)
        end,
    })

    MoveSection:Slider({
        Text = 'Fly Speed',
        Default = flySpeed,
        Minimum = 10,
        Maximum = 300,
        Callback = function(val)
            flySpeed = tonumber(val) or flySpeed
        end,
    })

    PlayerTab:Select()
    ----------------------------------------------------------------

    -- Tycoon Tab + sections
    local TycoonTab = Window:Tab({ Text = 'Tycoon' })
    local FarmSection =
        TycoonTab:Section({ Text = 'Auto Farm (Owner-Matched)' })
    local CollectSection = TycoonTab:Section({ Text = 'Auto Collect' })
    local BuySection = TycoonTab:Section({ Text = 'Auto Buy' })
    local ArmorSection = TycoonTab:Section({ Text = 'Armor' })
    local PvPSection = TycoonTab:Section({ Text = 'Base / Zone' })
    local UtilSection = TycoonTab:Section({ Text = 'Utilities' })
    local RebirthSection = TycoonTab:Section({ Text = 'Rebirth' })

    FarmSection:Toggle({ Text = 'Auto Click Dropper', Callback = setAutoClick })
    FarmSection:Toggle({ Text = 'Auto Put Parts', Callback = setAutoPut })
    FarmSection:Toggle({ Text = 'Auto Put Parts+', Callback = setAutoPutUp })

    CollectSection:Toggle({
        Text = 'Auto Collect Cash',
        Callback = setAutoCollect,
    })
    BuySection:Toggle({ Text = 'Auto Buy Buttons', Callback = setAutoBuy })

    ArmorSection:Button({
        Text = 'Equip Light Armor',
        Callback = equipLightArmor,
    })
    ArmorSection:Button({
        Text = 'Equip Standard Armor',
        Callback = equipStandardArmor,
    })

    PvPSection:Button({
        Text = 'TP to Base (Rockey Ridge)',
        Callback = tpToBase,
    })
    PvPSection:Button({ Text = 'TP to My Tycoon', Callback = tpToMyTycoon })
    PvPSection:Button({
        Text = 'Check Players in Zone',
        Callback = checkPlayersInZone,
    })

    UtilSection:Button({
        Text = 'Press Nearby Interactables',
        Callback = function()
            pressNearbyInteractables(40)
        end,
    })

    RebirthSection:Button({
        Text = 'Rebirth (Auto-Claim)',
        Callback = rebirthAndClaim,
    })
else
    local F = buildFallbackUI()

    -- Fallback Combat buttons
    F.AddButton('INF AMMO', function()
        applyInfAmmoPatch()
    end)
    F.AddButton('Silent Aim', function()
        loadstring(
            game:HttpGet(
                'https://raw.githubusercontent.com/Averiias/Universal-SilentAim/refs/heads/main/main.lua',
                true
            )
        )()
    end)
    F.AddToggle('ESP (players)', function(state)
        wantESP = state
        setESPEnabled(state)
    end)

    -- Tycoon features (fallback)
    F.AddToggle('Auto Click Dropper', setAutoClick)
    F.AddToggle('Auto Put Parts', setAutoPut)
    F.AddToggle('Auto Put Parts+', setAutoPutUp)
    F.AddToggle('Auto Collect Cash', setAutoCollect)
    F.AddToggle('Auto Buy Buttons', setAutoBuy)

    F.AddButton('Equip Light Armor', equipLightArmor)
    F.AddButton('Equip Standard Armor', equipStandardArmor)

    F.AddButton('TP to Base (Rockey Ridge)', tpToBase)
    F.AddButton('TP to My Tycoon', tpToMyTycoon)
    F.AddButton('Check Players in Zone', checkPlayersInZone)

    F.AddButton('Press Nearby Interactables', function()
        pressNearbyInteractables(40)
    end)
    F.AddButton('Rebirth (Auto-Claim)', rebirthAndClaim)

    F.Notify('Loaded fallback UI (library failed).', 4)
end