//================================================================================
// RefineryAPI.
//================================================================================

class RefineryAPI extends UIEventManager
	native;

// Export URefineryAPI::execConfirmTargetItem(FFrame&, void* const)
native static function ConfirmTargetItem(ItemID sID);

// Export URefineryAPI::execConfirmRefinerItem(FFrame&, void* const)
native static function ConfirmRefinerItem(ItemID a_TargetItemID, ItemID a_RefinerItemID);

// Export URefineryAPI::execConfirmGemStone(FFrame&, void* const)
native static function ConfirmGemStone(ItemID a_TargetItemID, ItemID a_RefinerItemID, ItemID a_GemStoneID, INT64 a_GemStoneCount);

// Export URefineryAPI::execConfirmCancelItem(FFrame&, void* const)
native static function ConfirmCancelItem(ItemID a_CancelItemID);

// Export URefineryAPI::execRequestRefineCancel(FFrame&, void* const)
native static function RequestRefineCancel(ItemID a_CancelItemID);

// Export URefineryAPI::execGetItemListFromInven(FFrame&, void* const)
native static function int GetItemListFromInven(int TargetItemClassID, out array<ItemInfo> Items);

// Export URefineryAPI::execGetTargetItemListFromInven(FFrame&, void* const)
native static function int GetTargetItemListFromInven(out array<ItemInfo> Items);

// Export URefineryAPI::execGetRefineryFee(FFrame&, void* const)
native static function bool GetRefineryFee(int TargetItemClassID, int FeeItemPercent, int FeeAdenaPercent, out int FeeItemID, out int FeeItemCount, out INT64 FeeAdena, out int CancelFee);

// Export URefineryAPI::execGetOptionDesc(FFrame&, void* const)
native static function bool GetOptionDesc(int TargetItemClassID, int RefinerClassID, out string OptionDesc1, out string OptionDesc2, out string OptionDesc3, out string OptionDesc4);

// Export URefineryAPI::execGetOptionProbability(FFrame&, void* const)
native static function bool GetOptionProbability(int TargetItemClassID, int RefinerClassID, out array<VariationProbUIData> Variation1, out array<VariationProbUIData> Variation2);

// Export URefineryAPI::execGetOptionDescByOptionID(FFrame&, void* const)
native static function bool GetOptionDescByOptionID(int OptionID, out string OptionDesc1, out string OptionDesc2, out string OptionDesc3);

defaultproperties
{
}
