//================================================================================
// UIAPI_EFFECTBUTTON.
//================================================================================

class UIAPI_EFFECTBUTTON extends UIAPI_WINDOW
	native;

// Export UUIAPI_EFFECTBUTTON::execBeginEffect(FFrame&, void* const)
native static function BeginEffect(string ControlName, int iEffectNumber);

// Export UUIAPI_EFFECTBUTTON::execEndEffect(FFrame&, void* const)
native static function EndEffect(string ControlName);

defaultproperties
{
}
