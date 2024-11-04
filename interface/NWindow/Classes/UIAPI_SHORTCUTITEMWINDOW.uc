//================================================================================
// UIAPI_SHORTCUTITEMWINDOW.
//================================================================================

class UIAPI_SHORTCUTITEMWINDOW extends UIAPI_WINDOW
	native;

// Export UUIAPI_SHORTCUTITEMWINDOW::execUpdateShortcut(FFrame&, void* const)
native static function UpdateShortcut(string a_strWindowID, int a_nShortcutID);

// Export UUIAPI_SHORTCUTITEMWINDOW::execClear(FFrame&, void* const)
native static function Clear(string a_strWindowID);

// Export UUIAPI_SHORTCUTITEMWINDOW::execAddShortcutItem(FFrame&, void* const)
native static function AddShortcutItem(ItemInfo a_itemInfo, int a_nShortcutID);

// Export UUIAPI_SHORTCUTITEMWINDOW::execGetShortcutItem(FFrame&, void* const)
native static function bool GetShortcutItem(out ItemInfo a_itemInfo, int a_nShortcutID);

defaultproperties
{
}
