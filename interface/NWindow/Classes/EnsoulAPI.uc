//================================================================================
// EnsoulAPI.
//================================================================================

class EnsoulAPI extends UIEventManager
	native;

// Export UEnsoulAPI::execRequestItemEnsoul(FFrame&, void* const)
native static function RequestItemEnsoul(string strParam);

// Export UEnsoulAPI::execRequestItemExtraction(FFrame&, void* const)
native static function RequestItemExtraction(string strParam);

defaultproperties
{
}
