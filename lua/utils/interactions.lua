local function pingObject(obj, player_color)
  Player[player_color].pingTable(obj.getPosition())
end

return {
  pingObject = pingObject
}
