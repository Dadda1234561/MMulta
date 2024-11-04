//=============================================================================
// LevelSummary contains the summary properties from the LevelInfo actor.
// Designed for fast loading.
//=============================================================================
class LevelSummary extends Object
	native;

//-----------------------------------------------------------------------------
// Properties.

// From LevelInfo.
var(LevelSummary) localized String Title;
var(LevelSummary) String Author;
var() int	IdealPlayerCount;

var() localized string LevelEnterText;

