//================================================================================
// UIDATA_PLAYER.
//================================================================================

class UIDATA_PLAYER extends UIDataManager
	native;

// Export UUIDATA_PLAYER::execIsHero(FFrame&, void* const)
native static function bool IsHero();

// Export UUIDATA_PLAYER::execIsLegend(FFrame&, void* const)
native static function bool IsLegend();

// Export UUIDATA_PLAYER::execGetPlayerID(FFrame&, void* const)
native static function int GetPlayerID();

// Export UUIDATA_PLAYER::execGetRecipeShopMsg(FFrame&, void* const)
native static function string GetRecipeShopMsg();

// Export UUIDATA_PLAYER::execGetPlayerEXPRate(FFrame&, void* const)
native static function float GetPlayerEXPRate();

// Export UUIDATA_PLAYER::execGetPlayerMoveType(FFrame&, void* const)
native static function UIEventManager.EMoveType GetPlayerMoveType();

// Export UUIDATA_PLAYER::execGetPlayerEnvironment(FFrame&, void* const)
native static function UIEventManager.EEnvType GetPlayerEnvironment();

// Export UUIDATA_PLAYER::execHasCrystallizeAbility(FFrame&, void* const)
native static function bool HasCrystallizeAbility();

// Export UUIDATA_PLAYER::execGetInventoryLimit(FFrame&, void* const)
native static function int GetInventoryLimit();

// Export UUIDATA_PLAYER::execGetInventoryCount(FFrame&, void* const)
native static function int GetInventoryCount();

// Export UUIDATA_PLAYER::execGetMeshType(FFrame&, void* const)
native static function int GetMeshType();

// Export UUIDATA_PLAYER::execIsInDethrone(FFrame&, void* const)
native static function bool IsInDethrone();

// Export UUIDATA_PLAYER::execIsInPrison(FFrame&, void* const)
native static function bool IsInPrison();

// Export UUIDATA_PLAYER::execSetAbilityPoint(FFrame&, void* const)
native static function SetAbilityPoint(int point);

defaultproperties
{
}
