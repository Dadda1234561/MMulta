class TeleportWnd extends UICommonAPI;

const TELEPORT_FAVORITES_MAX = 50;

enum ETeleportListType 
{
	Normal,
	Favorites,
	Special,
	Searching
};

enum ETeleportFavoritesSortType 
{
	Latest,
	Oldest,
	NameAscending,
	NameDescending,
	LevelAscending,
	LevelDescending,
	Max
};

struct TeleportInfo
{
	var string Name;
	var int Id;
	var int TownID;
	var int DominionID;
	var int locX;
	var int locY;
	var int Type;
	var int Level;
	var int Priority;
	var array<RequestItem> Price;
	var int UsableLevel;
	var int UsableTransferDegree;
	var int ServerRange;
	var bool isTown;
	var bool isSpecial;
	var bool isWorldServer;
};

struct TeleportTownInfo
{
	var TeleportInfo townInfo;
	var array<TeleportInfo> dominions;
};

struct TeleportUIStateInfo
{
	var ETeleportFavoritesSortType sortType;
	var ETeleportListType listType;
	var ETeleportListType recentlyListType;
	var string searchStr;
};

var array<TeleportInfo> _teleportTotalList;
var array<TeleportTownInfo> _teleportTownList;
var array<TeleportInfo> _specialTeleportList;
var array<int> _favoritesTeleportIds;
var TeleportUIStateInfo _teleportUIStateInfo;
var int _tempTeleportId;
var int _priceRacio;
var WindowHandle Me;
var WindowHandle searchWnd;
var WindowHandle modalWnd;
var WindowHandle specialTypeContiner;
var WindowHandle normalTypeContainer;
var WindowHandle favoritesTypeContainer;
var WindowHandle searchingTypeContainer;
var WindowHandle listDisableContainer;
var TextBoxHandle listDisableTextBox;
var ButtonHandle searchBtn;
var ButtonHandle favoritesTabBtn;
var ButtonHandle specialTabBtn;
var ButtonHandle teleportBtn;
var ButtonHandle favoritesSortBtn;
var RichListCtrlHandle townRichList;
var RichListCtrlHandle dominionRichList;
var UIControlDialogAssets teleportDialog;
var UIControlTextInput searchTextInput;

static function TeleportWnd Inst()
{
	return TeleportWnd(GetScript("TeleportWnd"));	
}

function Initialize()
{
	InitTelpoListData();
	initControls();	
}

function initControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	searchWnd = GetWindowHandle(ownerFullPath $ ".ItemFind_Wnd");
	modalWnd = GetWindowHandle(ownerFullPath $ ".WindowDisable_Wnd");
	teleportDialog = class'UIControlDialogAssets'.static.InitScript(GetWindowHandle(modalWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset"));
	teleportDialog.SetDisableWindow(modalWnd);
	favoritesTabBtn = GetButtonHandle(ownerFullPath $ ".FavoritesView_Btn");
	specialTabBtn = GetButtonHandle(ownerFullPath $ ".SpecialView_Btn");
	searchBtn = GetButtonHandle(ownerFullPath $ ".BtnFind");
	teleportBtn = GetButtonHandle(ownerFullPath $ ".Teleport_Btn");
	favoritesSortBtn = GetButtonHandle(ownerFullPath $ ".FavoritesSort_btn");
	townRichList = GetRichListCtrlHandle(ownerFullPath $ ".TownZone_ListCtrl");
	dominionRichList = GetRichListCtrlHandle(ownerFullPath $ ".HuntingZone_ListCtrl");
	townRichList.SetTooltipType("TeleportWndListTooltip");
	dominionRichList.SetTooltipType("TeleportWndListTooltip");
	townRichList.SetSelectedSelTooltip(false);
	townRichList.SetAppearTooltipAtMouseX(true);
	dominionRichList.SetSelectedSelTooltip(false);
	dominionRichList.SetAppearTooltipAtMouseX(true);
	dominionRichList.SetUseStripeBackTexture(false);
	listDisableContainer = GetWindowHandle(ownerFullPath $ ".FindDisable_Wnd");
	listDisableTextBox = GetTextBoxHandle(listDisableContainer.m_WindowNameWithFullPath $ ".Disable_Text");
	specialTypeContiner = GetWindowHandle(ownerFullPath $ ".SpecialViewBG_GroupBoxWnd");
	normalTypeContainer = GetWindowHandle(ownerFullPath $ ".HuntingViewBG_GroupBoxWnd");
	favoritesTypeContainer = GetWindowHandle(ownerFullPath $ ".FavoritesViewBG_GroupBoxWnd");
	searchingTypeContainer = GetWindowHandle(ownerFullPath $ ".FindViewBG_GroupBoxWnd");
	searchTextInput = class'UIControlTextInput'.static.InitScript(GetWindowHandle(ownerFullPath $ ".TextInput"));
	searchTextInput.DelegateOnClear = OnSearchTextInputClear;
	searchTextInput.DelegateOnCompleteEditBox = OnSearchTextInputCompleted;
	searchTextInput.SetDisable(false);
	searchTextInput.SetEdtiable(true);
	searchTextInput.SetDefaultString(GetSystemString(2507));
	townRichList.SetEnableInteractionPass(false);
	dominionRichList.SetEnableInteractionPass(false);	
}

function InitTelpoListData()
{
	local TeleportTownInfo tempTownInfo;
	local TeleportInfo tempTownTelInfo, tempDominionTelInfo;
	local TeleportListAPI.TeleportListData TeleportInfo;
	local int i, j;

	_teleportTownList.Length = 0;
	TeleportInfo = class'TeleportListAPI'.static.GetFirstTeleportListData();

	// End:0x6E [Loop If]
	while("" != TeleportInfo.Name)
	{
		// End:0x56
		if(TeleportInfo.Priority >= 0)
		{
			_teleportTotalList[_teleportTotalList.Length] = MakeTeleportInfo(TeleportInfo);
		}
		TeleportInfo = class'TeleportListAPI'.static.GetNextTeleportListData();
	}

	// End:0x15A [Loop If]
	for(i = 0; i < _teleportTotalList.Length; i++)
	{
		tempTownTelInfo = _teleportTotalList[i];
		// End:0x150
		if(tempTownTelInfo.isTown == true)
		{
			tempTownInfo.townInfo = tempTownTelInfo;
			tempTownInfo.dominions.Length = 0;

			// End:0x13E [Loop If]
			for(j = 0; j < _teleportTotalList.Length; j++)
			{
				tempDominionTelInfo = _teleportTotalList[j];
				// End:0x134
				if(tempDominionTelInfo.isTown == false && tempDominionTelInfo.TownID == tempTownTelInfo.TownID)
				{
					tempTownInfo.dominions[tempTownInfo.dominions.Length] = tempDominionTelInfo;
				}
			}
			_teleportTownList[_teleportTownList.Length] = tempTownInfo;
		}

	}	
}

function UpdateSpecialTeleportList()
{
	local int i, classTransferDegree;
	local TeleportInfo tempTeleportInfo;
	local UserInfo UserInfo;

	_specialTeleportList.Length = 0;
	// End:0x1B
	if((GetPlayerInfo(UserInfo)) == false)
	{
		return;
	}
	classTransferDegree = GetClassTransferDegree(UserInfo.nClassID);
	searchTextInput.inputTextBox.ClearAdditionalSearchList(SLT_ADDITIONAL_LIST);

	// End:0x117 [Loop If]
	for(i = 0; i < _teleportTotalList.Length; i++)
	{
		tempTeleportInfo = _teleportTotalList[i];
		// End:0xE9
		if(tempTeleportInfo.isSpecial)
		{
			// End:0xE6
			if((classTransferDegree >= tempTeleportInfo.UsableTransferDegree) && UserInfo.nLevel >= tempTeleportInfo.UsableLevel)
			{
				_specialTeleportList[_specialTeleportList.Length] = tempTeleportInfo;
				searchTextInput.inputTextBox.AddNameToAdditionalSearchList(tempTeleportInfo.Name, SLT_ADDITIONAL_LIST);
			}
			// [Explicit Continue]
			continue;
		}
		searchTextInput.inputTextBox.AddNameToAdditionalSearchList(tempTeleportInfo.Name, SLT_ADDITIONAL_LIST);
	}
	// End:0x16D
	if(_specialTeleportList.Length > 0)
	{
		specialTabBtn.ShowWindow();
		townRichList.AdjustShowRow(12);
		townRichList.SetContentsHeight(31);
		townRichList.SetWindowSize(202, 372);		
	}
	else
	{
		specialTabBtn.HideWindow();
		townRichList.AdjustShowRow(13);
		townRichList.SetContentsHeight(32);
		townRichList.SetWindowSize(202, 416);
	}	
}

function UpdateFavoritesButtonLabel()
{
	local string favoritesStr, countStr;

	favoritesStr = GetSystemString(379);
	countStr = "(" $ string(_favoritesTeleportIds.Length) $ "/" $ string(TELEPORT_FAVORITES_MAX) $ ")";
	favoritesTabBtn.SetNameText(favoritesStr @ countStr);	
}

function TeleportInfo MakeTeleportInfo(TeleportListAPI.TeleportListData teleportData)
{
	local TeleportInfo Result;

	Result.Name = teleportData.Name;
	Result.Id = teleportData.Id;
	Result.TownID = teleportData.TownID;
	Result.DominionID = teleportData.DominionID;
	Result.locX = teleportData.locX;
	Result.locY = teleportData.locY;
	Result.Level = teleportData.Level;
	Result.Price = teleportData.Price;
	Result.UsableLevel = teleportData.UsableLevel;
	Result.UsableTransferDegree = teleportData.UsableTransferDegree;
	// End:0x105
	if(teleportData.Priority == 1 || teleportData.Priority == 2)
	{
		Result.isTown = true;		
	}
	else
	{
		Result.isTown = false;
	}
	// End:0x144
	if(teleportData.UsableTransferDegree != 0 || teleportData.UsableLevel != 0)
	{
		Result.isSpecial = true;		
	}
	else
	{
		Result.isSpecial = false;
	}
	// End:0x171
	if(teleportData.ServerRange == 1)
	{
		Result.isWorldServer = true;		
	}
	else
	{
		Result.isWorldServer = false;
	}
	return Result;	
}

function INT64 GetTeleportCost(INT64 cost, int UsableLevel, int UsableTransferDegree)
{
	local INT64 teleportCost;
	local bool isSpecialTeleport, isFreeLevel;

	isFreeLevel = class'UIData'.static.Inst().IsTeleportFreeLevel();
	// End:0x4E
	if(_priceRacio > 0)
	{
		teleportCost = (cost * 100 - _priceRacio) / 100;		
	}
	else
	{
		teleportCost = cost;
	}
	isSpecialTeleport = UsableLevel > 0 || UsableTransferDegree > 0;
	// End:0xAC
	if(GetLanguage() == LANG_Korean)
	{
		// End:0xA9
		if(isSpecialTeleport == false && isFreeLevel == true)
		{
			teleportCost = 0;
		}		
	}
	else
	{
		// End:0xC1
		if(isFreeLevel == true)
		{
			teleportCost = 0;
		}
	}
	return teleportCost;	
}

function int GetTeleportFavoritesListIndex(int TeleportID)
{
	local int i, favoritesId;

	// End:0x47 [Loop If]
	for(i = 0; i < _favoritesTeleportIds.Length; i++)
	{
		favoritesId = _favoritesTeleportIds[i];
		// End:0x3D
		if(favoritesId == TeleportID)
		{
			return i;
		}
	}
	return -1;	
}

function bool IsTeleportFavorites(int TeleportID)
{
	// End:0x13
	if(GetTeleportFavoritesListIndex(TeleportID) >= 0)
	{
		return true;
	}
	return false;	
}

function AddTeleportFavorites(int TeleportID)
{
	// End:0x23
	if(IsTeleportFavorites(TeleportID) == false)
	{
		_favoritesTeleportIds[_favoritesTeleportIds.Length] = TeleportID;
	}	
}

function RemoveTeleportFavorites(int TeleportID)
{
	local int Index;

	Index = GetTeleportFavoritesListIndex(TeleportID);
	// End:0x28
	if(Index >= 0)
	{
		_favoritesTeleportIds.Remove(Index, 1);
	}	
}

function UpdateTownListControls()
{
	local TeleportInfo tempTeleportInfo;
	local RichListCtrlRowData RowData;
	local Color NameColor;
	local L2Util util;
	local int i, recordCnt, deleteIndex;
	local bool isFavorites;

	RowData.cellDataList.Length = 3;
	recordCnt = townRichList.GetRecordCount();
	util = L2Util(GetScript("L2Util"));
	NameColor = util.ColorGold;
	deleteIndex = 0;

	// End:0x3E8 [Loop If]
	for(i = 0; i < Max(_teleportTownList.Length, recordCnt); i++)
	{
		// End:0x3B9
		if(i < _teleportTownList.Length)
		{
			tempTeleportInfo = _teleportTownList[i].townInfo;
			RowData.cellDataList[0].drawitems.Length = 0;
			RowData.cellDataList[1].drawitems.Length = 0;
			RowData.cellDataList[2].drawitems.Length = 0;
			RowData.nReserved1 = tempTeleportInfo.Id;
			RowData.nReserved2 = tempTeleportInfo.TownID;
			isFavorites = IsTeleportFavorites(tempTeleportInfo.Id);
			RowData.nReserved3 = int(isFavorites);
			addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.HtmlWnd.BTN_Icon_Teleport", 12, 12, 4);
			addRichListCtrlString(RowData.cellDataList[1].drawitems, tempTeleportInfo.Name, NameColor, false);
			// End:0x28D
			if(isFavorites)
			{
				addRichListCtrlButton(RowData.cellDataList[2].drawitems, "listFavoritesBtn_" @ string(tempTeleportInfo.Id), 0, 0, "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", 19, 18, 19, 18, int(isFavorites));				
			}
			else
			{
				addRichListCtrlButton(RowData.cellDataList[2].drawitems, "listFavoritesBtn_" @ string(tempTeleportInfo.Id), 0, 0, "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", 19, 18, 19, 18, int(isFavorites));
			}
			// End:0x3A2
			if(i < recordCnt)
			{
				townRichList.ModifyRecord(i, RowData);				
			}
			else
			{
				townRichList.InsertRecord(RowData);
			}
			// [Explicit Continue]
			continue;
		}
		townRichList.DeleteRecord((recordCnt - deleteIndex) - 1);
		deleteIndex++;
	}
}

function UpdateDominionListControls()
{
	local int selectedTownIndex, TownID, i;
	local array<TeleportInfo> dominionList;
	local RichListCtrlRowData selectedData, RowData;
	local TeleportInfo tempTeleportInfo;
	local int recordCnt, deleteIndex, iconOffsetY, costStrWidth, costStrHeight;

	local L2Util util;
	local string zoneIconPath, costIconPath, levelStr, costStr;
	local Color NameColor;
	local bool isFavorites;

	selectedTownIndex = townRichList.GetSelectedIndex();
	util = L2Util(GetScript("L2Util"));
	// End:0xEA
	if(_teleportUIStateInfo.listType == ETeleportListType.Normal)
	{
		listDisableTextBox.SetText(GetSystemString(14186));
		// End:0xE7
		if(selectedTownIndex >= 0)
		{
			townRichList.GetSelectedRec(selectedData);
			TownID = int(selectedData.nReserved2);

			// End:0xE7 [Loop If]
			for(i = 0; i < _teleportTownList.Length; i++)
			{
				// End:0xDD
				if(_teleportTownList[i].townInfo.TownID == TownID)
				{
					dominionList = _teleportTownList[i].dominions;
					// [Explicit Break]
					break;
				}
			}
		}		
	}
	else if(_teleportUIStateInfo.listType == ETeleportListType.Special)
	{
		dominionList = _specialTeleportList;			
	}
	else if(_teleportUIStateInfo.listType == ETeleportListType.Favorites)
	{
		listDisableTextBox.SetText(GetSystemString(14185));
		dominionList = GetTeleportFavoritesList(_teleportUIStateInfo.sortType);				
	}
	else if(_teleportUIStateInfo.listType == ETeleportListType.Searching)
	{
		listDisableTextBox.SetText(GetSystemString(14184));
		dominionList = GetTeleportSearchingList(_teleportUIStateInfo.searchStr);
	}

	RowData.cellDataList.Length = 3;
	recordCnt = dominionRichList.GetRecordCount();
	deleteIndex = 0;

	// End:0x82E [Loop If]
	for(i = 0; i < Max(dominionList.Length, recordCnt); i++)
	{
		// End:0x7FF
		if(i < dominionList.Length)
		{
			tempTeleportInfo = dominionList[i];
			RowData.cellDataList[0].drawitems.Length = 0;
			RowData.cellDataList[1].drawitems.Length = 0;
			RowData.cellDataList[2].drawitems.Length = 0;
			RowData.nReserved1 = tempTeleportInfo.Id;
			RowData.nReserved2 = tempTeleportInfo.DominionID;
			isFavorites = IsTeleportFavorites(tempTeleportInfo.Id);
			RowData.nReserved3 = int(isFavorites);
			NameColor = util.White;
			iconOffsetY = -14;
			// End:0x31D
			if(tempTeleportInfo.isSpecial)
			{
				zoneIconPath = "L2UI_NewTex.TeleportWnd.TeleporMap_LVHuntingIcon_Normal";
				NameColor = util.VIOLET01;				
			}
			else if(tempTeleportInfo.isWorldServer)
			{
				zoneIconPath = "L2UI_NewTex.TeleportWnd.Teleport_World";					
			}
			else if(tempTeleportInfo.isTown)
			{
				zoneIconPath = "L2UI_CT1.HtmlWnd.BTN_Icon_Teleport";
				iconOffsetY = -17;						
			}
			else
			{
				zoneIconPath = "L2UI_NewTex.TeleportWnd.TeleporMap_HuntingIcon_Normal";
			}

			// End:0x424
			if(tempTeleportInfo.Price[0].Id == 57)
			{
				costIconPath = "L2UI_CT1.Icon.Icon_DF_Common_Adena";				
			}
			else
			{
				costIconPath = "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin";
			}
			// End:0x484
			if(tempTeleportInfo.Level > 0)
			{
				levelStr = "Lv" @ string(tempTeleportInfo.Level);				
			}
			else
			{
				levelStr = "";
			}
			costStr = MakeCostStringINT64(GetTeleportCost(tempTeleportInfo.Price[0].Amount, tempTeleportInfo.UsableLevel, tempTeleportInfo.UsableTransferDegree));
			GetTextSizeDefault(costStr, costStrWidth, costStrHeight);
			addRichListCtrlTexture(RowData.cellDataList[0].drawitems, zoneIconPath, 12, 12, 2, iconOffsetY);
			addRichListCtrlString(RowData.cellDataList[1].drawitems, tempTeleportInfo.Name, NameColor, false, 0, 4);
			addRichListCtrlString(RowData.cellDataList[1].drawitems, "", util.White, true);
			addRichListCtrlTexture(RowData.cellDataList[1].drawitems, costIconPath, 20, 15, 222, 6);
			addRichListCtrlString(RowData.cellDataList[1].drawitems, costStr, util.ColorGold, true, 218 - costStrWidth, -15);
			addRichListCtrlString(RowData.cellDataList[1].drawitems, levelStr, util.ColorGold, true, 6, -14);
			// End:0x6D3
			if(isFavorites)
			{
				addRichListCtrlButton(RowData.cellDataList[2].drawitems, "listFavoritesBtn_" @ string(tempTeleportInfo.Id), 0, 0, "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_On", 19, 18, 19, 18, int(isFavorites));				
			}
			else
			{
				addRichListCtrlButton(RowData.cellDataList[2].drawitems, "listFavoritesBtn_" @ string(tempTeleportInfo.Id), 0, 0, "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", "L2UI_NewTex.TeleportWnd.TeleportMap_FavoriteBtn_Off", 19, 18, 19, 18, int(isFavorites));
			}
			// End:0x7E8
			if(i < recordCnt)
			{
				dominionRichList.ModifyRecord(i, RowData);				
			}
			else
			{
				dominionRichList.InsertRecord(RowData);
			}
			// [Explicit Continue]
			continue;
		}
		dominionRichList.DeleteRecord((recordCnt - deleteIndex) - 1);
		deleteIndex++;
	}
	// End:0x84C
	if(dominionList.Length == 0)
	{
		listDisableContainer.ShowWindow();		
	}
	else
	{
		listDisableContainer.HideWindow();
	}
}

function SetCurrentZoneListSelected(optional bool setNormaTab)
{
	local int townListIndex, dominionListIndex;
	local string teleportName;

	teleportName = GetCurrentZoneName();
	GetListIndexByZoneName(teleportName, townListIndex, dominionListIndex);
	// End:0x5A
	if(setNormaTab == true || (_teleportUIStateInfo.listType == ETeleportListType.Special) && _specialTeleportList.Length == 0)
	{
		SetListUIState(ETeleportListType.Normal/*0*/);
	}
	townRichList.SetSelectedIndex(Max(townListIndex, 0), true);
	UpdateDominionListControls();
	// End:0xA2
	if(_teleportUIStateInfo.listType == ETeleportListType.Normal)
	{
		dominionRichList.SetSelectedIndex(dominionListIndex, true);
	}
	UpdateMapTownZoneIcons();
	UpdateMapDominionZoneIcons();	
}

function ScrollToTopDominionList()
{
	dominionRichList.SetSelectedIndex(0, true);
	dominionRichList.SetSelectedIndex(-1, false);
}

function UpdateListControls()
{
	UpdateFavoritesButtonLabel();
	UpdateTownListControls();
	UpdateDominionListControls();	
}

function UpdateUIContols()
{
	UpdateMapTownZoneIcons();
	UpdateMapDominionZoneIcons();
	UpdateListControls();	
}

function UpdateMapTownZoneIcons()
{
	class'TeleportWndMap'.static.Inst().UpdateTownZoneIcons();	
}

function UpdateMapDominionZoneIcons()
{
	class'TeleportWndMap'.static.Inst().UpdateDominionZoneIcons();	
}

function UnselectTownList()
{
	townRichList.SetSelectedIndex(-1, false);	
}

function UnselectDominionList()
{
	dominionRichList.SetSelectedIndex(-1, false);	
}

delegate int OnSortSearchingList(TeleportInfo A, TeleportInfo B)
{
	// End:0x4A
	if(A.isTown != B.isTown)
	{
		// End:0x44
		if(A.isTown == true && B.isTown == false)
		{
			return 0;			
		}
		else
		{
			return -1;
		}
	}
	// End:0x94
	if(A.isSpecial != B.isSpecial)
	{
		// End:0x8E
		if(A.isSpecial == false && B.isSpecial == true)
		{
			return 0;			
		}
		else
		{
			return -1;
		}
	}
	// End:0xB6
	if(A.Name > B.Name)
	{
		return -1;		
	}
	else
	{
		return 0;
	}	
}

delegate int OnSortByNameAscending(TeleportInfo A, TeleportInfo B)
{
	// End:0x22
	if(A.Name > B.Name)
	{
		return -1;		
	}
	else
	{
		return 0;
	}	
}

delegate int OnSortByNameDescending(TeleportInfo A, TeleportInfo B)
{
	// End:0x22
	if(A.Name < B.Name)
	{
		return -1;		
	}
	else
	{
		return 0;
	}	
}

delegate int OnSortByLevelAscending(TeleportInfo A, TeleportInfo B)
{
	// End:0x3D
	if(A.Level != B.Level)
	{
		// End:0x37
		if(A.Level > B.Level)
		{
			return 0;			
		}
		else
		{
			return -1;
		}
	}
	// End:0x5F
	if(A.Name > B.Name)
	{
		return -1;		
	}
	else
	{
		return 0;
	}	
}

delegate int OnSortByLevelDescending(TeleportInfo A, TeleportInfo B)
{
	// End:0x3D
	if(A.Level != B.Level)
	{
		// End:0x37
		if(A.Level < B.Level)
		{
			return 0;			
		}
		else
		{
			return -1;
		}
	}
	// End:0x5F
	if(A.Name > B.Name)
	{
		return -1;		
	}
	else
	{
		return 0;
	}	
}

function array<TeleportInfo> GetTeleportFavoritesList(ETeleportFavoritesSortType sortType)
{
	local int i;
	local array<TeleportInfo> favoritesList;

	// End:0x5B
	if(sortType == ETeleportFavoritesSortType.Latest/*0*/)
	{
		// End:0x52 [Loop If]
		for(i = _favoritesTeleportIds.Length - 1; i >= 0; i--)
		{
			favoritesList[favoritesList.Length] = GetTeleportInfo(_favoritesTeleportIds[i]);
		}
		return favoritesList;		
	}
	else
	{
		// End:0x9A [Loop If]
		for(i = 0; i < _favoritesTeleportIds.Length; i++)
		{
			favoritesList[favoritesList.Length] = GetTeleportInfo(_favoritesTeleportIds[i]);
		}
		// End:0xB0
		if(sortType == ETeleportFavoritesSortType.Oldest/*1*/)
		{
			return favoritesList;
		}
	}
	// End:0xCE
	if(sortType == ETeleportFavoritesSortType.NameAscending/*2*/)
	{
		favoritesList.Sort(OnSortByNameAscending);		
	}
	else if(sortType == ETeleportFavoritesSortType.NameDescending/*3*/)
	{
		favoritesList.Sort(OnSortByNameDescending);			
	}
	else if(sortType == ETeleportFavoritesSortType.LevelAscending/*4*/)
	{
		favoritesList.Sort(OnSortByLevelAscending);				
	}
	else if(sortType == ETeleportFavoritesSortType.LevelDescending/*5*/)
	{
		favoritesList.Sort(OnSortByLevelDescending);
	}
	return favoritesList;	
}

function array<TeleportInfo> GetTeleportSearchingList(string searchStr)
{
	local int i;
	local array<TeleportInfo> searchingList;
	local TeleportInfo tempTeleportInfo;
	local bool isShowSpecialTeleport;

	// End:0x14
	if(_specialTeleportList.Length > 0)
	{
		isShowSpecialTeleport = true;
	}

	// End:0x92 [Loop If]
	for(i = 0; i < _teleportTotalList.Length; i++)
	{
		tempTeleportInfo = _teleportTotalList[i];
		// End:0x5B
		if(isShowSpecialTeleport == false && tempTeleportInfo.isSpecial)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x88
		if(StringMatching(tempTeleportInfo.Name, searchStr, " "))
		{
			searchingList[searchingList.Length] = tempTeleportInfo;
		}
	}
	searchingList.Sort(OnSortSearchingList);
	return searchingList;	
}

function array<TeleportTownInfo> GetTeleportTownList()
{
	return _teleportTownList;	
}

function TeleportInfo GetTeleportInfo(int TeleportID)
{
	local int i;
	local TeleportInfo Info;

	// End:0x4C [Loop If]
	for(i = 0; i < _teleportTotalList.Length; i++)
	{
		Info = _teleportTotalList[i];
		// End:0x42
		if(Info.Id == TeleportID)
		{
			return Info;
		}
	}
	return Info;	
}

function TeleportTownInfo GetTownInfo(int TownID)
{
	local int i;
	local TeleportTownInfo Info;

	// End:0x51 [Loop If]
	for(i = 0; i < _teleportTownList.Length; i++)
	{
		Info = _teleportTownList[i];
		// End:0x47
		if(Info.townInfo.TownID == TownID)
		{
			return Info;
		}
	}
	return Info;	
}

function int GetSelectedTownID()
{
	local RichListCtrlRowData selectedData;

	// End:0x36
	if(townRichList.GetSelectedIndex() >= 0)
	{
		townRichList.GetSelectedRec(selectedData);
		return int(selectedData.nReserved2);
	}
	return -1;	
}

function int GetSelectedDominionTeleportID()
{
	local RichListCtrlRowData selectedData;

	// End:0x36
	if(dominionRichList.GetSelectedIndex() >= 0)
	{
		dominionRichList.GetSelectedRec(selectedData);
		return int(selectedData.nReserved1);
	}
	return -1;	
}

function bool GetListIndexByZoneName(string teleportName, out int outTownIndex, out int outDominionIndex)
{
	local int townIndex, dominionIndex;
	local TeleportTownInfo townInfo;

	// End:0xC3 [Loop If]
	for(townIndex = 0; townIndex < _teleportTownList.Length; townIndex++)
	{
		townInfo = _teleportTownList[townIndex];
		// End:0x5C
		if(townInfo.townInfo.Name == teleportName)
		{
			outTownIndex = townIndex;
			outDominionIndex = -1;
			return true;
			// [Explicit Continue]
			continue;
		}

		// End:0xB9 [Loop If]
		for(dominionIndex = 0; dominionIndex < townInfo.dominions.Length; dominionIndex++)
		{
			// End:0xAF
			if(townInfo.dominions[dominionIndex].Name == teleportName)
			{
				outTownIndex = townIndex;
				outDominionIndex = dominionIndex;
				return true;
			}
		}
	}
	outTownIndex = -1;
	outDominionIndex = -1;
	return false;	
}

function int GetSelectedTeleportID()
{
	local RichListCtrlRowData selectedData;
	local int SelectedIndex;

	SelectedIndex = dominionRichList.GetSelectedIndex();
	// End:0x5F
	if(SelectedIndex >= 0 && SelectedIndex < dominionRichList.GetRecordCount())
	{
		dominionRichList.GetSelectedRec(selectedData);
		return int(selectedData.nReserved1);		
	}
	else
	{
		// End:0x95
		if(townRichList.GetSelectedIndex() >= 0)
		{
			townRichList.GetSelectedRec(selectedData);
			return int(selectedData.nReserved1);
		}
	}
	return -1;	
}

function ShowTeleportDialog(INT64 TeleportID)
{
	local string Desc, teleportName;
	local TeleportInfo targetTeleport;
	local INT64 teleportCost;

	_tempTeleportId = int(TeleportID);
	targetTeleport = GetTeleportInfo(_tempTeleportId);
	// End:0x5F
	if(targetTeleport.Id == 0)
	{
		Debug("ShowTeleportDialog() invalid teleportId");
		return;
	}
	// End:0xA2
	if(targetTeleport.Level > 0)
	{
		teleportName = "(" $ targetTeleport.Name $ " Lv " $ string(targetTeleport.Level) $ ")";		
	}
	else
	{
		teleportName = "(" $ targetTeleport.Name $ ")";
	}
	Desc = GetSystemMessage(5239) $ "\\n\\n" $ teleportName;
	teleportDialog.SetDialogDesc(Desc);
	teleportDialog.SetUseNeedItem(true);
	teleportDialog.StartNeedItemList(1);
	teleportCost = GetTeleportCost(targetTeleport.Price[0].Amount, targetTeleport.UsableLevel, targetTeleport.UsableTransferDegree);
	// End:0x177
	if(targetTeleport.Price.Length > 0)
	{
		teleportDialog.AddNeedItemClassID(targetTeleport.Price[0].Id, teleportCost);
	}
	teleportDialog.SetItemNum(1);
	teleportDialog.Show();
	teleportDialog.DelegateOnClickBuy = OnTeleportDialogConfirm;
	teleportDialog.DelegateOnCancel = OnTeleportDialogCancel;	
}

function SetTownRichListScroll(bool bIncrease)
{
	// End:0x1C
	if(bIncrease)
	{
		townRichList.IncreaseStartRow(1);		
	}
	else
	{
		townRichList.DecreaseStartRow(1);
	}	
}

function SetDominionRichListScroll(bool bIncrease)
{
	// End:0x1C
	if(bIncrease)
	{
		dominionRichList.IncreaseStartRow(1);		
	}
	else
	{
		dominionRichList.DecreaseStartRow(1);
	}	
}

function SetListUIState(ETeleportListType listType)
{
	// End:0x43
	if(_teleportUIStateInfo.listType == ETeleportListType.Searching && listType != ETeleportListType.Searching/*3*/)
	{
		_teleportUIStateInfo.searchStr = "";
		searchTextInput.Clear();
	}
	// End:0x71
	if(listType == ETeleportListType.Special/*2*/ && _specialTeleportList.Length == 0)
	{
		_teleportUIStateInfo.listType = ETeleportListType.Normal;		
	}
	else
	{
		_teleportUIStateInfo.listType = listType;
	}
	favoritesTabBtn.SetEnable(true);
	specialTabBtn.SetEnable(true);
	specialTypeContiner.HideWindow();
	normalTypeContainer.HideWindow();
	favoritesTypeContainer.HideWindow();
	searchingTypeContainer.HideWindow();
	switch(_teleportUIStateInfo.listType)
	{
		// End:0x120
		case ETeleportListType.Favorites/*1*/:
			favoritesTabBtn.SetEnable(false);
			favoritesTypeContainer.ShowWindow();
			// End:0x188
			break;
		// End:0x147
		case ETeleportListType.Special/*2*/:
			specialTabBtn.SetEnable(false);
			specialTypeContiner.ShowWindow();
			// End:0x188
			break;
		// End:0x16E
		case ETeleportListType.Normal/*0*/:
			normalTypeContainer.ShowWindow();
			// End:0x188
			break;
		// End:0x185
		case ETeleportListType.Searching/*3*/:
			searchingTypeContainer.ShowWindow();
			// End:0x188
			break;
	}
}

function SetFavoritesSortBtnState(ETeleportFavoritesSortType sortType)
{
	local CustomTooltip toolTipInfo;
	local array<DrawItemInfo> drawListArr;
	local Color colorLatest, colorOldest, colorNameAscending, colorNameDescending, colorLevelAscending, colorLevelDescending;

	local L2Util util;
	local Color defaultTextColor;

	util = L2Util(GetScript("L2Util"));
	defaultTextColor.R = 153;
	defaultTextColor.G = 153;
	defaultTextColor.B = 153;
	defaultTextColor.A = 255;
	_teleportUIStateInfo.sortType = sortType;
	colorLatest = defaultTextColor;
	colorOldest = defaultTextColor;
	colorNameAscending = defaultTextColor;
	colorNameDescending = defaultTextColor;
	colorLevelAscending = defaultTextColor;
	colorLevelDescending = defaultTextColor;
	switch(sortType)
	{
		// End:0x15C
		case ETeleportFavoritesSortType.Latest/*0*/:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.ascendingorder_time", "L2UI_NewTex.TeleportWnd.ascendingorder_time", "L2UI_NewTex.TeleportWnd.ascendingorder_time_O");
			colorLatest = util.Yellow;
			// End:0x4C2
			break;
		// End:0x213
		case ETeleportFavoritesSortType.Oldest/*1*/:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.descendingorder_time", "L2UI_NewTex.TeleportWnd.descendingorder_time", "L2UI_NewTex.TeleportWnd.descendingorder_time_O");
			colorOldest = util.Yellow;
			// End:0x4C2
			break;
		// End:0x2B8
		case ETeleportFavoritesSortType.NameAscending/*2*/:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.ascendingorder", "L2UI_NewTex.TeleportWnd.ascendingorder", "L2UI_NewTex.TeleportWnd.ascendingorder_O");
			colorNameAscending = util.Yellow;
			// End:0x4C2
			break;
		// End:0x360
		case ETeleportFavoritesSortType.NameDescending/*3*/:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.descendingorder", "L2UI_NewTex.TeleportWnd.descendingorder", "L2UI_NewTex.TeleportWnd.descendingorder_O");
			colorNameDescending = util.Yellow;
			// End:0x4C2
			break;
		// End:0x40E
		case ETeleportFavoritesSortType.LevelAscending/*4*/:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.ascendingorder_Lv", "L2UI_NewTex.TeleportWnd.ascendingorder_Lv", "L2UI_NewTex.TeleportWnd.ascendingorder_Lv_O");
			colorLevelAscending = util.Yellow;
			// End:0x4C2
			break;
		// End:0x4BF
		case ETeleportFavoritesSortType.LevelDescending/*5*/:
			favoritesSortBtn.SetTexture("L2UI_NewTex.TeleportWnd.descendingorder_Lv", "L2UI_NewTex.TeleportWnd.descendingorder_Lv", "L2UI_NewTex.TeleportWnd.descendingorder_Lv_O");
			colorLevelDescending = util.Yellow;
			// End:0x4C2
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_ascendingorder_time", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14139), colorLatest, "", false, true, 5, 2);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_descendingorder_time", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14140), colorOldest, "", false, true, 5, 2);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_ascendingorder", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14141), colorNameAscending, "", false, true, 5, 2);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_descendingorder", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14142), colorNameDescending, "", false, true, 5, 2);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_ascendingorder_Lv", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14199), colorLevelAscending, "", false, true, 5, 2);
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.TeleportWnd.Tooltip_descendingorder_Lv", true, true, 0, 2, 14, 14);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14200), colorLevelDescending, "", false, true, 5, 2);
	toolTipInfo = MakeTooltipMultiTextByArray(drawListArr);
	favoritesSortBtn.SetTooltipCustomType(toolTipInfo);
}

function CheckFavoritesBtn(string btnName)
{
	local array<string> names;

	Split(btnName, "_", names);
	// End:0x40
	if(names[0] == "listFavoritesBtn")
	{
		OnListFavoritesBtnClicked(int(names[1]));
	}	
}

function StartTeleportSearching()
{
	local string searchStr;

	searchStr = searchTextInput.GetString();
	// End:0x23
	if(searchStr == "")
	{
		return;
	}
	_teleportUIStateInfo.searchStr = searchStr;
	// End:0x5D
	if(_teleportUIStateInfo.listType != 3)
	{
		_teleportUIStateInfo.recentlyListType = _teleportUIStateInfo.listType;
	}
	SetListUIState(ETeleportListType.Searching/*3*/);
	UpdateDominionListControls();
	ScrollToTopDominionList();	
}

function ResetTelerportSearching()
{
	searchTextInput.Clear();
	_teleportUIStateInfo.searchStr = "";
	// End:0x55
	if(_teleportUIStateInfo.recentlyListType == 0 && townRichList.GetSelectedIndex() == -1)
	{
		SetCurrentZoneListSelected();		
	}
	else
	{
		SetListUIState(_teleportUIStateInfo.recentlyListType);
	}
	UpdateDominionListControls();	
}

function Rq_EV_XML_TeleportFavoritesList()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_TELEPORT_FAVORITES_LIST, stream);	
}

function Rq_C_EX_TELEPORT_FAVORITES_UI_TOGGLE(bool isOn)
{
	local array<byte> stream;
	local UIPacket._C_EX_TELEPORT_FAVORITES_UI_TOGGLE packet;

	packet.bOn = byte(isOn);
	// End:0x33
	if(! class'UIPacket'.static.Encode_C_EX_TELEPORT_FAVORITES_UI_TOGGLE(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_TELEPORT_FAVORITES_UI_TOGGLE, stream);	
}

function Rq_C_EX_TELEPORT_FAVORITES_ADD_DEL(bool bAdd, int TeleportID)
{
	local array<byte> stream;
	local UIPacket._C_EX_TELEPORT_FAVORITES_ADD_DEL packet;

	packet.bAddOrDel = byte(bAdd);
	packet.nZoneID = TeleportID;
	// End:0x43
	if(! class'UIPacket'.static.Encode_C_EX_TELEPORT_FAVORITES_ADD_DEL(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_TELEPORT_FAVORITES_ADD_DEL, stream);	
}

function Rq_C_EX_TELEPORT_UI()
{
	local array<byte> stream;

	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_TELEPORT_UI, stream);	
}

function Rs_EV_XML_TeleportFavoritesList(string param)
{
	local int i, isFavoritesTabOn, favoritesMaxCnt, tempBookmardId;

	ParseInt(param, "bUIOn", isFavoritesTabOn);
	ParseInt(param, "ZoneCount", favoritesMaxCnt);
	// End:0x64
	if(bool(isFavoritesTabOn) == true && _teleportUIStateInfo.listType != 3)
	{
		SetListUIState(ETeleportListType.Favorites/*1*/);
		UnselectDominionList();
	}
	_favoritesTeleportIds.Length = 0;

	// End:0xC0 [Loop If]
	for(i = 0; i < favoritesMaxCnt; i++)
	{
		ParseInt(param, "ZoneID_" $ string(i), tempBookmardId);
		_favoritesTeleportIds[_favoritesTeleportIds.Length] = tempBookmardId;
	}
	UpdateListControls();	
}

function Rs_S_EX_TELEPORT_UI()
{
	local UIPacket._S_EX_TELEPORT_UI packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_TELEPORT_UI(packet))
	{
		return;
	}
	// End:0x45
	if(_priceRacio != packet.nPriceRatio)
	{
		_priceRacio = packet.nPriceRatio;
		UpdateUIContols();
	}	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_TeleportMapWndShow);
	RegisterEvent(EV_XML_TeleportFavoritesList);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_TELEPORT_UI));	
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();	
}

event OnEvent(int a_EventID, string param)
{
	// End:0x09
	if(USE_XML_TELEPORT_UI == false)
	{
		return;
	}
	switch(a_EventID)
	{
		// End:0x2A
		case EV_TeleportMapWndShow:
			Me.ShowWindow();
			// End:0x63
			break;
		// End:0x40
		case EV_XML_TeleportFavoritesList:
			Rs_EV_XML_TeleportFavoritesList(param);
			// End:0x63
			break;
		// End:0x60
		case EV_PacketID(class'UIPacket'.const.S_EX_TELEPORT_UI):
			Rs_S_EX_TELEPORT_UI();
			// End:0x63
			break;
	}	
}

event OnShow()
{
	// End:0x3E
	if(class'UIDATA_PLAYER'.static.IsInPrison())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		Me.HideWindow();
		return;
	}
	searchTextInput.Clear();
	SetListUIState(_teleportUIStateInfo.listType);
	UpdateSpecialTeleportList();
	UpdateUIContols();
	class'TeleportWndMap'.static.Inst().UpdateCurrentZoneInfo();
	class'TeleportWndMap'.static.Inst().StartPlayerPositionTimer();
	class'TeleportWndMap'.static.Inst().PlayMapIconAnimation();
	SetCurrentZoneListSelected();
	SetFavoritesSortBtnState(ETeleportFavoritesSortType(GetOptionInt("UI", "TeleportFavoritesSortType")));
	Rq_EV_XML_TeleportFavoritesList();
	// End:0xF7
	if(USE_XML_TELEPORT_UI)
	{
		Rq_C_EX_TELEPORT_UI();
	}
	Me.SetFocus();
	townRichList.SetFocus();	
}

event OnHide()
{
	class'TeleportWndMap'.static.Inst().KillPlayerPositionTimer();
	class'TeleportWndMap'.static.Inst().StopMapIconAnimation();
	teleportDialog.Hide();	
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x26
		case "FavoritesView_Btn":
			OnBookMarkTabBtnClicked();
			// End:0x14E
			break;
		// End:0x43
		case "SpecialView_Btn":
			OnSpecialTabBtnClicked();
			// End:0x14E
			break;
		case "BtnFind":
			OnSearchBtnClicked();
			// End:0x14E
			break;
		// End:0x8C
		case "Teleport_Btn":
			OnTeleportBtnClicked();
			// End:0x14E
			break;
		// End:0xAB
		case "FavoritesSort_btn":
			OnFavoritesSortBtnClicked();
			// End:0x14E
			break;
		// End:0xCD
		case "TownZoneArrowUP_Btn":
			SetTownRichListScroll(false);
			// End:0x14E
			break;
		// End:0xF1
		case "TownZoneArrowDown_Btn":
			SetTownRichListScroll(true);
			// End:0x14E
			break;
		// End:0x116
		case "HuntingZoneArrowUP_Btn":
			SetDominionRichListScroll(false);
			// End:0x14E
			break;
		// End:0x13D
		case "HuntingZoneArrowDown_Btn":
			SetDominionRichListScroll(true);
			// End:0x14E
			break;
		// End:0xFFFF
		default:
			CheckFavoritesBtn(Name);
			// End:0x14E
			break;
	}	
}

event OnClickListCtrlRecord(string strID)
{
	switch(strID)
	{
		// End:0x56
		case "TownZone_ListCtrl":
			// End:0x39
			if(_teleportUIStateInfo.listType == ETeleportListType.Favorites)
			{
				Rq_C_EX_TELEPORT_FAVORITES_UI_TOGGLE(false);
			}
			SetListUIState(ETeleportListType.Normal/*0*/);
			UpdateDominionListControls();
			ScrollToTopDominionList();
			UpdateMapDominionZoneIcons();
			// End:0x7B
			break;
		// End:0x78
		case "HuntingZone_ListCtrl":
			UpdateMapDominionZoneIcons();
			// End:0x7B
			break;
	}	
}

event OnDBClickListCtrlRecord(string strID)
{
	local RichListCtrlRowData selectedData;

	switch(strID)
	{
		// End:0x44
		case "TownZone_ListCtrl":
			townRichList.GetSelectedRec(selectedData);
			ShowTeleportDialog(selectedData.nReserved1);
			// End:0x87
			break;
		// End:0x84
		case "HuntingZone_ListCtrl":
			dominionRichList.GetSelectedRec(selectedData);
			ShowTeleportDialog(selectedData.nReserved1);
			// End:0x87
			break;
	}	
}

event OnRollOverListCtrlRecord(string strID, int Index)
{
	local RichListCtrlRowData targetData;

	switch(strID)
	{
		// End:0x85
		case "TownZone_ListCtrl":
			// End:0x69
			if(Index >= 0)
			{
				townRichList.GetRec(Index, targetData);
				class'TeleportWndMap'.static.Inst().ShowMapIconTooltip(int(targetData.nReserved1));				
			}
			else
			{
				class'TeleportWndMap'.static.Inst().HideMapIconTooltip();
			}
			// End:0x109
			break;
		// End:0x106
		case "HuntingZone_ListCtrl":
			// End:0xEA
			if(Index >= 0)
			{
				dominionRichList.GetRec(Index, targetData);
				class'TeleportWndMap'.static.Inst().ShowMapIconTooltip(int(targetData.nReserved1));				
			}
			else
			{
				class'TeleportWndMap'.static.Inst().HideMapIconTooltip();
			}
			// End:0x109
			break;
	}	
}

event OnMouseOut(WindowHandle WindowHandle)
{
	// End:0x39
	if((WindowHandle == townRichList) || WindowHandle == dominionRichList)
	{
		class'TeleportWndMap'.static.Inst().HideMapIconTooltip();
	}	
}

event OnBookMarkTabBtnClicked()
{
	// End:0x1C
	if(_teleportUIStateInfo.listType != 1)
	{
		Rq_C_EX_TELEPORT_FAVORITES_UI_TOGGLE(true);
	}
	SetListUIState(ETeleportListType.Favorites/*1*/);
	UnselectTownList();
	ScrollToTopDominionList();
	UpdateDominionListControls();
	UpdateMapDominionZoneIcons();	
}

event OnSpecialTabBtnClicked()
{
	// End:0x1C
	if(_teleportUIStateInfo.listType == ETeleportListType.Favorites)
	{
		Rq_C_EX_TELEPORT_FAVORITES_UI_TOGGLE(false);
	}
	SetListUIState(ETeleportListType.Special/*2*/);
	UnselectTownList();
	ScrollToTopDominionList();
	UpdateDominionListControls();
	UpdateMapDominionZoneIcons();	
}

event OnTeleportBtnClicked()
{
	local int selectedTeleportID;

	selectedTeleportID = GetSelectedTeleportID();
	// End:0x27
	if(selectedTeleportID >= 0)
	{
		ShowTeleportDialog(selectedTeleportID);		
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13743));
	}	
}

event OnFavoritesSortBtnClicked()
{
	local ETeleportFavoritesSortType nextSortType;

	nextSortType = _teleportUIStateInfo.sortType;
	nextSortType = ETeleportFavoritesSortType(nextSortType + 1);
	// End:0x3A
	if(nextSortType >= ETeleportFavoritesSortType.Max/*6*/)
	{
		nextSortType = ETeleportFavoritesSortType.Latest/*0*/;
	}
	SetFavoritesSortBtnState(nextSortType);
	SetOptionInt("UI", "TeleportFavoritesSortType", nextSortType);
	UpdateDominionListControls();	
}

event OnSearchBtnClicked()
{
	StartTeleportSearching();	
}

event OnSearchTextInputClear()
{
	ResetTelerportSearching();	
}

event OnSearchTextInputCompleted(string Text)
{
	StartTeleportSearching();	
}

event OnListFavoritesBtnClicked(int TeleportID)
{
	local bool isFavorites;

	isFavorites = IsTeleportFavorites(TeleportID);
	// End:0x49
	if(! isFavorites && _favoritesTeleportIds.Length >= TELEPORT_FAVORITES_MAX)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13194));
		return;
	}
	// End:0x7D
	if(IsPlayerOnWorldRaidServer() == false)
	{
		// End:0x6C
		if(isFavorites)
		{
			RemoveTeleportFavorites(TeleportID);			
		}
		else
		{
			AddTeleportFavorites(TeleportID);
		}
		UpdateListControls();
	}
	Rq_C_EX_TELEPORT_FAVORITES_ADD_DEL(! isFavorites, TeleportID);	
}

event OnTeleportDialogCancel()
{
	teleportDialog.Hide();
	_tempTeleportId = 0;	
}

event OnTeleportDialogConfirm()
{
	local UserInfo UserInfo;

	// End:0x13
	if((GetPlayerInfo(UserInfo)) == false)
	{
		return;
	}
	// End:0x4F
	if(UserInfo.nCurHP == 0)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5243));
		teleportDialog.Hide();
		return;
	}
	class'TeleportListAPI'.static.RequestTeleport(_tempTeleportId);
	teleportDialog.Hide();
	Me.HideWindow();
	_tempTeleportId = 0;	
}

event OnReceivedCloseUI()
{
	// End:0x2D
	if(teleportDialog.Me.IsShowWindow())
	{
		teleportDialog.Hide();		
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}	
}

defaultproperties
{
}
