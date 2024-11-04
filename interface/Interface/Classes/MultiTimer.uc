//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : MultiTimer  ( 과거 AI-Timer , 여러 종류 타이머 ) - SCALEFORM UI
//      AITimerWnd.uc 을 대신하여 사용.
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
