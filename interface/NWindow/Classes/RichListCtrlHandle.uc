//================================================================================
// RichListCtrlHandle.
//================================================================================

class RichListCtrlHandle extends WindowHandle
	native;

// Export URichListCtrlHandle::execInsertRecord(FFrame&, void* const)
native final function InsertRecord(RichListCtrlRowData Record);

// Export URichListCtrlHandle::execDeleteAllItem(FFrame&, void* const)
native final function DeleteAllItem();

// Export URichListCtrlHandle::execDeleteRecord(FFrame&, void* const)
native final function DeleteRecord(int Index);

// Export URichListCtrlHandle::execGetRecordCount(FFrame&, void* const)
native final function int GetRecordCount();

// Export URichListCtrlHandle::execGetSelectedIndex(FFrame&, void* const)
native final function int GetSelectedIndex();

// Export URichListCtrlHandle::execSetSelectedIndex(FFrame&, void* const)
native final function SetSelectedIndex(int Index, bool bMoveToRow);

// Export URichListCtrlHandle::execShowScrollBar(FFrame&, void* const)
native final function ShowScrollBar(bool bShow);

// Export URichListCtrlHandle::execModifyRecord(FFrame&, void* const)
native final function bool ModifyRecord(int Index, RichListCtrlRowData Record);

// Export URichListCtrlHandle::execGetSelectedRec(FFrame&, void* const)
native final function GetSelectedRec(out RichListCtrlRowData Record);

// Export URichListCtrlHandle::execGetRec(FFrame&, void* const)
native final function GetRec(int Index, out RichListCtrlRowData Record);

// Export URichListCtrlHandle::execInitListCtrl(FFrame&, void* const)
native final function InitListCtrl();

// Export URichListCtrlHandle::execAdjustColumnWidth(FFrame&, void* const)
native final function AdjustColumnWidth(int Col);

// Export URichListCtrlHandle::execSetHeaderAlignment(FFrame&, void* const)
native final function SetHeaderAlignment(int Col, UIEventManager.ETextAlign Align);

// Export URichListCtrlHandle::execSetHeaderTextOffset(FFrame&, void* const)
native final function SetHeaderTextOffset(int Col, int offset);

// Export URichListCtrlHandle::execSetResizable(FFrame&, void* const)
native final function SetResizable(bool B);

// Export URichListCtrlHandle::execSetColumnWidth(FFrame&, void* const)
native final function SetColumnWidth(int Index, int Width);

// Export URichListCtrlHandle::execEnablePageBrowser(FFrame&, void* const)
native final function EnablePageBrowser(bool Enable);

// Export URichListCtrlHandle::execSetContentsHeight(FFrame&, void* const)
native final function SetContentsHeight(int Height);

// Export URichListCtrlHandle::execSetSelectedSelTooltip(FFrame&, void* const)
native final function SetSelectedSelTooltip(bool bFlag);

// Export URichListCtrlHandle::execSetAppearTooltipAtMouseX(FFrame&, void* const)
native final function SetAppearTooltipAtMouseX(bool bFlag);

// Export URichListCtrlHandle::execSetColumnString(FFrame&, void* const)
native final function SetColumnString(int Index, int StrIndex);

// Export URichListCtrlHandle::execSetColumnMinimumWidth(FFrame&, void* const)
native final function SetColumnMinimumWidth(bool bFlag);

// Export URichListCtrlHandle::execSetUseHorizontalScrollBar(FFrame&, void* const)
native final function SetUseHorizontalScrollBar(bool bFlag);

// Export URichListCtrlHandle::execSetStatusBarTexture(FFrame&, void* const)
native final function SetStatusBarTexture(string ForeLeftTex, string ForeCenterTex, string ForeRightTex, string BackLeftTex, string BackCenterTex, string BackRightTex);

// Export URichListCtrlHandle::execSetUseStripeBackTexture(FFrame&, void* const)
native final function SetUseStripeBackTexture(bool bUseStripeBackTexture);

// Export URichListCtrlHandle::execSetSelectable(FFrame&, void* const)
native final function SetSelectable(bool bSelectable);

// Export URichListCtrlHandle::execSetStartRow(FFrame&, void* const)
native final function SetStartRow(int StartRow);

// Export URichListCtrlHandle::execSetEnableItemRecordDrag(FFrame&, void* const)
native final function SetEnableItemRecordDrag(bool bEnableDrag);

// Export URichListCtrlHandle::execGetShowRow(FFrame&, void* const)
native final function int GetShowRow();

// Export URichListCtrlHandle::execSetSortable(FFrame&, void* const)
native final function SetSortable(bool bSortable);

// Export URichListCtrlHandle::execShowSortIcon(FFrame&, void* const)
native final function ShowSortIcon(int HeaderIndex);

// Export URichListCtrlHandle::execHideSortIcon(FFrame&, void* const)
native final function HideSortIcon();

// Export URichListCtrlHandle::execSetAscend(FFrame&, void* const)
native final function SetAscend(int HeaderIndex, bool bAscend);

// Export URichListCtrlHandle::execIsAscending(FFrame&, void* const)
native final function bool IsAscending(int HeaderIndex);

// Export URichListCtrlHandle::execAdjustShowRow(FFrame&, void* const)
native final function AdjustShowRow(int ShowRow);

// Export URichListCtrlHandle::execIncreaseStartRow(FFrame&, void* const)
native final function IncreaseStartRow(int Cnt);

// Export URichListCtrlHandle::execDecreaseStartRow(FFrame&, void* const)
native final function DecreaseStartRow(int Cnt);

// Export URichListCtrlHandle::execGetStartRow(FFrame&, void* const)
native final function int GetStartRow();

// Export URichListCtrlHandle::execSetEnableInteractionPass(FFrame&, void* const)
native final function SetEnableInteractionPass(bool bEnablePass);

// Export URichListCtrlHandle::execGetPointedRec(FFrame&, void* const)
native final function GetPointedRec(out RichListCtrlRowData Record);

defaultproperties
{
}
