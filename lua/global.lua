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
  local allObjects = getObjects()
  local eventTokens = table.filter(allObjects, isEventToken)
  local cultureCards = table.filter(allObjects, isCultureCard)
  local encounterTokens = table.filter(allObjects, isEncounterToken)

  setup.setSnapPointList(Global.getSnapPoints())
  setup.eventTokens(eventTokens, EventTokenBagGUID)
  setup.cultureCards(cultureCards, CultureCardBagGUID)
  setup.encounters(encounterTokens, EncounterBagGUID)
end

function isEventToken(obj)
  return obj.hasTag('event') and obj.hasTag('token')
end

function isCultureCard(obj)
  return obj.hasTag('culture') and obj.hasTag('card')
end

function isEncounterToken(obj)
  return obj.hasTag('encounter') and obj.hasTag('token')
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
