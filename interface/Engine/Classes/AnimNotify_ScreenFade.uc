//#ifdef __L2 // by nonblock
class AnimNotify_ScreenFade extends AnimNotify
	native;

var() float	FadeOutDuration;
var() color FadeOutColor;
var() float BlackOutDuration;
var() float FadeInDuration;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//#endif


// Decompiled with UE Explorer.
defaultproperties
{
    FadeOutDuration=3000
    FadeOutColor=(B=255,G=255,R=255,A=255)
    FadeInDuration=1000
}