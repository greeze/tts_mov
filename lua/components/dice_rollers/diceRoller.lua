require('lua/utils/table')

local function getHitObjectRef(hitObj)
  return hitObj.hit_object
end

local function isDice(obj)
  return obj.name == 'Die_6'
end

local function rollDie(obj)
  obj.roll()
end

local function rollDice()
  local hitObjs = Physics.cast({
    type = 3,
    origin = self.getPosition(),
    direction = {0, 1, 0},
    size = self.getBounds().size,
  })

  local hitRefs = table.map(hitObjs, getHitObjectRef)
  local dice = table.filter(hitRefs, isDice)
  table.forEach(dice, rollDie)
end

function handleClick()
  rollDice()
end
