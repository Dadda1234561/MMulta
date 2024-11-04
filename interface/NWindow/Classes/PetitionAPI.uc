//================================================================================
// PetitionAPI.
//================================================================================

class PetitionAPI extends Object
	native
	export;

// Export UPetitionAPI::execRequestPetitionCancel(FFrame&, void* const)
native static function RequestPetitionCancel();

// Export UPetitionAPI::execRequestPetition(FFrame&, void* const)
native static function RequestPetition(string a_Message, int a_PetitionType);

// Export UPetitionAPI::execRequestPetitionFeedBack(FFrame&, void* const)
native static function RequestPetitionFeedBack(int a_Rate, string a_Message);

defaultproperties
{
}
