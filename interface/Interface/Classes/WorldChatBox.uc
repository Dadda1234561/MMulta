class WorldChatBox extends L2UIGFxScript;

function OnRegisterEvent()
{
}

function OnLoad()
{	
	registerState( "WorldChatBox", "GamingState" );	
	// ��� �����̳ʿ� ���� ���� ����
	SetContainerHUD(WINDOWTYPE_NONE, 0);
	AddState("GAMINGSTATE");
	AddState( "ARENABATTLESTATE" );
	AddState( "ARENAGAMINGSTATE" );

	SetHavingFocus(false);
	//setDefaultShow(true);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomRight, EAnchorPointType.ANCHORPOINT_TopLeft, 0 , 0);
}

function onCallUCFunction( string functionName, string param )
{	
	//switch ( functionName ) 
}

defaultproperties
{
}
