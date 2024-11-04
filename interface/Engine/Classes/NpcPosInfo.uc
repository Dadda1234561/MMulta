class NpcPosInfo extends Info
	showcategories(Movement)
	native
	placeable;

#exec Texture Import File=Textures\Territory_info.pcx Name=S_TerritoryInfo Mips=Off MASKED=1

struct NpcPos
{
	var() vector Delta;
	var() int	Yaw;
	var() int Percent;
};

var()	array<NpcPos>	pos;
var()	color	LineColor;
var()	name	NpcName;
var()	string	nickname;
var()	name	ai;
var()	array<NpcPrivate> Privates;
var()	WhenExtinctionCreate when_extinction_create;
var()	bool	bWayPointsShow;
var()	array<WayPoint> WayPoints;


// Decompiled with UE Explorer.
defaultproperties
{
    LineColor=(B=10,G=255,R=255,A=255)
    bStatic=true
    Texture=Texture'S_TerritoryInfo'
    bStaticLighting=true
}