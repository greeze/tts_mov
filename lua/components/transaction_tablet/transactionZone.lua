require('lua/utils/table')
local constants = require('lua/global/constants')
local money = require('lua/global/money')
local sumValueItems = require('lua/utils/sumValueItems')
local tagHelpers = require('lua/utils/tagHelpers')
local interactions = require('lua/utils/interactions')

-- likelihood that a user's intent is to buy or sell, based on items added
local initialLikelihoods = { buy = 0, sell = 0 }
local transactionLikelihoods = {}

---@param obj table
---@return boolean
local function isTransactionTablet(obj)
  return tagHelpers.objHasAllTags(obj, { 'tablet', 'transactions' })
end

---@param obj table
---@return boolean
local function isCash(obj)
  return tagHelpers.objHasAllTags(obj, { 'credits', 'token' })
end

---@param obj table
---@return boolean
local function isSpaceportDeed(obj)
  return tagHelpers.objHasAllTags(obj, { 'spaceport', 'deed', 'token' })
end

---@param obj table
---@return boolean
local function isFactoryDeed(obj)
  return tagHelpers.objHasAllTags(obj, { 'factory', 'deed', 'token' })
end

---@param obj table
---@return boolean
local function isGood(obj)
  return tagHelpers.objHasAllTags(obj, { 'good', 'token' })
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

---@param obj table
---@return boolean
local function isEquipment(obj)
  return tagHelpers.objHasAllTags(obj, { 'equipment', 'token' })
end

---@param obj table
---@return boolean
local function isRelic(obj)
  return tagHelpers.objHasAllTags(obj, { 'relic', 'encounter' })
end

--- Resets the estimated transaction types
local function resetLikelihoods()
  transactionLikelihoods = table.merge({}, initialLikelihoods)
end

--- Attempts to guess the likeliest transaction intended for the given obj
---@param obj table
---@return boolean | string
local function determineLikelyTransactionFromObject(obj)
  local likelyTransactionType = false
  if (isGood(obj)) then
    if (obj.is_face_down) then
      likelyTransactionType = 'sell'
    else
      likelyTransactionType = 'buy'
    end
  elseif (
    isSpaceportDeed(obj) or
    isFactoryDeed(obj) or
    isCultureCard(obj)
  ) then
    likelyTransactionType = 'buy'
  elseif (
    isDemand(obj) or
    isRelic(obj) or
    isPassenger(obj)
  ) then
    likelyTransactionType = 'sell'
  end

  return likelyTransactionType
end

local function addToLikelihoods(obj)
  local estimatedTransactionType = determineLikelyTransactionFromObject(obj)
  if (estimatedTransactionType) then
    transactionLikelihoods[estimatedTransactionType] = transactionLikelihoods[estimatedTransactionType] + 1
  end
end

local function removeFromLikelihoods(obj)
  local estimatedTransactionType = determineLikelyTransactionFromObject(obj)
  if (estimatedTransactionType) then
    transactionLikelihoods[estimatedTransactionType] = transactionLikelihoods[estimatedTransactionType] - 1
  end
end

---@param containedObjects table[]
---@return table[]
local function getCash(containedObjects)
  return table.filter(containedObjects, isCash)
end

---@param containedObjects table[]
---@return table[]
local function getSpaceportDeeds(containedObjects)
  return table.filter(containedObjects, isSpaceportDeed)
end

---@param containedObjects table[]
---@return table[]
local function getFactoryDeeds(containedObjects)
  return table.filter(containedObjects, isFactoryDeed)
end

---@param containedObjects table[]
---@return table[]
local function getGoods(containedObjects)
  return table.filter(containedObjects, isGood)
end

---@param containedObjects table[]
---@return table[]
local function getPassengers(containedObjects)
  return table.filter(containedObjects, isPassenger)
end

---@param containedObjects table[]
---@return table[]
local function getDemands(containedObjects)
  return table.filter(containedObjects, isDemand)
end

---@param containedObjects table[]
---@return table[]
local function getCultureCards(containedObjects)
  return table.filter(containedObjects, isCultureCard)
end

---@param containedObjects table[]
---@return table[]
local function getEquipment(containedObjects)
  return table.filter(containedObjects, isEquipment)
end

---@param containedObjects table[]
---@return table[]
local function getRelics(containedObjects)
  return table.filter(containedObjects, isRelic)
end

---@param cashItems table[]
---@return integer
local function calculateCash(cashItems)
  return sumValueItems(cashItems) or 0
end

---@param containedObjects table[]
---@return integer
local function calculateIou(containedObjects)
  local iou = 0
  local cultureCards = getCultureCards(containedObjects)
  if (#cultureCards > 0) then
    iou = cultureCards[1].getVar('iou') or 0
  end
  return iou
end

---@param spaceportDeeds table[]
---@return integer
local function calculateSpaceportDeedValues(spaceportDeeds)
  return sumValueItems(spaceportDeeds) or 0
end

---@param factoryDeeds table[]
---@return integer
local function calculateFactoryDeedValues(factoryDeeds)
  return sumValueItems(factoryDeeds) or 0
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
  table.forEach(passengers, function(passenger)
    passengerTotal = passengerTotal + passenger.getVar('value')
  end)
  return passengerTotal
end

---@param demands table[]
---@return integer
local function calculateDemandValues(demands)
  local demandTotal = 0
  table.forEach(demands, function(demand)
    demandTotal = demandTotal + demand.getVar('value')
  end)
  return demandTotal
end

---@param equipments table[]
---@return integer
local function calculateEquipmentValues(equipments)
  local equipmentTotal = 0
  table.forEach(equipments, function(equipment)
    equipmentTotal = equipmentTotal + equipment.getVar('value')
  end)
  return equipmentTotal
end

---@param relics table[]
---@return integer
local function calculateRelicValues(relics)
  local relicTotal = 0
  table.forEach(relics, function(relic)
    relicTotal = relicTotal + relic.getVar('value')
  end)
  return relicTotal
end

local function updateTransactionTablet()
  local containedObjects = self.getObjects()
  local transactionTablet = table.find(containedObjects, isTransactionTablet)

  if (transactionTablet ~= nil) then
    -- ========================================================================
    -- Buy
    -- ========================================================================
    -- Payments
    local cashItems = getCash(containedObjects)
    local cashTotal = calculateCash(cashItems)
    local iou = calculateIou(containedObjects)

    -- Items
    local spaceportDeeds = getSpaceportDeeds(containedObjects)
    local spaceportDeedTotal = calculateSpaceportDeedValues(spaceportDeeds)

    local factoryDeeds = getFactoryDeeds(containedObjects)
    local factoryDeedTotal = calculateFactoryDeedValues(factoryDeeds)

    -- ========================================================================
    -- Sell
    -- ========================================================================
    local passengers = getPassengers(containedObjects)
    local passengerTotal = calculatePassengerValues(passengers)

    local demands = getDemands(containedObjects)
    local demandTotal = calculateDemandValues(demands)

    -- ========================================================================
    -- Both Buy and Sell
    -- ========================================================================
    local goods = getGoods(containedObjects)
    local buyGoodsTotal, sellGoodsTotal, factoryTotal = calculateGoodsValues(goods)

    local equipment = getEquipment(containedObjects)
    local equipmentTotal = calculateEquipmentValues(equipment)

    local relics = getRelics(containedObjects)
    local relicTotal = calculateRelicValues(relics)

    -- ========================================================================
    -- Totals
    -- ========================================================================
    local playerGets = sellGoodsTotal + cashTotal + passengerTotal + demandTotal + (equipmentTotal / 2) + (relicTotal / 2)
    local playerOwes = (buyGoodsTotal + equipmentTotal + relicTotal + spaceportDeedTotal + factoryDeedTotal) - (cashTotal + iou)

    ---@type State
    local buyState = {
      cashTotal = cashTotal,
      playerOwes = playerOwes,
      factoryGets = factoryTotal,
      spaceportGets = buyGoodsTotal * 0.1,
    }

    ---@type State
    local sellState = {
      playerGets = playerGets,
      spaceportGets = (sellGoodsTotal + demandTotal) * 0.1,
    }

    local likelyTransactionType = false
    local likelyBuyWeight = transactionLikelihoods.buy
    local likelySellWeight = transactionLikelihoods.sell
    if (likelyBuyWeight > likelySellWeight) then
      likelyTransactionType = 'buy'
    elseif (likelySellWeight > likelyBuyWeight) then
      likelyTransactionType = 'sell'
    end

    ---@type TransactionStates
    local transactionStates = { buyState = buyState, sellState = sellState, likelyTransactionType = likelyTransactionType }

    transactionTablet.call('handleNewStateFromTransactionZone', transactionStates)
  end
end

local function discardItems(items, discard)
  table.forEach(items, function(item)
    discard.putObject(item)
  end)
end

local function resolveBuy(player, transactionState, goods, equipments, relics, spaceportDeeds, factoryDeeds)
  if (transactionState.transaction == 'buy') then
    if (transactionState.playerOwes < 0) then
      local playerRefund = transactionState.playerOwes * -1
      local adjustedAmount = math.min(playerRefund, transactionState.cashTotal)
      money.payPlayer(adjustedAmount, player)
    end

    if (transactionState.factoryColor) then
      money.payPlayer(transactionState.factoryGets, Player[transactionState.factoryColor])
    end

    table.forEach(goods, function(good)
      -- I tried 9999, but it glitched out. 10 stacked goods is still impossibly high without cheating.
      good.deal(10, player.color)
    end)

    table.forEach(equipments, function(equipment)
      equipment.deal(10, player.color)
    end)

    table.forEach(relics, function(relic)
      relic.deal(10, player.color)
    end)

    table.forEach(spaceportDeeds, function(spaceport)
      spaceport.deal(10, player.color)
    end)

    table.forEach(factoryDeeds, function(factory)
      factory.deal(10, player.color)
    end)
  end
end

local function resolveSell(player, transactionState, goods, passengers, demands, relics)
  if (transactionState.transaction == 'sell') then
    money.payPlayer(transactionState.playerGets, player)

    local eventStagingZone = getObjectFromGUID(constants.GUIDS.EventStagingLayoutGUID)
    local eventStagingPosition = eventStagingZone.getPosition()
    local drawbag = getObjectFromGUID(constants.GUIDS.EventTokenBagGUID)
    local drawbagPosition = drawbag.getPosition() + Vector(0, 5, 0)
    local nextToTablet = self.getPosition() + Vector(-7, 5, 0)

    interactions.dealObjectsToPosition(goods, eventStagingPosition)
    interactions.dealObjectsToPosition(passengers, eventStagingPosition)
    interactions.dealObjectsToPosition(demands, eventStagingPosition)
    interactions.dealObjectsToPosition(relics, nextToTablet)

    local relicsNeedPlacing = relics and #relics > 0
    local drawbagItemsNeedPlacing = (goods and #goods > 0) or (passengers and #passengers > 0) or (demands and #demands > 0)

    Wait.time(function()
      eventStagingZone.LayoutZone.layout()
      if (relicsNeedPlacing) then
        Player[player.color].pingTable(nextToTablet + Vector(0, -5, 0))
        broadcastToAll('Remember to place sold relics on the system you sold them to.', player.color)
      end
      if (drawbagItemsNeedPlacing) then
        Player[player.color].pingTable(drawbagPosition)
        Player[player.color].lookAt({ position = drawbagPosition, pitch = 30, yaw = 30 })
        broadcastToAll('Remember to place sold goods, passengers, and demands into the drawbag and draw new ones.', player.color)
      end
    end, 1)
  end
end

local function resolveTransaction(player, transactionState)
  local containedObjects = self.getObjects()
  local cashItems = getCash(containedObjects)
  local spaceportDeeds = getSpaceportDeeds(containedObjects)
  local factoryDeeds = getFactoryDeeds(containedObjects)
  local cultureCards = getCultureCards(containedObjects)
  local passengers = getPassengers(containedObjects)
  local firstDemand = getDemands(containedObjects)[1]
  local goods = getGoods(containedObjects)
  local equipment = getEquipment(containedObjects)
  local relics = getRelics(containedObjects)

  -- Randomly choose a discard location for discarded items
  local discards = getObjectsWithTag('discard')
  local discard = discards[(math.random(1, #discards))]

  discardItems(cashItems, discard)
  if (transactionState.transaction == 'buy') then
    discardItems(cultureCards, discard)
  else
    discardItems(equipment, discard)
  end

  resolveBuy(player, transactionState, goods, equipment, relics, spaceportDeeds, factoryDeeds)
  resolveSell(player, transactionState, goods, passengers, { firstDemand }, relics)

  if (transactionState.spaceportColor) then
    money.payPlayer(transactionState.spaceportGets, Player[transactionState.spaceportColor])
  end

  Wait.time(function ()
    resetLikelihoods()
    updateTransactionTablet()
  end, 1)
end

--- Called by transactionTablet when submit is clicked. Takes player and transactionState.
---@param submitParams table
function handleSubmit(submitParams)
  local player = submitParams.player
  local transactionState = submitParams.transactionState
  resolveTransaction(player, transactionState)
  resetLikelihoods()
end

---@param zone table
function onObjectEnterZone(zone, obj)
  if (zone == self) then
    addToLikelihoods(obj)
    updateTransactionTablet()
  end
end

---@param zone table
function onObjectLeaveZone(zone, obj)
  if (zone == self) then
    removeFromLikelihoods(obj)
    updateTransactionTablet()
  end
end

function onLoad()
  resetLikelihoods()
  money.init()
end
