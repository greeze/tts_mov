-- ============================================================================
-- This gets imported into Global because it's too expensive to put on every
-- valueTile.
-- ============================================================================
local function updateTileValue(obj)
  local value = obj.getVar('val') or obj.value
  local quantity = obj.getQuantity()

  if quantity > -1 then
    value = value * quantity
  end

  obj.value = value
end

local function onObjectEnterContainer(container, obj)
  if (obj.type == 'Tile' and obj.hasTag('scoring')) then
    updateTileValue(container)
  end
end

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
