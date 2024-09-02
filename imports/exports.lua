---@param resource string
---@param method string
---@param callback function
function provideExport(resource, method, callback)
    AddEventHandler(('__cfx_export_%s_%s'):format(resource, method), function(setCb) setCb(callback) end)
end
