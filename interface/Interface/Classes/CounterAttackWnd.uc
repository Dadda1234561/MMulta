// 반격 UI 
class CounterAttackWnd extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;

var int  clickedX, clickedY ;
var bool OnMousePressed;

var AutoUseItemWnd autoUseItemWndScript;

const TIMER_ID      = 111;
//const TIMER_DELAY   = 1800;
const TIMER_DELAY   = 180000;

function OnRegisterEvent()
{
	RegisterEvent( EV_CounterAttackListAdded );
	RegisterEvent( EV_CounterAttackListEmpty );
}

function OnLoad()
{
	Me = GetWindowHandle ( m_WindowName ) ;
	autoUseItemWndScript = AutoUseItemWnd ( GetScript ( "AutoUseItemWnd" ) ) ;
}

function OnLButtonDown ( WindowHandle a_WindowHandle, int X, int Y ) 
{
	local Rect rectWnd;

	rectWnd = Me.GetRect();	

	clickedX = rectWnd.nX; 
	clickedY = rectWnd.nY;
}

function OnShow () 
{	
	Me.SetTimer ( TIMER_ID, TIMER_DELAY ) ;
}

function OnHide ( ) 
{
	Me.KillTimer( TIMER_ID ) ;
}

function OnTimer (int TimerID)
{
	switch (TimerID )
	{
		case TIMER_ID : 
			// Debug("반격기 없애기") ;
			ResetCounterAttackList ();
		break;
	}
}

function function OnClickButton( string Name )
{
	local Rect rectWnd;

	switch ( Name) 
	{
		case "CounterAttackIcon": 
			rectWnd = Me.GetRect();			
			if ( getAbs(clickedX - rectWnd.nX ) > 3 || clickedY - rectWnd.nY > 3 ) {return;}

			if ( autoUseItemWndScript.autotarget_bUseAutoTarget ) autoUseItemWndScript.requestAutoPlay ( false ) ;
			
			SelectCounterAttackTarget ();
		break;
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	switch ( a_EventID ) 
	{
		case EV_CounterAttackListAdded :
			if(!Me.IsShowWindow())
			{
				Me.ShowWindow();
				Me.SetFocus();
			}
			break;
		case EV_CounterAttackListEmpty:
			Me.HideWindow();
			break;
	}
}

function int getAbs(int num)
{
	if(num < 0)
	{
		return - num;
	}
	return num;
}

defaultproperties
{
     m_WindowName="CounterAttackWnd"
}
