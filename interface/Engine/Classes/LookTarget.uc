//=============================================================================
// LookTarget
//
// A convenience actor that you can point a matinee camera at.
//
// Isn't bStatic so you can attach these to movers and such.
//
//=============================================================================
class LookTarget extends KeyPoint
	native;

// Sprite.
#exec Texture Import File=Textures\LookTarget.pcx Name=S_LookTarget Mips=Off MASKED=1


// Decompiled with UE Explorer.
defaultproperties
{
    bStatic=false
    bNoDelete=true
    Texture=Texture'S_LookTarget'
}