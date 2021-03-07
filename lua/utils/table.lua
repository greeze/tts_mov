function table.set(tbl) -- set of list
  local u = { }
  for _, v in ipairs(t)do
    u[v] = true
  end
  return u
end

function table.keys(tbl)
  local out = {}
  for k, v in pairs(tbl) do
    table.insert(out, k)
  end
  return out
end

function table.values(tbl)
  local out = {}
  for k, v in pairs(tbl) do
    table.insert(out, v)
  end
  return out
end

function table.reverseLookup(tbl)
  local out = {}
  for k, v in pairs(values) do
    out[v] = k
  end
  return out
end

function table.indexOf(tbl, val)
  for k, v in pairs(tbl) do
    if (v == val) then
      return k
    end
  end
  return 0
end

function table.includes(tbl, val)
  return table.indexOf(tbl, val) > 0
end

function table.find(tbl, fn)
  for _, v in pairs(tbl) do
    if fn(v) then
      return v
    end
  end
  return nil
end

function table.filter(tbl, fn) -- retrun new array with elements of tbl satisfying fn(v)
  local out = {}
  for _, v in pairs(tbl) do
    if fn(v) then
      table.insert(out, v)
    end
  end
  return out
end

function table.forEach(tbl, fn)
  for k, v in pairs(tbl) do
    fn(v, k)
  end
end

function table.map(tbl, fn)
  local out = {}
  local t_len = #tbl
  for i = 1, t_len do
      out[i] = fn(tbl[i])
  end
  return out
end

function table.merge(...)
  local t0 = {}
  for _, tbl in ipairs({ ... }) do
    for k, v in pairs(tbl) do
      t0[k] = v
    end
  end
  return t0
end

function table.reduce(tbl, fn, init)
  local acc = init
  for k, v in pairs(tbl) do
    acc = fn(acc, v, k, tbl)
  end
  return acc
end

function table.sum(tbl)
  return table.reduce(tbl, |a, b| a + b, 0)
end
