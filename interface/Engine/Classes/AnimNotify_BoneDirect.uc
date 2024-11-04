
class AnimNotify_BoneDirect extends AnimNotify
	native;

var()	float	StartFrameIndex;
var()	float	PeakFrameIndex;
var()	float	EndFrameIndex;

var()	int		BoneIndex;

// only for targeting(default)
// (maybe) to-do : using fixed input data
enum PartialBoneDirectorType
{
	PBDT_RelativeTarget,
};
var()	PartialBoneDirectorType BoneDirectorType;

var(WorldTranslation)	bool EnableWorldTrans;
var(WorldTranslation)	float LeastDistance;
var(WorldTranslation)	vector WorldTransDirection;

var(WorldRotation)	bool EnableWorldRot;
var(WorldRotation)	float GreatestAngle;
var(WorldRotation)	vector WorldRotateAxis;

var(LocalRotation)	bool EnableLocalRot;
var(LocalRotation)	rotator LocalRotator;
var(LocalRotation)	float LocalRotateSpeed;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

