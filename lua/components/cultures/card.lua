require('lua/utils/table')
local constants = require('lua/global/constants')
local tagHelpers = require('lua/utils/tagHelpers')
local interactions = require('lua/utils/interactions')
local cultureData = require('data/cultures')

local function setCardValue()
  local cultureId = tonumber(string.match(self.getName(), 'Culture (%d%d).*'))
  local cardData = table.find(cultureData, function (data)
    return data.id == cultureId
  end)

  self.setVar('data', cardData)
  self.setVar('iou', cardData.iou)
end

--- Get the scripting zone for this card's system
---@return table
local function getSystem()
  local systemZones = getObjectsWithAllTags({ 'system', 'zone' })
  local systemZone = table.find(systemZones, function(zone)
    return table.includes(zone.getObjects(), self)
  end)

  return systemZone
end

--- Get the tagName for this card's system (eg 'S05')
---@param system table
---@return string
local function getSystemTag(system)
  return table.find(constants.SYSTEM_TAGS, function(systemTag) return system.hasTag(systemTag) end)
end

--- Deals the Goods, Factory Deed, and Culture Token for a given culture to a given system.
---@param systemTag string
local function dealCultureTokensToSystem(systemTag)
  if (systemTag == nil) then return end

  local cultureTag = 'c' .. string.match(self.getName(), 'Culture (%d%d).*')

  local cultureTokens = getObjectsWithAllTags({ cultureTag, 'token' })
  local systemSnaps = table.filter(Global.getSnapPoints(), function(snap) return tagHelpers.snapHasTag(snap, systemTag) end)
  local cultureSnaps = table.filter(systemSnaps, function(snap) return tagHelpers.snapHasTag(snap, 'culture') end)

  local cultureDetailsToken = table.find(cultureTokens, function(obj) return obj.hasTag('details') end)
  local cultureDetailsSnap = table.find(cultureSnaps, function(snap) return tagHelpers.snapHasTag(snap, 'details') end)

  local normalGoodsToken = table.find(cultureTokens, function(obj) return obj.hasTag('normal') and obj.hasTag('good') end)
  local normalGoodsSnap = table.find(cultureSnaps, function(snap) return tagHelpers.snapHasAllTags(snap, {'normal', 'good'}) end)

  local factoryGoodsToken = table.find(cultureTokens, function(obj) return obj.hasTag('factory') and obj.hasTag('good') end)
  local factoryGoodsSnap = table.find(cultureSnaps, function(snap) return tagHelpers.snapHasAllTags(snap, {'factory', 'good'}) end)

  local factoryDeedToken = table.find(cultureTokens, function(obj) return obj.hasTag('factory') and obj.hasTag('deed') end)
  local factoryDeedSnap = table.find(cultureSnaps, function(snap) return tagHelpers.snapHasAllTags(snap, {'factory', 'deed'}) end)

  interactions.dealObjectToSnap(cultureDetailsToken, cultureDetailsSnap)
  interactions.dealObjectToSnap(normalGoodsToken, normalGoodsSnap)
  interactions.dealObjectToSnap(factoryGoodsToken, factoryGoodsSnap)
  interactions.dealObjectToSnap(factoryDeedToken, factoryDeedSnap)
end

---@param player table
local function discover(player)
  local allowedColors = constants.ALLOWED_PLAYER_COLORS
  local playerIsAllowed = table.includes(allowedColors, player.color)
  if (not playerIsAllowed) then return end

  local systemZone = getSystem()
  if (systemZone == nil) then return end

  local systemTag = getSystemTag(systemZone)

  self.UI.hide('discoverButton')
  self.deal(1, player.color)

  dealCultureTokensToSystem(systemTag)
end

--- Called from a button in the XML UI. Cannot be `local` function.
function handleDiscoverClick(player)
  discover(player)
end

function onLoad()
  setCardValue()
end

function onSpawn()
  setCardValue()
end
