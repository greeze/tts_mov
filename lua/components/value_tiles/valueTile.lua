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

function setTileValue()
  self.value = stringToNum(self.getGMNotes())
  self.setVar('val', self.value)
  if (self.hasTag('credits')) then
    self.value_flags = groups['credits']
  end

  -- Todo: Why the hell is this even necessary?!
  Global.call('updateTileValue', self)
end
