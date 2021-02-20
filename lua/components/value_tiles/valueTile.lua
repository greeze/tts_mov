require("lua/utils/stringToNum")
require("lua/components/value_tiles/setTileValue")

function getVal()
  return stringToNum(self.getGMNotes())
end

function onSpawn()
  setTileValue(getVal())
end

function onLoad()
  setTileValue(getVal())
end
