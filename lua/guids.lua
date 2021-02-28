-- ============================================================================
-- All GUIDs referenced ANYWHERE in Lua
-- ============================================================================
CulturePoolZoneGUID = '4cf1e3'
CultureCardBagGUID = '711a6c'
EncounterBagGUID = 'e78408'
EventTokenBagGUID = '15ea2d'

TableGUIDs = {
  Board = '332a2b',
  MainTable = '7df0c6',
  PlayerTables = '8c8f95',
  SharedTable = 'fdf9e3',
}

-- ============================================================================
-- GUIDs to lock so the user can't interact with them (references, no strings)
-- ============================================================================
GUIDsToDisable = {
  -- CultureCardBagGUID,
  -- EncounterBagGUID,
  TableGUIDs.Board,
  TableGUIDs.MainTable,
  TableGUIDs.PlayerTables,
  TableGUIDs.SharedTable,
}
