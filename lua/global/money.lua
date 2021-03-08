require('lua/utils/table')
local constants = require('lua/global/constants')

---@type table<string, number> | table<number, string>
local lookupTable

---@type number[]
local denominations

local initialized = false
local function init()
  if (initialized) then return end
  lookupTable = constants.MONEY_LOOKUP
  denominations = { table.unpack(constants.MONEY_VALUES) } --copy the table because sorting is destructive
  table.sort(denominations, function(a, b) return b < a end) -- sort descending
  initialized = true
end

---@param amount number
---@param allowedDenominations number[]
---@return table<number, number>
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

---@param amounts table<number, number>
---@param player table
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

---@param amount number
---@param player table
---@param allowedDenominations number[]
local function payPlayer(amount, player, allowedDenominations)
  local amountsToDeal = calculateAmounts(amount, allowedDenominations)
  dealToPlayer(amountsToDeal, player)
end

---@param amount number
---@param player table
---@return table<number, number>
local function breakBill(amount, player)
  -- disallow the bill being broken from the denominations
  local allowedDenominations = table.filter(denominations, function(denomination) return denomination ~= amount end)
  local amountsToDeal = calculateAmounts(amount, player, allowedDenominations)
  return amountsToDeal
end

---@param amounts number[]
---@param player table
---@return table<number, number>
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
