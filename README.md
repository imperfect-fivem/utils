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

### [Convar](./imports/convar.lua)

[`fxmanifest.lua`](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/):

```lua
shared_script '@utils/imports/convar.lua'
```

#### Example

```lua
local debugging = GetConvarBoolean('resource:debug', false)
```

### [Network](./imports/network.lua)

[`fxmanifest.lua`](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/):

```lua
client_script '@utils/imports/convar.lua'
```

#### Example

`client.lua`

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

[`fxmanifest.lua`](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/):

```lua
shared_script '@utils/imports/patterns.lua'
```

### [Colors](./imports/colors.lua)

[`fxmanifest.lua`](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/):

```lua
shared_scripts {
    '@utils/imports/patterns.lua',
    '@utils/imports/colors.lua'
}
```

## 🤖 Language Server

Install [Sumneko Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) Language Server on [Visual Studio Code](https://code.visualstudio.com/).
