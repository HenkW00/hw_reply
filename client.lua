RegisterNetEvent('hw_reply:receiveReply')
AddEventHandler('hw_reply:receiveReply', function(message, senderName, notifyMethod)
    local fullMessage = "From " .. senderName .. ": " .. message
    if notifyMethod == "hw_notify" then
        exports.hw_notify:SendNotification({text = fullMessage, type = "info", timeout = 5000})
    elseif notifyMethod == "okokNotify" then
        exports.okokNotify:Alert("Admin Reply", fullMessage, 5000, 'info')
    end
end)