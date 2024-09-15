---@param varName string
---@param default boolean
---@return boolean
function GetConvarBoolean(varName, default)
    return GetConvarInt(varName, default and 1 or 0) == 1
end
