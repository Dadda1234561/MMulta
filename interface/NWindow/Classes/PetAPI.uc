//================================================================================
// PetAPI.
//================================================================================

class PetAPI extends UIEventManager
	native;

// Export UPetAPI::execRequestPetInventoryItemList(FFrame&, void* const)
native static function RequestPetInventoryItemList();

// Export UPetAPI::execRequestPetUseItem(FFrame&, void* const)
native static function RequestPetUseItem(ItemID sID);

// Export UPetAPI::execRequestGiveItemToPet(FFrame&, void* const)
native static function RequestGiveItemToPet(ItemID sID, INT64 Num);

// Export UPetAPI::execRequestGetItemFromPet(FFrame&, void* const)
native static function RequestGetItemFromPet(ItemID sID, INT64 Num, bool IsEquipItem);

// Export UPetAPI::execGetPetEvolveCondition(FFrame&, void* const)
native static function bool GetPetEvolveCondition(int PetID, int EvolveStep, out array<EvolveCondition> arrReqConditions, out array<RequestItem> arrReqItems);

// Export UPetAPI::execGetPetEvolveLookInfo(FFrame&, void* const)
native static function bool GetPetEvolveLookInfo(int EvolveLookID, out PetLookInfo LookInfo);

// Export UPetAPI::execGetPetEvolveNameInfo(FFrame&, void* const)
native static function bool GetPetEvolveNameInfo(int EvolveNameID, out PetNameInfo NameInfo);

// Export UPetAPI::execGetPetNameIDBySkill(FFrame&, void* const)
native static function int GetPetNameIDBySkill(int a_SkillID, int a_SkillLevel);

// Export UPetAPI::execGetPetAcquireSkillList(FFrame&, void* const)
native static function GetPetAcquireSkillList(int PetID, int PetLevel, int EvolveStep, out array<PetAcquireSkillInfo> arrAcquireSkill);

// Export UPetAPI::execGetPetExtractInfo(FFrame&, void* const)
native static function bool GetPetExtractInfo(int PetID, int PetLevel, out PetExtractInfo ExtractInfo);

// Export UPetAPI::execGetPetRaceEmblemData(FFrame&, void* const)
native static function bool GetPetRaceEmblemData(int a_PetID, out L2PetRaceEmblemUIData o_PetEmblemData);

// Export UPetAPI::execGetPetRaceEmblemDataAll(FFrame&, void* const)
native static function GetPetRaceEmblemDataAll(out array<L2PetRaceEmblemUIData> o_ArrPetEmblemData);

defaultproperties
{
}
