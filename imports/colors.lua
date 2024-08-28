pcall(require, '@utils.imports.patterns')
if patterns == nil then
    print("^5@utils/imports/colors.lua^1 didn't load, ^5@utils/imports/patterns.lua^1 is required.^7")
    return
end

local function is256(value)
    return math.type(value) == 'integer' and value >= 0 and value <= 255
end

---@alias ColorOpacity number 0.0 ~ 1.0
---@alias DecimalColor integer 0 ~ (2^24 - 1)
---@alias HexColor string #000000 ~ #FFFFFF
---@class RGBColor
---@field r integer 0 ~ 255
---@field g integer 0 ~ 255
---@field b integer 0 ~ 255
---@class RGBAColor: RGBColor
---@field a integer 0 ~ 255

---@class Color
---@field opacity ColorOpacity
---@field decimal DecimalColor
---@field hex HexColor
---@field rgb RGBColor
---@field rgba RGBAColor

---@param decimal integer
local function toHex(decimal)
    return ('#%x'):format(decimal)
end

---@param decimal integer
local function toRGB(decimal)
    return { r = (decimal & 0xFF0000) >> 16, g = (decimal & 0xFF00) >> 8, b = (decimal & 0xFF) }
end

---@type metatable
local colorMeta = {}

---@param color Color
---@param key any
colorMeta.__index = function(color, key)
    if key == 'hex' then
        return toHex(color.decimal)
    elseif key == 'rgb' then
        return toRGB(color.decimal)
    elseif key == 'rgba' then
        local rgba = toRGB(color.decimal)
        ---@cast rgba RGBAColor
        rgba.a = math.ceil(color.opacity * 255)
        return rgba
    end
end

colorMeta.__newindex = function(color, key)
    error('Color class is read-only.')
end

---@overload fun(value: DecimalColor|HexColor|RGBColor|string, opacity: ColorOpacity): Color
---@overload fun(value: RGBAColor|string): Color
Color = setmetatable({}, {
    __call = function(_, value, opacity)
        local color = { opacity = (type(opacity) == "number" and opacity >= 0 and opacity <= 1 and opacity or 1) + 0.0 }
        ---@cast color Color

        local test
        test = Color.ParseRGB(value)
        if not test then test = Color.ParseRGBA(value) end
        if test then
            value = test
            goto rgbaCheck
        end

        ---@cast value DecimalColor
        if Color.IsDecimal(value) then
            color.decimal = value
            goto returnColor
        end

        ---@cast value HexColor
        test = Color.HexToDecimal(value)
        if test then
            color.decimal = test
            goto returnColor
        end

        ::rgbaCheck::
        ---@cast value RGBAColor
        test = Color.RGBToDecimal(value)
        if test then
            color.decimal = test
            if is256(value.a) then color.opacity = value.a / 255 end
            goto returnColor
        end

        color.decimal = 0

        ::returnColor::
        return setmetatable(color, colorMeta)
    end
})

---@param value any
---@return boolean
function Color.IsDecimal(value)
    if type(value) ~= 'number' then return false end
    return value >= 0 and value <= 0xFFFFFF
end

---@param color DecimalColor
---@return RGBColor?
function Color.DecimalToRGB(color)
    if not Color.IsDecimal(color) then return end
    return toRGB(color)
end

---@param color DecimalColor
---@return HexColor?
function Color.DecimalToHex(color)
    if not Color.IsDecimal(color) then return end
    return toHex(color)
end

---@param value any
---@return boolean
function Color.IsHex(value)
    if type(value) ~= 'string' then return false end
    ---@cast value string
    local hash = value:find('#')
    if hash then
        if hash ~= 1 then return false end
        value = value:sub(2)
    end
    value = value:match('^%x%x%x%x%x%x$') or value:match('^%x%x%x$')
    return value ~= nil, value ---@diagnostic disable-line: redundant-return-value
end

---@param color HexColor
---@return integer?
function Color.HexToDecimal(color)
    local isHex, hex = Color.IsHex(color)
    if not isHex then return end
    ---@cast hex HexColor
    return tonumber(hex, 16)
end

---@param color HexColor
---@return RGBColor?
function Color.HexToRGB(color)
    local isHex, hex = Color.IsHex(color)
    if not isHex then return end
    ---@cast hex HexColor
    local offsets = #hex == 3 and { 1, 1, 2, 2, 3, 3 } or { 1, 2, 3, 4, 5, 6 }
    return {
        r = tonumber(hex:sub(offsets[1], offsets[2]), 16),
        g = tonumber(hex:sub(offsets[3], offsets[4]), 16),
        b = tonumber(hex:sub(offsets[5], offsets[6]), 16)
    }
end

local rgbKeys = { r = true, g = true, b = true }
---@param value any
---@return boolean
function Color.IsRGB(value)
    if type(value) ~= 'table' then return false end
    ---@cast value RGBColor
    for key in pairs(rgbKeys) do
        if not is256(value[key]) then
            return false
        end
    end
    return true
end

---@param color RGBColor
---@return integer?
function Color.RGBToDecimal(color)
    if not Color.IsRGB(color) then return end
    return (color.r << 16) + (color.g << 8) + color.b
end

---@param color RGBColor
---@return HexColor?
function Color.RGBToHex(color)
    if not Color.IsRGB(color) then return end
    return ('#%x%x%x'):format(color.r, color.g, color.b)
end

---@param str string `"rgb(0~255, 0~255, 0~255)"`
---@return RGBColor?
function Color.ParseRGB(str)
    if type(str) ~= 'string' then return end
    local components = patterns.parseIntegersStringCall('rgb', 3, str)
    local color = components and { r = components[1], g = components[2], b = components[3] } or nil
    if Color.IsRGB(color) then return color end
end

---@param value any
---@return boolean
function Color.IsRGBA(value)
    if not Color.IsRGB(value) then return false end
    return is256(value.a)
end

---@param str string `"rgba(0~255, 0~255, 0~255, 0~255)"`
---@return RGBAColor?
function Color.ParseRGBA(str)
    if type(str) ~= 'string' then return end
    local components = patterns.parseIntegersStringCall('rgba', 4, str)
    local color = components and { r = components[1], g = components[2], b = components[3], a = components[4] } or nil
    if Color.IsRGBA(color) then return color end
end
