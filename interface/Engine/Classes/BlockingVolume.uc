//=============================================================================
// BlockingVolume:  a bounding volume
// used to block certain classes of actors
// primary use is to provide collision for non-zero extent traces around static meshes 

//=============================================================================

class BlockingVolume extends Volume
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var() bool bClampFluid;
var() bool bClassBlocker; // sjs
var() Array< class<Actor> > BlockedClasses; // sjs


// Decompiled with UE Explorer.
defaultproperties
{
    bClampFluid=true
    bWorldGeometry=true
    bBlockActors=true
    bBlockPlayers=true
    bBlockZeroExtentTraces=false
    bBlockKarma=true
}