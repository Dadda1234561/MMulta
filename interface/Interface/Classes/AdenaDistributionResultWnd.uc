//�Ƶ��� �й� â
class AdenaDistributionResultWnd extends L2UIGFxScript;

function OnRegisterEvent()
{	
	//�Ƶ��� ������Ʈ�� �ޱ� ���� 
	RegisterGFxEvent( EV_DivideAdenaDone ); //9710
}

function OnLoad()
{	
	registerState( "AdenaDistributionResultWnd", "GamingState" );	
	SetContainerWindow( WINDOWTYPE_DECO_NORMAL, 0 );
	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0 , 0);	
}

defaultproperties
{
}
