//__L2 kurt
class NProjectile extends Emitter
	dynamicrecompile
	native;

// Motion information.
var		float   Speed;               // Initial speed of projectile.
var		float   AccSpeed;            // Limit on speed of projectile (0 means no limit)

var		Actor	TargetActor;
var		vector LastTargetLocation;
var		rotator	LastTargetRotation;	// by nonblock
var     Actor	TraceActor;

var		bool	 bTrackingCamera;
var		bool	 bPreDestroy;

//#ifdef __L2 by nonblock
var(interpolation)		bool	 bHermiteInterpolation;
var(interpolation)		vector	 VelInitial;
var(interpolation)		vector	 VelFinal;
var(interpolation)		vector	 LocInitial;
var(interpolation)		float	 Duration;
var(interpolation)		transient	float	CurTime;
var(interpolation)		float	 Disp;
//var(interpolation)		range	DurationRange;
//var(interpolation)		float	DurationCoef;
var transient NMagicInfo     MagicInfo;
//#endif

// #ifdef __L2 // anima - ?????? ????
var(interpolation)		bool				bBezierCurve;
var(interpolation)		array<vector>		ControlPoints;
// #endif

//?????????? ???? ????
var	int				EffectPawnClassID; //?????? ????????
var	bool			bEffectPawnIsNpc;  //NPCGRP?? ????????????? ?????? ?????? ???????? ????
var	name			SequenceName;	//???????? ?????????? ??????
var Pawn			ProjectilePawn;
var vector			ProjectilePawnOffset;
var float			ProjectilePawnScale;
//

var transient	float	LifetimeAfterHit;

simulated event	ShotNotify();

// __L2 by nonblock
simulated event PreshotNotify(Pawn Attacker);
// #endif



// Decompiled with UE Explorer.
defaultproperties
{
    Speed=10
    AccSpeed=10
    EffectPawnClassID=-1
    bEffectPawnIsNpc=true
    ProjectilePawnScale=1
    bNoDelete=false
    LifeSpan=100
    CollisionRadius=5
    CollisionHeight=5
}