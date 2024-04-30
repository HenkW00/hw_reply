fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'HenkW'
description 'Admin reply script with multiple notify integrations'
version '1.1.0'

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    'config.lua',
    'server.lua',
    'version.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    '@mysql-async/lib/MySQL.lua'
}

dependency 'es_extended' 