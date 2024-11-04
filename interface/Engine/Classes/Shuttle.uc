class Shuttle extends Pawn
	native;

var bool bStart;
var() array<ShuttleWall> WallList;
var() array<ShuttleDoor> DoorList;
var() array<string> DoorMeshNameList;
var AmbientSoundObject ShuttleAmbientSound;
var int ShuttleSoundVol;
var int ShuttleSoundVolWhenStop;
var int ShuttleSoundRadii;
var sound ShuttleStartSound;
var sound ShuttleStopSound;

event OnClose()
{
	local int doornum;
	local int dooridx;
	doornum = DoorList.Length;
	
	for(dooridx = 0; dooridx < doornum ; dooridx++)
	{
		DoorList[dooridx].Close();
	}
}

event OnOpen()
{

	local int doornum;
	local int dooridx;
	doornum = DoorList.Length;

	for(dooridx = 0; dooridx < doornum ; dooridx++)
	{
		DoorList[dooridx].Open();
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    bAsTreatWorld=true
    bCanBeBaseForPawns=true
    bIgnoreEncroachers=true
    CollisionRadius=0
    CollisionHeight=0
    bCollideWorld=false
}