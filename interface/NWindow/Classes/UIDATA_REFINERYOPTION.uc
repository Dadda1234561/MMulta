//================================================================================
// UIDATA_REFINERYOPTION.
//================================================================================

class UIDATA_REFINERYOPTION extends Object
	native
	export;

// Export UUIDATA_REFINERYOPTION::execGetQuality(FFrame&, void* const)
native static function int GetQuality(int a_ID);

// Export UUIDATA_REFINERYOPTION::execGetOptionDescription(FFrame&, void* const)
native static function bool GetOptionDescription(int a_ID, out string a_Desc1, out string a_Desc2, out string a_Desc3);

defaultproperties
{
}
