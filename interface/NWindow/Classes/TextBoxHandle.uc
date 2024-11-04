//================================================================================
// TextBoxHandle.
//================================================================================

class TextBoxHandle extends WindowHandle
	native;

// Export UTextBoxHandle::execGetText(FFrame&, void* const)
native final function string GetText();

// Export UTextBoxHandle::execSetText(FFrame&, void* const)
native final function SetText(string a_Text);

// Export UTextBoxHandle::execSetTextColor(FFrame&, void* const)
native final function SetTextColor(Color a_Color);

// Export UTextBoxHandle::execGetTextColor(FFrame&, void* const)
native final function Color GetTextColor();

// Export UTextBoxHandle::execSetAlign(FFrame&, void* const)
native final function SetAlign(UIEventManager.ETextAlign Align);

// Export UTextBoxHandle::execSetInt(FFrame&, void* const)
native final function SetInt(int Number);

// Export UTextBoxHandle::execSetTooltipString(FFrame&, void* const)
native final function SetTooltipString(string Text);

// Export UTextBoxHandle::execSetTextEllipsisWidth(FFrame&, void* const)
native final function SetTextEllipsisWidth(int Width);

// Export UTextBoxHandle::execSetFontIDByName(FFrame&, void* const)
native final function SetFontIDByName(string FontName, optional bool SetChild);

// Export UTextBoxHandle::execGetSizeX(FFrame&, void* const)
native final function int GetSizeX();

// Export UTextBoxHandle::execGetSizeY(FFrame&, void* const)
native final function int GetSizeY();

// Export UTextBoxHandle::execSetFormatString(FFrame&, void* const)
native final function SetFormatString(string formatString);

defaultproperties
{
}
