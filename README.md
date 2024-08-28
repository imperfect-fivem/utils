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

### [Convar](./imports/convar.lua)

```lua
require '@utils.imports.convar'
```

#### Example

```lua
local debugging = GetConvarBoolean('resource:debug', false)
```

### [Network](./imports/network.lua)

[`Client`](https://docs.fivem.net/docs/scripting-reference/client-functions/) only.

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

TODO: document

```lua
require '@utils.imports.patterns'
```

### [Colors](./imports/colors.lua)

TODO: document

```lua
require '@utils.imports.colors'
```

## 🤖 Language Server

Install [Sumneko Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) Language Server on [Visual Studio Code](https://code.visualstudio.com/).
