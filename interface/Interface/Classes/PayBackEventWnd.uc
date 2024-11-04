class PayBackEventWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle PayBackEvent_Btn;
var int Activate;

function OnLoad()
{
	Initialize();
}

function OnRegisterEvent()
{
	RegisterEvent(EV_PaybackUILauncher);
}

function Initialize()
{
	Me = GetWindowHandle("PayBackEventWnd");
	PayBackEvent_Btn = GetButtonHandle("PayBackEventWnd.PayBackEvent_Btn");
}


//----------------------------------------------------------------------------------------------------------------------------------------------------------------
// OnEvent
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnEvent( int Event_ID, string param )
{
	switch(Event_ID)
	{
		case EV_PaybackUILauncher :
			//Debug("--- EV_PaybackUILauncher : " @ param);
			openUI( param );	
			break;
	}
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "PayBackEvent_Btn":
			//Debug("--- EV_PaybackUILauncher :ShowWindow");
			OpenPayBackWnd();
			break;
	}
}


function openUI( string param )
{
	parseInt ( param, "Activate", Activate );
	if( Activate == 1)
	{
		Me.ShowWindow();
	}
}

function OpenPayBackWnd()
{
	RequestPaybackList( PAYBACK_EVENT_ID_TYPE.CR_EVENT_LCOIN_2018 );
}

defaultproperties
{
}
