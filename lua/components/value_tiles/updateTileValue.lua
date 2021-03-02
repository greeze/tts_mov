function updateTileValue(object)
  local value = object.getVar('val') or object.value
  local quantity = object.getQuantity()

  if quantity > -1 then
    value = value * quantity
  end

  object.value = value
end

function onObjectEnterContainer(container, obj)
  if (obj.type == 'Tile' and obj.hasTag('scoring')) then
    updateTileValue(container)
  end
end

function onObjectLeaveContainer(container, obj)
  if (obj.type == 'Tile' and obj.hasTag('scoring')) then
    updateTileValue(container)
  end
end
