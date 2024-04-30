RegisterNetEvent('hw_reply:receiveReply')
AddEventHandler('hw_reply:receiveReply', function(message, senderName, notifyMethod)
    local fullMessage = "From " .. senderName .. ": " .. message
    if notifyMethod == "hw" then
        exports.hw_notify:SendNotification({text = fullMessage, type = "info", timeout = 5000})
    elseif notifyMethod == "okok" then
        exports.okokNotify:Alert("Admin Reply", fullMessage, 5000, 'info')
    elseif notifyMethod == "mythic" then
        exports['mythic_notify']:SendAlert('success', fullMessage)
    elseif notifyMethod == "ox" then
        lib.notify({
            title = 'Admin Reply',
            description = fullMessage,
            type = 'success'
        })
    end
end)