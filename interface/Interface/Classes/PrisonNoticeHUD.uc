class PrisonNoticeHUD extends UICommonAPI;

const TIMER_ID_REMAIN_TIME = 1;
const TIMER_DELAY_REMAIN_TIME = 10000;

struct PrisonUIInfo
{
	var bool inPrison;
	var int PrisonType;
	var PrisonUIData prisonData;
	var int serverRemainTime;
	var int uiRemainTime;
	var int currentItemCnt;
};

var PrisonUIInfo _prisonInfo;
var int _remainTimerCount;
var bool _isEnterPacket;
var WindowHandle Me;
var TextBoxHandle prisonNameTextBox;
var TextBoxHandle remainTimeTextBox;
var TextBoxHandle currentCntTextBox;
var TextBoxHandle maxCntTextBox;
var TextBoxHandle cntDivisionTextBox;
var L2UIInventoryObjectSimple inventoryObject;

static function PrisonNoticeHUD Inst()
{
	return PrisonNoticeHUD(GetScript("PrisonNoticeHUD"));	
}

function Initialize()
{
	initControls();
	inventoryObject = AddItemListenerSimple(0);
	inventoryObject.DelegateOnUpdateItem = OnNeedItemUpdated;	
}

function initControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	prisonNameTextBox = GetTextBoxHandle(ownerFullPath $ ".PrisonName");
	remainTimeTextBox = GetTextBoxHandle(ownerFullPath $ ".PrisonTimer_txt");
	currentCntTextBox = GetTextBoxHandle(ownerFullPath $ ".PrisonCounterRemain_txt");
	maxCntTextBox = GetTextBoxHandle(ownerFullPath $ ".PrisonCounterGoal_txt");
	cntDivisionTextBox = GetTextBoxHandle(ownerFullPath $ ".Slash_txt");	
}

function UpdateUIControls()
{
	UpdateInfoControls();	
}

function UpdateRemainTimeInfo()
{
	local int timerTime;

	timerTime = _remainTimerCount * 10;
	_prisonInfo.uiRemainTime = _prisonInfo.serverRemainTime - timerTime;
	// End:0x41
	if(_prisonInfo.uiRemainTime <= 0)
	{
		KillRemainTimer();
	}	
}

function UpdateInfoControls()
{
	local Color currentCntColor;

	// End:0x25
	if(_prisonInfo.inPrison == false || _prisonInfo.PrisonType == 0)
	{
		return;
	}
	prisonNameTextBox.SetText(GetSystemString(GetPrisonTitleStringId(_prisonInfo.PrisonType)));
	remainTimeTextBox.SetText(GetRemainTimeText(_prisonInfo.uiRemainTime));
	// End:0xB3
	if(_prisonInfo.prisonData.NeedItem.Id == 0)
	{
		currentCntTextBox.HideWindow();
		maxCntTextBox.HideWindow();
		cntDivisionTextBox.HideWindow();		
	}
	else
	{
		currentCntTextBox.SetText(string(_prisonInfo.currentItemCnt));
		maxCntTextBox.SetText(string(_prisonInfo.prisonData.NeedItem.Amount));
		currentCntTextBox.ShowWindow();
		maxCntTextBox.ShowWindow();
		cntDivisionTextBox.ShowWindow();
		// End:0x15D
		if(_prisonInfo.currentItemCnt >= _prisonInfo.prisonData.NeedItem.Amount)
		{
			currentCntColor = GetColor(238, 170, 34, 255);			
		}
		else
		{
			currentCntColor = GetColor(221, 221, 221, 255);
		}
		currentCntTextBox.SetTextColor(currentCntColor);
	}	
}

function ResetPrisonInfo()
{
	_prisonInfo.inPrison = false;
	_prisonInfo.PrisonType = 0;
	_prisonInfo.prisonData.PrisonType = 0;
	_prisonInfo.serverRemainTime = 0;
	_prisonInfo.uiRemainTime = 0;
	_prisonInfo.currentItemCnt = 0;	
}

function CloseAndResetInfo()
{
	KillRemainTimer();
	ResetPrisonInfo();
	CloseNoticeHUD();
	_isEnterPacket = false;
	_remainTimerCount = 0;
	class'PrisonWnd'.static.Inst().ClosePrisonWnd();	
}

function StartRemainTimer()
{
	KillRemainTimer();
	Me.SetTimer(1, 10000);	
}

function KillRemainTimer()
{
	Me.KillTimer(1);	
}

function OpenNoticeHUD()
{
	// End:0x3E
	if(_prisonInfo.inPrison == true && GetGameStateName() != "COLLECTIONSTATE")
	{
		Me.ShowWindow();
	}	
}

function CloseNoticeHUD()
{
	Me.HideWindow();	
}

function CheckAndCloseWindows()
{
	local int i;
	local array<string> toCloseWindows;

	toCloseWindows[toCloseWindows.Length] = "TeleportWnd";
	toCloseWindows[toCloseWindows.Length] = "DethroneWnd";
	toCloseWindows[toCloseWindows.Length] = "TeleportBookMarkWnd";
	toCloseWindows[toCloseWindows.Length] = "OlympiadWnd";
	toCloseWindows[toCloseWindows.Length] = "TimeZoneWnd";

	// End:0xE2 [Loop If]
	for(i = 0; i < toCloseWindows.Length; i++)
	{
		// End:0xD8
		if(class'UIAPI_WINDOW'.static.IsShowWindow(toCloseWindows[i]))
		{
			class'UIAPI_WINDOW'.static.HideWindow(toCloseWindows[i]);
		}
	}	
}

function UpdatePrisonInfo()
{
	local PrisonUIData prisonData;

	// End:0x5C
	if(_prisonInfo.PrisonType > 0)
	{
		GetPrisonData(_prisonInfo.PrisonType, prisonData);
		_prisonInfo.prisonData = prisonData;
		inventoryObject.setId(GetItemID(prisonData.NeedItem.Id));		
	}
	else
	{
		ResetPrisonInfo();
		inventoryObject.setId();
	}	
}

function UpdatePrisonNeedItemCntInfo()
{
	local int needItemId;

	needItemId = _prisonInfo.prisonData.NeedItem.Id;
	// End:0x59
	if(_prisonInfo.inPrison == true && needItemId > 0)
	{
		_prisonInfo.currentItemCnt = int(GetInventoryItemCount(GetItemID(needItemId)));		
	}
	else
	{
		_prisonInfo.currentItemCnt = 0;
	}	
}

function int GetPrisonTitleStringId(int PrisonType)
{
	switch(PrisonType)
	{
		// End:0x11
		case 1:
			return 14213;
		// End:0x1C
		case 2:
			return 14214;
		// End:0x27
		case 3:
			return 14215;
	}
	return 0;
}

function PrisonUIInfo GetInPrisonInfo()
{
	return _prisonInfo;	
}

function int GetInPrisonType()
{
	return _prisonInfo.PrisonType;	
}

function string GetRemainTimeText(int Time)
{
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	// End:0x3C
	if(Time <= 0)
	{
		return MakeFullSystemMsg(GetSystemMessage(3390), string(0));		
	}
	else if(Time < 60)
	{
		return MakeFullSystemMsg(GetSystemMessage(4360), string(1));			
	}
	else
	{
		return util.getTimeStringBySec(Time, true, true);
	}
}

function Rq_C_EX_PRISON_USER_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_PRISON_USER_INFO packet;

	// End:0x20
	if(! class'UIPacket'.static.Encode_C_EX_PRISON_USER_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PRISON_USER_INFO, stream);	
}

function Rs_S_EX_PRISON_USER_ENTER()
{
	local UIPacket._S_EX_PRISON_USER_ENTER packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PRISON_USER_ENTER(packet))
	{
		return;
	}
	_isEnterPacket = true;
	CheckAndCloseWindows();
	Rq_C_EX_PRISON_USER_INFO();	
}

function Rs_S_EX_PRISON_USER_EXIT()
{
	local UIPacket._S_EX_PRISON_USER_EXIT packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PRISON_USER_EXIT(packet))
	{
		return;
	}
	CloseAndResetInfo();	
}

function Rs_S_EX_PRISON_USER_INFO()
{
	local UIPacket._S_EX_PRISON_USER_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PRISON_USER_INFO(packet))
	{
		return;
	}
	// End:0x3B
	if(packet.cPrisonType > 0)
	{
		_prisonInfo.inPrison = true;		
	}
	else
	{
		_prisonInfo.inPrison = false;
	}
	_prisonInfo.PrisonType = packet.cPrisonType;
	_prisonInfo.currentItemCnt = packet.nItemAmount;
	_prisonInfo.serverRemainTime = packet.nRemainTime;
	_prisonInfo.uiRemainTime = packet.nRemainTime;
	UpdatePrisonInfo();
	// End:0x103
	if(_prisonInfo.inPrison == true)
	{
		_remainTimerCount = 0;
		OpenNoticeHUD();
		// End:0xD6
		if(_prisonInfo.serverRemainTime != 0)
		{
			StartRemainTimer();
		}
		// End:0x103
		if(_isEnterPacket == true)
		{
			_isEnterPacket = false;
			class'PrisonWnd'.static.Inst().OpenPrisonWnd();
		}
	}	
}

function Nt_EV_Restart()
{
	CloseAndResetInfo();	
}

function Nt_EV_StateChanged()
{
	// End:0x21
	if(GetGameStateName() == "GAMINGSTATE")
	{
		OpenNoticeHUD();		
	}
	else
	{
		CloseNoticeHUD();
		// End:0x49
		if(GetGameStateName() != "COLLECTIONSTATE")
		{
			KillRemainTimer();
		}
	}	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_PRISON_USER_ENTER));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_PRISON_USER_EXIT));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_PRISON_USER_INFO));
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_StateChanged);	
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		// End:0x15
		case EV_Restart:
			Nt_EV_Restart();
			// End:0x89
			break;
		// End:0x26
		case EV_StateChanged:
			Nt_EV_StateChanged();
			// End:0x89
			break;
		// End:0x46
		case EV_PacketID(class'UIPacket'.const.S_EX_PRISON_USER_ENTER):
			Rs_S_EX_PRISON_USER_ENTER();
			// End:0x89
			break;
		// End:0x66
		case EV_PacketID(class'UIPacket'.const.S_EX_PRISON_USER_EXIT):
			Rs_S_EX_PRISON_USER_EXIT();
			// End:0x89
			break;
		// End:0x86
		case EV_PacketID(class'UIPacket'.const.S_EX_PRISON_USER_INFO):
			Rs_S_EX_PRISON_USER_INFO();
			// End:0x89
			break;
	}	
}

event OnTimer(int TimerID)
{
	// End:0x37
	if(TimerID == 1)
	{
		_remainTimerCount++;
		UpdateRemainTimeInfo();
		UpdateInfoControls();
		class'PrisonWnd'.static.Inst().UpdatePrisonPanelControls();
	}	
}

event OnClickButton(string buttonStr)
{
	switch(buttonStr)
	{
		// End:0x22
		case "PrisonHud_btn":
			OnPrisonWndBtnClicked();
			// End:0x25
			break;
	}	
}

event OnNeedItemUpdated(optional array<ItemInfo> iInfo, optional int Index)
{
	// End:0x60
	if(_prisonInfo.inPrison == true && _prisonInfo.prisonData.NeedItem.Id > 0 && iInfo.Length > 0)
	{
		UpdatePrisonNeedItemCntInfo();
		UpdateInfoControls();
		class'PrisonWnd'.static.Inst().UpdatePrisonPanelControls();
	}	
}

event OnPrisonWndBtnClicked()
{
	class'PrisonWnd'.static.Inst().ToggleOpenPrisonWnd();	
}

event OnShow()
{
	UpdatePrisonInfo();
	UpdateUIControls();	
}

event OnLoad()
{
	Initialize();	
}

defaultproperties
{
}
