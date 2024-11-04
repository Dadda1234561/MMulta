/**
 *   출석부 시스템(해외쪽 부터 개발되고, 국내에도 사용 예정)
 *   
 *   관련 빌드 명령어 
 *   //attendance info
 *   //attendance check 1(날짜)
 *   //attendance reset [type1:normal, 2:newbie, 3:dormant]
 *   //attendance reset 1  (타겟 찍고)
 *   //attendance reset_time  (타겟 찍고)
 *   //pccafe on     //pc방 모드
 *   
 **/ 

class AttendCheckWnd extends UICommonAPI;

const SHOW_STEP_PER_PAGE = 7;
const SHOW_STEP_MINIMUM_PAGE = 1;
const TIMER_REQUEST_DELAY = 1000;
const TIMER_ID_REQUEST_DELAY = 1;

enum EAttendCheckState 
{
	Unchecked,
	Available,
	Checked
};

struct AttendCheckStepInfo
{
	var int Day;
	var int ItemID;
	var INT64 ItemAmount;
	var bool isHighLight;
	var EAttendCheckState State;
};

struct AttendCheckInfo
{
	var int currentPage;
	var int maxPage;
	var int minimumLevel;
	var int today;
	var int todayPage;
	var int attendDay;
	var bool itemGetEnable;
	var array<AttendCheckStepInfo> stepInfos;
};

var WindowHandle Me;
var WindowHandle scrollAreaContainer;
var WindowHandle scrollArea;
var TextBoxHandle infoTextBox;
var ButtonHandle pagePrevBtn;
var ButtonHandle pageNextBtn;
var ButtonHandle attendCheckBtn;
var UIControlPageNavi pageNaviControl;
var array<AttendCheckSlot> stepControlList;
var AttendCheckInfo _attendCheckInfo;
var bool _isWaitingRequestDelay;
var int scrollAreaWidth;

//------------------------------------------------------------------------------------------------------------------------------------
//  OnRegisterEvent
//------------------------------------------------------------------------------------------------------------------------------------
event OnRegisterEvent()
{
	RegisterEvent(EV_VipAttendanceItemList); //10050
	RegisterEvent(EV_VipAttendanceCheck); //10051
	RegisterEvent(EV_Restart);	
}

//------------------------------------------------------------------------------------------------------------------------------------
//  OnLoad
//------------------------------------------------------------------------------------------------------------------------------------
event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnShow()
{
	// 지정한 윈도우를 제외한 닫기 기능 
	_isWaitingRequestDelay = false;
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
}

//------------------------------------------------------------------------------------------------------------------------------------
//  Init
//------------------------------------------------------------------------------------------------------------------------------------
function Initialize()
{
	//--------------------------------------
	// 윈도우 핸들.
	//--------------------------------------
	// 윈도우 핸들
	local string ownerFullPath;
	local int i, tempHeight;
	local WindowHandle targetStepWnd;
	local AttendCheckSlot stepControl;
	local WindowHandle pageNaviControlWnd;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle("AttendCheckWnd");
	infoTextBox = GetTextBoxHandle(ownerFullPath $ ".Message_TextBox");
	infoTextBox.SetText("");
	pageNaviControlWnd = GetWindowHandle(ownerFullPath $ ".PageNavi_Control");
	pageNaviControlWnd.SetScript("UIControlPageNavi");
	pageNaviControl = UIControlPageNavi(pageNaviControlWnd.GetScript());
	pageNaviControl.Init(ownerFullPath $ ".PageNavi_Control");
	pageNaviControl.DelegeOnChangePage = OnPageNaviChanged;
	pagePrevBtn = GetButtonHandle(ownerFullPath $ ".Prev_Btn");
	pageNextBtn = GetButtonHandle(ownerFullPath $ ".Next_Btn");
	attendCheckBtn = GetButtonHandle(ownerFullPath $ ".RewardBtn");
	scrollAreaContainer = GetWindowHandle(ownerFullPath $ ".ScrollAreaWnd");
	scrollArea = GetWindowHandle(scrollAreaContainer.m_WindowNameWithFullPath $ ".ScrollArea");
	scrollArea.GetWindowSize(scrollAreaWidth, tempHeight);
	_attendCheckInfo.currentPage = 1;
	stepControlList.Length = 0;

	// End:0x29A [Loop If]
	for(i = 0; i < 7; i++)
	{
		targetStepWnd = GetWindowHandle(scrollArea.m_WindowNameWithFullPath $ ".DaySlot_" $ string(i));
		targetStepWnd.SetScript("AttendCheckSlot");
		stepControl = AttendCheckSlot(targetStepWnd.GetScript());
		stepControl.Init(targetStepWnd, self);
		stepControl.DelegateOnItemClicked = OnStepAvailableItemClicked;
		stepControlList[i] = stepControl;
	}
}

function ResetInfo()
{
	local AttendCheckInfo defaultInfo;

	_attendCheckInfo = defaultInfo;
	_attendCheckInfo.currentPage = 1;	
}

function StopAllAniTexture()
{
	local int i;

	// End:0x36 [Loop If]
	for(i = 0; i < stepControlList.Length; i++)
	{
		stepControlList[i].StopAnimation();
	}	
}

function CheckAndPlayStampAnimaion()
{
	local int i;

	// End:0x36 [Loop If]
	for(i = 0; i < stepControlList.Length; i++)
	{
		stepControlList[i].CheckAndPlayStampAnimation();
	}	
}

function InitScrollArea()
{
	scrollArea.SetScrollHeight(scrollAreaWidth * _attendCheckInfo.maxPage);
	scrollArea.SetScrollUnit(scrollAreaWidth, true);	
}

function UpdateScrollPosition()
{
	scrollArea.SetScrollPosition(GetScrollPosByPage(_attendCheckInfo.currentPage));	
}

function UpdateUIControls()
{
	UpdateStepControls();
	UpdateButtonControls();
	UpdateScrollPosition();
	UpdateInfoControls();
}

function UpdateStepControls()
{
	local int i, infoIndex, infoLength, currentPage;

	currentPage = Max(_attendCheckInfo.currentPage, 1);
	infoLength = _attendCheckInfo.stepInfos.Length;
	infoIndex = (currentPage - 1) * 7;

	// End:0xA7 [Loop If]
	for(i = 0; i < 7; i++)
	{
		// End:0x80
		if(infoIndex < infoLength)
		{
			stepControlList[i].SetInfo(_attendCheckInfo.stepInfos[infoIndex]);			
		}
		else
		{
			stepControlList[i].SetDisable(true);
		}
		infoIndex++;
	}
	SetPageNaviMaxPage(_attendCheckInfo.maxPage);
	SetPageNaviCurrentPage(currentPage);
	// End:0xF5
	if(_attendCheckInfo.maxPage == 1)
	{
		pagePrevBtn.SetEnable(false);
		pageNextBtn.SetEnable(false);		
	}
	else if(_attendCheckInfo.currentPage == _attendCheckInfo.maxPage)
	{
		pagePrevBtn.SetEnable(true);
		pageNextBtn.SetEnable(false);			
	}
	else if(_attendCheckInfo.currentPage == 1)
	{
		pagePrevBtn.SetEnable(false);
		pageNextBtn.SetEnable(true);				
	}
	else
	{
		pagePrevBtn.SetEnable(true);
		pageNextBtn.SetEnable(true);
	}
}

function SetPageNaviMaxPage(int maxPage)
{
	pageNaviControl.SetTotalPage(maxPage);
}

function SetPageNaviCurrentPage(int Page)
{
	pageNaviControl.Go(Page);
}

function UpdateInfoControls()
{
	local UserInfo UserInfo;
	local int minimumLevel;

	minimumLevel = _attendCheckInfo.minimumLevel;
	// End:0x5A
	if(_attendCheckInfo.today >= _attendCheckInfo.stepInfos.Length && _attendCheckInfo.itemGetEnable == false)
	{
		infoTextBox.SetText(GetSystemMessage(6222));		
	}
	else
	{
		// End:0xCB
		if(minimumLevel > 0)
		{
			GetPlayerInfo(UserInfo);
			// End:0xAE
			if(minimumLevel > UserInfo.nLevel)
			{
				infoTextBox.SetText(MakeFullSystemMsg(GetSystemMessage(6188), string(minimumLevel)));				
			}
			else
			{
				infoTextBox.SetText(GetSystemMessage(6194));
			}			
		}
		else
		{
			infoTextBox.SetText(GetSystemMessage(6194));
		}
	}	
}

function UpdateButtonControls()
{
	// End:0x64
	if(_attendCheckInfo.itemGetEnable == true)
	{
		attendCheckBtn.SetButtonName(5600);
		// End:0x51
		if(_attendCheckInfo.todayPage == _attendCheckInfo.currentPage)
		{
			attendCheckBtn.SetEnable(true);			
		}
		else
		{
			attendCheckBtn.SetEnable(false);
		}		
	}
	else
	{
		attendCheckBtn.SetEnable(false);
		attendCheckBtn.SetButtonName(5601);
	}
	// End:0xAB
	if(_attendCheckInfo.maxPage == 1)
	{
		pageNaviControl.SetDisable(true);		
	}
	else
	{
		pageNaviControl.SetDisable(false);
	}	
}

function int GetPageByScrollPos(int pos)
{
	return (pos / scrollAreaWidth) + 1;	
}

function int GetScrollPosByPage(int Page)
{
	return (Page - 1) * scrollAreaWidth;	
}

function RequestAttendCheck()
{
	// End:0x18
	if(_isWaitingRequestDelay == false)
	{
		StartRequestDelayTimer();
		RequestAttendanceCheck();
	}
}

function StartRequestDelayTimer()
{
	_isWaitingRequestDelay = true;
	Me.SetTimer(TIMER_ID_REQUEST_DELAY, TIMER_REQUEST_DELAY);	
}

function KillRequestDelayTimer()
{
	Me.KillTimer(TIMER_ID_REQUEST_DELAY);
	_isWaitingRequestDelay = false;	
}

//------------------------------------------------------------------------------------------------------------------------------------
//  OnEvent Process
//------------------------------------------------------------------------------------------------------------------------------------
function OnEvent(int Event_ID, string a_Param)
{
	if(Event_ID == EV_VipAttendanceItemList)
	{
		Rs_EV_VipAttendanceItemList(a_Param);
	}
	else if(Event_ID == EV_VipAttendanceCheck)
	{
		Nt_EV_VipAttendanceCheck(a_Param);
	}
	else if(Event_ID == EV_Restart)
	{
		ResetInfo();
	}
}

function Rs_EV_VipAttendanceItemList(string param)
{
	local int i, itemTotalCount, itemGetEnable, attendDay, today, ItemID,
		Amount, highLight, minimumLevel, maxPage;

	local AttendCheckStepInfo stepInfo;

	ParseInt(param, "Today", today);
	ParseInt(param, "NormalDay", attendDay);
	ParseInt(param, "ItemCount", itemTotalCount);
	ParseInt(param, "NormalAttendanceEnable", itemGetEnable);
	ParseInt(param, "MinimumLevel", minimumLevel);
	_attendCheckInfo.stepInfos.Length = 0;

	// End:0x1DF [Loop If]
	for(i = 1; i <= itemTotalCount; i++)
	{
		ParseInt(param, "ItemID_" $ string(i), ItemID);
		ParseInt(param, "Amount_" $ string(i), Amount);
		ParseInt(param, "HighLight_" $ string(i), highLight);
		stepInfo.Day = i;
		stepInfo.ItemAmount = Amount;
		stepInfo.isHighLight = bool(highLight);
		stepInfo.ItemID = ItemID;
		// End:0x183
		if(attendDay >= i)
		{
			stepInfo.State = Checked;			
		}
		else
		{
			stepInfo.State = Unchecked;
		}
		// End:0x1B9
		if((today == i) && itemGetEnable > 0)
		{
			stepInfo.State = Available;
		}
		_attendCheckInfo.stepInfos[_attendCheckInfo.stepInfos.Length] = stepInfo;
	}
	maxPage = Max(appCeil(float(itemTotalCount) / SHOW_STEP_PER_PAGE), SHOW_STEP_MINIMUM_PAGE);
	_attendCheckInfo.minimumLevel = minimumLevel;
	_attendCheckInfo.today = today;
	_attendCheckInfo.attendDay = attendDay;
	_attendCheckInfo.itemGetEnable = bool(itemGetEnable);
	_attendCheckInfo.maxPage = maxPage;
	_attendCheckInfo.todayPage = Min(Max(appCeil(float(today) / SHOW_STEP_PER_PAGE), SHOW_STEP_MINIMUM_PAGE), maxPage);
	_attendCheckInfo.currentPage = _attendCheckInfo.todayPage;
	InitScrollArea();
	UpdateUIControls();
	// End:0x2C9
	if(! Me.IsShowWindow())
	{
		Me.ShowWindow();
		Me.SetFocus();
	}	
}

function Nt_EV_VipAttendanceCheck(string param)
{
	local int checkDay, checkType, dayIndex;
	local AttendCheckStepInfo stepInfo;

	ParseInt(param, "CheckDay", checkDay);
	ParseInt(param, "CheckType", checkType);
	// End:0xF8
	if(checkDay > 0)
	{
		dayIndex = checkDay - 1;
		// End:0xF8
		if(_attendCheckInfo.stepInfos.Length > dayIndex)
		{
			stepInfo = _attendCheckInfo.stepInfos[dayIndex];
			stepInfo.State = Checked;
			_attendCheckInfo.stepInfos[dayIndex] = stepInfo;
			_attendCheckInfo.itemGetEnable = false;
			CheckAndPlayStampAnimaion();
			UpdateButtonControls();
			UpdateInfoControls();
			PlaySound("InterfaceSound.stamp_red");
			getInstanceNoticeWnd().RemoveAttendCheckNotice();
		}
	}
}

event OnHide()
{
	StopAllAniTexture();
}

event OnScrollMove(string strID, int pos)
{
	local int targetPage;

	targetPage = GetPageByScrollPos(pos);
	// End:0x42
	if(pos != (GetScrollPosByPage(targetPage)))
	{
		scrollArea.SetScrollPosition(GetScrollPosByPage(targetPage));
		return;
	}
	// End:0x6C
	if(_attendCheckInfo.currentPage != targetPage)
	{
		_attendCheckInfo.currentPage = targetPage;
		UpdateUIControls();
	}	
}

event OnTimer(int TimerID)
{
	// End:0x11
	if(TimerID == TIMER_ID_REQUEST_DELAY)
	{
		KillRequestDelayTimer();
	}
}

event OnPageNaviChanged(int Page)
{
	_attendCheckInfo.currentPage = Page;
	UpdateUIControls();	
}

event OnPageStepperClicked(bool isNext)
{
	// End:0x12
	if(_attendCheckInfo.currentPage < 1)
	{
		return;
	}
	// End:0x46
	if(isNext == true)
	{
		// End:0x43
		if(_attendCheckInfo.currentPage < _attendCheckInfo.maxPage)
		{
			_attendCheckInfo.currentPage++;
		}		
	}
	else
	{
		// End:0x62
		if(_attendCheckInfo.currentPage > 1)
		{
			_attendCheckInfo.currentPage--;
		}
	}
	UpdateUIControls();	
}

//------------------------------------------------------------------------------------------------------------------------------------
//  OnClickButton Event
//------------------------------------------------------------------------------------------------------------------------------------
event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x1C
		case "HelpBtn":
			OnHelpBtnClicked();
			// End:0x7B
			break;
		// End:0x33
		case "CancelBtn":
			OnCancelBtnClicked();
			// End:0x7B
			break;
		// End:0x4A
		case "Prev_Btn":
			OnPageStepperClicked(false);
			// End:0x7B
			break;
		// End:0x61
		case "Next_Btn":
			OnPageStepperClicked(true);
			// End:0x7B
			break;
		// End:0x78
		case "RewardBtn":
			OnAttendCheckBtnClicked();
			// End:0x7B
			break;
	}	
}

event OnAttendCheckBtnClicked()
{
	RequestAttendCheck();
}

event OnStepAvailableItemClicked(AttendCheckSlot Slot)
{
}

event OnCancelBtnClicked()
{
	Me.HideWindow();	
}

event OnHelpBtnClicked()
{
	local string strParam;

	ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "g_attendance_help001.htm");
	HelpHtmlWnd(GetScript("HelpHtmlWnd")).HandleShowHelp(strParam);
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
}
