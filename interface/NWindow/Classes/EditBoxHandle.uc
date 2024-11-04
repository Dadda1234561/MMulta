//================================================================================
// EditBoxHandle.
//================================================================================

class EditBoxHandle extends WindowHandle
	native;

// Export UEditBoxHandle::execGetString(FFrame&, void* const)
native final function string GetString();

// Export UEditBoxHandle::execSetString(FFrame&, void* const)
native final function SetString(string Str);

// Export UEditBoxHandle::execAddString(FFrame&, void* const)
native final function AddString(string Str);

// Export UEditBoxHandle::execSimulateBackspace(FFrame&, void* const)
native final function SimulateBackspace();

// Export UEditBoxHandle::execClear(FFrame&, void* const)
native final function Clear();

// Export UEditBoxHandle::execSetEditType(FFrame&, void* const)
native final function SetEditType(string Type);

// Export UEditBoxHandle::execSetHighLight(FFrame&, void* const)
native final function SetHighLight(bool bHighlight);

// Export UEditBoxHandle::execSetMaxLength(FFrame&, void* const)
native final function SetMaxLength(int MaxLength);

// Export UEditBoxHandle::execGetMaxLength(FFrame&, void* const)
native final function int GetMaxLength();

// Export UEditBoxHandle::execSetEnableTextLink(FFrame&, void* const)
native final function SetEnableTextLink(bool bEnable);

// Export UEditBoxHandle::execClearHistory(FFrame&, void* const)
native final function ClearHistory();

// Export UEditBoxHandle::execAllSelect(FFrame&, void* const)
native final function AllSelect();

// Export UEditBoxHandle::execAddNameToAdditionalSearchList(FFrame&, void* const)
native final function bool AddNameToAdditionalSearchList(string Name, UIEventManager.ESearchListType listType);

// Export UEditBoxHandle::execFillAdditionalSearchList(FFrame&, void* const)
native final function bool FillAdditionalSearchList(out array<string> stringArr, UIEventManager.ESearchListType listType);

// Export UEditBoxHandle::execClearAdditionalSearchList(FFrame&, void* const)
native final function bool ClearAdditionalSearchList(UIEventManager.ESearchListType listType);

// Export UEditBoxHandle::execDeleteNameFromAdditionalSearchList(FFrame&, void* const)
native final function bool DeleteNameFromAdditionalSearchList(string Name, UIEventManager.ESearchListType listType);

// Export UEditBoxHandle::execAddItemToAutoCompleteHistory(FFrame&, void* const)
native final function bool AddItemToAutoCompleteHistory(string Name);

// Export UEditBoxHandle::execSetDownList(FFrame&, void* const)
native final function SetDownList(bool bDownList);

// Export UEditBoxHandle::execIsShowCandidateBox(FFrame&, void* const)
native final function bool IsShowCandidateBox();

// Export UEditBoxHandle::execDeleteClipBoard(FFrame&, void* const)
native final function bool DeleteClipBoard();

// Export UEditBoxHandle::execSetFocusedBackTexture(FFrame&, void* const)
native final function SetFocusedBackTexture(string Texture1, string Texture2, string Texture3);

// Export UEditBoxHandle::execSetUnFocusedBackTexture(FFrame&, void* const)
native final function SetUnFocusedBackTexture(string Texture1, string Texture2, string Texture3);

// Export UEditBoxHandle::execIsEmpty(FFrame&, void* const)
native final function bool IsEmpty();

// Export UEditBoxHandle::execAddEmojiIcon(FFrame&, void* const)
native final function bool AddEmojiIcon(int IconID);

// Export UEditBoxHandle::execSetFormatString(FFrame&, void* const)
native final function bool SetFormatString(string formatString);

// Export UEditBoxHandle::execGetFormatString(FFrame&, void* const)
native final function string GetFormatString();

// Export UEditBoxHandle::execSetAlign(FFrame&, void* const)
native final function SetAlign(UIEventManager.ETextAlign Align);

// Export UEditBoxHandle::execSetVAlign(FFrame&, void* const)
native final function SetVAlign(UIEventManager.ETextVAlign VAlign);

// Export UEditBoxHandle::execSetAsChatEditBox(FFrame&, void* const)
native final function SetAsChatEditBox();

// Export UEditBoxHandle::execSetIME(FFrame&, void* const)
native final function SetIME();

defaultproperties
{
}
