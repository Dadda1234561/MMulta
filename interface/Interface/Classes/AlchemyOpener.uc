class AlchemyOpener extends L2UIGFxScript;

function OnLoad()
{
	
	registerState( "AlchemyOpener", "GamingState" );
	SetContainerWindow( WINDOWTYPE_DECO_NORMAL, 3257);
	AddState("GAMINGSTATE");

	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0 , 0);

	//�Լ� ���� �� onStateOut, onStateIn �Լ��� invoke �� ���� 
	//SetStateChangeNotification();

	//�����ϸ� ó�� ���� �������� ���� ��
	//SetDefaultShow(true);

	//SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0 , 0);		
}

defaultproperties
{
}
