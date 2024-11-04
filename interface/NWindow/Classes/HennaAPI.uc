//================================================================================
// HennaAPI.
//================================================================================

class HennaAPI extends Object
	native
	export;

// Export UHennaAPI::execGetHennaInfoCount(FFrame&, void* const)
native static function int GetHennaInfoCount();

// Export UHennaAPI::execGetHennaInfo(FFrame&, void* const)
native static function bool GetHennaInfo(int a_Index, out int a_HennaID, out int a_IsActive);

// Export UHennaAPI::execGetPremiumHennaInfo(FFrame&, void* const)
native static function bool GetPremiumHennaInfo(out int a_HennaID, out int a_IsActive);

// Export UHennaAPI::execGetPremiumHennaPeriod(FFrame&, void* const)
native static function int GetPremiumHennaPeriod();

defaultproperties
{
}
