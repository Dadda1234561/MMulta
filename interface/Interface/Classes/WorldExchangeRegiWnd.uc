class WorldExchangeRegiWnd extends UICommonAPI;

const MAXRegiItemNum = 10;
const MINRegiBundlePrice = 10;
const ADENA_CLASSID = 57;
const LCOIN_CLASSID = 4037;
const MAXITEMNUM = 1000;
const INSERT_ONCE_LIST_NUM = 10;
const LOAD_ONCE_LIST_NUM = 100;
const REFRESHLIMIT = 1000;
const REFRESHLIMITMIN = 500;

const REQUEST_FILTER_ADENA = 0;
const REQUEST_FILTER_COINS = 1;
const REQUEST_FILTER_ALL = 2;

enum E_WORLD_EXCHANGE_SORT_TYPE 
{
	EWEST_NONE,
	EWEST_ITEM_NAME,
	EWEST_ENCHANT_ASCE,
	EWEST_ENCHANT_DESC,
	EWEST_PRICE_ASCE,
	EWEST_PRICE_DESC,
	EWEST_AMOUNT_ASCE,
	EWEST_AMOUNT_DESC,
	EWEST_PRICE_PER_PIECE_ASCE,
	EWEST_PRICE_PER_PIECE_DESC
};

var int refreshMinCount;
var int lastLoadedPage;
var int nMaxPage;
var bool bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST;
var bool bRQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE;
var array<UIPacket._WorldExchangeItemData> _itemDatas;
var WindowHandle FindDisable_Wnd;
var WindowHandle WindowDisable_Wnd;
var L2UITimerObject tObject;
var L2UITimerObject tObjectListAdd;
var RichListCtrlHandle ExchangeFind_RichList;
var ItemInfo sellItemInfo;
var ItemInfo readySellItemInfo;
var int scrollPos;
var int _regieditemNum;
var int sortHeaderIndex;
var float nAveragePrice;
var UIControlNumberInput itemSell_NumberInputScr;
var UIControlNumberInput bundlePrice_NumberInputScr;
var WorldExchangeRegiWndItemHistoryTabWnd historyScr;

var CheckBoxHandle	hUseAdenaCheckBox;
var CheckBoxHandle	hUseCoinCheckBox;
var ECoinType m_eCoinType;
var ItemInfo m_LCoinInfo;
var string strLCoinName;

static function WorldExchangeRegiWnd Inst()
{
	return WorldExchangeRegiWnd(GetScript("WorldExchangeRegiWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_ITEM_LIST));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_REGI_ITEM));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_AVERAGE_PRICE));
}

event OnLoad()
{
	SetClosingOnESC();
	hUseAdenaCheckBox = GetCheckBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox");
	hUseCoinCheckBox = GetCheckBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseCoinCheckBox");
	
	m_eCoinType = ECoinType.ERCT_LCOIN;
	m_LCoinInfo = GetItemInfoByClassID(LCOIN_CLASSID);
	strLCoinName = GetLCoinName();

	hUseAdenaCheckBox.SetTitle(GetSystemString(5216)); // Адены
	hUseCoinCheckBox.SetTitle(strLCoinName); // ЛКоины

	ExchangeFind_RichList = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ExchangeFind_RichList");
	ExchangeFind_RichList.SetSelectedSelTooltip(false);
	ExchangeFind_RichList.SetAppearTooltipAtMouseX(true);
	ExchangeFind_RichList.SetSortable(false);

	itemSell_NumberInputScr = class'UIControlNumberInput'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.ItemSell_NumberInput"));
	bundlePrice_NumberInputScr = class'UIControlNumberInput'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_NumberInput"));
	bundlePrice_NumberInputScr._SetMinCountCanBuy(0);
	itemSell_NumberInputScr.DelegateGetCountCanBuy = DelegateGetCanSellItemNum;
	bundlePrice_NumberInputScr.DelegateGetCountCanBuy = GetCanLcoinPriceItemNum;
	itemSell_NumberInputScr.DelegateOnClickInput = HandleOnItemCountEditBtonClicked;
	bundlePrice_NumberInputScr.DelegateOnClickInput = HandleOnPriceCountEditBtonClicked;
	itemSell_NumberInputScr._SetUseCaculator(true);
	bundlePrice_NumberInputScr._SetUseCaculator(true);
	itemSell_NumberInputScr._SetForceDisable(true);
	bundlePrice_NumberInputScr._SetForceDisable(true);
	itemSell_NumberInputScr.DelegateESCKey = OnReceivedCloseUI;
	bundlePrice_NumberInputScr.DelegateESCKey = OnReceivedCloseUI;
	itemSell_NumberInputScr.DelegateOnItemCountEdited = HandleOnitemCountEdited;
	bundlePrice_NumberInputScr.DelegateOnItemCountEdited = HandleOnPriceCountEdited;
	bundlePrice_NumberInputScr.DelegateOnOverInput = HandleOnOverInput;


	AddItemListenerSimple(ADENA_CLASSID, 0, ADENA_CLASSID).DelegateOnUpdateItem = HandleMyItemChanged;
	AddItemListenerSimple(LCOIN_CLASSID, 0, LCOIN_CLASSID).DelegateOnUpdateItem = HandleMyItemChanged;

	tObject = class'L2UITimer'.static.Inst()._AddNewTimerObject(1000);
	tObject._DelegateOnEnd = SetEnableRefresh;
	SetTimerObject();
	SetScriptHistory();
	FindDisable_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.FindDisable_Wnd");
	FindDisable_Wnd.ShowWindow();
	WindowDisable_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".WindowDisable_Wnd");
	Get_MyAdenaCount_Txt().SetText("0" @ GetSystemString(469));
	Get_MyLcoinCount_Txt().SetText("0" @ strLCoinName);
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.SellTime_txt").SetText("-");
	SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_ASCE/*8*/);
}

function SetTimerObject()
{
	local int Time, Count;

	Count = 100 / 10;
	Time = 1000 / Count;
	tObjectListAdd = class'L2UITimer'.static.Inst()._AddNewTimerObject(Time, Count);
	tObjectListAdd._DelegateOnStart = TInsertRecord;
	tObjectListAdd._DelegateOnTime = TInsertRecordOnTime;
	tObjectListAdd._DelegateOnEnd = TInserDelayCheck;
	refreshMinCount = 500 / Time;	
}

function SetScriptHistory()
{
	local WindowHandle historyWnd;

	historyWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemHistoryTabWnd");
	historyWnd.SetScript("WorldExchangeRegiWndItemHistoryTabWnd");
	historyScr = WorldExchangeRegiWndItemHistoryTabWnd(historyWnd.GetScript());
	historyScr.m_hOwnerWnd = historyWnd;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		// End:0x27
		case EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_ITEM_LIST):
			RT_S_EX_WORLD_EXCHANGE_ITEM_LIST();
			// End:0x4A
			break;
		// End:0x47
		case EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_REGI_ITEM):
			RT_S_EX_WORLD_EXCHANGE_REGI_ITEM();
			// End:0x4A
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_AVERAGE_PRICE):
			RT_S_EX_WORLD_EXCHANGE_AVERAGE_PRICE();
			// End:0x6A
			break;
	}
}

event OnScrollMove(string strID, int pos)
{
	switch(strID)
	{
		// End:0x2F
		case "ExchangeFind_RichList":
			HandleScrollMove(pos);
			// End:0x32
			break;
	}
}

event OnShow()
{
	SetMyInfos();
	historyScr.RQ_C_EX_WORLD_EXCHANGE_SETTLE_LIST();
	CheckWorldExchangeRegiSubWnd();
	HandleClickCoinRadioButton();
	class'WorldExchangeBuyWnd'.static.Inst()._Hide();
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	DelItemInfo();
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.TaxRateTitle_txt").SetText(GetSystemString(1608) $ ":" @ string(API_GetWorldExchangeData().SellFee) $ "%");
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.TaxRateTitle_txt").SetText(GetSystemString(1608) $ ":" @ string(API_GetWorldExchangeData().SellFee) $ "%");
	// End:0x15E
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		tObjectListAdd._Reset();
		tObject._Reset();
	}
	SetHideSellDialogWindow();
	// End:0x1AB
	if(getInstanceUIData().getIsLiveServer())
	{
		SideBar(GetScript("SideBar")).ToggleByWindowName("WorldExchangeBuyWnd", true);
	}	
}

event OnHide()
{
	// End:0x36
	if((DialogIsMine()) && class'DialogBox'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		DialogHide();
	}
	// End:0x7D
	if(getInstanceUIData().getIsLiveServer())
	{
		SideBar(GetScript("SideBar")).ToggleByWindowName("WorldExchangeBuyWnd", false);
	}	
}

function bool IsCoinActive()
{
	return class'UIAPI_CHECKBOX'.static.IsChecked(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseCoinCheckBox");
}

function bool IsAdenaActive()
{
	return class'UIAPI_CHECKBOX'.static.IsChecked(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox");
}

function HandleClickAdenaRadioButton()
{
	class'UIAPI_CHECKBOX'.static.SetCheck(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseCoinCheckBox", false );
	class'UIAPI_CHECKBOX'.static.SetCheck(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox", true );

	// DBG_SendMessageToChat("HandleClickAdenaRadioButton: hUseAdenaCheckBox.IsChecked() == " $ hUseAdenaCheckBox.IsChecked() $ " &&  hUseCoinCheckBox.IsChecked() == " $ hUseCoinCheckBox.IsChecked());
	// DBG_SendMessageToChat("HandleClickAdenaRadioButton: hUseAdenaCheckBox.IsChecked() == " $ IsAdenaActive() $ " &&  hUseCoinCheckBox.IsChecked() == " $ IsCoinActive());

	GetMeTexture("RegiTabWnd.ItemRegi_Wnd.BundlePrice_NumberInput.BundlePriceIcon_Tex").SetTexture("L2UI_CT1.Icon.Icon_DF_Common_Adena");
	m_eCoinType = ECoinType.ERCT_ADENA;
	bundlePrice_NumberInputScr._SetMinCountCanBuy(class'WorldExchangeBuyWnd'.static.Inst().ADENA_MIN);
	bundlePrice_NumberInputScr._SetPlusBasicUnit(class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT);
	bundlePrice_NumberInputScr.SetCount(class'WorldExchangeBuyWnd'.static.Inst().ADENA_MIN);
}

function HandleClickCoinRadioButton()
{
	class'UIAPI_CHECKBOX'.static.SetCheck(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox", false );
	class'UIAPI_CHECKBOX'.static.SetCheck(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseCoinCheckBox", true );

	// DBG_SendMessageToChat("HandleClickCoinRadioButton: hUseAdenaCheckBox.IsChecked() == " $ hUseAdenaCheckBox.IsChecked() $ " &&  hUseCoinCheckBox.IsChecked() == " $ hUseCoinCheckBox.IsChecked());
	// DBG_SendMessageToChat("HandleClickCoinRadioButton: hUseAdenaCheckBox.IsChecked() == " $ IsAdenaActive() $ " &&  hUseCoinCheckBox.IsChecked() == " $ IsCoinActive());

	GetMeTexture("RegiTabWnd.ItemRegi_Wnd.BundlePrice_NumberInput.BundlePriceIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");

	m_eCoinType = ECoinType.ERCT_LCOIN;
	bundlePrice_NumberInputScr._SetMinCountCanBuy(class'WorldExchangeBuyWnd'.static.Inst().LCOIN_MIN);
	bundlePrice_NumberInputScr._SetPlusBasicUnit(class'WorldExchangeBuyWnd'.static.Inst().LCOIN_BASIC_UNIT);
	bundlePrice_NumberInputScr.SetCount(class'WorldExchangeBuyWnd'.static.Inst().LCOIN_MIN);
}

// Get name of the LCoin
function string GetLCoinName()
{
	if ( m_LCoinInfo.Id.ClassID == 0 )
	{
		// return system string if item info is not found
		return GetSystemString(3931);
	}
	return m_LCoinInfo.Name;
}

event OnClickCheckBox(string strID)
{
	local ECoinType prevCoinType;

	prevCoinType = m_eCoinType;

	switch(strID)
	{
		case "UseAdenaCheckBox":
				HandleClickAdenaRadioButton();
			// End:0x126
			break;
		case "UseCoinCheckBox":
				HandleClickCoinRadioButton();
			// End:0x126
			break;
	}
}


// Get selected currency id
private function int GetSelectedCurrencyID()
{
	if ( m_eCoinType == ECoinType.ERCT_ADENA )
	{
		return ADENA_CLASSID;
	}
	else if ( m_eCoinType == ECoinType.ERCT_LCOIN )
	{
		return LCOIN_CLASSID;
	}
	return 0;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x3E
		case "GetReward_Btn":
			HandleGetRewardBtn();
			// End:0x126
			break;
		// End:0x58
		case "WndClose_BTN":
			_Hide();
			// End:0x126
			break;
		// End:0x71
		case "Refresh_btn":
			HandleRefresh();
			// End:0x126
			break;
		// End:0x8A
		case "MoveWnd_Btn":
			handleSwap();
			// End:0x126
			break;
		// End:0xA2
		case "Cancel_Btn":
			SetHideSellDialogWindow();
			// End:0x126
			break;
		// End:0xBC
		case "Ok_Btn":
			HandleClickOK_Btn();
			// End:0x126
			break;
		// End:0xD7
		case "Cancel_Ok_Btn":
			HandleCancelOK();
			// End:0x126
			break;
		// End:0xF6
		case "Cancel_Cancel_Btn":
			HandleCancelCancel();
			// End:0x126
			break;
		// End:0x108
		case "RegiList_Tab0":
		// End:0x123
		case "RegiList_Tab1":
			CheckWorldExchangeRegiSubWnd();
			// End:0x126
			break;
	}
}

event OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	local ItemInfo iInfo;

	// End:0x22
	if(a_hItemWindow.GetParentWindowName() == "Dialog_Wnd")
	{
		return;
	}
	a_hItemWindow.GetItem(a_Index, iInfo);
	ItemDrop(iInfo);
}

event OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	local ItemInfo iInfo;

	// End:0x22
	if(a_hItemWindow.GetParentWindowName() == "Dialog_Wnd")
	{
		return;
	}
	a_hItemWindow.GetItem(a_Index, iInfo);
	ItemDrop(iInfo);
}

event OnDropItemSource(string strTarget, ItemInfo Info)
{
	// End:0x0B
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	// End:0x25
	if(strTarget == "Item_ItemWnd")
	{
		return;
	}
	// End:0x44
	if(Info.DragSrcName != "Item_ItemWnd")
	{
		return;
	}
	ItemDrop(Info);
}

function ItemDrop(ItemInfo Info)
{
	// End:0x47
	if(class'InputAPI'.static.IsAltPressed() || ! IsStackableItem(Info.ConsumeType) || Info.ItemNum == 1)
	{
		DelItemInfo();		
	}
	else
	{
		// End:0x1A1
		if(IsAdena(Info.Id))
		{
			class'DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
			DialogShow(DialogModalType_Modalless, DialogType_NumberPadAdena, MakeFullSystemMsg(GetSystemMessage(1833), sellItemInfo.Name, ""), string(self));
			class'DialogBox'.static.Inst().AnchorToOwner();
			class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOKSource;
			DialogSetInputlimit(Min64(sellItemInfo.ItemNum / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT, class'WorldExchangeBuyWnd'.static.Inst().ADENA_MAX / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT));
			DialogSetParamInt64(Min64(sellItemInfo.ItemNum / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT, class'WorldExchangeBuyWnd'.static.Inst().ADENA_MAX / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT));						
		}
		else
		{
			class'DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(1833), sellItemInfo.Name, ""), string(self));
			class'DialogBox'.static.Inst().AnchorToOwner();
			class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOKSource;
			DialogSetInputlimit(sellItemInfo.ItemNum);
			DialogSetParamInt64(sellItemInfo.ItemNum);
		}
	}
}

event OnDropItem(string strTarget, ItemInfo iInfo, int X, int Y)
{
	// End:0x0B
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	// End:0x34
	if(_regieditemNum == 10)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13688));
		return;
	}
	// End:0x5F
	if(iInfo.DragSrcName != "itemEnchantSubWndItemWnd")
	{
		return;
	}
	// End:0xDF
	if(class'InputAPI'.static.IsAltPressed() || ! IsStackableItem(iInfo.ConsumeType) || iInfo.ItemNum == 1)
	{
		SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_ASCE/*8*/);
		sellItemInfo = iInfo;
		sellItemInfo.ItemNum = GetSellItemInfoNum(iInfo.Id.ServerID);
		SetItemInfo();
		RQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE();		
	}
	else
	{
		readySellItemInfo = iInfo;
		class'DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
		// End:0x240
		if(IsAdena(iInfo.Id))
		{
			// End:0x15D
			if(iInfo.ItemNum < class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT)
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13750));
				return;
			}
			
			DialogShow(DialogModalType_Modalless, DialogType_NumberPadAdena, GetSystemString(14193), string(self));
			DialogSetInputlimit(Min64(iInfo.ItemNum / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT, class'WorldExchangeBuyWnd'.static.Inst().ADENA_MAX / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT));
			DialogSetParamInt64(Min64(iInfo.ItemNum / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT, class'WorldExchangeBuyWnd'.static.Inst().ADENA_MAX / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT));			
		}
		else
		{
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), iInfo.Name, ""), string(self));
			DialogSetInputlimit(Min64(1000, iInfo.ItemNum));
			DialogSetParamInt64(Min64(1000, iInfo.ItemNum));
		}
		class'DialogBox'.static.Inst().AnchorToOwner();
		class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOKDrop;
	}
}

event OnClickHeaderCtrl(string strID, int Index)
{
	// End:0x0B
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	SetSortByHeaderIndex(Index);
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
}

function WorldExchangeUIData API_GetWorldExchangeData()
{
	return GetWorldExchangeData();
}

function int API_GetServerPrivateStoreSearchItemSubType(int a_ClassID)
{
	return GetServerPrivateStoreSearchItemSubType(a_ClassID);
}

function RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST(optional int Page)
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_ITEM_LIST packet;

	// End:0x0B
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	// End:0x19
	if(_itemDatas.Length > 0)
	{
		return;
	}
	// End:0x35
	if(Page > 0)
	{
		// End:0x35
		if(nMaxPage < Page)
		{
			return;
		}
	}
	if(IsAdena(sellItemInfo.Id))
	{
		if(class'WorldExchangeBuyWnd'.static.Inst()._IsNewServer())
		{
			ExchangeFind_RichList.SetColumnString(2, 14424);			
		}
		else
		{
			ExchangeFind_RichList.SetColumnString(2, 14192);
		}
		bundlePrice_NumberInputScr.SetCount(bundlePrice_NumberInputScr.GetCount());		
	}
	else
	{
		ExchangeFind_RichList.SetColumnString(2, 2511);
	}
	SetDisablbRefresh();
	lastLoadedPage = Page;
	packet.nCategory = API_GetServerPrivateStoreSearchItemSubType(sellItemInfo.Id.ClassID);
	packet.cSortType = GetSortType();
	packet.nPage = Page;
	packet.vItemIDList[0] = sellItemInfo.Id.ClassID;
	packet.cType = int(m_eCoinType); // (0 - Adena, 1 - Lcoin)
	// End:0x123
	if(! class'UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_ITEM_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLD_EXCHANGE_ITEM_LIST, stream);
}

function RT_S_EX_WORLD_EXCHANGE_ITEM_LIST()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_ITEM_LIST packet;

	// End:0x16
	if(! m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	// End:0x31
	if(! class'UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_ITEM_LIST(packet))
	{
		return;
	}
	Debug("Handle_S_EX_WORLD_EXCHANGE_ITEM_LIST" @ string(_itemDatas.Length));
	// End:0x9F
	if(lastLoadedPage == 0)
	{
		_itemDatas.Length = 0;
		ExchangeFind_RichList.DeleteAllItem();
		FindDisable_Wnd.ShowWindow();
		nMaxPage = 0;
	}
	// End:0xBB
	if(packet.vItemDataList.Length == 100)
	{
		++ nMaxPage;		
	}
	else
	{
		nMaxPage = lastLoadedPage;
	}
	Handle_S_EX_WORLD_EXCHANGE_ITEM_LIST(packet);
}

function Handle_S_EX_WORLD_EXCHANGE_ITEM_LIST(UIPacket._S_EX_WORLD_EXCHANGE_ITEM_LIST packet)
{
	local int i;

	tObjectListAdd._Reset();
	// End:0x28
	if(packet.vItemDataList.Length == 0)
	{
		SetEnableRefresh();
		return;
	}
	FindDisable_Wnd.HideWindow();

	// End:0x91 [Loop If]
	for(i = 0; i < packet.vItemDataList.Length; i++)
	{
		_itemDatas[_itemDatas.Length] = packet.vItemDataList[i];
	}
}

function RQ_C_EX_WORLD_EXCHANGE_REGI_ITEM()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_REGI_ITEM packet;

	packet.nItemSid = sellItemInfo.Id.ServerID;
	packet.nAmount = itemSell_NumberInputScr.GetCount();
	packet.nPrice = bundlePrice_NumberInputScr.GetCount();
	packet.nCurrencyId = GetSelectedCurrencyID();
	// End:0x6E
	if(! class'UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_REGI_ITEM(stream, packet))
	{
		return;
	}
	Debug("RQ_C_EX_WORLD_EXCHANGE_REGI_ITEM" @ string(packet.nItemSid) @ string(packet.nAmount) @ string(packet.nPrice));
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLD_EXCHANGE_REGI_ITEM, stream);
}

private function RT_S_EX_WORLD_EXCHANGE_REGI_ITEM()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_REGI_ITEM packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_REGI_ITEM(packet))
	{
		return;
	}
	// End:0x43
	if(packet.cSuccess == 1)
	{
		DelItemInfo();
		historyScr.RQ_C_EX_WORLD_EXCHANGE_SETTLE_LIST();		
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4334));
	}
}

private function RQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_AVERAGE_PRICE packet;

	nAveragePrice = 0.0f;
	packet.nItemID = sellItemInfo.Id.ClassID;
	// End:0x45
	if(! class'UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE(stream, packet))
	{
		return;
	}
	Debug("RQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE" @ string(packet.nItemID));
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLD_EXCHANGE_AVERAGE_PRICE, stream);
	bRQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE = true;	
}

private function RT_S_EX_WORLD_EXCHANGE_AVERAGE_PRICE()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_AVERAGE_PRICE packet;

	bRQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE = false;
	// End:0x23
	if(! class'UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_AVERAGE_PRICE(packet))
	{
		return;
	}
	Debug("RT_S_EX_WORLD_EXCHANGE_AVERAGE_PRICE" @ string(packet.nItemID) @ string(sellItemInfo.Id.ClassID) @ string(packet.nAveragePrice));
	// End:0xB4
	if(packet.nItemID == sellItemInfo.Id.ClassID)
	{
		nAveragePrice = float(packet.nAveragePrice) / 100;
	}	
}

function _ShowDisableWIndow()
{
	WindowDisable_Wnd.ShowWindow();
	WindowDisable_Wnd.SetFocus();
}

function _HideDisableWindow()
{
	WindowDisable_Wnd.HideWindow();
}

function SetDisablbRefresh()
{
	bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST = true;
	_ShowDisableWIndow();
	tObject._Reset();
}

function SetEnableRefresh()
{
	bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST = false;
	WindowDisable_Wnd.HideWindow();
}

function SetItemInfo()
{
	local ItemWindowHandle Item_ItemWnd;

	Item_ItemWnd = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.Item_ItemWnd");
	Item_ItemWnd.Clear();
	sellItemInfo.bShowCount = IsStackableItem(sellItemInfo.ConsumeType);
	Item_ItemWnd.AddItem(sellItemInfo);
	// End:0xE6
	if(IsAdena(sellItemInfo.Id))
	{
		if (m_eCoinType != ECoinType.ERCT_LCOIN)
		{
			// Toggle states of check boxes
			class'UIAPI_CHECKBOX'.static.SetCheck(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox", false);
			class'UIAPI_CHECKBOX'.static.SetCheck(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseCoinCheckBox", true);

			// Disable adena checkbox
			class'UIAPI_CHECKBOX'.static.SetDisable(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox", true);
		}

		itemSell_NumberInputScr._SetMinCountCanBuy(class'WorldExchangeBuyWnd'.static.Inst().ADENA_MIN);
		itemSell_NumberInputScr._SetPlusBasicUnit(class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT);		
	}
	else
	{
		// Reactivate adena checkbox
		if (class'UIAPI_CHECKBOX'.static.IsDisable(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox"))
		{
			class'UIAPI_CHECKBOX'.static.SetDisable(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox", false);
		}

		itemSell_NumberInputScr._SetMinCountCanBuy(1);
		itemSell_NumberInputScr._SetPlusBasicUnit(1);
	}

	itemSell_NumberInputScr.SetCount(sellItemInfo.ItemNum);
	itemSell_NumberInputScr._SetForceDisable(false);
	bundlePrice_NumberInputScr._SetForceDisable(false);

	// Enabling radio buttons for coin selection when item is selected
	if (IsAdenaActive()) {
		HandleClickAdenaRadioButton();
	} else if (IsCoinActive()) {
		HandleClickCoinRadioButton();
	}
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Refresh_btn").EnableWindow();
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST(0);
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.SellTime_txt").SetText(GetSystemString(14084));
}

function DelItemInfo()
{
	local ItemInfo emptyInfo;
	GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.Item_ItemWnd").Clear();
	itemSell_NumberInputScr._SetForceDisable(true);
	bundlePrice_NumberInputScr._SetForceDisable(true);
	// End:0x91
	if(itemSell_NumberInputScr.GetCount() != 0)
	{
		itemSell_NumberInputScr.SetCount(0);
	}
	// End:0xBB
	if(bundlePrice_NumberInputScr.GetCount() != 0)
	{
		bundlePrice_NumberInputScr.SetCount(0);
	}
	Get_UnitPriceCount_Txt().SetText("0");
	Get_RegiFeePiceCount_Txt().SetText("0" @ GetSystemString(469));
	Get_RegiFeePiceCount_TxtUnit_Txt().SetText("");
	Get_SellFeePiceCount_Txt().SetText("0" @ strLCoinName);
	Get_UnitPriceCount_Txt().SetText("0");
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.GetReward_Btn").DisableWindow();
	
	if (IsAdena(sellItemInfo.Id))
	{
		// Reactivate adena checkbox
		if (class'UIAPI_CHECKBOX'.static.IsDisable(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox"))
		{
			class'UIAPI_CHECKBOX'.static.SetDisable(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox", false);
		}
	}

	sellItemInfo = emptyInfo;
	lastLoadedPage = 0;
	ExchangeFind_RichList.DeleteAllItem();

	// reset regi coin type
	// m_eRegiCoinType = ECoinType.ERCT_LCOIN;

	FindDisable_Wnd.ShowWindow();
	tObjectListAdd._Stop();
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Refresh_btn").DisableWindow();
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.SellTime_txt").SetText("-");
}

function INT64 DelegateGetCanSellItemNum()
{
	return GetSellItemInfoNum(sellItemInfo.Id.ServerID);
}

function INT64 GetSellItemInfoNum(int sererID)
{
	local ItemInfo iInfo;

	// End:0x3A
	if(class'UIDATA_INVENTORY'.static.FindItem(sellItemInfo.Id.ServerID, iInfo))
	{
		// End:0x9B
		if(IsAdena(iInfo.Id))
		{
			return Min64((iInfo.ItemNum / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT) * class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT, class'WorldExchangeBuyWnd'.static.Inst().ADENA_MAX);			
		}
		else
		{
			return Min64(1000, iInfo.ItemNum);
		}
	}
	return 0;
}

function INT64 GetCanLcoinPriceItemNum()
{
	local INT64 Adena;
	local WorldExchangeUIData tmpWorldExchangeUIData;

	tmpWorldExchangeUIData = API_GetWorldExchangeData();

	if (m_eCoinType == ECoinType.ERCT_ADENA)
	{
		return class'WorldExchangeBuyWnd'.static.Inst().ADENA_MAX;
	}
	return class'WorldExchangeBuyWnd'.static.Inst().LCOIN_MAX;
}

function INT64 GetCommitionRegist(ECoinType coinType)
{
	local WorldExchangeUIData tmpWorldExchangeUIData;

	tmpWorldExchangeUIData = API_GetWorldExchangeData();
	if (coinType == ECoinType.ERCT_ADENA)
	{
		// Calculate 5% of bundle price
		return float(bundlePrice_NumberInputScr.GetCount() / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT) * (float(tmpWorldExchangeUIData.RegistFee) / 100);
		// return bundlePrice_NumberInputScr.GetCount() / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT * tmpWorldExchangeUIData.RegistFee;
		// return float((bundlePrice_NumberInputScr.GetCount() / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT)) * (float(tmpWorldExchangeUIData.RegistFee) / 100);
	}
	return bundlePrice_NumberInputScr.GetCount() * tmpWorldExchangeUIData.RegistFee;
}

function int GetCommitionSell()
{
	local WorldExchangeUIData tmpWorldExchangeUIData;

	tmpWorldExchangeUIData = API_GetWorldExchangeData();
	return Min(tmpWorldExchangeUIData.MaxSellFee, int(float(bundlePrice_NumberInputScr.GetCount()) * (float(tmpWorldExchangeUIData.SellFee) / 100)));	
}

function _GetSellItemInfo(out ItemInfo ItemInfo)
{
	ItemInfo = sellItemInfo;
}

function HandleScrollMove(optional int pos)
{
	scrollPos = pos;
	// End:0x16
	if(bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST)
	{
		return;
	}
	// End:0x4E
	if(pos == (ExchangeFind_RichList.GetRecordCount() - ExchangeFind_RichList.GetShowRow()))
	{
		RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST(lastLoadedPage + 1);
	}
}

function TInsertRecordOnTime(int Count)
{
	TInsertRecord();
}

function TInsertRecord()
{
	local int i, Cnt;
	local RichListCtrlRowData RowData;

	// End:0x50
	if(_itemDatas.Length == 0)
	{
		// End:0x4E
		if(tObjectListAdd._curCount >= refreshMinCount)
		{
			tObjectListAdd._Stop();
			tObject._Stop();
			TInserDelayCheck();
			SetEnableRefresh();
		}
		return;
	}
	Cnt = Min(10, _itemDatas.Length);
	// End:0xD6
	if(IsAdena(sellItemInfo.Id))
	{
		// End:0xD3 [Loop If]
		for(i = 0; i < Cnt; i++)
		{
			// End:0xC9
			if(class'WorldExchangeBuyWnd'.static.Inst()._MakeRowDataAdena(_itemDatas[i], RowData))
			{
				ExchangeFind_RichList.InsertRecord(RowData);
			}
		}		
	}
	else
	{
		// End:0x123 [Loop If]
		for(i = 0; i < Cnt; i++)
		{
			// End:0x119
			if(MakeRowData(_itemDatas[i], RowData))
			{
				ExchangeFind_RichList.InsertRecord(RowData);
			}
		}
	}
	_itemDatas.Remove(0, Cnt);
}

function TInserDelayCheck()
{
	HandleScrollMove(scrollPos);
}

function bool MakeRowData(UIPacket._WorldExchangeItemData _itemData, out RichListCtrlRowData outRowData)
{
	local RichListCtrlRowData RowData;
	local ItemInfo iInfo;
	local string strcom, itemParam;
	local float unitPrice;

	RowData.cellDataList.Length = 3;
	// End:0x20
	if(_itemData.nItemClassID < 1)
	{
		return false;
	}
	// End:0x4B
	if(! class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nItemClassID), iInfo))
	{
		return false;
	}
	RowData.nReserved1 = _itemData.nWEIndex;
	RowData.nReserved2 = ExchangeFind_RichList.GetRecordCount();
	iInfo.ItemNum = _itemData.nAmount;
	iInfo.bShowCount = IsStackableItem(iInfo.ConsumeType);
	iInfo.Enchanted = _itemData.nEnchant;
	iInfo.RefineryOp1 = _itemData.nVariationOpt1;
	iInfo.RefineryOp2 = _itemData.nVariationOpt2;
	iInfo.AttackAttributeType = _itemData.nBaseAttributeAttackType;
	iInfo.AttackAttributeValue = _itemData.nBaseAttributeAttackValue;
	iInfo.DefenseAttributeValueFire = _itemData.nBaseAttributeDefendValue[0];
	iInfo.DefenseAttributeValueWater = _itemData.nBaseAttributeDefendValue[1];
	iInfo.DefenseAttributeValueWind = _itemData.nBaseAttributeDefendValue[2];
	iInfo.DefenseAttributeValueEarth = _itemData.nBaseAttributeDefendValue[3];
	iInfo.DefenseAttributeValueHoly = _itemData.nBaseAttributeDefendValue[4];
	iInfo.DefenseAttributeValueUnholy = _itemData.nBaseAttributeDefendValue[5];
	iInfo.LookChangeItemID = _itemData.nShapeShiftingClassId;
	iInfo.LookChangeItemName = class'UIDATA_ITEM'.static.GetItemName(GetItemID(_itemData.nShapeShiftingClassId));
	// End:0x221
	if(_itemData.nShapeShiftingClassId > 0)
	{
		iInfo.LookChangeIconPanel = "BranchSys3.Icon.pannel_lookChange";
	}
	iInfo.EnsoulOption[1 - 1].OptionArray[0] = _itemData.nEsoulOption[0];
	iInfo.EnsoulOption[1 - 1].OptionArray[1] = _itemData.nEsoulOption[1];
	iInfo.EnsoulOption[2 - 1].OptionArray[0] = _itemData.nEsoulOption[2];
	iInfo.IsBlessedItem = _itemData.nBlessOption == 1;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 0, 1);
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), GTColor().White, false, 4, 2);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, "x" $ string(_itemData.nAmount), GTColor().White, true, 39, 3);
	iInfo.Price = _itemData.nPrice;
	strcom = MakeCostStringINT64(iInfo.Price);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, strLCoinName, GetColor(147, 136, 112, 255), false, 18, 0);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, strcom, GetNumericColor(strcom), false, 5, 0);
	unitPrice = float(iInfo.Price) / float(iInfo.ItemNum);
	strcom = MakeCostStringINT64(iInfo.Price / iInfo.ItemNum);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, "." $ class'WorldExchangeBuyWnd'.static.Inst().GetDecimalNnmStr(unitPrice), GetColor(123, 123, 123, 255), false, 0, 1, "hs7");
	addRichListCtrlString(RowData.cellDataList[2].drawitems, strcom, GetNumericColor(strcom), false, 0, -2);
	ItemInfoToParam(iInfo, itemParam);
	RowData.szReserved = itemParam;
	outRowData = RowData;
	return true;
}

function HandleDialogOKSource()
{
	local INT64 ItemNum;

	ItemNum = MAX64(0, int64(DialogGetString()));
	// End:0x50
	if(IsAdena(sellItemInfo.Id))
	{
		ItemNum = ItemNum * class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT;
	}
	sellItemInfo.ItemNum = sellItemInfo.ItemNum - (MAX64(Min64(ItemNum, sellItemInfo.ItemNum), 0));
	// End:0xA2
	if(sellItemInfo.ItemNum == 0)
	{
		DelItemInfo();		
	}
	else
	{
		SetItemInfo();
	}
}

function HandleDialogOKDrop()
{
	local INT64 ItemNum;

	ItemNum = MAX64(0, int64(DialogGetString()));
	// End:0x27
	if(ItemNum == 0)
	{
		return;
	}
	// End:0x60
	if(IsAdena(readySellItemInfo.Id))
	{
		ItemNum = ItemNum * class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT;
	}
	// End:0x9C
	if(sellItemInfo.Id == readySellItemInfo.Id)
	{
		sellItemInfo.ItemNum = sellItemInfo.ItemNum + ItemNum;		
	}
	else
	{
		SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_ASCE/*8*/);
		readySellItemInfo.ItemNum = ItemNum;
		sellItemInfo = readySellItemInfo;
		RQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE();
	}
	SetItemInfo();	
}

function HandleDialogOkEdit()
{
	local INT64 ItemNum;

	ItemNum = MAX64(0, int64(DialogGetString()));
	// End:0x50
	if(IsAdena(readySellItemInfo.Id))
	{
		ItemNum = ItemNum * class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT;
	}
	// End:0x60
	if(ItemNum == 0)
	{
		return;
	}
	sellItemInfo.ItemNum = ItemNum;
	SetItemInfo();
}

function HandleDialogOKPrice()
{
	local INT64 ItemNum;
	local string dialogString;

	dialogString = DialogGetString();
	ItemNum = MAX64(0, int64(dialogString));
	if(ItemNum == 0)
	{
		return;
	}
	if (m_eCoinType == ECoinType.ERCT_ADENA)
	{
		ItemNum = ItemNum * class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT;
	}
	bundlePrice_NumberInputScr.SetCount(ItemNum);
}

function HandleGetRewardBtn()
{
	SetSellPopupInfos();
}

function SetSellPopupInfos()
{
	local string popupPath;

	popupPath = m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd";
	GetWindowHandle(popupPath).ShowWindow();
	GetItemWindowHandle(popupPath $ ".Dialog_Wnd.Item_ItemWnd").Clear();
	// End:0x15E
	if(IsAdena(sellItemInfo.Id))
	{
		GetTextBoxHandle(popupPath $ ".ItemName_Txt").SetTextColor(GetNumericColor(string(sellItemInfo.ItemNum)));
		GetTextBoxHandle(popupPath $ ".ItemName_Txt").SetText(string(sellItemInfo.ItemNum) $ GetSystemString(469));
		GetTextBoxHandle(popupPath $ ".ItemNum_Txt").SetText("x1");
		// End:0x17A
		if(class'WorldExchangeBuyWnd'.static.Inst()._IsNewServer())
		{
			GetTextBoxHandle(popupPath $ ".UnitPriceTitle_Txt").SetText(GetSystemString(14424));			
		}
		else
		{
			GetTextBoxHandle(popupPath $ ".UnitPriceTitle_Txt").SetText(GetSystemString(14192));
		}	
	}
	else
	{
		GetTextBoxHandle(popupPath $ ".ItemName_Txt").SetTextColor(GetColor(153, 153, 153, 255));
		GetTextBoxHandle(popupPath $ ".Dialog_Wnd.ItemName_Txt").SetText(GetItemNameAll(sellItemInfo));
		GetTextBoxHandle(popupPath $ ".Dialog_Wnd.ItemNum_Txt").SetText("x" $ string(sellItemInfo.ItemNum));
		GetTextBoxHandle(popupPath $ ".UnitPriceTitle_Txt").SetText(GetSystemString(14088));
	}
	GetItemWindowHandle(popupPath $ ".Dialog_Wnd.Item_ItemWnd").AddItem(sellItemInfo);
	GetTextBoxHandle(popupPath $ ".Dialog_Wnd.TotalPiceCount_txt").SetText(MakeCostString(string(bundlePrice_NumberInputScr.GetCount())) @ strLCoinName);
	GetTextBoxHandle(popupPath $ ".Dialog_Wnd.TotalPiceCount_txt").SetTextColor(GetColor(255, 255, 255, 255));
	GetTextBoxHandle(popupPath $ ".Dialog_Wnd.RegiFeePiceCount_txt").SetText(Get_RegiFeePiceCount_Txt().GetText());
	GetTextBoxHandle(popupPath $ ".Dialog_Wnd.SellFeePiceCount_txt").SetText(Get_SellFeePiceCount_Txt().GetText());
	GetTextBoxHandle(popupPath $ ".Dialog_Wnd.UnitPriceCount_txt").SetText(Get_UnitPriceCount_Txt().GetText());
	GetTextBoxHandle(popupPath $ ".Dialog_Wnd.UnitPricePrimeNumber_txt").SetText(Get_UnitPricePrimeNumber_txt().GetText());	
}

function SetHideSellDialogWindow()
{
	local string popupPath;

	TweenCancel();
	popupPath = m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd";
	GetWindowHandle(popupPath).HideWindow();
}

function _Show()
{
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
}

function handleSwap()
{
	Debug("HandleSwap");
	class'WorldExchangeBuyWnd'.static.Inst()._Show();
	getInstanceL2Util().syncWindowLoc(m_hOwnerWnd.m_WindowNameWithFullPath, "WorldExchangeBuyWnd");
}

function HandleRefresh()
{
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
}

function CheckWorldExchangeRegiSubWnd()
{
	// End:0x51
	if(GetTabHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiList_Tab").GetTopIndex() == 0)
	{
		class'WorldExchangeRegiSubWnd'.static.Inst()._Show();		
	}
	else
	{
		class'WorldExchangeRegiSubWnd'.static.Inst()._Hide();
	}
}

function SetMyInfos()
{
	local array<ItemInfo> iInfos;

	Get_MyAdenaCount_Txt().SetText(MakeCostString(string(GetAdena())) @ GetSystemString(469));
	// End:0x7E
	if(class'UIDATA_INVENTORY'.static.FindItemByClassID(LCOIN_CLASSID, iInfos) > 0)
	{
		Get_MyLcoinCount_Txt().SetText(MakeCostString(string(iInfos[0].ItemNum)) @ strLCoinName);		
	}
	else
	{
		Get_MyLcoinCount_Txt().SetText("0" @ strLCoinName);
	}
}

function HandleMyItemChanged(optional array<ItemInfo> iInfos, optional int Index)
{
	SetMyInfos();
}

function HandleOnitemCountEdited(INT64 changedNum)
{
	local ItemWindowHandle Item_ItemWnd;
	local string commitionRegist;

	commitionRegist = string(GetCommitionRegist(m_eCoinType));
	sellItemInfo.ItemNum = itemSell_NumberInputScr.GetCount();
	Item_ItemWnd = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.Item_ItemWnd");
	Item_ItemWnd.SetItem(0, sellItemInfo);
	class'WorldExchangeRegiSubWnd'.static.Inst()._ResetSellItem();
	_SetUnity(bundlePrice_NumberInputScr.GetCount(), itemSell_NumberInputScr.GetCount());
	Get_RegiFeePiceCount_Txt().SetText(MakeCostString(commitionRegist) @ GetSystemString(469));
	Get_RegiFeePiceCount_TxtUnit_Txt().SetText(ConvertNumToText(commitionRegist));
	Get_RegiFeePiceCount_TxtUnit_Txt().SetTextColor(GetNumericColor(commitionRegist));
	// End:0x180
	if(IsAdena(sellItemInfo.Id))
	{
		itemSell_NumberInputScr._SetEditBoxFontColor(GetNumericColor(string(sellItemInfo.ItemNum)));
		itemSell_NumberInputScr._SetEditBoxDisable(true);

		class'UIAPI_CHECKBOX'.static.SetCheck(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox", false);
		class'UIAPI_CHECKBOX'.static.SetCheck(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseCoinCheckBox", true);
		class'UIAPI_CHECKBOX'.static.SetDisable(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.BundlePrice_SelectCoin.UseAdenaCheckBox", true);
		m_eCoinType = ECoinType.ERCT_LCOIN;
		
		bundlePrice_NumberInputScr.SetCount(bundlePrice_NumberInputScr.GetCount());		
	}
	else
	{
		itemSell_NumberInputScr._SetEditBoxFontColor(getInstanceL2Util().BrightWhite);
		itemSell_NumberInputScr._SetEditBoxDisable(false);
	}
	CheckGetRewardBtn();	
}

function HandleOnPriceCountEdited(INT64 changedNum)
{
	local string commitionRegist;

	commitionRegist = string(GetCommitionRegist(m_eCoinType));
	if (m_eCoinType == ECoinType.ERCT_ADENA)
	{
		_SetUnity((bundlePrice_NumberInputScr.GetCount() / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT), itemSell_NumberInputScr.GetCount());
	}
	else
	{
		_SetUnity(bundlePrice_NumberInputScr.GetCount(), itemSell_NumberInputScr.GetCount());
	}
	Get_RegiFeePiceCount_Txt().SetText(MakeCostString(commitionRegist) @ GetSystemString(469));
	Get_RegiFeePiceCount_TxtUnit_Txt().SetText(ConvertNumToText(commitionRegist));
	Get_RegiFeePiceCount_TxtUnit_Txt().SetTextColor(GetNumericColor(commitionRegist));
	Get_SellFeePiceCount_Txt().SetText(MakeCostString(string(GetCommitionSell())) @ strLCoinName);
	CheckGetRewardBtn();
}

function HandleOnOverInput()
{
	getInstanceL2Util().showGfxScreenMessage(GetSystemString(13448));
}

function HandleOnItemCountEditBtonClicked()
{
	local INT64 maxItemNum64;

	maxItemNum64 = GetSellItemInfoNum(readySellItemInfo.Id.ServerID);
	// End:0x6F
	if(IsAdena(sellItemInfo.Id))
	{
		DialogShow(DialogModalType_Modalless, DialogType_NumberPadAdena, GetSystemString(14193), string(self));
		maxItemNum64 = maxItemNum64 / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT;		
	}
	else
	{
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), sellItemInfo.Name, ""), string(self));
	}
	DialogSetInputlimit(maxItemNum64);
	DialogSetParamInt64(maxItemNum64);
	class'DialogBox'.static.Inst().AnchorToOwner();
	class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOkEdit;	
}

function HandleOnPriceCountEditBtonClicked()
{
	if (m_eCoinType == ECoinType.ERCT_LCOIN)
	{
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(322), string(self));
		DialogSetInputlimit(class'WorldExchangeBuyWnd'.static.Inst().LCOIN_MAX);
		DialogSetParamInt64(5221615900385345559);
	}
	else
	{
		DialogShow(DialogModalType_Modalless, DialogType_NumberPadAdena, GetSystemMessage(322), string(self));
		DialogSetInputlimit(class'WorldExchangeBuyWnd'.static.Inst().ADENA_MAX / class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT);
		DialogSetParamInt64(5221615900385345559);
	}
	
	class'DialogBox'.static.Inst().AnchorToOwner();
	class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOKPrice;
}

function CheckGetRewardBtn()
{
	// End:0x71
	if(itemSell_NumberInputScr.GetCount() == 0 || (GetCommitionSell()) == 0)
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.GetReward_Btn").DisableWindow();		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.GetReward_Btn").EnableWindow();
	}
}

function _SetShowCancelDialog(string itemReservedString)
{
	local ItemInfo iInfo;
	local string CancelSaleDialogPath;

	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CancelSaleDialog_Wnd").ShowWindow();
	CancelSaleDialogPath = m_hOwnerWnd.m_WindowNameWithFullPath $ ".CancelSaleDialog_Wnd.CancelSalePopUp_Wnd";
	ParamToItemInfo(itemReservedString, iInfo);
	GetTextBoxHandle(CancelSaleDialogPath $ ".ItemName_Txt").SetText(GetItemNameAll(iInfo));
	GetItemWindowHandle(CancelSaleDialogPath $ ".Result_ItemWnd").Clear();
	GetItemWindowHandle(CancelSaleDialogPath $ ".Result_ItemWnd").AddItem(iInfo);
}

function _SetCurrentRigedItemNum(int Num)
{
	_regieditemNum = Num;
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.RegiItemNumTxt_Apply").SetText(string(Num));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.RegiItemNumTxt_Total").SetText("/" $ string(10));
	// End:0x116
	if(Num == 10)
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.ItemFullDisable_Wnd").ShowWindow();		
	}
	else
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.ItemFullDisable_Wnd").HideWindow();
	}
}

private function HandleClickOK_Btn()
{
	local float perPrice;

	perPrice = float(bundlePrice_NumberInputScr.GetCount()) / float(itemSell_NumberInputScr.GetCount());
	// End:0x64
	if(IsAdena(sellItemInfo.Id))
	{
		perPrice = perPrice * float(class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT);
	}
	// End:0x6F
	if(bRQ_C_EX_WORLD_EXCHANGE_AVERAGE_PRICE)
	{
		return;
	}
	Debug("HandleClickOK_Btn" @ string(perPrice) @ string(nAveragePrice * 0.90f));
	// End:0x156
	if(perPrice < (nAveragePrice * 0.90f))
	{
		class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(14204), string(self), 410, 109);
		class'DialogBox'.static.Inst().AnchorToOwner(-7, 144);
		class'DialogBox'.static.Inst().DelegateOnOK = HandleOK;
		class'DialogBox'.static.Inst().DelegateOnCancel = SetHideSellDialogWindow;
		TweenAdd();		
	}
	else
	{
		HandleOK();
	}	
}

private function TweenAdd()
{
	class'L2UITween'.static.Inst()._AddTweenTwinlkle(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPriceCount_txt"), -1.0f);
	class'L2UITween'.static.Inst()._AddTweenTwinlkle(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPricePrimeNumber_txt"), -1.0f);	
}

private function TweenCancel()
{
	Debug("TweenCancel 취소 ~~~ ");
	class'L2UITween'.static.Inst()._KillTwinkleWithWnd(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPriceCount_txt"));
	class'L2UITween'.static.Inst()._KillTwinkleWithWnd(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPricePrimeNumber_txt"));
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPriceCount_txt").SetAlpha(255);
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd.Dialog_Wnd.UnitPricePrimeNumber_txt").SetAlpha(255);	
}

private function HandleOK()
{
	SetHideSellDialogWindow();
	RQ_C_EX_WORLD_EXCHANGE_REGI_ITEM();	
}

function HandleCancelOK()
{
	historyScr._RQ_C_EX_WORLD_EXCHANGE_SETTLE_RECV_RESULT();
}

function HandleCancelCancel()
{
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CancelSaleDialog_Wnd").HideWindow();
}

function bool IsShowHistory()
{
	local TabHandle regilistTab;

	regilistTab = GetTabHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiList_Tab");
	return m_hOwnerWnd.IsShowWindow() && regilistTab.GetTopIndex() == 1;
}

function _CheckOnClickNoticeBtn()
{
	local TabHandle regilistTab;

	regilistTab = GetTabHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiList_Tab");
	// End:0x46
	if(IsShowHistory())
	{
		m_hOwnerWnd.HideWindow();		
	}
	else
	{
		_Show();
		regilistTab.SetTopOrder(1, true);
	}
	CheckWorldExchangeRegiSubWnd();
}

function int GetSortType()
{
	switch(sortHeaderIndex)
	{
		// End:0x2F
		case 0:
			// End:0x2A
			if(ExchangeFind_RichList.IsAscending(sortHeaderIndex))
			{
				return 2;				
			}
			else
			{
				return 3;
			}
		// End:0x57
		case 1:
			// End:0x52
			if(ExchangeFind_RichList.IsAscending(sortHeaderIndex))
			{
				return 4;				
			}
			else
			{
				return 5;
			}
		// End:0x80
		case 2:
			// End:0x7B
			if(ExchangeFind_RichList.IsAscending(sortHeaderIndex))
			{
				return 8;				
			}
			else
			{
				return 9;
			}
		// End:0xFFFF
		default:
			return 2;
	}
}

function SetSortByHeaderIndex(int Index)
{
	Debug("SetSortByHeaderIndex" @ string(Index));
	switch(Index)
	{
		// End:0x5D
		case 0:
			// End:0x52
			if(ExchangeFind_RichList.IsAscending(Index))
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_ENCHANT_DESC/*3*/);				
			}
			else
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_ENCHANT_ASCE/*2*/);
			}
			// End:0xCE
			break;
		// End:0x8E
		case 1:
			// End:0x83
			if(ExchangeFind_RichList.IsAscending(Index))
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_DESC/*5*/);				
			}
			else
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_ASCE/*4*/);
			}
			// End:0xCE
			break;
		// End:0xC0
		case 2:
			// End:0xB5
			if(ExchangeFind_RichList.IsAscending(Index))
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_DESC/*9*/);				
			}
			else
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_ASCE/*8*/);
			}
			// End:0xCE
			break;
		// End:0xFFFF
		default:
			SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_ENCHANT_ASCE/*2*/);
			// End:0x9C
			break;
	}
}

function SetSortType(WorldExchangeRegiWnd.E_WORLD_EXCHANGE_SORT_TYPE sortType)
{
	local bool bAscend;

	Debug("SetSortType" @ string(sortType));
	switch(sortType)
	{
		// End:0x3A
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_ENCHANT_ASCE:
			sortHeaderIndex = 0;
			bAscend = true;
			// End:0x94
			break;
		// End:0x51
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_ENCHANT_DESC:
			sortHeaderIndex = 0;
			bAscend = false;
			// End:0x94
			break;
		// End:0x68
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_ASCE:
			sortHeaderIndex = 1;
			bAscend = true;
			// End:0x94
			break;
		// End:0x7F
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_DESC:
			sortHeaderIndex = 1;
			bAscend = false;
			// End:0xC4
			break;
		// End:0x97
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_ASCE/*8*/:
			sortHeaderIndex = 2;
			bAscend = true;
			// End:0xC4
			break;
		// End:0xAF
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_DESC/*9*/:
			sortHeaderIndex = 2;
			bAscend = false;
			// End:0xC4
			break;
		// End:0xFFFF
		default:
			sortHeaderIndex = 0;
			bAscend = true;
			// End:0x94
			break;
	}
	ExchangeFind_RichList.SetAscend(sortHeaderIndex, bAscend);
	ExchangeFind_RichList.ShowSortIcon(sortHeaderIndex);
}

function _SetUnity(INT64 bundlePrice, INT64 ItemNum)
{
	local float unitPrice;
	local string strcom;

	// End:0x94
	if(IsAdena(sellItemInfo.Id))
	{
		bundlePrice = bundlePrice * class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT;
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.UnitPriceTitle_Txt").SetText(GetSystemString(14424));			
	}
	else
	{
		if (m_eCoinType == ECoinType.ERCT_ADENA)
		{
			bundlePrice = bundlePrice * class'WorldExchangeBuyWnd'.static.Inst().ADENA_BASIC_UNIT;
		}
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.UnitPriceTitle_Txt").SetText(GetSystemString(14088));
	}
	unitPrice = float(bundlePrice) / float(ItemNum);
	strcom = MakeCostStringINT64(bundlePrice / ItemNum);
	Debug("_SetUnity --- " @ string(bundlePrice) @ string(ItemNum) @ string(unitPrice) @ strcom);
	Get_UnitPriceCount_Txt().SetText(strcom);
	Get_UnitPricePrimeNumber_txt().SetText("." $ class'WorldExchangeBuyWnd'.static.Inst().GetDecimalNnmStr(unitPrice));
}

function TextBoxHandle Get_UnitPriceCount_Txt()
{
	return GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.UnitPriceCount_Txt");	
}

function TextBoxHandle Get_UnitPricePrimeNumber_txt()
{
	return GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.UnitPricePrimeNumber_txt");	
}

function TextBoxHandle Get_RegiFeePiceCount_Txt()
{
	return GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.RegiFeePiceCount_Txt");
}

function TextBoxHandle Get_RegiFeePiceCount_TxtUnit_Txt()
{
	return GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.RegiFeePiceCount_TxtUnit_Txt");
}

function TextBoxHandle Get_SellFeePiceCount_Txt()
{
	return GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.SellFeePiceCount_Txt");
}

function TextBoxHandle Get_MyAdenaCount_Txt()
{
	return GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.MyAdenaCount_Txt");
}

function TextBoxHandle Get_MyLcoinCount_Txt()
{
	return GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.MyLcoinCount_Txt");
}

function _OnLoadEachServer()
{
	if(class'WorldExchangeBuyWnd'.static.Inst()._IsNewServer())
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.GetHelp_Btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14425)));		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RegiTabWnd.ItemRegi_Wnd.GetHelp_Btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14089)));
	}
	GetMeTexture("ItemRegiDialog_Wnd.Dialog_Wnd.TotalPiceIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
	GetMeTexture("ItemRegiDialog_Wnd.Dialog_Wnd.SellFeeIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
	GetMeTexture("RegiTabWnd.ItemRegi_Wnd.BundlePrice_NumberInput.BundlePriceIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
	GetMeTexture("RegiTabWnd.ItemRegi_Wnd.SellIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
	GetMeTexture("RegiTabWnd.ItemRegi_Wnd.MyLcoinIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");	
}

event OnReceivedCloseUI()
{
	local string popupPath;

	popupPath = m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemRegiDialog_Wnd";
	// End:0x4C
	if(GetWindowHandle(popupPath).IsShowWindow())
	{
		SetHideSellDialogWindow();		
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		_Hide();
	}
}

defaultproperties
{
}
