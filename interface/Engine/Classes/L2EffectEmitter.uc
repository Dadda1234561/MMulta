class L2EffectEmitter extends Object	
	native
	dynamicrecompile
	//abstract
	editinlinenew	
	hidecategories(Object)
	collapsecategories;	


enum AttachMethod
{	
	AM_None,				// don't attach
	AM_Location,			// don't attach, there is no target, spawn with received location
	AM_RH,					// attach to GetRHandBoneName()
	AM_LH,					// attach to GetLHandBoneName()
	AM_RA,					// attach to GetRArmBoneName()
	AM_LA,					// attach to GetLArmBoneName()
	AM_Wing,				// attach to GetWingBoneName()
	AM_BoneSpecified,		// attach to this.AttachBoneName
	AM_AliasSpecified,		// attach to TagAlias(AttachBoneName)
	AM_Trail,				// don't attach, trail the targetactor( assume physics of the emitter is PHYS_Trailer )
	AM_BoneLocation,		// don't attach, but spawn on AttachBoneName
	AM_AliasLocation		// don't attach, but spawn on TagAlias(AttachBoneName)
	//branch
	, AM_Agathion			// attach to AttachBoneName in Agathion
	, AM_DependOnMagicInfoInClient	// 
	//end of branch
};

enum EGPawnLightType
{
	EPLT_DAMAGE,
	EPLT_ABNORMAL,
	EPLT_SKILL	
};

struct native EffectPawnLightParam
{
	var()	EGPawnLightType			PawnLightType;
	var()	Light.ELightType		LightType;
	var()	Light.ELightEffect		LightEffectType;
	var()	plane					LightColor;
	var()	float					LightLifeTime;
	var()	float					LightRadius;
	var()	ParticleEmitter.EParticleCoordinateSystem	LightCoordSystem;
};

enum EtcEffectType
{
	EET_None,
	EET_FireCracker,			// ????
	EET_SoulShot,				// ??????
	EET_SpiritShot,				// ??????, ????????
	EET_Cubic,					// ????
	EET_SoundCrystal,			// ????????
	EET_JewelShot,				// ?????? ???? ???? ?????? - by y2jinc
	EET_PetJewelShot,			// ?? ???? ????(?????? ???? ???? ??????) - by y2jinc
};

enum EtcEffectParam
{
	EEP_None,
	EEP_FireCrackerSmall,
	EEP_FireCrackerMiddle,
	EEP_FireCrackerLarge,
	EEP_GradeNone,			// ??????, ??????,????????, ????
	EEP_GradeD,
	EEP_GradeC,
	EEP_GradeB,
	EEP_GradeA,
	EEP_GradeS,
	EEP_GradeR,
};


////////////////////////////////////////////////////////////////////////////////
// attach
////////////////////////////////////////////////////////////////////////////////
var(attach)		AttachMethod		AttachOn;
var(attach)		name				AttachBoneName;
var(attach)		bool				bAbsolute;


////////////////////////////////////////////////////////////////////////////////
// positioning
////////////////////////////////////////////////////////////////////////////////
var(positioning)		rotator				RelativeRotation;
var(positioning)		vector				offset;
var(positioning)		bool				bSpawnOnTarget;
var(positioning)		bool				bRelativeToCylinder;
var(positioning)		bool				bOnMultiTarget;
var(positioning)		bool				bChaining;					// Use When MagicType is SKT_CHAINLIGHTING
var(positioning)		bool				bChangeHand;				// Use When MagicType is SKT_DOUBLESHOT 
var(positioning)		bool				bUseOffsetNative;			// Use When AttachMethod is AM_Location
var(positioning)		bool				bMultiLocation;				// Use When AttachMethod is AM_Location


////////////////////////////////////////////////////////////////////////////////
// emitter
////////////////////////////////////////////////////////////////////////////////
var(emitter)			bool				bAdjustLifeTime;
var(emitter)			bool				bRibbonSet;
var(emitter)			bool				bChanneling;
var(emitter)			bool				bAsyncLifeTime;			//SKT_UNIONSUMMON ?????? ChannelingActor?? LifeTime ???? ????
var(emitter)			bool				bMyUnionTargetAction;	//UnionTargetAction?? ???? ?????? ?????? ??????
var(emitter)			bool				bShotAndDrain;
var(emitter)			bool				bSkipAbsorbEffect;		//?????? ???????? ????????. 
var(emitter)			float				ScaleSize;
var(emitter)			float				SpawnDelay;
var(emitter)			class<Emitter>		EffectClass;
var(emitter)			class<Emitter>		SimpleEffectClass;

////////////////////////////////////////////////////////////////////////////////
// ???????????? ???? ???????? ???? ?????????? 2010.6 - jdh84
////////////////////////////////////////////////////////////////////////////////
var						int				EffectPawnClassID; //?????? ????????
var						bool			bEffectPawnIsNpc;  //NPCGRP?? ????????????? ?????? ?????? ???????? ????
var						name				SequenceName;	//???????? ?????????? ??????
var						float				AnimStartFrame; //???????? ???????????? ???? ??????
var						float				AnimEndFrame; //???????? ???????????? ???? ??????

////////////////////////////////////////////////////////////////////////////////
// pawnlight
////////////////////////////////////////////////////////////////////////////////
var(pawnlight)			bool					bPawnLight;
var(pawnlight)			EffectPawnLightParam	PawnLightParam;


////////////////////////////////////////////////////////////////////////////////
// interpolation
////////////////////////////////////////////////////////////////////////////////
var(interpolation)		bool				bHermiteInterpolation;		// Use Hermite Interpolation
var(interpolation)		bool				bBezierCurve;				// Use Bezier Curve
var(interpolation)		array<vector>		ControlPointOffset;			// Bezier Curve Control Point Offset


////////////////////////////////////////////////////////////////////////////////
// etc
////////////////////////////////////////////////////////////////////////////////
var(etc)				EtcEffectType			EtcEffect;
var(etc)				EtcEffectParam			EtcEffectInfo;

// For halloween event - lancelot 2009. 10. 7
var(emitter)			float				BR_ForceLifeTime;
var(emitter)			name				BR_Tag;

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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    bSpawnOnTarget=true
    bRelativeToCylinder=true
    bAdjustLifeTime=true
    EffectPawnClassID=-1
    bEffectPawnIsNpc=true
}