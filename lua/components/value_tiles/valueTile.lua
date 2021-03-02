require("lua/utils/stringToNum")
require("lua/utils/table")

local groups = {
  credits = 1
}

function onLoad()
  setTileValue()
end

function onSpawn()
  setTileValue()
end

function setTileValue(val)
  local val = stringToNum(self.getGMNotes())
  self.value = val
  if (self.hasTag('credits')) then
    self.value_flags = groups['credits']
  end
  self.setVar('val', val)
  Global.call('updateTileValue', self)
end
