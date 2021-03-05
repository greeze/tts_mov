require('lua/utils/table')

function onLoad(save_state)
  updatePlayerDisplay()
end

function onObjectEnterScriptingZone(zone)
  if (zone == self) then
    updatePlayerDisplay()
  end
end

function onObjectLeaveScriptingZone(zone)
  if (zone ~= nil and zone == self) then
    updatePlayerDisplay()
  end
end

function updatePlayerDisplay()
  local containedObjects = self.getObjects()
  if (containedObjects == nil or #containedObjects == 0) then return end

  local cashValue = calculateCash(containedObjects) .. ' c'
  local totalValue = calculateTotal(containedObjects) .. ' c'
  local playerDisplay = table.find(containedObjects, isPlayerDisplay)
  if (playerDisplay ~= nil) then
    playerDisplay.UI.setValue('cash', cashValue)
    playerDisplay.UI.setValue('total', totalValue)
    playerDisplay.setName('Cash: ' .. cashValue)
    playerDisplay.setDescription('Net Worth: ' .. totalValue)
  end
end

function calculateCash(containedObjects)
  local cashItems = table.filter(containedObjects, isCash)
  local cashValue = sumValues(cashItems)
  return cashValue or 0
end

function calculateTotal(containedObjects)
  local scoringItems = table.filter(containedObjects, isScoringItem)
  local totalValue = sumValues(scoringItems)
  return totalValue or 0
end

function sumValues(scoringItems)
  local values = table.map(
    scoringItems,
    function(scoringItem)
      if (scoringItem == nil) then return 0 end
      return scoringItem.value or 0
    end
  )
  return table.sum(values)
end

function isPlayerDisplay(obj)
  if (obj == nil) then return false end
  return obj.hasTag('player') and obj.hasTag('display')
end

function isCash(obj)
  if (obj == nil) then return false end
  return obj.hasTag('credits')
end

function isScoringItem(obj)
  if (obj == nil) then return false end
  return obj.hasTag('scoring')
end
