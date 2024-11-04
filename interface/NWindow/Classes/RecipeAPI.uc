//================================================================================
// RecipeAPI.
//================================================================================

class RecipeAPI extends UIEventManager
	native;

// Export URecipeAPI::execRequestRecipeShopMakeInfo(FFrame&, void* const)
native static function RequestRecipeShopMakeInfo(int nServerID, int nRecipeID);

// Export URecipeAPI::execRequestRecipeShopSellList(FFrame&, void* const)
native static function RequestRecipeShopSellList(int nServerID);

// Export URecipeAPI::execRequestRecipeShopMakeDo(FFrame&, void* const)
native static function RequestRecipeShopMakeDo(int merchantId, int RecipeID, INT64 Adena, optional int OfferingCount, optional array<OfferingItemList> OfferItemList);

// Export URecipeAPI::execRequestRecipeItemMakeSelf(FFrame&, void* const)
native static function RequestRecipeItemMakeSelf(int RecipeID, optional int OfferingCount, optional array<OfferingItemList> OfferItemList);

// Export URecipeAPI::execRequestRecipeItemMakeInfo(FFrame&, void* const)
native static function RequestRecipeItemMakeInfo(ItemID sID);

// Export URecipeAPI::execRequestRecipeBookOpen(FFrame&, void* const)
native static function RequestRecipeBookOpen(int Type);

// Export URecipeAPI::execRequestRecipeItemDelete(FFrame&, void* const)
native static function RequestRecipeItemDelete(ItemID sID);

// Export URecipeAPI::execRequestRecipeShopManageQuit(FFrame&, void* const)
native static function RequestRecipeShopManageQuit();

// Export URecipeAPI::execRequestRecipeShopMessageSet(FFrame&, void* const)
native static function RequestRecipeShopMessageSet(string strMsg);

// Export URecipeAPI::execRequestRecipeShopListSet(FFrame&, void* const)
native static function RequestRecipeShopListSet(string param);

defaultproperties
{
}
