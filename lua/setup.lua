setup = {}

local snapPointList = {}
local encounterSnaps = {}

function setup.setSnapPointList(snapPoints)
  snapPointList = snapPoints
  encounterSnaps = table.filter(snapPointList, isEncounterSnap)
end

function setup.encounters(bagGUID)
  local encounterBag = getObjectFromGUID(bagGUID)
  local waitTime = 0 -- delay between each object being dealt

  table.forEach(encounterSnaps, function(snap)
    local destPosition = {
      x = snap.position.x,
      y = snap.position.y + 1, -- lift it off the table a bit
      z = snap.position.z,
    }

    local destRotation = {
      x = snap.rotation.x,
      y = snap.rotation.y,
      z = 180, -- flip, because the "flip" option doesn't actually work
    }

    local takeOptions = {
      position = destPosition,
      rotation = destRotation,
    }

    Wait.time(|| encounterBag.takeObject(takeOptions), waitTime)
    waitTime = waitTime + 0.1
  end)
end

function isEncounterSnap(snap)
  return table.includes(snap.tags, 'encounter')
end
