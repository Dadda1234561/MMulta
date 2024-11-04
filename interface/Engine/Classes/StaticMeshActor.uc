//=============================================================================
// StaticMeshActor.
// An actor that is drawn using a static mesh(a mesh that never changes, and
// can be cached in video memory, resulting in a speed boost).
//=============================================================================

class StaticMeshActor extends Actor
	native
	dynamicrecompile
	placeable;

//#if __L2 // gigadeth
struct native AccessoryType
{
	var() int Depth;
	var() StaticMesh Mesh;
};
//#endif

struct native StaticMeshDecoInfo
{
	var float LightWeight[3];
};

struct native StaticMeshDecorationLayerData
{
	var array<DecoInfo> DecoInstances;
	var array<StaticMeshDecoInfo> StaticMeshDecoInstances;	// Deco information specific to staticmesh
};

enum EDecorationSortOrder
{
	DECOSORT_NoSort,
	DECOSORT_BackToFront,
	DECOSORT_FrontToBack,
};

enum EBeastMapScaleFactor
{
	BMSF_ONE,
	BMSF_HALF,
	BMSF_QUARTER,
	BMSF_MIN,
};

//#ifdef __L2 // zodiac agit???? ????
//var(Agit) bool bAgitDefaultStaticMesh;
var(Agit) int AgitID;
// Accessroy?? 0???? ???? ????. 0?? wallpaper???? ????????.
var(Agit) int AccessoryIndex;
var(Agit) int AgitStatus;
var(Agit) transient int CurrAccessoryType;
var(Agit) array<AccessoryType> AccessoryTypeList;
//#endif

//#if __L2 // gigadeth
//var(TimeReactor) bool bTimeReactor;
var(TimeReactor) float ShowTime;
var(TimeReactor) float HideTime;
//#endif

//#ifdef __L2 // zodiac
var(Sound) sound		StepSound_1;
var(Sound) sound		StepSound_2;
var(Sound) sound		StepSound_3;
//#endif

// flagoftiger
//var(L2ServerObject) bool				bTargetable;
var(L2ServerObject) array<StaticMesh>	StateStaticMeshs;
var(L2ServerObject) array<name>			StateChangeEffectNames;

// 2009/02/03 Static Mesh Decoration Layer - Joon Min
var(StaticMeshDeco) array<DecorationLayer> DecoLayers;
var Color DecoAmbientColor;
var array<StaticMeshDecorationLayerData> DecoLayerData;

//var() bool bExactProjectileCollision;		// nonzero extent projectiles should shrink to zero when hitting this actor
var() array<int>  ZoneRenderState;

//by elsacred 2011.10.13
//Ambient?? Diffuse&Specular?? ?????? ???????? Light?? ?????????? StaticMeshActor???? ?? ?? ???? ??????.
//Default?? 1.0???? LightIntensity?? LightMap?? ???????? ???? MovableStaticMesh & L2MovableStaticMesh?????? ?????? ??????.
var(Lighting) float AmbientIntensity;
var(Lighting) float LightIntensity;

// bool ???? ???????? ???????? ??????
var(Agit) bool bAgitDefaultStaticMesh;
var(TimeReactor) bool bTimeReactor;
var(L2ServerObject) bool				bTargetable;
var() bool bExactProjectileCollision;
// by sunrice 2013.9.
// StaticmMeshInstance?? ColorStream?? ???? ?????? ???? Sunlight ?????? ???????? ??????. ?? ?????? ???????? ???? ??????
// EnableCollisionforShadow ???????? ???????? ?????????? ???? ???? ????.
var(Lighting) bool	bDynamicSunlight;
var			  bool	bDynamicSunlightForPostEditLoad;	// ???????? bDynamicSunlight ???????? Material?? ???????? PostEditLoad()???? ??????

// ???????? ???????? #3659
var(Lighting) EBeastMapScaleFactor BeastMapScaleSunLight;
var(Lighting) EBeastMapScaleFactor BeastMapScaleLocalLight;


// Decompiled with UE Explorer.
defaultproperties
{
    AmbientIntensity=1
    LightIntensity=1
    bTargetable=true
    bExactProjectileCollision=true
    DrawType=8
    bStatic=true
    bWorldGeometry=true
    bShadowCast=true
    bStaticLighting=true
    CollisionRadius=1
    CollisionHeight=1
    bCollideActors=true
    bBlockActors=true
    bBlockPlayers=true
    bBlockKarma=true
    bEdShouldSnap=true
}