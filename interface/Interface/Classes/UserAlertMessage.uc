class UserAlertMessage extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(EV_ExtraWorldChattingCnt);
	RegisterGFxEvent(EV_ScenePlayStart);
}

function OnLoad()
{
	RegisterState("UserAlertMessage", "GamingState");
	// 어느 콘테이너에 넣을 건지 선언
	SetContainerHUD(WINDOWTYPE_NONE, 0);
	AddState("GAMINGSTATE");
	AddState("ARENABATTLESTATE");
	AddState("ARENAGAMINGSTATE");
	SetHavingFocus(false);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0 , 0);
}

defaultproperties
{
}
