//================================================================================
// UnionActionAPI.
//================================================================================

class UnionActionAPI extends UIEventManager
	native;

// Export UUnionActionAPI::execRequestUnionJoin(FFrame&, void* const)
native static function RequestUnionJoin(int unionID);

// Export UUnionActionAPI::execRequestUnionChange(FFrame&, void* const)
native static function RequestUnionChange(int unionID);

// Export UUnionActionAPI::execRequestUnionWithdraw(FFrame&, void* const)
native static function RequestUnionWithdraw();

// Export UUnionActionAPI::execRequestUnionRequest(FFrame&, void* const)
native static function RequestUnionRequest(int requestType);

// Export UUnionActionAPI::execRequestUnionAdjust(FFrame&, void* const)
native static function RequestUnionAdjust();

// Export UUnionActionAPI::execRequestUnionSummon(FFrame&, void* const)
native static function RequestUnionSummon(int NpcType);

// Export UUnionActionAPI::execRequestUnionStart(FFrame&, void* const)
native static function RequestUnionStart(int NpcType);

defaultproperties
{
}
