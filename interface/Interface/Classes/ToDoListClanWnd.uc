/**  
 *   ����  : ���� �̼� 
 **/
class ToDoListClanWnd extends UICommonAPI;

var WindowHandle Me;
var CheckBoxHandle AllLevelCheckBox;
var ListCtrlHandle ToDoList_ListCtrl;
var TextBoxHandle MissionName_Text;
var TextureHandle IconLock_texture;
var TextBoxHandle MissionDateName_Text;
var ButtonHandle RefreshBtn;
var ButtonHandle EssentialBtn;
var ButtonHandle RewardBtn;
var WindowHandle CompleteWnd_scrollarea;
var TextBoxHandle CompleteDescriotion_Text;
var WindowHandle ConditionWnd_scrollarea;
var TextBoxHandle ConditionDescriotion_Text;
var WindowHandle RewardInfoWnd_scrollarea;

var ItemWindowHandle DailyRewardItem;
var StatusBarHandle Completegage_statusbar;
var WindowHandle	areaScroll;

var TextBoxHandle ClanFameInput_Text;
var TextBoxHandle PrivateFameInput_Text;
var TextBoxHandle WeekMissionNum_Text;

var TextBoxHandle WeekMission_Text;
var ButtonHandle HelpButton;
var TabHandle ToDoListClan_TabCtrl;

var WindowHandle toDoDisable_Wnd;
var WindowHandle todoComplete_Wnd;
var array<int> rewards;


//������ ���� struct �� sort0, sort1�� ������.
struct ToDoListInfo
{
	var LVDataRecord        record;
	var int			        sort0;
	var int			        sort1;	
};
//������ ���� �迭
var Array<ToDoListInfo> todoArray;

//��� ���ſ� Ÿ�̸� ID
const TIMER_CLICK       = 99901;
//��� ���ſ� Ÿ�̸� ������ 3��
const TIMER_DELAYC       = 3000;

// ���� ���� ������ ����
var int curRewardCount;
// �ִ� ���� ���� ���� ����
var int maxRewardCount;
var int lastClickIndex;

struct ToDoListClanData
{
	// �̼� ID	
	var int missionID ;
	// ���� ���� ����
	var int progressCount;
	// ���� (0:�Ϸ�, 1: ����Ұ�, 2: ��������, 3: ������, 4:������ɰ���)
	var int curState; 
	// ���� (1:�Ϲ�, 2:��ȭ, 3:����, 4:�̺�Ʈ )
	var int category;
	// �̺�Ʈ �Ⱓ���� ����
	var bool isEventPeroid;
};

const STATE_COMPLETE  = 0 ;
const STATE_BLOCK     = 1;
const STATE_PROCESS   = 2;
const STATE_REWARD    = 3;


//��Ʈ ���� ���, ����, ����
var color Y, R, V;

var int currentTabIndex ;

const TAB_NORMAL        = 1;
const TAB_DEEPENING     = 2;
const TAB_ACHIEVEMENTS  = 3;
const TAB_EVENT         = 4;

var array <ToDoListClanData> toDoClanArray;

var int serverStartTime;

var int numOfEventList;
var int numOfRewardList;

var int clientStartSec ;

function Initialize()
{
	Me = GetWindowHandle( "ToDoListClanWnd" );
	AllLevelCheckBox = GetCheckBoxHandle( "ToDoListClanWnd.AllLevelCheckBox" );
	ToDoList_ListCtrl = GetListCtrlHandle( "ToDoListClanWnd.ToDoList_Wnd.ToDoList_ListCtrl" );
	MissionName_Text = GetTextBoxHandle( "ToDoListClanWnd.DetailInfo_Wnd.MissionName_Text" );
	IconLock_texture = GetTextureHandle( "ToDoListClanWnd.DetailInfo_Wnd.IconLock_texture" );
	MissionDateName_Text = GetTextBoxHandle( "ToDoListClanWnd.DetailInfo_Wnd.MissionDateName_Text" );

	RefreshBtn = GetButtonHandle( "ToDoListClanWnd.RefreshBtn" );
	EssentialBtn = GetButtonHandle( "ToDoListClanWnd.EssentialBtn" );

	areaScroll                  = GetWindowHandle       (   "ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea" );

	RewardInfoWnd_scrollarea     = GetWindowHandle      (   "ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea" );
	RewardBtn                   = GetButtonHandle       (   "ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.RewardBtn" );
	DailyRewardItem             = GetItemWindowHandle	(   "ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.DailyRewardItem" );

	CompleteDescriotion_Text    = GetTextBoxHandle      (   "ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.CompleteDescriotion_Text" );
	CompleteWnd_scrollarea      = GetWindowHandle       (   "ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea" );
	//LocalfindBtn_BTN            = GetButtonHandle       (   "ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.LocalfindBtn_BTN" );
	Completegage_statusbar      = GetStatusBarHandle    (   "ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.Completegage_statusbar" );

	ConditionDescriotion_Text       = GetTextBoxHandle      (   "ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.ConditionWnd_scrollarea.ConditionDescriotion_Text" );
	ConditionWnd_scrollarea         = GetWindowHandle       (   "ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.ConditionWnd_scrollarea" );

	WeekMissionNum_Text         = GetTextBoxHandle      (   "ToDoListClanWnd.WeekMissionNum_Text" );

	WeekMission_Text            = GetTextBoxHandle      (   "ToDoListClanWnd.WeekMission_Text" );
	HelpButton                  = GetButtonHandle      (   "ToDoListClanWnd.HelpButton" );

	ClanFameInput_Text         = GetTextBoxHandle      (   "ToDoListClanWnd.DetailInfo_Wnd.RewardInfoWnd_scrollarea.ClanFameInput_Text" );
	PrivateFameInput_Text      = GetTextBoxHandle      (   "ToDoListClanWnd.DetailInfo_Wnd.RewardInfoWnd_scrollarea.PrivateFameInput_Text" );	

	ToDoListClan_TabCtrl        = GetTabHandle          ( "ToDoListClanWnd.ToDoListClan_TabCtrl" );	

	toDoDisable_Wnd             = GetWindowHandle      (   "ToDoListClanWnd.TodoDisable_Wnd" );
	todoComplete_Wnd            = GetWindowHandle      (   "ToDoListClanWnd.TodoComplete_Wnd");          

	
	R.R = 255;
	R.G = 153;
	R.B = 153;

	Y.R = 255;
	Y.G = 255;
	Y.B = 187;

	V.R = 238;
	V.G = 170;
	V.B = 255;

	numOfEventList = 0 ;
	rewards.Length = 4;
	ClearRewardList();
}

event OnRegisterEvent()
{
	//���� �̼� ���� �̺�Ʈ
	RegisterEvent(EV_PledgeMissionInfo);
	//���� �̼� ���� ���� ����(����/�ִ�) �̺�Ʈ
	RegisterEvent(EV_PledgeMissionRewardCount);

	RegisterEvent(EV_Restart);

//	RegisterEvent ( EV_test_7 ) ;

	RegisterEvent(EV_CurrentserverTime);
}


/*************************************************************************************************** 
 *  �̺�Ʈ �ڵ�
 *****************************************************************************************************/
/**  OnLoad  */
event OnLoad()
{
	Initialize();
	setResultEmpty();
	registerState(getCurrentWindowName(string(Self)), "GamingState" );
	SetClosingOnESC(); 
	//�ɼ� �ε�
	loadOptionToDo();
	refreshByTabIndexChage(TAB_NORMAL);

	HelpButton.SetTooltipCustomType(getCustomToolTip(GetSystemString(3688)));
}

/**  onShow  */
event onShow()
{	
	//��� ��������
	Me.SetTimer( TIMER_CLICK, TIMER_DELAYC );
	//��ư ��Ȱ��
	RefreshBtn.DisableWindow();
	Me.SetFocus();
	handleListEmpty();
	API_RequestPledgeMissionInfo();
}

/** 
 *  üũ �ڽ� Ŭ�� ��
 **/
event OnClickCheckBox( String strID )
{
	switch( strID )
	{
		//"��ü �̼� ����" üũ �ڽ� Ŭ�� ��
		case "AllLevelCheckBox": 
			SetOptionToDo();
			refreshData ();
			break;
	}
}

/**
 * �ð� Ÿ�̸� && ��� ���� Ÿ�̸� �̺�Ʈ
 ***/
event OnTimer(int TimerID) 
{
	if( TimerID == TIMER_CLICK )
	{
		RefreshBtn.EnableWindow();
		Me.KillTimer( TIMER_CLICK );
	}
}


/** 
 *  ��ư Ŭ�� ��
 **/
event OnClickButton( string Name )
{
	//Debug ( "OnClickButton" @ Name );
	switch( Name )
	{
		//��� ���� ��ư Ŭ��
		case "RefreshBtn":
			//��� ���ſ� Ÿ�̸� ����
			Me.SetTimer( TIMER_CLICK, TIMER_DELAYC );
			//��ư ��Ȱ��
			RefreshBtn.DisableWindow();
			//��� ����
			API_RequestPledgeMissionInfo();
			break;
		//�ݱ� ��ư Ŭ��
		case "EssentialBtn":
			Me.HideWindow();
			break;
		//���� �ޱ� ��ư Ŭ��
		case "RewardBtn":
			requestReward();			
			break;		
		case "ToDoListClan_TabCtrl0" :
			refreshByTabIndexChage ( TAB_NORMAL ) ;
			break;
		case "ToDoListClan_TabCtrl1" :
			refreshByTabIndexChage ( TAB_DEEPENING ) ;
			break;
		case "ToDoListClan_TabCtrl2" :
			refreshByTabIndexChage ( TAB_ACHIEVEMENTS ) ;
			break;
		case "ToDoListClan_TabCtrl3" :
			refreshByTabIndexChage ( TAB_EVENT ) ;
			break;
		case "WndHelp_Button" :
			ExecuteEvent(EV_ShowHelp, "152");
			break;
	}
}


/**  OnEvent  */
event OnEvent( int a_EventID, String param )
{
	//Debug ( "OnEvent " @ a_EventID @ param );
	switch( a_EventID )
	{		
		case EV_PledgeMissionInfo :		
			handlePledgeMissionInfo ( param ) ;
			//Debug ( "EV_PledgeMissionInfo" @ param ) ;
		break;
		case EV_PledgeMissionRewardCount :
			handlePledgeMissionRewardCount(param);
			//Debug ( "EV_PledgeMissionRewardCount" @ param ) ;
		break;
		// ����Ʈ Ŭ���� 
		case EV_Restart :
			ToDoList_ListCtrl.DeleteAllItem();
			toDoClanArray.Length = 0;
			numOfEventList = 0;
			clientStartSec = 0;
			lastClickIndex = -1;
			ClearRewardList();
		break;

		case  EV_CurrentserverTime :
			//Debug("---> EV_CurrentserverTime" @ param);
			setCurrentserverTime(param);
		break;
	}
}

delegate int SortByRewardDelegate(ToDoListClanData A, ToDoListClanData B)
{
	// End:0x33
	if(boolToNum(A.curState == 3) < boolToNum(B.curState == 3))
	{
		return -1;
	}
	return 0;	
}

/**  
 *   ����Ʈ Ŭ��
 **/
event OnClickListCtrlRecord( string ListCtrlID )
{
	local LVDataRecord Record;
	/* 
	 * ���� �̼� 
	 * */
	local PledgeMissionUIData pledgeMissionUIDataOut;

	//saveIndex = ToDoList_ListCtrl.GetSelectedIndex();

	//Debug ( "OnClickListCtrlRecord" @ ToDoList_ListCtrl.GetSelectedIndex() );

	if (ToDoList_ListCtrl.GetSelectedIndex() >= 0) 
	{
		ToDoList_ListCtrl.GetSelectedRec(Record);		
		
		GetPledgeMissionData ( int(Record.szReserved), pledgeMissionUIDataOut )  ;		
		//Debug ( "�Ϸ�" @ pledgeMissionUIDataOut.GoalDesc @ pledgeMissionUIDataOut.Condition.PledgeLevel );
		
		// ����
		setResultTitle ( Record.LVDataList[1].szData, pledgeMissionUIDataOut.isRepeat, toDoClanArray[ int(Record.nReserved1) ].curState ) ;
		// ����
		setResultReward ( pledgeMissionUIDataOut.RewardItems, pledgeMissionUIDataOut.RewardPledgeNameValue, pledgeMissionUIDataOut.RewardPVPPoint, toDoClanArray[ int(Record.nReserved1) ].curState ) ; 
		// ���� ����
		setResultConditions ( pledgeMissionUIDataOut.Condition );
		// �Ϸ� ����
		setResultGoalCondition (pledgeMissionUIDataOut.GoalDesc, toDoClanArray[ int(Record.nReserved1) ].progressCount, pledgeMissionUIDataOut.GoalCount ) ;
		// ��ũ�� ����
		//��ũ�� �ʱ�ȭ
		areaScroll.SetScrollPosition( 0 ) ;
		//ũ�⿡ ���� ��ũ�� ����
		areaScroll.SetScrollHeight( RewardInfoWnd_scrollarea.GetRect().nHeight + ConditionWnd_scrollarea.GetRect().nHeight + CompleteWnd_scrollarea.GetRect().nHeight );
	}
}

function API_RequestPledgeMissionInfo()
{
	RequestPledgeMissionInfo();
}

/**********************************************************************************************
 * �̺�Ʈ �Ⱓ ó��
 * ************************************************************************************************/
function setCurrentserverTime(string param)
{
	// ���� �ð�
	ParseInt(param, "ServerTime", serverStartTime);
	clientStartSec = GetAppSeconds();
}

// �̺�Ʈ (��¥) �Ⱓ�ΰ�?
function bool isEventPeroid(PledgeMissionCondition condition)
{
	local L2UITime l2UITime;	
	//local string zeroString, dateString;	

	//Debug ( "isEventPeroid " @ condition.StartDate @  condition.StartTime @  condition.EndDate @  condition.EndTime );
	//Debug ( "isEventPeroid " @ l2UITime.nYear @  l2UITime.nMonth @  l2UITime.nDay );
	local int curDate, curTime;

	if ( condition.StartDate == 0  ) return true;
	GetTimeStruct( serverStartTime + GetAppSeconds() - clientStartSec, l2UITime) ;

    // 2017.01.02 => 170102 ��ȯ
    curDate = ((l2UITime.nYear % 100) * 10000) + (l2UITime.nMonth * 100) + l2UITime.nDay;

    // 18:30 => 1830 ��ȯ
    curTime = (l2UITime.nHour * 100) + l2UITime.nMin;

    // �Ⱓ(date + time) �˻�.
    if (condition.StartDate > 0  && condition.EndDate > 0)
    {
        if (curDate < condition.StartDate || curDate > condition.EndDate)
            return false;

        if (curDate == condition.StartDate && curTime < condition.StartTime)
            return false;

        if (curDate == condition.EndDate && curTime >= condition.EndTime)
            return false;
    }

    return true;

	//zeroString = getInstanceL2Util().makeZeroString(6, condition.StartDate);
		
	//dateString = l2UITime.nYear $ getInstanceL2Util().makeZeroString(2, l2UITime.nMonth) $ getInstanceL2Util().makeZeroString(2, l2UITime.nDay);
	
	//if ( l2UITime.nYear < 2000 + int (Mid(zeroString, 0, 2) )) return false;
	//if ( l2UITime.nMonth < int (Mid(zeroString, 2, 2) )) return false;
	//if ( l2UITime.nDay < int (Mid(zeroString, 4, 2) )) return false;

	//// ���� ���ڰ� �����̸�, �ð��� 0�� �ƴ� ��� 
	////Debug ( dateString @  "20" $ zeroString @ dateString  == ( "20" $ zeroString ) ) ;
	//if ( dateString == ( "20" $ zeroString ) && condition.StartTime != 0 ) 
	//{
	//	zeroString = getInstanceL2Util().makeZeroString(4, condition.StartTime);
	//	if ( l2UITime.nHour < int (Mid(zeroString, 0, 2) )) return false;
	//	if ( l2UITime.nMin < int (Mid(zeroString, 2, 2) )) return false;
	//}

	//zeroString = getInstanceL2Util().makeZeroString(6, condition.EndDate);
	//if ( l2UITime.nYear > 2000 + int (Mid(zeroString, 0, 2) )) return false;
	//if ( l2UITime.nMonth > int (Mid(zeroString, 2, 2) )) return false;
	//if ( l2UITime.nDay > int (Mid(zeroString, 4, 2) )) return false;
	
	//if ( dateString == ( "20" $ zeroString ) && condition.EndTime != 0 ) 
	//{
	//	zeroString = getInstanceL2Util().makeZeroString(4, condition.EndTime);
	//	if ( l2UITime.nHour < int (Mid(zeroString, 0, 2) )) return false;
	//	if ( l2UITime.nMin < int (Mid(zeroString, 2, 2) )) return false;
	//}
	
	//return true;
}



/**********************************************************************************************
 * �̺�Ʈ �� ����Ÿ ó��
 * ************************************************************************************************/
function handleEventMissionNum ( int idx, bool isEventPeroid  ) 
{	
	// ���� �� 
	if ( idx != -1 )
	{
		if ( isEventPeroid != toDoClanArray[idx].isEventPeroid)
			if ( isEventPeroid ) numOfEventList ++; else numOfEventList--;
	// �߰� �� 
	} else if ( isEventPeroid ) numOfEventList ++ ;

	ToDoListClan_TabCtrl.SetDisable( 3 , numOfEventList == 0 ) ;
}

function handleCompletedMissionNum (int idx, bool isRwardState, bool isEventPeroid, int Category)
{	
	// ���� �� 
	local NoticeWnd script ;
	local string param ;
	local int oldNumOfRewardList;

	oldNumOfRewardList = numOfRewardList;
	//Debug ( "handleCompletedMissionNum" @ isRwardState  @ isEventPeroid) ;

	if ( idx != -1 )
	{
		// �̺�Ʈ �Ⱓ�̳� �Ϸ� ���°� �ٲ� ���
		if ( toDoClanArray[idx].isEventPeroid != isEventPeroid || isRwardState != (toDoClanArray[idx].curState == STATE_REWARD))
			if ( isRwardState && isEventPeroid )
			{
				numOfRewardList ++;
				rewards[Category - 1]++;
				SetTabCompletedNum(Category - 1);
			}
			else
			{
				numOfRewardList--;
				rewards[Category - 1]--;
				SetTabCompletedNum(Category - 1);
			}
	// �߰� �� 
	}
	else if ( isRwardState && isEventPeroid )
	{
		numOfRewardList ++ ;
		rewards[Category - 1]++;
		SetTabCompletedNum(Category - 1);
	}
	
	//Debug ( "handleCompletedMissionNum" @ numOfRewardList) ;
	// �˸� �޽��� �߰�
	// ���� �Ȱ��� ������ �˸��� �޽��� ���� �� ��
	if ( oldNumOfRewardList == numOfRewardList )
		return;

	script = NoticeWnd(GetScript("NoticeWnd"));

	if ( numOfRewardList == 0 )
		script.removeNoticeButton( script.ENoticeType.TYPE_TODOLIST ) ;	
	else 
	{
		param = "";
		paramAdd( param , "rewardCount", String(numOfRewardList) ) ;
		script.createNoticeButtonWithParam(script.ENoticeType.TYPE_TODOLIST, 3670, param); 
	}
}

function SetTabCompletedNum (int tabindex)
{
	local int completedNum;
	local string TextureName;

	completedNum = rewards[tabindex];
	if ( completedNum > 9 )
	{
		TextureName = "L2UI_CT1.Tab.TabNoticeCount_09" $ "Plus";
	}
	else if ( completedNum != 0 )
	{
		TextureName = "L2UI_CT1.Tab.TabNoticeCount_0" $ string(completedNum);
	}
	ToDoListClan_TabCtrl.SetButtonOffsetTex(tabindex,TextureName,76,-7);
}

function handlePledgeMissionInfo( string param ) 
{	
	local int idx, listIndex;
	local ToDoListClanData tmpToDoListClanDataOut;
	local PledgeMissionUIData tmpPledgeMissionUIData;		

	parseInt ( param , "MissionID" , tmpToDoListClanDataOut.missionID ) ;
	parseInt ( param , "ProgressCount" , tmpToDoListClanDataOut.progressCount ) ;
	parseInt ( param , "CurState" , tmpToDoListClanDataOut.curState) ;

	//Debug ( "!! handlePledgeMissionInfo " @ tmpToDoListClanDataOut.missionID  @ tmpToDoListClanDataOut.progressCount  @ tmpToDoListClanDataOut.curState) ;
	
	if ( !GetPledgeMissionData( tmpToDoListClanDataOut.missionID, tmpPledgeMissionUIData )) return;

	tmpToDoListClanDataOut.category = tmpPledgeMissionUIData.Category ;
	// �̺�Ʈ �Ⱓ������ ���� 
	tmpToDoListClanDataOut.isEventPeroid = isEventPeroid( tmpPledgeMissionUIData.Condition );

	idx = findIdx ( tmpToDoListClanDataOut.missionID ) ;	

	handleEventMissionNum( idx, tmpToDoListClanDataOut.isEventPeroid ) ;
	handleCompletedMissionNum( idx, tmpToDoListClanDataOut.curState == STATE_REWARD, tmpToDoListClanDataOut.isEventPeroid, tmpPledgeMissionUIData.Category);

	// ó�� ���� ��� 
	if(idx == -1)
	{
		idx = toDoClanArray.Length;
		toDoClanArray.Length = toDoClanArray.Length + 1;
		toDoClanArray[idx] = tmpToDoListClanDataOut;

		if(tmpPledgeMissionUIData.Category == currentTabIndex)
		{
			refreshData();
			return;
		}
	}
	else
	{
		toDoClanArray[idx] = tmpToDoListClanDataOut;
		
		if ( tmpPledgeMissionUIData.Category == currentTabIndex ) 
		{	
			listIndex = findListIndex( idx ) ;
			
			// ����Ʈ�� ���� ��� 
			if ( listIndex == -1 ) listinsert ( idx ) ;
			// ����Ʈ�� �ִ� ���
			else 
			{	
				if ( tmpPledgeMissionUIData.Category == TAB_EVENT && !tmpToDoListClanDataOut.isEventPeroid ) listDelete( listIndex ) ;
				else
				{
					switch (toDoClanArray[idx].curState )
					{
						// ��� �� ��� üũ �ڽ� ���¿� ���� 
						case STATE_BLOCK :
							if ( AllLevelCheckBox.IsChecked() ) listModify ( listIndex , idx) ;
							else listDelete( listIndex ) ;
						break;
						// �Ϸ� �� ��� ����
						case STATE_COMPLETE :
							listDelete( listIndex ) ;
						break;					
						default :
							listModify ( listIndex , idx ) ;
						break;
					}				
				}
			}
			autoSelectList();
		}
		refreshData();
	}
}

function handleListEmpty () 
{
	if ( currentTabIndex == TAB_NORMAL && curRewardCount == maxRewardCount && maxRewardCount > 0) 
	{
		toDoDisable_Wnd.HideWindow();
		todoComplete_Wnd.ShowWindow();
		ToDoList_ListCtrl.DeleteAllItem();	
	}
	else if ( ToDoList_ListCtrl.GetRecordCount() == 0 ) 
	{
		toDoDisable_Wnd.ShowWindow();
		todoComplete_Wnd.HideWindow();	
	}
	else 
	{
		toDoDisable_Wnd.HideWindow();
		todoComplete_Wnd.HideWindow();
	}
}

function listinsert ( int idx ) 
{
	//Debug ("���� 1 " @ AllLevelCheckBox.IsChecked() || toDoClanArray[idx].curState != STATE_BLOCK ) ;
	//Debug ("���� 2 " @ toDoClanArray[idx].Category != TAB_EVENT || toDoClanArray[idx].isEventPeroid ) ;			
	//Debug ("���� 3 " @ currentTabIndex != TAB_NORMAL || curRewardCount != maxRewardCount ) ;
	if ( toDoClanArray[idx].curState != STATE_COMPLETE )
		if ( AllLevelCheckBox.IsChecked() || toDoClanArray[idx].curState != STATE_BLOCK ) 
			// �̺�Ʈ ���� �ƴ� ��� Ȥ�� �Ⱓ�� �´� ���
			if ( toDoClanArray[idx].Category != TAB_EVENT || toDoClanArray[idx].isEventPeroid ) 				
				// �Ϲ� ���� �ƴϰų�, �Ϲ� �̼��� �Ϸ� ���� ���� ���
				if ( currentTabIndex != TAB_NORMAL || curRewardCount != maxRewardCount ) 
					ToDoList_ListCtrl.InsertRecord( makeMissionRecord ( idx ) ) ;
}

function listDelete ( int listIndex ) 
{		
	setResultEmpty();
	ToDoList_ListCtrl.DeleteRecord( listIndex ) ;
}

function listModify( int listIndex, int idx ) 
{
	ToDoList_ListCtrl.ModifyRecord ( listIndex , makeMissionRecord ( idx ) ) ;
	if ( listIndex == ToDoList_ListCtrl.GetSelectedIndex() ) OnClickListCtrlRecord("");
}

function refreshData()
{
	local int i;

	ToDoList_ListCtrl.DeleteAllItem();
	toDoClanArray.Sort(SortByRewardDelegate);

	for ( i = 0 ; i < toDoClanArray.Length ; i ++ ) 
		if ( toDoClanArray[i].Category == currentTabIndex )  
			listinsert ( i ) ;
	
	handleListEmpty();
	autoSelectList();
}

function autoSelectList()
{
	// End:0x2C
	if(lastClickIndex > -1)
	{
		ToDoList_ListCtrl.SetSelectedIndex(lastClickIndex, true);
		OnClickListCtrlRecord("");
	}	
}

function handlePledgeMissionRewardCount ( string param ) 
{
	parseInt ( param , "CurRewardCount" , curRewardCount) ;
	parseInt ( param , "MaxRewardCount" , maxRewardCount) ;

	WeekMissionNum_Text.SetText( "("$String(curRewardCount)$"/"$String(maxRewardCount)$")");

	handleListEmpty();
}

function LVDataRecord makeMissionRecord ( int idx ) 
{
	local LVDataRecord record;
	local PledgeMissionUIData missionUIData;
	
	if ( !GetPledgeMissionData( toDoClanArray[idx].missionID,  missionUIData ) ) return record ;		

	/* ����Ʈ�� �ʿ��� ���� 
	 * ���� Ÿ��
	 * �̼� �̸�
	 * ����
	 * */

	//3��
	record.LVDataList.Length = 3;
	//���� �� 3����.
	record.LVDataList[0].buseTextColor = True;
	record.LVDataList[1].buseTextColor = True;		
	record.LVDataList[2].buseTextColor = True;

	
	//�ֱ⿡ ���� ���� �� ����
	record.LVDataList[0].TextColor = setTextColor( missionUIData.IsRepeat );
	//�ֱ⺰ �ý��� �޽��� 
	if ( missionUIData.IsRepeat ) 
		record.LVDataList[0].szData = GetSystemString(1793);
	else 
		record.LVDataList[0].szData = GetSystemString(1792);
	
	//�̼� ���� �⺻ �� ���� - ���
	record.LVDataList[1].TextColor = getInstanceL2Util().BrightWhite;

	// *2 �̺�Ʈ �ϵ� �ڵ� �κ�
	if ( getIsEventMission (toDoClanArray[idx].missionID) ) 
	{
		record.LVDataList[1].hasIcon = true;

		record.LVDataList[1].szTexture = "L2UI_CT1.Clan.ClanMission_x2Icon";
		//record.LVDataList[1].IconPosX = getTextFieldWidth (missionUIData.MissionName) + 12;		
		record.LVDataList[1].IconPosX = 8;		
		record.LVDataList[1].nTextureWidth=24;
		record.LVDataList[1].nTextureHeight=24;
		record.LVDataList[1].nTextureU=24;
		record.LVDataList[1].nTextureV=24;

		//record.LVDataList[1].iconBackTexName = "L2UI_CT1.Clan.ClanMission_x2Icon";
		//record.LVDataList[1].backTexOffsetXFromIconPosX = getTextFieldWidth (missionUIData.MissionName) + 12;
		//record.LVDataList[1].backTexOffsetYFromIconPosY = 12;
		//record.LVDataList[1].backTexWidth = 24;
		//record.LVDataList[1].backTexHeight = 24;
		//record.LVDataList[1].backTexUL = 24;
		//record.LVDataList[1].backTexVL = 24 ;

		record.LVDataList[1].HiddenStringForSorting = "0" $ missionUIData.MissionName;		
	}
	else record.LVDataList[1].HiddenStringForSorting = "1" $ missionUIData.MissionName;

	record.LVDataList[1].szData         = missionUIData.MissionName;
	record.LVDataList[1].textAlignment  = TA_Left;		


	// ���°� ���� 
	switch( toDoClanArray[idx].curState )
	{
		// ���ɰ���
		case STATE_REWARD : 
			//���� ���
			record.LVDataList[2].TextColor = getInstanceL2Util().Yellow;
			//���� ���� ����
			record.LVDataList[2].szData = GetSystemString(3586); 	
			record.LVDataList[2].HiddenStringForSorting = "0";
			break;
		// ��� or ������
		 case STATE_PROCESS :
			//���൵ StatusBar �߰�		
			//Debug ( "�Ⱥ��� �� progress"  @ record.bUseStatusBar);
			record.bUseStatusBar = true;
			record.nStatusBarIndex = 2; // ���° �÷��� �߰��Ұ��ΰ�.
			record.LVDataList[2].nStatusBarCurrentCount = toDoClanArray[idx].progressCount;
			record.LVDataList[2].nStatusBarMaxCount = missionUIData.GoalCount;

			//record.LVDataList[2].nTextureU=0;
			//record.LVDataList[2].nTextureV=0;

			record.strStatusBarForeLeftTex      = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
			record.strStatusBarForeCenterTex    = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
			record.strStatusBarForeRightTex     = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";

			record.strStatusBarBackLeftTex      = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Left3";
			record.strStatusBarBackCenterTex    = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Center3";
			record.strStatusBarBackRightTex     = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Right3";
			record.nStatusBarWidth = 110;
			record.nStatusBarHeight = 12;			
			record.LVDataList[2].HiddenStringForSorting = "1";
			break;
		//���� �Ұ�
		case STATE_BLOCK :			
			//�ڹ��� ������ �߰�
			record.LVDataList[2].hasIcon = true;
			record.LVDataList[2].nTextureWidth=14;
			record.LVDataList[2].nTextureHeight=14;
			record.LVDataList[2].nTextureU=14;
			record.LVDataList[2].nTextureV=14;
			record.LVDataList[2].szTexture = "L2UI_CT1.DailyMissionWnd_IconLock"; 
			record.LVDataList[2].IconPosX = 28;	
			record.LVDataList[2].FirstLineOffsetX=5;
			record.LVDataList[2].TextColor = R;
			record.LVDataList[2].szData = GetSystemString(3682);
			record.LVDataList[2].HiddenStringForSorting = "2";
			break;
	}	
	
	//0,2 ���� ����
	record.LVDataList[0].textAlignment = TA_CENTER;
	record.LVDataList[2].textAlignment = TA_CENTER;

	//��� ���� ����(����, ����) -- param ���� �߰��Ͽ� ���
	//ParamAdd( param, "rewardBool", rewardBool );
	//���� ���� ���� -- param ���� �߰��Ͽ� ���
	//ParamAdd( param, "Block", String(Block) );
	//record�� �߰�.
	record.szReserved = String ( missionUIData.MissionID );
	record.nReserved1 = idx ; 
	//record.nReserved2 = serverID;
	//������ ���� �迭�� insert

	return record ;
}


/***********************************************************************************************
 * ���
 * *********************************************************************************************/
/************************************* ��� ���� *************************************/
function setResultEmpty ( ) 
{	
	local array<PledgeMissionRewardItem> emptyRewardItems;
	local PledgeMissionCondition emptyCondition;

	// ����	
	MissionName_Text.SetText( "" );		
	MissionDateName_Text.SetText( "" );
	IconLock_texture.hideWindow();

	// ����	
	setResultReward ( emptyRewardItems, 0, 0, STATE_BLOCK ) ; 
	// ���� ����
	setResultConditions ( emptyCondition );
	// �Ϸ� ����
	setResultGoalCondition ("", 0, 0 ) ;
	// ��ũ�� ����
	//��ũ�� �ʱ�ȭ
	areaScroll.SetScrollPosition( 0 ) ;
	//ũ�⿡ ���� ��ũ�� ����
	areaScroll.SetScrollHeight( RewardInfoWnd_scrollarea.GetRect().nHeight + ConditionWnd_scrollarea.GetRect().nHeight + CompleteWnd_scrollarea.GetRect().nHeight );
}


/************************************ �Ϸ� ���� ************************************/
function setResultGoalCondition (string goalDesc, int progressCount, int goalCount) 
{
	local int resultHeight;
	// �Ϸ� ����
	//CompleteDescriotion_Text �Ϸ� ���� ǥ�� �� �ؽ�Ʈ ����
	//Debug ( GoalDesc ) ;
	resultHeight = setTextFieldHight( CompleteDescriotion_Text, GoalDesc );
	//CompleteDescriotion_Text, �ؽ�Ʈ �ʵ� ���� �� + �ʵ� ũ�� + ���� + �����ͽ� ũ�� �� ���� : 27
	CompleteWnd_scrollarea.SetWindowSize ( 266, resultHeight + 53 + 7 );
	//Completegage_statusbar
	Completegage_statusbar.SetPoint( progressCount, GoalCount );
}

function String setResultMakeJob ( bool jobMain, bool jobDual, bool jobSub, string conditionString ) 
{	
	local string classString ;
	
	if ( jobMain ) classString = GetSystemString ( 2340 );	
	if ( jobDual ) 
	{ 
		if ( classString != "" ) classString = classString $ ", " ; 
		classString = classString $ GetSystemString ( 2737 ); 
	}
	if ( jobSub ) 
	{ 
		if ( classString != "" ) classString =  classString $", " ; 
		classString = classString $ GetSystemString ( 2339 ); 
	};

	if ( classString != "" ) addConditionSring  ( classString, conditionString ) ;

	return conditionString ;
}

function string setResultMakeLevelString ( int minLevel, int maxLevel, string conditionString ) 
{	
	local String levelString;
	
	if ( minLevel > 0 ) levelString =  minLevel @ GetSystemString (859); 
	if ( maxLevel > 0 ) 
	{
		if ( levelString != "" ) levelString = levelString $ " ~ " ;
		levelString = levelString $ maxLevel @ GetSystemString(13266) ;		
	}
	
	if ( levelString != "" ) addConditionSring  ( GetSystemString( 2321) @ GetSystemString( 537) @ levelString, conditionString ) ;

	return conditionString ;
}

function string setResultMakeDateString ( int date ) 
{	
	local String yearStr, monthStr, dayStr, zeroString;

	//Debug ( "setResultMakeDateString" @ date );

	zeroString = getInstanceL2Util().makeZeroString(6, date);
	yearStr  = Mid(zeroString, 0, 2);
	monthStr = Mid(zeroString, 2, 2);
	dayStr   = Mid(zeroString, 4, 2);

	//return yearStr$"."$ monthStr $"."$ dayStr;
	return MakeFullSystemMsg(GetSystemMessage(4467), yearStr, monthStr, dayStr);
}

function string setResultMakeTimeString ( int time ) 
{
	local string zeroString;

	//Debug ( "setResultMakeTimeString" @ time );

	if ( time == 0 ) return "";
	zeroString = getInstanceL2Util().makeZeroString(4, time);		
	return " " $ Mid(zeroString, 0, 2)$":"$Mid(zeroString, 2, 4);
}

// ���� ��Ʈ������ ȯ���Ͽ� ����
function string getDayString(array<int> AvailableDays)
{
	local int i, len, nCount;
	local string dayStr;
	len = AvailableDays.Length;		
	
	if (len > 0)
	{		
		for(i = 0; i < len; i++)
		{
			if(AvailableDays[i] > 0)
			{				
				nCount++;
				switch( AvailableDays[i])
				{
					//case 0 : if (dayStr != "") dayStr = dayStr $ ","; dayStr = dayStr $ GetSystemString(5140); break;  // �� 
					case 1 : if (dayStr != "") dayStr = dayStr $ ","; dayStr = dayStr $ GetSystemString(5134); break;  // ��
					case 2 : if (dayStr != "") dayStr = dayStr $ ","; dayStr = dayStr $ GetSystemString(5135); break;  // ȭ 
					case 3 : if (dayStr != "") dayStr = dayStr $ ","; dayStr = dayStr $ GetSystemString(5136); break;  // �� 
					case 4 : if (dayStr != "") dayStr = dayStr $ ","; dayStr = dayStr $ GetSystemString(5137); break;  // �� 
					case 5 : if (dayStr != "") dayStr = dayStr $ ","; dayStr = dayStr $ GetSystemString(5138); break;  // �� 
					case 6 : if (dayStr != "") dayStr = dayStr $ ","; dayStr = dayStr $ GetSystemString(5139); break;  // ��
				}
			}
		}
		// �Ͽ��� �߰� 
		if(AvailableDays[0] == 0)
		{
			nCount++;
			if (dayStr != "") dayStr = dayStr $ ","; dayStr = dayStr $ GetSystemString(5140); // �� 
		}   
	}
	// Debug("nCount" @ nCount);

	if (nCount > 6 || nCount == 0) dayStr = GetSystemString(3613);

	dayStr = "[" $  dayStr $ "]";

	return dayStr;
}

function requestReward()
{
	local LVDataRecord Record;

	lastClickIndex = ToDoList_ListCtrl.GetSelectedIndex();
	if(ToDoList_ListCtrl.GetSelectedIndex() >= 0)
	{
		ToDoList_ListCtrl.GetSelectedRec(Record);
		RequestPledgeMissionReward(int(Record.szReserved));
	}
}



/************************************ ���� ���� ************************************/
function setResultConditions( PledgeMissionCondition condition) 
{
	//���� ��
	local int resultHeight;
	local string conditionString;
	
	// ���� ����
	if ( condition.PledgeLevel > 0 ) addConditionSring ( MakeFullSystemMsg(GetSystemMessage ( 4546 ), String(condition.PledgeLevel) ), conditionString);
	// ���� �����͸� ����
	if ( condition.PledgeMasteryName != "" ) addConditionSring ( condition.PledgeMasteryName, conditionString);
	// ����
	conditionString = setResultMakeLevelString (condition.MinLevel, condition.MaxLevel, conditionString );
	// ����
	conditionString = setResultMakeJob ( condition.JobMain , condition.JobDual, condition.JobSub, conditionString ) ;
	// ���� �̼�
	if ( condition.PreMissionID > 0 ) addConditionSring ( "\"" $ getMissionNameByID(condition.PreMissionID ) $"\"" @ GetSystemString ( 898 ) , conditionString);	
	
	//condition.StartDate = 888888;
	//condition.EndDate = 888888;	
	//condition.StartTime = 8888;	
	//condition.EndTime = 8888;	

	if ( condition.StartDate != 0 ) 
	{	
		addConditionSring ( GetSystemString (2099) , conditionString  ) ;
		if ( condition.StartTime != 0 ) conditionString = conditionString $"\\n   ";
		else conditionString = conditionString $ " : ";
		conditionString = conditionString $setResultMakeDateString (condition.StartDate) $ setResultMakeTimeString (condition.StartTime) @ "~" @ setResultMakeDateString (condition.EndDate) $ setResultMakeTimeString (condition.EndTime) ;		
	}
	
	if ( condition.ActivateTime != 0 ) 
	{
		addConditionSring ( GetSystemString (3605) $ " :", conditionString  ) ;		
		conditionString = conditionString $setResultMakeTimeString (condition.ActivateTime) @ "~" $ setResultMakeTimeString (condition.DeactivateTime) ;		
	}
	
	if ( condition.AvailableDays.Length > 0 ) 	
		addConditionSring ( GetSystemString (3693) $" : " $ getDayString ( condition.AvailableDays ), conditionString  ) ;
	
	//Debug ( conditionString ) ;
	//TimedDescriotion_Text ���� �ð� ǥ�� �� �ؽ�Ʈ ����
	resultHeight = setTextFieldHight( ConditionDescriotion_Text, conditionString );
	//TimedWnd_scrollarea, �ؽ�Ʈ �ʵ� ���� �� + �ʵ� ũ�� + ����
	ConditionWnd_scrollarea.SetWindowSize ( 266, resultHeight + 30 );	
}

function string getMissionNameByID ( int missionID ) 
{
	local PledgeMissionUIData pledgeMissionUIDataOut;
	GetPledgeMissionData( missionID, pledgeMissionUIDataOut ) ;
	return pledgeMissionUIDataOut.MissionName ;
}

function addConditionSring ( string str, out string conditionString)
{
	local string dot;	
	// �ؿ� ��Ʈ�� ��� ���� �ڵ尡 �ٸ� �� �ֽ��ϴ�.
	if (GetLanguage() == LANG_Korean ) dot = "��"; else dot = "-"; 
	if ( conditionString != "" ) conditionString = conditionString $"\\n";
	conditionString = conditionString $ dot $ str;
}

function ClearRewardList ()
{
	local int i;

	numOfRewardList = 0;

	for ( i = 0;i < rewards.Length; i++ )
		rewards[i] = 0;
}
/************************************ ���� ************************************/
function setResultReward ( array<PledgeMissionRewardItem> rewardItems, int rewardPledgeNameValue, int rewardPVPPoint, int curState ) 
{
	local int i;	

	DailyRewardItem.Clear ();

	for ( i = 0 ; i < rewardItems.Length ; i ++ ) 	
		setResultRewardItems ( rewardItems[i] );
	
	// ���� ��ġ
	ClanFameInput_Text.SetText( MakeCostString ( String ( rewardPledgeNameValue ) ) ) ;	
	// ���� ��ġ 
	PrivateFameInput_Text.SetText( MakeCostString ( String ( rewardPVPPoint ) ) ) ;	
	//���� ���� ���� ���� �϶�
	if( curState == STATE_REWARD )
	{
		//���� �ޱ�
		RewardBtn.SetButtonName( 2279 );
		RewardBtn.enableWindow();
	}
	else
	{
		//���� �Ұ�
		RewardBtn.SetButtonName( 3604 );
		RewardBtn.disableWindow(); 
	}
}

function setResultRewardItems( PledgeMissionRewardItem rewarditem )
{
	//������info
	local ItemInfo itemInfo;
	
	//������ ID
	local ItemID   itemID;	
	
	itemID.classID = rewarditem.ItemClassID;	

	//itemID�� ������info �ޱ�
	class'UIDATA_ITEM'.static.GetItemInfo( itemID, itemInfo );

	itemInfo.itemNum = rewarditem.ItemCount;
	//������ �ֱ�
	DailyRewardItem.AddItem( itemInfo );
}

/************************************ ���� ************************************/
function setResultTitle( string title, bool isRepeat, int curState ) 
{
	MissionName_Text.SetText( title );		
	//�ֱ�ǥ��
	MissionDateName_Text.SetTextColor( setTextColor( isRepeat ) );

	if ( isRepeat ) MissionDateName_Text.SetText( GetSystemString(3679) );
	else MissionDateName_Text.SetText( GetSystemString(3582) );
	//��� ���¶�� �ڹ��� ������ ����
	if( curState == STATE_BLOCK)	
		IconLock_texture.ShowWindow();
	else		
		IconLock_texture.hideWindow();
}


/***************************************************************************
* util
 ***************************************************************************/
function int findIdx ( int missionID ) 
{
	local int i ;
	for ( i = 0 ; i < toDoClanArray.Length ; i ++ ) 
	
		if ( toDoClanArray[i].missionID == missionID ) return i;
	
	return -1;
}

function int findListIndex ( int idx ) 
{
	local int i ;
	local LVDataRecord Record;
	for ( i = 0 ; i < ToDoList_ListCtrl.GetRecordCount() ; i ++ )
	{
		ToDoList_ListCtrl.GetRec( i, Record) ;
		if ( Record.nReserved1 == idx ) return i ;
	}
	return -1;
}


/**
 * �� Ŭ�� �� 
 **/
function refreshByTabIndexChage ( int tabIndex )
{	
	if ( currentTabIndex != tabIndex ) 
	{
		currentTabIndex = tabIndex;
		setResultEmpty();
		refreshData ();		

		if ( currentTabIndex == TAB_NORMAL ) 
		{
			WeekMissionNum_Text.ShowWindow();
			WeekMission_Text.ShowWindow();
			HelpButton.ShowWindow();
		}
		else 
		{
			WeekMissionNum_Text.hideWindow();
			WeekMission_Text.hideWindow();
			HelpButton.hideWindow();
		}
	}
}

/**
 * �ֱ⿡ ���� ���� �� ����
 **/
function color setTextColor(bool isRefeat)
{		
	if ( isRefeat  ) return V;
	return Y ;
}

/**
 * �ؽ�Ʈ ���̿� ���� �ؽ�Ʈ ���̸� ���� ��. �����̰� ����
 **/
function int setTextFieldHight ( TextBoxHandle txtWnd, String text ) 
{
	local int nWidth, nHeight, defaultHeight, i, descHeight ;
	local string sNextStringWithWidth;

	txtWnd.SetText ( text );

	// defaultHeight �� ��� ��
	GetTextSizeDefault(text, nWidth, defaultHeight);

	// nWidth �� ��� ��
	CompleteDescriotion_Text.GetWindowSize( nWidth, nHeight );

	// �� ���ٷ� �������� ��� �� 
	i = 0;	
	sNextStringWithWidth = DivideStringWithWidth( txtWnd.GetText(), nWidth );
	while ( sNextStringWithWidth != "" ) 
	{		
		sNextStringWithWidth = NextStringWithWidth(nWidth);			
		i ++ ;
	}	
	
	descHeight = i * ( defaultHeight + 1 ) ; 
	txtWnd.SetWindowSize ( nWidth, descHeight );

	return descHeight;
}

/**
 * �ؽ�Ʈ ���̸� ����
 **/
//function int getTextFieldWidth ( String text ) 
//{
//	local int nWidth , nHeight;

//	GetTextSizeDefault(text, nWidth, nHeight);
	
//	return nWidth;
//}

/*
 *����
 */
function CustomTooltip getCustomToolTip(string Text)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	
	Tooltip.MinimumWidth = 144;
	
	Tooltip.DrawList.Length = 1;
	info.eType = DIT_TEXT;
	info.t_bDrawOneLine = true;
	info.t_color.R = 178;
	info.t_color.G = 190;
	info.t_color.B = 207;
	info.t_color.A = 255;
	info.t_strText = Text;
	Tooltip.DrawList[0] = info;

	return Tooltip;
}


/** �ɼ��� ���� : �׻� ���� �Ҷ� ���� �� ���ΰ�? */
function SetOptionToDo()
{	
	local bool bChecked;

	bChecked = AllLevelCheckBox.IsChecked();
	SetOptionBool( "UI", "TodoListClan", bChecked );
}

/** �ɼ� �ε�  */
function loadOptionToDo()
{
	local bool bChecked;

	bChecked = getOptionBool( "UI", "TodoListClan");
	AllLevelCheckBox.SetCheck(bChecked);
}


/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}

function bool getIsEventMission ( int ID ) 
{	
	// ���� �̼� �̺�Ʈ ���� 0308
	return false ;
	switch ( ID ) 
	{   
		
		case 1001 : // 85���� �̻� ���� ���
		case 1003 : // 85~94 �ν��Ͻ��� Ž��
		case 1004 : // 95~99 �ν��Ͻ��� Ž��
		case 1005 : // 100~105 �ν��Ͻ��� Ž��
		case 1007 : // ���� ����
		case 1014 : // ���� �ν��Ͻ��� Ž�� �ʱ�
		case 1015 : // �ø��ǾƵ� ����
		case 1016 : // ȥ���� ���� ����
		case 1017 : // ���� �ν��Ͻ��� Ž�� �߱�
		case 2001 : // 85~94 �ʵ庸�� ���
		case 2002 : // 100~105 �ʵ庸�� ���
		case 2003 : // ũ������ ����� ����
		case 2004 : // ���� ����� ����
		case 2006 : // �޻��̾� ��ä �ܼ� ����
		case 2016 :	// ȥ���� ���� �¸� �޼�
			return true;
	}
	return false;
}

defaultproperties
{
}
