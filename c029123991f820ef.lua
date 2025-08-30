local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Fluent UI Setup
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local lp = game.Players.LocalPlayer
local minimizeUI = Enum.KeyCode.RightAlt

-- Main UI
local Window
local success, err = pcall(function()
    Window = Fluent:CreateWindow({
        Title = "Grow a garden",
        SubTitle = "By Moondiety",
        TabWidth = 160,
        Size = UDim2.fromOffset(498, 445),
        Acrylic = false,
        Theme = Amethyst,
        MinimizeKey = minimizeUI
    })
end)
if not success then
    warn("Failed to create Window: ", err)
    return
end

-- Wait for UI to initialize
task.wait(0.1) -- Small delay to ensure Window is ready

-- Tabs
local Tabs = {}
local tabNames = {
    "Home", "Auto", "Misc", "Shops", "Ability", "Esp", "Guis", "Events","settings"
}
local tabIcons = {
    "rbxassetid://6026568198", -- Home
    "rbxassetid://6031763426", -- Auto
    "rbxassetid://6034509993", -- Misc
    "percent", -- Shops
    "leaf", -- Ability
    "eye", -- esp
    "heart", -- hsl(0,0%,100%)
    "star", -- Events (calendar icon)
    "settings" -- settings tab
  
}

for i, name in ipairs(tabNames) do
    local success, tab = pcall(function()
        return Window:AddTab({ Title = name, Icon = tabIcons[i] })
    end)
    if success and tab then
        Tabs[name] = tab
        print("Successfully created tab: " .. name)
    else
        warn("Failed to create tab: " .. name)
    end
end

-- Utility Functions
local function parseMoney(moneyStr)
    if not moneyStr then return 0 end
    moneyStr = tostring(moneyStr):gsub("Â¢", ""):gsub(",", ""):gsub(" ", ""):gsub("%$", "")
    local multiplier = 1
    if moneyStr:lower():find("k") then
        multiplier = 1000
        moneyStr = moneyStr:lower():gsub("k", "")
    elseif moneyStr:lower():find("m") then
        multiplier = 1000000
        moneyStr = moneyStr:lower():gsub("m", "")
    end
    return (tonumber(moneyStr) or 0) * multiplier
end

local function getPlayerMoney()
    return parseMoney((shecklesStat and shecklesStat.Value) or 0)
end

local function isInventoryFull()
    return #lp.Backpack:GetChildren() >= 200
end

-- Home Tab Content
Tabs.Home:AddParagraph({
    Title = "Credits",
    Content = "By Moondiety x Vuk some fuatres by Vuk"
})

Tabs.Home:AddButton({
    Title = "Join Discord",
    Description = "Join up like a good boy for more scripts",
    Callback = function()
        setclipboard("https://discord.gg/wZ4hBXSrxY")
        Fluent:Notify({
            Title = "Discord Link Copied!",
            Content = "Paste it into your browser to join.",
            Duration = 5
        })
    end
})

Tabs.Home:AddButton({
    Title = "Anti afk",
    Description = "",
    Callback = function()
        local local_player = game:GetService("Players").LocalPlayer
        local virtual_user = game:GetService("VirtualUser")

        if getgc then
            for _, v in next, getgc(true) do
                if typeof(v) == "function" and islclosure(v) then
                    local info = debug.getinfo(v)
                    if info and info.source and string.find(info.source, "Idled") then
                        local success, _ = pcall(function()
                            if getfenv(v).script == local_player then
                                if v.Disable then v.Disable(v) end
                                if v.Disconnect then v.Disconnect(v) end
                            end
                        end)
                    end
                end
            end
        else
            local_player.Idled:Connect(function()
                virtual_user:CaptureController()
                virtual_user:ClickButton2(Vector2.new())
            end)
        end

        library:Notify("Anti AFK Enabled!")
    end
})



local Sections = { as = Tabs.Auto:AddSection("Auto Buy Seeds") }

-- Auto Tab Content
local Options = Fluent.Options




-- Misc Tab Content
local Sections = { femb = Tabs.Auto:AddSection("Auto Buy Gears") }

local AllGears = {
    "All",
    "Watering Can", "Trading Ticket" "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Medium Toy", "Medium Treat",
    "Godly Sprinkler", "Magnifying Glass", "Tanning Mirror", "Master Sprinkler", "Cleaning Spray", "Favorite Tool",
    "Harvest Tool", "Friendship Pot", "Grandmaster Sprinkler", "Levelup Lollipop"
}

local SelectedGears = {}

local GearDropdown = Tabs.Auto:AddDropdown("SelectedGearDropdown", {
    Title = "Select Gear to Buy",
    Values = AllGears,
    Multi = true,
    Default = {},
})

GearDropdown:OnChanged(function(Value)
    SelectedGears = {}
    for gear, selected in pairs(Value) do
        if selected then
            table.insert(SelectedGears, gear)
        end
    end
end)

Tabs.Auto:AddToggle("AutoBuySelectedGear", {
    Title = "Auto Buy Selected Gear",
    Default = false,
    Callback = function(enabled)
        if enabled then
            if #SelectedGears == 282828282992 then
                Fluent:Notify({
                    Title = "Error",
                    Content = "Nigga how the fuck you manged to do that.",
                    Duration = 80
                })
                Fluent.Options.AutoBuySelectedGear:SetValue(false)
                return
            end

            task.spawn(function()
                while Fluent.Options.AutoBuySelectedGear.Value do
                    if table.find(SelectedGears, "All") then
                        for i = 2, #AllGears do
                            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(AllGears[i])
                        end
                    else
                        for _, gear in ipairs(SelectedGears) do
                            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(gear)
                            task.wait(0.2)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- 🎉 EVENT ITEM SETUP

local Sections = { tuff = Tabs.Auto:AddSection("Auto Buy Eggs") }

local Options = Fluent.Options
local eggList = {
    "Common Egg",
    "Common Summer Egg",
    "Rare Summer Egg",
    "Mythical Egg",
    "Paradise Summer Egg",
    "Bee Egg",
    "Bug Egg"
}

local MultiEggDropdown = Tabs.Auto:AddDropdown("SelectedEggs", {
    Title = "Select Egg to buy",
    Description = "Select eggs to buy",
    Values = { "All", unpack(eggList) },
    Multi = true,
    Default = {}
})

local AutoBuyToggle = Tabs.Auto:AddToggle("AutoBuyEggs", { Title = "Auto buy selected Eggs", Default = false })

-- Buy function
local function buyEgg(eggName)
    local args = { eggName }
    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"):FireServer(unpack(args))
end

-- Main auto-buy loop
task.spawn(function()
    while true do
        task.wait()
        if Options.AutoBuyEggs.Value then
            local selected = Options.SelectedEggs.Value
            local toBuy = {}

            if table.find(selected, "All") then
                toBuy = eggList
            else
                toBuy = selected
            end

            for _, eggName in ipairs(toBuy) do
                buyEgg(eggName)
                task.wait(0.5)
                if not Options.AutoBuyEggs.Value then break end
            end
        end
    end
end)



local Sections = { nigga = Tabs.Auto:AddSection("Auto Hervest") }

local AutoHarvestV1Toggle = Tabs.Auto:AddToggle("AutoHarvestV1", {
    Title = "Auto Harvest",
    Description = "harvests all plants and fruits automatically.",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                local player = game:GetService("Players").LocalPlayer
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local getFarm = require(ReplicatedStorage.Modules.GetFarm)
                local byteNetReliable = ReplicatedStorage:WaitForChild("ByteNetReliable")
                local buffer = buffer.fromstring("\1\1\0\1")

                local minWeight, maxWeight = 0, 9999

                -- harvestFilter بدون فیلتر وزن و نام، همه رو قبول می‌کنه
                local function harvestFilter(obj, minW, maxW)
                    local w = obj:FindFirstChild("Weight")
                    if not w or not tonumber(w.Value) then return false end
                    local val = tonumber(w.Value)
                    return val >= minW and val <= maxW
                end

                while Fluent.Options.AutoHarvestV1.Value do
                    local farm = getFarm(player)
                    if not farm or not farm:FindFirstChild("Important") or not farm.Important:FindFirstChild("Plants_Physical") then
                        warn("Could not find Plants_Physical.")
                        Fluent.Options.AutoHarvestV1.Value = false
                        return
                    end

                    for _, plant in ipairs(farm.Important.Plants_Physical:GetChildren()) do
                        if not Fluent.Options.AutoHarvestV1.Value then break end

                        if harvestFilter(plant, minWeight, maxWeight) then
                            byteNetReliable:FireServer(buffer, { plant })
                            task.wait(math.max(0.01, Fluent.Options.HarvestV1Speed.Value or 0.01))
                        end

                        local fruits = plant:FindFirstChild("Fruits", true)
                        if fruits then
                            for _, fruit in ipairs(fruits:GetChildren()) do
                                if not Fluent.Options.AutoHarvestV1.Value then break end

                                if harvestFilter(fruit, minWeight, maxWeight) then
                                    byteNetReliable:FireServer(buffer, { fruit })
                                    task.wait(math.max(0.01, Fluent.Options.HarvestV1Speed.Value or 0.01))
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- Input Field for Auto Harvest V1 Speed
local HarvestV1SpeedInput = Tabs.Auto:AddInput("HarvestV1Speed", {
    Title = "Set Harvest Speed",
    Default = "0.1",
    Placeholder = "Enter seconds (e.g., 0.05)",
    Numeric = false,
    Finished = true,
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            Fluent.Options.HarvestV1Speed.Value = num
        else
            Fluent:Notify({
                Title = "Summer event",
                Content = "Invalid speed value! Please enter a positive number (e.g., 0.05).",
                Duration = 5
            })
            Fluent.Options.HarvestV1Speed.Value = 0.01
        end
    end
})

local Sections = { fembsex = Tabs.Auto:AddSection("Auto Sell") }

local autoSellEnabled = false
local autoSellThread

local function sellItems()
    local steven = workspace.NPCS:FindFirstChild("Steven")
    if not steven then return false end
    
    local char = lp.Character
    if not char then return false end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local originalPosition = hrp.CFrame
    hrp.CFrame = steven.HumanoidRootPart.CFrame * CFrame.new(0, 3, 3)
    task.wait(0.5)
    
    for _ = 1, 5 do
        pcall(function()
            ReplicatedStorage.GameEvents.Sell_Inventory:FireServer()
        end)
        task.wait(0.15)
    end
    
    hrp.CFrame = originalPosition
    return true
end

local AutoSellToggle = Tabs.Auto:AddToggle("AutoSellToggle", {
    Title = "Auto Sell",
    Default = false
})

AutoSellToggle:OnChanged(function(state)
    autoSellEnabled = state
    if autoSellEnabled then
        autoSellThread = task.spawn(function()
            while autoSellEnabled do
                sellItems()
                task.wait(1)
            end
        end)
    else
        if autoSellThread then
            task.cancel(autoSellThread)
            autoSellThread = nil
        end
    end
end)

local Sections = { Craft = Tabs.Misc:AddSection("Auto crafting") }
local CraftingService = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("CraftingGlobalObjectService")
local player = game.Players.LocalPlayer

-- Initialize global table for tracking used tools if not already set
getgenv().usedUUIDs = getgenv().usedUUIDs or {}

-- Function to input a tool into the crafting system
local function inputToolByName(name, index, itemType, Workbench, WorkbenchName, exactMatch)
    itemType = itemType or "Holdable"
    local backpack = player:WaitForChild("Backpack")
    
    -- Clean tool name by removing quantity indicators (e.g., "x123" or "[x123]")
    local function cleanToolName(str)
        str = str:gsub("%s*x%d+$", "")      -- Remove " x123"
        str = str:gsub("%s*%[.-%]%s*", "")  -- Remove "[...]" with or without spaces
        return str
    end
    
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            -- Apply blacklist unless explicitly ignored
            if not getgenv().ignoreBlacklist then
                local lower = tool.Name:lower()
                if lower:find("seed") or lower:find("rahhhh") then
                    continue
                end
            end
            
            local toolNameToCheck = cleanToolName(tool.Name)
            local matched = exactMatch and (toolNameToCheck == name) or toolNameToCheck:find(name)
            
            if matched then
                local uuid = tool:GetAttribute("c")
                if uuid and not table.find(getgenv().usedUUIDs, uuid) then
                    local args = {
                        "InputItem",
                        Workbench,
                        WorkbenchName,
                        index,
                        {
                            ItemType = itemType,
                            ItemData = { UUID = uuid }
                        }
                    }
                    CraftingService:FireServer(unpack(args))
                    table.insert(getgenv().usedUUIDs, uuid)
                    task.wait(0.2)
                    return true -- Tool successfully inputted
                end
            end
        end
    end
    return false -- Tool not found or already used
end

-- Generalized function to trigger proximity prompt on any workbench
local function triggerProximityPrompt(workbench)
    task.wait(2)
    for _, descendant in ipairs(workbench:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") and descendant.Name == "CraftingProximityPrompt" then
            fireproximityprompt(descendant)
            task.wait(3)
            fireproximityprompt(descendant)
            break
        end
    end
end

-- Crafting functions for items
local function craftLightningRod()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Lightning Rod")
    task.wait(1)
    local success = true
    success = success and inputToolByName("Basic Sprinkler", 1, "Sprinkler", Workbench, WorkbenchName)
    success = success and inputToolByName("Advanced Sprinkler", 2, "Sprinkler", Workbench, WorkbenchName)
    success = success and inputToolByName("Godly Sprinkler", 3, "Sprinkler", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Lightning Rod: Missing required tools")
    end
end

local function craftReclaimer()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Reclaimer")
    task.wait(0.3)
    local success = true
    success = success and inputToolByName("Common Egg", 1, "PetEgg", Workbench, WorkbenchName)
    success = success and inputToolByName("Harvest Tool", 2, "Harvest Tool", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Reclaimer: Missing required tools")
    end
end

local function craftTropicalMist()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Tropical Mist Sprinkler")
    task.wait(1)
    local success = true
    success = success and inputToolByName("Coconut", 1, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Dragon Fruit", 2, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Mango", 3, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Godly Sprinkler", 4, "Sprinkler", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Tropical Mist Sprinkler: Missing required tools")
    end
end

local function craftBerryBlusher()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Berry Blusher Sprinkler")
    task.wait(1)
    local success = true
    success = success and inputToolByName("Grape", 1, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Blueberry", 2, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Strawberry", 3, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Godly Sprinkler", 4, "Sprinkler", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Berry Blusher Sprinkler: Missing required tools")
    end
end

local function craftSweetSoaker()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Sweet Soaker Sprinkler")
    task.wait(1)
    local success = true
    success = success and inputToolByName("Watermelon", 1, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Watermelon", 2, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Watermelon", 3, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Master Sprinkler", 4, "Sprinkler", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Sweet Soaker Sprinkler: Missing required tools")
    end
end

local function craftFlowerFroster()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Flower Froster Sprinkler")
    task.wait(1)
    local success = true
    success = success and inputToolByName("Orange Tulip", 1, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Daffodil", 2, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Advanced Sprinkler", 3, "Sprinkler", Workbench, WorkbenchName)
    success = success and inputToolByName("Basic Sprinkler", 4, "Sprinkler", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Flower Froster Sprinkler: Missing required tools")
    end
end

local function craftSpiceSpritzer()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Spice Spritzer Sprinkler")
    task.wait(1)
    local success = true
    success = success and inputToolByName("Pepper", 1, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Ember Lily", 2, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Cacao", 3, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Master Sprinkler", 4, "Sprinkler", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Spice Spritzer Sprinkler: Missing required tools")
    end
end

local function craftStalkSprout()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Stalk Sprout Sprinkler")
    task.wait(1)
    local success = true
    success = success and inputToolByName("Bamboo", 1, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Beanstalk", 2, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Mushroom", 3, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Advanced Sprinkler", 4, "Sprinkler", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Stalk Sprout Sprinkler: Missing required tools")
    end
end

local function craftMutationSprayChoc()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Mutation Spray Choc")
    task.wait(0.4)
    local success = true
    success = success and inputToolByName("Cleaning Spray", 1, "SprayBottle", Workbench, WorkbenchName)
    success = success and inputToolByName("Cacao", 2, nil, Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Mutation Spray Choc: Missing required tools")
    end
end

local function craftMutationSprayChilled()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Mutation Spray Chilled")
    task.wait(0.4)
    local success = true
    success = success and inputToolByName("Cleaning Spray", 1, "SprayBottle", Workbench, WorkbenchName)
    success = success and inputToolByName("Godly Sprinkler", 2, "Sprinkler", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Mutation Spray Chilled: Missing required tools")
    end
end

local function craftMutationSprayShocked()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Mutation Spray Shocked")
    task.wait(0.4)
    local success = true
    success = success and inputToolByName("Cleaning Spray", 1, "SprayBottle", Workbench, WorkbenchName)
    success = success and inputToolByName("Lightning Rod", 2, "Lightning Rod", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Mutation Spray Shocked: Missing required tools")
    end
end

local function craftAntiBeeEgg()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Anti Bee Egg")
    task.wait(0.4)
    local success = inputToolByName("Bee Egg", 1, "PetEgg", Workbench, WorkbenchName, true)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Anti Bee Egg: Missing Bee Egg")
    end
end

local function craftSmallToy()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    local prevIgnore = getgenv().ignoreBlacklist
    getgenv().ignoreBlacklist = true
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Small Toy")
    task.wait(0.4)
    local success = true
j inputToolByName("Common Egg", 1, "PetEgg", Workbench, WorkbenchName, true)
b inputToolByName("Coconut Seed", 2, "Seed", Workbench, WorkbenchName)
j inputToolByName("Coconut", 3, nil, Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Small Toy: Missing required tools")
    end
    getgenv().ignoreBlacklist = prevIgnore
end

local function craftSmallTreat()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    local prevIgnore = getgenv().ignoreBlacklist
    getgenv().ignoreBlacklist = true
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Small Treat")
    task.wait(0.4)
    local success = true
    success = success and inputToolByName("Common Egg", 1, "PetEgg", Workbench, WorkbenchName, true)
    success = success and inputToolByName("Dragon Fruit Seed", 2, "Seed", Workbench, WorkbenchName)
    success = success and inputToolByName("Blueberry", 3, nil, Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Small Treat: Missing required tools")
    end
    getgenv().ignoreBlacklist = prevIgnore
end

local function craftPackBee()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("EventCraftingWorkBench")
    local WorkbenchName = "GearEventWorkbench"
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Pack Bee")
    task.wait(0.4)
    local success = true
    success = success and inputToolByName("Anti Bee Egg", 1, "PetEgg", Workbench, WorkbenchName)
    success = success and inputToolByName("Sunflower", 2, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Purple Dahlia", 3, nil, Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Pack Bee: Missing required tools")
    end
end

-- Crafting functions for seeds
local function craftHorsetailSeed()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("SeedEventCraftingWorkBench")
    local WorkbenchName = "SeedEventWorkbench"
    local prevIgnore = getgenv().ignoreBlacklist
    getgenv().ignoreBlacklist = true
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Horsetail")
    task.wait(0.3)
    local success = true
    success = success and inputToolByName("Stonebite Seed", 1, "Seed", Workbench, WorkbenchName)
    success = success and inputToolByName("Bamboo", 2, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Corn", 3, nil, Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Horsetail Seed: Missing required tools")
    end
    getgenv().ignoreBlacklist = prevIgnore
end

local function craftLingonBerrySeed()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("SeedEventCraftingWorkBench")
    local WorkbenchName = "SeedEventWorkbench"
    local prevIgnore = getgenv().ignoreBlacklist
    getgenv().ignoreBlacklist = true
    local recipeTools = {"Blueberry Seed", "Blueberry Seed", "Blueberry Seed", "Horsetail"}

    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Lingonberry")
    task.wait(0.3)

    local success = true

    getgenv().usedUUIDs = {}
    success = success and inputToolByName("Blueberry Seed", 1, "Seed", Workbench, WorkbenchName)
    task.wait(0.5)

    getgenv().usedUUIDs = {}
    success = success and inputToolByName("Blueberry Seed", 2, "Seed", Workbench, WorkbenchName)
    task.wait(0.5)

    getgenv().usedUUIDs = {}
    success = success and inputToolByName("Blueberry Seed", 3, "Seed", Workbench, WorkbenchName)
    task.wait(0.5)

    success = success and inputToolByName("Horsetail", 4, nil, Workbench, WorkbenchName)

    if success then
        task.wait(0.2)
        fireyk()
        if hasSpacedTool(recipeTools) then
            task.wait(0.3)
            getgenv().usedUUIDs = {}
        end
    else
        warn("Failed to craft Lingon Berry Seed: Missing required tools")
    end

    getgenv().ignoreBlacklist = prevIgnore
end

local function craftAmberSpineSeed()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("SeedEventCraftingWorkBench")
    local WorkbenchName = "SeedEventWorkbench"
    local prevIgnore = getgenv().ignoreBlacklist
    getgenv().ignoreBlacklist = true
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Amber Spine")
    task.wait(0.3)
    local success = true
    success = success and inputToolByName("Cactus Seed", 1, "Seed", Workbench, WorkbenchName)
    success = success and inputToolByName("Pumpkin", 2, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Horsetail", 3, nil, Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Amber Spine Seed: Missing required tools")
    end
    getgenv().ignoreBlacklist = prevIgnore
end

local function craftGrandVolcaniaSeed()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("SeedEventCraftingWorkBench")
    local WorkbenchName = "SeedEventWorkbench"
    local prevIgnore = getgenv().ignoreBlacklist
    getgenv().ignoreBlacklist = true
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Grand Volcania")
    task.wait(0.3)
    local success = true
    success = success and inputToolByName("Ember Lily", 1, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Ember Lily", 2, nil, Workbench, WorkbenchName)
    success = success and inputToolByName("Dinosaur Egg", 3, "PetEgg", Workbench, WorkbenchName)
    success = success and inputToolByName("Ancient Seed Pack", 4, "Seed Pack", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Grand Volcania Seed: Missing required tools")
    end
    getgenv().ignoreBlacklist = prevIgnore
end

local function craftPeaceLilySeed()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("SeedEventCraftingWorkBench")
    local WorkbenchName = "SeedEventWorkbench"
    local prevIgnore = getgenv().ignoreBlacklist
    getgenv().ignoreBlacklist = true
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Peace Lily")
    task.wait(0.3)
    local success = true
    success = success and inputToolByName("Rafflesia Seed", 1, "Seed", Workbench, WorkbenchName)
    success = success and inputToolByName("Cauliflower Seed", 2, "Seed", Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Peace Lily Seed: Missing required tools")
    end
    getgenv().ignoreBlacklist = prevIgnore
end

local function craftAloeVeraSeed()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("SeedEventCraftingWorkBench")
    local WorkbenchName = "SeedEventWorkbench"
    local prevIgnore = getgenv().ignoreBlacklist
    getgenv().ignoreBlacklist = true
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Aloe Vera")
    task.wait(0.3)
    local success = true
    success = success and inputToolByName("Peace Lily Seed", 1, "Seed", Workbench, WorkbenchName)
    success = success and inputToolByName("Prickly Pear", 2, nil, Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Aloe Vera Seed: Missing required tools")
    end
    getgenv().ignoreBlacklist = prevIgnore
end

local function craftGuanabanaSeed()
    getgenv().usedUUIDs = {}
    local Workbench = workspace:WaitForChild("CraftingTables"):WaitForChild("SeedEventCraftingWorkBench")
    local WorkbenchName = "SeedEventWorkbench"
    local prevIgnore = getgenv().ignoreBlacklist
    getgenv().ignoreBlacklist = true
    CraftingService:FireServer("SetRecipe", Workbench, WorkbenchName, "Guanabana")
    task.wait(0.3)
    local success = true
    success = success and inputToolByName("Aloe Vera Seed", 1, "Seed", Workbench, WorkbenchName)
    success = success and inputToolByName("Prickly Pear Seed", 2, "Seed", Workbench, WorkbenchName)
    success = success and inputToolByName("Banana", 3, nil, Workbench, WorkbenchName)
    if success then
        task.wait(0.2)
        triggerProximityPrompt(Workbench)
    else
        warn("Failed to craft Guanabana Seed: Missing required tools")
    end
    getgenv().ignoreBlacklist = prevIgnore
end

-- UI Setup
local Dropdown = Sections.Craft:AddDropdown("CraftItemDropdown", {
    Title = "Select Item Recipes",
    Values = {
        "Lightning Rod", "Reclaimer", "Tropical Mist Sprinkler", "Berry Blusher Sprinkler",
        "Sweet Soaker Sprinkler", "Flower Froster Sprinkler", "Spice Spritzer Sprinkler",
        "Stalk Sprout Sprinkler", "Mutation Spray Choc", "Mutation Spray Chilled",
        "Mutation Spray Shocked", "Anti Bee Egg", "Small Toy", "Small Treat", "Pack Bee"
    },
    Multi = false,
    Default = 1
})

local SeedDropdown = Sections.Craft:AddDropdown("SeedRecipeDropdown", {
    Title = "Select Seed Recipe",
    Values = {"Horsetail Seed", "Lingon Berry Seed", "Amber Spine Seed", "Grand Volcania Seed", "Peace Lily Seed", "Aloe Vera Seed", "Guanabana Seed"},
    Multi = false,
    Default = "Horsetail Seed"
})

local AutoCraftToggle = Sections.Craft:AddToggle("AutoCraftToggle", {
    Title = "Auto Craft Selected Item Recipes",
    Default = false
})

local AutoSeedToggle = Sections.Craft:AddToggle("AutoCraftSeedToggle", {
    Title = "Auto Craft Selected Seed Recipe",
    Default = false
})

-- Crafting loop logic
local activeLoop = false
local craftTimes = {
    ["Lightning Rod"] = 46, ["Reclaimer"] = 26, ["Tropical Mist Sprinkler"] = 61,
    ["Berry Blusher Sprinkler"] = 61, ["Spice Spritzer Sprinkler"] = 61,
    ["Flower Froster Sprinkler"] = 61, ["Stalk Sprout Sprinkler"] = 61,
    ["Sweet Soaker Sprinkler"] = 61, ["Mutation Spray Choc"] = 13,
    ["Mutation Spray Chilled"] = 6, ["Mutation Spray Shocked"] = 31,
    ["Anti Bee Egg"] = 121, ["Small Toy"] = 11, ["Small Treat"] = 11, ["Pack Bee"] = 241
}

local function stopLoop()
    activeLoop = false
end

local function startLoop(itemName, intervalMins, func)
    stopLoop()
    activeLoop = true
    coroutine.wrap(function()
        while activeLoop and AutoNormToggle.Value and Dropdown.Value == itemName do
            func()
            local waitTime = intervalMins * 60
            local startTime = tick()
            while tick() - startTime < waitTime do
                if not (activeLoop and AutoCraftToggle.Value and Dropdown.Value == itemName) then
                    break
                end
                task.wait(1)
            end
        end
    end)()
end

local function updateCraftingLoop()
    stopLoop()
    if not AutoCraftToggle.Value then return end
    local selected = Dropdown.Value
    local interval = craftTimes[selected]
    if not interval then return end

    local functionMap = {
        ["Lightning Rod"] = craftLightningRod,
        ["Reclaimer"] = craftReclaimer,
        ["Tropical Mist Sprinkler"] = craftTropicalMist,
        ["Berry Blusher Sprinkler"] = craftBerryBlusher,
        ["Sweet Soaker Sprinkler"] = craftSweetSoaker,
        ["Flower Froster Sprinkler"] = craftFlowerFroster,
        ["Spice Spritzer Sprinkler"] = craftSpiceSpritzer,
        ["Stalk Sprout Sprinkler"] = craftStalkSprout,
        ["Mutation Spray Choc"] = craftMutationSprayChoc,
        ["Mutation Spray Chilled"] = craftMutationSprayChilled,
        ["Mutation Spray Shocked"] = craftMutationSprayShocked,
        ["Anti Bee Egg"] = craftAntiBeeEgg,
        ["Small Toy"] = craftSmallToy,
        ["Small Treat"] = craftSmallTreat,
        ["Pack Bee"] = craftPackBee
    }

    local func = functionMap[selected]
    if func then
        startLoop(selected, interval, func)
    end
end

Dropdown:OnChanged(updateCraftingLoop)
AutoCraftToggle:OnChanged(updateCraftingLoop)

-- Seed crafting loop logic
local activeSeedLoop = false
local seedCraftTimes = {
    ["Horsetail Seed"] = 16,
    ["Lingon Berry Seed"] = 16,
    ["Amber Spine Seed"] = 31,
    ["Grand Volcania Seed"] = 46,
    ["Peace Lily Seed"] = 11,
    ["Aloe Vera Seed"] = 11,
    ["Guanabana Seed"] = 11
}

local function stopSeedLoop()
    activeSeedLoop = false
end

local function startSeedLoop(seedName, intervalMins, func)
    stopSeedLoop()
    activeSeedLoop = true
    coroutine.wrap(function()
        while activeSeedLoop and AutoSeedToggle.Value and SeedDropdown.Value == seedName do
            func()
            local waitTime = intervalMins * 60
            local startTime = tick()
            while tick() - startTime < waitTime do
                if not (activeSeedLoop and AutoSeedToggle.Value and SeedDropdown.Value == seedName) then
                    break
                end
                task.wait(1)
            end
        end
    end)()
end

local function updateSeedLoop()
    stopSeedLoop()
    if not AutoSeedToggle.Value then return end
    local seed = SeedDropdown.Value
    local interval = seedCraftTimes[seed]
    if not interval then return end

    local seedMap = {
        ["Horsetail Seed"] = craftHorsetailSeed,
        ["Lingon Berry Seed"] = craftLingonBerrySeed,
        ["Amber Spine Seed"] = craftAmberSpineSeed,
        ["Grand Volcania Seed"] = craftGrandVolcaniaSeed,
        ["Peace Lily Seed"] = craftPeaceLilySeed,
        ["Aloe Vera Seed"] = craftAloeVeraSeed,
        ["Guanabana Seed"] = craftGuanabanaSeed
    }

    local fn = seedMap[seed]
    if fn then
        startSeedLoop(seed, interval, fn)
    end
end

SeedDropdown:OnChanged(updateSeedLoop)
AutoSeedToggle:OnChanged(updateSeedLoop)

local Sections = { sex = Tabs.Misc:AddSection("Auto Feed") }


-- Dropdown for method selection








local Options = Fluent.Options
local AutoFeedLoopRunning = false

-- Dropdown for method selection
local MethodDropdown = Tabs.Misc:AddDropdown("ChooseMethod", {
    Title = "Choose Method",
    Values = {"Closest", "All"},
    Multi = false,
    Default = 1,
})
MethodDropdown:SetValue("Closest")

-- Toggle for auto feed
local AutoFeedToggle = Tabs.Misc:AddToggle("AutoFeed", {
    Title = "Auto Feed",
    Default = false,
})
AutoFeedToggle:SetValue(false)

-- Feeding logic
local function feedPets()
    local selected_method = Options.ChooseMethod.Value
    local replicated_storage = game:GetService("ReplicatedStorage")
    local pets = workspace:WaitForChild("PetsPhysical")
    local local_player = game:GetService("Players").LocalPlayer

    if selected_method == "Closest" then
        local pet = (function()
            local nearest, dist = nil, math.huge
            for _, v in ipairs(pets:GetChildren()) do
                if v:IsA("Part") and v:GetAttribute("OWNER") == local_player.Name then
                    local d = (v.Position - local_player.Character.PrimaryPart.Position).Magnitude
                    if d < dist then
                        nearest, dist = v, d
                    end
                end
            end
            return nearest
        end)()

        if not pet then
            Fluent:Notify({Title = "Pet Feeder", Content = "No Pets Found", Duration = 6})
            return
        end

        replicated_storage:WaitForChild("GameEvents"):WaitForChild("ActivePetService"):FireServer("Feed", pet:GetAttribute("UUID"))
        Fluent:Notify({Title = "Pet Feeder", Content = "Done Feeding Pet", Duration = 3})
        return
    end

    if selected_method == "All" then
        for _, v in ipairs(pets:GetChildren()) do
            if v:IsA("Part") and v:GetAttribute("OWNER") == local_player.Name and v:GetAttribute("UUID") then
                replicated_storage:WaitForChild("GameEvents"):WaitForChild("ActivePetService"):FireServer("Feed", v:GetAttribute("UUID"))
            end
        end
        Fluent:Notify({Title = "Pet Feeder", Content = "Done Feeding Pets", Duration = 0})
        return
    end
end

-- Auto feed toggle logic
Options.AutoFeed:OnChanged(function(state)
    if state and not AutoFeedLoopRunning then
        AutoFeedLoopRunning = true
        task.spawn(function()
            while Options.AutoFeed.Value do
                pcall(feedPets)
                task.wait(1)
            end
            AutoFeedLoopRunning = false
        end)
    end
end)

local Sections = { fs = Tabs.Misc:AddSection("Anhtoers") }

-- تنظیم Toggle در UI


local HideNotificationsToggle = MiscTab:AddToggle("HideNotifications", {
    Title = "Hide Notifications",
    Default = false,
    Callback = function(value)
        local player = game:GetService("Players").LocalPlayer
        local frame = player:WaitForChild("PlayerGui"):WaitForChild("Top_Notification"):WaitForChild("Frame")
        frame.Visible = not value
    end
})



local hasFixLagBeenClicked = false
local FixLagButton = Tabs.Misc:AddButton({
    Title = "Fix Lag Cannot Be Turned Off",
    Description = "Runs a lag reduction script once. Cannot be clicked again.",
    Callback = function()
        if not hasFixLagBeenClicked then
            hasFixLagBeenClicked = true
            pcall(function()
                loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fix-lag-all-game-24449"))()
                Fluent:Notify({
                    Title = "Grow a garden - Summer Event",
                    Content = "Lag fix script executed!",
                    Duration = 5
                })
            end)
        else
            Fluent:Notify({
                Title = "Grow a garden - Summer Event",
                Content = "Lag fix script can only be run once!",
                Duration = 5
            })
        end
    end
})
d

-- Ability Tab Content
local flyEnabled = false
local flySpeed = 48
local bodyVelocity, bodyGyro
local flightConnection

local function Fly(state)
    flyEnabled = state
    if flyEnabled then
        local character = lp.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        bodyGyro = Instance.new("BodyGyro")
        bodyVelocity = Instance.new("BodyVelocity")
        bodyGyro.P = 9000
        bodyGyro.MaxTorque = Vector3.new(999999, 999999, 999999)
        bodyGyro.CFrame = character.HumanoidRootPart.CFrame
        bodyGyro.Parent = character.HumanoidRootPart

        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(999999, 999999, 999999)
        bodyVelocity.Parent = character.HumanoidRootPart

        humanoid.PlatformStand = true

        flightConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled or not character:FindFirstChild("HumanoidRootPart") then
                if flightConnection then flightConnection:Disconnect() end
                return
            end

            local cam = workspace.CurrentCamera.CFrame
            local moveVec = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVec += cam.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVec -= cam.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVec -= cam.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVec += cam.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVec += Vector3.new(0, flySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVec -= Vector3.new(0, flySpeed, 0)
            end

            if moveVec.Magnitude > 0 then
                moveVec = moveVec.Unit * flySpeed
            end

            bodyVelocity.Velocity = moveVec
            bodyGyro.CFrame = cam
        end)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end

        local character = lp.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end

        if flightConnection then
            flightConnection:Disconnect()
            flightConnection = nil
        end
    end
end

Tabs.Ability:AddToggle("FlyToggle", {
    Title = "Fly",
    Default = false,
    Callback = function(state)
        Fly(state)
    end
})

local noclipEnabled = false
local noclipConn = nil
local char = lp.Character
local infJumpConn

local function ToggleNoclip(state)
    noclipEnabled = state
    if noclipEnabled and not noclipConn then
        noclipConn = RunService.Stepped:Connect(function()
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    elseif not noclipEnabled and noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
end

local infJumpEnabled = false

local function ToggleInfJump(state)
    infJumpEnabled = state
end

if not infJumpConn then
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled and char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local NoClipToggle = Tabs.Ability:AddToggle("NoClipToggle", {
    Title = "NoClip",
    Default = false
})

NoClipToggle:OnChanged(function(state)
    ToggleNoclip(state)
end)

local InfJumpToggle = Tabs.Ability:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump",
    Default = false
})

InfJumpToggle:OnChanged(function(state)
    ToggleInfJump(state)
end)


-- Shops Tab Content
local SeedShopToggle = Tabs.Shops:AddToggle("SeedShopToggle", {
    Title = "Seed Shop",
    Default = false
})

SeedShopToggle:OnChanged(function(state)
    local shop = lp.PlayerGui:FindFirstChild("Seed_Shop")
    if shop then
        shop.Enabled = state
    end
end)

local GearShopToggle = Tabs.Shops:AddToggle("GearShopToggle", {
    Title = "Gear Shop",
    Default = false
})

GearShopToggle:OnChanged(function(state)
    local gear = lp.PlayerGui:FindFirstChild("Gear_Shop")
    if gear then
        gear.Enabled = state
    end
end)



local QuestToggle = Tabs.Shops:AddToggle("QuestToggle", {
    Title = "Daily Quest",
    Default = false
})

QuestToggle:OnChanged(function(state)
    local quest = lp.PlayerGui:FindFirstChild("DailyQuests_UI")
    if quest then
        quest.Enabled = state
    end
end)

local OneClickRemoveToggle = Tabs.Shops:AddToggle("OneClickRemoveToggle", {
    Title = "Destroy plant",
    Default = false
})

local enabled = false

local function OneClickRemove(state)
    enabled = state
    local confirmFrame = Players.LocalPlayer.PlayerGui:FindFirstChild("ShovelPrompt")
    if confirmFrame and confirmFrame:FindFirstChild("ConfirmFrame") then
        confirmFrame.ConfirmFrame.Visible = not state
    end
end

OneClickRemoveToggle:OnChanged(function(state)
    OneClickRemove(state)
end)

-- Events Tab Content
-- Auto Harvest V2 Toggle with speed input support
local AutoSendPetsToggle = Tabs.Events:AddToggle("AutoSendPets", {
    Title = "Auto Send Pets",
    Description = "Auto sends dna.",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while Fluent.Options.AutoSendPets.Value do
                    local args = {
                        "MachineInteract"
                    }
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("GameEvents")
                        :WaitForChild("DinoMachineService_RE")
                        :FireServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})
        

local AutoSubmitToggle = Tabs.Events:AddToggle("AutoSubmitSummerFruit", {
    Title = "Auto Claims",
    Description = "Automatically claims dna.",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while Fluent.Options.AutoSubmitSummerFruit.Value do
                    local args = {
                        "ClaimReward"
                    }
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("GameEvents")
                        :WaitForChild("DinoMachineService_RE")
                        :FireServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})
-- Input Field for Submit Fruit Interval (Main Tab)

local Sections = { Dino = Tabs.Events:AddSection("Auto Dino Recipes") }

local CraftingService = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("CraftingGlobalObjectService")
local player = game.Players.LocalPlayer
getgenv().usedUUIDs = getgenv().usedUUIDs or {}

local DinoWorkbench = workspace:WaitForChild("DinoEvent"):WaitForChild("DinoCraftingTable")

local function inputToolByName(name, index, itemType)
	itemType = itemType or "Holdable"
	local backpack = player:WaitForChild("Backpack")
	local function stripCount(toolName)
		local baseName = toolName:match("^(.-)%s*x%d+$")
		return baseName or toolName
	end
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") then
			if getgenv().ignoreBlacklist ~= true then
				local nameLower = tool.Name:lower()
				if nameLower:find("seed") or nameLower:find("Niggers") then
					continue
				end
			end
			local matched = false
			if getgenv().ExactToolMatch == true then
				matched = (stripCount(tool.Name) == name)
			else
				matched = tool.Name:find(name)
			end
			local uuid = tool:GetAttribute("c")
			if matched and uuid and not table.find(getgenv().usedUUIDs, uuid) then
				CraftingService:FireServer("InputItem", DinoWorkbench, "DinoEventWorkbench", index, {
					ItemType = itemType,
					ItemData = { UUID = uuid }
				})
				table.insert(getgenv().usedUUIDs, uuid)
				task.wait(0.2)
				break
			end
		end
	end
end

local function fireAllDinoEventProximityPrompts()
	task.delay(1, function()
		for _, p in ipairs(workspace:WaitForChild("DinoEvent"):GetDescendants()) do
			if p:IsA("ProximityPrompt") and p.Name == "CraftingProximityPrompt" and p.Parent:IsA("Part") and p.Parent.Name == "TableTop" then
				local original = p.MaxActivationDistance
				p.MaxActivationDistance = 9999
				fireproximityprompt(p)
				task.delay(1, function()
					fireproximityprompt(p)
					task.delay(0.2, function()
						p.MaxActivationDistance = original
					end)
				end)
				return
			end
		end
	end)
end

-- Craft functions
local function craftMutationSprayAmber()
	getgenv().usedUUIDs = {}
	CraftingService:FireServer("SetRecipe", DinoWorkbench, "DinoEventWorkbench", "Mutation Spray Amber")
	task.wait(0.3)
	inputToolByName("Cleaning Spray", 1, "SprayBottle")
	inputToolByName("Dinosaur Egg", 2, "PetEgg")
	task.wait(1)
	fireAllDinoEventProximityPrompts()
end

local function craftAncientSeedPack()
	getgenv().usedUUIDs = {}
	CraftingService:FireServer("SetRecipe", DinoWorkbench, "DinoEventWorkbench", "Ancient Seed Pack")
	task.wait(0.3)
	inputToolByName("Dinosaur Egg", 1, "PetEgg")
	task.wait(1)
	fireAllDinoEventProximityPrompts()
end

local function craftDinoCrate()
	getgenv().usedUUIDs = {}
	CraftingService:FireServer("SetRecipe", DinoWorkbench, "DinoEventWorkbench", "Dino Crate")
	task.wait(0.3)
	inputToolByName("Dinosaur Egg", 1, "PetEgg")
	task.wait(1)
	fireAllDinoEventProximityPrompts()
end

local function craftArchaeologistCrate()
	getgenv().usedUUIDs = {}
	CraftingService:FireServer("SetRecipe", DinoWorkbench, "DinoEventWorkbench", "Archaeologist Crate")
	task.wait(0.3)
	inputToolByName("Dinosaur Egg", 1, "PetEgg")
	task.wait(1)
	fireAllDinoEventProximityPrompts()
end

-- GUI Dropdown + Toggle
local selectedEventRecipe = nil
local eventDropdown = Sections.Dino:AddDropdown("DinoRecipeDropdown", {
	Title = "Select Event Item",
	Values = { "Mutation Spray Amber", "Ancient Seed Pack", "Dino Crate", "Archaeologist Crate" },
	Multi = false,
	Default = "Mutation Spray Amber",
	Callback = function(value)
		selectedEventRecipe = value
	end
})

local AutoDinoToggle = Sections.Dino:AddToggle("AutoCraftDinoToggle", {
	Title = "Auto Craft Selected Event Items",
	Default = false,
	Callback = function(enabled)
		if enabled then
			startDinoCraftingLoop()
		end
	end
})

local dinoTimers = {
	["Mutation Spray Amber"] = 61,
	["Ancient Seed Pack"] = 61,
	["Dino Crate"] = 31,
	["Archaeologist Crate"] = 31,
}

local dinoFunctions = {
	["Mutation Spray Amber"] = craftMutationSprayAmber,
	["Ancient Seed Pack"] = craftAncientSeedPack,
	["Dino Crate"] = craftDinoCrate,
	["Archaeologist Crate"] = craftArchaeologistCrate,
}

local craftingLoopActive = false
function startDinoCraftingLoop()
	if craftingLoopActive then return end
	craftingLoopActive = true
	task.spawn(function()
		while craftingLoopActive and AutoDinoToggle.Value do
			local selected = eventDropdown.Value
			local func = dinoFunctions[selected]
			local delayMins = dinoTimers[selected]
			if func and delayMins then
				func()
				for i = 1, delayMins * 60 do
					if not craftingLoopActive or not AutoDinoToggle.Value or eventDropdown.Value ~= selected then
						break
					end
					task.wait(1)
				end
			else
				break
			end
		end
		craftingLoopActive = false
	end)
end

AutoDinoToggle:OnChanged(function(enabled)
	if not enabled then
		craftingLoopActive = false
	end
end)

eventDropdown:OnChanged(function()
	if AutoDinoToggle.Value then
		craftingLoopActive = false
		task.wait(0.2)
		startDinoCraftingLoop()
	end
end)


-- Guis Tab Content
local EventGuiToggle = Tabs.Guis:AddToggle("EventGuiToggle", {
    Title = "TP to Event GUI",
    Description = "Shows/hides the TP to Event button.",
    Default = false,
    Callback = function(value)
        local player = game:GetService("Players").LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")
        if value then
            if not playerGui:FindFirstChild("EventGui") then
                local screenGui = Instance.new("ScreenGui")
                screenGui.Name = "EventGui"
                screenGui.ResetOnSpawn = false
                screenGui.Parent = playerGui

                local tpButton = Instance.new("ImageButton")
                tpButton.Name = "TPToEventButton"
                tpButton.Size = UDim2.new(0, 160, 0, 30)
                tpButton.Position = UDim2.new(0.5, -80, 0, -35)
                tpButton.BackgroundColor3 = Color3.fromRGB(255, 230, 80)
                tpButton.Image = "rbxassetid://9438453826"
                tpButton.ScaleType = Enum.ScaleType.Slice
                tpButton.SliceCenter = Rect.new(8, 8, 56, 56)
                tpButton.SliceScale = 0.5
                tpButton.AutoButtonColor = false
                tpButton.Parent = screenGui

                local corner = Instance.new("UICorner", tpButton)
                corner.CornerRadius = UDim.new(0, 10)

                local shadow = Instance.new("UIStroke", tpButton)
                shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                shadow.Thickness = 4
                shadow.Color = Color3.new(0, 0, 0)
                shadow.Transparency = 0.75

                local glow = Instance.new("UIStroke", tpButton)
                glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                glow.Thickness = 1
                glow.Color = Color3.fromRGB(255, 255, 150)
                glow.Transparency = 0.3

                local label = Instance.new("TextLabel")
                label.Parent = tpButton
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "TP to Event"
                label.Font = Enum.Font.FredokaOne
                label.TextScaled = true
                label.TextColor3 = Color3.fromRGB(25, 25, 25)
                label.TextStrokeTransparency = 0.3
                label.TextStrokeColor3 = Color3.new(1, 1, 1)

                local defaultColor = tpButton.BackgroundColor3
                local hoverColor = Color3.fromRGB(255, 250, 130)

                tpButton.MouseEnter:Connect(function()
                    TweenService:Create(tpButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = hoverColor
                    }):Play()
                end)

                tpButton.MouseLeave:Connect(function()
                    TweenService:Create(tpButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = defaultColor
                    }):Play()
                end)

                tpButton.MouseButton1Click:Connect(function()
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")
                    local destination = Vector3.new(-104.11, 0.9, -12.10)
                    hrp.CFrame = CFrame.new(destination)
                end)
            end
        else
            local existingGui = playerGui:FindFirstChild("EventGui")
            if existingGui then
                existingGui:Destroy()
            end
        end
    end
})

local GearButtonToggle = Tabs.Guis:AddToggle("GearButtonToggle", {
    Title = "Gear Button",
    Default = false,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")
        task.wait(0.1) -- Small delay to ensure PlayerGui is ready

        if value then
            if not playerGui:FindFirstChild("GearGui") then
                local gui = Instance.new("ScreenGui")
                gui.Name = "GearGui"
                gui.ResetOnSpawn = false
                gui.IgnoreGuiInset = false
                gui.Parent = playerGui

                local button = Instance.new("TextButton")
                button.Name = "GearButton"
                button.Text = "GEAR"
                button.TextSize = 17
                button.Font = Enum.Font.GothamBold
                button.Size = UDim2.new(0, 60, 0, 28)
                button.Position = UDim2.new(0.26, 0, 0.024, 0)
                button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                button.TextColor3 = Color3.new(1, 1, 1)
                button.BorderSizePixel = 0
                button.AutoButtonColor = true
                button.Parent = gui

                local uistroke = Instance.new("UIStroke")
                uistroke.Thickness = 1
                uistroke.Color = Color3.fromRGB(0, 120, 0)
                uistroke.Parent = button

                local targetPosition = Vector3.new(-285.41, 2.77, -13.98)
                local lookDirection = Vector3.new(-285.41, 2.77, -20)

                button.MouseButton1Click:Connect(function()
                    local character = player.Character or player.CharacterAdded:Wait()
                    local hrp = character:WaitForChild("HumanoidRootPart")
                    hrp.CFrame = CFrame.lookAt(targetPosition, lookDirection)
                end)
            end
        else
            local existingGui = playerGui:FindFirstChild("GearGui")
            if existingGui then
                existingGui:Destroy()
            end
        end
    end
})

-- Esp Tab Content
Tabs.Esp:AddParagraph({
        Title = "will by added soon",
        Content = "Empty for now!"
    })
  
  
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Moondiety")
SaveManager:SetFolder("Moondiety/grow_a_garden")
InterfaceManager:BuildInterfaceSection(Tabs.settings)
SaveManager:BuildConfigSection(Tabs.settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Moondiety Grow a garden",
    Content = "Moondiety hub has been loaded successfully!.",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()

local player = game:GetService("Players").LocalPlayer
repeat wait() until player:FindFirstChild("PlayerGui")

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Create ScreenGui for the button
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DraggableClickableImageGui"
screenGui.Parent = CoreGui

local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0, 50, 0, 50)
imageButton.Position = UDim2.new(0, 10, 1, -160)
imageButton.BackgroundTransparency = 1
imageButton.Image = "rbxassetid://133495621202705"
imageButton.Parent = screenGui
imageButton.Active = true
imageButton.Selectable = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = imageButton

local uiScale = Instance.new("UIScale")
uiScale.Parent = imageButton

local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local hoverTween = TweenService:Create(uiScale, tweenInfo, { Scale = 1.1 })
local leaveTween = TweenService:Create(uiScale, tweenInfo, { Scale = 1 })

imageButton.MouseEnter:Connect(function()
    hoverTween:Play()
end)

imageButton.MouseLeave:Connect(function()
    leaveTween:Play()
end)

-- Drag and toggle logic with animated movement
local dragging = false
local dragStart, startPos, dragInput
local clickThreshold = 10

-- Smooth flicker effect function
local function playFlickerOnce()
    task.spawn(function()
        imageButton.ImageTransparency = 0.2
        task.wait(0.15)
        imageButton.ImageTransparency = 0.6
        task.wait(0.15)

        local fadeTween = TweenService:Create(imageButton, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            ImageTransparency = 0
        })
        fadeTween:Play()
    end)
end

-- Function to check for target ScreenGui
local function findTargetScreenGui()
    return CoreGui:FindFirstChild("ScreenGui")
end

-- Function to toggle visibility of frames
local function toggleFrames()
    local targetScreenGui = findTargetScreenGui()
    if targetScreenGui then
        for _, obj in ipairs(targetScreenGui:GetChildren()) do
            if obj:IsA("Frame") and obj.Name == "Frame" then
                local size = obj.Size
                if size.X.Scale == 0 and size.Y.Scale == 0 then
                    if size.X.Offset >= 470 and size.Y.Offset >= 380 then
                        obj.Visible = not obj.Visible
                    end
                end
            end
        end
    end
end

imageButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = imageButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                local moved = (input.Position - dragStart).Magnitude
                if moved < clickThreshold then
                    playFlickerOnce()  -- Run flicker effect on click
                    toggleFrames()     -- Toggle visibility of frames
                end
            end
        end)
    end
end)

imageButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

        local moveTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local moveTween = TweenService:Create(imageButton, moveTweenInfo, { Position = newPosition })
        moveTween:Play()
    end
end)

-- Logic to check for ScreenGui every second and destroy if it disappears
local function monitorScreenGui()
    local wasFound = false
    while true do
        local targetScreenGui = findTargetScreenGui()
        if targetScreenGui then
            wasFound = true  -- Mark that ScreenGui was found at least once
        elseif wasFound then
            -- If ScreenGui was previously found but is now gone, destroy the button
            screenGui:Destroy()
            return
        end
        task.wait(1)  -- Check every second
    end
end

-- Start monitoring the ScreenGui
task.spawn(monitorScreenGui)