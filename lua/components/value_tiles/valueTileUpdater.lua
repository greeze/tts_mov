-- ============================================================================
-- This gets imported into Global because it's too expensive to put on every
-- valueTile.
-- ============================================================================
---@param obj table
local function updateTileValue(obj)
  local value = obj.getVar('val') or obj.value
  local quantity = obj.getQuantity()

  if quantity > -1 then
    value = value * quantity
  end

  obj.value = value
end

---@param container table
---@param obj table
local function onObjectEnterContainer(container, obj)
  if (obj.type == 'Tile' and obj.hasTag('scoring')) then
    updateTileValue(container)
  end
end

---@param container table
---@param obj table
local function onObjectLeaveContainer(container, obj)
  if (obj.type == 'Tile' and obj.hasTag('scoring')) then
    updateTileValue(container)
  end
end

return {
  updateTileValue = updateTileValue,
  onObjectEnterContainer = onObjectEnterContainer,
  onObjectLeaveContainer = onObjectLeaveContainer,
}
