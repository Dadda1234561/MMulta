class 	BeautyShopCameraActor extends Actor
	config(user)
	native
	hidecategories(Collision,Lighting,LightColor,Karma,Force)
	placeable;

#exec Texture Import File=Textures\ZoneInfo.pcx Name=S_ZoneInfo Mips=Off MASKED=1

var transient bool		bUseMouseTurning;
var transient float		turningSpeed;
var transient bool		isOutOfRangeZ;
var transient bool		isOutOfRangeY;
var transient vector	InitialLocation;
var transient bool		bLeftMouseClick;
var transient bool		bRightMouseClick;
var transient int		LeftMouseClickedX;
var transient int		LeftMouseClickedY;
var transient int		RightMouseClickedX;
var transient int		RightMouseClickedY;
var transient int		CurrentMouseX;
var transient int		CurrentMouseY;
var transient int		wheelDelta;
var transient bool		bMoveToZoomTarget;
var transient vector	zoomTarget;
var transient float		MaxZoomInPos;
var transient float     MaxZoomOutPos;
var transient Pawn		pRelativePawn;
var transient int		CharMeshType;

var config    float     WheelRatio;
var config    float		VelocityDecreaseRatio;
var config    float     DampingFactor;
var config    int		CharaterYawInShop;
var config    int		CameraYawInShop;
var config    float     mouseTurningRatio;
var config    int		CameraManualMoveZMax[18];
var config    int		CameraManualMoveZMin[18];
var config    vector	PosForSize[3]; 
var config	  vector	PosForZoomIn[18];
var config	  vector	PosForZoomOut[18];
var config    float		moveSpeed;
var config    float		accelRate;
var config	  int		CameraTilt[18];

