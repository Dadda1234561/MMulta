//================================================================================
// StatusBarHandle.
//================================================================================

class StatusBarHandle extends StatusBaseHandle
	native;

// Export UStatusBarHandle::execSetDecimalPlace(FFrame&, void* const)
native final function SetDecimalPlace(int nDecimalPlace);

// Export UStatusBarHandle::execSetDrawPoint(FFrame&, void* const)
native final function SetDrawPoint(bool bDrawPoint);

defaultproperties
{
}
