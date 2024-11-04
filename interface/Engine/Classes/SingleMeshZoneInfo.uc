class SingleMeshZoneInfo extends Info
	noexport
	showcategories(Movement)
	native
	placeable;

#exec Texture Import File=Textures\ZoneInfo.pcx Name=S_ZoneInfo Mips=Off MASKED=1

var() range AffectRange;
var() vector AffectInnerBox;
var() vector AffectOuterBox;

var() bool bUseAffectBox;

