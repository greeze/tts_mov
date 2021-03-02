require("lua/utils/table")
require("lua/global/constants")
require("lua/global/setup")
require("lua/global/money")
require("lua/components/value_tiles/updateTileValue")

function onLoad(save_state)
  disableNonInteractables()
  money.init()
end

function disableNonInteractables()
  table.forEach(GUIDsToDisable, function(guid)
    getObjectFromGUID(guid).interactable = false
  end)
end
