//------------------------------------------------------------------------------------------------------------------------
//
// 제목       : 올림피아드 방 리스트
//
//------------------------------------------------------------------------------------------------------------------------
class OlympiadArenaListWnd extends UICommonAPI;
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

struct playerDataStruct 
{
	var int     num;
	var int     arenaType;
	var int     arenaState;
	var string  player1Name;
	var string  player2Name;
};

function OnRegisterEvent()
{
	registerEvent(EV_ReceiveOlympiadGameList);
}

function OnLoad()
{   
	m_WindowName = getCurrentWindowName(String(self));
	Me = GetWindowHandle ( m_WindowName ) ;

	SetClosingOnESC();
	listCtrl = GetListCtrlHandle( m_WindowName $ ".OlympiadArenaList_ListCtrl");
	listCtrl.SetColumnMinimumWidth( true ) ;	

	refreshButton = GetButtonHandle ( m_WindowName $ ".refresh_Button");
}

function OnEvent(int Event_ID, string a_param)
{
	//Debug ("my OnEvent" @  Event_ID  @ a_param ) ;	
	switch (Event_ID)
	{
		case EV_ReceiveOlympiadGameList:       //5080
			HandleRoomLists ( a_Param ) ;
			Me.SetFocus();
			break;
	}
}

function OnDBClickListCtrlRecord( string ListCtrlID )
{	
	local LVDataRecord record;

	if (listCtrl.GetSelectedIndex() >= 0)
	{
		listCtrl.GetSelectedRec( record );
		Debug( "onDBClick" @ record.nReserved1 );
		class'OlympiadAPI'.static.RequestExOlympiadWatchGame( int ( record.nReserved1) );
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

function OnHide () 
{
	listCtrl.DeleteAllItem();
}

function HandleRefresh () 
{
	listCtrl.DeleteAllItem();
	class'OlympiadAPI'.static.RequestOlympiadMatchList();
	refreshButton.DisableWindow();
	Me.SetTimer(TIMER_ID, TIMER_DELAY) ;
	//RequestObservingListCuriousHouse();  
}


function HandleRoomLists ( String a_param ) 
{
	local playerDataStruct  playerData;	
	local int               gameNum, i;
	local int               bRemain;	
	//Debug ( "HandleRoomLists" @ a_param ) ;


	// 마지막 들어 오는 정보라면, 딜리트 하고, 
	//if ( bRemain == 0 ) listCtrl.DeleteAllItem();
	//parseInt ( a_param, "gameNum", gameNum );

	listCtrl.DeleteAllItem();
	parseInt ( a_param, "gameNum", gameNum ) ;
	parseInt ( a_param, "bRemain", bRemain ) ;
	for ( i = 0 ; i <  gameNum ; i ++ ) 
	{
		parseInt ( a_param, "num_"$i, playerData.num );
		parseInt ( a_param, "arenaType_"$i, playerData.arenaType );
		parseInt ( a_param, "arenaState_"$i, playerData.arenaState );
		parseString ( a_param, "player1Name_"$i, playerData.player1Name );
		parseString ( a_param, "player2Name_"$i, playerData.player2Name );		
		HandleRoomList( playerData );
	}
	
	if ( bRemain == 0 ) Me.ShowWindow();
}

function HandleRoomList (playerDataStruct playerData)
{
	////Debug ( "handleRoomList" @ a_param );
	local LVDataRecord record;

	record.LVDataList.Length = 5;

	record.nReserved1 = playerData.num + 1 ;
	// 번호
	record.LVDataList[0].szData = String(record.nReserved1);
	record.LVDataList[0].textAlignment = TA_Center;

	// 경기타입
	if ( playerData.arenaType < 3 ) 
		record.LVDataList[1].szData = GetSystemString( 2283 - playerData.arenaType );
	else 
		record.LVDataList[1].szData = "";
	record.LVDataList[1].textAlignment = TA_Center;
	
	// 상태
	if ( playerData.arenaState == 0 ) 
		record.LVDataList[2].szData = GetSystemString(906);
	else 
		record.LVDataList[2].szData = GetSystemString ( 1717 + playerData.arenaState ) ;
	record.LVDataList[2].textAlignment = TA_Center;

	// 플레이어1
	record.LVDataList[3].buseTextColor = True;
	record.LVDataList[3].szData = playerData.player1Name;
	record.LVDataList[3].textAlignment = TA_Center;
	record.LVDataList[3].TextColor.R = 238;
	record.LVDataList[3].TextColor.G = 119;
	record.LVDataList[3].TextColor.B = 119;

	// 플레이어2
	record.LVDataList[4].buseTextColor = True;
	record.LVDataList[4].szData = playerData.player2Name;
	record.LVDataList[4].textAlignment = TA_Center;
	record.LVDataList[4].TextColor.R = 102;
	record.LVDataList[4].TextColor.G = 170;
	record.LVDataList[4].TextColor.B = 238;
	
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
