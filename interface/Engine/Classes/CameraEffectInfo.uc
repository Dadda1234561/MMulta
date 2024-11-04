//=============================================================================
// CemeraEffectInfo: ???? ?????? ?????? ?????? ???????? ???? ????
// ?????? ?????????? ????????.. ???? ???????????? ?????? ?????? ????????..
// Created at 2010. 10. 6. jdh84
//=============================================================================
class CameraEffectInfo extends Actor
	native
	hidecategories(Collision,Lighting,LightColor,Karma,Force)
	dynamicrecompile
	placeable;

#exec Texture Import File=Textures\ZoneInfo.pcx Name=S_ZoneInfo Mips=Off MASKED=1


struct native EarthQuakeParameter
{
	var() float StartTimeInSec;
	var() float MaintainTimeInSec;
	var() float ShakeAmplitude;	
	var() float Frequency;	
};

var transient float ElapsedTimeForStart;

var (EarthQuake) bool bRecursion;
var (EarthQuake) float EarthQuakeEffectDist;
var (EarthQuake) array<EarthQuakeParameter> EarthQuakeInfos;


// Decompiled with UE Explorer.
defaultproperties
{
    bRecursion=true
    EarthQuakeEffectDist=100
}