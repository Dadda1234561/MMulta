class QuestWnd extends UICommonAPI;

const QuestWnd_MAX_COUNT = 40;
const QUEST_WINDOW_ONE = 0;
const QUEST_WINDOW_REPEAT = 1;
const QUEST_WINDOW_EPIC = 2;
const QUEST_WINDOW_JOB = 3;
const QUEST_WINDOW_SPECIAL = 4;

enum NotifType 
{
	NOTIF_ACCEPT,
	NOTIF_PROGRESS,
	NOTIF_COMPLETE
};

struct QuestUseInfo
{
	var int QuestID;
	var int Level;
	var int Completed;
	var int QuestType;
	var bool bShowCompletionItem;
	var array<int> ArrNeedItemIDList;
	var array<int> ArrNeedItemNumList;
	var array<int> arrGoalType;
	var array<int> rewardIDList;
	var array<INT64> rewardNumList;
};

var WindowHandle Me;
var TabHandle QuestTreeTab;
var TextureHandle TexTabBg;
var TextureHandle TexTabBgLine;
var TextBoxHandle txtQuestTreeTitle;
var TextBoxHandle txtQuestNum;
var array<QuestUseInfo> ArrQuest;
var QuestAlarmWnd scQuestAlarm;
var QuestDrawerWnd scTreeDrawer;
var ButtonHandle m_btnAddAlarm;
var ButtonHandle m_btnDeleteAlarm;
var L2Util util;
var int QuestID_Alarm;
var int QuestLevel_Alarm;
var int QuestEnd_Alarm;
var int m_OldQuestID;
var ListCtrlHandle ListTrackItem1;
var array<LVDataRecord> m_QuestTrackData;
var int m_TrackID;
var int m_DeleteQuestID;
var string m_DeleteNodeName;
var int m_recentlyQuestID;
var NoticeWnd NoticeWndScript;
var Vector currentQuestDirectTargetPos;
var string currentQuestDirectTargetString;
var private int overedIndex;
var private int nProceedingQuestCount;
var private int toSelectqID;
var private bool bRequest_C_EX_QUEST_UI;

static function QuestWnd Inst()
{
	return QuestWnd(GetScript("QuestWnd"));	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_QuestSetCurrentID);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_QUEST_NOTIFICATION));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_QUEST_UI));	
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	util = L2Util(GetScript("L2Util"));
	scQuestAlarm = QuestAlarmWnd(GetScript("QuestAlarmWnd"));
	scTreeDrawer = QuestDrawerWnd(GetScript("QuestDrawerWnd"));
	NoticeWndScript = NoticeWnd(GetScript("NoticeWnd"));
	m_OldQuestID = 0;
	m_recentlyQuestID = 0;
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl0").SetSelectedSelTooltip(false);
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl0").SetAppearTooltipAtMouseX(true);
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl1").SetSelectedSelTooltip(false);
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl1").SetAppearTooltipAtMouseX(true);
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl2").SetSelectedSelTooltip(false);
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl2").SetAppearTooltipAtMouseX(true);	
}

function Initialize()
{
	QuestTreeTab = GetTabHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestTreeTab");
	TexTabBg = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".TexTabBg");
	TexTabBgLine = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".TexTabBgLine");
	txtQuestTreeTitle = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestTreeTitle");
	txtQuestNum = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestNum");
	m_btnAddAlarm = GetButtonHandle("QuestDrawerWnd.btnAddAlarm");
	m_btnDeleteAlarm = GetButtonHandle("QuestDrawerWnd.btnDeleteAlarm");	
}

event OnShow()
{
	GetWindowHandle("QuestAcceptableListWnd").HideWindow();
	Me.SetFocus();
	RQ_C_EX_QUEST_UI();	
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x6F
		case "SwapBtn":
			getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "QuestAcceptableListWnd");
			GetWindowHandle("QuestAcceptableListWnd").ShowWindow();
			// End:0x72
			break;
	}	
}

event OnEvent(int Event_ID, string param)
{
	Debug("OnEvent" @ string(Event_ID));
	switch(Event_ID)
	{
		// End:0x3F
		case EV_PacketID(class'UIPacket'.const.S_EX_QUEST_NOTIFICATION):
			RT_S_EX_QUEST_NOTIFICATION();
			// End:0x78
			break;
		// End:0x5F
		case EV_PacketID(class'UIPacket'.const.S_EX_QUEST_UI):
			RT_S_EX_QUEST_UI();
			// End:0x78
			break;
		// End:0x75
		case EV_Restart:
			bRequest_C_EX_QUEST_UI = false;
			SetQuestOff();
			// End:0x78
			break;
	}
	// End:0xA1
	if(Event_ID == EV_QuestSetCurrentID)
	{
		HandleQuestSetCurrentID(param);
		Me.SetFocus();
	}	
}

private function MakeLists()
{
	local array<UIPacket._PkQuestNotif> pkQuestNotifs;

	pkQuestNotifs.Length = 10;
	pkQuestNotifs[0].nID = 10143;
	pkQuestNotifs[0].nCount = 1000;
	pkQuestNotifs[1].nID = 20007;
	pkQuestNotifs[1].nCount = 50;
	pkQuestNotifs[2].nID = 20008;
	pkQuestNotifs[2].nCount = 0;
	pkQuestNotifs[3].nID = 20009;
	pkQuestNotifs[3].nCount = 1;	
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData RowData;

	Debug("OnClickListCtrlRecord : 선택 됐습니다. " @ ListCtrlID @ string(GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ ListCtrlID).GetSelectedIndex()));
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ "." $ ListCtrlID).GetSelectedRec(RowData);
	scTreeDrawer._SetCurrentQuestInfos(int(RowData.nReserved1), int(RowData.nReserved2), int(RowData.nReserved3));	
}

event OnRollOverListCtrlRecord(string strID, int Index)
{
	overedIndex = Index;	
}

function curQuestExpand(int QuestID)
{
	m_recentlyQuestID = QuestID;	
}

function Vector getCurrentQuestDirectTargetPos()
{
	return currentQuestDirectTargetPos;	
}

private function Detele3DArrow()
{
	local int QuestID;
	local Vector vTargetPos;

	QuestID = 1;
	// End:0xB1
	if(QuestID == 0)
	{
		// End:0x3C
		if(! IsPlayerOnWorldRaidServer())
		{
			class'QuestAPI'.static.SetQuestTargetInfo(false, false, false, "", vTargetPos, QuestID, 0);
		}
		class'UIAPI_WINDOW'.static.HideWindow("QuestDrawerWnd");
		CallGFxFunction("RadarMapWnd", "hideQuestTargetInfo", "");
		CallGFxFunction("MiniMapGfxWnd", "hideQuestTargetInfo", "");
	}	
}

function findNowQuestExist(int QuestID)
{
	local int i;
	local bool isExist;

	// End:0x46 [Loop If]
	for(i = 0; i < ArrQuest.Length; i++)
	{
		// End:0x3C
		if(ArrQuest[i].QuestID == QuestID)
		{
			isExist = true;
			// [Explicit Break]
			break;
		}
	}
	// End:0x91
	if(! isExist)
	{
		// End:0x65
		if(GetReleaseMode() == RM_DEV)
		{			
		}
		else
		{
			// End:0x91
			if(class'UIAPI_WINDOW'.static.IsShowWindow("NoticeWnd"))
			{
				NoticeWndScript.hideNoticeButton_QUEST();
			}
		}
	}	
}

private function initVars()
{
	m_OldQuestID = 0;
	m_TrackID = 0;
	m_DeleteQuestID = 0;
	m_DeleteNodeName = "";
	ArrQuest.Remove(0, ArrQuest.Length);	
}

private function UpdateTargetNoneCheckPosBox(bool ShowArrow)
{
	// End:0x0C
	if(ShowArrow)
	{		
	}
	else
	{
		SetQuestOff();
	}	
}

private function SetQuestOff()
{
	UpdateQuestCount();
	CallGFxFunction("RadarMapWnd", "hideQuestTargetInfo", "");
	CallGFxFunction("MiniMapGfxWnd", "hideQuestTargetInfo", "");	
}

private function UpdateQuestCount()
{
	txtQuestNum.SetText("(" $ string(nProceedingQuestCount) $ "/" $ string(40) $ ")");	
}

function HandleQuestSetCurrentID(string param);

function _HandleQuestSetCurrentIDfromMiniMap(int QuestID, int Level, int nQuestType);

function _SetSelectQuest(int qID)
{
	local int Index;

	GetTabHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestTreeTab").SetTopOrder(GetTopIndex(qID), true);
	Index = GetQuestIndex(qID);
	// End:0x7C
	if(! m_hOwnerWnd.IsShowWindow())
	{
		toSelectqID = qID;
		m_hOwnerWnd.ShowWindow();
		return;
	}
	// End:0x9E
	if(Index == -1)
	{
		RQ_C_EX_QUEST_UI();
		toSelectqID = qID;
		return;
	}
	m_hOwnerWnd.SetFocus();
	GetRichListCtrlByID(qID).SetSelectedIndex(Index, true);
	OnClickListCtrlRecord(GetRichListCtrlByID(qID).GetWindowName());	
}

private function Handle_S_EX_QUEST_NOTIFICATION(int qID, int nCount, int cNotifType)
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x16
	if(! m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	switch(cNotifType)
	{
		// End:0x57
		case 0:
			// End:0x54
			if(MakeRowData(qID, nCount, 1, RowData))
			{
				InsertRecord(GetRichListCtrlByID(qID), RowData, 0);
			}
			// End:0x1F3
			break;
		// End:0x129
		case 1:
			i = GetQuestIndex(qID);
			// End:0x126
			if(MakeRowData(qID, nCount, 1, RowData))
			{
				GetRichListCtrlByID(qID).ModifyRecord(i, RowData);
				// End:0x126
				if(class'QuestDrawerWnd'.static.Inst()._GetCurrentQuestID() == qID)
				{
					Debug("갱신 해야 함" @ string(class'QuestDrawerWnd'.static.Inst()._GetCurrentQuestID() == qID));
					class'QuestDrawerWnd'.static.Inst()._SetCurrentQuestInfos(qID, nCount, 1);
				}
			}
			// End:0x1F3
			break;
		// End:0x1F0
		case 2:
			i = GetQuestIndex(qID);
			// End:0x183
			if(class'QuestDrawerWnd'.static.Inst().currentQuestID == qID)
			{
				GetWindowHandle("QuestDrawerWnd").HideWindow();
			}
			// End:0x1B8
			if(qID >= class'QuestDialogWnd'.const.QUEST_CATEGORY_SUB)
			{
				GetRichListCtrlByID(qID).DeleteRecord(i);				
			}
			else
			{
				// End:0x1ED
				if(MakeRowData(qID, nCount, 2, RowData))
				{
					GetRichListCtrlByID(qID).ModifyRecord(0, RowData);
				}
			}
			// End:0x1F3
			break;
	}
	UpdateQuestCount();	
}

private function bool MakeRowData(int qID, int nCount, int cState, out RichListCtrlRowData oRowData)
{
	local NQuestUIData questUIData;
	local RichListCtrlRowData RowData;
	local Color TextColor;

	// End:0x17
	if(! API_GetNQuestData(qID, questUIData))
	{
		return false;
	}
	// End:0x55
	if(cState == 2)
	{
		// End:0x53
		if(qID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SUB)
		{
			nCount = questUIData.Goal.Num;			
		}
		else
		{
			return false;
		}
	}
	RowData.cellDataList.Length = 1;
	RowData.nReserved1 = qID;
	RowData.nReserved2 = nCount;
	RowData.nReserved3 = cState;
	RowData.cellDataList[0].szData = questUIData.Name;
	// End:0x106
	if(cState == 1)
	{
		// End:0xEF
		if(questUIData.Goal.Num <= nCount)
		{
			TextColor = GetColor(255, 221, 102, 255);			
		}
		else
		{
			TextColor = GetColor(170, 153, 119, 255);
		}		
	}
	else
	{
		TextColor = GetColor(170, 153, 119, 100);
	}
	Debug("MakeRowData" @ string(cState));
	addRichListCtrlString(RowData.cellDataList[0].drawitems, questUIData.Name, TextColor);
	oRowData = RowData;
	return true;	
}

function Handle_S_EX_S_EX_QUEST_UI(array<UIPacket._PkQuestInfo> questInfos)
{
	local int i;
	local RichListCtrlRowData RowData;

	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl0").DeleteAllItem();
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl1").DeleteAllItem();
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl2").DeleteAllItem();
	
	// End:0x19D [Loop If]
	for(i = questInfos.Length; i >= 0; i--)
	{
		// End:0x193
		if(MakeRowData(questInfos[i].nID, questInfos[i].nCount, questInfos[i].cState, RowData))
		{
			// End:0x16E
			if(questInfos[i].nID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SUB)
			{
				// End:0x146
				if(questInfos[i].cState == 1)
				{
					InsertRecord(GetRichListCtrlByID(questInfos[i].nID), RowData, 0);					
				}
				else
				{
					GetRichListCtrlByID(questInfos[i].nID).InsertRecord(RowData);
				}
				// [Explicit Continue]
				continue;
			}
			GetRichListCtrlByID(questInfos[i].nID).InsertRecord(RowData);
		}
	}	
}

private function InsertRecord(RichListCtrlHandle rHandle, RichListCtrlRowData rowDataNew, int Index)
{
	local int i, lastIndex, lastSelectedIndex;
	local RichListCtrlRowData RowData;

	lastSelectedIndex = rHandle.GetSelectedIndex();
	// End:0x41
	if(rHandle.GetRecordCount() == 0)
	{
		rHandle.InsertRecord(rowDataNew);		
	}
	else
	{
		lastIndex = rHandle.GetRecordCount() - 1;
		rHandle.GetRec(lastIndex, RowData);
		rHandle.InsertRecord(RowData);

		// End:0xDF [Loop If]
		for(i = lastIndex; i > Index; i--)
		{
			rHandle.GetRec(i - 1, RowData);
			rHandle.ModifyRecord(i, RowData);
		}
		rHandle.ModifyRecord(Index, rowDataNew);
	}
	// End:0x11F
	if(lastSelectedIndex >= Index)
	{
		rHandle.SetSelectedIndex(lastSelectedIndex + 1, false);
	}	
}

private function RT_S_EX_QUEST_UI()
{
	local int Index;
	local UIPacket._S_EX_QUEST_UI packet;

	bRequest_C_EX_QUEST_UI = false;
	// End:0x23
	if(! class'UIPacket'.static.Decode_S_EX_QUEST_UI(packet))
	{
		return;
	}
	nProceedingQuestCount = packet.nProceedingQuestCount;
	UpdateQuestCount();
	Handle_S_EX_S_EX_QUEST_UI(packet.questInfos);
	// End:0x56
	if(toSelectqID < 1)
	{
		return;
	}
	Index = GetQuestIndex(toSelectqID);
	// End:0x78
	if(Index == -1)
	{
		return;
	}
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	GetRichListCtrlByID(toSelectqID).SetSelectedIndex(Index, true);
	OnClickListCtrlRecord(GetRichListCtrlByID(toSelectqID).GetWindowName());
	toSelectqID = -1;
	Debug("toSelectqID :" @ string(toSelectqID) @ string(Index));	
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

private function RQ_C_EX_QUEST_UI()
{
	local array<byte> stream;

	// End:0x0B
	if(bRequest_C_EX_QUEST_UI)
	{
		return;
	}
	bRequest_C_EX_QUEST_UI = true;
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_QUEST_UI, stream);	
}

private function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);	
}

private function int GetTopIndex(int qID)
{
	// End:0x1A
	if(qID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SUB)
	{
		return 0;
	}
	// End:0x34
	if(qID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SPECIAL)
	{
		return 1;
	}
	return 2;	
}

private function RichListCtrlHandle GetRichListCtrlByID(int qID)
{
	return GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".questListCtrl" $ string(GetTopIndex(qID)));	
}

private function int GetQuestIndex(int qID)
{
	local int i;
	local RichListCtrlRowData RowData;
	local RichListCtrlHandle rHandle;

	rHandle = GetRichListCtrlByID(qID);

	// End:0x9D [Loop If]
	for(i = 0; i < rHandle.GetRecordCount(); i++)
	{
		rHandle.GetRec(i, RowData);
		Debug("GetQuestIndex" @ string(RowData.nReserved1) @ string(qID));
		// End:0x93
		if(RowData.nReserved1 == qID)
		{
			return i;
		}
	}
	return -1;	
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).HideWindow();	
}

defaultproperties
{
}
