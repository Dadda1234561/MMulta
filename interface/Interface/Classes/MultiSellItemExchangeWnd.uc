class MultiSellItemExchangeWnd extends UICommonAPI;

const DIALOG_ID_ITEM_SET_COUNT = 1;
const TIMER_UPDATE_ID = 1;
const TIMER_UPDATEDELAY = 1;

struct MultiSellGroupInfo
{
	var int MultisellID;
	var int tabindex;
	var bool Loaded;
	var array<MultiSellInfo> infoList;
};

struct MultiSellRequestInfo
{
	var MultiSellInfo MultiSellInfo;
	var int MultisellID;
	var int exchangeNum;
	var int lastSelectedIndex;
	var bool needSelected;
};

struct NoStackableItemData
{
	var int ClassID;
	var INT64 Count;
};

struct multiSellData
{
	var int PcCafePoint;
	var int clanPoint;
	var int PvPPoint;
	var int RaidPoint;
	var int craftPoint;
	var INT64 vitalityPoint;
	var INT64 adena;
};

var array<ItemExchangeMultisellUIData> _multiSellTabInfos;
var int _selectedTabIndex;
var array<MultiSellGroupInfo> _multiSellGroupInfos;
var int _tempMultiSellInfoIndex;
var int _tempTabIndex;
var int _tempMultiSellId;
var int _tempShowType;
var array<MultiSellInfo> _tempMultiSellInfoList;
var bool _isWaitingResponse;
var MultiSellRequestInfo _requestInfo;
var multiSellData mData;
var UIData UIDataScript;
var bool hasEItemcheck;
var WindowHandle Me;
var WindowHandle disableWnd;
var WindowHandle availableListEmptyWnd;
var RichListCtrlHandle itemTotalRichList;
var RichListCtrlHandle itemAvailableRichList;
var UIControlGroupButtonAssets tabGroupButtonAsset;
var UIControlNeedItemList needItemScript;
var TabHandle multiSellTab;
var UIControlNumberInput inputItemScript;
var UIControlDialogAssets exchangeDialog;

static function MultiSellItemExchangeWnd Inst()
{
	return MultiSellItemExchangeWnd(GetScript("MultiSellItemExchangeWnd"));	
}

function Initialize()
{
	InitControls();	
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle needItemWnd, exchangeDialogWnd;
	local RichListCtrlHandle needItemRichList;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	UIDataScript = UIData(GetScript("UIData"));
	Me = GetWindowHandle(ownerFullPath);
	disableWnd = GetWindowHandle(ownerFullPath $ ".DisableWnd");
	exchangeDialogWnd = GetWindowHandle(ownerFullPath $ ".UIControlDialogAsset");
	exchangeDialog = class'UIControlDialogAssets'.static.InitScript(exchangeDialogWnd);
	exchangeDialog.DelegateOnCancel = OnExchangeDialogCancel;
	exchangeDialog.DelegateOnClickBuy = OnExchangeDialogConfirm;
	exchangeDialog.SetUseBuyItem(true);
	exchangeDialog.SetUseNeedItem(false);
	exchangeDialog.SetUseNumberInput(false);
	exchangeDialog.SetDisableWindow(disableWnd);
	itemTotalRichList = GetRichListCtrlHandle(ownerFullPath $ ".MultisellTabTotalWnd.ItemTotal_RichList");
	itemTotalRichList.SetSelectedSelTooltip(false);
	itemTotalRichList.SetAppearTooltipAtMouseX(true);
	itemAvailableRichList = GetRichListCtrlHandle(ownerFullPath $ ".MultisellTabEnableWnd.ItemEnable_RichList");
	itemAvailableRichList.SetSelectedSelTooltip(false);
	itemAvailableRichList.SetAppearTooltipAtMouseX(true);
	availableListEmptyWnd = GetWindowHandle(ownerFullPath $ ".MultisellTabEnableWnd.ListDisable_Wnd");
	multiSellTab = GetTabHandle(ownerFullPath $ ".MultiSellTab");
	tabGroupButtonAsset = class'UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle(ownerFullPath $ ".TopGroupButtonAsset"));
	tabGroupButtonAsset._SetStartInfo("L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", true);
	tabGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = OnTabGroupBtnClicked;
	needItemWnd = GetWindowHandle(ownerFullPath $ ".Bottom_Wnd.NeedItemWnd");
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemRichList = GetRichListCtrlHandle(needItemWnd.m_WindowNameWithFullPath $ ".NeedItemRichListCtrl");
	needItemScript.SetRichListControler(needItemRichList);
	needItemRichList.SetTooltipType("UIControlNeedItemList");
	inputItemScript = class'UIControlNumberInput'.static.InitScript(GetWindowHandle(ownerFullPath $ ".Bottom_Wnd.InputItemWnd"));
	inputItemScript._SetUseCaculator(true);
	inputItemScript.DelegateGetCountCanBuy = MaxNumCanBuy;
	inputItemScript.DelegateOnItemCountEdited = OnItemCountChanged;
	inputItemScript.DelegateESCKey = OnItemCountESCKey;
	inputItemScript.DelegateOnClickInput = OnSetCountBtnClicked;
	inputItemScript.DelegateOnClickBuy = OnExchangeBtnClicked;	
}

function ResetInfo()
{
	_multiSellGroupInfos.Length = 0;
	_multiSellTabInfos.Length = 0;
	_isWaitingResponse = false;
	ResetTempInfo();	
}

function ResetTempInfo()
{
	_tempMultiSellInfoList.Length = 0;
	_tempMultiSellInfoIndex = 0;
	_tempMultiSellId = 0;
	_tempTabIndex = -1;	
}

function InitTabButtonControls(int SelectedIndex)
{
	local int i;

	// End:0x3A8 [Loop If]
	for(i = 0; i < _multiSellTabInfos.Length; i++)
	{
		tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(i, _multiSellTabInfos[i].MultisellName);
		tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(i, i);
		// End:0x131
		if(_multiSellTabInfos.Length == 1)
		{
			tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(i, "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected");
			// [Explicit Continue]
			continue;
		}
		// End:0x1FF
		if(i == 0)
		{
			tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(i, "L2UI_NewTex.WindowTab.FlatBrown_Tab_Left_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Left_Selected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Left_Unselected_Over");
			// [Explicit Continue]
			continue;
		}
		// End:0x2D8
		if(i == _multiSellTabInfos.Length - 1)
		{
			tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(i, "L2UI_NewTex.WindowTab.FlatBrown_Tab_Right_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Right_Selected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Right_Unselected_Over");
			// [Explicit Continue]
			continue;
		}
		tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(i, "L2UI_NewTex.WindowTab.FlatBrown_Tab_Center_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Center_Selected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Center_Unselected_Over");
	}
	tabGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(_multiSellTabInfos.Length);
	tabGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(594, 0);
	tabGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(SelectedIndex, true);	
}

function UpdateTabButtonControls();

function UpdateItemListControls()
{
	local MultiSellGroupInfo groupInfo;
	local int i, N, arrayIndex;
	local bool bNoExchange, bCheck;
	local ItemInfo Info;
	local RichListCtrlRowData tempRowData;
	local array<NoStackableItemData> noStackableItemDataArray;

	// End:0x21
	if(_selectedTabIndex < _multiSellGroupInfos.Length)
	{
		groupInfo = _multiSellGroupInfos[_selectedTabIndex];
	}
	itemTotalRichList.DeleteAllItem();
	itemAvailableRichList.DeleteAllItem();

	// End:0x1F2 [Loop If]
	for(i = 0; i < groupInfo.infoList.Length; i++)
	{
		bNoExchange = false;
		bCheck = true;
		noStackableItemDataArray.Length = 0;
		Info = groupInfo.infoList[i].OutputItemInfoList[0];

		// End:0x18B [Loop If]
		for(N = 0; N < groupInfo.infoList[i].InputItemInfoList.Length; N++)
		{
			// End:0x10B
			if(IsStackableItem(groupInfo.infoList[i].InputItemInfoList[N].ConsumeType))
			{
				bCheck = CompareWithInven(groupInfo.infoList[i].InputItemInfoList[N]);				
			}
			else
			{
				arrayIndex = GetNoStackableItemCountArrayIndex(groupInfo.infoList[i].InputItemInfoList[N], noStackableItemDataArray);
				bCheck = CompareWithInven(groupInfo.infoList[i].InputItemInfoList[N], noStackableItemDataArray[arrayIndex]);
			}
			// End:0x181
			if(bCheck == false)
			{
				bNoExchange = true;
				// [Explicit Continue]
				continue;
			}
		}
		// End:0x1CF
		if(bNoExchange == false)
		{
			Info.ForeTexture = "L2UI_CT1.SellablePanel";
			AddItemRichListCtrl(itemAvailableRichList, Info, i);
		}
		// End:0x1E8
		if(true)
		{
			AddItemRichListCtrl(itemTotalRichList, Info, i);
		}
	}
	// End:0x219
	if(itemAvailableRichList.GetRecordCount() > 0)
	{
		availableListEmptyWnd.HideWindow();		
	}
	else
	{
		availableListEmptyWnd.ShowWindow();
	}
	// End:0x360
	if(_requestInfo.needSelected == true)
	{
		_requestInfo.needSelected = false;
		// End:0x360
		if(_requestInfo.lastSelectedIndex > -1)
		{
			// End:0x2E9
			if(multiSellTab.GetTopIndex() == 0)
			{
				// End:0x2E6 [Loop If]
				for(i = 0; i < itemTotalRichList.GetRecordCount(); i++)
				{
					itemTotalRichList.GetRec(i, tempRowData);
					// End:0x2DC
					if(tempRowData.nReserved2 == _requestInfo.lastSelectedIndex)
					{
						itemTotalRichList.SetSelectedIndex(i, true);
						// [Explicit Break]
						break;
					}
				}
			}
			else
			{
				// End:0x360 [Loop If]
				for(i = 0; i < itemAvailableRichList.GetRecordCount(); i++)
				{
					itemAvailableRichList.GetRec(i, tempRowData);
					// End:0x356
					if(tempRowData.nReserved2 == _requestInfo.lastSelectedIndex)
					{
						itemAvailableRichList.SetSelectedIndex(i, true);
						// [Explicit Break]
						break;
					}
				}
			}
		}
	}	
}

function UpdateItemInfoControls(optional bool modifyList)
{
	local int i;
	local MultiSellInfo MultiSellInfo;

	// End:0x1D
	if(modifyList == false)
	{
		needItemScript.StartNeedItemList(2);
	}
	// End:0x151
	if(GetSelectedMultiSellInfo(MultiSellInfo))
	{
		for(i = 0; i < MultiSellInfo.InputItemInfoList.Length; i++)
		{
			// End:0xC7
			if(isPointType(MultiSellInfo.InputItemInfoList[i]))
			{
				needItemScript.AddNeedPoint(MultiSellInfo.InputItemInfoList[i].Name, MultiSellInfo.InputItemInfoList[i].IconName, MultiSellInfo.InputItemInfoList[i].ItemNum, getHasItemOrPointCount(MultiSellInfo.InputItemInfoList[i]));
				// [Explicit Continue]
				continue;
			}
			needItemScript.AddNeedItemClassID(MultiSellInfo.InputItemInfoList[i].Id.ClassID, MultiSellInfo.InputItemInfoList[i].ItemNum);
		}
		// End:0x13C
		if(needItemScript.GetMaxNumCanBuy() > 0)
		{
			inputItemScript.SetCount(1);			
		}
		else
		{
			inputItemScript.SetCount(0);
		}		
	}
	else
	{
		inputItemScript.SetCount(0);
	}
}

function UpdateUIControlsWithTimer()
{
	Me.KillTimer(TIMER_UPDATE_ID);
	Me.SetTimer(TIMER_UPDATE_ID, TIMER_UPDATEDELAY);	
}

function UpdateUIControls()
{
	UpdateTabButtonControls();
	UpdateItemListControls();
	UpdateItemInfoControls();	
}

function AddItemRichListCtrl(RichListCtrlHandle itemListCtrl, ItemInfo Info, int Index)
{
	local RichListCtrlRowData Record;
	local string fullNameString, toolTipParam;
	local L2Util util;

	fullNameString = GetItemNameAll(Info, true);
	util = getInstanceL2Util();
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.cellDataList.Length = 1;
	Record.nReserved1 = Info.ConsumeType;
	Record.nReserved2 = Index;
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 8, 1);
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, Info, 32, 32, -34, 1);
	// End:0x11C
	if(Info.IconPanel != "")
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconPanel, 32, 32, -32, 0);
	}
	// End:0x168
	if(Info.IsBlessedItem)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "Icon.icon_panel.bless_panel", 32, 32, -32, 0);
	}
	// End:0x178
	if(Info.Enchanted > 0)
	{
	}
	// End:0x1B4
	if(Info.ForeTexture != "")
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.ForeTexture, 32, 32, -32, 0);
	}
	// End:0x2BE
	if(IsStackableItem(Info.ConsumeType))
	{
		addRichListCtrlString(Record.cellDataList[0].drawitems, fullNameString, util.White, false, 6, 10);
		// End:0x23A
		if(Info.AdditionalName != "")
		{
			addRichListCtrlString(Record.cellDataList[0].drawitems, Info.AdditionalName, util.Yellow03, false, 3, 0);
		}
		// End:0x28E
		if(Info.ItemNum > 0)
		{
			addRichListCtrlString(Record.cellDataList[0].drawitems, "(" $ string(Info.ItemNum) $ ")", util.White, false, 0, 0);			
		}
		else
		{
			addRichListCtrlString(Record.cellDataList[0].drawitems, "(1)", util.White, false, 0, 0);
		}		
	}
	else
	{
		addRichListCtrlString(Record.cellDataList[0].drawitems, fullNameString, util.White, false, 6, 10);
		// End:0x331
		if(Info.AdditionalName != "")
		{
			addRichListCtrlString(Record.cellDataList[0].drawitems, Info.AdditionalName, util.Yellow03, false, 3, 0);
		}
	}
	itemListCtrl.InsertRecord(Record);	
}

function ShowItemCountDialog()
{
	local ItemInfo Info;

	DialogHide();
	Debug("ShowItemCountDialog");
	DialogSetReservedItemID(Info.Id);
	DialogSetParamInt64(needItemScript.GetMaxNumCanBuy());
	DialogSetID(DIALOG_ID_ITEM_SET_COUNT);
	DialogSetCancelD(DIALOG_ID_ITEM_SET_COUNT);
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362), string(self));
	class'DialogBox'.static.Inst().AnchorToOwner(0, 100);
	class'DialogBox'.static.Inst().DelegateOnCancel = OnItemCountDialogCancel;
	class'DialogBox'.static.Inst().DelegateOnOK = OnItemCountDialogConfirm;
	class'DialogBox'.static.Inst().DelegateOnHide = OnItemCountDialogHide;
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);	
}

function ShowExchangeDialog()
{
	local ItemInfo ItemInfo, inputItemInfo;
	local MultiSellInfo MultiSellInfo;
	local int inputItemCnt, i, descId;

	// End:0x0F
	if(DialogIsMine())
	{
		DialogHide();
	}
	// End:0x22
	if((GetSelectedMultiSellInfo(MultiSellInfo)) == false)
	{
		return;
	}
	// End:0x34
	if(_selectedTabIndex >= _multiSellGroupInfos.Length)
	{
		return;
	}
	inputItemCnt = int(inputItemScript.GetCount());
	// End:0x58
	if(inputItemCnt <= 0)
	{
		return;
	}
	hasEItemcheck = false;

	// End:0xF2 [Loop If]
	for(i = 0; i < MultiSellInfo.InputItemInfoList.Length; i++)
	{
		inputItemInfo = MultiSellInfo.InputItemInfoList[i];
		// End:0xE8
		if(inputItemInfo.ItemType == 0 || inputItemInfo.ItemType == 1 || inputItemInfo.ItemType == 2)
		{
			// End:0xE8
			if((isPointType(inputItemInfo)) == false)
			{
				hasEItemcheck = true;
			}
		}
	}
	_requestInfo.MultiSellInfo = MultiSellInfo;
	_requestInfo.exchangeNum = inputItemCnt;
	_requestInfo.MultisellID = _multiSellGroupInfos[_selectedTabIndex].MultisellID;
	ItemInfo = MultiSellInfo.OutputItemInfoList[0];
	// End:0x156
	if(hasEItemcheck)
	{
		descId = 13801;		
	}
	else
	{
		descId = 13800;
	}
	exchangeDialog.SetDialogDesc(MakeFullSystemMsg(GetSystemMessage(descId), GetItemNameAll(ItemInfo)));
	exchangeDialog.SetBuyItemInfo(ItemInfo, int(ItemInfo.ItemNum), 0);
	exchangeDialog.SetItemNum(_requestInfo.exchangeNum);
	exchangeDialog.OKButton.EnableWindow();
	exchangeDialog.Show();	
}

function int GetNoStackableItemCountArrayIndex(ItemInfo inputItemInfo, out array<NoStackableItemData> noStackableItemDataArray)
{
	local int arrayIndex, nClassID;
	local INT64 noStackableNeedItemNum;
	local array<ItemInfo> hasItemInfoArray;

	// End:0x121
	if(! IsStackableItem(inputItemInfo.ConsumeType))
	{
		nClassID = inputItemInfo.Id.ClassID;
		noStackableNeedItemNum = class'UIDATA_INVENTORY'.static.FindItemByClassID(nClassID, hasItemInfoArray);
		arrayIndex = GetIndexArray(nClassID, noStackableItemDataArray);
		// End:0xE1
		if(arrayIndex == -1)
		{
			noStackableItemDataArray.Length = noStackableItemDataArray.Length + 1;
			// End:0xC0
			if(noStackableItemDataArray.Length > 0)
			{
				noStackableItemDataArray[noStackableItemDataArray.Length - 1].ClassID = nClassID;
				noStackableItemDataArray[noStackableItemDataArray.Length - 1].Count = noStackableNeedItemNum;
			}
			// End:0xDE
			if(arrayIndex == -1)
			{
				arrayIndex = noStackableItemDataArray.Length - 1;
			}			
		}
		else
		{
			// End:0x121
			if(noStackableItemDataArray[arrayIndex].Count > 0)
			{
				noStackableItemDataArray[arrayIndex].Count = noStackableItemDataArray[arrayIndex].Count - 1;
			}
		}
	}
	return arrayIndex;	
}

function int GetSelectedItemIndex()
{
	local int selectedListIndex;
	local RichListCtrlRowData Record;

	selectedListIndex = -1;
	// End:0x64
	if(multiSellTab.GetTopIndex() == 0)
	{
		selectedListIndex = itemTotalRichList.GetSelectedIndex();
		// End:0x61
		if(selectedListIndex >= 0)
		{
			itemTotalRichList.GetSelectedRec(Record);
			return int(Record.nReserved2);
		}		
	}
	else
	{
		selectedListIndex = itemAvailableRichList.GetSelectedIndex();
		// End:0xA5
		if(selectedListIndex >= 0)
		{
			itemAvailableRichList.GetSelectedRec(Record);
			return int(Record.nReserved2);
		}
	}
	return selectedListIndex;	
}

function bool GetSelectedMultiSellInfo(out MultiSellInfo MultiSellInfo)
{
	local int SelectedIndex;

	SelectedIndex = GetSelectedItemIndex();
	// End:0x1D
	if(SelectedIndex == -1)
	{
		return false;
	}
	// End:0x66
	if(_selectedTabIndex < _multiSellGroupInfos.Length)
	{
		// End:0x66
		if(SelectedIndex < _multiSellGroupInfos[_selectedTabIndex].infoList.Length)
		{
			MultiSellInfo = _multiSellGroupInfos[_selectedTabIndex].infoList[SelectedIndex];
			return true;
		}
	}
	return false;	
}

function int GetIndexArray(int ClassID, out array<NoStackableItemData> noStackableItemDataArray)
{
	local int i;

	// End:0x41 [Loop If]
	for(i = 0; i < noStackableItemDataArray.Length; i++)
	{
		// End:0x37
		if(noStackableItemDataArray[i].ClassID == ClassID)
		{
			return i;
		}
	}
	return -1;	
}

function bool CompareWithInven(ItemInfo Info, optional NoStackableItemData noStackableItemDataInfo)
{
	local ItemInfo InvenItemInfo;
	local bool flag;
	local int hasItemCount;
	local array<ItemInfo> itemInfoArr;

	// End:0x36
	if(Info.IconName == GetPcCafeItemIconPackageName())
	{
		// End:0x33
		if(mData.PcCafePoint >= Info.ItemNum)
		{
			return true;
		}		
	}
	else if(Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00")
	{
		// End:0x89
		if(mData.clanPoint >= Info.ItemNum)
		{
			return true;
		}			
	}
	else if(Info.IconName == "icon.pvp_point_i00")
	{
		// End:0xCD
		if(mData.PvPPoint >= Info.ItemNum)
		{
			return true;
		}				
	}
	else if(Info.IconName == "icon.etc_i.etc_rp_point_i00")
	{
		// End:0x11A
		if(mData.RaidPoint >= Info.ItemNum)
		{
			return true;
		}					
	}
	else if(Info.IconName == "Icon.etc_i.craft_point")
	{
		// End:0x162
		if(mData.craftPoint >= Info.ItemNum)
		{
			return true;
		}						
	}
	else if(Info.IconName == "icon.etc_sayha_point_01")
	{
		// End:0x1A9
		if(mData.vitalityPoint >= Info.ItemNum)
		{
			return true;
		}							
	}
	else if(Info.Id.ClassID > 0)
	{
		itemInfoArr.Length = 0;
		hasItemCount = class'UIDATA_INVENTORY'.static.FindItemByClassID(Info.Id.ClassID, itemInfoArr);
		// End:0x26E
		if(hasItemCount > 0)
		{
			InvenItemInfo = itemInfoArr[0];
			// End:0x23C
			if(IsStackableItem(InvenItemInfo.ConsumeType))
			{
				// End:0x239
				if(InvenItemInfo.ItemNum >= Info.ItemNum)
				{
					return true;
				}										
			}
			else
			{
				// End:0x267
				if(noStackableItemDataInfo.ClassID > 0)
				{
					// End:0x267
					if(noStackableItemDataInfo.Count > 0)
					{
						flag = true;
					}
				}
				return flag;
			}
		}
	}
	return false;	
}

function bool isPointType(ItemInfo Info)
{
	local bool RValue;

	// End:0x20
	if(Info.IconName == GetPcCafeItemIconPackageName())
	{
		RValue = true;		
	}
	else if(Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00")
	{
		RValue = true;			
	}
	else if(Info.IconName == "icon.pvp_point_i00")
	{
		RValue = true;				
	}
	else if(Info.IconName == "icon.etc_i.etc_rp_point_i00")
	{
		RValue = true;					
	}
	else if(Info.IconName == "Icon.etc_i.craft_point")
	{
		RValue = true;						
	}
	else if(Info.IconName == "icon.etc_sayha_point_01")
	{
		RValue = true;
	}

	return RValue;	
}

function INT64 getHasItemOrPointCount(ItemInfo Info)
{
	local INT64 hasNum;
	local array<ItemInfo> itemInfoArray;
	local int ItemCount;

	// End:0x2A
	if(Info.IconName == GetPcCafeItemIconPackageName())
	{
		hasNum = mData.PcCafePoint;		
	}
	else if(Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00")
	{
		hasNum = mData.clanPoint;			
	}
	else if(Info.IconName == "icon.pvp_point_i00")
	{
		hasNum = mData.PvPPoint;				
	}
	else if(Info.IconName == "icon.etc_i.etc_rp_point_i00")
	{
		hasNum = mData.RaidPoint;					
	}
	else if(Info.IconName == "Icon.etc_i.craft_point")
	{
		hasNum = mData.craftPoint;						
	}
	else if(Info.IconName == "icon.etc_sayha_point_01")
	{
		hasNum = mData.vitalityPoint;							
	}
	else
	{
		ItemCount = class'UIDATA_INVENTORY'.static.FindItemByClassID(Info.Id.ClassID, itemInfoArray);
		// End:0x1AA
		if(ItemCount > 0)
		{
			hasNum = itemInfoArray[0].ItemNum;
		}
	}
	return hasNum;	
}

function updateMultiSellData(optional string serverUpdateParam)
{
	local int nPointCount, nPoint, nType, N;
	local UserInfo PlayerInfo;

	GetPlayerInfo(PlayerInfo);
	ParseInt(serverUpdateParam, "NumPoint", nPointCount);
	
	// End:0x153 [Loop If]
	for(N = 0; N < nPointCount; N++)
	{
		ParseInt(serverUpdateParam, "Type" $ string(N), nType);
		ParseInt(serverUpdateParam, "Point" $ string(N), nPoint);
		// End:0x9C
		if(MSIT_RAID_POINT == nType)
		{
			mData.PvPPoint = nPoint;
			// [Explicit Continue]
			continue;
		}
		// End:0xBE
		if(MSIT_PVP_POINT == nType)
		{
			mData.PvPPoint = nPoint;
			// [Explicit Continue]
			continue;
		}
		// End:0xF4
		if(MSIT_PLEDGE_POINT == nType)
		{
			mData.clanPoint = nPoint;
			UIDataScript.setCurrentClanNameValue(nPoint);
			// [Explicit Continue]
			continue;
		}
		// End:0x12A
		if(MSIT_PCCAFE_POINT == nType)
		{
			mData.PcCafePoint = nPoint;
			UIDataScript.setPcCafePoint(nPoint);
			// [Explicit Continue]
			continue;
		}
		// End:0x149
		if(MSIT_CRAFT_POINT == nType)
		{
			mData.craftPoint = nPoint;
		}
	}
	// End:0x1D6
	if(nPointCount <= 0)
	{
		mData.PvPPoint = PlayerInfo.PvPPoint;
		mData.RaidPoint = PlayerInfo.RaidPoint;
		mData.PcCafePoint = UIDataScript.getCurrentPcCafePoint();
		mData.clanPoint = UIDataScript.getCurrentClanNameValue();
		mData.craftPoint = UIDataScript.getCurrentCraftPoint();
	}
	mData.vitalityPoint = UIDataScript.getCurrentVitalityPoint();	
}

function INT64 MaxNumCanBuy()
{
	local MultiSellInfo MultiSellInfo;
	local INT64 Count;

	// End:0x66
	if(GetSelectedMultiSellInfo(MultiSellInfo))
	{
		// End:0x44
		if(IsStackableItem(MultiSellInfo.OutputItemInfoList[0].ConsumeType))
		{
			Count = int(needItemScript.GetMaxNumCanBuy());			
		}
		else
		{
			Count = Min(1, int(needItemScript.GetMaxNumCanBuy()));
		}
		return Count;
	}
	return 0;	
}

event OnRegisterEvent()
{
	RegisterEvent(EV_MultiSellInfoListBegin);
	RegisterEvent(EV_MultiSellResultItemInfo);
	RegisterEvent(EV_MultiSellOutputItemInfo);
	RegisterEvent(EV_MultiSellInputItemInfo);
	RegisterEvent(EV_MultiSellInfoListEnd);
	RegisterEvent(EV_MultiSellResult);
	RegisterEvent(EV_ShowSimpleItemExchangeMultisellWnd);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);	
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x1D
		case EV_ShowSimpleItemExchangeMultisellWnd:
			Rs_EV_ShowSimpleItemExchangeMultisellWnd(param);
			// End:0x20
			break;
	}
	// End:0x37
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	// End:0x60
	if(Event_ID == EV_MultiSellInfoListBegin)
	{
		ParseInt(param, "ShowType", _tempShowType);
	}
	// End:0xFC
	if(_tempShowType == 4)
	{
		switch(Event_ID)
		{
			// End:0x8B
			case EV_MultiSellInfoListBegin:
				Rs_EV_MultiSellInfoListBegin(param);
				// End:0xFC
				break;
			// End:0xA1
			case EV_MultiSellResultItemInfo:
				Rs_EV_MultiSellResultItemInfo(param);
				// End:0xFC
				break;
			// End:0xB7
			case EV_MultiSellOutputItemInfo:
				Rs_EV_MultiSellOutputItemInfo(param);
				// End:0xFC
				break;
			// End:0xCD
			case EV_MultiSellInputItemInfo:
				Rs_EV_MultiSellInputItemInfo(param);
				// End:0xFC
				break;
			// End:0xE3
			case EV_MultiSellInfoListEnd:
				Rs_EV_MultiSellInfoListEnd(param);
				// End:0xFC
				break;
			// End:0xF9
			case EV_MultiSellResult:
				Nt_EV_MultiSellResult(param);
				// End:0xFC
				break;
		}
	}
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();	
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Me.SetFocus();	
}

event OnHide()
{
	// End:0x0F
	if(DialogIsMine())
	{
		DialogHide();
	}
	exchangeDialog.Hide();
	ResetInfo();
	needItemScript.CleariObjects();
	Me.KillTimer(TIMER_UPDATE_ID);	
}

function OnTimer(int TimerID)
{
	// End:0x21
	if(TimerID == TIMER_UPDATE_ID)
	{
		UpdateUIControls();
		Me.KillTimer(TIMER_UPDATE_ID);
	}	
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	local int MultisellID;

	_selectedTabIndex = Index;
	// End:0x97
	if(Index < _multiSellTabInfos.Length)
	{
		MultisellID = _multiSellTabInfos[Index].MultisellID;
		// End:0x97
		if(MultisellID > 0)
		{
			// End:0x87
			if(Index < _multiSellGroupInfos.Length && _multiSellGroupInfos[Index].MultisellID == MultisellID && _multiSellGroupInfos[Index].Loaded)
			{
				UpdateUIControls();				
			}
			else
			{
				Rq_C_EX_MULTI_SELL_LIST(MultisellID, Index);
			}
		}
	}	
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		// End:0x19
		case "MultiSellTab0":
		// End:0x34
		case "MultiSellTab1":
			UpdateItemInfoControls();
			// End:0x37
			break;
	}	
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	// End:0x18
	if(Me.IsShowWindow())
	{
		ShowExchangeDialog();
	}	
}

event OnItemCountChanged(INT64 ItemCount)
{
	ItemCount = MAX64(1, ItemCount);
	needItemScript.SetBuyNum(int(ItemCount));	
}

event OnSetCountBtnClicked()
{
	ShowItemCountDialog();	
}

event OnExchangeBtnClicked()
{
	ShowExchangeDialog();	
}

event OnItemCountDialogCancel();

event OnItemCountDialogConfirm()
{
	// End:0x22
	if(DialogIsMine())
	{
		inputItemScript.SetCount(int(DialogGetString()));
	}	
}

event OnItemCountDialogHide()
{
	disableWnd.HideWindow();	
}

event OnExchangeDialogConfirm()
{
	local string param;
	local MultiSellInfo MultiSellInfo;

	MultiSellInfo = _requestInfo.MultiSellInfo;
	ParamAdd(param, "MultiSellGroupID", string(_requestInfo.MultisellID));
	ParamAdd(param, "MultiSellInfoID", string(MultiSellInfo.MultiSellInfoID));
	ParamAdd(param, "ItemCount", string(_requestInfo.exchangeNum));
	ParamAdd(param, "Enchant", string(MultiSellInfo.ResultItemInfo.Enchanted));
	ParamAdd(param, "RefineryOp1", string(MultiSellInfo.ResultItemInfo.RefineryOp1));
	ParamAdd(param, "RefineryOp2", string(MultiSellInfo.ResultItemInfo.RefineryOp2));
	ParamAdd(param, "AttrAttackType", string(MultiSellInfo.ResultItemInfo.AttackAttributeType));
	ParamAdd(param, "AttrAttackValue", string(MultiSellInfo.ResultItemInfo.AttackAttributeValue));
	ParamAdd(param, "AttrDefenseValueFire", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueFire));
	ParamAdd(param, "AttrDefenseValueWater", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueWater));
	ParamAdd(param, "AttrDefenseValueWind", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueWind));
	ParamAdd(param, "AttrDefenseValueEarth", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueEarth));
	ParamAdd(param, "AttrDefenseValueHoly", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueHoly));
	ParamAdd(param, "AttrDefenseValueUnholy", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueUnholy));
	addParamEnsoulOptionInfo(MultiSellInfo.ResultItemInfo, param);
	ParamAdd(param, "IsBlessedItem", string(boolToNum(MultiSellInfo.ResultItemInfo.IsBlessedItem)));
	_requestInfo.lastSelectedIndex = GetSelectedItemIndex();
	_requestInfo.needSelected = true;
	RequestMultiSellChoose(param);
	exchangeDialog.Hide();	
}

event OnExchangeDialogCancel()
{
	exchangeDialog.Hide();	
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		// End:0x27
		case "ItemTotal_RichList":
			UpdateItemInfoControls();
			// End:0x4B
			break;
		// End:0x48
		case "ItemEnable_RichList":
			UpdateItemInfoControls();
			// End:0x4B
			break;
	}	
}

event OnItemCountESCKey()
{
	// End:0x27
	if(multiSellTab.GetTopIndex() == 0)
	{
		itemTotalRichList.SetFocus();		
	}
	else
	{
		itemAvailableRichList.SetFocus();
	}	
}

event OnReceivedCloseUI()
{
	// End:0x2D
	if(exchangeDialog.Me.IsShowWindow())
	{
		exchangeDialog.Hide();		
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}	
}

function OpenWindow(int ItemClassID)
{
	// End:0x23
	if(Me.IsShowWindow())
	{
		Me.HideWindow();
		return;
	}
	// End:0x49
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		return;
	}
	ResetInfo();
	multiSellTab.SetTopOrder(0, false);
	inputItemScript.SetCount(0);
	disableWnd.HideWindow();
	updateMultiSellData();
	GetItemExchangeMultisellData(ItemClassID, _multiSellTabInfos);
	_selectedTabIndex = 0;
	hasEItemcheck = false;
	InitTabButtonControls(_selectedTabIndex);
	Rq_C_EX_MULTI_SELL_LIST(_multiSellTabInfos[_selectedTabIndex].MultisellID, _selectedTabIndex);
	UpdateUIControls();
	Me.ShowWindow();	
}

function addEnsoulInfo(int slotType, int slotCount, string param, out ItemInfo Info)
{
	local int N, nEOptionID;

	// End:0x82 [Loop If]
	for(N = 1; N < slotCount + 1; N++)
	{
		ParseInt(param, "EnsoulOptionID_" $ string(slotType) $ "_" $ string(N), nEOptionID);
		Info.EnsoulOption[slotType - 1].OptionArray[N - 1] = nEOptionID;
	}	
}

function Rq_C_EX_MULTI_SELL_LIST(int MultisellID, int tabindex)
{
	local array<byte> stream;
	local UIPacket._C_EX_MULTI_SELL_LIST packet;

	packet.nGroupID = MultisellID;
	// End:0x52
	if(tabindex < _multiSellGroupInfos.Length)
	{
		// End:0x52
		if((_multiSellGroupInfos[tabindex].MultisellID == MultisellID) && _multiSellGroupInfos[tabindex].Loaded)
		{
			return;
		}
	}
	// End:0x60
	if(_isWaitingResponse == true)
	{
		return;
	}
	// End:0x80
	if(! class'UIPacket'.static.Encode_C_EX_MULTI_SELL_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MULTI_SELL_LIST, stream);
	_isWaitingResponse = true;	
}

function Rs_EV_ShowSimpleItemExchangeMultisellWnd(string param)
{
	local int ItemClassID;

	ParseInt(param, "ItemClassID", ItemClassID);
	OpenWindow(ItemClassID);	
}

function Rs_EV_MultiSellInfoListBegin(string param)
{
	ParseInt(param, "MultiSellGroupID", _tempMultiSellId);
	_tempTabIndex = _selectedTabIndex;	
}

function Rs_EV_MultiSellResultItemInfo(string param)
{
	local int nMultiSellInfoID, nBuyType, nIsBlessedItem, ensoulNormalSlot, ensoulBmSlot;

	local ItemInfo Info;

	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "BuyType", nBuyType);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);
	ParseInt(param, "EnsoulOptionNum_" $ string(2), ensoulBmSlot);
	ParseInt(param, "EnsoulOptionNum_" $ string(1), ensoulNormalSlot);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	_tempMultiSellInfoIndex = _tempMultiSellInfoList.Length;
	_tempMultiSellInfoList.Length = _tempMultiSellInfoList.Length + 1;
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].MultiSellInfoID = nMultiSellInfoID;
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].MultiSellType = nBuyType;
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].ResultItemInfo = Info;	
}

function Rs_EV_MultiSellOutputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentOutputItemInfoIndex, nIsBlessedItem, nItemClassID, ensoulNormalSlot, ensoulBmSlot;

	local ItemInfo Info;

	ParseItemID(param, Info.Id);
	class'UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseINT64(param, "SlotBitType", Info.SlotBitType);
	ParseInt(param, "ItemType", Info.ItemType);
	ParseINT64(param, "ItemCount", Info.ItemNum);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);
	ParseInt(param, "EnsoulOptionNum_" $ string(2), ensoulBmSlot);
	ParseInt(param, "EnsoulOptionNum_" $ string(1), ensoulNormalSlot);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	// End:0x379
	if(_tempMultiSellInfoList[_tempMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		return;
	}
	// End:0x3DF
	if(nItemClassID == MSIT_PCCAFE_POINT)
	{
		Info.Name = GetSystemString(1277);
		Info.IconName = GetPcCafeItemIconPackageName();
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;		
	}
	else if(nItemClassID == MSIT_PLEDGE_POINT)
	{
		Info.Name = GetSystemString(1311);
		Info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;			
	}
	else if(nItemClassID == MSIT_PVP_POINT)
	{
		Info.Name = GetSystemString(102);
		Info.IconName = "icon.pvp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;				
	}
	else if(nItemClassID == MSIT_RAID_POINT)
	{
		Info.Name = GetSystemString(3183);
		Info.IconName = "icon.etc_i.etc_rp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;					
	}
	else if(nItemClassID == MSIT_CRAFT_POINT)
	{
		Info.Name = GetSystemString(13159);
		Info.IconName = "Icon.etc_i.craft_point";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;						
	}
	else if(nItemClassID == MSIT_VITAL_POINT)
	{
		Info.Name = GetSystemString(2492);
		Info.IconName = "icon.etc_sayha_point_01";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	// End:0x666
	if(0 < Info.Durability)
	{
		Info.CurrentDurability = Info.Durability;
	}
	nCurrentOutputItemInfoIndex = _tempMultiSellInfoList[_tempMultiSellInfoIndex].OutputItemInfoList.Length;
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].OutputItemInfoList.Length = nCurrentOutputItemInfoIndex + 1;
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = Info;
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex].Reserved = _tempMultiSellInfoIndex;	
}

function Rs_EV_MultiSellInputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentInputItemInfoIndex, nItemClassID, nIsBlessedItem, ensoulNormalSlot, ensoulBmSlot;

	local ItemInfo Info;

	ParseItemID(param, Info.Id);
	class'UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "ItemType", Info.ItemType);
	ParseINT64(param, "ItemCount", Info.ItemNum);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);
	ParseInt(param, "EnsoulOptionNum_" $ string(2), ensoulBmSlot);
	ParseInt(param, "EnsoulOptionNum_" $ string(1), ensoulNormalSlot);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	// End:0x357
	if(_tempMultiSellInfoList[_tempMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		return;
	}
	// End:0x3BD
	if(nItemClassID == MSIT_PCCAFE_POINT)
	{
		Info.Name = GetSystemString(1277);
		Info.IconName = GetPcCafeItemIconPackageName();
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;		
	}
	else if(nItemClassID == MSIT_PLEDGE_POINT)
	{
		Info.Name = GetSystemString(1311);
		Info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;			
	}
	else if(nItemClassID == MSIT_PVP_POINT)
	{
		Info.Name = GetSystemString(102);
		Info.IconName = "icon.pvp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;				
	}
	else if(nItemClassID == MSIT_RAID_POINT)
	{
		Info.Name = GetSystemString(3183);
		Info.IconName = "icon.etc_i.etc_rp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;					
	}
	else if(nItemClassID == MSIT_CRAFT_POINT)
	{
		Info.Name = GetSystemString(13159);
		Info.IconName = "Icon.etc_i.craft_point";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;						
	}
	else if(nItemClassID == MSIT_VITAL_POINT)
	{
		Info.Name = GetSystemString(2492);
		Info.IconName = "icon.etc_sayha_point_01";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;							
	}
	else
	{
		Info.Name = class'UIDATA_ITEM'.static.GetItemName(Info.Id);
		Info.IconName = class'UIDATA_ITEM'.static.GetItemTextureName(Info.Id);
	}
	Info.CrystalType = class'UIDATA_ITEM'.static.GetItemCrystalType(Info.Id);
	// End:0x6EA
	if(nItemClassID != MSIT_FIELD_CYCLE_POINT)
	{
		nCurrentInputItemInfoIndex = _tempMultiSellInfoList[_tempMultiSellInfoIndex].InputItemInfoList.Length;
		_tempMultiSellInfoList[_tempMultiSellInfoIndex].InputItemInfoList.Length = nCurrentInputItemInfoIndex + 1;
		_tempMultiSellInfoList[_tempMultiSellInfoIndex].InputItemInfoList[nCurrentInputItemInfoIndex] = Info;
	}	
}

function Rs_EV_MultiSellInfoListEnd(string param)
{
	local MultiSellGroupInfo groupInfo;

	groupInfo.infoList = _tempMultiSellInfoList;
	groupInfo.MultisellID = _tempMultiSellId;
	groupInfo.tabindex = _tempTabIndex;
	groupInfo.Loaded = true;
	_multiSellGroupInfos[_tempTabIndex] = groupInfo;
	_isWaitingResponse = false;
	updateMultiSellData();
	UpdateUIControlsWithTimer();
	ResetTempInfo();	
}

function Nt_EV_MultiSellResult(string param)
{
	local int Success, i;

	ParseInt(param, "Success", Success);
	Debug("MultiSellItemExchangeWnd Nt_EV_MultiSellResult" @ string(Success));
	// End:0xCB
	if(hasEItemcheck == true)
	{
		// End:0x98 [Loop If]
		for(i = 0; i < _multiSellGroupInfos.Length; i++)
		{
			_multiSellGroupInfos[i].Loaded = false;
		}
		// End:0xC3
		if(_selectedTabIndex < _multiSellTabInfos.Length)
		{
			Rq_C_EX_MULTI_SELL_LIST(_multiSellTabInfos[_selectedTabIndex].MultisellID, _selectedTabIndex);
		}
		hasEItemcheck = false;
	}	
}

defaultproperties
{
}
