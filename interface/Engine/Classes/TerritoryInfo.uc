class TerritoryInfo extends Info
	showcategories(Movement)
	native
	placeable;

#exec Texture Import File=Textures\Territory_info.pcx Name=S_TerritoryInfo Mips=Off MASKED=1

enum InitalSpawn
{
	all,
	random1,
	random2
};

struct AnywhereNpc
{
	var() name NpcName;
	var() int	total;
	var() string respawn;
	var() string nickname;
	var() name ai;
	var() array<NpcPrivate> Privates;
	var() WhenExtinctionCreate when_extinction_create;
	var() bool bWayPointsShow;
	var() array<WayPoint> WayPoints;
};

struct AnywhereNpcMaker
{
	var() bool bGroup;
	var() InitalSpawn inital_spawn;
	var() int maximum_npc;
	var() array<AnywhereNpc> Npc;
};

var()	string	TerritoryName;
var()	int		PointNum;
var()	float	TerritoryHeight;
var()	vector	DeltaPoint[64];
var()	color	LineColor;
var()	array<AnywhereNpcMaker> npcmaker;
var transient int PrevPointNum;


// Decompiled with UE Explorer.
defaultproperties
{
    PointNum=4
    TerritoryHeight=200
    DeltaPoint[0]=(X=-100,Y=-100,Z=0)
    DeltaPoint[1]=(X=100,Y=-100,Z=0)
    DeltaPoint[2]=(X=100,Y=100,Z=0)
    DeltaPoint[3]=(X=-100,Y=100,Z=0)
    DeltaPoint[4]=(X=-100,Y=0,Z=0)
    DeltaPoint[5]=(X=-100,Y=0,Z=0)
    DeltaPoint[6]=(X=-100,Y=0,Z=0)
    DeltaPoint[7]=(X=-100,Y=0,Z=0)
    DeltaPoint[8]=(X=-100,Y=0,Z=0)
    DeltaPoint[9]=(X=-100,Y=0,Z=0)
    DeltaPoint[10]=(X=-100,Y=0,Z=0)
    DeltaPoint[11]=(X=-100,Y=0,Z=0)
    DeltaPoint[12]=(X=-100,Y=0,Z=0)
    DeltaPoint[13]=(X=-100,Y=0,Z=0)
    DeltaPoint[14]=(X=-100,Y=0,Z=0)
    DeltaPoint[15]=(X=-100,Y=0,Z=0)
    DeltaPoint[16]=(X=-100,Y=0,Z=0)
    DeltaPoint[17]=(X=-100,Y=0,Z=0)
    DeltaPoint[18]=(X=-100,Y=0,Z=0)
    DeltaPoint[19]=(X=-100,Y=0,Z=0)
    DeltaPoint[20]=(X=-100,Y=0,Z=0)
    DeltaPoint[21]=(X=-100,Y=0,Z=0)
    DeltaPoint[22]=(X=-100,Y=0,Z=0)
    DeltaPoint[23]=(X=-100,Y=0,Z=0)
    DeltaPoint[24]=(X=-100,Y=0,Z=0)
    DeltaPoint[25]=(X=-100,Y=0,Z=0)
    DeltaPoint[26]=(X=-100,Y=0,Z=0)
    DeltaPoint[27]=(X=-100,Y=0,Z=0)
    DeltaPoint[28]=(X=-100,Y=0,Z=0)
    DeltaPoint[29]=(X=-100,Y=0,Z=0)
    DeltaPoint[30]=(X=-100,Y=0,Z=0)
    DeltaPoint[31]=(X=-100,Y=0,Z=0)
    DeltaPoint[32]=(X=-100,Y=0,Z=0)
    DeltaPoint[33]=(X=-100,Y=0,Z=0)
    DeltaPoint[34]=(X=-100,Y=0,Z=0)
    DeltaPoint[35]=(X=-100,Y=0,Z=0)
    DeltaPoint[36]=(X=-100,Y=0,Z=0)
    DeltaPoint[37]=(X=-100,Y=0,Z=0)
    DeltaPoint[38]=(X=-100,Y=0,Z=0)
    DeltaPoint[39]=(X=-100,Y=0,Z=0)
    DeltaPoint[40]=(X=-100,Y=0,Z=0)
    DeltaPoint[41]=(X=-100,Y=0,Z=0)
    DeltaPoint[42]=(X=-100,Y=0,Z=0)
    DeltaPoint[43]=(X=-100,Y=0,Z=0)
    DeltaPoint[44]=(X=-100,Y=0,Z=0)
    DeltaPoint[45]=(X=-100,Y=0,Z=0)
    DeltaPoint[46]=(X=-100,Y=0,Z=0)
    DeltaPoint[47]=(X=-100,Y=0,Z=0)
    DeltaPoint[48]=(X=-100,Y=0,Z=0)
    DeltaPoint[49]=(X=-100,Y=0,Z=0)
    DeltaPoint[50]=(X=-100,Y=0,Z=0)
    DeltaPoint[51]=(X=-100,Y=0,Z=0)
    DeltaPoint[52]=(X=-100,Y=0,Z=0)
    DeltaPoint[53]=(X=-100,Y=0,Z=0)
    DeltaPoint[54]=(X=-100,Y=0,Z=0)
    DeltaPoint[55]=(X=-100,Y=0,Z=0)
    DeltaPoint[56]=(X=-100,Y=0,Z=0)
    DeltaPoint[57]=(X=-100,Y=0,Z=0)
    DeltaPoint[58]=(X=-100,Y=0,Z=0)
    DeltaPoint[59]=(X=-100,Y=0,Z=0)
    DeltaPoint[60]=(X=-100,Y=0,Z=0)
    DeltaPoint[61]=(X=-100,Y=0,Z=0)
    DeltaPoint[62]=(X=-100,Y=0,Z=0)
    DeltaPoint[63]=(X=-100,Y=0,Z=0)
    LineColor=(B=10,G=10,R=255,A=255)
    bAlwaysVisible=true
    bStatic=true
    Texture=Texture'S_TerritoryInfo'
    bStaticLighting=true
}