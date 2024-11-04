//================================================================================
// TeamMatchAPI.
//================================================================================

class TeamMatchAPI extends UIEventManager
	native;

// Export UTeamMatchAPI::execRequestCleftAllData(FFrame&, void* const)
native static function RequestCleftAllData();

// Export UTeamMatchAPI::execRequestExCleftEnter(FFrame&, void* const)
native static function RequestExCleftEnter(int a_TeamID);

// Export UTeamMatchAPI::execRequestBlockGameAllData(FFrame&, void* const)
native static function RequestBlockGameAllData();

// Export UTeamMatchAPI::execRequestExBlockGameEnter(FFrame&, void* const)
native static function RequestExBlockGameEnter(int a_Stage, int a_TeamID);

// Export UTeamMatchAPI::execRequestExBlockGameVote(FFrame&, void* const)
native static function RequestExBlockGameVote(int a_Stage, int a_Start);

defaultproperties
{
}
