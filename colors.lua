if patterns == nil then
    print('\27[35m' .. "@utils/colors.lua" .. '\27[31m' .. " didn't load, " .. '\27[33m' .. "please import " .. '\27[35m' .. "@utils/patterns.lua" .. '\27[31m' .. "." .. '\27[0m')
    return
end

---@alias DecimalColor integer 0 ~ (2^24 - 1)
---@alias HexColor string #000000 ~ #FFFFFF
---@alias rgb vector3
rgb = vector3

---@param value any
---@return boolean
function IsDecimalColor(value)
  if type(value) ~= 'number' then return false end
  return value >= 0 and value <= 0xFFFFFF
end

---@param color DecimalColor
---@return rgb?
function DecimalToRGB(color)
  if not IsDecimalColor(color) then return end
  return rgb((color & 0xFF0000) >> 16, (color & 0xFF00) >> 8, (color & 0xFF));
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
  if not isHex then return end ---@cast hex HexColor
  return tonumber(hex, 16)
end

---@param color HexColor
---@return rgb?
function HexColorToRGB(color)
  local isHex, hex = IsHexColor(color)
  if not isHex then return end ---@cast hex HexColor
  local offsets = #hex == 3 and {1, 1, 2, 2, 3, 3} or {1, 2, 3, 4, 5, 6}
  return rgb(tonumber(hex:sub(offsets[1], offsets[2]), 16), tonumber(hex:sub(offsets[3], offsets[4]), 16), tonumber(hex:sub(offsets[5], offsets[6]), 16))
end

---@param value any
---@return boolean
function IsRGB(value)
  if type(value) ~= 'vector3' then return false end
  for i = 1, 3 do
    if value[i] < 0 or value[i] > 255 then
      return false
    end
  end
  return true
end

---@param color rgb
---@return integer?
function RGBToDecimal(color)
  if not IsRGB(color) then return end
  return (color.r << 16) + (color.g << 8) + color.b
end

---@param color rgb
---@return HexColor?
function RGBToDecimal(color)
  if not IsRGB(color) then return end
  return ('#%x%x%x'):format(color.r, color.g, color.b)
end

local rgbPattern = patterns.stringCallFn('rgb', { '%d+', '%d+', '%d+' })

---@param str string `"rgb(0~255, 0~255, 0~255)"`
---@return rgb?
function ParseRGBString(str)
    if type(str) ~= 'string' then return end
    local components = { str:match(rgbPattern) } --[=[@as string[]]=]
    if not next(components) then return end
    for index, component in ipairs(components) do
        components[index] = tonumber(component)
        if not components[index] then return end
    end
    ---@cast components number[]
    local color = rgb(table.unpack(components))
    return IsRGB(color) and color or nil
end
