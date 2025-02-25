fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name "samy_aimblock"
description "Disables players from shooting while aiming close to a wall"
author "Samy"
original_repo "https://github.com/RodericAguilar/Roda_BlockX"
version "1.0.1"

client_scripts {
    'client.lua',
}

shared_scripts {
	'@ox_lib/init.lua',
	'cfg.lua'
}
