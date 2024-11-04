//=============================================================================
// SkyRenderInfo : The class describes sky rendering paramater
//
// Created at 2010. 4. 27. jdh84
//=============================================================================
class SkyRenderInfo extends Actor
	native
	hidecategories(Collision,Lighting,LightColor,Karma,Force)
	placeable;

#exec Texture Import File=Textures\ZoneInfo.pcx Name=S_ZoneInfo Mips=Off MASKED=1

struct native constructive SkyParameter
{
	var() bool bUseCloudColor;
	var() array<color> Cloudcolor;
	var() bool bUseHazeRingcolor;
	var() color HazeRingcolor;
	var() bool bUseBackgroundcolor;
	var() color Backgroundcolor;
	var() float	ZScale;
};

var(SkySetting) SkyParameter paramater;

var(SkySetting) enum ESkyRenderShape
{
	SRS_CIRCLE,
	SRS_RECTANGLE,	
} SkyRenderShape;


var(SkySetting) int EffectDistanceX;
var(SkySetting) int EffectDistanceY;
var(SkySetting) int GradiationDistanceY;
var(SkySetting) int GradiationDistanceX;
var(SkySetting) int EffectRadius;
var(SkySetting) int GradiationRadius;


// Decompiled with UE Explorer.
defaultproperties
{
    bHidden=true
    bNoDelete=true
    bSkipActorPropertyReplication=true
    bOnlyDirtyReplication=true
    NetUpdateFrequency=10
    Texture=Texture'S_ZoneInfo'
}