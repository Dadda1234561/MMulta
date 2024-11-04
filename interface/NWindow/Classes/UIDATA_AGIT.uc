//================================================================================
// UIDATA_AGIT.
//================================================================================

class UIDATA_AGIT extends UIDataManager
	native;

// Export UUIDATA_AGIT::execGetAllDecoNPCInfo(FFrame&, void* const)
native static function GetAllDecoNPCInfo(out array<AgitDecoNPCData> AgitDecoNPCDataList, out array<AgitDecoNPCTypeList> NpcTypeList, int Grade, array<int> Domains);

// Export UUIDATA_AGIT::execGetDecoNPCInfo(FFrame&, void* const)
native static function bool GetDecoNPCInfo(int DecoNpcId, out AgitDecoNPCData DecoData);

// Export UUIDATA_AGIT::execRequestOpenDecoNPC(FFrame&, void* const)
native static function RequestOpenDecoNPC(int AgitID);

// Export UUIDATA_AGIT::execRequestCheckAvailability(FFrame&, void* const)
native static function RequestCheckAvailability(int AgitID, int SlotNum, int DecoNpcId);

defaultproperties
{
}
