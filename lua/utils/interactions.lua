require('lua/utils/table')

local function dealObjectToPosition(obj, position)
  obj.setPositionSmooth(position, false, true)
end

local function dealStackToPosition(stack, position)
  for i = 2, stack.getQuantity() do
    stack.takeObject({ position = position })
    if (stack.remainder) then
      dealObjectToPosition(stack.remainder, position)
    end
  end
end

local function dealObjectsToPosition(objects, position)
  table.forEach(objects, function (obj)
    if (obj.getQuantity() == -1) then
      dealObjectToPosition(obj, position)
    else
      dealStackToPosition(obj, position)
    end
  end)
end

--- Moves an object over a snap point, then drops it
---@param obj table
---@param snap table
local function dealObjectToSnap(obj, snap)
  obj.setLock(false)
  local destPosition = {
    x = snap.position.x,
    y = snap.position.y + 1,
    z = snap.position.z,
  }
  obj.setPositionSmooth(destPosition, false)
end

--- Pings an object with an arrow of the given player's color
---@param obj table
---@param playerColor string
local function pingObject(obj, playerColor)
  Player[playerColor].pingTable(obj.getPosition())
end

return {
  dealObjectToPosition = dealObjectToPosition,
  dealStackToPosition = dealStackToPosition,
  dealObjectsToPosition = dealObjectsToPosition,
  dealObjectToSnap = dealObjectToSnap,
  pingObject = pingObject,
}
