local Framework = nil

Citizen.CreateThread(function()
    if Config.Framework == "ESX" then
        while Framework == nil do
            TriggerEvent('esx:getSharedObject', function(obj) Framework = obj end)
            Citizen.Wait(0) 
            if Framework == nil then
                Framework = exports['es_extended']:getSharedObject() 
            end
        end
    elseif Config.Framework == "QB" then
        Framework = exports['qb-core']:GetCoreObject()
    end
end)

local function isGroupAllowed(group)
    for _, allowedGroup in ipairs(Config.AllowedGroups) do
        if group == allowedGroup then
            return true
        end
    end
    return false
end

RegisterCommand('reply', function(source, args, rawCommand)
    local _source = source
    local playerGroup = nil
    local xPlayer = nil

    if not Framework then
        print("Framework not initialized.")
        return
    end

    if Config.Framework == "ESX" then
        xPlayer = Framework.GetPlayerFromId(_source)
        playerGroup = xPlayer.getGroup()
    elseif Config.Framework == "QB" then
        xPlayer = Framework.Functions.GetPlayer(_source)
        if xPlayer.PlayerData.job then
            playerGroup = xPlayer.PlayerData.job.name
        end
    end

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
                -- ESX notification method if necessary
            end
        end
    else
        if Config.Framework == "QB" then
            TriggerClientEvent('QBCore:Notify', _source, 'You do not have permission to use this command.', 'error')
        else
            -- ESX notification method if necessary
        end
    end
end, false)