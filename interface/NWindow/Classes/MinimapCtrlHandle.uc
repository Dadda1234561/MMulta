//================================================================================
// MinimapCtrlHandle.
//================================================================================

class MinimapCtrlHandle extends WindowHandle
	native;

// Export UMinimapCtrlHandle::execAdjustMapView(FFrame&, void* const)
native final function AdjustMapView(Vector Loc, optional bool a_ZoomToTownMap, optional bool a_UseGridLocation);

// Export UMinimapCtrlHandle::execAddTarget(FFrame&, void* const)
native final function AddTarget(Vector a_Loc);

// Export UMinimapCtrlHandle::execDeleteTarget(FFrame&, void* const)
native final function DeleteTarget(Vector a_Loc);

// Export UMinimapCtrlHandle::execDeleteAllTarget(FFrame&, void* const)
native final function DeleteAllTarget();

// Export UMinimapCtrlHandle::execSetShowQuest(FFrame&, void* const)
native final function SetShowQuest(bool a_ShowQuest);

// Export UMinimapCtrlHandle::execSetSSQStatus(FFrame&, void* const)
native final function SetSSQStatus(int a_SSQStatus);

// Export UMinimapCtrlHandle::execDrawGridIcon(FFrame&, void* const)
native final function DrawGridIcon(string a_IconName, Vector a_Loc, bool a_Refresh, int a_IconWidth, int a_IconHeight, optional int a_XOffset, optional int a_YOffset, optional string ToolTipString);

// Export UMinimapCtrlHandle::execRequestReduceBtn(FFrame&, void* const)
native final function RequestReduceBtn();

// Export UMinimapCtrlHandle::execIsOverlapped(FFrame&, void* const)
native final function bool IsOverlapped(int FirstX, int FirstY, int SecondX, int SecondY);

// Export UMinimapCtrlHandle::execDeleteAllCursedWeaponIcon(FFrame&, void* const)
native final function DeleteAllCursedWeaponIcon();

// Export UMinimapCtrlHandle::execAddRegionInfo(FFrame&, void* const)
native final function AddRegionInfo(string RegionInfo);

// Export UMinimapCtrlHandle::execUpdateRegionInfo(FFrame&, void* const)
native final function UpdateRegionInfo(int idx, string RegionInfo);

// Export UMinimapCtrlHandle::execEraseAllRegionInfo(FFrame&, void* const)
native final function EraseAllRegionInfo();

// Export UMinimapCtrlHandle::execEraseRegionInfo(FFrame&, void* const)
native final function EraseRegionInfo(int Index);

// Export UMinimapCtrlHandle::execSetContinent(FFrame&, void* const)
native final function SetContinent(int Continent);

// Export UMinimapCtrlHandle::execGetContinent(FFrame&, void* const)
native final function int GetContinent(Vector worldLoc);

// Export UMinimapCtrlHandle::execGetPlayerContinent(FFrame&, void* const)
native final function int GetPlayerContinent();

// Export UMinimapCtrlHandle::execRegisterQuestIcon(FFrame&, void* const)
native final function RegisterQuestIcon(int QuestID, int worldX, int worldY, int worldZ, string typeName);

// Export UMinimapCtrlHandle::execEraseQuestIcon(FFrame&, void* const)
native final function EraseQuestIcon(int QuestID);

// Export UMinimapCtrlHandle::execSetDrawTeleportPath(FFrame&, void* const)
native static function SetDrawTeleportPath(bool bDraw);

// Export UMinimapCtrlHandle::execSetDirIconDest(FFrame&, void* const)
native static function SetDirIconDest(UIEventManager.EMinimapTargetIcon Index, Vector DestLoc, string ToolTip);

// Export UMinimapCtrlHandle::execDisableDirIcon(FFrame&, void* const)
native static function DisableDirIcon(UIEventManager.EMinimapTargetIcon Index);

// Export UMinimapCtrlHandle::execAddRegionInfoCtrl(FFrame&, void* const)
native final function AddRegionInfoCtrl(MinimapRegionInfo RegionInfo);

// Export UMinimapCtrlHandle::execUpdateRegionInfoCtrl(FFrame&, void* const)
native final function UpdateRegionInfoCtrl(MinimapRegionInfo RegionInfo);

// Export UMinimapCtrlHandle::execEraseRegionInfoCtrl(FFrame&, void* const)
native final function EraseRegionInfoCtrl(UIEventManager.EMinimapRegionType eType, int nIndex);

// Export UMinimapCtrlHandle::execEraseRegionInfoByType(FFrame&, void* const)
native final function EraseRegionInfoByType(UIEventManager.EMinimapRegionType eType);

// Export UMinimapCtrlHandle::execSetShowRegionInfoByType(FFrame&, void* const)
native final function SetShowRegionInfoByType(UIEventManager.EMinimapRegionType eType, bool bShow);

defaultproperties
{
}
