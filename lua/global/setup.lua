require("lua/utils/table")

setup = {}

local snapPointList = {}
local encounterSnaps = {}
local cultureCardSnaps = {}

function setup.setSnapPointList(snapPoints)
  snapPointList = snapPoints
  cultureCardSnaps = table.filter(snapPointList, isCultureCardSnap)
  encounterSnaps = table.filter(snapPointList, isEncounterSnap)
end

function setup.eventTokens(eventTokens, bagGUID)
  local eventTokenBag = getObjectFromGUID(bagGUID)
  table.forEach(eventTokens, function(obj)
    eventTokenBag.putObject(obj)
  end)
end

function setup.cultureCards(cultureCards, bagGUID)
  local cultureCardBag = getObjectFromGUID(bagGUID)
  table.forEach(cultureCards, function(obj)
    cultureCardBag.putObject(obj)
  end)
  dealFromContainerToSnaps(cultureCardBag, cultureCardSnaps, true)
end

function setup.encounters(encounterTokens, bagGUID)
  local encounterBag = getObjectFromGUID(bagGUID)
  table.forEach(encounterTokens, function(obj)
    encounterBag.putObject(obj)
  end)
  dealFromContainerToSnaps(encounterBag, encounterSnaps, true)
end

function dealFromContainerToSnaps(container, snaps, flip)
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

function isCultureCardSnap(snap)
  return table.includes(snap.tags, 'culture') and table.includes(snap.tags, 'card')
end

function isEncounterSnap(snap)
  return table.includes(snap.tags, 'encounter')
end
