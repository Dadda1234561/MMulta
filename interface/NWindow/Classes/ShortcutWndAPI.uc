//================================================================================
// ShortcutWndAPI.
//================================================================================

class ShortcutWndAPI extends UIEventManager
	native;

// Export UShortcutWndAPI::execSetShortcutPage(FFrame&, void* const)
native static function SetShortcutPage(int a_ShortcutPage);

// Export UShortcutWndAPI::execExecuteShortcutBySlot(FFrame&, void* const)
native static function ExecuteShortcutBySlot(int Slot);

// Export UShortcutWndAPI::execRequestAutomaticUseItemActivateAll(FFrame&, void* const)
native static function RequestAutomaticUseItemActivateAll(bool bActivate);

// Export UShortcutWndAPI::execRequestAutomaticUseItemActivate(FFrame&, void* const)
native static function RequestAutomaticUseItemActivate(int Slot, bool bActivate);

// Export UShortcutWndAPI::execSetAutoUseMacro(FFrame&, void* const)
native static function SetAutoUseMacro(int Slot, bool AutoUse);

// Export UShortcutWndAPI::execRequestRegisterShortcut(FFrame&, void* const)
native static function RequestRegisterShortcut(int a_slot, ItemInfo a_itemInfo);

// Export UShortcutWndAPI::execGetSkillListFromShortcutItems(FFrame&, void* const)
native static function int GetSkillListFromShortcutItems(out array<int> o_SkillList);

defaultproperties
{
}
