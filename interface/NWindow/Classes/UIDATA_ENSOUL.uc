//================================================================================
// UIDATA_ENSOUL.
//================================================================================

class UIDATA_ENSOUL extends UIDataManager
	native;

// Export UUIDATA_ENSOUL::execGetEnsoulSlotCount(FFrame&, void* const)
native static function int GetEnsoulSlotCount(ItemID Id, int slotType);

// Export UUIDATA_ENSOUL::execGetEnsoulOptionInfo(FFrame&, void* const)
native static function bool GetEnsoulOptionInfo(int OptionID, out string optionInfo);

// Export UUIDATA_ENSOUL::execGetEnsoulStoneInfo(FFrame&, void* const)
native static function bool GetEnsoulStoneInfo(ItemID Id, out string ensoulStoneInfo);

// Export UUIDATA_ENSOUL::execGetEnsoulFeeInfoByItemId(FFrame&, void* const)
native static function bool GetEnsoulFeeInfoByItemId(int ItemID, bool bIsRefee, int SlotIndex, out string ensoulFeeInfo);

// Export UUIDATA_ENSOUL::execGetEnsoulExtractionFeeInfoByItemId(FFrame&, void* const)
native static function bool GetEnsoulExtractionFeeInfoByItemId(int ItemID, out string ensoulFeeInfo);

defaultproperties
{
}
