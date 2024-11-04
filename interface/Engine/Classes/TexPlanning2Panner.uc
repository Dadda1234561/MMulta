class TexPlanning2Panner extends TexPanner
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

enum CountBasisDirection
{
	X_DIR,
	Y_DIR
};

var() float MinWaitTime;
var() float MaxWaitTime;
var() float PlayCount;
var() CountBasisDirection BasisAxis;

var transient float WaitTime;
var transient float WaitTimeStamp;

var transient float ElapsedTimeStamp;
var transient float TotalPlayTime;

var transient bool Playing;

var transient float Curdu;
var transient float Curdv;

