require("lua/utils/table")

function discover(player)
  local allowedColors = Global.getVar("ALLOWED_PLAYER_COLORS")
  local playerIsAllowed = table.includes(allowedColors, player.color)
  if (not playerIsAllowed) then return end

  local systemZone = getSystem()

  self.UI.hide('discoverButton')
  self.deal(1, player.color)
  dealCultureTokensToSystem(systemZone)
end

function getCultureTag()
  return table.find(Global.getVar('CULTURE_TAGS'), |cultureTag| self.hasTag(cultureTag))
end

function getSystemTag()
end

function getSystem()
  local systemZones = table.filter(getObjects(), function(obj)
    return obj.hasTag('system') and obj.hasTag('zone')
  end)

  local systemZone = table.find(systemZones, |zone| table.includes(zone.getObjects(), self))

  return systemZone
end

function dealCultureTokensToSystem(systemZone)
  if (systemZone == nil) then return end
  local cultureTokens = getCultureTokens()
  -- TODO: ZONE.getSnapPoints() doesn't fucking work, so.... whatnow?
  local systemSnaps = systemZone.getSnapPoints()
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

function dealTokenToSnap(token, snap)
  -- log(snap)
end

function getCultureTokens()
  local cultureTag = getCultureTag()
  local culturePoolZoneGUID = Global.getVar('CulturePoolZoneGUID')
  local culturePoolZone = getObjectFromGUID(culturePoolZoneGUID)
  return table.filter(culturePoolZone.getObjects(), |obj| obj.hasTag(cultureTag) and obj.hasTag('token'))
end
