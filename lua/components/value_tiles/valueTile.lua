require('lua/utils/table')
local stringHelpers = require('lua/utils/stringHelpers')

function onLoad()
  setTileValue()
end

function onSpawn()
  setTileValue()
end

function setTileValue()
  self.value = stringHelpers.stringToNum(self.getGMNotes())
end
