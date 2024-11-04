//================================================================================
// UIAPI_COMBOBOX.
//================================================================================

class UIAPI_COMBOBOX extends UIAPI_WINDOW
	native;

// Export UUIAPI_COMBOBOX::execAddString(FFrame&, void* const)
native static function AddString(string ControlName, string Str);

// Export UUIAPI_COMBOBOX::execSYS_AddString(FFrame&, void* const)
native static function SYS_AddString(string ControlName, int Index);

// Export UUIAPI_COMBOBOX::execAddStringWithReserved(FFrame&, void* const)
native static function AddStringWithReserved(string ControlName, string Str, int Reserved);

// Export UUIAPI_COMBOBOX::execSYS_AddStringWithReserved(FFrame&, void* const)
native static function SYS_AddStringWithReserved(string ControlName, int Index, int Reserved);

// Export UUIAPI_COMBOBOX::execGetString(FFrame&, void* const)
native static function string GetString(string ControlName, int Num);

// Export UUIAPI_COMBOBOX::execGetReserved(FFrame&, void* const)
native static function int GetReserved(string ControlName, int Num);

// Export UUIAPI_COMBOBOX::execGetSelectedNum(FFrame&, void* const)
native static function int GetSelectedNum(string ControlName);

// Export UUIAPI_COMBOBOX::execSetSelectedNum(FFrame&, void* const)
native static function SetSelectedNum(string ControlName, int Num);

// Export UUIAPI_COMBOBOX::execClear(FFrame&, void* const)
native static function Clear(string ControlName);

// Export UUIAPI_COMBOBOX::execGetNumOfItems(FFrame&, void* const)
native static function int GetNumOfItems(string ControlName);

// Export UUIAPI_COMBOBOX::execAddStringWithColor(FFrame&, void* const)
native static function int AddStringWithColor(string ControlName, string Str, Color Col);

defaultproperties
{
}
