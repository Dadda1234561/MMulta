//------------------------------------------------------------------------------------------------------------------------
//
// ����         : VIPInfoWnd  ( VIP ���� â ) - SCALEFORM UI
//
//------------------------------------------------------------------------------------------------------------------------
class VipInfoWnd extends L2UIGFxScript;


function OnRegisterEvent()
{
	RegisterGFxEvent(EV_VIPInfo);
	RegisterGFxEvent(EV_VIPInfoRemainTime);
}

function OnLoad()
{
	AddState("GAMINGSTATE");
	SetContainerWindow(WINDOWTYPE_DECO_NORMAL, 5819);
}

defaultproperties
{
}
