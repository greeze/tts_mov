-- ============================================================================
-- All GUIDs referenced ANYWHERE in Lua
-- ============================================================================
CultureDeckGUID = '0a8f09'
EncounterBagGUID = 'e78408'

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
  CultureDeckGUID,
  EncounterBagGUID,
  TableGUIDs.Board,
  TableGUIDs.MainTable,
  TableGUIDs.PlayerTables,
  TableGUIDs.SharedTable,
}
