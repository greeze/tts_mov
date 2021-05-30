require('lua/utils/table')
local constants = require('lua/global/constants')
local tagHelpers = require('lua/utils/tagHelpers')

---@type table<string, table | nil>
local demands = {}

--- Refreshes the grid layout of demands for this culture's token.
local function updateDemandUI()
  local assets = {}
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

  table.forEach(demands, function(demand, guid)
    table.insert(assets, { name = guid, url = demand.CustomImage.ImageURL })
    table.insert(gridLayout.children, { tag = "Button", attributes = { image = guid, onClick = 'handleDemandButtonClick(' .. guid .. ')' } })
  end)

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
  updateDemandUI()
end

function handleDemandButtonClick(player, guid)
  spawnDemand(player, guid)
end

function onCollisionEnter(collisionInfo)
  local obj = collisionInfo.collision_object
  if (isEventToken(obj)) then
    local guid = obj.getGUID()
    local data = obj.getData()
    demands[guid] = data
    obj.destruct()
  end
  updateDemandUI()
end
