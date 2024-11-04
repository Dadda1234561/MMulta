//=============================================================================
// Emitter: An Unreal Sprite Particle Emitter.
//=============================================================================
class SpriteEmitter extends ParticleEmitter
	native;


enum EParticleDirectionUsage
{
	PTDU_None,
	PTDU_Up,
	PTDU_Right,
	PTDU_Forward,
	PTDU_Normal,
	PTDU_UpAndNormal,
	PTDU_RightAndNormal,
	PTDU_Scale
};

enum ESpriteRefraction
{
	REF_None,
	REF_LightPerformance,
	REF_HeavyPerformanceButElaborate
};

var (Sprite)		EParticleDirectionUsage		UseDirectionAs;
var (Sprite)		vector						ProjectionNormal;
var (Sprite)		ESpriteRefraction			Refraction;
var (Sprite)		float						RefrUScale;
var (Sprite)		float						RefrVScale;
var transient		vector						RealProjectionNormal;



// Decompiled with UE Explorer.
defaultproperties
{
    ProjectionNormal=(X=0,Y=0,Z=1)
    RefrUScale=0.06
    RefrVScale=0.06
}