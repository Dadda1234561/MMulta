//=============================================================================
// Ambient sound -- Extended to support random interval sound emitters (gam).
// Copyright 2001 Digital Extremes - All Rights Reserved.
// Confidential.
//=============================================================================
class AmbientSound extends Keypoint
	native
	exportstructs
	hidecategories(Movement,Collision,Lighting,LightColor,Karma,Force,Wind,Display);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

#exec Texture Import File=Textures\Ambient.pcx Name=S_Ambient Mips=Off MASKED=1

// Sound will trigger every EmitInterval +/- Rand(EmitVariance) seconds.

struct SoundEmitter
{
    var() float EmitInterval;
    var() float EmitVariance;
    
    var transient float EmitTime;

    var() Sound EmitSound; // Manually re-order because Dan turned off property sorting and broke binary compatibility.
};

var(Sound) Array<SoundEmitter> SoundEmitters;
var globalconfig float AmbientVolume;		// ambient volume multiplier (scaling)


// Decompiled with UE Explorer.
defaultproperties
{
    AmbientVolume=0.3
    bStatic=false
    bNoDelete=true
    RemoteRole=0
    Texture=Texture'S_Ambient'
    SoundRadius=100
    SoundVolume=100
}