class EventChristmasWnd extends GFxUIScript;

function OnRegisterEvent()
{	
	RegisterGFxEvent( EV_ShowEventChristmasWnd ); //9650
}

function OnLoad()
{	
	registerState( "EventChristmasWnd", "GamingState" );	
	// ��� �����̳ʿ� ���� ���� ����
	SetContainer( "ContainerWindow" );
	//setDefaultShow(true);
}

function onCallUCFunction( string functionName, string param )
{	
	//switch ( functionName ) 
}

defaultproperties
{
}
