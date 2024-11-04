class SimulationNotify extends Object
	native;

var		float		Frame;
var		bool		UseForce;
var		vector		Force;
var		float		ResetFactor;
var		bool		TerrainCollision;
var		float		TerrainCollisionZ;
var		float		Stiffness;


// Decompiled with UE Explorer.
defaultproperties
{
    frame=-1
    UseForce=true
    ResetFactor=-1
    TerrainCollisionZ=0.3
    Stiffness=0.5
}