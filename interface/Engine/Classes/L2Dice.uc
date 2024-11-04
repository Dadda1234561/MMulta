class L2Dice extends Actor
	placeable
	native
	nativereplication;
	
struct NActionPtr
{
	var	int		Ptr;
};

var rotator TargetRotation;
var rotator DeltaRotation;
var sound	DropSound;
var vector	CheckLocation;
var NActionPtr Action;	
var bool bActionOn;


// Decompiled with UE Explorer.
defaultproperties
{
    bNeedCleanup=false
    NoCheatCollision=true
    bOrientOnSlope=true
    bAlwaysRelevant=true
    bCheckChangableLevel=true
    NetUpdateFrequency=8
    NetPriority=1.4
    Texture=Texture'S_Inventory'
    CollisionRadius=0.1
    CollisionHeight=0.1
    bCollideActors=true
    bProjTarget=true
    bFixedRotationDir=true
}