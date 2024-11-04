/**
 * 
 *  저주 받은 검 (죽었을 때 알림판), 2018.11.29
 *  
 **/
class CursedWeaponMessage extends UICommonAPI;

const TimeID = 102222;
const DELAY_NUM = 10000;

var WindowHandle Me;
var TextBoxHandle Message_Txt;

function OnRegisterEvent()
{
	RegisterEvent(EV_ShowCursedBarrierInfo); // 11120
	RegisterEvent(EV_Restart);	
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle( "CursedWeaponMessage" );
	Message_Txt = GetTextBoxHandle( "CursedWeaponMessage.Message_Txt" );
}

function Load()
{

}

function OnTimer(int nTimeID)
{
	if (TimeID == nTimeID)
	{
		Me.KillTimer(TimeID);
		Me.HideWindow();
	}
}

function OnShow()
{
	Me.KillTimer(TimeID);
	Me.SetTimer(TimeID, DELAY_NUM);
}

//---------------------------------------------------------------------------------------------------------------------------------------
// OnEvent
//---------------------------------------------------------------------------------------------------------------------------------------
function OnEvent( int a_EventID, String a_Param )
{	
	//Debug( "OnEvent" @ a_EventID);
	switch( a_EventID )
	{
		case EV_ShowCursedBarrierInfo:
			Me.ShowWindow();
			break;
		case EV_Restart:
			Me.KillTimer(TimeID);
			Me.HideWindow();
			break;
	}
}

defaultproperties
{
}
