//================================================================================
// HeroTowerAPI.
//================================================================================

class HeroTowerAPI extends Object
	native
	export;

// Export UHeroTowerAPI::execRequestWriteHeroWords(FFrame&, void* const)
native static function RequestWriteHeroWords(string strWord);

// Export UHeroTowerAPI::execRequestHeroMatchRecord(FFrame&, void* const)
native static function RequestHeroMatchRecord(int ClassID);

defaultproperties
{
}
