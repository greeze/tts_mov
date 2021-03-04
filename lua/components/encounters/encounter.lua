require('lua/utils/table')
local interactions = require('lua/utils/interactions')

function onCollisionEnter()
  toggleTooltip()
end

function onCollisionExit()
  toggleTooltip()
end

function toggleTooltip()
  if (self.is_face_down) then
    self.setName('Encounter')
  else
    self.setName(self.getGMNotes() or 'Encounter')
  end
end

function pingTelegates(player_color)
  if(self.is_face_down) then return end

  if (self.hasTag('telegate')) then
    local telegates = getObjectsWithAllTags({'telegate', 'encounter'})
    table.forEach(telegates, function(telegate)
      if (telegate ~= nil and telegate ~= self and not telegate.is_face_down) then
        interactions.pingObject(telegate, player_color)
      end
    end)
  end
end

function onPickUp(player_color)
  pingTelegates(player_color)
end
