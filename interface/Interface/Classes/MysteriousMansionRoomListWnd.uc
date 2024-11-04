//------------------------------------------------------------------------------------------------------------------------
//
// 제목       : 혼돈의 제전 방 리스트
//
//------------------------------------------------------------------------------------------------------------------------
class MysteriousMansionRoomListWnd extends UICommonAPI;
// 윈도우 공통
var string              m_WindowName;
var WindowHandle        Me;

// 리스트 공통
var ListCtrlHandle      listCtrl;

// 비활성화 시켜야 할 버튼
var ButtonHandle refreshButton;

// 버튼 리셋 타이머
const TIMER_ID      = 148 ;
const TIMER_DELAY   = 3000 ;

struct roomDataStruct 
{
	var int     ID ;
	var String  HouseName;
	var int     State ;
	var int     Count ;
};

function OnRegisterEvent()
{
        //registerGfxEvent(EV_CuriousHouseObserveListStart);
        //registerGfxEvent(EV_CuriousHouseObserveList);
        //registerGfxEvent(EV_CuriousHouseObserveListEnd);

		registerEvent(EV_CuriousHouseObserveListStart); 
        registerEvent(EV_CuriousHouseObserveList);
        registerEvent(EV_CuriousHouseObserveListEnd);
}

function OnLoad()
{   
	m_WindowName = getCurrentWindowName(String(self));
	Me = GetWindowHandle ( m_WindowName ) ;

	SetClosingOnESC();
	listCtrl = GetListCtrlHandle( m_WindowName $ ".RoomList_ListCtrl");
	listCtrl.SetColumnMinimumWidth( true ) ;	

	refreshButton = GetButtonHandle ( m_WindowName $ ".refresh_Button");
}

function OnEvent(int Event_ID, string a_param)
{
	//Debug ("my OnEvent" @  Event_ID  @ a_param ) ;	
	switch (Event_ID)
	{
		case EV_CuriousHouseObserveListStart:       //9390
			listCtrl.DeleteAllItem();
		break;
		case EV_CuriousHouseObserveList:            //9391
			HandleRoomList(a_param);
		break;
		case EV_CuriousHouseObserveListEnd:         //9392
			GetWindowHandle(m_WindowName ).ShowWindow() ;
		break;
	}
}

function OnDBClickListCtrlRecord( string ListCtrlID )
{	
	local LVDataRecord record;

	if (listCtrl.GetSelectedIndex() >= 0)
	{
		listCtrl.GetSelectedRec( record );
		RequestObservingCuriousHouse( int ( record.nReserved1) );
	}
}

function OnClickButton( string strID )
{		
	switch ( strID ) 
	{
		case "close_Button" :
			GetWindowHandle(m_WindowName ).HideWindow() ;
		break;
		case "refresh_Button":
			HandleRefresh () ;
		break;
	}	
}


function OnTimer(int TimerID)
{
	switch ( TimerID ) 
	{
		case TIMER_ID: 
			refreshButton.EnableWindow();
		break;
	}
}

function HandleRefresh () 
{
	refreshButton.DisableWindow();
	Me.SetTimer(TIMER_ID, TIMER_DELAY) ;
	RequestObservingListCuriousHouse();  
}

function HandleRoomList (string a_param)
{
	local roomDataStruct roomData ;
	local LVDataRecord record;
	//Debug ( "handleRoomList" @ a_param );
	ParseInt(a_param, "ID",         roomData.ID );
	ParseString(a_param, "HouseName",  roomData.HouseName );
	Parseint(a_param, "State",      roomData.State );
	ParseInt(a_param, "Count",      roomData.Count );	

	if ( roomData.Count <= 0 ) return;

	record.LVDataList.Length = 4;

	record.nReserved1 = roomData.ID;
	// 번호
	record.LVDataList[0].szData = String(listCtrl.GetRecordCount() + 1);
	record.LVDataList[0].textAlignment = TA_Center;
	// 하우스 이름
	record.LVDataList[1].szData = GetSystemString(2806) $ roomData.HouseName;
	record.LVDataList[1].textAlignment = TA_Center;
	// 스테이트
	if ( roomData.State == 0 ) 
		record.LVDataList[2].szData = GetSystemString(1718);
	else 
		record.LVDataList[2].szData = GetSystemString(1719);
	record.LVDataList[2].textAlignment = TA_Center;
	// 인원 수
	record.LVDataList[3].szData = String(roomData.Count);
	record.LVDataList[3].textAlignment = TA_Center;
	
	listCtrl.InsertRecord( record ) ;
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
}
