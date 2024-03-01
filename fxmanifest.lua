fx_version 'cerulean'
game 'gta5'

author 'HenkW'
description 'Admin reply script with okokNotify/hw_notify integration'
version '1.0.7'

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua', 
    'config.lua',
    'server.lua',
    'version.lua'
}

dependency 'es_extended' 

shared_script '@es_extended/imports.lua'
