class AlchemySkillCollectionWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
}

function OnLoad()
{	
	
	registerState( "AlchemySkillCollectionWnd", "GamingState" );
	// ��� �����̳ʿ� ���� ���� ����
	//SetContainer( "ContainerWindow" );
	
	SetContainerWindow(WINDOWTYPE_DECO_NORMAL, 3298);
	AddState("GAMINGSTATE");
	
	//setDefaultShow(true);
	//SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0 , 0);
}

function onShow ()
{
}

function onCallUCFunction( string functionName, string param )
{
}

defaultproperties
{
}
