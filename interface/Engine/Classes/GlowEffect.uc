class GlowEffect extends CameraEffect
	native
	noexport
	editinlinenew
	collapsecategories;
	
var const int	RenderTargets[5];
var float		Luminance;			
var float		MiddleGray;
var float		WhiteCutoff;
var float		Threshold;		
var float		BloomScale;
var int			BlurNum;
var int			GlowType;
var float		RGBCutoff;		

var int			FinalBlendBlurType;		// 1 - gauss, 2 - 16box, 3 - ?
var int			FinalBlendOpacity;
var int	        AspectBlendOpacity;


// Decompiled with UE Explorer.
defaultproperties
{
    Luminance=0.08
    MiddleGray=0.18
    WhiteCutoff=0.8
    Threshold=0.35
    BloomScale=1.5
    BlurNum=2
    GlowType=1
    RGBCutoff=0.8
    FinalBlendBlurType=1
    FinalBlendOpacity=85
    AspectBlendOpacity=192
}