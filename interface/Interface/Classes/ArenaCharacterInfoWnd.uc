//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : Menu 스케일폼 버전 - SCALEFORM UI
//                아레나 케릭터 정보 창
//
//------------------------------------------------------------------------------------------------------------------------
class ArenaCharacterInfoWnd extends L2UIGFxScriptNoneContainer;

function OnRegisterEvent()
{	
	RegisterEvent( EV_StateChanged );
	
	RegisterGFxEvent( EV_StartChooseClassArena );
	RegisterGFxEvent( EV_ChangeClassArena  );
	RegisterGFxEvent( EV_ConfirmClassArena  );

	RegisterGFxEvent( EV_StartBattleReadyArena  );
}

function OnLoad()
{		

	AddState( "ARENAGAMINGSTATE" );
	AddState("ARENABATTLESTATE");
	//SetContainerWindow(WINDOWTYPE_NONE, 0);

	SetClosingOnESC();

	//SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0,0);


	//setDefaultShow(true);
	//SetHavingFocus( false );
}

function OnEvent(int Event_ID, string param)
{
	//if(Event_ID == EV_StateChanged)
	//{
	//	if (param == "ARENAGAMINGSTATE")
	//	{
	//		ShowWindow();
	//		//Debug( "ARENAPICKSTATE" @  param );
	//	}
	//	else //if (param == "ARENABATTLESTATE")
	//	{
	//		HideWindow();
	//	}
	//}
}

function OnFlashLoaded()
{		
	//아레나 관련 델리게이트
	RegisterDelegateHandler(EDelegateHandlerType.EDHandler_Arena);
//	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0 , 0);	
}

defaultproperties
{
}
