//=============================================================================
// SkyMeshActor 
// Ignore Range Clipping and always use Zero Lod Model
//=============================================================================

class SkyMeshActor extends StaticMeshActor
	native
	placeable;

var(Display)	bool	IsSkyDorm;
var(Display)	float	DormRadius;

// Decompiled with UE Explorer.
defaultproperties
{
    DormRadius=240
    bStatic=false
    bUnlit=true
    bIgnoredRange=true
}