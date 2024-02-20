RegisterNetEvent('hw_reply:receiveReply')
AddEventHandler('hw_reply:receiveReply', function(message, senderName)
    local fullMessage = "From " .. senderName .. ": " .. message
    exports.okokNotify:Alert("Admin Reply", fullMessage, 5000, 'info')
end)


