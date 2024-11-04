//================================================================================
// UIDATA_QUEST.
//================================================================================

class UIDATA_QUEST extends UIDataManager
	native;

// Export UUIDATA_QUEST::execGetFirstID(FFrame&, void* const)
native static function int GetFirstID();

// Export UUIDATA_QUEST::execGetNextID(FFrame&, void* const)
native static function int GetNextID();

// Export UUIDATA_QUEST::execIsValidData(FFrame&, void* const)
native static function bool IsValidData(int Id);

// Export UUIDATA_QUEST::execIsMinimapOnly(FFrame&, void* const)
native static function bool IsMinimapOnly(int Id, int Level);

// Export UUIDATA_QUEST::execGetQuestName(FFrame&, void* const)
native static function string GetQuestName(int nQuestID, optional int nQuestLevel);

// Export UUIDATA_QUEST::execGetQuestJournalName(FFrame&, void* const)
native static function string GetQuestJournalName(int Id, int Level);

// Export UUIDATA_QUEST::execGetQuestJournalNameLine(FFrame&, void* const)
native static function string GetQuestJournalNameLine(string Name);

// Export UUIDATA_QUEST::execGetQuestJournalNameSplit(FFrame&, void* const)
native static function string GetQuestJournalNameSplit(string Name, int Completed);

// Export UUIDATA_QUEST::execGetQuestDescription(FFrame&, void* const)
native static function string GetQuestDescription(int Id, int Level);

// Export UUIDATA_QUEST::execGetQuestItem(FFrame&, void* const)
native static function string GetQuestItem(int Id, int Level);

// Export UUIDATA_QUEST::execGetTargetLoc(FFrame&, void* const)
native static function Vector GetTargetLoc(int Id, int Level);

// Export UUIDATA_QUEST::execGetTargetName(FFrame&, void* const)
native static function string GetTargetName(int Id, int Level);

// Export UUIDATA_QUEST::execGetStartNPCLoc(FFrame&, void* const)
native static function Vector GetStartNPCLoc(int Id, int Level);

// Export UUIDATA_QUEST::execGetStartNPCID(FFrame&, void* const)
native static function int GetStartNPCID(int Id, int Level);

// Export UUIDATA_QUEST::execGetRequirement(FFrame&, void* const)
native static function string GetRequirement(int Id, int Level);

// Export UUIDATA_QUEST::execGetIntro(FFrame&, void* const)
native static function string GetIntro(int Id, int Level);

// Export UUIDATA_QUEST::execGetMinLevel(FFrame&, void* const)
native static function int GetMinLevel(int Id, int Level);

// Export UUIDATA_QUEST::execGetMaxLevel(FFrame&, void* const)
native static function int GetMaxLevel(int Id, int Level);

// Export UUIDATA_QUEST::execGetQuestType(FFrame&, void* const)
native static function int GetQuestType(int Id, int Level);

// Export UUIDATA_QUEST::execGetClearedQuest(FFrame&, void* const)
native static function int GetClearedQuest(int Id, int Level);

// Export UUIDATA_QUEST::execGetQuestZone(FFrame&, void* const)
native static function int GetQuestZone(int Id, int Level);

// Export UUIDATA_QUEST::execGetQuestZoneName(FFrame&, void* const)
native static function string GetQuestZoneName(int Id, int Level);

// Export UUIDATA_QUEST::execIsShowableJournalQuest(FFrame&, void* const)
native static function bool IsShowableJournalQuest(int Id, int Level);

// Export UUIDATA_QUEST::execIsShowableItemNumQuest(FFrame&, void* const)
native static function bool IsShowableItemNumQuest(int Id, int Level);

// Export UUIDATA_QUEST::execGetQuestIscategory(FFrame&, void* const)
native static function int GetQuestIscategory(int Id, int Level);

// Export UUIDATA_QUEST::execGetQuestReward(FFrame&, void* const)
native static function bool GetQuestReward(int Id, int Level, out array<int> rewardIDList, out array<INT64> rewardNumList);

// Export UUIDATA_QUEST::execGetMarkType(FFrame&, void* const)
native static function int GetMarkType(int Id, int Level);

// Export UUIDATA_QUEST::execGetQuestCategoryID(FFrame&, void* const)
native static function int GetQuestCategoryID(int Id, int Level);

// Export UUIDATA_QUEST::execGetQuestPriority(FFrame&, void* const)
native static function int GetQuestPriority(int Id, int Level);

// Export UUIDATA_QUEST::execIsClassLimitContains(FFrame&, void* const)
native static function bool IsClassLimitContains(int QuestID, int ClassID);

// Export UUIDATA_QUEST::execIsClearedQuest(FFrame&, void* const)
native static function bool IsClearedQuest(int Id);

// Export UUIDATA_QUEST::execIsDoingQuest(FFrame&, void* const)
native static function bool IsDoingQuest(int Id);

// Export UUIDATA_QUEST::execGetQuestStatus(FFrame&, void* const)
native static function UIEventManager.EQuestStatus GetQuestStatus(int Id);

// Export UUIDATA_QUEST::execIsAcceptableQuest(FFrame&, void* const)
native static function bool IsAcceptableQuest(int Id);

defaultproperties
{
}
