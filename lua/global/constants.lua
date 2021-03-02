-- ============================================================================
-- All GUIDs referenced ANYWHERE in Lua
-- ============================================================================
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
WORKSHOP_ID = '2413086259'
ALLOWED_PLAYER_COLORS = { 'Yellow', 'Red', 'Green', 'Orange' }
CULTURE_TAGS = { 'c00', 'c01', 'c02', 'c03', 'c04', 'c05', 'c06', 'c07', 'c08', 'c09', 'c10', 'c11', 'c12', 'c13', 'c14' }
SYSTEM_TAGS = { 's00', 's01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13', 's14' }
MONEY_TAGS = { 'm0001', 'm0005', 'm0010', 'm0050', 'm0100', 'm0500', 'm1000' }
MONEY_VALUES = { 1, 5, 10, 50, 100, 500, 1000 }
MONEY_LOOKUP = {
  m0001 = 1, m0005 = 5, m0010 = 10, m0050 = 50, m0100 = 100, m0500 = 500, m1000 = 1000,
  [1] = 'm0001', [5] = 'm0005', [10] = 'm0010', [50] = 'm0050', [100] = 'm0100', [500] = 'm0500', [1000] = 'm1000'
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
