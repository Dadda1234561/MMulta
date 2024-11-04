//================================================================================
// UIDATA_ARTIFACT.
//================================================================================

class UIDATA_ARTIFACT extends UIDataManager
	native;

// Export UUIDATA_ARTIFACT::execGetArtifactMinEnchantMaterial(FFrame&, void* const)
native static function int GetArtifactMinEnchantMaterial(int Enchant);

// Export UUIDATA_ARTIFACT::execGetArtifactMaterialGroupList(FFrame&, void* const)
native static function bool GetArtifactMaterialGroupList(int ArtifactGroupID, out array<int> MaterialIDs);

// Export UUIDATA_ARTIFACT::execGetArtifactEnchantCondition(FFrame&, void* const)
native static function bool GetArtifactEnchantCondition(int ArtifactID, int Enchant, out int GroupID, out int MaterialCount, out int ResultProb);

// Export UUIDATA_ARTIFACT::execGetAllArtifactData(FFrame&, void* const)
native static function GetAllArtifactData(out array<ArtifactUIData> ArtifactData);

// Export UUIDATA_ARTIFACT::execFindArtifactData(FFrame&, void* const)
native static function bool FindArtifactData(int ArtifactItemID, out ArtifactUIData Data);

defaultproperties
{
}
