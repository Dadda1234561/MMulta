//=============================================================================
// The brush class.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Brush extends Actor
	native;

//-----------------------------------------------------------------------------
// Variables.

// CSG operation performed in editor.
var() enum ECsgOper
{
	CSG_Active,			// Active brush.
	CSG_Add,			// Add to world.
	CSG_Subtract,		// Subtract from world.
	CSG_Intersect,		// Form from intersection with world.
	CSG_Deintersect,	// Form from negative intersection with world.
} CsgOper;

// Outdated.
var const object UnusedLightMesh;
var vector  PostPivot;

// Scaling.
// Outdated : these are only here to allow the "ucc mapconvert" commandlet to work.
//            They are NOT used by the engine/editor for anything else.
var scale MainScale;
var scale PostScale;
var scale TempScale;

// Information.
var() color BrushColor;
var() int	PolyFlags;
var() bool  bColored;


// Decompiled with UE Explorer.
defaultproperties
{
    MainScale=(Scale=(X=3.498596E-35,Y=1,Z=1),SheerRate=1,SheerAxis=112)
    PostScale=(Scale=(X=3.498596E-35,Y=1,Z=1),SheerRate=1,SheerAxis=112)
    TempScale=(Scale=(X=3.498596E-35,Y=1,Z=1),SheerRate=1,SheerAxis=112)
    DrawType=3
    bStatic=true
    bHidden=true
    bNoDelete=true
    bFixedRotationDir=true
    bEdShouldSnap=true
}