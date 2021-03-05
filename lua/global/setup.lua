require("lua/utils/table")
local constants = require("lua/global/constants")
local money = require("lua/global/money")

local snapPointList = {}
local encounterSnaps = {}
local cultureCardSnaps = {}

local function dealFromContainerToSnaps(container, snaps, flip)
  local totalWaitTime = 0
  local delayBetween = 0.1
  table.forEach(snaps, function(snap)
    if (#container.getObjects() <= 0) then
      return
    end

    local destPosition = snap.position
    destPosition.y = snap.position.y + 1 -- lift it off the table a bit

    local destRotation = snap.rotation
    if (flip) then
      destRotation.z = 180 -- the "flip" opt of takeObject doesn't work
    end

    local takeOptions = {
      position = destPosition,
      rotation = destRotation,
    }

    Wait.time(|| container.takeObject(takeOptions), totalWaitTime)
    totalWaitTime = totalWaitTime + delayBetween
  end)
end

local function getEventTokens(allObjects)
  local function isEventToken(obj)
    return obj.hasTag('event') and obj.hasTag('token')
  end

  return table.filter(allObjects, isEventToken)
end

local function getCultureCards(allObjects)
  local function isCultureCard(obj)
    return obj.hasTag('culture') and obj.hasTag('card')
  end

  return table.filter(allObjects, isCultureCard)
end

local function getEncounterTokens(allObjects)
  local function isEncounterToken(obj)
    return obj.hasTag('encounter') and obj.hasTag('token')
  end

  return table.filter(allObjects, isEncounterToken)
end

local function setupPlayers()
  table.forEach(Player.getPlayers(), function(player)
    player.promote()
  end)
end

local function setupMoney()
  local seatedPlayers = getSeatedPlayers()
  local amount = #seatedPlayers * 20
  table.forEach(seatedPlayers, function(playerColor)
    money.payPlayer(amount, Player[playerColor])
  end)
end

local function setupEventTokens(eventTokens, bagGUID)
  local eventTokenBag = getObjectFromGUID(bagGUID)
  table.forEach(eventTokens, function(obj)
    obj.setLock(false)
    eventTokenBag.putObject(obj)
  end)
end

local function setupCultureCards(cultureCards, bagGUID)
  local cultureCardBag = getObjectFromGUID(bagGUID)
  table.forEach(cultureCards, function(obj)
    obj.setLock(false)
    cultureCardBag.putObject(obj)
  end)
  dealFromContainerToSnaps(cultureCardBag, cultureCardSnaps, true)
end

local function setupEncounters(encounterTokens, bagGUID)
  local encounterBag = getObjectFromGUID(bagGUID)
  table.forEach(encounterTokens, function(obj)
    obj.setLock(false)
    encounterBag.putObject(obj)
  end)
  dealFromContainerToSnaps(encounterBag, encounterSnaps, true)
end

local function isCultureCardSnap(snap)
  return table.includes(snap.tags, 'culture') and table.includes(snap.tags, 'card')
end

local function isEncounterSnap(snap)
  return table.includes(snap.tags, 'encounter')
end

local function setupGame(player, setupButtonId)
  Global.UI.hide(setupButtonId)
  local allObjects = getObjects()
  local eventTokens = getEventTokens(allObjects)
  local cultureCards = getCultureCards(allObjects)
  local encounterTokens = getEncounterTokens(allObjects)

  snapPointList = Global.getSnapPoints()
  cultureCardSnaps = table.filter(snapPointList, isCultureCardSnap)
  encounterSnaps = table.filter(snapPointList, isEncounterSnap)

  setupPlayers()
  setupMoney()
  setupEventTokens(eventTokens, constants.GUIDS.EventTokenBagGUID)
  setupCultureCards(cultureCards, constants.GUIDS.CultureCardBagGUID)
  setupEncounters(encounterTokens, constants.GUIDS.EncounterBagGUID)
end

return {
  setupGame = setupGame
}
