class AnimNotify_Effect extends AnimNotify
	native;

var() class<Emitter> EffectClass;
var() name Bone;
var() vector OffsetLocation;
var() rotator OffsetRotation;
var() bool Attach;
var() name Tag;
var() float DrawScale;
var() vector DrawScale3D;
//kurt
var() bool TrailCamera;
var() bool IndependentRotation;
var() float EffectScale;

var() bool bCylinderBottom;

var private transient Actor LastSpawnedEffect;	// Valid only in the editor.

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    DrawScale=1
    DrawScale3D=(X=1,Y=1,Z=1)
    EffectScale=1
}