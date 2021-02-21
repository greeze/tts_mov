require("lua/utils/table") -- lua tables, not the game table
require("lua/guids")
require("lua/setup")
require("lua/components/value_tiles/updateTileValue")

function onLoad(save_state)
  disableNonInteractables()
  setupGame()
end

function setupGame()
  setup.encounters(EncounterBagGUID)
end

function disableNonInteractables()
  table.forEach(GUIDsToDisable, disableGUID)
end

function disableGUID(guid)
  getObjectFromGUID(guid).interactable = false
end

function onObjectEnterContainer(container, obj)
  updateTileValue(container)
end

function onObjectLeaveContainer(container, obj)
  updateTileValue(container)
end
