//=============================================================================
// Emitter: An Unreal Emitter Actor.
//=============================================================================
class Emitter extends Actor
	native
	placeable;

#exec Texture Import File=Textures\S_Emitter.pcx  Name=S_Emitter Mips=Off MASKED=1


var()	export	editinline	array<ParticleEmitter>	Emitters;
var		transient			array<ParticleEmitter>	ExtraTickEmitters;

var		(Global)	rangevector			GlobalOffsetRange;
var		(Global)	range				TimeTillResetRange;
var		(Global)	bool				AutoDestroy;
var		(Global)	bool				AutoReset;
var		(Global)	bool				DisableFogging;
//#ifdef __L2 //kurt
var		(Global)	bool				AutoReplay;//only editor
var		(Global)	bool				bRotEmitter;
var		(Global)	bool				FixedBoundingBox;
var		(Global)	rotator				RotPerSecond;
var		(Global)	FLOAT				FixedBoundingBoxExpand;
var		float							SpeedRate;//for skillspeed rate

var		(SpawnSound)	array<sound>	SpawnSound;
var		(SpawnSound)	float			SoundRadius;
var		(SpawnSound)	float			SoundVolume;
var		(SpawnSound)	float			SoundDelay;
var		(SpawnSound)	float			SoundPitchMin;
var		(SpawnSound)	float			SoundPitchMax;
var		(SpawnSound)	bool			SoundLooping;
var		(SpawnSound)    bool			IsUISound;
//Sound FadeOut, ttmayrin
var		(SpawnSound)	float			SoundFadeInDuration;
var		(SpawnSound)	float			SoundFadeOutStart;
var		(SpawnSound)	float			SoundFadeOutDuration;
//#endif

var		transient	bool				ActorForcesEnabled;
var		transient	bool				UseParticleProjectors;
var		transient	bool				DeleteParticleEmitters;
var		transient	bool				bAwaked;		// Rendering ??????, ?????? Packet?? ???? disable?? ?????????? ???? ???????? update?? render?? ???????? ??????.
var		transient	int					Initialized;
var		transient	box					BoundingBox;
var		transient	float				EmitterRadius;
var		transient	float				EmitterHeight;
var		transient	vector				GlobalOffset;
var		transient	float				TimeTillReset;


//jdh84 ???????? ?????? ??????
var		transient	float				AccDeltatime;

//nonblock
var		transient	float				FixedLifeTime;

//kurt
var		transient	vector				TrailerPrePivot;
var		transient	bool				FirstSpawnParticle;
//emitter light
var     (EmitterLight)		bool		bUseLight;
var		(EmitterLight)		byte		LightType, LightEffect;
var		(EmitterLight)		byte		LightBrightness;
var		(EmitterLight)		byte		LightHue, LightSaturation;
var		(EmitterLight)		byte		EmitterLightingType;
var		(EmitterLight)		float		LightRadius;
var		(EmitterLight)		float		EL_LifeSpan;
var		(EmitterLight)		float		EL_InitialDelay;
var		transient		emitterlight	pEmitterLight;

//emitter quake 
var     (EmitterQuake)		bool		bUseQuake;
var     (EmitterQuake)		byte		ShakeType;
var     (EmitterQuake)		float		ShakeIntensity;
var     (EmitterQuake)		vector		ShakeVector;
var     (EmitterQuake)		float		ShakeRange;
var     (EmitterQuake)		int			ShakeCount;
var     (EmitterQuake)		float		ShakeTime;
var     (EmitterQuake)		float		EQ_InitialDelay;
// by anima
var		(EmitterQuake)		float		ShakeScope;			// Shake?? ???? ????
var		(EmitterQuake)		float		ShakeLiveTime;		// Shake?? ???????? ????
var		(EmitterQuake)		float		ShakeStopTime;		// Shake?? ???????? ????

// nonblock
// render if the distance is within
var		(Global)			range			VisibleLimit;
var		(Global)			float			VisibilityInterpRange;

// flagoftiger
var		(Global)			bool			bSetSizeScale;

// anima - Only Use Enchant Effect 
var		(Enchant)			bool			bSetMatrix;
var		(Enchant)			vector			EnchantOffset;
var		(Enchant)			vector			EnchantScale;
var		(Enchant)			name			EnchantBone;
var		(Enchant)			Matrix			EditorEnchantMatrix;		// Enchant ???? Emitter ???? Matrix - Editor?????? ????

//var		(Global)			bool			bIsSkillEffectEmitter;

// lpislhy - for parallel processing
var							bool			bUpdate;
var							bool			bAllDead;
var							bool			bAllDisabled;
var							bool			bActorForces;
var							bool			bOnInitialDelay;

// For halloween event - lancelot 2009. 10. 7
var			transient float		m_fLifeTime;
var			transient float		m_fCurTime;

//#ifdef__L2 //elsacred
var()		bool		IsScreenEffect; // For Screen Filter on 2009.10.30 
//#endif

// For Ortho Render - jin 2009. 12. 07
var		bool	bOrthoRender;
var		float	fOrthoCoordX;
var		float	fOrthoCoordY;
var		bool	bOrthoVisible;

var		(Global)	bool bForcedActiveLimit;

var		transient bool	CannotUpdateSkippable;

// Performance check
var		transient int tickCycle;
var		transient int renderCycle;

// distance from camera(or user pawn)
var transient	int CurrentDist;

var transient	vector			AttachedBoneSpaceTranslation;
var transient	rotator			AttachedBoneSpaceRotation;	

var transient	bool				bRendered;
var transient   ParticleMaterial    ParticleMaterial;

// shutdown the emitter and make it auto-destroy when the last active particle dies.
native function Kill();
 
simulated function UpdatePrecacheMaterials()
{
	local int i;
	for( i=0; i<Emitters.Length; i++ )
	{
		if( Emitters[i] != None )
		{
			if( Emitters[i].Texture != None )
				Level.AddPrecacheMaterial(Emitters[i].Texture);
		}
	}
}

event Trigger( Actor Other, Pawn EventInstigator )
{
	local int i;
	for( i=0; i<Emitters.Length; i++ )
	{
		if( Emitters[i] != None )
			Emitters[i].Trigger();
	}
}



// Decompiled with UE Explorer.
defaultproperties
{
    AutoDestroy=true
    SpeedRate=1
    SoundPitchMin=1
    SoundPitchMax=1
    VisibilityInterpRange=500
    bSetSizeScale=true
    bNeedCleanup=false
    bNoDelete=true
    bCheckChangableLevel=true
    bUseL2ActorViewType=false
    Texture=Texture'S_Emitter'
    TranslucentRenderPriority=-1
    bUnlit=true
}