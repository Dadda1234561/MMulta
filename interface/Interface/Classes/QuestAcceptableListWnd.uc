class QuestAcceptableListWnd extends UICommonAPI;

var private RichListCtrlHandle questAcceptableList_RichList;
var private bool bRequest_S_EX_QUEST_ACCEPTABLE_LIST;

static function QuestAcceptableListWnd Inst()
{
	return QuestAcceptableListWnd(GetScript("QuestAcceptableListWnd"));	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_QUEST_ACCEPTABLE_LIST));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_QUEST_ACCEPTABLE_ALARM));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_QUEST_NOTIFICATION));	
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();	
}

function Initialize()
{
	questAcceptableList_RichList = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".questAcceptableList_RichList");
	questAcceptableList_RichList.SetSelectedSelTooltip(false);
	questAcceptableList_RichList.SetAppearTooltipAtMouseX(true);	
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		// End:0x17
		case EV_Restart:
			bRequest_S_EX_QUEST_ACCEPTABLE_LIST = false;
			// End:0x92
			break;
		// End:0x37
		case EV_PacketID(class'UIPacket'.const.S_EX_QUEST_ACCEPTABLE_LIST):
			RT_S_EX_QUEST_ACCEPTABLE_LIST();
			// End:0x92
			break;
		// End:0x6F
		case EV_PacketID(class'UIPacket'.const.S_EX_QUEST_ACCEPTABLE_ALARM):
			// End:0x66
			if(m_hOwnerWnd.IsShowWindow())
			{
				RQ_C_EX_QUEST_ACCEPTABLE_LIST();
			}
			RT_S_EX_QUEST_ACCEPTABLE_ALARM();
			// End:0x92
			break;
		// End:0x8F
		case EV_PacketID(class'UIPacket'.const.S_EX_QUEST_NOTIFICATION):
			RT_S_EX_QUEST_NOTIFICATION();
			// End:0x92
			break;
	}	
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();
	GetWindowHandle("QuestWnd").HideWindow();
	RQ_C_EX_QUEST_ACCEPTABLE_LIST();	
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x53
		case "SwapBtn":
			getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "QuestWnd");
			GetWindowHandle("QuestWnd").ShowWindow();
			// End:0x56
			break;
	}	
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	questAcceptableList_RichList.SetSelectedIndex(-1, false);	
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	class'QuestDialogWnd'.static.Inst()._ShowStartDialog(GetQuestIDAtIndex(questAcceptableList_RichList.GetSelectedIndex()));
	questAcceptableList_RichList.SetSelectedIndex(-1, false);	
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).HideWindow();	
}

private function AcceptQuest(int qID)
{
	local int Index;

	// End:0x16
	if(! m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	Index = GetQuestIndex(qID);
	// End:0x38
	if(Index == -1)
	{
		return;
	}
	questAcceptableList_RichList.DeleteRecord(Index);	
}

private function bool MakeRowData(int qID, out RichListCtrlRowData o_rowData)
{
	local string questName;
	local NQuestUIData questUIData;
	local RichListCtrlRowData RowData;

	// End:0x17
	if(! API_GetNQuestData(qID, questUIData))
	{
		return false;
	}
	RowData.cellDataList.Length = 1;
	RowData.nReserved1 = qID;
	questName = questUIData.Name;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, questName, GetColor(211, 211, 211, 255));
	o_rowData = RowData;
	return true;	
}

private function Handle_S_EX_QUEST_NOTIFICATION(int qID, int cNotifType)
{
	switch(cNotifType)
	{
		// End:0x35
		case QuestWnd(GetScript("QuestWnd")).const.QUEST_WINDOW_ONE:
			AcceptQuest(qID);
			// End:0x38
			break;
	}	
}

private function Handle_S_EX_QUEST_ACCEPTABLE_LIST(array<int> questIDs)
{
	local int i;
	local RichListCtrlRowData RowData;

	questAcceptableList_RichList.DeleteAllItem();

	// End:0x80 [Loop If]
	for(i = 0; i < questIDs.Length; i++)
	{
		// End:0x76
		if(MakeRowData(questIDs[i], RowData))
		{
			// End:0x62
			if(IsMainQuest(questIDs[i]))
			{
				InsertRecord(RowData, 0);
				// [Explicit Continue]
				continue;
			}
			questAcceptableList_RichList.InsertRecord(RowData);
		}
	}	
}

private function InsertRecord(RichListCtrlRowData rowDataNew, int Index)
{
	local int i, lastIndex;
	local RichListCtrlRowData RowData;

	// End:0x2C
	if(questAcceptableList_RichList.GetRecordCount() == 0)
	{
		questAcceptableList_RichList.InsertRecord(rowDataNew);		
	}
	else
	{
		lastIndex = questAcceptableList_RichList.GetRecordCount() - 1;
		questAcceptableList_RichList.GetRec(lastIndex, RowData);
		questAcceptableList_RichList.InsertRecord(RowData);

		// End:0xCA [Loop If]
		for(i = lastIndex; i > Index; i--)
		{
			questAcceptableList_RichList.GetRec(i - 1, RowData);
			questAcceptableList_RichList.ModifyRecord(i, RowData);
		}
		questAcceptableList_RichList.ModifyRecord(Index, rowDataNew);
	}	
}

private function RT_S_EX_QUEST_NOTIFICATION()
{
	local UIPacket._S_EX_QUEST_NOTIFICATION packet;

	// End:0x16
	if(! m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	// End:0x31
	if(! class'UIPacket'.static.Decode_S_EX_QUEST_NOTIFICATION(packet))
	{
		return;
	}
	Handle_S_EX_QUEST_NOTIFICATION(packet.nID, packet.cNotifType);	
}

private function RT_S_EX_QUEST_ACCEPTABLE_LIST()
{
	local UIPacket._S_EX_QUEST_ACCEPTABLE_LIST packet;

	bRequest_S_EX_QUEST_ACCEPTABLE_LIST = false;
	// End:0x23
	if(! class'UIPacket'.static.Decode_S_EX_QUEST_ACCEPTABLE_LIST(packet))
	{
		return;
	}
	Handle_S_EX_QUEST_ACCEPTABLE_LIST(packet.questIDs);	
}

private function RQ_C_EX_QUEST_ACCEPTABLE_LIST()
{
	local array<byte> stream;

	// End:0x0B
	if(bRequest_S_EX_QUEST_ACCEPTABLE_LIST)
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_QUEST_ACCEPTABLE_LIST, stream);	
}

private function RT_S_EX_QUEST_ACCEPTABLE_ALARM()
{
	NoticeWnd(GetScript("NoticeWnd")).ArriveShowQuest();	
}

private function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);	
}

private function bool IsMainQuest(int qID)
{
	return qID < class'QuestDialogWnd'.const.QUEST_CATEGORY_SUB;	
}

private function int GetQuestIDAtIndex(int Index)
{
	local RichListCtrlRowData RowData;

	// End:0x1F
	if(questAcceptableList_RichList.GetRecordCount() <= Index)
	{
		return -1;
	}
	questAcceptableList_RichList.GetRec(Index, RowData);
	return int(RowData.nReserved1);	
}

private function int GetQuestIndex(int qID)
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x60 [Loop If]
	for(i = 0; i < questAcceptableList_RichList.GetRecordCount(); i++)
	{
		questAcceptableList_RichList.GetRec(i, RowData);
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
