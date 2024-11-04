//================================================================================
// UIAPI_EDITBOX.
//================================================================================

class UIAPI_EDITBOX extends UIAPI_WINDOW
	native;

// Export UUIAPI_EDITBOX::execGetString(FFrame&, void* const)
native static function string GetString(string ControlName);

// Export UUIAPI_EDITBOX::execSetString(FFrame&, void* const)
native static function SetString(string ControlName, string Str);

// Export UUIAPI_EDITBOX::execAddString(FFrame&, void* const)
native static function AddString(string ControlName, string Str);

// Export UUIAPI_EDITBOX::execSimulateBackspace(FFrame&, void* const)
native static function SimulateBackspace(string ControlName);

// Export UUIAPI_EDITBOX::execClear(FFrame&, void* const)
native static function Clear(string ControlName);

// Export UUIAPI_EDITBOX::execSetEditType(FFrame&, void* const)
native static function SetEditType(string CotrolName, string Type);

// Export UUIAPI_EDITBOX::execSetHighLight(FFrame&, void* const)
native static function SetHighLight(string CotrolName, bool bHighlight);

// Export UUIAPI_EDITBOX::execAllSelect(FFrame&, void* const)
native static function AllSelect(string ControlName);

// Export UUIAPI_EDITBOX::execSetAlign(FFrame&, void* const)
native static function SetAlign(string ControlName, UIEventManager.ETextAlign Align);

defaultproperties
{
}
