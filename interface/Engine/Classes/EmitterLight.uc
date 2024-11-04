//=============================================================================
// The EmitterLight class.
//=============================================================================
class EmitterLight extends Light
	native;

var(EmitterLight) enum EEmitterLightType
{	
	EEL_PawnOnly,
	EEL_WorldOnly,
	EEL_All,
	
} EmitterLightType;


// Decompiled with UE Explorer.
defaultproperties
{
    bStatic=false
    bNoDelete=false
    bDynamicLight=true
}