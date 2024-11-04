class TexPlanningPanner extends TexPanner
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


var() float MinWaitTime;
var() float MaxWaitTime;
var() float MinPlayTime;
var() float MaxPlayTime;

var transient float WaitTime;
var transient float WaitTimeStamp;
var transient float PlayTime;
var transient float PlayTimeStamp;
var transient float ElapsedTimeStamp;
var transient float TotalPlayTime;

var transient bool	IsPlaying;

