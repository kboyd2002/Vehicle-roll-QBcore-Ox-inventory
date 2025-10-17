fx_version 'cerulean'
game 'gta5'

author 'MidgetYoda'
description 'Vehicle Random Spin'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/ped.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/images/*.png'
}

dependencies {
    'qb-core',
    'qb-target',
    'ox_inventory',
    'oxmysql'
}

lua54 'yes'