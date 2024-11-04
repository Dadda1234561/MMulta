class PartyMatchWnd extends PartyMatchWndCommon
	dependson(PartyMatchRoomWnd);

const MAXMEMBER = 12;

var string m_WindowName;
//HandleList
var WindowHandle Me;
var ListCtrlHandle PartyMatchListCtrl;
var ComboBoxHandle LevelFilterComboBox;
var ButtonHandle PrevBtn;
var ButtonHandle NextBtn;
var ButtonHandle AutoJoinBtn;
var ButtonHandle RefreshBtn;

//Other Window
var WindowHandle PartyMatchMakeRoomWnd;
var WindowHandle PartyMatchWaitListWnd;
var WindowHandle PartyMatchOutWaitListWnd;
var EditBoxHandle PartyMatchOutWaitListWnd_MinLevel;
var EditBoxHandle PartyMatchOutWaitListWnd_MaxLevel;

// Ŭ�� ���� ������
var WindowHandle DisableWnd;

var WindowHandle PartyMatchHistory_Wnd;
var ListCtrlHandle WaitList_ListCtrl;

// Ȱ������ ��Ƽ ���� ���
var TextBoxHandle ActivityPartyTitle_Text;
var TextBoxHandle ActivityParty_Text;
var TextBoxHandle ActivityPartyMemberTitle_Text;
var TextBoxHandle ActivityPartyMember_Text;

//���� ����(2010.02.22 ~ 03.08)�Ϸ�
var ComboBoxHandle JobFilterComboBox;
var EditBoxHandle PartyMatchOutWaitListWnd_Name;

//Global Variable
var int CompletelyQuitPartyMatching;
var bool bOpenStateLobby;
var int CUR_PAGE;

//���ո�Ī
var ListCtrlHandle UnionMatchListCtrl;
var ButtonHandle UnionPrevBtn;
var ButtonHandle UnionNextBtn;
var ButtonHandle UnionRefreshBtn;
var WindowHandle UnionMatchMakeRoomWnd;
var int CUR_PAGE_UNION;

var bool IsInParty;

function InitHandle()
{
	Me = m_hOwnerWnd;
	PartyMatchListCtrl = GetListCtrlHandle("PartyMatchWnd.PartyMatchListCtrl");
	UnionMatchListCtrl = GetListCtrlHandle("PartyMatchWnd.UnionMatchListCtrl");
	LevelFilterComboBox = GetComboBoxHandle("PartyMatchWnd.LevelFilterComboBox");
	PrevBtn = GetButtonHandle("PartyMatchWnd.PrevBtn");
	NextBtn = GetButtonHandle("PartyMatchWnd.NextBtn");
	AutoJoinBtn = GetButtonHandle("PartyMatchWnd.AutoJoinBtn");
	RefreshBtn = GetButtonHandle("PartyMatchWnd.RefreshBtn");

	//Other Window
	PartyMatchMakeRoomWnd = GetWindowHandle("PartyMatchMakeRoomWnd");
	PartyMatchWaitListWnd = GetWindowHandle("PartyMatchWaitListWnd");
	PartyMatchOutWaitListWnd = GetWindowHandle("PartyMatchOutWaitListWnd");
	PartyMatchOutWaitListWnd_MinLevel = GetEditBoxHandle("PartyMatchOutWaitListWnd.MinLevel");
	PartyMatchOutWaitListWnd_MaxLevel = GetEditBoxHandle("PartyMatchOutWaitListWnd.MaxLevel");
	//���� ����(2010.02.22 ~ 03.08)�Ϸ�
	JobFilterComboBox = GetComboBoxHandle("PartyMatchOutWaitListWnd.Job");
	PartyMatchOutWaitListWnd_Name = GetEditBoxHandle("PartyMatchOutWaitListWnd.Name");

	//���ո�Ī
	UnionPrevBtn = GetButtonHandle("PartyMatchWnd.UnionPrevBtn");
	UnionNextBtn = GetButtonHandle("PartyMatchWnd.UnionNextBtn");
	UnionRefreshBtn = GetButtonHandle("PartyMatchWnd.UnionRefreshBtn");
	UnionMatchMakeRoomWnd = GetWindowHandle("UnionMatchMakeRoomWnd");

	// Ŭ������ ������
	DisableWnd = GetWindowHandle("PartyMatchWnd.DisableWnd");

	// ��Ƽ �����丮 ������
	PartyMatchHistory_Wnd = GetWindowHandle("PartyMatchWnd.PartyMatchHistory_Wnd");

	// ��Ƽ �����丮 ���
	WaitList_ListCtrl = GetListCtrlHandle("PartyMatchWnd.PartyMatchHistory_Wnd.WaitList_ListCtrl");

	// ��Ƽ���� ���� ���
	ActivityPartyTitle_Text = GetTextBoxHandle("PartyMatchWnd.ActivityPartyTitle_Text");
	ActivityParty_Text = GetTextBoxHandle("PartyMatchWnd.ActivityParty_Text");
	ActivityPartyMemberTitle_Text = GetTextBoxHandle("PartyMatchWnd.ActivityPartyMemberTitle_Text");
	ActivityPartyMember_Text = GetTextBoxHandle("PartyMatchWnd.ActivityPartyMember_Text");

	DisableWnd.DisableWindow();
}

function SetIsInParty(bool B)
{
	IsInParty = B;
}

function OnRegisterEvent()
{
	RegisterEvent(EV_PartyMatchStart);
	RegisterEvent(EV_PartyMatchList);
	RegisterEvent(EV_PartyMatchRoomStart);
	
	//���ո�Ī
	RegisterEvent(EV_ListMpccWaitingStart);
	RegisterEvent(EV_ListMpccWaitingRoomInfo);
	
	//��Ƽâ ��� �߻�
	RegisterEvent(EV_UsePartyMatchAction);
	//
	RegisterEvent(EV_Restart);

	// ��Ƽ �����丮 ���
	RegisterEvent(EV_PartyMatchingRoomHistory);
}

function OnLoad()
{
	SetClosingOnESC();
	InitHandle();
	Init();
}

function Init()
{
	CompletelyQuitPartyMatching = 0;
	bOpenStateLobby = false;

	CUR_PAGE = 0;
	CUR_PAGE_UNION = 0;
	IsInParty = false;
	LevelFilterComboBox.SetSelectedNum(1);
}

function OnShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);

	PartyMatchHistory_Wnd.HideWindow();
	DisableCurrentWindow(false);

	PartyMatchListCtrl.ShowScrollBar(false);
	
	//���ո�Ī�� ����Ʈ ��û(1���� ������ �Ŀ� ��Ŷ�� ������)
	UnionMatchListCtrl.DeleteAllItem();

	if(!getInstanceUIData().getIsArenaServer())
	{
		Me.SetTimer(1, 1000);
	}

	if(USE_XML_BOTTOM_BAR_UI)
	{
		class'BottomBar'.static.Inst().SetPartyOnOffState(true, false);
	}
	else
	{
		CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onShow windowName=PartyMatchWnd");
	}
}

function OnTimer(int TimerID)
{
	if(TimerID == 1)
	{
		RequestUnionRoomList(1);
		Me.KillTimer(1);
	}
}

//x��ư�� ������ �����츦 ������, ����ڸ�Ͽ��� ������.
function OnSendPacketWhenHiding()
{
	class'PartyMatchAPI'.static.RequestExitPartyMatchingWaitingRoom();
}

function OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	PartyMatchMakeRoomWnd.HideWindow();
	PartyMatchHistory_Wnd.HideWindow();
	DisableCurrentWindow(false);

	if(USE_XML_BOTTOM_BAR_UI)
	{
		class'BottomBar'.static.Inst().SetPartyOnOffState(false, false);
	}
	else
	{
		CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onHide");
	}
}

function OnEvent(int a_EventID, string param)
{
	local PartyMatchMakeRoomWnd script;

	//Debug("parthMatchWnd" @ a_EventID @ param);

	switch(a_EventID)
	{
		case EV_PartyMatchStart:
			if(CompletelyQuitPartyMatching == 1)
			{
				class'PartyMatchAPI'.static.RequestExitPartyMatchingWaitingRoom();
				Me.HideWindow();

				script = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));
				script.OnCancelButtonClick();

				CompletelyQuitPartyMatching = 0;
				SetWaitListWnd(false);
			}
			else
			{
				//����ڸ���Ʈ ������Ʈ
				UpdateWaitListWnd();

				if(Me.IsShowWindow() == false)
				{
					Me.ShowWindow();
					PartyMatchListCtrl.ShowScrollBar(false);
				}
				Me.SetFocus();
			}
			break;
		case EV_PartyMatchList:
			HandlePartyMatchList(param);
			break;
		case EV_PartyMatchRoomStart:
			Me.HideWindow();
			break;
		//���ո�Ī
		case EV_ListMpccWaitingStart:
			HandleListMpccWaitingStart(param);
			break;
		case EV_ListMpccWaitingRoomInfo:
			HandleListMpccWaitingRoomInfo(param);
			break;
		case EV_UsePartyMatchAction:
			HandlePartyToggle();
			break;
		case EV_Restart:
			SetIsInParty(false);
			//���� ����(2010.03.31)�Ϸ�
			bOpenStateLobby = false;
			break;
		case EV_PartyMatchingRoomHistory :
			updatePartyMatchingRoomHistory(param);
			break;
	}
}

// ��Ƽ ��� �����丮 ���� 
function updatePartyMatchingRoomHistory(string param)
{
	local int i, count;
	local string masterName, roomName;
	local LVDataRecord Record;

	Debug("��Ƽ �����丮 " @ param);

	WaitList_ListCtrl.DeleteAllItem();
	//���� ����(2010.02.22 ~ 03.08)�Ϸ�
	Record.LVDataList.Length = 2;

	ParseInt(param, "Count", count);
	
	for(i = 0; i < count; i++)
	{
		roomName = "";
		masterName = "";

		ParseString(param, "MasterName_" $ i, masterName);
		ParseString(param, "RoomName_" $ i, roomName);

		// ������, ��Ƽ�� �̸�
		Record.LVDataList[0].szData = roomName;
		Record.LVDataList[1].szData = masterName;

		WaitList_ListCtrl.InsertRecord(Record);
	}
}

function OnMinimize()
{
	if(USE_XML_BOTTOM_BAR_UI)
	{
		class'BottomBar'.static.Inst().SetPartyOnOffState(false, true);
	}
	else
	{
		CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onMinimize");
	}
}

function HandlePartyToggle(){//��Ƽâ�� ����ݴ� ��� Ŀ�ǵ�. ������. ����. �׼ǻ��. /��Ƽ��Ī �Է½� �� �Լ��� ȣ��ȴ�. jdh84
	local WindowHandle TaskWnd, TaskWnd2;
	local PartyMatchRoomWnd p2_script;

	TaskWnd = GetWindowHandle("PartyMatchWnd");
	TaskWnd2 = GetWindowHandle("PartyMatchRoomWnd");
	p2_script = PartyMatchRoomWnd(GetScript("PartyMatchRoomWnd"));

	if(TaskWnd.IsShowWindow())//��Ƽ��ġ â�� �����ִٸ�
	{
		ClosePartyMatchingWnd(); //�ݴ´�
	}
	else if(TaskWnd2.IsShowWindow())//��Ƽ���� �����ִٸ�
	{
		TaskWnd2.HideWindow(); //�ݴ´�
		p2_script.OnSendPacketWhenHiding();
	}
	else if(class'UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))//��Ƽ���� �̴ϸ����� ���¶��
	{
		TaskWnd2.ShowWindow();//��Ƽ���� ����.
	}
	else
	{
		RequestPartyRoomListLocal(1); //������ ���� ��쿡�� ������ ��û�Ѵ�. ��Ƽ��ġ�� �̴ϸ����� �� ���� ��쿡�� �׷��� �Ѵ�.
	}
}

function ClosePartyMatchingWnd()//��Ƽâ�� 
{
	local WindowHandle TaskWnd;
	local PartyMatchWnd p_script;

	p_script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	TaskWnd = GetWindowHandle("PartyMatchWnd");

	TaskWnd.HideWindow();
	p_script.OnSendPacketWhenHiding();
}

//5�ʰ� ������ ��ư���� Disable���°� Ǯ����
function OnButtonTimer(bool bExpired)
{
	if(bExpired)
	{
		PrevBtn.EnableWindow();
		NextBtn.EnableWindow();
		AutoJoinBtn.EnableWindow();
		RefreshBtn.EnableWindow();
	}
	else
	{
		PrevBtn.DisableWindow();
		NextBtn.DisableWindow();
		AutoJoinBtn.DisableWindow();
		RefreshBtn.DisableWindow();
	}
}

function HandlePartyMatchList(string param)
{
	local int Count, i;
	local LVDataRecord Record;
	local int Number;
	local string PartyRoomName, PartyLeader;
	local int MinLevel;
	local int MaxLevel;
	local int MinMemberCnt;
	local int MaxMemberCnt;

	//���� ����(2010.02.22 ~ 03.08)�Ϸ�
	local int j;
	local int MemberCnt;
	local int MemberClassID;
	local string MemberName;
	local LVData data1;

	// ��Ƽ ��Ī���� �ɹ�, ��Ƽ�� �� �����ִ� �� �߰�(2015-10-26)
	local int totalPartyMemberCount;
	local int totalPartyCount;

	// Debug("::----> HandlePartyMatchList: " @ param);

	ParseInt(param, "TotalPartyCount", totalPartyCount);
	ParseInt(param, "TotalPartyMemberCount", totalPartyMemberCount);

	// Ȱ������ ��Ƽ ���� ���

	ActivityParty_Text.SetText(MakeFullSystemMsg(GetSystemMessage(1983), string(totalPartyCount)));
	ActivityPartyMember_Text.SetText(MakeFullSystemMsg(GetSystemMessage(3305), string(totalPartyMemberCount)));

	PartyMatchListCtrl.DeleteAllItem();
	//���� ����(2010.02.22 ~ 03.08)�Ϸ�
	Record.LVDataList.Length = 7 + (MAXMEMBER / 2);

	ParseInt(param, "PageNum", CUR_PAGE);
	ParseInt(param, "RoomCount", Count);

	for(i = 0; i < Count; ++i)
	{
		ParseInt(param, "RoomNum_" $ i, Number);
		ParseString(param, "Leader_" $ i, PartyLeader);
		ParseInt(param, "MinLevel_" $ i, MinLevel);
		ParseInt(param, "MaxLevel_" $ i, MaxLevel);
		ParseInt(param, "CurMember_" $ i, MinMemberCnt);
		ParseInt(param, "MaxMember_" $ i, MaxMemberCnt);

		if(!getInstanceUIData().getIsClassicServer())
		{
			// �ƽ� ���� �̻��� ��� getInstanceUIData().MAXLV2DISPLAY �� ���� ��
			if(MaxLevel == getInstanceUIData().MAXLV)
			{
				MaxLevel = getInstanceUIData().MAXLV2DISPLAY;
			}
			if(MinLevel == getInstanceUIData().MAXLV)
			{
				MinLevel = getInstanceUIData().MAXLV2DISPLAY;
			}
			// getInstanceUIData().MAXLV2DISPLAY �̻��� ��� getInstanceUIData().MAXLV2DISPLAY �� ������
			//if(MaxLevel > getInstanceUIData().MAXLV2DISPLAY)MaxLevel = getInstanceUIData().MAXLV2DISPLAY;
			//if(MinLevel > getInstanceUIData().MAXLV2DISPLAY)MinLevel = getInstanceUIData().MAXLV2DISPLAY;
		}

		//Debug("HandlePartyMatchList MaxLevel" @ MaxLevel);

		ParseString(param, "RoomName_" $ i, PartyRoomName);
		ParseInt(param, "MemberCnt_" $ i, MemberCnt);

		Record.LVDataList[0].szData = string(Number);
		Record.LVDataList[1].szData = PartyLeader;
		Record.LVDataList[2].szData = PartyRoomName;
		Record.LVDataList[3].szData = MinLevel $ "-" $ MaxLevel;
		Record.LVDataList[4].szData = MinMemberCnt $ "/" $ MaxMemberCnt;
		Record.LVDataList[5].szData = string(MemberCnt);

		//���� ����(2010.02.22 ~ 03.08)�Ϸ�
		for(j = 0 ; j < MemberCnt ; ++j)
		{
			ParseString(param, "MemberName_" $ i $ "_" $ j, MemberName);
			ParseInt(param, "MemberClassID_" $ i $ "_" $ j, MemberClassID);

			//debug("[" $ i $ "]" $ "[" $ j $ "]==" $ MemberName);
			//debug("[" $ i $ "]" $ "[" $ j $ "]==" $ MemberClassID);

			data1.nReserved1 = MemberClassID;
			data1.szData = MemberName;

			Record.LVDataList[7 + j] = data1;
		}

		PartyMatchListCtrl.InsertRecord(Record);
	}
}

/** 
 * ���� �����츦 ��Ȱ��ȭ �Ѵ�.
 * ������ �ֻ�ܿ� ū �����츦 �ΰ� �װɷ� �Ʒ� �ִ� ��ҵ��� Ŭ������ �ȵǵ��� �Ѵ�.
 **/
function DisableCurrentWindow(bool bFlag)
{
	DisableWnd.DisableWindow();
	// disableCurrentWindowFlag = bFlag;
	if(bFlag)
	{
		//DisableWnd.SetFocus();
		DisableWnd.ShowWindow();
	}
	else
	{
		DisableWnd.HideWindow();
	}
}

function OnClickButton(string a_strButtonName)
{
	//Debug("a_strButtonName" @ a_strButtonName);
	switch(a_strButtonName)
	{
		case "RefreshBtn":
			OnRefreshBtnClick();
			break;
		case "PrevBtn":
			OnPrevBtnClick();
			break;
		case "NextBtn":
			OnNextBtnClick();
			break;
		case "MakeRoomBtn":
			OnMakeRoomBtnClick();
			break;
		case "AutoJoinBtn":
			OnAutoJoinBtnClick();
			break;
		case "WaitListButton":
			OnWaitListButton();
			break;
		//���ո�Ī
		case "UnionRefreshBtn":
			OnUnionRefreshBtn();
			break;
		case "UnionPrevBtn":
			OnUnionPrevBtn();
			break;
		case "UnionNextBtn":
			OnUnionNextBtn();
			break;
		case "PartyMatchHistory_Btn":
			// ����� ���� â�� ���� �ִٸ� �ݱ�
			if(GetWindowHandle("PartyMatchWaitListWnd").IsShowWindow())
			{
				SetWaitListWnd(false);
				ShowHideWaitListWnd();
			}

			DisableCurrentWindow(true);
			PartyMatchHistory_Wnd.ShowWindow();
			PartyMatchHistory_Wnd.SetFocus();
			Debug("Call --> RequestPartyMatchingHistory()");
			class'PartyMatchAPI'.static.RequestPartyMatchingHistory();
			break;

		// �����丮 â, �ݱ� ��ư
		case "CloseButton":
		case "Close_Btn":
			PartyMatchHistory_Wnd.HideWindow();
			DisableCurrentWindow(false);
			break;
		case "Refresh_Btn":
			Debug("Call --> RequestPartyMatchingHistory()");
			class'PartyMatchAPI'.static.RequestPartyMatchingHistory();
			break;
	}
}

function OnWaitListButton()
{
	ToggleWaitListWnd();
	UpdateWaitListWnd();
}

function OnRefreshBtnClick()
{
	RequestPartyRoomListLocal(1);
}

function OnPrevBtnClick()
{
	local int WantedPageNum;

	if(1 >= CUR_PAGE)
	{
		WantedPageNum = 1;
	}
	else
	{
		WantedPageNum = CUR_PAGE - 1;
	}

	RequestPartyRoomListLocal(WantedPageNum);
}

function OnNextBtnClick()
{
	RequestPartyRoomListLocal(CUR_PAGE + 1);
}

function RequestPartyRoomListLocal(int a_Page)
{
	class'PartyMatchAPI'.static.RequestPartyRoomList(a_Page, GetLocationFilter(), GetLevelFilter());
}

function OnMakeRoomBtnClick()
{
	local PartyMatchMakeRoomWnd Script;
	local UserInfo PlayerInfo;
	local int MAX_LEVEL;

	if(getInstanceUIData().getIsClassicServer())
	{
		MAX_LEVEL = getInstanceUIData().MAXLV;
	} else {
		MAX_LEVEL = getInstanceUIData().MAXLV2DISPLAY;
	}

	script = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));

	if(script != none)
	{
		script.SetRoomNumber(0);
		script.SetTitle(GetSystemMessage(1398));
		script.SetMaxPartyMemberCount(12);

		if(GetPlayerInfo(PlayerInfo))
		{
			if(PlayerInfo.nLevel - 5 > 0)
			{
				script.SetMinLevel(PlayerInfo.nLevel - 5);
			}
			else
			{
				script.SetMinLevel(1);
			}
			if(PlayerInfo.nLevel + 5 <= MAX_LEVEL)
			{
				script.SetMaxLevel(PlayerInfo.nLevel + 5);
			}
			else
			{
				script.SetMaxLevel(MAX_LEVEL);
			}
		}
	}
	script.InviteState = script.InviteStateType.MAKEROOM;

	PartyMatchMakeRoomWnd.ShowWindow();
	PartyMatchMakeRoomWnd.SetFocus();
}

function OnDBClickListCtrlRecord(string a_ListCtrlName)
{
	local int SelectedRecordIndex;
	local LVDataRecord Record;

	if(a_ListCtrlName == "PartyMatchListCtrl")
	{
		SelectedRecordIndex = PartyMatchListCtrl.GetSelectedIndex();
		PartyMatchListCtrl.GetRec(SelectedRecordIndex, Record);
		class'PartyMatchAPI'.static.RequestJoinPartyRoom(int(Record.LVDataList[0].szData));
	}
	else if(a_ListCtrlName == "UnionMatchListCtrl")
	{
		SelectedRecordIndex = UnionMatchListCtrl.GetSelectedIndex();
		UnionMatchListCtrl.GetRec(SelectedRecordIndex, Record);
		class'PartyMatchAPI'.static.RequestJoinMpccRoom(int(Record.LVDataList[0].szData), 0);
	}
	return;
}

function OnAutoJoinBtnClick()
{
	class'PartyMatchAPI'.static.RequestJoinPartyRoomAuto(CUR_PAGE, GetLocationFilter(), GetLevelFilter());
}

//20140309 ��ġ ���� ������ ���� ��
function int GetLocationFilter()
{
	/*
	* -1 �� ��� ��ü�� �޴´�.
	* -2 �� �� ����
	* ������ ���ڴ� zoneID ��.
	*/
	return -1;
}

function int GetLevelFilter()
{
	return LevelFilterComboBox.GetSelectedNum();
}

/////////////////////////////////////////////////////////////////////////////////
////// ����� ����Ʈ ���� ���� �Լ�
////// WaitListWnd�� 2���� �ִµ�, Show/Hide�� ������ �Ѱ����� �����ϱ� ����
/////////////////////////////////////////////////////////////////////////////////

//����ڸ���Ʈ Flag����
function SetWaitListWnd(bool bShow)
{
	bOpenStateLobby = bShow;
}

//����ڸ���Ʈ ǥ��
function ShowHideWaitListWnd()
{
	if(bOpenStateLobby)
	{
		PartyMatchOutWaitListWnd.ShowWindow();
		PartyMatchWaitListWnd.ShowWindow();
	} else {
		PartyMatchOutWaitListWnd.HideWindow();
		PartyMatchWaitListWnd.HideWindow();
	}
}

//����ڸ���Ʈ ������Ʈ
function UpdateWaitListWnd()
{
	local int MinLevel;
	local int MaxLevel;
	local string strName;

	if(IsShowWaitListWnd())
	{
		MinLevel = int(PartyMatchOutWaitListWnd_MinLevel.GetString());
		MaxLevel = int(PartyMatchOutWaitListWnd_MaxLevel.GetString());

		//���� ����(2010.02.22 ~ 03.08)�Ϸ�
		strName = PartyMatchOutWaitListWnd_Name.GetString();
		RequestPartyMatchWaitList(1, MinLevel, MaxLevel, JobFilterComboBox.GetSelectedNum(), strName);
	}
}

//����ڸ���Ʈ ���
function ToggleWaitListWnd()
{
	bOpenStateLobby = !bOpenStateLobby;
	ShowHideWaitListWnd();
}

function bool IsShowWaitListWnd()
{
	return bOpenStateLobby;
}

////////////////////////////////////////////////////
// ���ո�Ī 2009.3.17 ttmayrin /////////////////////
////////////////////////////////////////////////////
function HandleListMpccWaitingStart(string param)
{
	local int ListCount;

	ParseInt(param, "Page", CUR_PAGE_UNION);
	ParseInt(param, "listCount", ListCount);

	UnionMatchListCtrl.DeleteAllItem();

	if(CUR_PAGE_UNION > 1)
	{
		UnionPrevBtn.EnableWindow();
	}
	if(ListCount > 0)
	{
		UnionNextBtn.EnableWindow();
	}
}

function HandleListMpccWaitingRoomInfo(string param)
{
	local LVDataRecord Record;
	local int RoomNum;
	local string Title;
	local string MasterName;
	local int MinLevelLimit;
	local int MaxLevelLimit;
	local int CurrentJoinMemberCnt;
	local int MaxMemberLimit;

	Record.LVDataList.Length = 5;
	ParseInt(param, "RoomNum", RoomNum);
	ParseString(param, "Title", Title);
	ParseString(param, "MasterName", MasterName);
	ParseInt(param, "MinLevelLimit", MinLevelLimit);
	ParseInt(param, "MaxLevelLimit", MaxLevelLimit);
	ParseInt(param, "CurrentJoinMemberCnt", CurrentJoinMemberCnt);
	ParseInt(param, "MaxMemberLimit", MaxMemberLimit);

	Record.LVDataList[0].szData = string(RoomNum);
	Record.LVDataList[1].szData = Title;
	Record.LVDataList[2].szData = MasterName;
	Record.LVDataList[3].szData = MinLevelLimit $ "-" $ MaxLevelLimit;
	Record.LVDataList[4].szData = CurrentJoinMemberCnt $ "/" $ MaxMemberLimit;

	UnionMatchListCtrl.InsertRecord(Record);
}

function OnUnionRefreshBtn()
{
	RequestUnionRoomList(1);
}

function OnUnionPrevBtn()
{
	local int WantedPageNum;

	if(1 >= CUR_PAGE_UNION)
	{
		WantedPageNum = 1;
	}
	else
	{
		WantedPageNum = CUR_PAGE_UNION - 1;
	}

	RequestUnionRoomList(WantedPageNum);
}

function OnUnionNextBtn()
{
	RequestUnionRoomList(CUR_PAGE_UNION + 1);
}

function RequestUnionRoomList(int a_Page)
{
	UnionPrevBtn.DisableWindow();
	UnionNextBtn.DisableWindow();
	class'PartyMatchAPI'.static.RequestListMpccWaiting(a_Page, GetLocationFilter(), GetLevelFilter());
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
	m_WindowName="PartyMatchWnd"
}
