class DethroneTab04_Mission extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var TextureHandle ServerRichListFrame;
var RichListCtrlHandle Tab_RichList;
var TextureHandle ListBg_tex;
var ButtonHandle Refresh_btn;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_DAILY_MISSION_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_DETHRONE_DAILY_MISSION_GET_REWARD);
}

function OnLoad()
{
	Initialize();
	Load();
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	ServerRichListFrame = GetTextureHandle(m_WindowName $ ".ServerRichListFrame");
	Tab_RichList = GetRichListCtrlHandle(m_WindowName $ ".Tab_RichList");
	ListBg_tex = GetTextureHandle(m_WindowName $ ".ListBg_tex");
	Refresh_btn = GetButtonHandle(m_WindowName $ ".Refresh_btn");
	DisableWndList = GetWindowHandle(m_WindowName $ ".DisableWndList");
	List_Empty = GetTextBoxHandle(m_WindowName $ ".DisableWndList.List_Empty");
	Tab_RichList.SetSelectedSelTooltip(false);
	Tab_RichList.SetAppearTooltipAtMouseX(true);
}

event OnShow()
{
	Debug("Onshow " @ m_WindowName);
	// End:0x3C
	if(GetWindowHandle("DethroneWnd").IsShowWindow())
	{
		API_C_EX_DETHRONE_DAILY_MISSION_INFO();
	}
}

function Load()
{}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x20
		case "Refresh_btn":
			OnRefresh_btnClick();
			// End:0x3A
			break;
		// End:0x37
		case "rewardBtn":
			onRewardBtnClick();
			// End:0x3A
			break;
	}
}

function onRewardBtnClick()
{
	local RichListCtrlRowData RowData;

	Debug("rewardBtn --> " @ string(Tab_RichList.GetSelectedIndex()));
	Tab_RichList.GetRec(Tab_RichList.GetSelectedIndex(), RowData);
	Debug("RowData.cellDataList[2].szData" @ RowData.cellDataList[2].szData @ string(RowData.nReserved1));
	// End:0xC9
	if(RowData.cellDataList[2].szData == "True")
	{
		API_C_EX_DETHRONE_DAILY_MISSION_GET_REWARD(int(RowData.nReserved1));
		OnRefresh_btnClick();
	}
}

function OnRefresh_btnClick()
{
	API_C_EX_DETHRONE_DAILY_MISSION_INFO();
	DethroneWnd(GetScript("DethroneWnd")).setDisableWnd();
}

function AddDethronePointStateListItem(int nMissionID, string MissionName, int Progress, int progressTotal, bool bReward)
{
	local RichListCtrlRowData RowData;
	local float statusPercent;

	RowData.cellDataList.Length = 3;
	addRichListCtrlString(RowData.cellDataList[0].drawitems, MissionName, GTColor().White, false, 0, 0);
	statusPercent = (Progress / progressTotal) * 100;
	// End:0xAC
	if(statusPercent >= 100)
	{
		AddRichListCtrlStatusInfo(RowData.cellDataList[1].drawitems, 200, 15, 15, 6, true, statusPercent, 0.0f, (string(Progress) $ " / ") $ string(progressTotal), 3);		
	}
	else
	{
		AddRichListCtrlStatusInfo(RowData.cellDataList[1].drawitems, 200, 15, 15, 6, true, statusPercent, 0.0f, (string(Progress) $ " / ") $ string(progressTotal), 2);
	}
	// End:0x203
	if(bReward)
	{
		addRichListCtrlButton(RowData.cellDataList[2].drawitems, "rewardBtn", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_AdditionalReward", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_AdditionalReward", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_AdditionalReward", 34, 38, 34, 38);		
	}
	else
	{
		addRichListCtrlButton(RowData.cellDataList[2].drawitems, "rewardBtn", 0, 0, "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", 34, 38, 34, 38);
	}
	RowData.cellDataList[2].drawitems[RowData.cellDataList[2].drawitems.Length - 1].TooltipDesc = GetSystemString(7529);
	RowData.cellDataList[0].szData = MissionName;
	RowData.cellDataList[1].szData = string(Progress);
	RowData.cellDataList[2].szData = string(bReward);
	RowData.nReserved1 = nMissionID;
	Tab_RichList.InsertRecord(RowData);
}

function ModifyDethronePointStateListItem(int indexRecord, bool bReward)
{
	local RichListCtrlRowData RowData;

	Tab_RichList.GetRec(indexRecord, RowData);
	RowData.cellDataList[2].drawitems.Length = 0;
	addRichListCtrlButton(RowData.cellDataList[2].drawitems, "rewardBtn", 0, 0, "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", "L2UI_EPIC.DethroneWnd.List_Icon_RewardDisable", 34, 38, 34, 38);
	RowData.cellDataList[2].szData = string(bReward);
	Tab_RichList.ModifyRecord(indexRecord, RowData);
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_DAILY_MISSION_INFO):
			ParsePacket_S_EX_DETHRONE_DAILY_MISSION_INFO();
			// End:0x4A
			break;
		// End:0x47
		case EV_PacketID(class'UIPacket'.const.S_EX_DETHRONE_DAILY_MISSION_GET_REWARD):
			ParsePacket_S_EX_DETHRONE_DAILY_MISSION_GET_REWARD();
			// End:0x4A
			break;
	}
}

function ParsePacket_S_EX_DETHRONE_DAILY_MISSION_GET_REWARD()
{
	local UIPacket._S_EX_DETHRONE_DAILY_MISSION_GET_REWARD packet;
	local int Index;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_DAILY_MISSION_GET_REWARD(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_DAILY_MISSION_GET_REWARD :  " @ string(packet.bSuccess) @ string(packet.nID) @ string(packet.nPersonalDethronePoint) @ string(packet.nServerDethronePoint));
	// End:0x10C
	if(packet.bSuccess > 0)
	{
		AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13428), string(packet.nPersonalDethronePoint), string(packet.nServerDethronePoint)));
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13428), string(packet.nPersonalDethronePoint), string(packet.nServerDethronePoint)));
	}
	Index = getListIndexByMissionID(packet.nID);
	// End:0x13D
	if(Index > -1)
	{
		ModifyDethronePointStateListItem(Index, false);
	}
	deleteNoticeCheck();
}

function deleteNoticeCheck()
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x62 [Loop If]
	for(i = 0; i < Tab_RichList.GetRecordCount(); i++)
	{
		Tab_RichList.GetRec(i, RowData);
		// End:0x58
		if(RowData.cellDataList[2].szData == "True")
		{
			return;
		}
	}
	NoticeWnd(GetScript("NoticeWnd")).removeNoticeDethroneMissionNotice();
}

function int getListIndexByMissionID(int nMissionID)
{
	local int i;
	local RichListCtrlRowData RowData;

	// End:0x60 [Loop If]
	for(i = 0; i < Tab_RichList.GetRecordCount(); i++)
	{
		Tab_RichList.GetRec(i, RowData);
		// End:0x56
		if(nMissionID == RowData.nReserved1)
		{
			return i;
		}
	}
	return -1;
}

function ParsePacket_S_EX_DETHRONE_DAILY_MISSION_INFO()
{
	local int i;
	local UIPacket._S_EX_DETHRONE_DAILY_MISSION_INFO packet;
	local DethroneDailyMissionData missionData;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DETHRONE_DAILY_MISSION_INFO(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_DETHRONE_DAILY_MISSION_INFO :  len->" @ string(packet.missionInfoList.Length));
	Tab_RichList.DeleteAllItem();

	// End:0x13F [Loop If]
	for(i = 0; i < packet.missionInfoList.Length; i++)
	{
		Debug("" @ string(packet.missionInfoList[i].nID));
		GetDethroneDailyMissionData(packet.missionInfoList[i].nID, missionData);
		AddDethronePointStateListItem(packet.missionInfoList[i].nID, missionData.Name, packet.missionInfoList[i].nCount, missionData.GoalCount, numToBool(packet.missionInfoList[i].bHasReward));
	}
	Tab_RichList.SetFocus();
	deleteNoticeCheck();
}

function API_C_EX_DETHRONE_DAILY_MISSION_INFO()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_DAILY_MISSION_INFO, stream);
	Debug("----> Api Call : C_EX_DETHRONE_DAILY_MISSION_INFO ");
}

function API_C_EX_DETHRONE_DAILY_MISSION_GET_REWARD(int nMissionID)
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_DAILY_MISSION_GET_REWARD packet;

	packet.nID = nMissionID;
	// End:0x30
	if(! class'UIPacket'.static.Encode_C_EX_DETHRONE_DAILY_MISSION_GET_REWARD(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_DETHRONE_DAILY_MISSION_GET_REWARD, stream);
	Debug("----> Api Call : C_EX_DETHRONE_DAILY_MISSION_GET_REWARD " @ string(nMissionID));
}

defaultproperties
{
}
