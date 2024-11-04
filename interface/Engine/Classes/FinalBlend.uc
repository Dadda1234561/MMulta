class FinalBlend extends Modifier
	showcategories(Material)
	native;

enum EFrameBufferBlending
{
	FB_Overwrite,
	FB_Modulate,
	FB_AlphaBlend,
	FB_AlphaModulate_MightNotFogCorrectly,
	FB_Translucent,
	FB_Darken,
	FB_Brighten,
	FB_Invisible,
	FB_Add,
	FB_InWaterBlend,
	FB_Capture,
	FB_OverwriteAlpha,
	FB_DarkenInv,
};

var() EFrameBufferBlending FrameBufferBlending;
var() bool ZWrite;
var() bool ZTest;
var() bool AlphaTest;
var() bool TwoSided;
var() byte AlphaRef;
var() bool TreatAsTwoSided;


// Decompiled with UE Explorer.
defaultproperties
{
    ZWrite=true
    ZTest=true
}