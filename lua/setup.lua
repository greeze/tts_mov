setup = {}

local snapPointList = {}
local encounterSnaps = {}

function setup.setSnapPointList(snapPoints)
  snapPointList = snapPoints
  encounterSnaps = table.filter(snapPointList, isEncounterSnap)
end

function setup.encounters(guid)
  log(encounterSnaps)
end

function isEncounterSnap(snap)
  return table.includes(snap.tags, 'encounter')
end
