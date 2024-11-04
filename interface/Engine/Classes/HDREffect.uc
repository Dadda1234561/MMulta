class HDREffect extends CameraEffect
	native
	noexport
	editinlinenew
	collapsecategories;

var const int	RenderTargets[7];
var float HDRTimeStamp;
// var	int	TrigAccum;

var int	idxCurLum;
//var float RGBBias;

var float GrayLum;
var float FinalCoef;

var float ExpBase;
var float ExpCoef;

var float ClampMin;
var float ClampMax;


// Decompiled with UE Explorer.
defaultproperties
{
    idxCurLum=5
    GrayLum=0.6
    FinalCoef=3.5
    ExpBase=0.98
    ExpCoef=30
    ClampMin=0.3
    ClampMax=0.75
}