//================================================================================
// CommandChannelAPI.
//================================================================================

class CommandChannelAPI extends Object
	native
	export;

// Export UCommandChannelAPI::execRequestCommandChannelInfo(FFrame&, void* const)
native static function RequestCommandChannelInfo();

// Export UCommandChannelAPI::execRequestCommandChannelBanParty(FFrame&, void* const)
native static function RequestCommandChannelBanParty(string PartyMasterName);

// Export UCommandChannelAPI::execRequestCommandChannelWithdraw(FFrame&, void* const)
native static function RequestCommandChannelWithdraw();

// Export UCommandChannelAPI::execRequestCommandChannelPartyMembersInfo(FFrame&, void* const)
native static function RequestCommandChannelPartyMembersInfo(int MasterID);

defaultproperties
{
}
