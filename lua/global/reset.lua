require('lua/utils/table')
local constants = require('lua/global/constants')

local function getDefaultConfig()
  return {
    start = {
      x = 0,
      y = 1,
      z = 0,
    },

    step = {
      x = 5,
      z = -5,
    },

    row = 10,
  }
end

local function getDefaultTakeParams()
  return {
    callback_function = |obj| obj.setLock(true),
    rotation = {0, 0, 0},
  }
end

local function layout(bag, configOverrides, takeOverrides)
  local config = table.merge(getDefaultConfig(), configOverrides or {})
  local takeParams = table.merge(getDefaultTakeParams(), takeOverrides or {})

  local start = config.start
  local step = config.step
  local row = config.row

  local objects = table.sort(
    table.map(bag.getObjects(), |obj| { name = obj.name, guid = obj.guid }),
    |a, b| a.name < b.name
  )

  local multiplier = 0
  table.forEach(objects, function(obj)
    takeParams.guid = obj.guid
    takeParams.position = {
      start.x + step.x * (multiplier % row),
      start.y,
      start.z + step.z * math.floor(multiplier / row)
    }
    bag.takeObject(takeParams, true)
    multiplier = multiplier + 1
  end)
end

local function gatherTaggedItemsIntoBag(tags, bagGUID)
  local objects = getObjectsWithAllTags(tags)
  local bag = getObjectFromGUID(bagGUID)
  table.forEach(objects, function(obj)
    obj.setLock(false)
    bag.putObject(obj)
  end)
  return bag
end

local function resetEventTokens()
  local bag = gatherTaggedItemsIntoBag({ 'event', 'token' }, constants.GUIDS.EventTokenBagGUID)

  local layoutConfig = {
    start = {
      x = 9.5,
      y = 1,
      z = 44.5,
    },
    step = {
      x = 2.75,
      z = -3.75,
    },
    row = 13,
  }

  local takeOptions = {
    rotation = {0, 180, 0},
  }

  layout(bag, layoutConfig, takeOptions)
end

local function resetCultureCards()
  local bag = gatherTaggedItemsIntoBag({ 'culture', 'card' }, constants.GUIDS.CultureCardBagGUID)

  local layoutConfig = {
    start = {
      x = -44,
      y = 1,
      z = 44,
    },
    step = {
      x = 3.75,
      z = -5.25,
    },
    row = 5,
  }

  local takeOptions = {
    rotation = {0, 180, 0},
  }

  layout(bag, layoutConfig, takeOptions)
end

local function resetEncounters()
  local bag = gatherTaggedItemsIntoBag({ 'encounter', 'token' }, constants.GUIDS.EncounterBagGUID)

  local layoutConfig = {
    start = {
      x = -25.5,
      y = 1,
      z = 45,
    },
    step = {
      x = 2.75,
      z = -3,
    },
    row = 7,
  }

  local takeOptions = {
    rotation = {0, 180, 0},
  }

  layout(bag, layoutConfig, takeOptions)
end

local function resetGame(player, resetButtonId)
  if (not player.host) then
    broadcastToColor('Only the host may reset the table.', player.color, 'Red')
    return
  end
  resetEventTokens()
  resetCultureCards()
  resetEncounters()
end

return {
  resetGame = resetGame,
}
