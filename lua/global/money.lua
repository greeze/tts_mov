require("lua/utils/table")
local constants = require("lua/global/constants")

local lookupTable
local denominations

local initialized = false
local function init()
  if (initialized) then return end
  lookupTable = constants.MONEY_LOOKUP
  denominations = { table.unpack(constants.MONEY_VALUES) } --copy the table because sorting is destructive
  table.sort(denominations, |a, b| b < a) -- sort descending
  initialized = true
end

local function calculateAmounts(amount, allowedDenominations)
  if (allowedDenominations == nil) then
    allowedDenominations = denominations
  end

  return table.reduce(allowedDenominations, function(acc, denomination)
    acc[denomination] = 0
    while (denomination <= amount) do
      amount = amount - denomination
      acc[denomination] = acc[denomination] + 1
    end
    return acc
  end, {})
end

local function dealToPlayer(amounts, player)
  local allowedColors = constants.ALLOWED_PLAYER_COLORS
  local playerIsAllowed = table.includes(allowedColors, player.color)
  if (not playerIsAllowed) then return end

  for k, v in pairs(amounts) do
    if (v > 0) then
      local moneyTag = lookupTable[k]
      local moneyBag = getObjectsWithAllTags({ 'bag', 'credits', moneyTag })[1]
      moneyBag.deal(v, player.color)
    end
  end
end

local function payPlayer(amount, player, allowedDenominations)
  local amountsToDeal = calculateAmounts(amount, allowedDenominations)
  dealToPlayer(amountsToDeal, player)
end

local function breakBill(amount, player)
  -- disallow the bill being broken from the denominations
  local allowedDenominations = table.filter(denominations, |denomination| denomination ~= amount)
  local amountsToDeal = calculateAmounts(amount, player, allowedDenominations)
  return amountsToDeal
end

local function combineBills(amounts, player)
  local amount = table.sum(amounts)
  local amountsToDeal = calculateAmounts(amount, player)
  return amountsToDeal
end

return {
  init = init,
  breakBill = breakBill,
  combineBills = combineBills,
  payPlayer = payPlayer,
}
