class TexPanner extends TexModifier
	editinlinenew
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var() rotator PanDirection;
var() float PanRate;
//always last member : Matrix M
var Matrix M;


// Decompiled with UE Explorer.
defaultproperties
{
    PanRate=0.1
}