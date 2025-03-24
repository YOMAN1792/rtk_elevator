fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0.1'
author 'YOMAN1792'

server_script 'server.lua'
client_script 'client.lua'

shared_script 'config.lua'

shared_scripts {
    '@es_extended/imports.lua', -- Import ESX functions and PlayerData
    '@es_extended/locale.lua', -- Import the Locale system
  }
   
dependencies {
    'es_extended' -- Ensure the script starts after es_extended so that the functions work.
}
