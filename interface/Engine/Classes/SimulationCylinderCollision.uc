class SimulationCylinderCollision extends SimulationCollision
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var		float		Radius;
var		int			BoneIndexB;
var		bool		SphereA;
var		bool		SphereB;

var	transient	vector	BoneCenterB;
var	transient	vector	AB;
var	transient	vector  NomalizedAB;

// Decompiled with UE Explorer.
defaultproperties
{
    BoneIndexB=-1
}