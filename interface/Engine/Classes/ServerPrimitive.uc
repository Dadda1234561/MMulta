class ServerPrimitive extends Info
	showcategories(Movement)
	native
	placeable;

#exec Texture Import File=Textures\ServerPrimitive_info.pcx Name=S_ServerPrimitive Mips=Off MASKED=1

struct ServerPointStruct
{
	var() string Name;
	var() vector Point;
	var() plane Color;
};

struct ServerLineStruct
{
	var() string Name;
	var() vector Start;
	var() vector End;
	var() plane Color;
};

var()	array<ServerPointStruct>	PointArray;
var()	array<ServerLineStruct>		LineArray;
var()	color						LineColor;
var()	string						Name;



// Decompiled with UE Explorer.
defaultproperties
{
    LineColor=(B=10,G=10,R=255,A=255)
    bAlwaysVisible=true
    bHidden=false
    bDisableSorting=true
    Texture=Texture'S_ServerPrimitive'
    bStaticLighting=true
    CollisionRadius=0
    CollisionHeight=0
}