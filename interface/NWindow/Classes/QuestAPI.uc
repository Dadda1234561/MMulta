//================================================================================
// QuestAPI.
//================================================================================

class QuestAPI extends Object
	native
	export;

// Export UQuestAPI::execRequestQuestList(FFrame&, void* const)
native static function RequestQuestList();

// Export UQuestAPI::execRequestDestroyQuest(FFrame&, void* const)
native static function RequestDestroyQuest(int QuestID);

// Export UQuestAPI::execSetQuestTargetInfo(FFrame&, void* const)
native static function SetQuestTargetInfo(bool QuestOn, bool ShowTargetInRadar, bool ShowArrow, string TargetName, Vector TargetPos, int QuestID, int QuestLevel);

defaultproperties
{
}
