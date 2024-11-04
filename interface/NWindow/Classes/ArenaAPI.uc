//================================================================================
// ArenaAPI.
//================================================================================

class ArenaAPI extends Object
	native
	export;

// Export UArenaAPI::execRequestMatchGroup(FFrame&, void* const)
native static function RequestMatchGroup();

// Export UArenaAPI::execRequestMatchGroupAsk(FFrame&, void* const)
native static function RequestMatchGroupAsk(string TargetUserName);

// Export UArenaAPI::execRequestMatchGroupAnswer(FFrame&, void* const)
native static function RequestMatchGroupAnswer(bool Result);

// Export UArenaAPI::execRequestMatchGroupWithdraw(FFrame&, void* const)
native static function RequestMatchGroupWithdraw();

// Export UArenaAPI::execRequestMatchGroupOust(FFrame&, void* const)
native static function RequestMatchGroupOust(string TargetUserName);

// Export UArenaAPI::execRequestMatchGroupChangeMaster(FFrame&, void* const)
native static function RequestMatchGroupChangeMaster(string TargetUserName);

defaultproperties
{
}
