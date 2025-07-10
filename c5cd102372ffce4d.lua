local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local Window = Library:NewWindow("Spawn Cars")
 
local Tab = Window:NewSection("Credits: TGMANKASKE")
 
Tab:CreateButton("Get BEST CAR", function()
print("HI")

local args = {
	"Futuristic Supercar"
}
game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("AddVehicleToBase"):FireServer(unpack(args))

end)


local Tab = Window:NewSection("Links")
 
Tab:CreateButton("Discord Group", function()
print("HI")
 
setclipboard("https://discord.gg/8A6k73JqCM")
toclipboard("https://discord.gg/8A6k73JqCM")
 
end)
 
Tab:CreateButton("Youtube", function()
print("HI")
 
setclipboard("https://www.youtube.com/@TGMANKASKE")
toclipboard("https://www.youtube.com/@TGMANKASKE")
 
end)