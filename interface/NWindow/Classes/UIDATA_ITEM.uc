//================================================================================
// UIDATA_ITEM.
//================================================================================

class UIDATA_ITEM extends UIDataManager
	native;

// Export UUIDATA_ITEM::execGetFirstID(FFrame&, void* const)
native static function ItemID GetFirstID();

// Export UUIDATA_ITEM::execGetNextID(FFrame&, void* const)
native static function ItemID GetNextID();

// Export UUIDATA_ITEM::execFindNextID(FFrame&, void* const)
native static function ItemID FindNextID(string strItemName, int ItemType, int ItemCrystalType);

// Export UUIDATA_ITEM::execGetDataCount(FFrame&, void* const)
native static function int GetDataCount();

// Export UUIDATA_ITEM::execGetItemName(FFrame&, void* const)
native static function string GetItemName(ItemID Id);

// Export UUIDATA_ITEM::execGetItemAdditionalName(FFrame&, void* const)
native static function string GetItemAdditionalName(ItemID Id);

// Export UUIDATA_ITEM::execGetItemTextureName(FFrame&, void* const)
native static function string GetItemTextureName(ItemID Id);

// Export UUIDATA_ITEM::execGetItemDescription(FFrame&, void* const)
native static function string GetItemDescription(ItemID Id);

// Export UUIDATA_ITEM::execGetItemWeight(FFrame&, void* const)
native static function int GetItemWeight(ItemID Id);

// Export UUIDATA_ITEM::execGetItemDataType(FFrame&, void* const)
native static function int GetItemDataType(ItemID Id);

// Export UUIDATA_ITEM::execGetItemCrystalType(FFrame&, void* const)
native static function int GetItemCrystalType(ItemID Id);

// Export UUIDATA_ITEM::execGetItemInfo(FFrame&, void* const)
native static function bool GetItemInfo(ItemID Id, out ItemInfo Info);

// Export UUIDATA_ITEM::execGetItemInfoString(FFrame&, void* const)
native static function bool GetItemInfoString(int ItemClassID, out string Info);

// Export UUIDATA_ITEM::execIsCrystallizable(FFrame&, void* const)
native static function bool IsCrystallizable(ItemID Id);

// Export UUIDATA_ITEM::execIsMagicWeapon(FFrame&, void* const)
native static function bool IsMagicWeapon(ItemID Id);

// Export UUIDATA_ITEM::execGetRefineryItemName(FFrame&, void* const)
native static function string GetRefineryItemName(string strItemName, int RefineryOp1, int RefineryOp2);

// Export UUIDATA_ITEM::execGetSetItemNum(FFrame&, void* const)
native static function int GetSetItemNum(ItemID Id, int setIdId);

// Export UUIDATA_ITEM::execIsExistSetItem(FFrame&, void* const)
native static function bool IsExistSetItem(ItemID Id, int setId, int Index);

// Export UUIDATA_ITEM::execGetSetItemFirstID(FFrame&, void* const)
native static function int GetSetItemFirstID(ItemID Id, int setId, int Index);

// Export UUIDATA_ITEM::execGetSetItemID(FFrame&, void* const)
native static function bool GetSetItemID(ItemID Id, int setId, int Index, out array<ItemID> arrID);

// Export UUIDATA_ITEM::execGetItemSetEnchantEffectNum(FFrame&, void* const)
native static function int GetItemSetEnchantEffectNum(ItemID Id);

// Export UUIDATA_ITEM::execGetSetItemEnchantConditionalValue(FFrame&, void* const)
native static function int GetSetItemEnchantConditionalValue(ItemID Id, int Index);

// Export UUIDATA_ITEM::execGetSetItemEnchantEffectDescription(FFrame&, void* const)
native static function string GetSetItemEnchantEffectDescription(ItemID Id, int Index);

// Export UUIDATA_ITEM::execGetEtcItemTextureName(FFrame&, void* const)
native static function string GetEtcItemTextureName(ItemID Id);

// Export UUIDATA_ITEM::execGetSetItemPeaceEffectNum(FFrame&, void* const)
native static function int GetSetItemPeaceEffectNum(ItemID Id, int setId);

// Export UUIDATA_ITEM::execGetSetItemPeaceEffectDescription(FFrame&, void* const)
native static function string GetSetItemPeaceEffectDescription(ItemID Id, int setId, int EffectIndex);

// Export UUIDATA_ITEM::execGetItemNameClass(FFrame&, void* const)
native static function int GetItemNameClass(ItemID Id);

// Export UUIDATA_ITEM::execGetInventoryType(FFrame&, void* const)
native static function UIEventManager.EItemInventoryType GetInventoryType(int ClassID);

// Export UUIDATA_ITEM::execGetTextureName(FFrame&, void* const)
native static function GetTextureName(ItemID Id, int MeshType, out array<string> TexNameList);

// Export UUIDATA_ITEM::execGetMeshName(FFrame&, void* const)
native static function GetMeshName(ItemID Id, int MeshType, out array<string> MeshNameList);

// Export UUIDATA_ITEM::execGetExTextureName(FFrame&, void* const)
native static function GetExTextureName(ItemID Id, int MeshType, out array<string> ExTexNameList);

// Export UUIDATA_ITEM::execGetExMeshName(FFrame&, void* const)
native static function GetExMeshName(ItemID Id, int MeshType, out array<string> ExMeshNameList);

// Export UUIDATA_ITEM::execGetAutomaticUseItemType(FFrame&, void* const)
native static function UIEventManager.EAutomaticUseItemType GetAutomaticUseItemType(int ItemClassID);

// Export UUIDATA_ITEM::execGetEnchantedItemSkillDesc(FFrame&, void* const)
native static function bool GetEnchantedItemSkillDesc(int a_ClassID, int a_Enchanted, out array<string> o_Descriptions, out int o_FontLevel);

// Export UUIDATA_ITEM::execGetBlessOptionData(FFrame&, void* const)
native static function GetBlessOptionData(int ItemClassID, out array<BlessOptionData> o_OptionList);

// Export UUIDATA_ITEM::execGetBlessedItemName(FFrame&, void* const)
native static function string GetBlessedItemName(string strItemName);

// Export UUIDATA_ITEM::execGetEnchantBlessScrollData(FFrame&, void* const)
native static function bool GetEnchantBlessScrollData(int ItemClassID, out EnchantBlessScrollUIData o_data);

// Export UUIDATA_ITEM::execGetDBDeleteDateString(FFrame&, void* const)
native static function string GetDBDeleteDateString(INT64 nDBDeleteDate);

// Export UUIDATA_ITEM::execGetDBDeleteRemainTimeString(FFrame&, void* const)
native static function string GetDBDeleteRemainTimeString(INT64 nDBDeleteDate);

// Export UUIDATA_ITEM::execGetEnchantValidateValue(FFrame&, void* const)
native static function GetEnchantValidateValue(int a_ItemClassID, int a_Enchanted, out EnchantValidateUIData o_data);

// Export UUIDATA_ITEM::execGetEnchantScrollSetData(FFrame&, void* const)
native static function bool GetEnchantScrollSetData(int a_ScrollItemClassID, out EnchantScrollSetUIData o_data);

// Export UUIDATA_ITEM::execGetChallengePointGroupID(FFrame&, void* const)
native static function byte GetChallengePointGroupID(int a_ItemClassID);

// Export UUIDATA_ITEM::execGetEnchantChallengePointSettingData(FFrame&, void* const)
native static function GetEnchantChallengePointSettingData(out EnchantChallengePointSettingUIData o_data);

// Export UUIDATA_ITEM::execGetEnchantChallengePointData(FFrame&, void* const)
native static function bool GetEnchantChallengePointData(byte a_PointGroupID, out EnchantChallengePointUIData o_data);

// Export UUIDATA_ITEM::execGetItemCreateInfo(FFrame&, void* const)
native static function bool GetItemCreateInfo(int a_ItemClassID, out array<ItemCreateUIData> o_ItemList);

// Export UUIDATA_ITEM::execIsDefaultActionPeel(FFrame&, void* const)
native static function bool IsDefaultActionPeel(int a_ItemClassID);

// Export UUIDATA_ITEM::execGetStringMatchingItemList(FFrame&, void* const)
native static function GetStringMatchingItemList(string a_str, string a_delim, UIEventManager.EStringMatchingItemFilter a_filter, bool a_bAscend, out array<int> o_ItemList);

// Export UUIDATA_ITEM::execIsDualInventorySlot(FFrame&, void* const)
native static function bool IsDualInventorySlot(INT64 a_SlotBitType);

defaultproperties
{
}
