function updateTileValue(object)
  if object.tag == "Tile" then
    local value = object.getVar("val") or object.value
    local quantity = object.getQuantity()

    if quantity > -1 then
      value = value * quantity
    end

    object.value = value
  end
end
