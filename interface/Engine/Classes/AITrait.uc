// AITrait
// AI trait is a set of properties which declares the characteristic of AI through scaled parameter values.

class AITrait extends Object
	native
	dynamicrecompile;

var array<int> PrioritySkills;

var bool EnableShortcut;	// true:PrioritySkills array?? ???? shortcut id?? ??????

var float AttackRange;

var float RoamBoundary;


// Decompiled with UE Explorer.
defaultproperties
{
    AttackRange=150
    RoamBoundary=5000
}