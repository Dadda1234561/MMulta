//================================================================================
// CheckBoxHandle.
//================================================================================

class CheckBoxHandle extends WindowHandle
	native;

// Export UCheckBoxHandle::execSetTitle(FFrame&, void* const)
native final function SetTitle(string Title);

// Export UCheckBoxHandle::execSetCheck(FFrame&, void* const)
native final function SetCheck(bool bCheck);

// Export UCheckBoxHandle::execIsChecked(FFrame&, void* const)
native final function bool IsChecked();

// Export UCheckBoxHandle::execIsDisable(FFrame&, void* const)
native final function bool IsDisable();

// Export UCheckBoxHandle::execSetDisable(FFrame&, void* const)
native final function SetDisable(bool bDisable);

// Export UCheckBoxHandle::execToggleDisable(FFrame&, void* const)
native final function ToggleDisable();

defaultproperties
{
}
