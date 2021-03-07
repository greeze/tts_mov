require('lua/utils/table')
local constants = require('lua/global/constants')

local demands = {}

function onLoad()
  updateDemandUI()
end

function spawnDemand(player, guid)
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
      callback_function = |obj| obj.deal(1, player.color)
    })
  end
  updateDemandUI()
end

function updateDemandUI()
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
    table.insert(gridLayout.children, { tag = "Button", attributes = { image = guid, onClick = 'spawnDemand(' .. guid .. ')' } })
  end)

  self.UI.setCustomAssets(assets)
  self.UI.setXmlTable({ gridLayout })
end

function isEventToken(obj)
  return obj.hasTag('event') and obj.hasTag('token')
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
