function jPrint(...)
  local toPrint = {}
  for i, v in ipairs({...}) do
    table.insert(toPrint, j(v)..' ')
  end
  print(table.unpack(toPrint))
end

function j(obj)
  return JSON.encode_pretty(obj)
end
