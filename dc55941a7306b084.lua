local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local Window = Library:NewWindow("Script")
 
local Tab = Window:NewSection("Credits: TGMANKASKE")
 
Tab:CreateButton("Get BEST Upgrade", function()
print("HI")

local args = {
	"Cosmify",
	0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))

end)

Tab:CreateButton("Get BEST Drill", function()
print("HI")

local args = {
	"Laser Drill",
	-0
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))

end)

Tab:CreateButton("Inf. Money", function()
print("HI")

local args = {
	"Thx for using my script",
	-9999999999999
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy"):FireServer(unpack(args))

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