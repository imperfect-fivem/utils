patterns = {}

---@alias Pattern string [reference](https://www.lua.org/pil/20.2.html).

---@param pattern Pattern
---@param trimFlags?
---| 0 # default, doesn't trim any
---| 1 # trim left side
---| 2 # trim right side
---@return Pattern
function patterns.untrimmed(pattern, trimFlags)
    if not trimFlags then trimFlags = 0 end
    return (trimFlags & 1 ~= 0 and '' or '%s*') .. pattern .. (trimFlags & 2 ~= 0 and '' or '%s*')
end

---@param fnNamePattern Pattern
---@param paramsPatterns Pattern[]
---@return Pattern
function patterns.stringCallFn(fnNamePattern, paramsPatterns)
    for index, pattern in ipairs(paramsPatterns) do paramsPatterns[index] = '(' .. pattern .. ')' end
    return '^' .. patterns.untrimmed(fnNamePattern, 2) .. patterns.untrimmed('%(') .. table.concat(paramsPatterns, patterns.untrimmed(',')) .. patterns.untrimmed('%)') .. '$'
end
