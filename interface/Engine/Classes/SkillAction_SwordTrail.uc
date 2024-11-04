////////////////////////////////////////////
// SkillAction_SwordTrail.uc
// 
// revision history : created by nonblock (8th,Nov,2004)
////////////////////////////////////////////
class SkillAction_SwordTrail extends SkillAction
	native;
	// native collapsecategories editinlinenew;

var() float	DurationRatio; // = duration / shotTime
var() bool bRightHand;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


// Decompiled with UE Explorer.
defaultproperties
{
    DurationRatio=0.8
    bRightHand=true
}