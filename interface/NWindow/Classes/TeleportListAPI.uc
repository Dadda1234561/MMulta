//================================================================================
// TeleportListAPI.
//================================================================================

class TeleportListAPI extends UIEventManager
	native;

struct TeleportListData
{
	var string Name;
	var int Id;
	var int TownID;
	var int DominionID;
	var int locX;
	var int locY;
	var int Type;
	var int Level;
	var int Priority;
	var array<RequestItem> Price;
	var int UsableLevel;
	var int UsableTransferDegree;
	var int ServerRange;
};

// Export UTeleportListAPI::execGetCurrentZoneKey(FFrame&, void* const)
native static function int GetCurrentZoneKey();

// Export UTeleportListAPI::execGetTeleportListaDataWithZoneKey(FFrame&, void* const)
native static function TeleportListData GetTeleportListaDataWithZoneKey(int nZoneKey);

// Export UTeleportListAPI::execModifyExceptionLocation(FFrame&, void* const)
native static function Vector ModifyExceptionLocation(int locX, int locY, int locZ);

// Export UTeleportListAPI::execGetFirstTeleportListData(FFrame&, void* const)
native static function TeleportListData GetFirstTeleportListData();

// Export UTeleportListAPI::execGetNextTeleportListData(FFrame&, void* const)
native static function TeleportListData GetNextTeleportListData();

// Export UTeleportListAPI::execGetDominionList(FFrame&, void* const)
native static function int GetDominionList(out array<int> IDList, out array<string> NameList);

// Export UTeleportListAPI::execRequestTeleport(FFrame&, void* const)
native static function RequestTeleport(int nTeleportID);

// Export UTeleportListAPI::execRequestTeleportFavoritesList(FFrame&, void* const)
native static function RequestTeleportFavoritesList();

defaultproperties
{
}
