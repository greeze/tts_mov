require('lua/utils/table')

function getHitObjectRef(hitObj)
  return hitObj.hit_object
end

function isDice(obj)
  return obj.name == 'Die_6'
end

function rollDie(obj)
  obj.roll()
end

function handleClick()
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
