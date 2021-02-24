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
