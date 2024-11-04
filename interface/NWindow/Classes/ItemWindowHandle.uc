//================================================================================
// ItemWindowHandle.
//================================================================================

class ItemWindowHandle extends WindowHandle
	native;

// Export UItemWindowHandle::execGetSelectedNum(FFrame&, void* const)
native final function int GetSelectedNum();

// Export UItemWindowHandle::execGetItemNum(FFrame&, void* const)
native final function int GetItemNum();

// Export UItemWindowHandle::execClearSelect(FFrame&, void* const)
native final function ClearSelect();

// Export UItemWindowHandle::execAddItem(FFrame&, void* const)
native final function AddItem(ItemInfo Info);

// Export UItemWindowHandle::execAddItemWithFaded(FFrame&, void* const)
native final function AddItemWithFaded(ItemInfo Info);

// Export UItemWindowHandle::execSetItem(FFrame&, void* const)
native final function bool SetItem(int Index, ItemInfo Info);

// Export UItemWindowHandle::execDeleteItem(FFrame&, void* const)
native final function DeleteItem(int Index);

// Export UItemWindowHandle::execGetSelectedItem(FFrame&, void* const)
native final function bool GetSelectedItem(out ItemInfo Info);

// Export UItemWindowHandle::execGetItem(FFrame&, void* const)
native final function bool GetItem(int Index, out ItemInfo Info);

// Export UItemWindowHandle::execGetItemIdLevel(FFrame&, void* const)
native final function GetItemIdLevel(int Index, out int Id, out int Level, out int SubLevel);

// Export UItemWindowHandle::execGetItemSkillDisabled(FFrame&, void* const)
native final function int GetItemSkillDisabled(int Index);

// Export UItemWindowHandle::execSetItemSkillDisabled(FFrame&, void* const)
native final function SetItemSkillDisabled(int Index, int SkillDisabled);

// Export UItemWindowHandle::execSetBlessPanelDrawType(FFrame&, void* const)
native final function SetBlessPanelDrawType(int Index, UIEventManager.EBlessPanelDrawType Type);

// Export UItemWindowHandle::execClear(FFrame&, void* const)
native final function Clear();

// Export UItemWindowHandle::execFindItem(FFrame&, void* const)
native final function int FindItem(ItemID scID);

// Export UItemWindowHandle::execFindItemWithAllProperty(FFrame&, void* const)
native final function int FindItemWithAllProperty(ItemInfo Info);

// Export UItemWindowHandle::execFindItemWithReserved(FFrame&, void* const)
native final function int FindItemWithReserved(int Reserved);

// Export UItemWindowHandle::execSetFaded(FFrame&, void* const)
native final function SetFaded(bool bOn);

// Export UItemWindowHandle::execShowScrollBar(FFrame&, void* const)
native final function ShowScrollBar(bool bShow);

// Export UItemWindowHandle::execSwapItems(FFrame&, void* const)
native final function SwapItems(int index1, int index2);

// Export UItemWindowHandle::execGetIndexAt(FFrame&, void* const)
native final function int GetIndexAt(int X, int Y, int OffsetX, int OffsetY);

// Export UItemWindowHandle::execSetDisableTex(FFrame&, void* const)
native final function SetDisableTex(string a_DisableTex);

// Export UItemWindowHandle::execSetRow(FFrame&, void* const)
native final function SetRow(int a_Row);

// Export UItemWindowHandle::execSetCol(FFrame&, void* const)
native final function SetCol(int a_Col);

// Export UItemWindowHandle::execSetExpandItemNum(FFrame&, void* const)
native final function SetExpandItemNum(int Index, int Num);

// Export UItemWindowHandle::execSetItemUsability(FFrame&, void* const)
native final function SetItemUsability();

// Export UItemWindowHandle::execFindItemByClassID(FFrame&, void* const)
native final function int FindItemByClassID(ItemID scID);

// Export UItemWindowHandle::execGetSideTypePageNum(FFrame&, void* const)
native final function int GetSideTypePageNum();

// Export UItemWindowHandle::execGetSideTypeCurPage(FFrame&, void* const)
native final function int GetSideTypeCurPage();

// Export UItemWindowHandle::execPushSideTypePrevBtn(FFrame&, void* const)
native final function PushSideTypePrevBtn();

// Export UItemWindowHandle::execPushSideTypeNextBtn(FFrame&, void* const)
native final function PushSideTypeNextBtn();

// Export UItemWindowHandle::execSetSelectedNum(FFrame&, void* const)
native final function SetSelectedNum(int idx);

// Export UItemWindowHandle::execResizeScrollBar(FFrame&, void* const)
native final function ResizeScrollBar();

// Export UItemWindowHandle::execSetToggleEffect(FFrame&, void* const)
native final function SetToggleEffect(int Index, bool bToggle);

// Export UItemWindowHandle::execSetIconIndex(FFrame&, void* const)
native final function SetIconIndex(int Index, int IconIndex);

// Export UItemWindowHandle::execSetIconDrawType(FFrame&, void* const)
native final function SetIconDrawType(UIEventManager.EItemWindowIconDrawType DrawType);

// Export UItemWindowHandle::execSetNewlyAcquired(FFrame&, void* const)
native final function SetNewlyAcquired(int Index, bool bNewlyAcquired);

// Export UItemWindowHandle::execClearNewlyAcquired(FFrame&, void* const)
native final function ClearNewlyAcquired();

// Export UItemWindowHandle::execClearItemTooltip(FFrame&, void* const)
native final function ClearItemTooltip();

// Export UItemWindowHandle::execSetButtonClick(FFrame&, void* const)
native final function SetButtonClick(bool bToggle);

// Export UItemWindowHandle::execSetNoItemDrag(FFrame&, void* const)
native final function SetNoItemDrag(bool bToggle);

// Export UItemWindowHandle::execSetDualSlotBitType(FFrame&, void* const)
native final function SetDualSlotBitType(INT64 a_SlotBitType);

defaultproperties
{
}
