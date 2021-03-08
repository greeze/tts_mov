require('lua/utils/table')
local constants = require('lua/global/constants')
local setup = require('lua/global/setup')
local reset = require('lua/global/reset')
local money = require('lua/global/money')
local valueTileUpdater = require('lua/components/value_tiles/valueTileUpdater')

---@param save_state table
function onLoad(save_state)
  disableNonInteractables()
  money.init()
end

---@param player table
---@param setupButtonId string
function setupGame(player, setupButtonId)
  setup.setupGame(player, setupButtonId)
end

---@param player table
---@param resetButtonId string
function resetGame(player, resetButtonId)
  reset.resetGame(player, resetButtonId)
end

function disableNonInteractables()
  table.forEach(constants.GUIDS_TO_DISABLE, function(guid)
    getObjectFromGUID(guid).interactable = false
  end)
end

---@param obj table
function updateTileValue(obj)
  valueTileUpdater.updateTileValue(obj)
end

---@param container table
---@param obj table
function onObjectEnterContainer(container, obj)
  valueTileUpdater.onObjectEnterContainer(container, obj)
end

---@param container table
---@param obj table
function onObjectLeaveContainer(container, obj)
  valueTileUpdater.onObjectLeaveContainer(container, obj)
end
