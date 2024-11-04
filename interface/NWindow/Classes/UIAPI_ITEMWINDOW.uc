//================================================================================
// UIAPI_ITEMWINDOW.
//================================================================================

class UIAPI_ITEMWINDOW extends UIAPI_WINDOW
	native;

// Export UUIAPI_ITEMWINDOW::execGetSelectedNum(FFrame&, void* const)
native static function int GetSelectedNum(string ControlName);

// Export UUIAPI_ITEMWINDOW::execGetItemNum(FFrame&, void* const)
native static function int GetItemNum(string ControlName);

// Export UUIAPI_ITEMWINDOW::execClearSelect(FFrame&, void* const)
native static function ClearSelect(string ControlName);

// Export UUIAPI_ITEMWINDOW::execAddItem(FFrame&, void* const)
native static function AddItem(string ControlName, ItemInfo Info);

// Export UUIAPI_ITEMWINDOW::execSetItem(FFrame&, void* const)
native static function SetItem(string ControlName, int Index, ItemInfo Info);

// Export UUIAPI_ITEMWINDOW::execDeleteItem(FFrame&, void* const)
native static function DeleteItem(string ControlName, int Index);

// Export UUIAPI_ITEMWINDOW::execGetSelectedItem(FFrame&, void* const)
native static function bool GetSelectedItem(string ControlName, out ItemInfo Info);

// Export UUIAPI_ITEMWINDOW::execGetItem(FFrame&, void* const)
native static function bool GetItem(string ControlName, int Index, out ItemInfo Info);

// Export UUIAPI_ITEMWINDOW::execClear(FFrame&, void* const)
native static function Clear(string ControlName);

// Export UUIAPI_ITEMWINDOW::execFindItem(FFrame&, void* const)
native static function int FindItem(string ControlName, ItemID Id);

// Export UUIAPI_ITEMWINDOW::execFindItemByClassID(FFrame&, void* const)
native static function int FindItemByClassID(string ControlName, int ClassID);

// Export UUIAPI_ITEMWINDOW::execSetFaded(FFrame&, void* const)
native static function SetFaded(string ControlName, bool bOn);

// Export UUIAPI_ITEMWINDOW::execShowScrollBar(FFrame&, void* const)
native static function ShowScrollBar(string ControlName, bool bShow);

// Export UUIAPI_ITEMWINDOW::execSetToggleEffect(FFrame&, void* const)
native static function SetToggleEffect(string ControlName, int Index, bool bToggle);

// Export UUIAPI_ITEMWINDOW::execSetIconIndex(FFrame&, void* const)
native static function SetIconIndex(string ControlName, int Index, int IconIndex);

defaultproperties
{
}
