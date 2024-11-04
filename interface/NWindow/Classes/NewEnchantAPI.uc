//================================================================================
// NewEnchantAPI.
//================================================================================

class NewEnchantAPI extends UIEventManager
	native;

// Export UNewEnchantAPI::execRequestPushOne(FFrame&, void* const)
native static function RequestPushOne(ItemID a_sTargetID);

// Export UNewEnchantAPI::execRequestPushTwo(FFrame&, void* const)
native static function RequestPushTwo(ItemID a_sTargetID);

// Export UNewEnchantAPI::execRequestRemoveOne(FFrame&, void* const)
native static function RequestRemoveOne(ItemID a_sTargetID);

// Export UNewEnchantAPI::execRequestRemoveTwo(FFrame&, void* const)
native static function RequestRemoveTwo(ItemID a_sTargetID);

// Export UNewEnchantAPI::execRequestTryEnchant(FFrame&, void* const)
native static function RequestTryEnchant();

// Export UNewEnchantAPI::execRequestClose(FFrame&, void* const)
native static function RequestClose();

// Export UNewEnchantAPI::execRequestEnchantRetryPutItems(FFrame&, void* const)
native static function RequestEnchantRetryPutItems(int OneSlotItemServerID, int TwoSlotItemServerID);

// Export UNewEnchantAPI::execGetMaterialItemForEnchantFromInven(FFrame&, void* const)
native static function int GetMaterialItemForEnchantFromInven(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out INT64 Commission, out array<ItemInfo> MaterialItems, optional int FilterID);

// Export UNewEnchantAPI::execGetMaterialItemForEnchantFromEquip(FFrame&, void* const)
native static function int GetMaterialItemForEnchantFromEquip(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out INT64 Commission, out array<ItemInfo> MaterialItems, optional int FilterID);

// Export UNewEnchantAPI::execGetResultItemForEnchant(FFrame&, void* const)
native static function bool GetResultItemForEnchant(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out int ResultItemClassID, out int ResultItemEnchant, out int ResultItemNum, out int ResultItemDisplay, out int FailResultItemClassID, out int FailResultItemEnchant, out int FailResultItemNum, out int FailResultItemDisplay);

// Export UNewEnchantAPI::execIsNoFailResultEffectType(FFrame&, void* const)
native static function bool IsNoFailResultEffectType(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant);

// Export UNewEnchantAPI::execGetEnchantCandidateMaterialList(FFrame&, void* const)
native static function int GetEnchantCandidateMaterialList(int ItemClassID, out array<int> CandidateMaterials);

// Export UNewEnchantAPI::execGetCombinationItemData(FFrame&, void* const)
native static function bool GetCombinationItemData(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out CombinationItemUIData o_data);

defaultproperties
{
}
