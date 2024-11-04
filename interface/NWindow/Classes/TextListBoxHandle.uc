//================================================================================
// TextListBoxHandle.
//================================================================================

class TextListBoxHandle extends WindowHandle
	native;

enum ELineGapType {
	LG_NONE,
	LG_AUTO,
	LG_MANUAL
};

// Export UTextListBoxHandle::execAddString(FFrame&, void* const)
native final function AddString(string Text, Color TextColor);

// Export UTextListBoxHandle::execAddStringToChatWindow(FFrame&, void* const)
native final function AddStringToChatWindow(string Text, Color TextColor, Color textSubColor, optional int SharedPositionID);

// Export UTextListBoxHandle::execClear(FFrame&, void* const)
native final function Clear();

// Export UTextListBoxHandle::execSetTextListBoxScrollPosition(FFrame&, void* const)
native final function SetTextListBoxScrollPosition(int pos);

// Export UTextListBoxHandle::execSetFontIDByName(FFrame&, void* const)
native final function SetFontIDByName(string FontName, optional bool SetChild, optional TextListBoxHandle.ELineGapType LGType, optional int LineGap);

defaultproperties
{
}
