//=============================================================================
// AmbientVolumeSound:  
//=============================================================================
class AmbientVolumeSound extends Object
	editinlinenew
	native;

enum	AmbientVolumeType{
	AmbientVolume_Always,
	AmbientVolume_Day,
	AmbientVolume_Night };

var() AmbientVolumeType Type;
var() int Volume; // ?????? ????
var() float Pitch;
var() int Random; // 0~100 ??????. 20???? 5?? ?????? ???? ???? 1?? ?????????? ????.
var() sound AmbientSound;
var float WaitingTime;
var bool NeedToWait;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
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
    Volume=250
    Pitch=1
    Random=100
}