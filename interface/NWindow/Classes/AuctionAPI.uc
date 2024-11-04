//================================================================================
// AuctionAPI.
//================================================================================

class AuctionAPI extends Object
	native
	export;

// Export UAuctionAPI::execRequestBidItemAuction(FFrame&, void* const)
native static function RequestBidItemAuction(int AuctionID, INT64 Adena);

// Export UAuctionAPI::execRequestInfoItemAuction(FFrame&, void* const)
native static function RequestInfoItemAuction(int AuctionID);

defaultproperties
{
}
