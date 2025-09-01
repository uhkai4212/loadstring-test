local Library = loadstring(game:HttpGet("https://pastefy.app/IEsfnVtX/raw"))()

local Window = Library:CreateWindow("Dinas Hub")
local Tab1 = Window:AddTab("Main")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local collectdiamonds = ReplicatedStorage:WaitForChild("rbxts_include")
    :WaitForChild("node_modules")
    :WaitForChild("@rbxts")
    :WaitForChild("remo")
    :WaitForChild("src")
    :WaitForChild("container")
    :WaitForChild("collect.diamonds")

local collectdrops = ReplicatedStorage.rbxts_include.node_modules["@rbxts"].remo.src.container["collect.drops"]
local processorupgrade = ReplicatedStorage.rbxts_include.node_modules["@rbxts"].remo.src.container["processor.upgrade"]

local rebirth = ReplicatedStorage:WaitForChild("rbxts_include")
    :WaitForChild("node_modules")
    :WaitForChild("@rbxts")
    :WaitForChild("remo")
    :WaitForChild("src")
    :WaitForChild("container")
    :WaitForChild("rebirth")

local enabledDiamonds = false
local enabledDrops = false
local enabledProcessorUpgrade = false
local enabledAutoRebirth = false

-- You can change number
local diamondAmount = 99999999999999

local function collectDiamonds(amount)
    local args = {amount}
    collectdiamonds:FireServer(unpack(args))
end

Tab1:AddLabel({
    Text = "Infinity Mod!",
    Size = 18,
    Color = Color3.new(1, 0.5, 0),
    Center = true,
    Stroke = true
})

Tab1:AddToggle({
    Text = "Collect Diamonds(Inf)",
    Default = false,
    Callback = function(value)
        enabledDiamonds = value
        if enabledDiamonds then
            spawn(function()
                while enabledDiamonds do
                    collectDiamonds(diamondAmount)
                    wait(0.1)
                end
            end)
        end
    end,
})

Tab1:AddToggle({
    Text = "Collect Drops(Inf)",
    Default = false,
    Callback = function(value)
        enabledDrops = value
        if enabledDrops then
            spawn(function()
                while enabledDrops do
                    collectdrops:FireServer({
                        RedSand = 99999999999999,
                        Dirt = 9,
                        Cobblestone = 9
                    })
                    wait(0.1)
                end
            end)
        end
    end,
})

Tab1:AddToggle({
    Text = "Processor Upgrade",
    Default = false,
    Callback = function(value)
        enabledProcessorUpgrade = value
        if enabledProcessorUpgrade then
            spawn(function()
                while enabledProcessorUpgrade do
                    processorupgrade:InvokeServer()
                    wait(0.1)
                end
            end)
        end
    end,
})

Tab1:AddToggle({
    Text = "Auto Rebirth",
    Default = false,
    Callback = function(value)
        enabledAutoRebirth = value
        if enabledAutoRebirth then
            spawn(function()
                while enabledAutoRebirth do
                    rebirth:InvokeServer()
                    wait(0.1)
                end
            end)
        end
    end,
})