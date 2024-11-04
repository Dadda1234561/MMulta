//================================================================================
// UIDATA_INVENTORY.
//================================================================================

class UIDATA_INVENTORY extends UIDataManager
	native;

// Export UUIDATA_INVENTORY::execHasItem(FFrame&, void* const)
native static function bool HasItem(int a_ServerID);

// Export UUIDATA_INVENTORY::execHasItemByClassID(FFrame&, void* const)
native static function bool HasItemByClassID(int a_ClassID);

// Export UUIDATA_INVENTORY::execFindItem(FFrame&, void* const)
native static function bool FindItem(int a_ServerID, out ItemInfo Info);

// Export UUIDATA_INVENTORY::execFindItemByClassID(FFrame&, void* const)
native static function int FindItemByClassID(int a_ClassID, out array<ItemInfo> Info);

// Export UUIDATA_INVENTORY::execIsEquipItem(FFrame&, void* const)
native static function bool IsEquipItem(int a_ServerID);

// Export UUIDATA_INVENTORY::execIsEquipItemByClassID(FFrame&, void* const)
native static function bool IsEquipItemByClassID(int a_ClassID);

// Export UUIDATA_INVENTORY::execIsQuestItem(FFrame&, void* const)
native static function bool IsQuestItem(int a_ServerID);

// Export UUIDATA_INVENTORY::execIsQuestItemByClassID(FFrame&, void* const)
native static function bool IsQuestItemByClassID(int a_ClassID);

// Export UUIDATA_INVENTORY::execGetAllItem(FFrame&, void* const)
native static function int GetAllItem(out array<ItemInfo> Info);

// Export UUIDATA_INVENTORY::execGetAllEquipItem(FFrame&, void* const)
native static function int GetAllEquipItem(out array<ItemInfo> Info);

// Export UUIDATA_INVENTORY::execGetAllInvenItem(FFrame&, void* const)
native static function int GetAllInvenItem(out array<ItemInfo> Info);

// Export UUIDATA_INVENTORY::execGetAllQuestItem(FFrame&, void* const)
native static function int GetAllQuestItem(out array<ItemInfo> Info);

// Export UUIDATA_INVENTORY::execGetAllArtifactItem(FFrame&, void* const)
native static function int GetAllArtifactItem(out array<ItemInfo> Info);

// Export UUIDATA_INVENTORY::execGetItemByScriptFilter(FFrame&, void* const)
native static function int GetItemByScriptFilter(int FilterID, out array<ItemInfo> Info);

// Export UUIDATA_INVENTORY::execGetAllEnchantableInvenItem(FFrame&, void* const)
native static function int GetAllEnchantableInvenItem(int a_ScrollItemClassID, out array<ItemInfo> o_ItemInfos);

// Export UUIDATA_INVENTORY::execGetAllDefaultActionPeelItem(FFrame&, void* const)
native static function int GetAllDefaultActionPeelItem(out array<ItemInfo> o_ItemInfos);

defaultproperties
{
}
