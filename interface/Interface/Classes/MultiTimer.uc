//------------------------------------------------------------------------------------------------------------------------
//
// ����         : MultiTimer  ( ���� AI-Timer , ���� ���� Ÿ�̸� ) - SCALEFORM UI
//      AITimerWnd.uc �� ����Ͽ� ���.
//
//------------------------------------------------------------------------------------------------------------------------
class MultiTimer extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(EV_AITimer);
	RegisterGFxEvent(EV_KserthFieldEventStep);
	RegisterGFxEvent(EV_KserthFieldEventPoint);
	RegisterGFxEvent(EV_Restart);
}

function OnLoad()
{
	RegisterState("MultiTimer", "GamingState");
	SetContainerHUD(WINDOWTYPE_NONE, 0);
	AddState("GAMINGSTATE");
	SetDefaultShow(true);
	SetHavingFocus(false);
}

defaultproperties
{
}
