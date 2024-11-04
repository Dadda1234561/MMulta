//================================================================================
// TabHandle.
//================================================================================

class TabHandle extends WindowHandle
	native;

// Export UTabHandle::execInitTabCtrl(FFrame&, void* const)
native final function InitTabCtrl();

// Export UTabHandle::execSetTopOrder(FFrame&, void* const)
native final function SetTopOrder(int Index, bool bSendMessage);

// Export UTabHandle::execGetTopIndex(FFrame&, void* const)
native final function int GetTopIndex();

// Export UTabHandle::execSetDisable(FFrame&, void* const)
native final function SetDisable(int Index, bool bDisable);

// Export UTabHandle::execMergeTab(FFrame&, void* const)
native final function MergeTab(int Index);

// Export UTabHandle::execSetButtonName(FFrame&, void* const)
native final function SetButtonName(int Index, string NewName);

// Export UTabHandle::execSetButtonSizeTex(FFrame&, void* const)
native final function SetButtonSizeTex(int Index, float Width, float Height);

// Export UTabHandle::execSetButtonOffsetTex(FFrame&, void* const)
native final function SetButtonOffsetTex(int Index, string NewTex, int OffsetX, int OffsetY);

// Export UTabHandle::execSetButtonBlink(FFrame&, void* const)
native final function SetButtonBlink(int Index, bool Enable);

// Export UTabHandle::execSetButtonDisableTexture(FFrame&, void* const)
native final function SetButtonDisableTexture(int Index, string TextureName);

// Export UTabHandle::execRemoveTabControl(FFrame&, void* const)
native final function RemoveTabControl(int Index);

// Export UTabHandle::execSetTabControlTexture(FFrame&, void* const)
native final function SetTabControlTexture(int Index, string NewForeTexName, optional string NewBackTexName, optional string NewHighLightTexName);

// Export UTabHandle::execSetButtonTooltip(FFrame&, void* const)
native final function SetButtonTooltip(int Index, int stringIdx);

defaultproperties
{
}
