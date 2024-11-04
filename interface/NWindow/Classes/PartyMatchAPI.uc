//================================================================================
// PartyMatchAPI.
//================================================================================

class PartyMatchAPI extends Object
	native
	export;

// Export UPartyMatchAPI::execRequestOpenPartyMatch(FFrame&, void* const)
native static function RequestOpenPartyMatch();

// Export UPartyMatchAPI::execRequestPartyRoomList(FFrame&, void* const)
native static function RequestPartyRoomList(int a_Page, int a_LocationFilter, int a_LevelFilter);

// Export UPartyMatchAPI::execRequestJoinPartyRoom(FFrame&, void* const)
native static function RequestJoinPartyRoom(int a_RoomNumber);

// Export UPartyMatchAPI::execRequestJoinPartyRoomAuto(FFrame&, void* const)
native static function RequestJoinPartyRoomAuto(int a_Page, int a_LocationFilter, int a_LevelFilter);

// Export UPartyMatchAPI::execRequestManagePartyRoom(FFrame&, void* const)
native static function RequestManagePartyRoom(int a_RoomNumber, int a_MaxPartyMemberCount, int a_MinLevel, int a_MaxLevel, string a_RoomTitle);

// Export UPartyMatchAPI::execRequestDismissPartyRoom(FFrame&, void* const)
native static function RequestDismissPartyRoom(int a_RoomNumber);

// Export UPartyMatchAPI::execRequestWithdrawPartyRoom(FFrame&, void* const)
native static function RequestWithdrawPartyRoom(int a_RoomNumber);

// Export UPartyMatchAPI::execRequestBanFromPartyRoom(FFrame&, void* const)
native static function RequestBanFromPartyRoom(int a_MemberID);

// Export UPartyMatchAPI::execRequestPartyMatchWaitList(FFrame&, void* const)
native static function RequestPartyMatchWaitList(int a_Page, int a_MinLevel, int a_MaxLevel, int ClassRole);

// Export UPartyMatchAPI::execRequestExitPartyMatchingWaitingRoom(FFrame&, void* const)
native static function RequestExitPartyMatchingWaitingRoom();

// Export UPartyMatchAPI::execRequestAskJoinPartyRoom(FFrame&, void* const)
native static function RequestAskJoinPartyRoom(string a_name);

// Export UPartyMatchAPI::execRequestPartyMatchingHistory(FFrame&, void* const)
native static function RequestPartyMatchingHistory();

// Export UPartyMatchAPI::execRequestListMpccWaiting(FFrame&, void* const)
native static function RequestListMpccWaiting(int Page, int Location, int LevelFilter);

// Export UPartyMatchAPI::execRequestManageMpccRoom(FFrame&, void* const)
native static function RequestManageMpccRoom(int RoomNum, int MaxMemberCount, int MinLevelLimit, int MaxLevelLimit, int PartyRoutingType, string Title);

// Export UPartyMatchAPI::execRequestJoinMpccRoom(FFrame&, void* const)
native static function RequestJoinMpccRoom(int RoomNum, int Location);

// Export UPartyMatchAPI::execRequestOustFromMpccRoom(FFrame&, void* const)
native static function RequestOustFromMpccRoom(int Id);

// Export UPartyMatchAPI::execRequestDismissMpccRoom(FFrame&, void* const)
native static function RequestDismissMpccRoom();

// Export UPartyMatchAPI::execRequestWithdrawMpccRoom(FFrame&, void* const)
native static function RequestWithdrawMpccRoom();

// Export UPartyMatchAPI::execRequestMpccPartymasterList(FFrame&, void* const)
native static function RequestMpccPartymasterList();

defaultproperties
{
}
