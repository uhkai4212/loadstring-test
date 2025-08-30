local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 创建主窗口
local Window = Rayfield:CreateWindow({
    Name = "哔哩JaPaQ",
    LoadingTitle = "Outdoor脚本",
    LoadingSubtitle = "doors脚本qq频道:pd28143948",
    ConfigurationSaving = {
        Enabled = false,
    },
})

-- 创建标签页
local Tab1 = Window:CreateTab("视觉类")
local Tab2 = Window:CreateTab("功能类")
local Tab3 = Window:CreateTab("人物类")
local Tab4 = Window:CreateTab("QQ频道和群")
local Tab5 = Window:CreateTab("我想说的")
local Tab6 = Window:CreateTab("未来想更新(will update")

-- 视觉类标签页的开关
local ToggleExample = Tab1:CreateToggle({
    Name = "Groundskeeper(园丁🤠)esp",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        print("园丁ESP状态:", Value)
        -- 获取必要的服务
local Workspace = game:GetService("Workspace")

-- 查找 Groundskeeper 对象
local function findGroundskeeper()
    local groundskeeperObjects = Workspace:GetDescendants()
    local result = {}
    for _, obj in pairs(groundskeeperObjects) do
        if obj.Name == "Groundskeeper" then
            table.insert(result, obj)
        end
    end
    return result
end

-- 为对象创建并设置 Highlight（高亮轮廓，黄色）
local function createHighlight(target)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = target
    highlight.Parent = target
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop  
    highlight.FillColor = Color3.fromRGB(255, 255, 0)  -- 黄色填充
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)  -- 黄色轮廓
    return highlight
end

-- 主逻辑：循环检测并应用高亮 ESP
while wait(1) do 
    local groundskeepers = findGroundskeeper()
    for _, groundskeeper in pairs(groundskeepers) do
        -- 检查是否已创建高亮，避免重复创建
        if not groundskeeper:FindFirstChild("Highlight") then
            createHighlight(groundskeeper)
        end
    end
end
    end
})

local ToggleExample = Tab1:CreateToggle({
    Name = "Mandrake(活的曼德拉草🌿)esp",
    CurrentValue = false,
    Flag = "Toggle2",
    Callback = function(Value)
        print("曼德拉草ESP状态:", Value)
        -- 快速 ESP Mandrakes：高亮+名称+距离
local mandrakes = workspace:WaitForChild("CurrentRooms"):GetDescendants()
local function esp(obj)
    -- 高亮
    local h = Instance.new("Highlight", obj)
    h.FillColor = Color3.fromRGB(255,0,0)
    h.OutlineColor = Color3.fromRGB(255,0,0)
    -- 名称标签
    local b = Instance.new("BillboardGui", obj)
    b.StudsOffset = Vector3.new(0,2,0)
    local t = Instance.new("TextLabel", b)
    t.Size = UDim2.new(0,200,0,50)
    t.TextColor3 = Color3.fromRGB(255,255,255)
    t.TextStrokeTransparency = 0
    t.Text = obj.Name.." [ESP]"
    -- 实时更新距离
    game:GetService("RunService").RenderStepped:Connect(function()
        if obj.Parent then
            local dist = (workspace.CurrentCamera.CFrame.Position - obj.Position).magnitude
            t.Text = obj.Name.." ["..math.floor(dist).." studs]"
        else
            h:Destroy()
            b:Destroy()
        end
    end)
end

-- 自动应用到所有 Mandrakes
for _,v in pairs(mandrakes) do
    if v:IsA("Model") and v.Name == "Mandrakes" then
        esp(v)
    end
end

-- 监听新增 Mandrakes
workspace.CurrentRooms.DescendantAdded:Connect(function(child)
    if child:IsA("Model") and child.Name == "Mandrakes" then
        esp(child)
    end
end)
    end
})

local ToggleExample = Tab1:CreateToggle({
    Name = "IronDoor(铁门🚪)esp",
    CurrentValue = false,
    Flag = "Toggle3",
    Callback = function(Value)
        print("铁门ESP状态:", Value)
        -- 配置目标路径参数
local ROOT = workspace:FindFirstChild("CurrentRooms")
local MIN_FOLDER_NUM = 0   -- 数字文件夹起始（0）
local MAX_FOLDER_NUM = 100 -- 数字文件夹结束（100）
local TARGET_NAME = "Door" -- 要标记的对象名称

-- 查找所有符合路径的 Door
local function findTargetDoors()
    local doors = {}
    if not ROOT then return doors end -- 若 CurrentRooms 不存在则返回空
    
    -- 遍历 0 到 100 的数字文件夹
    for folderNum = MIN_FOLDER_NUM, MAX_FOLDER_NUM do
        local numFolder = ROOT:FindFirstChild(tostring(folderNum))
        if numFolder then -- 找到对应数字文件夹
            local door = numFolder:FindFirstChild(TARGET_NAME)
            if door then -- 文件夹下存在 Door
                table.insert(doors, door)
            end
        end
    end
    return doors
end

-- 为 Door 添加 ESP 效果（灰色高亮 + 标签）
local function markDoor(door)
    -- 1. 标签显示
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = door.PrimaryPart or door:FindFirstChildOfClass("BasePart")
    billboard.StudsOffset = Vector3.new(0, 2, 0) -- 门上方显示
    billboard.Parent = door

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 80, 0, 30)
    label.Text = "Door"
    label.TextColor3 = Color3.fromRGB(128, 128, 128) -- 灰色
    label.Parent = billboard

    -- 2. 三维高亮（可选，穿透显示）
    local highlight = Instance.new("Highlight")
    highlight.Adornee = door
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(128, 128, 128)
    highlight.Parent = door
end

-- 初始标记所有符合条件的 Door
local targetDoors = findTargetDoors()
for _, door in pairs(targetDoors) do
    markDoor(door)
end

print("已标记 " .. #targetDoors .. " 个 Door（位于 CurrentRooms 下 0-100 数字文件夹内）")

-- 实时监听新生成的 Door（若数字文件夹动态创建）
if ROOT then
    ROOT.ChildAdded:Connect(function(child)
        -- 检查新增的是否是 0-100 的数字文件夹
        local folderNum = tonumber(child.Name)
        if folderNum and folderNum >= MIN_FOLDER_NUM and folderNum <= MAX_FOLDER_NUM then
            -- 监听该文件夹下的 Door 新增
            child.ChildAdded:Connect(function(subChild)
                if subChild.Name == TARGET_NAME then
                    markDoor(subChild)
                    print("新 Door 已标记：" .. child.Name .. " → " .. subChild.Name)
                end
            end)
        end
    end)
end
    end
})

local ToggleExample = Tab1:CreateToggle({
    Name = "IronKey(铁钥匙🔑)esp",
    CurrentValue = false,
    Flag = "Toggle4",
    Callback = function(Value)
        print("铁钥匙ESP状态:", Value)
        local function createESP(target)
    if target:FindFirstChild("IronKeyForCryptLabel") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "IronKeyForCryptLabel"
    billboard.Parent = target
    billboard.Adornee = target
    billboard.Size = UDim2.new(0, 60, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = "IronKeyForCrypt"
    textLabel.TextColor3 = Color3.fromRGB(150, 75, 0)  -- 棕色
    textLabel.TextScaled = true
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
end

local function setupRoomMonitoring(room)
    if not room then return end
    
    local function searchAndLabel(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == "IronKeyForCrypt" then
                createESP(child)
            end
            searchAndLabel(child)
        end
    end
    
    searchAndLabel(room)
    
    local function setupDeepMonitoring(parent)
        parent.ChildAdded:Connect(function(child)
            if child.Name == "IronKeyForCrypt" then
                createESP(child)
            end
            setupDeepMonitoring(child)
        end)
    end
    
    setupDeepMonitoring(room)
end

local function main()
    local workspace = game:GetService("Workspace")
    local currentRooms = workspace:FindFirstChild("CurrentRooms")
    
    if not currentRooms then
        return
    end
    
    for i = 0, 35 do
        local roomName = tostring(i)
        local room = currentRooms:FindFirstChild(roomName)
        if room then
            setupRoomMonitoring(room)
        else
            local connection
            connection = currentRooms.ChildAdded:Connect(function(child)
                if child.Name == roomName then
                    setupRoomMonitoring(child)
                    connection:Disconnect()
                end
            end)
        end
    end
    
    currentRooms.ChildAdded:Connect(function(child)
        if tonumber(child.Name) then
            setupRoomMonitoring(child)
        end
    end)
end

main()
            end
})

local ToggleExample = Tab1:CreateToggle({
    Name = "LotusPetal(荷花瓣🪷)esp",
    CurrentValue = false,
    Flag = "Toggle5",
    Callback = function(Value)
        print("荷花瓣ESP状态:", Value)
        local function createESP(target)
    if target:FindFirstChild("LotusPetalESP") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "LotusPetalESP"
    billboard.Parent = target
    billboard.Adornee = target
    billboard.Size = UDim2.new(0, 40, 0, 15)
    billboard.StudsOffset = Vector3.new(0, 1.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = "Lotus Petal"
    textLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 12
end

-- 使用表来跟踪已经设置监听的父对象，避免重复监听
local monitoredParents = {}

local function setupDeepMonitoring(parent)
    if monitoredParents[parent] then return end
    monitoredParents[parent] = true
    
    parent.ChildAdded:Connect(function(child)
        if child.Name == "LotusPetalPickup" then
            task.spawn(createESP, child)
        end
        -- 只对Model和Folder等可能包含对象的类型进行递归监听
        if child:IsA("Model") or child:IsA("Folder") then
            task.spawn(setupDeepMonitoring, child)
        end
    end)
end

local function searchAndLabel(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "LotusPetalPickup" then
            task.spawn(createESP, child)
        end
        -- 限制递归深度，只对可能包含对象的类型进行搜索
        if child:IsA("Model") or child:IsA("Folder") then
            task.spawn(searchAndLabel, child)
        end
    end
end

local function setupRoomMonitoring(room)
    if not room then return end
    
    task.spawn(searchAndLabel, room)
    task.spawn(setupDeepMonitoring, room)
end

local function main()
    local currentRooms = workspace:FindFirstChild("CurrentRooms")
    
    if not currentRooms then
        currentRooms = workspace:WaitForChild("CurrentRooms")
    end

    -- 先设置对CurrentRooms的整体监听
    task.spawn(setupDeepMonitoring, currentRooms)
    
    -- 分批处理房间，避免一次性处理太多
    for i = 0, 35 do
        local roomName = tostring(i)
        local room = currentRooms:FindFirstChild(roomName)
        if room then
            task.spawn(setupRoomMonitoring, room)
        else
            local connection
            connection = currentRooms.ChildAdded:Connect(function(child)
                if child.Name == roomName then
                    task.spawn(setupRoomMonitoring, child)
                    connection:Disconnect()
                end
            end)
        end
        task.wait(0.1) -- 增加处理间隔
    end
    
    currentRooms.ChildAdded:Connect(function(child)
        if tonumber(child.Name) then
            task.spawn(setupRoomMonitoring, child)
        end
    end)
end

-- 延迟启动，避免游戏加载时卡顿
task.wait(2)
coroutine.wrap(main)()
    end
})

local ToggleExample = Tab1:CreateToggle({
    Name = "Gold💰(精子🥛)有点bug，警慎使用 esp",
    CurrentValue = false,
    Flag = "Toggle6",
    Callback = function(Value)
        print("金币ESP状态:", Value)
        local monitoredParents = {} -- 跟踪已经设置监听的父对象

local function createESP(target)
    if target:FindFirstChild("GoldPileESP") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "GoldPileESP"
    billboard.Parent = target
    billboard.Adornee = target
    billboard.Size = UDim2.new(0, 40, 0, 15)
    billboard.StudsOffset = Vector3.new(0, 1.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = "Gold Pile"
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 12
    
    -- 创建渐变金色效果
    local time = 0
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if not billboard.Parent then
            connection:Disconnect()
            return
        end
        time = time + 0.05
        local r = 0.8 + 0.2 * math.sin(time)
        local g = 0.6 + 0.2 * math.sin(time + 1)
        local b = 0.1 + 0.1 * math.sin(time + 2)
        textLabel.TextColor3 = Color3.new(r, g, b)
    end)
end

local function searchAndLabel(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "GoldPile" then
            createESP(child)
        end
        if #child:GetChildren() > 0 then
            searchAndLabel(child)
        end
    end
end

local function setupDeepMonitoring(parent)
    if monitoredParents[parent] then return end
    monitoredParents[parent] = true
    
    parent.ChildAdded:Connect(function(child)
        if child.Name == "GoldPile" then
            task.spawn(createESP, child)
        end
        -- 对新添加的对象也设置监听
        if child:IsA("Model") or child:IsA("Folder") then
            task.spawn(setupDeepMonitoring, child)
        end
    end)
end

local function setupRoomMonitoring(room)
    if not room then return end
    
    searchAndLabel(room)
    setupDeepMonitoring(room)
end

local function main()
    local currentRooms = workspace:FindFirstChild("CurrentRooms")
    
    if not currentRooms then
        currentRooms = workspace:WaitForChild("CurrentRooms")
    end

    -- 先对整个CurrentRooms设置监听
    setupDeepMonitoring(currentRooms)
    
    for i = 0, 35 do
        local roomName = tostring(i)
        local room = currentRooms:FindFirstChild(roomName)
        if room then
            setupRoomMonitoring(room)
        else
            local connection
            connection = currentRooms.ChildAdded:Connect(function(child)
                if child.Name == roomName then
                    setupRoomMonitoring(child)
                    connection:Disconnect()
                end
            end)
        end
        task.wait(0.05) -- 短暂延迟避免卡顿
    end
    
    currentRooms.ChildAdded:Connect(function(child)
        if tonumber(child.Name) then
            setupRoomMonitoring(child)
        end
    end)
end

-- 延迟启动以确保游戏加载完成
task.wait(1)
coroutine.wrap(main)()
    end
})

-- 功能类标签页的按钮
local ButtonExample = Tab2:CreateButton({
    Name = "AntiSnare(反地刺📌)就是删除",
    Callback = function()
        print("AntiSnare按钮被点击")
        -- 存储已处理的 Snare，避免重复删除
local deletedSnares = {}

-- 核心删除函数
local function deleteSnare(snare)
    if deletedSnares[snare] or not snare:IsDescendantOf(workspace) then
        return -- 已删除或不在场景中，跳过
    end
    deletedSnares[snare] = true
    snare:Destroy() -- 删除对象
    print("已删除 Snare：" .. snare:GetFullName())
end

-- 初始扫描并删除所有现存 Snare
local function scanAndDeleteExisting()
    local allObjects = workspace:GetDescendants()
    for _, obj in pairs(allObjects) do
        if obj.Name == "Snare" then
            deleteSnare(obj)
        end
    end
end

-- 监听新生成的 Snare 并删除
local function listenForNewSnares()
    -- 监听整个场景的新对象
    workspace.DescendantAdded:Connect(function(child)
        if child.Name == "Snare" then
            deleteSnare(child)
        end
    end)
end

-- 启动逻辑
scanAndDeleteExisting() -- 处理已存在的
listenForNewSnares()    -- 监听新生成的

print("已启动 Snare 自动删除功能（包括新生成的）")
    end,
})

local ButtonExample = Tab2:CreateButton({
    Name = "AntiSurge(反宙斯)不是删除",
    Callback = function()
        print("AntiSurge按钮被点击")
        local RepStorage = game:GetService("ReplicatedStorage") local SurgeCheck = require(RepStorage.ModulesShared.SurgeCheck)  SurgeCheck.GetUncoveredPosition = function() return nil end
    end,
})

local ButtonExample = Tab3:CreateButton({
    Name = "iy(输入tpwalk 0.5,追逐战关了,输入untpwalk)",
    Callback = function()
        print("按钮被点击了!")
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Infinite-Yield-31802"))()
    end,
})

local ButtonExample = Tab4:CreateButton({
    Name = "频道号",
    Callback = function()
        print("QQ频道按钮被点击")
        setclipboard("pd28143948")
    end,
})

local ButtonExample = Tab4:CreateButton({
    Name = "群号",
    Callback = function()
        print("按钮被点击了!")
        setclipboard("956763259")
    end,
})

local ButtonExample = Tab5:CreateButton({
    Name = "开关有问题(本来想做按钮)",
    Callback = function()
        print("按钮被点击了!")
        setclipboard("不会做关闭,很好笑")
    end,
})

local ButtonExample = Tab5:CreateButton({
    Name = "2025年八月我才开始学做脚本，缺点很多，请谅解一下",
    Callback = function()
        print("按钮被点击了!")
        setclipboard("感谢您的支持")
    end,
})

local ButtonExample = Tab6:CreateButton({
    Name = "esp monument(纪念碑)",
    Callback = function()
        print("按钮被点击了!")
    end,
})

local ButtonExample = Tab6:CreateButton({
    Name = "esp断头台",
    Callback = function()
        print("按钮被点击了!")
    end,
})

local ButtonExample = Tab6:CreateButton({
    Name = "esp Bramble(又聋又瞎的那个)",
    Callback = function()
        print("按钮被点击了!")
    end,
})