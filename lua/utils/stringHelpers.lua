---@param str string
---@return integer
local function stringToNum(str)
  local numStr, _ = str:gsub('%D+', '')
  local num = tonumber(numStr)
  return num and num or 0
end

return {
  stringToNum = stringToNum,
}
