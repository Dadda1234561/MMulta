//================================================================================
// UIDATA_STATICOBJECT.
//================================================================================

class UIDATA_STATICOBJECT extends UIDataManager
	native;

// Export UUIDATA_STATICOBJECT::execGetServerObjectNameID(FFrame&, void* const)
native static function int GetServerObjectNameID(int Id);

// Export UUIDATA_STATICOBJECT::execGetServerObjectName(FFrame&, void* const)
native static function string GetServerObjectName(int Id);

// Export UUIDATA_STATICOBJECT::execGetServerObjectType(FFrame&, void* const)
native static function Actor.EL2ObjectType GetServerObjectType(int Id);

// Export UUIDATA_STATICOBJECT::execGetServerObjectMaxHP(FFrame&, void* const)
native static function int GetServerObjectMaxHP(int Id);

// Export UUIDATA_STATICOBJECT::execGetServerObjectHP(FFrame&, void* const)
native static function int GetServerObjectHP(int Id);

// Export UUIDATA_STATICOBJECT::execGetStaticObjectName(FFrame&, void* const)
native static function string GetStaticObjectName(int NameID);

// Export UUIDATA_STATICOBJECT::execGetStaticObjectShowHP(FFrame&, void* const)
native static function bool GetStaticObjectShowHP(int a_ID);

defaultproperties
{
}
