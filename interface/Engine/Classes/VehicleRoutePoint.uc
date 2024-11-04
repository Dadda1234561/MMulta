class VehicleRoutePoint extends Vehicle
	native;

var()	string				RouteName;
var()	array<vector>		DeltaPoint;
var()	array<vector>		AbsPoint;
var()	array<int>			MovingSpeed;
var()	array<int>			RotatingSpeed;
var()	array<int>			TimeToNextAction;
var()	array<int>			SpeakerID;
var()	array<int>			WaitingMessageID;
var()	array<int>			StationID;
var()	color				LineColor;
var()	color				PathColor;
var()	color				FontColor;
var		int					Paths;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    LineColor=(B=10,G=10,R=255,A=255)
    PathColor=(B=10,G=255,R=10,A=255)
    FontColor=(B=10,G=255,R=10,A=255)
}