require('lua/utils/table')
local goodsData = require('data/goods')

local function setTileValue()
  local cultureId = tonumber(string.match(self.getName(), '.*Good (%d%d).*'))
  local goodData = table.find(goodsData, function (data) return data.from == cultureId end)

  local buyValue = goodData.buy
  local sellValue = goodData.sell
  local factoryValue = 0

  if(self.hasTag('factory')) then
    buyValue = goodData.factory.buy
    sellValue = goodData.factory.sell
    factoryValue = buyValue * 0.5
  end

  self.setVar('data', goodData)
  self.setVar('buyValue', buyValue)
  self.setVar('sellValue', sellValue)
  self.setVar('factoryValue', factoryValue)
  self.value = 0
end

function onLoad()
  setTileValue()
end

function onSpawn()
  setTileValue()
end
