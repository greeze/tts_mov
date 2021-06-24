require('lua/utils/table')
local constants = require('lua/global/constants')
local setup = require('lua/global/setup')
local reset = require('lua/global/reset')
local money = require('lua/global/money')

---@param save_state table
function onLoad(save_state)
  disableNonInteractables()
  money.init()

  -- local goods = getObjectsWithAllTags({ 'good', 'token' })
  -- table.forEach(goods, function(obj)
  --   obj.setLuaScript('require("lua/components/value_tiles/goodsTile")')
  -- end)

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
