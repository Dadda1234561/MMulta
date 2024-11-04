//================================================================================
// PropertyControllerHandle.
//================================================================================

class PropertyControllerHandle extends WindowHandle
	native;

// Export UPropertyControllerHandle::execSetProperty(FFrame&, void* const)
native final function SetProperty(UIEventManager.EXMLControlType a_Type, WindowHandle a_WindowHandle);

// Export UPropertyControllerHandle::execClear(FFrame&, void* const)
native final function Clear();

// Export UPropertyControllerHandle::execClearValue(FFrame&, void* const)
native final function ClearValue();

// Export UPropertyControllerHandle::execGetPropertyHeight(FFrame&, void* const)
native final function int GetPropertyHeight();

// Export UPropertyControllerHandle::execUpdatePropertyGroup(FFrame&, void* const)
native final function UpdatePropertyGroup(string GroupName);

// Export UPropertyControllerHandle::execGetGroupType(FFrame&, void* const)
native final function UIEventManager.EControlPropertyGroupType GetGroupType(string GroupName);

// Export UPropertyControllerHandle::execSetGroupCheck(FFrame&, void* const)
native final function SetGroupCheck(string GroupName, bool Value);

// Export UPropertyControllerHandle::execGetGroupCheck(FFrame&, void* const)
native final function bool GetGroupCheck(string GroupName);

// Export UPropertyControllerHandle::execDeleteGroup(FFrame&, void* const)
native final function DeleteGroup(string GroupName);

// Export UPropertyControllerHandle::execAddGroup(FFrame&, void* const)
native final function string AddGroup();

// Export UPropertyControllerHandle::execSetGroupExpandState(FFrame&, void* const)
native final function SetGroupExpandState(string GroupName, bool bExpand);

// Export UPropertyControllerHandle::execSetGroupVisible(FFrame&, void* const)
native final function SetGroupVisible(string GroupName, bool bShow);

// Export UPropertyControllerHandle::execGetItemType(FFrame&, void* const)
native final function UIEventManager.EControlPropertyItemType GetItemType(string ItemName);

// Export UPropertyControllerHandle::execSetItemBooleanValue(FFrame&, void* const)
native final function SetItemBooleanValue(string ItemName, bool Value);

// Export UPropertyControllerHandle::execSetItemIntegerValue(FFrame&, void* const)
native final function SetItemIntegerValue(string ItemName, int Value);

// Export UPropertyControllerHandle::execSetItemStringValue(FFrame&, void* const)
native final function SetItemStringValue(string ItemName, string Value);

// Export UPropertyControllerHandle::execGetItemBooleanValue(FFrame&, void* const)
native final function bool GetItemBooleanValue(string ItemName);

// Export UPropertyControllerHandle::execGetItemIntegerValue(FFrame&, void* const)
native final function int GetItemIntegerValue(string ItemName);

// Export UPropertyControllerHandle::execGetItemStringValue(FFrame&, void* const)
native final function string GetItemStringValue(string ItemName);

defaultproperties
{
}
