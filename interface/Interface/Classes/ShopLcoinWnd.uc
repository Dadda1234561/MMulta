//================================================================================
// ShopLcoinWnd.
//================================================================================
class ShopLcoinWnd extends UICommonAPI;

const DIALOG_ASK_PRICE = 10111;
const MAX_CATEGORY = 6;
const ShopIndex = 3;
const COSTITEMNUM = 3;
const TIMER_CLICK = 99902;
const TIMER_DELAYC = 3000;
const TIMER_FOCUS = 99903;
const TIMER_FOCUS_DELAY = 100;
const MAXITEMNUM = 99999;
const NUMIN_PAGE_BIG = 2;
const NUMIN_PAGE_SMALL = 4;
const BUY_WND_SIZE_W_NORMAL = 418;
const BUY_wND_SIZE_H_NORMAL = 324;
const BUY_WND_SIZE_W_RELAY = 418;
const BUY_wND_SIZE_H_RELAY = 412;

struct PLShopItemDataStruct
{
	var int Index;
	var int nSlotNum;
	var int nItemClassID;
	var int nCostItemId[COSTITEMNUM];
	var INT64 nCostItemAmount[COSTITEMNUM];
	var int nRemainItemAmount;
	var int nRemainSec;
	var int nRemainServerItemAmount;
	var int sCircleNum;
	var bool isRelay;
};

var WindowHandle Me;
var CheckBoxHandle ListOption_CheckBox;
var ItemWindowHandle NeededItem_Item1Num_Item;
var TextBoxHandle NeededItem_Item1_Title;
var TextBoxHandle NeededItem_Item1Num_text;
var TextBoxHandle NeededItem_Item1MyNum_text;
var ItemWindowHandle NeededItem_Item2Num_Item;
var TextBoxHandle NeededItem_Item2_Title;
var TextBoxHandle NeededItem_Item2Num_text;
var TextBoxHandle NeededItem_Item2MyNum_text;
var ItemWindowHandle NeededItem_Item3Num_Item;
var TextBoxHandle NeededItem_Item3_Title;
var TextBoxHandle NeededItem_Item3Num_text;
var TextBoxHandle NeededItem_Item3MyNum_text;
var EditBoxHandle ItemCount_EditBox;
var ButtonHandle Reset_Btn;
var ButtonHandle Buy_Btn;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var WindowHandle ItemInfo_Wnd;
var WindowHandle Buy_Wnd;
var WindowHandle DisableWnd;
var WindowHandle DisableWndStep2;
var ButtonHandle Refresh_Button;
var TextBoxHandle ItemNum_TextBox;
var WindowHandle ShopDailyConfirm_ResultWnd;
var WindowHandle ShopDailySuccess_ResultWnd;
var WindowHandle ShopDailyFails_ResultWnd;
var TextBoxHandle ReceiveListNumberBig;
var TextBoxHandle ReceiveListNumberSmall;
var string m_WindowName;
var int currentTabIndex;
var array<int> selectedByCategoryList;
var L2Util util;
var array<PLShopItemDataStruct> pLShopItemDataList;
var array<int> homeMainList;
var array<int> homeSubList;
var int currentHomeMainPage;
var int currentHomeSubPage;
var ButtonHandle BtnBuyLast;
var HtmlHandle HtmlViewer;
var HtmlHandle HtmlViewerBanner;
var TextureHandle bannerTexture;
var LCoinShopBannerUIData bannerData;
var EditBoxHandle EditBoxFind;
var WindowHandle BannerLink;
var EffectViewportWndHandle Result_EffectViewport;
var WindowHandle BuyRelay_Wnd;
var bool isShowRelayBuyWnd;

function Initialize()
{
	local int i;

	Me = GetWindowHandle(m_WindowName);
	ItemInfo_Wnd = GetWindowHandle(m_WindowName $ ".ItemInfo_Wnd");
	Buy_Wnd = GetWindowHandle(m_WindowName $ ".Buy_Wnd");
	ListOption_CheckBox = GetCheckBoxHandle(m_WindowName $ ".List_Wnd.ListOption_CheckBox");
	ItemCount_EditBox = GetEditBoxHandle(m_WindowName $ ".Buy_Wnd.ItemCount_EditBox");
	EditBoxFind = GetEditBoxHandle(m_WindowName $ ".List_Wnd.EditBoxFind");
	Reset_Btn = GetButtonHandle(m_WindowName $ ".Buy_Wnd.Reset_Btn");
	MultiSell_Up_Button = GetButtonHandle(m_WindowName $ ".Buy_Wnd.MultiSell_Up_Button");
	MultiSell_Down_Button = GetButtonHandle(m_WindowName $ ".Buy_Wnd.MultiSell_Down_Button");
	MultiSell_Input_Button = GetButtonHandle(m_WindowName $ ".Buy_Wnd.MultiSell_Input_Button");
	DisableWnd = GetWindowHandle(m_WindowName $ ".DisableWnd");
	DisableWndStep2 = GetWindowHandle(m_WindowName $ ".Buy_Wnd.DisableWndStep2");
	Refresh_Button = GetButtonHandle(m_WindowName $ ".ListRefresh_Btn");
	ShopDailyConfirm_ResultWnd = GetWindowHandle(m_WindowName $ ".ShopDailyConfirm_ResultWnd");
	ItemNum_TextBox = GetTextBoxHandle(m_WindowName $ ".ShopDailyConfirm_ResultWnd.ItemNum_TextBox");
	ShopDailySuccess_ResultWnd = GetWindowHandle(m_WindowName $ ".ShopDailySuccess_ResultWnd");
	ShopDailyFails_ResultWnd = GetWindowHandle(m_WindowName $ ".ShopDailyFails_ResultWnd");
	ReceiveListNumberBig = GetTextBoxHandle(m_WindowName $ ".Home_Wnd.ReceiveListNumberBig");
	ReceiveListNumberSmall = GetTextBoxHandle(m_WindowName $ ".Home_Wnd.ReceiveListNumberSmall");
	BtnBuyLast = GetButtonHandle(m_WindowName $ ".Buy_Wnd.BtnBuyLast");
	HtmlViewer = GetHtmlHandle(m_WindowName $ ".ItemInfo_Wnd.HtmlViewer");
	bannerTexture = GetTextureHandle(m_WindowName $ ".Home_Wnd.Banner");
	BannerLink = GetWindowHandle(m_WindowName $ ".BannerLink");
	HtmlViewerBanner = GetHtmlHandle(m_WindowName $ ".HtmlViewerBanner");
	Result_EffectViewport = GetEffectViewportWndHandle(m_WindowName $ ".Result_EffectViewport");
	BuyRelay_Wnd = GetWindowHandle(m_WindowName $ ".Buy_Wnd.BuyRelay_Wnd");
	util = L2Util(GetScript("L2Util"));

	for(i = 1; i <= MAX_CATEGORY; i++)
	{
		getListCtrlByCategory(i).SetSelectedSelTooltip(false);
		getListCtrlByCategory(i).SetAppearTooltipAtMouseX(true);
	}
}

function API_RequestPurchaseLimitShopItemBuy(int nSlotNum, int nItemAmount)
{
	RequestPurchaseLimitShopItemBuy(ShopIndex, nSlotNum, nItemAmount);
}

function API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST packet;

	packet.cShopIndex = ShopIndex;
	if (!Class'UIPacket'.static.Encode_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST(stream, packet))
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST, stream);
}

function API_GetLCoinShopBannerData(out array<LCoinShopBannerUIData> arrBannerData)
{
	GetLCoinShopBannerData(arrBannerData);
}

function API_GetLCoinShopProductData(int ProductID, out LCoinShopProductUIData productData)
{
	GetLCoinShopProductData(ProductID, productData);
}

function OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW));
	RegisterEvent(EV_PurchaseLimitShopItemBuy);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_VitalityEffectInfo);
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
	currentTabIndex = 0;
	initSelectedItemIDArray();
}

function OnEvent(int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_PacketID(class'UIPacket'.const.S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW):
			ClearAll();
			HandleS_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW();
			// End:0xAB
			break;
		case EV_PurchaseLimitShopItemBuy:
			if(! IsMyShopIndex(param))
			{
				return;
			}
			HandleBuyResult(param);
			// End:0xAB
			break;
		case EV_UpdateUserInfo:
			if(Me.IsShowWindow())
			{
				HandleUserInfo();
			}
			// End:0xAB
			break;
		case EV_DialogOK:
			HandleDialogOK(true);
			// End:0xAB
			break;
		case EV_DialogCancel:
			HandleDialogOK(false);
			// End:0xAB
			break;
		// End:0xA8
		case EV_GamingStateEnter:
			EditBoxFind.Clear();
			HandleFormByLanguage();
			SetTabNameByServerType();
			break;
			case EV_VitalityEffectInfo:
			break;
	}
}

function OnTimer(int TimerID)
{
	switch (TimerID)
	{
		case TIMER_CLICK:
			Refresh_Button.EnableWindow();
			Me.KillTimer(TIMER_CLICK);
		case TIMER_FOCUS:
			if(currentTabIndex != 0)
			{
				getListCtrlByCategory(currentTabIndex).SetFocus();
			}
			Me.KillTimer(TIMER_FOCUS);
			break;
	}
}

function OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	if (EditBoxFind.IsFocused())
	{
		if (nKey == IK_Enter)
		{
			ClearAll();
			ShopDailyFails_ResultWnd.HideWindow();
			DisableWnd.HideWindow();
			HandleItemNewList();
		}
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x77
		case "BtnBuyLast":
			SetBuyConfirmWnd();
			DisableWndStep2.ShowWindow();
			DisableWndStep2.SetFocus();
			ShopDailyConfirm_ResultWnd.ShowWindow();
			ShopDailyConfirm_ResultWnd.SetFocus();
			// End:0x67
			if(DialogIsMine())
			{
				DialogHide();
			}
			break;
		// End:0x88
		case "BtnCancelBtn":
		// End:0xB6
		case "BtnClose":
			DisableWnd.HideWindow();
			Buy_Wnd.HideWindow();
			// End:0xB5
			if(DialogIsMine())
			{
				DialogHide();
			}
			break;
		// End:0xCE
		case "BtnBuyInfo":
			OnBuy_ButtonClick();
			// End:0x410
			break;
		// End:0xEB
		case "ListRefresh_Btn":
			OnRefresh_ButtonClick();
			// End:0x410
			break;
		// End:0x102
		case "OK_Button":
			OnOK_ButtonClick();
			// End:0x410
			break;
		// End:0x11D
		case "Cancel_Button":
			OnCancel_ButtonClick();
			// End:0x410
			break;
		// End:0x139
		case "Success_Button":
			OnSuccess_ButtonClick();
			// End:0x410
			break;
		// End:0x152
		case "Fail_Button":
			OnFail_ButtonClick();
			// End:0x410
			break;
		// End:0x176
		case "MultiSell_Input_Button":
			OnPriceEditBtnHandler();
			// End:0x410
			break;
		// End:0x197
		case "MultiSell_Up_Button":
			OnMultiSell_Up_ButtonClick();
			// End:0x410
			break;
		// End:0x1BA
		case "MultiSell_Down_Button":
			OnMultiSell_Down_ButtonClick();
			// End:0x410
			break;
		// End:0x1D2
		case "Reset_Btn":
			SetItemCountEditBox(1);
			// End:0x410
			break;
		// End:0x1ED
		case "FrameHelp_BTN":
			OnClickHelp();
			// End:0x410
			break;
		// End:0x215
		case "ReceiveListPrevBtn":
			HandleCurrentHomeMainPage(currentHomeMainPage - 1);
			// End:0x410
			break;
		// End:0x23D
		case "ReceiveListNextBtn":
			HandleCurrentHomeMainPage(currentHomeMainPage + 1);
			// End:0x410
			break;
		// End:0x26A
		case "ReceiveListPrevBtnSmall":
			HandleCurrentHomeSubPage(currentHomeSubPage - 1);
			// End:0x410
			break;
		// End:0x297
		case "ReceiveListNextBtnSmall":
			HandleCurrentHomeSubPage(currentHomeSubPage + 1);
			// End:0x410
			break;
		// End:0x2BA
		case "BtnClearEditBox":
			EditBoxFind.Clear();
			//break;
		// End:0x2D5
		case "BtnFind":
			ClearAll();
			ShopDailyFails_ResultWnd.HideWindow();
			DisableWnd.HideWindow();
			HandleItemNewList();
			// End:0x410
			break;
		// End:0x2E5
		case "BannerClose":
		// End:0x31D
		case "BannerTopClose_Btn":
			DisableWnd.HideWindow();
			BannerLink.HideWindow();
			// End:0x410
			break;
		// End:0x3A1
		case "BtnBanner":
			BannerLink.ShowWindow();
			DisableWnd.ShowWindow();
			DisableWnd.SetFocus();
			HtmlViewerBanner.LoadHtml(GetLocalizedL2TextPathNameUC() $ "product\\" $ bannerData.LinkURL);
			HtmlViewerBanner.SetFocus();
			// End:0x410
			break;
		// End:0x3B3
		case "ItemInfoClose":
		// End:0x3E5
		case "BtnCloseInfo":
			DisableWnd.HideWindow();
			ItemInfo_Wnd.HideWindow();
			// End:0x410
			break;
		// End:0x3FF
		case "BuyItemInfo_Btn":
			OnInfo_ButtonClick();
			//break;
		default:
			HandleBtnClick(Name);
			break;
	}
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local string WindowName, strID;

	switch(a_ButtonHandle.GetWindowName())
	{
		case "BtnBuy":
			WindowName = a_ButtonHandle.GetParentWindowHandle().GetWindowName();
			if (GetStringIDFromBtnName(WindowName, "Item_Big", strID))
			{
				selectedByCategoryList[currentTabIndex] = homeMainList[int(strID) + NUMIN_PAGE_BIG * currentHomeMainPage];
			}
			else
			{
				if (GetStringIDFromBtnName(WindowName, "Item_Small", strID))
				{
					selectedByCategoryList[currentTabIndex] = homeSubList[int(strID) + NUMIN_PAGE_SMALL * currentHomeSubPage];
				}
			}
			OnBuy_ButtonClick();
			break;
		case "BtnInfo":
			WindowName = a_ButtonHandle.GetParentWindowHandle().GetWindowName();
			if (GetStringIDFromBtnName(WindowName, "Item_Big", strID))
			{
				selectedByCategoryList[currentTabIndex] = homeMainList[int(strID) + NUMIN_PAGE_BIG * currentHomeMainPage];
			}
			else
			{
				if (GetStringIDFromBtnName(WindowName, "Item_Small", strID))
				{
					selectedByCategoryList[currentTabIndex] = homeSubList[int(strID) + NUMIN_PAGE_SMALL * currentHomeSubPage];
				}
			}
			OnInfo_ButtonClick();
			break;
	}
}

function OnInfo_ButtonClick()
{
	DisableWnd.ShowWindow();
	DisableWnd.SetFocus();
	GetButtonHandle(m_WindowName $ ".ItemInfo_Wnd.BtnBuyInfo").SetButtonName(2517);
	ShowInfoWnd();
	HtmlViewer.SetFocus();
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local ItemInfo Info;
	local RichListCtrlRowData Record;
	local PLShopItemDataStruct itemData;
	local LCoinShopProductUIData productData;

	Record = GetSelectedRecord();
	getListCtrlByCategory(currentTabIndex).GetSelectedRec(Record);
	itemData = pLShopItemDataList[int(Record.nReserved1)];
	Info = GetItemInfoByClassID(itemData.nItemClassID);
	API_GetLCoinShopProductData(itemData.nSlotNum, productData);

	if(Info.Id.ClassID > -1)
		selectedByCategoryList[currentTabIndex] = int(Record.nReserved1);
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	OnBuy_ButtonClick();
}

function OnClickCheckBox(string strID)
{
	switch (strID)
	{
		case "ListOption_CheckBox":
			ClearAll();
			ShopDailyFails_ResultWnd.HideWindow();
			DisableWnd.HideWindow();
			HandleItemNewList();
			break;
	}
}

function OnChangeEditBox(string strID)
{
	switch (strID)
	{
		case "ItemCount_EditBox":
			HandleEditBox();
			SetItemCountEditBox(int(ItemCount_EditBox.GetString()));
			break;
	}
}

function OnHide()
{
	Result_EffectViewport.SpawnEffect("");
	if(DialogIsMine())
	{
		DialogHide();
	}
	isShowRelayBuyWnd = false;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	GetTabHandle(m_WindowName $ ".LcoinShopList_Tab").SetTopOrder(0, true);
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	DisableWnd.HideWindow();
	ItemInfo_Wnd.HideWindow();
	Buy_Wnd.HideWindow();
	BannerLink.HideWindow();
	DisableWndStep2.HideWindow();
	ShopDailyConfirm_ResultWnd.HideWindow();
	ShopDailySuccess_ResultWnd.HideWindow();
	ShopDailyFails_ResultWnd.HideWindow();
	SetBanner();
	Me.SetFocus();
}

function OnClickHelp()
{
	if (getInstanceUIData().getIsClassicServer())
	{
		ExecuteEvent(EV_ShowHelp, "8");
	}
}

function showCategoryList(int nCategory)
{
	local int i;
	local RichListCtrlHandle empthRichListCtrl;
	local RichListCtrlHandle RichListCtrl;

	for (i = 1;i <= MAX_CATEGORY;i++)
	{
		RichListCtrl = getListCtrlByCategory(i);
		if (RichListCtrl != empthRichListCtrl)
		{
			if (i == nCategory)
			{
				RichListCtrl.ShowWindow();
				HandleFindResult();
				Me.KillTimer(TIMER_FOCUS);
				Me.SetTimer(TIMER_FOCUS, TIMER_FOCUS_DELAY);
				// [Explicit Continue]
				continue;
			}

			RichListCtrl.HideWindow();

		}
	}
	OnClickListCtrlRecord("List_ListCtrl");
}

function HandleFindResult()
{
	if ((getListCtrlByCategory(currentTabIndex).GetRecordCount() == 0) && (EditBoxFind.GetString() != ""))
	{
		GetTextBoxHandle(m_WindowName $ ".List_Wnd.CanNotFindText").ShowWindow();
		GetTextBoxHandle(m_WindowName $ ".List_Wnd.CanNotFindText").SetText(MakeFullSystemMsg(GetSystemMessage(4356), EditBoxFind.GetString()));
	}
	else
	{
		GetTextBoxHandle(m_WindowName $ ".List_Wnd.CanNotFindText").HideWindow();
	}
}

function HandleBtnClick(string btnName)
{
	local string strID;

	if(GetStringIDFromBtnName(btnName, "LcoinShopList_Tab", strID))
	{
		currentTabIndex = int(strID);
		showCategoryList(currentTabIndex);
	}
	else if(GetStringIDFromBtnName(btnName, "btnBuy", strID))
	{
		OnBuy_ButtonClick();
	}
	else if (GetStringIDFromBtnName(btnName, "btnInfo", strID))
	{
		OnInfo_ButtonClick();
	}
	else
	{
		Debug(btnName @ "Clicked");
	}
}

function OnRefresh_ButtonClick()
{
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	Me.SetTimer(TIMER_CLICK, TIMER_DELAYC);
	Refresh_Button.DisableWindow();
}

function OnPriceEditBtnHandler()
{
	DisableWnd.ShowWindow();
	DisableWnd.SetFocus();
	DialogSetID(DIALOG_ASK_PRICE);
	DialogSetEditBoxMaxLength(6);
	DialogSetCancelD(DIALOG_ASK_PRICE);
	DialogSetEditType("number");
	DialogSetParamInt64(GetCountCanBuyByIndex(GetCurrentSelectedIndex()));
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362), string(self));
}

function OnBuy_ButtonClick()
{
	DisableWnd.ShowWindow();
	DisableWnd.SetFocus();
	ShowBuyWnd();
}

function ShowInfoWnd()
{
	local ItemInfo Info, nullItem;
	local int SelectedIndex;
	local PLShopItemDataStruct ItemData;
	local LCoinShopProductUIData productData;

	SelectedIndex = GetCurrentSelectedIndex();
	ItemData = pLShopItemDataList[SelectedIndex];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	Info = GetItemInfoCurrentSelected();
	if(Info != nullItem)
	{
		GetItemWindowHandle(m_WindowName $ ".ItemInfo_Wnd.Item01_ItemWindow").Clear();
		GetItemWindowHandle(m_WindowName $ ".ItemInfo_Wnd.Item01_ItemWindow").AddItem(Info);
		GetTextBoxHandle(m_WindowName $ ".ItemInfo_Wnd.Item01Title_TextBox").SetText(GetProductNameByIndex(SelectedIndex));
		GetTextBoxHandle(m_WindowName $ ".ItemInfo_Wnd.Item01NumTitle_TextBox").SetText(("(" $ string(productData.BuyItems[itemData.sCircleNum].Count)) $ ")");
		HtmlViewer.LoadHtml(GetLocalizedL2TextPathNameUC() $ "product\\" $ productData.ProductHtm);
		// End:0x21C
		if(ItemData.nCostItemId[0] == MSIT_PCCAFE_POINT)
		{
			Info = nullItem;
			Info.Name = GetSystemString(1277);
			Info.IconName = GetPcCafeItemIconPackageName();
			Info.Enchanted = 0;
			Info.ItemType = -1;
			Info.Id.ClassID = 0;			
		}
		else if(ItemData.nCostItemId[0] == MSIT_VITAL_POINT)
		{
			Info = nullItem;
			Info.Name = GetSystemString(2492);
			Info.IconName = "icon.etc_sayha_point_01";
			Info.Enchanted = 0;
			Info.ItemType = -1;
			Info.Id.ClassID = 0;				
		}
		else
		{
			Info = GetItemInfoByClassID(ItemData.nCostItemId[0]);
		}
		GetItemWindowHandle(m_WindowName $ ".ItemInfo_Wnd.CostItem01_ItemWindow").Clear();
		GetItemWindowHandle(m_WindowName $ ".ItemInfo_Wnd.CostItem01_ItemWindow").AddItem(Info);
		GetTextBoxHandle(m_WindowName $ ".ItemInfo_Wnd.CostItem01Title_TextBox").SetText(Info.Name);
		GetTextBoxHandle(m_WindowName $ ".ItemInfo_Wnd.CostItem01NumTitle_TextBox").SetText("x" $ MakeCostStringINT64(itemData.nCostItemAmount[0]));
		GetTextureHandle(m_WindowName $ ".ItemInfo_Wnd.Item01Restriction_Texture").SetTexture(GetLimitTypeIcon(productData.LimitType));
		// End:0x425
		if(productData.LimitType == 0)
		{
			GetButtonHandle(m_WindowName $ ".ItemInfo_Wnd.btn_conditionHelp").HideWindow();
			GetTextureHandle(m_WindowName $ ".ItemInfo_Wnd.Item01Restriction_Texture").HideWindow();
			GetTextBoxHandle(m_WindowName $ ".ItemInfo_Wnd.Item01Restriction_TextBox").SetAnchor(m_WindowName $ ".ItemInfo_Wnd", "TopLeft", "TopLeft", 39, 83);			
		}
		else
		{
			GetTextureHandle(m_WindowName $ ".ItemInfo_Wnd.Item01Restriction_Texture").ShowWindow();
			// End:0x52D
			if(GetBuyTypeStringBuyLimit(productData.LimitType, productData.ResetType) == "")
			{
				GetButtonHandle(m_WindowName $ ".ItemInfo_Wnd.btn_conditionHelp").HideWindow();
				GetTextBoxHandle(m_WindowName $ ".ItemInfo_Wnd.Item01Restriction_TextBox").SetAnchor(m_WindowName $ ".ItemInfo_Wnd", "TopLeft", "TopLeft", 39, 83);				
			}
			else
			{
				GetButtonHandle(m_WindowName $ ".ItemInfo_Wnd.btn_conditionHelp").ShowWindow();
				GetTextBoxHandle(m_WindowName $ ".ItemInfo_Wnd.Item01Restriction_TextBox").SetAnchor(m_WindowName $ ".ItemInfo_Wnd", "TopLeft", "TopLeft", 56, 83);
				GetButtonHandle(m_WindowName $ ".ItemInfo_Wnd.btn_conditionHelp").SetTooltipCustomType(MakeTooltipSimpleText(GetBuyTypeStringBuyLimit(productData.LimitType, productData.ResetType)));
			}
		}
		GetTextBoxHandle(m_WindowName $ ".ItemInfo_Wnd.Item01Restriction_TextBox").SetText(GetLimitTypeIconString(productData.LimitType, productData.ResetType));
		ItemInfo_Wnd.ShowWindow();
		Buy_Wnd.HideWindow();
	}
}

function ShowBuyWnd()
{
	local ItemInfo Info, nullItem;
	local int SelectedIndex;
	local PLShopItemDataStruct ItemData;
	local LCoinShopProductUIData productData;
	local TextBoxHandle levelLimitConditionText;

	SelectedIndex = GetCurrentSelectedIndex();
	ItemData = pLShopItemDataList[SelectedIndex];
	API_GetLCoinShopProductData(ItemData.nSlotNum, productData);
	Info = GetItemInfoCurrentSelected();
	// End:0x85C
	if(Info != nullItem)
	{
		GetItemWindowHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.Item01_ItemWindow").Clear();
		GetItemWindowHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.Item01_ItemWindow").AddItem(Info);
		GetTextBoxHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Title_TextBox").SetText(GetProductNameByIndex(SelectedIndex));
		GetTextBoxHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.Item01NumTitle_TextBox").SetText(("(" $ string(productData.BuyItems[itemData.sCircleNum].Count)) $ ")");
		// End:0x211
		if(ItemData.nCostItemId[0] == MSIT_PCCAFE_POINT)
		{
			Info = nullItem;
			Info.Name = GetSystemString(1277);
			Info.IconName = GetPcCafeItemIconPackageName();
			Info.Enchanted = 0;
			Info.ItemType = -1;
			Info.Id.ClassID = 0;			
		}
		else if(ItemData.nCostItemId[0] == MSIT_VITAL_POINT)
		{
			Info = nullItem;
			Info.Name = GetSystemString(2492);
			Info.IconName = "Icon.etc_sayha_point_01";
			Info.Enchanted = 0;
			Info.ItemType = -1;
			Info.Id.ClassID = 0;
		}
		else
		{
			Info = GetItemInfoByClassID(ItemData.nCostItemId[0]);
		}
		GetItemWindowHandle(m_WindowName $ ".buy_Wnd.BuyCost_Wnd.CostItem01_ItemWindow").Clear();
		GetItemWindowHandle(m_WindowName $ ".buy_Wnd.BuyCost_Wnd.CostItem01_ItemWindow").AddItem(Info);
		GetTextBoxHandle(m_WindowName $ ".buy_Wnd.BuyCost_Wnd.CostItem01Title_TextBox").SetText(Info.Name);
		SetItemCountEditBox(1);
		GetTextureHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_Texture").SetTexture(GetLimitTypeIcon(productData.LimitType));
		// End:0x350
		if(productData.LimitType == 0)
		{
			GetButtonHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.btn_conditionHelp").HideWindow();
			GetTextureHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_Texture").HideWindow();
			GetTextBoxHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_TextBox").SetAnchor(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.BuyItemInfoBg_Texture", "TopLeft", "TopLeft", 29, 53);			
		}
		else
		{
			GetTextureHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_Texture").ShowWindow();
			// End:0x575
			if(GetBuyTypeStringBuyLimit(productData.LimitType, productData.ResetType) == "")
			{
				GetButtonHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.btn_conditionHelp").HideWindow();
				GetTextBoxHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_TextBox").SetAnchor(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.BuyItemInfoBg_Texture", "TopLeft", "TopLeft", 29, 53);				
			}
			else
			{
				GetButtonHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.btn_conditionHelp").ShowWindow();
				GetTextBoxHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_TextBox").SetAnchor(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.BuyItemInfoBg_Texture", "TopLeft", "TopLeft", 45, 53);
				GetButtonHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.btn_conditionHelp").SetTooltipCustomType(MakeTooltipSimpleText(GetBuyTypeStringBuyLimit(productData.LimitType, productData.ResetType)));
			}
		}
		GetTextBoxHandle(m_WindowName $ ".buy_Wnd.BuyItemInfo_Wnd.Item01Restriction_TextBox").SetText(GetLimitTypeIconString(productData.LimitType, productData.ResetType));
		ItemCount_EditBox.ShowWindow();
		levelLimitConditionText = GetTextBoxHandle(m_WindowName $ ".Buy_Wnd.LvLimit_TextBox.LvLimit_TextBox");
		levelLimitConditionText.SetText((GetSystemString(13255) @ ":") @ (GetLevelString(productData.BuyItems[itemData.sCircleNum].LevelMin, productData.BuyItems[itemData.sCircleNum].LevelMax)));
		// End:0x7EF
		if(CheckLevelCondition(GetCurrentSelectedIndex()))
		{
			levelLimitConditionText.SetTextColor(getInstanceL2Util().Blue);			
		}
		else
		{
			levelLimitConditionText.SetTextColor(getInstanceL2Util().DRed);
		}
		// End:0x838
		if(ItemData.isRelay)
		{
			ShowRelayItem(productData.BuyItems, ItemData.sCircleNum);			
		}
		else
		{
			HideRelayItem();
		}
		Buy_Wnd.ShowWindow();
		ItemInfo_Wnd.HideWindow();
	}
}

function OnOK_ButtonClick()
{
	API_RequestPurchaseLimitShopItemBuy(pLShopItemDataList[GetCurrentSelectedIndex()].nSlotNum, int(ItemCount_EditBox.GetString()));
	DisableWndStep2.HideWindow();
	ShopDailyConfirm_ResultWnd.HideWindow();
}

function OnCancel_ButtonClick()
{
	ItemCount_EditBox.ShowWindow();
	DisableWndStep2.HideWindow();
	ShopDailyConfirm_ResultWnd.HideWindow();
}

function OnSuccess_ButtonClick()
{
	DisableWnd.HideWindow();
	Buy_Wnd.HideWindow();
	DisableWndStep2.HideWindow();
	ShopDailySuccess_ResultWnd.HideWindow();
	ItemCount_EditBox.ShowWindow();
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	isShowRelayBuyWnd = pLShopItemDataList[GetCurrentSelectedIndex()].isRelay;
}

function OnFail_ButtonClick()
{
	DisableWndStep2.HideWindow();
	Buy_Wnd.HideWindow();
	ShopDailySuccess_ResultWnd.HideWindow();
	ShopDailyFails_ResultWnd.HideWindow();
	DisableWnd.HideWindow();
	ItemCount_EditBox.ShowWindow();
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
}

function OnMultiSell_Up_ButtonClick()
{
	SetItemCountEditBox(int(ItemCount_EditBox.GetString()) + 1);
}

function OnMultiSell_Down_ButtonClick()
{
	SetItemCountEditBox(int(ItemCount_EditBox.GetString()) - 1);
}

function SetBanner()
{
	local array<LCoinShopBannerUIData> arrBannerData;
	local ButtonHandle BtnBanner;

	API_GetLCoinShopBannerData(arrBannerData);
	BtnBanner = GetButtonHandle(m_WindowName $ ".Home_Wnd.BtnBanner");
	if (arrBannerData.Length <= 0)
	{
		bannerTexture.SetTexture("L2UI_ct1.LCoinShopWnd_Banner_Img");
		BtnBanner.HideWindow();
		return;
	}
	bannerData = arrBannerData[Rand(arrBannerData.Length)];
	if (bannerData.TextureName == "")
	{
		bannerTexture.SetTexture("L2UI_ct1.LCoinShopWnd_Banner_Img");
		BtnBanner.HideWindow();
		return;
	}
	bannerTexture.SetTexture(bannerData.TextureName);
	if (bannerData.LinkURL == "")
	{
		BtnBanner.HideWindow();
	}
	else
	{
		BtnBanner.ShowWindow();
	}
}

function ClearAll()
{
	local int i;

	for (i = 1;i <= MAX_CATEGORY;i++)
	{
		getListCtrlByCategory(i).DeleteAllItem();
	}
	DisableWndStep2.HideWindow();
	ShopDailyConfirm_ResultWnd.HideWindow();
	ShopDailySuccess_ResultWnd.HideWindow();
	ItemCount_EditBox.ShowWindow();
}

function initSelectedItemIDArray()
{
	selectedByCategoryList[0] = -1;
	selectedByCategoryList[1] = -1;
	selectedByCategoryList[2] = -1;
	selectedByCategoryList[3] = -1;
	selectedByCategoryList[4] = -1;
	selectedByCategoryList[5] = -1;
	selectedByCategoryList[6] = -1;
}

function HandleUserInfo()
{
	if (getInstanceUIData().isLevelUP())
	{
		Me.HideWindow();
	}
}

function bool CanBuyByRecord(RichListCtrlRowData Record)
{
	return GetCountCanBuy(Record) > 0;
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

function int GetCountCanBuy(RichListCtrlRowData Record)
{
	return GetCountCanBuyByIndex(int(Record.nReserved1));
}

function int GetCountCanBuyByIndex(int Index)
{
	local int Count;

	// End:0x12
	if(! CheckLevelCondition(Index))
	{
		return 0;
	}
	Count = GetItemLimitAmount(Index);
	Count = Min(GetMinAmoutByCostItemNum(Index), Count);
	// End:0x5D
	if(pLShopItemDataList[Index].isRelay)
	{
		Count = Min(1, Count);
	}
	return Count;
}

function bool CheckLevelCondition(int Index)
{
	local UserInfo Info;
	local PLShopItemDataStruct itemData;
	local LCoinShopProductUIData productData;

	itemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(itemData.nSlotNum, productData);
	if(! GetPlayerInfo(Info))
	{
		return false;
	}
	if(Info.nLevel > productData.BuyItems[itemData.sCircleNum].LevelMax || Info.nLevel < productData.BuyItems[itemData.sCircleNum].LevelMin)
	{
		return false;
	}
	return true;
}

function int GetItemLimitAmount(int Index)
{
	local LCoinShopProductUIData productData;

	API_GetLCoinShopProductData(pLShopItemDataList[Index].nSlotNum, productData);
	if (productData.LimitType == 0)
	{
		return MAXITEMNUM;
	}
	else
	{
		return pLShopItemDataList[Index].nRemainItemAmount;
	}
}

function int GetMinAmoutByCostItemNum(int Index)
{
	local int i, costItemID;
	local INT64 Count, CostItemAmount;
	local PLShopItemDataStruct ItemData;

	ItemData = pLShopItemDataList[Index];
	Count = MAXITEMNUM;

	for (i = 0; i < COSTITEMNUM; i++)
	{
		costItemID = ItemData.nCostItemId[i];
		CostItemAmount = ItemData.nCostItemAmount[i];
		// End:0x91
		if(costItemID > 0)
		{
			Count = Min64(Count, GetInventoryItemCount(GetItemID(costItemID)) / CostItemAmount);
			// [Explicit Continue]
			continue;
		}
		// End:0xD6
		if(costItemID < 0 && costItemID == MSIT_PCCAFE_POINT)
		{
			Count = Min64(Count, getInstanceUIData().getCurrentPcCafePoint() / CostItemAmount);
			// [Explicit Continue]
			continue;
		}
		if(costItemID < 0 && costItemID == MSIT_VITAL_POINT)
		{
			Count = Min64(Count, getInstanceUIData().getCurrentVitalityPoint() / CostItemAmount);
		}
	}
	return int(Count);
}

function SetHomeMainItem(int Index, int homeListIndex)
{
	local ItemInfo Info;
	local PLShopItemDataStruct itemData;
	local LCoinShopProductUIData productData;

	if (homeMainList.Length <= homeListIndex)
	{
		GetHomeMainByIndex(Index).HideWindow();
		return;
	}
	GetHomeMainByIndex(Index).ShowWindow();
	itemData = pLShopItemDataList[homeMainList[homeListIndex]];
	API_GetLCoinShopProductData(itemData.nSlotNum, productData);
	Info = GetItemInfoByClassID(itemData.nItemClassID);
	GetHomeMainItemByIndex(Index).Clear();
	GetHomeMainItemByIndex(Index).AddItem(Info);
	if (productData.MarkType == 0)
	{
		GetHomeMainSaleType(Index).HideWindow();
	}
	else
	{
		GetHomeMainSaleType(Index).SetTexture(GetMarkIconByType(productData.MarkType));
		GetHomeMainSaleType(Index).ShowWindow();
	}
	if (GetLanguage() == LANG_Korean)
	{
		GetHomeMainText(Index, 0).SetText(productData.HeadLine);
	}
	else
	{
		if (Index % 2 == 0)
		{
			GetHomeMainText(Index, 0).SetText(GetSystemString(5923));
		}
		else
		{
			GetHomeMainText(Index, 0).SetText(GetSystemString(5924));
		}
	}
	GetHomeMainText(Index, 1).SetText(GetProductNameByIndex(homeMainList[homeListIndex]));
	GetHomeMainText(Index, 2).SetText(("(" $ string(productData.BuyItems[itemData.sCircleNum].Count)) $ ")");
	// End:0x234
	if(itemData.nRemainSec > 0)
	{
		GetHomeMainText(Index, 3).SetText(util.getTimeStringBySec3(itemData.nRemainSec));
	}
	else
	{
		GetHomeMainText(Index, 3).SetText(GetSystemString(3979));
	}
	if (productData.LimitCountMax == 0)
	{
		GetHomeMainText(Index, 4).SetText(GetSystemString(13270));
	}
	else
	{
		GetHomeMainText(Index, 4).SetText(string(itemData.nRemainItemAmount) $ "/" $ string(productData.LimitCountMax) @GetBuyTypeStringBuyRefresh(productData.ResetType));
		GetHomeMainText(Index, 4).SetTextColor(GetColor(255, 255, 255, 255));
	}
	GetHomeMainIconType(Index).SetTexture(GetMoneyIconByID(itemData.nCostItemId[0]));
	GetHomeMainText(Index, 8).SetText(GetLevelString(productData.BuyItems[itemData.sCircleNum].LevelMin, productData.BuyItems[itemData.sCircleNum].LevelMax));
	GetHomeMainText(Index, 7).SetText(MakeCostStringINT64(itemData.nCostItemAmount[0]));
}

function string GetLevelString(int MinLevel, int MaxLevel)
{
	if (MinLevel == 1 && MaxLevel == 999)
	{
		return "-";
	}
	if (MinLevel == 1)
	{
		return string(MaxLevel) @GetSystemString(5182);
	}
	if (MaxLevel == 999)
	{
		return string(MinLevel) @GetSystemString(859);
	}
	return string(MinLevel) @GetSystemString(859) @ "~" @string(MaxLevel) @GetSystemString(13266);
}

function SetHomeSubItem(int Index, int homeListIndex)
{
	local ItemInfo Info;
	local PLShopItemDataStruct itemData;
	local LCoinShopProductUIData productData;

	if (homeSubList.Length <= homeListIndex)
	{
		GetHomeSubByIndex(Index).HideWindow();
		return;
	}
	GetHomeSubByIndex(Index).ShowWindow();
	itemData = pLShopItemDataList[homeSubList[homeListIndex]];
	API_GetLCoinShopProductData(itemData.nSlotNum, productData);
	Info = GetItemInfoByClassID(itemData.nItemClassID);
	GetHomeSubItemByIndex(Index).Clear();
	GetHomeSubItemByIndex(Index).AddItem(Info);
	if (productData.MarkType == 0)
	{
		GetHomeSubSaleType(Index).HideWindow();
	}
	else
	{
		GetHomeSubSaleType(Index).SetTexture(GetMarkIconByType(productData.MarkType));
		GetHomeSubSaleType(Index).ShowWindow();
	}
	GetHomeSubText(Index, 0).SetText(GetProductNameByIndex(homeSubList[homeListIndex]));
	GetHomeSubText(Index, 1).SetText(("(" $ string(productData.BuyItems[itemData.sCircleNum].Count)) $ ")");
	if(itemData.nRemainSec > 0)
	{
		GetHomeSubText(Index, 2).SetText(util.getTimeStringBySec3(itemData.nRemainSec));
	}
	else
	{
		GetHomeSubText(Index, 2).SetText(GetSystemString(3979));
	}
	GetHomeSubIconType(Index).SetTexture(GetMoneyIconByID(itemData.nCostItemId[0]));
	GetHomeSubText(Index, 3).SetText(MakeCostStringINT64(itemData.nCostItemAmount[0]));
}

function HandleCurrentHomeMainPage(int pageNum)
{
	local int i;
	local int maxPage;

	maxPage = homeMainList.Length / NUMIN_PAGE_BIG;
	if (homeMainList.Length % NUMIN_PAGE_BIG > 0)
	{
		maxPage++;
	}
	if (pageNum >= maxPage)
	{
		pageNum = 0;
	}
	else
	{
		if (pageNum < 0)
		{
			pageNum = maxPage - 1;
		}
	}
	
	for (i = 0; i < NUMIN_PAGE_BIG; i++)
	{
		SetHomeMainItem(i, pageNum * NUMIN_PAGE_BIG + i);
	}
	currentHomeMainPage = pageNum;
	ReceiveListNumberBig.SetText(string(currentHomeMainPage + 1) $ "/" $ string(maxPage));
}

function HandleCurrentHomeSubPage(int pageNum)
{
	local int i;
	local int maxPage;

	maxPage = homeSubList.Length / NUMIN_PAGE_SMALL;
	if (homeSubList.Length % NUMIN_PAGE_SMALL > 0)
	{
		maxPage++;
	}
	if (pageNum >= maxPage)
	{
		pageNum = 0;
	}
	else
	{
		if (pageNum < 0)
		{
			pageNum = maxPage - 1;
		}
	}
	
	for (i = 0;i < NUMIN_PAGE_SMALL;i++)
	{
		SetHomeSubItem(i, pageNum * NUMIN_PAGE_SMALL + i);
	}
	currentHomeSubPage = pageNum;
	ReceiveListNumberSmall.SetText(string(currentHomeSubPage + 1) $ "/" $ string(maxPage));
}

function HandleS_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW()
{
	local UIPacket._S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW packet;
	local int i, j;
	local PLShopItemDataStruct pLShopItemData;
	local LCoinShopProductUIData productData;

	if (!class'UIPacket'.static.Decode_S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW(packet))
	{
		return;
	}
	if (packet.cShopIndex != ShopIndex)
	{
		return;
	}

	if(packet.cPage == 1)
	{
		pLShopItemDataList.Length = 0;
	}

	for (i = 0; i < packet.vItemList.Length; i++)
	{
		pLShopItemData.Index = i;
		pLShopItemData.nSlotNum = packet.vItemList[i].nSlotNum;
		pLShopItemData.nItemClassID = packet.vItemList[i].nItemClassID;

		for (j = 0; j < ShopIndex; j++)
		{
			pLShopItemData.nCostItemId[j] = packet.vItemList[i].nCostItemId[j];
		}

		for (j = 0;j < ShopIndex; j++)
		{
			pLShopItemData.nCostItemAmount[j] = packet.vItemList[i].nCostItemAmount[j];
		}

		pLShopItemData.nRemainItemAmount = packet.vItemList[i].nRemainItemAmount;
		pLShopItemData.nRemainSec = packet.vItemList[i].nRemainSec;
		pLShopItemData.nRemainServerItemAmount = packet.vItemList[i].nRemainServerItemAmount;
		pLShopItemData.sCircleNum = packet.vItemList[i].sCircleNum;
		API_GetLCoinShopProductData(packet.vItemList[i].nSlotNum, productData);
		pLShopItemData.isRelay = productData.MarkType == 6;
		pLShopItemDataList[pLShopItemDataList.Length] = pLShopItemData;
	}

	if(packet.cPage < packet.cMaxPage)
	{
		return;
	}
	HandleItemNewList();
	// End:0x256
	if(isShowRelayBuyWnd)
	{
		isShowRelayBuyWnd = false;
		ShowBuyWnd();
	}
}

function HandleItemNewList()
{
	local int i;
	local RichListCtrlRowData Record;
	local LCoinShopProductUIData productData;
	local bool canBuy;

	homeMainList.Length = 0;
	homeSubList.Length = 0;
	
	for (i = 0; i < pLShopItemDataList.Length; i++)
	{
		API_GetLCoinShopProductData(pLShopItemDataList[i].nSlotNum, productData);
		switch(productData.ProductType)
		{
			// End:0x55
			case 0:
				// End:0x8B
				break;
			// End:0x6E
			case 1:
				homeMainList[homeMainList.Length] = i;
				// End:0x8B
				break;
			// End:0x88
			case 2:
				homeSubList[homeSubList.Length] = i;
				break;
		}
		canBuy = GetCountCanBuyByIndex(pLShopItemDataList[i].Index) > 0;
		if(ListOption_CheckBox.IsChecked())
		{
			// End:0xCB
			if(! canBuy)
			{
				continue;
			}
		}

		// End:0xDE
		if(! bFindMatchString(productData))
		{
			// [Explicit Continue]
			continue;
		}

		Record = makeRecord(i);
		getListCtrlByCategory(productData.Category + 1).InsertRecord(Record);
	}

	HandleCurrentHomeMainPage(currentHomeMainPage);
	HandleCurrentHomeSubPage(currentHomeSubPage);
	HandleFindResult();
}

function bool bFindMatchString(LCoinShopProductUIData productData)
{
	local int j;

	// End:0x58 [Loop If]
	for(j = 0; j < productData.BuyItems.Length; j++)
	{
		// End:0x4E
		if((findMatchString(productData.BuyItems[j].ProductName, EditBoxFind.GetString())) == 1)
		{
			return true;
		}
	}
	return false;
}

function RichListCtrlRowData makeRecord(int Index)
{
	local RichListCtrlRowData Record;
	local string fullNameString, toolTipParam;
	local ItemInfo Info;
	local UserInfo PlayerInfo;
	local INT64 tmpCostNum;
	local PLShopItemDataStruct itemData;
	local LCoinShopProductUIData productData;
	local Color tmpTextColor;
	local bool bBreakLine, canBuy;

	itemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(itemData.nSlotNum, productData);
	canBuy = GetItemLimitAmount(Index) > 0;
	GetPlayerInfo(PlayerInfo);
	Info = GetItemInfoByClassID(itemData.nItemClassID);
	fullNameString = GetItemNameAll(Info);
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.cellDataList.Length = 6;
	Record.nReserved1 = int64(Index);
	Record.cellDataList[0].nReserved1 = itemData.nItemClassID;
	Record.cellDataList[2].nReserved3 = itemData.nSlotNum;
	Record.cellDataList[0].szData = fullNameString;
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconName, 32, 32, 10, 6);
	// End:0x162
	if(Info.IconPanel != "")
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconPanel, 32, 32, -32, 0);
	}
	// End:0x1BA
	if(! canBuy)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.ItemWindow.ItemWindow_IconDisable", 32, 32, -32, 0);
	}
	// End:0x1DA
	if(canBuy)
	{
		tmpTextColor = GetColor(170, 153, 119, 255);
	}
	else
	{
		tmpTextColor = util.DarkGray;
	}
	// End:0x232
	if(productData.MarkType == 0)
	{
		addRichListCtrlString(Record.cellDataList[0].drawitems, GetProductNameByIndex(Index), tmpTextColor, false, 5, 2);
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, GetMarkIconByType(productData.MarkType), 64, 64, -42, -6);
		if(itemData.isRelay)
		{
			Record.sOverlayTex = "L2UI_EPIC.LCoinShopWnd.ListBg_RelayItem";
			Record.OverlayTexU = 957;
			Record.OverlayTexV = 50;
		}
		addRichListCtrlString(Record.cellDataList[0].drawitems, GetProductNameByIndex(Index), tmpTextColor, false, -16, 8);
	}
	addRichListCtrlString(Record.cellDataList[0].drawitems, ("(" $ string(productData.BuyItems[itemData.sCircleNum].Count)) $ ")", tmpTextColor, true, 47, 0);
	// End:0x35B
	if(canBuy)
	{
		tmpTextColor = GetColor(254, 215, 160, 255);
	}
	else
	{
		tmpTextColor = util.DarkGray;
	}
	// End:0x3E4
	if(productData.BuyItems[itemData.sCircleNum].LevelMin != 1)
	{
		addRichListCtrlString(Record.cellDataList[1].drawitems, string(productData.BuyItems[itemData.sCircleNum].LevelMin) @ GetSystemString(859), tmpTextColor, false, 10, -2);
		bBreakLine = true;
	}
	// End:0x45A
	if(productData.BuyItems[itemData.sCircleNum].LevelMax != 999)
	{
		addRichListCtrlString(Record.cellDataList[1].drawitems, GetSystemString(13268) @ string(productData.BuyItems[itemData.sCircleNum].LevelMax), tmpTextColor, bBreakLine, 10, -2);
	}
	if(productData.BuyItems[itemData.sCircleNum].LevelMin == 1 && productData.BuyItems[itemData.sCircleNum].LevelMax == 999)
	{
		addRichListCtrlString(Record.cellDataList[1].drawitems, "-", tmpTextColor, false, 10, 0);
	}
	// End:0x4E3
	if(canBuy)
	{
		tmpTextColor = util.White;
	}
	else
	{
		tmpTextColor = util.DarkGray;
	}

	if(itemData.nRemainSec > 0)
	{
		addRichListCtrlString(Record.cellDataList[2].drawitems, util.getTimeStringBySec3(itemData.nRemainSec), tmpTextColor, false, 0, 0);
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[2].drawitems, "L2UI_CT1.ShopDailyWnd.ShopDailyWnd_Icon_Infinity", 16, 8, 0, 0);
	}
	// End:0x5F7
	if(productData.LimitCountMax > 0)
	{
		addRichListCtrlString(Record.cellDataList[3].drawitems, ((string(itemData.nRemainItemAmount) $ "/") $ string(productData.LimitCountMax)) @ (GetBuyTypeStringBuyRefresh(productData.ResetType)), tmpTextColor, false, 0, 0);		
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[3].drawitems, "L2UI_CT1.ShopDailyWnd.ShopDailyWnd_Icon_Infinity", 16, 8, 0, 0);
	}
	if (GetLanguage() == LANG_Korean)
	{
		addRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo" $ string(Index), 20, 0, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Info_Button", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Info_Button_Down", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Info_Button_Over", 32, 32, 32, 32);
	}
	addRichListCtrlButton(Record.cellDataList[4].drawitems, "btnBuy" $ string(Index), 37, 0, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Down", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Over", 32, 32, 32, 32);
	tmpCostNum = GetAdenaNum(itemData);
	if (tmpCostNum != -1)
	{
		addRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
		addRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
		addRichListCtrlTexture(Record.cellDataList[4].drawitems, "L2UI_CT1.Icon.Icon_DF_Common_Adena", 16, 12, 220, -16);
	}
	else
	{
		tmpCostNum = GetLcoinNum(itemData);
		if (tmpCostNum != -1)
		{
			addRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
			addRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
			addRichListCtrlTexture(Record.cellDataList[4].drawitems, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin", 18, 18, 220, -16);
		}
		tmpCostNum = GetMultiCoinNum(itemData);
		if (tmpCostNum != -1)
		{
			addRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
			addRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
			addRichListCtrlTexture(Record.cellDataList[4].drawitems, "L2UI_NewTex.BottomBar.BottomBar_EinhasadCoin", 18, 18, 220, -16);
		}
		tmpCostNum = GetPCCafePointNum(itemData);
		// End:0xA0E
		if(tmpCostNum != -1)
		{
			addRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
			addRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
			addRichListCtrlTexture(Record.cellDataList[4].drawitems, GetPcCafeItemIconPackageName(true), 18, 18, 220, -16);
		}
		tmpCostNum = GetVitalPointNum(ItemData);
		// End:0xAC8
		if(tmpCostNum != -1)
		{
			addRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
			addRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
			addRichListCtrlTexture(Record.cellDataList[4].drawitems, "L2UI_EPIC.LCoinShopWnd.Sayhas_Small", 18, 18, 220, -16);
		}
		tmpCostNum = GetAcoinNum(ItemData);
		// End:0xAD2
		if(tmpCostNum != -1)
		{
			addRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostStringINT64(tmpCostNum), tmpTextColor, false, 40, 10);
			addRichListCtrlString(Record.cellDataList[4].drawitems, "", tmpTextColor, true, 0, 0);
			addRichListCtrlTexture(Record.cellDataList[4].drawitems, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Acoin", 18, 18, 220, -16);
		}
	}
	return Record;
}

function SetControlerBtns()
{
	local int Count, canBuyCount;

	canBuyCount = GetCountCanBuyByIndex(GetCurrentSelectedIndex());
	Count = int(ItemCount_EditBox.GetString());
	if (canBuyCount > 0)
	{
		if (canBuyCount == 1)
		{
			MultiSell_Input_Button.DisableWindow();
			ItemCount_EditBox.DisableWindow();
		}
		else
		{
			MultiSell_Input_Button.EnableWindow();
			ItemCount_EditBox.EnableWindow();
		}
		if (canBuyCount == Count)
		{
			MultiSell_Up_Button.DisableWindow();
		}
		else
		{
			MultiSell_Up_Button.EnableWindow();
		}
		if (Count <= 1)
		{
			Reset_Btn.DisableWindow();
			MultiSell_Down_Button.DisableWindow();
		}
		else
		{
			Reset_Btn.EnableWindow();
			MultiSell_Down_Button.EnableWindow();
		}
		if (Count > 0)
		{
			BtnBuyLast.EnableWindow();
		}
		else
		{
			BtnBuyLast.DisableWindow();
		}
	}
	else
	{
		MultiSell_Up_Button.DisableWindow();
		MultiSell_Down_Button.DisableWindow();
		MultiSell_Input_Button.DisableWindow();
		ItemCount_EditBox.DisableWindow();
		BtnBuyLast.DisableWindow();
	}
	SetBuyButtonTooltip();
}

function SetItemCountEditBox(int Num)
{
	if (GetCurrentSelectedIndex() == -1)
	{
		Num = 0;
	}
	else
	{
		if (Num < 1)
		{
			Num = 0;
		}
	}
	Num = Min(GetCountCanBuyByIndex(GetCurrentSelectedIndex()), Num);
	Debug("SetItemCountEditBox" @ string(Num) @ string(GetCountCanBuyByIndex(GetCurrentSelectedIndex())));
	if(Num != int(ItemCount_EditBox.GetString()))
	{
		ItemCount_EditBox.SetString(string(Num));
	}
	SetBuyCostText(Num);
	SetControlerBtns();
}

function SetBuyCostText(int Count)
{
	local INT64 COSTITEMNUM;
	local INT64 haveItem;

	Debug("---pLShopItemDataList[GetCurrentSelectedIndex()].nCostItemID[0]" @ string(pLShopItemDataList[GetCurrentSelectedIndex()].nCostItemId[0]));
	// End:0x96
	if(pLShopItemDataList[GetCurrentSelectedIndex()].nCostItemId[0] == MSIT_PCCAFE_POINT)
	{
		haveItem = getInstanceUIData().getCurrentPcCafePoint();		
	}
    else if(pLShopItemDataList[GetCurrentSelectedIndex()].nCostItemId[0] == MSIT_VITAL_POINT)
	{
		haveItem = getInstanceUIData().getCurrentVitalityPoint();
	}
	else
	{
		haveItem = GetInventoryItemCount(GetItemID(pLShopItemDataList[GetCurrentSelectedIndex()].nCostItemId[0]));
	}
	COSTITEMNUM = pLShopItemDataList[GetCurrentSelectedIndex()].nCostItemAmount[0] * Max(Count, 1);
	// End:0x176
	if(haveItem >= COSTITEMNUM)
	{
		GetTextBoxHandle(m_WindowName $ ".Buy_Wnd.CostItem01MyNumTitle_TextBox").SetTextColor(util.BLUE01);
	}
	else
	{
		GetTextBoxHandle(m_WindowName $ ".Buy_Wnd.CostItem01MyNumTitle_TextBox").SetTextColor(util.DRed);
	}
	GetTextBoxHandle(m_WindowName $ ".Buy_Wnd.CostItem01NumTitle_TextBox").SetText("x" $ MakeCostStringINT64(COSTITEMNUM));
	GetTextBoxHandle(m_WindowName $ ".Buy_Wnd.CostItem01MyNumTitle_TextBox").SetText("(" $ MakeCostStringINT64(haveItem) $ ")");
}

function SetBuyButtonTooltip()
{
	local CustomTooltip t;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(10);
	// End:0x55
	if((GetCurrentSelectedIndex()) == -1)
	{
		BtnBuyLast.SetTooltipCustomType(util.getCustomToolTip());
		return;
	}
	// End:0x8D
	if(! CheckLevelCondition(GetCurrentSelectedIndex()))
	{
		util.ToopTipInsertText(GetSystemString(1030), true, true, util.ETooltipTextType.COLOR_RED);
	}
	if (GetItemLimitAmount(GetCurrentSelectedIndex()) == 0)
	{
		util.ToopTipInsertText(GetSystemString(3725) $ " ", true, true, util.ETooltipTextType.COLOR_GRAY);
		util.ToopTipInsertText("0", true, False, util.ETooltipTextType.COLOR_RED);
	}
	if (GetMinAmoutByCostItemNum(GetCurrentSelectedIndex()) == 0)
	{
		util.ToopTipInsertText(GetSystemMessage(701), true, true, util.ETooltipTextType.COLOR_RED);
	}
	BtnBuyLast.SetTooltipCustomType(util.getCustomToolTip());
}

function HandleEditBox()
{
	local string EditBoxString;

	EditBoxString = ItemCount_EditBox.GetString();
	if ((Left(EditBoxString, 1) == "0") && (Len(EditBoxString) > 1))
	{
		ItemCount_EditBox.SetString(Right(EditBoxString, Len(EditBoxString) - 1));
	}
}

function HandleDialogOK(bool bOK)
{
	if (!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case DIALOG_ASK_PRICE:
			SetItemCountEditBox(int(DialogGetString()));
			// End:0x4F
			if(Buy_Wnd.IsShowWindow() == false)
			{
				DisableWnd.HideWindow();
			}
			break;
	}
}

function SetBuyConfirmWnd()
{
	local ItemInfo Info;
	local ItemWindowHandle Result_ItemWnd;
	local TextBoxHandle ItemName_TextBox;
	local TextBoxHandle BCNum_TextBox;
	local TextBoxHandle AdenaNum_TextBox;
	local TextBoxHandle CostNum_TextBox;
	local TextBoxHandle ItemName_TextBox1;
	local TextBoxHandle ItemName_TextBox2;
	local TextBoxHandle ItemName_TextBox3;
	local PLShopItemDataStruct itemData;
	local LCoinShopProductUIData productData;

	itemData = pLShopItemDataList[GetCurrentSelectedIndex()];
	API_GetLCoinShopProductData(itemData.nSlotNum, productData);
	Info = GetItemInfoCurrentSelected();
	Result_ItemWnd = GetItemWindowHandle(m_WindowName $ ".ShopDailyConfirm_ResultWnd.Result_ItemWnd");
	ItemName_TextBox = GetTextBoxHandle(m_WindowName $ ".ShopDailyConfirm_ResultWnd.ItemName_TextBox");
	GetTextBoxHandle(m_WindowName $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox").SetText(class'UIDATA_ITEM'.static.GetItemName(GetItemID(itemData.nCostItemId[0])));
	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem(Info);
	ItemName_TextBox.SetText((((GetProductNameByIndex(GetCurrentSelectedIndex())) $ "(") $ string(productData.BuyItems[itemData.sCircleNum].Count)) $ ")");
	textBoxShortStringWithTooltip(ItemName_TextBox, true);
	ItemName_TextBox1 = GetTextBoxHandle(m_WindowName $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox");
	ItemName_TextBox1.SetText(GetTextBoxHandle(m_WindowName $ ".buy_Wnd.CostItem01Title_TextBox").GetText());
	BCNum_TextBox = GetTextBoxHandle(m_WindowName $ ".ShopDailyConfirm_ResultWnd.BCNum_TextBox");
	BCNum_TextBox.SetText(GetTextBoxHandle(m_WindowName $ ".buy_Wnd.CostItem01NumTitle_TextBox").GetText());
	ItemName_TextBox2 = GetTextBoxHandle(m_WindowName $ ".ShopDailyConfirm_ResultWnd.AdenaTitle_TextBox");
	ItemName_TextBox2.SetText(NeededItem_Item2_Title.GetText());
	AdenaNum_TextBox = GetTextBoxHandle(m_WindowName $ ".ShopDailyConfirm_ResultWnd.AdenaNum_TextBox");
	AdenaNum_TextBox.SetText(NeededItem_Item2Num_text.GetText());
	ItemName_TextBox3 = GetTextBoxHandle(m_WindowName $ ".ShopDailyConfirm_ResultWnd.CostTitle_TextBox");
	ItemName_TextBox3.SetText(NeededItem_Item3_Title.GetText());
	CostNum_TextBox = GetTextBoxHandle(m_WindowName $ ".ShopDailyConfirm_ResultWnd.CostNum_TextBox");
	CostNum_TextBox.SetText(NeededItem_Item3Num_text.GetText());
	ItemNum_TextBox.SetText("x" $ ItemCount_EditBox.GetString());
	ItemCount_EditBox.HideWindow();
}

function HandleBuyResult(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	DisableWnd.SetFocus();
	DisableWndStep2.ShowWindow();
	DisableWndStep2.SetFocus();
	switch(Result)
	{
		case 0:
			SetSuccessWnd(param);
			break;
		case 7:
			SetFailWnd(3675);
			break;
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 11:
		default:
			SetFailWnd(4334);
			break;
	}
}

function SetSuccessWnd(string param)
{
	local ItemWindowHandle Result_ItemWnd;
	local TextBoxHandle ItemName_TextBox;
	local TextBoxHandle Discription_TextBox;
	local int ItemClassID;
	local ItemInfo Info;

	ParseInt(param,"ItemClassId_0",ItemClassID);
	Result_ItemWnd = GetItemWindowHandle(m_WindowName $ ".ShopDailySuccess_ResultWnd.Result_ItemWnd");
	ItemName_TextBox = GetTextBoxHandle(m_WindowName $ ".ShopDailySuccess_ResultWnd.ItemName_TextBox");
	Discription_TextBox = GetTextBoxHandle(m_WindowName $ ".ShopDailySuccess_ResultWnd.Discription_TextBox");
	Result_ItemWnd.Clear();
	Info = GetItemInfoByIndex(GetCurrentSelectedIndex());
	Result_ItemWnd.AddItem(Info);
	ItemName_TextBox.SetText(GetItemNameAll(Info) @"x" $ ItemCount_EditBox.GetString());
	Discription_TextBox.SetText(GetSystemMessage(4570));
	ShopDailySuccess_ResultWnd.ShowWindow();
	ShopDailySuccess_ResultWnd.SetFocus();
}

function SetFailWnd(int msgIndex)
{
	local TextBoxHandle Discription_TextBox;

	Discription_TextBox = GetTextBoxHandle(m_WindowName $ ".ShopDailyFails_ResultWnd.Discription_TextBox");
	Discription_TextBox.SetText(GetSystemMessage(msgIndex));
	DisableWndStep2.ShowWindow();
	DisableWndStep2.SetFocus();
	ShopDailyFails_ResultWnd.ShowWindow();
	ShopDailyFails_ResultWnd.SetFocus();
}

function bool IsMyShopIndex(string param)
{
	local int ShopIndex;

	ParseInt(param, "ShopIndex", ShopIndex);
	return ShopIndex == ShopIndex;
}

function string GetProductNameByIndex(int Index)
{
	local string fullNameString;
	local PLShopItemDataStruct itemData;
	local LCoinShopProductUIData productData;

	itemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(itemData.nSlotNum, productData);
	fullNameString = productData.BuyItems[itemData.sCircleNum].ProductName;
	if(itemData.isRelay)
	{
		return ((fullNameString @ "/") @ string(itemData.sCircleNum + 1)) $ GetSystemString(2980);
	}
	return fullNameString;
}

function int GetProductCategoryByIndex(int Index)
{
	local PLShopItemDataStruct itemData;
	local LCoinShopProductUIData productData;

	if (Index == -1)
	{
		Index = GetCurrentSelectedIndex();
	}
	itemData = pLShopItemDataList[Index];
	API_GetLCoinShopProductData(itemData.nSlotNum, productData);
	return productData.Category;
}

function int findMatchString(string targetString, string toFindString)
{
	local string delim;

	if (toFindString == "")
	{
		return 1;
	}
	delim = " ";
	if (StringMatching(targetString, toFindString, delim))
	{
		return 1;
	}
	else
	{
		return -1;
	}
	return 1;
}

function int GetCurrentSelectedIndex()
{
	return selectedByCategoryList[currentTabIndex];
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	if (!CheckBtnName(btnName, someString))
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

	for (i = 0;i < 3;i++)
	{
		if (itemData.nCostItemId[i] == 57)
		{
			return itemData.nCostItemAmount[i];
		}
	}
	return -1;
}

function INT64 GetLcoinNum(PLShopItemDataStruct itemData)
{
	local int i;

	for (i = 0;i < 3;i++)
	{
		if (itemData.nCostItemId[i] == 91663)
		{
			return itemData.nCostItemAmount[i];
		}
	}
	return -1;
}

function INT64 GetMultiCoinNum(PLShopItemDataStruct itemData)
{
	local int i;

	for (i = 0;i < 3;i++)
	{
		if (itemData.nCostItemId[i] == 4037)
		{
			return itemData.nCostItemAmount[i];
		}
	}
	return -1;
}

function INT64 GetAcoinNum(PLShopItemDataStruct itemData)
{
	local int i;

	for (i = 0;i < 3;i++)
	{
		if (itemData.nCostItemId[i] == 97145)
		{
			return itemData.nCostItemAmount[i];
		}
	}
	return -1;
}

function INT64 GetPCCafePointNum(PLShopItemDataStruct itemData)
{
	local int i;

	for (i = 0; i < 3; i++)
	{
		if (itemData.nCostItemId[i] == MSIT_PCCAFE_POINT)
		{
			return itemData.nCostItemAmount[i];
		}
	}
	return -1;
}

function INT64 GetVitalPointNum(PLShopItemDataStruct ItemData)
{
	local int i;

	// End:0x48 [Loop If]
	for (i = 0; i < 3; i++)
	{
		// End:0x3E
		if(ItemData.nCostItemId[i] == MSIT_VITAL_POINT)
		{
			return ItemData.nCostItemAmount[i];
		}
	}
	return -1;	
}

function string GetLimitTypeIcon(PLSHOP_LIMIT_TYPE Type)
{
	switch(Type)
	{
		case PLSHOP_LIMIT_NONE:
			return "L2UI_CT1.ShopDailyWnd.ShopDailyWnd_Icon_Infinity";
			break;
		case PLSHOP_LIMIT_CHARACTER:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Character";
			break;
		case PLSHOP_LIMIT_ACCOUNT:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Account";
			break;
	}
	return "";
}

function string GetLimitTypeIconString(PLSHOP_LIMIT_TYPE Type, PLSHOP_RESET_TYPE type2)
{
	switch(Type)
	{
		// End:0x1B
		case PLSHOP_LIMIT_NONE:
			return GetSystemString(539);
			// End:0x120
			break;
		// End:0x9C
		case PLSHOP_LIMIT_CHARACTER:
			// End:0x3F
			if(type2 == PLSHOP_RESET_ALWAYS)
			{
				return GetSystemString(13260);				
			}
			else if(type2 == PLSHOP_RESET_ONEDAY)
			{
				return GetSystemString(13259);					
			}
			else if(type2 == PLSHOP_RESET_ONEWEEK)
			{
				return GetSystemString(13869);						
			}
			else if(type2 == PLSHOP_RESET_ONEMONTH)
			{
				return GetSystemString(13871);
			}
			// End:0x120
			break;
		// End:0x11D
		case PLSHOP_LIMIT_ACCOUNT:
			// End:0xC0
			if(type2 == PLSHOP_RESET_ALWAYS)
			{
				return GetSystemString(13262);				
			}
			else if(type2 == PLSHOP_RESET_ONEDAY)
			{
				return GetSystemString(13261);					
			}
			else if(type2 == PLSHOP_RESET_ONEWEEK)
			{
				return GetSystemString(13868);						
			}
			else if(type2 == PLSHOP_RESET_ONEMONTH)
			{
				return GetSystemString(13870);
			}
			// End:0x120
			break;
	}
	return "";
}

function string GetBuyTypeStringBuyLimit(PLSHOP_LIMIT_TYPE Type, PLSHOP_RESET_TYPE type2)
{
	switch(Type)
	{
		// End:0x12
		case PLSHOP_LIMIT_NONE:
			return "";
			// End:0x92
			break;
		// End:0x17
		case PLSHOP_LIMIT_CHARACTER:
		// End:0x8F
		case PLSHOP_LIMIT_ACCOUNT:
			// End:0x32
			if(type2 == PLSHOP_RESET_ALWAYS)
			{
				return "";				
			}
			else if(type2 == PLSHOP_RESET_ONEDAY)
			{
				return GetSystemString(13872);					
			}
			else if(type2 == PLSHOP_RESET_ONEWEEK)
			{
				return GetSystemString(13873);						
			}
			else if(type2 == PLSHOP_RESET_ONEMONTH)
			{
				return GetSystemString(13874);
			}
			// End:0x92
			break;
	}
	return "";
}

function string GetBuyTypeStringBuyRefresh(PLSHOP_RESET_TYPE Type)
{
	switch(Type)
	{
		// End:0x25
		case PLSHOP_RESET_ALWAYS:
			return "(" $ GetSystemString(5142) $ ")";
			// End:0x87
			break;
		// End:0x48
		case PLSHOP_RESET_ONEDAY:
			return "(" $ "1" $ GetSystemString(1109) $ ")";
			// End:0x87
			break;
		// End:0x66
		case PLSHOP_RESET_ONEWEEK:
			return "(" $ GetSystemString(13866) $ ")";
			// End:0x87
			break;
		// End:0x84
		case PLSHOP_RESET_ONEMONTH:
			return "(" $ GetSystemString(13867) $ ")";
			// End:0x87
			break;
	}
	return "";
}

function string GetMarkIconByType(ELCoinShopMarkType MarkType)
{
	switch(MarkType)
	{
		case LCoinShopMark_None:
			return "";
		case LCoinShopMark_Event:
			return "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_EventIcon_02";
		case LCoinShopMark_Sale:
			return "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_SaleIcon_02";
		case LCoinShopMark_Best:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_BestIcon";
		case LCoinShopMark_Limited:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_LimitedIcon";
		case LCoinShopMark_New:
			return "L2UI_EPIC.LCoinShopICON_ribbonNEW";
		// End:0xFFFF
		default:
			return "L2UI_EPIC.LCoinShopWnd.RelayIcon";
	}
	return "";
}

function string GetMoneyIconByID(int cID)
{
	switch (cID)
	{
		case 57:
			return "L2UI_CT1.Icon.Icon_DF_Common_Adena";
		case 91663:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin";
		case 4037:
			return "L2UI_NewTex.BottomBar.BottomBar_EinhasadCoin";
		// End:0x82
		case MSIT_PCCAFE_POINT:
			return GetPcCafeItemIconPackageName(true);
		case MSIT_VITAL_POINT:
			return "L2UI_EPIC.LCoinShopWnd.Sayhas_Small";
		// End:0xBA
		case 97145:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Acoin";
	}
}

function int FindItemIndex(int Category, int SlotNum)
{
	local int i;
	local RichListCtrlRowData Record;

	for (i = 1; i < getListCtrlByCategory(Category).GetRecordCount();i++)
	{
		getListCtrlByCategory(Category).GetRec(i, Record);
		if (SlotNum == GetSlotNumByRecord(Record))
		{
			return i;
		}
	}
	return -1;
}

function RichListCtrlRowData GetSelectedRecord()
{
	local RichListCtrlRowData Record, nullRecord;
	local int SlotNum;

	// End:0x11
	if(currentTabIndex == 0)
	{
		return nullRecord;
	}
	getListCtrlByCategory(currentTabIndex).GetSelectedRec(Record);
	// End:0x8D
	if(Record == nullRecord)
	{
		SlotNum = pLShopItemDataList[GetCurrentSelectedIndex()].nSlotNum;
		// End:0x8D
		if(SlotNum > -1)
		{
			getListCtrlByCategory(currentTabIndex).GetRec(FindItemIndex(currentTabIndex, SlotNum), Record);
		}
	}
	return Record;
}

function RichListCtrlHandle getListCtrlByCategory(int nCategory)
{
	return GetRichListCtrlHandle(m_WindowName $ ".List_Wnd.List_ListCtrl" $ string(nCategory));
}

function WindowHandle GetHomeMainByIndex(int Index)
{
	return GetWindowHandle(m_WindowName $ ".Home_Wnd.Item_Big" $ string(Index));
}

function ItemWindowHandle GetHomeMainItemByIndex(int Index)
{
	return GetItemWindowHandle(m_WindowName $ ".Home_Wnd.Item_Big" $ string(Index) $ ".item");
}

function TextBoxHandle GetHomeMainText(int Index, int Num)
{
	return GetTextBoxHandle(m_WindowName $ ".Home_Wnd.Item_Big" $ string(Index) $ ".text" $ string(Num));
}

function TextureHandle GetHomeMainSaleType(int Index)
{
	return GetTextureHandle(m_WindowName $ ".Home_Wnd.Item_Big" $ string(Index) $ ".Sale");
}

function TextureHandle GetHomeMainIconType(int Index)
{
	return GetTextureHandle(m_WindowName $ ".Home_Wnd.Item_Big" $ string(Index) $ ".IconMoney01");
}

function ButtonHandle GetHomeMainBtnInfoByIndex(int Index)
{
	return GetButtonHandle(m_WindowName $ ".Home_Wnd.Item_Big" $ string(Index) $ ".BtnInfo");
}

function ButtonHandle GetHomeMainBtnBuyByIndex(int Index)
{
	return GetButtonHandle(m_WindowName $ ".Home_Wnd.Item_Big" $ string(Index) $ ".BtnBuy");
}

function TextureHandle GetHomeMainIconInfoByIndex(int Index)
{
	return GetTextureHandle(m_WindowName $ ".Home_Wnd.Item_Big" $ string(Index) $ ".IconInfo");
}

function TextureHandle GetHomeMainIconBuyByIndex(int Index)
{
	return GetTextureHandle(m_WindowName $ ".Home_Wnd.Item_Big" $ string(Index) $ ".IconBuy");
}

function WindowHandle GetHomeSubByIndex(int Index)
{
	return GetWindowHandle(m_WindowName $ ".Home_Wnd.Item_Small" $ string(Index));
}

function ItemWindowHandle GetHomeSubItemByIndex(int Index)
{
	return GetItemWindowHandle(m_WindowName $ ".Home_Wnd.Item_Small" $ string(Index) $ ".item");
}

function TextBoxHandle GetHomeSubText(int Index, int Num)
{
	return GetTextBoxHandle(m_WindowName $ ".Home_Wnd.Item_Small" $ string(Index) $ ".text" $ string(Num));
}

function TextureHandle GetHomeSubSaleType(int Index)
{
	return GetTextureHandle(m_WindowName $ ".Home_Wnd.Item_Small" $ string(Index) $ ".Sale");
}

function TextureHandle GetHomeSubIconType(int Index)
{
	return GetTextureHandle(m_WindowName $ ".Home_Wnd.Item_Small" $ string(Index) $ ".Icon3");
}

function ButtonHandle GetHomeSubBtnInfoByIndex(int Index)
{
	return GetButtonHandle(m_WindowName $ ".Home_Wnd.Item_Small" $ string(Index) $ ".BtnInfo");
}

function ButtonHandle GetHomeSubBtnBuyByIndex(int Index)
{
	return GetButtonHandle(m_WindowName $ ".Home_Wnd.Item_Small" $ string(Index) $ ".BtnBuy");
}

function TextureHandle GetHomeSubIconInfoByIndex(int Index)
{
	return GetTextureHandle(m_WindowName $ ".Home_Wnd.Item_Small" $ string(Index) $ ".IconInfo");
}

function TextureHandle GetHomeSubIconBuyByIndex(int Index)
{
	return GetTextureHandle(m_WindowName $ ".Home_Wnd.Item_Small" $ string(Index) $ ".IconBuy");
}

function HideRelayItem()
{
	local ButtonHandle successBtn;

	Buy_Wnd.SetWindowSize(418, 324);
	GetButtonHandle(m_WindowName $ ".ShopDailySuccess_ResultWnd.Fail_Button").HideWindow();
	successBtn = GetButtonHandle(m_WindowName $ ".ShopDailySuccess_ResultWnd.Success_Button");
	successBtn.SetAnchor(m_WindowName $ ".ShopDailySuccess_ResultWnd", "BottomCenter", "BottomCenter", 0, -10);
	successBtn.SetButtonName(140);
	BuyRelay_Wnd.HideWindow();
}

function ShowRelayItem(array<LCoinShopBuyItemInfo> BuyItems, int nCircle)
{
	local string Path;
	local ItemWindowHandle iWnd0, iWnd1, iWnd2;
	local ButtonHandle successBtn;

	GetButtonHandle(m_WindowName $ ".ShopDailySuccess_ResultWnd.Fail_Button").ShowWindow();
	successBtn = GetButtonHandle(m_WindowName $ ".ShopDailySuccess_ResultWnd.Success_Button");
	successBtn.SetAnchor(m_WindowName $ ".ShopDailySuccess_ResultWnd", "BottomCenter", "BottomRight", -3, -10);
	successBtn.SetButtonName(3135);
	Path = m_WindowName $ ".Buy_Wnd.BuyRelay_Wnd.";
	iWnd0 = GetItemWindowHandle(Path $ "RelayItem01_ItemWindow");
	iWnd1 = GetItemWindowHandle(Path $ "RelayItem02_ItemWindow");
	iWnd2 = GetItemWindowHandle(Path $ "RelayItem03_ItemWindow");
	iWnd0.Clear();
	iWnd1.Clear();
	iWnd2.Clear();
	// End:0x25C
	if(nCircle > 0)
	{
		iWnd0.AddItem(GetItemInfoLCoinShopBuyItemInfo(BuyItems[nCircle - 1]));
		GetWindowHandle(Path $ "BuyRelayArrow01_Tex").ShowWindow();
		iWnd0.ShowWindow();
		GetTextureHandle(Path $ "RelayItem01SlotBg_Texture").ShowWindow();		
	}
	else
	{
		GetWindowHandle(Path $ "BuyRelayArrow01_Tex").HideWindow();
		iWnd0.HideWindow();
		GetTextureHandle(Path $ "RelayItem01SlotBg_Texture").HideWindow();
	}
	// End:0x382
	if(nCircle > -1)
	{
		iWnd1.AddItem(GetItemInfoLCoinShopBuyItemInfo(BuyItems[nCircle]));
		// End:0x34D
		if((GetCountCanBuyByIndex(pLShopItemDataList[GetCurrentSelectedIndex()].Index)) > 0)
		{
			GetWindowHandle(Path $ "RelayItem02SlotFrame_Texture").ShowWindow();			
		}
		else
		{
			GetWindowHandle(Path $ "RelayItem02SlotFrame_Texture").HideWindow();
		}
	}
	// End:0x45C
	if(nCircle < (BuyItems.Length - 1))
	{
		iWnd2.AddItem(GetItemInfoLCoinShopBuyItemInfo(BuyItems[nCircle + 1]));
		GetWindowHandle(Path $ "RelayItem03SlotLock_Texture").HideWindow();
		GetWindowHandle(Path $ "BuyRelayArrow02_Tex").ShowWindow();
		iWnd2.ShowWindow();
		GetTextureHandle(Path $ "RelayItem03SlotBg_Texture").ShowWindow();		
	}
	else
	{
		GetWindowHandle(Path $ "RelayItem03SlotLock_Texture").HideWindow();
		GetWindowHandle(Path $ "BuyRelayArrow02_Tex").HideWindow();
		iWnd2.HideWindow();
		GetTextureHandle(Path $ "RelayItem03SlotBg_Texture").HideWindow();
	}
	GetTextBoxHandle(Path $ "BuyRelayItemNum01_Txt").SetText(string(nCircle + 1));
	GetTextBoxHandle(Path $ "BuyRelayItemNum02_Txt").SetText(string(BuyItems.Length));
	Buy_Wnd.SetWindowSize(418, 418);
	BuyRelay_Wnd.ShowWindow();
}

function ItemInfo GetItemInfoLCoinShopBuyItemInfo(LCoinShopBuyItemInfo buyItem)
{
	local ItemInfo iInfo;

	class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(buyItem.ItemClassID), iInfo);
	iInfo.ItemNum = buyItem.Count;
	iInfo.bShowCount = IsStackableItem(iInfo.ConsumeType);
	return iInfo;
}

function SetTabNameByServerType()
{
	local TabHandle lcoinTab;

	lcoinTab = GetTabHandle(m_WindowName $ ".LcoinShopList_Tab");
	// End:0x84
	if(IsAdenServer())
	{
		lcoinTab.SetButtonName(2, GetSystemString(14035));
		lcoinTab.SetButtonName(3, GetSystemString(49));
		lcoinTab.SetButtonName(4, GetSystemString(14036));
	}
	else
	{
		lcoinTab.SetButtonName(2, GetSystemString(13544));
		lcoinTab.SetButtonName(3, GetSystemString(3935));
		lcoinTab.SetButtonName(4, GetSystemString(49));
	}
}

function HandleFormByLanguage()
{
	local int i;
	local string anchorName;

	// End:0x13
	if (GetLanguage() == LANG_Korean)
	{
		return;
	}
	
	for (i = 0; i < 2; i++)
	{
		GetHomeMainBtnInfoByIndex(i).HideWindow();
		GetHomeMainIconInfoByIndex(i).HideWindow();
		anchorName = m_WindowName $ ".Home_Wnd." $ GetHomeMainBtnBuyByIndex(i).GetParentWindowName();
		GetHomeMainBtnBuyByIndex(i).SetAnchor(anchorName, "BottomCenter", "BottomCenter", 0, -10);
		GetHomeMainIconBuyByIndex(i).SetAnchor(anchorName, "BottomCenter", "BottomCenter", 0, -16);
	}

	for (i = 0; i < 4; i++)
	{
		GetHomeSubBtnInfoByIndex(i).HideWindow();
		GetHomeSubIconInfoByIndex(i).HideWindow();
		anchorName = m_WindowName $ ".Home_Wnd." $ GetHomeSubBtnBuyByIndex(i).GetParentWindowName();
		GetHomeSubBtnBuyByIndex(i).SetAnchor(anchorName, "BottomCenter", "BottomCenter", 0, -10);
		GetHomeSubIconBuyByIndex(i).SetAnchor(anchorName, "BottomCenter", "BottomCenter", 0, -16);
	}
}

function OnReceivedCloseUI()
{
	if (BannerLink.IsShowWindow())
	{
		BannerLink.HideWindow();
		DisableWnd.HideWindow();
	}
	else if (ShopDailyConfirm_ResultWnd.IsShowWindow())
	{
		ItemCount_EditBox.ShowWindow();
		DisableWndStep2.HideWindow();
		ShopDailyConfirm_ResultWnd.HideWindow();
	}

	else if(ShopDailySuccess_ResultWnd.IsShowWindow())
	{
		ShopDailySuccess_ResultWnd.HideWindow();
		DisableWndStep2.HideWindow();
		Buy_Wnd.HideWindow();
		DisableWnd.HideWindow();
	}
	else if(ShopDailyFails_ResultWnd.IsShowWindow())
	{
		ShopDailyFails_ResultWnd.HideWindow();
		Buy_Wnd.HideWindow();
		DisableWnd.HideWindow();
		DisableWndStep2.HideWindow();
	}
	else if (ItemInfo_Wnd.IsShowWindow())
	{
		ItemInfo_Wnd.HideWindow();
		DisableWnd.HideWindow();
	}
	else if (Buy_Wnd.IsShowWindow())
	{
		Buy_Wnd.HideWindow();
		DisableWnd.HideWindow();
	}
	else
	{
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

defaultproperties
{
     m_WindowName="ShopLcoinWnd"
}
