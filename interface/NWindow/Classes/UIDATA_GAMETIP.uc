//================================================================================
// UIDATA_GAMETIP.
//================================================================================

class UIDATA_GAMETIP extends UIDataManager
	native;

// Export UUIDATA_GAMETIP::execGetDataCount(FFrame&, void* const)
native static function int GetDataCount();

// Export UUIDATA_GAMETIP::execGetDataByIndex(FFrame&, void* const)
native static function bool GetDataByIndex(int a_nIndex, out GameTipData a_GameTipData);

defaultproperties
{
}
