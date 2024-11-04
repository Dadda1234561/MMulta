//================================================================================
// MacroAPI.
//================================================================================

class MacroAPI extends UIEventManager
	native;

cpptext
{
	EMacroErrorType CheckMacroCommand(TArray<FString> &CommandList);
	VOID SaveMacroFromCommandList(L2ParamStack* param, TArray<FString> &CommandList);
}

enum EMacroErrorType {
	MERR_NONE,
	MERR_INVALID,
	MERR_LIMIT_WORLDCHAT
};

// Export UMacroAPI::execRequestMacroList(FFrame&, void* const)
native static function RequestMacroList();

// Export UMacroAPI::execRequestUseMacro(FFrame&, void* const)
native static function RequestUseMacro(ItemID cID);

// Export UMacroAPI::execRequestDeleteMacro(FFrame&, void* const)
native static function RequestDeleteMacro(ItemID cID);

// Export UMacroAPI::execRequestMakeMacro(FFrame&, void* const)
native static function bool RequestMakeMacro(ItemID cID, string Name, string IconName, int IconNum, int IconSkillId, string Description, array<string> CommandList);

defaultproperties
{
}
