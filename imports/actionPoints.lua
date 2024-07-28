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

---@alias ActionPointFunction fun(point: CActionPoint)
---@alias ActionPointToggle fun(point: CActionPoint, enable: boolean, force?: boolean)

---@class ActionPointStatics
---@field marker MarkerProps drawn when nearby
---@field action ActionPointFunction invoked when key is released
---@field onEnterMarker? ActionPointFunction invoked once the player enter the marker and determines whether to allow performing or not
---@field inMarker? ActionPointFunction invoked while player is in marker
---@field onExitMarker? ActionPointFunction invoked once the player exit the marker
---@field performKey? integer [control](https://docs.fivem.net/docs/game-references/controls/), default `INPUT_PICKUP`

---@class (exact) ActionPointProperties: PointProperties, ActionPointStatics
---@field spaceHeight? number usually used with ground markers

---@class CActionPoint: CPoint, ActionPointStatics
---@field isInMarker fun(point: CActionPoint): boolean determines whether player is in the marker or not
---@field toggle ActionPointToggle toggle point on-key behavior
---@field toggled boolean point toggle state

local groundMarkers = { 1, 8, 9, 23, 25, 26, 27 }

---@type ActionPointFunction
local function nearby(point)
    if point.toggled then
        point.marker:draw()
    end
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
        point:isInMarker()
        if not point.wasInMarker then
            point.wasInMarker = true
            point:onEnterMarker()
        end
        if point.toggled and IsControlJustReleased(0, point.performKey) then
            point:action()
        end
    elseif point.wasInMarker then
        point.wasInMarker = false
        point:onExitMarker()
    end
end

---@type ActionPointToggle
local function toggle(point, enable, force)
    if not point.forcedToggle or force then
        point.toggled = enable
        point.forcedToggle = force
    end
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
    if not point.onEnterMarker then point.onEnterMarker = noop end
    if not point.inMarker then point.inMarker = noop end
    if not point.onExitMarker then point.onExitMarker = noop end

    if not point.performKey then point.performKey = 38 end

    point.nearby = nearby

    point.toggle = toggle
    point:toggle(true)

    return point
end
