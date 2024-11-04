//================================================================================
// SiegeAPI.
//================================================================================

class SiegeAPI extends Object
	native
	export;

// Export USiegeAPI::execRequestCastleSiegeAttackerList(FFrame&, void* const)
native static function RequestCastleSiegeAttackerList(int castleID);

// Export USiegeAPI::execRequestCastleSiegeDefenderList(FFrame&, void* const)
native static function RequestCastleSiegeDefenderList(int castleID);

// Export USiegeAPI::execRequestJoinCastleSiege(FFrame&, void* const)
native static function RequestJoinCastleSiege(int castleID, int IsAttacker, int IsRegister);

// Export USiegeAPI::execRequestConfirmCastleSiegeWaitingList(FFrame&, void* const)
native static function RequestConfirmCastleSiegeWaitingList(int castleID, int clanID, int IsRegister);

// Export USiegeAPI::execRequestSetCastleSiegeTime(FFrame&, void* const)
native static function RequestSetCastleSiegeTime(int castleID, int TimeID);

// Export USiegeAPI::execRequestMCWCastleInfo(FFrame&, void* const)
native static function RequestMCWCastleInfo(int castleID);

// Export USiegeAPI::execRequestMCWCastleSiegeInfo(FFrame&, void* const)
native static function RequestMCWCastleSiegeInfo(int castleID);

// Export USiegeAPI::execRequestMCWCastleSiegeAttackerList(FFrame&, void* const)
native static function RequestMCWCastleSiegeAttackerList(int castleID);

// Export USiegeAPI::execRequestMCWCastleSiegeDefenderList(FFrame&, void* const)
native static function RequestMCWCastleSiegeDefenderList(int castleID);

// Export USiegeAPI::execRequestPledgeMercenaryMemberList(FFrame&, void* const)
native static function RequestPledgeMercenaryMemberList(int castleID, int PledgeID);

// Export USiegeAPI::execRequestPledgeMercenaryRecruitInfoSet(FFrame&, void* const)
native static function RequestPledgeMercenaryRecruitInfoSet(int castleID, int Type, int IsMercenaryRecruit, INT64 MercenaryReward);

// Export USiegeAPI::execRequestPledgeMercenaryMemberJoin(FFrame&, void* const)
native static function RequestPledgeMercenaryMemberJoin(int castleID, int Type, int UserID, int PledgeID);

defaultproperties
{
}
