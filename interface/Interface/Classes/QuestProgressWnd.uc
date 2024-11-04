class QuestProgressWnd extends UICommonAPI;

const QUEST_REQUEST_TIMERID = 1123;
const LISTWIDTH = 250;
const WNDWIDTH = 270;
const MaxHeight = 200;
const MAXLISTCOUNT = 4;
const LIST_HEIGHT = 40;
const DIALOG_TOOLTIP_KEY0 = "\\#$Tooltip0";

enum NotifType 
{
	NOTIF_ACCEPT,
	NOTIF_PROGRESS,
	NOTIF_COMPLETE
};

var private int RecentlyAddedQuestID;
var WindowHandle Me;
var private L2UITimerObject tObject;
var private L2UITimerObject tObjectDeactiveOld;
var private int lastActiveQID;
var RichListCtrlHandle QuestAlarmList_RichList;
var private UIControlDialogAssets teleportDialog;

delegate int OnSortValueCompare(int bitA, int bitB)
{
	// End:0x15
	if(bitA > bitB)
	{
		return -1;
	}
	return 1;	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_QUEST_NOTIFICATION_ALL));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_QUEST_NOTIFICATION));	
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	tObject = class'L2UITimer'.static.Inst()._AddTimer(8000, 1);
	tObject._DelegateOnTime = DlegateOnTimeCheckNew;
	tObjectDeactiveOld = class'L2UITimer'.static.Inst()._AddTimer(4000, 1);
	tObjectDeactiveOld._DelegateOnTime = DlegateOnTimeCheckDeactiveOld;	
}

function Initialize()
{
	QuestAlarmList_RichList = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestAlarmList_RichList");
	QuestAlarmList_RichList.SetSelectedSelTooltip(false);
	QuestAlarmList_RichList.SetAppearTooltipAtMouseX(true);
	QuestAlarmList_RichList.SetUseStripeBackTexture(false);
	teleportDialog = class'UIControlDialogAssets'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset"));
	teleportDialog.NeedItemRichListCtrl.SetColumnWidth(0, MaxHeight);
	teleportDialog.m_hOwnerWnd.ClearAnchor();
	teleportDialog.Hide();	
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		// End:0x48
		case EV_Restart:
			tObject._Stop();
			tObjectDeactiveOld._Stop();
			Me.KillTimer(QUEST_REQUEST_TIMERID);
			RecentlyAddedQuestID = 0;
			// End:0x8B
			break;
		// End:0x68
		case EV_PacketID(class'UIPacket'.const.S_EX_QUEST_NOTIFICATION_ALL):
			RT_S_EX_QUEST_NOTIFICATION_ALL();
			// End:0x8B
			break;
		// End:0x88
		case EV_PacketID(class'UIPacket'.const.S_EX_QUEST_NOTIFICATION):
			RT_S_EX_QUEST_NOTIFICATION();
			// End:0x8B
			break;
	}	
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x41
		case "btnMinimize":
			class'MinimizeManager'.static.Inst()._MinimizeWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
			// End:0x44
			break;
	}	
}

event OnHide()
{
	teleportDialog.Hide();
	ReLoadOnTeleportShowHide();	
}

event OnReceivedCloseUI()
{
	// End:0x63
	if(teleportDialog.m_hOwnerWnd.IsShowWindow())
	{
		teleportDialog.Hide();
		// End:0x63
		if(class'MinimizeManager'.static.Inst()._IsMin(m_hOwnerWnd.m_WindowNameWithFullPath))
		{
			m_hOwnerWnd.HideWindow();
		}
	}	
}

event OnRClickListCtrlRecord(string ListCtrlID)
{
	local int Index;

	Index = QuestAlarmList_RichList.GetSelectedIndex();
	Debug("Rclicked" @ string(Index));
	class'QuestWnd'.static.Inst()._SetSelectQuest(GetQuestIDAtIndex(Index));
	QuestAlarmList_RichList.SetSelectedIndex(-1, false);	
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData RowData;
	local int Index;

	Index = QuestAlarmList_RichList.GetSelectedIndex();
	QuestAlarmList_RichList.GetRec(Index, RowData);
	// End:0x6C
	if(RowData.cellDataList[0].nReserved1 == 1)
	{
		class'QuestDialogWnd'.static.Inst()._ShowCompleteDialog(GetQuestIDAtIndex(Index));		
	}
	else
	{
		ChkTeleport(GetQuestIDAtIndex(Index));
	}
	QuestAlarmList_RichList.SetSelectedIndex(-1, false);	
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	QuestAlarmList_RichList.SetSelectedIndex(-1, false);	
}

event OnEnterState(name a_CurrentStateName)
{
	// End:0x3C
	if(QuestAlarmList_RichList.GetRecordCount() > 0)
	{
		class'MinimizeManager'.static.Inst()._ShowWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	}	
}

event OnCallUCFunction(string functionName, string param)
{
	Debug("OnCallfunction" @ functionName);
	switch(functionName)
	{
		// End:0x46
		case "minimizeManager":
			HandleOnMinimizeManager(param);
			// End:0x49
			break;
	}	
}

private function HandleOnMinimizeManager(string param)
{
	switch(param)
	{
		// End:0x11
		case "OnMin":
		// End:0x24
		case "OnMax":
			TeleportDialogModeOnOff();
			// End:0x27
			break;
	}	
}

private function MoveRecord(int fromIndex, int toIndex)
{
	local RichListCtrlRowData RowData;

	// End:0x11
	if(fromIndex == toIndex)
	{
		return;
	}
	QuestAlarmList_RichList.GetRec(fromIndex, RowData);
	// End:0x60
	if(fromIndex < toIndex)
	{
		InsertRecord(RowData, toIndex);
		QuestAlarmList_RichList.DeleteRecord(fromIndex);		
	}
	else
	{
		QuestAlarmList_RichList.DeleteRecord(fromIndex);
		InsertRecord(RowData, toIndex);
	}	
}

private function InsertRecord(RichListCtrlRowData rowDataNew, int Index)
{
	local int i, lastIndex;
	local RichListCtrlRowData RowData;

	// End:0x2C
	if(QuestAlarmList_RichList.GetRecordCount() == 0)
	{
		QuestAlarmList_RichList.InsertRecord(rowDataNew);		
	}
	else
	{
		lastIndex = QuestAlarmList_RichList.GetRecordCount() - 1;
		QuestAlarmList_RichList.GetRec(lastIndex, RowData);
		QuestAlarmList_RichList.InsertRecord(RowData);

		// End:0xCA [Loop If]
		for(i = lastIndex; i > Index; i--)
		{
			QuestAlarmList_RichList.GetRec(i - 1, RowData);
			QuestAlarmList_RichList.ModifyRecord(i, RowData);
		}
		QuestAlarmList_RichList.ModifyRecord(Index, rowDataNew);
	}	
}

private function bool MakeRowData(int qID, int nCount, bool IsActive, out RichListCtrlRowData o_rowData, out int isComplete)
{
	local NQuestUIData questUIData;
	local RichListCtrlRowData RowData;
	local Color typeColor;
	local int textW, textH;
	local array<string> tooltipStrings;
	local NQuestDialogUIData questDialogUIData;
	local int i;

	// End:0x17
	if(! API_GetNQuestData(qID, questUIData))
	{
		return false;
	}
	RowData.cellDataList.Length = 1;
	// End:0x47
	if(questUIData.Goal.Num <= nCount)
	{
		isComplete = 1;		
	}
	else
	{
		isComplete = 0;
	}
	RowData.nReserved1 = qID;
	RowData.nReserved2 = nCount;
	RowData.cellDataList[0].nReserved1 = isComplete;
	RowData.cellDataList[0].nReserved2 = int(IsActive);
	// End:0xC5
	if(isComplete == 1)
	{
		typeColor = GetColor(255, 221, 102, 255);		
	}
	else
	{
		// End:0xE5
		if(IsActive)
		{
			typeColor = GetColor(221, 221, 221, 255);			
		}
		else
		{
			typeColor = GetColor(120, 120, 120, 255);
		}
	}
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_NewTex.QuestWnd.AlarmListBg", 235, 40, 0, -40);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, "", GetColor(0, 0, 0, 0), true);
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, GetTypeIcon(qID), 14, 14, 2, 5);
	AddEllipsisString(RowData.cellDataList[0].drawitems, questUIData.Name, 190, GetColor(170, 153, 119, 255), false, true, 20, 0);
	// End:0x240
	if((isComplete == 0) && questUIData.TeleportID > 0)
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, "", GetColor(0, 0, 0, 0), true);
		addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.Minimap.TelIcon_16", 16, 16, 193, -15);
	}
	// End:0x302
	if(questUIData.Goal.Num > 1)
	{
		GetTextSizeDefault(string(nCount) $ "/" $ string(questUIData.Goal.Num), textW, textH);
		addRichListCtrlString(RowData.cellDataList[0].drawitems, string(nCount) $ "/" $ string(questUIData.Goal.Num), typeColor, true, 0, 0);
		AddEllipsisString(RowData.cellDataList[0].drawitems, questUIData.Goal.Name, (LISTWIDTH - LIST_HEIGHT) - textW, typeColor, false, true, 2, 0);		
	}
	else
	{
		AddEllipsisString(RowData.cellDataList[0].drawitems, questUIData.Goal.Name, LISTWIDTH - LIST_HEIGHT, typeColor, true, true, 2, 2);
	}
	// End:0x3BC
	if(teleportDialog.m_hOwnerWnd.IsShowWindow() && teleportDialog.nDialogID == qID)
	{
		RowData.sOverlayTex = "L2UI_NewTex.QuestWnd.ListBg_Teleoprt";
		RowData.OverlayTexU = 232;
		RowData.OverlayTexV = LIST_HEIGHT;		
	}
	else
	{
		RowData.sOverlayTex = "";
	}
	API_GetNQuestDialogData(qID, questDialogUIData);
	GetStrings(DIALOG_TOOLTIP_KEY0, questDialogUIData.QuestInfo, tooltipStrings);
	// End:0x462
	if(tooltipStrings.Length > 0)
	{
		RowData.szReserved = tooltipStrings[0];

		for(i = 1; i < tooltipStrings.Length; i++)
		{
			RowData.szReserved = RowData.szReserved $ "\\n" $ tooltipStrings[i];
		}
	}
	o_rowData = RowData;
	return true;	
}

private function string GetTypeIcon(int qID)
{
	// End:0x3A
	if(qID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SUB)
	{
		return "L2UI_NewTex.QuestWnd.QIcon_Main";
	}
	// End:0x73
	if(qID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SPECIAL)
	{
		return "L2UI_NewTex.QuestWnd.QIcon_Sub";
	}
	return "L2UI_NewTex.QuestWnd.QIcon_Especial";	
}

private function reSizeWindow()
{
	local int listHeight;

	listHeight = Min(160, QuestAlarmList_RichList.GetRecordCount() * LIST_HEIGHT);
	QuestAlarmList_RichList.ShowScrollBar(LIST_HEIGHT * MAXLISTCOUNT <= listHeight);
	QuestAlarmList_RichList.SetWindowSize(LISTWIDTH, listHeight);
	m_hOwnerWnd.SetWindowSize(WNDWIDTH, Min(MaxHeight, listHeight) + LIST_HEIGHT);	
}

private function Handle_S_EX_QUEST_NOTIFICATION_ALL(array<UIPacket._PkQuestNotif> pkQuestNotifs)
{
	local int i;
	local RichListCtrlRowData RowData;
	local int isComplete;

	QuestAlarmList_RichList.DeleteAllItem();

	// End:0xD2 [Loop If]
	for(i = 0; i < pkQuestNotifs.Length; i++)
	{
		// End:0xC8
		if(MakeRowData(pkQuestNotifs[i].nID, pkQuestNotifs[i].nCount, false, RowData, isComplete))
		{
			// End:0x82
			if(IsMainQuest(pkQuestNotifs[i].nID))
			{
				InsertRecord(RowData, 0);
				// [Explicit Continue]
				continue;
			}
			// End:0xB4
			if(isComplete == 1)
			{
				// End:0xA5
				if(IsMainQuestFirst())
				{
					InsertRecord(RowData, 1);					
				}
				else
				{
					InsertRecord(RowData, 0);
				}
				// [Explicit Continue]
				continue;
			}
			QuestAlarmList_RichList.InsertRecord(RowData);
		}
	}
	// End:0x12A
	if(pkQuestNotifs.Length > 0)
	{
		reSizeWindow();
		// End:0x127
		if(GetGameStateName() != "COLLECTIONSTATE")
		{
			class'MinimizeManager'.static.Inst()._ShowWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
		}		
	}
	else
	{
		class'MinimizeManager'.static.Inst()._HideWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	}	
}

private function Handle_S_EX_QUEST_NOTIFICATION(int qID, int nCount, int cNotifType)
{
	local int i, isComplete, toIndex;
	local RichListCtrlRowData RowData;

	switch(cNotifType)
	{
		// End:0x5D
		case 0:
			// End:0x5A
			if(MakeRowData(qID, nCount, false, RowData, isComplete))
			{
				// End:0x49
				if(IsMainQuest(qID))
				{
					InsertRecord(RowData, 0);					
				}
				else
				{
					InsertRecord(RowData, GetActieLastOrNewFirstRecordIndex());
				}
			}
			// End:0x1CF
			break;
		// End:0x170
		case 1:
			i = GetQuestIndex(qID);
			// End:0x16D
			if(MakeRowData(qID, nCount, true, RowData, isComplete))
			{
				QuestAlarmList_RichList.ModifyRecord(i, RowData);
				// End:0xE4
				if(isComplete == 1)
				{
					// End:0xE4
					if(teleportDialog.nDialogID == qID)
					{
						teleportDialog.Hide();
						ReLoadOnTeleportShowHide();
					}
				}
				// End:0x12A
				if(! IsMainQuest(qID))
				{
					// End:0x10E
					if(isComplete == 1)
					{
						toIndex = GetCompleteLastRecord();						
					}
					else
					{
						toIndex = GetActieLastOrNewFirstRecordIndex();
					}
					MoveRecord(i, toIndex);
				}
				// End:0x16D
				if(isComplete == 0)
				{
					// End:0x15E
					if(lastActiveQID != qID)
					{
						lastActiveQID = qID;
						tObjectDeactiveOld._Reset();
					}
					tObject._Reset();
				}
			}
			// End:0x1CF
			break;
		// End:0x1CC
		case 2:
			// End:0x1A4
			if(teleportDialog.nDialogID == qID)
			{
				teleportDialog.Hide();
				ReLoadOnTeleportShowHide();
			}
			i = GetQuestIndex(qID);
			QuestAlarmList_RichList.DeleteRecord(i);
			// End:0x1CF
			break;
	}
	// End:0x230
	if(QuestAlarmList_RichList.GetRecordCount() > 0)
	{
		reSizeWindow();
		// End:0x22D
		if(GetGameStateName() != "COLLECTIONSTATE")
		{
			class'MinimizeManager'.static.Inst()._ShowWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
		}
	}
	else
	{
		class'MinimizeManager'.static.Inst()._HideWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	}
	// End:0x280
	if(isComplete == 1)
	{
		class'QuestDialogWnd'.static.Inst()._ShowCompleteDialog(qID);
	}
	// End:0x2F4
	if(GetSomeCompleted() > -1 || cNotifType == 0)
	{
		// End:0x2F1
		if(class'MinimizeManager'.static.Inst()._IsMin(m_hOwnerWnd.m_WindowNameWithFullPath))
		{
			class'MinimizeManager'.static.Inst()._ShowAlarm(m_hOwnerWnd.m_WindowNameWithFullPath);
		}		
	}
	else
	{
		class'MinimizeManager'.static.Inst()._HideAlarm(m_hOwnerWnd.m_WindowNameWithFullPath);
	}
	// End:0x334
	if(cNotifType == 0)
	{
		ChkTeleportOnAccept(qID);
	}	
}

private function int GetSomeCompleted()
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x60 [Loop If]
	for(i = 0; i < QuestAlarmList_RichList.GetRecordCount(); i++)
	{
		QuestAlarmList_RichList.GetRec(i, RowData);
		// End:0x56
		if(RowData.cellDataList[0].nReserved1 == 1)
		{
			return i;
		}
	}
	return -1;	
}

private function ChkTeleportOnAccept(int qID)
{
	local NQuestUIData questUIData;
	local TeleportListAPI.TeleportListData targetTeleport;

	teleportDialog.nDialogID = -1;
	// End:0x2B
	if(! API_GetNQuestData(qID, questUIData))
	{
		return;
	}
	// End:0x3D
	if(questUIData.TeleportID < 1)
	{
		return;
	}
	// End:0x54
	if(! GetTeleportInfo(qID, targetTeleport))
	{
		return;
	}
	// End:0x6B
	if((API_GetCurrentZoneName()) == targetTeleport.Name)
	{
		return;
	}
	ShowTeleportDialog(qID);
	// End:0x9D
	if(teleportDialog.nDialogID == qID)
	{
		m_hOwnerWnd.ShowWindow();
	}	
}

private function ChkTeleport(int qID)
{
	local NQuestUIData questUIData;

	teleportDialog.nDialogID = -1;
	// End:0x2B
	if(! API_GetNQuestData(qID, questUIData))
	{
		return;
	}
	// End:0x3D
	if(questUIData.TeleportID < 1)
	{
		return;
	}
	ShowTeleportDialog(qID);	
}

private function ShowTeleportDialog(int qID)
{
	local string Desc, teleportName;
	local TeleportListAPI.TeleportListData targetTeleport;
	local INT64 teleportCost;

	// End:0x17
	if(! GetTeleportInfo(qID, targetTeleport))
	{
		return;
	}
	// End:0x5A
	if(targetTeleport.Level > 0)
	{
		teleportName = "(" $ targetTeleport.Name $ " Lv " $ string(targetTeleport.Level) $ ")";		
	}
	else
	{
		teleportName = "(" $ targetTeleport.Name $ ")";
	}
	Desc = GetSystemMessage(5239) $ "\\n\\n" $ teleportName;
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset.NeedItemWnd.NeedItemRichListCtrl").SetUseHorizontalScrollBar(false);
	teleportDialog.SetDialogDesc(Desc);
	teleportDialog.SetUseNeedItem(true);
	teleportDialog.StartNeedItemList(1);
	teleportCost = class'TeleportWnd'.static.Inst().GetTeleportCost(targetTeleport.Price[0].Amount, targetTeleport.UsableLevel, targetTeleport.UsableTransferDegree);
	// End:0x19B
	if(targetTeleport.Price.Length > 0)
	{
		teleportDialog.AddNeedItemClassID(targetTeleport.Price[0].Id, teleportCost);
	}
	teleportDialog.SetItemNum(1);
	teleportDialog.nDialogID = qID;
	teleportDialog.Show();
	teleportDialog.DelegateOnClickBuy = OnTeleportDialogConfirm;
	teleportDialog.DelegateOnCancel = OnTeleportDialogCancel;
	ReLoadOnTeleportShowHide();	
}

private function TeleportDialogModeOnOff()
{
	local int i;
	local array<WindowHandle> childs;

	m_hOwnerWnd.GetChildWindowList(childs);
	// End:0xCA
	if(class'MinimizeManager'.static.Inst()._IsMin(m_hOwnerWnd.m_WindowNameWithFullPath))
	{
		// End:0x92 [Loop If]
		for(i = 0; i < childs.Length; i++)
		{
			// End:0x88
			if(teleportDialog.m_hOwnerWnd != childs[i])
			{
				childs[i].HideWindow();
			}
		}
		teleportDialog.m_hOwnerWnd.MoveC(16, -158);
		m_hOwnerWnd.SetWindowSize(WNDWIDTH, 30);		
	}
	else
	{
		// End:0x11E [Loop If]
		for(i = 0; i < childs.Length; i++)
		{
			// End:0x114
			if(teleportDialog.m_hOwnerWnd != childs[i])
			{
				childs[i].ShowWindow();
			}
		}
		teleportDialog.m_hOwnerWnd.MoveC(16, -188);
		reSizeWindow();
	}	
}

private function int GetTeleportID(int qID)
{
	local NQuestUIData questUIData;

	// End:0x1B
	if(! API_GetNQuestData(qID, questUIData))
	{
		return -1;
	}
	return questUIData.TeleportID;	
}

private function bool GetTeleportInfo(int qID, out TeleportListAPI.TeleportListData o_tInfo)
{
	local TeleportListAPI.TeleportListData tInfo;
	local NQuestUIData questUIData;

	// End:0x17
	if(! API_GetNQuestData(qID, questUIData))
	{
		return false;
	}
	// End:0x29
	if(questUIData.TeleportID < 1)
	{
		return false;
	}
	tInfo = class'TeleportListAPI'.static.GetFirstTeleportListData();

	// End:0x8D [Loop If]
	while("" != tInfo.Name)
	{
		// End:0x75
		if(tInfo.Id == questUIData.TeleportID)
		{
			o_tInfo = tInfo;
			return true;
		}
		tInfo = class'TeleportListAPI'.static.GetNextTeleportListData();
	}
	return false;	
}

private function OnTeleportDialogConfirm()
{
	local UserInfo UserInfo;

	teleportDialog.Hide();
	// End:0x22
	if(GetPlayerInfo(UserInfo) == false)
	{
		return;
	}
	// End:0x4F
	if(UserInfo.nCurHP == 0)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5243));
		return;
	}
	class'TeleportListAPI'.static.RequestTeleport(GetTeleportID(teleportDialog.nDialogID));
	ReLoadOnTeleportShowHide();
	// End:0xB1
	if(class'MinimizeManager'.static.Inst()._IsMin(m_hOwnerWnd.m_WindowNameWithFullPath))
	{
		m_hOwnerWnd.HideWindow();
	}	
}

private function OnTeleportDialogCancel()
{
	teleportDialog.Hide();
	ReLoadOnTeleportShowHide();
	// End:0x4E
	if(class'MinimizeManager'.static.Inst()._IsMin(m_hOwnerWnd.m_WindowNameWithFullPath))
	{
		m_hOwnerWnd.HideWindow();
	}	
}

private function ReLoadOnTeleportShowHide()
{
	local int Index, isCompleted;
	local RichListCtrlRowData RowData;

	Index = GetQuestIndex(teleportDialog.nDialogID);
	QuestAlarmList_RichList.GetRec(Index, RowData);
	// End:0x8B
	if(MakeRowData(int(RowData.nReserved1), int(RowData.nReserved2), RowData.cellDataList[0].nReserved2 == 1, RowData, isCompleted))
	{
		QuestAlarmList_RichList.ModifyRecord(Index, RowData);
	}	
}

private function DlegateOnTimeCheckDeactiveOld(int Cnt)
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0xC8 [Loop If]
	for(i = 0; i < QuestAlarmList_RichList.GetRecordCount(); i++)
	{
		QuestAlarmList_RichList.GetRec(i, RowData);
		// End:0x53
		if(RowData.nReserved1 == lastActiveQID)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x6D
		if(RowData.cellDataList[0].nReserved2 != 1)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0xBE
		if(MakeRowData(int(RowData.nReserved1), int(RowData.nReserved2), false, RowData, RowData.cellDataList[0].nReserved1))
		{
			QuestAlarmList_RichList.ModifyRecord(i, RowData);
		}
	}	
}

private function DlegateOnTimeCheckNew(int Cnt)
{
	local int Index, isComplete;
	local RichListCtrlRowData RowData;

	Index = GetQuestIndex(lastActiveQID);
	QuestAlarmList_RichList.GetRec(Index, RowData);
	// End:0x6F
	if(MakeRowData(int(RowData.nReserved1), int(RowData.nReserved2), false, RowData, isComplete))
	{
		QuestAlarmList_RichList.ModifyRecord(Index, RowData);
	}
	lastActiveQID = -1;	
}

function externalDelayTimerRequestAddExpandQuest(int nRecentlyAddedQuestID)
{
	RecentlyAddedQuestID = nRecentlyAddedQuestID;
	// End:0x43
	if(RecentlyAddedQuestID > 0)
	{
		Me.KillTimer(QUEST_REQUEST_TIMERID);
		Me.SetTimer(QUEST_REQUEST_TIMERID, 1000);
	}	
}

private function RT_S_EX_QUEST_NOTIFICATION()
{
	local UIPacket._S_EX_QUEST_NOTIFICATION packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_QUEST_NOTIFICATION(packet))
	{
		return;
	}
	Handle_S_EX_QUEST_NOTIFICATION(packet.nID, packet.nCount, packet.cNotifType);	
}

private function RT_S_EX_QUEST_NOTIFICATION_ALL()
{
	local UIPacket._S_EX_QUEST_NOTIFICATION_ALL packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_QUEST_NOTIFICATION_ALL(packet))
	{
		return;
	}
	Handle_S_EX_QUEST_NOTIFICATION_ALL(packet.questNotifs);	
}

private function RQ_C_EX_QUEST_NOTIFICATION_ALL()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_QUEST_NOTIFICATION_ALL, stream);	
}

private function string API_GetCurrentZoneName()
{
	return GetCurrentZoneName();	
}

private function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);	
}

private function bool API_GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data)
{
	return GetNQuestDialogData(a_QuestID, o_data);	
}

private function GetStrings(string keyString, string wordString, out array<string> strings)
{
	local int startIndex, endIndex, keylen;

	startIndex = InStr(wordString, keyString $ "S");
	if(startIndex == -1)
	{
		return;
	}
	endIndex = InStr(wordString, keyString $ "E");
	keylen = Len(keyString) + 1;
	strings[strings.Length] = Mid(wordString, startIndex + keylen, endIndex - (startIndex + keylen));
	GetStrings(keyString, Right(wordString, Len(wordString) - (endIndex + keylen)), strings);	
}

private function bool IsMainQuestFirst()
{
	// End:0x17
	if(QuestAlarmList_RichList.GetRecordCount() == 0)
	{
		return false;
	}
	return IsMainQuest(GetQuestIDAtIndex(0));	
}

private function bool IsMainQuest(int qID)
{
	return qID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SUB;	
}

private function int GetCompleteLastRecord()
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x13
	if(IsMainQuestFirst())
	{
		i = 1;		
	}
	else
	{
		i = 0;
	}

	// End:0x81 [Loop If]
	for(i = i; i < QuestAlarmList_RichList.GetRecordCount(); i++)
	{
		QuestAlarmList_RichList.GetRec(i, RowData);
		// End:0x71
		if(RowData.cellDataList[0].nReserved1 == 1)
		{
			// [Explicit Continue]
			continue;
		}
		return i;
	}
	return i;	
}

private function int GetActieLastOrNewFirstRecordIndex()
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x68 [Loop If]
	for(i = GetCompleteLastRecord(); i < QuestAlarmList_RichList.GetRecordCount(); i++)
	{
		QuestAlarmList_RichList.GetRec(i, RowData);
		// End:0x58
		if(RowData.cellDataList[0].nReserved2 == 1)
		{
			// [Explicit Continue]
			continue;
		}
		return i;
	}
	return i;	
}

private function int GetQuestIDAtIndex(int Index)
{
	local RichListCtrlRowData RowData;

	// End:0x1F
	if(QuestAlarmList_RichList.GetRecordCount() <= Index)
	{
		return -1;
	}
	QuestAlarmList_RichList.GetRec(Index, RowData);
	return int(RowData.nReserved1);	
}

private function int GetQuestIndex(int qID)
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x60 [Loop If]
	for(i = 0; i < QuestAlarmList_RichList.GetRecordCount(); i++)
	{
		QuestAlarmList_RichList.GetRec(i, RowData);
		// End:0x56
		if(RowData.nReserved1 == qID)
		{
			return i;
		}
	}
	return -1;	
}

defaultproperties
{
}
