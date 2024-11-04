//================================================================================
// UIDATA_CLAN.
//================================================================================

class UIDATA_CLAN extends UIDataManager
	native;

// Export UUIDATA_CLAN::execGetName(FFrame&, void* const)
native static function string GetName(int Id);

// Export UUIDATA_CLAN::execGetAllianceName(FFrame&, void* const)
native static function string GetAllianceName(int Id);

// Export UUIDATA_CLAN::execGetCrestTexture(FFrame&, void* const)
native static function bool GetCrestTexture(int Id, out Texture texCrest);

// Export UUIDATA_CLAN::execGetEmblemTexture(FFrame&, void* const)
native static function bool GetEmblemTexture(int Id, out Texture emblemTexture);

// Export UUIDATA_CLAN::execGetAllianceCrestTexture(FFrame&, void* const)
native static function bool GetAllianceCrestTexture(int Id, out Texture texCrest);

// Export UUIDATA_CLAN::execGetNameValue(FFrame&, void* const)
native static function bool GetNameValue(int Id, out int namevalue);

// Export UUIDATA_CLAN::execRequestClanInfo(FFrame&, void* const)
native static function RequestClanInfo();

// Export UUIDATA_CLAN::execRequestClanSkillList(FFrame&, void* const)
native static function RequestClanSkillList();

// Export UUIDATA_CLAN::execRequestSubClanSkillList(FFrame&, void* const)
native static function RequestSubClanSkillList(int subClanIndex);

// Export UUIDATA_CLAN::execGetSkillLevel(FFrame&, void* const)
native static function int GetSkillLevel(int SkillID);

// Export UUIDATA_CLAN::execGetSubClanSkillLevel(FFrame&, void* const)
native static function int GetSubClanSkillLevel(int SkillID, int subClanIndex);

// Export UUIDATA_CLAN::execRequestUnionInfo(FFrame&, void* const)
native static function RequestUnionInfo();

// Export UUIDATA_CLAN::execRequestOpenUnionWnd(FFrame&, void* const)
native static function RequestOpenUnionWnd();

defaultproperties
{
}
