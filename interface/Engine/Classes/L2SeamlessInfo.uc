class L2SeamlessInfo extends Info
	native
	placeable;

#exec Texture Import File=Textures\SeamlessInfo.pcx Name=S_L2SeamlessInfo Mips=Off MASKED=1

var() float AffectRange;
var() int MapX;
var() int MapY;
var() vector AffectBox;
var() bool bUseAffectBox;
var bool bLoaded;


// Decompiled with UE Explorer.
defaultproperties
{
    Texture=Texture'S_L2SeamlessInfo'
}