require('lua/utils/table')
local stringHelpers = require('lua/utils/stringHelpers')

local function setTileValue()
  local value = stringHelpers.stringToNum(self.getGMNotes())

  -- For calculating actual value
  self.setVar('value', value)
  self.value = 0

  -- For tooltip on credits only
  if (self.hasTag('credits')) then
    self.value = value
  end
end

function onLoad()
  setTileValue()
end

function onSpawn()
  setTileValue()
end
