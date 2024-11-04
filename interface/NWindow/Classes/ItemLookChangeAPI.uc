//================================================================================
// ItemLookChangeAPI.
//================================================================================

class ItemLookChangeAPI extends UIEventManager
	native;

// Export UItemLookChangeAPI::execRequestItemLookChange(FFrame&, void* const)
native static function RequestItemLookChange(ItemID a_sTargetID);

// Export UItemLookChangeAPI::execRequestExTryToPut_Shape_Shifting_TargetItem(FFrame&, void* const)
native static function RequestExTryToPut_Shape_Shifting_TargetItem(ItemID a_sTargetID);

// Export UItemLookChangeAPI::execRequestExTryToPut_Shape_Shifting_EnchantSupportItem(FFrame&, void* const)
native static function RequestExTryToPut_Shape_Shifting_EnchantSupportItem(ItemID a_sTargetID, ItemID a_sSupportID);

// Export UItemLookChangeAPI::execRequestExCancelItemLookChange(FFrame&, void* const)
native static function RequestExCancelItemLookChange();

defaultproperties
{
}
