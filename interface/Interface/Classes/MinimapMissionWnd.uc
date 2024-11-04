/***
 * *
 *   맵 부속 임무, 지역 정보 창
 * 
 **/
class MinimapMissionWnd extends UICommonAPI;
/**
var WindowHandle Me;
var TextBoxHandle TxtMission_Title;

// 임무
var WindowHandle MissionTab;
var ButtonHandle BTN_Huntingzone;
var ButtonHandle BTN_Inzone;
var ButtonHandle BTN_Raid;
var ListCtrlHandle Mission_ListCtrl;

// 지역
var WindowHandle LocalInfoTab;
var ListCtrlHandle LocalInfo_ListCtrl;
var TabHandle TabCtrl;

var MinimapWnd miniMapWndScript;


// 퀘스트 추천
var ListCtrlHandle QuestInfo_ListCtrl;
var ButtonHandle BTN_AllQuest;

var TextureHandle QuestTooltip;

//var QuestTreeWnd questTreenWndScript;

// 토글 버튼 
var bool bShowHuntingZone, bShowInzone, bShowRaid;

var LVDataRecord lastSelectListRecord;

//var int lastSelectedTabIndex;
var int nClassID;


const QuestStatus_None = 0;
const QuestStatus_Doing = 1;
const QuestStatus_Done = 2;

struct  MapListInfo
{
	var string      sortingKey;
	var int			index;	
};

struct  QuestRecommandData
{
	var int		categoryID;
	var int		priority;

	var int		questID;
};

struct  QuestCategoryArrayData
{
	var int		categoryID;

	var Array<QuestRecommandData> questRecommandData_Array;
};


function OnRegisterEvent()
{
	return;
	RegisterEvent( EV_Restart );

	registerEvent( EV_InzoneWaitingInfo ); 	
	RegisterEvent( EV_RaidBossSpawnInfo );
}

function OnLoad()
{
	/*Initialize();
	Load();*/
}

function Initialize()
{
	Me               = GetWindowHandle( "MinimapMissionWnd" );
	TxtMission_Title = GetTextBoxHandle( "MinimapMissionWnd.TxtMission_Title" );

	// 임무
	MissionTab       = GetWindowHandle( "MinimapMissionWnd.MissionTab" );
	BTN_Huntingzone  = GetButtonHandle( "MinimapMissionWnd.MissionTab.BTN_Huntingzone" );
	BTN_Inzone       = GetButtonHandle( "MinimapMissionWnd.MissionTab.BTN_Inzone" );
	BTN_Raid         = GetButtonHandle( "MinimapMissionWnd.MissionTab.BTN_Raid" );
	Mission_ListCtrl = GetListCtrlHandle( "MinimapMissionWnd.MissionTab.Mission_ListCtrl" );

	// 지역
	LocalInfoTab        = GetWindowHandle( "MinimapMissionWnd.LocalInfoTab" );
	LocalInfo_ListCtrl  = GetListCtrlHandle( "MinimapMissionWnd.LocalInfoTab.LocalInfo_ListCtrl" );
	TabCtrl             = GetTabHandle( "MinimapMissionWnd.TabCtrl" );


	// 퀘스트 추천
	QuestInfo_ListCtrl  = GetListCtrlHandle( "MinimapMissionWnd.QuestInfoTab.QuestInfo_ListCtrl" );	
	BTN_AllQuest        = GetButtonHandle( "MinimapMissionWnd.QuestInfoTab.BTN_AllQuest" );


	QuestTooltip        = GetTextureHandle( "MinimapMissionWnd.QuestInfoTab.QuestTooltip" );

	miniMapWndScript    = MinimapWnd(GetScript("MinimapWnd"));	
	//questTreenWndScript = QuestTreeWnd(GetScript("QuestTreeWnd"));

	//class'UIAPI_WINDOW'.static.SetAlwaysOnTop( "MinimapMissionWnd", true );
}

function OnShow()
{
	updateOptionSave();

	//refresh();	 // 월드맵 minimapWnd 에서 refresh 를 호출 하고 있어서 여긴 주석처리
}

function Load()
{
	init();

	QuestInfo_ListCtrl.SetSelectedSelTooltip(false);	
	QuestInfo_ListCtrl.SetAppearTooltipAtMouseX(true);

	InitQuestTooltip();
}

function init()
{
	bShowRaid = true;
	bShowInzone = true;
	bShowHuntingZone = true;

	LocalInfo_ListCtrl.DeleteAllItem();
	Mission_ListCtrl.DeleteAllItem();
}

//---------------------------------------------------------------------------------------------------
// Button Click
//---------------------------------------------------------------------------------------------------
function OnClickButton( string Name )
{
	switch( Name )
	{
		case "BTN_Raid":
		case "BTN_Inzone":
		case "BTN_Huntingzone":
			 toggleButtonClick(Name);
			 break;

		//case "TabCtrl0" : lastSelectedTabIndex = 0; break;
		//case "TabCtrl1" : lastSelectedTabIndex = 1; break;
		//case "TabCtrl2" : 
						  
		//				  if(TabCtrl.GetTopIndex() == lastSelectedTabIndex) Debug("같다..");
		//				  lastSelectedTabIndex = 2; 
		//				  break;

		case "BTN_AllQuest":
			 if (GetWindowHandle("QuestListWnd").IsShowWindow()) GetWindowHandle("QuestListWnd").HideWindow();
			 else ShowQuestInfoWindow();

			 break;

		case "CloseButton" : miniMapWndScript.OnClickButton("OpenGuideWnd");
		     break;
	}
}

// 토글 버튼 클릭 
function toggleButtonClick(string buttonName)
{
	switch( buttonName )
	{
		case "BTN_Raid":
			 bShowRaid = !bShowRaid;
			 miniMapWndScript.showRegionIcon(EMinimapRegionType.MRT_Raid, bShowRaid);
			 SetINIBool ( "MinimapMissionWnd", "a", bShowRaid, "WindowsInfo.ini") ;

			 //Debug(buttonName @ ": " @ bShowRaid);
			 break;

		case "BTN_Inzone":
			 bShowInzone = !bShowInzone;
			 miniMapWndScript.showRegionIcon(EMinimapRegionType.MRT_InstantZone, bShowInzone);
			 SetINIBool ( "MinimapMissionWnd", "e", bShowInzone, "WindowsInfo.ini") ;
			 break;

		case "BTN_Huntingzone":
			 bShowHuntingZone = !bShowHuntingZone;
			 miniMapWndScript.showRegionIcon(EMinimapRegionType.MRT_HuntingZone_Mission, bShowHuntingZone);
			 SetINIBool ( "MinimapMissionWnd", "p", bShowHuntingZone, "WindowsInfo.ini");
			 break;
	}

	CallGFxFunction("MiniMapGFxWnd","showHideCommend","");
	Debug("열때-버튼");
	refresh();
}

function updateOptionSave()
{
	local int nHunt, nInzone, nRaid, nFirstRun;
	
	GetINIBool( "MinimapMissionWnd", "l", nFirstRun  , "WindowsInfo.ini");
	GetINIBool( "MinimapMissionWnd", "a", nRaid  , "WindowsInfo.ini");
	GetINIBool( "MinimapMissionWnd", "e", nInzone, "WindowsInfo.ini");
	GetINIBool( "MinimapMissionWnd", "p", nHunt  , "WindowsInfo.ini");

	// 처음 옵션이 사용 된거라면..
	if (nFirstRun == 0)
	{
		bShowRaid = true;
		bShowInzone = true;
		bShowHuntingZone = true;
		SetINIBool ( "MinimapMissionWnd", "a", bShowRaid, "WindowsInfo.ini") ;
		SetINIBool ( "MinimapMissionWnd", "e", bShowInzone, "WindowsInfo.ini") ;
		SetINIBool ( "MinimapMissionWnd", "p", bShowHuntingZone, "WindowsInfo.ini");

		SetINIBool ( "MinimapMissionWnd", "l", true, "WindowsInfo.ini");
	}
	else
	{
		// false 이면 보이게.. 최초 실행 했을때 기본값이 false, 0이라.. 어쩔 수 없음.
		bShowRaid        = numToBool(nRaid);
		bShowInzone      = numToBool(nInzone);
		bShowHuntingZone = numToBool(nHunt);
	}

	miniMapWndScript.showRegionIcon(EMinimapRegionType.MRT_Raid, bShowRaid);
	miniMapWndScript.showRegionIcon(EMinimapRegionType.MRT_InstantZone, bShowInzone);
	miniMapWndScript.showRegionIcon(EMinimapRegionType.MRT_HuntingZone_Mission, bShowHuntingZone);
}

function updateToggleButton()
{
	// 레이드
	if(bShowRaid) 
		BTN_Raid.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");
	else
		BTN_Raid.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
		

	// 사냥터
	if(bShowHuntingZone) 
		BTN_Huntingzone.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");
	else
		BTN_Huntingzone.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
		

	// 인존은 라이브만 있다. 
	// 클래식 서버에는 인존이 없다.
	if(getInstanceUIData().getIsClassicServer())
	{
		bShowInzone = false;

		// 인존을 숨기고, 레이드 버튼 위치를 변경.
		BTN_Inzone.HideWindow();
		GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Inzone_Tex").HideWindow();

		BTN_Raid.ClearAnchor();
		BTN_Raid.SetAnchor( "MinimapMissionWnd.MissionTab.BTN_Huntingzone", "TopLeft", "TopLeft", 107, 0 );

		GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Raid_Tex").ClearAnchor();
		GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Raid_Tex").SetAnchor( "MinimapMissionWnd.MissionTab.BTN_Raid", "TopLeft", "TopLeft", 6, 5 );
	}
	else
	{
		BTN_Raid.ClearAnchor();
		BTN_Raid.SetAnchor( "MinimapMissionWnd.MissionTab.BTN_Huntingzone", "TopLeft", "TopLeft", 254, 0 );

		GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Raid_Tex").ClearAnchor();
		GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Raid_Tex").SetAnchor( "MinimapMissionWnd.MissionTab.BTN_Raid", "TopLeft", "TopLeft", 6, 5 );

		BTN_Inzone.ShowWindow();
		GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Inzone_Tex").ShowWindow();

		if(bShowInzone) 
			BTN_Inzone.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");
		else
			BTN_Inzone.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
	}

	//Debug("bShowRaid" @ bShowRaid);
	//Debug("bShowInzone" @ bShowInzone);
	//Debug("bShowHuntingZone" @ bShowHuntingZone);
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

// 갱신 
function refresh()
{
	// 버튼 업데이트
	updateToggleButton();

	addMissionList();

	addLocalList();

	addQuestList();
}

function bool tryLevelCheckForHuntingZone (int UserLevel, int MinLevel, int MaxLevel)
{
	if ( getInstanceUIData().getIsClassicServer() )
		return tryLevelCheck(UserLevel,MinLevel,MaxLevel);
	else if ( (UserLevel >= MinLevel - 5) && (UserLevel <= MaxLevel + 5) )
		return True;
	return False;
}

// 지역 정보 리스트
function addMissionList()
{
	local int i;
	local Array<MapListInfo> nHuntingArray, nInzoneArray;
	local UserInfo pUserInfo;
	local HuntingZoneUIData huntingZoneData;

	GetPlayerInfo ( pUserInfo );

	// 일단 목록 전체 삭제
	Mission_ListCtrl.DeleteAllItem();
	
	nHuntingArray.Remove(0, nHuntingArray.Length);
	nInzoneArray.Remove(0, nInzoneArray.Length);

	// 데이타를 일단 분리
	for (i = 0; i < 500 ; i++)
	{
		if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i) == false) continue;
		
		class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);

		if(huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_SOLO ||
		   huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTY ||
		   huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTYWITH_SOLO)
		{
			if (bShowHuntingZone)
			{
				//if (huntingZoneData.nRegionID <= 0) continue;

				if(tryLevelCheckForHuntingZone(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel) == false) continue;

				nHuntingArray.Insert(nHuntingArray.Length, 1);
				nHuntingArray[nHuntingArray.Length - 1].index = i;
				nHuntingArray[nHuntingArray.Length - 1].sortingKey = getInstanceL2Util().makeZeroString(4, huntingZoneData.nMinLevel);
				
				nHuntingArray.Sort(OnSortCompare);
			}			
		}
		else if(huntingZoneData.nType == HuntingZoneType.INSTANCE_ZONE_SOLO ||
			    huntingZoneData.nType == HuntingZoneType.INSTANCE_ZONE_PARTY)
		{
			if (bShowInzone)
			{
				if(tryLevelCheck(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel) == false) continue;

				nInzoneArray.Insert(nInzoneArray.Length, 1);
				nInzoneArray[nInzoneArray.Length - 1].index = i;
				nInzoneArray[nInzoneArray.Length - 1].sortingKey = getInstanceL2Util().makeZeroString(4, huntingZoneData.nMinLevel);
				
				nInzoneArray.Sort(OnSortCompare);

			}
		}
	}
	
	makeMapList(Mission_ListCtrl, nHuntingArray, GetSystemString(1296), true, "L2UI_CT1.Minimap.Mission_huntingzone", false);  // 사냥터	
	makeMapList(Mission_ListCtrl, nInzoneArray, GetSystemString(2668), true, "L2UI_CT1.Minimap.Mission_inzone", true);        // 인존	

	if(bShowInzone) RequestInzoneWaitingTime(false);
	if(bShowRaid) makeRaidList();

	missionListBeforeSelect();
}

function missionListBeforeSelect()
{
	local int i;
	local int nInstantZoneID, index, nFactionID, npcID;
	local int selectedInstantZoneID, selectedIndex, selectedNFactionID, selectedNpcID;
	local LVDataRecord Record;

	//Debug("-->missionListBeforeSelect run" @ Mission_ListCtrl.GetRecordCount());

	for (i = 0; i <	Mission_ListCtrl.GetRecordCount(); i++)
	{
		Mission_ListCtrl.GetRec(i, Record);

		//Debug("-->Record" @ Record.LVDataList.Length);
		//Debug("-->lastSelectListRecord" @ lastSelectListRecord.LVDataList.Length);
		
		if (Record.LVDataList.Length == 0) continue;

		parseInt (Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
		parseInt (Record.LVDataList[0].szReserved, "nFactionID", nFactionID);
		parseInt (Record.LVDataList[0].szReserved, "index", index);
		parseInt (Record.LVDataList[0].szReserved, "npcID", npcID);

		if (lastSelectListRecord.LVDataList.Length == 0) continue;

		parseInt (lastSelectListRecord.LVDataList[0].szReserved, "instantZoneID", selectedInstantZoneID);
		parseInt (lastSelectListRecord.LVDataList[0].szReserved, "nFactionID", selectedNFactionID);
		parseInt (lastSelectListRecord.LVDataList[0].szReserved, "index", selectedIndex);
		parseInt (lastSelectListRecord.LVDataList[0].szReserved, "npcID", selectedNpcID);

		// 헤더나 잘못된 값이면 넘어감.
		if ((nInstantZoneID + nFactionID + index + npcID) <= 0) continue;

		// 선택된 것과 같은게 있다면 선택
		if(nInstantZoneID == selectedInstantZoneID && selectedNFactionID == nFactionID &&  selectedIndex == index || 
			(selectedNpcID == npcID) && selectedNpcID > 0)
		{
			Mission_ListCtrl.SetSelectedIndex(i, true);
			break;
		}
	}
}

function makeMapList(ListCtrlHandle list, Array<MapListInfo> targetMapListInfo, string headerString, bool bLevelLimitView, string headerIcon, optional bool bInstanceZoneID)
{
	local int n, i;
	local string addStr, backStr, szReserved;
	local HuntingZoneUIData huntingZoneData;

	// 성
	for (n = 0; n < targetMapListInfo.Length ; n++)
	{
		addStr = "";
		szReserved = "";

		// 헌팅존 스크립트의 index
		i = targetMapListInfo[n].index;
		class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
		
		// 헤더 출력
		if (n == 0) addListItemHead(list, headerString $ " (" $ targetMapListInfo.Length $")", headerIcon); // 성 정보	
		ParamAdd(szReserved, "index", String(i));
		if (bInstanceZoneID)
			ParamAdd(szReserved, "instantZoneID", String(huntingZoneData.nInstantZoneID));

		if(bLevelLimitView) addStr = getLevelRangeString(i);

		backStr = "";
		// 헌팅존, 인존이 0이면 "이용 불가" 를 알 수 없는 상황이기 때문에 예외처리를 해준다. 
		if (huntingZoneData.nInstantZoneID == 0 && bInstanceZoneID == true)
		{
			backStr = "(" $ GetSystemString(3554) $ ")";  // 알수 없음
		}

		addListItem(list, makeListLvDataText(addStr $ huntingZoneData.strName $ backStr, getInstanceL2Util().Gold, huntingZoneData.nWorldLoc, szReserved));	
	}
}

// 지역 정보 리스트
function addLocalList()
{
	local int i;
	local Array<MapListInfo> nCastlevilleArray, nFortressArray, nAgitCountArray, nHuntingZoneArray, nFactionArray;
	local HuntingZoneUIData huntingZoneData;

	// 이미 뭔가 생성되어 있으면 그대로 사용한다. 세력 정보를 제외하면 나머지는 변경되지 않는 정보이다
	if (LocalInfo_ListCtrl.GetRecordCount() <= 0)
	{
		// 일단 목록 전체 삭제
		LocalInfo_ListCtrl.DeleteAllItem();
		
		nCastlevilleArray.Remove(0, nCastlevilleArray.Length);
		nFortressArray.Remove(0, nFortressArray.Length);
		nAgitCountArray.Remove(0, nAgitCountArray.Length);
		nHuntingZoneArray.Remove(0, nHuntingZoneArray.Length);
		nFactionArray.Remove(0, nFactionArray.Length);

		// 데이타를 일단 분리
		for (i = 0; i < 500 ; i++)
		{
			if(class'UIDATA_HUNTINGZONE'.static.IsValidData(i) == false) continue;
			
			class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);

			if(huntingZoneData.nType == HuntingZoneType.CASTLE)
			{
				nCastlevilleArray.Insert(nCastlevilleArray.Length, 1);
				nCastlevilleArray[nCastlevilleArray.Length - 1].index = i;
				nCastlevilleArray[nCastlevilleArray.Length - 1].sortingKey = huntingZoneData.strName;
				nCastlevilleArray.Sort(OnSortCompare);
			}
			else if(huntingZoneData.nType == HuntingZoneType.FORTRESS)
			{
				nFortressArray.Insert(nFortressArray.Length, 1);
				nFortressArray[nFortressArray.Length - 1].index = i;
				nFortressArray[nFortressArray.Length - 1].sortingKey = huntingZoneData.strName;
				nFortressArray.Sort(OnSortCompare);
			}
			else if(huntingZoneData.nType == HuntingZoneType.AGIT)
			{
				nAgitCountArray.Insert(nAgitCountArray.Length, 1);
				nAgitCountArray[nAgitCountArray.Length - 1].index = i;
				nAgitCountArray[nAgitCountArray.Length - 1].sortingKey = huntingZoneData.strName;
				nAgitCountArray.Sort(OnSortCompare);
			}
			else if(huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_SOLO ||
					huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTY || 
					huntingZoneData.nType == HuntingZoneType.FIELD_HUNTING_ZONE_PARTYWITH_SOLO)
			{
				nHuntingZoneArray.Insert(nHuntingZoneArray.Length, 1);
				nHuntingZoneArray[nHuntingZoneArray.Length - 1].index = i;
				nHuntingZoneArray[nHuntingZoneArray.Length - 1].sortingKey = getInstanceL2Util().makeZeroString(4, huntingZoneData.nMinLevel);
				nHuntingZoneArray.Sort(OnSortCompare);
			}
		}

		makeMapList(LocalInfo_ListCtrl, nCastlevilleArray, GetSystemString(3529), false, "L2UI_CT1.EmptyBtn");  // 성
		makeMapList(LocalInfo_ListCtrl, nFortressArray, GetSystemString(1605), false, "L2UI_CT1.EmptyBtn");     // 요새
		makeMapList(LocalInfo_ListCtrl, nAgitCountArray, GetSystemString(1616), false, "L2UI_CT1.EmptyBtn");    // 아지트
		makeMapList(LocalInfo_ListCtrl, nHuntingZoneArray, GetSystemString(1296), true, "L2UI_CT1.EmptyBtn");  // 사냥터	

		makeFactionList(); // 세력 정보 생성
	}
}

// 세력 지역 정보 목록 만들기
function makeFactionList()
{
	local array<L2UserFactionUIInfo>  factionInfoListArray;
	local UserInfo pUserInfo;	
	local int i, n;
	local string szReserved;

	local L2FactionUIData factionData;

	local MinimapRegionIconData iconData;
	local Vector loc;

	// local RaidUIData nRaidUIData;

	GetPlayerInfo(pUserInfo);

	GetUserFactionInfoList(pUserInfo.nID, factionInfoListArray);

	// 세력의 위치 정보와 세력 수는 고정이기 때문에 미리 목록을 생성 하고 목록 자체는 한번 생성하면 아무것도 안해도 된다.
	for(i = 0; i < factionInfoListArray.Length; i++)
	{   
		// Debug("factionInfoListArray[i].nFactionID:" @ factionInfoListArray[i].nFactionID);
		GetFactionData(factionInfoListArray[i].nFactionID, factionData);

		//Debug("-------------------------------------------------------");
		//Debug("세력 이름 : " @ factionData.strFactionName);

		//for(n = 0; n < factionData.arrFactionAreaZoneID.Length; n++)
		//{
		//	Debug("factionData.arrFactionAreaZoneID" @ factionData.arrFactionAreaZoneID[n]);
		//}
		//for(n = 0; n < factionData.arrFactionAreaName.Length; n++)
		//{
		//	Debug("factionData.arrFactionAreaName" @ factionData.arrFactionAreaName[n]);
		//}

		if(GetMinimapRegionIconData(factionData.nRegionID, iconData))
		{
			loc.x = iconData.nWorldLocX;
			loc.y = iconData.nWorldLocY;
			loc.z = iconData.nWorldLocZ;
		}

		// 헤더 출력 , 3443 세력
		if (i == 0) addListItemHead(LocalInfo_ListCtrl, GetSystemString(3443) $ " (" $ factionInfoListArray.Length $")", "L2UI_CT1.EmptyBtn"); // 세력 헤더

		szReserved = "";
		//ParamAdd(szReserved, "index", String(i));
		ParamAdd(szReserved, "nFactionID", String(factionData.nFactionID));

		addListItem(LocalInfo_ListCtrl, makeListLvDataText(factionData.strFactionName, getInstanceL2Util().Gold, loc, szReserved));	
	}
}

function makeRaidList()
{
	local UserInfo pUserInfo;
	local int i, raidCount;
	//local bool bAddList;
	local array<int> raidNpcIDArray;

	local string addStr;
	local string textStr;

	local array<RaidUIData> raidUIDataArray;
	local RaidUIData raidData;
	local array<int> raidDataKeyList;
	local string szReserved;

	local int raidMin, raidMax;

	GetPlayerInfo ( pUserInfo );

	// 레이드 타입 다 지움,
	//m_MiniMap.EraseRegionInfoByType(EMinimapRegionType.MRT_Raid);
	class'UIDATA_RAID'.static.GetRaidDataKeyList(raidDataKeyList);

	//local int raidMin, raidMax;
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


	for(i = 0; i < raidDataKeyList.Length; i++)
	{
		raidData = getRaidDataByIndex(raidDataKeyList[i]);

		//Debug("	raidData.raidMonsterName " @ raidData.raidMonsterName);
		//Debug("	raidData.id " @ raidData.id);
		addStr = "";
		// 0, 0, 0 위치 좌표가 모두 0이면 기획쪽에서 보여주길 원치 않는 데이타로 판단 해서 무시함.
		if(raidData.nWorldLoc.x == 0 && raidData.nWorldLoc.y == 0 && raidData.nWorldLoc.z == 0) continue;

		//miniMapWndScript.drawMinimapRegionInfo(EMinimapRegionType.MRT_Raid, raidData.id, false);

		if(tryLevelCheck(pUserInfo.nLevel, raidData.nMinLevel,  raidData.nMaxLevel) == false) continue;

		raidData.sortingKey = getInstanceL2Util().makeZeroString(4, raidData.nRaidMonsterLevel);
		raidUIDataArray[raidUIDataArray.Length] = raidData;
	}


	raidUIDataArray.Sort(OnSortCompareForRaid);

	for (i = 0; i < raidUIDataArray.Length; i++)
	{
		// 레이드
		if (raidCount == 0) addListItemHead(Mission_ListCtrl, GetSystemString(1297) $ " (" $ raidUIDataArray.Length $")", "L2UI_CT1.Minimap.Mission_raid"); 
		raidCount++;
		//bAddList = true;

		raidData = raidUIDataArray[i];

		szReserved = "";
		ParamAdd(szReserved, "npcID", String(raidData.nRaidMonsterID));
		ParamAdd(szReserved, "index", String(raidData.id)); //String(i));

		// List 목록 추가
		//			if (raidData.nMinLevel != 0 && raidData.nMinLevel != 0)
		//	addStr = "[Lv." $ raidData.nMinLevel $ "~"$ raidData.nMaxLevel $"] ";
		addStr = "[Lv." $ raidData.nRaidMonsterLevel $ "] ";

		ParamAdd(szReserved, "addStr", addStr);
		// 서버에 생존 여부를 물어볼 목록 만든다.
		raidNpcIDArray[raidNpcIDArray.Length] = raidData.nRaidMonsterID;
		// 몬스터이름(이용 불가) 같은 식으로 리스트 , 회색으로 생성
		if(GetLanguage() == ELanguageType.LANG_Russia || GetLanguage() == ELanguageType.LANG_Euro)
			textStr = addStr $ raidData.raidMonsterName $ " (" $ GetSystemString(3526) $ ")";
		else
			textStr = addStr $ raidData.raidMonsterName $ " (" $ GetSystemString(1718) $ ")";
		addListItem(Mission_ListCtrl,makeListLvDataText(textStr, getInstanceL2Util().ColorGray, raidData.nWorldLoc, szReserved));	
	}

	// 서버에 레이드 몬스터의 상태를 요청 한다. 
	if (raidNpcIDArray.Length > 0)
	{
		class'MiniMapAPI'.static.RequestRaidBossSpawnInfo(raidNpcIDArray);
		//Debug("[API Call] class'MiniMapAPI'.static.RequestRaidBossSpawnInfo --> " @ raidNpcIDArray.Length $ "ArrayLength");

		//for(i = 0; i < raidNpcIDArray.Length; i++)
		//{
		//	Debug("raidNpcIDArray :" @ i @ "-->" @ raidNpcIDArray[i]);
		//}
	}
}

// 리스트
function addListItem(ListCtrlHandle list, LVData lData)
{
	//local LVData Data;
	local LVDataRecord Record;

	Record.LVDataList.length = 1;

	Record.LVDataList[0] = lData;

	list.InsertRecord(Record);
}

// 헤더 같은 리스트를 추가 한다.
function addListItemHead(ListCtrlHandle list, string textStr,  string iconName)
{
	//local LVData Data;
	local LVDataRecord Record;

	Record.LVDataList.length = 1;

	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].szData = " " $ textStr;

	Record.LVDataList[0].nTextureWidth=15;
	Record.LVDataList[0].nTextureHeight=15;
	Record.LVDataList[0].nTextureU=15;
	Record.LVDataList[0].nTextureV=15;
	Record.LVDataList[0].szTexture = iconName; 

	// back texture 
	Record.LVDataList[0].iconBackTexName="L2UI_CT1.List_HeadLineFrame";
	Record.LVDataList[0].backTexOffsetXFromIconPosX=-6;
	Record.LVDataList[0].backTexOffsetYFromIconPosY=0;
	Record.LVDataList[0].backTexWidth=354;
	Record.LVDataList[0].backTexHeight=19;

	Record.LVDataList[0].backTexUL=32;
	Record.LVDataList[0].backTexVL=19;

	//Record.FirstLineOffsetX=0;
	list.InsertRecord(Record);
}

// 퀘스트 정보창에서 리스트를 클릭하면, 시작 npc로 압정을 찍음
function ShowQuestTarget()
{
	local int		idx;
	local int		QuestID;
	local int		NpcID;
	local string	strTargetName, questName;
	local vector	vTargetPos;
	local MinimapWnd Script;
	//local MinimapWnd_Expand Script2;
	local LVDataRecord record;
	local WindowHandle mapSWnd;
	local Vector emptyVector;
	
	Script = MinimapWnd(GetScript("MinimapWnd"));
	mapSWnd = GetWindowHandle( "MinimapWnd" );

	idx = QuestInfo_ListCtrl.GetSelectedIndex();
	if (idx>-1)
	{
		QuestInfo_ListCtrl.GetRec(idx, record);
		QuestID = int(record.nReserved1);
	}
	if (QuestID > 0)
	{
		questName = class'UIDATA_QUEST'.static.GetQuestName(QuestID, 1);
		NpcID = class'UIDATA_QUEST'.static.GetStartNPCID(QuestID, 1);
		strTargetName = class'UIDATA_NPC'.static.GetNPCName(NpcID);
		vTargetPos = class'UIDATA_QUEST'.static.GetStartNPCLoc(QuestID, 1);

		if (vTargetPos.x == 0 && vTargetPos.y == 0 && vTargetPos.z == 0)
		{
			getInstanceL2Util().showGfxScreenMessage( GetSystemMessage(5205));
			//class'QuestAPI'.static.SetQuestTargetInfo( false, false, false, "", emptyVector, 0, 0);
			miniMapWndScript.hideYellowPin();
		}
		
		if (Len(strTargetName)>0)
		{
			//class'QuestAPI'.static.SetQuestTargetInfo(true, true, false, strTargetName, vTargetPos, QuestID, 1);

			miniMapWndScript.showYellowPin(vTargetPos, strTargetName, questName);
			
			//Script.OnClickTargetButton();

			//getInstanceL2Util().showGfxScreenMessage( questName );			 

		}
	}	
}

function HideGFxYelloPin ()
{
	CallGFxFunction("MiniMapGFxWnd","HideQuestIcon","");
}

function OnClickListCtrlRecord( String strID )
{
	local int Idx, nInstantZoneID, nFactionID, index, npcID;
	local LVDataRecord record;

	local HuntingZoneUIData huntingZoneData;
	//local MinimapRegionInfo regionInfoForMapIcon;
	local MinimapRegionIconData iconData;
	local L2FactionUIData factionData;

	local Vector loc;
	
	if( strID == "Mission_ListCtrl")
	{
		Idx = Mission_ListCtrl.GetSelectedIndex();
		Mission_ListCtrl.GetRec( Idx, record );
	}
	else if (strID == "LocalInfo_ListCtrl")
	{
		Idx = LocalInfo_ListCtrl.GetSelectedIndex();
		LocalInfo_ListCtrl.GetRec( Idx, record );
	}

	else if (strID == "QuestInfo_ListCtrl")
	{
		//Idx = QuestInfo_ListCtrl.GetSelectedIndex();
		//QuestInfo_ListCtrl.GetRec( Idx, record );

		ShowQuestTarget();
		
		return;
	}

	// Debug("OnClickListCtrlRecord" @ strID);
	//record.LVDataList[0].szData
	loc.x = record.LVDataList[0].nReserved1;
	loc.y = record.LVDataList[0].nReserved2;
	loc.z = record.LVDataList[0].nReserved3;

	parseInt (Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
	parseInt (Record.LVDataList[0].szReserved, "index", index);
	parseInt (Record.LVDataList[0].szReserved, "nFactionID", nFactionID);
	parseInt (Record.LVDataList[0].szReserved, "npcID", npcID);

	//Debug("OnClickListCtrlRecord szReserved: " @ record.LVDataList[0].szReserved);
	//Debug("OnClickListCtrlRecord 1:" @ record.LVDataList[0].nReserved1);
	//Debug("OnClickListCtrlRecord 2:" @ record.LVDataList[0].nReserved2);
	//Debug("OnClickListCtrlRecord 3:" @ record.LVDataList[0].nReserved3);

	// 이전 클릭 값을 기억 하기 위해서..
	lastSelectListRecord = record;
	
	// npc 값이 있으면 레이드
	if (npcID > 0)
	{
		loc.x = record.LVDataList[0].nReserved1;
		loc.y = record.LVDataList[0].nReserved2;
		loc.z = record.LVDataList[0].nReserved3;
	}
	// 헌팅존 index
	else if (index > 0)
	{
		class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(index, huntingZoneData);
		GetMinimapRegionIconData(huntingZoneData.nRegionID, iconData);

		if (huntingZoneData.nRegionID > 0)
		{
			loc.x =  iconData.nWorldLocX;
			loc.y =  iconData.nWorldLocY;
			loc.z =  iconData.nWorldLocZ;
		}
		else
		{
			loc = huntingZoneData.nWorldLoc;
		}
	}
	// 세력
	else if (nFactionID > 0)
	{
		GetFactionData(nFactionID, factionData);

		if(GetMinimapRegionIconData(factionData.nRegionID, iconData))
		{
			loc.x = iconData.nWorldLocX;
			loc.y = iconData.nWorldLocY;
			loc.z = iconData.nWorldLocZ;
		}
	}

	if (isVectorZero(loc) == false)
	{
		// 대륙 탭 전환.
		miniMapWndScript.SetLocContinent(loc);	
		miniMapWndScript.mapIconHighlight(loc, iconData);

		class'UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, false);
		ChaseMiniPosition(Loc,IconData);
	}

	if( strID == "Mission_ListCtrl")
	{
		Mission_ListCtrl.SetFocus();
	}
	else if (strID == "LocalInfo_ListCtrl")
	{
		LocalInfo_ListCtrl.SetFocus();
	}
}

function ChaseMiniPosition (Vector Loc, optional MinimapRegionIconData IconData)
{
	local string param;
	local int OffsetX;
	local int OffsetY;

	param = "";
	OffsetX = (IconData.nWidth / 2) + IconData.nIconOffsetX;
	OffsetY = (IconData.nHeight / 2) + IconData.nIconOffsetY;
	ParamAdd(param,"x",string(Loc.X));
	ParamAdd(param,"y",string(Loc.Y));
	ParamAdd(param,"z",string(Loc.Z));
	ParamAdd(param,"offsetX",string(OffsetX));
	ParamAdd(param,"offsetY",string(OffsetY));
	CallGFxFunction("MiniMapGFxWnd","adjustMapView",param);
}

/** 아이템을 추가 한다. */
function LVData makeListLvDataText(string textStr, Color pColor, Vector loc, optional string szReserved)
{
	local LVData lData;

	lData.buseTextColor = True;
	lData.TextColor = pColor;
	lData.szData = textStr;

	// 이동 좌표 저장
	lData.nReserved1 = loc.x;
	lData.nReserved2 = loc.y;
	lData.nReserved3 = loc.z;
	lData.szReserved = szReserved;

	return lData;
}

//---------------------------------------------------------------------------------------------------
// Event
//---------------------------------------------------------------------------------------------------
function OnEvent(int Event_ID, string param)
{
	//Debug( "MinimapMissionWnd OnEvent " @ Event_ID ) ;

	if (Event_ID == EV_Restart)
	{
		init();		
	}
	// 10181 NpcCount=1 NpcID_0=29001   (여왕개미 레이드) 35레벨로..
	else if (Event_ID == EV_RaidBossSpawnInfo)
	{
		// Debug("EV_RaidBossSpawnInfo" @ param);
		updateRaidNpc(param);
	}
	// 5860
	else if (Event_ID == EV_InzoneWaitingInfo)
	{
		// Debug("EV_InzoneWaitingInfo" @ param);
		handleInzoneWaitingInfo(param);
	}
}

// 사용 못하는 인존 처리
function string handleInzoneWaitingInfo(string param)
{
	//local int currentInzoneID;
	local int sizeOfBlockedInzone ;
	local int blockedInzoneID ;
	
	local int i, m, nInstantZoneID, index, nDataSystemMessage;//, nCount;
	local int nShowWindow;
	local string addStr;

	local LVDataRecord Record;

	//Debug("인존 이벤트 " @param);
	//parseInt (param, "currentInzoneID" , currentInzoneID );
	parseInt (param, "ShowWindow" , nShowWindow );	
	parseInt (param, "sizeOfBlockedInzone" , sizeOfBlockedInzone );	
	
	if(nShowWindow <= 0)
	{
		for (i = 0 ; i <  sizeOfBlockedInzone ; i++ ) 
		{
			parseInt (param, "blockedInzoneID_" $ i, blockedInzoneID);
			
			for (m = 0; m < Mission_ListCtrl.GetRecordCount(); m++)
			{
				Mission_ListCtrl.GetRec(m, Record);

				if (Record.LVDataList[0].szReserved != "")
				{
					//Debug("Record.LVDataList[0].szData" @ Record.LVDataList[0].szData);
					//Debug("Record.LVDataList[0].szReserved" @ Record.LVDataList[0].szReserved);

					parseInt (Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
					parseInt (Record.LVDataList[0].szReserved, "index", index);

					// 리스트에 차단할 인스턴스 존이 있다면..
					if (nInstantZoneID == blockedInzoneID)
					{
						addStr = getLevelRangeString(index);
						Record.LVDataList[0].buseTextColor = True;
						Record.LVDataList[0].TextColor = getInstanceL2Util().ColorGray;
						Record.LVDataList[0].szData = addStr $ GetInZoneNameWithZoneID(nInstantZoneID)  $ " (" $ GetSystemString(5099) $ ")";
						Mission_ListCtrl.ModifyRecord(m, Record);

						// 맵 아이콘 정보 갱신, 비활성화 (평소에 활성화 되어 있음)
						miniMapWndScript.drawMinimapRegionInfo(EMinimapRegionType.MRT_InstantZone, index, false, true);
						//nCount++;
						break;

						//Debug("서버 정보에서 인존 정보 업데이트: " @Record.LVDataList[0].szData @ "- id - " @ nInstantZoneID @ ", index " @ index);					
						//if(nCount == sizeOfBlockedInzone) break;
					}
				}
			}
		}	

		//-------------------------------------------------------------------------------------------------------------------
		// *** 예외처리 : (기획자 요청: 최동걸) ***
		for (m = 0; m < Mission_ListCtrl.GetRecordCount(); m++)
		{
			Mission_ListCtrl.GetRec(m, Record);

			if (Record.LVDataList[0].szReserved != "")
			{
				index = 0;
				nInstantZoneID = 0;

				parseInt (Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
				parseInt (Record.LVDataList[0].szReserved, "index", index);

				// 인존인 경우만..
				if (nInstantZoneID > 0)
				{
					nDataSystemMessage = miniMapWndScript.getServerNData(MapServerInfoType.DEFENSEWARFARE);

					// Debug("nDataSystemMessage : " @ nDataSystemMessage);
					// Debug("nInstantZoneID : " @ nInstantZoneID);

					// 메사이아 요새 외성, 내성, 크세르스 요세전 서버에서 오는 메세지 값이 4432, 4434, 4435 인 경우 아이콘 비활성화
					if ((nInstantZoneID == 265 || nInstantZoneID == 266) && 
						(nDataSystemMessage == 4432 || nDataSystemMessage == 4434 || nDataSystemMessage == 4435))
					{
						addStr = getLevelRangeString(index);
						Record.LVDataList[0].buseTextColor = True;
						Record.LVDataList[0].TextColor = getInstanceL2Util().ColorGray;
						Record.LVDataList[0].szData = addStr $ GetInZoneNameWithZoneID(nInstantZoneID)  $ " (" $ GetSystemString(5099) $ ")";
						Mission_ListCtrl.ModifyRecord(m, Record);

						miniMapWndScript.drawMinimapRegionInfo(EMinimapRegionType.MRT_InstantZone, index, false, true);
						//Debug("메사이아 요새 예외 처리 작동" @ nInstantZoneID);
					}
				}
			}
		}
	}
}

function updateRaidNpc(string param)
{
	local int npcCount, i, npcID;

	//Debug("updateRaidNpc + param:" @ param);
	// 업데이트 할 레이드npc
	ParseInt(param, "NpcCount", npcCount);
	CallGFxFunction("MiniMapGFxWnd","drawMiniMapRegionInfoStart","");

	for (i = 0; i < NpcCount; i++)
	{		
		ParseInt(param, "NpcId_" $ i, npcID); 
		if (npcID > 0) updateRaidListRecord(npcID);
	}
}

function updateRaidListRecord(int npcID)
{
	local LVDataRecord Record;
	local int i, currentNpcID, index;
	local string addStr;

	//Debug("목록 검사 레이드 몬스터 id " @ npcID);
	for (i = 0; i < Mission_ListCtrl.GetRecordCount(); i++)
	{
		Mission_ListCtrl.GetRec(i, Record);

		if (Record.LVDataList[0].szReserved != "")
		{
			//Debug("Record.LVDataList[0].szData" @ Record.LVDataList[0].szData);
			//Debug("Record.LVDataList[0].szReserved" @ Record.LVDataList[0].szReserved);

			parseInt (Record.LVDataList[0].szReserved, "npcID", currentNpcID);
			parseInt (Record.LVDataList[0].szReserved, "index", index);
			parseString (Record.LVDataList[0].szReserved, "addStr", addStr);

			if (currentNpcID == npcID)
			{
				// npc 이름 칼라를 활성화 시키고, 이용불가 텍스트를 삭제
				Record.LVDataList[0].buseTextColor = True;
				Record.LVDataList[0].TextColor = getInstanceL2Util().Gold;
				Record.LVDataList[0].szData = addStr $ class'UIDATA_NPC'.static.GetNPCName(npcID);
				Mission_ListCtrl.ModifyRecord(i, Record);

				// 맵 아이콘 정보 갱신, 활성화
				miniMapWndScript.drawMinimapRegionInfo(EMinimapRegionType.MRT_Raid, index, true, true);

				//Debug("--------------------");
				//Debug("서버 정보에서 레이드 정보 업데이트: " @Record.LVDataList[0].szData);
				//Debug("index" @ index);
				//Debug("addStr" @ addStr);
				break;
			}
		}
	}
}

function string getLevelRangeString(int i)
{
	local string addStr;
	local HuntingZoneUIData huntingZoneData;

	class'UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);

	if (huntingZoneData.nMinLevel != 0 && huntingZoneData.nMinLevel != 0)
	addStr = "[Lv." $ huntingZoneData.nMinLevel $ "~"$ huntingZoneData.nMaxLevel $"] ";

	return addStr;

}

delegate int OnSortCompare( MapListInfo a, MapListInfo b )
{
    if (a.sortingKey > b.sortingKey) // 오름 차순. 조건문에 < 이면 내림차순.
    {
        return -1;  // 자리를 바꿔야할때 -1를 리턴 하게 함.
    }
    else
    {
        return 0;
    }
}

delegate int OnSortCompareForRaid( RaidUIData a, RaidUIData b )
{
    if (a.sortingKey > b.sortingKey) // 오름 차순. 조건문에 < 이면 내림차순.
    {
        return -1;  // 자리를 바꿔야할때 -1를 리턴 하게 함.
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

	//Debug("myInfo.nSubClass" @ myInfo.nSubClass);
	//Debug("myInfo.Class" @ myInfo.Class);
	//Debug("myInfo.Class" @ myInfo.nClassID);
	//Debug("myInfo.name" @ myInfo.name);

	// Debug(" addQuestList nClassID" @ nClassID);
	
	findRecommandQuest();
}

function Color questStateColor(int nState)
{
	if (nState == QuestStatus_Done)
		return getColor(182, 182, 182, 255); // 완료
	else if (nState == QuestStatus_Doing)
		return getColor(255, 221, 102, 255); // 진행중

	// 평싱시 
	return getColor(170, 153, 119, 255);	
	
}

//퀘스트 리스트를 추가
function insertListQuestInfo(int QuestID)
{
	//local int		QuestID;
	local string	QuestName;
	//local string	QuestRequirement;
	//local string	QuestLevel;
	local int		QuestType;
	//local string	QuestNpcName;
	//local string	QuestDecription;
	
	local string levelText, questCompleteStr;

	local int MinLevel, MaxLevel;
    local int QuestState;

	local bool bQuestDoing;
	
	local LVDataRecord	record;
	
	QuestName = class'UIDATA_QUEST'.static.GetQuestName(QuestID);
	QuestType = class'UIDATA_QUEST'.static.GetQuestType(QuestID, 1);
	
	// 퀘스트 진행중인가?
	bQuestDoing = class'UIDATA_QUEST'.static.IsDoingQuest(QuestID); //questTreenWndScript.isQuestIDSearch(QuestID);

	// 퀘스트 완료 표기
	if(class'UIDATA_QUEST'.static.IsClearedQuest(QuestID))
	{
		// 반복성
		if(bQuestDoing && (QuestType == 0 || QuestType == 2))
		{
			// 반복 퀘스트가 진행 중이고, 완료가 되었으면 진행 중 표시 하지 않고 일반으로 표시
			QuestState = QuestStatus_None;
		}
		else
		{
			// 완료시 
			QuestState = QuestStatus_Done;
			questCompleteStr = "["$ GetSystemString(898) $ "] ";
		}
	}
	else
	{
		if (bQuestDoing)
		{
			// 진행중 
			QuestState = QuestStatus_Doing;
			questCompleteStr = "["$ GetSystemString(829) $ "] ";
		}
		else
		{
			// 평상시
			QuestState = QuestStatus_None;
		}
	}
	
	//Debug("------------------------------------------");
	//Debug("QuestName" @ QuestName);
	//Debug("QuestID" @ QuestID);
	//Debug("QuestType " @ QuestType);
	//Debug("bQuestDoing " @ bQuestDoing);
	//Debug("questCompleteStr " @ questCompleteStr);

	MinLevel = class'UIDATA_QUEST'.static.GetMinLevel( QuestID, 1 );
	MaxLevel = class'UIDATA_QUEST'.static.GetMaxLevel( QuestID, 1 );
	if ( MaxLevel > 0 && MinLevel > 0)
		levelText =  MinLevel $ "~" $ MaxLevel;
	else if ( MinLevel > 0 )
		levelText =  MinLevel $ " " $ GetSystemString(859);
	else
		levelText = GetSystemString(866);

	record.LVDataList.Length = 3;
	
	//record.szReserved = QuestName;


	record.LVDataList[0].szData = questCompleteStr $ QuestName; //퀘스트 이름
	record.LVDataList[0].buseTextColor = True;
	record.LVDataList[0].TextColor = questStateColor(QuestState);

	record.LVDataList[1].szData = levelText;			//레벨대
	record.LVDataList[1].buseTextColor = True;
	record.LVDataList[1].TextColor = questStateColor(QuestState);

	

	record.LVDataList[2].nTextureWidth = 16;
	record.LVDataList[2].nTextureHeight = 16;
	switch( QuestType )
	{
		case 0:
		case 2:
			record.LVDataList[2].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_1";
			record.LVDataList[2].szData = GetSystemString( 861 );  //반복성
			break;
		case 1:
		case 3:
			record.LVDataList[2].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_2";
			record.LVDataList[2].szData = GetSystemString( 862 ); // 일회성 퀘스트
			break;

		case 4:		
			//Debug("일일 파티");		
		case 5:
			record.LVDataList[2].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_3";
			record.LVDataList[2].szData = GetSystemString( 2788 ); // "일일퀘스트"
			//Debug("일일 솔로");
			break;
	}
	record.LVDataList[2].nReserved1 = QuestType;//반복성

	ParamAdd(record.szReserved, "QuestName", QuestName);
	ParamAdd(record.szReserved, "LevelText", levelText);
	ParamAdd(record.szReserved, "QuestTypeText", record.LVDataList[2].szData);
	
	//record.LVDataList[4].szData = QuestNpcName;		/의뢰자
	//record.szReserved = QuestDecription;				//설명
	record.nReserved1 = QuestID;
	
	QuestInfo_ListCtrl.InsertRecord(record);

	//Debug("record.szReserved" @ record.szReserved);
}

function QuestRecommandData getQuestRecommandData(int questID, int categoryID, int priority)
{
	local QuestRecommandData questRecommandData;

	questRecommandData.questID    = questID;
	questRecommandData.priority   = priority;
	questRecommandData.categoryID = categoryID;

	return questRecommandData;	
}

// 퀘스트 추천 추가
function findRecommandQuest( )
{
	local String questName;
	local int questType, questID, questCategoryID, questPriority, maxLevel, minLevel; //i;, questIDForStartCondition;

	local UserInfo userInfo;

	local bool bClearedQuest;

	local QuestRecommandData questData;
	local array<QuestCategoryArrayData> categoryArr;

	local int i, m;

	GetPlayerInfo(userInfo);

	// 일단 목록 전체 삭제
	QuestInfo_ListCtrl.DeleteAllItem();

	// 퀘스트 검색	
	for( questID = class'UIDATA_QUEST'.static.GetFirstID(); -1 != questID ; questID = class'UIDATA_QUEST'.static.GetNextID() )
	{
		questName = class'UIDATA_QUEST'.static.GetQuestName(questID);
		questType = class'UIDATA_QUEST'.static.GetQuestType(questID, 1);

		questCategoryID = class'UIDATA_QUEST'.static.GetQuestCategoryID(questID, 1);
		questPriority   = class'UIDATA_QUEST'.static.GetQuestPriority(questID, 1);

		maxLevel = class'UIDATA_QUEST'.static.GetMaxLevel(questID, 1);
		minLevel = class'UIDATA_QUEST'.static.GetMinLevel(questID, 1);
		
		//if(minLevel == 0)
		//{
		//	Debug("-----------------------------------------------------------------");
		//	Debug("questName : " @questName);
		//	Debug("questID : " @questID);
		//	Debug("questType : " @questType);
		//	Debug("questCategoryID : " @questCategoryID);
		//	Debug("questPriority : " @questPriority);
		//	Debug("maxLevel : " @maxLevel);
		//	Debug("minLevel : " @minLevel);
		//}

		questData.categoryID = questCategoryID;
		questData.priority   = questPriority;
		questData.questID    = questID;
		
		// 추천하지 않는 거면 다음으로
		if (questPriority == 0) continue;
		else if (questPriority == -1)
		{			
			// -1 은 +5레벨만 보여주는 제한이 없이, 현재 레벨보다 높으면 다 보여줌.
			if (userInfo.nLevel >= minLevel)
				questPriority = 100;
			else continue;
		}
		else 
		{
			// questPriority가 양수 이면..
			if (questPriority > 0)
			{
				// minLevel == 0 과 같다면 무조건 추가
				if (minLevel != 0) 
				{
					if (userInfo.nLevel >= minLevel && userInfo.nLevel <= minLevel + 5)	
					{
						// empty 
					}
					else continue;			
				}
			}
		}

		//if(class'UIDATA_QUEST'.static.IsDoingQuest(QuestID))

		// 플레이어가 받기 가능한 퀘스트 인가?
		if(class'UIDATA_QUEST'.static.IsAcceptableQuest(QuestID) == false)
		{
			//Debug("---IsAcceptableQuest---");
			//Debug("class'UIDATA_QUEST'.static.IsAcceptableQuest(QuestID) : " @ class'UIDATA_QUEST'.static.IsAcceptableQuest(QuestID));
			//Debug("questName : " @questName);

			// 추가 안함.
			if(class'UIDATA_QUEST'.static.IsDoingQuest(QuestID) == false) continue;
		}

		//Debug("nClassID" @ nClassID);
		//Debug("IsClassLimitContains:" @ class'UIDATA_QUEST'.static.IsClassLimitContains(QuestID, nClassID));

		//// 퀘스트 수행이 가능한 클래스인가?
		//if(class'UIDATA_QUEST'.static.IsClassLimitContains(QuestID, nClassID) == false)
		//{
		//	// 아니면 추가 안함.
		//	continue;
		//}

		//// --- 퀘스트 시작 조건, 수행 조건 필터
		//questIDForStartCondition = class'UIDATA_QUEST'.static.GetClearedQuest(QuestID, 1);

		//// Debug("questIDForStartCondition" @ questIDForStartCondition);
		//if (questIDForStartCondition > 0)
		//{
		//	bClearedQuest = class'UIDATA_QUEST'.static.IsClearedQuest(questIDForStartCondition);

		//	// Debug("bClearedQuest" @ bClearedQuest);

		//	// 퀘스트 수행 조건, 퀘스트가 완료 안되었다면
		//	if(bClearedQuest == false)
		//	{				
		//		continue; // 퀘스트 추가 안함.
		//	}
		//}

		// --- 퀘스트 완료 시 조건 필터 
		bClearedQuest = class'UIDATA_QUEST'.static.IsClearedQuest(QuestID);
		// 완료 되었다면..
		if(bClearedQuest)
		{
			// 1회성 타입
			// 완료 되어도 목록에 추가 안함 (리스트 제외)
			if (questType == 1 || questType ==3)
			{
				continue; // 퀘스트 추가 안함.
			}
		}

		// 카테고리 ID 는 최대 99999, 의미는 없지만 일단 그렇다고 해둠.
		// questPriority 는 최대 999
		//Debug("-----------------------------------------------------------------");
		//Debug("questName : " @questName);
		//Debug("questID : " @questID);

		addCategoryArrQuestID(categoryArr, questData);
	}

	//Debug("categoryArr.Length :: " @ categoryArr.Length);

	for(i = 0; i < categoryArr.Length; i++)
	{
		//Debug("---------------");
		//Debug("categoryArr[i].categoryID    :" @ categoryArr[i].categoryID);
		//Debug("categoryArr[i].questRecommandData_Array : " @ categoryArr[i].questRecommandData_Array.Length);
 
		// 1개 이상 퀘스트가 카테고리배열안에 있다면.. 정렬
		if (categoryArr[i].questRecommandData_Array.Length > 1)
		{
			categoryArr[i].questRecommandData_Array.Sort(OnSortCompareQuestPriority);
		}

		// 가장 우선도 높은 첫번째 퀘스트만 추천으로 보여줌.
		if (categoryArr[i].questRecommandData_Array.Length > 0)
		{
			//insertListQuestInfo(categoryArr[i].questRecommandData_Array[0].questID);

			for(m = 0; m < categoryArr[i].questRecommandData_Array.Length; m++)
			{
				// 가장 높은 값으로 같은 Priority 값이있다면 다 보여주기
				if (categoryArr[i].questRecommandData_Array[0].priority == categoryArr[i].questRecommandData_Array[m].priority)
				{
					insertListQuestInfo(categoryArr[i].questRecommandData_Array[m].questID);
				}
			}
		}

		// -  데이타 확인용 코드 
		//Debug("**** 카테고리 ID : " @ categoryArr[i].categoryID);
		//for (m = 0; m < categoryArr[i].questRecommandData_Array.Length; m++)
		//{
		//	Debug(" - 퀘스트 이름     : " @ class'UIDATA_QUEST'.static.GetQuestName(categoryArr[i].questRecommandData_Array[m].questID));
		//	Debug(" - 퀘스트 priority : " @ categoryArr[i].questRecommandData_Array[m].priority);
		//	Debug(" - 퀘스트 questID  : " @ categoryArr[i].questRecommandData_Array[m].questID);
		//}
	}
}

function addCategoryArrQuestID(out array<QuestCategoryArrayData> categoryArr, QuestRecommandData questData )
{
	local int i;
	local QuestCategoryArrayData newCategoryArrData;

	for (i = 0; i < categoryArr.Length; i++)
	{
		if (categoryArr[i].categoryID == questData.categoryID)
		{
			categoryArr[i].questRecommandData_Array[categoryArr[i].questRecommandData_Array.Length] = questData;
			return; 
		}
	}

	// 새로운 카테고리면..
	newCategoryArrData.categoryID = questData.categoryID;
	newCategoryArrData.questRecommandData_Array[newCategoryArrData.questRecommandData_Array.Length] = questData;

	categoryArr[categoryArr.Length] = newCategoryArrData;
}

delegate int OnSortCompareQuestPriority( QuestRecommandData a, QuestRecommandData b )
{
    if (a.priority < b.priority) // 조건문에 < 이면 내림차순.
    {
        return -1;  // 자리를 바꿔야할때 -1를 리턴 하게 함.
    }
	//else   if (a.priority == b.priority)
	//{
	//	a.categoryID
	//}
    else
    {
        return 0;
    }
}

// "?" 퀘스트 설명 툴팁 
function InitQuestTooltip()
{
	//Custom Tooltip
	local CustomTooltip TooltipInfo;
		
	TooltipInfo.DrawList.length = 6;
	
	TooltipInfo.DrawList[0].eType = DIT_TEXTURE;
	TooltipInfo.DrawList[0].u_nTextureWidth = 16;
	TooltipInfo.DrawList[0].u_nTextureHeight = 16;
	TooltipInfo.DrawList[0].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_1";
	
	TooltipInfo.DrawList[1].eType = DIT_TEXT;
	TooltipInfo.DrawList[1].nOffSetX = 5;
	TooltipInfo.DrawList[1].t_bDrawOneLine = true;
	TooltipInfo.DrawList[1].t_strText = GetSystemString( 861 ); //무한반복 퀘스트
	
	TooltipInfo.DrawList[2].eType = DIT_TEXTURE;
	TooltipInfo.DrawList[2].nOffSetY = 2;
	TooltipInfo.DrawList[2].u_nTextureWidth = 16;
	TooltipInfo.DrawList[2].u_nTextureHeight = 16;
	TooltipInfo.DrawList[2].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_2";
	TooltipInfo.DrawList[2].bLineBreak = true;
	
	TooltipInfo.DrawList[3].eType = DIT_TEXT;
	TooltipInfo.DrawList[3].nOffSetY = 2;
	TooltipInfo.DrawList[3].nOffSetX = 5;
	TooltipInfo.DrawList[3].t_bDrawOneLine = true;
	TooltipInfo.DrawList[3].t_strText = GetSystemString( 862 ); // 일회성 퀘스트

	TooltipInfo.DrawList[4].eType = DIT_TEXTURE;
	TooltipInfo.DrawList[4].nOffSetY = 2;
	TooltipInfo.DrawList[4].u_nTextureWidth = 16;
	TooltipInfo.DrawList[4].u_nTextureHeight = 16;
	TooltipInfo.DrawList[4].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_3";
	TooltipInfo.DrawList[4].bLineBreak = true;
	
	TooltipInfo.DrawList[5].eType = DIT_TEXT;
	TooltipInfo.DrawList[5].nOffSetY = 2;
	TooltipInfo.DrawList[5].nOffSetX = 5;
	TooltipInfo.DrawList[5].t_bDrawOneLine = true;
	TooltipInfo.DrawList[5].t_strText = GetSystemString( 2788 ); // "일일퀘스트"
	
	QuestTooltip.SetTooltipCustomType(TooltipInfo);
}

**/

defaultproperties
{
}
