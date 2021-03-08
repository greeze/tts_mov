---Turns a table into a Set of uniques
---@generic V
---@param tbl V[]
---@return table<V, boolean>
function table.set(tbl)
  local u = { }
  for _, v in ipairs(tbl)do
    u[v] = true
  end
  return u
end

---@generic K, V
---@param tbl V[] | table<K, V>
---@return number[] | K[]
function table.keys(tbl)
  local out = {}
  for k, v in pairs(tbl) do
    table.insert(out, k)
  end
  return out
end

---@generic V
---@param tbl V[] | table<string, V>
---@return V[]
function table.values(tbl)
  local out = {}
  for k, v in pairs(tbl) do
    table.insert(out, v)
  end
  return out
end

---@generic K, V
---@param tbl table<K, V>
---@return table<V, K>
function table.reverseLookup(tbl)
  local out = {}
  for k, v in pairs(tbl) do
    out[v] = k
  end
  return out
end

---@generic K, V
---@param tbl V[] | table<K, V>
---@param val V
---@return string | number
function table.indexOf(tbl, val)
  for k, v in pairs(tbl) do
    if (v == val) then
      return k
    end
  end
  return 0
end

---@generic K, V
---@param tbl V[] | table<K, V>
---@param val V
---@return boolean
function table.includes(tbl, val)
  return table.indexOf(tbl, val) > 0
end

---@generic K, V
---@param tbl V[] | table<K, V>
---@param fn fun(val:V):boolean
---@return V | nil
function table.find(tbl, fn)
  for _, v in pairs(tbl) do
    if fn(v) then
      return v
    end
  end
  return nil
end

---Returns table of elements from tbl that satisfy fn(v)
---@generic K, V
---@param tbl V[] | table<K, V>
---@param fn fun(val:V):boolean
---@return V[]
function table.filter(tbl, fn)
  local out = {}
  for _, v in pairs(tbl) do
    if fn(v) then
      table.insert(out, v)
    end
  end
  return out
end

---@generic K, V
---@param tbl V[] | table<K, V>
---@param fn fun(v:V, k:K)
function table.forEach(tbl, fn)
  for k, v in pairs(tbl) do
    fn(v, k)
  end
end

---@generic V, T
---@param tbl V[]
---@param fn fun(val:V):T
---@return T[]
function table.map(tbl, fn)
  local out = {}
  local t_len = #tbl
  for i = 1, t_len do
    out[i] = fn(tbl[i])
  end
  return out
end

---@generic K, V
---@vararg table
---@return table<K, V>
function table.merge(...)
  local t0 = {}
  for _, tbl in ipairs({ ... }) do
    for k, v in pairs(tbl) do
      t0[k] = v
    end
  end
  return t0
end

---@generic K, V, T
---@param tbl table<K, V>
---@param fn fun(acc:T, val:V, key:K, tbl:table):T
---@param init T
---@return T
function table.reduce(tbl, fn, init)
  local acc = init
  for k, v in pairs(tbl) do
    acc = fn(acc, v, k, tbl)
  end
  return acc
end

---@param tbl number[]
---@return number
function table.sum(tbl)
  return table.reduce(tbl, function(a, b) return a + b end, 0)
end
