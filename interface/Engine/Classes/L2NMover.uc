//=============================================================================
// NMover.
//=============================================================================
class L2NMover extends Actor
	native;

struct NMoverTarget
{
	var int bTarget;
	var int bOwnedTarget;
	var vector Loc;
	var actor Target;
};

var bool bLoop;
var bool bMoveStart;
var bool bMoveEnd;
var bool bMovePause;
var float MoveStartDelay;
var vector OwnerOrigin;
var int TargetIndex;
var array<NMoverTarget> MoverTargets;
var float MoveSpeed;
var float CurMoveSpeed;
var float AccelRate;
var float AccelAccelRate;
var float CurAccelRate;
var float MaxSpeed;
var float MinSpeed;
var float MaxAccelRate;
var float MinAccelRate;
var actor ForceBounceActor;
var float MoveDuration;
var float CurMoveTime;


// Decompiled with UE Explorer.
defaultproperties
{
    MoveSpeed=100
    MaxSpeed=2000
    MinSpeed=1
    MaxAccelRate=1000
    MinAccelRate=-1000
    bHidden=true
    CollisionRadius=1
    CollisionHeight=1
}