//================================================================================
// ShortcutAPI.
//================================================================================

class ShortcutAPI extends UIEventManager
	native;

// Export UShortcutAPI::execAssignSpecialKey(FFrame&, void* const)
native static function bool AssignSpecialKey(ShortcutCommandItem Command);

// Export UShortcutAPI::execAssignCommand(FFrame&, void* const)
native static function bool AssignCommand(string GroupName, ShortcutCommandItem Command);

// Export UShortcutAPI::execGetGroupCommandList(FFrame&, void* const)
native static function GetGroupCommandList(string GroupName, out array<ShortcutCommandItem> Commands);

// Export UShortcutAPI::execGetGroupList(FFrame&, void* const)
native static function GetGroupList(out array<string> groups);

// Export UShortcutAPI::execGetActiveGroupList(FFrame&, void* const)
native static function GetActiveGroupList(out array<string> groups);

// Export UShortcutAPI::execGetAssignedKeyFromCommand(FFrame&, void* const)
native static function GetAssignedKeyFromCommand(string GroupName, string Command, out ShortcutCommandItem commandItem);

// Export UShortcutAPI::execLockShortcut(FFrame&, void* const)
native static function LockShortcut();

// Export UShortcutAPI::execUnlockShortcut(FFrame&, void* const)
native static function UnlockShortcut();

// Export UShortcutAPI::execSave(FFrame&, void* const)
native static function Save();

// Export UShortcutAPI::execRequestList(FFrame&, void* const)
native static function RequestList();

// Export UShortcutAPI::execRequestShortcutScriptData(FFrame&, void* const)
native static function bool RequestShortcutScriptData(int Id, out ShortcutScriptData Data);

// Export UShortcutAPI::execActivateGroup(FFrame&, void* const)
native static function ActivateGroup(string GroupName);

// Export UShortcutAPI::execDeactivateGroup(FFrame&, void* const)
native static function DeactivateGroup(string GroupName);

// Export UShortcutAPI::execDeactivateAll(FFrame&, void* const)
native static function DeactivateAll();

// Export UShortcutAPI::execRestoreDefault(FFrame&, void* const)
native static function RestoreDefault();

// Export UShortcutAPI::execClear(FFrame&, void* const)
native static function Clear();

// Export UShortcutAPI::execExecuteShortcutCommand(FFrame&, void* const)
native static function ExecuteShortcutCommand(string Command);

defaultproperties
{
}
