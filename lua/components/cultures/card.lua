require('lua/utils/table')
local constants = require('lua/global/constants')

---@param player table
function discover(player)
  local allowedColors = constants.ALLOWED_PLAYER_COLORS
  local playerIsAllowed = table.includes(allowedColors, player.color)
  if (not playerIsAllowed) then return end

  local systemZone = getSystem()
  if (systemZone == nil) then return end

  local cultureTag = getCultureTag()
  local systemTag = getSystemTag(systemZone)

  self.UI.hide('discoverButton')
  self.deal(1, player.color)

  dealCultureTokensToSystem(cultureTag, systemTag)
end

---@param snap table
---@param tag string
---@return boolean
function snapHasTag(snap, tag)
  return table.includes(snap.tags, tag)
end

---@param snap table
---@param tags string[]
---@return boolean
function snapHasAllTags(snap, tags)
  local hasAllTags = true
  table.forEach(tags, function(tag)
    if (not snapHasTag(snap, tag)) then
      hasAllTags = false
    end
  end)
  return hasAllTags
end

---@return table
function getSystem()
  local systemZones = table.filter(getObjects(), function(obj)
    return obj.hasTag('system') and obj.hasTag('zone')
  end)

  ---@type table
  local systemZone = table.find(systemZones, function(zone) return table.includes(zone.getObjects(), self) end)

  return systemZone
end

---@return string
function getCultureTag()
  return table.find(constants.CULTURE_TAGS, function(cultureTag) return self.hasTag(cultureTag) end)
end

---@param system table
---@return string
function getSystemTag(system)
  return table.find(constants.SYSTEM_TAGS, function(systemTag) return system.hasTag(systemTag) end)
end

---@param cultureTag string
---@param systemTag string
function dealCultureTokensToSystem(cultureTag, systemTag)
  if (systemTag == nil) then return end

  local cultureTokens = getObjectsWithAllTags({ cultureTag, 'token' })
  local systemSnaps = table.filter(Global.getSnapPoints(), function(snap) return snapHasTag(snap, systemTag) end)
  local cultureSnaps = table.filter(systemSnaps, function(snap) return snapHasTag(snap, 'culture') end)

  local cultureDetailsToken = table.find(cultureTokens, function(obj) return obj.hasTag('details') end)
  local cultureDetailsSnap = table.find(cultureSnaps, function(snap) return snapHasTag(snap, 'details') end)

  local normalGoodsToken = table.find(cultureTokens, function(obj) return obj.hasTag('normal') and obj.hasTag('good') end)
  local normalGoodsSnap = table.find(cultureSnaps, function(snap) return snapHasAllTags(snap, {'normal', 'good'}) end)

  local factoryGoodsToken = table.find(cultureTokens, function(obj) return obj.hasTag('factory') and obj.hasTag('good') end)
  local factoryGoodsSnap = table.find(cultureSnaps, function(snap) return snapHasAllTags(snap, {'factory', 'good'}) end)

  local factoryDeedToken = table.find(cultureTokens, function(obj) return obj.hasTag('factory') and obj.hasTag('deed') end)
  local factoryDeedSnap = table.find(cultureSnaps, function(snap) return snapHasAllTags(snap, {'factory', 'deed'}) end)

  dealTokenToSnap(cultureDetailsToken, cultureDetailsSnap)
  dealTokenToSnap(normalGoodsToken, normalGoodsSnap)
  dealTokenToSnap(factoryGoodsToken, factoryGoodsSnap)
  dealTokenToSnap(factoryDeedToken, factoryDeedSnap)
end

---@param token table
---@param snap table
function dealTokenToSnap(token, snap)
  token.setLock(false)
  local destPosition = {
    x = snap.position.x,
    y = snap.position.y + 1,
    z = snap.position.z,
  }
  token.setPositionSmooth(destPosition, false)
end
