//================================================================================
// UIAPI_MINIMAPCTRL.
//================================================================================

class UIAPI_MINIMAPCTRL extends UIAPI_WINDOW
	native;

// Export UUIAPI_MINIMAPCTRL::execAdjustMapView(FFrame&, void* const)
native static function AdjustMapView(string a_ControlID, Vector Loc, optional bool a_ZoomToTownMap, optional bool a_UseGridLocation);

// Export UUIAPI_MINIMAPCTRL::execAddTarget(FFrame&, void* const)
native static function AddTarget(string a_ControlID, Vector a_Loc);

// Export UUIAPI_MINIMAPCTRL::execDeleteTarget(FFrame&, void* const)
native static function DeleteTarget(string a_ControlID, Vector a_Loc);

// Export UUIAPI_MINIMAPCTRL::execDeleteAllTarget(FFrame&, void* const)
native static function DeleteAllTarget(string a_ControlID);

// Export UUIAPI_MINIMAPCTRL::execSetShowQuest(FFrame&, void* const)
native static function SetShowQuest(string a_ControlID, bool a_ShowQuest);

// Export UUIAPI_MINIMAPCTRL::execSetDailyQuest(FFrame&, void* const)
native static function SetDailyQuest(string a_ControlID, bool a_ShowRange, int a_DailyQuestIndex);

// Export UUIAPI_MINIMAPCTRL::execSetSSQStatus(FFrame&, void* const)
native static function SetSSQStatus(string a_ControlID, int a_SSQStatus);

// Export UUIAPI_MINIMAPCTRL::execDrawGridIcon(FFrame&, void* const)
native static function DrawGridIcon(string a_ControlID, string a_IconName, Vector a_Loc, bool a_Refresh, int a_IconWidth, int a_IconHeight, optional int a_XOffset, optional int a_YOffset, optional string ToolTipString);

// Export UUIAPI_MINIMAPCTRL::execRequestReduceBtn(FFrame&, void* const)
native static function RequestReduceBtn(string a_ControlID);

// Export UUIAPI_MINIMAPCTRL::execIsOverlapped(FFrame&, void* const)
native static function bool IsOverlapped(string a_ControlID, int FirstX, int FirstY, int SecondX, int SecondY);

// Export UUIAPI_MINIMAPCTRL::execDeleteAllCursedWeaponIcon(FFrame&, void* const)
native static function DeleteAllCursedWeaponIcon(string a_ControlID);

// Export UUIAPI_MINIMAPCTRL::execShowCertainLayer(FFrame&, void* const)
native static function ShowCertainLayer(string a_ControlID, int LayerNumber);

// Export UUIAPI_MINIMAPCTRL::execResetMinimapData(FFrame&, void* const)
native static function ResetMinimapData(string a_ControlID);

defaultproperties
{
}
