//------------------------------------------------------------------------------------------------------------------------
//
// ����         : Menu �������� ���� - SCALEFORM UI
//                ���� �޴�
//
//------------------------------------------------------------------------------------------------------------------------
class ArenaRevivalWnd extends L2UIGFxScript;

function OnRegisterEvent()
{	

}

function OnLoad()
{		
	AddState( "ARENAGAMINGSTATE" );
	AddState( "ARENABATTLESTATE" );
	AddState( "ARENAPICKSTATE" );
	
	SetContainerWindow(WINDOWTYPE_NONE, 0);
	SetHavingFocus( false );
}

function OnFlashLoaded()
{		
	SetRenderOnTop(true);
	SetAlwaysFullAlpha(true);
	SetAnchor("", EAnchorPointType.ANCHORPOINT_CenterCenter, EAnchorPointType.ANCHORPOINT_CenterCenter, 0 , -50);	
}


function onEvent ( int id, string param) 
{
	//Debug ( "onEvent" @ id @ param ) ;
	switch ( id ) 
	{
	//	case EV_UpdateMyHP : HandleUpdateHP( param ) ;break;
		case EV_RestartMenuShow : ShowWindow() ;break;
		case EV_RestartMenuHide : 
		case EV_Restart :hideWindow() ;break;
	}
}

defaultproperties
{
}
