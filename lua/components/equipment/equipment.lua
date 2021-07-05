require('lua/utils/table')
local equipmentsData = require('data/equipment')

local function setTileValue()
  local fullName = string.lower(self.getName())
  local equipmentData = table.find(equipmentsData, function (data)
    return data.name == fullName
  end)

  self.setVar('data', equipmentData)
  self.setVar('value', equipmentData.cost)
end

function onLoad()
  setTileValue()
end

function onSpawn()
  setTileValue()
end
