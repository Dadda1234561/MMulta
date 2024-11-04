//================================================================================
// ShopLcoinCraftWnd.
//================================================================================
class ShopLcoinCraftWnd extends UICommonAPI;

const SUCCESSION_ITEM_FILTER_ID = 3;
const MAX_CATEGORY = 7;
const ShopIndex = 4;
const TIMER_CLICK = 99902;
const TIMER_DELAYC = 3000;
const TIMER_FOCUS = 99903;
const TIMER_FOCUS_DELAY = 100;
const TWEEN_ID_ANI_GaugeCharge = 1;
const TWEEN_ID_ANI_Shake_END = 2;
const TWEEN_SHAKE_DELAY = 1020;
const TWEEN_ANI_REFRESH = 2000;
const TWEEN_ANI_CARD_ALPHA = 500;
const TWEEN_ID_CARD_ALPHA = 1000;
const TIMER_ID_HIT = 1;
const DIALOG_ASK_PRICE = 10111;
const COSTITEMNUM = 5;
const MAX_FILTERTYPE = 7;
const DWAFT_ID = 19673;
const DWAFT_dist = 400;
const DWAFT_offsetX = -8;
const DWAFT_offsetY = -3;
const DWAFT_ROTATION = 33000;
const MAX_CARD = 5;
const titleString = "$title$";
const REQUIRE_SKILL_MAX = 10;

enum StateCraft
{
	Normal,
	Buy,
	process,
	confirm,
	Result
};

struct PLShopItemDataStruct
{
	var int Index;
	var int nSlotNum;
	var int nItemClassID;
	var int nCostItemId[COSTITEMNUM];
	var INT64 nCostItemAmount[COSTITEMNUM];
	var int sCostItemEnchant[COSTITEMNUM];
	var int nRemainItemAmount;
	var int nRemainSec;
	var int nRemainServerItemAmount;
	var int filterType;
	var int ProductRank;
	var int Category;
	var int CategorySub;
};

struct SuccessionInfo
{
	var int successionItemSId;
	var int materialItemSId;
	var array<PurchaseLimitCraftBuyItemInfo> successionFee;
	var array<int> costItemCId;
	var array<INT64> CostItemAmount;
	var array<int> costItemEnchant;
	var bool isResultScene;
	var int itemOption1;
	var int itemOption2;
	var int ProductID;
	var bool isKeepOption;
	var int ProductItemEnchant;
};

struct FindItemInfo
{
	var bool isWaitingResponse;
	var string findName;
	var int Category;
};

struct CategorySubStruct
{
	var array<int> categorySubs;
	var array<int> categoryFolded;
};

var SuccessionInfo _successionInfo;
var UIControlGroupButtonAssets tabGroupButton;
var TextureHandle tabEventIcon;
var TextureHandle tabSuccessionIcon;
var WindowHandle successionWndContainer;
var WindowHandle successionWnd;
var WindowHandle itemRegisterContainer;
var UIControlNeedItemList successionNeedItemScript;
var ItemWindowHandle successionCostItemWnd;
var TextBoxHandle successionPossibleTextBox;
var TextBoxHandle successionFeeDescTextBox;
var ButtonHandle buyWndConfirmBtn;
var WindowHandle CraftItemWnd;
var CheckBoxHandle passAnimationCheck;
var WindowHandle Buy_Wnd;
var WindowHandle CraftResult01_CostItem_Wnd;
var WindowHandle CraftResult02_Gauge_Wnd;
var WindowHandle CraftResult03_Description_Wnd;
var WindowHandle DisableWnd;
var CharacterViewportWindowHandle m_ObjectViewport;
var EffectViewportWndHandle EffectViewport00;
var TextureHandle CraftGaugeWndGauge_tex;
var TextBoxHandle Description_Text;
var TextBoxHandle CanNotFindText;
var EditBoxHandle ItemCount_EditBox;
var ButtonHandle Reset_Btn;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var ButtonHandle Max_Btn;
var ButtonHandle Refresh_Button;
var ButtonHandle Craft_Btn;
var WindowHandle ShopDailyFails_ResultWnd;
var EditBoxHandle EditBoxFind;
var int currentTabIndex;
var StateCraft CurrentState;
var array<PLShopItemDataStruct> pLShopItemDataList;
var array<int> selectedByCategoryList;
var array<int> SelectedRadioBoxList;
var array<int> currentFilterTypes;
var int aniLoop;
var private Rect gaugeRect;
var private Rect craftItemWndRect;
var FindItemInfo _findItemInfo;
var int invenCount;
var int invenMax;
var UIControlNeedItemList needItemScript;
var UIControlNeedItemList confirmNeedItemScript;
var array<CategorySubStruct> categorySubDatas;
var ItemWindowHandle LiveNeedSkill_ItemWnd;
var TextBoxHandle LiveNeedSkillTitle_Txt;
var L2UITween l2UITweenScript;
var L2Util util;

function Initialize()
{
	local int i;
	local WindowHandle tabGroupButtonWindow;

	CraftItemWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd");
	Buy_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_Wnd");
	CraftResult01_CostItem_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd");
	CraftResult02_Gauge_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult02_Gauge_Wnd");
	CraftResult03_Description_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult03_Description_Wnd");
	Description_Text = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult03_Description_Wnd.Description_text");
	DisableWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd");
	Craft_Btn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.Craft_Btn");
	m_ObjectViewport = GetCharacterViewportWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.ObjectViewport");
	m_ObjectViewport.SetUISound(true);
	CraftGaugeWndGauge_tex = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult02_Gauge_Wnd.CraftGaugeWndGauge_tex");
	gaugeRect = CraftGaugeWndGauge_tex.GetRect();
	EditBoxFind = GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EditBoxFind");
	MultiSell_Up_Button = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.MultiSell_Up_Button");
	MultiSell_Down_Button = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.MultiSell_Down_Button");
	MultiSell_Input_Button = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.MultiSell_Input_Button");
	ItemCount_EditBox = GetEditBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.ItemCount_EditBox");
	Reset_Btn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.Reset_Btn");
	Max_Btn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.Max_Btn");
	Refresh_Button = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".BtnListRefresh");
	CanNotFindText = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CanNotFindText");
	util = L2Util(GetScript("L2Util"));
	l2UITweenScript = L2UITween(GetScript("L2UITween"));
	ShopDailyFails_ResultWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShopDailyFails_ResultWnd");
	EffectViewport00 = GetEffectViewportWndHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".EffectViewport00");
	tabGroupButtonWindow = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".LcoinShopList_Tab");
	tabGroupButton = class'UIControlGroupButtonAssets'.static._InitScript(tabGroupButtonWindow);
	tabEventIcon = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RibbonEvent_tex");
	tabSuccessionIcon = GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".RibbonBless_tex");
	successionPossibleTextBox = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.BlessCraftTilte_txt");
	successionFeeDescTextBox = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftResult01_CostItem_Wnd.CostItemDescrip_TextBox");
	buyWndConfirmBtn = GetButtonHandle(Buy_Wnd.m_WindowNameWithFullPath $ ".BuyWndCraft_Btn");
	tabGroupButton._SetStartInfo("L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Middle_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Middle_Select", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Middle_Unselected_Over", true);
	tabGroupButton._GetGroupButtonsInstance().DelegateOnClickButton = OnTabGroupBtnClicked;

	for (i = 0; i < MAX_CATEGORY; i++)
	{
		getListCtrlByCategory(i).SetSelectedSelTooltip(false);
		getListCtrlByCategory(i).SetAppearTooltipAtMouseX(true);
		getListCtrlByCategory(i).SetTooltipType("ShopLcoinCraftTooltip");
	}
	categorySubDatas.Length = MAX_CATEGORY;
	MakeAllItemCategorySubList();
	InitSuccessionControl();
	InitNeedItemControl();
	passAnimationCheck = GetCheckBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CheckBox");

	if(GetOptionBool("UI", "PurchaseLimitCraftAnimShow"))
	{
		passAnimationCheck.SetCheck(true);
	}
	LiveNeedSkill_ItemWnd = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.LiveNeedSkill_ItemWnd");
	LiveNeedSkillTitle_Txt = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.LiveNeedSkillTitle_Txt");
}

function InitSuccessionControl()
{
	local WindowHandle needItemWnd;
	local RichListCtrlHandle needItemRichList;

	successionWndContainer = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Bless_Wnd");
	successionWnd = GetWindowHandle(successionWndContainer.m_WindowNameWithFullPath $ ".BlessItemConfirmWnd");
	itemRegisterContainer = GetWindowHandle(successionWnd.m_WindowNameWithFullPath $ ".ItemRegistrationWnd");
	successionCostItemWnd = GetItemWindowHandle(itemRegisterContainer.m_WindowNameWithFullPath $ ".SucceedItemWnd");
	needItemWnd = GetWindowHandle(successionWnd.m_WindowNameWithFullPath $ ".NeedItem_RichlistWnd");
	needItemWnd.SetScript("UIControlNeedItemList");
	successionNeedItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemRichList = GetRichListCtrlHandle(successionWnd.m_WindowNameWithFullPath $ ".RichListCtrl");
	successionNeedItemScript.SetFormType(successionNeedItemScript.FORM_TYPE.nameSide);
	successionNeedItemScript.SetRichListControler(needItemRichList);
	successionNeedItemScript.SetColumnCount(2);
	needItemRichList.SetTooltipType("UIControlNeedItemList");
}

function InitNeedItemControl()
{
	local WindowHandle needItemWnd, confirmItemWnd;

	needItemWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.NeedItem_RichlistWnd");
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemScript.SetRichListControler(GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.NeedItem_RichlistWnd.RichListCtrl"));
	GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.NeedItem_RichlistWnd.RichListCtrl").SetTooltipType("UIControlNeedItemList");
	needItemScript.SetColumnCount(2);
	confirmItemWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_Wnd.BuyItemRichListCtrl");
	confirmItemWnd.SetScript("UIControlNeedItemList");
	confirmNeedItemScript = UIControlNeedItemList(confirmItemWnd.GetScript());
	confirmNeedItemScript.SetRichListControler(GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_Wnd.BuyItemRichListCtrl.RichListCtrl"));
}

function API_RequestPurchaseLimitShopItemBuy(int nSlotNum, int nItemAmount, optional int successionItemSId, optional int materialItemSId)
{
	local array<byte> stream;
	local UIPacket._C_EX_PURCHASE_LIMIT_SHOP_ITEM_BUY packet;

	packet.cShopIndex = 4;
	packet.nSlotNum = nSlotNum;
	packet.nItemAmount = nItemAmount;
	packet.nSuccessionItemSID = successionItemSId;
	packet.nMaterialItemSID = materialItemSId;

	if(! class'UIPacket'.static.Encode_C_EX_PURCHASE_LIMIT_SHOP_ITEM_BUY(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PURCHASE_LIMIT_SHOP_ITEM_BUY, stream);
}

function API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST packet;

	packet.cShopIndex = 4;

	if(! class'UIPacket'.static.Encode_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST(stream, packet))
	{
		return;
	}
	Class 'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST, stream);
}

function bool API_GetPurchaseLimitCraftData(int nProductID, out PurchaseLimitCraftUIData Data)
{
	return GetPurchaseLimitCraftData(4, nProductID, Data);
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW);
	RegisterEvent(EV_PurchaseLimitShopItemBuy);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_SetMaxCount);
	RegisterEvent(EV_Restart);
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
	currentTabIndex = 0;
	SetCheckButtonByCategory(0);
	SetCheckBox(0);
	initSelectedItemIDArray();
	SetForm();
	InitDefaultShakeRect();	
}

function InitDefaultShakeRect()
{
	local Rect parentWndRect;

	parentWndRect = m_hOwnerWnd.GetRect();
	craftItemWndRect = CraftItemWnd.GetRect();
	craftItemWndRect.nX = craftItemWndRect.nX - parentWndRect.nX;
	craftItemWndRect.nY = craftItemWndRect.nY - parentWndRect.nY;
}

function SetForm()
{
	local int CategoryIndex, buttonIndex;
	local array<int> stringIds;
	local int disableButtonIndex;

	disableButtonIndex = -1;

	if(getInstanceUIData().getIsClassicServer())
	{
		disableButtonIndex = 1;
	}

	if(IsAdenServer())
	{
		stringIds[stringIds.Length] = 14291;
		stringIds[stringIds.Length] = 116;		
	}
	else
	{
		stringIds[stringIds.Length] = 2520;
		stringIds[stringIds.Length] = 2532;
	}

	if(getInstanceUIData().getIsClassicServer())
	{
		setWindowTitleByString(GetSystemString(13302));
		stringIds[stringIds.Length] = 2558;
		stringIds[stringIds.Length] = 13687;
		stringIds[stringIds.Length] = 704;		
	}
	else
	{
		setWindowTitleByString(GetSystemString(645));
		stringIds[stringIds.Length] = 2537;
		stringIds[stringIds.Length] = 13705;
		stringIds[stringIds.Length] = 704;
		LiveNeedSkill_ItemWnd.SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	}

	if(IsEnableSuccessionCategory())
	{
		stringIds[stringIds.Length] = 13384;
	}
	stringIds[stringIds.Length] = 3004;

	for(CategoryIndex = 0; CategoryIndex < stringIds.Length; CategoryIndex++)
	{
		if(disableButtonIndex != CategoryIndex)
		{
			tabGroupButton._GetGroupButtonsInstance()._setButtonText(buttonIndex, GetSystemString(stringIds[CategoryIndex]));
			tabGroupButton._GetGroupButtonsInstance()._setButtonValue(buttonIndex, CategoryIndex);
			buttonIndex++;
		}
	}
	tabGroupButton._GetGroupButtonsInstance()._setShowButtonNum(buttonIndex);
	tabGroupButton._GetGroupButtonsInstance()._setAutoWidth(987, 0);
	tabGroupButton._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Left_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Left_Select", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_Left_Unselected_Over");
	tabGroupButton._GetGroupButtonsInstance()._setButtonTexture(buttonIndex - 1, "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_RightBasic_Unselected", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_RightBasic_Select", "L2UI_EPIC.LCoinShopWnd.LCoinShopWndTabBTN_RightBasic_Unselected_Over");

	if(IsEnableSuccessionCategory())
	{
		tabGroupButton._GetGroupButtonsInstance()._setTextureLoc(buttonIndex - 2, tabSuccessionIcon, 0, 3);
		tabSuccessionIcon.ShowWindow();
	}
	else
	{
		tabSuccessionIcon.HideWindow();
	}
	tabGroupButton._GetGroupButtonsInstance()._setTextureLoc(buttonIndex - 1, tabEventIcon, 0, 3);
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(currentTabIndex);
}

function SetButtonNameString()
{
	local int tabNameStringNum;
	local bool tabNameString;
	local int tabindex;

	tabNameString = GetINIInt("Localize", "ShopLcoinCraftEtcTabName", tabNameStringNum, "L2.ini");

	if(IsEnableSuccessionCategory())
	{
		tabindex = 7 - 2;
	}
	else
	{
		tabindex = 7 - 1;
	}

	if(tabNameString)
	{
		tabGroupButton._GetGroupButtonsInstance()._setButtonText(tabindex, GetSystemString(tabNameStringNum));
	}
	else
	{
		tabGroupButton._GetGroupButtonsInstance()._setButtonText(tabindex, GetSystemString(13383));
	}
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW:
			ClearAll();
			HandleS_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW();
			break;
		case EV_PurchaseLimitShopItemBuy:
			if(! IsMyShopIndex(param))
			{
				return;
			}
			HandleBuyResult(param);
			break;
		case EV_UpdateUserInfo:
			if(m_hOwnerWnd.IsShowWindow())
			{
				HandleUserInfo();
				SetCurrentCostItems(true);
			}
			break;
		case EV_GameStart:
			initSelectedItemIDArray();
			SetDwaft();
			break;
		case EV_DialogOK:
			HandleDialogOK(true);
			break;
		case EV_DialogCancel:
			HandleDialogOK(false);
			break;
		case EV_AdenaInvenCount:
			ParseInt(param, "InvenCount", invenCount);
			HandleInvenCount();
			HandleInvenWeight();
			break;
		case EV_SetMaxCount:
			ParseInt(param, "Inventory", invenMax);
			HandleInvenCount();
			break;
		case EV_Restart:
			ClearItemCategorySubList();
			MakeAllItemCategorySubList();
			break;
	}
}

event OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "CheckBox":
			SetOptionBool("UI", "PurchaseLimitCraftAnimShow", passAnimationCheck.IsChecked());
			break;
	}
}

event OnKeyUp(WindowHandle a_WindowHandle, EInputKey nKey)
{
	if (EditBoxFind.IsFocused() && EditBoxFind.IsEnableWindow())
	{
		if (nKey == IK_Enter)
		{
			ClearAll();
			HandleItemNewList(-1);
		}
	}
}

function HandleOnClickBuyWndCraft_Btn()
{
	if(passAnimationCheck.IsChecked())
	{
		AnimationCardToBack();
		SetState(confirm);
	}
	else
	{
		SetState(process);
	}
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "Craft_Btn":
			HandleCraftBtn();
			break;
		case "BtnClose":
		case "BuyWndCancel_Btn":
			SetState(Normal);
			break;
		case "BuyWndCraft_Btn":
			HandleOnClickBuyWndCraft_Btn();
			break;
		case "BtnClearEditBox":
			EditBoxFind.Clear();
		case "BtnFind":
			ClearAll();
			HandleItemNewList(-1);
			break;
		case "MultiSell_Input_Button":
			OnPriceEditBtnHandler();
			break;
		case "MultiSell_Up_Button":
			OnMultiSell_Up_ButtonClick();
			break;
		case "MultiSell_Down_Button":
			OnMultiSell_Down_ButtonClick();
			break;
		case "Reset_Btn":
			SetItemCountEditBox(1);
			break;
		case "FrameHelp_BTN":
			OnClickHelp();
			break;
		case "BtnListRefresh":
			OnRefresh_ButtonClick();
			break;
		case "Max_Btn":
			SetItemCountEditBox(GetCountCanBuyByIndex(GetCurrentSelectedIndex(), true));
			break;
		case "Fail_Button":
			SetState(Normal);
			break;
		case "Registration_Btn":
			OnSuccessionRegistBtnClicked();
			break;
		case "OK_Btn":
			OnSuccecssionConfirmBtnClicked();
			break;
		case "Cancel_Btn":
			OnSuccecssionCancelBtnClicked();
			break;
	}
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local string WindowName, strID;

	switch(a_ButtonHandle.GetWindowName())
	{
		case "Select_Checkbox":
			WindowName = a_ButtonHandle.GetParentWindowHandle().GetWindowName();

			if(GetStringIDFromBtnName(WindowName, "categorySelect_Wnd", strID))
			{
				HandleOnClickFilterButton(int(strID));
			}
			break;
	}
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local ItemInfo Info;
	local RichListCtrlRowData Record;
	local PLShopItemDataStruct ItemData;
	local PurchaseLimitCraftUIData productData;
	local bool bFolded;
	local int selectedIdx, i;

	Record = GetSelectedRecord();
	ItemData = pLShopItemDataList[int(Record.nReserved1)];
	selectedIdx = getListCtrlByCategory(currentTabIndex).GetSelectedIndex();

	if(Record.szReserved == titleString)
	{
		return;
		API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
		bFolded = ! GetbFolded(productData.Category, productData.CategorySub);
		SetbFolded(productData.Category, productData.CategorySub, bFolded);
		getListCtrlByCategory(currentTabIndex).ModifyRecord(selectedIdx, MakeTitleRecord(int(Record.nReserved1), productData.CategorySub, bFolded));

		if(bFolded)
		{
			HideCategorySubs(selectedIdx);
		}
		else
		{
			ShowCategorySubs(selectedIdx);
		}
		return;
	}
	Info = GetItemInfoByClassID(ItemData.nItemClassID);
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
	_successionInfo.isKeepOption = productData.KeepOption;
	_successionInfo.successionFee = productData.KeepOptionFee;
	_successionInfo.ProductItemEnchant = productData.ProductItemEnchant;
	_successionInfo.ProductID = ItemData.nSlotNum;
	_successionInfo.costItemCId.Length = 0;
	_successionInfo.costItemEnchant.Length = 0;
	_successionInfo.CostItemAmount.Length = 0;

	for(i = 0; i < 5; i++)
	{
		if(ItemData.nCostItemId[i] > 0)
		{
			_successionInfo.costItemCId[_successionInfo.costItemCId.Length] = ItemData.nCostItemId[i];
		}
		if(ItemData.sCostItemEnchant[i] > 0)
		{
			_successionInfo.costItemEnchant[_successionInfo.costItemEnchant.Length] = ItemData.sCostItemEnchant[i];
		}
		if(ItemData.nCostItemAmount[i] > 0)
		{
			_successionInfo.CostItemAmount[_successionInfo.CostItemAmount.Length] = ItemData.nCostItemAmount[i];
		}
	}

	if(productData.KeepOption == true)
	{
		successionPossibleTextBox.ShowWindow();

		if(productData.KeepOptionFee.Length > 0)
		{
			successionFeeDescTextBox.ShowWindow();			
		}
		else
		{
			successionFeeDescTextBox.HideWindow();
		}		
	}
	else
	{
		successionPossibleTextBox.HideWindow();
		successionFeeDescTextBox.HideWindow();
	}

	if(Info.Id.ClassID > 0)
	{
		selectedByCategoryList[currentTabIndex] = ItemData.Index;
		CanNotFindText.HideWindow();
		CraftItemWnd.ShowWindow();
		SetBuyItems();
		SetCurrentLimitType();
		SetCurrentLimitTimeType();
		SetCurrentLimitServerRemain();
		SetCurrentCostItems();
		SetCurrentNeedSkills();
		SetItemCountEditBox(1);
	}
}

event OnChangeEditBox(string strID)
{
	switch(strID)
	{
		case "ItemCount_EditBox":
			HandleEditBox();
			SetItemCountEditBox(int(ItemCount_EditBox.GetString()));
			break;
	}
}

event OnShow()
{
	if(GetWindowHandle("PrivateShopWndReport").IsShowWindow())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4217));
		m_hOwnerWnd.HideWindow();
		return;
	}

	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		m_hOwnerWnd.HideWindow();
		return;
	}
	ResetSuccessionInfo();
	HideSuccessionDialog();
	HandleNotSelected();
	getInstanceL2Util().ItemRelationWindowHide(m_hOwnerWnd.m_WindowNameWithFullPath);
	m_hOwnerWnd.SetFocus();
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	SetState(Normal);
	SetDwaft();
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_hOwnerWnd.m_WindowNameWithFullPath, true);
}

event OnHide()
{
	if(DialogIsMine())
	{
		DialogHide();
	}
	AnimationStop();
	ResetFindItemInfo();
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_hOwnerWnd.m_WindowNameWithFullPath, false);
	successionNeedItemScript.CleariObjects();
	needItemScript.CleariObjects();
	confirmNeedItemScript.CleariObjects();
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case l2UITweenScript.TWEENEND:
			AnimationComplete(int(param));
			break;
		case l2UITweenScript.SHAKEEND:
			ShakeComplete(int(param));
			break;
		default:
	}
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case TIMER_CLICK:
			Refresh_Button.EnableWindow();
			m_hOwnerWnd.KillTimer(TIMER_CLICK);
			break;
		case TIMER_FOCUS:
			getListCtrlByCategory(currentTabIndex).SetFocus();
			HandleSelectOnChangeListCondition();
			m_hOwnerWnd.KillTimer(TIMER_FOCUS);
			break;
		case 1:
			AnimationNext();
			break;
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
			DisableWnd.HideWindow();

			if(bOK)
			{
				SetItemCountEditBox(int(DialogGetString()));
			}
			break;
	}
}

function HandleCraftBtn()
{
	switch(CurrentState)
	{
		case Normal:
			SetState(buy);
			break;
		case Buy:
			break;
		case process:
			SetState(Normal);
			break;
		case confirm:
			Craft_Btn.DisableWindow();
			MakeResultShakeObject();
			break;
		case Result:
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetState(Normal);
			break;
	}
}

function OnRefresh_ButtonClick()
{
	API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
	m_hOwnerWnd.SetTimer(TIMER_CLICK, TIMER_DELAYC);
	Refresh_Button.DisableWindow();
}

function OnPriceEditBtnHandler()
{
	DisableWnd.ShowWindow();
	DisableWnd.SetFocus();
	DialogSetID(DIALOG_ASK_PRICE);
	DialogSetEditBoxMaxLength(6);
	DialogSetCancelD(DIALOG_ASK_PRICE);
	DialogSetParamInt64(GetCountCanBuyByIndex(GetCurrentSelectedIndex(), true));
	DialogSetEditType("number");
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362), string(self));
}

function OnMultiSell_Up_ButtonClick()
{
	SetItemCountEditBox(int(ItemCount_EditBox.GetString()) + 1);
}

function OnMultiSell_Down_ButtonClick()
{
	SetItemCountEditBox(int(ItemCount_EditBox.GetString()) - 1);
}

function OnClickHelp()
{
	//class'HelpWnd'.static.ShowHelp(67);
}

function ClearAll()
{
	local int i;

	for (i = 0; i < MAX_CATEGORY; i++)
	{
		getListCtrlByCategory(i).DeleteAllItem();
	}
}

function HandleS_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW()
{
	local UIPacket._S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW packet;
	local int i, j;
	local PLShopItemDataStruct pLShopItemData;
	local PurchaseLimitCraftUIData productData;

	if(! class'UIPacket'.static.Decode_S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW(packet))
	{
		return;
	}

	if(packet.cShopIndex != 4)
	{
		return;
	}

	if(packet.cPage == 1)
	{
		pLShopItemDataList.Length = 0;
	}
	Debug("리스트 정보 갱신 --- _S_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST_NEW");

	for (i = 0; i < packet.vItemList.Length; i++)
	{
		API_GetPurchaseLimitCraftData(packet.vItemList[i].nSlotNum, productData);
		pLShopItemData.nSlotNum = packet.vItemList[i].nSlotNum;
		pLShopItemData.nItemClassID = packet.vItemList[i].nItemClassID;
		pLShopItemData.Category = productData.Category;
		pLShopItemData.CategorySub = productData.CategorySub;

		for (j = 0; j < MAX_CARD; j++)
		{
			pLShopItemData.nCostItemId[j] = packet.vItemList[i].nCostItemId[j];
			pLShopItemData.nCostItemAmount[j] = packet.vItemList[i].nCostItemAmount[j];
			pLShopItemData.sCostItemEnchant[j] = packet.vItemList[i].sCostItemEnchant[j];
		}
		pLShopItemData = ArrangingPeeItem(pLShopItemData);
		pLShopItemData.nRemainItemAmount = packet.vItemList[i].nRemainItemAmount;
		pLShopItemData.nRemainSec = packet.vItemList[i].nRemainSec;
		pLShopItemData.nRemainServerItemAmount = packet.vItemList[i].nRemainServerItemAmount;
		pLShopItemDataList[pLShopItemDataList.Length] = pLShopItemData;
	}
	if(packet.cPage < packet.cMaxPage)
	{
		return;
	}
	pLShopItemDataList.Sort(OnSortCompareCategorySub);
	pLShopItemDataList.Sort(OnSortCompareCategory);

	for(i = 0; i < pLShopItemDataList.Length; i++)
	{
		pLShopItemDataList[i].Index = i;
	}

	MakeItemCategorySubList();
	HandleItemNewList(-1);
	SetCheckButtonByCategory(currentTabIndex);
	CheckFindItem();
}

function HandleItemNewList(int Category, optional int startIndex)
{
	local int i;
	local RichListCtrlRowData Record;
	local PurchaseLimitCraftUIData productData;
	local bool canBuy;
	local array<bool> useCategories;
	local int lastCategorySub, lastCategory;
	local bool bFolded;

	useCategories.Length = MAX_CATEGORY;
	lastCategory = -1;

	for (i = startIndex; i < pLShopItemDataList.Length; i++)
	{
		API_GetPurchaseLimitCraftData(pLShopItemDataList[i].nSlotNum, productData);
		if(Category != -1 && Category != productData.Category)
		{
			continue;
		}

		if(lastCategory != productData.Category)
		{
			lastCategory = productData.Category;
			lastCategorySub = -1;
		}
		useCategories[productData.Category] = true;
		canBuy = GetCountCanBuyByIndex(pLShopItemDataList[i].Index) > 0;

		if(SelectedCategorySub(productData.Category) != 0 && SelectedCategorySub(productData.Category) != productData.CategorySub)
		{
			continue;
		}
		if(lastCategorySub != productData.CategorySub)
		{
			lastCategorySub = productData.CategorySub;
			getListCtrlByCategory(productData.Category).InsertRecord(MakeTitleRecord(i, productData.CategorySub, bFolded));
		}
		if(findMatchString(productData.ProductName, EditBoxFind.GetString()) == -1)
		{
			continue;
		}
		Record = makeRecord(i, canBuy);
		getListCtrlByCategory(productData.Category).InsertRecord(Record);
	}
	SetEmptyCategories(useCategories);
	HandleSelectOnChangeListCondition();
}

function SetEmptyCategories(array<bool> useCategories)
{
	local int i;

	for (i = 0; i < useCategories.Length; i++)
	{
		if(useCategories[i])
		{
		}
	}
}

function HandleSelectOnChangeListCondition()
{
	local int currentSelectedIndex, listIndex, currentSlotNum;

	if(HandleFindResult())
	{
		return;
	}
	CanNotFindText.HideWindow();
	CraftItemWnd.ShowWindow();
	currentSelectedIndex = GetCurrentSelectedIndex();

	if(currentSelectedIndex != -1)
	{
		currentSlotNum = pLShopItemDataList[currentSelectedIndex].nSlotNum;

		if(currentSlotNum != -1)
		{
			listIndex = GetCurrentListIndexBySlotNum(currentSlotNum);
		}

		if(listIndex != -1)
		{
			getListCtrlByCategory(currentTabIndex).SetSelectedIndex(listIndex, true);
			OnClickListCtrlRecord("");
			return;
		}
	}
	HandleNotSelected();
}

function string MakeTooltipString(PLShopItemDataStruct itemData, PurchaseLimitCraftUIData productData)
{
	local int i;
	local string param;
	local int Count, buyItemEnchant;

	param = "";
	buyItemEnchant = 0;

	if(productData.KeepOption == true && productData.ProductItemEnchant > 0)
	{
		buyItemEnchant = productData.ProductItemEnchant;
	}

	for (i = 0; i < MAX_CARD; i++)
	{
		if(itemData.nCostItemId[i] > 0)
		{
			ParamAdd(param, "costItemAmout" $ string(i), string(itemData.nCostItemAmount[i]));
			ParamAdd(param, "costItemID" $ string(i), string(itemData.nCostItemId[i]));
			ParamAdd(param, "costItemEnchant" $ string(i), string(itemData.sCostItemEnchant[i]));
			Count++;
		}
	}

	ParamAdd(param, "countCost", string(Count));
	ParamAdd(param, "itemCount", string(productData.BuyItems.Length));

	for(i = 0; i < productData.BuyItems.Length; i++)
	{
		ParamAdd(param, "buyItem" $ string(i), string(productData.BuyItems[i].ItemClassID));
		ParamAdd(param, "buyItemCount" $ string(i), string(productData.BuyItems[i].Count));
		ParamAdd(param, "buyItemEnchant" $ string(i), string(buyItemEnchant));
	}
	return param;
}

function RichListCtrlRowData MakeTitleRecord(int startIndex, int CategorySub, bool bFolded)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 1;

	if(bFolded)
	{
		addRichListCtrlString(Record.cellDataList[0].drawitems, GetNpcString(CategorySub), getInstanceL2Util().Gray, false, 10, 0, "hs11");		
	}
	else
	{
		addRichListCtrlString(Record.cellDataList[0].drawitems, GetNpcString(CategorySub), getInstanceL2Util().Yellow, false, 10, 0, "hs11");
	}
	Record.szReserved = titleString;
	Record.nReserved1 = startIndex;
	Record.sOverlayTex = "L2UI_EPIC.LCoinShopWnd.CraftListInHeader";
	Record.OverlayTexU = 258;
	Record.OverlayTexV = 50;
	return Record;
}

function RichListCtrlRowData makeRecord(int Index, bool canBuy)
{
	local RichListCtrlRowData Record;
	local string fullNameString;
	local ItemInfo Info;
	local UserInfo PlayerInfo;
	local PLShopItemDataStruct itemData;
	local PurchaseLimitCraftUIData productData;
	local Color tmpTextColor;
	local int textWidth, textHeight;

	itemData = pLShopItemDataList[Index];
	API_GetPurchaseLimitCraftData(itemData.nSlotNum, productData);
	GetPlayerInfo(PlayerInfo);
	Info = GetItemInfoByClassID(itemData.nItemClassID);
	fullNameString = GetItemNameAll(Info);
	Record.szReserved = MakeTooltipString(itemData, productData);
	Record.cellDataList.Length = 1;
	Record.nReserved1 = int64(Index);
	Record.cellDataList[0].nReserved1 = itemData.nItemClassID;
	Record.cellDataList[0].nReserved3 = itemData.nSlotNum;
	Record.cellDataList[0].szData = fullNameString;

	if(productData.MarkType == 0)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconName, 32, 32, 10, 0);
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconName, 32, 32, 10, 26);
	}

	if(Info.IconPanel != "")
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconPanel, 32, 32, -32, 0);
	}

	if(! canBuy)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.ItemWindow.ItemWindow_IconDisable", 32, 32, -32, 0);
	}

	if(canBuy)
	{
		tmpTextColor = GetColor(170, 153, 119, 255);
	}
	else
	{
		tmpTextColor = util.DarkGray;
	}
	class'L2Util'.static.GetEllipsisString(productData.ProductName, 190);
	GetTextSizeDefault(productData.ProductName, textWidth, textHeight);

	if(productData.MarkType == 0)
	{
		addRichListCtrlString(Record.cellDataList[0].drawitems, productData.ProductName, tmpTextColor, false, 5, 10);		
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, GetMarkIconByType(productData.MarkType), 64, 64, -42, -6);
		addRichListCtrlString(Record.cellDataList[0].drawitems, productData.ProductName, tmpTextColor, false, -17, 16);
	}
	if(productData.MarkType == LCoinShopMark_Limited && itemData.nRemainServerItemAmount <= 0)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_EPIC.LCoinShopWnd.LCoinShopCraft_SoldoutIcon", 100, 50, - textWidth + 30, - textHeight, 128, 64);
	}
	return Record;
}

function HandleInvenCount()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		SetCurrentCostItems(true);
		SetCurrentNeedSkills();
		OnChangeEditBox("ItemCount_EditBox");
	}
}

function HandleInvenWeight()
{
	if(! GetCanInventoryWeight())
	{
		if(CurrentState == Normal)
		{
			SetBuyButtonTooltip();
			Craft_Btn.DisableWindow();
		}
	}
}

function HandleUserInfo()
{
	if(getInstanceUIData().isLevelUP())
	{
		m_hOwnerWnd.HideWindow();
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
	return Record.cellDataList[0].nReserved3;
}

function int GetCountCanBuy(RichListCtrlRowData Record)
{
	return GetCountCanBuyByIndex(int(Record.nReserved1));
}

function bool GetCanInventoryWeight()
{
	local UserInfo uInfo;
	local float Per;

	if(GetPlayerInfo(uInfo))
	{
		Per = uInfo.nCarringWeight / uInfo.nCarryWeight;
		return Per <= 0.50f;
	}
	return false;
}

function int GetCanBUyByInvenEmpty(int Index)
{
	local PurchaseLimitCraftUIData productData;

	API_GetPurchaseLimitCraftData(pLShopItemDataList[Index].nSlotNum, productData);

	if(GetIsStackableItemByIndex(Index))
	{
		if(GetInventoryEmpty() >= productData.BuyItems.Length)
		{
			return 9999;
		}
	}
	return GetInventoryEmpty();
}

function int GetInventoryEmpty()
{
	return invenMax - invenCount;
}

function bool GetIsStackableItemByIndex(int Index)
{
	local int i;
	local ItemInfo Info;
	local PurchaseLimitCraftUIData productData;

	API_GetPurchaseLimitCraftData(pLShopItemDataList[Index].nSlotNum, productData);

	for (i = 0; i < productData.BuyItems.Length; i++)
	{
		Info = GetItemInfoByClassID(productData.BuyItems[i].ItemClassID);

		if(! IsStackableItem(Info.ConsumeType))
		{
			return false;
		}
	}
	return true;
}

function int GetCountCanBuyByIndex(int Index, optional bool chkInventory)
{
	local int Count;
	local PurchaseLimitCraftUIData productData;

	API_GetPurchaseLimitCraftData(pLShopItemDataList[Index].nSlotNum, productData);

	if(! CheckLevelCondition(Index))
	{
		return 0;
	}

	if(! CheckNeedSkill(Index))
	{
		return 0;
	}
	Count = 9999;

	if(chkInventory)
	{
		Count = Min(Count, GetCanBUyByInvenEmpty(Index));
	}
	Count = Min(GetItemLimitAmount(Index), Count);
	Count = Min(GetMinAmoutByCostItemNum(Index), Count);
	return Count;
}

function bool CheckLevelCondition(int Index)
{
	local UserInfo Info;
	local PLShopItemDataStruct itemData;
	local PurchaseLimitCraftUIData productData;

	itemData = pLShopItemDataList[Index];
	API_GetPurchaseLimitCraftData(itemData.nSlotNum, productData);

	if(! GetPlayerInfo(Info))
	{
		return false;
	}
	if(Info.nLevel > productData.LevelMax || Info.nLevel < productData.LevelMin)
	{
		return false;
	}
	return true;
}

function int GetServerItemAmount(int Index)
{
	local PLShopItemDataStruct itemData;
	local PurchaseLimitCraftUIData productData;

	itemData = pLShopItemDataList[Index];
	API_GetPurchaseLimitCraftData(itemData.nSlotNum, productData);

	if(productData.ServerCountMax == 0 && productData.MarkType != LCoinShopMark_Limited)
	{
		return 9999;
	}
	return pLShopItemDataList[Index].nRemainServerItemAmount;
}

function int GetItemLimitAmount(int Index)
{
	local PurchaseLimitCraftUIData productData;

	API_GetPurchaseLimitCraftData(pLShopItemDataList[Index].nSlotNum, productData);

	if(productData.LimitType == 0)
	{
		return 9999;
	}
	else
	{
		return pLShopItemDataList[Index].nRemainItemAmount;
	}
}

function int GetMinAmoutByCostItemNum(int Index)
{
	local int Count, i, j;
	local PLShopItemDataStruct itemData;
	local PurchaseLimitCraftUIData productData;
	local INT64 haveItem;
	local array<string> RecapData;
	
	
	itemData = pLShopItemDataList[Index];
	API_GetPurchaseLimitCraftData(pLShopItemDataList[Index].nSlotNum, productData);
	Count = 9999;

	for(i = 0; i < COSTITEMNUM; i++)
	{
		if(itemData.nCostItemId[i] != 0)
		{
			if(itemData.nCostItemId[i] == MSIT_CRAFT_POINT)
			{
				haveItem = getInstanceUIData().getCurrentVitalityPoint();
			}
			else
			{
				haveItem = GetHaveItem(i, itemData);
			}
			Count = Min(Count, int(haveItem / (GetCostItemAmount(i, itemData))));

			/////**************
			RecapData.Remove(0,RecapData.Length);
			RecapData = Arr(SettingSectorStr("SpecialCraft", "RECAP_" $ itemData.nCostItemId[i]), ";");
			if(RecapData.Length > 0)
			{
				for(j=0; j<RecapData.Length; j++)
				{
					Count += InventoryWnd(GetScript("InventoryWnd")).getItemCountByClassID(int(RecapData[j]));
				}
			}

			///**************
		}
	}
	return Count;
}

function int GetCurrMinLv()
{
	local PLShopItemDataStruct itemData;
	local PurchaseLimitCraftUIData productData;

	itemData = pLShopItemDataList[GetCurrentSelectedIndex()];
	API_GetPurchaseLimitCraftData(itemData.nSlotNum, productData);
	return productData.LevelMin;
}

function int GetCurrMaxLv()
{
	local PLShopItemDataStruct itemData;
	local PurchaseLimitCraftUIData productData;

	itemData = pLShopItemDataList[GetCurrentSelectedIndex()];
	API_GetPurchaseLimitCraftData(itemData.nSlotNum, productData);
	return productData.LevelMax;
}

function int GetCurrentMaxItemNum()
{
	return 9999;
}

function HandleOnClickFilterButton(int Index)
{
	if(SelectedRadioBoxList[currentTabIndex] == Index)
	{
		return;
	}
	SelectedRadioBoxList[currentTabIndex] = Index;
	SetCheckBox(SelectedRadioBoxList[currentTabIndex]);
	getListCtrlByCategory(currentTabIndex).DeleteAllItem();
	HandleItemNewList(currentTabIndex);
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	currentTabIndex = tabGroupButton._GetGroupButtonsInstance()._getButtonValue(Index);
	SetProductListVisible(currentTabIndex);
	SetCheckButtonByCategory(currentTabIndex);
	m_hOwnerWnd.KillTimer(TIMER_FOCUS);
	m_hOwnerWnd.SetTimer(TIMER_FOCUS, TIMER_FOCUS_DELAY);	
}

function SetProductListVisible(int Index)
{
	local int i;
	local RichListCtrlHandle ListCtrl;

	for(i = 0; i < MAX_CATEGORY; i++)
	{
		ListCtrl = getListCtrlByCategory(i);

		if(i == Index)
		{
			ListCtrl.ShowWindow();
			continue;
		}
		ListCtrl.HideWindow();
	}	
}

function SetBuyItems()
{
	local int i;
	local ItemInfo Info;
	local PurchaseLimitCraftUIData productData;

	Info = GetItemInfoCurrentSelected();
	productData = GetSelectedProductData();

	for(i = 0; i < productData.BuyItems.Length; i++)
	{
		Info = GetItemInfoByClassID(productData.BuyItems[i].ItemClassID);
		Info.RefineryOp1 = 0;
		Info.RefineryOp2 = 0;

		if(_successionInfo.isKeepOption == true)
		{
			if(_successionInfo.ProductItemEnchant > 0)
			{
				Info.Enchanted = _successionInfo.ProductItemEnchant;
			}
		}
		GetTexturehandleCraftCardBack(i).HideWindow();
		GetTexturehandleCraftSlot(i).ShowWindow();
		GetTexturehandleCraftSlot(i).Clear();
		GetTexturehandleCraftSlot(i).AddItem(Info);
		GetTexturehandleCraftCardBG(i).SetTexture(GetGradeTextureByRank(productData.BuyItems[i].ProductRank));
		GetTextBoxhandleCraftItemNum(i).SetText(GetSystemString(2503) @ string(productData.BuyItems[i].Count));
		GetCraftProbabilityTextBox(i).SetText(class'L2Util'.static.Inst().CutFloatDecimalPlaces(productData.BuyItems[i].Prob));
		GetTexturehandleCraftCardNum(i).HideWindow();
		GetCard(i).ShowWindow();

		if(productData.BuyItems[i].IsLimitServer)
		{
			GetTextureHandleLimitIcon(i).ShowWindow();
			continue;
		}
		GetTextureHandleLimitIcon(i).HideWindow();
	}
	AlignCards(productData.BuyItems.Length);

	for (i = i; i < MAX_CARD; i++)
	{
		GetTexturehandleCraftCardBack(i).ShowWindow();
		GetTexturehandleCraftSlot(i).HideWindow();
		GetTexturehandleCraftCardBack(i).SetAlpha(255);
		GetTexturehandleCraftCardNum(i).HideWindow();
		GetCard(i).HideWindow();
	}
}

function UpdateSuccessionResultBuyItems()
{
	local int i;
	local ItemInfo Info;
	local PurchaseLimitCraftUIData productData;

	Info = GetItemInfoCurrentSelected();
	productData = GetSelectedProductData();

	for(i = 0; i < productData.BuyItems.Length; i++)
	{
		Info = GetItemInfoByClassID(productData.BuyItems[i].ItemClassID);
		Info.RefineryOp1 = 0;
		Info.RefineryOp2 = 0;

		if(_successionInfo.isKeepOption == true)
		{
			if(_successionInfo.ProductItemEnchant > 0)
			{
				Info.Enchanted = _successionInfo.ProductItemEnchant;
			}
			Info.RefineryOp1 = _successionInfo.itemOption1;
			Info.RefineryOp2 = _successionInfo.itemOption2;
		}
		GetTexturehandleCraftSlot(i).Clear();
		GetTexturehandleCraftSlot(i).AddItem(Info);
	}	
}

function AlignCards(int Num)
{
	local int i, StartX, gab, gabW;

	gab = 138;
	gabW = ((5 - Num) * 138) / 2;
	StartX = 30 + gabW;

	for(i = 0; i < Num; i++)
	{
		GetCard(i).MoveC(StartX + (gab * i), 215);
	}
}

function HandleBuyResult(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	switch(Result)
	{
		case 0:
			SetSuccessWnd(param);
			break;
		case 7:
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetFailWnd(3646);
			break;
		case 6:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 11:
		default:
			API_C_EX_PURCHASE_LIMIT_SHOP_ITEM_LIST();
			SetFailWnd(4334);
			break;
	}
}

function SetSuccessWnd(string param)
{
	local int i, ItemCount, itemIndex, ItemAmount, itemRankMax;

	local PurchaseLimitCraftUIData productData;

	ParseInt(param, "ItemCount", ItemCount);
	productData = GetSelectedProductData();

	for(i = 0; i < ItemCount; i++)
	{
		ParseInt(param, "itemIndex_" $ string(i), itemIndex);
		itemRankMax = Max(itemRankMax, productData.BuyItems[itemIndex].ProductRank);
		ParseInt(param, "ItemAmount_" $ string(i), ItemAmount);
		GetTexturehandleCraftCardNum(itemIndex).ShowWindow();
		GetTexturehandleCraftCardNum(itemIndex).SetText("x" $ string(ItemAmount));
		AnimationCardToFront(itemIndex);
	}
	switch(itemRankMax)
	{
		case 0:
			EffectViewport00.SetCameraDistance(500.0f);
			playEffectViewPort("LineageEffect2.ui_upgrade_succ");
			PlaySound("ItemSound3.enchant_success");
			break;
		case 1:
			EffectViewport00.SetCameraDistance(360.0f);
			playEffectViewPort("LineageEffect2.ui_upgrade_succ");
			PlaySound("ItemSound3.enchant_success");
			break;
		case 2:
			EffectViewport00.SetCameraDistance(600.0f);
			playEffectViewPort("LineageEffect.d_firework_b");
			PlaySound("ItemSound2.C3_Firework_explosion");
			break;
		case 3:
			EffectViewport00.SetCameraDistance(730.0f);
			playEffectViewPort("LineageEffect_br.br_e_firebox_fire_b");
			PlaySound("SkillSound14.d_firework_a");
			break;
	}
	SetState(Result);
}

function SetFailWnd(int msgIndex)
{
	local TextBoxHandle Discription_TextBox;

	Discription_TextBox = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShopDailyFails_ResultWnd.Discription_TextBox");
	Discription_TextBox.SetText(GetSystemMessage(msgIndex));
	ShopDailyFails_ResultWnd.ShowWindow();
	ShopDailyFails_ResultWnd.SetFocus();
}

function SetCurrentLimitType()
{
	local PurchaseLimitCraftUIData productData;
	local PLShopItemDataStruct itemData;

	productData = GetSelectedProductData();
	itemData = GetSelectedItemData();
	GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictTypeIcon_tex").SetTexture(GetLimitTypeIcon(productData.LimitType));

	if(productData.LimitType == PLSHOP_LIMIT_NONE)
	{
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictTypeIcon_tex").HideWindow();
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.btn_conditionHelp").HideWindow();
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictType_Text").SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd", "TopLeft", "TopLeft", 42, 56);
	}
	else
	{
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictTypeIcon_tex").ShowWindow();

		if(GetBuyTypeStringBuyLimit(productData.LimitType, productData.ResetType) == "")
		{
			GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.btn_conditionHelp").HideWindow();
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictType_Text").SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd", "TopLeft", "TopLeft", 42, 56);			
		}
		else
		{
			GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.btn_conditionHelp").ShowWindow();
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictType_Text").SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd", "TopLeft", "TopLeft", 59, 56);
			GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.btn_conditionHelp").SetTooltipCustomType(MakeTooltipSimpleText(GetBuyTypeStringBuyLimit(productData.LimitType, productData.ResetType)));
		}
	}
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictType_Text").SetText(GetLimitTypeIconString(productData.LimitType, productData.ResetType));

	if(productData.LimitCountMax != 0)
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictTypeNum_Text").SetText(string(itemData.nRemainItemAmount) $ "/" $ string(productData.LimitCountMax));
	}
	else
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RestrictTypeNum_Text").SetText("");
	}
}

function SetCurrentLimitTimeType()
{
	local PLShopItemDataStruct itemData;

	itemData = GetSelectedItemData();

	if(itemData.nRemainSec > 0)
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftTime_Text").SetText(util.getTimeStringBySec3(itemData.nRemainSec));
	}
	else
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftTime_Text").SetText(GetSystemString(3979));
	}
}

function SetCurrentLimitServerRemain()
{
	local int serverItemAmount;

	serverItemAmount = GetServerItemAmount(GetCurrentSelectedIndex());

	if(GetSelectedProductData().MarkType == LCoinShopMark_Limited)
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.LimitedProduction_Text").ShowWindow();

		if(serverItemAmount == 0)
		{
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.LimitedProductionNum_Text").SetTextColor(GetColor(255, 102, 102, 255));
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.LimitedProductionNum_Text").SetText(GetSystemString(13795));
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.Description_text").SetTextColor(GetColor(255, 102, 102, 255));
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.Description_text").SetText(GetSystemString(13796));			
		}
		else
		{
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.LimitedProductionNum_Text").SetTextColor(GetColor(255, 255, 255, 255));
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.LimitedProductionNum_Text").SetText(string(serverItemAmount));
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.Description_text").SetTextColor(GetColor(170, 153, 119, 255));
			GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.Description_text").SetText(GetSystemString(13175));
		}
	}
	else
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.LimitedProduction_Text").HideWindow();
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.LimitedProductionNum_Text").SetText("");
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.Description_text").SetTextColor(GetColor(170, 153, 119, 255));
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.Description_text").SetText(GetSystemString(13175));
	}
}

function array<ItemInfo> FilterNeedItems(int ClassID, int Enchanted, bool isKeepOption)
{
	local array<ItemInfo> needItems, needItemFiltered;
	local int i, Len;

	if(isKeepOption)
	{
		Len = class'UIDATA_INVENTORY'.static.GetItemByScriptFilter(3, needItems);		
	}
	else
	{
		Len = class'UIDATA_INVENTORY'.static.GetItemByScriptFilter(1, needItems);
	}

	for(i = 0; i < Len; i++)
	{
		if(needItems[i].Id.ClassID == ClassID)
		{
			if(needItems[i].Enchanted == Enchanted)
			{
				needItemFiltered[needItemFiltered.Length] = needItems[i];
			}
		}
	}
	return needItemFiltered;
}

function INT64 GetHaveItem(int i, PLShopItemDataStruct itemData, optional bool isKeepOption)
{
	local array<ItemInfo> haveItemInfos;
	local int j, haveItem;
	local ItemInfo Info;
	local int inputedNum;

	Info = GetItemInfoByClassID(itemData.nCostItemId[i]);

	if(! IsStackableItem(Info.ConsumeType))
	{
		haveItemInfos = FilterNeedItems(itemData.nCostItemId[i], itemData.sCostItemEnchant[i], isKeepOption);
		haveItem = haveItemInfos.Length;

		for (j = 0; j < i; j++)
		{
			if(itemData.nCostItemId[i] == itemData.nCostItemId[j] && itemData.sCostItemEnchant[i] == itemData.sCostItemEnchant[j])
			{
				inputedNum = int(ItemCount_EditBox.GetString());

				if(inputedNum == 0)
				{
					inputedNum = 1;
				}
				haveItem = Max(0, haveItem - (inputedNum * int(itemData.nCostItemAmount[j])));
			}
		}
	}
	else
	{
		return GetInventoryItemCount(Info.Id);
	}
	return haveItem;
}

function INT64 GetCostItemAmount(int i, PLShopItemDataStruct itemData)
{
	local int j;
	local INT64 nCostItemAmount;

	nCostItemAmount = itemData.nCostItemAmount[i];

	for(j = i + 1; j < 5; j++)
	{
		if(itemData.nCostItemId[i] == itemData.nCostItemId[j] && itemData.sCostItemEnchant[i] == itemData.sCostItemEnchant[j])
		{
			nCostItemAmount += itemData.nCostItemAmount[j];
		}
	}
	return nCostItemAmount;
}

function PLShopItemDataStruct ArrangingPeeItem(PLShopItemDataStruct itemData)
{
	local int i, j;
	local array<int> tmpCostItemID, tmpCostItemEnchant;
	local array<INT64> tmpCostItemAmount;

	for (i = 0; i < COSTITEMNUM; i++)
	{
		tmpCostItemID[i] = itemData.nCostItemId[i];
		tmpCostItemAmount[i] = itemData.nCostItemAmount[i];
		tmpCostItemEnchant[i] = itemData.sCostItemEnchant[i];
	}

	for (i = 0; i < COSTITEMNUM; i++)
	{
		if(tmpCostItemID[i] == 0)
		{
			continue;
		}

		for (j = i + 1; j < COSTITEMNUM; j++)
		{
			if(tmpCostItemID[i] == tmpCostItemID[j] && tmpCostItemEnchant[i] == tmpCostItemEnchant[j])
			{
				tmpCostItemAmount[i] += tmpCostItemAmount[j];
				tmpCostItemID.Remove(j, 1);
				tmpCostItemEnchant.Remove(j, 1);
				tmpCostItemAmount.Remove(j, 1);
				tmpCostItemID[tmpCostItemID.Length] = 0;
				tmpCostItemEnchant[tmpCostItemEnchant.Length] = 0;
				tmpCostItemAmount[tmpCostItemAmount.Length] = 0;
			}
		}
	}

	for(i = 0; i < COSTITEMNUM; i++)
	{
		itemData.nCostItemId[i] = tmpCostItemID[i];
		itemData.sCostItemEnchant[i] = tmpCostItemEnchant[i];
		itemData.nCostItemAmount[i] = tmpCostItemAmount[i];
	}
	return itemData;
}

function SetCurrentCostItems(optional bool modifyList)
{
	local PLShopItemDataStruct ItemData;
	local PurchaseLimitCraftUIData productData;
	local int i,j, editBoxCount;
	local INT64 haveItem;
	local ItemInfo Info, nullItem;
	local int buyNum;
	local array<string> RecapData;
	
	
	ItemData = GetSelectedItemData();
	API_GetPurchaseLimitCraftData(ItemData.nSlotNum, productData);
	editBoxCount = int(ItemCount_EditBox.GetString());

	if(modifyList == false)
	{
		needItemScript.StartNeedItemList(2);
	}
	confirmNeedItemScript.StartNeedItemList(5);

	for(i = 0; i < COSTITEMNUM; i++)
	{
		if(ItemData.nCostItemId[i] > 0 || ItemData.nCostItemId[i] == MSIT_CRAFT_POINT)
		{
			if(ItemData.nCostItemId[i] == MSIT_CRAFT_POINT)
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
				Info = GetItemInfoByClassID(itemData.nCostItemId[i]);
			}

			if(ItemData.sCostItemEnchant[i] > 0)
			{
				Info.Enchanted = ItemData.sCostItemEnchant[i];
			}

			if(ItemData.nCostItemId[i] == MSIT_CRAFT_POINT)
			{
				haveItem = getInstanceUIData().getCurrentVitalityPoint();
			}
			else
			{
				haveItem = GetHaveItem(i, ItemData);

				/////**************
				RecapData.Remove(0,RecapData.Length);
				RecapData = Arr(SettingSectorStr("SpecialCraft", "RECAP_" $ itemData.nCostItemId[i]), ";");
				if(RecapData.Length > 0)
				{
					for(j=0; j<RecapData.Length; j++)
					{
						haveItem += InventoryWnd(GetScript("InventoryWnd")).getItemCountByClassID(int(RecapData[j]));
					}
				}
			///**************
			}

			if(modifyList == true)
			{
				needItemScript.ModifyNeeItemInfo(Info, ItemData.nCostItemAmount[i], haveItem);
			}
			else
			{
				needItemScript.AddNeeItemInfo(Info, ItemData.nCostItemAmount[i], haveItem);
			}
			confirmNeedItemScript.AddNeeItemInfo(Info, ItemData.nCostItemAmount[i], haveItem);
		}
	}
	buyNum = Max(editBoxCount, 1);
	needItemScript.SetBuyNum(buyNum);
	confirmNeedItemScript.SetBuyNum(buyNum);

	if(_successionInfo.isKeepOption == true && _successionInfo.successionItemSId > 0 && _successionInfo.materialItemSId > 0)
	{
		if(_successionInfo.successionFee.Length > 0 && _successionInfo.itemOption1 > 0 || _successionInfo.itemOption2 > 0)
		{
			for(i = 0; i < _successionInfo.successionFee.Length; i++)
			{
				confirmNeedItemScript.AddNeedItemClassID(_successionInfo.successionFee[i].ItemClassID, _successionInfo.successionFee[i].Count);
			}
			buyWndConfirmBtn.SetEnable(confirmNeedItemScript.GetCanBuy());
		}
		else
		{
			buyWndConfirmBtn.SetEnable(true);
		}
	}
	else
	{
		buyWndConfirmBtn.SetEnable(true);
	}
}

function ClearRequirmentBuySkills()
{
	local int i;
	local ItemInfo clearInfo;

	LiveNeedSkill_ItemWnd.Clear();
	clearInfo.IconName = "L2ui_ct1.emptyBtn";

	for(i = 0; i < 10; i++)
	{
		LiveNeedSkill_ItemWnd.AddItem(clearInfo);
	}
}

function SetCurrentNeedSkills()
{
	local PurchaseLimitCraftUIData craftUIData;
	local int i, Index;
	local ItemInfo iInfo;

	ClearRequirmentBuySkills();
	craftUIData = GetSelectedProductData();

	if(craftUIData.RequirementBuySkills.Length > 0)
	{
		for(i = 0; i < craftUIData.RequirementBuySkills.Length; i++)
		{
			iInfo = GetSkillItemInfo(craftUIData.RequirementBuySkills[i]);
			Index = int(float((i / 5) * 5) + (float(4) - (float(i) % float(5))));
			LiveNeedSkill_ItemWnd.SetItem(Index, iInfo);
		}
		LiveNeedSkillTitle_Txt.ShowWindow();
	}
	else
	{
		LiveNeedSkillTitle_Txt.HideWindow();
	}
}

function ItemInfo GetSkillItemInfo(int SkillID)
{
	local SkillInfo sInfo;
	local ItemInfo iInfo;

	GetSkillInfo(SkillID, 1, 0, sInfo);
	class'L2Util'.static.Inst().GetSkill2ItemInfo(sInfo, iInfo);
	iInfo.bDisabled = 1 - class'UIDATA_SKILL'.static.SkillIsNewOrUp(iInfo.Id);
	return iInfo;
}

function bool CheckNeedSkill(int Index)
{
	local PurchaseLimitCraftUIData craftUIData;
	local PLShopItemDataStruct itemData;
	local ItemInfo iInfo;
	local int i;

	itemData = pLShopItemDataList[Index];
	API_GetPurchaseLimitCraftData(itemData.nSlotNum, craftUIData);

	for(i = 0; i < craftUIData.RequirementBuySkills.Length; i++)
	{
		iInfo = GetSkillItemInfo(craftUIData.RequirementBuySkills[i]);

		if(iInfo.bDisabled == 1)
		{
			return false;
		}
	}
	return true;
}

function HandleEditBox()
{
	local string EditBoxString;

	EditBoxString = ItemCount_EditBox.GetString();

	if(Left(EditBoxString, 1) == "0" && Len(EditBoxString) > 1)
	{
		ItemCount_EditBox.SetString(Right(EditBoxString, Len(EditBoxString) - 1));
	}
}

function SetItemCountEditBox(int Num)
{
	local int buyNum;

	if(GetCurrentSelectedIndex() == -1)
	{
		Num = 0;
	}
	else
	{
		if(Num < 1)
		{
			Num = 0;
		}
	}
	Num = Min(GetCountCanBuyByIndex(GetCurrentSelectedIndex(), true), Num);

	if(Num != int(ItemCount_EditBox.GetString()))
	{
		ItemCount_EditBox.SetString(string(Num));
	}
	buyNum = Max(Num, 1);
	needItemScript.SetBuyNum(int64(buyNum));
	confirmNeedItemScript.SetBuyNum(int64(buyNum));
	SetControlerBtns();
}

function SetControlerBtns()
{
	local int Count, canBuyCount;

	canBuyCount = GetCountCanBuyByIndex(GetCurrentSelectedIndex(), true);
	Count = int(ItemCount_EditBox.GetString());
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.NeedItem_RichlistWnd.RichListCtrl.DisableWndNeedItem").HideWindow();

	if(canBuyCount > 0 && GetSelectedProductData().MarkType != LCoinShopMark_Limited || GetServerItemAmount(GetCurrentSelectedIndex()) > 0)
	{
		if(canBuyCount == 1)
		{
			MultiSell_Input_Button.DisableWindow();
			ItemCount_EditBox.DisableWindow();
		}
		else
		{
			MultiSell_Input_Button.EnableWindow();
			ItemCount_EditBox.EnableWindow();
		}

		if(canBuyCount == Count)
		{
			MultiSell_Up_Button.DisableWindow();
			Max_Btn.DisableWindow();
		}
		else
		{
			MultiSell_Up_Button.EnableWindow();
			Max_Btn.EnableWindow();
		}

		if(Count <= 1)
		{
			Reset_Btn.DisableWindow();
			MultiSell_Down_Button.DisableWindow();
		}
		else
		{
			Reset_Btn.EnableWindow();
			MultiSell_Down_Button.EnableWindow();
		}

		if(Count > 0 && GetCanInventoryWeight())
		{
			Craft_Btn.EnableWindow();
		}
		else
		{
			Craft_Btn.DisableWindow();
		}
	}
	else
	{
		if(GetSelectedProductData().MarkType == LCoinShopMark_Limited && GetServerItemAmount(GetCurrentSelectedIndex()) == 0)
		{
			GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.CraftResult01_CostItem_Wnd.NeedItem_RichlistWnd.RichListCtrl.DisableWndNeedItem").ShowWindow();
		}
		MultiSell_Up_Button.DisableWindow();
		MultiSell_Down_Button.DisableWindow();
		MultiSell_Input_Button.DisableWindow();
		ItemCount_EditBox.DisableWindow();
		Reset_Btn.DisableWindow();
		Max_Btn.DisableWindow();

		if(CurrentState != Result)
		{
			Craft_Btn.DisableWindow();
		}
	}
	SetBuyButtonTooltip();
}

function SetBuyButtonTooltip()
{
	local CustomTooltip t;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(10);

	if(GetCurrentSelectedIndex() == -1)
	{
		Craft_Btn.SetTooltipCustomType(util.getCustomToolTip());
		return;
	}

	if(! GetCanInventoryWeight())
	{
		util.ToopTipInsertText(GetSystemString(13713), true, true, util.ETooltipTextType.COLOR_RED);
	}

	if((GetCanBUyByInvenEmpty(GetCurrentSelectedIndex())) == 0)
	{
		util.ToopTipInsertText(GetSystemString(7177), true, true, util.ETooltipTextType.COLOR_RED);
	}

	if(! CheckNeedSkill(GetCurrentSelectedIndex()))
	{
		util.ToopTipInsertText(GetSystemString(13896), true, true, util.ETooltipTextType.COLOR_RED);
	}

	if(! CheckLevelCondition(GetCurrentSelectedIndex()))
	{
		util.ToopTipInsertText(ShopLcoinWnd(GetScript("ShopLcoinWnd")).GetLevelString(GetCurrMinLv(), GetCurrMaxLv()), true, true, util.ETooltipTextType.COLOR_RED);
	}

	if(GetItemLimitAmount(GetCurrentSelectedIndex()) == 0)
	{
		util.ToopTipInsertText(GetSystemString(3725) $ " ", true, true, util.ETooltipTextType.COLOR_GRAY);
		util.ToopTipInsertText("0", true, false, util.ETooltipTextType.COLOR_RED);
	}

	if(GetMinAmoutByCostItemNum(GetCurrentSelectedIndex()) == 0)
	{
		util.ToopTipInsertText(GetSystemMessage(701), true, true, util.ETooltipTextType.COLOR_RED);
	}

	if(GetSelectedProductData().MarkType == 4 && GetServerItemAmount(GetCurrentSelectedIndex()) == 0)
	{
		util.ToopTipInsertText(GetSystemString(13796), true, true, util.ETooltipTextType.COLOR_RED);
		DisalbeCardAll();
	}
	else
	{
		EnableCardAll();
	}
	Craft_Btn.SetTooltipCustomType(util.getCustomToolTip());
}

function RichListCtrlHandle getListCtrlByCategory(int nCategory)
{
	return GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".LcoinCraftList_Wnd.List_ListCtrl" $ string(nCategory));
}

function ButtonHandle GetFilterButton(int nFilterType)
{
	return GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".categorySelect_Wnd" $ string(nFilterType) $ ".Select_Checkbox");
}

function WindowHandle GetCard(int Num)
{
	return GetWindowHandle(GetCardWndPath(Num));
}

function TextureHandle GetTexturehandleCraftCardBG(int Num)
{
	return GetTextureHandle(GetCardWndPath(Num) $ ".CraftCardBG_tex");
}

function TextureHandle GetTexturehandleCraftCardBack(int Num)
{
	return GetTextureHandle(GetCardWndPath(Num) $ ".CraftCardBack_tex");
}

function ItemWindowHandle GetTexturehandleCraftSlot(int Num)
{
	return GetItemWindowHandle(GetCardWndPath(Num) $ ".CraftSlot_ItemWnd");
}

function TextBoxHandle GetTextBoxhandleCraftItemNum(int Num)
{
	return GetTextBoxHandle(GetCardWndPath(Num) $ ".CraftNum_textbox");
}

function TextBoxHandle GetTexturehandleCraftCardNum(int Num)
{
	return GetTextBoxHandle(GetCardWndPath(Num) $ ".ResultNum_textbox");
}

function TextureHandle GetTextureHandleLimitIcon(int Num)
{
	return GetTextureHandle(GetCardWndPath(Num) $ ".LimitedRibbon_Tex");
}

function TextureHandle GetTextureHandleDiable(int Num)
{
	return GetTextureHandle(GetCardWndPath(Num) $ ".RandomSlotDisable_tex");
}

function string GetCardWndPath(int Num)
{
	return m_hOwnerWnd.m_WindowNameWithFullPath $ ".CraftItemWnd.RandomSlotGroup_Wnd" $ string(Num);
}

function TextBoxHandle GetCraftProbabilityTextBox(int Num)
{
	return GetTextBoxHandle(GetCardWndPath(Num) $ ".CraftProbability_textbox");
}

function bool IsMyShopIndex(string param)
{
	local int ShopIndex;

	ParseInt(param, "ShopIndex", ShopIndex);
	return ShopIndex == ShopIndex;
}

function int findMatchString(string targetString, string toFindString)
{
	local string delim;

	if(toFindString == "")
	{
		return 1;
	}
	delim = " ";

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

function bool HandleFindResult()
{
	if((getListCtrlByCategory(currentTabIndex).GetRecordCount() < currentFilterTypes.Length) && EditBoxFind.GetString() != "")
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CanNotFindText").ShowWindow();
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CanNotFindText").SetText(MakeFullSystemMsg(GetSystemMessage(4356), EditBoxFind.GetString()));
		CraftItemWnd.HideWindow();
		Craft_Btn.DisableWindow();
		return true;
	}
	else
	{
		GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".CanNotFindText").HideWindow();
		CraftItemWnd.ShowWindow();
		return false;
	}
	return false;
}

function HandleNotSelected()
{
	local string findStr;

	findStr = EditBoxFind.GetString();

	if(findStr == "" || findStr != "" && GetCurrentListSelectedIndex() == -1)
	{
		CanNotFindText.ShowWindow();
		CanNotFindText.SetText(GetSystemMessage(13186));
		CraftItemWnd.HideWindow();
	}
	Craft_Btn.DisableWindow();
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
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

function PurchaseLimitCraftUIData GetSelectedProductData()
{
	local PLShopItemDataStruct itemData;
	local PurchaseLimitCraftUIData productData;
	local int SelectedIndex;

	SelectedIndex = GetCurrentSelectedIndex();

	if(pLShopItemDataList.Length < SelectedIndex)
	{
		return productData;
	}
	itemData = pLShopItemDataList[SelectedIndex];
	API_GetPurchaseLimitCraftData(itemData.nSlotNum, productData);
	return productData;
}

function int GetProductCategoryByIndex(int Index)
{
	local PLShopItemDataStruct itemData;
	local PurchaseLimitCraftUIData productData;

	if(Index == -1)
	{
		Index = GetCurrentSelectedIndex();
	}
	itemData = pLShopItemDataList[Index];
	API_GetPurchaseLimitCraftData(itemData.nSlotNum, productData);
	return productData.Category;
}

function int GetCurrentSelectedIndex()
{
	return selectedByCategoryList[currentTabIndex];
}

function PLShopItemDataStruct GetSelectedItemData()
{
	return pLShopItemDataList[GetCurrentSelectedIndex()];
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
		case PLSHOP_LIMIT_NONE:
			return GetSystemString(539);
			break;
		case PLSHOP_LIMIT_CHARACTER:
			if(type2 == PLSHOP_RESET_ALWAYS)
			{
				return GetSystemString(13299);
			}
			else if(type2 == PLSHOP_RESET_ONEDAY)
			{
				return GetSystemString(13298);
			}
			else if(type2 == PLSHOP_RESET_ONEWEEK)
			{
				return GetSystemString(13879);
			}
			else if(type2 == PLSHOP_RESET_ONEMONTH)
			{
				return GetSystemString(13881);
			}
			break;
		case PLSHOP_LIMIT_ACCOUNT:
			if(type2 == PLSHOP_RESET_ALWAYS)
			{
				return GetSystemString(13301);
			}
			else if(type2 == PLSHOP_RESET_ONEDAY)
			{
				return GetSystemString(13300);
			}
			else if(type2 == PLSHOP_RESET_ONEWEEK)
			{
				return GetSystemString(13878);
			}
			else if(type2 == PLSHOP_RESET_ONEMONTH)
			{
				return GetSystemString(13880);
			}
			break;
	}
	return "";
}

function string GetBuyTypeStringBuyLimit(PLSHOP_LIMIT_TYPE Type, PLSHOP_RESET_TYPE type2)
{
	switch(Type)
	{
		case PLSHOP_LIMIT_NONE:
			return "";
			break;
		case PLSHOP_LIMIT_CHARACTER:
		case PLSHOP_LIMIT_ACCOUNT:
			if(type2 == PLSHOP_RESET_ALWAYS)
			{
				return "";
			}
			else
			{
				if(type2 == PLSHOP_RESET_ONEDAY)
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
			}
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
			break;
		case LCoinShopMark_Event:
			return "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_EventIcon_02";
			break;
		case LCoinShopMark_Sale:
			return "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_SaleIcon_02";
			break;
		case LCoinShopMark_Best:
			return "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_BestIcon";
			break;
		case LCoinShopMark_Limited:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraft_ListRibbonLIMITED";
			break;
		case LCoinShopMark_New:
			return "L2UI_EPIC.LCoinShopICON_ribbonNEW";
			break;
	}
	return "";
}

function RichListCtrlRowData GetSelectedRecord()
{
	local RichListCtrlRowData Record, nullRecord;
	local int SlotNum, listIndex;

	if(GetCurrentListSelectedIndex() == -1)
	{
		SlotNum = pLShopItemDataList[GetCurrentSelectedIndex()].nSlotNum;

		if(SlotNum > -1)
		{
			listIndex = GetCurrentListIndexBySlotNum(SlotNum);

			if(listIndex == -1)
			{
				return nullRecord;
			}
			getListCtrlByCategory(currentTabIndex).GetRec(listIndex, Record);
		}
	}
	else
	{
		getListCtrlByCategory(currentTabIndex).GetSelectedRec(Record);
	}
	return Record;
}

function int GetCurrentListIndexBySlotNum(int SlotNum)
{
	return FindListIndex(currentTabIndex, SlotNum);
}

function int FindListIndex(int Category, int SlotNum)
{
	local int i;
	local RichListCtrlRowData Record;

	for (i = 0; i < getListCtrlByCategory(Category).GetRecordCount(); i++)
	{
		getListCtrlByCategory(Category).GetRec(i, Record);

		if(SlotNum == GetSlotNumByRecord(Record))
		{
			return i;
		}
	}
	return -1;
}

function string GetGradeTextureByRank(int ProductRank)
{
	switch(ProductRank)
	{
		case 0:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCard_01";
			break;
		case 1:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCard_02";
			break;
		case 2:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCard_03";
			break;
		case 3:
			return "L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCard_04";
			break;
	}
	return "";
}

function int GetCurrentListSelectedIndex()
{
	return getListCtrlByCategory(currentTabIndex).GetSelectedIndex();
}

function SetCheckButtonByCategory(int nCategory)
{
	local int i, Max;
	local ButtonHandle filterBtn;

	currentFilterTypes.Length = 0;
	currentFilterTypes = GetCategorySubList(nCategory);
	Max = currentFilterTypes.Length;

	for (i = 0; i < Max; i++)
	{
		filterBtn = GetFilterButton(i);
		filterBtn.ShowWindow();
		filterBtn.SetNameText(GetFilterString(i));
	}

	for (i = i; i < MAX_FILTERTYPE; i++)
	{
		filterBtn = GetFilterButton(i);
		filterBtn.HideWindow();
	}

	if(SelectedRadioBoxList.Length > 0)
	{
		SetCheckBox(SelectedRadioBoxList[currentTabIndex]);
	}
}

function string GetFilterString(int Index)
{
	if(Index == 0)
	{
		return GetSystemString(144);
	}
	return GetNpcString(currentFilterTypes[Index]);
}

function SetCheckBox(int Index)
{
	local int i;

	for(i = 0; i < currentFilterTypes.Length; i++)
	{
		SelectFilterButton(i, false);
	}
	SelectFilterButton(Index, true);
}

function SelectFilterButton(int nFilterType, bool bSelect)
{
	if(bSelect)
	{
		GetFilterButton(nFilterType).SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");		
	}
	else
	{
		GetFilterButton(nFilterType).SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
	}
}

function int SelectedCategorySub(int Category)
{
	if(categorySubDatas.Length <= 0)
	{
		return 0;
	}

	if(SelectedRadioBoxList.Length <= 0)
	{
		return 0;
	}
	return GetCategorySubList(Category)[SelectedRadioBoxList[Category]];
}

function MakeItemCategorySubList()
{
	local int i;
	local PurchaseLimitCraftUIData productData;

	for(i = 0; i < pLShopItemDataList.Length; i++)
	{
		API_GetPurchaseLimitCraftData(pLShopItemDataList[i].nSlotNum, productData);
		SetSubCategory(productData.Category, productData.CategorySub);
	}
}

function MakeAllItemCategorySubList()
{
	local int i;

	for(i = 0; i < MAX_CATEGORY; i++)
	{
		SetSubCategory(i, 0);
	}	
}

function ClearItemCategorySubList()
{
	local int i;

	for(i = 0; i < categorySubDatas.Length; i++)
	{
		categorySubDatas[i].categorySubs.Length = 0;
		categorySubDatas[i].categoryFolded.Length = 0;
	}	
}

function bool GetbFolded(int Category, int CategorySub)
{
	local int Index;

	Index = GetCategorySubIndex(Category, CategorySub);
	return categorySubDatas[Category].categoryFolded[Index] == 1;
}

function SetbFolded(int Category, int CategorySub, bool bFolded)
{
	local int Index;

	Index = GetCategorySubIndex(Category, CategorySub);

	if(bFolded)
	{
		categorySubDatas[Category].categoryFolded[Index] = 1;		
	}
	else
	{
		categorySubDatas[Category].categoryFolded[Index] = 0;
	}
}

function array<int> GetCategorySubList(int Category)
{
	return categorySubDatas[Category].categorySubs;
}

function SetSubCategory(int Category, int CategorySub)
{
	local int Index, Len;

	Index = GetCategorySubIndex(Category, CategorySub);

	if(Index == -1)
	{
		Len = categorySubDatas[Category].categorySubs.Length;
		categorySubDatas[Category].categorySubs[Len] = CategorySub;
		categorySubDatas[Category].categoryFolded[Len] = 0;
	}
}

function int GetCategorySubIndex(int Category, int CategorySub)
{
	local int i;

	for(i = 0; i < categorySubDatas[Category].categorySubs.Length; i++)
	{
		if(categorySubDatas[Category].categorySubs[i] == CategorySub)
		{
			return i;
		}
	}
	return -1;
}

function DisalbeCardAll()
{
	local int i;

	for(i = 0; i < MAX_CARD; i++)
	{
		GetTextureHandleDiable(i).ShowWindow();
	}
}

function EnableCardAll()
{
	local int i;

	for(i = 0; i < MAX_CARD; i++)
	{
		GetTextureHandleDiable(i).HideWindow();
	}
}

function AnimationComplete(int Id)
{
	if (CurrentState != process)
	{
		return;
	}
	switch (Id)
	{
		case 1:
			AnimationEnd();
			break;
	}
}

function ShakeComplete(int Id)
{
	if(CurrentState != confirm)
	{
		return;
	}
	switch(Id)
	{
		case 2:
			if(_successionInfo.isKeepOption == true && _successionInfo.successionItemSId > 0 && _successionInfo.materialItemSId > 0)
			{
				API_RequestPurchaseLimitShopItemBuy(pLShopItemDataList[GetCurrentSelectedIndex()].nSlotNum, int(ItemCount_EditBox.GetString()), _successionInfo.successionItemSId, _successionInfo.materialItemSId);				
			}
			else
			{
				API_RequestPurchaseLimitShopItemBuy(pLShopItemDataList[GetCurrentSelectedIndex()].nSlotNum, int(ItemCount_EditBox.GetString()));
			}
			break;
	}
}

function AnimationStart()
{
	aniLoop = 0;
	AnimationNext();
	CraftGaugeWndGauge_tex.SetWindowSize(0, gaugeRect.nHeight);
	MakeChargeObject();
	AnimationCardToBack();
	m_hOwnerWnd.KillTimer(TWEEN_ID_ANI_GaugeCharge);
	m_hOwnerWnd.SetTimer(TWEEN_ID_ANI_GaugeCharge, TWEEN_ANI_REFRESH);
}

function float GetSizePer()
{
	local float Per;

	switch(aniLoop)
	{
		case 0:
			Per = 0.20f;
			break;
		case 1:
			Per = 0.60f;
			break;
		case 2:
			Per = 1.0f;
			break;
	}
	return Per;
}

function AnimationNext()
{
	local int randNum;

	MakeShakeObject();
	randNum = Rand(10);

	if(randNum < 2)
	{
		m_ObjectViewport.PlayAnimation(2);
	}
	else
	{
		m_ObjectViewport.PlayAnimation(1);
	}
	aniLoop++;
}

function MakeShakeObject()
{
	local float Size;

	Size = 50.0 * GetSizePer();
	l2UITweenScript.StartShake(CraftItemWnd.GetWindowName(), int(Size), 200, l2UITweenScript.directionType.small, TWEEN_SHAKE_DELAY);
}

function MakeResultShakeObject()
{
	local L2UITween.ShakeObject shakeObjectData;

	shakeObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	shakeObjectData.Id = 2;
	shakeObjectData.shakeSize = 10.0;
	shakeObjectData.Direction = l2UITweenScript.directionType.big;
	shakeObjectData.Target = CraftItemWnd;
	shakeObjectData.Duration = TWEEN_ANI_REFRESH;
	l2UITweenScript.StartShakeObject(shakeObjectData);
}

function MakeChargeObject()
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tweenObjectData.Id = 1;
	tweenObjectData.Target = CraftGaugeWndGauge_tex;
	tweenObjectData.Duration = TWEEN_ANI_REFRESH * TWEEN_ID_ANI_Shake_END + TWEEN_SHAKE_DELAY;
	tweenObjectData.SizeX = gaugeRect.nWidth;
	tweenObjectData.ease = l2UITweenScript.easeType.IN_STRONG;
	l2UITweenScript.AddTweenObject(tweenObjectData);
}

function AnimationStop()
{
	local int i;
	local PurchaseLimitCraftUIData productData;

	m_ObjectViewport.PlayAnimation(-1);
	l2UITweenScript.StopTween(m_hOwnerWnd.m_WindowNameWithFullPath, 1);
	l2UITweenScript.StopShake(m_hOwnerWnd.m_WindowNameWithFullPath, 2);
	CraftItemWnd.MoveC(craftItemWndRect.nX, craftItemWndRect.nY);
	productData = GetSelectedProductData();

	for (i = 0; i < productData.BuyItems.Length; i++)
	{
		l2UITweenScript.StopTween(m_hOwnerWnd.m_WindowNameWithFullPath, TWEEN_ID_CARD_ALPHA  + i);
	}
	m_hOwnerWnd.KillTimer(1);
}

function AnimationEnd()
{
	AnimationStop();
	SetState(confirm);
}

function AnimationCardToBack()
{
	local int i;
	local L2UITween.TweenObject tweenObjectData;
	local TextureHandle cardBackTexture;
	local PurchaseLimitCraftUIData productData;

	productData = GetSelectedProductData();

	for (i = 0; i < productData.BuyItems.Length; i++)
	{
		cardBackTexture = GetTexturehandleCraftCardBack(i);
		GetTexturehandleCraftSlot(i).HideWindow();
		tweenObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
		tweenObjectData.Id = TWEEN_ID_CARD_ALPHA + i;
		tweenObjectData.Target = cardBackTexture;
		tweenObjectData.Duration = TWEEN_ANI_CARD_ALPHA;
		tweenObjectData.Delay = TWEEN_ANI_CARD_ALPHA * i / 5;
		tweenObjectData.ease = l2UITweenScript.easeType.OUT_STRONG;
		tweenObjectData.Alpha = 255.0;
		cardBackTexture.SetAlpha(0);
		cardBackTexture.ShowWindow();
		l2UITweenScript.AddTweenObject(tweenObjectData);
	}
}

function AnimationCardToFront(int i)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tweenObjectData.Id = 1000 + i;
	tweenObjectData.Target = GetTexturehandleCraftCardBack(i);
	GetTexturehandleCraftSlot(i).ShowWindow();
	tweenObjectData.Duration = TWEEN_ANI_CARD_ALPHA;
	tweenObjectData.Delay = (TWEEN_ANI_CARD_ALPHA * i) / 5;
	tweenObjectData.ease = l2UITweenScript.easeType.OUT_STRONG;
	tweenObjectData.Alpha = -255.0f;
	l2UITweenScript.AddTweenObject(tweenObjectData);
}

function playEffectViewPort(string effectPath)
{
	EffectViewport00.SpawnEffect(effectPath);
}

function SetState(StateCraft State)
{
	CurrentState = State;
	m_hOwnerWnd.KillTimer(1);
	switch (State)
	{
		case Normal:
			EditBoxFind.EnableWindow();
			playEffectViewPort("");
			DisableWnd.HideWindow();
			ShowBuyWnd(false);
			CraftResult01_CostItem_Wnd.ShowWindow();
			CraftResult02_Gauge_Wnd.HideWindow();
			CraftResult03_Description_Wnd.HideWindow();
			AnimationStop();
			SetBuyItems();
			Craft_Btn.SetButtonName(645);
			Craft_Btn.EnableWindow();
			ShopDailyFails_ResultWnd.HideWindow();
			passAnimationCheck.ShowWindow();
			break;
		case buy:
			EditBoxFind.DisableWindow();
			ShowBuyWnd(true);
			CraftResult01_CostItem_Wnd.ShowWindow();
			CraftResult02_Gauge_Wnd.HideWindow();
			CraftResult03_Description_Wnd.HideWindow();
			AnimationStop();
			Craft_Btn.SetButtonName(645);
			passAnimationCheck.ShowWindow();
			break;
		case process:
			EditBoxFind.DisableWindow();
			DisableWnd.ShowWindow();
			DisableWnd.SetFocus();
			ShowBuyWnd(false);
			CraftResult01_CostItem_Wnd.HideWindow();
			CraftResult02_Gauge_Wnd.ShowWindow();
			CraftResult03_Description_Wnd.HideWindow();
			AnimationStop();
			AnimationStart();
			Craft_Btn.SetButtonName(141);
			passAnimationCheck.HideWindow();
			break;
		case confirm:
			EditBoxFind.DisableWindow();
			playEffectViewPort("LineageEffect.br_e_u095_flower_shower");
			EffectViewport00.SetCameraDistance(530.0f);
			PlaySound("ItemSound2.smelting.smelting_finalA");
			DisableWnd.ShowWindow();
			DisableWnd.SetFocus();
			ShowBuyWnd(false);
			CraftResult01_CostItem_Wnd.HideWindow();
			CraftResult02_Gauge_Wnd.HideWindow();
			CraftResult03_Description_Wnd.ShowWindow();
			Craft_Btn.SetButtonName(140);
			Description_Text.SetText(GetSystemString(13295));
			passAnimationCheck.HideWindow();
			break;
		case Result:
			EditBoxFind.DisableWindow();

			if(_successionInfo.isKeepOption == true)
			{
				UpdateSuccessionResultBuyItems();
			}
			DisableWnd.ShowWindow();
			DisableWnd.SetFocus();
			ShowBuyWnd(false);
			CraftResult01_CostItem_Wnd.HideWindow();
			CraftResult02_Gauge_Wnd.HideWindow();
			CraftResult03_Description_Wnd.ShowWindow();
			Craft_Btn.SetButtonName(3135);
			Craft_Btn.EnableWindow();
			Description_Text.SetText(GetSystemString(13296));
			passAnimationCheck.HideWindow();
			break;
	}
}

function initSelectedItemIDArray()
{
	local int i;

	for (i = 0; i < MAX_CATEGORY; i++)
	{
		selectedByCategoryList[i] = -1;
		SelectedRadioBoxList[i] = 0;
	}
}

function SetDwaft()
{
	m_ObjectViewport.SetCameraDistance(DWAFT_dist);
	m_ObjectViewport.SetCharacterOffsetX(DWAFT_offsetX);
	m_ObjectViewport.SetCharacterOffsetY(DWAFT_offsetY);
	m_ObjectViewport.SetNPCInfo(DWAFT_ID);
	m_ObjectViewport.SetCurrentRotation(DWAFT_ROTATION);
	m_ObjectViewport.ShowNPC(0.10f);
	m_ObjectViewport.SpawnNPC();
	m_ObjectViewport.ShowWindow();
}

function OnReceivedCloseUI()
{
	if(CurrentState != Normal)
	{
		SetState(Normal);
		return;
	}
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

function HideCategorySubs(int startIndex)
{
	local int i, Len;
	local RichListCtrlRowData Record;
	local RichListCtrlHandle richList;

	richList = getListCtrlByCategory(currentTabIndex);
	Len = richList.GetRecordCount();
	startIndex = startIndex + 1;

	for (i = startIndex; i < Len; i++)
	{
		richList.GetRec(i, Record);

		if(Record.szReserved == titleString)
		{
			return;
		}
		richList.DeleteRecord(startIndex);
	}
}

function ShowCategorySubs(int startIndex)
{
	local int i, Len, startItemListIndex;
	local RichListCtrlRowData Record;
	local RichListCtrlHandle richList;

	richList = getListCtrlByCategory(currentTabIndex);
	richList.GetRec(i, Record);
	startItemListIndex = int(Record.nReserved1);
	Len = richList.GetRecordCount();

	for(i = startIndex; i < Len; i++)
	{
		richList.DeleteRecord(startIndex);
	}
	HandleItemNewList(currentTabIndex, startItemListIndex);
}

delegate int OnSortCompareCategorySub(PLShopItemDataStruct A, PLShopItemDataStruct B)
{
	if(A.CategorySub > B.CategorySub)
	{
		return -1;		
	}
	else
	{
		return 0;
	}
}

delegate int OnSortCompareCategory(PLShopItemDataStruct A, PLShopItemDataStruct B)
{
	if(A.Category > B.Category)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function ShowBuyWnd(bool isShow)
{
	if(_successionInfo.isKeepOption == true)
	{
		if(isShow)
		{
			if(DialogIsMine())
			{
				DialogHide();
			}
			ShowSuccessionDialog();
		}
		else
		{
			Buy_Wnd.HideWindow();
			HideSuccessionDialog();
		}
	}
	else
	{
		if(isShow)
		{
			if(DialogIsMine())
			{
				DialogHide();
			}
			UpdateBuyWndControls();
			SetCurrentCostItems();
			Buy_Wnd.ShowWindow();
			Buy_Wnd.SetFocus();
		}
		else
		{
			Buy_Wnd.HideWindow();
		}
	}
}

function ResetSuccessionDialogInfo()
{
	_successionInfo.successionItemSId = 0;
	_successionInfo.materialItemSId = 0;
	_successionInfo.itemOption1 = 0;
	_successionInfo.itemOption2 = 0;
	_successionInfo.isResultScene = false;
}

function ResetSuccessionInfo()
{
	ResetSuccessionDialogInfo();
	_successionInfo.ProductID = 0;
	_successionInfo.isKeepOption = false;
	_successionInfo.costItemCId.Length = 0;
	_successionInfo.costItemEnchant.Length = 0;
	_successionInfo.CostItemAmount.Length = 0;
	_successionInfo.successionFee.Length = 0;
	_successionInfo.ProductItemEnchant = 0;	
}

function UpdateSuccessionInvenWnd()
{
	local int i, COSTITEMNUM, targetCostItemCId, targetCostItemEnchant;
	local ItemInfo tempInfo;
	local array<ItemInfo> itemInfos, resultInfos;

	successionCostItemWnd.Clear();
	COSTITEMNUM = GetSuccessionCostItemNum();

	if(COSTITEMNUM == 0)
	{
		return;
	}
	else if(COSTITEMNUM == 1)
	{
		targetCostItemCId = _successionInfo.costItemCId[0];
		targetCostItemEnchant = _successionInfo.costItemEnchant[0];
	}
	else if(COSTITEMNUM == 2)
	{
		if(_successionInfo.successionItemSId == 0)
		{
			targetCostItemCId = _successionInfo.costItemCId[0];
			targetCostItemEnchant = _successionInfo.costItemEnchant[0];
		}
		else
		{
			targetCostItemCId = _successionInfo.costItemCId[1];
			targetCostItemEnchant = _successionInfo.costItemEnchant[1];
		}
	}
	tempInfo = GetItemInfoByClassID(targetCostItemCId);

	if(IsStackableItem(tempInfo.ConsumeType))
	{
		targetCostItemEnchant = 0;
	}
	class'UIDATA_INVENTORY'.static.GetItemByScriptFilter(3, itemInfos);

	for(i = 0; i < itemInfos.Length; i++)
	{
		tempInfo = itemInfos[i];

		if(tempInfo.Id.ClassID == targetCostItemCId)
		{
			if((_successionInfo.successionItemSId == tempInfo.Id.ServerID) || _successionInfo.materialItemSId == tempInfo.Id.ServerID)
			{
				continue;
			}

			if((targetCostItemEnchant > 0) && targetCostItemEnchant != tempInfo.Enchanted)
			{
				continue;
			}
			tempInfo.bShowCount = false;
			tempInfo.bDisabled = 0;
			resultInfos[resultInfos.Length] = tempInfo;
		}
	}
	resultInfos.Sort(SortItemOptionDelegate);

	for(i = 0; i < resultInfos.Length; i++)
	{
		successionCostItemWnd.AddItem(resultInfos[i]);
	}
}

function UpdateSuccessionDialogControls()
{
	local ItemWindowHandle successionItemSlot, materialItemSlot;
	local TextBoxHandle registerTextBox, successionOptionTextBox, materialOptionTextBox, successionItemLabel, materialItemLabel;

	local ButtonHandle registerBtn;
	local ItemInfo successionItemInfo, materialItemInfo, slotItemInfo;
	local TextureHandle successionOptionTexture, materialOptionTexture;
	local WindowHandle needItemDisableWnd;
	local AnimTextureHandle successionSlotAnimTex, materialSlotAnimTex;
	local L2Util util;
	local string ItemName;
	local bool needUpdateSlot;
	local int i;

	if(_successionInfo.isKeepOption == false)
	{
		Debug("not succession product item");
		return;
	}
	util = L2Util(GetScript("L2Util"));
	successionItemSlot = GetItemWindowHandle(successionWnd.m_WindowNameWithFullPath $ ".Succeed_Item");
	materialItemSlot = GetItemWindowHandle(successionWnd.m_WindowNameWithFullPath $ ".SucceedMaterial_Item");
	registerTextBox = GetTextBoxHandle(itemRegisterContainer.m_WindowNameWithFullPath $ ".RegistrationTitle_txt");
	registerBtn = GetButtonHandle(itemRegisterContainer.m_WindowNameWithFullPath $ ".Registration_Btn");
	successionOptionTextBox = GetTextBoxHandle(successionWnd.m_WindowNameWithFullPath $ ".Succeed_txtOptions");
	materialOptionTextBox = GetTextBoxHandle(successionWnd.m_WindowNameWithFullPath $ ".SucceedMaterial_txtOptions");
	successionOptionTexture = GetTextureHandle(successionWnd.m_WindowNameWithFullPath $ ".Succeed_optionGradeTexture");
	materialOptionTexture = GetTextureHandle(successionWnd.m_WindowNameWithFullPath $ ".SucceedMaterial_optionGradeTexture");
	needItemDisableWnd = GetWindowHandle(successionWnd.m_WindowNameWithFullPath $ ".NeedItem_RichlistWnd.DisableWndNeedItem");
	successionSlotAnimTex = GetAnimTextureHandle(successionWnd.m_WindowNameWithFullPath $ ".SuccedSlotani_Tex");
	materialSlotAnimTex = GetAnimTextureHandle(successionWnd.m_WindowNameWithFullPath $ ".MaterialSlotani_Tex");
	successionItemLabel = GetTextBoxHandle(successionWnd.m_WindowNameWithFullPath $ ".ItemName_Succeed_txt");
	materialItemLabel = GetTextBoxHandle(successionWnd.m_WindowNameWithFullPath $ ".ItemName_Material_txt");

	if(_successionInfo.isResultScene == false)
	{
		if(_successionInfo.successionItemSId > 0 && class'UIDATA_INVENTORY'.static.FindItem(_successionInfo.successionItemSId, successionItemInfo))
		{
			needUpdateSlot = true;

			if(successionItemSlot.GetItem(0, slotItemInfo))
			{
				if(slotItemInfo.Id.ServerID == _successionInfo.successionItemSId)
				{
					needUpdateSlot = false;
				}
			}

			if(needUpdateSlot == true)
			{
				successionSlotAnimTex.Stop();
				successionSlotAnimTex.Play();
				ItemName = GetItemNameAll(successionItemInfo);
				util.GetEllipsisString(ItemName, 210);
				successionItemLabel.SetText(ItemName);

				if(! successionItemSlot.SetItem(0, successionItemInfo))
				{
					successionItemSlot.AddItem(successionItemInfo);
				}
			}
		}
		else
		{
			successionItemSlot.Clear();
			successionItemLabel.SetText("");
		}

		if(_successionInfo.materialItemSId > 0 && class'UIDATA_INVENTORY'.static.FindItem(_successionInfo.materialItemSId, materialItemInfo))
		{
			needUpdateSlot = true;

			if(materialItemSlot.GetItem(0, slotItemInfo))
			{
				if(slotItemInfo.Id.ServerID == _successionInfo.materialItemSId)
				{
					needUpdateSlot = false;
				}
			}

			if(needUpdateSlot == true)
			{
				materialSlotAnimTex.Stop();
				materialSlotAnimTex.Play();
				ItemName = GetItemNameAll(materialItemInfo);
				materialItemLabel.SetText(ItemName);
				util.GetEllipsisString(ItemName, 210);

				if(! materialItemSlot.SetItem(0, materialItemInfo))
				{
					materialItemSlot.AddItem(materialItemInfo);
				}
			}
		}
		else
		{
			materialItemSlot.Clear();
			materialItemLabel.SetText("");
		}
		itemRegisterContainer.ShowWindow();
		UpdateSuccessionInvenWnd();

		if((_successionInfo.successionItemSId > 0) && _successionInfo.materialItemSId > 0)
		{
			registerBtn.SetEnable(true);
		}
		else
		{
			registerBtn.SetEnable(false);
		}

		if(_successionInfo.successionItemSId == 0)
		{
			registerTextBox.SetText(GetSystemString(14149));
		}
		else if(_successionInfo.materialItemSId == 0)
		{
			registerTextBox.SetText(GetSystemString(14150));
		}
		else
		{
			registerTextBox.SetText(GetSystemString(14151));
		}
	}
	else
	{
		itemRegisterContainer.HideWindow();
		class'UIDATA_INVENTORY'.static.FindItem(_successionInfo.successionItemSId, successionItemInfo);
		class'UIDATA_INVENTORY'.static.FindItem(_successionInfo.materialItemSId, materialItemInfo);
		_successionInfo.itemOption1 = successionItemInfo.RefineryOp1;
		_successionInfo.itemOption2 = successionItemInfo.RefineryOp2;
		SetItemOptionControl(successionItemInfo.RefineryOp1, successionItemInfo.RefineryOp2, successionOptionTextBox, successionOptionTexture);
		SetItemOptionControl(materialItemInfo.RefineryOp1, materialItemInfo.RefineryOp2, materialOptionTextBox, materialOptionTexture);

		if(successionItemInfo.RefineryOp1 != 0 || successionItemInfo.RefineryOp2 != 0)
		{
			if(_successionInfo.successionFee.Length > 0)
			{
				successionNeedItemScript.StartNeedItemList(2);

				for(i = 0; i < _successionInfo.successionFee.Length; i++)
				{
					if(_successionInfo.successionFee[i].ItemClassID > 0)
					{
						successionNeedItemScript.AddNeedItemClassID(_successionInfo.successionFee[i].ItemClassID, _successionInfo.successionFee[i].Count);
					}
				}
				successionNeedItemScript.SetBuyNum(1);
				needItemDisableWnd.HideWindow();
			}
			else
			{
				successionNeedItemScript.CleariObjects();
				needItemDisableWnd.ShowWindow();
			}
		}
		else
		{
			successionNeedItemScript.CleariObjects();
			needItemDisableWnd.ShowWindow();
		}
	}
}

function UpdateBuyWndControls()
{
	local TextureHandle buyWndBackTexture, optionTexture;
	local WindowHandle buyWndOptionContainer;
	local TextBoxHandle optionTextBox, descTextBox;
	local bool isSucceedOption;

	buyWndBackTexture = GetTextureHandle(Buy_Wnd.m_WindowNameWithFullPath $ ".BuyWndBG");
	buyWndOptionContainer = GetWindowHandle(Buy_Wnd.m_WindowNameWithFullPath $ ".RefineryOption_wnd");
	descTextBox = GetTextBoxHandle(Buy_Wnd.m_WindowNameWithFullPath $ ".description_TextBox");
	optionTextBox = GetTextBoxHandle(buyWndOptionContainer.m_WindowNameWithFullPath $ ".txtOptions");
	optionTexture = GetTextureHandle(buyWndOptionContainer.m_WindowNameWithFullPath $ ".optionGradeTexture");
	isSucceedOption = false;

	if(_successionInfo.isKeepOption && _successionInfo.successionItemSId > 0 && _successionInfo.materialItemSId > 0)
	{
		if(_successionInfo.itemOption1 > 0 || _successionInfo.itemOption2 > 0)
		{
			isSucceedOption = true;
		}
	}

	if(isSucceedOption == true)
	{
		SetItemOptionControl(_successionInfo.itemOption1, _successionInfo.itemOption2, optionTextBox, optionTexture);
		buyWndOptionContainer.ShowWindow();
		buyWndBackTexture.SetTextureSize(362, 460);
		buyWndBackTexture.SetWindowSize(362, 460);
		descTextBox.SetText(GetSystemString(14155));
		buyWndConfirmBtn.SetButtonName(14145);
	}
	else
	{
		buyWndOptionContainer.HideWindow();
		buyWndBackTexture.SetTextureSize(362, 330);
		buyWndBackTexture.SetWindowSize(362, 330);
		descTextBox.SetText(GetSystemString(13276));
		buyWndConfirmBtn.SetButtonName(645);
	}
}

function RegisterSuccessionMaterialItem(bool isMaterial, int itemSId)
{
	if(_successionInfo.isKeepOption != true || _successionInfo.isResultScene != false)
	{
		return;
	}

	if(isMaterial == true)
	{
		if(_successionInfo.successionItemSId == 0)
		{
			_successionInfo.successionItemSId = itemSId;
		}
		else
		{
			_successionInfo.materialItemSId = itemSId;
		}
	}
	else
	{
		_successionInfo.successionItemSId = itemSId;
		_successionInfo.materialItemSId = 0;
	}
	UpdateSuccessionDialogControls();
}

function UnregisterSuccessionMaterialItem(bool isMaterial)
{
	if(_successionInfo.isKeepOption != true || _successionInfo.isResultScene != false)
	{
		return;
	}

	if(isMaterial == true)
	{
		_successionInfo.materialItemSId = 0;
	}
	else
	{
		_successionInfo.successionItemSId = 0;
		_successionInfo.materialItemSId = 0;
	}
	UpdateSuccessionDialogControls();
}

function bool IsEnableSuccessionCategory()
{
	if(getInstanceUIData().getIsClassicServer())
	{
		return true;
	}
	return false;
}

function ShowSuccessionDialog()
{
	ResetSuccessionDialogInfo();
	UpdateSuccessionDialogControls();
	successionWndContainer.ShowWindow();
	successionWnd.SetFocus();
}

function HideSuccessionDialog()
{
	successionWndContainer.HideWindow();
}

function SetItemOptionControl(int RefineryOp1, int RefineryOp2, TextBoxHandle textBox, TextureHandle Texture)
{
	local string strDesc1, strDesc2, strDesc3, descAll;
	local int ColorR, ColorG, ColorB, Quality;

	descAll = "";

	if(RefineryOp1 != 0 || RefineryOp2 != 0)
	{
		if(RefineryOp2 != 0)
		{
			Quality = GetOptionQuality(RefineryOp2);
			Texture.SetTexture(GetGradeTextureByQuality(Quality));

			if(Quality <= 0)
			{
				Texture.HideWindow();
			}
			else
			{
				Texture.ShowWindow();
			}
			ToolTip(GetScript("Tooltip")).GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		}

		if(RefineryOp1 != 0)
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";

			if(class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(RefineryOp1, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}

		if(RefineryOp2 != 0)
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";

			if(class'UIDATA_REFINERYOPTION'.static.GetOptionDescription(RefineryOp2, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		textBox.SetTextColor(GetColor(ColorR, ColorG, ColorB, 255));
		textBox.SetText(descAll);

		if(descAll != "")
		{
			Texture.ShowWindow();
		}
	}
	else
	{
		textBox.SetText(GetSystemString(14165));
		Texture.HideWindow();
	}
}

function ShowAndFindItem(string findName, int Category)
{
	_findItemInfo.isWaitingResponse = true;
	_findItemInfo.findName = findName;
	_findItemInfo.Category = Category;

	if(m_hOwnerWnd.IsShowWindow())
	{
		OnShow();
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
	}
}

function CheckFindItem()
{
	if(_findItemInfo.isWaitingResponse == false || _findItemInfo.findName == "" || _findItemInfo.Category < 0)
	{
		return;
	}
	tabGroupButton._GetGroupButtonsInstance()._setTopOrder(_findItemInfo.Category);
	EditBoxFind.SetString(_findItemInfo.findName);
	ClearAll();
	HandleItemNewList(-1);
	ResetFindItemInfo();
}

function ResetFindItemInfo()
{
	local FindItemInfo defaultInfo;

	_findItemInfo = defaultInfo;
}

function AddDesc(string Desc, out string descAll)
{
	if(Desc == "")
	{
		return;
	}

	if(descAll != "")
	{
		descAll = descAll $ "\\n" $ Desc;
	}
	else
	{
		descAll = Desc;
	}	
}

function int GetOptionQuality(int OptionID)
{
	local int Quality;

	Quality = class'UIDATA_REFINERYOPTION'.static.GetQuality(OptionID);

	if(0 >= Quality)
	{
		Quality = 1;		
	}
	else
	{
		if(4 < Quality)
		{
			Quality = 4;
		}
	}
	return Quality;	
}

function int GetSuccessionCostItemNum()
{
	local int i, COSTITEMNUM;

	for(i = 0; i < _successionInfo.costItemCId.Length; i++)
	{
		if(_successionInfo.costItemCId[i] != 0)
		{
			COSTITEMNUM++;
		}
	}
	return COSTITEMNUM;	
}

function string GetGradeTextureByQuality(int Quality)
{
	switch(Quality)
	{
		case 1:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Yellow";
			break;
		case 2:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Blue";
			break;
		case 3:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_purple";
			break;
		case 4:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Red";
			break;
		default:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Red";
			break;
	}
}

event OnSuccessionRegistBtnClicked()
{
	if(_successionInfo.isResultScene == false && _successionInfo.successionItemSId != 0 && _successionInfo.materialItemSId != 0)
	{
		_successionInfo.isResultScene = true;
	}
	else
	{
		_successionInfo.isResultScene = false;
	}
	UpdateSuccessionDialogControls();
}

event OnSuccecssionConfirmBtnClicked()
{
	HideSuccessionDialog();
	SetCurrentCostItems();
	UpdateBuyWndControls();
	Buy_Wnd.ShowWindow();	
}

event OnSuccecssionCancelBtnClicked()
{
	_successionInfo.isResultScene = false;
	UpdateSuccessionDialogControls();	
}

event OnDBClickItem(string strID, int Index)
{
	local ItemInfo targetItemInfo;

	if(Index < 0)
	{
		return;
	}

	if(strID == "SucceedItemWnd")
	{
		successionCostItemWnd.GetItem(Index, targetItemInfo);
		RegisterSuccessionMaterialItem(true, targetItemInfo.Id.ServerID);
	}
	else if(strID == "Succeed_Item")
	{
		UnregisterSuccessionMaterialItem(false);
	}
	else if(strID == "SucceedMaterial_Item")
	{
		UnregisterSuccessionMaterialItem(true);
	}
}

event OnDropItemSource(string strTarget, ItemInfo Info)
{
	if(strTarget == "Console")
	{
		if(Info.DragSrcName == "Succeed_Item")
		{
			UnregisterSuccessionMaterialItem(false);
		}
		else if(Info.DragSrcName == "SucceedMaterial_Item")
		{
			UnregisterSuccessionMaterialItem(true);
		}
	}
}

event OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	if(Info.ShortcutType == 4)
	{
		return;
	}

	if(Info.DragSrcName != "SucceedItemWnd")
	{
		return;
	}

	if(strID == "Succeed_Item")
	{
		RegisterSuccessionMaterialItem(false, Info.Id.ServerID);
	}
	else if(strID == "SucceedMaterial_Item")
	{
		RegisterSuccessionMaterialItem(true, Info.Id.ServerID);
	}
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);	
}

delegate int SortItemOptionDelegate(ItemInfo A, ItemInfo B)
{
	if(A.RefineryOp2 < B.RefineryOp2)
	{
		return -1;
	}
	return 0;
}

//ext
function string SettingSectorStr(string block, string field)
{
	local string b;
	GetINIString(block, field, b,"GeneralSettings.ini");
	return b;
}

function array<string> Arr(string str, string delim, optional int q)
{
	local array<string> tmp;
	q = Split( str, delim, tmp );
		
	return tmp;
}

defaultproperties
{
}
