//------------------------------------------------------------------------------------------------------------------------
//
// ����         : Menu �������� ���� - SCALEFORM UI
//                ������
//
//------------------------------------------------------------------------------------------------------------------------
class ArenaMatchGroupWnd extends L2UIGFxScript;

function OnRegisterEvent()
{	
	RegisterGFxEvent( EV_MatchGroup);
	RegisterGFxEvent( EV_MatchGroupAsk);
	RegisterGFxEvent( EV_MatchGroupWithdraw);
	RegisterGFxEvent( EV_MatchGroupOust);
	RegisterGFxEvent( EV_TargetUpdate );
	RegisterGFxEvent( EV_FriendAdded );
	RegisterGFxEvent( EV_FriendRemoved );
	RegisterGFxEvent( EV_Restart );
}


function OnLoad()
{		
	AddState( "ARENAGAMINGSTATE" );	
	SetDefaultShow( true ) ;
	SetContainerWindow(WINDOWTYPE_SIMPLE_DRAG, 0); 
	SetHavingFocus( false );
}

function OnFlashLoaded()
{		
	//IgnoreUIEvent(true);	
	SetAnchor("", EAnchorPointType.ANCHORPOINT_TopLeft, EAnchorPointType.ANCHORPOINT_TopLeft, 0 , 356);	
}

function onCallUCFunction ( string functionName, string param ) 
{
	switch ( functionName ) 
	{
		case "addFriend" :
			class'PersonalConnectionAPI'.static.RequestAddFriend(param);						
			break;
	}
}

defaultproperties
{
}
