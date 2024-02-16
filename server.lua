local Framework = nil

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

-- Command Registration
RegisterCommand('reply', function(source, args, rawCommand)
    local _source = source
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
    elseif Config.Framework == "QB" then
        xPlayer = Framework.Functions.GetPlayer(_source)
        if xPlayer.PlayerData.job then
            playerGroup = xPlayer.PlayerData.job.name
        end
    end

    -- Permission and message sending
    if xPlayer and isGroupAllowed(playerGroup) then
        local targetId = tonumber(args[1])
        table.remove(args, 1)
        local message = table.concat(args, " ")
        if targetId and message then
            TriggerClientEvent('admin:receiveReply', targetId, message)
        else
            if Config.Framework == "QB" then
                TriggerClientEvent('QBCore:Notify', _source, 'Invalid usage. /reply [playerId] [message]', 'error')
            else
                xPlayer.showNotification('Invalid usage. /reply [playerId] [message]') -- Assuming ESX v1 final or lower
            end
        end
    else
        if Config.Framework == "QB" then
            TriggerClientEvent('QBCore:Notify', _source, 'You do not have permission to use this command.', 'error')
        else
            xPlayer.showNotification('You do not have permission to use this command.') -- Assuming ESX v1 final or lower
        end
    end
end, false)
