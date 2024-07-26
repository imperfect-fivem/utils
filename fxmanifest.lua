fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version "0.0.2"
author "m-imperfect <owner@m-imperfect.net>"
description "Opinionated utilities."

server_script 'src/server_dependency.lua'

files {
    'imports/patterns.lua',
	'imports/colors.lua',

    'imports/actionPoints.lua',

    'imports/tasks.lua'
}
