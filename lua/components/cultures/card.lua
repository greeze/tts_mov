require("lua/utils/table")

function discover(player)
  local allowedColors = Global.getVar("ALLOWED_PLAYER_COLORS")
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

function getSystem()
  local systemZones = table.filter(getObjects(), function(obj)
    return obj.hasTag('system') and obj.hasTag('zone')
  end)

  local systemZone = table.find(systemZones, |zone| table.includes(zone.getObjects(), self))

  return systemZone
end

function getCultureTag()
  return table.find(Global.getVar('CULTURE_TAGS'), |cultureTag| self.hasTag(cultureTag))
end

function getSystemTag(system)
  return table.find(Global.getVar('SYSTEM_TAGS'), |systemTag| system.hasTag(systemTag))
end

function dealCultureTokensToSystem(cultureTag, systemTag)
  if (systemTag == nil) then return end

  local cultureTokens = getObjectsWithAllTags({ cultureTag, 'token' })
  local systemSnaps = table.filter(Global.getSnapPoints(), |snap| snapHasTag(snap, systemTag))
  local cultureSnaps = table.filter(systemSnaps, |snap| snapHasTag(snap, 'culture'))

  local cultureDetailsToken = table.find(cultureTokens, |obj| obj.hasTag('details'))
  local cultureDetailsSnap = table.find(cultureSnaps, |snap| snapHasTag(snap, 'details'))

  local normalGoodsToken = table.find(cultureTokens, |obj| obj.hasTag('normal') and obj.hasTag('good'))
  local normalGoodsSnap = table.find(cultureSnaps, |snap| snapHasAllTags(snap, {'normal', 'good'}))

  local factoryGoodsToken = table.find(cultureTokens, |obj| obj.hasTag('factory') and obj.hasTag('good'))
  local factoryGoodsSnap = table.find(cultureSnaps, |snap| snapHasAllTags(snap, {'factory', 'good'}))

  local factoryDeedToken = table.find(cultureTokens, |obj| obj.hasTag('factory') and obj.hasTag('deed'))
  local factoryDeedSnap = table.find(cultureSnaps, |snap| snapHasAllTags(snap, {'factory', 'deed'}))

  dealTokenToSnap(cultureDetailsToken, cultureDetailsSnap)
  dealTokenToSnap(normalGoodsToken, normalGoodsSnap)
  dealTokenToSnap(factoryGoodsToken, factoryGoodsSnap)
  dealTokenToSnap(factoryDeedToken, factoryDeedSnap)
end

function dealTokenToSnap(token, snap)
  token.setLock(false)
  local destPosition = {
    x = snap.position.x,
    y = snap.position.y + 1,
    z = snap.position.z,
  }
  token.setPositionSmooth(destPosition, false, true)
end

function snapHasAllTags(snap, tags)
  local hasAllTags = true
  table.forEach(tags, function(tag)
    if (not snapHasTag(snap, tag)) then
      hasAllTags = false
    end
  end)
  return hasAllTags
end

function snapHasTag(snap, tag)
  return table.includes(snap.tags, tag)
end
