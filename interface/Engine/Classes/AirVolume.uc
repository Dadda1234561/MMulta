////////////////////////////////////////////
// AirVolume
////////////////////////////////////////////
//#ifdef __L2 // by nonblock
class AirVolume extends Volume
	native
	nativereplication;

var(AirVolume) name EffectName;
var(AirVolume) float FullFadeSeconds;
var(AirVolume) float RelativeOffset;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}


//#endif

// Decompiled with UE Explorer.
defaultproperties
{
    FullFadeSeconds=60
}