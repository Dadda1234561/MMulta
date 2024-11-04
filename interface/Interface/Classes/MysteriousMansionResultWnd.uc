//------------------------------------------------------------------------------------------------------------------------
//
// 제목       : 혼돈의 제전 결과창
// 특징       : 리스트 컨트롤
//
//------------------------------------------------------------------------------------------------------------------------
class MysteriousMansionResultWnd extends UICommonAPI;
// 윈도우 공통
var string              m_WindowName;
var WindowHandle        Me;
// 리스트 공통
var ListCtrlHandle      listCtrl;

struct ResultDataStruct
{
	var string UserName ;
	var int ClassID ;
	var int LifeTimeInSec ;
	var int KillCnt ;
};

// 창 닫히는 시간 타이머
const TIMER_ID      = 148 ;
const TIMER_DELAY   = 20000 ;

var string userFakeName;

function OnRegisterEvent()
{
	//gfx 이벤트로 풀려면 클라이언트 수정 필요 
	//registerGFxEvent(EV_CuriousHouseResultIsVictory);
	//registerGFxEvent(EV_CuriousHouseResultListStart);
	//registerGFxEvent(EV_CuriousHouseResultList);
	//registerGFxEvent(EV_CuriousHouseResultListEnd);
	//registerGFxEvent(EV_CuriousHouseMemberList);

    registerEvent(EV_CuriousHouseResultIsVictory);
	registerEvent(EV_CuriousHouseResultListStart);
	registerEvent(EV_CuriousHouseResultList);
	registerEvent(EV_CuriousHouseResultListEnd);
	registerEvent(EV_CuriousHouseMemberList);
}

function OnLoad()
{
	m_WindowName = getCurrentWindowName(String(self));
	Me = GetWindowHandle ( m_WindowName ) ;

	SetClosingOnESC();
	listCtrl = GetListCtrlHandle( m_WindowName $ ".Result_ListCtrl");
	listCtrl.SetColumnMinimumWidth( true ) ;	
}

function OnEvent(int Event_ID, string a_param)
{
	//Debug ("my OnEvent" @  Event_ID  @ a_param ) ;	
	switch (Event_ID)
	{
	// 본인 케릭터 인지 알기 위해 userFakeName 이름을 받아 둠.
	case EV_CuriousHouseMemberList :        //9341		
		HandleMemberList(a_param);
		break;
	// 승리 여부를 처리
	case EV_CuriousHouseResultIsVictory :   //9370		
		HandleResultIsVictory(a_param); 
		break;
	// 데이터 삭제
	case EV_CuriousHouseResultListStart:    //9380
		listCtrl.DeleteAllItem();
		break;
	// 리스트 
	case EV_CuriousHouseResultList :        //9381		
		HandleResultList(a_param);
		break;
	// 윈도우를 보여줍니다.
	case EV_CuriousHouseResultListEnd  :    //9382
		Me.ShowWindow() ;
		break;
	}
}

function onSHow()
{
	Me.SetTimer(TIMER_ID,TIMER_DELAY) ;
}

function onHide ()
{
	Me.KillTimer(TIMER_ID);
}

function OnTimer(int TimerID)
{
	switch ( TimerID ) 
	{
		case TIMER_ID: 
			Me.HideWindow();
		break;
	}
}

function OnClickButton( string strID )
{
	Me.HideWindow() ;
}

// 유저의 임시 이름을 받아 둠.
function HandleMemberList(string a_param)
{
	local UserInfo  userinfo;
	local int       ServerID;	

	ParseInt( a_param , "ServerID", ServerID);	
	if ( GetPlayerInfo ( userinfo ))
		if ( userinfo.nID == ServerID )
			ParseString(a_param, "UserName", userFakeName);
}


function HandleResultIsVictory (string a_param)
{	
	local int isVictory;
	ParseInt(a_param, "isVictory", isVictory);

	switch ( isVictory ) 
	{	
		case 0 :
			getTextBoxHandle( m_WindowName $ ".resultTxt" ).setText(getSystemString( 846 )); 	//무승부
		break;
		case 1 :
			getTextBoxHandle( m_WindowName $ ".resultTxt" ).setText(getSystemString( 828 ));   // ...  승리				
		break;
		case 2 :
			getTextBoxHandle( m_WindowName $ ".resultTxt" ).setText(getSystemString( 2356 ));  //패배
		break;
	}
}

function HandleResultList (string a_param)
{
	local UserInfo userinfo;

	local ResultDataStruct resultData ;
	local LVDataRecord record;

	ParseString(a_param, "UserName",    resultData.UserName);
	ParseInt(a_param, "ClassID",        resultData.ClassID);
	Parseint(a_param, "LifeTimeInSec",  resultData.LifeTimeInSec);
	ParseInt(a_param, "KillCnt",        resultData.KillCnt);

	// 자기 이름과 userFakeName이 같으면 
	if (userFakeName == resultData.UserName) 
	{
		if(GetPlayerInfo(userinfo))
			resultData.UserName = userinfo.Name; //username로 자기 이름을 올림

		GetTextBoxHandle (m_WindowName $ ".ResultMyName_Text" ).SetText( resultData.UserName ) ;
		GetTextBoxHandle (m_WindowName $ ".ResultMyClass_Text").SetText( getClassType( resultData.ClassID) );
		GetTextBoxHandle (m_WindowName $ ".ResultMyTime_Text" ).SetText( resultData.LifeTimeInSec @ getSystemString(2001)) ;		
		GetTextBoxHandle (m_WindowName $ ".ResultMyKill_Text" ).SetText( String ( resultData.KillCnt) ) ;
	}

	record.LVDataList.Length = 4;
	record.LVDataList[0].szData = resultData.UserName;
	record.LVDataList[1].szData = getClassType( resultData.ClassID);
	record.LVDataList[2].szData = String(resultData.KillCnt);
	record.LVDataList[2].textAlignment = TA_Center;
	record.LVDataList[3].szData = resultData.LifeTimeInSec @ getSystemString(2001);
	record.LVDataList[3].textAlignment = TA_Center;
	//record.LVDataList[0].FirstLineOffsetX = -20;

	listCtrl.InsertRecord( record ) ;
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( m_WindowName ).HideWindow();
}

defaultproperties
{
}
