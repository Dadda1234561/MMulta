class AnimNotify_CameraLocation extends AnimNotify
	native;

//#ifdef __L2	jumper
enum ECameraLocationType
{
    CLT_None,
	CLT_WatchBone,
	CLT_MoveToBone,
	CLT_Both,
	CLT_SpawnCameraPawn,
};
//#endif

var()		int		BoneIndex;
var()		int		ViewTargetBoneIndex;
var()		int		LocationBoneIndex;
//var()		bool	bCalcWithBone;
var()		ECameraLocationType		eCameraLocType;
var()		rotator		FixedRotation;
var()		string	CameraPawnAniName;
var()		float	CameraPawnAniScale;
var()		vector  CameraPawnSpawnOffset;
var()		bool	bPlayerAnimationOnly;
var()		float	ReturningTime;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    CameraPawnAniScale=1
}