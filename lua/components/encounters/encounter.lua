require('lua/utils/table')
local interactions = require('lua/utils/interactions')

local function toggleTooltip()
  if (self.is_face_down) then
    self.setName('Encounter')
  else
    self.setName(self.getGMNotes() or 'Encounter')
  end
end

---@param obj table
---@return boolean
local function isFaceUpTelegate(obj)
  return obj.hasTag('telegate') and not obj.is_face_down
end

local function getFaceUpTelegates()
  local telegates = getObjectsWithAllTags({'telegate', 'encounter'})
  return table.filter(telegates, function(telegate)
    return telegate ~= nil and telegate ~= self and isFaceUpTelegate(telegate)
  end)
end

---@param playerColor string
local function pingTelegates(playerColor)
  if(not isFaceUpTelegate(self)) then return end

  table.forEach(getFaceUpTelegates(), function(telegate)
    telegate.highlightOn(playerColor, 5)
    interactions.pingObject(telegate, playerColor)
  end)
end

function onCollisionEnter()
  toggleTooltip()
end

function onCollisionExit()
  toggleTooltip()
end

---@param playerColor string
function onPickUp(playerColor)
  pingTelegates(playerColor)
end
