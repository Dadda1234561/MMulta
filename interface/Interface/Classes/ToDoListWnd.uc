/**  
 *   ����  : ������ ����
 *   �޸�  : �������� ���� �߰� (�߱� ���������� ����)
 *   �ؿ� ���� �ٽ� ����(����)
 **/
class ToDoListWnd extends UICommonAPI;

enum ETabType 
{
	Mission0,
	Mission1,
	Mission2,
	MissionLevel,
	Max
};

var WindowHandle Me;
var CheckBoxHandle AllLevelCheckBox;
var WindowHandle ToDoList_Wnd;
var ListCtrlHandle ToDoList_ListCtrl;
var WindowHandle DetailInfo_Wnd;
var TextBoxHandle DetailInfoTitle_Text;
var TextBoxHandle MissionName_Text;
var TextureHandle IconLock_texture;
var TextBoxHandle MissionDateName_Text;
var TextureHandle divider_texture;
var TextureHandle DetailInfoMissionGroupbox_texture;
var TextureHandle DetailInfoMissionGroupboxDeco_texture;
var TextureHandle scrollGroupBox_Texture;
var TextureHandle DailyMissionListWndGroupBox_Texture;
var TextureHandle DailyMissionInfoWndGroupBox_Texture;
var ButtonHandle RefreshBtn;
var ButtonHandle RewardBtn;
var WindowHandle CompleteWnd_scrollarea;
var TextBoxHandle CompleteDescriotion_Text;
var WindowHandle TimedWnd_scrollarea;
var TextBoxHandle TimedDescriotion_Text;
var WindowHandle RewardInfoWnd_scrollarea;
var ButtonHandle LocalfindBtn_BTN;
var ItemWindowHandle DailyRewardItem;
var StatusBarHandle Completegage_statusbar;
var WindowHandle areaScroll;
var WindowHandle toDoListContainer;
var WindowHandle missionLevelContainer;
var ToDoListTabMissionLevel missionLevelScript;

var TabHandle   MissionCategoryTab;

//������ ���� ID, ServerID
var int selectRewardID, selectServerID; 
// ��������
var string rewardDesc; 
// ����Ⱓ-�̶�µ� �ƴ� ����Ϸ� ���� rewardPeriod = RequestOneDayRewardPeriod( rewardID );
var string rewardPeriod; 
//��Ʈ ���� ����, ���, �Ķ�
var color R, Y, B;
//������ ������ List index��
var int saveIndex;
//���� �����ð�
var int DayRemainTime;
//�ְ� �����ð�
var int WeekRemainTime;
//���� �����ð�
var int MonthRemainTime;
//���� ����
var int ServerDay;
//������ ���� struct �� sort0, sort1�� ������.
struct ToDoListInfo
{
	var LVDataRecord        record;
	var int			        sort0;
	var int			        sort1;	
};
//������ ���� �迭all
//var Array<ToDoListInfo> todoArray;

// �Ǻ� ����Ʈ ��
// ���
var Array<ToDoListInfo> todoArray0;
// ���̵�
var Array<ToDoListInfo> todoArray1;
// �ý���
var Array<ToDoListInfo> todoArray2;
// ����
var Array<ToDoListInfo> todoArray3;

//�ð�ǥ�ø� ���� ����
var int nResetPeriod;
//�ð��� Ÿ�̸� ID
const TIMER_ID          = 99900;
//�ð��� Ÿ�̸� ������ 1��
const TIMER_DELAY       = 1000;
//��� ���ſ� Ÿ�̸� ID
const TIMER_CLICK       = 99901;
//��� ���ſ� Ÿ�̸� ������ 3��
const TIMER_DELAYC       = 3000;


var array<int> rewards;

/***************************************************** �� ****************************************************/
var array<ETabType> tabList;
var ETabType currentCategory;
var int rewardRsCount;

function Initialize()
{
	Me = GetWindowHandle("ToDoListWnd");
	AllLevelCheckBox = GetCheckBoxHandle("ToDoListWnd.AllLevelCheckBox");
	missionLevelScript = ToDoListTabMissionLevel(GetScript(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ToDoListTabMissionLevel"));
	toDoListContainer = GetWindowHandle("ToDoListWnd.ToDoListContainer");
	ToDoList_Wnd = GetWindowHandle("ToDoListWnd.ToDoListContainer.ToDoList_Wnd");
	ToDoList_ListCtrl = GetListCtrlHandle("ToDoListWnd.ToDoListContainer.ToDoList_Wnd.ToDoList_ListCtrl");
	DetailInfo_Wnd = GetWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd");
	DetailInfoTitle_Text = GetTextBoxHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfoTitle_Text");
	MissionName_Text = GetTextBoxHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.MissionName_Text");
	IconLock_texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.IconLock_texture");
	MissionDateName_Text = GetTextBoxHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.MissionDateName_Text");
	Divider_Texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.divider_texture");
	DetailInfoMissionGroupbox_texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfoMissionGroupbox_texture");
	DetailInfoMissionGroupboxDeco_texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfoMissionGroupboxDeco_texture");
	scrollGroupBox_Texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.scrollGroupBox_Texture");
	DailyMissionListWndGroupBox_Texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DailyMissionListWndGroupBox_Texture");
	DailyMissionInfoWndGroupBox_Texture = GetTextureHandle("ToDoListWnd.ToDoListContainer.DailyMissionInfoWndGroupBox_Texture");
	refreshBtn = GetButtonHandle("ToDoListWnd.RefreshBtn");
	areaScroll = GetWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea");
	RewardInfoWnd_scrollarea = GetWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea");
	rewardBtn = GetButtonHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.RewardBtn");
	DailyRewardItem = GetItemWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.DailyRewardItem");
	CompleteDescriotion_Text = GetTextBoxHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.CompleteDescriotion_Text");
	CompleteWnd_scrollarea = GetWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea");
	LocalfindBtn_BTN = GetButtonHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.LocalfindBtn_BTN");
	Completegage_statusbar = GetStatusBarHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.Completegage_statusbar");
	TimedDescriotion_Text = GetTextBoxHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.TimedWnd_scrollarea.TimedDescriotion_Text");
	TimedWnd_scrollarea = GetWindowHandle("ToDoListWnd.ToDoListContainer.DetailInfo_Wnd.DetailInfo_ScrollArea.TimedWnd_scrollarea");
	MissionCategoryTab = GetTabHandle("TodoListWnd.ToDoList_Wnd.ToDoListTab");
	R.R = 255;
	R.G = 153;
	R.B = 153;
	Y.R = 255;
	Y.G = 255;
	Y.B = 187;
	B.R = 136;
	B.G = 255;
	B.B = 255;
	saveIndex = 0;
	rewards.Length = 0;
	InitTabGorup();
}

function InitTabGorup()
{
	tabList.Length = 0;
	// End:0x91
	if(IsEnableMissionLevel())
	{
		tabList[tabList.Length] = MissionLevel;
		MissionCategoryTab.SetButtonName(0, GetSystemString(14038));
		MissionCategoryTab.SetButtonName(1, GetSystemString(3579));
		MissionCategoryTab.SetButtonName(2, GetSystemString(14037));
		MissionCategoryTab.SetButtonName(3, GetSystemString(1792));		
	}
	else
	{
		MissionCategoryTab.RemoveTabControl(4 - 1);
		MissionCategoryTab.SetButtonName(0, GetSystemString(3579));
		MissionCategoryTab.SetButtonName(1, GetSystemString(14037));
		MissionCategoryTab.SetButtonName(2, GetSystemString(1792));
	}
	tabList[tabList.Length] = Mission0;
	tabList[tabList.Length] = Mission1;
	tabList[tabList.Length] = Mission2;
	currentCategory = tabList[0];
}

function bool IsEnableMissionLevel()
{
	return false;
}

function _SetMissionLevelRewardNum(int rewardNum)
{
	// End:0x25
	if(IsEnableMissionLevel())
	{
		rewards[3] = rewardNum;
		SetTabCompletedNum(0, rewardNum);
	}
}

/*************************************************************************************
 * On
*************************************************************************************/

function OnRegisterEvent()
{
	RegisterEvent(EV_TodoListShow);	
	// ���Ϻ��� �ý��۸�� 
	RegisterEvent(EV_OneDayRewardListStart);
	RegisterEvent(EV_OneDayRewardList);
	RegisterEvent(EV_OneDayRewardListEnd);
	// ���Ϻ��� �ý��� ������ ��� 
	RegisterEvent(EV_OneDayRewardItemListStart);
	RegisterEvent(EV_OneDayRewardItemList);
	RegisterEvent(EV_OneDayRewardItemListEnd);
}

/**  onShow  */
function onShow()
{
	//�ɼ� �ε�
	loadOptionToDo();
	//��� ��������
	refreshList();
	// End:0x2F
	if(IsEnableMissionLevel())
	{
		rewardRsCount = -1;
		missionLevelScript.OnParentShow();
	}
	Me.SetFocus();
}

/**  onHide  */
function onHide()
{	
	//�̴ϸ� 
	getInstanceL2Util().DelGFxMiniMapArea(Me.GetWindowName());
	// End:0x37
	if(IsEnableMissionLevel())
	{
		missionLevelScript.OnParentHide();
	}
}

/** OnDefaultPosition */
function OnDefaultPosition(){}

/**  OnLoad  */
function OnLoad()
{
	registerState(getCurrentWindowName(string(Self)), "GamingState" );
	registerState(getCurrentWindowName(string(Self)), "ARENAGAMINGSTATE" );
	SetClosingOnESC(); 
	Initialize();
}

/**  OnEvent  */
function OnEvent( int a_EventID, String param )
{
	//Debug ( "OnEvent Event " @ a_EventID @ param );
	switch( a_EventID )
	{
		case EV_TodoListShow :  
//			debug("EV_TodoListShow : " @ param);
			openProcess(param);
			break;
		//���� �̼� ����Ʈ �ޱ� ����
		case EV_OneDayRewardListStart :
			OneDayRewardListStart( param );			
			break;
		//���� �̼� ����Ʈ ����
		case EV_OneDayRewardList : 
			//Debug( param );
			OneDayRewardList( param );
			break;
		//���� �̼� ����Ʈ ���� �Ϸ�
		case EV_OneDayRewardListEnd : 
			OneDayRewardListEnd( param );											
			//checkNoneNoticeHtml();
			break;

		// ���� �̼� �ý��� ���� ��� �ޱ� ����
		case EV_OneDayRewardItemListStart : 
			DailyRewardItem.Clear();
			break;
		// ���� �̼� �ý��� ���� ��� �ޱ�
		case EV_OneDayRewardItemList :
			OneDayRewardItemList( param );
			break;
		// ���� �̼� �ý��� ���� ��� �ޱ� �Ϸ�
		case EV_OneDayRewardItemListEnd : 								
			break;
	}
}

/** 
 *  üũ �ڽ� Ŭ�� ��
 **/
function OnClickCheckBox( String strID )
{
	switch( strID )
	{
		//"��ü �̼� ����" üũ �ڽ� Ŭ�� ��
		case "AllLevelCheckBox": 
			SetOptionToDo();
			refreshList();
			break;
	}
}
/** 
 *  ��ư Ŭ�� ��
 **/
function OnClickButton( string stringID )
{
	local int clickedTabIndex;

	switch( stringID )
	{
		//��� ���� ��ư Ŭ��
		case "RefreshBtn":
			//��� ���ſ� Ÿ�̸� ����
			Me.SetTimer( TIMER_CLICK, TIMER_DELAYC );
			//��ư ��Ȱ��
			RefreshBtn.DisableWindow();
			// End:0x72
			if(IsEnableMissionLevel())
			{
				// End:0x69
				if(currentCategory == ETabType.MissionLevel/*3*/)
				{
					missionLevelScript._RequestRewardList();
					rewardRsCount = -1;				
				}
				refreshList();			
			}
			else
			{
				//��� ����
				refreshList();
			}
			break;
		//�ݱ� ��ư Ŭ��
		case "Btn":
			Me.HideWindow();
			break;
		//���� �ޱ� ��ư Ŭ��
		case "RewardBtn":
			RequestOneDayRewardReceive(selectServerID);
			break;
		//�������� ��ư Ŭ��
		case "LocalfindBtn_BTN":
			LocalfindBtnClick();
			break;
		case "ToDoListTab0" :			
		case "ToDoListTab1" :
		case "ToDoListTab2" :
		case "ToDoListTab3" :
		// End:0x16F
		case "ToDoListTab4":
			clickedTabIndex = int(Right(StringID, 1));
			ToDoList_ListCtrl.DeleteAllItem();			
			// End:0x164
			if(clickedTabIndex < tabList.Length)
			{
				currentCategory = tabList[clickedTabIndex];
			}
			OneDayRewardListEnd( "" ) ;
			break;
	}
}

/**  
 *   ����Ʈ Ŭ��
 **/
function OnClickListCtrlRecord( string ListCtrlID )
{
	local int rewardID, serverID, CurrentCount, MaxCount;
	local LVDataRecord Record;
	local string param, rewardBool;
	local int ResetPeriod;
	local int ShowQuestRange;
	local string Block;
	local string CheckType;
	local string CheckTypeStr;

	saveIndex = ToDoList_ListCtrl.GetSelectedIndex();

	if (saveIndex >= 0) 
	{
		ToDoList_ListCtrl.GetSelectedRec(Record);
		
		param = Record.szReserved;

		ParseINT(param,    "ResetPeriod"        , ResetPeriod);
		ParseINT(param,    "rewardID"           , rewardID);
		ParseINT(param,    "serverID"           , serverID);
		ParseINT(param,    "ShowQuestRange"     , ShowQuestRange);
		ParseINT(param,    "CurrentCount"       , CurrentCount);
		ParseINT(param,    "MaxCount"           , MaxCount);

		ParseString(param, "rewardBool"         , rewardBool);
		ParseString(param, "Block"              , Block);
		ParseString(param, "CheckType"			, CheckType);

		selectRewardID = rewardID;
		selectServerID = serverID;
		if ( int(CheckType) == 0 )
			CheckTypeStr = " - " @ GetSystemString(2321);
		else if ( int(CheckType) == 1 )
			CheckTypeStr = " - " @ GetSystemString(13248);

		//�̼� �̸� �ֱ�
		MissionName_Text.SetText( Record.LVDataList[1].szData );		
		//�ֱ�
		MissionDateName_Text.SetTextColor( setTextColor( ResetPeriod ) );
		switch( ResetPeriod )
		{
			//����
			case 1:
				MissionDateName_Text.SetText( GetSystemString(3583) @ CheckTypeStr);
				break;
			//�ְ�
			case 2:
				MissionDateName_Text.SetText( GetSystemString(3584) @ CheckTypeStr);
				break;
			//����
			case 3:
				MissionDateName_Text.SetText( GetSystemString(3585) @ CheckTypeStr);
				break;
			//��ȸ��
			case 4:
				MissionDateName_Text.SetText( GetSystemString(3582) @ CheckTypeStr);
				break;
		}

		//���� ������ ����Ʈ ��û 
		RequestOneDayRewardItemList( rewardID ); 
		//��������
		rewardDesc = RequestOneDayRewardDesc( rewardID ); 		

		//���� ���� ���� ���� �϶�
		if( rewardBool == "t" )
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
		//��� �̼��� �ƴ� ���
		if( ShowQuestRange == 0 )
		{
			//���� ���� ��ư ����
			LocalfindBtn_BTN.DisableWindow();
			LocalfindBtn_BTN.HideWindow();
		}
		else
		{
			//���� ���� ��ư ������
			LocalfindBtn_BTN.showWindow();
			LocalfindBtn_BTN.enableWindow();			
		}		
		//��� ���¶��
		if( Block == "True")
		{
			//�ڹ��� ������ ����
			IconLock_texture.ShowWindow();
		}
		else
		{
			//�ڹ��� ������ ����
			IconLock_texture.hideWindow();
		}
		//statusbar ���� �߰�
		Completegage_statusbar.SetPoint( CurrentCount, MaxCount );

		rewardInfo();
	}	
}
/**
 * �ð� Ÿ�̸� && ��� ���� Ÿ�̸� �̺�Ʈ
 ***/
function OnTimer(int TimerID) 
{
	//�� �ð� ������Ʈ
	if( TimerID == TIMER_ID )
	{
		DayRemainTime--;
		WeekRemainTime--;
		MonthRemainTime--;

		TimedDescriotion_Text.SetText( timeToString() );
	}
	//��ϰ��� ��ư Ȱ��ȭ
	else if( TimerID == TIMER_CLICK )
	{
		RefreshBtn.EnableWindow();
		Me.KillTimer( TIMER_CLICK );
	}
}

/*************************************************************************************
 * List
*************************************************************************************/
/**
 * ���� �̼� ����Ʈ �ޱ� ����
 * DayRemainTime(���� �����ð�), WeekRemainTime(�ְ� ���� �ð�), MonthRemainTime(���� �����ð�), ServerDay(���� ����)
 * **/
function OneDayRewardListStart( string param )
{
	//���� �迭 �ʱ�ȭ
	todoArray0.Remove( 0, todoArray0.Length );
	todoArray1.Remove( 0, todoArray1.Length );
	todoArray2.Remove( 0, todoArray2.Length );
	todoArray3.Remove( 0, todoArray3.Length );
	//�ֱ⺰ ���� �ð��� ����
	ParseINT(param,   "DayRemainTime"     , DayRemainTime);
	ParseINT(param,   "WeekRemainTime"    , WeekRemainTime);
	ParseINT(param,   "MonthRemainTime"   , MonthRemainTime);
	ParseINT(param,   "ServerDay"         , ServerDay);
	
	rewards[0] = 0;
	rewards[1] = 0;
	rewards[2] = 0;
	//����Ʈ ������ �ʱ�ȭ
	ToDoList_ListCtrl.DeleteAllItem();
	//���� �ð� ǥ�ÿ� Ÿ�̸� �ʱ�ȭ
	Me.KillTimer( TIMER_ID );
	//���� �ð� ǥ�ÿ� Ÿ�̸� ����
	Me.SetTimer( TIMER_ID, TIMER_DELAY );
	rewardRsCount++;
}
/**
 *  ���� �̼� ����Ʈ ����
 *  (serverID(����ID(int), rewardID(����ID(int)), rewardName(�̼� ��(string)), rewardStatus(������ɻ���(int))
 */
function OneDayRewardList( string param )
{
	/***  param �� ----- ***/
	//�̼� ���� ���� ����
	local int CanConditionDay, CanConditionDayCount;
	//�̼� ���� �ּ� ����
	local int CanConditionLvMin;
	//�̼� ���� �ִ� ����
	local int CanConditionLvMax;
	//�̼� ID, ����ID ��
	local int rewardID, serverID;
	//�̼� ���� ���� ����
	local int rewardStatus;
	//�̼� ���൵ ��
	local int CurrentCount;
	//�̼� ���൵ �Ϸ� ��
	local int MaxCount;
	//�̼� Event, New �� new=1 event=2
	local int NewEvent;
	//��� �̼� ����(��������) 1=��ɹ̼� 0=��ɹ̼Ǿƴ�
	local int ShowQuestRange;
	//�̼� �ֱ�
	local int ResetPeriod;
	//�̼� ����
	local string rewardName;
	// ī�װ��� ��
	local int Category;
	/***  param �� ----- ***/
	local int CheckType;

	local int ServerRange, i;
	//���� ���� ���
	local UserInfo playerInfo;
	//���� ���� ����
	local int nSort;
	//ToDoList_ListCtrl�� �� record ��
	local LVDataRecord record;

	//��� ���� ����(����, ����) -- param ���� �߰��Ͽ� ���
	local bool Block;
	//���� ���� ���� -- param ���� �߰��Ͽ� ���
	local string rewardBool;
	local int nWidth, nHeight;

	// 
	//local array<ToDoListInfo> tmpToDoListInfo;

	//�⺻�� ����
	Block = false;
	nSort = 0;
	rewardBool = "f";	

	//���� ���� ����
	GetPlayerInfo(playerInfo);
	
	/***  param �� ���� ----- ***/	
	ParseInt(param, "CanConditionDayCount", CanConditionDayCount);
	ParseInt(param, "rewardID", rewardID);
	ParseInt(param, "serverID", serverID);
	ParseInt(param, "rewardStatus", rewardStatus);
	ParseInt(param, "NewEvent", NewEvent);
	ParseInt(param, "CurrentCount", CurrentCount);
	ParseInt(param, "MaxCount", MaxCount);
	ParseInt(param, "ResetPeriod", ResetPeriod);
	ParseInt(param, "CanConditionLvMin", CanConditionLvMin);
	ParseInt(param, "CanConditionLvMax", CanConditionLvMax);
	ParseInt(param, "ShowQuestRange", ShowQuestRange);
	ParseString(param, "rewardName", rewardName);
	ParseInt(param, "Category", Category);
	ParseInt(param, "CheckType", CheckType);
	ParseInt(param, "ServerRange", ServerRange);
	/***  param �� ���� ----- ***/	

	
//	Debug ( "������ ��� �� Category" @ Category ) ;

	//������ ��� ���� ��� �� �� �ִ� ���� ���� 0�� �ͼ� 999�� ��������. 
	if( CanConditionLvMax == 0 )
	{
		CanConditionLvMax = 999;
	}

	//��� ���� Ȯ�� ����
	if ( playerInfo.nLevel < CanConditionLvMin ||  playerInfo.nLevel > CanConditionLvMax )
	{
		Block = true;
	}
	//��� Ȯ�� ����
	if( CanConditionDayCount != 0 )
	{
		for( i = 0 ; i < CanConditionDayCount ; i++ )
		{
			//���� ���� 1=�� 2=�� 3=ȭ 4=�� 5=�� 6=�� 7=��
			ParseInt( param, "CanConditionDay" $ i, CanConditionDay );
			
			//���� ���ϰ� ���� ������ ������ ����
			if( ServerDay  == CanConditionDay )
			{
				Block = false;
				break;
			}
			//���� ���ϰ� ���� ������ ������ ���
			else
			{
				Block = true;
			}
		}
	}

	//3��
	record.LVDataList.Length = 3;
	//���� �� 3����.
	record.LVDataList[0].buseTextColor = True;
	record.LVDataList[1].buseTextColor = True;		
	record.LVDataList[2].buseTextColor = True;

	
	//�ֱ⿡ ���� ���� �� ����
	record.LVDataList[0].TextColor = setTextColor( ResetPeriod );
	//�ֱ⺰ �ý��� �޽��� 
	switch( ResetPeriod )
	{
		//����
		case 1:
			record.LVDataList[0].szData         = GetSystemString(3579);
			break;
		//�ְ�
		case 2:
			record.LVDataList[0].szData         = GetSystemString(3580);
			break;
		//����
		case 3:
			record.LVDataList[0].szData         = GetSystemString(3581);
			break;
		//��ȸ��
		case 4:
			record.LVDataList[0].szData         = GetSystemString(1792);
			break;
	}
	//�̼� ���� �⺻ �� ���� - ���
	record.LVDataList[1].TextColor = getInstanceL2Util().BrightWhite;

	// ���°� ���� 
	switch( rewardStatus )
	{
		// ���ɰ���
		case 1 : 
			//���� ���
			record.LVDataList[2].TextColor = getInstanceL2Util().Yellow;
			//���� ���� ����
			record.LVDataList[2].szData = GetSystemString(3586); 
			rewardBool = "t";
			nSort = 1;
			rewards[Category] ++ ;
			break;

		// ��� or ������
		case 2 :
			//���
			if ( Block )
			{
				nSort = 3;
				//�ڹ��� ������ �߰�
				record.LVDataList[2].hasIcon = true;
				record.LVDataList[2].nTextureWidth=14;
				record.LVDataList[2].nTextureHeight=14;
				record.LVDataList[2].nTextureU=14;
				record.LVDataList[2].nTextureV=14;
				record.LVDataList[2].szTexture = "L2UI_CT1.DailyMissionWnd_IconLock"; 
				record.LVDataList[2].IconPosX = 46;	
				record.LVDataList[2].FirstLineOffsetX=5;
				record.LVDataList[2].TextColor = R;
				record.LVDataList[2].szData = GetSystemString(3587);
			}
			//������
			else
			{
				nSort = 2;
				//���൵ StatusBar �߰�
				record.bUseStatusBar = true;
				record.nStatusBarIndex = 2; // ���° �÷��� �߰��Ұ��ΰ�.
				record.LVDataList[record.nStatusBarIndex].nStatusBarCurrentCount = CurrentCount;
				record.LVDataList[record.nStatusBarIndex].nStatusBarMaxCount = MaxCount;
				
				record.strStatusBarForeLeftTex      = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
				record.strStatusBarForeCenterTex    = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
				record.strStatusBarForeRightTex     = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";

				record.strStatusBarBackLeftTex      = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Left3";
				record.strStatusBarBackCenterTex    = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Center3";
				record.strStatusBarBackRightTex     = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Right3";
				record.nStatusBarWidth = 110;
				record.nStatusBarHeight = 12;
			}
			break;

		//���ɿϷ�
		case 3 :
			nSort = 4;
			//���� ȸ��
			record.LVDataList[1].TextColor = getInstanceL2Util().Gray;
			record.LVDataList[2].TextColor = getInstanceL2Util().Gray;
			record.LVDataList[2].szData = GetSystemString(898);
			break;
	}
	GetTextSizeDefault(rewardName, nWidth, nHeight);
	// End:0x9B9
	if(ServerRange == 1)
	{
		// End:0x85B
		if(NewEvent == 0)
		{
			record.LVDataList[1].arrTexture.Length = 2;
			lvTextureAdd(Record.LVDataList[1].arrTexture[0], "L2UI_EPIC.Icon.IconWorld", nWidth + 12, 0, 41, 19);			
		}
		else if(NewEvent == 1)
		{
			record.LVDataList[1].arrTexture.Length = 2;
			lvTextureAdd(Record.LVDataList[1].arrTexture[0], "L2UI_CT1.DailyMissionWnd_IconNewt", nWidth + 12, 0, 41, 19);
			lvTextureAdd(Record.LVDataList[1].arrTexture[1], "L2UI_EPIC.Icon.IconWorld", nWidth + 51, 0, 41, 19);				
		}
		else if(NewEvent == 2)
		{
			record.LVDataList[1].arrTexture.Length = 2;
			lvTextureAdd(Record.LVDataList[1].arrTexture[0], "L2UI_CT1.DailyMissionWnd_IconEvent", nWidth + 12, 0, 41, 19);
			lvTextureAdd(Record.LVDataList[1].arrTexture[1], "L2UI_EPIC.Icon.IconWorld", nWidth + 51, 0, 41, 19);
		}
	}
	else
	{
		// End:0xA9C
		if(NewEvent == 1)
		{
			Record.LVDataList[1].hasIcon = true;
			record.LVDataList[1].iconPostion = true;
			record.LVDataList[1].nTextureWidth = 41;
			record.LVDataList[1].nTextureHeight = 19;
			record.LVDataList[1].nTextureU = 41;
			record.LVDataList[1].nTextureV = 19;
			Record.LVDataList[1].szTexture = "L2UI_CT1.DailyMissionWnd_IconNewt";
			record.LVDataList[1].IconPosX = 2;
			record.LVDataList[1].FirstLineOffsetX = 4;			
		}
		else if(NewEvent == 2)
		{
			record.LVDataList[1].hasIcon = true;
			record.LVDataList[1].iconPostion = true;
			record.LVDataList[1].nTextureWidth = 41;
			record.LVDataList[1].nTextureHeight = 19;
			record.LVDataList[1].nTextureU = 41;
			record.LVDataList[1].nTextureV = 19;
			record.LVDataList[1].szTexture = "L2UI_CT1.DailyMissionWnd_IconEvent";
			record.LVDataList[1].IconPosX = 2;
			record.LVDataList[1].FirstLineOffsetX = 4;
		}
	}
	record.LVDataList[1].szData = rewardName;
	record.LVDataList[1].textAlignment = TA_Left;

	// �븸 �߱��� ���� �ϸ� ���� ����
	// Debug ("�ؿ� Ȯ���� �ʿ���!!!.");
	/*
	switch(GetLanguageCustom()) 
	{
		case ELanguageType.LANG_Taiwan  :
		case ELanguageType.LANG_Chinese : record.LVDataList[1].textAlignment = TA_CENTER; break;	
		default : record.LVDataList[1].textAlignment = TA_LEFT;
	}*/
	
	//0,2 ���� ����
	record.LVDataList[0].textAlignment = TA_CENTER;
	record.LVDataList[2].textAlignment = TA_CENTER;

	//��� ���� ����(����, ����) -- param ���� �߰��Ͽ� ���
	ParamAdd( param, "rewardBool", rewardBool );
	//���� ���� ���� -- param ���� �߰��Ͽ� ���
	ParamAdd( param, "Block", String(Block) );
	ParamAdd( param, "CheckType", String(CheckType) );
	//record�� �߰�.
	record.szReserved = param;
	record.nReserved1 = rewardID;
	record.nReserved2 = ServerID;
	SetToDolistByCategroy(Category, record, nSort, NewEvent);
}

/**
 *  ���� �̼� ����Ʈ ���� �Ϸ�
 **/
function OneDayRewardListEnd( string param )
{
	local int i;
	local array< ToDoListInfo > tmpToDoListInfo;
	
	// End:0x44
	if(currentCategory == ETabType.MissionLevel/*3*/)
	{
		// End:0x3A
		if(IsEnableMissionLevel() && param == "")
		{
			// End:0x3A
			if(rewardRsCount > 0)
			{
				RequestMissionLevelRewardList();
			}
		}
		ShowMissionLevelPanel(true);		
	}
	else
	{
		ShowMissionLevelPanel(false);
	}
	
	tmpToDoListInfo = GetCurrentToDoListByCategroy( currentCategory ) ;
	//���� New, Event ����
	tmpToDoListInfo.Sort(OnSortCompare1);
	//���� ���� ����
	tmpToDoListInfo.Sort(OnSortCompare);

	for( i = 0 ; i < tmpToDoListInfo.Length ; i++ )
	{
		//"��ü �̼� ����" üũ �� ���� ������
		if( AllLevelCheckBox.IsChecked() )
		{	
			ToDoList_ListCtrl.InsertRecord( tmpToDoListInfo[ i ].record );
		}
		//"��ü �̼� ����" ���� �� ��� ���� ���� ���� ����
		else
		{
			if( tmpToDoListInfo[i].sort0 != 3 )
			{
				ToDoList_ListCtrl.InsertRecord( tmpToDoListInfo[ i ].record );
			}
		}   
	}
	
	SetSelectListCtrl ();
	
	OnClickListCtrlRecord("DailyRewardListCtrl");
	
	// End:0x196 [Loop If]
	for(i = 0; i < tabList.Length; i++)
	{
		// End:0x18C
		if(tabList.Length > i)
		{
			// End:0x180
			if(rewards.Length > tabList[i])
			{
				SetTabCompletedNum(i, rewards[tabList[i]]);
				// [Explicit Continue]
				continue;
			}
			SetTabCompletedNum(i, 0);
		}
	}
}

// ������ ���õ� ���� �ִٸ� ���� 
// ���� ����Ʈ�� ���� ���� �ε��� ���� �۴ٸ� ����Ʈ ������ ����
function SetSelectListCtrl () 
{	
	if ( ToDoList_ListCtrl.GetRecordCount() < 1 ) 
	{		
		ToDoList_ListCtrl.SetSelectedIndex( saveIndex, false );
		saveIndex = -1;
		SetResultEmpty();
		// ������ ���� ����
	}
	else if ( saveIndex < ToDoList_ListCtrl.GetRecordCount() ) 
	{
		if ( saveIndex < 0 ) saveIndex = 0 ;
		ToDoList_ListCtrl.SetSelectedIndex( saveIndex, true );		
	}
	else 
	{
		saveIndex = 0 ;// ToDoList_ListCtrl.GetRecordCount() - 1;
		ToDoList_ListCtrl.SetSelectedIndex( saveIndex, true );		
	}
	// Debug ( "SetSelectListCtrl" @ saveIndex @ "/" @ ToDoList_ListCtrl.GetRecordCount()) ;
}


/**
 * ������ list index�� �ֱ�
 **/
function int selectIndexPeriod()
{
	local LVDataRecord Record;	
	local string param;

	ToDoList_ListCtrl.GetSelectedRec( Record );

	//������ list�� ���� ��찡 ����
	if( Record.szReserved != "" ) 
	{
		param = Record.szReserved;
		//�׷��� local ���� ��� �ϸ� �ʵ�.
		ParseINT( param, "ResetPeriod", nResetPeriod );
	}
	return nResetPeriod;
}

/** 
 *  ��ϰ���  
 *  */
function refreshList()
{
	RequestTodoListOneDayReward();
}

function RequestMissionLevelRewardList()
{
	// End:0x1F
	if(IsEnableMissionLevel())
	{
		rewardRsCount = 0;
		missionLevelScript._RequestRewardList();
	}	
}

/*************************************************************************************
 * Result ( ���� �� ���� ) 
*************************************************************************************/
/**
 * �������� ��ư Ŭ��
 **/
function LocalfindBtnClick()
{
	local LVDataRecord Record;
	//��ǥ ���� ��
	local Vector XYZ;
	//��ǥ x,y,z ��
	local float x, y, z;
	local string param;
	//�̴ϸ�
	local Color areaColor;
	
	//����� index�� record �� ����
	ToDoList_ListCtrl.GetRec( saveIndex, Record );
	param = Record.szReserved;

	//x,y,z �� ����
	ParseFloat ( param, "TargetX", x );
	ParseFloat ( param, "TargetY", y );
	ParseFloat ( param, "TargetZ", z );
	//���� ����
	XYZ.x = int(x) ;
	XYZ.y = int(y) ;
	XYZ.z = int(z) ;

	areaColor.R = 129;
	areaColor.G = 243;
	areaColor.B = 254;
	areaColor.A = 90;
	getInstanceL2Util().AddGFxMiniMapArea(Me.GetWindowName(),XYZ,areaColor,2);
	getInstanceL2Util().ShowHighLightMapIcon(XYZ,0,0);
}

/** 
 *  �Ϸ� ����, ���� �ð� ǥ�� �� ��ũ�� on/off
 **/
function rewardInfo()
{	
	//���� ��
	local int resultHeight;
	selectIndexPeriod();

	//TimedDescriotion_Text ���� �ð� ǥ�� �� �ؽ�Ʈ ����
	resultHeight = setTextFieldHight( TimedDescriotion_Text, timeToString() );
	//TimedWnd_scrollarea, �ؽ�Ʈ �ʵ� ���� �� + �ʵ� ũ�� + ����
	TimedWnd_scrollarea.SetWindowSize (302, resultHeight + 30);	
	
	//CompleteDescriotion_Text �Ϸ� ���� ǥ�� �� �ؽ�Ʈ ����
	resultHeight = setTextFieldHight( CompleteDescriotion_Text, rewardDesc );
	//CompleteDescriotion_Text, �ؽ�Ʈ �ʵ� ���� �� + �ʵ� ũ�� + ����
	CompleteWnd_scrollarea.SetWindowSize (302, resultHeight + 53);	
	
	//��ũ�� �ʱ�ȭ
	areaScroll.SetScrollPosition( 0 ) ;
	//ũ�⿡ ���� ��ũ�� ����
	areaScroll.SetScrollHeight( RewardInfoWnd_scrollarea.GetRect().nHeight + TimedWnd_scrollarea.GetRect().nHeight + CompleteWnd_scrollarea.GetRect().nHeight );
}

/** 
 *  ���� �̼� �ý��� ���� ��� �ޱ� (classID(������Ŭ����ID(int)), itemCount(�����۰���(int))) 
 **/
function OneDayRewardItemList( string param )
{
	//������info
	local ItemInfo itemInfo;
	/***  param �� ----- ***/
	//������ ID
	local ItemID   itemID;
	//������ ����
	local int itemCount;
	/***  param �� ----- ***/

	/***  param �� ���� ----- ***/	
	ParseItemID( param, itemID );
	ParseINT(param, "itemCount", itemCount);
	/***  param �� ���� ----- ***/	

	//itemID�� ������info �ޱ�
	class'UIDATA_ITEM'.static.GetItemInfo( itemID, itemInfo );

	itemInfo.itemNum = itemCount;
	//������ �ֱ�
	DailyRewardItem.AddItem( itemInfo );
}

/** 
 *  ��� â �ʱ�ȭ
 **/
function SetResultEmpty ( ) 
{
	// �̼� �̸� �ֱ�
	MissionName_Text.SetText( "" );		
	// �ֱ�
	MissionDateName_Text.SetText( "" );	
	// ���� ���� 
	DailyRewardItem.clear();
	// ��ư ���� �Ұ�
	RewardBtn.SetButtonName( 3604 );
	RewardBtn.disableWindow(); 	
	
	// ���� ���� ��ư ����
	LocalfindBtn_BTN.DisableWindow();
	LocalfindBtn_BTN.HideWindow();	
	
	IconLock_texture.hideWindow();

	// �Ϸ� ����
	rewardDesc = "";
	//CompleteDescriotion_Text.SetText( "" ) ;

	// Statusbar ���� �߰�
	Completegage_statusbar.SetPoint( 0, 0 );

	// ���� �Ⱓ
	Me.KillTimer( TIMER_ID );
	// ���� ���� ���ϱ�
	rewardInfo();
	TimedDescriotion_Text.SetText( "" ) ;
}


/*************************************************************************************
 * Option
*************************************************************************************/
/** �ɼ��� ���� : �׻� ���� �Ҷ� ���� �� ���ΰ�? */
function SetOptionToDo()
{	
	local bool bChecked;

	bChecked = AllLevelCheckBox.IsChecked();
	SetOptionBool( "UI", "TodoList", bChecked );
}

/** �ɼ� �ε�  */
function loadOptionToDo()
{
	local bool bChecked;

	bChecked = getOptionBool( "UI", "TodoList");
	AllLevelCheckBox.SetCheck(bChecked);
}

/*************************************************************************************
 * Data
*************************************************************************************/
function Array<TodoListInfo> GetCurrentToDoListByCategroy ( int categroy )
{
	switch ( categroy ) 
	{
	case 0 : 
		return todoArray0 ;
		break;
	case 1 : 
		return todoArray1 ;
		break;
	case 2 : 
		return todoArray2 ;
		break;
	case 3 : 
		return todoArray3 ;
		break;
	}
}

function SetToDolistByCategroy( int categroy, LVDataRecord record, int nSort, int NewEvent )
{
	local ToDoListInfo tmpTodoListInfo;

	tmpTodoListInfo.record = record;
	tmpTodoListInfo.sort0 = nSort ;
	tmpTodoListInfo.sort1 = NewEvent ;	

	switch ( categroy ) 
	{
		case 0 : 
			todoArray0[todoArray0.Length] = tmpTodoListInfo;			
			break;
		case 1 : 
			todoArray1[todoArray1.Length] = tmpTodoListInfo;			
			break;
		case 2 : 
			todoArray2[todoArray2.Length] = tmpTodoListInfo;			
			break;
		case 3 : 
			todoArray3[todoArray3.Length] = tmpTodoListInfo;			
			break;
	}
}


/*************************************************************************************
 * Util
*************************************************************************************/
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
	sNextStringWithWidth = DivideStringWithWidth( text, nWidth );	
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
 * �� �ֱ⺰ �ð� ������ ǥ��
 **/
function string timeToString()
{
	local string str;

	switch( selectIndexPeriod() )
	{
		//����
		case 1:			
			str = getTimeStringBySec( DayRemainTime );
			break;
		//�ְ�
		case 2:			
			str = getTimeStringBySec( WeekRemainTime );
			break;
		//����
		case 3:
			str = getTimeStringBySec( MonthRemainTime );
			break;
		//��ȸ
		case 4:
			str = GetSystemString(1792);
			break;
	}
	return str;
}


/**
 * ��/�ð�/�� || �ð�/�� || //�� || //1�й̸� ���� �ð� �ٲ���
 **/
function string getTimeStringBySec(int sec)
{
	local int timeTemp, timeTemp0, timeTemp1;
	local string returnStr;

	returnStr = "";
	timeTemp = ((sec / 60) / 60 / 24);
	timeTemp0 = ((sec / 60) / 60);
	timeTemp1 = ((sec / 60));

	if( timeTemp > 0 )
	{
		//��/�ð�/��
		returnStr =  MakeFullSystemMsg(GetSystemMessage(4466), string(timeTemp), string(int( (sec / 60) / 60 % 24 ) ), string(int((sec / 60) % 60)));
	}
	else if( timeTemp0 > 0 )
	{
		//�ð�/��
		returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int((sec / 60) % 60)));
	}
	else if( timeTemp1 > 0 )
	{
		//��
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp0));
	}
	else
	{
		//1�й̸�
		returnStr = MakeFullSystemMsg( GetSystemMessage(4360) , string ( 1 ) ) ;
	}
	return returnStr;	 
}

/**
 * �ֱ⿡ ���� ���� �� ����
 **/
function color setTextColor(int n)
{	
	local color returnColor;

	switch( n )
	{
		//����
		case 1:
			returnColor      = Y;
			break;
		//�ְ�
		case 2:
			returnColor      = R;
			break;
		//����
		case 3:
			returnColor      = B;
			break;
		//��ȸ
		case 4:
			returnColor      = Y;
			break;
	}
	return returnColor;
}


delegate int OnSortCompare( ToDoListInfo a, ToDoListInfo b )
{
    if (a.sort0 > b.sort0) // ���� ����. ���ǹ��� < �̸� ��������.
    {
        return -1;  // �ڸ��� �ٲ���Ҷ� -1�� ���� �ϰ� ��.
    }
    else
    {
        return 0;
    }
}
delegate int OnSortCompare1( ToDoListInfo a, ToDoListInfo b )
{
    if (a.sort1 < b.sort1) // ���� ����. ���ǹ��� < �̸� ��������.
    {
        return -1;  // �ڸ��� �ٲ���Ҷ� -1�� ���� �ϰ� ��.
    }
    else
    {
        return 0;
    }
}

function SetTabCompletedNum ( int tabIndex, int completedNum ) 
{
	local string textureName ;

	if ( completedNum > 9 ) 
		textureName = "L2UI_CT1.Tab.TabNoticeCount_09" $ "Plus" ;
	else if  ( completedNum != 0 ) 
		textureName = "L2UI_CT1.Tab.TabNoticeCount_0" $ completedNum  ;

	MissionCategoryTab.SetButtonOffsetTex (tabIndex, textureName, 180, -7);
}

/*************************************************************************************
 * ����
*************************************************************************************/
/** 
 *  ���� ó��
 **/
function openProcess(string a_param)
{	
	local UserInfo myInfo;
	local int nforceOpen;

	if ( !GetPlayerInfo (myInfo ) ) return;
	ParseInt(a_param, "forceOpen", nforceOpen);

	//  1���� ���� ó�� , forceOpen 1�� ���ٸ� ������ ���� 
	if (myInfo.nLevel > 1 || nforceOpen == 1) getInstanceL2Util().toggleWindow("ToDoListWnd", true);	
}

/*************************************************************************************
 * etc
*************************************************************************************/
function ToggleByClanMission ()
{
	if ( Me.IsShowWindow() )
	{
		Me.HideWindow();
		return;
	}
	Me.ShowWindow();
}

function ShowMissionLevelPanel(bool isShow)
{
	// End:0x5D
	if(isShow == true)
	{
		missionLevelScript.m_hOwnerWnd.ShowWindow();
		missionLevelScript.m_hOwnerWnd.SetFocus();
		toDoListContainer.HideWindow();
		AllLevelCheckBox.HideWindow();		
	}
	else
	{
		missionLevelScript.m_hOwnerWnd.HideWindow();
		toDoListContainer.ShowWindow();
		AllLevelCheckBox.ShowWindow();
	}
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

defaultproperties
{
}
