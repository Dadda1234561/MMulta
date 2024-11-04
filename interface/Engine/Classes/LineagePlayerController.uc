//=============================================================================
// PlayerController
//
// PlayerControllers are used by human players to control pawns.
//
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class LineagePlayerController extends PlayerController
	native;
	
//#ifdef __L2 // by ttmayrin
enum EFixedCameraType
{
	FCT_Pawn,
	FCT_VehicleRider,
	FCT_VehicleController,
	FCT_FlightTransform,
	FCT_FlyMove,
};

enum ESoundFileType
{
	SFT_None,
	SFT_Streaming,
	SFT_Packaging,
};


//#endif

var transient float RollSpeed;
var transient bool bClockWiseRoll;
var transient bool bAntiClockWiseRoll;

var transient vector CameraEffectInfoPivot;
		
var bool bFixCameraRotation;
var config	int		CheatFlyYaw;
var config	float	AutoTrackingPawnSpeed;		//???????? ????
var config	int		VolumeCameraRadius;			//VolumeCamera?? Rotation
var config	int		HitCheckCameraMinDist;		//HitCheckCamera?? ???????? ???? ???? ??????
var config	int		FixedDefaultViewNum;		//?????? DefaultCamera ????
var config	int		FixedDefaultGroupNum;		//?????? DefaultCamera ????????
var config	int		FixedDefaultCurrentGroup;	//?????? DefaultCamera ????????
var config	int		FixedDefaultCameraYaw[15];
var config	int		FixedDefaultCameraPitch[15];
var config	float	FixedDefaultCameraDist[15];
var config	float	FixedDefaultCameraViewHeight[15];
var config	int		FixedDefaultCameraHidePlayer[15];
var config	int		FixedDefaultCameraDisableZoom[15];
//#ifdef __L2 // by ttmayrin
var config	int		FixedDefaultCameraExteriorView[15];
var config	int		FixedDefaultCameraMinDist[15];
var config	int		FixedDefaultCameraMaxDist[15];
var config	int		FixedDefaultCameraDisablePitch[15];
//#endif
var	config	float	CameraViewHeightAdjust;		//ViewTarget ????????
var config	bool	bUseAutoTrackingPawn;		//?????????? ?????? ???????
var config	bool	bUseVolumeCamera;			//VolumeCamera?? ?????? ???????
var config	bool	bUseHitCheckCamera;			//HitCheckCamera?? ?????? ???????
var config	bool	bUseExteriorView;			//ViewTarget?? ?????? ???? Camera?? ?????? ???????

var			bool	bDisableCameraManuallyRotating;//???????? Manually ?????? Disable???????
var			bool	bCameraManuallyRotating;	//???????? Manually ???????????????
var			int		CameraManuallyRotatingDelta;//???????? Manually ???????? ?????? ??????????..
var			bool	bCameraManuallyZoomed;		//Camera is manually zoomed in or out
var			bool	bFixView;					//???? ???????????
var			bool	bCameraMovingToDefault;		//Camera?? Default?? ???????????
var			bool	bUseDefaultCameraYaw;		//DefalutCamera?? Yaw?? ???????????
var			bool	bUseDefaultCameraPitch;		//DefalutCamera?? Pitch?? ???????????
var			bool	bUseDefaultCameraDist;		//DefalutCamera?? Dist?? ???????????
var			bool	bDisableZoom;
var			bool	bDisablePitch;

var			bool	bCameraSpecialMove;
var			bool	bCameraMovingToSpecial;

var			bool	bKeyboardMoving;
var			bool	bDesiredKeyboardMoving;
var			bool	bRequestKeyboardMoving;
var			bool	bMovingPermanently;
var			bool	bDesiredMovingPermanently;
var			bool	bMovingPermanentlyLeftMouseOn;
var			bool	bMovingPermanentlyRightMouseOn;
var			bool	bJoypadMoving;
var			bool	bDesiredJoypadMoving;

var			bool	ShouldTurnToMovingDir;

var			bool	bFromCharacterCreateToLobby;	//?????? ???????? ?????? ?????? ?? Turn On ????.
//#ifdef __L2 // zodiac
var bool			bObserverModeOn;
var bool			bBroadcastObserverModeOn;
var bool			bCanPlayMusic;
var bool			bVehicleStart;
var bool			bGetServerMusic;
var bool			bLockMusic;
//#endif

//branch - ???? ???? ?????????? ???????????? ???? ?? ??????.
var bool		br_bGetItemMusic;
var bool		br_bLoopItemMusic;
var bool		br_bLockMusic;
//end of branch

//#ifdef __L2 // idearain
var bool			bCameraWalking;				// CameraWalkingMode ?????
//#endif

var			bool	bBlending;					//???????? ??????????????
var			float   BlendingTime;				//?????? ???????? ???????? ????
var			float   AccBlendingTime;			//???????? ?????? ????

var			vector	BlendingStartLocation;		//?????? ???????? ?????? ????
var			rotator BlendingStartRotation;		//?????? ???????? ?????? ????

var			float	OldZoomingDist;				//???? Tick?????? ZoomingDist
var			vector	OldCameraLocation;			//???? Tick?????? CameraLocation
var			rotator	OldCameraRotation;			//???? Tick?????? CameraRotation
var			vector	OldViewTargetLocation;		//???? Tick?????? ViewTargetLocation

var			float	ManuallyCameraYaw;			//???????? Manually Yaw ??????
var			float	ManuallyCameraPitch;		//???????? Manually Pitch ??????
var			float	CurZoomingDist;				//???? Zoom ????
var			float	PrevDesiredZoomingDist;		//?????? User ???? Zoom ????
var			float	DesiredZoomingDist;			//User ???? Zoom ????
var			int		DesiredPitch;				//User ???? Pitch
var			int		CurVolumeCameraRadius;		//???? Zoom ????

var			int		PrevFixedDefaultCameraNo;	//?????? ?????? DefaultCamera ????
var			int		CurFixedDefaultCameraNo;	//?????? ?????? DefaultCamera ????
var			int		DefaultCameraYaw;			//bDefaultCamera?? ???? Yaw
var			int		DefaultCameraPitch;			//bDefaultCamera?? ???? Pitch
var			float	DefaultCameraDist;			//bDefaultCamera?? ???? Dist
var			float	HitCheckCameraDist;			//???????? ???? ?????? ?????? ?????????? ????
var			float	HitCheckCameraReturnDist;	//???????? ???? ?????? ???????? ???????? ?????? ????
var			float	CameraViewDeltaTime;

var			int		SpecialCameraYaw;
var			int		SpecialCameraPitch;
var			float	SpecialCameraDist;
var			float	SpecialCameraDistSpeed;
var			int		SpecialCameraYawSpeed;
var			int		SpecialCameraPitchSpeed;
var			float	SpecialCameraDuration;
var			int		SpecialCurCameraYaw;
var			int		SpecialCurCameraPitch;
var			float	SpecialCurCameraDist;

var			int		CameraRelYaw;
var			int		CameraRelPitch;
var			int		CameraRelRoll;
var			int		CameraRelYawSpeed;
var			int		CameraRelPitchSpeed;
var			int		CameraRelRollSpeed;
var			int		CameraCurRelYaw;
var			int		CameraCurRelPitch;
var			int		CameraCurRelRoll;

//var			float	OriFovAngle;

var			int		SavedViewTargetYaw;			//bDefaultCamera?? ???????? ?????? ViewTarget?? Yaw
var			int		SavedViewTargetPitch;		//bDefaultCamera?? ???????? ?????? ViewTarget?? Pitch

var			float	ValidateLocationTime;

var			int		KeyboardMovingDir;
var			int		KeyboardMovingDirFlg;
var			float	KeyboardMovingPendingTime;
var			bool	bKeyboardTurning;
var			bool	bKeyboardTurningLeftOn;
var			bool	bKeyboardTurningRightOn;
var			float	MovingPendingTime;
var			float	DirectionalMovePendingTime;
var			float	TurningMovePendingTime;
var			int		JoypadMovingDir;
var			float	JoypadMovingPendingTime;

//#ifdef __L2 //kurt
var	config	float   MaxZoomingDist;
var			float   MinZoomingDist;
enum ENPCZoomCameraMode
{
	NZCM_ZoomIn,
	NZCM_ZoomingIn,
	NZCM_ZoomingOut,
	NZCM_Normal
};
var		ENPCZoomCameraMode	NpcZoomCamMode;
struct NViewShakePtr
{
	var	int		Ptr;
};
var array<NViewShakePtr>	NViewShake;
struct NViewShakeMgrPtr
{
	var	int		Ptr;
};
var array<NViewShakeMgrPtr>	NViewShakeMgr;
//#endif

//#ifdef __L2 // zodiac
var MusicVolume		MusicVolume;
var float			MusicWaitTime;
var float			DefaultMusicWaitTime;
var int				MusicHandle;
var int				VoiceHandle;
var ESoundFileType	SoundFileType;
var float			PlayMusicDelay;
var float			PlayVoiceDelay;
var string			bServerMusicName;
var string			bServerVoiceName;
//#endif

//#ifdef __L2 // idearain
var Actor			CameraModeTarget;
//#endif
//#ifdef __L2 // gigadeth
var float			ManuallyCameraSpeed;	// ?????? ?????? ???? Default=1.0
//#endif

//#ifdef __L2 // by nonblock
var(AirVolume) AirEmitter			AirEffect;
//var(AirVolume) transient	name	RecentAirEffect;
//var(AirVolume) transient	bool	bWasInAirVolume;
//var(AirVolume) transient	float	TimeTouching;
//var(AirVolume) transient	bool	DoNotSpawn;				// don't try to spawn aireffect until the player leaves the volume.
//#endif

//#ifdef __L2 // anima
var		vector	CurrentShakeEpicenter;		// ???? ?????? ???? ???? Shake Emitter?? ????
//#endif

//#ifdef __L2 // anima
//var		bool	bCalcCameraLocationWithBone;		// ???????? ?????? TargetActor?? ???? Bone?? ???????? ????
//var		ECameraLocationType		eCameraLocType;
var		rotator	FixedRotation;
var		int		CalcBoneIndex;						// ???? Bone Index

var		int		ViewTargetBoneIndex;
var		int		LocationBoneIndex;

var		name	CalcBoneAnimName;					// ?????? ???????? Animation Name
//#endif
//#ifdef __L2 // ttmayrin
var float	ElasticCameraDist;
var float	ElasticCameraAccel;
var	float	ElasticCameraVel;
var float	ElasticCameraOldDist;
//#endif

//#ifdef __L2 // jumper
var vector SavedZoomOutCamLoc;
var rotator SavedZoomOutCamRot;
var vector ZoomCameraLoc;
var rotator ZoomCameraRot;
var vector ZoomCamDeltaLocPerTime;
var rotator ZoomCamDeltaRotPerTime;
var float	m_CameraZoomingDuration;
//#endif

var bool bCrowdControl;							// ???? ???? ???? ????, sunrice
event PostBeginPlay()
{
}

exec function HidePlayerPawn()
{
	Pawn.bHidden = true;
}

exec function ShowPlayerPawn()
{
	Pawn.bHidden = false;
}

exec function SetFlyYaw(int Value)
{
	CheatFlyYaw = Value;
}
/// DO NOT USE these functions. It's replaced by UInput Command.
//exec function CameraRotationOn()
//{
//	if( bCameraMovingToSpecial || bCameraSpecialMove || bDisableCameraManuallyRotating || bCameraMovingToDefault ) return;
//	bCameraManuallyRotating = true;
//}
//
//exec function CameraRotationOff()
//{
//	bCameraManuallyRotating = false;
//}
//
//exec function UseAutoTrackingPawnOn()
//{
//	bUseAutoTrackingPawn = true;
//}
//
//exec function UseAutoTrackingPawnOff()
//{
//	bUseAutoTrackingPawn = false;
//}

exec function UseHitCheckCameraOn()
{
	bUseHitCheckCamera = true;
}

exec function UseHitCheckCameraOff()
{
	bUseHitCheckCamera = false;
}

exec function SetHitCheckCameraMinDist(int Delta)
{
	HitCheckCameraMinDist += Delta;
}

exec function ViewFix()
{
	if( bFixView ) bFixView = false;
	else bFixView = true;
}


// Decompiled with UE Explorer.
defaultproperties
{
    bCanPlayMusic=true
    br_bLoopItemMusic=true
    BlendingTime=1
    DirectionalMovePendingTime=1
    TurningMovePendingTime=0.2
    MinZoomingDist=-200
    MusicHandle=-1
    VoiceHandle=-1
    ManuallyCameraSpeed=1
    DesiredFOV=60
    DefaultFOV=60
    bMyController=true
}