setup = {}

local snapPointList = {}
local encounterSnaps = {}
local cultureCardSnaps = {}

function setup.setSnapPointList(snapPoints)
  snapPointList = snapPoints
  cultureCardSnaps = table.filter(snapPointList, isCultureCardSnap)
  encounterSnaps = table.filter(snapPointList, isEncounterSnap)
end

function setup.cultureCards(bagGUID)
  local cultureCardBag = getObjectFromGUID(bagGUID)
  dealFromContainerToSnaps(cultureCardBag, cultureCardSnaps, true)
  cultureCardBag.destruct()
end

function setup.encounters(bagGUID)
  local encounterBag = getObjectFromGUID(bagGUID)
  dealFromContainerToSnaps(encounterBag, encounterSnaps, true)
  encounterBag.destruct()
end

function dealFromContainerToSnaps(container, snaps, flip)
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

    container.takeObject(takeOptions)
  end)
end

function isCultureCardSnap(snap)
  return table.includes(snap.tags, 'culture') and table.includes(snap.tags, 'card')
end

function isEncounterSnap(snap)
  return table.includes(snap.tags, 'encounter')
end
