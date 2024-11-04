//================================================================================
// L2UIColor.
//================================================================================

class L2UIColor extends UIScript;

var Color White;
var Color WhiteSmoke;
var Color Yellow;
var Color Yellow2;
var Color Tallow;
var Color Blue;
var Color DeepSkyBlue;
var Color BrightWhite;
var Color Gold;
var Color Gray;
var Color DrakGray;
var Color Silver;
var Color Nobel;
var Color Charcoal;
var Color Yellow03;
var Color Frangipani;
var Color ColorDesc;
var Color ColorYellow;
var Color ColorGray;
var Color ColorLightBrown;
var Color ColorGold;
var Color ColorMinimapFont;
var Color Brown;
var Color HotPink;
var Color PowderPink;
var Color Token0;
var Color Token1;
var Color Token2;
var Color Token3;
var Color DarkGray;
var Color BrightGray;
var Color BWhite;
var Color DRed;
var Color Red;
var Color Red1;
var Color Red2;
var Color Red3;
var Color Orange;
var Color Orange2;
var Color Froly;
var Color VIOLET01;
var Color VIOLET02;
var Color PKNameColor;
var Color Green;
var Color Green2;
var Color Green3;
var Color Lime;
var Color BLUE01;
var Color CAPRI;
var Color Sandrift;

function OnLoad()
{
	initColor();
}

static function L2UIColor Inst()
{
	return L2UIColor(GetScript("L2UIColor"));
}

function initColor()
{
	Sandrift.R = 176;
	Sandrift.G = 155;
	Sandrift.B = 121;
	Sandrift.A = 255;
	BrightWhite.R = 255;
	BrightWhite.G = 255;
	BrightWhite.B = 255;
	BrightWhite.A = 255;
	WhiteSmoke.R = 240;
	WhiteSmoke.G = 240;
	WhiteSmoke.B = 240;
	WhiteSmoke.A = 255;
	White.R = 200;
	White.G = 200;
	White.B = 200;
	White.A = 255;
	Yellow.R = 235;
	Yellow.G = 205;
	Yellow.B = 0;
	Yellow.A = 255;
	Yellow2.R = 220;
	Yellow2.G = 150;
	Yellow2.B = 10;
	Yellow2.A = 255;
	Tallow.R = 170;
	Tallow.G = 153;
	Tallow.B = 119;
	Tallow.A = 255;
	Blue.R = 102;
	Blue.G = 150;
	Blue.B = 253;
	Blue.A = 255;
	Gold.R = 176;
	Gold.G = 153;
	Gold.B = 121;
	Gold.A = 255;
	Gray.R = 120;
	Gray.G = 120;
	Gray.B = 120;
	Gray.A = 255;
	DrakGray.R = 100;
	DrakGray.G = 100;
	DrakGray.B = 100;
	DrakGray.A = 255;
	Silver.R = 182;
	Silver.G = 182;
	Silver.B = 182;
	Silver.A = 255;
	HotPink.R = 195;
	HotPink.G = 46;
	HotPink.B = 97;
	HotPink.A = 255;
	PowderPink.R = 255;
	PowderPink.G = 192;
	PowderPink.B = 203;
	PowderPink.A = 255;
	Token0.R = 211;
	Token0.G = 192;
	Token0.B = 82;
	Token0.A = 255;
	Token1.R = 170;
	Token1.G = 152;
	Token1.B = 120;
	Token1.A = 255;
	Token2.R = 168;
	Token2.G = 103;
	Token2.B = 53;
	Token2.A = 255;
	Token3.R = 175;
	Token3.G = 42;
	Token3.B = 39;
	Token3.A = 255;
	Yellow03.R = 255;
	Yellow03.G = 204;
	Yellow03.B = 0;
	Yellow03.A = 255;
	Frangipani.R = 254;
	Frangipani.G = 215;
	Frangipani.B = 160;
	Frangipani.A = 255;
	ColorDesc.R = 175;
	ColorDesc.G = 185;
	ColorDesc.B = 205;
	ColorDesc.A = 255;
	ColorYellow.R = 255;
	ColorYellow.G = 221;
	ColorYellow.B = 102;
	ColorYellow.A = 255;
	ColorGray.R = 182;
	ColorGray.G = 182;
	ColorGray.B = 182;
	ColorGray.A = 255;
	ColorGold.R = 176;
	ColorGold.G = 153;
	ColorGold.B = 121;
	ColorGold.A = 255;
	ColorMinimapFont.R = 181;
	ColorMinimapFont.G = 181;
	ColorMinimapFont.B = 170;
	ColorMinimapFont.A = 255;
	ColorLightBrown.R = 238;
	ColorLightBrown.G = 170;
	ColorLightBrown.B = 34;
	ColorLightBrown.A = 255;
	Brown.R = 75;
	Brown.G = 45;
	Brown.B = 35;
	Brown.A = 255;
	DarkGray.R = 68;
	DarkGray.G = 68;
	DarkGray.B = 68;
	DarkGray.A = 255;
	BrightGray.R = 150;
	BrightGray.G = 150;
	BrightGray.B = 150;
	BrightGray.A = 255;
	BWhite.R = 211;
	BWhite.G = 211;
	BWhite.B = 211;
	BWhite.A = 255;
	DRed.R = 255;
	DRed.G = 102;
	DRed.B = 102;
	DRed.A = 255;
	Red.R = 255;
	Red.G = 50;
	Red.B = 0;
	Red.A = 255;
	Red1.R = 255;
	Red1.G = 0;
	Red1.B = 0;
	Red1.A = 255;
	Red2.R = 255;
	Red2.G = 102;
	Red2.B = 102;
	Red2.A = 255;
	Red3.R = 255;
	Red3.G = 153;
	Red3.B = 153;
	Red3.A = 255;
	VIOLET01.R = 238;
	VIOLET01.G = 170;
	VIOLET01.B = 255;
	VIOLET01.A = 255;
	Orange.R = 170;
	Orange.G = 100;
	Orange.B = 67;
	Orange.A = 255;
	Orange2.R = 255;
	Orange2.G = 170;
	Orange2.B = 0;
	Orange2.A = 255;
	VIOLET02.R = 136;
	VIOLET02.G = 136;
	VIOLET02.B = 255;
	VIOLET02.A = 255;
	PKNameColor.R = 230;
	PKNameColor.G = 100;
	PKNameColor.B = 255;
	PKNameColor.A = 255;
	BLUE01.R = 85;
	BLUE01.G = 153;
	BLUE01.B = 255;
	BLUE01.A = 255;
	Green.R = 119;
	Green.G = 255;
	Green.B = 153;
	Green.A = 255;
	Green2.R = 0;
	Green2.G = 255;
	Green2.B = 75;
	Green2.A = 255;
	Green3.R = 119;
	Green3.G = 255;
	Green3.B = 153;
	Green3.A = 255;
	Lime.R = 0;
	Lime.G = 255;
	Lime.B = 0;
	Lime.A = 255;
	CAPRI.R = 0;
	CAPRI.G = 170;
	CAPRI.B = 255;
	CAPRI.A = 255;
	Froly.R = 230;
	Froly.G = 101;
	Froly.B = 101;
	Froly.A = 255;
	Nobel.R = 230;
	Nobel.G = 101;
	Nobel.B = 101;
	Nobel.A = 255;
	Charcoal.R = 70;
	Charcoal.G = 70;
	Charcoal.B = 70;
	Charcoal.A = 255;
	DeepSkyBlue.R = 0;
	DeepSkyBlue.G = 170;
	DeepSkyBlue.B = 255;
	DeepSkyBlue.A = 255;
}

function Color Hex2RGB(string hex)
{
	local Color C;

	C.R = byte(Hex2Dec2(Left(hex, 2)));
	C.G = byte(Hex2Dec2(Mid(hex, 4, 2)));
	C.B = byte(Hex2Dec2(Right(hex, 2)));
	return C;
}

function int Hex2Dec2(string hex)
{
	return Hex2Dec(Left(hex, 1)) * 16 + Hex2Dec(Right(hex, 1));
}

function int Hex2Dec(string hex)
{
	// End:0x1A
	if(Asc(hex) >= 65)
	{
		return Asc(hex) - 55;
	}
	return int(hex);
}

defaultproperties
{
}
