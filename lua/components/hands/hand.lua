
---@param obj table
---@return boolean
function isCash(obj)
  if (obj == nil) then return false end
  return obj.hasTag('credits')
end

---@param zone table
function onObjectEnterZone(zone, obj)
  if (zone == self and isCash(obj)) then
    obj.setRotation({0, 90, 0})
  end
end
