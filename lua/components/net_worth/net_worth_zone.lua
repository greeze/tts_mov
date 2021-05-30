require('lua/utils/table')
local sumValueItems = require('lua/utils/sumValueItems')
local tagHelpers = require('lua/utils/tagHelpers')

---@param obj table
---@return boolean
local function isCash(obj)
  return tagHelpers.objHasAllTags(obj, { 'credits' })
end

---@param obj table
---@return boolean
local function isScoringItem(obj)
  return tagHelpers.objHasAllTags(obj, { 'scoring' })
end

---@param obj table
---@return boolean
local function isPlayerDisplay(obj)
  return tagHelpers.objHasAllTags(obj, { 'player', 'display' })
end

---@param containedObjects table[]
---@return integer
local function calculateCash(containedObjects)
  local cashItems = table.filter(containedObjects, isCash)
  local cashValue = sumValueItems(cashItems)
  return cashValue or 0
end

---@param containedObjects table[]
---@return integer
local function calculateTotal(containedObjects)
  local scoringItems = table.filter(containedObjects, isScoringItem)
  local totalValue = sumValueItems(scoringItems)
  return totalValue or 0
end

local function updatePlayerDisplay()
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

---@param save_state table
function onLoad(save_state)
  updatePlayerDisplay()
end

---@param zone table
function onObjectEnterZone(zone)
  if (zone == self) then
    updatePlayerDisplay()
  end
end

---@param zone table
function onObjectLeaveZone(zone)
  if (zone ~= nil and zone == self) then
    updatePlayerDisplay()
  end
end
