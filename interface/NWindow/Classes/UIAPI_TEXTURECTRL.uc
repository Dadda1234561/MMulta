//================================================================================
// UIAPI_TEXTURECTRL.
//================================================================================

class UIAPI_TEXTURECTRL extends UIAPI_WINDOW
	native;

// Export UUIAPI_TEXTURECTRL::execSetUV(FFrame&, void* const)
native static function SetUV(string ControlName, int a_U, int a_V);

// Export UUIAPI_TEXTURECTRL::execSetTexture(FFrame&, void* const)
native static function SetTexture(string ControlName, string strTexture);

// Export UUIAPI_TEXTURECTRL::execSetTextureCtrlType(FFrame&, void* const)
native static function SetTextureCtrlType(string ControlName, UIEventManager.ETextureCtrlType Type);

// Export UUIAPI_TEXTURECTRL::execSetTextureWithClanCrest(FFrame&, void* const)
native static function SetTextureWithClanCrest(string ControlName, int clanID);

// Export UUIAPI_TEXTURECTRL::execSetTextureWithObject(FFrame&, void* const)
native static function SetTextureWithObject(string ControlName, Texture objTexture);

// Export UUIAPI_TEXTURECTRL::execGetTextureName(FFrame&, void* const)
native static function string GetTextureName(string ControlName);

defaultproperties
{
}
