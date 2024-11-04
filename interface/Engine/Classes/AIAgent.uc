// AIAgent
// AI agent which is controlling the pawn through a scripted sequence specified by Behavior Tree

class AIAgent extends Actor
	native;

// referenced
var private Controller MyController;
var private AITrait MyTrait;
var private array<int> AggresiveUserIDs;

var bool IsRunning;

struct native AIAgentStateData
{
var bool idle;
var bool stationary;
var bool actionResult;
var int stationaryCheckCount;
var int actionFailCount;
var vector prevMyLocation;
var vector myStartLocation;
var vector mySafeZoneLocation;
};
var transient AIAgentStateData State;

struct native AIAgentCachedData
{
	var Pawn focusedEnemyPawn;
	var Pawn nextEnemyPawn;
	var array<Pawn> aggresiveEnemyPawns;
	var float myHPpercent;
	var float myMPpercent;
	var int usablePrioritySkillID;
	var vector herdLocation;
	var vector alterLocation;
};
var transient AIAgentCachedData Cached;

// behavior tree
var BTNode MyBTRoot;
var array<BTAction> AcceptedActions;
var int ActivatedIndex;

// debug	
var private bool ShowDebugString;

//-----------------------------------------------------------------------------
// native functions
native function EvaluateWhenTimer();

function Timer()
{
	EvaluateWhenTimer();
}


// Decompiled with UE Explorer.
defaultproperties
{
    ShowDebugString=true
}