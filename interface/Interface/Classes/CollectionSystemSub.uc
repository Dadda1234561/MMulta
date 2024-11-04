class CollectionSystemSub extends UICommonAPI;

const MAX_COLLECTION_SLOT_NUM = 6;

struct indexInfoStruct
{
	var int Index;
	var bool IsKeyItem;
	var string hiddenStringForHidden;
};

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var RichListCtrlHandle CollectionList_ListCtrl;
var CollectionSystem collectionSystemScript;
var CollectionSystemCategory collectionSystemCategoryScript;
var CollectionSystemProgressComponent ProgressCollectionComplete_wndScript;
var CollectionSystemProgressComponent ProgressItemComplete_wndScript;
var WindowHandle CollectionSystemSubPopupProgressWindow;
var EditBoxHandle EditBoxFind_EditBox;
var ComboBoxHandle A0_ComboBox;
var ComboBoxHandle A1_ComboBox;
var TextureHandle Img00_tex;
var TextBoxHandle SearchFailed_txt;
var CollectionCount currentCollectionCount;

function SetTextureByCategory()
{
	local int Index;

	Index = collectionSystemScript.selectedCategory - 1;
	Img00_tex.SetTexture("L2UI_EPIC.CollectionSystemWnd.KeyItem" $ collectionSystemScript.GetStringKeyByIndex(Index));
}

function SetSearchInit()
{
	A0_ComboBox.SetSelectedNum(0);
	A1_ComboBox.SetSelectedNum(0);
	EditBoxFind_EditBox.SetString("");
}

function InitComboBoxes()
{
	local int i;
	local array<CollectionOption> Options;

	A0_ComboBox.Clear();
	A0_ComboBox.SYS_AddString(144);
	A0_ComboBox.SYS_AddString(13498);
	A0_ComboBox.SYS_AddString(13497);
	A0_ComboBox.SYS_AddString(13701);
	A1_ComboBox.Clear();
	A1_ComboBox.SYS_AddString(144);
	collectionSystemScript.API_GetCollectionOption(Options);

	for(i = 0; i < Options.Length; i++)
	{
		A1_ComboBox.AddString(Options[i].Name);
	}
	A0_ComboBox.SetSelectedNum(0);
	A1_ComboBox.SetSelectedNum(0);
}

function InitComboboxA1()
{
	local int i;
	local array<string> optionNames;

	A1_ComboBox.Clear();
	collectionSystemScript.API_GetCollectionOptionName(collectionSystemScript.selectedCategory, optionNames);
	optionNames.Sort(SortByNameDelegate);
	A1_ComboBox.SYS_AddString(144);

	// End:0x88 [Loop If]
	for(i = 0; i < optionNames.Length; i++)
	{
		A1_ComboBox.AddString(optionNames[i]);
	}
	A1_ComboBox.SetSelectedNum(0);
}

delegate int SortByNameDelegate(string name0, string name1)
{
	// End:0x15
	if(name0 > name1)
	{
		return -1;
	}
	return 0;
}

delegate int SortRecordListByNameDelegate(indexInfoStruct structA, indexInfoStruct structB)
{
	// End:0x26
	if(! structA.IsKeyItem && structB.IsKeyItem)
	{
		return -1;
	}
	return 0;
}

delegate int SortRecordListDelegate(indexInfoStruct structA, indexInfoStruct structB)
{
	// End:0x1F
	if(structA.hiddenStringForHidden < structB.hiddenStringForHidden)
	{
		return -1;
	}
	return 0;
}

function InitProgressComponents()
{
	local string _progressWindowName;

	_progressWindowName = m_WindowName $ ".SubContents.ProgressCollectionComplete_wnd";
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressCollectionComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressCollectionComplete_wndScript.Init(_progressWindowName);
	ProgressCollectionComplete_wndScript.DelegateOnButtonClick = HandleOnClickProgressComponent;
	_progressWindowName = m_WindowName $ ".SubContents.ProgressItemComplete_wnd";
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressItemComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressItemComplete_wndScript.Init(_progressWindowName);
	ProgressItemComplete_wndScript.DelegateOnButtonClick = HandleOnClickProgressComponent;
}

function HandleOnClickProgressComponent()
{
	switch(collectionSystemScript.CurrentState)
	{
		case collectionSystemScript.collectionState.Sub:
			collectionSystemScript.SetState(collectionSystemScript.collectionState.subProgress);
			break;
		case collectionSystemScript.collectionState.stand:
			collectionSystemScript.SetState(collectionSystemScript.collectionState.mainProgress);
			break;
	}
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
	collectionSystemScript = CollectionSystem(GetScript("CollectionSystem"));
	collectionSystemCategoryScript = CollectionSystemCategory(GetScript("CollectionSystem.CollectionSystemCategory"));
	CollectionList_ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".SubContents.CollectionList_ListCtrl");
	CollectionList_ListCtrl.SetTooltipType("CollectionSystemListTooltip");
	InitProgressComponents();
	EditBoxFind_EditBox = GetEditBoxHandle(m_WindowName $ ".SubContents.EditBoxFind_EditBox");
	A0_ComboBox = GetComboBoxHandle(m_WindowName $ ".SubContents.A0_ComboBox");
	A1_ComboBox = GetComboBoxHandle(m_WindowName $ ".SubContents.A1_ComboBox");
	Img00_tex = GetTextureHandle(m_WindowName $ ".SubContents.Img00_tex");
	SearchFailed_txt = GetTextBoxHandle(m_WindowName $ ".SubContents.SearchFailed_txt");
	InitComboBoxes();
	CollectionList_ListCtrl.SetSelectedSelTooltip(false);
	CollectionList_ListCtrl.SetUseStripeBackTexture(false);
	CollectionList_ListCtrl.SetAppearTooltipAtMouseX(true);
}

event OnLoad()
{
	Initialize();
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "Close_btn":
			collectionSystemScript.SetState(collectionSystemScript.collectionState.stand);
			break;
		case "btnInfo":
			HandleShowDetailInfo();
			break;
		case "favoriteBtn":
			HandleFavoriteBtn();
			break;
		case "ClearEditBox_Btn":
			SetFindKeyWord("");
			SetCategory(collectionSystemScript.selectedCategory);
			break;
		case "Find_Btn":
			SetCategory(collectionSystemScript.selectedCategory);
			break;
	}
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	HandleShowDetailInfo();
}

event OnKeyDown(WindowHandle a_WindowHandle, EInputKey nKey)
{
	local string mainKey;

	// End:0x65
	if(EditBoxFind_EditBox.IsFocused() && Me.IsShowWindow())
	{
		mainKey = class'InputAPI'.static.GetKeyString(nKey);
		// End:0x65
		if(mainKey == "ENTER")
		{
			SetCategory(collectionSystemScript.selectedCategory);
		}
	}
}

function HandleShowDetailInfo()
{
	collectionSystemScript.SetState(collectionSystemScript.collectionState.detailinfo);
}

function HandleFavoriteBtn()
{
	local bool bRegister;
	local int favorited, nCollectionID;

	favorited = GetFavoriteSelected();
	// End:0x1D
	if(favorited == -1)
	{
		return;
	}
	bRegister = (GetFavoriteSelected()) != 1;
	nCollectionID = GetSelectedCollectionID();
	collectionSystemScript.API_C_EX_COLLECTION_UPDATE_FAVORITE(bRegister, nCollectionID);
}

function Show()
{
	Me.ShowWindow();
}

function SetFindKeyWord(string ItemName)
{
	EditBoxFind_EditBox.SetString(ItemName);
}

function HandleCollectionRegisted(string param)
{
	local int Success, collectionid;

	ParseInt(param, "Success", Success);
	// End:0x26
	if(Success != 1)
	{
		return;
	}
	ParseInt(param, "CollectionID", collectionid);
	ModifyRecordByCollectionID(collectionid);
}

function ModifyRecordByCollectionID(int collectionid)
{
	local int Index;
	local RichListCtrlRowData Record;

	Index = GetRecordIndexByCollectionID(collectionid);
	// End:0x22
	if(Index == -1)
	{
		return;
	}
	// End:0x4D
	if(! makeRecord(collectionid, Record))
	{
		CollectionList_ListCtrl.DeleteRecord(Index);
		return;
	}
	CollectionList_ListCtrl.ModifyRecord(Index, Record);
	// End:0x75
	if(SetCurrentCollectionCount())
	{
		SetCollectionCount();
	}
	CollectionList_ListCtrl.SetFocus();
}

function CheckAllCategorys()
{
	local array<int> collectionIds;
	local int i, j, selectedNum0, selectedNum1, nNotEnoughEnchanted, nHaveNotEnoughListNum,
		nOverNeedEnchantList;

	local string optionKeyward;
	local CollectionData cdata;
	local bool canregist;

	selectedNum0 = A0_ComboBox.GetSelectedNum();
	selectedNum1 = A1_ComboBox.GetSelectedNum();
	collectionSystemCategoryScript.HideAllDot();
	// End:0x6B
	if(selectedNum0 == 0 && selectedNum1 == 0 && EditBoxFind_EditBox.GetString() == "")
	{
		return;
	}
	// End:0x8B
	if(A1_ComboBox.GetSelectedNum() == 0)
	{
		optionKeyward = "";
	}
	else
	{
		optionKeyward = A1_ComboBox.GetString(selectedNum1);
	}

	for(i = 1; i <= collectionSystemScript.MAX_CATEGORY; i++)
	{
		collectionSystemCategoryScript.HideDot(i);
		// End:0x152
		if(! collectionSystemScript.API_GetCollectionIdByItemName(collectionIds, i, selectedNum0 == 1, selectedNum0 == 2, collectionSystemScript.favoriteCategory == i, EditBoxFind_EditBox.GetString(), optionKeyward, selectedNum0 == 3))
		{
			collectionSystemCategoryScript.ShowDot(i, 3);
			continue;
		}

		for(j = 0; j < collectionIds.Length; j++)
		{
			// End:0x190
			if(! collectionSystemScript.API_GetCollectionData(collectionIds[j], cdata))
			{
				continue;
			}
			nNotEnoughEnchanted = 0;
			nHaveNotEnoughListNum = 0;
            nOverNeedEnchantList = 0;
			canregist = CanRegistrationCollectionData(cdata, nNotEnoughEnchanted, nHaveNotEnoughListNum, nOverNeedEnchantList);
			// End:0x1DE
			if(canregist)
			{
				collectionSystemCategoryScript.ShowDot(i, 1);
				break;
				continue;
			}
			// End:0x20C
			if((nNotEnoughEnchanted > 0) || nHaveNotEnoughListNum > 0)
			{
				collectionSystemCategoryScript.ShowDot(i, 2);
				continue;
			}
			if(nOverNeedEnchantList > 0)
			{
				collectionSystemCategoryScript.ShowDot(i, 4);
			}
		}
	}
}

function SetCategory(int Category)
{
	local array<int> collectionIds;
	local int i, Index, selectedNum0, selectedNum1;
	local RichListCtrlRowData Record;
	local string optionKeyward;
	local array<RichListCtrlRowData> records;
	local array<indexInfoStruct> indexInfos;

	SetTextureByCategory();
	selectedNum0 = A0_ComboBox.GetSelectedNum();
	selectedNum1 = A1_ComboBox.GetSelectedNum();
	// End:0x50
	if(A1_ComboBox.GetSelectedNum() == 0)
	{
		optionKeyward = "";
	}
	else
	{
		optionKeyward = A1_ComboBox.GetString(selectedNum1);
	}
	collectionSystemScript.API_GetCollectionIdByItemName(collectionIds, Category, selectedNum0 == 1, selectedNum0 == 2, collectionSystemScript.favoriteCategory == Category, EditBoxFind_EditBox.GetString(), optionKeyward, selectedNum0 == 3);
	switch(collectionSystemScript.requestedMode)
	{
		// End:0x2A9
		case collectionSystemScript.LIST_REQUESTEDMODE.Normal:
			CollectionList_ListCtrl.DeleteAllItem();

			for(i = 0; i < collectionIds.Length; i++)
			{
				// End:0x128
				if(! makeRecord(collectionIds[i], Record))
				{
					// [Explicit Continue]
					continue;
				}
				records[records.Length] = Record;
				Index = indexInfos.Length;
				indexInfos.Length = Index + 1;
				indexInfos[Index].Index = Index;
				indexInfos[Index].IsKeyItem = Record.cellDataList[0].nReserved1 > 0;
				indexInfos[Index].hiddenStringForHidden = Record.cellDataList[4].HiddenStringForSorting;
			}
			// End:0x210
			if(((EditBoxFind_EditBox.GetString() == "") && A0_ComboBox.GetSelectedNum() == 0) && A1_ComboBox.GetSelectedNum() == 0)
			{
				indexInfos.Sort(SortRecordListByNameDelegate);
			}
			else
			{
				indexInfos.Sort(SortRecordListDelegate);
			}

			for(i = 0; i < records.Length; i++)
			{
				CollectionList_ListCtrl.InsertRecord(records[indexInfos[i].Index]);
			}
			// End:0x270
			if(SetCurrentCollectionCount())
			{
				SetCollectionCount();
			}
			// End:0x297
			if(CollectionList_ListCtrl.GetRecordCount() > 0)
			{
				SearchFailed_txt.HideWindow();
			}
			else
			{
				SearchFailed_txt.ShowWindow();
			}
			// End:0x309
			break;
		// End:0x306
		case collectionSystemScript.LIST_REQUESTEDMODE.modify:
			collectionSystemScript.requestedMode = collectionSystemScript.LIST_REQUESTEDMODE.Normal;

			// End:0x303 [Loop If]
			for(i = 0; i < collectionIds.Length; i++)
			{
				ModifyRecordByCollectionID(collectionIds[i]);
			}
			break;
	}
	CheckAllCategorys();
}

function int GetFavoriteSelected()
{
	local RichListCtrlRowData Record;

	CollectionList_ListCtrl.GetSelectedRec(Record);
	return Record.cellDataList[2].nReserved1;
}

function int GetSelectedCollectionID()
{
	local RichListCtrlRowData Record;

	CollectionList_ListCtrl.GetSelectedRec(Record);
	return int(Record.nReserved1);
}

function bool SetSelectByCollectionID(int collectionid)
{
	local int Index;

	Index = GetRecordIndexByCollectionID(collectionid);
	// End:0x1E
	if(Index < 0)
	{
		return false;
	}
	CollectionList_ListCtrl.SetSelectedIndex(Index, true);
}

function int GetRecordIndexByCollectionID(int collectionid)
{
	local RichListCtrlRowData Record;
	local int i;

	// End:0x60 [Loop If]
	for(i = 0; i < CollectionList_ListCtrl.GetRecordCount(); i++)
	{
		CollectionList_ListCtrl.GetRec(i, Record);
		// End:0x56
		if(Record.nReserved1 == int64(collectionid))
		{
			return i;
		}
	}
	return -1;
}

function bool SetCurrentCollectionCount()
{
	local int i;
	local CollectionCount tmpCollectionCount;

	currentCollectionCount.CollectionTotalCount = 0;
	currentCollectionCount.CollectionCompleteCount = 0;
	currentCollectionCount.CollectionProgressCount = 0;
	currentCollectionCount.SlotTotalCount = 0;
	currentCollectionCount.SlotRegistCount = 0;

	// End:0xF6 [Loop If]
	for(i = 1; i < (collectionSystemScript.MAX_CATEGORY - 1); i++)
	{
		// End:0x7E
		if(! collectionSystemScript.API_GetCollectionCount(i, tmpCollectionCount))
		{
			return false;
		}
		currentCollectionCount.CollectionTotalCount += tmpCollectionCount.CollectionTotalCount;
		currentCollectionCount.CollectionCompleteCount += tmpCollectionCount.CollectionCompleteCount;
		currentCollectionCount.CollectionProgressCount += tmpCollectionCount.CollectionProgressCount;
		currentCollectionCount.SlotTotalCount += tmpCollectionCount.SlotTotalCount;
		currentCollectionCount.SlotRegistCount += tmpCollectionCount.SlotRegistCount;
	}
	return true;
}

function SetCollectionCount()
{
	ProgressCollectionComplete_wndScript.SetPoint(currentCollectionCount.CollectionCompleteCount, currentCollectionCount.CollectionTotalCount);
	ProgressItemComplete_wndScript.SetPoint(currentCollectionCount.SlotRegistCount, currentCollectionCount.SlotTotalCount);
	collectionSystemScript.CollectionSystemSubPopupProgressScript.SetProgressCollection(currentCollectionCount.CollectionTotalCount, currentCollectionCount.CollectionCompleteCount, currentCollectionCount.CollectionProgressCount);
	collectionSystemScript.CollectionSystemSubPopupProgressScript.SetProgressItem(currentCollectionCount.SlotTotalCount, currentCollectionCount.SlotRegistCount);
	collectionSystemScript.ProgressCollectionComplete_wndScript.SetPoint(currentCollectionCount.CollectionCompleteCount, currentCollectionCount.CollectionTotalCount);
	collectionSystemScript.ProgressItemComplete_wndScript.SetPoint(currentCollectionCount.SlotRegistCount, currentCollectionCount.SlotTotalCount);
}

function string GetOptionByOptionID(int option_id)
{
	local string strDesc1, strDesc2, strDesc3;

	// End:0x2C
	if(class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(option_id, strDesc1, strDesc2, strDesc3))
	{
		return strDesc1;
	}
	return "";
}

function string Int2Str2(int i)
{
	// End:0x19
	if(i < 10)
	{
		return "0" $ string(i);
	}
	return string(i);
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	// End:0x17
	if(! CheckBtnName(btnName, someString))
	{
		return false;
	}
	strID = Mid(btnName, Len(someString));
	return true;
}

function bool CheckBtnName(string btnName, string someString)
{
	return Left(btnName, Len(someString)) == someString;
}

function bool getSlotItemInfo(CollectionSlotItem cSItem, CollectionItemInfo cIInfo, out ItemInfo slotItemInfo)
{
	// End:0xA1
	if(cIInfo.nItemClassID > 0)
	{
		// End:0x3B
		if(! class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(cIInfo.nItemClassID), slotItemInfo))
		{
			return false;
		}
		slotItemInfo.IsBlessedItem = byte(cSItem.BlessCondition) == 1;
		slotItemInfo.Enchanted = cIInfo.Enchant;
		slotItemInfo.ItemNum = cIInfo.Amount;
		slotItemInfo.BlessPanelDrawType = EBlessPanelDrawType(cIInfo.BlessCondition);
	}
	else
	{
		// End:0xCC
		if(! class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(cSItem.ItemID), slotItemInfo))
		{
			return false;
		}
		slotItemInfo.IsBlessedItem = byte(cSItem.BlessCondition) == 1;
		slotItemInfo.Enchanted = cSItem.EnchantCondition;
		slotItemInfo.ItemNum = cSItem.ItemCount;
		slotItemInfo.BlessPanelDrawType = EBlessPanelDrawType(cSItem.BlessCondition);
		slotItemInfo.bDisabled = 1;
	}
	slotItemInfo.bShowCount = IsStackableItem(slotItemInfo.ConsumeType);
	return true;
}

function bool GetItemList(CollectionInfo cInfo, CollectionData cdata, out array<ItemInfo> iIonfos)
{
	local int i;
	local bool isCompleted;
	local ItemInfo iInfo;

	isCompleted = true;
	// End:0x1B
	if(cdata.SlotItems.Length == 0)
	{
		return false;
	}

	for(i = 0; i < cdata.SlotItems.Length; i++)
	{
		// End:0xC0
		if(cdata.SlotItems[i].Representative == true)
		{
			// End:0x96
			if(! getSlotItemInfo(cdata.SlotItems[i], cInfo.ItemInfo[cdata.SlotItems[i].SlotID], iInfo))
			{
				// [Explicit Continue]
				continue;
			}
			// End:0xAE
			if(iInfo.bDisabled == 1)
			{
				isCompleted = false;
			}
			iIonfos[iIonfos.Length] = iInfo;
		}
	}
	return isCompleted;
}

function bool bUseReplaceItem(int SlotID, CollectionData cdata)
{
	local int i;

	// End:0x63 [Loop If]
	for(i = 0; i < cdata.SlotItems.Length; i++)
	{
		// End:0x59
		if(cdata.SlotItems[i].SlotID == SlotID)
		{
			// End:0x59
			if(cdata.SlotItems[i].Representative == false)
			{
				return true;
			}
		}
	}
	return false;
}

function bool makeRecord(int collectionid, out RichListCtrlRowData outRecord)
{
	local int i;
	local CollectionInfo cInfo;
	local CollectionData cdata;
	local RichListCtrlRowData Record;
	local array<ItemInfo> iIonfos;
	local bool IsKeyItem;
	local CollectionMainData mainData;
	local int nWidth, nHeight;
	local bool isCompleted, canregist;
	local array<CollectionRegistFailReason> failReasons;
	local CollectionRegistFailReason failReason;
	local array<int> canRegists;
	local int sortScore;

	Record.cellDataList.Length = 5;
	Record.nReserved1 = collectionid;
	// End:0x40
	if(! collectionSystemScript.API_GetCollectionInfo(collectionid, cInfo))
	{
		return false;
	}
	// End:0x60
	if(! collectionSystemScript.API_GetCollectionData(collectionid, cdata))
	{
		return false;
	}
	collectionSystemScript.API_GetCollectionMainData(cdata.main_category, mainData);
	IsKeyItem = collectionSystemScript.IsKeyItem(collectionid);
	// End:0xB8
	if(IsKeyItem)
	{
		Record.cellDataList[0].nReserved1 = 1;
	}
	else
	{
		Record.cellDataList[0].nReserved1 = 0;
	}
	Record.cellDataList[0].szData = cdata.collection_name;
	addRichListCtrlString(Record.cellDataList[0].drawitems, Record.cellDataList[0].szData, util.White, false);
	addRichListCtrlString(Record.cellDataList[0].drawitems, "", util.White, true, 0, 3);
	Record.cellDataList[0].HiddenStringForSorting = Record.cellDataList[0].szData;
	isCompleted = GetItemList(cInfo, cdata, iIonfos);

	// End:0x1D1 [Loop If]
	for(i = 0; i < iIonfos.Length; i++)
	{
		AddRichListCtrlItem(Record.cellDataList[0].drawitems, iIonfos[i], 32, 32, 5);
	}
	Record.cellDataList[1].szData = GetOptionByOptionID(cdata.option_id);
	// End:0x251
	if(cdata.Period > 0)
	{
		addRichListCtrlTexture(Record.cellDataList[1].drawitems, "L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 12, 12);
	}
	class'L2Util'.static.GetEllipsisString(cData.collection_name, 232);
	addRichListCtrlString(Record.cellDataList[1].drawitems, Record.cellDataList[1].szData, util.ColorGold, false);
	Record.cellDataList[1].HiddenStringForSorting = Record.cellDataList[1].szData;
	// End:0x3FC
	if(cInfo.isFavorite)
	{
		Record.cellDataList[2].nReserved1 = 1;
		addRichListCtrlButton(Record.cellDataList[2].drawitems, "favoriteBtn", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBtn", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBtn", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBtn", 32, 32, 32, 32);
		Record.cellDataList[2].HiddenStringForSorting = "1";
	}
	else
	{
		// End:0x41F
		if(collectionSystemScript.selectedCategory == collectionSystemScript.favoriteCategory)
		{
			return false;
		}
		Record.cellDataList[2].nReserved1 = 0;
		addRichListCtrlButton(Record.cellDataList[2].drawitems, "favoriteBtn", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBg", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBg", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBg", 32, 32, 32, 32);
		Record.cellDataList[2].HiddenStringForSorting = "0";
	}
	// End:0x5F1
	if((! isCompleted || cInfo.isReward) || cdata.RewardItems.Length == 0)
	{
		addRichListCtrlTexture(Record.cellDataList[3].drawitems, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_AdditionalReward_Get", 34, 38);
		Record.cellDataList[3].HiddenStringForSorting = "1";
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[3].drawitems, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_AdditionalReward", 34, 38);
		Record.cellDataList[3].HiddenStringForSorting = "0";
	}
	canregist = GetRegistrationStates(cdata, canRegists, failReasons, failReason);
	// End:0x893
	if(isCompleted)
	{
		// End:0x7A7
		if(IsKeyItem)
		{
			addRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_YellowBtn", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_YellowBtn_down", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_YellowBtn_over", 108, 30, 108, 30);
		}
		else
		{
			addRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_GreenBtn", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_GreenBtn_down", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_GreenBtn_over", 108, 30, 108, 30);
		}
	}
	else
	{
		// End:0x98B
		if(canregist)
		{
			addRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtn", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtn_down", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtn_over", 108, 30, 108, 30);
			sortScore += 8;
		}
		else
		{
			switch(failReason)
			{
				// End:0xA7C
				case CollectionRegistFailReason.CRFR_OverNeedEnchant/*3*/:
					sortScore += 6;
					addRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnSky", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnSky_Down", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnSky_over", 108, 30, 108, 30);
					// End:0xC5D
					break;
				// End:0xA81
				case CollectionRegistFailReason.CRFR_UnderNeedEnchant/*1*/:
				// End:0xB8A
				case CollectionRegistFailReason.CRFR_HaveNotEnoughItem/*2*/:
					sortScore += 4;
					addRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnEnchant", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnEnchant_Down", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnEnchant_over", 108, 30, 108, 30);
					// End:0xC5D
					break;
				// End:0xC5A
				case CollectionRegistFailReason.CRFR_None/*0*/:
					sortScore += 2;
					addRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button", "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button_down", "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button_over", 108, 30, 108, 30);
					// End:0xC5D
					break;
			}
		}
	}
	// End:0xB7C
	if(IsKeyItem)
	{
		sortScore += 1;
	}
	Record.cellDataList[4].HiddenStringForSorting = string(sortScore);
	GetTextSizeDefault(GetSystemString(1797), nWidth, nHeight);
	addRichListCtrlString(Record.cellDataList[4].drawitems, GetSystemString(1797), util.White, false, - 108 + nWidth / 2, (30 - nHeight) / 2);
	Record.sOverlayTex = GetOverlayTex(collectionid, isCompleted, IsKeyItem);
	Record.OverlayTexU = 810;
	Record.OverlayTexV = 70;
	Record.ForceRefreshTooltip = true;
	addRichListCtrlString(Record.cellDataList[0].drawitems, "", GetColor(0, 0, 0, 0), true, - 32 + 6, -32);
	// End:0xEFE [Loop If]
	for(i = 0; i < canRegists.Length; i++)
	{
		// End:0xDE6
		if(canRegists[i] > 0)
		{
			addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_EPIC.CollectionSystemWnd_Registration", 8, 8, 32 - 3);
			// [Explicit Continue]
			continue;
		}
		switch(failReasons[i])
		{
			// End:0xDF8
			case CRFR_UnderNeedEnchant:
			// End:0xE4D
			case CRFR_HaveNotEnoughItem:
				addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_EPIC.CollectionSystemWnd_Insufficient", 8, 8, 32 - 3);
				// End:0xEF4
				break;
			// End:0xEB5
			case CRFR_OverNeedEnchant:
				addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_OverEnchant", 8, 8, 32 - 3);
				// End:0xEF4
				break;
			// End:0xEF1
			case CRFR_None:
				addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.EmptyBtn", 8, 8, 32 - 3);
				// End:0xEF4
				break;
		}
	}
	Record.szReserved = string(collectionid);
	outRecord = Record;
	return true;
}

function string GetOverlayTex(int collectionid, bool isCompleted, bool IsKeyItem)
{
	// End:0xB0
	if(IsKeyItem)
	{
		// End:0x67
		if(isCompleted)
		{
			return "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_KeyCollectionBg_complete";
		}
		else
		{
			return "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_KeyCollectionBg";
		}
	}
	// End:0x10B
	if(isCompleted)
	{
		return "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_CollectionBg_complete";
	}
	else
	{
		return "";
	}
}

function bool CanRegistrationCollectionData(CollectionData cData, out int nNotEnoughItemNum, out int nHaveNotEnoughListNum, out int nOverNeedEnchantList)
{
	local int i;
	local array<ItemInfo> notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList;

	// End:0x8A [Loop If]
	for(i = 0; i < collectionSystemScript.MAX_SLOT; i++)
	{
		// End:0x55
		if(collectionSystemScript.CollectionSystemPopupDetailsScript.CanRegistration(cData, i, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList))
		{
			return true;
			// [Explicit Continue]
			continue;
		}
		nNotEnoughItemNum = Max(nNotEnoughItemNum, notEnoughEnchantedList.Length);
		nHaveNotEnoughListNum = Max(nHaveNotEnoughListNum, haveNotEnoughList.Length);
		nOverNeedEnchantList = Max(nOverNeedEnchantList, overNeedEnchantList.Length);
	}
	return false;
}

function bool GetRegistrationStates(CollectionData cData, out array<int> canRegists, out array<CollectionRegistFailReason> failReasons, out CollectionRegistFailReason failReason)
{
	local int i;
	local array<ItemInfo> notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList;
	local bool canregist;

	failReason = CRFR_None;

	// End:0x156 [Loop If]
	for(i = 0; i < collectionSystemScript.MAX_SLOT; i++)
	{
		canRegists[i] = int(collectionSystemScript.CollectionSystemPopupDetailsScript.CanRegistration(cData, i, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList));
		// End:0x133
		if(canRegists[i] == 0)
		{
			// End:0x91
			if(notEnoughEnchantedList.Length > 0)
			{
				failReasons[i] = CRFR_UnderNeedEnchant;				
			}
			else
			{
				// End:0xAE
				if(haveNotEnoughList.Length > 0)
				{
					failReasons[i] = CRFR_UnderNeedEnchant;					
				}
				else
				{
					// End:0xCB
					if(overNeedEnchantList.Length > 0)
					{
						failReasons[i] = CRFR_OverNeedEnchant;						
					}
					else
					{
						failReasons[i] = CRFR_None;
					}
				}
			}
			switch(failReason)
			{
				// End:0xF9
				case CollectionRegistFailReason.CRFR_None/*0*/:
					failReason = failReasons[i];
					// End:0x133
					break;
				// End:0x128
				case CollectionRegistFailReason.CRFR_UnderNeedEnchant/*1*/:
					// End:0x125
					if(failReasons[i] == 3)
					{
						failReason = failReasons[i];
					}
					// End:0x133
					break;
				// End:0x130
				case CollectionRegistFailReason.CRFR_OverNeedEnchant/*3*/:
					// End:0x133
					break;
			}
		}
		else
		{
			if(canRegists[i] > 0)
			{
				canregist = true;
			}
		}
		return canregist;
	}
}

function bool ChkSerVer()
{
	return getInstanceUIData().getIsLiveServer();
}

defaultproperties
{
}
