//================================================================================
// ConsignmentSaleAPI.
//================================================================================

class ConsignmentSaleAPI extends Object
	native
	export;

// Export UConsignmentSaleAPI::execRequestCommissionInfo(FFrame&, void* const)
native static function RequestCommissionInfo(int ServerID);

// Export UConsignmentSaleAPI::execRequestCommissionRegistrableItemList(FFrame&, void* const)
native static function RequestCommissionRegistrableItemList();

// Export UConsignmentSaleAPI::execRequestCommissionSellingPremiumItemList(FFrame&, void* const)
native static function RequestCommissionSellingPremiumItemList();

// Export UConsignmentSaleAPI::execRequestCommissionRegister(FFrame&, void* const)
native static function RequestCommissionRegister(int ServerID, string ItemName, INT64 PricePerUnit, INT64 Amount, int Period, int premiumItemID);

// Export UConsignmentSaleAPI::execRequestCommissionCancel(FFrame&, void* const)
native static function RequestCommissionCancel();

// Export UConsignmentSaleAPI::execRequestCommissionDelete(FFrame&, void* const)
native static function RequestCommissionDelete(INT64 CommissionDBId, int ItemType, int PeriodType);

// Export UConsignmentSaleAPI::execRequestCommissionList(FFrame&, void* const)
native static function RequestCommissionList(int depth, int DepthType, int NameCalss, int Grade, string SearchString);

// Export UConsignmentSaleAPI::execRequestCommissionBuyInfo(FFrame&, void* const)
native static function RequestCommissionBuyInfo(INT64 CommissionDBId, int ItemType);

// Export UConsignmentSaleAPI::execRequestCommissionBuyItem(FFrame&, void* const)
native static function RequestCommissionBuyItem(INT64 CommissionDBId, int ItemType);

// Export UConsignmentSaleAPI::execRequestCommissionRegisteredItem(FFrame&, void* const)
native static function RequestCommissionRegisteredItem();

// Export UConsignmentSaleAPI::execGetCommissionSellerID(FFrame&, void* const)
native static function int GetCommissionSellerID();

defaultproperties
{
}
