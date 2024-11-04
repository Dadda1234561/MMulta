class SpawnedLight extends Light
	native;

var() float FadeInTime;
var() float MiddleTime;
var() float FadeOutTime;
var() float LightIntensity;

//internal
var float CurrentLightIntensity; //fade in-out ????
var float ElapsedTime; //lifetime ?? ???? lerp


// Decompiled with UE Explorer.
defaultproperties
{
    LightIntensity=1
    bStatic=false
    bNoDelete=false
    bDynamicLight=true
    bMovable=true
}