//------------------------------------------------------------------------------------------------------------------------
//
// ����         : Menu �������� ���� - SCALEFORM UI
//                ���� �޴�
//
//------------------------------------------------------------------------------------------------------------------------
class ArenaMatchWnd extends L2UIGFxScript;

function OnRegisterEvent()
{	
	RegisterEvent( EV_StateChanged );
	
	RegisterGFxEvent( EV_RequestMatchArena );
	RegisterGFxEvent( EV_CompleteMatchArena );
	RegisterGFxEvent( EV_ConfirmMatchArena );
	RegisterGFxEvent( EV_CancelMatchArena );

	// ��Ƽ ���¿� �ٶ� �ٸ��� ǥ�� �ϵ���	
	RegisterGFxEvent( EV_BecamePartyMaster );   //��Ƽ���̵�
	RegisterGFxEvent( EV_RecvPartyMaster );     //��Ƽ���� �̾����	

	RegisterGFxEvent( EV_HandOverPartyMaster ); //4918 ��Ƽ���� �絵�� 
	
	RegisterGFxEvent( EV_PartyAddParty );       //��Ƽ Ȥ�� ����	

	RegisterGFxEvent( EV_PartyDeleteAllParty ); //��� ��Ƽ�� ����
}

function OnLoad()
{		
	AddState( "ARENAGAMINGSTATE" );
	SetContainerHUD(WINDOWTYPE_NONE, 0);

	setHUD();
	setDefaultShow(true);		
	SetHavingFocus( false );
}

function OnEvent(int Event_ID, string param)
{
	if(Event_ID == EV_StateChanged)
	{
		//Debug( "ArenaMatchWnd- EV_StateChanged ->" @  param );
		if (param == "ARENAGAMINGSTATE")
		{
			ShowWindow();			
			GetWindowHandle("ChatWnd").ShowWindow();
			GetWindowHandle("ShortcutWnd").ShowWindow();			
			//ExecuteCommand("//set_member_arena 2");
		}
		else if( param == "ARENAPICKSTATE" )
		{
			HideWindow();
		}
		else if( param == "ARENABATTLESTATE" )
		{
			GetWindowHandle("ChatWnd").ShowWindow();
			GetWindowHandle("ShortcutWnd").ShowWindow();			
			HideWindow();
		}

	}
}

function OnFlashLoaded()
{		
	SetAnchor("", EAnchorPointType.ANCHORPOINT_BottomCenter, EAnchorPointType.ANCHORPOINT_TopCenter, 0 , 0 );	
}

defaultproperties
{
}
