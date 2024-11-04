//================================================================================
// UIDATA_MACRO.
//================================================================================

class UIDATA_MACRO extends UIDataManager
	native;

// Export UUIDATA_MACRO::execGetMacroInfo(FFrame&, void* const)
native static function bool GetMacroInfo(ItemID cID, out MacroInfo Info);

// Export UUIDATA_MACRO::execGetMacroCount(FFrame&, void* const)
native static function int GetMacroCount();

// Export UUIDATA_MACRO::execGetUseSkillID(FFrame&, void* const)
native static function ItemID GetUseSkillID(string Command);

// Export UUIDATA_MACRO::execGetMacroCommandList(FFrame&, void* const)
native static function GetMacroCommandList(ItemID cID, out array<string> Commands);

// Export UUIDATA_MACRO::execGetMacroSkillIDList(FFrame&, void* const)
native static function GetMacroSkillIDList(ItemID cID, out array<ItemID> SkillIDs);

// Export UUIDATA_MACRO::execGetMacroPresetIDs(FFrame&, void* const)
native static function int GetMacroPresetIDs(out array<int> IDs);

// Export UUIDATA_MACRO::execGetMacroPresetInfo(FFrame&, void* const)
native static function bool GetMacroPresetInfo(int presetID, out MacroPresetInfo Info);

defaultproperties
{
}
