fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version "0.0.3"
author "m-imperfect <owner@m-imperfect.net>"
description "Opinionated utilities."

server_script 'src/server_dependency.lua'

files {
    'imports/tasks.lua',
    'imports/network.lua',

    'imports/patterns.lua',
	'imports/colors.lua',

    'imports/actionPoints.lua'
}
