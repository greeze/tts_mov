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
-- Constants
-- ============================================================================
ALLOWED_PLAYER_COLORS = { 'Yellow', 'Red', 'Green', 'Orange' }
CULTURE_TAGS = { 'c00', 'c01', 'c02', 'c03', 'c04', 'c05', 'c06', 'c07', 'c08', 'c09', 'c10', 'c11', 'c12', 'c13', 'c14' }
SYSTEM_TAGS = { 's00', 's01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13', 's14' }
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
