class NCubics extends Emitter	
	dynamicrecompile
	native;

var enum ECubicType
{
	ECT_STORM,
	ECT_VAMPIRIC,
	ECT_LIFE,
	ECT_VIPER,
	ECT_DEBUFF,

} CubicType;

var enum ECubicMovementType
{
	ECMT_FOLLOW,
	ECMT_FLOAT,
	ECMT_SKILLUSE,
	ECMT_BUFF,
	ECMT_FLOATSTART,
	ECMT_ONVEHICLE,

} CubicMovementType;

var vector	DestLocation;
var int		CubicIndex;
var int		SkillID;
var	pawn	TargetPawn;
var float	SkillActiveTime;
var	rotator	RotPerSecond;
var transient NMagicInfo     MagicInfo;


// Decompiled with UE Explorer.
defaultproperties
{
    CubicIndex=-1
    SkillID=-1
    NoCheatCollision=true
    bNoDelete=false
    bAlwaysRelevant=true
    NetUpdateFrequency=8
    NetPriority=1.4
    CollisionRadius=0.1
    CollisionHeight=0.1
    bFixedRotationDir=true
}