--- Given a table of objects, sums the values that were assigned using `object.setVar('value', number)`
---@param valueItems table[] @table of TTS objects
---@param valueVarName string @string name of the numeric variable to sum, retrieved using `object.getVar('value')`. Defaults to 'value'.
---@return number
local function sumValueItems(valueItems, valueVarName)
  valueVarName = valueVarName or 'value'
  local values = table.map(
    valueItems,
    function(valueItem)
      if (valueItem == nil) then return 0 end
      return (valueItem.getVar(valueVarName) or 0) * math.abs(valueItem.getQuantity())
    end
  )
  return table.sum(values)
end

return sumValueItems
