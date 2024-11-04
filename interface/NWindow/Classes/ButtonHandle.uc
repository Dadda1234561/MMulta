//================================================================================
// ButtonHandle.
//================================================================================

class ButtonHandle extends WindowHandle
	native;

// Export UButtonHandle::execGetButtonName(FFrame&, void* const)
native final function string GetButtonName();

// Export UButtonHandle::execSetButtonName(FFrame&, void* const)
native final function SetButtonName(int a_NameID);

// Export UButtonHandle::execSetNameText(FFrame&, void* const)
native final function SetNameText(string NameText);

// Export UButtonHandle::execSetTexture(FFrame&, void* const)
native final function SetTexture(string sForeTexture, string sBackTexture, string sHighlightTexture);

// Export UButtonHandle::execIsMouseOver(FFrame&, void* const)
native final function bool IsMouseOver();

// Export UButtonHandle::execGetButtonValue(FFrame&, void* const)
native final function int GetButtonValue();

// Export UButtonHandle::execSetButtonValue(FFrame&, void* const)
native final function SetButtonValue(int Value);

// Export UButtonHandle::execSetEnable(FFrame&, void* const)
native final function SetEnable(bool bEnable);

// Export UButtonHandle::execSetDefaultTextEnableColor(FFrame&, void* const)
native final function SetDefaultTextEnableColor(Color a_Color);

// Export UButtonHandle::execSetDefaultTextDisableColor(FFrame&, void* const)
native final function SetDefaultTextDisableColor(Color a_Color);

defaultproperties
{
}
