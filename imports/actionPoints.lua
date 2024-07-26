if lib == nil then
    print("^5@utils/imports/actionPoints.lua^1 didn't load,^3 please load ^5@ox_lib/init.lua^1.^7")
    return
end

table = lib.table

function noop() end

---@param difference vector3
---@param space vector3
---@return boolean
local function insideSpace(difference, space)
    for axis = 1, space.n do
        if math.abs(difference[axis]) > space[axis] then
            return false
        end
    end
    return true
end

---@param point CActionPoint
---@return boolean
local function insideMarker(point)
    return insideSpace(cache.coords - point.marker.coords, point.markerSpace)
end

---@param point CActionPoint
---@return boolean
local function standingOnMarker(point)
    local difference = cache.coords - point.marker.coords
    if difference.z < 0 then return false end
    return insideSpace(difference, point.markerSpace)
end

---@alias ActionPointActionFunction fun(point: CActionPoint, callback: function)
---@alias ActionPointFunction fun(point: CActionPoint)
---@alias ActionPointIndicatorFunction fun(point: CActionPoint): boolean
---@alias ActionPointToggleFunction fun(point: CActionPoint, enable: boolean)

---@class ActionPointStatics
---@field marker MarkerProps drawn when nearby
---@field action async ActionPointActionFunction invoked when key is released, callback to end performing
---@field onEnterMarker? ActionPointIndicatorFunction invoked once the player enter the marker and determines whether to allow performing or not
---@field inMarker? ActionPointFunction invoked while player is in marker
---@field onExitMarker? ActionPointFunction invoked once the player exit the marker
---@field performKey? integer [control](https://docs.fivem.net/docs/game-references/controls/), default `INPUT_PICKUP`

---@class (exact) ActionPointProperties: PointProperties, ActionPointStatics
---@field spaceHeight? number usually used with ground markers

---@class CActionPoint: CPoint, ActionPointStatics
---@field isInMarker ActionPointIndicatorFunction determines whether player is in the marker or not
---@field performing boolean indicates whether player is performing the action now or not
---@field toggle ActionPointToggleFunction toggle point nearby behavior

local groundMarkers = { 1, 8, 9, 23, 25, 26, 27 }

---@param point CActionPoint
local function nearby(point)
    point.marker:draw()
    -- DrawMarker(
    --     28, point.coords,
    --     0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    --     point.space.x, point.space.y, point.space.z,
    --     255, 0, 0, 50,
    --     false, false, 2, false,
    --     nil, nil,
    --     false
    -- )
    if point:isInMarker() then
        point:inMarker()
        if point.performing or not point.allowPerforming then return end
        if not point.wasInMarker then
            point.wasInMarker = true
            if not point:onEnterMarker() then
                point.allowPerforming = false
                return
            end
        end
        if not IsControlJustReleased(0, point.performKey) then return end
        point.performing = true
        Citizen.CreateThreadNow(function()
            point:action(function ()
                point.performing = false
            end)
        end)
    elseif point.wasInMarker then
        point.wasInMarker = false
        Citizen.CreateThreadNow(function ()
            point:onExitMarker()
            point.performing = false
            point.allowPerforming = true
        end)
    end
end

---@param point CActionPoint
---@param enable boolean
local function toggle(point, enable)
    point.nearby = enable and nearby or noop
end

---@param properties ActionPointProperties
---@return CActionPoint
function AddActionPoint(properties)
    local point = lib.points.new(properties) --[[@as CActionPoint]]

    point.marker = lib.marker.new(properties.marker)
    point.markerSpace = vector3(vector2(point.marker.width), point.marker.height)
    point.isInMarker = insideMarker

    if table.contains(groundMarkers, point.marker.type) then
        point.markerSpace = point.markerSpace - vector3(point.markerSpace.xy / 2, -point.markerSpace.z / 3)
        point.marker.coords = point.marker.coords - vector3(0, 0, 1)
        point.isInMarker = standingOnMarker
    end

    if point.spaceHeight then
        point.markerSpace = vector3(point.markerSpace.xy, point.spaceHeight)
        point.spaceHeight = nil
    end

    point.wasInMarker = false
    if not point.onEnterMarker then point.onEnterMarker = function() return true end end
    if not point.inMarker then point.inMarker = noop end
    if not point.onExitMarker then point.onExitMarker = noop end

    point.performing = false
    point.allowPerforming = true
    if not point.performKey then point.performKey = 38 end

    point.toggle = toggle
    point:toggle(true)

    return point
end
