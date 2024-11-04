//================================================================================
// UIDATA_USER.
//================================================================================

class UIDATA_USER extends UIDataManager
	native;

// Export UUIDATA_USER::execGetUserName(FFrame&, void* const)
native static function string GetUserName(int ServerID);

// Export UUIDATA_USER::execGetClanType(FFrame&, void* const)
native static function bool GetClanType(int Id, out int Type);

// Export UUIDATA_USER::execGetPrologueGrowType(FFrame&, void* const)
native static function bool GetPrologueGrowType(int Id, out int nPrologue);

// Export UUIDATA_USER::execIsPrologueGrowType(FFrame&, void* const)
native static function bool IsPrologueGrowType(int nClassID);

// Export UUIDATA_USER::execIsDethroneEnemy(FFrame&, void* const)
native static function bool IsDethroneEnemy(int ServerID);

// Export UUIDATA_USER::execIsDethroneComrade(FFrame&, void* const)
native static function bool IsDethroneComrade(int ServerID);

defaultproperties
{
}
