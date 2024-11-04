//================================================================================
// UIDATA_HUNTINGZONE.
//================================================================================

class UIDATA_HUNTINGZONE extends UIDataManager
	native;

// Export UUIDATA_HUNTINGZONE::execIsValidData(FFrame&, void* const)
native static function bool IsValidData(int Id);

// Export UUIDATA_HUNTINGZONE::execGetHuntingZoneName(FFrame&, void* const)
native static function string GetHuntingZoneName(int Id);

// Export UUIDATA_HUNTINGZONE::execGetHuntingZoneType(FFrame&, void* const)
native static function int GetHuntingZoneType(int Id);

// Export UUIDATA_HUNTINGZONE::execGetMinLevel(FFrame&, void* const)
native static function int GetMinLevel(int Id);

// Export UUIDATA_HUNTINGZONE::execGetMaxLevel(FFrame&, void* const)
native static function int GetMaxLevel(int Id);

// Export UUIDATA_HUNTINGZONE::execGetHuntingZoneLoc(FFrame&, void* const)
native static function Vector GetHuntingZoneLoc(int Id);

// Export UUIDATA_HUNTINGZONE::execGetHuntingZone(FFrame&, void* const)
native static function int GetHuntingZone(int Id);

// Export UUIDATA_HUNTINGZONE::execGetHuntingDescription(FFrame&, void* const)
native static function string GetHuntingDescription(int Id);

// Export UUIDATA_HUNTINGZONE::execGetHuntingZoneData(FFrame&, void* const)
native static function GetHuntingZoneData(int nID, out HuntingZoneUIData huntingZoneData);

defaultproperties
{
}
