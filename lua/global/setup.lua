require('lua/utils/table')
local constants = require('lua/global/constants')
local money = require('lua/global/money')

---@param container table
---@param snaps table[]
---@param flip boolean
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
      destRotation.z = 180 -- the 'flip' opt of takeObject doesn't work
    end

    local takeOptions = {
      position = destPosition,
      rotation = destRotation,
    }

    Wait.time(function() container.takeObject(takeOptions) end, totalWaitTime)
    totalWaitTime = totalWaitTime + delayBetween
  end)
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

local function setupEventTokens()
  local eventTokens = getObjectsWithAllTags({ 'event', 'token' })
  local eventTokenBag = getObjectFromGUID(constants.GUIDS.EventTokenBagGUID)
  table.forEach(eventTokens, function(obj)
    obj.setLock(false)
    eventTokenBag.putObject(obj)
  end)
end

---@param cultureCardSnaps table[]
local function setupCultureCards(cultureCardSnaps)
  local cultureCards = getObjectsWithAllTags({ 'culture', 'card' })
  local cultureCardBag = getObjectFromGUID(constants.GUIDS.CultureCardBagGUID)
  table.forEach(cultureCards, function(obj)
    obj.setLock(false)
    cultureCardBag.putObject(obj)
  end)
  dealFromContainerToSnaps(cultureCardBag, cultureCardSnaps, true)
end

---@param encounterSnaps table[]
local function setupEncounters(encounterSnaps)
  local encounterTokens = getObjectsWithAllTags({ 'encounter', 'token' })
  local encounterBag = getObjectFromGUID(constants.GUIDS.EncounterBagGUID)
  table.forEach(encounterTokens, function(obj)
    obj.setLock(false)
    encounterBag.putObject(obj)
  end)
  dealFromContainerToSnaps(encounterBag, encounterSnaps, true)
end

---@param snap table
---@return boolean
local function isCultureCardSnap(snap)
  return table.includes(snap.tags, 'culture') and table.includes(snap.tags, 'card')
end

---@param snap table
---@return boolean
local function isEncounterSnap(snap)
  return table.includes(snap.tags, 'encounter')
end

---@param player table
---@param setupButtonId string
local function setupGame(player, setupButtonId)
  Global.UI.hide(setupButtonId)

  local snapPointList = Global.getSnapPoints()
  local cultureCardSnaps = table.filter(snapPointList, isCultureCardSnap)
  local encounterSnaps = table.filter(snapPointList, isEncounterSnap)

  setupPlayers()
  setupMoney()
  setupEventTokens()
  setupCultureCards(cultureCardSnaps)
  setupEncounters(encounterSnaps)
end

return {
  setupGame = setupGame
}
