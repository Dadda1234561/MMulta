//================================================================================
// UIAPI_TEXTBOX.
//================================================================================

class UIAPI_TEXTBOX extends UIAPI_WINDOW
	native;

// Export UUIAPI_TEXTBOX::execSetTextColor(FFrame&, void* const)
native static function SetTextColor(string ControlName, Color a_Color);

// Export UUIAPI_TEXTBOX::execSetText(FFrame&, void* const)
native static function SetText(string ControlName, string Text);

// Export UUIAPI_TEXTBOX::execSetAlign(FFrame&, void* const)
native static function SetAlign(string ControlName, UIEventManager.ETextAlign Align);

// Export UUIAPI_TEXTBOX::execSetInt(FFrame&, void* const)
native static function SetInt(string ControlName, int Number);

// Export UUIAPI_TEXTBOX::execGetText(FFrame&, void* const)
native static function string GetText(string ControlName);

// Export UUIAPI_TEXTBOX::execSetTooltipString(FFrame&, void* const)
native static function SetTooltipString(string ControlName, string Text);

defaultproperties
{
}
