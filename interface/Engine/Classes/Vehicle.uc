class Vehicle extends Pawn
	abstract
	dynamicrecompile
	native;

enum EVehicleType
{
	VT_NONE,
	VT_PASSENGER_SHIP,
	VT_AIR_SHIP,
	VT_SHUTTLE
};
struct native constructive VehiclePartInfo
{
	var actor	PartActor;
	var int		PartID;
	var int		MeshID;
	var int		ServerID;
	var vector	Offset;
	var bool	bAnimation;
};
var array<VehiclePartInfo> VehiclePartList;

//Vehicle Info
var EVehicleType Type;
var Pawn DriverPawn;
var int DriverID;
var array<int> PassengerIDList;
var int MaxHP;
var int CurHP;
var int MaxFuel;
var int CurFuel;

var class<VehiclePart> PartClass[16];
var VehiclePart VehicleParts[16];
var vector PartOffset[16];
var int NumParts;

var bool bActivated;
var bool bUpdating;		// true if any parts are updating

function PostBeginPlay()
{
	local int i;
	local vector RotX, RotY, RotZ;

	Super.PostBeginPlay();

	GetAxes(Rotation,RotX,RotY,RotZ);

	for ( i=0; i<16; i++ )
	{
		if ( PartClass[i] != None )
		{
			VehicleParts[i] = spawn(PartClass[i],self,,Location+PartOffset[i].X * RotX + PartOffset[i].Y * RotY + PartOffset[i].Z * RotZ);
			if ( VehicleParts[i] == None )
				log("WARNING - "$PartClass[i]$" failed to spawn for "$self);
			VehicleParts[i].SetRotation(Rotation);
			VehicleParts[i].SetBase(self);
			NumParts++;
		}
		else
			break;
	}
}

/* PointOfView()
called by controller when possessing this vehicle
true (3rd person) for vehicles by default
*/
simulated function bool PointOfView()
{
	return true;
}

function Tick(Float DeltaTime)
{
	local int i;
	
	bUpdating = false;
	for ( i=0; i<NumParts; i++ )
		if ( (VehicleParts[i] != None) && VehicleParts[i].bUpdating )
		{
			VehicleParts[i].Update(DeltaTime);
			bUpdating = true;
		}

	if ( bUpdating )
	{
		if ( Physics == PHYS_None )
			SetPhysics(PHYS_Rotating);
	}
//	else if ( Physics == PHYS_Rotating )
//		SetPhysics(PHYS_None);
}

Auto State Startup
{
	function Tick(Float DeltaTime)
	{
		local int i;
		
		bUpdating = false;
		for ( i=0; i<NumParts; i++ )
			if ( (VehicleParts[i] != None) && VehicleParts[i].bUpdating )
			{
				VehicleParts[i].Update(DeltaTime);
				bUpdating = true;
			}
	}

Begin:
	GotoState('');
}


// Decompiled with UE Explorer.
defaultproperties
{
    ControllerClass=none
    Physics=4
    bOwnerNoSee=false
}