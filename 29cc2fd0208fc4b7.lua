local player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local R_Server = RS:WaitForChild("R_Server")
local R_Pets = RS:WaitForChild("R_Pets")
local B_Client = RS:WaitForChild("B_Cilent")

local gamepasses = {
    {id=1317699134, display="x2 Coins"},
    {id=1318193583, display="x2 Speed"},
    {id=1318271434, display="VIP Rank"},
    {id=1318135522, display="More Storages"},
    {id=1318755432, display="More Equip"},
    {id=1372082781, display="Super Auto"}
}

local pets = {
    "Bombini_Guzzini_BloodMoon","Cappuccino_Assassino_BloodMoon","Pet_Alien",
    "Pet_Angel","Pet_Arctic","Pet_Baby_Tralalero_Diamond","Pet_Baby_Tralalero_Golden",
    "Pet_Blue","Pet_Boku","Pet_Boshiro","Pet_Bot","Pet_Cake","Pet_Camelo",
    "Pet_Cappuccino_Diamond","Pet_Cappuccino_Golden","Pet_Capybara_Kiwini","Pet_Cat",
    "Pet_Cat_Legendary","Pet_Celestial","Pet_Chef_Crabracadabra","Pet_Chicken",
    "Pet_Chimpanzini_Bananini","Pet_ClownDog","Pet_Cocofanto_Elefanto","Pet_Cold_Dragon",
    "Pet_Crab_Pixel","Pet_D.Dark","Pet_Dark_Boshiro","Pet_Desert_Bunny","Pet_Desert_Dragon",
    "Pet_Desert_Spider","Pet_Desert_Stegosaurus","Pet_Desert_Tiger","Pet_Dog","Pet_Duck",
    "Pet_EasterIce","Pet_Frozen","Pet_GolemHydra","Pet_Honey_Alien","Pet_Honey_Bunny",
    "Pet_Honey_Huge","Pet_Honey_Kitten","Pet_Honey_Mutant","Pet_Husky","Pet_Ice_Alien",
    "Pet_Ice_Dragon","Pet_Ice_Frost","Pet_Justice","Pet_Kingdom","Pet_Knight","Pet_Knight_V",
    "Pet_Magic_Snow","Pet_Mystery_Cat","Pet_Parrot","Pet_Patapim","Pet_Peak","Pet_Pianta",
    "Pet_Pixel_Dark","Pet_Pixel_Drake","Pet_Pixel_Null","Pet_Pixel_Purple","Pet_Poseidon",
    "Pet_Punk","Pet_Pure","Pet_Puzzel","Pet_Rasta","Pet_Red_Dominus","Pet_Reniamru",
    "Pet_Rhino_Toasterino","Pet_Roro","Pet_Snow_Golem","Pet_Snow_Wolf","Pet_Snow_Yeti",
    "Pet_SuperClown","Pet_Suprise_Dog","Pet_Sweet_Axolotl","Pet_Thor","Pet_Tralalero_Tralala",
    "Pet_TungSahur","Pet_Ultra_Capybara","Pet_Volcano","Pet_Warrior","Pet_Zeus",
    "Tralalero_Tralala_BloodMoon","Tung_Tung_Sahur_BloodMoon"
}

local gui = Instance.new("ScreenGui")
gui.Name = "CustomGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,240,0,180)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Thickness = 2

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Climb and Slide"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

local container = Instance.new("Frame")
container.Size = UDim2.new(1,0,1,-30)
container.Position = UDim2.new(0,0,0,30)
container.BackgroundTransparency = 1
container.Parent = frame

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = text
    btn.Parent = container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    btn.MouseButton1Click:Connect(callback)
end

createButton("Get All Gamepasses", function()
    for _, gp in ipairs(gamepasses) do
        R_Server:FireServer("Gamepass_Buy", gp.id)
    end
end)

createButton("Get All Pets", function()
    for _, pet in ipairs(pets) do
        R_Pets:FireServer("Give_Pet", pet)
    end
end)

local cashActive = false
local cashConn

local cashButton = Instance.new("TextButton")
cashButton.Size = UDim2.new(0.9,0,0,40)
cashButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
cashButton.TextColor3 = Color3.fromRGB(255,255,255)
cashButton.Font = Enum.Font.GothamBold
cashButton.TextScaled = true
cashButton.Text = "Start Inf Cash"
cashButton.Parent = container
Instance.new("UICorner", cashButton).CornerRadius = UDim.new(0,8)

cashButton.MouseButton1Click:Connect(function()
    cashActive = not cashActive
    cashButton.Text = cashActive and "Stop Inf Cash" or "Start Inf Cash"

    if cashActive then
        cashConn = game:GetService("RunService").Stepped:Connect(function()
            B_Client:Fire("Split_Money", 9.999173301558694e+99, 7)
        end)
    else
        if cashConn then
            cashConn:Disconnect()
        end
    end
end)


local minimized = false
game:GetService("UserInputService").InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        minimized = not minimized
        frame.Visible = not minimized
    end
end)