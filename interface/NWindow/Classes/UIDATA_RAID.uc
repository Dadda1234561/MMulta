//================================================================================
// UIDATA_RAID.
//================================================================================

class UIDATA_RAID extends UIDataManager
	native;

// Export UUIDATA_RAID::execIsValidData(FFrame&, void* const)
native static function bool IsValidData(int Id);

// Export UUIDATA_RAID::execGetRaidMonsterID(FFrame&, void* const)
native static function int GetRaidMonsterID(int RaidID);

// Export UUIDATA_RAID::execGetRaidMonsterLevel(FFrame&, void* const)
native static function int GetRaidMonsterLevel(int RaidID);

// Export UUIDATA_RAID::execGetRaidMonsterZone(FFrame&, void* const)
native static function int GetRaidMonsterZone(int RaidID);

// Export UUIDATA_RAID::execGetRaidDescription(FFrame&, void* const)
native static function string GetRaidDescription(int RaidID);

// Export UUIDATA_RAID::execGetRaidLoc(FFrame&, void* const)
native static function Vector GetRaidLoc(int Id);

// Export UUIDATA_RAID::execGetRaidRecommendLevel(FFrame&, void* const)
native static function GetRaidRecommendLevel(int RaidID, out int nMinLevel, out int nMaxLevel);

// Export UUIDATA_RAID::execGetRaidDataKeyList(FFrame&, void* const)
native static function GetRaidDataKeyList(out array<int> arrKeyList);

defaultproperties
{
}
