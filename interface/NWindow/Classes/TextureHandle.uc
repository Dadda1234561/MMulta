//================================================================================
// TextureHandle.
//================================================================================

class TextureHandle extends WindowHandle
	native;

// Export UTextureHandle::execSetTexture(FFrame&, void* const)
native final function SetTexture(string a_TextureName);

// Export UTextureHandle::execSetUV(FFrame&, void* const)
native final function SetUV(int a_U, int a_V);

// Export UTextureHandle::execSetTextureSize(FFrame&, void* const)
native final function SetTextureSize(int a_UL, int a_VL);

// Export UTextureHandle::execSetTextureCtrlType(FFrame&, void* const)
native final function SetTextureCtrlType(UIEventManager.ETextureCtrlType Type);

// Export UTextureHandle::execSetTextureWithClanCrest(FFrame&, void* const)
native final function SetTextureWithClanCrest(int clanID);

// Export UTextureHandle::execSetTextureWithObject(FFrame&, void* const)
native final function SetTextureWithObject(Texture objTexture);

// Export UTextureHandle::execGetTextureName(FFrame&, void* const)
native final function string GetTextureName();

// Export UTextureHandle::execSetAutoRotateType(FFrame&, void* const)
native final function SetAutoRotateType(UIEventManager.ETextureAutoRotateType Type);

// Export UTextureHandle::execSetRotatingDirection(FFrame&, void* const)
native final function SetRotatingDirection(int Dir);

// Export UTextureHandle::execGetColor(FFrame&, void* const)
native final function Color GetColor(int a_U, int a_V);

// Export UTextureHandle::execSetColorModify(FFrame&, void* const)
native final function SetColorModify(Color a_ColorModify);

defaultproperties
{
}
