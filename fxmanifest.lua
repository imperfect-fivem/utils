fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version "0.0.1"
author "m-imperfect <owner@m-imperfect.net>"
description "Utilities."

dependency 'ox_lib'

shared_script '@ox_lib/init.lua'

files {
    'patterns.lua',
	'colors.lua',

    'actionPoints.lua'
}
