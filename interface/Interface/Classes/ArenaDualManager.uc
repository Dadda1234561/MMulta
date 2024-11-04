//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : Menu 스케일폼 버전 - SCALEFORM UI
//                전광판
//
//------------------------------------------------------------------------------------------------------------------------
class ArenaDualManager extends L2UIGFxScript;

function OnRegisterEvent()
{	
	RegisterGFxEvent( EV_DuelReady);
	RegisterGFxEvent( EV_DuelStart);
	RegisterGFxEvent( EV_DuelEnd);
	RegisterGFxEvent( EV_DuelUpdateUserInfo);
	RegisterGFxEvent( EV_DuelEnemyRelation);
	RegisterGFxEvent( EV_ArenaKillInfo);
	RegisterGFxEvent( EV_BattleResultArena );
	RegisterGFxEvent( EV_StartBattleReadyArena );
	RegisterGFxEvent( EV_TargetUpdate );
}


function OnLoad()
{	
	AddState( "ARENABATTLESTATE" );
	AddState("ARENAOBSERVERSTATE");
	SetDefaultShow( true ) ;
	SetContainerHUD(WINDOWTYPE_NONE, 0);    
	SetHavingFocus( false );
}

function OnFlashLoaded()
{		
	IgnoreUIEvent(true);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterRight, EAnchorPointType.ANCHORPOINT_TopRight, -26 , -160);	
}

defaultproperties
{
}
