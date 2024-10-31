--[[ ===================================================== ]] --
--[[             MH Restarter Script by MaDHouSe           ]] --
--[[ ===================================================== ]] --
fx_version 'cerulean'
game 'gta5'

author 'MaDHouSe'
description 'MH Restarter.'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/*.html',
    'html/assets/js/*.js',
    'html/assets/css/*.css',
    'html/assets/sounds/*.ogg',
}

shared_scripts {
    'config.lua',
    'locales/*.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
    'server/update.lua',
}

lua54 'yes'
