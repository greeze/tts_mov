require('lua/utils/table')
local constants = require('lua/global/constants')
local setup = require('lua/global/setup')
local reset = require('lua/global/reset')
local money = require('lua/global/money')

---@param save_state table
function onLoad(save_state)
  disableNonInteractables()
  money.init()
  broadcastToAll('\nClick the Setup button after all players are seated.')
end

---@param player table
---@param setupButtonId string
function setupGame(player, setupButtonId)
  local allowedColors = constants.ALLOWED_PLAYER_COLORS
  local playerIsAllowed = table.includes(allowedColors, player.color)
  if (not playerIsAllowed) then
    broadcastToColor('Please choose a spot at the table before setting up the game.', player.color, 'Red')
    return
  end
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
