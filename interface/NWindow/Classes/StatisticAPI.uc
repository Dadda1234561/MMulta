//================================================================================
// StatisticAPI.
//================================================================================

class StatisticAPI extends UIDataManager
	native;

// Export UStatisticAPI::execGetTitleNameOfStatistic(FFrame&, void* const)
native static function string GetTitleNameOfStatistic(int Id);

// Export UStatisticAPI::execGetContentInfo(FFrame&, void* const)
native static function string GetContentInfo(int Id);

// Export UStatisticAPI::execGetTableOfContent(FFrame&, void* const)
native static function string GetTableOfContent();

// Export UStatisticAPI::execRequestHotLinkStatistics(FFrame&, void* const)
native static function RequestHotLinkStatistics(int Id);

// Export UStatisticAPI::execRequestWorldStatistics(FFrame&, void* const)
native static function RequestWorldStatistics(int Id);

// Export UStatisticAPI::execRequestUserStatistics(FFrame&, void* const)
native static function RequestUserStatistics();

defaultproperties
{
}
