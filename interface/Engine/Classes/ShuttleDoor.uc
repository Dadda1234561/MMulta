class ShuttleDoor extends Pawn
	native;

enum DoorState
{
	DOOR_OPENING,	
	DOOR_OPENED,
	DOOR_CLOSING,	
	DOOR_CLOSED,
};

var float OpenTime;
var float CloseTime;
var float RemainTime;
var DoorState mDoorState;
var Shuttle OwnerShuttle;
var vector relOpenLocation;
var vector relCloseLocation;
var vector relSafeLocation;


native function Open();

native function Close();

// Decompiled with UE Explorer.
defaultproperties
{
    OpenTime=2
    CloseTime=2
    bCanBeBaseForPawns=true
    CollisionRadius=0
    CollisionHeight=0
    bCollideWorld=false
}