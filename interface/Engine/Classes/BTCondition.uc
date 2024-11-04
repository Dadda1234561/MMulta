// BTcondition

class BTCondition extends BTNode
	native
	dynamicrecompile;

enum BTConditionLogic
{
	BTConditionLogic_AND,
	BTConditionLogic_OR,
};
	
var BTConditionLogic Logic;
var array<BTQuery> Queries;
var bool ExpectedResult;


	
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
		

	

// Decompiled with UE Explorer.
defaultproperties
{
    ExpectedResult=true
}