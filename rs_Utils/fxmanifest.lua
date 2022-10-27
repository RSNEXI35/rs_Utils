resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
fx_version 'adamant'
game 'gta5'


server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'config.lua',
    'server/server.lua',
}

client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'client/client.lua'

}
