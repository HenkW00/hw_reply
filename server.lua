local Framework = nil

-- Function to send logs to Discord
local function sendDiscordLog(fromName, toPlayerId, message)
    local webhookURL = Config.Webhook  -- Use the configurable webhook URL
    if webhookURL == nil or webhookURL == "" then
        print("Discord webhook URL is not configured. Please set Config.Webhook.")
        return
    end
    
    local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") 
    local discordData = {
        username = "Server Logs",
        embeds = {{
            title = "Message Log",
            description = string.format("**From:** %s\n**To:** %s\n**Message:**\n```\n%s\n```", fromName, GetPlayerName(toPlayerId), message),
            footer = { text = "Sent at: " .. timestamp },
            color = 65280 
        }},
        avatar_url = "https://example.com/avatar.jpg"
    }
    
    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode(discordData), { ['Content-Type'] = 'application/json' })
end

-- Dynamic Framework Initialization
Citizen.CreateThread(function()
    if Config.Framework == "ESX" then
        while Framework == nil do
            TriggerEvent('esx:getSharedObject', function(obj) Framework = obj end)
            Citizen.Wait(0) -- Use a short wait to prevent hanging the thread indefinitely
        end
    elseif Config.Framework == "QB" then
        Framework = exports['qb-core']:GetCoreObject()
    end
end)

-- Check if the player's group is allowed
local function isGroupAllowed(group)
    for _, allowedGroup in ipairs(Config.AllowedGroups) do
        if group == allowedGroup then
            return true
        end
    end
    return false
end

-- Notification function based on Config.Notify
local function sendNotification(source, message, messageType)
    if Config.Notify == "hw_notify" then
        TriggerClientEvent('hw_notify:SendNotification', source, {text = message, type = messageType, layout = "topCenter", timeout = 5000})
    elseif Config.Notify == "okokNotify" then
        TriggerClientEvent('okokNotify:Alert', source, "Notification", message, 5000, messageType)
    else
        -- Default notification for ESX if no valid Config.Notify is set
        if Framework and Framework.IsPlayerLoaded(source) then
            local xPlayer = Framework.GetPlayerFromId(source)
            xPlayer.showNotification(message)
        end
    end
end

-- Command Registration
RegisterCommand('reply', function(source, args, rawCommand)
    local _source = source
    local playerName = "Unknown"  -- Default player name
    local playerGroup = nil
    local xPlayer = nil

    -- Ensure the framework is loaded
    while not Framework do
        Citizen.Wait(100) -- Wait for the framework to initialize
    end

    -- Framework-specific logic
    if Config.Framework == "ESX" then
        xPlayer = Framework.GetPlayerFromId(_source)
        playerGroup = xPlayer.getGroup()
        playerName = xPlayer.getName()  -- Get player name for ESX
    elseif Config.Framework == "QB" then
        xPlayer = Framework.Functions.GetPlayer(_source)
        if xPlayer.PlayerData.job then
            playerGroup = xPlayer.PlayerData.job.name
        end
        playerName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname -- Get player name for QBCore
    end

    -- Permission check
    if xPlayer and isGroupAllowed(playerGroup) then
        local targetId = tonumber(args[1])
        table.remove(args, 1)
        local message = table.concat(args, " ")
        if targetId and message then
            -- Send the message along with the sender's name
            TriggerClientEvent('hw_reply:receiveReply', targetId, message, playerName, Config.Notify) -- Updated to pass Config.Notify
            sendDiscordLog(playerName, targetId, message)
        else
            sendNotification(_source, 'Invalid usage. /reply [playerId] [message]', 'error')
        end
    else
        sendNotification(_source, 'You do not have permission to use this command.', 'error')
    end
end, false)
