//#ifdef __L2 //kurt
class AnimNotify_ViewShake extends AnimNotify
	native;

var () enum EViewShakeType
{
	VST_DAMAGE,
	VST_VIBRATION,	
	VST_USER,
	VST_UP,
	VST_DOWN,
	VST_UPDOWN,
	VST_DOWNUP,
	// by anima
	VST_TERRAIN,	// ?????? ???? Shake
	VST_ABNORMAL,	// ?????????? ???? Shake
	VST_ZOOM,		// Zoom
} ShakeType;

var() float  ShakeIntensity;
var() vector ShakeVector;
var() float  ShakeRange;
var() int    ShakeCount;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//#endif
