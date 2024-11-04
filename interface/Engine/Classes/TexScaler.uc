class TexScaler extends TexModifier
	editinlinenew
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var() float UScale;
var() float VScale;
var() float UOffset;
var() float VOffset;

//always last member : Matrix M
var Matrix M;


// Decompiled with UE Explorer.
defaultproperties
{
    UScale=1
    VScale=1
}