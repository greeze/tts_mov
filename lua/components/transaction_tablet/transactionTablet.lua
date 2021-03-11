require('lua/utils/table')

---@class State
---@field transaction string
---@field playerOwes integer
---@field factoryGets integer
---@field spaceportGets integer

---@type State
local initialState = {
  factoryGets = 0,
  playerGets = 0,
  playerOwes = 0,
  spaceportGets = 0,
  transaction = 'buy',
}

local state = {}
local transactions = { ['0'] = 'buy', ['1'] = 'sell' }
local transactionPanes = { buy = 'BuySettings', sell = 'SellSettings' }
local xmlIDs = {
  factoryGetsText = 'FactoryGetsText',
  playerGetsText = 'PlayerGetsText',
  playerOwesButton = 'PlayerOwesButton',
  playerOwesText = 'PlayerOwesText',
  spaceportGetsTextBuy = 'SpaceportGetsTextBuy',
  spaceportGetsTextSell = 'SpaceportGetsTextSell',
}

function refreshUi()
  Wait.frames(function() self.UI.setXml(self.UI.getXml()) end, 2)
end

---@param transaction string
function switchUiPane(transaction)
  table.forEach(transactionPanes, function(v, k)
    self.UI.setAttribute(v, 'active', k == transaction)
  end)
end

---@param amount integer
function setFactoryGetsUi(amount)
  local factoryGetsStr = 'Factory Gets: ' .. amount .. 'c'

  self.UI.setValue(xmlIDs.factoryGetsText, factoryGetsStr)
end

---@param amount integer
function setPlayerGetsUi(amount)
  local playerGetsStr = amount .. 'c'

  self.UI.setValue(xmlIDs.playerGetsText, playerGetsStr)
end

---@param amount integer
function setPlayerOwesUi(amount)
  local playerOwesStr = 'Player Owes: ' .. amount .. 'c'
  local payStr = 'Pay ' .. amount .. 'c'

  self.UI.setValue(xmlIDs.playerOwesText, playerOwesStr)
  self.UI.setAttribute(xmlIDs.playerOwesButton, 'text', payStr)
  self.UI.setValue(xmlIDs.playerOwesButton, payStr)
end

---@param amount integer
function setSpaceportGetsUi(amount)
  local spaceportGetsStr = 'Spaceport Gets: ' .. amount .. 'c'

  self.UI.setValue(xmlIDs.spaceportGetsTextBuy, spaceportGetsStr)
  self.UI.setValue(xmlIDs.spaceportGetsTextSell, spaceportGetsStr)
end

---@param newState State
function updateUi(newState)
  state = table.merge(state, newState)

  setFactoryGetsUi(state.factoryGets)
  setPlayerGetsUi(state.playerGets)
  setPlayerOwesUi(state.playerOwes)
  setSpaceportGetsUi(state.spaceportGets)
  switchUiPane(state.transaction)

  -- Some items redraw with the wrong styles if we don't refresh after updating.
  refreshUi()
end

function resetUi()
  updateUi(initialState)
end

function onTransactionChanged(player, val)
  switchUiPane(transactions[val])
end

function onPickUp(playerColor)
  self.UI.setClass('Container', 'Container ' .. playerColor)
  self.setColorTint(playerColor)
end

function onLoad()
  resetUi()
end

function onSpawn()
  resetUi()
end
