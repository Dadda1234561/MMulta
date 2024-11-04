//================================================================================
// AudioAPI.
//================================================================================

class AudioAPI extends Object
	native
	export;

// Export UAudioAPI::execPlaySound(FFrame&, void* const)
native static function PlaySound(string a_SoundName);

// Export UAudioAPI::execPlayMusic(FFrame&, void* const)
native static function PlayMusic(string a_MusicName, float a_FadeInTime);

// Export UAudioAPI::execStopMusic(FFrame&, void* const)
native static function StopMusic();

// Export UAudioAPI::execPlayVoice(FFrame&, void* const)
native static function PlayVoice(string VoiceName);

// Export UAudioAPI::execPlayNotifySound(FFrame&, void* const)
native static function PlayNotifySound(string SoundName);

// Export UAudioAPI::execPlayIndexedNotifySound(FFrame&, void* const)
native static function PlayIndexedNotifySound(string a_SoundName, int a_iSoundIndex, bool a_bVoice);

defaultproperties
{
}
