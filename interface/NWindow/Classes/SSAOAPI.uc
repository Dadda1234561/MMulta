//================================================================================
// SSAOAPI.
//================================================================================

class SSAOAPI extends Object
	native
	export;

// Export USSAOAPI::execSSAO_Level(FFrame&, void* const)
native static function SSAO_Level(int Level);

// Export USSAOAPI::execSSAO_Blend(FFrame&, void* const)
native static function SSAO_Blend(int Mode);

// Export USSAOAPI::execSSAO_Strength(FFrame&, void* const)
native static function SSAO_Strength(float Value);

// Export USSAOAPI::execSSAO_MaxIntensity(FFrame&, void* const)
native static function SSAO_MaxIntensity(float Value);

// Export USSAOAPI::execSSAO_FadeFront(FFrame&, void* const)
native static function SSAO_FadeFront(float Value);

// Export USSAOAPI::execSSAO_DepthDifference(FFrame&, void* const)
native static function SSAO_DepthDifference(float Value);

// Export USSAOAPI::execSSAO_NoiseScale(FFrame&, void* const)
native static function SSAO_NoiseScale(float Value);

// Export USSAOAPI::execSSAO_SampleDistance(FFrame&, void* const)
native static function SSAO_SampleDistance(float Value);

// Export USSAOAPI::execSSAO_BlurIntensity(FFrame&, void* const)
native static function SSAO_BlurIntensity(float Value);

// Export USSAOAPI::execSSAO_BlurDepthDifference(FFrame&, void* const)
native static function SSAO_BlurDepthDifference(float Value);

// Export USSAOAPI::execSSAO_BlurNormalDifference(FFrame&, void* const)
native static function SSAO_BlurNormalDifference(float Value);

defaultproperties
{
}
