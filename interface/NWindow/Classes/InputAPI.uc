//================================================================================
// InputAPI.
//================================================================================

class InputAPI extends UIEventManager
	native;

// Export UInputAPI::execIsShiftPressed(FFrame&, void* const)
native static function bool IsShiftPressed();

// Export UInputAPI::execIsCtrlPressed(FFrame&, void* const)
native static function bool IsCtrlPressed();

// Export UInputAPI::execIsAltPressed(FFrame&, void* const)
native static function bool IsAltPressed();

// Export UInputAPI::execGetKeyString(FFrame&, void* const)
native static function string GetKeyString(EInputKey Key);

// Export UInputAPI::execGetInputKey(FFrame&, void* const)
native static function EInputKey GetInputKey(string keyString);

defaultproperties
{
}
