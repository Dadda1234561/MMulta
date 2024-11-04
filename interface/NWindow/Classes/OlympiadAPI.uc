//================================================================================
// OlympiadAPI.
//================================================================================

class OlympiadAPI extends Object
	native
	export;

// Export UOlympiadAPI::execRequestOlympiadObserverEnd(FFrame&, void* const)
native static function RequestOlympiadObserverEnd();

// Export UOlympiadAPI::execRequestOlympiadMatchList(FFrame&, void* const)
native static function RequestOlympiadMatchList();

// Export UOlympiadAPI::execRequestExOlympiadWatchGame(FFrame&, void* const)
native static function RequestExOlympiadWatchGame(int FieldId);

// Export UOlympiadAPI::execRequestExOlympiadMatchMaking(FFrame&, void* const)
native static function RequestExOlympiadMatchMaking();

// Export UOlympiadAPI::execRequestExOlympiadMatchMakingCancel(FFrame&, void* const)
native static function RequestExOlympiadMatchMakingCancel();

defaultproperties
{
}
