//=============================================================================
// Ambient event actor, sits there and emits its sound when its event occurs. 
//=============================================================================
class AmbientEventActor extends Actor
	placeable
	native;

// Import the sprite.
#exec Texture Import File=Textures\Ambient.pcx Name=S_Ambient Mips=Off MASKED=1

var AmbientSoundObject m_pAmbientSoundObject;

var(Sound) sound		AmbientSound;
var(Sound) float        SoundRadius;			// Radius of ambient sound.
var(Sound) byte         SoundVolume;			// Volume of ambient sound.
var(Sound) byte         SoundPitch;				// Sound pitch shift, 64.0=none.


// Decompiled with UE Explorer.
defaultproperties
{
    SoundRadius=64
    SoundVolume=190
    SoundPitch=64
    bHidden=true
    Texture=Texture'S_Ambient'
}