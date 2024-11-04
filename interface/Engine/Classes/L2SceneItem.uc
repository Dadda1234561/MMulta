class L2SceneItem extends Object
	native
	dynamicrecompile		
	hidecategories(Object);

enum ScreenItemType
{
	SIT_NONE,
	SIT_FADE,
	SIT_MESSAGE,
	SIT_SLIDE_START,
	SIT_SLIDE_CHANGE,
	SIT_SLIDE_MOVE,
	SIT_SLIDE_END,
	SIT_POST_EFFECT
};
enum UseCameraMode
{
	UCM_SPECIAL_VIEW,
	UCM_FIXED_CAMERA,
	UCM_FREE_CAMERA
};
enum SlideDirectionType
{
	SDT_ALPHA,
	SDT_LEFT,
	SDT_RIGHT,
	SDT_UP,
	SDT_DOWN
};
enum NpcItemType
{
	NIT_SPAWN,
	NIT_DESPAWN,
	NIT_MOVE,
	NIT_USE_SKILL,
	NIT_PLAY_ANIMATION,
	NIT_AIRSHIP_SPAWN,
	NIT_AIRSHIP_MOVE,
	NIT_ABNORMAL,
	NIT_EFFECT_SPAWN
};

enum PcItemType
{
	PIT_SPAWN,
	PIT_DESPAWN,
	PIT_TELEPORT,
	PIT_SELECTTARGET,
	PIT_EQUIPITEM,
	PIT_MOVE,
	PIT_ATTACK,
	PIT_USESKILL,
	PIT_PLAYANIM,
	PIT_ABNORMAL,
	PIT_SPAWNEFFECT,
	PIT_TELEPORTTOORIGIN,
	PIT_SELF
};

enum ScreenWindowType
{
	SWT_UPPERLEFT,
	SWT_UPPERCENTER,
	SWT_UPPERRIGHT,
	SWT_MIDDLELEFT,
	SWT_MIDDLECENTER,
	SWT_MIDDLERIGHT,
	SWT_LOWERLEFT,
	SWT_LOWERCENTER,
	SWT_LOWERRIGHT,
	SWT_BOTTOMCENTER
};

enum ScreenWindowAnimationType
{
	SWAT_0,
	SWAT_1,
	SWAT_2_NOTUSE,
	SWAT_3_NOTUSE,
	SWAT_4_NOTUSE,
	SWAT_5_NOTUSE,
	SWAT_6_NOTUSE,
	SWAT_7_NOTUSE,
	SWAT_8_NOTUSE,
	SWAT_9_NOTUSE,
	SWAT_10_NOTUSE,
	SWAT_11,
	SWAT_12,
	SWAT_13
};

enum DelayedFadeType
{
	DFT_NONE,
	DFT_ANIMNOTIFY,
	DFT_SPAWNEDPAWN
};

enum VisualItemType
{
	VIT_NONE,
	VIT_GLOVE,		// ST_GLOVES
	VIT_CHEST,		// ST_CHEST
	VIT_LEGS,		// ST_LEGS
	VIT_FEET,		// ST_FEET
	VIT_BACK,		// ST_BACK
	VIT_HAIRACC,	// ST_HAIRACCESSORY 
	VIT_HAIRACC2,	// ST_HAIRACCESSORY2
	VIT_RHAND,		// ST_RHAND
	VIT_LHAND		// ST_LHAND
};

struct native ScreenItem
{	
	var ScreenItemType	ScreenType;
	var DelayedFadeType	DelayedType;
	var float			FadeOutDuration;
	var float			FadeInDuration;
	var float			BlackOutDuration;
	var color			FadeColor;
	var int				WindowType;
	var int				AnimationType;
	var int				FontType;
	var int				BackgroundType;
	var int				MsgNo;
	var string			MsgText;
	var int				SlideDirection;
	var int				SlidingTime;
	var string			SlideTexName;
	var int				SlideTexUSize;
	var int				SlideTexVSize;
	var int				SlideMoveRatio;
	var int				SlideWndRatio;
	var int				PostEffectID;
};

struct native NpcItem
{
	var string			Description;
	var	NpcItemType		NpcItemType;
	var	int				NpcID;
	var	int				Index;
	var	int				TargetIndex;
	var	vector			Location;
	var	int				Yaw;
	var	int				SkillID;
	var	string			AnimName;

	var	bool			IsFly;
	var bool			IsRun;
	var bool			IsLoop;
	var bool			ImmInsight;
};

struct native CameraItem
{
	var UseCameraMode	UseCamera;
	var	int			TargetIndex;
	var	int			Dist;
	var	int			Yaw;
	var	int			Pitch;
	var	int			Time;
	var	int			Duration;
	var	int			RelYaw;
	var	int			RelPitch;
	var int			RelRoll;

	var	bool		IsWide;
	var	bool		IsRelAngle;
	var	bool		IsImmTarget;

	var float		CameraFov;
};

struct native MusicItem
{
	var bool		UseMusic;
	var bool		StopMapMusic;
	var bool		StopMapSoundFx;
	var bool		StopMapAmbient;
	var bool		IsSound;
	var bool		IsVoice;

	var string		MusicName;
	var int			Volume;
	var int			FadeInTime;
	var int			FadeOutTime;
};

struct native VisualItem
{
	var VisualItemType type;
	var int VisualItemID;
};

struct native PcItem
{
	var bool			IsSelfPawn;
	var bool			IsMage;
	var bool			IsRun;
	var bool			IsLoop;
	var bool			UseSpirit;
	var bool			ImmInsight;

	var string			Description;
	var	PcItemType		PcItemType;	
	var	vector			Location;
	var int				Index;
	var int				TargetIndex;
	var int				Race;
	var int				Sex;
	var int				Yaw;
	var int				SkillID;
	var string			AnimName;
	var int				SetItemNo;
	var int				SetItemType;

	var array<VisualItem>	VisualItemList;
};

var	float			SceneTime;
var string			Description;
var float			ScenePlayRate;
var	CameraItem		CameraInfo;
var ScreenItem		ScreenInfo;
var MusicItem		MusicInfo;		
var	array<NpcItem>	NpcInfo;
var array<PcItem>	PcInfo;


// Decompiled with UE Explorer.
defaultproperties
{
    ScenePlayRate=1
}