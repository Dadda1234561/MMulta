//=============================================================================
// Ambient sound, sits there and emits its sound.  This class is no different 
// than placing any other actor in a level and setting its ambient sound.
//=============================================================================
class AmbientSoundObject extends LevelObject
	placeable
	native;

// Import the sprite.
#exec Texture Import File=Textures\Ambient.pcx Name=S_Ambient Mips=Off MASKED=1

//#ifdef	__L2	Hunter
enum	ASType1{
	AST1_Always,
	AST1_Day,
	AST1_Night,
	AST1_Water,
	AST1_RangeTime};
var(Sound)	array<range> AmbientSoundRangeTime;	// Custom RangeTime for AST_RangeTime	2010.11.22. winkey
var(Sound)	ASType1		AmbientSoundType;
var(Sound)	int			AmbientRandom;	 // Radius of ambient sound.
var			float		AmbientSoundStartTime;	//Sound Run-Time Variable
//#endif

// Ambient sound.
var(Sound) sound		AmbientSound;			// Ambient sound effect.
var(Sound) float        SoundRadius;			// Radius of ambient sound.
var(Sound) byte         SoundVolume;			// Volume of ambient sound.
var(Sound) byte         SoundPitch;				// Sound pitch shift, 64.0=none.
var(Sound) array<int>   ZonePlayState;			// Zone Play State by elsacred on 2009.11.5
var(Movement) actor		ParentActor;

// Decompiled with UE Explorer.
defaultproperties
{
    AmbientRandom=100
    SoundRadius=64
    SoundVolume=190
    SoundPitch=64
    bHidden=false
    Texture=Texture'S_Ambient'
}