//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : Menu 스케일폼 버전 - SCALEFORM UI
//                전광판
//
//------------------------------------------------------------------------------------------------------------------------
class ArenaMapGuidance extends L2UIGFxScript;

function OnRegisterEvent()
{	
	RegisterGFxEvent( EV_ScenePlayStart );
	RegisterGFxEvent( EV_ScenePlay );	
	RegisterGFxEvent( EV_BattleReadyArena );
	RegisterGFxEvent( EV_ClosedArena );
	RegisterEvent( EV_StateChanged );	
}

function OnLoad()
{	
	AddState( "ARENAGAMINGSTATE" );
	AddState( "ARENABATTLESTATE" );
	AddState( "ARENAPICKSTATE" );
	AddState( "SPECIALCAMERASTATE" );

	SetContainerWindow(WINDOWTYPE_NONE, 0);    

	setHUD();
	SetHavingFocus( false );
	SetCanBeShownDuringScene( true );
}

function OnFlashLoaded()
{		
	IgnoreUIEvent(true);
}

function OnEvent ( int eventID , String param ) 
{
	switch ( eventID ) 
	{
		case EV_StateChanged :
			if (!getInstanceUIData().getIsArenaServer()  ) return; 
			if( param == "ARENAGAMINGSTATE")
				HideWindow();
			else if( param == "SPECIALCAMERASTATE" )
				ShowWindow();
		break;
	}
}

defaultproperties
{
}
