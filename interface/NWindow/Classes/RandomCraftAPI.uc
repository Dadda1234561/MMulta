//================================================================================
// RandomCraftAPI.
//================================================================================

class RandomCraftAPI extends UIEventManager
	native;

struct ItemAmount
{
	var int ItemClassID;
	var int Amount;
};

// Export URandomCraftAPI::execGetMaxSlotLockCount(FFrame&, void* const)
native static function byte GetMaxSlotLockCount();

// Export URandomCraftAPI::execGetMaxItemLockCount(FFrame&, void* const)
native static function byte GetMaxItemLockCount();

// Export URandomCraftAPI::execGetItemLockCost(FFrame&, void* const)
native static function ItemAmount GetItemLockCost(byte lockNum);

// Export URandomCraftAPI::execGetItemMakingCosts(FFrame&, void* const)
native static function array<ItemAmount> GetItemMakingCosts();

// Export URandomCraftAPI::execGetRestCosts(FFrame&, void* const)
native static function array<ItemAmount> GetRestCosts();

// Export URandomCraftAPI::execGetMaxItemPoint(FFrame&, void* const)
native static function byte GetMaxItemPoint();

// Export URandomCraftAPI::execGetSlotsSuccessRate(FFrame&, void* const)
native static function array<byte> GetSlotsSuccessRate();

// Export URandomCraftAPI::execGetRewardItems(FFrame&, void* const)
native static function array<ItemAmount> GetRewardItems();

// Export URandomCraftAPI::execGetItemAnnounceGrade(FFrame&, void* const)
native static function UIEventManager.RandomCraftAnnounceGrade GetItemAnnounceGrade(int nItemClassID);

// Export URandomCraftAPI::execGetMaxGaugeValue(FFrame&, void* const)
native static function int GetMaxGaugeValue();

defaultproperties
{
}
