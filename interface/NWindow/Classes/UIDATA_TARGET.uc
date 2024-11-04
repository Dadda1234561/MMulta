//================================================================================
// UIDATA_TARGET.
//================================================================================

class UIDATA_TARGET extends UIDataManager
	native;

// Export UUIDATA_TARGET::execGetTargetID(FFrame&, void* const)
native static function int GetTargetID();

// Export UUIDATA_TARGET::execGetTargetUserRank(FFrame&, void* const)
native static function int GetTargetUserRank();

// Export UUIDATA_TARGET::execGetTargetMaxHP(FFrame&, void* const)
native static function int GetTargetMaxHP();

// Export UUIDATA_TARGET::execGetTargetHP(FFrame&, void* const)
native static function int GetTargetHP();

// Export UUIDATA_TARGET::execGetTargetMaxMP(FFrame&, void* const)
native static function int GetTargetMaxMP();

// Export UUIDATA_TARGET::execGetTargetMP(FFrame&, void* const)
native static function int GetTargetMP();

// Export UUIDATA_TARGET::execGetTargetName(FFrame&, void* const)
native static function string GetTargetName();

// Export UUIDATA_TARGET::execGetTargetNameColor(FFrame&, void* const)
native static function Color GetTargetNameColor(int Level);

// Export UUIDATA_TARGET::execGetTargetPledgeID(FFrame&, void* const)
native static function int GetTargetPledgeID();

// Export UUIDATA_TARGET::execGetTargetClassID(FFrame&, void* const)
native static function int GetTargetClassID();

// Export UUIDATA_TARGET::execIsServerObject(FFrame&, void* const)
native static function bool IsServerObject();

// Export UUIDATA_TARGET::execIsNpc(FFrame&, void* const)
native static function bool IsNpc();

// Export UUIDATA_TARGET::execIsPet(FFrame&, void* const)
native static function bool IsPet();

// Export UUIDATA_TARGET::execIsCanBeAttacked(FFrame&, void* const)
native static function bool IsCanBeAttacked();

// Export UUIDATA_TARGET::execIsHPShowableNPC(FFrame&, void* const)
native static function bool IsHPShowableNPC();

// Export UUIDATA_TARGET::execIsVehicle(FFrame&, void* const)
native static function bool IsVehicle();

// Export UUIDATA_TARGET::execGetTargetActor(FFrame&, void* const)
native static function Actor GetTargetActor();

defaultproperties
{
}
