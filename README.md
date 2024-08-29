# FiveM Utilities

Opinionated utilities for [FiveM development environment](https://docs.fivem.net/docs/).  
**Note:** This script is under development and not fully functional, star and watch the repo for updates.  
[Download Link](https://github.com/imperfect-fivem/utils/releases/latest/download/utils.zip)

## 🖇️ [Server Dependency](./src/server_dependency.lua)

Makes a resource depend on another server-only resource without [breaking client loading](https://forum.cfx.re/t/resource-manifest-server-only-dependencies-break-loading-client-side/4762860).  
Example [`fxmanifest.lua`](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/):

- api_resource

```lua
server_only 'yes'
```

- logic_resource

```lua
server_dependency 'api_resource'
```

## 📥 Lua Imports

The [`require`](https://overextended.dev/ox_lib/Modules/Require/Shared) function that is used in this section is defined in [ox_lib](https://overextended.dev/ox_lib).  
If you don't want to use it then load the target file manually in your resource [`fxmanifest.lua`](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/).

### [Promise](./imports/promise.lua)

```lua
require '@utils.imports.promise'
```

#### Example

```lua
local function operation(p1, callback, p2)
  --- ...
  callback(true, 123, 'text')
end

local results = promise:new()
operation('whatever', results:resolveCallback(), 'whatever2')
local bool, int, str = results:awaitCallback()
print(bool, int, str) --- true    123    text
```

### [Convar](./imports/convar.lua)

```lua
require '@utils.imports.convar'
```

#### Example

```lua
local debugging = GetConvarBoolean('resource:debug', false)
```

### [Network](./imports/network.lua)

[**`client`**](https://docs.fivem.net/docs/scripting-reference/client-functions/)

```lua
require '@utils.imports.network'
```

#### Example

```lua
RegisterNetEvent('TurnOffVehicleRadio', function(vehicleNetId)
    local attempts, attemptDelay = 2, 5000
    local vehicle = WaitEntityWithNetworkIdToExistLocally(vehicleNetId, attempts, attemptDelay)
    if not vehicle then
        TriggerEvent('WaitedForVehicleToLoadForTooLong', vehicleNetId)
        return
    end

    SetVehRadioStation(vehicle, "OFF")
end)
```

### [Patterns](./imports/patterns.lua)

<!-- TODO: document -->

```lua
require '@utils.imports.patterns'
```

### [Colors](./imports/colors.lua)

[**`lua 5.4`**](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/#lua54)

<!-- TODO: document -->

```lua
require '@utils.imports.colors'
```

#### Examples

```lua
local color = Color('#4287f5', 0.39)
print('opacity:', color.opacity) -- 0.39
print('decimal:', color.decimal) -- 4360181
print('hex:', color.hex) -- #4287f5
local rgb = color.rgb
print('rgb:', rgb.r, rgb.b, rgb.g) -- 66      245     135
local rgba = color.rgba
print('rgba:', rgba.r, rgba.b, rgba.g, rgba.a) -- 66      245     135     100
```

```lua
local color = Color('rgba(252, 3, 182, 51)')
print('opacity:', color.opacity) -- 0.2
print('decimal:', color.decimal) -- 16516022
print('hex:', color.hex) -- #fc03b6
local rgb = color.rgb
print('rgb:', rgb.r, rgb.b, rgb.g) -- 252     182     3
local rgba = color.rgba
print('rgba:', rgba.r, rgba.b, rgba.g, rgba.a) -- 252     182     3       51
```

## 🤖 Language Server

Install [Sumneko Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) Language Server on [Visual Studio Code](https://code.visualstudio.com/).
