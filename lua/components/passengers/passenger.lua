require('lua/utils/table')
local passengerData = require('data/passengers')

local function setTileValue()
  local fullName = self.getName()
  local passengerName = string.match(fullName, 'Passenger %- (.*)$')
  local passengerData = table.find(passengerData, function (data)
    return data.name == string.lower(passengerName)
  end)

  self.setVar('data', passengerData)
  self.setVar('value', passengerData.value)
  self.value = 0
end

function onLoad()
  setTileValue()
end

function onSpawn()
  setTileValue()
end
