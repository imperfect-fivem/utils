---@class promise
local deferred = getmetatable(promise:new():resolve())

---@return fun(...)
function deferred:resolveCallback()
    return function(...)
        self:resolve({ ... })
    end
end

---@return unknown ...
function deferred:awaitCallback()
    return table.unpack(Citizen.Await(self))
end
