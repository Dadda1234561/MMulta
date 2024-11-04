//================================================================================
// UIAPI_MULTISELLITEMINFO.
//================================================================================

class UIAPI_MULTISELLITEMINFO extends UIAPI_WINDOW
	native;

// Export UUIAPI_MULTISELLITEMINFO::execSetItemInfo(FFrame&, void* const)
native static function SetItemInfo(string ControlName, int Index, ItemInfo item);

// Export UUIAPI_MULTISELLITEMINFO::execClear(FFrame&, void* const)
native static function Clear(string ControlName);

defaultproperties
{
}
