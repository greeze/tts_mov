require('lua/utils/table')
local demandsData = require('data/demands')

local function setTileValue()
  local fullName = string.lower(self.getName())
  local name, valStr, destStr = string.match(fullName, '.* %- (.*): %+(%d%d) at (%d%d)')
  local val = tonumber(valStr)
  local destId = tonumber(destStr)
  local demandData = table.find(demandsData, function(data)
    return (data.name == name) and (data.value == val) and (data.to == destId)
  end)

  self.setVar('data', demandData)
  self.setVar('value', val)
end

function onLoad()
  setTileValue()
end

function onSpawn()
  setTileValue()
end
