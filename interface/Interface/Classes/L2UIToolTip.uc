//------------------------------------------------------------------------------------------------------------------------
//
// ����         : L2UIToolTip  - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class L2UIToolTip extends GFxUIScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(EV_ResolutionChanged);
	//RegisterEvent(EV_StateChanged);
	//RegisterGFxEvent(77777);
}

function OnLoad()
{
	RegisterState("L2UIToolTip", "LoginState");
	RegisterState("L2UIToolTip", "SERVERLISTSTATE");
	registerState("L2UIToolTip", "GamingState");
	registerState("L2UIToolTip", "CHARACTERCREATESTATE");
	registerState("L2UIToolTip", "CHARACTERSELECTSTATE");
	registerState("L2UIToolTip", "ARENAGAMINGSTATE");
	registerState("L2UIToolTip", "ARENABATTLESTATE");
	SetHavingFocus(false);
	setDefaultShow(true);
	//SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0, 0 );	
	
	//�Լ� ���� �� onStateOut, onStateIn �Լ��� invoke �� ���� 
	//SetStateChangeNotification();
}

function OnFlashLoaded()
{
	SetRenderOnTop(true);
	SetAlwaysFullAlpha(true);
	IgnoreUIEvent(true);
}

defaultproperties
{
}
