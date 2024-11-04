//================================================================================
// UIAPI_STATUSICONCTRL.
//================================================================================

class UIAPI_STATUSICONCTRL extends UIAPI_WINDOW
	native;

// Export UUIAPI_STATUSICONCTRL::execAddRow(FFrame&, void* const)
native static function AddRow(string ControlName);

// Export UUIAPI_STATUSICONCTRL::execAddCol(FFrame&, void* const)
native static function AddCol(string ControlName, int Row, StatusIconInfo Info);

// Export UUIAPI_STATUSICONCTRL::execClear(FFrame&, void* const)
native static function Clear(string ControlName);

defaultproperties
{
}
