//================================================================================
// RankingHistoryWnd.
//================================================================================

class RankingHistoryWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(EV_MyRankingHistoryList);
}

function OnLoad()
{
	AddState("GAMINGSTATE");
	SetContainerWindow(WINDOWTYPE_DECO_NORMAL,3598);
}

defaultproperties
{
}
