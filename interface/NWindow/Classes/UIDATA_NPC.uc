//================================================================================
// UIDATA_NPC.
//================================================================================

class UIDATA_NPC extends UIDataManager
	native;

// Export UUIDATA_NPC::execGetFirstID(FFrame&, void* const)
native static function int GetFirstID();

// Export UUIDATA_NPC::execGetNextID(FFrame&, void* const)
native static function int GetNextID();

// Export UUIDATA_NPC::execIsValidData(FFrame&, void* const)
native static function bool IsValidData(int Id);

// Export UUIDATA_NPC::execGetNPCName(FFrame&, void* const)
native static function string GetNPCName(int Id);

// Export UUIDATA_NPC::execGetNPCNickName(FFrame&, void* const)
native static function string GetNPCNickName(int Id);

// Export UUIDATA_NPC::execGetNpcProperty(FFrame&, void* const)
native static function bool GetNpcProperty(int Id, out array<int> arrProperty);

// Export UUIDATA_NPC::execGetSummonSort(FFrame&, void* const)
native static function int GetSummonSort(int Id);

// Export UUIDATA_NPC::execGetSummonMaxCount(FFrame&, void* const)
native static function int GetSummonMaxCount(int Id);

// Export UUIDATA_NPC::execGetSummonGrade(FFrame&, void* const)
native static function int GetSummonGrade(int Id);

// Export UUIDATA_NPC::execGetNPCIconName(FFrame&, void* const)
native static function string GetNPCIconName(int Id);

// Export UUIDATA_NPC::execGetMentoringNPCId(FFrame&, void* const)
native static function int GetMentoringNPCId();

// Export UUIDATA_NPC::execGetNPCMesh(FFrame&, void* const)
native static function string GetNPCMesh(int Id);

// Export UUIDATA_NPC::execGetNPCTextureList(FFrame&, void* const)
native static function bool GetNPCTextureList(int Id, out array<string> TexList);

// Export UUIDATA_NPC::execGetNPCClass(FFrame&, void* const)
native static function string GetNPCClass(int Id);

defaultproperties
{
}
