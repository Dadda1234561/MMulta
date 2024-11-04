//================================================================================
// PostWndAPI.
//================================================================================

class PostWndAPI extends UIEventManager
	native;

// Export UPostWndAPI::execRequestFriendList(FFrame&, void* const)
native static function RequestFriendList();

// Export UPostWndAPI::execRequestAddingPostFriend(FFrame&, void* const)
native static function RequestAddingPostFriend(string Name);

// Export UPostWndAPI::execRequestDeletingPostFriend(FFrame&, void* const)
native static function RequestDeletingPostFriend(string Name);

// Export UPostWndAPI::execRequestPostFriendList(FFrame&, void* const)
native static function RequestPostFriendList();

// Export UPostWndAPI::execRequestPledgeMemberList(FFrame&, void* const)
native static function RequestPledgeMemberList();

defaultproperties
{
}
