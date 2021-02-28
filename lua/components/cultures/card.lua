require("lua/utils/table")

local systemZone = nil
local systemLocked = false

function discover(player)
  local allowedColors = Global.getVar("ALLOWED_PLAYER_COLORS")
  local playerIsAllowed = table.includes(allowedColors, player.color)
  if (not playerIsAllowed) then return end

  self.UI.hide('discoverButton')
  self.deal(1, player.color)

  dealCultureTokensToSystem()
end

function dealCultureTokensToSystem()
  if (systemZone == nil) then return end
  local zoneObjects = systemZone.getObjects()
end

-- ============================================================================
-- We assume that we are being spawned as a result of the user clicking the
-- "Setup" button, which means that we are currently hurtling through the air
-- trying to find our home system. When we stop moving, assume that we have
-- landed at our home system, and lock that value in.
-- ============================================================================
function onObjectSpawn(obj)
  if (obj == self) then
    lockSystemWhenResting()
  end
end

-- ============================================================================
-- As the card moves through scripting zones, check to see whether any
-- of the zones are "system" zones. If they are, register them as the
-- systemZone. When lockSystemWhenResting(), start waiting until
-- all movement has stopped. When it has, lock the current system zone
-- and assume that this card has found its culture's home.
-- ============================================================================
function onObjectEnterScriptingZone(zone, obj)
  if (obj ~= self) then return end

  registerSystem(zone)
end

function registerSystem(zone)
  if (systemLocked or not zone.hasTag('system')) then return end

  systemZone = zone
end

function lockSystem()
  if (systemLocked) then return end

  systemLocked = true
end

function lockSystemWhenResting()
  Wait.condition(lockSystem, || self.resting)
end
