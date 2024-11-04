//------------------------------------------------------------------------------------------------------------------------
//
// ����         : Menu �������� ���� - SCALEFORM UI
//                ������
//
//------------------------------------------------------------------------------------------------------------------------
class ArenaScoreBoardHUD extends L2UIGFxScript;

function OnRegisterEvent()
{
	return;
	RegisterGFxEvent( EV_ArenaDashboard);
	RegisterGFxEvent( EV_ArenaKillInfo);
	RegisterGFxEvent( EV_UpdateHP);	
	RegisterGFxEvent( EV_InventoryUpdateItem ); 
	RegisterGFxEvent( EV_TransformNotification ); 
	RegisterEvent( EV_StateChanged);
	RegisterGFxEvent( EV_BattleReadyArena ); 

	RegisterGFxEvent( EV_ArenaBattleOccupyDashBoard);
	RegisterGFxEvent( EV_ArenaBattleOccupyStatus);
	RegisterGFxEvent( EV_ArenaBattleOccupyScore);
}

function OnLoad()
{	
	AddState( "ARENABATTLESTATE" );
	AddState( "ARENAGAMINGSTATE" );	
	AddState("ARENAOBSERVERSTATE");
	SetContainerHUD(WINDOWTYPE_NONE, 0);    
	SetHavingFocus( false );
}

function OnFlashLoaded()
{		
	IgnoreUIEvent(true);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_TopCenter, EAnchorPointType.ANCHORPOINT_TopCenter, 0 , 0);	
}


function onEvent ( int id, string param) 
{	
	switch ( id ) 
	{
		// ������Ʈ ���� �� open �� �־� as ������ ��.
		case EV_StateChanged : 
			if( param == "ARENABATTLESTATE" || param == "ARENAOBSERVERSTATE" ) ShowWindow ( getCurrentWindowName(string(Self)) );
			else hideWindow ( getCurrentWindowName(string(Self)) );
		break;
	}
}

defaultproperties
{
}
