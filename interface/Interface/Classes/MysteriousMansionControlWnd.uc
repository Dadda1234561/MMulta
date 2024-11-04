class MysteriousMansionControlWnd extends UIScript;

var WindowHandle Me;
var ButtonHandle btnRecord;
var ButtonHandle btnGuide;
var ButtonHandle btnOtherGame;
var ButtonHandle btnStop;

var WindowHandle OlympiadGuideWnd;

function OnLoad()
{
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle( "MysteriousMansionControlWnd" );
	btnRecord = GetButtonHandle( "MysteriousMansionControlWnd.btnRecord" );
	btnGuide = GetButtonHandle( "MysteriousMansionControlWnd.btnGuide" );
	btnOtherGame = GetButtonHandle( "MysteriousMansionControlWnd.btnOtherGame" );
	btnStop = GetButtonHandle( "MysteriousMansionControlWnd.btnStop" );

	OlympiadGuideWnd = GetWindowHandle( "OlympiadGuideWnd" );
}



function OnShow()
{	
	local OlympiadGuideWnd script;
	script = OlympiadGuideWnd(GetScript("OlympiadGuideWnd"));
	script.MysteriousMansionShow(); //���̵� �����츦 ������
}

function OnHide()
{
	local OlympiadGuideWnd script;
	script = OlympiadGuideWnd(GetScript("OlympiadGuideWnd"));
	script.MysteriousMansionHide(); //���̵� �����츦 ������� ��
}

function OnRegisterEvent()
{	
	//registerState( "MysteriousMansionControlWnd", "CuriousHouseObserverState" );
	RegisterEvent( EV_ReplayRecStarted );
	RegisterEvent( EV_ReplayRecEnded );

}


function OnEvent( int Event_ID, String Param )
{
	switch(Event_ID)
	{
	case EV_ReplayRecStarted:
		btnRecord.SetButtonName( 2301 );
		break;
	case EV_ReplayRecEnded:
		btnRecord.SetButtonName( 2300 );
		break;
	}
}


function OnClickButton(string strID)
{	
	switch (strID)
	{
		case "btnStop":
			RequestLeaveObservingCuriousHouse();
			break;
		case "btnOtherGame":
			RequestObservingListCuriousHouse();
			break;
			
		case "btnRecord":
			ToggleReplayRec();
			break;
		case "btnGuide":
			showGuidWnd();
			break;
	}
}

function showGuidWnd()
{	
	local OlympiadGuideWnd script;
	script = OlympiadGuideWnd(GetScript("OlympiadGuideWnd"));
	script.OpenCloseGuide();	
}

defaultproperties
{
}
