//================================================================================
// BarHandle.
//================================================================================

class BarHandle extends WindowHandle
	native;

// Export UBarHandle::execSetValue(FFrame&, void* const)
native final function SetValue(int a_MaxValue, int a_CurValue);

// Export UBarHandle::execGetValue(FFrame&, void* const)
native final function GetValue(out int a_MaxValue, out int a_CurValue);

// Export UBarHandle::execClear(FFrame&, void* const)
native final function Clear();

// Export UBarHandle::execSetTexture(FFrame&, void* const)
native final function SetTexture(int TextureIdx, string TexName);

defaultproperties
{
}
