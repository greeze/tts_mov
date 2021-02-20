require("lua/components/value_tiles/updateTileValue")

function onObjectEnterContainer(container, obj)
  updateTileValue(container)
end

function onObjectLeaveContainer(container, obj)
  updateTileValue(container)
end
