//================================================================================
// PersonalConnectionAPI.
//================================================================================

class PersonalConnectionAPI extends UIDataManager
	native;

// Export UPersonalConnectionAPI::execRequestAddFriend(FFrame&, void* const)
native static function RequestAddFriend(string Name);

// Export UPersonalConnectionAPI::execRequestRemoveFriend(FFrame&, void* const)
native static function RequestRemoveFriend(string Name);

// Export UPersonalConnectionAPI::execRequestFriendInfoList(FFrame&, void* const)
native static function RequestFriendInfoList();

// Export UPersonalConnectionAPI::execRequestFriendDetailInfo(FFrame&, void* const)
native static function RequestFriendDetailInfo(string Name);

// Export UPersonalConnectionAPI::execRequestUpdateFriendMemo(FFrame&, void* const)
native static function RequestUpdateFriendMemo(string Name, string memo);

// Export UPersonalConnectionAPI::execRequestAddBlock(FFrame&, void* const)
native static function RequestAddBlock(string Name);

// Export UPersonalConnectionAPI::execRequestRemoveBlock(FFrame&, void* const)
native static function RequestRemoveBlock(string Name);

// Export UPersonalConnectionAPI::execRequestBlockInfoList(FFrame&, void* const)
native static function RequestBlockInfoList();

// Export UPersonalConnectionAPI::execRequestBlockDetailInfo(FFrame&, void* const)
native static function RequestBlockDetailInfo(string Name);

// Export UPersonalConnectionAPI::execRequestUpdateBlockMemo(FFrame&, void* const)
native static function RequestUpdateBlockMemo(string Name, string memo);

// Export UPersonalConnectionAPI::execRequestInzonePartyInfoHistory(FFrame&, void* const)
native static function RequestInzonePartyInfoHistory();

// Export UPersonalConnectionAPI::execRequestPledgeMemberList(FFrame&, void* const)
native static function RequestPledgeMemberList();

// Export UPersonalConnectionAPI::execGetFriendServerID(FFrame&, void* const)
native static function int GetFriendServerID(string Name);

// Export UPersonalConnectionAPI::execRequestFriendChat(FFrame&, void* const)
native static function RequestFriendChat(string Name);

// Export UPersonalConnectionAPI::execRequestMenteeAdd(FFrame&, void* const)
native static function RequestMenteeAdd(string MenteeName);

// Export UPersonalConnectionAPI::execConfirmMenteeAdd(FFrame&, void* const)
native static function ConfirmMenteeAdd(string MentorName, int Ok);

// Export UPersonalConnectionAPI::execRequestMentorList(FFrame&, void* const)
native static function RequestMentorList();

// Export UPersonalConnectionAPI::execRequestMentorCancel(FFrame&, void* const)
native static function RequestMentorCancel(int ImMentor, string TargetName);

// Export UPersonalConnectionAPI::execRequestPvpbookList(FFrame&, void* const)
native static function RequestPvpbookList();

// Export UPersonalConnectionAPI::execRequestPvpbookKillerLocation(FFrame&, void* const)
native static function RequestPvpbookKillerLocation(string KillerName);

// Export UPersonalConnectionAPI::execRequestPvpbookTeleportToKiller(FFrame&, void* const)
native static function RequestPvpbookTeleportToKiller(string KillerName);

// Export UPersonalConnectionAPI::execGetPvpbookRequiredItem(FFrame&, void* const)
native static function GetPvpbookRequiredItem(string ActionType, int Sequence, out int ItemClassID, out INT64 ItemAmount);

// Export UPersonalConnectionAPI::execGetPvpbookMaxCount(FFrame&, void* const)
native static function int GetPvpbookMaxCount(string ActionType);

defaultproperties
{
}
