//================================================================================
// EnchantAPI.
//================================================================================

class EnchantAPI extends UIEventManager
	native;

// Export UEnchantAPI::execRequestEnchantItem(FFrame&, void* const)
native static function RequestEnchantItem(ItemID a_sTargetID, bool a_UseLateAnnounce);

// Export UEnchantAPI::execRequestEnchantItemAttribute(FFrame&, void* const)
native static function RequestEnchantItemAttribute(ItemID sID, INT64 Num);

// Export UEnchantAPI::execRequestRemoveAttribute(FFrame&, void* const)
native static function RequestRemoveAttribute(ItemID sID, int Type);

// Export UEnchantAPI::execRequestExTryToPutEnchantTargetItem(FFrame&, void* const)
native static function RequestExTryToPutEnchantTargetItem(ItemID a_sTargetID);

// Export UEnchantAPI::execRequestExTryToPutEnchantSupportItem(FFrame&, void* const)
native static function RequestExTryToPutEnchantSupportItem(ItemID a_sTargetID, ItemID a_sSupportID);

// Export UEnchantAPI::execRequestExAddEnchantScrollItem(FFrame&, void* const)
native static function RequestExAddEnchantScrollItem(ItemID a_sTargetID, ItemID a_sScrollID);

// Export UEnchantAPI::execRequestExRemoveEnchantSupportItem(FFrame&, void* const)
native static function RequestExRemoveEnchantSupportItem();

// Export UEnchantAPI::execRequestExCancelEnchantItem(FFrame&, void* const)
native static function RequestExCancelEnchantItem();

// Export UEnchantAPI::execRequestLockedItem(FFrame&, void* const)
native static function RequestLockedItem(int TargetItemID);

// Export UEnchantAPI::execRequestLockedItemCancel(FFrame&, void* const)
native static function RequestLockedItemCancel();

// Export UEnchantAPI::execRequestUnlockedItem(FFrame&, void* const)
native static function RequestUnlockedItem(int TargetItemID);

// Export UEnchantAPI::execRequestUnlockedItemCancel(FFrame&, void* const)
native static function RequestUnlockedItemCancel();

defaultproperties
{
}
