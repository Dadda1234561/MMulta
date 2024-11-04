class RestartMenuWndOption extends UICommonAPI;

struct RetartPointInfoStruct
{
	var RestartPoint restartPointLock;
	var int ClassID;
	var bool bLocked;
};

var array<RetartPointInfoStruct> restartPointLocks;
var bool bExpDown;
var private RetartPointInfoStruct requestedLock;
var private bool bRequeksted;
var private RestartMenuWnd restartMenuWndscr;
var L2UITimerObject tObject;

event OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_USER_RESTART_LOCKER_UPDATE));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_USER_RESTART_LOCKER_LIST));
}

event OnLoad()
{
	SetTitles();
	InitTimer();
	restartMenuWndscr = RestartMenuWnd(GetScript("RestartMenuWnd"));
	restartPointLocks.Length = 8;
	restartPointLocks[0].restartPointLock = RESTART_TIME_FIELD_START_POS;
	restartPointLocks[0].ClassID = -1;
	restartPointLocks[1].restartPointLock = RESTART_VILLAGE;
	restartPointLocks[1].ClassID = -1;
	restartPointLocks[2].restartPointLock = RESTART_VILLAGE_USING_ITEM;
	restartPointLocks[2].ClassID = class'RestartMenuWnd'.const.RESTARTPOINTITEM_LCOIN;
	restartPointLocks[3].restartPointLock = RESTART_CASTLE;
	restartPointLocks[3].ClassID = -1;
	restartPointLocks[4].restartPointLock = RESTART_FORTRESS;
	restartPointLocks[4].ClassID = -1;
	restartPointLocks[5].restartPointLock = RESTART_BATTLE_CAMP;
	restartPointLocks[5].ClassID = -1;
	restartPointLocks[6].restartPointLock = RESTART_NEARBY_BATTLE_FIELD;
	restartPointLocks[6].ClassID = -1;
	HideAllLocks();
}

event OnEvent(int Event_ID, string param)
{
	// End:0x0D
	if(! IsAdenServer())
	{
		return;
	}
	switch(Event_ID)
	{
		// End:0x22
		case EV_Restart:
			HideAllLocks();
			// End:0x65
			break;
		// End:0x42
		case EV_PacketID(class'UIPacket'.const.S_EX_USER_RESTART_LOCKER_LIST):
			RT_S_EX_USER_RESTART_LOCKER_LIST();
			// End:0x65
			break;
		// End:0x62
		case EV_PacketID(class'UIPacket'.const.S_EX_USER_RESTART_LOCKER_UPDATE):
			RT_S_EX_USER_RESTART_LOCKER_UPDATE();
			// End:0x65
			break;
	}
}

event OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local array<string> btnNames;
	local RestartPoint pnt;
	local int Index, ClassID;

	Split(a_ButtonHandle.GetParentWindowName(), "_", btnNames);
	// End:0x9E
	if(btnNames[1] == "Wnd")
	{
		pnt = GetRestartPoint(btnNames[0]);
		ClassID = GetClassID(btnNames[0]);
		Index = GetIndex(pnt, ClassID);
		// End:0x7B
		if(Index == -1)
		{
			return;
		}
		RQ_C_EX_USER_RESTART_LOCKER_UPDATE(pnt, ClassID, ! restartPointLocks[Index].bLocked);
	}
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x15
		case "Close_Btn":
		// End:0x37
		case "CloseButton":
			m_hOwnerWnd.HideWindow();
			// End:0x3A
			break;
	}
}

function HideAllLocks()
{
	local int i;

	// End:0x48 [Loop If]
	for(i = 0; i < restartPointLocks.Length; i++)
	{
		SetEhcekRestartLock(restartPointLocks[i].restartPointLock, restartPointLocks[i].ClassID, false);
	}
	GetTextureHandle("RestartMenuWnd.FeeVillage_lock").HideWindow();
}

function SetEhcekRestartLock(RestartPoint pnt, int ClassID, bool bLocked)
{
	local int Index;
	local string restartWndName;

	Index = GetIndex(pnt, ClassID);
	restartPointLocks[Index].restartPointLock = pnt;
	restartPointLocks[Index].ClassID = ClassID;
	restartPointLocks[Index].bLocked = bLocked;
	restartWndName = GetRestartWindowName(pnt, ClassID);
	// End:0x16A
	if(bLocked)
	{
		// End:0xE8
		if(GetButtonHandle("RestartMenuWnd." $ GetRestartName(pnt, ClassID)).IsShowWindow())
		{
			// End:0xE8
			if(pnt != RESTART_VILLAGE && pnt != RESTART_TIME_FIELD_START_POS || bExpDown)
			{
				restartMenuWndscr.GetLockTexture(Index).ShowWindow();
			}
		}
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ restartWndName $ ".checked").ShowWindow();
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ restartWndName $ ".btnTitle_txt").SetTextColor(GetColor(122, 105, 101, 255));		
	}
	else
	{
		restartMenuWndscr.GetLockTexture(Index).HideWindow();
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ restartWndName $ ".checked").HideWindow();
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ restartWndName $ ".btnTitle_txt").SetTextColor(GetColor(230, 220, 190, 255));
	}
}

function RT_S_EX_USER_RESTART_LOCKER_LIST()
{
	local UIPacket._S_EX_USER_RESTART_LOCKER_LIST packet;
	local int i;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_USER_RESTART_LOCKER_LIST(packet))
	{
		return;
	}
	bExpDown = packet.bExpDown == 1;

	// End:0xA3 [Loop If]
	for(i = 0; i < packet._lockers.Length; i++)
	{
		SetEhcekRestartLock(RestartPoint(packet._lockers[i].nRestartPoint), packet._lockers[i].nClassID, packet._lockers[i].bLocked == 1);
	}
	// End:0xD0
	if(! bExpDown)
	{
		restartMenuWndscr.GetLockTexture(GetIndex(RESTART_VILLAGE, 0)).HideWindow();
		restartMenuWndscr.GetLockTexture(GetIndex(RESTART_TIME_FIELD_START_POS, 0)).HideWindow();
	}
}

function RT_S_EX_USER_RESTART_LOCKER_UPDATE()
{
	local UIPacket._S_EX_USER_RESTART_LOCKER_UPDATE packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_USER_RESTART_LOCKER_UPDATE(packet))
	{
		return;
	}
	tObject._Stop();
	bRequeksted = false;
	// End:0x46
	if(packet.bSuccess == 0)
	{
		return;
	}
	SetEhcekRestartLock(requestedLock.restartPointLock, requestedLock.ClassID, requestedLock.bLocked);
}

function RQ_C_EX_USER_RESTART_LOCKER_UPDATE(RestartPoint pnt, int ClassID, bool bLock)
{
	local array<byte> stream;
	local UIPacket._C_EX_USER_RESTART_LOCKER_UPDATE packet;

	// End:0x0B
	if(bRequeksted)
	{
		return;
	}
	requestedLock.restartPointLock = pnt;
	requestedLock.ClassID = ClassID;
	requestedLock.bLocked = bLock;
	packet.nRestartPoint = pnt;
	packet.nClassID = ClassID;
	// End:0x78
	if(bLock)
	{
		packet.bLocked = 1;		
	}
	else
	{
		packet.bLocked = 0;
	}
	tObject._Reset();
	// End:0xB4
	if(! class'UIPacket'.static.Encode_C_EX_USER_RESTART_LOCKER_UPDATE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_USER_RESTART_LOCKER_UPDATE, stream);
}

function SetTitles()
{
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ GetRestartWindowName(RESTART_TIME_FIELD_START_POS) $ ".btnTitle_txt").SetText(GetSystemString(14132));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ GetRestartWindowName(RESTART_VILLAGE) $ ".btnTitle_txt").SetText(GetSystemString(372));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ GetRestartWindowName(RESTART_VILLAGE_USING_ITEM, class'RestartMenuWnd'.const.RESTARTPOINTITEM_LCOIN) $ ".btnTitle_txt").SetText(GetSystemString(13716));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ GetRestartWindowName(RESTART_CASTLE) $ ".btnTitle_txt").SetText(GetSystemString(375));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ GetRestartWindowName(RESTART_FORTRESS) $ ".btnTitle_txt").SetText(GetSystemString(1535));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ GetRestartWindowName(RESTART_BATTLE_CAMP) $ ".btnTitle_txt").SetText(GetSystemString(373));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ GetRestartWindowName(RESTART_NEARBY_BATTLE_FIELD) $ ".btnTitle_txt").SetText(GetSystemString(13076));
}

function InitTimer()
{
	tObject = class'L2UITimer'.static.Inst()._AddNewTimerObject(5000);
	tObject._DelegateOnEnd = DelegateRefreshTImer;
	tObject._DelegateOnStart = DelegateOnStartTImer;
}

function DelegateRefreshTImer()
{
	bRequeksted = false;
}

function DelegateOnStartTImer()
{
	bRequeksted = true;
}

function bool GetLockedByName(string restartname)
{
	local int lockIndex;

	lockIndex = GetIndexByName(restartname);
	// End:0x22
	if(lockIndex == -1)
	{
		return false;
	}
	return restartPointLocks[lockIndex].bLocked;
}

function int GetIndexByName(string restartname)
{
	return GetIndex(GetRestartPoint(restartname), GetClassID(restartname));
}

function int GetIndex(RestartPoint pnt, int ClassID)
{
	local int i;

	// End:0x5F [Loop If]
	for(i = 0; i < restartPointLocks.Length; i++)
	{
		// End:0x55
		if(restartPointLocks[i].restartPointLock == pnt)
		{
			// End:0x55
			if(restartPointLocks[i].ClassID == ClassID)
			{
				return i;
			}
		}
	}
	return -1;
}

function string GetRestartWindowName(RestartPoint RestartPoint, optional int ClassID)
{
	return GetRestartName(RestartPoint, ClassID) $ "_wnd";
}

function int GetClassID(string restartname)
{
	switch(restartname)
	{
		// End:0x2A
		case "payLcoinVillage":
			return class'RestartMenuWnd'.const.RESTARTPOINTITEM_LCOIN;
		default:
			return -1;
	}
}

function RestartPoint GetRestartPoint(string restartname)
{
	switch(restartname)
	{
		// End:0x1A
		case "btnTimeZone":
			return RESTART_TIME_FIELD_START_POS;
		// End:0x19
		case "btnVillage":
			return RESTART_VILLAGE;
		// End:0x35
		case "btnNearbyBattleField":
			return RESTART_NEARBY_BATTLE_FIELD;
		// End:0x46
		case "btnCastle":
			return RESTART_CASTLE;
		// End:0x5B
		case "btnBattleCamp":
			return RESTART_BATTLE_CAMP;
		// End:0x6E
		case "btnFortress":
			return RESTART_FORTRESS;
		// End:0x85
		case "payLcoinVillage":
			return RESTART_VILLAGE_USING_ITEM;
		default:
			return RESTART_DUMMY_10;
	}
}

function string GetRestartName(RestartPoint RestartPoint, optional int ClassID)
{
	switch(RestartPoint)
	{
		case RESTART_TIME_FIELD_START_POS/*25*/:
			return "btnTimeZone";
		// End:0x19
		case RESTART_VILLAGE:
			return "btnVillage";
		// End:0x35
		case RESTART_NEARBY_BATTLE_FIELD:
			return "btnNearbyBattleField";
		// End:0x46
		case RESTART_CASTLE:
			return "btnCastle";
		// End:0x5B
		case RESTART_BATTLE_CAMP:
			return "btnBattleCamp";
		// End:0x6E
		case RESTART_FORTRESS:
			return "btnFortress";
		// End:0xD9
		case RESTART_VILLAGE_USING_ITEM:
			return "payLcoinVillage";
	}
	return "";
}

defaultproperties
{
}
