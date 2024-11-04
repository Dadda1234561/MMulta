//================================================================================
// UIDATA_API.
//================================================================================

class UIDATA_API extends UIDataManager
	native;

// Export UUIDATA_API::execSetState(FFrame&, void* const)
native static function SetState(string stateName);

// Export UUIDATA_API::execChangeToPrevState(FFrame&, void* const)
native static function ChangeToPrevState();

defaultproperties
{
}
