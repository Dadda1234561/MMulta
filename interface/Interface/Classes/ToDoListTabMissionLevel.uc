class ToDoListTabMissionLevel extends UICommonAPI;

const SHOW_STEP_PER_PAGE = 10;
const SHOW_STEP_MINIMUM_PAGE = 1;
const TIMER_ID_SEASON_REMAIN = 1;
const TIMER_ID_BTN_DELAY = 2;
const TIMER_DELAY_BTN_DISABLE = 1000;
const TIMER_DELAY_SEASON_REMAIN = 60000;

enum EMissionLevelRewardType 
{
	RewardNone,
	RewardBase,
	RewardKey,
	RewardSpecial,
	RewardExtra
};

enum EMissionLevelRewardState 
{
	Unavailable,
	Available,
	AlreadyReceived
};

struct MissionLevelStepInfo
{
	var int Level;
	var MissionRewardItem baseRewardItem;
	var MissionRewardItem keyRewardItem;
	var EMissionLevelRewardState baseRewardState;
	var EMissionLevelRewardState keyRewardState;
};

struct MissionLevelInfo
{
	var int CurrentLevel;
	var int SeasonYear;
	var int SeasonMonth;
	var int RemainTime;
	var int pointPercent;
	var int extraRewardsAvailable;
	var int totalRewardsAvailable;
	var EMissionLevelRewardState specialRewardState;
	var EMissionLevelRewardState extraRewardState;
	var int SeasonDate;
	var int LimitLevel;
	var MissionRewardItem SpecialRewardItem;
	var MissionRewardItem ExtraRewardItem;
	var int currentStepPage;
	var int maxStepPage;
	var int availableBaseRewardLevel;
	var int availableKeyRewardLevel;
	var array<MissionLevelStepInfo> stepInfo;
};

var MissionLevelInfo _missionLevelInfo;
var int _remainTimerCount;
var bool _isWaitingBtnDelay;
var bool _isOpenPacket;
var WindowHandle Me;
var ToDoListWnd parentWnd;
var WindowHandle missionStepContainer;
var ButtonHandle stepPrevBtn;
var ButtonHandle stepNextBtn;
var ButtonHandle specialRewardGetBtn;
var ButtonHandle extraRewardGetBtn;
var UIControlPageNavi PageNaviControl;
var TextBoxHandle prevLvTextBox;
var TextBoxHandle nextLvTextBox;
var TextBoxHandle remainTimeTextBox;
var StatusBarHandle missionStatusBar;
var ButtonHandle exRewardGetBtn;
var ItemWindowHandle exRewardItemWnd;
var TextureHandle specialRewardBgTex;
var TextureHandle addRewardTex;
var TextBoxHandle exRewardNameTextBox;
var EffectViewportWndHandle specialRewardEffect;
var array<ToDoListMissionLevelStepItem> stepControlList;

function Initialize()
{
	local string ownerFullPath;
	local int i;
	local WindowHandle pageNaviControlWnd;

	_isWaitingBtnDelay = false;
	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	parentWnd = ToDoListWnd(GetScript("ToDoListWnd"));
	Me = GetWindowHandle(ownerFullPath);
	stepPrevBtn = GetButtonHandle(ownerFullPath $ ".ControlNaviAdvance_PrevBtn");
	stepNextBtn = GetButtonHandle(ownerFullPath $ ".ControlNaviAdvance_NextBtn");
	specialRewardGetBtn = GetButtonHandle(ownerFullPath $ ".LastRewardGet_BTN");
	extraRewardGetBtn = GetButtonHandle(ownerFullPath $ ".BonusRewardGet_BTN");
	pageNaviControlWnd = GetWindowHandle(ownerFullPath $ ".PageNaviControl");
	pageNaviControlWnd.SetScript("UIControlPageNavi");
	PageNaviControl = UIControlPageNavi(pageNaviControlWnd.GetScript());
	PageNaviControl.Init(ownerFullPath $ ".PageNaviControl");
	PageNaviControl.DelegeOnChangePage = OnPageNaviChanged;
	prevLvTextBox = GetTextBoxHandle(ownerFullPath $ ".PrvLVNum_txt");
	nextLvTextBox = GetTextBoxHandle(ownerFullPath $ ".NextLVNum_txt");
	remainTimeTextBox = GetTextBoxHandle(ownerFullPath $ ".Time_txt");
	missionStatusBar = GetStatusBarHandle(ownerFullPath $ ".LVGauge_bar");
	exRewardItemWnd = GetItemWindowHandle(ownerFullPath $ ".AdvanceRewardItem_ItemWnd");
	specialRewardBgTex = GetTextureHandle(ownerFullPath $ ".AdvanceRewardItemBG_Texture");
	addRewardTex = GetTextureHandle(ownerFullPath $ ".AddReward");
	exRewardNameTextBox = GetTextBoxHandle(ownerFullPath $ ".RewardItemName_text");
	specialRewardEffect = GetEffectViewportWndHandle(ownerFullPath $ ".Result_EffectViewport");
	_missionLevelInfo.currentStepPage = 1;

	// End:0x336 [Loop If]
	for(i = 0; i < SHOW_STEP_PER_PAGE; i++)
	{
		AddStepControl(stepControlList, "Section0", i, Me);
	}
}

function AddStepControl(out array<ToDoListMissionLevelStepItem> componentList, string componentName, int Index, WindowHandle Owner)
{
	local WindowHandle targetWindowHandle;
	local ToDoListMissionLevelStepItem targetControl;

	targetWindowHandle = GetWindowHandle(Owner.m_WindowNameWithFullPath $ "." $ componentName $ string(Index));
	targetWindowHandle.SetScript("ToDoListMissionLevelStepItem");
	targetControl = ToDoListMissionLevelStepItem(targetWindowHandle.GetScript());
	targetControl.Init(targetWindowHandle, self);
	targetControl.DelegateOnBaseRewardClicked = OnBaseRewardStepClicked;
	targetControl.DelegateOnKeyRewardClicked = OnKeyRewardStepClicked;
	componentList[componentList.Length] = targetControl;
}

function UpdateStepControls()
{
	local int i, infoindex, infoLength, currentPage;

	currentPage = Max(_missionLevelInfo.currentStepPage, 1);
	infoLength = _missionLevelInfo.stepInfo.Length;
	infoindex = ((currentPage - 1) * SHOW_STEP_PER_PAGE) + 1;

	// End:0xC8 [Loop If]
	for(i = 0; i < SHOW_STEP_PER_PAGE; i++)
	{
		// End:0xA1
		if(infoindex < infoLength)
		{
			stepControlList[i]._SetStepInfo(_missionLevelInfo.stepInfo[infoindex], _missionLevelInfo.CurrentLevel, _missionLevelInfo.availableBaseRewardLevel, _missionLevelInfo.availableKeyRewardLevel);			
		}
		else
		{
			stepControlList[i]._SetDisable(true);
		}
		infoindex++;
	}
	SetPageNaviMaxPage(_missionLevelInfo.maxStepPage);
	SetPageNaviCurrentPage(currentPage);
	// End:0x116
	if(_missionLevelInfo.maxStepPage == 1)
	{
		stepPrevBtn.SetEnable(false);
		stepNextBtn.SetEnable(false);		
	}
	else
	{
		// End:0x152
		if(_missionLevelInfo.currentStepPage == _missionLevelInfo.maxStepPage)
		{
			stepPrevBtn.SetEnable(true);
			stepNextBtn.SetEnable(false);			
		}
		else
		{
			// End:0x185
			if(_missionLevelInfo.currentStepPage == 1)
			{
				stepPrevBtn.SetEnable(false);
				stepNextBtn.SetEnable(true);				
			}
			else
			{
				stepPrevBtn.SetEnable(true);
				stepNextBtn.SetEnable(true);
			}
		}
	}
}

function UpdateProgressInfoControls()
{
	local int CurrentLevel;

	CurrentLevel = _missionLevelInfo.CurrentLevel;
	prevLvTextBox.SetText(string(CurrentLevel));
	nextLvTextBox.SetText(string(CurrentLevel + 1));
	// End:0x80
	if(CurrentLevel >= _missionLevelInfo.LimitLevel)
	{
		missionStatusBar.SetGaugeColor(missionStatusBar.StatusBarSplitType.SBST_ForeCenter, GetColor(155, 40, 45, 255));		
	}
	else
	{
		missionStatusBar.SetGaugeColor(missionStatusBar.StatusBarSplitType.SBST_ForeCenter, GetColor(205, 130, 5, 255));
	}
	missionStatusBar.SetDecimalPlace(0);
	missionStatusBar.SetPointExpPercentRate(float(_missionLevelInfo.pointPercent) / float(100));
}

function UpdateRemainTimeControls()
{
	local int RemainTime;

	RemainTime = _missionLevelInfo.RemainTime;
	RemainTime -= _remainTimerCount * 60;
	remainTimeTextBox.SetText(parentWnd.getTimeStringBySec(RemainTime));
}

function UpdateExRewardControls()
{
	local ItemInfo rewardIteminfo;
	local string rewardNameStr, rewardNumStr;

	// End:0x13D
	if(_missionLevelInfo.specialRewardState == AlreadyReceived)
	{
		rewardIteminfo = GetItemInfoByClassID(_missionLevelInfo.ExtraRewardItem.ItemClassID);
		exRewardItemWnd.Clear();
		exRewardItemWnd.AddItem(rewardIteminfo);
		rewardNameStr = rewardIteminfo.Name;
		// End:0x9E
		if(_missionLevelInfo.extraRewardsAvailable > 1)
		{
			rewardNumStr = "x" $ string(_missionLevelInfo.ExtraRewardItem.Amount * _missionLevelInfo.extraRewardsAvailable);			
		}
		else
		{
			rewardNumStr = "x" $ string(_missionLevelInfo.ExtraRewardItem.Amount);
		}
		exRewardNameTextBox.SetText(rewardNameStr @ rewardNumStr);
		// End:0xFD
		if(_missionLevelInfo.extraRewardState == Available)
		{
			extraRewardGetBtn.SetEnable(true);			
		}
		else
		{
			extraRewardGetBtn.SetEnable(false);
		}
		specialRewardBgTex.HideWindow();
		specialRewardGetBtn.HideWindow();
		extraRewardGetBtn.ShowWindow();		
	}
	else
	{
		rewardIteminfo = GetItemInfoByClassID(_missionLevelInfo.SpecialRewardItem.ItemClassID);
		exRewardItemWnd.Clear();
		exRewardItemWnd.AddItem(rewardIteminfo);
		rewardNameStr = rewardIteminfo.Name;
		rewardNumStr = "x" $ string(_missionLevelInfo.SpecialRewardItem.Amount);
		exRewardNameTextBox.SetText(rewardNameStr @ rewardNumStr);
		// End:0x1EA
		if(_missionLevelInfo.specialRewardState == Available)
		{
			specialRewardGetBtn.SetEnable(true);			
		}
		else
		{
			specialRewardGetBtn.SetEnable(false);
		}
		specialRewardBgTex.ShowWindow();
		specialRewardGetBtn.ShowWindow();
		extraRewardGetBtn.HideWindow();
	}
	// End:0x249
	if(_missionLevelInfo.extraRewardsAvailable > 0)
	{
		addRewardTex.ShowWindow();		
	}
	else
	{
		addRewardTex.HideWindow();
	}
}

function UpdateUIControls()
{
	UpdateProgressInfoControls();
	UpdateExRewardControls();
	UpdateStepControls();
	UpdateRemainTimeControls();
}

function ShowSpecialRewardEffect(bool isShow)
{
	// End:0x20
	if(parentWnd.Me.IsShowWindow() == false)
	{
		return;
	}
	// End:0x6D
	if(isShow == true)
	{
		specialRewardEffect.ShowWindow();
		specialRewardEffect.SpawnEffect("LineageEffect2.ui_upgrade_succ");		
	}
	else
	{
		specialRewardEffect.HideWindow();
	}
}

function bool UpdateMissionLevelInfo(int SeasonDate)
{
	local int i;
	local MissionLevelUIData UIData;
	local MissionRewardItem tempRewardInfo;
	local MissionLevelStepInfo stepInfo;

	// End:0x1B8
	if(GetMissionLevelData(SeasonDate, UIData) == true)
	{
		_missionLevelInfo.RemainTime = UIData.SeasonRemainTime;
		StartSeasonRemainTimer();
		// End:0x1B5
		if(_missionLevelInfo.SeasonDate != UIData.SeasonDate)
		{
			_missionLevelInfo.SeasonDate = UIData.SeasonDate;
			_missionLevelInfo.LimitLevel = UIData.LimitLevel;
			_missionLevelInfo.SpecialRewardItem = UIData.SpecialRewardItem;
			_missionLevelInfo.ExtraRewardItem = UIData.ExtraRewardItem;
			_missionLevelInfo.currentStepPage = 1;
			_missionLevelInfo.maxStepPage = Max(appCeil(float(UIData.LimitLevel) / float(SHOW_STEP_PER_PAGE)), 1);
			_missionLevelInfo.stepInfo.Length = 0;

			// End:0x159 [Loop If]
			for(i = 0; i < UIData.BaseRewardItems.Length; i++)
			{
				tempRewardInfo = UIData.BaseRewardItems[i];
				stepInfo.Level = tempRewardInfo.RewardLevel;
				stepInfo.baseRewardItem = tempRewardInfo;
				_missionLevelInfo.stepInfo[tempRewardInfo.RewardLevel] = stepInfo;
			}

			// End:0x1B5 [Loop If]
			for(i = 0; i < UIData.KeyRewardItems.Length; i++)
			{
				tempRewardInfo = UIData.KeyRewardItems[i];
				_missionLevelInfo.stepInfo[tempRewardInfo.RewardLevel].keyRewardItem = tempRewardInfo;
			}
		}		
	}
	else
	{
		return false;
	}
	return true;
}

function UpdateDefaultStepPage()
{
	local int availableRewardLevel;

	// End:0x44
	if(_missionLevelInfo.availableBaseRewardLevel > 0 && _missionLevelInfo.availableKeyRewardLevel > 0)
	{
		availableRewardLevel = Max(0, Min(_missionLevelInfo.availableBaseRewardLevel, _missionLevelInfo.availableKeyRewardLevel));		
	}
	else
	{
		// End:0x6A
		if(_missionLevelInfo.availableBaseRewardLevel > 0)
		{
			availableRewardLevel = Max(0, _missionLevelInfo.availableBaseRewardLevel);			
		}
		else
		{
			// End:0x90
			if(_missionLevelInfo.availableKeyRewardLevel > 0)
			{
				availableRewardLevel = Max(0, _missionLevelInfo.availableKeyRewardLevel);				
			}
			else
			{
				availableRewardLevel = Max(0, _missionLevelInfo.CurrentLevel);
			}
		}
	}
	_missionLevelInfo.currentStepPage = Min(Max(appCeil(float(availableRewardLevel) / float(SHOW_STEP_PER_PAGE)), 1), _missionLevelInfo.maxStepPage);
}

function SetPageNaviMaxPage(int maxPage)
{
	PageNaviControl.SetTotalPage(maxPage);
}

function SetPageNaviCurrentPage(int Page)
{
	PageNaviControl.Go(Page);
}

function StartSeasonRemainTimer()
{
	KillSeasonRemainTimer();
	Me.SetTimer(TIMER_ID_SEASON_REMAIN, TIMER_DELAY_SEASON_REMAIN);
}

function KillSeasonRemainTimer()
{
	Me.KillTimer(TIMER_ID_SEASON_REMAIN);
	_remainTimerCount = 0;
}

function StartBtnDelayTimer()
{
	_isWaitingBtnDelay = true;
	Me.SetTimer(TIMER_ID_BTN_DELAY, TIMER_DELAY_BTN_DISABLE);
}

function KillBtnDelayTimer()
{
	Me.KillTimer(TIMER_ID_BTN_DELAY);
	_isWaitingBtnDelay = false;
}

function StopAllAnimations()
{
	local int i;

	// End:0x36 [Loop If]
	for(i = 0; i < stepControlList.Length; i++)
	{
		stepControlList[i]._StopAllAnimations();
	}
}

function _RequestRewardList()
{
	// End:0x20
	if(parentWnd.Me.IsShowWindow() == false)
	{
		return;
	}
	Rq_C_EX_MISSION_LEVEL_REWARD_LIST();
}

event OnLoad()
{
	Initialize();
}

event OnShow()
{}

event OnHide()
{}

event OnParentShow()
{
	KillBtnDelayTimer();
	UpdateUIControls();
	ShowSpecialRewardEffect(false);
	_isOpenPacket = true;
	_RequestRewardList();
}

event OnParentHide()
{
	KillBtnDelayTimer();
	KillSeasonRemainTimer();
	StopAllAnimations();
}

event OnTimer(int TimerID)
{
	// End:0x1B
	if(TimerID == TIMER_ID_SEASON_REMAIN)
	{
		_remainTimerCount++;
		UpdateRemainTimeControls();		
	}
	else if(TimerID == TIMER_ID_BTN_DELAY)
	{
		KillBtnDelayTimer();
	}
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_MISSION_LEVEL_REWARD_LIST));
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_MISSION_LEVEL_REWARD_LIST):
			Rs_S_EX_MISSION_LEVEL_REWARD_LIST();
			// End:0x2A
			break;
	}
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x26
		case "LastRewardGet_BTN":
			OnSpecialRewardGetBtnClicked();
			// End:0x9B
			break;
		// End:0x46
		case "BonusRewardGet_BTN":
			OnExtraRewardGetBtnClicked();
			// End:0x9B
			break;
		// End:0x6F
		case "ControlNaviAdvance_PrevBtn":
			OnPageStepperClicked(false);
			// End:0x9B
			break;
		// End:0x98
		case "ControlNaviAdvance_NextBtn":
			OnPageStepperClicked(true);
			// End:0x9B
			break;
	}
}

event OnSpecialRewardGetBtnClicked()
{
	// End:0x0E
	if(_isWaitingBtnDelay == true)
	{
		return;
	}
	// End:0x3B
	if(_missionLevelInfo.specialRewardState == Available)
	{
		StartBtnDelayTimer();
		Rq_C_EX_MISSION_LEVEL_RECEIVE_REWARD(_missionLevelInfo.LimitLevel, EMissionLevelRewardType.RewardSpecial/*3*/);
	}
}

event OnExtraRewardGetBtnClicked()
{
	// End:0x0E
	if(_isWaitingBtnDelay == true)
	{
		return;
	}
	// End:0x3B
	if(_missionLevelInfo.extraRewardState == Available)
	{
		StartBtnDelayTimer();
		Rq_C_EX_MISSION_LEVEL_RECEIVE_REWARD(_missionLevelInfo.CurrentLevel, EMissionLevelRewardType.RewardExtra/*4*/);
	}
}

event OnBaseRewardStepClicked(ToDoListMissionLevelStepItem Owner)
{
	// End:0x0E
	if(_isWaitingBtnDelay == true)
	{
		return;
	}
	// End:0x52
	if(Owner._info.baseRewardState == 1)
	{
		StartBtnDelayTimer();
		Rq_C_EX_MISSION_LEVEL_RECEIVE_REWARD(Owner._info.baseRewardItem.RewardLevel, EMissionLevelRewardType.RewardBase/*1*/);
	}
}

event OnKeyRewardStepClicked(ToDoListMissionLevelStepItem Owner)
{
	// End:0x0E
	if(_isWaitingBtnDelay == true)
	{
		return;
	}
	// End:0x52
	if(Owner._info.keyRewardState == 1)
	{
		StartBtnDelayTimer();
		Rq_C_EX_MISSION_LEVEL_RECEIVE_REWARD(Owner._info.keyRewardItem.RewardLevel, EMissionLevelRewardType.RewardKey/*2*/);
	}
}

event OnPageNaviChanged(int Page)
{
	_missionLevelInfo.currentStepPage = Page;
	UpdateUIControls();
}

event OnPageStepperClicked(bool isNext)
{
	// End:0x12
	if(_missionLevelInfo.currentStepPage < 1)
	{
		return;
	}
	// End:0x46
	if(isNext == true)
	{
		// End:0x43
		if(_missionLevelInfo.currentStepPage < _missionLevelInfo.maxStepPage)
		{
			_missionLevelInfo.currentStepPage++;
		}		
	}
	else
	{
		// End:0x62
		if(_missionLevelInfo.currentStepPage > 1)
		{
			_missionLevelInfo.currentStepPage--;
		}
	}
	UpdateUIControls();
}

function Rq_C_EX_MISSION_LEVEL_REWARD_LIST()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MISSION_LEVEL_REWARD_LIST, stream);
}

function Rq_C_EX_MISSION_LEVEL_RECEIVE_REWARD(int Level, EMissionLevelRewardType rewardType)
{
	local array<byte> stream;
	local UIPacket._C_EX_MISSION_LEVEL_RECEIVE_REWARD packet;

	packet.nLevel = Level;
	packet.nRewardType = rewardType;
	// End:0x42
	if(! class'UIPacket'.static.Encode_C_EX_MISSION_LEVEL_RECEIVE_REWARD(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MISSION_LEVEL_RECEIVE_REWARD, stream);
}

function Rs_S_EX_MISSION_LEVEL_REWARD_LIST()
{
	local UIPacket._S_EX_MISSION_LEVEL_REWARD_LIST packet;
	local int i, firstAvailableBaseLevel, firstAvailableKeyLevel;
	local UIPacket._PkMissionLevelReward rewardInfo;

	firstAvailableBaseLevel = -1;
	firstAvailableKeyLevel = -1;
	// End:0x31
	if(! class'UIPacket'.static.Decode_S_EX_MISSION_LEVEL_REWARD_LIST(packet))
	{
		return;
	}
	// End:0x7A
	if(packet.rewards.Length == 0)
	{
		Debug("Rs_S_EX_MISSION_LEVEL_REWARD_LIST Empty Packet");
		return;
	}
	_missionLevelInfo.extraRewardsAvailable = packet.nExtraRewardsAvailable;
	_missionLevelInfo.CurrentLevel = packet.nLevel;
	_missionLevelInfo.pointPercent = packet.nPointPercent;
	_missionLevelInfo.SeasonYear = packet.nSeasonYear;
	_missionLevelInfo.SeasonMonth = packet.nSeasonMonth;
	_missionLevelInfo.totalRewardsAvailable = packet.nTotalRewardsAvailable;
	// End:0x118
	if(packet.nExtraRewardsAvailable > 0)
	{
		_missionLevelInfo.extraRewardState = Available;		
	}
	else
	{
		_missionLevelInfo.extraRewardState = Unavailable;
	}
	// End:0x33A
	if(UpdateMissionLevelInfo((packet.nSeasonYear * 100) + packet.nSeasonMonth))
	{
		// End:0x317 [Loop If]
		for(i = 0; i < packet.rewards.Length; i++)
		{
			rewardInfo = packet.rewards[i];
			// End:0x190
			if(rewardInfo.nType == 4)
			{
				// [Explicit Continue]
				continue;
			}
			// End:0x1FE
			if(rewardInfo.nType == 3)
			{
				// End:0x1E4
				if(_missionLevelInfo.specialRewardState == Available && _isOpenPacket != true)
				{
					// End:0x1E4
					if(byte(rewardInfo.nState) == 2)
					{
						ShowSpecialRewardEffect(true);
					}
				}
				_missionLevelInfo.specialRewardState = EMissionLevelRewardState(rewardInfo.nState);
				// [Explicit Continue]
				continue;
			}
			// End:0x287
			if(rewardInfo.nType == 1)
			{
				_missionLevelInfo.stepInfo[rewardInfo.nLevel].baseRewardState = EMissionLevelRewardState(rewardInfo.nState);
				// End:0x284
				if(byte(rewardInfo.nState) == 1)
				{
					// End:0x26D
					if(firstAvailableBaseLevel < 0)
					{
						firstAvailableBaseLevel = rewardInfo.nLevel;						
					}
					else
					{
						firstAvailableBaseLevel = Min(firstAvailableBaseLevel, rewardInfo.nLevel);
					}
				}
				// [Explicit Continue]
				continue;
			}
			// End:0x30D
			if(rewardInfo.nType == 2)
			{
				_missionLevelInfo.stepInfo[rewardInfo.nLevel].keyRewardState = EMissionLevelRewardState(rewardInfo.nState);
				// End:0x30D
				if(EMissionLevelRewardState(rewardInfo.nState) == 1)
				{
					// End:0x2F6
					if(firstAvailableKeyLevel < 0)
					{
						firstAvailableKeyLevel = rewardInfo.nLevel;
						// [Explicit Continue]
						continue;
					}
					firstAvailableKeyLevel = Min(firstAvailableKeyLevel, rewardInfo.nLevel);
				}
			}
		}
		_missionLevelInfo.availableBaseRewardLevel = firstAvailableBaseLevel;
		_missionLevelInfo.availableKeyRewardLevel = firstAvailableKeyLevel;		
	}
	else
	{
		Debug("Not Found MissionLevel Client Season Info");
	}
	// End:0x385
	if(_isOpenPacket == true)
	{
		_isOpenPacket = false;
		UpdateDefaultStepPage();
	}
	parentWnd._SetMissionLevelRewardNum(packet.nTotalRewardsAvailable);
	UpdateUIControls();
}

defaultproperties
{
}
