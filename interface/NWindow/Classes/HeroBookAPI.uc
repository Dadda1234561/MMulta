//================================================================================
// HeroBookAPI.
//================================================================================

class HeroBookAPI extends UIEventManager
    native;

// Export UHeroBookAPI::execGetHeroBookData(FFrame&, void* const)
native static function GetHeroBookData(int a_Level, out HeroBookData o_LevelData);

// Export UHeroBookAPI::execGetHeroBookMaxPoint(FFrame&, void* const)
native static function int GetHeroBookMaxPoint(int a_Level);

// Export UHeroBookAPI::execGetAllHeroBookListData(FFrame&, void* const)
native static function int GetAllHeroBookListData(out array<HeroBookListData> o_ListDatas);

// Export UHeroBookAPI::execGetHeroBookItemListFromInven(FFrame&, void* const)
native static function int GetHeroBookItemListFromInven(out array<ItemInfo> o_Items);

defaultproperties
{
}
