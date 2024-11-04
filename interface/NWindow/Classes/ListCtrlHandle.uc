//================================================================================
// ListCtrlHandle.
//================================================================================

class ListCtrlHandle extends WindowHandle
	native;

// Export UListCtrlHandle::execInsertRecord(FFrame&, void* const)
native final function InsertRecord(LVDataRecord Record);

// Export UListCtrlHandle::execDeleteAllItem(FFrame&, void* const)
native final function DeleteAllItem();

// Export UListCtrlHandle::execDeleteRecord(FFrame&, void* const)
native final function DeleteRecord(int Index);

// Export UListCtrlHandle::execGetRecordCount(FFrame&, void* const)
native final function int GetRecordCount();

// Export UListCtrlHandle::execGetSelectedIndex(FFrame&, void* const)
native final function int GetSelectedIndex();

// Export UListCtrlHandle::execSetSelectedIndex(FFrame&, void* const)
native final function SetSelectedIndex(int Index, bool bMoveToRow);

// Export UListCtrlHandle::execShowScrollBar(FFrame&, void* const)
native final function ShowScrollBar(bool bShow);

// Export UListCtrlHandle::execModifyRecord(FFrame&, void* const)
native final function bool ModifyRecord(int Index, LVDataRecord Record);

// Export UListCtrlHandle::execGetSelectedRec(FFrame&, void* const)
native final function GetSelectedRec(out LVDataRecord Record);

// Export UListCtrlHandle::execGetRec(FFrame&, void* const)
native final function GetRec(int Index, out LVDataRecord Record);

// Export UListCtrlHandle::execInitListCtrl(FFrame&, void* const)
native final function InitListCtrl();

// Export UListCtrlHandle::execAdjustColumnWidth(FFrame&, void* const)
native final function AdjustColumnWidth(int Col);

// Export UListCtrlHandle::execSetHeaderAlignment(FFrame&, void* const)
native final function SetHeaderAlignment(int Col, UIEventManager.ETextAlign Align);

// Export UListCtrlHandle::execSetHeaderTextOffset(FFrame&, void* const)
native final function SetHeaderTextOffset(int Col, int offset);

// Export UListCtrlHandle::execSetResizable(FFrame&, void* const)
native final function SetResizable(bool B);

// Export UListCtrlHandle::execSetColumnWidth(FFrame&, void* const)
native final function SetColumnWidth(int Index, int Width);

// Export UListCtrlHandle::execEnablePageBrowser(FFrame&, void* const)
native final function EnablePageBrowser(bool Enable);

// Export UListCtrlHandle::execSetSelectedSelTooltip(FFrame&, void* const)
native final function SetSelectedSelTooltip(bool bFlag);

// Export UListCtrlHandle::execSetAppearTooltipAtMouseX(FFrame&, void* const)
native final function SetAppearTooltipAtMouseX(bool bFlag);

// Export UListCtrlHandle::execSetColumnString(FFrame&, void* const)
native final function SetColumnString(int Index, int StrIndex);

// Export UListCtrlHandle::execSetColumnMinimumWidth(FFrame&, void* const)
native final function SetColumnMinimumWidth(bool bFlag);

// Export UListCtrlHandle::execSetUseHorizontalScrollBar(FFrame&, void* const)
native final function SetUseHorizontalScrollBar(bool bFlag);

// Export UListCtrlHandle::execGetShowRow(FFrame&, void* const)
native final function int GetShowRow();

// Export UListCtrlHandle::execSetSortable(FFrame&, void* const)
native final function SetSortable(bool bSortable);

// Export UListCtrlHandle::execShowSortIcon(FFrame&, void* const)
native final function ShowSortIcon(int HeaderIndex);

// Export UListCtrlHandle::execHideSortIcon(FFrame&, void* const)
native final function HideSortIcon();

// Export UListCtrlHandle::execSetAscend(FFrame&, void* const)
native final function SetAscend(int HeaderIndex, bool bAscend);

// Export UListCtrlHandle::execIsAscending(FFrame&, void* const)
native final function bool IsAscending(int HeaderIndex);

defaultproperties
{
}
