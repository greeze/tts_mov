require('lua/utils/table')
local constants = require('lua/global/constants')

local function getDefaultConfig()
  return {
    xStart = 0,
    yStart = 1,
    zStart = 0,

    xStep = 5,
    zStep = -5,

    itemsPerRow = 10,
  }
end

local function getDefaultTakeParams()
  return {
    flip = false,
    lock = true,
    rotation = {0, 0, 0}
  }
end

local function layout(bag, configOverrides, takeOverrides)
  local config = table.merge(getDefaultConfig(), configOverrides or {})
  local takeParams = table.merge(getDefaultTakeParams(), takeOverrides or {})

  local xStart = config.xStart
  local yStart = config.yStart
  local zStart = config.zStart
  local xStep = config.xStep
  local zStep = config.zStep
  local row = config.itemsPerRow

  local total = #bag.getObjects() - 1

  for i = 0, total, 1 do
    takeParams.position = {
      xStart + xStep * (i % row),
      yStart,
      zStart + zStep * math.floor(i / row)
    }
    obj = bag.takeObject(takeParams)
  end
end

local function gatherTaggedItemsInBag(tags, bagGUID)
  local objects = getObjectsWithAllTags(tags)
  local bag = getObjectFromGUID(bagGUID)
  table.forEach(objects, function(obj)
    obj.setLock(false)
    bag.putObject(obj)
  end)
  return bag
end

local function resetEncounters()
  local bag = gatherTaggedItemsInBag({ 'encounter', 'token' }, constants.GUIDS.EncounterBagGUID)
  local layoutConfig = {
    itemsPerRow = 9,
  }

  local takeOptions = {
    rotation = {0, 180, 0},
  }

  layout(bag, layoutConfig, takeOptions)
end

local function resetGame(player, resetButtonId)
  log('resetGame called!')
  resetEncounters()
end

return {
  resetGame = resetGame,
}
