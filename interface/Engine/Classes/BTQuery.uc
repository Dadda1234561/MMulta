// BTQuery

class BTQuery extends BTNode
	native
	dynamicrecompile;

//-----------------------------------------------------------------------------
enum BTQueryExpression
{
	UndefinedExpression,
	IfMyState_IsSit,
	IfMyState_IsStand,
	IfMyState_IsIdle,
	IfMyState_IsStationary,
	IfMyState_IsOutOfRoamBoundary,
	IfMyState_LastActionSucceed,
	IfMyState_IsInSafeZone,
	IfMyState_IsInStart,
	IfFocusedEnemy_IsExist,
	IfFocusedEnemy_IsFar,
	IfFocusedEnemy_IsNear,
	IfFocusedEnemy_IsDead,
	IfFocusedEnemy_IsWithinRange,
	IfAggresiveEnemy_IsFocused,
	IfAggresiveEnemy_IsAround,
	IfNextEnemy_IsExist,
	IfDropItem_IsAround,
	IfDropItem_IsTouchable,
	IfMyHPpercent_IsMoreThan,
	IfMyMPpercent_IsMoreThan,
	IfMyHPpercent_IsLessThan,
	IfMyMPpercent_IsLessThan,
	IfPrioritySkill_IsAvailable,
};

var BTQueryExpression Expression;
var bool ExpectedResult;
var float RValue;

//-----------------------------------------------------------------------------
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)



// Decompiled with UE Explorer.
defaultproperties
{
    ExpectedResult=true
    DebugString="BTQuery"
}