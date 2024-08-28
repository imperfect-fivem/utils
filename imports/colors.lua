if patterns == nil then
    print("^5@utils/colors.lua^1 didn't load,^3 please load ^5@utils/patterns.lua^1.^7")
    return
end

---@alias DecimalColor integer 0 ~ (2^24 - 1)
---@alias HexColor string #000000 ~ #FFFFFF
---@class RGBColor
---@field r integer 0 ~ 255
---@field g integer 0 ~ 255
---@field b integer 0 ~ 255
---@class RGBAColor: RGBColor
---@field a integer 0 ~ 255

---@param value any
---@return boolean
function IsDecimalColor(value)
    if type(value) ~= 'number' then return false end
    return value >= 0 and value <= 0xFFFFFF
end

---@param color DecimalColor
---@return RGBColor?
function DecimalToRGB(color)
    if not IsDecimalColor(color) then return end
    return { r = (color & 0xFF0000) >> 16, g = (color & 0xFF00) >> 8, b = (color & 0xFF) }
end

---@param color DecimalColor
---@return HexColor?
function DecimalToHexColor(color)
    if not IsDecimalColor(color) then return end
    return ('#%x'):format(color)
end

---@param value any
---@return boolean
function IsHexColor(value)
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
function HexToDecimalColor(color)
    local isHex, hex = IsHexColor(color)
    if not isHex then return end
    ---@cast hex HexColor
    return tonumber(hex, 16)
end

---@param color HexColor
---@return RGBColor?
function HexColorToRGB(color)
    local isHex, hex = IsHexColor(color)
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
function IsRGB(value)
    if type(value) ~= 'table' then return false end
    ---@cast value RGBColor
    for key in pairs(rgbKeys) do
        local component = value[key]
        if not component or component < 0 or component > 255 then
            return false
        end
    end
    return true
end

---@param color RGBColor
---@return integer?
function RGBToDecimal(color)
    if not IsRGB(color) then return end
    return (color.r << 16) + (color.g << 8) + color.b
end

---@param color RGBColor
---@return HexColor?
function RGBToDecimal(color)
    if not IsRGB(color) then return end
    return ('#%x%x%x'):format(color.r, color.g, color.b)
end

---@param str string `"rgb(0~255, 0~255, 0~255)"`
---@return RGBColor?
function ParseRGBString(str)
    if type(str) ~= 'string' then return end
    local components = patterns.parseIntegersStringCall('rgb', 3, str)
    local color = components and { r = components[1], g = components[2], b = components[3] } or nil
    if IsRGB(color) then return color end
end

---@param value any
---@return boolean
function IsRGBA(value)
    if not IsRGB(value) then return false end
    return value.a and value.a >= 0 and value.a <= 255
end

---@param str string `"rgba(0~255, 0~255, 0~255, 0~255)"`
---@return RGBAColor?
function ParseRGBAString(str)
    if type(str) ~= 'string' then return end
    local components = patterns.parseIntegersStringCall('rgba', 4, str)
    local color = components and { r = components[1], g = components[2], b = components[3], a = components[4] } or nil
    if IsRGBA(color) then return color end
end
