//================================================================================
// NameCtrlHandle.
//================================================================================

class NameCtrlHandle extends WindowHandle
	native;

// Export UNameCtrlHandle::execSetName(FFrame&, void* const)
native final function SetName(string Name, UIEventManager.ENameCtrlType Type, UIEventManager.ETextAlign Align);

// Export UNameCtrlHandle::execSetNameWithColor(FFrame&, void* const)
native final function SetNameWithColor(string Name, UIEventManager.ENameCtrlType Type, UIEventManager.ETextAlign Align, Color NameColor);

// Export UNameCtrlHandle::execGetName(FFrame&, void* const)
native final function string GetName();

// Export UNameCtrlHandle::execSetNameUsingItem(FFrame&, void* const)
native final function SetNameUsingItem(out ItemInfo Info, UIEventManager.ENameCtrlType Type, UIEventManager.ETextAlign Align);

defaultproperties
{
}
