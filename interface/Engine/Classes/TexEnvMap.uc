class TexEnvMap extends TexModifier
	editinlinenew
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var() enum ETexEnvMapType
{
	EM_WorldSpace,
	EM_CameraSpace,
	EM_SphereMap,
	EM_SphereMapModulateOpacity
} EnvMapType;


// Decompiled with UE Explorer.
defaultproperties
{
    EnvMapType=1
    TexCoordCount=1
}