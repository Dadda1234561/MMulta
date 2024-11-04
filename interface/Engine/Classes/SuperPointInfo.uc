class SuperPointInfo extends Info
	showcategories(Movement)
	native
	placeable;

#exec Texture Import File=Textures\Territory_info.pcx Name=S_SuperPointInfo Mips=Off MASKED=1


enum SuperPointMoveType
{
	Follow_Rail,
	Move_Random
};

var()	string				SuperPointName;
var()	SuperPointMoveType	MoveType;
var()	array<vector>		DeltaPoint;
var()	array<vector>		AbsPoint;
var()	array<int>			Delay;
var()	color				LineColor;
var()	color				PathColor;
var()	color				FontColor;
var		int					Paths;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    LineColor=(B=10,G=10,R=255,A=255)
    PathColor=(B=10,G=255,R=10,A=255)
    FontColor=(B=10,G=255,R=10,A=255)
    bAlwaysVisible=true
    bStatic=true
    Texture=Texture'S_SuperPointInfo'
    bStaticLighting=true
}