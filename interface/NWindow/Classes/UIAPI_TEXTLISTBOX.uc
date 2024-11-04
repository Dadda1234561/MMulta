//================================================================================
// UIAPI_TEXTLISTBOX.
//================================================================================

class UIAPI_TEXTLISTBOX extends UIAPI_WINDOW
	native;

// Export UUIAPI_TEXTLISTBOX::execAddString(FFrame&, void* const)
native static function AddString(string ControlName, string Text, Color TextColor);

// Export UUIAPI_TEXTLISTBOX::execClear(FFrame&, void* const)
native static function Clear(string ControlName);

defaultproperties
{
}
