//------------------------------------------------------------------------------------------------------------------------
//
// ����         : Menu �������� ���� - SCALEFORM UI
//                ������
//
//------------------------------------------------------------------------------------------------------------------------
class ArenaScoreBoardWnd extends L2UIGFxScript;

function OnRegisterEvent()
{	
	RegisterGFxEvent( EV_DuelUpdateUserInfo );			
	RegisterGFxEvent( EV_PartyAddParty);
	RegisterGFxEvent( EV_PartyDeleteParty);
	RegisterGFxEvent( EV_PartyUpdateParty);
	RegisterGFxEvent( EV_PartyDeleteAllParty );

	RegisterGFxEvent( EV_UpdateUserInfo);

	RegisterGFxEvent( EV_ArenaUpdateEquipSlot);

	RegisterGFxEvent( EV_ArenaDashboard);

	RegisterGFxEvent( EV_ArenaKillInfo);	

	RegisterGFxEvent( EV_BattleResultArena);
	RegisterGFxEvent( EV_BattleResultArenaReward);
	RegisterGFxEvent( EV_BattleResultArenaStat);

	RegisterGFxEvent( EV_StartBattleReadyArena);
	
	// GFx�δ� �� �´� ??
	RegisterGFxEvent( EV_ClosedArena);

	RegisterGFxEvent( EV_BattleReadyArena ); 
	
	RegisterGFxEvent( EV_ArenaBattleOccupyScore);
	//RegisterEvent( EV_ClosedArena);
	//RegisterEvent( EV_StateChanged );
	
}

function OnLoad()
{	
	AddState( "ARENABATTLESTATE" );
	//AddState( "ARENAGAMINGSTATE" );
	AddState("ARENAOBSERVERSTATE");
	AddState( "ARENAPICKSTATE" );

	//SetDefaultShow(true);

	SetContainerWindow(WINDOWTYPE_NONE, 0);
	SetHavingFocus( false );
}

function OnFlashLoaded()
{		
	SetRenderOnTop(true);
	SetAlwaysFullAlpha(true);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0 , 0);	
}


function onEvent ( int id, string param) 
{
	
	switch ( id ) 
	{			
		case EV_StateChanged : 
			if ( param == "ARENAGAMINGSTATE" ||  param == "ARENABATTLESTATE" ) HideWindow();
		break;
	}
}

defaultproperties
{
}
