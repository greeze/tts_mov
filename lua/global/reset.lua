require('lua/utils/table')
local constants = require('lua/global/constants')

local function getDefaultConfig()
  return {
    start = { x = 0, y = 5, z = 0 },
    step = { x = 5, z = -5 },
    row = 10,
  }
end

local function getDefaultTakeParams()
  return {
    callback_function = function(obj) obj.setLock(true) end,
    rotation = {0, 180, 0},
  }
end

---@param bag table
---@param configOverrides table
---@param takeOverrides table
local function layout(bag, configOverrides, takeOverrides)
  local config = table.merge(getDefaultConfig(), configOverrides or {})
  local takeParams = table.merge(getDefaultTakeParams(), takeOverrides or {})

  local start = config.start
  local step = config.step
  local row = config.row

  ---@type table[]
  local objects = table.sort(
    table.map(bag.getObjects(), function(obj) return { name = obj.name, guid = obj.guid } end),
    function(a, b) return a.name < b.name end
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

---@param tags string[]
---@param bag table
local function gatherTaggedItemsIntoBag(tags, bag)
  ---@type table[]
  local objects = getObjectsWithAllTags(tags)
  table.forEach(objects, function(obj)
    obj.setLock(false)
    bag.putObject(obj)
  end)
end

---@param callback fun(obj:table)
local function spawnBagThen(callback)
  spawnObject({
    scale = { x = 0, y = 0, z = 0 },
    type = 'Bag',
    callback_function = callback,
  })
end

local function resetEventTokens()
  local bag = getObjectFromGUID(constants.GUIDS.EventTokenBagGUID)
  gatherTaggedItemsIntoBag({ 'event', 'token' }, bag)

  local layoutConfig = {
    start = { x = 9.5, y = 1.5, z = 44.5 },
    step = { x = 2.75, z = -3.75 },
    row = 13,
  }

  layout(bag, layoutConfig)
end

local function resetCultureCards()
  local bag = getObjectFromGUID(constants.GUIDS.CultureCardBagGUID)
  gatherTaggedItemsIntoBag({ 'culture', 'card' }, bag)

  local layoutConfig = {
    start = { x = -44, y = 1.5, z = 44 },
    step = { x = 3.75, z = -5.25 },
    row = 5,
  }

  layout(bag, layoutConfig)
end

local function resetEncounters()
  local bag = getObjectFromGUID(constants.GUIDS.EncounterBagGUID)
  gatherTaggedItemsIntoBag({ 'encounter', 'token' }, bag)

  local layoutConfig = {
    start = { x = -25.5, y = 1.5, z = 45 },
    step = { x = 2.75, z = -3 },
    row = 7,
  }

  layout(bag, layoutConfig)
end

local function resetCultureTokens()
  local tokenData = {
    {
      tags = { 'culture', 'details', 'token' },
      layoutConfig = {
        start = { x = -33.5, y = 1.5, z = 19.5 },
        step = { x = 0, z = -3 },
        row = 1,
      },
    },
    {
      tags = { 'good', 'normal', 'token' },
      layoutConfig = {
        start = { x = -37.5, y = 1.5, z = 19.5 },
        step = { x = 0, z = -3 },
        row = 1,
      },
    },
    {
      tags = { 'good', 'factory', 'token' },
      layoutConfig = {
        start = { x = -37.5, y = 2.25, z = 19.5 },
        step = { x = 0, z = -3 },
        row = 1,
      },
    },
    {
      tags = { 'deed', 'factory', 'token' },
      layoutConfig = {
        start = { x = -37.5, y = 2.5, z = 19.5 },
        step = { x = 0, z = -3 },
        row = 1,
      },
    },
  }
  spawnBagThen(function(bag)
    table.forEach(tokenData, function(data)
      gatherTaggedItemsIntoBag(data.tags, bag)
      layout(bag, data.layoutConfig)
    end)
    bag.destruct()
  end)
end

---@param player table
---@param resetButtonId string
local function resetGame(player, resetButtonId)
  if (not player.host) then
    broadcastToColor('Only the host may reset the table.', player.color, 'Red')
    return
  end
  resetEventTokens()
  resetCultureCards()
  resetEncounters()
  resetCultureTokens()
end

return {
  resetGame = resetGame,
}
