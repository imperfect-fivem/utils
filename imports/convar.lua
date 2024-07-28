---@param varName string
---@param default boolean
---@return boolean
function GetConvarBoolean(varName, default)
    local raw = GetConvar(varName, tostring(default))
    return raw ~= '0' and raw ~= 'false'
end
