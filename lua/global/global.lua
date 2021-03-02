require("lua/utils/table")
require("lua/global/constants")
require("lua/global/setup")
require("lua/components/value_tiles/updateTileValue")

function onLoad(save_state)
  disableNonInteractables()
end

function disableNonInteractables()
  table.forEach(GUIDsToDisable, function(guid)
    getObjectFromGUID(guid).interactable = false
  end)
end
