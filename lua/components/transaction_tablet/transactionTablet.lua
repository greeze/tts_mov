require('lua/utils/table')
local constants = require('lua/global/constants')

---@class State
---@field factoryColor string | boolean
---@field factoryGets number
---@field cashTotal integer
---@field playerGets integer
---@field playerOwes integer
---@field spaceportColor string | boolean
---@field spaceportGets number
---@field transaction string

---@class TransactionStates
---@field buyState State
---@field sellState State
---@field likelyTransactionType string | boolean

---@type State
local initialState = {
  factoryColor = false,
  factoryGets = 0,
  cashTotal = 0,
  playerGets = 0,
  playerOwes = 0,
  spaceportColor = false,
  spaceportGets = 0,
  transaction = 'buy',
}

---@type State
local state = {}

---@type TransactionStates
local previousTransactionStates

local transactions = { ['0'] = 'buy', ['1'] = 'sell' }
local playerColors = { ['0'] = false, ['1'] = 'yellow', ['2'] = 'red', ['3'] = 'green', ['4'] = 'orange' }
local transactionToggleButtons = { buy = 'BuyToggleButton', sell = 'SellToggleButton' }
local transactionPanes = { buy = 'BuySettings', sell = 'SellSettings' }
local xmlIDs = {
  factoryGetsText = 'FactoryGetsText',
  factoryToggleNoneBuy="FactoryToggleNoneBuy",
  playerGetsText = 'PlayerGetsText',
  playerOwesTitleText = 'PlayerOwesTitleText',
  playerOwesText = 'PlayerOwesText',
  spaceportGetsTextBuy = 'SpaceportGetsTextBuy',
  spaceportGetsTextSell = 'SpaceportGetsTextSell',
  spaceportToggleNoneBuy="SpaceportToggleNoneBuy",
  spaceportToggleNoneSell="SpaceportToggleNoneSell",
  submitButton = 'SubmitButton',
}

---@param amount integer
local function setFactoryGetsUi(amount)
  local factoryGetsStr = 'Factory Gets: ' .. amount .. 'c'

  self.UI.setValue(xmlIDs.factoryGetsText, factoryGetsStr)
end

---@param amount integer
local function setPlayerGetsUi(amount)
  local playerGetsStr = amount .. 'c'

  self.UI.setValue(xmlIDs.playerGetsText, playerGetsStr)
end

---@param amount integer
local function setPlayerOwesUi(amount, cashTotal)
  local adjustedAmount = amount
  local playerOwesTitleStr = 'Player Owes:'
  if (amount < 0) then
    adjustedAmount = math.min(amount * -1, cashTotal)

    playerOwesTitleStr = 'Player Gets Change:'
  end
  local amountStr = adjustedAmount .. 'c'

  self.UI.setValue(xmlIDs.playerOwesTitleText, playerOwesTitleStr)
  self.UI.setValue(xmlIDs.playerOwesText, amountStr)
end

---@param amount integer
local function setSpaceportGetsUi(amount)
  local spaceportGetsStr = 'Spaceport Gets: ' .. amount .. 'c'

  self.UI.setValue(xmlIDs.spaceportGetsTextBuy, spaceportGetsStr)
  self.UI.setValue(xmlIDs.spaceportGetsTextSell, spaceportGetsStr)
end

---@param transaction string
local function switchUiPane(transaction)
  table.forEach(transactionToggleButtons, function(v, k)
    local attrs = self.UI.getAttributes(v)
    attrs.isOn = k == transaction
    self.UI.setAttributes(v, attrs)
  end)
  table.forEach(transactionPanes, function(v, k)
    local attrs = self.UI.getAttributes(v)
    attrs.active = k == transaction
    self.UI.setAttributes(v, attrs)
  end)
end

---@param playerOwes number
---@param transaction string
local function validateSubmitButtonState(playerOwes, transaction)
  local attrs = self.UI.getAttributes(xmlIDs.submitButton)
  if (transaction == 'buy') then
    attrs.interactable = playerOwes <= 0
  else
    attrs.interactable = true
  end
  self.UI.setAttributes(xmlIDs.submitButton, attrs)
end

---@param newState State
local function updateTransactionTabletUi(newState)
  state = table.merge(state, newState)

  setFactoryGetsUi(state.factoryGets)
  setPlayerGetsUi(state.playerGets)
  setPlayerOwesUi(state.playerOwes, state.cashTotal)
  setSpaceportGetsUi(state.spaceportGets)
  switchUiPane(state.transaction)
  validateSubmitButtonState(state.playerOwes, state.transaction)
end

local function resetUi()
  updateTransactionTabletUi(initialState)
end

--- Sets factory and spaceport toggles to "none"
local function resetFactoryAndSpaceportUi()
  state.factoryColor = false
  state.spaceportColor = false

  table.forEach({
    xmlIDs.factoryToggleNoneBuy,
    xmlIDs.spaceportToggleNoneBuy,
    xmlIDs.spaceportToggleNoneSell,
  }, function(toggleButtonId)
    local attrs = self.UI.getAttributes(toggleButtonId)
    attrs.isOn = true
    self.UI.setAttributes(toggleButtonId, attrs)
  end)
end

--- Receives updated buy and sell values from handleNewStateFromTransactionZone
---@param transactionStates TransactionStates
function handleNewStateFromTransactionZone(transactionStates)
  if (transactionStates.likelyTransactionType) then
    if (not previousTransactionStates or previousTransactionStates.likelyTransactionType ~= transactionStates.likelyTransactionType) then
      state.transaction = transactionStates.likelyTransactionType
      switchUiPane(state.transaction)
      end
  end

  previousTransactionStates = transactionStates

  if (state.transaction == 'buy') then
    updateTransactionTabletUi(transactionStates.buyState)
  else
    updateTransactionTabletUi(transactionStates.sellState)
  end
end

function handleTransactionTabChanged(player, val)
  local transaction = transactions[val]
  local previousTransactionState = {}

  if (previousTransactionStates) then
    if (transaction == 'buy') then
      previousTransactionState = previousTransactionStates.buyState
    else
      previousTransactionState = previousTransactionStates.sellState
    end
  end

  local newState = table.merge(previousTransactionState, { transaction = transaction })
  updateTransactionTabletUi(newState)
end

function handleFactoryChanged(player, val)
  state.factoryColor = playerColors[val]
end

function handleSpaceportChanged(player, val)
  state.spaceportColor = playerColors[val]
end

function handleSubmitClicked(player)
  local transactionZone = getObjectFromGUID(constants.GUIDS.TransactionZoneGUID)
  if (transactionZone ~= nil) then
    transactionZone.call('handleSubmit', { player = player, transactionState = state })
    resetFactoryAndSpaceportUi()
  end
end

function onLoad()
  resetUi()
end

function onSpawn()
  resetUi()
end
