class BR_CampaignAlarmWnd extends UICommonAPI;

const MAX_COUNT = 6;

const TIMER_ID = 501;

const TIMER_DELAY = 5000;


var WindowHandle Me;

//?ǥ ��ư
var ButtonHandle CampaignInfoButton;

var TextBoxHandle CampaignTitle;
//�ð�ǥ��
var TextBoxHandle TimeTitle;
//�����ð�
var TextBoxHandle Time;

//��� ��ư
var ButtonHandle Resultbtn;
//â ���� ��.
var TextureHandle Divider;

//������ ��
var BarHandle GoalGage1;
var BarHandle GoalGage2;
var BarHandle GoalGage3;
var BarHandle GoalGage4;
var BarHandle GoalGage5;
var BarHandle GoalGage6;

//������ �� 6�� �迭
var array<BarHandle> arrStatus;

//�׸�
var TextBoxHandle GoalTitle1;
var TextBoxHandle GoalTitle2;
var TextBoxHandle GoalTitle3;
var TextBoxHandle GoalTitle4;
var TextBoxHandle GoalTitle5;
var TextBoxHandle GoalTitle6;

//�׸� 6�� �迭
var array<TextBoxHandle> arrGoalTitle;

var bool bAccpept;

var int mID;
var int mSTEP;
var int mGoalGroupID;
var int mState;

var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent( EV_BR_Event_CampaignArrived );
	RegisterEvent( EV_BR_Event_CampaignProgressInfo );
	RegisterEvent( EV_BR_Event_CampaignFinish );

	RegisterEvent( EV_Restart );
}

function OnLoad()
{
	

	Me = GetWindowHandle( "BR_CampaignAlarmWnd" );
	Resultbtn = GetButtonHandle( "BR_CampaignAlarmWnd.Resultbtn" );
	Divider = GetTextureHandle ( "BR_CampaignAlarmWnd.Divider" );
	
	CampaignTitle = GetTextBoxHandle ( "BR_CampaignAlarmWnd.CampaignTitle" );
	TimeTitle = GetTextBoxHandle ( "BR_CampaignAlarmWnd.TimeTitle" );
	Time = GetTextBoxHandle ( "BR_CampaignAlarmWnd.Time" );
	  
	GoalGage1 = GetBarHandle( "BR_CampaignAlarmWnd.GoalGage1" );
	GoalGage2 = GetBarHandle( "BR_CampaignAlarmWnd.GoalGage2" );
	GoalGage3 = GetBarHandle( "BR_CampaignAlarmWnd.GoalGage3" );
	GoalGage4 = GetBarHandle( "BR_CampaignAlarmWnd.GoalGage4" );
	GoalGage5 = GetBarHandle( "BR_CampaignAlarmWnd.GoalGage5" );
	GoalGage6 = GetBarHandle( "BR_CampaignAlarmWnd.GoalGage6" );

	GoalTitle1 = GetTextBoxHandle ( "BR_CampaignAlarmWnd.GoalTitle1" );
	GoalTitle2 = GetTextBoxHandle ( "BR_CampaignAlarmWnd.GoalTitle2" );
	GoalTitle3 = GetTextBoxHandle ( "BR_CampaignAlarmWnd.GoalTitle3" );
	GoalTitle4 = GetTextBoxHandle ( "BR_CampaignAlarmWnd.GoalTitle4" );
	GoalTitle5 = GetTextBoxHandle ( "BR_CampaignAlarmWnd.GoalTitle5" );
	GoalTitle6 = GetTextBoxHandle ( "BR_CampaignAlarmWnd.GoalTitle6" );
	  
    util = L2Util(GetScript("L2Util"));

	arrStatus.Length = MAX_COUNT;
	arrGoalTitle.Length = MAX_COUNT;

	arrStatus[0] = GoalGage1;
	arrStatus[1] = GoalGage2;
	arrStatus[2] = GoalGage3;
	arrStatus[3] = GoalGage4;
	arrStatus[4] = GoalGage5;
	arrStatus[5] = GoalGage6;

	arrGoalTitle[0] = GoalTitle1;
	arrGoalTitle[1] = GoalTitle2;
	arrGoalTitle[2] = GoalTitle3;
	arrGoalTitle[3] = GoalTitle4;
	arrGoalTitle[4] = GoalTitle5;
	arrGoalTitle[5] = GoalTitle6;

	OnRegisterEvent();
}

// ��ưŬ�� �̺�Ʈ
function OnClickButton( string strID )
{
	//Debug("strID>>>" $ strID );

	if( strID == "CampaignInfoButton" )
	{
		//Debug( "mID-->" $ string( mID ) );
		//Debug( "mSTEP-->" $ string( mSTEP ) );
		RequestEventCampaignHtml( mID, mSTEP, mGoalGroupID );
	}
	else if( strID == "Resultbtn" )
	{
		RequestEventCampaignHtml( mID, mSTEP, mGoalGroupID );
	}
	else if( strID == "CloseButton" )
	{
		Me.HideWindow();
	}
}

function OnTimer(int TimerID)
{
	if( TimerID == TIMER_ID )
	{
		//Debug("OnTimer?? OnTimer");
		RequestEventCampaignProgressInfo( mID, mSTEP, mGoalGroupID );
	}
}

function OnEvent( int Event_ID, string param )
{
	switch( Event_ID )
	{
		//������Ʈ ���� ��
		case EV_BR_Event_CampaignArrived :
			//Debug("EV_CampaignArrived");
			CampaignArrived( param );
			break;
		//�� ����Ʈ ���� ��
		case EV_BR_Event_CampaignProgressInfo :
			//Debug("EV_CampaignProgressInfo");
			CampaignProgressInfo( param );
			break;
		//�� ����Ʈ �Ϸ�
		case EV_BR_Event_CampaignFinish :
			//Debug("EV_CampaignFinish");
			CampaignFinish( param );
			break;
		
		//����ŸƮ�� �ʱ�ȭ
		case EV_Restart :
			initCampaign();
			break;
	}
}

function initCampaign()
{
	bAccpept = false;
	Me.KillTimer( TIMER_ID );
}

function CampaignArrived( string param )
{
	//5210
	//ID=1 STEP=1 STATE=1

	//dquest dc_start 1 1
	//dquest accept 1 1
	//dquest accept 1 campaignId

	local int ID;
	local int STEP;
	local int GoalGroupID;

	initCampaign();

	ParseInt(param, "ID", ID);
	ParseInt(param, "STEP", STEP);
	ParseInt(param, "GOALGROUPID", GoalGroupID);
	
	mID = ID;
	mSTEP = STEP;
	mGoalGroupID = GoalGroupID;
	mState = 0;

	//Debug( "ID-->" $ string( ID ) );
	//Debug( "STEP-->" $ string( STEP ) );
	
	class'UIAPI_WINDOW'.static.ShowWindow("RadarMapWnd.BR_CampaignBtn");
	class'UIAPI_EFFECTBUTTON'.static.BeginEffect("RadarMapWnd.BR_CampaignBtn", 0);		
}

function CampaignProgressInfo( string param )
{
	//5230
	//ID=1 STEP=1 STATE=1 ParticipantsCnt=0 RemainTimeInSec=3600 GoalCnt=2 CurValue_0=0 GoalValue_0=10 CurValue_1=3 GoalValue_1=10 
	//dquest info 1 1
	//dquest point 1 1 101 1 1
	//dquest ranking 1 1
	//dquest reward 1 1
	local int i;
	local int ID;
	local int STEP;
	local int GoalGroupID;
	local int STATE;
	local int GoalCnt;
	local int ParticipantsCnt;
	local int RemainTimeInSec;

	local int CurValue;
	local int GoalValue;

	local EventContentInfo info;

	local NoticeWnd notice;
	
	if( bAccpept == false )
	{
		//ķ���� �˸� ��ư ����.
		notice = NoticeWnd( GetScript("NoticeWnd") );
		notice.ClearBRCampaignBtn();
		Me.ShowWindow();
		bAccpept = true;
		Me.SetTimer( TIMER_ID, TIMER_DELAY );
	}
		
	ParseInt(param, "ID", ID);
	ParseInt(param, "STEP", STEP);
	ParseInt(param, "GOALGROUPID", GoalGroupID);
	ParseInt(param, "STATE", STATE);
	ParseInt(param, "GoalCnt", GoalCnt);
	//������ �� (ķ������ 0)
	ParseInt(param, "ParticipantsCnt", ParticipantsCnt);
	//���� �ð�
	ParseInt(param, "RemainTimeInSec", RemainTimeInSec);

	
	//TEST����...������ 
	//ParseInt(param, "ParticipantsCnt", RemainTimeInSec);
	//ParseInt(param, "RemainTimeInSec", ParticipantsCnt);

	mID = ID;
	mSTEP = STEP;
	mGoalGroupID = GoalGroupID;
	mState = STATE;

	/*
	Debug( "ID-->" $ string( ID ) );
	Debug( "STEP-->" $ string( STEP ) );
	Debug( "STATE-->" $ string( STATE ) );
	Debug( "GoalCnt-->" $ string( GoalCnt ) );
	Debug( "ParticantsCnt-->" $ string( ParticipantsCnt ) );
	Debug( "RemainTimeInSec-->" $ string( RemainTimeInSec ) );
*/

	GetEventContentInfo( ID, STEP, GoalGroupID, info );
	
	//���� �ð� �����ֱ�
	Time.SetText( util.TimeNumberToHangulHourMin( RemainTimeInSec ) );	

	setWindowSize( GoalCnt, STATE );
	setWindowShow( GoalCnt, info );	

	for( i = 0 ; i < GoalCnt ; i++ )
	{
		ParseInt(param, "CurValue_"$i, CurValue );
		ParseInt(param, "GoalValue_"$i, GoalValue );
		//Debug("CurValue_"$string(i) $ ">>>>>>>>>"$ string(CurValue) );
		//Debug("GoalValue_"$string(i) $ ">>>>>>>>>"$ string(GoalValue) );

		//BarHandle��
		arrStatus[i].SetValue( GoalValue, CurValue );
	}
}

function CampaignFinish( string param )
{
	local int ID;
	local int STEP;
	local int GoalGroupID;

	ParseInt(param, "ID", ID);
	ParseInt(param, "STEP", STEP);
	ParseInt(param, "GOALGROUPID", GoalGroupID);

	mID = ID;
	mSTEP = STEP;
	mState = 0;
	mGoalGroupID = GoalGroupID;

	//Debug( "ID-->" $ string( ID ) );
	//Debug( "STEP-->" $ string( STEP ) );

	class'UIAPI_WINDOW'.static.HideWindow("RadarMapWnd.BR_CampaignBtn");
	Me.HideWindow();

	initCampaign();
}


//âũ�� ���� �� �����ð� Ÿ��Ʋ
function setWindowSize( int count, int State )
{
	local int size;
	local int h;

	switch( State )
	{
		//������
		case 1:
			size = 93;
			h = size + ( 33 * (count - 1) );

			//�����ð�
			TimeTitle.SetText( GetSystemString(1108) );

			Resultbtn.HideWindow();
			Divider.HideWindow();
			break;
		
		//������
		case 2:
			size = 125;
			h = size + ( 33 * (count - 1) );
			
			//���󰡴� �ð�
			TimeTitle.SetText( GetSystemString(2423) );
			
			Resultbtn.SetButtonName( 2279 );
			Resultbtn.ShowWindow();
			Divider.ShowWindow();
			break;

		//�������
		case 3:
			size = 125;
			h = size + ( 33 * (count - 1) );

			//���󰡴� �ð�
			TimeTitle.SetText( GetSystemString(2423) );

			Resultbtn.SetButtonName( 2426 );
			Resultbtn.ShowWindow();
			Divider.ShowWindow();
			break;
		
		//������
		case 4:
			size = 125;
			h = size + ( 33 * (count - 1) );

			//������� �����ð�
			TimeTitle.SetText( GetSystemString(2424) );

			Resultbtn.SetButtonName( 2425 );
			Resultbtn.ShowWindow();
			Divider.ShowWindow();
			break;
	}

	Me.SetWindowSize( 213, h );
}

//â ���� ������Ʈ
function setWindowShow( int count, EventContentInfo info )
{
	local int i;
	
	//CampaignTitle.SetText( info.Title );
	CampaignTitle.SetText( info.Name );
	CampaignTitle.SetTextEllipsisWidth( 160 );

	CampaignTitle.SetTooltipString( info.Tooltip );
	
	for( i = 0 ; i < MAX_COUNT ; i++ )
	{
		if( i < count )
		{
			arrGoalTitle[i].ShowWindow();
			arrGoalTitle[i].SetText( "- " $ info.GoalDescription[i] );
			arrStatus[i].ShowWindow();
		}
		else
		{
			arrGoalTitle[i].HideWindow();
			arrStatus[i].HideWindow();
		}
	}
	/*
	for( i = 1 ; i <= MAX_COUNT ; i++ )
	{
		if( i <= count )
		{
			GetTextBoxHandle( "CampaignAlarmWnd.GoalTitle"$i ).ShowWindow();
			GetTextBoxHandle( "CampaignAlarmWnd.GoalTitle"$i ).SetText( "- " $ info.GoalDescription[i - 1] );
			GetBarHandle( "CampaignAlarmWnd.GoalGage" $ i ).ShowWindow();
		}
		else
		{
			GetTextBoxHandle( "CampaignAlarmWnd.GoalTitle"$i ).HideWindow();
			GetBarHandle( "CampaignAlarmWnd.GoalGage" $ i ).HideWindow();
		}
	}*/
}

//���̴� ��ư Ŭ�� ���� ���.
function RaderButtonClick()
{
	if( mState == 0 )
	{
		//Debug( "mID-->" $ string( mID ) );
		//Debug( "mSTEP-->" $ string( mSTEP ) );
		RequestEventCampaignHtml( mID, mSTEP, mGoalGroupID );
	}
	else 
	{
		if( !Me.IsShowWindow() )
			Me.ShowWindow();
		else 
			Me.HideWindow();
	}
}


function int getCampaignState()
{
	return mState;
}

defaultproperties
{
}
