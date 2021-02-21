require("lua/utils/table")

function onLoad(save_state)
  updatePlayerDisplay()
end

function onObjectEnterScriptingZone(zone, enter_object)
  if(zone == self) then
    updatePlayerDisplay()
  end
end

function onObjectLeaveScriptingZone(zone, enter_object)
  if(zone == self) then
    updatePlayerDisplay()
  end
end

function updatePlayerDisplay()
  local containedObjects = self.getObjects()
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
      return scoringItem.value or 0
    end
  )
  return table.sum(values)
end

function isPlayerDisplay(obj)
  return obj.hasTag('player') and obj.hasTag('display')
end

function isCash(obj)
  return obj.hasTag('credits')
end

function isScoringItem(obj)
  return obj.hasTag('scoring')
end
