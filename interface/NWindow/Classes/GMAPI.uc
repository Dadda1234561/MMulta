//================================================================================
// GMAPI.
//================================================================================

class GMAPI extends UIEventManager
	native;

// Export UGMAPI::execBeginGMChangeServer(FFrame&, void* const)
native static function BeginGMChangeServer(int a_ServerID, Vector a_PlayerLocation);

// Export UGMAPI::execRequestGMCommand(FFrame&, void* const)
native static function RequestGMCommand(UIEventManager.EGMCommandType a_GMCommandType, optional string a_Param);

// Export UGMAPI::execGetObservingUserInfo(FFrame&, void* const)
native static function bool GetObservingUserInfo(out UserInfo a_ObservingUserInfo);

// Export UGMAPI::execRequestSnoopEnd(FFrame&, void* const)
native static function RequestSnoopEnd(int a_SnoopID);

defaultproperties
{
}
