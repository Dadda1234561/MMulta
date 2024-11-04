//#ifdef __L2 // zodiac
//=============================================================================
// L2MovableStaticMeshActor.
// An actor that is drawn using a static mesh(a mesh that never changes, and
// can be cached in video memory, resulting in a speed boost).
//=============================================================================

////////////////////////////////////////////////////////////////////////////////
//
// ???? MovableStaticMesh ?? ???? ?????? ???? ???? ?????????? ???? L2MovableStaticMeshActor ?? ??????
//
// gigadeth
//

class L2MovableStaticMeshActor extends StaticMeshActor
	native
	placeable;

var vector OrgScale;
var rotator OrgRotation;
var vector OrgLocation;

var vector ScaleMaxRatio;
var vector RotationMaxRatio;
var vector TranslationMaxRatio;

var vector ScaleCurrent;
var vector RotationCurrent;
var vector TranslationCurrent;

var bool bInitialized;
var(L2Movement) bool bUseRotatedTranslation;
var(L2Movement) bool bRandomMax;
var(L2Movement) bool bRandomStart;

var(L2Movement) array<name>	L2MovementTag;

var(L2Movement) rotator RotationMax;
var(L2Movement) rotator RotationRate;
var(L2Movement) vector ScaleMax;
var(L2Movement) vector ScaleRate;
var(L2Movement) vector TranslationMax;
var(L2Movement) vector TranslationRate;
var vector DeltaLocation;
var rotator DeltaRotation;
var vector DeltaScale;


// Decompiled with UE Explorer.
defaultproperties
{
    bRandomStart=true
    bStatic=false
}