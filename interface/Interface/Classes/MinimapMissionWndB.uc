//================================================================================
// MinimapMissionWndB.
//================================================================================

class MinimapMissionWndB extends UICommonAPI;

enum ERAID_BOSS_SPAWN_INFO
{
	ERBSI_DEAD,
	ERBSI_READY,
	ERBSI_BATTLE,
	ERBSI_MAX
};
struct QuestRecommandData
{
	var int categoryId;
	var int Priority;
	var int QuestID;
};

struct QuestCategoryArrayData
{
	var int categoryId;
	var array<QuestRecommandData> questRecommandData_Array;
};


struct MapListInfo
{
	var string sortingKey;
	var int Index;
};

const QuestStatus_Done = 2;
const QuestStatus_Doing = 1;
const QuestStatus_None = 0;

var WindowHandle Me;
var TextBoxHandle TxtMission_Title;
var WindowHandle MissionTab;
var ButtonHandle BTN_Huntingzone;
var ButtonHandle BTN_Inzone;
var ButtonHandle BTN_Raid;
var ListCtrlHandle Mission_ListCtrl;
var WindowHandle LocalInfoTab;
var ListCtrlHandle LocalInfo_ListCtrl;
var TabHandle TabCtrl;
var MinimapWnd miniMapWndScript;
var ListCtrlHandle QuestInfo_ListCtrl;
var ButtonHandle BTN_AllQuest;
var TextureHandle QuestTooltip;
var bool bShowHuntingZone;
var bool bShowInzone;
var bool bShowRaid;
var LVDataRecord lastSelectListRecord;
var int nClassID;
var string m_WindowName;

function OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_InzoneWaitingInfo);
	RegisterEvent(EV_RaidBossSpawnInfo);
}

function OnLoad()
{
	Initialize();
	Load();
	SetClosingOnESC();
}

function Initialize()
{
	Me = GetWindowHandle(m_WindowName);
	TxtMission_Title = GetTextBoxHandle(m_WindowName $ ".TxtMission_Title");
	MissionTab = GetWindowHandle(m_WindowName $ ".MissionTab");
	BTN_Huntingzone = GetButtonHandle(m_WindowName $ ".MissionTab.BTN_Huntingzone");
	BTN_Inzone = GetButtonHandle(m_WindowName $ ".MissionTab.BTN_Inzone");
	BTN_Raid = GetButtonHandle(m_WindowName $ ".MissionTab.BTN_Raid");
	Mission_ListCtrl = GetListCtrlHandle(m_WindowName $ ".MissionTab.Mission_ListCtrl");
	LocalInfoTab = GetWindowHandle(m_WindowName $ ".LocalInfoTab");
	LocalInfo_ListCtrl = GetListCtrlHandle(m_WindowName $ ".LocalInfoTab.LocalInfo_ListCtrl");
	TabCtrl = GetTabHandle(m_WindowName $ ".TabCtrl");
	QuestInfo_ListCtrl = GetListCtrlHandle(m_WindowName $ ".QuestInfoTab.QuestInfo_ListCtrl");
	BTN_AllQuest = GetButtonHandle(m_WindowName $ ".QuestInfoTab.BTN_AllQuest");
	QuestTooltip = GetTextureHandle(m_WindowName $ ".QuestInfoTab.QuestTooltip");
	miniMapWndScript = MinimapWnd(GetScript("MinimapWnd"));
}

function OnShow()
{
	updateOptionSave();
	refresh();
	Me.SetFocus();
}

function OnHide()
{
	getInstanceL2Util().HideGFxMiniMapSelectedPin(getInstanceL2Util().MapPinType.PIN_YELLOW);
}

function Load()
{
	Init();
	QuestInfo_ListCtrl.SetSelectedSelTooltip(False);
	QuestInfo_ListCtrl.SetAppearTooltipAtMouseX(True);
	InitQuestTooltip();
}

function Init()
{
	bShowRaid = True;
	bShowInzone = True;
	bShowHuntingZone = True;
	LocalInfo_ListCtrl.DeleteAllItem();
	Mission_ListCtrl.DeleteAllItem();
}

function OnClickButton(string Name)
{
	switch (Name)
	{
		case "BTN_Raid":
		case "BTN_Inzone":
		case "BTN_Huntingzone":
			toggleButtonClick(Name);
			break;
		case "BTN_AllQuest":
			if (GetWindowHandle("QuestListWnd").IsShowWindow())
			{
				GetWindowHandle("QuestListWnd").HideWindow();
			}
			else
			{
				ShowQuestInfoWindow();
			}
			break;
		case "minCloseButton":
			Me.HideWindow();
			break;
	}
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch (ListCtrlID)
	{
		case "Mission_ListCtrl":
			HandleDBClickedRaid();
			break;
	}
}

function HandleDBClickedRaid()
{
	local LVDataRecord Record;
	local int NpcID;

	Mission_ListCtrl.GetSelectedRec(Record);
	ParseInt(Record.LVDataList[0].szReserved, "npcID", NpcID);
	if (NpcID > 0)
	{
		CallGFxFunction("MiniMapGFxWnd", "ShowRaidTeleportDialog", string(NpcID));
	}
}

function toggleButtonClick(string buttonName)
{
	switch (buttonName)
	{
		case "BTN_Raid":
			bShowRaid = !bShowRaid;
			SetINIBool("MinimapMissionWnd", "a", bShowRaid, "WindowsInfo.ini");
			break;
		case "BTN_Inzone":
			bShowInzone = !bShowInzone;
			SetINIBool("MinimapMissionWnd", "e", bShowInzone, "WindowsInfo.ini");
			break;
		case "BTN_Huntingzone":
			bShowHuntingZone = !bShowHuntingZone;
			SetINIBool("MinimapMissionWnd", "p", bShowHuntingZone, "WindowsInfo.ini");
			break;
		default:
	}
	CallGFxFunction("MiniMapGFxWnd", "showHideCommend", "");
	Debug("ї­¶§-№цЖ°");
	refresh();
}

function updateOptionSave()
{
	local int nHunt;
	local int nInzone;
	local int nRaid;
	local int nFirstRun;

	GetINIBool("MinimapMissionWnd", "l", nFirstRun, "WindowsInfo.ini");
	GetINIBool("MinimapMissionWnd", "a", nRaid, "WindowsInfo.ini");
	GetINIBool("MinimapMissionWnd", "e", nInzone, "WindowsInfo.ini");
	GetINIBool("MinimapMissionWnd", "p", nHunt, "WindowsInfo.ini");
	if (nFirstRun == 0)
	{
		bShowRaid = True;
		bShowInzone = True;
		bShowHuntingZone = True;
		SetINIBool("MinimapMissionWnd", "a", bShowRaid, "WindowsInfo.ini");
		SetINIBool("MinimapMissionWnd", "e", bShowInzone, "WindowsInfo.ini");
		SetINIBool("MinimapMissionWnd", "p", bShowHuntingZone, "WindowsInfo.ini");
		SetINIBool("MinimapMissionWnd", "l", True, "WindowsInfo.ini");
	}
	else
	{
		bShowRaid = numToBool(nRaid);
		bShowInzone = numToBool(nInzone);
		bShowHuntingZone = numToBool(nHunt);
	}
}

function updateToggleButton()
{
	if (bShowRaid)
	{
		BTN_Raid.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");
	}
	else
	{
		BTN_Raid.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
	}
	if (bShowHuntingZone)
	{
		BTN_Huntingzone.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");
	}
	else
	{
		BTN_Huntingzone.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
	}
	if (getInstanceUIData().getIsClassicServer())
	{
		bShowInzone = False;
		BTN_Inzone.HideWindow();
		GetTextureHandle(m_WindowName $ ".MissionTab.BTNICON_Inzone_Tex").HideWindow();
		BTN_Raid.ClearAnchor();
		BTN_Raid.SetAnchor(m_WindowName $ ".MissionTab.BTN_Huntingzone", "TopLeft", "TopLeft", 107, 0);
		GetTextureHandle(m_WindowName $ ".MissionTab.BTNICON_Raid_Tex").ClearAnchor();
		GetTextureHandle(m_WindowName $ ".MissionTab.BTNICON_Raid_Tex").SetAnchor(m_WindowName $ ".MissionTab.BTN_Raid", "TopLeft", "TopLeft", 6, 5);
	}
	else
	{
		BTN_Raid.ClearAnchor();
		BTN_Raid.SetAnchor(m_WindowName $ ".MissionTab.BTN_Huntingzone", "TopLeft", "TopLeft", 254, 0);
		GetTextureHandle(m_WindowName $ ".MissionTab.BTNICON_Raid_Tex").ClearAnchor();
		GetTextureHandle(m_WindowName $ ".MissionTab.BTNICON_Raid_Tex").SetAnchor(m_WindowName $ ".MissionTab.BTN_Raid", "TopLeft", "TopLeft", 6, 5);
		BTN_Inzone.ShowWindow();
		GetTextureHandle(m_WindowName $ ".MissionTab.BTNICON_Inzone_Tex").ShowWindow();
		if (bShowInzone)
		{
			BTN_Inzone.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");
		}
		else
		{
			BTN_Inzone.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
		}
	}
}

function bool isShowRaid()
{
	return bShowRaid;
}

function bool isShowInzone()
{
	return bShowInzone;
}

function bool isShowHuntingZone()
{
	return bShowHuntingZone;
}

function refresh()
{
	updateToggleButton();
	addMissionList();
	addLocalList();
	// End:0xBB
	if(IsAdenServer())
	{
		TabCtrl.RemoveTabControl(2);
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabLineBg").SetWindowSize(138, 23);
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabLineBg").SetAnchor(m_WindowName $ "." $ TabCtrl.GetWindowName(), "TopLeft", "TopLeft", 218, 0);		
	}
	else
	{
		addQuestList();
	}
}

function bool tryLevelCheckForHuntingZone(int UserLevel, int MinLevel, int MaxLevel)
{
	if (getInstanceUIData().getIsClassicServer())
	{
		return tryLevelCheck(UserLevel, MinLevel, MaxLevel);
	}
	else
	{
		if ((UserLevel >= MinLevel - 10) && (UserLevel <= MaxLevel + 10))
		{
			return True;
		}
	}
	return False;
}

function addMissionList()
{
	local int i;
	local array<MapListInfo> nHuntingArray;
	local array<MapListInfo> nInzoneArray;
	local UserInfo pUserInfo;
	local HuntingZoneUIData huntingZoneData;

	GetPlayerInfo(pUserInfo);
	Mission_ListCtrl.DeleteAllItem();
	nHuntingArray.Remove(0, nHuntingArray.Length);
	nInzoneArray.Remove(0, nInzoneArray.Length);

	for (i = 0; i < 500; i++)
	{
		if (Class 'UIDATA_HUNTINGZONE'.static.IsValidData(i) == False)
		{
			continue;
		}
		Class 'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
		if (huntingZoneData.nType == 1 || huntingZoneData.nType == 2 || huntingZoneData.nType == 10)
		{
			if (bShowHuntingZone)
			{
				if (tryLevelCheckForHuntingZone(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel) == False)
				{
					continue;
				}
				nHuntingArray.Insert(nHuntingArray.Length, 1);
				nHuntingArray[nHuntingArray.Length - 1].Index = i;
				nHuntingArray[nHuntingArray.Length - 1].sortingKey = getInstanceL2Util().makeZeroString(4, huntingZoneData.nMinLevel);
				nHuntingArray.Sort(OnSortCompare);
			}
		}
		else
		{
			if (huntingZoneData.nType == 3 || huntingZoneData.nType == 4 || huntingZoneData.nType == 12)
			{
				if (bShowInzone)
				{
					if (tryLevelCheck(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel) == False)
					{
						continue;
					}
					nInzoneArray.Insert(nInzoneArray.Length, 1);
					nInzoneArray[nInzoneArray.Length - 1].Index = i;
					nInzoneArray[nInzoneArray.Length - 1].sortingKey = getInstanceL2Util().makeZeroString(4, huntingZoneData.nMinLevel);
					nInzoneArray.Sort(OnSortCompare);
				}
			}
		}
	}
	makeMapList(Mission_ListCtrl, nHuntingArray, GetSystemString(1296), True, "L2UI_CT1.Minimap.Mission_huntingzone", False);
	makeMapList(Mission_ListCtrl, nInzoneArray, GetSystemString(2668), True, "L2UI_CT1.Minimap.Mission_inzone", True);
	if (bShowInzone)
	{
		RequestInzoneWaitingTime(False);
	}
	if (bShowRaid)
	{
		makeRaidList();
	}
	missionListBeforeSelect();
}

function missionListBeforeSelect()
{
	local int i;
	local int nInstantZoneID;
	local int Index;
	local int nFactionID;
	local int NpcID;
	local int selectedInstantZoneID;
	local int SelectedIndex;
	local int selectedNFactionID;
	local int selectedNpcID;
	local LVDataRecord Record;


	for (i = 0; i < Mission_ListCtrl.GetRecordCount(); i++)
	{
		Mission_ListCtrl.GetRec(i, Record);
		if (Record.LVDataList.Length == 0)
		{
			continue;
		}
		ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
		ParseInt(Record.LVDataList[0].szReserved, "nFactionID", nFactionID);
		ParseInt(Record.LVDataList[0].szReserved, "index", Index);
		ParseInt(Record.LVDataList[0].szReserved, "npcID", NpcID);
		if (lastSelectListRecord.LVDataList.Length == 0)
		{
			continue;
		}
		ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "instantZoneID", selectedInstantZoneID);
		ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "nFactionID", selectedNFactionID);
		ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "index", SelectedIndex);
		ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "npcID", selectedNpcID);
		if (nInstantZoneID + nFactionID + Index + NpcID <= 0)
		{
			continue;
		}
		if ((nInstantZoneID == selectedInstantZoneID) && (selectedNFactionID == nFactionID) && (SelectedIndex == Index) || (selectedNpcID == NpcID) && (selectedNpcID > 0))
		{
			Mission_ListCtrl.SetSelectedIndex(i, True);
			break;
		}
	}
}

function MakeMapListCastle(ListCtrlHandle List, array<MapListInfo> targetMapListInfo, string headerString, bool bLevelLimitView, string headerIcon, optional bool bInstanceZoneID)
{
	local int N;
	local int i;
	local string addStr;
	local string backStr;
	local string szReserved;
	local HuntingZoneUIData huntingZoneData;
	local LVData lData;


	for (N = 0; N < targetMapListInfo.Length; N++)
	{
		addStr = "";
		szReserved = "";
		i = targetMapListInfo[N].Index;
		Class 'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
		if (N == 0)
		{
			addListItemHead(List, headerString $ " (" $ string(targetMapListInfo.Length) $ ")", headerIcon);
		}
		ParamAdd(szReserved, "index", string(i));
		if (bInstanceZoneID)
		{
			ParamAdd(szReserved, "instantZoneID", string(huntingZoneData.nInstantZoneID));
		}
		if (bLevelLimitView)
		{
			addStr = getLevelRangeString(i);
		}
		backStr = "";
		if ((huntingZoneData.nInstantZoneID == 0) && (bInstanceZoneID == True))
		{
			backStr = "(" $ GetSystemString(3554) $ ")";
		}
		lData = makeListLvDataText(addStr $ huntingZoneData.strName $ backStr, getInstanceL2Util().Gold, huntingZoneData.nWorldLoc, szReserved);
		// End:0x318
		if(getInstanceUIData().getIsLiveServer())
		{
			// End:0x20B
			if(huntingZoneData.nType == 1)
			{
				lData.hasIcon = true;
				lData.nTextureWidth = 15;
				lData.nTextureHeight = 11;
				lData.nTextureU = 15;
				lData.nTextureV = 11;
				lData.szTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_6";				
			}
			else if(huntingZoneData.nType == 10)
			{
				lData.hasIcon = true;
				lData.nTextureWidth = 15;
				lData.nTextureHeight = 11;
				lData.nTextureU = 15;
				lData.nTextureV = 11;
				lData.szTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_7";					
			}
			else if(huntingZoneData.nType == 2)
			{

				lData.hasIcon = true;
				lData.nTextureWidth = 15;
				lData.nTextureHeight = 11;
				lData.nTextureU = 15;
				lData.nTextureV = 11;
				lData.szTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_8";
			}
		}
		addListItem(List, lData);
	}
}

function makeMapList(ListCtrlHandle List, array<MapListInfo> targetMapListInfo, string headerString, bool bLevelLimitView, string headerIcon, optional bool bInstanceZoneID)
{
	local int N;
	local int i;
	local string addStr;
	local string backStr;
	local string szReserved;
	local HuntingZoneUIData huntingZoneData;


	for (N = 0; N < targetMapListInfo.Length; N++)
	{
		addStr = "";
		szReserved = "";
		i = targetMapListInfo[N].Index;
		Class 'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
		if (N == 0)
		{
			addListItemHead(List, headerString $ " (" $ string(targetMapListInfo.Length) $ ")", headerIcon);
		}
		ParamAdd(szReserved, "index", string(i));
		if (bInstanceZoneID)
		{
			ParamAdd(szReserved, "instantZoneID", string(huntingZoneData.nInstantZoneID));
		}
		if (bLevelLimitView)
		{
			addStr = getLevelRangeString(i);
		}
		backStr = "";
		if ((huntingZoneData.nInstantZoneID == 0) && (bInstanceZoneID == True))
		{
			backStr = "(" $ GetSystemString(3554) $ ")";
		}
		addListItem(List, makeListLvDataText(addStr $ huntingZoneData.strName $ backStr, getInstanceL2Util().Gold, huntingZoneData.nWorldLoc, szReserved));
	}
}

function addLocalList()
{
	local int i;
	local array<MapListInfo> nCastlevilleArray;
	local array<MapListInfo> nFortressArray;
	local array<MapListInfo> nAgitCountArray;
	local array<MapListInfo> nHuntingZoneArray;
	local array<MapListInfo> nFactionArray;
	local HuntingZoneUIData huntingZoneData;

	if (LocalInfo_ListCtrl.GetRecordCount() <= 0)
	{
		LocalInfo_ListCtrl.DeleteAllItem();
		nCastlevilleArray.Remove(0, nCastlevilleArray.Length);
		nFortressArray.Remove(0, nFortressArray.Length);
		nAgitCountArray.Remove(0, nAgitCountArray.Length);
		nHuntingZoneArray.Remove(0, nHuntingZoneArray.Length);
		nFactionArray.Remove(0, nFactionArray.Length);

		for (i = 0; i < 500; i++)
		{
			if (Class 'UIDATA_HUNTINGZONE'.static.IsValidData(i) == False)
			{
				continue;
			}
			Class 'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
			if (huntingZoneData.nType == 8)
			{
				nCastlevilleArray.Insert(nCastlevilleArray.Length, 1);
				nCastlevilleArray[nCastlevilleArray.Length - 1].Index = i;
				nCastlevilleArray[nCastlevilleArray.Length - 1].sortingKey = huntingZoneData.strName;
				nCastlevilleArray.Sort(OnSortCompare);
			}
			else
			{
				if (huntingZoneData.nType == 9)
				{
					nFortressArray.Insert(nFortressArray.Length, 1);
					nFortressArray[nFortressArray.Length - 1].Index = i;
					nFortressArray[nFortressArray.Length - 1].sortingKey = huntingZoneData.strName;
					nFortressArray.Sort(OnSortCompare);
				}
				else
				{
					if (huntingZoneData.nType == 5)
					{
						nAgitCountArray.Insert(nAgitCountArray.Length, 1);
						nAgitCountArray[nAgitCountArray.Length - 1].Index = i;
						nAgitCountArray[nAgitCountArray.Length - 1].sortingKey = huntingZoneData.strName;
						nAgitCountArray.Sort(OnSortCompare);
					}
					else
					{
						if ((huntingZoneData.nType == 1) || (huntingZoneData.nType == 2) || (huntingZoneData.nType == 10))
						{
							nHuntingZoneArray.Insert(nHuntingZoneArray.Length, 1);
							nHuntingZoneArray[nHuntingZoneArray.Length - 1].Index = i;
							nHuntingZoneArray[nHuntingZoneArray.Length - 1].sortingKey = getInstanceL2Util().makeZeroString(4, huntingZoneData.nMinLevel);
							nHuntingZoneArray.Sort(OnSortCompare);
						}
					}
				}
			}
		}
		MakeMapListCastle(LocalInfo_ListCtrl, nCastlevilleArray, GetSystemString(3529), False, "L2UI_CT1.EmptyBtn");
		makeMapList(LocalInfo_ListCtrl, nFortressArray, GetSystemString(1605), False, "L2UI_CT1.EmptyBtn");
		makeMapList(LocalInfo_ListCtrl, nAgitCountArray, GetSystemString(1616), False, "L2UI_CT1.EmptyBtn");
		makeMapList(LocalInfo_ListCtrl, nHuntingZoneArray, GetSystemString(1296), True, "L2UI_CT1.EmptyBtn");
	}
}

function makeFactionList()
{
	local array<L2UserFactionUIInfo> factionInfoListArray;
	local UserInfo pUserInfo;
	local int i;
	local string szReserved;
	local L2FactionUIData FactionData;
	local MinimapRegionIconData IconData;
	local Vector Loc;

	GetPlayerInfo(pUserInfo);
	GetUserFactionInfoList(pUserInfo.nID, factionInfoListArray);

	for (i = 0; i < factionInfoListArray.Length; i++)
	{
		GetFactionData(factionInfoListArray[i].nFactionID, FactionData);
		if (GetMinimapRegionIconData(FactionData.nRegionID, IconData))
		{
			Loc.X = IconData.nWorldLocX;
			Loc.Y = IconData.nWorldLocY;
			Loc.Z = IconData.nWorldLocZ;
		}
		if (i == 0)
		{
			addListItemHead(LocalInfo_ListCtrl, GetSystemString(3443) $ " (" $ string(factionInfoListArray.Length) $ ")", "L2UI_CT1.EmptyBtn");
		}
		szReserved = "";
		ParamAdd(szReserved, "nFactionID", string(FactionData.nFactionID));
		addListItem(LocalInfo_ListCtrl, makeListLvDataText(FactionData.strFactionName, getInstanceL2Util().Gold, Loc, szReserved));
	}
}

function makeRaidList()
{
	local UserInfo pUserInfo;
	local int i;
	local int raidCount;
	local array<int> raidNpcIDArray;
	local string addStr;
	local array<RaidUIData> raidUIDataArray;
	local RaidUIData raidData;
	local string szReserved;
	local int raidMin;
	local int raidMax;

	GetPlayerInfo(pUserInfo);
	if (IsBloodyServer())
	{
		raidMin = getInstanceUIData().RAID_BLOODY_MIN;
		raidMax = getInstanceUIData().RAID_BLOODY_MAXCOUNT;
	}
	else
	{
		raidMin = getInstanceUIData().RAID_MIN;
		raidMax = getInstanceUIData().RAID_MAXCOUNT;
	}

	for (i = raidMin; i < raidMax; i++)
	{
		raidData = getRaidDataByIndex(i);
		addStr = "";
		if ((raidData.nWorldLoc.X == 0) && (raidData.nWorldLoc.Y == 0) && (raidData.nWorldLoc.Z == 0))
		{
			continue;
		}
		if (tryLevelCheck(pUserInfo.nLevel, raidData.nMinLevel, raidData.nMaxLevel) == False)
		{
			continue;
		}
		raidData.sortingKey = getInstanceL2Util().makeZeroString(4, raidData.nRaidMonsterLevel);
		raidUIDataArray[raidUIDataArray.Length] = raidData;
	}
	raidUIDataArray.Sort(OnSortCompareForRaid);

	for (i = 0; i < raidUIDataArray.Length; i++)
	{
		if (raidCount == 0)
		{
			addListItemHead(Mission_ListCtrl, GetSystemString(1297) $ " (" $ string(raidUIDataArray.Length) $ ")", "L2UI_CT1.Minimap.Mission_raid");
		}
		raidCount++;
		raidData = raidUIDataArray[i];
		szReserved = "";
		ParamAdd(szReserved, "npcID", string(raidData.nRaidMonsterID));
		ParamAdd(szReserved, "index", string(raidData.Id));
		addStr = "[Lv." $ string(raidData.nRaidMonsterLevel) $ "] ";
		ParamAdd(szReserved, "addStr", addStr);
		raidNpcIDArray[raidNpcIDArray.Length] = raidData.nRaidMonsterID;
		addListItem(Mission_ListCtrl, makeListLvDataText(addStr $ raidData.raidMonsterName $ " (" $ GetSystemString(1718) $ ")", getInstanceL2Util().ColorGray, raidData.nWorldLoc, szReserved));
	}
	if (raidNpcIDArray.Length > 0)
	{
		Class 'MiniMapAPI'.static.RequestRaidBossSpawnInfo(raidNpcIDArray);
	}
}

function addListItem(ListCtrlHandle List, LVData lData)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 1;
	Record.LVDataList[0] = lData;
	List.InsertRecord(Record);
}

function addListItemHead(ListCtrlHandle List, string textStr, string IconName)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 1;
	Record.LVDataList[0].hasIcon = True;
	Record.LVDataList[0].szData = " " $ textStr;
	Record.LVDataList[0].nTextureWidth = 15;
	Record.LVDataList[0].nTextureHeight = 15;
	Record.LVDataList[0].nTextureU = 15;
	Record.LVDataList[0].nTextureV = 15;
	Record.LVDataList[0].szTexture = IconName;
	Record.LVDataList[0].iconBackTexName = "L2UI_CT1.List_HeadLineFrame";
	Record.LVDataList[0].backTexOffsetXFromIconPosX = -6;
	Record.LVDataList[0].backTexOffsetYFromIconPosY = 0;
	Record.LVDataList[0].backTexWidth = 354;
	Record.LVDataList[0].backTexHeight = 19;
	Record.LVDataList[0].backTexUL = 32;
	Record.LVDataList[0].backTexVL = 19;
	List.InsertRecord(Record);
}

function ShowQuestTarget()
{
	local int idx, questID, NpcID;
	local string strTargetName, QuestName;
	local Vector vTargetPos;
	local MinimapWnd script;
	local LVDataRecord Record;
	local WindowHandle mapSWnd;

	script = MinimapWnd(GetScript("MinimapWnd"));
	mapSWnd = GetWindowHandle("MinimapWnd");
	idx = QuestInfo_ListCtrl.GetSelectedIndex();

	if(idx > -1)
	{
		QuestInfo_ListCtrl.GetRec(idx, Record);
		questID = int(Record.nReserved1);
	}

	if(questID > 0)
	{
		QuestName = class'UIDATA_QUEST'.static.GetQuestName(questID, 1);
		NpcID = class'UIDATA_QUEST'.static.GetStartNPCID(questID, 1);
		strTargetName = class'UIDATA_NPC'.static.GetNPCName(NpcID);
		vTargetPos = class'UIDATA_QUEST'.static.GetStartNPCLoc(questID, 1);

		if(vTargetPos.X == 0 && vTargetPos.Y == 0 && vTargetPos.Z == 0)
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5205));
			getInstanceL2Util().HideGFxMiniMapSelectedPin(getInstanceL2Util().MapPinType.PIN_YELLOW);
		}

		if(Len(strTargetName) > 0)
		{
			getInstanceL2Util().ShowGFxMiniMapSelectedPin(getInstanceL2Util().MapPinType.PIN_YELLOW, vTargetPos, strTargetName, QuestName);
		}
	}
}

function OnClickListCtrlRecord(string strID)
{
	local int idx;
	local int nInstantZoneID;
	local int nFactionID;
	local int Index;
	local int NpcID;
	local LVDataRecord Record;
	local HuntingZoneUIData huntingZoneData;
	local MinimapRegionIconData IconData;
	local L2FactionUIData FactionData;
	local Vector Loc;
	local bool notToTown;

	if (strID == "Mission_ListCtrl")
	{
		idx = Mission_ListCtrl.GetSelectedIndex();
		Mission_ListCtrl.GetRec(idx, Record);
	}
	else if (strID == "LocalInfo_ListCtrl")
	{
		idx = LocalInfo_ListCtrl.GetSelectedIndex();
		LocalInfo_ListCtrl.GetRec(idx, Record);
	}
	else if (strID == "QuestInfo_ListCtrl")
	{
		ShowQuestTarget();
		return;
	}

	Loc.X = Record.LVDataList[0].nReserved1;
	Loc.Y = Record.LVDataList[0].nReserved2;
	Loc.Z = Record.LVDataList[0].nReserved3;
	ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
	ParseInt(Record.LVDataList[0].szReserved, "index", Index);
	ParseInt(Record.LVDataList[0].szReserved, "nFactionID", nFactionID);
	ParseInt(Record.LVDataList[0].szReserved, "npcID", NpcID);
	lastSelectListRecord = Record;
	if (NpcID > 0)
	{
		Loc.X = Record.LVDataList[0].nReserved1;
		Loc.Y = Record.LVDataList[0].nReserved2;
		Loc.Z = Record.LVDataList[0].nReserved3;
		notToTown = True;
	}
	else
	{
		if (Index > 0)
		{
			Class 'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(Index, huntingZoneData);
			GetMinimapRegionIconData(huntingZoneData.nRegionID, IconData);
			if (huntingZoneData.nRegionID > 0)
			{
				Loc.X = IconData.nWorldLocX;
				Loc.Y = IconData.nWorldLocY;
				Loc.Z = IconData.nWorldLocZ;
			}
			else
			{
				Loc = huntingZoneData.nWorldLoc;
			}
		}
		else
		{
			if (nFactionID > 0)
			{
				GetFactionData(nFactionID, FactionData);
				if (GetMinimapRegionIconData(FactionData.nRegionID, IconData))
				{
					Loc.X = IconData.nWorldLocX;
					Loc.Y = IconData.nWorldLocY;
					Loc.Z = IconData.nWorldLocZ;
				}
			}
		}
	}
	if (isVectorZero(Loc) == False)
	{
		ChaseMiniPosition(Loc, IconData, notToTown);
	}
	if (strID == "Mission_ListCtrl")
	{
		Mission_ListCtrl.SetFocus();
	}
	else
	{
		if (strID == "LocalInfo_ListCtrl")
		{
			LocalInfo_ListCtrl.SetFocus();
		}
	}
}

function ChaseMiniPosition(Vector Loc, optional MinimapRegionIconData IconData, optional bool notToTown)
{
	local int OffsetX;
	local int OffsetY;

	OffsetX = IconData.nWidth / 2 + IconData.nIconOffsetX;
	OffsetY = IconData.nHeight / 2 + IconData.nIconOffsetY;
	getInstanceL2Util().ShowHighLightMapIcon(Loc, OffsetX, OffsetY, notToTown);
}

function LVData makeListLvDataText(string textStr, Color pColor, Vector Loc, optional string szReserved)
{
	local LVData lData;

	lData.bUseTextColor = True;
	lData.TextColor = pColor;
	lData.szData = textStr;
	lData.nReserved1 = int(Loc.X);
	lData.nReserved2 = int(Loc.Y);
	lData.nReserved3 = int(Loc.Z);
	lData.szReserved = szReserved;
	return lData;
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_Restart)
	{
		Init();
	}
	else if (Event_ID == EV_RaidBossSpawnInfo)
	{
		updateRaidNpc(param);
	}
	else if (Event_ID == EV_InzoneWaitingInfo)
	{
		handleInzoneWaitingInfo(param);
	}
}

function handleInzoneWaitingInfo(string param)
{
	local int sizeOfBlockedInzone;
	local int blockedInzoneID;
	local int i;
	local int M;
	local int nInstantZoneID;
	local int Index;
	local int nDataSystemMessage;
	local int nShowWindow;
	local string addStr;
	local LVDataRecord Record;

	ParseInt(param, "ShowWindow", nShowWindow);
	ParseInt(param, "sizeOfBlockedInzone", sizeOfBlockedInzone);
	if (nShowWindow <= 0)
	{
		for (i = 0; i < sizeOfBlockedInzone; i++)
		{
			ParseInt(param, "blockedInzoneID_" $ string(i), blockedInzoneID);

			for (M = 0; M < Mission_ListCtrl.GetRecordCount(); M++)
			{
				Mission_ListCtrl.GetRec(M, Record);
				if (Record.LVDataList[0].szReserved != "")
				{
					ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
					ParseInt(Record.LVDataList[0].szReserved, "index", Index);
					if (nInstantZoneID == blockedInzoneID)
					{
						addStr = getLevelRangeString(Index);
						Record.LVDataList[0].bUseTextColor = True;
						Record.LVDataList[0].TextColor = getInstanceL2Util().ColorGray;
						Record.LVDataList[0].szData = addStr $ GetInZoneNameWithZoneID(nInstantZoneID) $ " (" $ GetSystemString(5099) $ ")";
						Mission_ListCtrl.ModifyRecord(M, Record);
						break;
					}
				}
			}
		}

		for (M = 0; M < Mission_ListCtrl.GetRecordCount(); M++)
		{
			Mission_ListCtrl.GetRec(M, Record);
			if (Record.LVDataList[0].szReserved != "")
			{
				Index = 0;
				nInstantZoneID = 0;
				ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
				ParseInt(Record.LVDataList[0].szReserved, "index", Index);
				if (nInstantZoneID > 0)
				{
					if (((nInstantZoneID == 265) || (nInstantZoneID == 266)) && ((nDataSystemMessage == 4432) || (nDataSystemMessage == 4434) || (nDataSystemMessage == 4435)))
					{
						addStr = getLevelRangeString(Index);
						Record.LVDataList[0].bUseTextColor = True;
						Record.LVDataList[0].TextColor = getInstanceL2Util().ColorGray;
						Record.LVDataList[0].szData = addStr $ GetInZoneNameWithZoneID(nInstantZoneID) $ " (" $ GetSystemString(5099) $ ")";
						Mission_ListCtrl.ModifyRecord(M, Record);
					}
				}
			}
		}
	}
}

function updateRaidNpc(string param)
{
	local int npcCount;
	local int i;
	local int NpcID;
	local int npcStatus;

	ParseInt(param, "NpcCount", npcCount);

	for (i = 0; i < npcCount; i++)
	{
		ParseInt(param, "NpcId_" $ string(i), NpcID);
		ParseInt(param, "NpcStatus_" $ string(i), npcStatus);
		if (NpcID > 0)
		{
			updateRaidListRecord(NpcID, npcStatus);
		}
	}
}

function updateRaidListRecord(int NpcID, int npcStatus)
{
	local LVDataRecord Record;
	local int i;
	local int currentNpcID;
	local int Index;
	local string addStr;
	local Color Color;
	local string fullStr;


	for (i = 0; i < Mission_ListCtrl.GetRecordCount(); i++)
	{
		Mission_ListCtrl.GetRec(i, Record);
		if (Record.LVDataList[0].szReserved != "")
		{
			ParseInt(Record.LVDataList[0].szReserved, "npcID", currentNpcID);
			ParseInt(Record.LVDataList[0].szReserved, "index", Index);
			ParseString(Record.LVDataList[0].szReserved, "addStr", addStr);
			if (currentNpcID == NpcID)
			{
				Record.LVDataList[0].bUseTextColor = True;
				switch (npcStatus)
				{
					case QuestStatus_None:
						Color = getInstanceL2Util().ColorGray;
						fullStr = addStr $ Class 'UIDATA_NPC'.static.GetNPCName(NpcID) $ " (" $ GetSystemString(1718) $ ")";
						break;
					case QuestStatus_Doing:
						Color = getInstanceL2Util().Gold;
						fullStr = addStr $ Class 'UIDATA_NPC'.static.GetNPCName(NpcID);
						break;
					case QuestStatus_Done:
						Color = GetColor(255, 102, 102, 255);
						fullStr = addStr $ Class 'UIDATA_NPC'.static.GetNPCName(NpcID) $ " (" $ GetSystemString(13157) $ ")";
						break;
				}
				Record.LVDataList[0].TextColor = Color;
				Record.LVDataList[0].szData = fullStr;
				Mission_ListCtrl.ModifyRecord(i, Record);
				break;
			}
		}
	}
}

function string getLevelRangeString(int i)
{
	local string addStr;
	local HuntingZoneUIData huntingZoneData;

	Class 'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
	// End:0x7A
	if((huntingZoneData.nMinLevel != 0) && huntingZoneData.nMinLevel != 0)
	{
		addStr = "[" $ GetSystemString(88) $ "." $ string(huntingZoneData.nMinLevel) $ "~" $ string(huntingZoneData.nMaxLevel) $ "] ";
	}
	// End:0xB9
	if(getInstanceUIData().getIsLiveServer())
	{
		addStr = "[" $ GetSystemString(88) $ "." $ string(huntingZoneData.nMinLevel) $ "] ";
	}
	return addStr;
}

delegate int OnSortCompare(MapListInfo A, MapListInfo B)
{
	if (A.sortingKey > B.sortingKey)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

delegate int OnSortCompareForRaid(RaidUIData A, RaidUIData B)
{
	if (A.sortingKey > B.sortingKey)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function addQuestList()
{
	local UserInfo myInfo;

	GetPlayerInfo(myInfo);
	nClassID = myInfo.nSubClass;
	findRecommandQuest();
}

function Color questStateColor(int nState)
{
	if (nState == 2)
	{
		return GetColor(182, 182, 182, 255);
	}
	else if (nState == 1)
	{
		return GetColor(255, 221, 102, 255);
	}
	return GetColor(170, 153, 119, 255);
}

function insertListQuestInfo(int questID)
{
	local string QuestName;
	local int QuestType;
	local string levelText;
	local string questCompleteStr;
	local int MinLevel;
	local int MaxLevel;
	local int QuestState;
	local bool bQuestDoing;
	local LVDataRecord Record;

	QuestName = Class 'UIDATA_QUEST'.static.GetQuestName(questID);
	QuestType = Class 'UIDATA_QUEST'.static.GetQuestType(questID, 1);
	bQuestDoing = Class 'UIDATA_QUEST'.static.IsDoingQuest(questID);
	if (Class 'UIDATA_QUEST'.static.IsClearedQuest(questID))
	{
		if (bQuestDoing && ((QuestType == 0) || (QuestType == 2)))
		{
			QuestState = 0;
		}
		else
		{
			QuestState = 2;
			questCompleteStr = "[" $ GetSystemString(898) $ "] ";
		}
	}
	else
	{
		if (bQuestDoing)
		{
			QuestState = 1;
			questCompleteStr = "[" $ GetSystemString(829) $ "] ";
		}
		else
		{
			QuestState = 0;
		}
	}
	MinLevel = Class 'UIDATA_QUEST'.static.GetMinLevel(questID, 1);
	MaxLevel = Class 'UIDATA_QUEST'.static.GetMaxLevel(questID, 1);
	if ((MaxLevel > 0) && (MinLevel > 0))
	{
		levelText = string(MinLevel) $ "~" $ string(MaxLevel);
	}
	else if (MinLevel > 0)
	{
		levelText = string(MinLevel) $ " " $ GetSystemString(859);
	}
	else
	{
		levelText = GetSystemString(866);
	}

	Record.LVDataList.Length = 3;
	Record.LVDataList[0].szData = questCompleteStr $ QuestName;
	Record.LVDataList[0].bUseTextColor = True;
	Record.LVDataList[0].TextColor = questStateColor(QuestState);
	Record.LVDataList[1].szData = levelText;
	Record.LVDataList[1].bUseTextColor = True;
	Record.LVDataList[1].TextColor = questStateColor(QuestState);
	Record.LVDataList[2].nTextureWidth = 16;
	Record.LVDataList[2].nTextureHeight = 16;

	switch (QuestType)
	{
		case 0:
		case 2:
			Record.LVDataList[2].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_1";
			Record.LVDataList[2].szData = GetSystemString(861);
			break;
		case 1:
		case 3:
			Record.LVDataList[2].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_2";
			Record.LVDataList[2].szData = GetSystemString(862);
			break;
		case 4:
		case 5:
			Record.LVDataList[2].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_3";
			Record.LVDataList[2].szData = GetSystemString(2788);
			break;
	}

	Record.LVDataList[2].nReserved1 = QuestType;
	ParamAdd(Record.szReserved, "QuestName", QuestName);
	ParamAdd(Record.szReserved, "LevelText", levelText);
	ParamAdd(Record.szReserved, "QuestTypeText", Record.LVDataList[2].szData);
	Record.nReserved1 = questID;
	QuestInfo_ListCtrl.InsertRecord(Record);
}

function QuestRecommandData getQuestRecommandData(int questID, int categoryId, int Priority)
{
	local QuestRecommandData QuestRecommandData;

	QuestRecommandData.questID = questID;
	QuestRecommandData.Priority = Priority;
	QuestRecommandData.categoryId = categoryId;
	return QuestRecommandData;
}

function findRecommandQuest()
{
	local string QuestName;
	local int QuestType;
	local int questID;
	local int questCategoryID;
	local int questPriority;
	local int MaxLevel;
	local int MinLevel;
	local UserInfo UserInfo;
	local bool bClearedQuest;
	local QuestRecommandData questData;
	local array<QuestCategoryArrayData> categoryArr;
	local int i;
	local int M;

	GetPlayerInfo(UserInfo);
	QuestInfo_ListCtrl.DeleteAllItem();
	questID = Class 'UIDATA_QUEST'.static.GetFirstID();
	if (questID != -1)
	{
		QuestName = Class 'UIDATA_QUEST'.static.GetQuestName(questID);
		QuestType = Class 'UIDATA_QUEST'.static.GetQuestType(questID, 1);
		questCategoryID = Class 'UIDATA_QUEST'.static.GetQuestCategoryID(questID, 1);
		questPriority = Class 'UIDATA_QUEST'.static.GetQuestPriority(questID, 1);
		MaxLevel = Class 'UIDATA_QUEST'.static.GetMaxLevel(questID, 1);
		MinLevel = Class 'UIDATA_QUEST'.static.GetMinLevel(questID, 1);
		questData.categoryId = questCategoryID;
		questData.Priority = questPriority;
		questData.QuestID = questID;
		if (questPriority == 0)
		{
			// goto JL0225; // TODO: 245 ... проверить как оно работает на всех этих goto, мб где return нужен
		}
		else if (questPriority == -1)
		{
			if (UserInfo.nLevel >= MinLevel)
			{
				questPriority = 100;
			}
			else
			{
				// goto JL0225;
			}
		}
		else if (questPriority > 0)
		{
			if (MinLevel != 0)
			{
				if ((UserInfo.nLevel >= MinLevel) && (UserInfo.nLevel <= MinLevel + 5))
				{
					// goto JL019E;
				}
			}
			else
			{
				if (Class 'UIDATA_QUEST'.static.IsAcceptableQuest(questID) == False)
				{
					if (Class 'UIDATA_QUEST'.static.IsDoingQuest(questID) == False)
					{
						// goto JL0225;
					}
				}
				bClearedQuest = Class 'UIDATA_QUEST'.static.IsClearedQuest(questID);
				if (bClearedQuest)
				{
					if ((QuestType == 1) || (QuestType == 3))
					{
						//  goto JL0225;
					}
				}
				addCategoryArrQuestID(categoryArr, questData);
			}
		}
		questID = Class 'UIDATA_QUEST'.static.GetNextID();
		//  goto JL002F;
	}

	for (i = 0; i < categoryArr.Length; i++)
	{
		if (categoryArr[i].questRecommandData_Array.Length > 1)
		{
			categoryArr[i].questRecommandData_Array.Sort(OnSortCompareQuestPriority);
		}
		if (categoryArr[i].questRecommandData_Array.Length > 0)
		{

			for (M = 0; M < categoryArr[i].questRecommandData_Array.Length; M++)
			{
				if (categoryArr[i].questRecommandData_Array[0].Priority
					== categoryArr[i].questRecommandData_Array[M].Priority)
				{
					insertListQuestInfo(categoryArr[i].questRecommandData_Array[M].questID);
				}
			}
		}
	}
}

function addCategoryArrQuestID(out array<QuestCategoryArrayData> categoryArr, QuestRecommandData questData)
{
	local int i;
	local QuestCategoryArrayData newCategoryArrData;

	for (i = 0; i < categoryArr.Length; i++)
	{
		if (categoryArr[i].categoryId == questData.categoryId)
		{
			categoryArr[i].questRecommandData_Array[categoryArr[i].questRecommandData_Array.Length] = questData;
			return;
		}
	}
	newCategoryArrData.categoryId = questData.categoryId;
	newCategoryArrData.questRecommandData_Array[newCategoryArrData.questRecommandData_Array.Length] = questData;
	categoryArr[categoryArr.Length] = newCategoryArrData;
}

delegate int OnSortCompareQuestPriority(QuestRecommandData A, QuestRecommandData B)
{
	if (A.Priority < B.Priority)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function InitQuestTooltip()
{
	local CustomTooltip toolTipInfo;

	// End:0x62B
	if(getInstanceUIData().getIsLiveServer())
	{
		toolTipInfo.DrawList.Length = 12;
		toolTipInfo.DrawList[0].eType = DIT_TEXTURE;
		toolTipInfo.DrawList[0].u_nTextureWidth = 16;
		toolTipInfo.DrawList[0].u_nTextureHeight = 16;
		toolTipInfo.DrawList[0].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_6";
		toolTipInfo.DrawList[1].eType = DIT_TEXT;
		toolTipInfo.DrawList[1].nOffSetX = 5;
		toolTipInfo.DrawList[1].t_bDrawOneLine = true;
		toolTipInfo.DrawList[1].t_strText = GetSystemString(14055);
		toolTipInfo.DrawList[2].eType = DIT_TEXTURE;
		toolTipInfo.DrawList[2].nOffSetY = 2;
		toolTipInfo.DrawList[2].u_nTextureWidth = 16;
		toolTipInfo.DrawList[2].u_nTextureHeight = 16;
		toolTipInfo.DrawList[2].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_7";
		toolTipInfo.DrawList[2].bLineBreak = true;
		toolTipInfo.DrawList[3].eType = DIT_TEXT;
		toolTipInfo.DrawList[3].nOffSetY = 2;
		toolTipInfo.DrawList[3].nOffSetX = 5;
		toolTipInfo.DrawList[3].t_bDrawOneLine = true;
		toolTipInfo.DrawList[3].t_strText = GetSystemString(14051);
		toolTipInfo.DrawList[4].eType = DIT_TEXTURE;
		toolTipInfo.DrawList[4].nOffSetY = 2;
		toolTipInfo.DrawList[4].u_nTextureWidth = 16;
		toolTipInfo.DrawList[4].u_nTextureHeight = 16;
		toolTipInfo.DrawList[4].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_8";
		toolTipInfo.DrawList[4].bLineBreak = true;
		toolTipInfo.DrawList[5].eType = DIT_TEXT;
		toolTipInfo.DrawList[5].nOffSetY = 2;
		toolTipInfo.DrawList[5].nOffSetX = 5;
		toolTipInfo.DrawList[5].t_bDrawOneLine = true;
		toolTipInfo.DrawList[5].t_strText = GetSystemString(3518);
		toolTipInfo.DrawList[6].eType = DIT_TEXTURE;
		toolTipInfo.DrawList[6].u_nTextureWidth = 16;
		toolTipInfo.DrawList[6].u_nTextureHeight = 16;
		toolTipInfo.DrawList[6].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_1";
		toolTipInfo.DrawList[6].bLineBreak = true;
		toolTipInfo.DrawList[7].eType = DIT_TEXT;
		toolTipInfo.DrawList[7].nOffSetX = 5;
		toolTipInfo.DrawList[7].t_bDrawOneLine = true;
		toolTipInfo.DrawList[7].t_strText = GetSystemString(861);
		toolTipInfo.DrawList[8].eType = DIT_TEXTURE;
		toolTipInfo.DrawList[8].nOffSetY = 2;
		toolTipInfo.DrawList[8].u_nTextureWidth = 16;
		toolTipInfo.DrawList[8].u_nTextureHeight = 16;
		toolTipInfo.DrawList[8].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_2";
		toolTipInfo.DrawList[8].bLineBreak = true;
		toolTipInfo.DrawList[9].eType = DIT_TEXT;
		toolTipInfo.DrawList[9].nOffSetY = 2;
		toolTipInfo.DrawList[9].nOffSetX = 5;
		toolTipInfo.DrawList[9].t_bDrawOneLine = true;
		toolTipInfo.DrawList[9].t_strText = GetSystemString(862);
		toolTipInfo.DrawList[10].eType = DIT_TEXTURE;
		toolTipInfo.DrawList[10].nOffSetY = 2;
		toolTipInfo.DrawList[10].u_nTextureWidth = 16;
		toolTipInfo.DrawList[10].u_nTextureHeight = 16;
		toolTipInfo.DrawList[10].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_3";
		toolTipInfo.DrawList[10].bLineBreak = true;
		toolTipInfo.DrawList[11].eType = DIT_TEXT;
		toolTipInfo.DrawList[11].nOffSetY = 2;
		toolTipInfo.DrawList[11].nOffSetX = 5;
		toolTipInfo.DrawList[11].t_bDrawOneLine = true;
		toolTipInfo.DrawList[11].t_strText = GetSystemString(2788);
		QuestTooltip.SetTooltipCustomType(toolTipInfo);
	}
	else
	{
		toolTipInfo.DrawList.Length = 6;
		toolTipInfo.DrawList[0].eType = DIT_TEXTURE;
		toolTipInfo.DrawList[0].u_nTextureWidth = 16;
		toolTipInfo.DrawList[0].u_nTextureHeight = 16;
		toolTipInfo.DrawList[0].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_1";
		toolTipInfo.DrawList[1].eType = DIT_TEXT;
		toolTipInfo.DrawList[1].nOffSetX = 5;
		toolTipInfo.DrawList[1].t_bDrawOneLine = true;
		toolTipInfo.DrawList[1].t_strText = GetSystemString(861);
		toolTipInfo.DrawList[2].eType = DIT_TEXTURE;
		toolTipInfo.DrawList[2].nOffSetY = 2;
		toolTipInfo.DrawList[2].u_nTextureWidth = 16;
		toolTipInfo.DrawList[2].u_nTextureHeight = 16;
		toolTipInfo.DrawList[2].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_2";
		toolTipInfo.DrawList[2].bLineBreak = true;
		toolTipInfo.DrawList[3].eType = DIT_TEXT;
		toolTipInfo.DrawList[3].nOffSetY = 2;
		toolTipInfo.DrawList[3].nOffSetX = 5;
		toolTipInfo.DrawList[3].t_bDrawOneLine = true;
		toolTipInfo.DrawList[3].t_strText = GetSystemString(862);
		toolTipInfo.DrawList[4].eType = DIT_TEXTURE;
		toolTipInfo.DrawList[4].nOffSetY = 2;
		toolTipInfo.DrawList[4].u_nTextureWidth = 16;
		toolTipInfo.DrawList[4].u_nTextureHeight = 16;
		toolTipInfo.DrawList[4].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_3";
		toolTipInfo.DrawList[4].bLineBreak = true;
		toolTipInfo.DrawList[5].eType = DIT_TEXT;
		toolTipInfo.DrawList[5].nOffSetY = 2;
		toolTipInfo.DrawList[5].nOffSetX = 5;
		toolTipInfo.DrawList[5].t_bDrawOneLine = true;
		toolTipInfo.DrawList[5].t_strText = GetSystemString(2788);
		QuestTooltip.HideWindow();
	}
}

function int GetCastleIDByRegionID(int nRegionID)
{
	local int castleID;
	local int regionID;

	for (castleID = 0; castleID < 20; castleID++)
	{
		regionID = GetCastleRegionID(castleID);
		if (regionID != 0)
		{
			if (regionID == nRegionID)
			{
				return castleID;
			}
		}
	}
	return -1;
}

function int GetRegionIDByHuttingZoneID(int huttingZoneID)
{
	local HuntingZoneUIData huntingZoneData;

	Class 'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(huttingZoneID, huntingZoneData);
	return huntingZoneData.nRegionID;
}

function int GetCastleIDByHuttingZoneID(int huttingZoneID)
{
	return GetCastleIDByRegionID(GetRegionIDByHuttingZoneID(huttingZoneID));
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
}

defaultproperties
{
     m_WindowName="MinimapMissionWndB"
}
