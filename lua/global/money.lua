require("lua/utils/table")

money = {}

local initialized = false
function money.init()
  if (initialized) then return end
  money.lookupTable = Global.getVar('MONEY_LOOKUP')
  money.denominations = { table.unpack(Global.getVar('MONEY_VALUES')) } --copy the table because sorting is destructive
  table.sort(money.denominations, |a, b| b < a) -- sort descending
  initialized = true
end

function calculateAmounts(amount, denominations)
  if (denominations == nil) then
    denominations = money.denominations
  end

  return table.reduce(denominations, function(acc, denomination)
    acc[denomination] = 0
    while (denomination <= amount) do
      amount = amount - denomination
      acc[denomination] = acc[denomination] + 1
    end
    return acc
  end, {})
end

function dealToPlayer(amounts, player)
  local allowedColors = Global.getVar("ALLOWED_PLAYER_COLORS")
  local playerIsAllowed = table.includes(allowedColors, player.color)
  if (not playerIsAllowed) then return end

  for k, v in pairs(amounts) do
    if (v > 0) then
      local moneyTag = money.lookupTable[k]
      local moneyBag = getObjectsWithAllTags({ 'bag', 'credits', moneyTag })[1]
      moneyBag.deal(v, player.color)
    end
  end
end

function money.payPlayer(amount, player, denominations)
  local amountsToDeal = calculateAmounts(amount, denominations)
  dealToPlayer(amountsToDeal, player)
end

function money.breakBill(amount, player)
  -- disallow the bill being broken from the denominations
  local denominations = table.filter(money.denominations, |denomination| denomination ~= amount)
  local amountsToDeal = calculateAmounts(amount, player, denominations)
  return amountsToDeal
end

function money.combineBills(amounts, player)
  local amount = table.sum(amounts)
  local amountsToDeal = calculateAmounts(amount, player)
  return amountsToDeal
end
