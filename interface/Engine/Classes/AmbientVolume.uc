//=============================================================================
// AmbientVolume:  
//=============================================================================
class AmbientVolume extends Volume
	native
	nativereplication;

var(AmbientSound) int Priority;	// ???? ?????? ?????????? ???? ?????????? ????. ?? ?????? ???? ?????????? ?????????? ????.
var(AmbientSound) float FadeInTime;
var(AmbientSound) float FadeOutTime;
var(AmbientSound) export editinline array<AmbientVolumeSound> AmbientVolumeSounds;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    Priority=1
    FadeInTime=1
    FadeOutTime=1
}