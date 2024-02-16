ESX = exports["es_extended"]:getSharedObject()

-- ESX = nil

-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('reply', function(source, args, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local playerGroup = xPlayer.getGroup()
        if isGroupAllowed(playerGroup) then
            local targetId = tonumber(args[1])
            table.remove(args, 1)
            local message = table.concat(args, " ")
            if targetId and message then
                TriggerClientEvent('hw_reply:receiveReply', targetId, message)
            else
                xPlayer.showNotification('Invalid usage. /reply [playerId] [message]')
            end
        else
            xPlayer.showNotification('You do not have permission to use this command.')
        end
    end
end, false)

function isGroupAllowed(group)
    for _, allowedGroup in ipairs(Config.AllowedGroups) do
        if group == allowedGroup then
            return true
        end
    end
    return false
end

