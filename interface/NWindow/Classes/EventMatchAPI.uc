//================================================================================
// EventMatchAPI.
//================================================================================

class EventMatchAPI extends UIEventManager
	native;

// Export UEventMatchAPI::execGetEventMatchData(FFrame&, void* const)
native static function bool GetEventMatchData(out EventMatchData a_EventMatchData);

// Export UEventMatchAPI::execGetScore(FFrame&, void* const)
native static function int GetScore(int a_TeamID);

// Export UEventMatchAPI::execGetTeamName(FFrame&, void* const)
native static function string GetTeamName(int a_TeamID);

// Export UEventMatchAPI::execGetPartyMemberCount(FFrame&, void* const)
native static function int GetPartyMemberCount(int a_TeamID);

// Export UEventMatchAPI::execGetUserData(FFrame&, void* const)
native static function bool GetUserData(int a_TeamID, int a_UserID, out EventMatchUserData a_UserData);

// Export UEventMatchAPI::execSetSelectedUser(FFrame&, void* const)
native static function SetSelectedUser(int a_TeamID, int a_UserID);

// Export UEventMatchAPI::execRequestEventMatchObserverEnd(FFrame&, void* const)
native static function RequestEventMatchObserverEnd(int MatchID);

defaultproperties
{
}
