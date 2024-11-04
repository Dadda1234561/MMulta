//================================================================================
// UIDATA_SKILL.
//================================================================================

class UIDATA_SKILL extends UIDataManager
	native;

// Export UUIDATA_SKILL::execGetFirstID(FFrame&, void* const)
native static function ItemID GetFirstID();

// Export UUIDATA_SKILL::execGetNextID(FFrame&, void* const)
native static function ItemID GetNextID();

// Export UUIDATA_SKILL::execGetDataCount(FFrame&, void* const)
native static function int GetDataCount();

// Export UUIDATA_SKILL::execGetIconName(FFrame&, void* const)
native static function string GetIconName(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetIconPanel(FFrame&, void* const)
native static function string GetIconPanel(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetIconPanel2(FFrame&, void* const)
native static function string GetIconPanel2(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetName(FFrame&, void* const)
native static function string GetName(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetDescription(FFrame&, void* const)
native static function string GetDescription(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetEnchantName(FFrame&, void* const)
native static function string GetEnchantName(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetEnchantSkillLevel(FFrame&, void* const)
native static function int GetEnchantSkillLevel(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetEnchantIcon(FFrame&, void* const)
native static function string GetEnchantIcon(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetOperateType(FFrame&, void* const)
native static function string GetOperateType(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execIsAlchemySkill(FFrame&, void* const)
native static function bool IsAlchemySkill(ItemID Id, int Level);

// Export UUIDATA_SKILL::execGetHpConsume(FFrame&, void* const)
native static function int GetHpConsume(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetMpConsume(FFrame&, void* const)
native static function int GetMpConsume(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetCastRange(FFrame&, void* const)
native static function int GetCastRange(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetUltimateSkillLevel(FFrame&, void* const)
native static function int GetUltimateSkillLevel(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execSkillIsNewOrUp(FFrame&, void* const)
native static function int SkillIsNewOrUp(ItemID Id);

// Export UUIDATA_SKILL::execIsAvailableClass(FFrame&, void* const)
native static function bool IsAvailableClass(ItemID Id, int Level, int SubLevel, int Class);

// Export UUIDATA_SKILL::execGetCurrentSkillList(FFrame&, void* const)
native static function GetCurrentSkillList(out array<ItemID> IDs);

// Export UUIDATA_SKILL::execIsToppingSkill(FFrame&, void* const)
native static function bool IsToppingSkill(ItemID Id, int Level, int SubLevel);

// Export UUIDATA_SKILL::execGetToppingSkillExtraInfo(FFrame&, void* const)
native static function bool GetToppingSkillExtraInfo(ItemID Id, int Level, int SubLevel, out ToppingSkillExtraInfo Info);

// Export UUIDATA_SKILL::execGetFirstDefaultToppingSkillExtraInfo(FFrame&, void* const)
native static function bool GetFirstDefaultToppingSkillExtraInfo(out ToppingSkillExtraInfo Info);

// Export UUIDATA_SKILL::execGetNextDefaultToppingSkillExtraInfo(FFrame&, void* const)
native static function bool GetNextDefaultToppingSkillExtraInfo(out ToppingSkillExtraInfo Info);

// Export UUIDATA_SKILL::execGetAutomaticUseSkillType(FFrame&, void* const)
native static function UIEventManager.EAutomaticUseSkillType GetAutomaticUseSkillType(ItemID Id);

// Export UUIDATA_SKILL::execGetMSCondItem(FFrame&, void* const)
native static function bool GetMSCondItem(int a_ID, int a_Level, int a_Sublevel, out int o_ItemClassID, out int o_ItemCount);

// Export UUIDATA_SKILL::execGetMSCondEquipType(FFrame&, void* const)
native static function bool GetMSCondEquipType(int a_ID, int a_Level, int a_Sublevel, out UIEventManager.ESkillConditionEquipType o_EquipType);

// Export UUIDATA_SKILL::execGetMSCondWeapons(FFrame&, void* const)
native static function bool GetMSCondWeapons(int a_ID, int a_Level, int a_Sublevel, out array<UIEventManager.AttackType> o_ArrWeapons);

defaultproperties
{
}
