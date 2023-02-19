fx_version 'adamant'
game 'gta5'
author 'Naiko | NH développement'


client_scripts {
    'menu.lua',
    'function.lua'
}

---SERVER SCRIPT
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

----LA CONFIG
shared_scripts {
    'config.lua',
    '@es_extended/imports.lua'
}

---- ICI LE RAGEUIMENU 
client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua", 
}



