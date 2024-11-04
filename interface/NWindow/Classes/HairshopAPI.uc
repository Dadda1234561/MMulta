//================================================================================
// HairshopAPI.
//================================================================================

class HairshopAPI extends UIEventManager
	native;

// Export UHairshopAPI::execUpdateCharHairInfo(FFrame&, void* const)
native static function UpdateCharHairInfo();

// Export UHairshopAPI::execApplyCharHairInfo(FFrame&, void* const)
native static function ApplyCharHairInfo(bool bUseNewHair, int Type, bool bUseHairColor, int nColorR, int nColorG, int nColorB);

// Export UHairshopAPI::execApplyHairType(FFrame&, void* const)
native static function ApplyHairType(int Type);

defaultproperties
{
}
