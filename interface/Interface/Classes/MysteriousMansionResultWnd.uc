//------------------------------------------------------------------------------------------------------------------------
//
// ����       : ȥ���� ���� ���â
// Ư¡       : ����Ʈ ��Ʈ��
//
//------------------------------------------------------------------------------------------------------------------------
class MysteriousMansionResultWnd extends UICommonAPI;
// ������ ����
var string              m_WindowName;
var WindowHandle        Me;
// ����Ʈ ����
var ListCtrlHandle      listCtrl;

struct ResultDataStruct
{
	var string UserName ;
	var int ClassID ;
	var int LifeTimeInSec ;
	var int KillCnt ;
};

// â ������ �ð� Ÿ�̸�
const TIMER_ID      = 148 ;
const TIMER_DELAY   = 20000 ;

var string userFakeName;

function OnRegisterEvent()
{
	//gfx �̺�Ʈ�� Ǯ���� Ŭ���̾�Ʈ ���� �ʿ� 
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
	// ���� �ɸ��� ���� �˱� ���� userFakeName �̸��� �޾� ��.
	case EV_CuriousHouseMemberList :        //9341		
		HandleMemberList(a_param);
		break;
	// �¸� ���θ� ó��
	case EV_CuriousHouseResultIsVictory :   //9370		
		HandleResultIsVictory(a_param); 
		break;
	// ������ ����
	case EV_CuriousHouseResultListStart:    //9380
		listCtrl.DeleteAllItem();
		break;
	// ����Ʈ 
	case EV_CuriousHouseResultList :        //9381		
		HandleResultList(a_param);
		break;
	// �����츦 �����ݴϴ�.
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

// ������ �ӽ� �̸��� �޾� ��.
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
			getTextBoxHandle( m_WindowName $ ".resultTxt" ).setText(getSystemString( 846 )); 	//���º�
		break;
		case 1 :
			getTextBoxHandle( m_WindowName $ ".resultTxt" ).setText(getSystemString( 828 ));   // ...  �¸�				
		break;
		case 2 :
			getTextBoxHandle( m_WindowName $ ".resultTxt" ).setText(getSystemString( 2356 ));  //�й�
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

	// �ڱ� �̸��� userFakeName�� ������ 
	if (userFakeName == resultData.UserName) 
	{
		if(GetPlayerInfo(userinfo))
			resultData.UserName = userinfo.Name; //username�� �ڱ� �̸��� �ø�

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
 * ������ ESC Ű�� �ݱ� ó�� 
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
