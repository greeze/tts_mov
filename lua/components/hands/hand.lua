---@param obj table
---@return boolean
local function isCash(obj)
  if (obj == nil) then return false end
  return obj.hasTag('credits')
end

---@param obj table
---@return boolean
local function isGood(obj)
  if (obj == nil) then return false end
  return obj.hasTag('good')
end

---@param zone table
function onObjectEnterZone(zone, obj)
  if (zone == self) then
    if (isCash(obj)) then
      obj.setRotation({0, 90, 0})
    elseif (isGood(obj)) then
      if (not obj.is_face_down) then
        obj.flip()
      end
    end
  end
end
