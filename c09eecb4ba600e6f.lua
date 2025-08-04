game:BindToClose(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Team ~= Player.Team then
            local character = plr.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp and originalProperties[plr] then
                    hrp.Size = originalProperties[plr].Size
                    hrp.Transparency = originalProperties[plr].Transparency
                    hrp.Color = originalProperties[plr].Color
                    hrp.CanCollide = false
                end
            end
        end
    end
    originalProperties = {}
end)