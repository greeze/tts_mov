require("lua/utils/table")
require("lua/guids")
require("lua/setup")
require("lua/components/value_tiles/updateTileValue")

ALLOWED_PLAYER_COLORS = { "Yellow", "Red", "Green", "Orange" }

function onLoad(save_state)
  disableNonInteractables()
end

function setupGame(player, setupButtonId)
  Global.UI.hide(setupButtonId)
  setup.setSnapPointList(Global.getSnapPoints())
  setup.cultureCards(CultureCardBagGUID)
  setup.encounters(EncounterBagGUID)
end

function disableNonInteractables()
  table.forEach(GUIDsToDisable, disableGUID)
end

function disableGUID(guid)
  getObjectFromGUID(guid).interactable = false
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
