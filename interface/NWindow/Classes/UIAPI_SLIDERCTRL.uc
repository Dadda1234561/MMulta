//================================================================================
// UIAPI_SLIDERCTRL.
//================================================================================

class UIAPI_SLIDERCTRL extends UIAPI_WINDOW
	native;

// Export UUIAPI_SLIDERCTRL::execGetCurrentTick(FFrame&, void* const)
native static function int GetCurrentTick(string ControlName);

// Export UUIAPI_SLIDERCTRL::execSetCurrentTick(FFrame&, void* const)
native static function SetCurrentTick(string ControlName, int iCurrTick);

// Export UUIAPI_SLIDERCTRL::execGetTotalTickCount(FFrame&, void* const)
native static function int GetTotalTickCount(string ControlName);

defaultproperties
{
}
