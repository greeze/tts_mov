require("lua/utils/table")

local groups = {
  credits = 1
}

function setTileValue(val)
  self.value = val
  if (self.hasTag('credits')) then
    self.value_flags = groups['credits']
  end
  self.setVar("val", val)
  Global.call("updateTileValue", self)
end
