//=============================================================================
// Moon
// 
//=============================================================================
class NMoon extends Actor
	placeable
	native;

var(Display)		float	Radius;
var					float	Latitude;
var					float	Longitude;
var(Display)		float	LimitMaxRadius;
var(Display)		float	MoonScale;
var					bool	bMakeLightmap;
var					vector  Position;
var(Display)		bool    bMoonLight;
var(Display)		int		EnvType;
var(Display)		texture	Flame[12];
var(LightColor)		byte	LightHue, LightSaturation;
var(LightColor)		float	LightBrightness;


// Decompiled with UE Explorer.
defaultproperties
{
    Radius=32768
    LimitMaxRadius=32768
    MoonScale=1
    bAcceptsProjectors=false
    bNetTemporary=true
    bIgnoredRange=true
    bGameRelevant=true
    bDirectional=true
}