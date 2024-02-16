RegisterNetEvent('hw_reply:receiveReply')
AddEventHandler('hw_reply:receiveReply', function(message)
    exports.okokNotify:Alert("Admin Reply", message, 5000, 'info')
end)

