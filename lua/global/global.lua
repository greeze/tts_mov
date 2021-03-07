require('lua/utils/table')
local constants = require('lua/global/constants')
local setup = require('lua/global/setup')
local reset = require('lua/global/reset')
local money = require('lua/global/money')
local valueTileUpdater = require('lua/components/value_tiles/valueTileUpdater')

function onLoad(save_state)
  disableNonInteractables()
  money.init()
end

function setupGame(player, setupButtonId)
  setup.setupGame(player, setupButtonId)
end

function resetGame(player, resetButtonId)
  reset.resetGame(player, resetButtonId)
end

function disableNonInteractables()
  table.forEach(constants.GUIDS_TO_DISABLE, function(guid)
    getObjectFromGUID(guid).interactable = false
  end)
end

function updateTileValue(obj)
  valueTileUpdater.updateTileValue(obj)
end

function onObjectEnterContainer(container, obj)
  valueTileUpdater.onObjectEnterContainer(container, obj)
end

function onObjectLeaveContainer(container, obj)
  valueTileUpdater.onObjectLeaveContainer(container, obj)
end
