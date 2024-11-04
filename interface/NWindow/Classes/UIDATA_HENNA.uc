//================================================================================
// UIDATA_HENNA.
//================================================================================

class UIDATA_HENNA extends UIDataManager
	native;

// Export UUIDATA_HENNA::execGetItemCheck(FFrame&, void* const)
native static function bool GetItemCheck(int a_ID);

// Export UUIDATA_HENNA::execGetItemNameS(FFrame&, void* const)
native static function string GetItemNameS(int a_ID);

// Export UUIDATA_HENNA::execGetDescriptionS(FFrame&, void* const)
native static function string GetDescriptionS(int a_ID);

// Export UUIDATA_HENNA::execGetIconTexS(FFrame&, void* const)
native static function string GetIconTexS(int a_ID);

// Export UUIDATA_HENNA::execGetAddtionNameS(FFrame&, void* const)
native static function string GetAddtionNameS(int a_ID);

// Export UUIDATA_HENNA::execGetItemName(FFrame&, void* const)
native static function bool GetItemName(int a_ID, out string a_ItemName);

// Export UUIDATA_HENNA::execGetDescription(FFrame&, void* const)
native static function bool GetDescription(int a_ID, out string a_Description);

// Export UUIDATA_HENNA::execGetIconTex(FFrame&, void* const)
native static function bool GetIconTex(int a_ID, out string a_IconTex);

// Export UUIDATA_HENNA::execGetDyeEffectSkillInfo(FFrame&, void* const)
native static function bool GetDyeEffectSkillInfo(int a_ClassID, int a_SlotIndex, out SkillInfo a_DyeEffectSkillInfo);

// Export UUIDATA_HENNA::execGetMaxDyeChargeAmount(FFrame&, void* const)
native static function int GetMaxDyeChargeAmount();

// Export UUIDATA_HENNA::execGetHennaDyeItemLevel(FFrame&, void* const)
native static function bool GetHennaDyeItemLevel(int a_HennaID, out int o_DyeItemLevel);

// Export UUIDATA_HENNA::execGetHennaDyeItemClassID(FFrame&, void* const)
native static function bool GetHennaDyeItemClassID(int a_HennaID, out int o_ItemClassID);

// Export UUIDATA_HENNA::execGetDyePotentialData(FFrame&, void* const)
native static function bool GetDyePotentialData(int a_DyePotentialID, out DyePotentialUIData o_data);

// Export UUIDATA_HENNA::execGetDyePotentialDataList(FFrame&, void* const)
native static function GetDyePotentialDataList(int a_DyeSlotID, out array<DyePotentialUIData> o_DataArray);

// Export UUIDATA_HENNA::execGetDyePotentialExpDataList(FFrame&, void* const)
native static function GetDyePotentialExpDataList(out array<DyePotentialExpUIData> o_DataArray);

// Export UUIDATA_HENNA::execGetDyePotentialFeeData(FFrame&, void* const)
native static function bool GetDyePotentialFeeData(int a_EnchantFeeStep, out DyePotentialFeeUIData o_data);

// Export UUIDATA_HENNA::execGetDyeCombinationData(FFrame&, void* const)
native static function bool GetDyeCombinationData(int a_SlotOneItemClassID, out DyeCombinationUIData o_data);

// Export UUIDATA_HENNA::execGetHennaEmblemTex(FFrame&, void* const)
native static function string GetHennaEmblemTex(int a_HennaID);

// Export UUIDATA_HENNA::execGetDyePotentialFeeDataBySlot(FFrame&, void* const)
native static function bool GetDyePotentialFeeDataBySlot(int a_DyeSlotID, int a_DyePotentialLevel, int a_EnchantFeeStep, out DyePotentialFeeUIData o_data);

// Export UUIDATA_HENNA::execGetDyePotentialSlotFeeUIData(FFrame&, void* const)
native static function bool GetDyePotentialSlotFeeUIData(int a_DyeSlotID, int a_DyePotentialLevel, out DyePotentialSlotFeeUIData o_data);

defaultproperties
{
}
