require('lua/utils/table')
local constants = require('lua/global/constants')
local tagHelpers = require('lua/utils/tagHelpers')
local culturesData = require('data/cultures')

---@type table<string, table | nil>
local demands = {}

local function setTileData()
  local fullName = string.lower(self.getName())
  local cultureId = tonumber(string.match(self.getName(), 'Culture (%d%d).*'))
  local cultureData = table.find(culturesData, function(data)
    return data.id == cultureId
  end)

  self.setVar('data', cultureData)
end

--- Refreshes the grid layout of demands for this culture's token.
local function updateDemandUI()
  local gridLayout = {
    tag = 'GridLayout',
    attributes = {
      cellSize = '300 300',
      childAlignment = 'LowerCenter',
      width = 940,
      height = 940,
      rotation = '90 0 180',
      spacing = '20 20',
      position = '0 0 -500',
      scale = '1 0.75',
    },
    children = {},
  }

  local assetsLookup = {}
  table.forEach(demands, function(demand, guid)
    -- TTS hates assets that have the same URL for some reason. Store a single URL per unique filename.
    local url = demand.CustomImage.ImageURL
    local assetName = string.match(url, '([^/]+)%.%w%w%w$')
    assetsLookup[assetName] = url

    -- Create a button the uses the filename as the `image` attr.
    table.insert(gridLayout.children, { tag = "Button", attributes = { image = assetName, onClick = 'handleDemandButtonClick(' .. guid .. ')' } })
  end)

  -- Iterate the unique URLs and create a single asset for each
  local assets = table.reduce(assetsLookup, function (acc, url, assetName)
    table.insert(acc, { name = assetName, url = url })
    return acc
  end, {})

  self.UI.setCustomAssets(assets)
  self.UI.setXmlTable({ gridLayout })
end

--- On clicking a demand in the culture details UI, removes the demand from the UI and spawns the actual object.
---@param player table
---@param guid string
local function spawnDemand(player, guid)
  local allowedColors = constants.ALLOWED_PLAYER_COLORS
  local playerIsAllowed = table.includes(allowedColors, player.color)
  if (not playerIsAllowed) then
    broadcastToColor('You must be seated at the table to use this.', player.color, 'Red')
    return
  end

  local data = demands[guid]
  demands[guid] = nil
  if (data) then
    local selfPos = self.getPosition()
    spawnObjectData({
      data = data,
      position = { x = selfPos.x, y = selfPos.y + 5, z = selfPos.z - 2 },
      callback_function = function(obj) obj.deal(1, player.color) end,
    })
  end
  updateDemandUI()
end

---@param obj table
---@return boolean
local function isEventToken(obj)
  return tagHelpers.objHasAllTags(obj, { 'event', 'token' })
end

function onLoad()
  setTileData()
  updateDemandUI()
end

function onSpawn()
  setTileData()
  updateDemandUI()
end

function handleDemandButtonClick(player, guid)
  spawnDemand(player, guid)
end

local collisionDebounce = 0
function onCollisionEnter(collisionInfo)
  local timestamp = os.clock()
  if (timestamp < collisionDebounce) then return end
  collisionDebounce = timestamp + 0.3

  local obj = collisionInfo.collision_object
  if (isEventToken(obj)) then
    local objData = obj.getVar('data')
    local objDest = objData and (objData.from or objData.to)
    local selfData = self.getVar('data')
    local selfId = selfData.id
    log('Token Destination: ' .. objDest .. ' | Culture ID: ' .. selfId)
    if (objDest == selfId) then
      local guid = obj.getGUID()
      local data = obj.getData()
      demands[guid] = data
      obj.destruct()
    end
    updateDemandUI()
  end
end
