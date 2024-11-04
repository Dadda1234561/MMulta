//================================================================================
// UIAPI_MULTIEDITBOX.
//================================================================================

class UIAPI_MULTIEDITBOX extends UIAPI_WINDOW
	native;

// Export UUIAPI_MULTIEDITBOX::execGetString(FFrame&, void* const)
native static function string GetString(string ControlName);

// Export UUIAPI_MULTIEDITBOX::execSetString(FFrame&, void* const)
native static function SetString(string ControlName, string Str);

defaultproperties
{
}
