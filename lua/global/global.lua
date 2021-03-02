require("lua/utils/table")
require("lua/global/constants")
require("lua/global/setup")
require("lua/global/money")
require("lua/components/value_tiles/updateTileValue")

function onLoad(save_state)
  disableNonInteractables()
  -- money.init()
  -- money.payPlayer(137, Player['Red'])
  -- money.breakBill(1000)
  -- money.combineBills({ 1, 1, 1, 1, 1, 5, 50, 1000 })
end

function disableNonInteractables()
  table.forEach(GUIDsToDisable, function(guid)
    getObjectFromGUID(guid).interactable = false
  end)
end
