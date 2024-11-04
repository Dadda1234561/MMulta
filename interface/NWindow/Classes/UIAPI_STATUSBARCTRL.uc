//================================================================================
// UIAPI_STATUSBARCTRL.
//================================================================================

class UIAPI_STATUSBARCTRL extends UIAPI_WINDOW
	native;

// Export UUIAPI_STATUSBARCTRL::execSetPoint(FFrame&, void* const)
native static function SetPoint(string ControlName, int CurrentValue, int MaxValue);

// Export UUIAPI_STATUSBARCTRL::execSetPointPercent(FFrame&, void* const)
native static function SetPointPercent(string ControlName, INT64 CurrentValue, INT64 MinValue, INT64 MaxValue);

// Export UUIAPI_STATUSBARCTRL::execSetPointExpPercentRate(FFrame&, void* const)
native static function SetPointExpPercentRate(string ControlName, float CurrentPercentRate);

// Export UUIAPI_STATUSBARCTRL::execSetRegenInfo(FFrame&, void* const)
native static function SetRegenInfo(string ControlName, int Duration, int ticks, float Amount);

defaultproperties
{
}
