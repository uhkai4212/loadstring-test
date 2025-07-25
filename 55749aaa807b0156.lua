local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local Window = Library:NewWindow("Script")
 
local Tab = Window:NewSection("Credits: TGMANKASKE")
 
Tab:CreateButton("Upgrade Money", function()
print("HI")

local args = {
	0
}
workspace:WaitForChild("Events"):WaitForChild("UpgradeMultiplier"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

end)

Tab:CreateButton("Inf. Rebirth", function()
print("HI")

local args = {
	999,
	0
}
workspace:WaitForChild("Events"):WaitForChild("UpgradeRebirth"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

end)

Tab:CreateToggle("Inf. Money", function(no)
_G.GetWins = no
while _G.GetWins== true do
    wait()

local args = {
	10000,
	-5481234172846274
}
workspace:WaitForChild("Events"):WaitForChild("UpgradeSpeed"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

end
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