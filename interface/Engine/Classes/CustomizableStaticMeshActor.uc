//=============================================================================
// CustomizableStaticMeshActor.
// An actor that is drawn using a static mesh(a mesh that never changes, and
// can be cached in video memory, resulting in a speed boost).
//=============================================================================

class CustomizableStaticMeshActor extends StaticMeshActor
	native
	placeable;
	
//
// To-do : static mesh actor?? agit?? ???????? ??.
//


var transient Name	UserDefinableTextureName;
var transient Name	OldUserDefinableTextureName;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)



// Decompiled with UE Explorer.
defaultproperties
{
    bStatic=false
}