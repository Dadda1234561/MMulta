class AnniveEvent extends L2UIGFxScript;

function OnRegisterEvent()
{	
	RegisterGFxEvent(EV_CardRewardStart);
	RegisterGFxEvent(EV_CardListProperty);
	RegisterGFxEvent(EV_CardProperty);
	RegisterGFxEvent(EV_EventAttendanceInfo); //6000
}

function OnLoad()
{	
	//registerState( "AnniveEvent", "GamingState" );
	// ��� �����̳ʿ� ���� ���� ����
	//SetContainer( "ContainerWindow" );
	
	SetContainerWindow(WINDOWTYPE_DECO_NORMAL, 14081);
	AddState("GAMINGSTATE");
	
	//setDefaultShow(true);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0 , 0);
}


function onCallUCFunction( string functionName, string param )
{
	// 15�ֳ� �̺�Ʈ ����
	if (functionName == "shop")
	{
		RequestOpenWndWithoutNPC(OPEN_15EVENT_HTML);
	}
}

defaultproperties
{
}
