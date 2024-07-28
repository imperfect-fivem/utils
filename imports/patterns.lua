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
---@param str string
---@return string[]?
function patterns.parseStringCall(fnNamePattern, paramsPatterns, str)
    if type(str) ~= 'string' then return end
    for index, pattern in ipairs(paramsPatterns) do paramsPatterns[index] = '(' .. pattern .. ')' end
    local callPattern = '^' .. patterns.untrimmed(fnNamePattern, 2) .. patterns.untrimmed('%(') .. table.concat(paramsPatterns, patterns.untrimmed(',')) .. patterns.untrimmed('%)') .. '$'
    local components = { str:lower():match(callPattern) }
    if next(components) then
        return components
    end
end

---@param fnNamePattern Pattern
---@param paramsCount integer
---@param str string
---@return number[]?
function patterns.parseIntegersStringCall(fnNamePattern, paramsCount, str)
    local integerPattern, paramsPatterns = '%d+', {}
    for i = 1, paramsCount do paramsPatterns[i] = integerPattern end
    local params = patterns.parseStringCall(fnNamePattern, paramsPatterns, str)
    if not params then return end
    for index, component in ipairs(params) do
        ---@cast params number[]
        params[index] = tonumber(component)
        if not params[index] then return end
    end
    return params
end
