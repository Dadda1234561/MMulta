//================================================================================
// ChatWindowHandle.
//================================================================================

class ChatWindowHandle extends TextListBoxHandle
	native;

// Export UChatWindowHandle::execEnableTexture(FFrame&, void* const)
native final function EnableTexture(bool bValue);

// Export UChatWindowHandle::execISScrollable(FFrame&, void* const)
native final function bool ISScrollable();

defaultproperties
{
}
