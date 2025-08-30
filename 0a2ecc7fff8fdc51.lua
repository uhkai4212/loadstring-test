local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Blocks n' props script",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "...",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateButton({
   Name = "Remove KillBrick",
   Callback = function()
      local killbrick = game.Workspace:FindFirstChild("Map"):FindFirstChild("Classic"):FindFirstChild("KillBrick")
      if killbrick then
         killbrick:Destroy()
         Rayfield:Notify({
            Title = "Removed",
            Content = "KillBrick Removed!",
            Duration = 3
         })
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "KillBrick Not existing!",
            Duration = 3
         })
      end
   end,
})


MainTab:CreateButton({
   Name = "Instant Win",
   Callback = function()
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")
      local buttonPart = game.Workspace:FindFirstChild("Map"):FindFirstChild("Classic"):FindFirstChild("Button")

      if buttonPart then
         hrp.CFrame = buttonPart.CFrame + Vector3.new(0, 3, 0)
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Cannot found button",
            Duration = 3
         })
      end
   end,
})


local noclipEnabled = false
MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "NoclipToggle",
   Callback = function(Value)
      noclipEnabled = Value
   end,
})


game:GetService("RunService").Stepped:Connect(function()
   if noclipEnabled then
      for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
   end
end)