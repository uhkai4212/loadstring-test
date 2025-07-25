local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/hoho_lib.lua", true))()
local win = lib:Window("Pepsi Cat Hub", "Noob Must dead", Color3.new(0.333333, 0.666667, 1))

local tab = win:Tab("Kill Noobs")
local tab2 = win:Tab("Items")
local tab3 = win:Tab("Other")
local tab4 = win:Tab("Credit")
local tab5 = win:Tab("Roles")

tab5:Line()


local S = nil

spawn(function()
    while wait(T) do
        if e then
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:IsA("Model") then
                    game:GetService("ReplicatedStorage").HurtEnemy:FireServer(enemy, 900000)
                end
            end
        end
    end
end)

tab:Line()

tab:Toggle("Auto Kill All Noobs", false, function(val)
    e = val
end)

tab:Button("Kill All Noobs", function()
for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:IsA("Model") then
                    game:GetService("ReplicatedStorage").HurtEnemy:FireServer(enemy, 900000)
                end
            end
end)

tab:Textbox("Delay", "Number", function(val)
    T = tonumber(val) or 1
end)

tab:Line()

local Ga = {}
local Ga2 = {}

for _, item in ipairs(game:GetService("ReplicatedStorage").PlrMan.Items:GetChildren()) do
    if item:IsA("Part") then
        table.insert(Ga, item.Name)
    end
end

for _, ns in ipairs(game:GetService("ReplicatedStorage").Fighters:GetChildren()) do
table.insert(Ga2, ns.Name)
end

local Lbajs = tab5:Label("Pls rejoin")

tab5:Dropdown("Selected", Ga2, function(val)
Fa = tostring(val)
end)

tab5:Button("Select Role", function()
local args = {
	Fa
}
game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenUI"):WaitForChild("SetActiveFighter"):FireServer(unpack(args))
end)

tab2:Line()
tab2:Dropdown("Selected", Ga, function(val)
    S = tostring(val)
end)

tab2:Button("Get", function()
    if S then
        game:GetService("ReplicatedStorage").PlrMan.Items.PickupItem:FireServer(S)
    end
end)

spawn(function()
    while wait(N) do
        if o and S then
            game:GetService("ReplicatedStorage").PlrMan.Items.PickupItem:FireServer(S)
        end
    end
end)

spawn(function()
   while wait(0) do
     if co then
     for i = 1, 3 do
     game:GetService("ReplicatedStorage").PlrMan.Items.PickupItem:FireServer(S)
     end
     end
  end
end)

tab2:Line()

tab2:Toggle("Auto Get", false, function(val)
    o = val
end)

tab2:Textbox("Delay", "Number", function(val)
    N = tonumber(val) or 1
end)

tab2:Line()

tab2:Toggle("Fast Auto Get", false, function(bool)
co = bool
end)

tab2:Line()

tab3:Textbox("Select eat burger", "Number", function(bool)
p = tonumber(bool)
end)

tab3:Button("Eat select burgers", function()
for i = 1, p do
    game:GetService("ReplicatedStorage").PlrMan.Items.PickupItem:FireServer("Chezburger")
end
end)

tab3:Line()

tab3:Button("be invulnerable", function()
for i = 1, 100 do
game:GetService("ReplicatedStorage").PlrMan.Items.PickupItem:FireServer("RegenCoil")
game:GetService("ReplicatedStorage").PlrMan.Items.PickupItem:FireServer("Cake")
game:GetService("ReplicatedStorage").PlrMan.Items.PickupItem:FireServer("Armor")
end
end)

tab3:Line()

tab4:Line()
local label = tab4:Label("Created By Кола Комару Скирпт", properties)

local label = tab4:Label("wwls", properties)
tab4:Line()