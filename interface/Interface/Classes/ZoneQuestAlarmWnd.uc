class ZoneQuestAlarmWnd extends UICommonAPI;

const MAX_COUNT = 6;

const TIMER_ID = 502;

const TIMER_DELAY = 5000;

var WindowHandle Me;

//?ǥ ��ư
var ButtonHandle ZoneQuestInfoButton;
//��� Ÿ��Ʋ
var TextBoxHandle ZoneQuestTitle;

//�ð�ǥ��
var TextBoxHandle TimeTitle;
//�����ð�
var TextBoxHandle Time;
//���� �ο���
var TextBoxHandle ParticipantsCounter;

//��Ȳ����
var ButtonHandle Situationbtn;
//����ޱ�
var ButtonHandle Rewardbtn;
//��� ��ư
var ButtonHandle Resultbtn;
//â ���� ��.
var TextureHandle Divider;

//������ ��
var StatusBarHandle GoalGage1;
var StatusBarHandle GoalGage2;
var StatusBarHandle GoalGage3;
var StatusBarHandle GoalGage4;
var StatusBarHandle GoalGage5;
var StatusBarHandle GoalGage6;

//������ �� 6�� �迭
var array<StatusBarHandle> arrStatus;

//�׸�
var TextBoxHandle GoalTitle1;
var TextBoxHandle GoalTitle2;
var TextBoxHandle GoalTitle3;
var TextBoxHandle GoalTitle4;
var TextBoxHandle GoalTitle5;
var TextBoxHandle GoalTitle6;

//�׸� 6�� �迭
var array<TextBoxHandle> arrGoalTitle;

var int Mid;
var int mSTEP;
var int Mstate;

var bool bAccpept;

var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent( EV_ZoneQuestArrived );
	RegisterEvent( EV_ZoneQuestProgressInfo );
	RegisterEvent( EV_ZoneQuestFinish );

	RegisterEvent( EV_Restart );
}

function OnLoad()
{
	OnRegisterEvent();

	Me = GetWindowHandle("ZoneQuestAlarmWnd");

	Situationbtn = GetButtonHandle("ZoneQuestAlarmWnd.Situationbtn");
	RewardBtn = GetButtonHandle("ZoneQuestAlarmWnd.Rewardbtn");
	Resultbtn = GetButtonHandle("ZoneQuestAlarmWnd.Resultbtn");
	Divider = GetTextureHandle("ZoneQuestAlarmWnd.Divider");

	ZoneQuestTitle = GetTextBoxHandle("ZoneQuestAlarmWnd.ZoneQuestTitle");
	TimeTitle = GetTextBoxHandle("ZoneQuestAlarmWnd.TimeTitle");
	Time = GetTextBoxHandle("ZoneQuestAlarmWnd.Time");
	ParticipantsCounter = GetTextBoxHandle("ZoneQuestAlarmWnd.ParticipantsCounter");

	GoalGage1 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage1");
	GoalGage2 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage2");
	GoalGage3 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage3");
	GoalGage4 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage4");
	GoalGage5 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage5");
	GoalGage6 = GetStatusBarHandle("ZoneQuestAlarmWnd.GoalGage6");

	GoalTitle1 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle1");
	GoalTitle2 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle2");
	GoalTitle3 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle3");
	GoalTitle4 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle4");
	GoalTitle5 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle5");
	GoalTitle6 = GetTextBoxHandle("ZoneQuestAlarmWnd.GoalTitle6");

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
}

function onShow()
{
	RequestDynamicQuestProgressInfo( Mid, mSTEP );
}

// ��ưŬ�� �̺�Ʈ
function OnClickButton( string strID )
{
	//Debug("strID>>>" $ strID );
	//Debug( "mID-->" $ string( Mid ) );
	//Debug( "mSTEP-->" $ string( mSTEP ) );

	if( strID == "ZoneQuestInfoButton" )
	{
		RequestDynamicContentHtml( Mid, mSTEP );
	}
	else if( strID == "Situationbtn" )
	{
		//������ || �������(���Ȯ��)
		if( mState == 1 || mState == 3 )
		{
			ShowWindow("ZoneQuestSituationWnd");
			RequestDynamicQuestScoreInfo( Mid, mSTEP );
		}
		else
		{
			RequestDynamicContentHtml( Mid, mSTEP );
		}
	}
	//���Ȯ��
	else if( strID == "Resultbtn" )
	{
		ShowWindow("ZoneQuestSituationWnd");
		RequestDynamicQuestScoreInfo( Mid, mSTEP );
	}
	//����ޱ�
	else if(strID == "Rewardbtn" )
	{
		RequestDynamicContentHtml( Mid, mSTEP );
	}
	else if( strID == "CloseButton" )
	{
		Me.HideWindow();
	}
}

function OnTimer(int TimerID)
{
	if(TimerID == TIMER_ID )
	{
		//Debug("OnTimer?? OnTimer2222");
		RequestDynamicQuestProgressInfo(Mid, mSTEP);
	}
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		//������Ʈ ���� ��
		case EV_ZoneQuestArrived :
			//Debug("EV_ZoneQuestArrived");
			ZoneQuestArrived( param );
			break;
		//�� ����Ʈ ���� ��
		case EV_ZoneQuestProgressInfo :
			//Debug("EV_ZoneQuestProgressInfo");
			ZoneQuestProgressInfo( param );
			break;
		//�� ����Ʈ �Ϸ�
		case EV_ZoneQuestFinish :
			//Debug("EV_ZoneQuestFinish");
			ZoneQuestFinish( param );
			break;

		//����ŸƮ�� �ʱ�ȭ
		case EV_Restart :
			initZoneQuest();
			break;
	}
}

function initZoneQuest()
{
	bAccpept = false;
	Me.KillTimer(TIMER_ID);
}

function ZoneQuestArrived(string param)
{
	//�� 198679,89754,-192
	//5220
	//ID=1 STEP=1
	//dquest dc_start 2 1
	//dquest accept 2 1

	local int Id;
	local int Step;

	initZoneQuest();

	ParseInt(param, "ID", Id);
	ParseInt(param, "STEP", Step);

	mID = Id;
	mSTEP = Step;
	Mstate = 0;

	//Debug( "ID-->" $ string( ID ) );
	//Debug( "STEP-->" $ string( STEP ) );
	
	// class'UIAPI_WINDOW'.static.ShowWindow("RadarMapWnd.ZoneQuestBtn");
	///class'UIAPI_EFFECTBUTTON'.static.BeginEffect("RadarMapWnd.ZoneQuestBtn", 0);
}

function ZoneQuestProgressInfo(string param)
{
	//5240
	//ID=1 STEP=1 STATE=1 ParticipantsCnt=2500 RemainTimeInSec=3600 GoalCnt=2 CurValue_0=5 GoalValue_0=10 CurValue_1=3 GoalValue_1=10 
	//dquest info 1 1
	local int i;
	local int Id;
	local int Step;
	local int State;
	local int GoalCnt;
	local int ParticipantsCnt;
	local int RemainTimeInSec;

	local int CurValue;
	local int GoalValue;

	local DynamicContentInfo Info;

	local ZoneQuestSituationWnd script;

	script = ZoneQuestSituationWnd( GetScript( "ZoneQuestSituationWnd" ) );
	//Debug(param);

	ParseInt(param, "ID", Id);
	ParseInt(param, "STEP", Step);
	ParseInt(param, "STATE", State);
	ParseInt(param, "GoalCnt", GoalCnt);
	//������ �� (ķ������ 0)
	ParseInt(param, "ParticipantsCnt", ParticipantsCnt);
	//���� �ð�
	ParseInt(param, "RemainTimeInSec", RemainTimeInSec);

	//TEST����...������ 
	//ParseInt(param, "ParticipantsCnt", RemainTimeInSec);
	//ParseInt(param, "RemainTimeInSec", ParticipantsCnt);

	Mid = Id;
	mSTEP = Step;
	Mstate = State;

	//Debug( "ID-->" $ string( ID ) );
	//Debug( "STEP-->" $ string( STEP ) );
	//Debug( "STATE-->" $ string( STATE ) );
	//Debug( "GoalCnt-->" $ string( GoalCnt ) );
	//Debug( "ParticantsCnt-->" $ string( ParticipantsCnt ) );
	//Debug( "RemainTimeInSec-->" $ string( RemainTimeInSec ) );

	GetDynamicContentInfo(Id, Step, Info);

	//���� �ð� �����ֱ�
	Time.SetText( util.TimeNumberToHangulHourMin( RemainTimeInSec ) );
	ParticipantsCounter.SetText( string(ParticipantsCnt) $ GetSystemString(1013) );

	//�ð�, ���� �ο� �־� �ֱ�.
	script.showTimeCounter( util.TimeNumberToHangulHourMin( RemainTimeInSec ), string(ParticipantsCnt) $ GetSystemString(1013) );

	SetWindowSize( GoalCnt, State );
	setWindowShow( GoalCnt, Info );

	for( i = 0 ; i < GoalCnt ; i++ )
	{
		ParseInt(param, "CurValue_"$i, CurValue );
		ParseInt(param, "GoalValue_"$i, GoalValue );
		//Debug("CurValue_"$string(i) $ ">>>>>>>>>"$ string(CurValue) );
		//Debug("GoalValue_"$string(i) $ ">>>>>>>>>"$ string(GoalValue) );

		//StatusBarHandle��
		arrStatus[i].SetPoint( CurValue, GoalValue );
	}

	RequestDynamicQuestScoreInfo( Mid, mSTEP );
}

function ZoneQuestFinish(string param)
{
	local int Id;
	local int Step;

	initZoneQuest();

	ParseInt(param, "ID", Id);
	ParseInt(param, "STEP", Step);

	Mid = Id;
	mSTEP = Step;
	Mstate = 0;

	//Debug( "ID-->" $ string( ID ) );
	//Debug( "STEP-->" $ string( STEP ) );

	// class'UIAPI_WINDOW'.static.HideWindow("RadarMapWnd.ZoneQuestBtn");
	getInstanceNoticeWnd().hideNoticeButton_ZONE();
	Me.HideWindow();
}

//âũ�� ���� �� �����ð� Ÿ��Ʋ
function SetWindowSize(int Count, int State)
{
	local int Size;
	local int h;

	Size = 139;
	h = Size + ( 33 * (count - 1) );

	switch(State)
	{
		//������
		case 1:
			//�����ð�
			TimeTitle.SetText(GetSystemString(1108));
			Situationbtn.SetButtonName(2437);
			Situationbtn.ShowWindow();
			Resultbtn.HideWindow();
			Rewardbtn.HideWindow();
			break;
		//������
		case 2:
			//���󰡴� �ð�
			TimeTitle.SetText(GetSystemString(2423));
			Situationbtn.HideWindow();
			Resultbtn.ShowWindow();
			Rewardbtn.ShowWindow();
			break;
		//�������
		case 3:
			//���󰡴� �ð�
			TimeTitle.SetText(GetSystemString(2423));

			//��� Ȯ��
			Situationbtn.SetButtonName(2426);
			Situationbtn.ShowWindow();
			Resultbtn.SetButtonName(2426);
			Resultbtn.HideWindow();
			Rewardbtn.HideWindow();
			break;
		//������
		case 4:
			//������� �����ð�
			TimeTitle.SetText(GetSystemString(2424));

			//����Ʈ ����
			Situationbtn.SetButtonName(2438);
			Situationbtn.ShowWindow();
			Resultbtn.HideWindow();
			Rewardbtn.HideWindow();
			break;
	}

	Me.SetWindowSize( 213, h );
}

//â ���� ������Ʈ
function setWindowShow(int Count, DynamicContentInfo Info)
{
	local int i;

	ZoneQuestTitle.SetText(Info.Name);
	ZoneQuestTitle.SetTextEllipsisWidth(160);
	ZoneQuestTitle.SetTooltipString(Info.Tooltip);
	
	for( i = 0 ; i < MAX_COUNT ; i++ )
	{
		if(i < Count)
		{
			arrGoalTitle[i].ShowWindow();
			arrGoalTitle[i].SetText( "- " $ Info.GoalDescription[i] );
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
			GetTextBoxHandle( "ZoneQuestAlarmWnd.GoalTitle"$i ).ShowWindow();
			GetTextBoxHandle( "ZoneQuestAlarmWnd.GoalTitle"$i ).SetText( "- " $ info.GoalDescription[i - 1] );
			GetStatusBarHandle( "ZoneQuestAlarmWnd.GoalGage" $ i ).ShowWindow();			
		}
		else
		{
			GetTextBoxHandle( "ZoneQuestAlarmWnd.GoalTitle"$i ).HideWindow();
			GetStatusBarHandle( "ZoneQuestAlarmWnd.GoalGage" $ i ).HideWindow();
		}
	}*/
}

//���̴� ��ư Ŭ�� ���� ���.
function RaderButtonClick()
{
	//�� ����Ʈ �˸� ��ư ����.
	local NoticeWnd notice;

	notice = NoticeWnd(GetScript("NoticeWnd"));
	notice.ClearZoneQuestBtn();

	if(Mstate == 0)
	{
		//Debug( "mID-->" $ string( mID ) );
		//Debug( "mSTEP-->" $ string( mSTEP ) );
		RequestDynamicContentHtml(Mid, mSTEP);
	}
	else 
	{
		if( !Me.IsShowWindow() )
			Me.ShowWindow();
		else 
			Me.HideWindow();

		if( bAccpept == false )
		{
			bAccpept = true;
			Me.SetTimer(TIMER_ID, TIMER_DELAY);
		}
	}
}

function int getZoneQuestID()
{
	return Mid;
}

function int getZoneQuestSTEP()
{
	return mSTEP;
}

function int getZoneQuestState()
{
	return Mstate;
}

defaultproperties
{
}
