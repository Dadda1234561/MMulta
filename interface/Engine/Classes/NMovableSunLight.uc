//=============================================================================
// Movable Directional sunlight
//=============================================================================
class NMovableSunlight extends Light
	placeable
	native;

#exec Texture Import File=Textures\SunIcon.dds  Name=SunIcon Mips=Off MASKED=1

var transient vector  BeastSunLocation;
var transient rotator BeastSunRotation;


// Decompiled with UE Explorer.
defaultproperties
{
    bSunlightColor=true
    LightEffect=20
    bStatic=false
    Texture=Texture'SunIcon'
    bIgnoredRange=true
    bMovable=true
    bDirectional=true
}