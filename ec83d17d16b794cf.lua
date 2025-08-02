local function C_50()
local script = DELTA["50"];
local textbox = script.Parent.Parent.Searchbar.Input

local uilib = require(script.Parent.Parent.Parent.UILibrary)

makefolder("ImageCache")


textbox.FocusLost:Connect(function()
    for i,v in pairs(script.Parent:GetChildren()) do
    if v:IsA("ImageButton") then
    v:Destroy()
    end
    end
--print"Searching"
    local KeyWordSearch = textbox.Text
    local url = "https://scriptblox.com/api/script/search?q="..string.gsub(KeyWordSearch, " ", "%%20")
    local response = game:HttpGetAsync(url)
    local http = game:GetService("HttpService")
    local decoded = http:JSONDecode(response)
    for _, script in pairs(decoded.result.scripts) do
    --print"found"
    if script.scriptType == "free" and script.isPatched == false then
    if (script.isUniversal == true) then
    local random = math.random(0, 10000)
    local randomname = "ImageCache/image"..tostring(random)..".png"
    pcall(function()