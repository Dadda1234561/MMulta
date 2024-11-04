//=============================================================================
// The light class.
//=============================================================================
class Light extends Actor
	placeable
	native;

#exec Texture Import File=Textures\S_Light.pcx  Name=S_Light Mips=Off MASKED=1


// __L2 gigadeth
var	bool bSunlightColor;
var(Lighting) bool bTimeLight;
var(Lighting) float LightOnTime;
var(Lighting) float LightOffTime;
var float LightPrevTime;
var float LightLifeTime;

var (Corona)	float	MinCoronaSize;
var (Corona)	float	MaxCoronaSize;
var (Corona)	float	CoronaRotation;
var (Corona)	float	CoronaRotationOffset;
var (Corona)	bool	UseOwnFinalBlend;
var (Corona)	float	CoronaRadius;

//Use only this propertys in Beast.

var (Beast)		bool	bBSTEnable;
var (Beast)		float	BSTIntensity;
var (Beast)		float	BSTDirectLightScale;
var (Beast)		float	BSTIndirectLightScale;
var	(Beast)		bool	bBSTBakeDirectLight;

var (Beast)		bool	bBSTVisibleForEye;
var (Beast)		bool	bBSTVisibleForRefl;
var (Beast)		bool	bBSTVisibleForRefr;
var (Beast)		bool	bBSTVisibleForGI;

//Use only this peoperty in Beast.
var (Beast)		bool	bBSTCastShadow;
var (Beast)		float	BSTShadowAngle;
var (Beast)		float	BSTShadowRadius;


// Decompiled with UE Explorer.
defaultproperties
{
    MaxCoronaSize=1000
    bBSTEnable=true
    BSTIntensity=1
    BSTDirectLightScale=1
    BSTIndirectLightScale=1
    bBSTBakeDirectLight=true
    bBSTVisibleForEye=true
    bBSTVisibleForRefl=true
    bBSTVisibleForRefr=true
    bBSTVisibleForGI=true
    bBSTCastShadow=true
    BSTShadowAngle=1
    BSTShadowRadius=1
    LightType=1
    LightBrightness=64
    LightRadius=64
    LightSaturation=255
    LightPeriod=32
    LightCone=128
    bStatic=true
    bHidden=true
    bNoDelete=true
    Texture=Texture'S_Light'
    bMovable=false
    CollisionRadius=24
    CollisionHeight=24
}