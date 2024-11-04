//================================================================================
// UIAPI_CHECKBOX.
//================================================================================

class UIAPI_CHECKBOX extends UIAPI_WINDOW
	native;

// Export UUIAPI_CHECKBOX::execSetTitle(FFrame&, void* const)
native static function SetTitle(string ControlName, string Title);

// Export UUIAPI_CHECKBOX::execSetCheck(FFrame&, void* const)
native static function SetCheck(string ControlName, bool bCheck);

// Export UUIAPI_CHECKBOX::execIsChecked(FFrame&, void* const)
native static function bool IsChecked(string ControlName);

// Export UUIAPI_CHECKBOX::execIsDisable(FFrame&, void* const)
native static function bool IsDisable(string ControlName);

// Export UUIAPI_CHECKBOX::execSetDisable(FFrame&, void* const)
native static function SetDisable(string ControlName, bool bDisable);

// Export UUIAPI_CHECKBOX::execToggleDisable(FFrame&, void* const)
native static function ToggleDisable(string ControlName);

defaultproperties
{
}
