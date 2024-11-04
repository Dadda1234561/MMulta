//=============================================================================
// ??, ?? , ????, ???? ???? ?????? ?????? ???????? ???? ????
// 
//=============================================================================


class L2CenterdDiamond extends Actor
	placeable
	native;
	

var		float	HeightRate;
var		float	RadiusRate;
var		texture DiaTexture[4];
var		float	DiaSpeed[4];
var		float	DiaWeight[4];
var		Matrix	LocalToWorldMatrix;

	

// Decompiled with UE Explorer.
defaultproperties
{
    HeightRate=1
    RadiusRate=1
    bNetTemporary=true
    bCheckChangableLevel=true
    bGameRelevant=true
}