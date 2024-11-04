// BTAction

class BTAction extends BTNode
	native
	dynamicrecompile;

//-----------------------------------------------------------------------------
enum BTActionStatement
{
	UndefinedStatement,
	Action_StandUp,
	Action_SitDown,
	Action_UnfocusEnemy,
	Action_FocusEnemy,
	Action_MoveToFocusedEnemy,
	Action_AutoAttack,
	Action_MoveToHerd,
	Action_PickUp,
	Action_UsePrioritySkill,
	Action_WanderAround,
	Action_MoveToStartLocation,
	Action_MoveToSafeZoneLocation,
	// for debug
	DebugAction_BeHealthy,
	DebugAction_FollowAlterPath,
};

var BTActionStatement Statement;
var float ConsumedTime;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

