class ClanShopWndClassic extends UICommonAPI;

const MAXITEMNUM = 99999;
const MAX_CATEGORY = 6;
const COSTITEMNUM = 5;
const ShopIndex = 100;
const TIMER_CLICK = 99902;
const TIMER_DELAYC = 3000;

struct PLShopItemDataStruct
{
	var int Index;
	var int nSlotNum;
	var int nItemClassID;
	var int nCostItemId[5];
	var INT64 nCostItemAmount[5];
	var int nRemainItemAmount;
	var int nRemainSec;
	var int nRemainServerItemAmount;
	var int PledgeLevel;
};

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle Refresh_Button;
var ButtonHandle Close_Button;
var WindowHandle ClanShopListWnd;
var RichListCtrlHandle ClanShop_RichListCtrl;
var WindowHandle ItemInfo_DisableWnd;
var TextBoxHandle ItemInfoDscrp_tex;
var WindowHandle ClanShopItemInfoWnd;
var TextBoxHandle ItemInfo_Text;
var TextBoxHandle NeedItemTitle_Text;
var WindowHandle BuyItemRichListCtrl;
var RichListCtrlHandle RichListCtrl;
var WindowHandle inputItemWnd;
var ButtonHandle Buy_Button;
var int nPledgeCoin;
var array<PLShopItemDataStruct> pLShopItemDataList;
var UIControlDialogAssets popupExpandScript;
var UIControlNumberInput inputItemScript;
var UIControlNeedItemList needItemScript;
var L2Util util;
var int selectnSlotNum;
var int selectIndex;
var int AddClanNeedPointListIndex;

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

function Initialize()
{
	Me = GetWindowHandle("ClanShopWndClassic");
	Refresh_Button = GetButtonHandle("ClanShopWndClassic.Refresh_Button");
	Close_Button = GetButtonHandle("ClanShopWndClassic.Close_Button");
	ClanShopListWnd = GetWindowHandle("ClanShopWndClassic.ClanShopListWnd");
	ClanShop_RichListCtrl = GetRichListCtrlHandle("ClanShopWndClassic.ClanShopListWnd.ClanShop_RichListCtrl");
	ItemInfo_DisableWnd = GetWindowHandle("ClanShopWndClassic.ItemInfo_DisableWnd");
	ItemInfoDscrp_tex = GetTextBoxHandle("ClanShopWndClassic.ItemInfo_DisableWnd.ItemInfoDscrp_tex");
	ClanShopItemInfoWnd = GetWindowHandle("ClanShopWndClassic.ClanShopItemInfoWnd");
	ItemInfo_Text = GetTextBoxHandle("ClanShopWndClassic.ClanShopItemInfoWnd.ItemInfo_Text");
	NeedItemTitle_Text = GetTextBoxHandle("ClanShopWndClassic.ClanShopItemInfoWnd.NeedItemTitle_Text");
	BuyItemRichListCtrl = GetWindowHandle("ClanShopWndClassic.ClanShopItemInfoWnd.BuyItemRichListCtrl");
	RichListCtrl = GetRichListCtrlHandle("ClanShopWndClassic.ClanShopItemInfoWnd.BuyItemRichListCtrl.RichListCtrl");
	inputItemWnd = GetWindowHandle("ClanShopWndClassic.ClanShopItemInfoWnd.inputItemWnd");
	Buy_Button = GetButtonHandle("ClanShopWndClassic.ClanShopItemInfoWnd.Buy_Button");
	util = L2Util(GetScript("L2Util"));
	ClanShop_RichListCtrl.SetSelectedSelTooltip(false);
	ClanShop_RichListCtrl.SetAppearTooltipAtMouseX(true);
	selectIndex = 0;
	SetPopupScript();
	InitNeedItem();
	InitInputControl();
}

function SetPopupScript()
{
	local WindowHandle poopExpandWnd, DisableWnd;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	popupExpandScript = class'UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	popupExpandScript.DelegateOnCancel = OnClickPopupCancel;
	popupExpandScript.DelegateOnClickBuy = OnClickPopupBuy;
	popupExpandScript.SetUseBuyItem(true);
	popupExpandScript.SetUseNeedItem(false);
	popupExpandScript.SetUseNumberInput(false);
	DisableWnd = GetWindowHandle(m_WindowName $ ".DisableWnd");
	popupExpandScript.SetDisableWindow(DisableWnd);
	class'UIAPI_WINDOW'.static.SetAlwaysOnTop(m_WindowName $ ".DisableWnd", false);
}

function OnClickPopupBuy()
{
	API_RequestPurchaseLimitShopItemBuy(selectnSlotNum, int(inputItemScript.GetCount()));
}

function OnClickPopupCancel()
{
	GetPopupExpandScript().Hide();
	showDisable(false);
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function API_RequestPurchaseLimitShopItemBuy(int nSlotNum, int nItemAmount)
{
	RequestPurchaseLimitShopItemBuy(100, nSlotNum, nItemAmount);
}

function InitNeedItem()
{
	BuyItemRichListCtrl.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(BuyItemRichListCtrl.GetScript());
	needItemScript.SetRichListControler(RichListCtrl);
}

function InitInputControl()
{
	inputItemWnd.SetScript("UIControlNumberInput");
	inputItemScript = UIControlNumberInput(inputItemWnd.GetScript());
	inputItemScript.Init(m_WindowName $ ".ClanShopItemInfoWnd.inputItemWnd");
	inputItemScript.DelegateGetCountCanBuy = MaxNumCanBuy;
	inputItemScript.DelegateOnItemCountEdited = OnItemCountChanged;
	inputItemScript.DelegateESCKey = OnESCKey;
	inputItemScript.Reset_Btn = GetButtonHandle("ClanShopWndClassic.ClanShopItemInfoWnd.inputItemWnd.Clear_Button");
	inputItemScript.Buy_Btn = GetButtonHandle(m_WindowName $ ".ClanShopItemInfoWnd.Buy_Button");
}

function INT64 MaxNumCanBuy()
{
	local RichListCtrlRowData RowData;
	local int Count, Index;
	local ItemInfo Info;
	local PLShopItemDataStruct itemData;

	Index = ClanShop_RichListCtrl.GetSelectedIndex();
	ClanShop_RichListCtrl.GetRec(Index, RowData);
	itemData = pLShopItemDataList[int(RowData.nReserved1)];
	Info = GetItemInfoByClassID(itemData.nItemClassID);
	// End:0x79
	if(RowData.nReserved2 == 0)
	{
		Count = 0;		
	}
	else
	{
		// End:0xB3
		if(IsStackableItem(Info.ConsumeType))
		{
			Count = Min(int(needItemScript.GetMaxNumCanBuy()), GetCountCanBuyByIndex(selectIndex));			
		}
		else
		{
			Count = 1;
		}
	}
	return Count;
}

function OnItemCountChanged(INT64 ItemCount)
{
	ItemCount = MAX64(1, ItemCount);
	needItemScript.SetBuyNum(ItemCount);
}

event OnShow()
{
	Debug(" ------------------ OnShow  ClanShopWndClassic");
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	showDisable(false);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
}

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_COIN_INFO);
	RegisterEvent(EV_PurchaseLimitShopItemBuy);
	RegisterEvent(EV_Restart);
}

function Load()
{
}

function API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST packet;

	packet.cShopIndex = 100;
	// End:0x2D
	if(! class'UIPacket'.static.Encode_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST, stream);
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW:
			HandleS_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW();
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_COIN_INFO:
			HandleS_EX_PLEDGE_COIN_INFO();
			break;
		case EV_PurchaseLimitShopItemBuy:
			if(! IsMyShopIndex(param))
			{
				return;
			}
			HandleBuyResult(param);
			break;
		case EV_Restart:
			selectIndex = 0;
			break;
	}
}

function HandleS_EX_PLEDGE_COIN_INFO()
{
	local UIPacket._S_EX_PLEDGE_COIN_INFO packet;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PLEDGE_COIN_INFO(packet))
	{
		return;
	}
	nPledgeCoin = packet.nPledgeCoin;
}

function HandleBuyResult(string param)
{
	local int Result;
	local PLShopItemDataStruct itemData;
	local ItemInfo Info;

	Debug("HandleBuyResult param" @ param);
	ParseInt(param, "Result", Result);
	GetPopupExpandScript().Hide();
	showDisable(false);
	switch(Result)
	{
		case 0:
			itemData = pLShopItemDataList[selectIndex];
			Info = GetItemInfoByClassID(itemData.nItemClassID);
			util.showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13403), GetItemNameAll(Info)));
			AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13403), GetItemNameAll(Info)));
			OnRefresh_ButtonClick();
			break;
		case 7:
			util.showGfxScreenMessage(GetSystemMessage(3675));
			AddSystemMessageString(GetSystemMessage(3675));
			break;
		case 4:
			util.showGfxScreenMessage(GetSystemMessage(13390));
			AddSystemMessageString(GetSystemMessage(13390));
			break;
		case 3:
			util.showGfxScreenMessage(GetSystemMessage(13389));
			AddSystemMessageString(GetSystemMessage(13389));
			break;
		case 2:
			util.showGfxScreenMessage(GetSystemMessage(13052));
			AddSystemMessageString(GetSystemMessage(13052));
			break;
		case 9:
			util.showGfxScreenMessage(GetSystemMessage(13391));
			AddSystemMessageString(GetSystemMessage(13391));
			break;
		case 1:
		case 5:
		case 6:
		case 8:
		case 11:
		default:
			util.showGfxScreenMessage(GetSystemMessage(4559));
			AddSystemMessageString(GetSystemMessage(4559));
			break;
	}
}

function ClearAll()
{
	pLShopItemDataList.Length = 0;
	ClanShop_RichListCtrl.DeleteAllItem();
	RichListCtrl.DeleteAllItem();
}

function bool IsMyShopIndex(string param)
{
	local int nShopIndex;

	ParseInt(param, "ShopIndex", nShopIndex);
	return 100 == nShopIndex;
}

function HandleS_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW()
{
	local UIPacket._S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW packet;
	local int i, j;
	local PLShopItemDataStruct pLShopItemData;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW(packet))
	{
		return;
	}
	// End:0x2E
	if(packet.cShopIndex != 100)
	{
		return;
	}
	// End:0x44
	if(packet.cPage == 1)
	{
		ClearAll();
	}

	for(i = 0; i < packet.vItemList.Length; i++)
	{
		pLShopItemData.Index = i;
		pLShopItemData.nSlotNum = packet.vItemList[i].nSlotNum;
		pLShopItemData.nItemClassID = packet.vItemList[i].nItemClassID;
		pLShopItemData.nRemainItemAmount = packet.vItemList[i].nRemainItemAmount;
		pLShopItemData.nRemainSec = packet.vItemList[i].nRemainSec;
		pLShopItemData.nRemainServerItemAmount = packet.vItemList[0].nRemainServerItemAmount;

		for(j = 0; j < 5; j++)
		{
			pLShopItemData.nCostItemId[j] = packet.vItemList[i].nCostItemId[j];
		}

		for(j = 0; j < 5; j++)
		{
			pLShopItemData.nCostItemAmount[j] = packet.vItemList[i].nCostItemAmount[j];
		}
		pLShopItemDataList[pLShopItemDataList.Length] = pLShopItemData;
	}
	if(packet.cPage < packet.cMaxPage)
	{
		return;
	}
	HandleItemNewList();
}

function HandleItemNewList()
{
	local int i;
	local RichListCtrlRowData Record;
	local PledgeShopProductUIData productData;
	local array<RichListCtrlRowData> RecordList;

	for(i = 0; i < pLShopItemDataList.Length; i++)
	{
		API_GetLCoinShopProductData(pLShopItemDataList[i].nSlotNum, productData);
		Record = makeRecord(i);
		RecordList[RecordList.Length] = Record;
	}

	for(i = 0; i < RecordList.Length; i++)
	{
		API_GetLCoinShopProductData(pLShopItemDataList[int(RecordList[i].nReserved1)].nSlotNum, productData);
		ClanShop_RichListCtrl.InsertRecord(RecordList[i]);
	}
	ClanShop_RichListCtrl.SetSelectedIndex(selectIndex, true);
	ClickRecord();
}

function API_GetLCoinShopProductData(int ProductID, out PledgeShopProductUIData productData)
{
	GetPledgeShopProductData(100, ProductID, productData);
}

function RichListCtrlRowData makeRecord(int Index)
{
	local RichListCtrlRowData Record;
	local string fullNameString, toolTipParam;
	local ItemInfo Info;
	local UserInfo PlayerInfo;
	local PLShopItemDataStruct itemData;
	local PledgeShopProductUIData productData;
	local Color tmpTextColor;
	local bool bBreakLine, canBuy, lockPanel;
	local ClanWndClassicNew ClanWnd;

	ClanWnd = ClanWndClassicNew(GetScript("ClanWndClassicNew"));
	itemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(itemData.nSlotNum, productData);
	canBuy = (GetItemLimitAmount(Index)) > 0;
	GetPlayerInfo(PlayerInfo);
	Info = GetItemInfoByClassID(itemData.nItemClassID);
	fullNameString = GetItemNameAll(Info);
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.cellDataList.Length = 3;
	Record.nReserved1 = int64(Index);
	Record.cellDataList[0].nReserved1 = itemData.nItemClassID;
	// End:0x123
	if(productData.PledgeLevelMin > ClanWnd.m_clanLevel)
	{
		lockPanel = false;
		Record.nReserved2 = 0;		
	}
	else
	{
		lockPanel = true;
		Record.nReserved2 = 1;
	}
	Record.cellDataList[2].nReserved3 = itemData.nSlotNum;
	Record.cellDataList[0].szData = fullNameString;
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, Info, 32, 32, 10, 6);
	// End:0x1E9
	if(! canBuy)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.ItemWindow.ItemWindow_IconDisable", 32, 32, -32, 0);
	}
	// End:0x22D
	if(! lockPanel)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.Icon.ItemLock", 32, 32, -32, 0);
	}
	// End:0x24D
	if(lockPanel)
	{
		tmpTextColor = GetColor(170, 153, 119, 255);		
	}
	else
	{
		tmpTextColor = util.DarkGray;
	}
	addRichListCtrlString(Record.cellDataList[0].drawitems, productData.ProductName, tmpTextColor, false, 5, 2);
	addRichListCtrlString(Record.cellDataList[0].drawitems, GetSystemString(3731) @ string(productData.PledgeLevelMin), tmpTextColor, true, 47, 0);
	// End:0x2E5
	if(lockPanel)
	{
		tmpTextColor = GetColor(254, 215, 160, 255);		
	}
	else
	{
		tmpTextColor = util.DarkGray;
	}
	// End:0x34E
	if(productData.LevelMin != 1)
	{
		addRichListCtrlString(Record.cellDataList[1].drawitems, string(productData.LevelMin) @ GetSystemString(859), tmpTextColor, false, 10, -2);
		bBreakLine = true;
	}
	// End:0x3A4
	if(productData.LevelMax != 999)
	{
		addRichListCtrlString(Record.cellDataList[1].drawitems, GetSystemString(13268) @ string(productData.LevelMax), tmpTextColor, bBreakLine, 10, -2);
	}
	// End:0x3ED
	if((productData.LevelMin == 1) && productData.LevelMax == 999)
	{
		addRichListCtrlString(Record.cellDataList[1].drawitems, "-", tmpTextColor, false, 10, 0);
	}
	// End:0x4A5
	if(productData.LimitCountMax > 0)
	{
		// End:0x43D
		if(lockPanel)
		{
			// End:0x426
			if(canBuy)
			{
				tmpTextColor = util.White;				
			}
			else
			{
				tmpTextColor = util.ColorYellow;
			}			
		}
		else
		{
			tmpTextColor = util.DarkGray;
		}
		addRichListCtrlString(Record.cellDataList[2].drawitems, ((string(itemData.nRemainItemAmount) $ "/") $ string(productData.LimitCountMax)) $ (GetBuyTypeStringBuyRefresh(productData.ResetType)), tmpTextColor, false, 0, 0);		
	}
	else
	{
		// End:0x4C5
		if(lockPanel)
		{
			tmpTextColor = GetColor(119, 255, 153, 255);			
		}
		else
		{
			tmpTextColor = util.DarkGray;
		}
		addRichListCtrlString(Record.cellDataList[2].drawitems, GetSystemString(866), tmpTextColor, false, 0, 0);
	}
	return Record;
}

function int GetCurrentSelectedIndex()
{
	return 0;
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

function string GetItemTextureNameByClassID(int ClassID)
{
	local ItemID cID;

	cID.ClassID = ClassID;
	return class'UIDATA_ITEM'.static.GetItemTextureName(cID);
}

function INT64 GetAdenaNum(PLShopItemDataStruct itemData)
{
	local int i;

	for(i = 0; i < 5; i++)
	{
		if(itemData.nCostItemId[i] == 57)
		{
			return itemData.nCostItemAmount[i];
		}
	}
	return -1;
}

function INT64 GetLcoinNum(PLShopItemDataStruct itemData)
{
	local int i;

	for(i = 0; i < 5; i++)
	{
		if(itemData.nCostItemId[i] == 91663)
		{
			return itemData.nCostItemAmount[i];
		}
	}
	return -1;
}

function string GetBuyTypeStringBuyRefresh(PLSHOP_RESET_TYPE Type)
{
	switch(Type)
	{
		case PLSHOP_RESET_ALWAYS:
			return ("(" $ GetSystemString(5142)) $ ")";
		case PLSHOP_RESET_ONEDAY:
			return (("(" $ "1") $ GetSystemString(1109)) $ ")";
		case PLSHOP_RESET_ONEWEEK:
			return "(" $ GetSystemString(13866) $ ")";
			// End:0x87
			break;
		// End:0x84
		case PLSHOP_RESET_ONEMONTH:
			return "(" $ GetSystemString(13867) $ ")";
			// End:0x8
	}
	return "";
}

function showDisable(bool bShow)
{
	// End:0x7C
	if(bShow)
	{
		GetWindowHandle(m_WindowName $ ".DisableWnd").ShowWindow();
		GetEditBoxHandle(m_WindowName $ ".ClanShopItemInfoWnd.inputItemWnd.ItemCount_EditBox").HideWindow();		
	}
	else
	{
		GetWindowHandle(m_WindowName $ ".DisableWnd").HideWindow();
		GetEditBoxHandle(m_WindowName $ ".ClanShopItemInfoWnd.inputItemWnd.ItemCount_EditBox").ShowWindow();
	}
}

function HandleUserInfo()
{
	// End:0x22
	if(getInstanceUIData().isLevelUP())
	{
		Me.HideWindow();
	}
}

function ItemInfo GetItemInfoByRecord(RichListCtrlRowData Record)
{
	return GetItemInfoByIndex(int(Record.nReserved1));
}

function ItemInfo GetItemInfoByIndex(int Index)
{
	return GetItemInfoByClassID(pLShopItemDataList[Index].nItemClassID);
}

function ItemInfo GetItemInfoCurrentSelected()
{
	return GetItemInfoByIndex(GetCurrentSelectedIndex());
}

function int GetSlotNumByRecord(RichListCtrlRowData Record)
{
	return Record.cellDataList[2].nReserved3;
}

function int GetCountCanBuyByIndex(int Index)
{
	local int Count;

	// End:0x12
	if(! CheckLevelCondition(Index))
	{
		return 0;
	}
	Count = pLShopItemDataList[Index].nRemainItemAmount;
	return Count;
}

function bool CheckLevelCondition(int Index)
{
	local UserInfo Info;
	local PLShopItemDataStruct itemData;
	local PledgeShopProductUIData productData;

	itemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(itemData.nSlotNum, productData);
	// End:0x38
	if(! GetPlayerInfo(Info))
	{
		return false;
	}
	// End:0x6E
	if((Info.nLevel > productData.LevelMax) || Info.nLevel < productData.LevelMin)
	{
		return false;
	}
	return true;
}

function int GetItemLimitAmount(int Index)
{
	local PledgeShopProductUIData productData;

	API_GetLCoinShopProductData(pLShopItemDataList[Index].nSlotNum, productData);
	return pLShopItemDataList[Index].nRemainItemAmount;
}

function int GetMinAmoutByCostItemNum(int Index)
{
	local int Count, i;
	local PLShopItemDataStruct itemData;

	itemData = pLShopItemDataList[Index];
	Count = 99999;

	for(i = 0; i < 5; i++)
	{
		// End:0x83
		if(itemData.nCostItemId[i] != 0)
		{
			Count = Min(Count, int(GetInventoryItemCount(GetItemID(itemData.nCostItemId[i])) / itemData.nCostItemAmount[i]));
		}
	}

	return Count;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "ClanShop_RichListCtrl":
			RichListCtrl.DeleteAllItem();
			ClickRecord();
			break;
	}
}

function ClickRecord()
{
	local int i, Index;
	local ItemInfo Info, info2;
	local RichListCtrlRowData RowData;
	local PLShopItemDataStruct itemData;
	local INT64 haveItem;

	class'UIAPI_MULTISELLITEMINFO'.static.Clear("ClanShopWndClassic.multiSellItemInfo");
	Index = ClanShop_RichListCtrl.GetSelectedIndex();
	ClanShop_RichListCtrl.GetRec(Index, RowData);
	itemData = pLShopItemDataList[int(RowData.nReserved1)];
	Info = GetItemInfoByClassID(itemData.nItemClassID);
	selectnSlotNum = itemData.nSlotNum;
	selectIndex = Index;
	class'UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("ClanShopWndClassic.multiSellItemInfo", 0, Info);
	needItemScript.StartNeedItemList(3);

	for(i = 0; i < 5; i++)
	{
		if(itemData.nCostItemId[i] != 0)
		{
			if(itemData.nCostItemId[i] == -700)
			{
				needItemScript.AddNeedPoint(GetSystemString(13696), "icon.etc_i.pledge_coin_dummy", itemData.nCostItemAmount[0], int64(nPledgeCoin));
				// [Explicit Continue]
				continue;
			}
			if(itemData.nCostItemId[i] == 57)
			{
				haveItem = GetInventoryItemCount(GetItemID(57));
				info2 = GetItemInfoByClassID(57);
				needItemScript.AddNeedPoint(info2.Name, info2.IconName, itemData.nCostItemAmount[0], haveItem);
				// [Explicit Continue]
				continue;
			}
			if(itemData.nCostItemId[i] == 91663)
			{
				haveItem = GetInventoryItemCount(GetItemID(91663));
				info2 = GetItemInfoByClassID(91663);
				needItemScript.AddNeedPoint(info2.Name, info2.IconName, itemData.nCostItemAmount[0], haveItem);
			}
		}
	}
	if(needItemScript.GetMaxNumCanBuy() > 0)
	{
		inputItemScript.SetCount(1);		
	}
	else
	{
		inputItemScript.SetCount(int(needItemScript.GetMaxNumCanBuy()));
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Refresh_Button":
			OnRefresh_ButtonClick();
			// End:0x7A
			break;
		// End:0x3D
		case "Close_Button":
			OnClose_ButtonClick();
			// End:0x7A
			break;
		// End:0x5F
		case "HelpWnd_Btn":
			ExecuteEvent(EV_ShowHelp, "68");
			// End:0x7A
			break;
		case "Buy_Button":
			OnBuy_ButtonClick();
			break;
	}
}

function OnRefresh_ButtonClick()
{
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	Me.SetTimer(99902, 3000);
	Refresh_Button.DisableWindow();
}

function OnTimer(int TimerID)
{
	// End:0x32
	if(TimerID == 99902)
	{
		Refresh_Button.EnableWindow();
		Me.KillTimer(99902);
	}
}

function OnClose_ButtonClick()
{
	GetWindowHandle(m_WindowName).HideWindow();
}

function OnClear_ButtonClick()
{
}

function OnMultiSell_Up_ButtonClick()
{
}

function OnMultiSell_Down_ButtonClick()
{
}

function OnMultiSell_Input_ButtonClick()
{
}

function OnBuy_ButtonClick()
{
	local PLShopItemDataStruct itemData;
	local ItemInfo Info;
	local PledgeShopProductUIData productData;

	itemData = pLShopItemDataList[selectIndex];
	Info = GetItemInfoByClassID(itemData.nItemClassID);
	API_GetLCoinShopProductData(itemData.nSlotNum, productData);
	popupExpandScript.SetDialogDesc(MakeFullSystemMsg(GetSystemMessage(13404), GetItemNameAll(Info)));
	popupExpandScript.SetBuyItemClassID(itemData.nItemClassID, productData.BuyItems[0].Count);
	popupExpandScript.SetItemNum(int(inputItemScript.GetCount()));
	popupExpandScript.OKButton.EnableWindow();
	popupExpandScript.Show();
	showDisable(true);
}

function OnESCKey()
{
	ClanShop_RichListCtrl.SetFocus();
}

function OnReceivedCloseUI()
{
	showDisable(false);
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="ClanShopWndClassic"
}
