
class L2Pickup extends Actor
	placeable
	native
	nativereplication;
	
var rotator TargetRotation;
var rotator DeltaRotation;
var sound	DropSound;
//__L2 kurt
var bool	bPendingDrop;
var Emitter	DropEffectActor;
var bool	bDropEffectActor;
var vector	CheckLocation;


simulated function Timer()
{
	if(bPendingDrop)	
		bHidden=False;		
}


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