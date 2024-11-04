//================================================================================
// UIDATA_PET.
//================================================================================

class UIDATA_PET extends UIDataManager
	native;

// Export UUIDATA_PET::execIsHavePet(FFrame&, void* const)
native static function bool IsHavePet();

// Export UUIDATA_PET::execGetSummonNum(FFrame&, void* const)
native static function int GetSummonNum();

// Export UUIDATA_PET::execGetPetEXPRate(FFrame&, void* const)
native static function float GetPetEXPRate(int ServerID);

defaultproperties
{
}
