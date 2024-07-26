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

### [Action Points](./imports/actionPoints.lua)

[`fxmanifest.lua`](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/):

```lua
shared_scripts {
    '@ox_lib/init.lua',
    '@utils/imports/actionPoints.lua'
}
```

## 🤖 Language Server

Install [Sumneko Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) Language Server on [Visual Studio Code](https://code.visualstudio.com/).
