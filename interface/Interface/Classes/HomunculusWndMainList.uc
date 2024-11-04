class HomunculusWndMainList extends UICommonAPI;

const LISTITEMMAX = 9;
const LISTMAX = 18;

var WindowHandle Me;
var string m_WindowName;
var HomunculusWndMainViewport homunculusWndMainViewportScript;
var HomunculusWndMainDetailStats homunculusWndMainDetailStatsScript;
var HomunculusWndMainDetailStatsEnchant homunculusWndMainDetailStatsEnchantScript;
var HomunculusWndBirth homunculusWndBirthScript;
var HomunculusWnd HomunculusWndScript;
var array<HomunculusWndMainListItem> listItems;
var int currentSelectedItemIndex;
var int currentSelectedIdx;
var int currentSelectedDataIndex;
var array<HomunculusAPI.HomunculusData> homunculusDatas;
var array<int> listNew;
var bool inited;
var int nActivateSlotIndex;
var UIControlPageNavi pageNavi;
var bool naviBtnClicked;

function HandleGameInit()
{
	// End:0x16
	if(! HomunculusWndScript.ChkSerVer())
	{
		return;
	}
	inited = false;
}

function HandleRestart()
{
	// End:0x16
	if(! HomunculusWndScript.ChkSerVer())
	{
		return;
	}
	inited = false;
}

function ClearAll()
{
	local int i;

	for ( i = 0;i < listItems.Length;i++ )
	{
		listItems[i].ClearAll();
	}
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	homunculusWndMainViewportScript = HomunculusWndMainViewport(GetScript("HomunculusWnd.HomunculusWndMainViewport"));
	homunculusWndMainDetailStatsScript = HomunculusWndMainDetailStats(GetScript("HomunculusWnd.HomunculusWndMainDetailStats"));
	homunculusWndMainDetailStatsEnchantScript = HomunculusWndMainDetailStatsEnchant(GetScript("HomunculusWnd.HomunculusWndMainDetailStatsEnchant"));
	homunculusWndBirthScript = HomunculusWndBirth(GetScript("HomunculusWnd.HomunculusWndBirth"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	InitPagenavi();
	InitHandleListItems();
}

function InitHandleListItems()
{
	local int i;

	for ( i = 0;i < LISTITEMMAX; i++ )
	{
		GetWindowHandle(m_WindowName $ ".Item" $ string(i)).SetScript("HomunculusWndMainListItem");
		listItems[i] = HomunculusWndMainListItem(GetWindowHandle(m_WindowName $ ".Item" $ string(i)).GetScript());
		listItems[i].Init(m_WindowName $ ".Item" $ string(i));
		listItems[i].SetState(listItems[i].type_State.Normal);
	}
	currentSelectedItemIndex = -1;
}

function InitPagenavi()
{
	local WindowHandle PageNaviControl;

	PageNaviControl = GetWindowHandle(m_WindowName $ ".PageNaviControl");
	PageNaviControl.SetScript("UIControlPageNavi");
	pageNavi = UIControlPageNavi(PageNaviControl.GetScript());
	pageNavi.Init(m_WindowName $ ".PageNaviControl");
	pageNavi.SetTotalPage(2);
	pageNavi.Go(1);
	pageNavi.DelegeOnChangePage = pageChanged;
	pageNavi.DelegateOnClickButton = pageNaviButtonClicked;
}

function API_EX_SHOW_HOMUNCULUS_INFO()
{
	HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(1);
}

function API_C_EX_HOMUNCULUS_ACTIVATE_SLOT(int SlotIndex)
{
	HomunculusWndScript.API_C_EX_HOMUNCULUS_ACTIVATE_SLOT(SlotIndex);
}

function OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_ShowHomunculusList);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_DELETE_HOMUNCLUS_DATA_RESULT));
}

function OnLoad()
{
	Initialize();
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x20
		case EV_ShowHomunculusList:
			HandleListItems();
			inited = true;
			// End:0x81
			break;
		// End:0x2E
		case EV_GamingStateEnter:
			HandleGameInit();
			// End:0x81
			break;
		// End:0x3C
		case EV_Restart:
			HandleRestart();
			// End:0x81
			break;
		// End:0x5D
		case EV_PacketID(class'UIPacket'.const.S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT):
			Handle_S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT();
			// End:0x81
			break;
		// End:0x7E
		case EV_PacketID(class'UIPacket'.const.S_EX_DELETE_HOMUNCLUS_DATA_RESULT):
			Handle_S_EX_DELETE_HOMUNCLUS_DATA_RESULT();
			// End:0x81
			break;
	}
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;
	local array<RequestItem> requestItems;
	local int i;

	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(GetSystemString(13557));
	popupExpandScript.SetUseNeedItem(true);
	requestItems = API_GetHomunculusSlotActivateCost(nActivateSlotIndex + 1);
	popupExpandScript.StartNeedItemList(requestItems.Length);

	// End:0xB8 [Loop If]
	for(i = 0; i < requestItems.Length; i++)
	{
		popupExpandScript.AddNeedItemClassID(requestItems[i].Id, requestItems[i].Amount);
	}
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = SetActivateSlot;
}

function array<RequestItem> API_GetHomunculusSlotActivateCost(int SlotIndex)
{
	return class'HomunculusAPI'.static.GetHomunculusSlotActivateCost(SlotIndex);
}

function SetActivateSlot()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.Hide();
	API_C_EX_HOMUNCULUS_ACTIVATE_SLOT(nActivateSlotIndex + 1);
}

function HandleListItemClicked(int itemIndex)
{
	switch(listItems[itemIndex].currState)
	{
		// End:0x33
		case listItems[itemIndex].type_State.NOTACTIVE:
			ShowPopup();
			// End:0xBF
			break;
		// End:0x7A
		case listItems[itemIndex].type_State.Normal:
			RemNew(listItems[itemIndex].currHomunculusData.idx);
			SetSelect(GetDataIndex(itemIndex));
			// End:0xBF
			break;
		// End:0xBC
		case listItems[itemIndex].type_State.READY:
			homunculusWndBirthScript.isGachaState = false;
			HomunculusWndScript.SetState(HomunculusWndScript.type_State.birth);
			// End:0xBF
			break;
	}
}

function DeSelect()
{
	local int i;

	for(i = 0; i < LISTITEMMAX; i++)
	{
		listItems[i].SetSelected(false);
	}

	HomunculusWndScript.ClearHomunculusData();
	currentSelectedDataIndex = -1;
	currentSelectedItemIndex = -1;
	currentSelectedIdx = -1;
}

function SetSelect(int dataindex)
{
	local int itemIndex;
	local int i;

	for(i = 0; i < LISTITEMMAX; i++)
	{
		listItems[i].SetSelected(false);
	}

	itemIndex = GetItemIndex(dataindex);
	currentSelectedIdx = homunculusDatas[dataindex].idx;
	currentSelectedDataIndex = dataindex;
	currentSelectedItemIndex = itemIndex;
	// End:0x95
	if(itemIndex != -1)
	{
		listItems[itemIndex].SetSelected(true);
	}
	HomunculusWndScript.RenewHomunculusData();
}

function Show()
{
	API_EX_SHOW_HOMUNCULUS_INFO();
	Me.ShowWindow();
	Me.SetFocus();
}

function Hide()
{
	Me.HideWindow();
}

function SetActiveIdx(bool bActive, int idx)
{
	local int Index;

	Index = GetDataIndexByIdx(idx);
	// End:0x22
	if(Index == -1)
	{
		return;
	}
	homunculusDatas[Index].Activate = bActive;
	listItems[Index].SetActive(bActive);
	homunculusWndMainViewportScript.SetActive(bActive);
}

function pageChanged(int Page)
{
	HandleListItems(naviBtnClicked);
}

function pageNaviButtonClicked(string buttonName)
{
	naviBtnClicked = true;
}

function SetActiveSlotIndex(int SlotIndex)
{
	// End:0x11
	if(nActivateSlotIndex > 0)
	{
		HandleListItems();
	}
	nActivateSlotIndex = SlotIndex;
}

function AddNew(int idx)
{
	local int Index;

	Index = GetIndexNew(idx);
	// End:0x22
	if(Index > -1)
	{
		return;
	}
	listNew[listNew.Length] = idx;
}

function RemNew(int idx)
{
	local int Index;

	Index = GetIndexNew(idx);
	// End:0x2C
	if(Index > -1)
	{
		listNew.Remove(Index, 1);
	}
}

function int HandleNew()
{
	local int i;
	local int dataindex;
	local int lastNewIdx;

	// End:0x19
	if(! inited)
	{
		listNew.Length = 0;
		return -1;
	}

	// End:0x6F [Loop If]
	for(i = 0; i < homunculusDatas.Length; i++)
	{
		// End:0x65
		if(homunculusDatas[i].IsNew)
		{
			lastNewIdx = homunculusDatas[i].idx;
			AddNew(lastNewIdx);
		}
	}
	// End:0xC1
	if(lastNewIdx > 0)
	{
		dataindex = GetDataIndexByIdx(lastNewIdx);
		// End:0xC1
		if(dataindex > -1)
		{
			currentSelectedIdx = lastNewIdx;
			currentSelectedDataIndex = dataindex;
			currentSelectedItemIndex = -1;
			return lastNewIdx;
		}
	}
	return -1;
}

function HandleListItems(optional bool dontGoToPage)
{
	local HomunculusAPI.HomunculusData newHomunculusData;
	local int i;
	local int dataindex;
	local int lastNewIdx;

	naviBtnClicked = false;
	homunculusDatas = HomunculusWndScript.API_GetHomunculusDatas();
	// End:0x38
	if(homunculusDatas.Length == 0)
	{
		homunculusWndMainViewportScript.SetNoneHomunculus();
	}
	// End:0xC7
	if(! dontGoToPage)
	{
		lastNewIdx = HandleNew();
		// End:0x7D
		if(lastNewIdx > 0)
		{
			pageNavi.Go(((GetDataIndexByIdx(lastNewIdx)) / 9) + 1);
			return;
		}
		// End:0xC7
		if(currentSelectedIdx > -1)
		{
			// End:0xC7
			if((GetPageByDataIndex(currentSelectedDataIndex)) != pageNavi.GetPage())
			{
				pageNavi.Go(GetPageByDataIndex(currentSelectedDataIndex));
				return;
			}
		}
	}
	
	for (i = 0; i < LISTITEMMAX; i++)
	{
		dataindex = GetDataIndex(i);
		// End:0x187
		if(dataindex < homunculusDatas.Length)
		{
			newHomunculusData = homunculusDatas[dataindex];
			listItems[i].SetState(listItems[i].type_State.Normal);
			newHomunculusData.IsNew = (GetIndexNew(newHomunculusData.idx)) != -1;
			listItems[i].SetHomunculusData(newHomunculusData);
			listItems[i].SetEnable();
		}
		// End:0x1FE
		if(dataindex == homunculusDatas.Length && homunculusWndBirthScript.BeProgress())
		{
			listItems[i].SetState(listItems[i].type_State.READY);
			listItems[i].SetOnBirth();
			listItems[i].SetEnable();
		}
		// End:0x236
		if(dataindex < nActivateSlotIndex)
		{
			listItems[i].SetState(listItems[i].type_State.READY);
		}
		// End:0x283
		if(dataindex == nActivateSlotIndex)
		{
			listItems[i].SetState(listItems[i].type_State.NOTACTIVE);
			listItems[i].SetEnable();
		}
		listItems[i].SetState(listItems[i].type_State.Lock);
	}
	dataindex = GetDataIndexByIdx(currentSelectedIdx);
	// End:0x2DC
	if(dataindex == -1)
	{
		DeSelect();		
	}
	else
	{
		SetSelect(dataindex);
	}
}

function Handle_S_EX_DELETE_HOMUNCLUS_DATA_RESULT()
{
	local UIPacket._S_EX_DELETE_HOMUNCLUS_DATA_RESULT packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_DELETE_HOMUNCLUS_DATA_RESULT(packet))
	{
		return;
	}
	// End:0x3F
	if(packet.Type == 1)
	{
		AddSystemMessage(13252);
		DeSelect();		
	}
	else
	{
		AddSystemMessage(packet.nID);
	}
}

function Handle_S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT()
{
	local UIPacket._S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT(packet))
	{
		return;
	}
	// End:0x31
	if(packet.Type == 1)
	{
		HandleListItems();
	}
}

function int GetDataIndex(int itemIndex)
{
	return itemIndex + ((pageNavi.GetPage() - 1) * 9);
}

function int GetItemIndex(int dataindex)
{
	// End:0x26
	if(pageNavi.GetPage() != ((dataindex / 9) + 1))
	{
		return -1;
	}
	return dataindex - ((pageNavi.GetPage() - 1) * 9);
}

function int GetPageByDataIndex(int dataindex)
{
	return (dataindex / 9) + 1;
}

function int GetDataIndexByIdx(int idx)
{
	local int i;

	for ( i = 0;i < homunculusDatas.Length;i++ )
	{
		// End:0x37
		if(homunculusDatas[i].idx == idx)
		{
			return i;
		}
	}
	return -1;
}

function int GetIndexNew(int idx)
{
	local int i;

	for ( i = 0;i < listNew.Length;i++ )
	{
		// End:0x32
		if(listNew[i] == idx)
		{
			return i;
		}
	}
	return -1;
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData()
{
	local HomunculusAPI.HomunculusData emptyHomunculusData;

	// End:0x1A
	if(currentSelectedDataIndex >= 0)
	{
		return homunculusDatas[currentSelectedDataIndex];
	}
	else
	{
		return emptyHomunculusData;
	}
}

function int GetEmptySlot()
{
	local int firstEmptySlot;

	firstEmptySlot = homunculusDatas.Length;
	// End:0x2C
	if(homunculusWndBirthScript.BeProgress())
	{
		firstEmptySlot = firstEmptySlot + 1;
	}
	// End:0x41
	if(firstEmptySlot == nActivateSlotIndex)
	{
		return -1;
	}
	return firstEmptySlot;
}

function bool CanActiveLock()
{
	local int SlotIndex;

	SlotIndex = nActivateSlotIndex;
	// End:0x2B
	if(homunculusWndBirthScript.BeProgress())
	{
		SlotIndex = SlotIndex + 1;
	}
	return SlotIndex < 18;
}

defaultproperties
{
}
