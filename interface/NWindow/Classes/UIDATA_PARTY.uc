//================================================================================
// UIDATA_PARTY.
//================================================================================

class UIDATA_PARTY extends UIDataManager
	native;

// Export UUIDATA_PARTY::execGetMemberName(FFrame&, void* const)
native static function string GetMemberName(int Id);

// Export UUIDATA_PARTY::execMovePartyMember(FFrame&, void* const)
native static function string MovePartyMember(int SrcPos, int TarPos);

// Export UUIDATA_PARTY::execGetMemberVirtualName(FFrame&, void* const)
native static function string GetMemberVirtualName(int Id);

// Export UUIDATA_PARTY::execGetMemberTacticalSign(FFrame&, void* const)
native static function int GetMemberTacticalSign(int Id);

defaultproperties
{
}
