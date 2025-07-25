local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()

local imageURL = "https://files.catbox.moe/n90d8q.jpg"
local imagePixels = {}
local isAutoDrawing = false
local drawIndex = 1
local startX, startY = 0, 0
local imageWidth = 100
local imageHeight = 100

local function downloadAndProcessImage()
    local success, imageData = pcall(function()
        return HttpService:GetAsync(imageURL)
    end)
    
    if not success then
        return createFallbackPattern()
    end
    
    return processImageData(imageData)
end

local function processImageData(data)
    local pixels = {}
    local lines = {}
    
    for line in data:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    
    for y = 1, math.min(#lines, imageHeight) do
        for x = 1, math.min(#lines[y], imageWidth) do
            local char = lines[y]:sub(x, x)
            if char and char ~= " " and char ~= "" then
                table.insert(pixels, {
                    x = x,
                    y = y,
                    draw = true
                })
            end
        end
    end
    
    return pixels
end

local function createFallbackPattern()
    local pixels = {}
    
    local text = {
        "  ████████  ",
        " ██      ██ ",
        "██  ████  ██",
        "██ ██  ██ ██",
        "██  ████  ██",
        " ██      ██ ",
        "  ████████  "
    }
    
    for y, line in ipairs(text) do
        for x = 1, #line do
            local char = line:sub(x, x)
            if char == "█" then
                table.insert(pixels, {
                    x = x * 3,
                    y = y * 3,
                    draw = true
                })
            end
        end
    end
    
    return pixels
end

local function simulateMouseMove(x, y)
    mousemoveabs(x, y)
end

local function simulateMouseDown()
    mouse1press()
end

local function simulateMouseUp()
    mouse1release()
end

local function startAutoDrawing(mouseX, mouseY)
    if isAutoDrawing then return end
    
    isAutoDrawing = true
    drawIndex = 1
    startX = mouseX
    startY = mouseY
    
    if #imagePixels == 0 then
        imagePixels = downloadAndProcessImage()
    end
    
    spawn(function()
        simulateMouseDown()
        wait(0.1)
        
        while isAutoDrawing and drawIndex <= #imagePixels do
            local pixel = imagePixels[drawIndex]
            
            if pixel and pixel.draw then
                local screenX = startX + pixel.x - (imageWidth / 2)
                local screenY = startY + pixel.y - (imageHeight / 2)
                
                simulateMouseMove(screenX, screenY)
                wait(0.005)
            end
            
            drawIndex = drawIndex + 1
        end
        
        simulateMouseUp()
        isAutoDrawing = false
    end)
end

local function stopAutoDrawing()
    isAutoDrawing = false
    simulateMouseUp()
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if not isAutoDrawing then
            local mouseX = Mouse.X
            local mouseY = Mouse.Y
            startAutoDrawing(mouseX, mouseY)
        end
    end
    
    if input.KeyCode == Enum.KeyCode.Q then
        stopAutoDrawing()
    end
    
    if input.KeyCode == Enum.KeyCode.R then
        imagePixels = {}
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if isAutoDrawing then
            stopAutoDrawing()
        end
    end
end)

print("Auto Draw Script Loaded")
print("Hold Left Mouse Button to start drawing")
print("Q - stop drawing, R - reload image")
print("You need to move your mouse for the game to detect movement")