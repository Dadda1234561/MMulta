class L2FogInfo extends Info
	noexport
	showcategories(Movement)
	native
	placeable;

#exec Texture Import File=Textures\S_L2FogInfo.tga Name=S_L2FogInfo Mips=Off MASKED=1

struct L2EnvironmentColorInfo
{
	var() float Time;
	var() color FogColor;
	var() color SkyColor;
	var() array<color> CloudColor;
	var() array<color> HazeRingColor;
};

var() range AffectRange;
var() range FogRange1;
var() range FogRange2;
var() range FogRange3;
var() range FogRange4;
var() range FogRange5;
var() float TextureDistance;
var() array<L2EnvironmentColorInfo> Colors;
var() Material CloudTexture;
var() vector AffectBoxMin;
var() vector AffectBoxMax;
var() bool bUseAffectBox;
var() bool bUseFogInfo;
var() bool bUseRangeOnly;


// Decompiled with UE Explorer.
defaultproperties
{
    bUseFogInfo=true
    Texture=Texture'S_L2FogInfo'
}