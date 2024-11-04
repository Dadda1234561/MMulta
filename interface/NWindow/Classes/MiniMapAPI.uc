//================================================================================
// MiniMapAPI.
//================================================================================

class MiniMapAPI extends Object
	native
	export;

// Export UMiniMapAPI::execRequestCursedWeaponList(FFrame&, void* const)
native static function RequestCursedWeaponList();

// Export UMiniMapAPI::execRequestCursedWeaponLocation(FFrame&, void* const)
native static function RequestCursedWeaponLocation();

// Export UMiniMapAPI::execRequestTreasureBoxLocation(FFrame&, void* const)
native static function RequestTreasureBoxLocation();

// Export UMiniMapAPI::execRequestSeedPhase(FFrame&, void* const)
native static function RequestSeedPhase();

// Export UMiniMapAPI::execRequestRaidBossSpawnInfo(FFrame&, void* const)
native static function RequestRaidBossSpawnInfo(array<int> arrNpcIDs);

// Export UMiniMapAPI::execRequestItemAuctionStatus(FFrame&, void* const)
native static function RequestItemAuctionStatus();

// Export UMiniMapAPI::execRequestRaidServerInfo(FFrame&, void* const)
native static function RequestRaidServerInfo();

// Export UMiniMapAPI::execRequestShowAgitSiegeInfo(FFrame&, void* const)
native static function RequestShowAgitSiegeInfo();

defaultproperties
{
}
