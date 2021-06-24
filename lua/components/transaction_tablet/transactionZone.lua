require('lua/utils/table')
local constants = require('lua/global/constants')
local money = require('lua/global/money')
local sumValueItems = require('lua/utils/sumValueItems')
local tagHelpers = require('lua/utils/tagHelpers')
local interactions = require('lua/utils/interactions')

---@param obj table
---@return boolean
local function isTransactionTablet(obj)
  return tagHelpers.objHasAllTags(obj, { 'tablet', 'transactions' })
end

---@param obj table
---@return boolean
local function isCash(obj)
  return tagHelpers.objHasAllTags(obj, { 'credits' })
end

---@param obj table
---@return boolean
local function isGood(obj)
  return tagHelpers.objHasAllTags(obj, { 'good' })
end

---@param obj table
---@return boolean
local function isPassenger(obj)
  return tagHelpers.objHasAllTags(obj, { 'passenger', 'event' })
end

---@param obj table
---@return boolean
local function isDemand(obj)
  return tagHelpers.objHasAllTags(obj, { 'demand', 'event' })
end

---@param obj table
---@return boolean
local function isCultureCard(obj)
  return tagHelpers.objHasAllTags(obj, { 'culture', 'card' })
end

local function getCash(containedObjects)
  return table.filter(containedObjects, isCash)
end

local function getGoods(containedObjects)
  return table.filter(containedObjects, isGood)
end

local function getPassengers(containedObjects)
  return table.filter(containedObjects, isPassenger)
end

local function getDemands(containedObjects)
  return table.filter(containedObjects, isDemand)
end

local function getCultureCards(containedObjects)
  return table.filter(containedObjects, isCultureCard)
end

---@param cashItems table[]
---@return integer
local function calculateCash(cashItems)
  return sumValueItems(cashItems) or 0
end

--- Sets buyValue and sellValue for the given good
---@param obj table
---@return integer, integer, number
local function getValuesForGood(obj)
  local quantity = math.abs(obj.getQuantity())

  local buyValue = obj.getVar('buyValue') * quantity
  local sellValue = obj.getVar('sellValue') * quantity
  local factoryValue = obj.getVar('factoryValue')

  return buyValue, sellValue, factoryValue
end

---@param goods table[]
---@return integer, integer, number
local function calculateGoodsValues(goods)
  local buyTotal = 0
  local sellTotal = 0
  local factoryTotal = 0

  table.forEach(goods, function(obj)
    local buyValue, sellValue, factoryValue = getValuesForGood(obj)
    buyTotal = buyTotal + buyValue
    sellTotal = sellTotal + sellValue
    factoryTotal = factoryTotal + factoryValue
  end)

  return buyTotal, sellTotal, factoryTotal
end

---@param passengers table[]
---@return integer
local function calculatePassengerValues(passengers)
  local passengerTotal = 0
  table.forEach(passengers, function (passenger)
    passengerTotal = passengerTotal + passenger.getVar('value')
  end)
  return passengerTotal
end

---@param demands table[]
---@return integer
local function calculateDemandValues(demands)
  local demandTotal = 0
  table.forEach(demands, function (demand)
    demandTotal = demandTotal + demand.getVar('value')
  end)
  return demandTotal
end

local function calculateIou(containedObjects)
  local iou = 0
  local cultureCards = getCultureCards(containedObjects)
  if (#cultureCards > 0) then
    iou = cultureCards[1].getVar('iou') or 0
  end
  return iou
end

local function updateTransactionTablet()
  local containedObjects = self.getObjects()
  local transactionTablet = table.find(containedObjects, isTransactionTablet)

  if (transactionTablet ~= nil) then
    local cashItems = getCash(containedObjects)
    local cashTotal = calculateCash(cashItems)

    local goods = getGoods(containedObjects)
    local buyTotal, sellTotal, factoryTotal = calculateGoodsValues(goods)

    local passengers = getPassengers(containedObjects)
    local passengerTotal = calculatePassengerValues(passengers)

    local demands = getDemands(containedObjects)
    local demandTotal = calculateDemandValues(demands)

    local iou = calculateIou(containedObjects)

    local playerGets = sellTotal + cashTotal + passengerTotal + demandTotal
    local playerOwes = buyTotal - (cashTotal + iou)

    ---@type State
    local buyState = {
      cashTotal = cashTotal,
      playerOwes = playerOwes,
      factoryGets = factoryTotal,
      spaceportGets = buyTotal * 0.1,
    }

    ---@type State
    local sellState = {
      playerGets = playerGets,
      spaceportGets = (sellTotal + demandTotal) * 0.1,
    }

    ---@type TransactionStates
    local transactionStates = { buyState = buyState, sellState = sellState }

    transactionTablet.call('handleNewStateFromTransactionZone', transactionStates)
  end
end

local function discardItems(items, discard)
  table.forEach(items, function(cashItem)
    discard.putObject(cashItem)
  end)
end

local function resolveBuy(player, transactionState, goods)
  if (transactionState.transaction == 'buy') then
    if (transactionState.playerOwes < 0) then
      local playerRefund = transactionState.playerOwes * -1
      money.payPlayer(playerRefund, player)
    end

    if (transactionState.factoryColor) then
      money.payPlayer(transactionState.factoryGets, Player[transactionState.factoryColor])
    end

    table.forEach(goods, function(good)
      -- I tried 9999, but it glitched out. 10 stacked goods is still impossibly high without cheating.
      good.deal(10, player.color)
    end)
  end
end

local function resolveSell(player, transactionState, goods, passengers, demands)
  if (transactionState.transaction == 'sell') then
    money.payPlayer(transactionState.playerGets, player)

    local eventStagingZone = getObjectFromGUID(constants.GUIDS.EventStagingLayoutGUID)
    local eventStagingPosition = eventStagingZone.getPosition()

    interactions.dealObjectsToPosition(goods, eventStagingPosition)
    interactions.dealObjectsToPosition(passengers, eventStagingPosition)
    interactions.dealObjectsToPosition(demands, eventStagingPosition)

    Wait.time(function()
      eventStagingZone.LayoutZone.layout()
    end, 1)
  end
end

local function resolveTransaction(player, transactionState)
  local containedObjects = self.getObjects()
  local cashItems = getCash(containedObjects)
  local goods = getGoods(containedObjects)
  local passengers = getPassengers(containedObjects)
  local firstDemand = getDemands(containedObjects)[1]
  local cultureCards = getCultureCards(containedObjects)
  local discards = getObjectsWithTag('discard')
  local discard = discards[(math.random(1, #discards))]

  discardItems(cashItems, discard)
  discardItems(cultureCards, discard)

  resolveBuy(player, transactionState, goods)
  resolveSell(player, transactionState, goods, passengers, { firstDemand })

  if (transactionState.spaceportColor) then
    money.payPlayer(transactionState.spaceportGets, Player[transactionState.spaceportColor])
  end

  updateTransactionTablet()
end

--- Called by transactionTablet when submit is clicked. Takes player and transactionState.
---@param submitParams table
function handleSubmit(submitParams)
  local player = submitParams.player
  local transactionState = submitParams.transactionState
  resolveTransaction(player, transactionState)
end

---@param zone table
function onObjectEnterZone(zone)
  if (zone == self) then
    updateTransactionTablet()
  end
end

---@param zone table
function onObjectLeaveZone(zone)
  if (zone == self) then
    updateTransactionTablet()
  end
end

function onLoad()
  money.init()
end
