//================================================================================
// ActionAPI.
//================================================================================

class ActionAPI extends UIEventManager
	native;

// Export UActionAPI::execRequestActionList(FFrame&, void* const)
native static function RequestActionList();

// Export UActionAPI::execRequestPetActionList(FFrame&, void* const)
native static function RequestPetActionList();

// Export UActionAPI::execRequestSummonedCommonActionList(FFrame&, void* const)
native static function RequestSummonedCommonActionList(int ServerID);

// Export UActionAPI::execRequestSummonedAllSkillActionList(FFrame&, void* const)
native static function RequestSummonedAllSkillActionList();

// Export UActionAPI::execGetActionNameBySocialIndex(FFrame&, void* const)
native static function GetActionNameBySocialIndex(int socialIndex, string retString);

// Export UActionAPI::execGetActionAutomaticUseType(FFrame&, void* const)
native static function int GetActionAutomaticUseType(int nActionClassID);

// Export UActionAPI::execGetActionUIData(FFrame&, void* const)
native static function bool GetActionUIData(int nActionID, out ActionUIData UIData);

defaultproperties
{
}
