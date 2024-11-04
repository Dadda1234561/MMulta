//================================================================================
// UIAPI_MULTISELLNEEDEDITEM.
//================================================================================

class UIAPI_MULTISELLNEEDEDITEM extends UIAPI_WINDOW
	native;

// Export UUIAPI_MULTISELLNEEDEDITEM::execAddData(FFrame&, void* const)
native static function AddData(string ControlName, string param);

// Export UUIAPI_MULTISELLNEEDEDITEM::execClear(FFrame&, void* const)
native static function Clear(string ControlName);

defaultproperties
{
}
