class BirthdayAlarmWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle BirthDayItem;
var TextBoxHandle itemAlarmTxt;
var ButtonHandle btnOk;

function OnRegisterEvent()
{
	registerEvent( EV_BirthdayItemAlarm );
	
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		Initialize();
	else
		InitializeCOD();

}

function OnShow()
{

}

function Initialize()
{
	Me = GetHandle( "BirthdayAlarmWnd" );
	BirthDayItem = TextureHandle ( GetHandle( "BirthDayItem" ) );
	itemAlarmTxt = TextBoxHandle ( GetHandle( "itemAlarmTxt" ) );
	btnOk = ButtonHandle ( GetHandle( "btnOK" ) );

}

function InitializeCOD()
{
		Me = GetWindowHandle( "BirthdayAlarmWnd" );
		BirthDayItem = GetTextureHandle ( "BirthdayAlarmWnd.BirthDayItem" );
		itemAlarmTxt = GetTextBoxHandle ( "BirthdayAlarmWnd.itemAlarmTxt" );
		btnOk = GetButtonHandle ( "BirthdayAlarmWnd.btnOK" );
}

function Load()
{

}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_BlockStateTeam:
		break;
		
	}

}

function OnClickButton(string Name)
{
	switch(Name)
	{
	case "btnOK":
		Me.hideWindow();
		break;
	}
}

//상태가 변할 경우 무조건 닫아준다.
function OnExitState( name a_CurrentStateName )
{
	Me.HideWindow();
}

defaultproperties
{
}
