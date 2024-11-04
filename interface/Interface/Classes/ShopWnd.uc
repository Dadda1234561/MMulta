//------------------------------------------------------------------------------------------------------------------------
//
// 제목         : ShopWnd (상점 UC)
//
//------------------------------------------------------------------------------------------------------------------------

class ShopWnd extends UICommonAPI;

//------------------------------------------------------------------------------------------------------------------------
// const
//------------------------------------------------------------------------------------------------------------------------
const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const DIALOG_PREVIEW       = 333;

// 재매입 추가 by jin 2009.03.24.
const REFUND_ITEM = 444;

enum ShopType
{
	ShopNone,		// Invalid type
	ShopBuy,
	ShopSell,
	ShopPreview,
	ShopRefund
};

enum TYPE_DIR 
{
	non,
	toTop,
	toBottom
};

struct taxInfoByCastle
{
	var int castleID;
	var int TaxRate;
};


struct itemsStruct
{
	var array<ItemInfo> iItems;
};

var int m_merchantID;
var int m_npcID;				    // only for shoppreveiw
var bool m_isCompleteTransaction;
var INT64 m_currentPrice;			// 구매/판매/재매입 목록에 올려놓은 아이템의 가격을 합산한 것
var INT64 m_UserAdena;
var string m_WindowName;			    // 상속에 사용하려고 윈도우 이름 추가 - lancelot 2006. 11. 27.
var int m_maxInventoryCount;		// Added by JoeyPark 2010/09/09
var int m_curInventoryCount;		// Added by JoeyPark 2010/09/09
var int m_numPossibleSlotCount;


var ShopType m_LastShopType;
var ShopType m_shopType;

//------------------------------------------------------------------------------------------------------------------------
// Control Handle
//------------------------------------------------------------------------------------------------------------------------
var WindowHandle Me;

// Tab Handle
var TabHandle m_TransactionTabHandle;
var TabHandle m_PreviewTabHandle;

// ItemWindow Handle
var ItemWindowHandle m_BuyTopListHandle;
var ItemWindowHandle m_SellTopListHandle;
var ItemWindowHandle m_RefundTopListHandle;

var ItemWindowHandle m_BuyBottomListHandle;
var ItemWindowHandle m_SellBottomListHandle;
var ItemWindowHandle m_RefundBottomListHandle;

var ItemWindowHandle m_PreviewTopListHandle;
var ItemWindowHandle m_PreviewBottomListHandle;

// Texture Handle
var TextureHandle m_TexTransactionBGLine;
var TextureHandle m_TexPreviewBGLine;

var TextureHandle m_TexRefundSlotBG;
var TextureHandle m_TexBuySellSlotBG;
var TextureHandle m_TexPreviewSlotBG;

// TextBox Handle
var TextBoxHandle m_PriceConstTextBoxHandle;
var TextBoxHandle m_PriceTextBoxHandle;
var TextBoxHandle m_AdenaTextBoxHandle;
var TextBoxHandle m_BottomTextBoxHandle;
var TextBoxHandle m_TopTextBoxHandle;
var TextBoxHandle m_ShopWndItemCountHandle; // Added by JoeyPark 2010/09/09
// Button Handle
var ButtonHandle m_OkButtonHandle;

var ButtonHandle m_CancelButtonHandle;

var WindowHandle m_itemEnchantWndHandle;
var ItemEnchantWnd m_itemEnchantWndScript;
var TextBoxHandle m_TaxText;
var TextBoxHandle m_TaxConstText;
var array<taxInfoByCastle> taxInfos;
var ButtonHandle m_SwapItemBtn;
var ButtonHandle m_SwapListBtn;
var RichListCtrlHandle topRichListCtrl;
var WindowHandle listWnd;
var UIControlTextInput uicontrolTextInputScr;
var bool isListView;
var array<itemsStruct> iInfos;

//------------------------------------------------------------------------------------------------------------------------
//
// Event Functions.
//
//------------------------------------------------------------------------------------------------------------------------

/** Desc : OnRegisterEvent  */
event OnRegisterEvent()
{
	RegisterEvent(EV_ShopAddItem);
	RegisterEvent(EV_SetMaxCount);
	RegisterEvent(EV_ShopOpenWindow);
	RegisterEvent(EV_OnEndTransactionList);
	RegisterEvent(EV_OnAddCastleTaxRateList);
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	SetEnableWindow(true);
	m_hOwnerWnd.EnableTick();
}

event OnTick()
{
	FocusToList();
}

event OnLButtonUp(WindowHandle a_WindowHandle, int nX, int nY)
{
	// End:0x7E
	if(GetWindowHandle("InventoryViewer").IsShowWindow())
	{
		GetWindowHandle("InventoryViewer").BringToFront();
		// End:0x7E
		if(GetWindowHandle("DialogBox").IsShowWindow())
		{
			GetWindowHandle("DialogBox").SetFocus();
		}
	}
}

/** Desc : OnLoad  */
event OnLoad()
{
	SetClosingOnESC();
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	m_SwapItemBtn = GetButtonHandle(m_WindowName $ ".SwapItemBtn");
	m_SwapListBtn = GetButtonHandle(m_WindowName $ ".SwapListBtn");
	m_TransactionTabHandle = GetTabHandle(m_WindowName $ ".TransactionSelectTab");
	m_PreviewTabHandle = GetTabHandle(m_WindowName $ ".PreviewSelectTab");
	m_BuyTopListHandle = GetItemWindowHandle(m_WindowName $ ".BuyTopList");
	m_SellTopListHandle = GetItemWindowHandle(m_WindowName $ ".SellTopList");
	m_RefundTopListHandle = GetItemWindowHandle(m_WindowName $ ".RefundTopList");
	m_BuyTopListHandle.SetTooltipType("InventoryPrice1HideEnchantStackable");
	m_SellTopListHandle.SetTooltipType("InventoryPrice2");
	m_RefundTopListHandle.SetTooltipType("InventoryPrice1");
	m_BuyBottomListHandle = GetItemWindowHandle(m_WindowName $ ".BuyBottomList");
	m_SellBottomListHandle = GetItemWindowHandle(m_WindowName $ ".SellBottomList");
	m_RefundBottomListHandle = GetItemWindowHandle(m_WindowName $ ".RefundBottomList");
	m_BuyBottomListHandle.SetTooltipType("InventoryStackableUnitPrice");
	m_SellBottomListHandle.SetTooltipType("InventoryStackableUnitPrice");
	m_RefundBottomListHandle.SetTooltipType("InventoryPrice1");
	m_PreviewTopListHandle = GetItemWindowHandle(m_WindowName $ ".PreviewTopList");
	m_PreviewBottomListHandle = GetItemWindowHandle(m_WindowName $ ".PreviewBottomList");
	m_TexTransactionBGLine = GetTextureHandle(m_WindowName $ ".TransactionSelectTabBgLine");
	m_TexPreviewBGLine = GetTextureHandle(m_WindowName $ ".Sell_TexTabBgLine");
	m_TexRefundSlotBG = GetTextureHandle(m_WindowName $ ".RefundItemListBg");
	m_TexBuySellSlotBG = GetTextureHandle(m_WindowName $ ".Buy_TopSlotListBg");
	m_TexPreviewSlotBG = GetTextureHandle(m_WindowName $ ".Sell_TopSlotListBg");
	m_PriceConstTextBoxHandle = GetTextBoxHandle(m_WindowName $ ".PriceConstText");
	m_PriceTextBoxHandle = GetTextBoxHandle(m_WindowName $ ".PriceText");
	m_AdenaTextBoxHandle = GetTextBoxHandle(m_WindowName $ ".AdenaText");
	m_BottomTextBoxHandle = GetTextBoxHandle(m_WindowName $ ".BottomText");
	m_TopTextBoxHandle = GetTextBoxHandle(m_WindowName $ ".TopText");
	m_ShopWndItemCountHandle = GetTextBoxHandle(m_WindowName $ ".ItemCount");
	m_OkButtonHandle = GetButtonHandle(m_WindowName $ ".OKButton");
	m_CancelButtonHandle = GetButtonHandle(m_WindowName $ ".CancelButton");
	m_isCompleteTransaction = false;
	m_LastShopType = ShopNone;
	m_itemEnchantWndHandle = GetWindowHandle("ItemEnchantWnd");
	m_itemEnchantWndScript = ItemEnchantWnd(GetScript("ItemEnchantWnd"));
	m_TaxConstText = GetTextBoxHandle(m_WindowName $ ".TaxConstText");
	// End:0x554
	if(IsAdenServer())
	{
		m_TaxConstText.SetText(GetSystemString(1608) @ ":");
		m_TaxText = GetTextBoxHandle(m_WindowName $ ".TaxText");
		m_TaxText.SetText("0%");
	}
	else
	{
		m_TaxConstText.HideWindow();
	}
	listWnd = GetWindowHandle(m_WindowName $ ".list_Wnd");
	listWnd.HideWindow();
	topRichListCtrl = GetRichListCtrlHandle(m_WindowName $ ".list_Wnd.topRichListCtrl");
	topRichListCtrl.SetSelectedSelTooltip(false);
	topRichListCtrl.SetAppearTooltipAtMouseX(true);
	topRichListCtrl.SetEnableItemRecordDrag(true);
	uicontrolTextInputScr = class'UIControlTextInput'.static.InitScript(GetWindowHandle(m_WindowName $ ".FindText"));
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolTextInputScr.SetDisable(false);
	uicontrolTextInputScr.SetEdtiable(true);
	uicontrolTextInputScr.SetDefaultString(GetSystemString(2507));
	iInfos.Length = 4;
	m_shopType = ShopNone;
}

function DelegateOnChangeEdited(string Text)
{
	SetItemsWithFindString();
}

function DelegateOnCompleteEditBox(string Text)
{}

function DelegateESCKey()
{
	FocusToList();
}

/** Desc : OnEvent  */
event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
	case EV_ShopOpenWindow:
		HandleOpenWindow(param);
		break;
	case EV_ShopAddItem:
		HandleAddItem(param);
		break;
	case EV_OnEndTransactionList:
		HandleEndTransactionList(param);
		break;
	case EV_SetMaxCount:	// Added by JoeyPark 2010/09/09	
		HandleSetMaxCount(param);
		break;
	case EV_OnAddCastleTaxRateList:
		HandleOnAddCastleTaxRateList(param);
		break;
	}
}

/** Desc : OnClickButton  */
event OnClickButton(string ControlName)
{
	// End:0x1D
	if(ControlName == "SwapItemBtn")
	{
		SwapList();
	}
	// End:0x3D
	if(ControlName == "SwapListBtn")
	{
		SwapList();
	}
	else if(ControlName == "OKButton")
	{
		SetEnableWindow(true);
		HandleOKButton();
	}
	else if(ControlName == "CancelButton")
	{
		SetEnableWindow(true);
		HideWindow(m_WindowName);
	}
	else if(ControlName == "TransactionSelectTab0")
	{
		SwapShopType(ShopBuy);
	}
	else if(ControlName == "TransactionSelectTab1")
	{
		SwapShopType(ShopSell);
	}
	else if(ControlName == "TransactionSelectTab2")
	{
		SwapShopType(ShopRefund);
	}
	else if(ControlName == "InventoryViewerCall_Button")
	{
		getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle(getCurrentWindowName(string(self))), true);
	}
}

/** Desc: 아이템을 더블 클릭 했을때 */
event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo iInfo;

	// End:0xAA
	if(ControlName == "BuyTopList" || ControlName == "RefundTopList" || ControlName == "SellTopList" || ControlName == "PreviewTopList")
	{
		GetCurrentTopListHandle().GetSelectedItem(iInfo);
		StartMoveItemTopToBottom(iInfo, class'InputAPI'.static.IsAltPressed() && m_shopType == ShopType.ShopSell/*2*/);		
	}
	else if(ControlName == "RefundBottomList" || ControlName == "PreviewBottomList" || ControlName == "BuyBottomList" || ControlName == "SellBottomList")
	{
		GetCurrentBottomListHandle().GetSelectedItem(iInfo);
		StartMoveItemBottomToTop(iInfo, class'InputAPI'.static.IsAltPressed() && (m_shopType == ShopType.ShopBuy/*1*/) || m_shopType == ShopType.ShopSell/*2*/);
	}
}

/** Desc: 아이템을 드래그 드랍 했을때 */
event OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	switch(GetDir(strID, Info))
	{
		// End:0x25
		case TYPE_DIR.toTop/*1*/:
			StartMoveItemBottomToTop(Info);
			// End:0x3E
			break;
		// End:0x38
		case TYPE_DIR.toBottom/*2*/:
			StartMoveItemTopToBottom(Info);
			// End:0x3E
			break;
		// End:0xFFFF
		default:
			// End:0x3E
			break;
	}
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local int Index;
	local ItemInfo iInfo;

	Index = topRichListCtrl.GetSelectedIndex();
	GetCurrentTopListHandle().GetItem(Index, iInfo);
	StartMoveItemTopToBottom(iInfo, class'InputAPI'.static.IsAltPressed() && m_shopType == ShopSell);
}

event OnRClickListCtrlRecord(string ListCtrlID)
{
	OnDBClickListCtrlRecord(ListCtrlID);
}

/** Desc : OnHide  */
event OnHide()
{
	m_LastShopType = ShopNone;

	if(m_shopType != ShopPreview)
	{
		RequestBuySellUIClose();
	}
	// End:0x2D
	if(DialogIsMine())
	{
		DialogHide();
	}
	Clear();
	m_isCompleteTransaction = false;
	m_itemEnchantWndScript.SetIsShopping(false);
	// End:0x90
	if(GetWindowHandle("InventoryViewer").IsShowWindow())
	{
		GetWindowHandle("InventoryViewer").HideWindow();
	}
	uicontrolTextInputScr.Clear();
}

function StartMoveItemBottomToTop(ItemInfo iInfo, optional bool bAllItem)
{
	local int Index;

	Index = FindItemIndexBot(iInfo.Id);
	// End:0x23
	if(Index < 0)
	{
		return;
	}
	MoveItemBottomToTop(Index, (iInfo.AllItemCount > 0) || bAllItem);
}

function StartMoveItemTopToBottom(ItemInfo iInfo, optional bool bAllItem)
{
	local int Index;
	local INT64 ItemNum;

	Index = FindItemIndexTop(iInfo.Id);
	// End:0x23
	if(Index < 0)
	{
		return;
	}
	ItemNum = iInfo.ItemNum;
	switch(m_shopType)
	{
		// End:0x48
		case ShopRefund:
			ItemNum = 1;
		// End:0x105
		case ShopBuy:
			// End:0xA5
			if(GetCurrentBottomListHandle().GetItemNum() >= m_numPossibleSlotCount)
			{
				// End:0xA5
				if(! IsStackableItem(iInfo.ConsumeType) || (FindItemIndexBot(iInfo.Id)) == -1)
				{
					AddSystemMessage(3675);
					return;
				}
			}
			// End:0xBC
			if(ItemNum == 0)
			{
				ItemNum = 1;
			}
			// End:0x102
			if(iInfo.Price > 0)
			{
				// End:0x102
				if((CheckUserAdena(iInfo)) < ItemNum)
				{
					getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(279));
					return;
				}
			}
			// End:0x108
			break;
	}
	MoveItemTopToBottom(Index, iInfo.AllItemCount > 0 || bAllItem);
}

function INT64 CheckUserAdena(ItemInfo iInfo)
{
	local INT64 canBuyPrice;

	canBuyPrice = m_UserAdena - m_currentPrice;
	return canBuyPrice / iInfo.Price;
}

/** Desc: 아이템인벤에서 위에서 아래로 이동 */
function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local int bottomIndex;
	local ItemInfo Info, bottomInfo;

	// End:0x0D
	if(Index < 0)
	{
		return;
	}
	// End:0x39
	if(m_shopType == ShopBuy)
	{
		m_BuyTopListHandle.GetItem(Index, Info);		
	}
	else if(m_shopType == ShopSell)
	{
		m_SellTopListHandle.GetItem(Index, Info);			
	}
	else if(m_shopType == ShopRefund)
	{
		m_RefundTopListHandle.GetItem(Index, Info);				
	}
	else if(m_shopType == ShopPreview)
	{
		m_PreviewTopListHandle.GetItem(Index, Info);
	}
	// End:0x355
	if(! bAllItem && IsStackableItem(Info.ConsumeType) && Info.ItemNum != 1 && m_shopType != ShopRefund)
	{
		SetEnableWindow(false);
		DialogSetID(DIALOG_TOP_TO_BOTTOM);
		DialogSetReservedItemID(Info.Id);
		DialogSetReservedItemInfo(Info);
		DialogSetReservedInt(GetCurrentAddedWeight());
		DialogSetDefaultOK();
		switch(m_shopType)
		{
			// End:0x203
			case ShopBuy:
				// End:0x183
				if(Info.Weight > 0)
				{
					DialogShow(DialogModalType_Modalless, DialogType_NumberPad2, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));					
				}
				else
				{
					DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));
				}
				DialogSetInputlimit(CheckUserAdena(Info));
				DialogSetParamInt64(0);
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				class'DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
				// End:0x352
				break;
			// End:0x27E
			case ShopSell:
				DialogSetParamInt64(Info.ItemNum);
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				class'DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
				// End:0x352
				break;
			// End:0x2E9
			case ShopPreview:
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				class'DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
				// End:0x352
				break;
			// End:0xFFFF
			default:
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				class'DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
				// End:0x352
				break;
		}
	}
	else
	{
		Info.bShowCount = false;
		// End:0x3E7
		if(m_shopType == ShopBuy)
		{
			// End:0x393
			if(Info.ItemNum == 0)
			{
				Info.ItemNum = 1;
			}
			m_BuyBottomListHandle.AddItem(Info);
			class'UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", Info.Weight * Info.ItemNum);			
		}
		else if(m_shopType == ShopSell)
		{
			bottomIndex = m_SellBottomListHandle.FindItem(Info.Id);
			// End:0x482
			if(bottomIndex >= 0 && IsStackableItem(Info.ConsumeType))
			{
				m_SellBottomListHandle.GetItem(bottomIndex, bottomInfo);
				bottomInfo.ItemNum += Info.ItemNum;
				m_SellBottomListHandle.SetItem(bottomIndex, bottomInfo);					
			}
			else
			{
				m_SellBottomListHandle.AddItem(Info);
			}
			class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", Info.Weight * Info.ItemNum);
			m_SellTopListHandle.DeleteItem(Index);
			topRichListCtrl.DeleteRecord(Index);				
		}
		else if(m_shopType == ShopRefund)
		{
			Info.Reserved = REFUND_ITEM;
			m_RefundTopListHandle.DeleteItem(Index);
			topRichListCtrl.DeleteRecord(Index);
			m_RefundBottomListHandle.AddItem(Info);
			class'UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", Info.Weight * Info.ItemNum);					
		}
		else if(m_shopType == ShopPreview)
		{
			bottomIndex = m_PreviewBottomListHandle.FindItem(Info.Id);
			Info.ItemNum = 1;
			m_PreviewBottomListHandle.AddItem(Info);
		}
		// End:0x61F
		if(Info.Reserved != REFUND_ITEM)
		{
			AddPrice(Info.Price * Info.ItemNum);			
		}
		else
		{
			AddPrice(Info.Price);
		}
	}
	UpdateItemCount();		// Added by JoeyPark 2010/09/09
}

function int GetCurrentAddedWeight()
{
	local int i, totalWeight;
	local ItemInfo iInfo;
	local ItemWindowHandle currentBottomList;

	currentBottomList = GetCurrentBottomListHandle();

	// End:0x74 [Loop If]
	for(i = 0; i < currentBottomList.GetItemNum(); i++)
	{
		currentBottomList.GetItem(i, iInfo);
		totalWeight = totalWeight + (iInfo.Weight * int(iInfo.ItemNum));
	}
	return totalWeight;
}

/** Desc: 아이템인벤에서 아래로 위로 이동 */
function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo Info, info2;
	local int topIndex;

	// End:0x0D
	if(Index < 0)
	{
		return;
	}
	// End:0x39
	if(m_shopType == ShopBuy)
	{
		m_BuyBottomListHandle.GetItem(Index, Info);		
	}
	else if(m_shopType == ShopSell)
	{
		m_SellBottomListHandle.GetItem(Index, Info);			
	}
	else if(m_shopType == ShopRefund)
	{
		m_RefundBottomListHandle.GetItem(Index, Info);				
	}
	else if(m_shopType == ShopPreview)
	{
		m_PreviewBottomListHandle.GetItem(Index, Info);
	}

	// End:0x1B1
	if(! bAllItem && IsStackableItem(Info.ConsumeType)&& (Info.ItemNum!=1) && (Info.Reserved != REFUND_ITEM))	// stackable?
	{
		SetEnableWindow(false);
		DialogSetID(DIALOG_BOTTOM_TO_TOP);
		DialogSetDefaultOK();
		DialogSetReservedItemID(Info.Id);
		DialogSetReservedItemInfo(Info);
		DialogSetParamInt64(Info.ItemNum);
		DialogSetDefaultOK();
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));
		class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		class'DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
	}
	else
	{
		// End:0x215
		if(m_shopType == ShopBuy)
		{
			m_BuyBottomListHandle.DeleteItem(Index);
			class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", Info.Weight * Info.ItemNum);			
		}
		else if(m_shopType == ShopSell)
		{
			m_SellBottomListHandle.DeleteItem(Index);
			topIndex = m_SellTopListHandle.FindItem(Info.Id);
			// End:0x298
			if(topIndex == -1)
			{
				m_SellTopListHandle.AddItem(Info);
				topRichListCtrl.InsertRecord(makeRecord(Info));					
			}
			else
			{
				m_SellTopListHandle.GetItem(topIndex, info2);
				info2.ItemNum += Info.ItemNum;
				m_SellTopListHandle.SetItem(topIndex, info2);
				ModifyItemNumRecord(topIndex, info2.ItemNum);
			}
			class'UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", Info.Weight * Info.ItemNum);				
		}
		else if(m_shopType == ShopRefund)
		{
			m_RefundBottomListHandle.DeleteItem(Index);
			// End:0x39C
			if(Info.Reserved == REFUND_ITEM)
			{
				m_RefundTopListHandle.AddItem(Info);
				topRichListCtrl.InsertRecord(makeRecord(Info));
			}
			class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", Info.Weight * Info.ItemNum);					
		}
		else if(m_shopType == ShopPreview)
		{
			m_PreviewBottomListHandle.DeleteItem(Index);
		}
		// End:0x437
		if(Info.Reserved != 444)
		{
			AddPrice(- Info.Price * Info.ItemNum);			
		}
		else
		{
			AddPrice(- Info.Price);
		}
	}
	UpdateItemCount();		// Added by JoeyPark 2010/09/09
}

/** Desc : 윈도우가 열릴때 처리 */
function HandleOpenWindow(string param)
{
	local string Type;
	local INT64 Adena;
	local string adenaString;

	ParseString(param, "type", Type);
	// End:0xF9
	if(Type == "buy")
	{
		Clear();
		ParseInt(param, "merchant", m_merchantID);
		ParseINT64(param, "adena", Adena);
		adenaString = MakeCostString(string(Adena));
		m_AdenaTextBoxHandle.SetText(adenaString);
		m_AdenaTextBoxHandle.SetTooltipString(ConvertNumToText(string(Adena)));
		ParseInt(param, "nInventoryItemCount", m_curInventoryCount);
		ShowWindow(m_WindowName);
		class'UIAPI_WINDOW'.static.SetFocus(m_WindowName);
		SwapShopType(ShopType.ShopBuy/*1*/);
		m_UserAdena = Adena;
	}
	else if(Type == "sell")
	{
		ParseInt(param, "nInventoryItemCount", m_curInventoryCount);
		SwapShopType(ShopType.ShopSell/*2*/);			
	}
	else if(Type == "refund")
	{
		ParseInt(param, "nInventoryItemCount", m_curInventoryCount);
		SwapShopType(ShopType.ShopRefund/*4*/);				
	}
	else if(Type == "preview")
	{
		Clear();
		ParseInt(param, "merchant", m_merchantID);
		ParseINT64(param, "adena", Adena);
		adenaString = MakeCostString(string(Adena));
		m_AdenaTextBoxHandle.SetText(adenaString);
		m_AdenaTextBoxHandle.SetTooltipString(ConvertNumToText(string(Adena)));
		ShowWindow(m_WindowName);
		class'UIAPI_WINDOW'.static.SetFocus(m_WindowName);
		SwapShopType(ShopPreview);
		ParseInt(param, "npc", m_npcID);
	}
	else
	{
		m_shopType = ShopNone;
	}
	iInfos[m_shopType - 1].iItems.Length = 0;
	// End:0x291
	if(m_itemEnchantWndHandle.IsShowWindow())
	{
		m_itemEnchantWndScript.OnClickButton("ExitBtn");
	}
	m_itemEnchantWndScript.SetIsShopping(true);
	taxInfos.Length = 0;
}

/** Desc : HandleAddItem */
function HandleAddItem(string param)
{
	local int Len, infosIndex;
	local ItemInfo iInfo;

	ParamToItemInfo(param, iInfo);
	// End:0x48
	if(isCollectionItem(iInfo))
	{
		iInfo.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
	}
	// End:0x7A
	if(m_shopType == ShopBuy && iInfo.ItemNum > 0)
	{
		iInfo.bShowCount = true;
	}
	infosIndex = m_shopType - 1;
	Len = iInfos[infosIndex].iItems.Length;
	iInfos[infosIndex].iItems[Len] = iInfo;
	// End:0xE9
	if((findMatchString(GetItemNameAll(iInfo), uicontrolTextInputScr.GetString())) == -1)
	{
		return;
	}
	GetCurrentTopListHandle().AddItem(iInfo);
	topRichListCtrl.InsertRecord(makeRecord(iInfo));
}

function SetItemsWithFindString()
{
	local int i, j;
	local ItemWindowHandle iHandle, iHandleBottom;
	local array<ItemInfo> Items, topItems;
	local ItemInfo iInfo, bottomItem;
	local int Index;
	local ShopType tmpShopType;

	// End:0x246 [Loop If]
	for(j = 1; j <= 4; j++)
	{
		tmpShopType = ShopType(ToShopType(j));
		iHandle = GetTopListHandleByShopType(tmpShopType);
		iHandle.Clear();
		iHandleBottom = GetBottomListHandleByShopType(tmpShopType);
		Items = iInfos[j - 1].iItems;
		topItems.Length = 0;

		// End:0x19E [Loop If]
		for(i = 0; i < Items.Length; i++)
		{
			iInfo = Items[i];
			// End:0xE1
			if(uicontrolTextInputScr.GetString() != "")
			{
				// End:0xE1
				if((findMatchString(GetItemNameAll(iInfo), uicontrolTextInputScr.GetString())) == -1)
				{
					// [Explicit Continue]
					continue;
				}
			}
			// End:0x182
			if(tmpShopType == ShopSell || tmpShopType == ShopPreview)
			{
				Index = iHandleBottom.FindItem(iInfo.Id);
				// End:0x182
				if(Index > -1)
				{
					iHandleBottom.GetItem(Index, bottomItem);
					iInfo.ItemNum = iInfo.ItemNum - bottomItem.ItemNum;
					// End:0x182
					if(iInfo.ItemNum == 0)
					{
						// [Explicit Continue]
						continue;
					}
				}
			}
			topItems[topItems.Length] = iInfo;
		}

		// End:0x1D9 [Loop If]
		for(i = 0; i < topItems.Length; i++)
		{
			iHandle.AddItem(topItems[i]);
		}
		// End:0x23C
		if(tmpShopType == m_shopType)
		{
			topRichListCtrl.DeleteAllItem();

			// End:0x23C [Loop If]
			for(i = 0; i < topItems.Length; i++)
			{
				topRichListCtrl.InsertRecord(makeRecord(topItems[i]));
			}
		}
	}
}

function HandleDialogCancel()
{
	Debug("HandleDialogCancel shop");
	SetEnableWindow(true);
}

/** Desc: 다이얼로그 박스에서 ok를 누른 경우 */
function HandleDialogOK()
{
	local int Id, Index, topIndex;
	local INT64 Num, MAXITEMNUM;
	local ItemInfo Info, topInfo;
	local string param;
	local ItemID cID;

	Debug("HandleDialogOK shop");
	SetEnableWindow(true);
	// End:0xA53
	if(DialogIsMine())
	{
		Id = DialogGetID();
		Num = int64(DialogGetString());
		cID = DialogGetReservedItemID();
		// End:0x4E1
		if(Id == DIALOG_TOP_TO_BOTTOM && Num > 0)
		{
			topIndex = FindItemIndexTop(cID);
			// End:0x4DE
			if(topIndex >= 0)
			{
				// End:0x1FE
				if(m_shopType == ShopBuy)
				{
					m_BuyTopListHandle.GetItem(topIndex, topInfo);
					MAXITEMNUM = class'DialogBox'.static.Inst().inputLimit;
					// End:0xEB
					if(Num > MAXITEMNUM)
					{
						Num = MAXITEMNUM;
					}
					Index = m_BuyBottomListHandle.FindItem(cID);
					// End:0x16F
					if(Index >= 0)
					{
						m_BuyBottomListHandle.GetItem(Index, Info);
						Info.ItemNum += Num;
						m_BuyBottomListHandle.SetItem(Index, Info);
						AddPrice(Num * Info.Price);
					}
					else
					{
						Info = topInfo;
						Info.ItemNum = Num;
						Info.bShowCount = false;
						m_BuyBottomListHandle.AddItem(Info);
						AddPrice(Num * Info.Price);
					}
					class'UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", Info.Weight * Num);					
				}
				else if(m_shopType == ShopSell)
				{
					m_SellTopListHandle.GetItem(topIndex, topInfo);
					// End:0x24C
					if(topInfo.ItemNum < Num)
					{
						Num = topInfo.ItemNum;
					}
					Index = m_SellBottomListHandle.FindItem(cID);
					// End:0x2D0
					if(Index >= 0)
					{
						m_SellBottomListHandle.GetItem(Index, Info);
						Info.ItemNum += Num;
						m_SellBottomListHandle.SetItem(Index, Info);
						AddPrice(Num * Info.Price);							
					}
					else
					{
						Info = topInfo;
						Info.ItemNum = Num;
						Info.bShowCount = false;
						m_SellBottomListHandle.AddItem(Info);
						AddPrice(Num * Info.Price);
					}
					topInfo.ItemNum -= Num;
					// End:0x374
					if(topInfo.ItemNum <= 0)
					{
						m_SellTopListHandle.DeleteItem(topIndex);
						topRichListCtrl.DeleteRecord(topIndex);							
					}
					else
					{
						m_SellTopListHandle.SetItem(topIndex, topInfo);
						ModifyItemNumRecord(topIndex, topInfo.ItemNum);
					}
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", Info.Weight * Num);						
				}
				// 재구매시에는 갯수 다이얼로그 박스가 뜰 일이 없다.
				else if(m_shopType == ShopPreview)
				{
					m_PreviewTopListHandle.GetItem(topIndex, topInfo);
					Index = m_PreviewBottomListHandle.FindItem(cID);
					// End:0x48A
					if(Index >= 0)
					{
						m_PreviewBottomListHandle.GetItem(Index, Info);
						Info.ItemNum += Num;
						m_PreviewBottomListHandle.SetItem(Index, Info);
						AddPrice(Num * Info.Price);								
					}
					else
					{
						Info = topInfo;
						Info.ItemNum = Num;
						Info.bShowCount = false;
						m_PreviewBottomListHandle.AddItem(Info);
						AddPrice(Num * Info.Price);
					}
				}
			}
		}
		else if(Id == DIALOG_BOTTOM_TO_TOP && Num > 0)
		{
			// End:0x525
			if(m_shopType == ShopBuy)
			{
				Index = m_BuyBottomListHandle.GetSelectedNum();					
			}
			else if(m_shopType == ShopSell)
			{
				Index = m_SellBottomListHandle.GetSelectedNum();						
			}
			else if(m_shopType == ShopRefund)
			{
				Index = m_RefundBottomListHandle.GetSelectedNum();							
			}
			else if(m_shopType == ShopPreview)
			{
				Index = m_PreviewBottomListHandle.GetSelectedNum();
			}
			// End:0x960
			if(Index >= 0)
			{
				// End:0x6A4
				if(m_shopType == ShopBuy)
				{
					m_BuyBottomListHandle.GetItem(Index, Info);
					Info.ItemNum -= Num;
					// End:0x60F
					if(Info.ItemNum > 0)
					{
						m_BuyBottomListHandle.SetItem(Index, Info);							
					}
					else
					{
						m_BuyBottomListHandle.DeleteItem(Index);
					}
					class'UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", Info.Weight * Num);
					// End:0x686
					if(Info.ItemNum <= 0)
					{
						Num = Info.ItemNum + Num;
					}
					AddPrice(- Num * Info.Price);
				}
				else if(m_shopType == ShopSell)
				{
					m_SellBottomListHandle.GetItem(Index, Info);
					// End:0x6F2
					if(Info.ItemNum < Num)
					{
								Num = Info.ItemNum;
					}
					Info.ItemNum -= Num;
					// End:0x733
					if(Info.ItemNum > 0)
					{
						m_SellBottomListHandle.SetItem(Index, Info);								
					}
					else
					{
						m_SellBottomListHandle.DeleteItem(Index);
					}
					topIndex = m_SellTopListHandle.FindItem(cID);
					// End:0x7DD
					if((topIndex >= 0) && IsStackableItem(Info.ConsumeType))
					{
						m_SellTopListHandle.GetItem(topIndex, topInfo);
						topInfo.ItemNum += Num;
						m_SellTopListHandle.SetItem(topIndex, topInfo);
						ModifyItemNumRecord(topIndex, topInfo.ItemNum);								
					}
					else
					{
						Info.ItemNum = Num;
						m_SellTopListHandle.AddItem(Info);
						topRichListCtrl.InsertRecord(makeRecord(Info));
					}
					// End:0x846
					if(Info.ItemNum <= 0)
					{
								Num = Info.ItemNum + Num;
					}
					AddPrice(- Num * Info.Price);
					class'UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", Info.Weight * Num);
				}
				else if(m_shopType == ShopPreview)
				{
					m_PreviewBottomListHandle.GetItem(Index, Info);
					Info.ItemNum -= Num;
					// End:0x906
					if(Info.ItemNum > 0)
					{
						m_PreviewBottomListHandle.SetItem(Index, Info);									
					}
					else
					{
						m_PreviewBottomListHandle.DeleteItem(Index);
					}
					// End:0x945
					if(Info.ItemNum <= 0)
					{
									Num = Info.ItemNum + Num;
					}
					AddPrice(- Num * Info.Price);
				}
			}
		}
		else if(Id == DIALOG_PREVIEW)
		{
			Num = m_PreviewBottomListHandle.GetItemNum();
			// End:0xA4D
			if(Num > 0)
			{
				ParamAdd(param, "merchant", string(m_merchantID));
				ParamAdd(param, "npc", string(m_npcID));
				ParamAdd(param, "num", string(Num));

				for(index = 0; index < Num; ++index)
				{
					m_PreviewBottomListHandle.GetItem(Index, Info);
					ParamAddItemIDWithIndex(param, Info.Id, Index);
				}
				RequestPreviewItem(param);
				HideWindow(m_WindowName);
			}
		}
		UpdateItemCount();		// Added by JoeyPark 2010/09/09
	}
}

/** Desc : HandleEndTransactionList */
function HandleEndTransactionList(string param)
{
	local int WindowOpenType;

	ParseInt(param, "type", WindowOpenType);
	// End:0x4E
	if(m_LastShopType == ShopSell)
	{
		m_TransactionTabHandle.SetTopOrder(1, false);
		ClearPriceWeightInfo();
		ClearBottomBuyList();
		SwapShopType(ShopSell);
	}
	else if(m_LastShopType == ShopRefund)
	{
		m_TransactionTabHandle.SetTopOrder(2, false);
		ClearPriceWeightInfo();
		ClearBottomBuyList();
		SwapShopType(ShopRefund);
	}
	else
	{
		SwapShopType(ShopBuy);
	}
	// End:0xC2
	if(WindowOpenType == 0)
	{
		m_TransactionTabHandle.SetTopOrder(0, false);
		ClearPriceWeightInfo();
		ClearBottomBuyList();
		SwapShopType(ShopBuy);
	}
	else if(WindowOpenType == 2)
	{
		DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(279), string(self));
		class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		class'DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
		m_isCompleteTransaction = false;
	}
	else if(WindowOpenType == 3)
	{
		DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(352), string(self));
		class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		class'DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
		m_isCompleteTransaction = false;
	}
	else if(WindowOpenType == 1 && m_isCompleteTransaction)
	{
		AddSystemMessage(3092);
		m_isCompleteTransaction = false;
		HideWindow(m_WindowName);
	}
	else
	{
		m_isCompleteTransaction = false;
	}
}

function HandleSetMaxCount(string param)
{
	// local int ExtraBeltCount;
	ParseInt(param, "Inventory", m_maxInventoryCount);
}

function HandleOnAddCastleTaxRateList(string param)
{
	local int i, totalTax;
	local taxInfoByCastle taxInfo;
	local CustomTooltip mCustomTooltip;

	ParseInt(param, "CastleID", taxInfo.castleID);
	ParseInt(param, "taxRate", taxInfo.TaxRate);
	taxInfos.Length = taxInfos.Length + 1;
	taxInfos[taxInfos.Length - 1] = taxInfo;

	for(i = 0; i < taxInfos.Length; i++)
	{
		totalTax = totalTax + taxInfos[i].TaxRate;
	}
	m_TaxText.SetText(string(totalTax) $ "%");
	mCustomTooltip = TaxInfoTooltip();
	m_TaxText.SetTooltipCustomType(mCustomTooltip);
	m_TaxConstText.SetTooltipCustomType(mCustomTooltip);
}

function SwapShopType(ShopType Type)
{
	// End:0x15
	if(m_shopType == Type)
	{
		return;
	}
	m_shopType = Type;
	ClearPriceWeightInfo();
	m_TexBuySellSlotBG.HideWindow();
	m_TexPreviewSlotBG.HideWindow();
	m_TexRefundSlotBG.HideWindow();
	m_BuyTopListHandle.HideWindow();
	m_SellTopListHandle.HideWindow();
	m_RefundTopListHandle.HideWindow();
	m_BuyBottomListHandle.HideWindow();
	m_SellBottomListHandle.HideWindow();
	m_RefundBottomListHandle.HideWindow();
	m_TexTransactionBGLine.ShowWindow();
	m_TexPreviewBGLine.HideWindow();
	m_TransactionTabHandle.ShowWindow();
	m_PreviewTabHandle.HideWindow();
	m_PreviewTopListHandle.HideWindow();
	m_PreviewBottomListHandle.HideWindow();
	switch(Type)
	{
		// End:0x1DF
		case ShopBuy:
			m_BuyTopListHandle.ShowWindow();
			ClearBottomBuyList();
			m_TexBuySellSlotBG.ShowWindow();
			m_BuyBottomListHandle.ShowWindow();
			m_TopTextBoxHandle.SetText(GetSystemString(2323));
			m_BottomTextBoxHandle.SetText(GetSystemString(139));
			m_PriceConstTextBoxHandle.SetText(GetSystemString(142));
			m_OkButtonHandle.SetNameText(GetSystemString(1434));
			topRichListCtrl.SetTooltipType("InventoryPrice1HideEnchantStackable");
			// End:0x438
			break;
		// End:0x299
		case ShopSell:
			m_SellTopListHandle.ShowWindow();
			ClearBottomSellList();
			m_TexBuySellSlotBG.ShowWindow();
			m_SellBottomListHandle.ShowWindow();
			m_TopTextBoxHandle.SetText(GetSystemString(138));
			m_BottomTextBoxHandle.SetText(GetSystemString(137));
			m_PriceConstTextBoxHandle.SetText(GetSystemString(143));
			m_OkButtonHandle.SetNameText(GetSystemString(1157));
			topRichListCtrl.SetTooltipType("InventoryPrice2");
			// End:0x438
			break;
		// End:0x35C
		case ShopRefund:
			m_RefundTopListHandle.ShowWindow();
			ClearBottomRefundList();
			m_TexRefundSlotBG.ShowWindow();
			m_RefundBottomListHandle.ShowWindow();
			m_TopTextBoxHandle.SetText(GetSystemString(2324));
			m_BottomTextBoxHandle.SetText(GetSystemString(2205));
			m_PriceConstTextBoxHandle.SetText(GetSystemString(2206));
			m_OkButtonHandle.SetNameText(GetSystemString(2028));
			topRichListCtrl.SetTooltipType("InventoryPrice1");
			// End:0x438
			break;
		// End:0x435
		case ShopPreview:
			m_PreviewTopListHandle.ShowWindow();
			m_TexPreviewSlotBG.ShowWindow();
			m_TexTransactionBGLine.HideWindow();
			m_TexPreviewBGLine.ShowWindow();
			m_TransactionTabHandle.HideWindow();
			m_PreviewTabHandle.ShowWindow();
			m_PreviewBottomListHandle.ShowWindow();
			m_TopTextBoxHandle.SetText(GetSystemString(2323));
			m_BottomTextBoxHandle.SetText(GetSystemString(812));
			m_PriceConstTextBoxHandle.SetText(GetSystemString(813));
			m_OkButtonHandle.SetNameText(GetSystemString(1337));
			// End:0x438
			break;
	}
	topRichListCtrl.DeleteAllItem();
	SetListItems();
	UpdateItemCount();
	m_shopType = Type;
	FocusToList();
}

function ClearBottomBuyList()
{
	local int Index, bottomIndex;
	local ItemInfo deleteItemInfo;

	bottomIndex = m_BuyBottomListHandle.GetItemNum();
	// End:0x59
	if(bottomIndex != 0)
	{
		// End:0x59 [Loop If]
		for(Index = 0; Index < bottomIndex; Index++)
		{
			m_BuyBottomListHandle.GetItem(Index, deleteItemInfo);
		}
	}
	getInstanceL2Util().SortItem(m_SellTopListHandle);
	m_BuyBottomListHandle.Clear();
}

function ClearBottomSellList()
{
	local int Index, bottomIndex, topIndex;
	local ItemInfo deleteItemInfo, addItemInfo;

	bottomIndex = m_SellBottomListHandle.GetItemNum();
	// End:0x10D
	if(bottomIndex != 0)
	{
		// End:0x10D [Loop If]
		for(Index = 0; Index < bottomIndex; Index++)
		{
			m_SellBottomListHandle.GetItem(Index, deleteItemInfo);
			// End:0xEF
			if(IsStackableItem(deleteItemInfo.ConsumeType))
			{
				topIndex = m_SellTopListHandle.FindItem(deleteItemInfo.Id);
				m_SellTopListHandle.GetItem(topIndex, addItemInfo);
				// End:0xD8
				if(topIndex >= 0)
				{
					addItemInfo.ItemNum += deleteItemInfo.ItemNum;
					m_SellTopListHandle.SetItem(topIndex, addItemInfo);					
				}
				else
				{
					m_SellTopListHandle.AddItem(deleteItemInfo);
				}
				// [Explicit Continue]
				continue;
			}
			m_SellTopListHandle.AddItem(deleteItemInfo);
		}
	}
	m_SellBottomListHandle.Clear();
}

function ClearBottomRefundList()
{
	local int Index, bottomIndex;
	local ItemInfo deleteItemInfo;

	bottomIndex = m_RefundBottomListHandle.GetItemNum();
	// End:0x6D
	if(bottomIndex != 0)
	{
		// End:0x6D [Loop If]
		for(Index = 0; Index < bottomIndex; Index++)
		{
			m_RefundBottomListHandle.GetItem(Index, deleteItemInfo);
			m_RefundTopListHandle.AddItem(deleteItemInfo);
		}
	}
	m_RefundBottomListHandle.Clear();
}

function ClearPriceWeightInfo()
{
	m_currentPrice = 0;
	m_PriceTextBoxHandle.SetText("0");
	m_PriceTextBoxHandle.SetTooltipString("");
	class'UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName $ ".InvenWeight");
}

/** Desc : Clear  */
function Clear()
{
	m_shopType = ShopNone;
	m_merchantID = -1;
	m_npcID = -1;
	topRichListCtrl.DeleteAllItem();
	m_BuyTopListHandle.Clear();
	m_SellTopListHandle.Clear();
	m_RefundTopListHandle.Clear();
	m_BuyBottomListHandle.Clear();
	m_SellBottomListHandle.Clear();
	m_RefundBottomListHandle.Clear();
	m_PreviewTopListHandle.Clear();
	m_PreviewBottomListHandle.Clear();
	ClearPriceWeightInfo();
	m_AdenaTextBoxHandle.SetText("0");
	m_AdenaTextBoxHandle.SetTooltipString("");
	m_TransactionTabHandle.InitTabCtrl();
	taxInfos.Length = 0;
}

function SwapList()
{
	// End:0x59
	if(m_SwapItemBtn.IsShowWindow())
	{
		m_SwapItemBtn.HideWindow();
		m_SwapListBtn.ShowWindow();
		listWnd.ShowWindow();
		topRichListCtrl.SetFocus();
		isListView = true;		
	}
	else
	{
		m_SwapItemBtn.ShowWindow();
		m_SwapListBtn.HideWindow();
		listWnd.HideWindow();
		GetCurrentTopListHandle().SetFocus();
		isListView = false;
	}
}

function SetListItems()
{
	local int i;
	local ItemWindowHandle tmpItemHandle;
	local ItemInfo iInfo;

	topRichListCtrl.DeleteAllItem();
	switch(m_shopType)
	{
		// End:0x29
		case ShopBuy:
			tmpItemHandle = m_BuyTopListHandle;
			// End:0x65
			break;
		// End:0x3C
		case ShopSell:
			tmpItemHandle = m_SellTopListHandle;
			// End:0x65
			break;
		// End:0x4F
		case ShopRefund:
			tmpItemHandle = m_RefundTopListHandle;
			// End:0x65
			break;
		// End:0x62
		case ShopPreview:
			tmpItemHandle = m_PreviewTopListHandle;
			// End:0x65
			break;
	}

	// End:0xC2 [Loop If]
	for(i = 0; i < tmpItemHandle.GetItemNum(); i++)
	{
		tmpItemHandle.GetItem(i, iInfo);
		topRichListCtrl.InsertRecord(makeRecord(iInfo));
	}
}

function int FindRecordIndex(ItemInfo iInfo, out RichListCtrlRowData Record)
{
	local int Count, i;
	local RichListCtrlRowData rec;

	Count = topRichListCtrl.GetRecordCount();

	// End:0x75 [Loop If]
	for(i = 0; i < Count; i++)
	{
		topRichListCtrl.GetRec(i, rec);
		// End:0x6B
		if(rec.nReserved1 == iInfo.Id.ClassID)
		{
			return i;
		}
	}
	return -1;
}

function RichListCtrlRowData makeRecord(ItemInfo iInfo)
{
	local RichListCtrlRowData Record;
	local string toolTipParam, strAdena, strAdenaComma;
	local Color AdenaColor;
	local string ItemName, AdditionalName, allName;
	local int wMax, additionalY;

	// End:0x21
	if(iInfo.ItemNum == 0)
	{
		iInfo.ItemNum = 1;
	}
	Record.cellDataList.Length = 1;
	ItemInfoToParam(iInfo, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.nReserved1 = iInfo.Id.ClassID;
	Record.nReserved2 = iInfo.ItemNum;
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, iInfo, 0, 0, 3, -1);
	ItemName = GetItemNameAll(iInfo, true);
	AdditionalName = iInfo.AdditionalName;
	wMax = 170;
	allName = ItemName;
	additionalY = 4;
	// End:0x10A
	if(AdditionalName != "")
	{
		allName = (allName @ "") @ AdditionalName;
		additionalY = 0;
	}
	class'L2Util'.static.GetEllipsisString(allName, wMax);
	addRichListCtrlString(Record.cellDataList[0].drawitems, Left(allName, Len(ItemName)), getInstanceL2Util().BrightWhite, false, 3, 3);
	addRichListCtrlString(Record.cellDataList[0].drawitems, Right(allName, Len(allName) - Len(ItemName)), getInstanceL2Util().Yellow03, false, 0, additionalY);
	strAdena = string(iInfo.Price);
	strAdenaComma = MakeCostString(strAdena);
	AdenaColor = GetNumericColor(strAdenaComma);
	switch(m_shopType)
	{
		// End:0x268
		case ShopBuy:
			addRichListCtrlString(Record.cellDataList[0].drawitems, "", AdenaColor, true, 37, 1);
			addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.Icon.Icon_DF_Common_Adena", 16, 12);
			addRichListCtrlString(Record.cellDataList[0].drawitems, strAdenaComma, AdenaColor, false, 3);
			// End:0x2F9
			break;
		// End:0x2AB
		case ShopSell:
			addRichListCtrlString(Record.cellDataList[0].drawitems, "x" $ string(Record.nReserved2), getInstanceL2Util().ColorGold, true, 39, 1);
			// End:0x2F9
			break;
		// End:0x2EE
		case ShopRefund:
			addRichListCtrlString(Record.cellDataList[0].drawitems, "x" $ string(Record.nReserved2), getInstanceL2Util().ColorGold, true, 39, 1);
			// End:0x2F9
			break;
		// End:0x2F6
		case ShopPreview:
			// End:0x2F9
			break;
		// End:0xFFFF
		default:
			break;
	}
	Record.ForceRefreshTooltip = true;
	return Record;
}

function ModifyItemNumRecord(int Index, INT64 ItemNum)
{
	local ItemInfo iInfo;
	local RichListCtrlRowData rec;
	local string toolTipParam;

	topRichListCtrl.GetRec(Index, rec);
	ParamToItemInfo(rec.szReserved, iInfo);
	iInfo.ItemNum = ItemNum;
	ItemInfoToParam(iInfo, toolTipParam);
	rec.szReserved = toolTipParam;
	rec.nReserved2 = ItemNum;
	rec.cellDataList[0].drawitems[0].ItemInfo.ItemInfo = iInfo;
	rec.cellDataList[0].drawitems[3].strInfo.strData = "x" $ string(ItemNum);
	topRichListCtrl.ModifyRecord(Index, rec);
}

/** Desc : HandleOKButton */
function HandleOKButton()
{
	local string param;
	local int topCount, bottomCount, topIndex, bottomIndex;
	local ItemInfo topInfo, bottomInfo;
	local INT64 limitedItemCount;

	// End:0x0B
	if(m_isCompleteTransaction)
	{
		return;
	}
	m_LastShopType = m_shopType;
	// End:0x1E6
	if(m_shopType == ShopBuy)
	{
		topCount = m_BuyTopListHandle.GetItemNum();

		for(topIndex = 0; topIndex < topCount; ++topIndex)
		{
			m_BuyTopListHandle.GetItem(topIndex, topInfo);
			// End:0x16E
			if(topInfo.ItemNum > 0)		// this item can be purchased only by limited number
			{
				limitedItemCount = 0;
				// search in BottomList for same classID
				bottomCount = m_BuyBottomListHandle.GetItemNum();
				for(bottomIndex=0; bottomIndex < bottomCount; ++bottomIndex)	// match found, then check whether the number exceeds limited number
				{
					m_BuyBottomListHandle.GetItem(bottomIndex, bottomInfo);
					// End:0xF9
					if(IsSameClassID(bottomInfo.Id, topInfo.Id))
					{
						limitedItemCount += bottomInfo.ItemNum;
					}
				}

				//debug("limited Item count " $ limitedItemCount);
				// End:0x16E
				if(limitedItemCount > topInfo.ItemNum)
				{
					// warning dialog
					DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1338), string(self));
					class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
					class'DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
					return;
				}
			}
		}
		// End:0x1E6
		if(m_currentPrice > m_UserAdena)
		{
			DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(279), string(self));
			class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			class'DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
			m_isCompleteTransaction = false;
			return;
		}
	}

	// 예외 이후, 실제 처리
	if(m_shopType == ShopBuy)
	{
		bottomCount = m_BuyBottomListHandle.GetItemNum();
		// End:0x2EC
		if(bottomCount > 0)
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));

			for(bottomIndex = 0 ; bottomIndex < bottomCount; ++bottomIndex)
			{
				m_BuyBottomListHandle.GetItem(bottomIndex, bottomInfo);

				ParamAdd(param, "ClassID_" $ bottomIndex, string(bottomInfo.Id.ClassID));
				ParamAdd(param, "Count_" $ bottomIndex, string(bottomInfo.ItemNum));
			}

			RequestBuyItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if(m_shopType == ShopSell)
	{
		bottomCount = m_SellBottomListHandle.GetItemNum();

		if(bottomCount > 0)
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));

			for(bottomIndex = 0 ; bottomIndex < bottomCount; ++bottomIndex)
			{
				m_SellBottomListHandle.GetItem(bottomIndex, bottomInfo);
				ParamAddItemIDWithIndex(param, bottomInfo.Id, bottomIndex);
				ParamAdd(param, "Count_" $ bottomIndex, string(bottomInfo.ItemNum));
			}

			RequestSellItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if(m_shopType == ShopRefund)
	{
		bottomCount = m_RefundBottomListHandle.GetItemNum();

		if(bottomCount > 0)
		{
			ParamAdd(param, "merchant", string(m_merchantID));
			ParamAdd(param, "num", string(bottomCount));

			for(bottomIndex = 0 ; bottomIndex < bottomCount; ++bottomIndex)
			{
				m_RefundBottomListHandle.GetItem(bottomIndex, bottomInfo);
				ParamAdd(param, "index_" $ bottomIndex, string(bottomInfo.Id.ServerID));
			}
			
			//ttp 65008, 65009 다이얼로그 메시지를 직접 띄우고 처리
			if(m_currentPrice > m_UserAdena)
			{
				DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(279), string(self));
				class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				class'DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
				m_isCompleteTransaction = false;
				return;
			}

			RequestRefundItem(param);
			m_isCompleteTransaction = true;
		}
	}
	else if(m_shopType == ShopPreview)
	{
		bottomCount = m_PreviewBottomListHandle.GetItemNum();

		if(bottomCount > 0)
		{
			DialogSetID(DIALOG_PREVIEW);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1157), string(Self));
			class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		}	

		//HideWindow(m_WindowName);
	}
}

function FocusToList()
{
	// End:0x1B
	if(isListView)
	{
		topRichListCtrl.SetFocus();		
	}
	else
	{
		GetCurrentTopListHandle().SetFocus();
	}
	m_hOwnerWnd.DisableTick();
}

function CustomTooltip TaxInfoTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local int i, castleNum;

	for(i = 0; i < taxInfos.Length; i++)
	{
		castleNum = i * 2;
		drawListArr[castleNum] = addDrawItemText(GetCastleName(taxInfos[i].castleID) $ " : ", getInstanceL2Util().White, "", true, true);
		drawListArr[castleNum + 1] = addDrawItemText(string(taxInfos[i].TaxRate) $ "%", getInstanceL2Util().Yellow, "", false, true);
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	return mCustomTooltip;
}

/** Desc : AddPrice */
function AddPrice(INT64 Price)
{
	local string Adena;

	m_currentPrice = m_currentPrice + Price;
	
	Adena = MakeCostStringINT64(m_currentPrice);
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".PriceText", Adena);
	class'UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".PriceText", ConvertNumToText(string(m_currentPrice)));
}

/** Desc: ?재 윈도우를 활성화 비활성화 시킨다. */
function SetEnableWindow(bool flag)
{
	// End:0x1B
	if(flag)
	{
		Me.EnableWindow();		
	}
	else
	{
		Me.DisableWindow();
	}
}

/** Desc: 거래창 우상측의 아이템 갯수를 업데이트 한다. */
function UpdateItemCount()
{
	local int iTradeListCount;

	m_numPossibleSlotCount = 0;
	// End:0x6F
	if(m_shopType == ShopBuy)
	{
		iTradeListCount = m_BuyBottomListHandle.GetItemNum();
		m_numPossibleSlotCount = m_maxInventoryCount - m_curInventoryCount;
		m_ShopWndItemCountHandle.SetText("(" $ string(iTradeListCount) $ "/" $ string(m_numPossibleSlotCount) $ ")");		
	}
	else if(m_shopType == ShopSell)
	{
		iTradeListCount = m_SellBottomListHandle.GetItemNum();
		m_numPossibleSlotCount = m_maxInventoryCount - m_curInventoryCount;
		m_ShopWndItemCountHandle.SetText("(" $ string(iTradeListCount) $ ")");			
	}
	else if(m_shopType == ShopRefund)
	{
		iTradeListCount = m_RefundBottomListHandle.GetItemNum();
		m_numPossibleSlotCount = m_maxInventoryCount - m_curInventoryCount;
		m_ShopWndItemCountHandle.SetText("(" $ string(iTradeListCount) $ "/" $ string(m_numPossibleSlotCount) $ ")");				
	}
	else if(m_shopType == ShopPreview)
	{
		iTradeListCount = m_PreviewBottomListHandle.GetItemNum();
		m_ShopWndItemCountHandle.SetText("(" $ string(iTradeListCount) $ ")");
	}
}

function ItemWindowHandle GetCurrentTopListHandle()
{
	return GetTopListHandleByShopType(m_shopType);
}

function ItemWindowHandle GetTopListHandleByShopType(ShopType sType)
{
	switch(sType)
	{
		// End:0x12
		case ShopRefund:
			return m_RefundTopListHandle;
		// End:0x1D
		case ShopPreview:
			return m_PreviewTopListHandle;
		// End:0x28
		case ShopSell:
			return m_SellTopListHandle;
		// End:0x33
		case ShopBuy:
			return m_BuyTopListHandle;
		// End:0xFFFF
		default:
			return none;
	}
}

function ItemWindowHandle GetBottomListHandleByShopType(ShopType sType)
{
	switch(sType)
	{
		// End:0x12
		case ShopRefund:
			return m_RefundBottomListHandle;
		// End:0x1D
		case ShopPreview:
			return m_PreviewBottomListHandle;
		// End:0x28
		case ShopSell:
			return m_SellBottomListHandle;
		// End:0x33
		case ShopBuy:
			return m_BuyBottomListHandle;
		// End:0xFFFF
		default:
			return none;
	}
}

function ItemWindowHandle GetCurrentBottomListHandle()
{
	return GetBottomListHandleByShopType(m_shopType);
}

function int findMatchString(string targetString, string toFindString)
{
	local string delim;

	// End:0x0E
	if(toFindString == "")
	{
		return 1;
	}
	delim = " ";
	// End:0x34
	if(StringMatching(targetString, toFindString, delim))
	{
		return 1;		
	}
	else
	{
		return -1;
	}
	return 1;
}

function ShopType ToShopType(int i)
{
	switch(i)
	{
		// End:0x0E
		case 0:
			return ShopNone;
		// End:0x15
		case 1:
			return ShopBuy;
		// End:0x1D
		case 2:
			return ShopSell;
		// End:0x25
		case 3:
			return ShopPreview;
		// End:0x2D
		case 4:
			return ShopRefund;
		// End:0xFFFF
		default:
			return ShopNone;
	}
}

function int FindItemIndexTop(ItemID cID)
{
	switch(m_shopType)
	{
		// End:0x21
		case ShopBuy:
			return m_BuyTopListHandle.FindItem(cID);
		// End:0x3B
		case ShopSell:
			return m_SellTopListHandle.FindItem(cID);
		// End:0x55
		case ShopRefund:
			return m_RefundTopListHandle.FindItem(cID);
		// End:0x6F
		case ShopPreview:
			return m_PreviewTopListHandle.FindItem(cID);
		// End:0xFFFF
		default:
			return -1;
	}
}

function int FindItemIndexBot(ItemID cID)
{
	switch(m_shopType)
	{
		// End:0x21
		case ShopBuy:
			return m_BuyBottomListHandle.FindItem(cID);
		// End:0x3B
		case ShopSell:
			return m_SellBottomListHandle.FindItem(cID);
		// End:0x55
		case ShopRefund:
			return m_RefundBottomListHandle.FindItem(cID);
		// End:0x6F
		case ShopPreview:
			return m_PreviewBottomListHandle.FindItem(cID);
		// End:0xFFFF
		default:
			return -1;
	}
}

function TYPE_DIR GetDir(string dropTarget, ItemInfo iInfo)
{
	// End:0x56
	if(dropTarget == "topRichListCtrl" || dropTarget == "BuyTopList" && iInfo.DragSrcName == "BuyBottomList")
	{
		return toTop;
	}
	// End:0xAE
	if(dropTarget == "topRichListCtrl" || dropTarget == "SellTopList" && iInfo.DragSrcName == "SellBottomList")
	{
		return toTop;
	}
	// End:0x10A
	if(dropTarget == "topRichListCtrl" || dropTarget == "RefundTopList" && iInfo.DragSrcName == "RefundBottomList")
	{
		return toTop;
	}
	// End:0x168
	if(dropTarget == "topRichListCtrl" || dropTarget == "PreviewTopList" && iInfo.DragSrcName == "PreviewBottomList")
	{
		return toTop;
	}
	// End:0x1C3
	if(iInfo.DragSrcName == "topRichListCtrl" || iInfo.DragSrcName == "BuyTopList" && dropTarget == "BuyBottomList")
	{
		return toBottom;
	}
	// End:0x220
	if(iInfo.DragSrcName == "topRichListCtrl" || iInfo.DragSrcName == "SellTopList" && dropTarget == "SellBottomList")
	{
		return toBottom;
	}
	// End:0x281
	if(iInfo.DragSrcName == "topRichListCtrl" || iInfo.DragSrcName == "RefundTopList" && dropTarget == "RefundBottomList")
	{
		return toBottom;
	}
	// End:0x2E4
	if(iInfo.DragSrcName == "topRichListCtrl" || iInfo.DragSrcName == "PreviewTopList" && dropTarget == "PreviewBottomList")
	{
		return toBottom;
	}
	return non;
}

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="ShopWnd"
}
