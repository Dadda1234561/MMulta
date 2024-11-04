//================================================================================
// UIAPI_LISTCTRL.
//================================================================================

class UIAPI_LISTCTRL extends UIAPI_WINDOW
	native;

// Export UUIAPI_LISTCTRL::execInsertRecord(FFrame&, void* const)
native static function InsertRecord(string ControlName, LVDataRecord Record);

// Export UUIAPI_LISTCTRL::execModifyRecord(FFrame&, void* const)
native static function bool ModifyRecord(string ControlName, int Index, LVDataRecord Record);

// Export UUIAPI_LISTCTRL::execDeleteAllItem(FFrame&, void* const)
native static function DeleteAllItem(string ControlName);

// Export UUIAPI_LISTCTRL::execDeleteRecord(FFrame&, void* const)
native static function DeleteRecord(string ControlName, int Index);

// Export UUIAPI_LISTCTRL::execGetRecordCount(FFrame&, void* const)
native static function int GetRecordCount(string ControlName);

// Export UUIAPI_LISTCTRL::execGetSelectedIndex(FFrame&, void* const)
native static function int GetSelectedIndex(string ControlName);

// Export UUIAPI_LISTCTRL::execSetSelectedIndex(FFrame&, void* const)
native static function SetSelectedIndex(string ControlName, int Index, bool bMoveToRow);

// Export UUIAPI_LISTCTRL::execShowScrollBar(FFrame&, void* const)
native static function ShowScrollBar(string ControlName, bool bShow);

defaultproperties
{
}
