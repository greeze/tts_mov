---@param obj table
---@param playerColor string
local function pingObject(obj, playerColor)
  Player[playerColor].pingTable(obj.getPosition())
end

return {
  pingObject = pingObject
}
