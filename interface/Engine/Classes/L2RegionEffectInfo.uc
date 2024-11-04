class L2RegionEffectInfo extends Info
	noexport
	showcategories(Movement)
	native
	placeable;

#exec Texture Import File=Textures\RegionInfo.pcx Name=S_L2RegionEffectInfo Mips=Off MASKED=1

enum	RegionEffectType
{
	REGION_YCBCR,
	REGION_HSV,
	REGION_RGB,
	REGION_MOTIONBLUR, // ?????????? ????????????.
	REGION_COLORGRADING,
	REGION_POSTEFFECTDATAID
};
enum	PlayType
{
	PLAYTYPE_MAXCOR_TO_MINCOR,
	PLAYTYPE_ORG_TO_MINCOR,
	PLAYTYPE_MAXCOR_TO_ORG
};

// Ycbcr, HSV, RGB, effectID?? ?????? ????
// EffectID?? ???????? PostEffectData.txt???? ?????? ?????? Time?? ????..
struct L2RegionEffectData
{
	var() RegionEffectType	effectType;
	var() range				affectRange;
	var() vector			affectBoxMin;
	var() vector			affectBoxMax;
	var() bool				FixData;	// YCbCr, HSV???? ????
	var() vector			YcbcrMinColor;
	var() vector			YcbcrMaxColor;
	var() vector			HSVMinColor;
	var() vector			HSVMaxColor;
	var() vector			RGBMinColor;
	var() vector			RGBMaxColor;
	var() texture			ColorGradingMinTexture;
	var() texture			ColorGradingMaxTexture;
	var() PlayType			playType;
	var() int				effectID;
	var() bool				UseAffectBox;

};

var() array<L2RegionEffectData>		RegionEffectData;
var		int							CurPos;




// Decompiled with UE Explorer.
defaultproperties
{
    CurPos=-1
}