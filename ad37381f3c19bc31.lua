local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local a = Instance.new("ScreenGui", game.CoreGui)
a.Name = "inkgameskibidi"
local b = Instance.new("Frame", a)
b.Size = UDim2.new(0, 200, 0, 90)
b.Position = UDim2.new(0, 80, 0, 100)
b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
b.BorderSizePixel = 0
b.Active = true
b.Draggable = true

local corner = Instance.new("UICorner", b)
corner.CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", b)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(255, 80, 80)

local c = Instance.new("TextLabel", b)
c.Size = UDim2.new(1, 0, 0, 30)
c.BackgroundTransparency = 1
c.Text = "Credit: Cáo Mod"
c.TextColor3 = Color3.fromRGB(255, 255, 255)
c.Font = Enum.Font.GothamBold
c.TextSize = 14
c.TextStrokeTransparency = 0.6

local d = Instance.new("TextButton", b)
d.Size = UDim2.new(1, -20, 0, 35)
d.Position = UDim2.new(0, 10, 0, 40)
d.Text = "Help Player"
d.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
d.TextColor3 = Color3.new(1, 1, 1)
d.Font = Enum.Font.GothamBold
d.TextSize = 14
d.BorderSizePixel = 0

local d_corner = Instance.new("UICorner", d)
d_corner.CornerRadius = UDim.new(0, 6)

local polygon = {
    Vector2.new(-52, -515),
    Vector2.new(115, -515),
    Vector2.new(115, 84),
    Vector2.new(-216, 84)
}

local function isPointInPolygon(point, poly)
    local inside = false
    local j = #poly
    for i = 1, #poly do
        local xi, zi = poly[i].X, poly[i].Y
        local xj, zj = poly[j].X, poly[j].Y
        if ((zi > point.Y) ~= (zj > point.Y)) and
            (point.X < (xj - xi) * (point.Y - zi) / (zj - zi + 1e-9) + xi) then
            inside = not inside
        end
        j = i
    end
    return inside
end

local function tpTo(cf)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = cf
    end
end

local function fireProximityPrompt(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    end
end

d.MouseButton1Click:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local liveChar = workspace:FindFirstChild("Live") and workspace.Live:FindFirstChild(player.Name)
            local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")

            if hrp then
                local posXZ = Vector2.new(hrp.Position.X, hrp.Position.Z)
                if isPointInPolygon(posXZ, polygon) then
                    local prompt = hrp:FindFirstChild("CarryPrompt")

                    if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
                        d.Text = "Helping: " .. player.Name
                        tpTo(hrp.CFrame + Vector3.new(0, 2, 0))
                        task.wait(0.4)
                        fireProximityPrompt(prompt)
                        task.wait(0.7)
                        tpTo(CFrame.new(-46, 1024, 110))
                        d.Text = "Done: " .. player.Name
                        task.wait(0.6)
                        d.Text = "Help Player"
                        return
                    end
                end
            end
        end
    end

    d.Text = "No one to help"
    task.wait(0.6)
    d.Text = "Help Player"
end)