class WorldExchangeBuyWnd extends UICommonAPI;

const INSERT_ONCE_LIST_NUM = 10;
const LOAD_ONCE_LIST_NUM = 100;
const REFRESHLIMIT = 1000;
const REFRESHLIMITMIN = 500;
const RESTARTPOINTITEM_LCOIN = 4037;
const RESTARTPOINTITEM_ADENA = 57;

const MAIN_TAB_CLASSIC_MAX = 6;
const MAIN_TAB_LIVE_MAX = 7;

enum ItemMainType 
{
	adena,
	Equipment,
	Artifact,
	Enchant,
	Consumable,
	EtcType,
	Collection,
	home
};

enum ItemSubtype 
{
	Weapon,
	Armor,
	Accessary,
	EtcEquipment,
	ArtifactB1,
	ArtifactC1,
	ArtifactD1,
	ArtifactA1,
	ENCHANTSCROLL,
	BlessEnchantScroll,
	MultiEnchantScroll,
	AncientEnchantScroll,
	Spiritshot,
	Soulshot,
	Buff,
	VariationStone,
	dye,
	SoulCrystal,
	SkillBook,
	EtcEnchant,
	PotionAndEtcScroll,
	ticket,
	Craft,
	IncEnchantProp,
	adena,
	EtcSubtype
};

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

enum HEADER_TYPE 
{
	ItemName,
	ItemNum,
	totalprice,
	perPrice
};

struct categoryStruct
{
	var int subSelectedIndex;
	var array<int > subCategoryStringArray;
	var array<int > subCategoryKeyArray;
	var array<int > subCategoryDotShow;
};

var INT64 ADENA_BASIC_UNIT;
var INT64 ADENA_MIN;
var INT64 ADENA_MAX;
var INT64 LCOIN_BASIC_UNIT;
var INT64 LCOIN_MIN;
var INT64 LCOIN_MAX;
var int refreshMinCount;
var int lastLoadedPage;
var int nMaxPage;
var bool bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST;
var array<UIPacket._WorldExchangeItemData > _itemDatas;
var L2UITimerObject tObjectListAdd;
var L2UITimerObject tObjectListRefreshDefaultDelay;
var UIControlTextInput uicontrolTextInputScr;
var RichListCtrlHandle List_RichList;
var RichListCtrlHandle List_RichListAdena;
var WindowHandle itemBuyDialog_Wnd;
var WindowHandle ItemBuyPopUp_Wnd;
var WindowHandle ItemBuyResultPopUp_Wnd;
var WindowHandle FindDisable_Wnd;

var CheckBoxHandle AllRadioButton;
var CheckBoxHandle AdenaRadioButton;
var CheckBoxHandle CoinRadioButtion;

var WindowHandle CoinSelection_Wnd;
var ECoinType eCurrCoinType;

var string lastFindString;
var array<int> ItemList;
var bool bFirst;
var int scrollPos;
var int requestedScrollPos;
var UIControlGroupButtonAssets TopGroupButtonAsset;
var UIControlGroupButtonAssets SubGroupButtonAsset;
var INT64 nWEIndex;
var int ShowHeaderIndex;
var int ShowHeaderIndexAdena;
var array<categoryStruct> categoryArray;
var private bool bFormSetting;

static function WorldExchangeBuyWnd Inst()
{
	return WorldExchangeBuyWnd(GetScript("WorldExchangeBuyWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_ITEM_LIST));
	RegisterEvent(EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_BUY_ITEM));
}

event OnLoad()
{
	SetClosingOnESC();
	InitHomeWnd();
	initGroupButton();
	List_RichList = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".List_RichList");
	List_RichList.SetSelectedSelTooltip(False);
	List_RichList.SetAppearTooltipAtMouseX(True);
	List_RichList.SetSortable(False);
	List_RichListAdena = GetRichListCtrlHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".List_RichListAdena");
	List_RichListAdena.SetSelectedSelTooltip(False);
	List_RichListAdena.SetAppearTooltipAtMouseX(True);
	List_RichListAdena.SetSortable(False);
	OnLoadEachServer();
	itemBuyDialog_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemBuyDialog_Wnd");
	ItemBuyPopUp_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemBuyDialog_Wnd.ItemBuyPopUp_Wnd");
	ItemBuyResultPopUp_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemBuyDialog_Wnd.ItemBuyResultPopUp_Wnd");
	FindDisable_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".FindDisable_Wnd");
	FindDisable_Wnd.ShowWindow();
	ShowBuyResultPopup();

	AllRadioButton = GetCheckBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".BundlePrice_SelectCoin.AllRadioButton");
	AdenaRadioButton = GetCheckBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".BundlePrice_SelectCoin.AdenaRadioButton");
	CoinRadioButtion = GetCheckBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".BundlePrice_SelectCoin.CoinRadioButton");

	AllRadioButton.SetTitle(GetSystemString(353)); // Все
	AdenaRadioButton.SetTitle(GetSystemString(5216)); // Адены
	CoinRadioButtion.SetTitle(class'WorldExchangeRegiWnd'.static.Inst().GetLCoinName()); // SM
	
	HandleCheckBoxSelected("AllRadioButton");

	CoinSelection_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".BundlePrice_SelectCoin");
	CoinSelection_Wnd.HideWindow();
	eCurrCoinType = ECoinType.ERCT_ALL;

	uicontrolTextInputScr = class'UIControlTextInput'.static.InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd.TextInput"));
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolTextInputScr.DelegateOnClear = DelegateOnClear;
	uicontrolTextInputScr.SetDefaultString(GetSystemString(2507));
	uicontrolTextInputScr.SetEdtiable(True);
	uicontrolTextInputScr.SetDisable(True);
	InitTimerObject();
	SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_ASCE/*8*/);
	List_RichList.SetAscend(0, True);
	List_RichList.ShowSortIcon(0);
	TopGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButtonTop;
	SubGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButtonSub;
	TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0, True);
	TopGroupButtonAsset._GetGroupButtonsInstance()._SetDisable(TopGroupButtonAsset._GetGroupButtonsInstance()._FindButtonIndexByValue(6));
	GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".TabIcon04_Tex").SetAlpha(100, 0.50f);
	TransformToHome();
}

private function HandleCheckBoxSelected(string checkBoxName)
{
	AllRadioButton.SetCheck(False);
	AdenaRadioButton.SetCheck(False);
	CoinRadioButtion.SetCheck(False);

	if (CheckboxName != "")
	{
		GetCheckBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".BundlePrice_SelectCoin."$checkBoxName).SetCheck(True);
	}
}

private function InitHomeWnd()
{
	local WindowHandle Home_Wnd, SearchResult_Wnd;

	Home_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".Home_Wnd");
	Home_Wnd.SetScript("WorldExchangeBuyHome");
	class'WorldExchangeBuyHome'.static.Inst().m_hOwnerWnd = Home_Wnd;
	SearchResult_Wnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".SearchResult_Wnd");
	SearchResult_Wnd.SetFocus();
	SearchResult_Wnd.HideWindow();
}

private function InitTimerObject()
{
	local int Time, Count;

	Count = 100 / 10;
	Time = 1000 / Count;
	tObjectListAdd = class'L2UITimer'.static.Inst()._AddNewTimerObject(Time, Count);
	tObjectListAdd._DelegateOnTime = TInsertRecordOnTime;
	tObjectListAdd._DelegateOnEnd = TInserDelayCheck;
	refreshMinCount = 500 / Time;	
}

event OnClickHeaderCtrl(string strID, int Index)
{
	// End:0x0B
	if( bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST )
	{
		return;
	}
	// End:0x1D
	if( !SetSortByHeaderIndex(Index) )
	{
		return;
	}
	RQWorldExchangeItemList(uicontrolTextInputScr.GetString());
	Debug("-- RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST "@"OnClickHeaderCtrl");
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();	
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_Restart:
			bFormSetting = False;
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_ITEM_LIST):
			RT_S_EX_WORLD_EXCHANGE_ITEM_LIST();
			break;
		case EV_PacketID(class'UIPacket'.const.S_EX_WORLD_EXCHANGE_BUY_ITEM):
			RT_S_EX_WORLD_EXCHANGE_BUY_ITEM();
			break;
	}
}

event OnShow()
{
	// End:0x1C
	if( !CheckOpenCondition() )
	{
		m_hOwnerWnd.HideWindow();
		return;
	}
	HandleOnGameStart();
	class'WorldExchangeRegiWnd'.static.Inst()._Hide();
	HideBuyDialog();
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(Self)));
	// End:0x6C
	if( bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST )
	{
		tObjectListAdd._Reset();
	}
	// End:0xA7
	if( getInstanceUIData().getIsLiveServer() )
	{
		SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(Self)), True);
	}
	class'WorldExchangeBuyHome'.static.Inst()._RQ_COININFO();
}

event OnHide()
{
	// End:0x22
	if( DialogIsMine() )
	{
		class'DialogBox'.static.Inst().HideDialog();
	}
	// End:0x5D
	if( getInstanceUIData().getIsLiveServer() )
	{
		SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(Self)), False);
	}	
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	Debug("OnClickButtonWithHandle"@a_ButtonHandle.GetWindowName());
	switch(a_ButtonHandle)
	{
		// End:0x70
		case GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd.BtnFind"):
			HandleBtnFind();
			// End:0xAA
			break;
		// End:0xA7
		case GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".SearchResult_Wnd.BtnFind"):
			// End:0xAA
			break;
	}	
}

event OnClickCheckBox(string strID)
{
	HandleCheckBoxSelected(strID);

	switch (strID)
	{
		case "AllRadioButton":
			SelectAllCoinType();
			break;
		case "AdenaRadioButton":
			SelectAdenaCoinType();
			break;
		case "CoinRadioButton":
			SelectLCoinCoinType();
			break;
	}
}

function SelectAdenaCoinType()
{
	eCurrCoinType = ECoinType.ERCT_ADENA;
	HandleBtnRefresh();
}

function SelectAllCoinType()
{
	eCurrCoinType = ECoinType.ERCT_ALL;
	HandleBtnRefresh();
}

function SelectLCoinCoinType()
{
	eCurrCoinType = ECoinType.ERCT_LCOIN;
	HandleBtnRefresh();
}

event OnClickButton(string strID)
{
	Debug("OnClickButton"@strID);
	switch(strID)
	{
		// End:0x21
		case "WndClose_BTN":
			_Hide();
			// End:0xC5
			break;
		// End:0x3A
		case "Refresh_btn":
			HandleBtnRefresh();
			// End:0xC5
			break;
		// End:0x68
		case "MoveWnd_Btn":
			HandleBtnSwap();
			// End:0xC5
			break;
		// End:0x80
		case "Cancel_Btn":
			HideBuyDialog();
			// End:0xC5
			break;
		// End:0x9A
		case "Ok_Btn":
			RQ_C_EX_WORLD_EXCHANGE_BUY_ITEM();
			HideBuyDialog();
			// End:0xC5
			break;
		// End:0xB4
		case "OkResult_Btn":
			HideBuyDialog();
			// End:0xC5
			break;
		// End:0xE4
		case "Back_Btn":
			class'WorldExchangeBuyHome'.static.Inst()._SwapToFind();
			// End:0x11D
			break;
		// End:0x10C
		case "gotoBtn":
			class'WorldExchangeBuyHome'.static.Inst()._GotoFind();
			// End:0x11D
			break;
		// End:0xFFFF
		default:
			ChckBtnName(strID);
			// End:0x11D
			break;
	}
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData RowData;

	switch(_GetCurrentMainType())
	{
		// End:0x2B
		case 7:
			class'WorldExchangeBuyHome'.static.Inst()._GotoFind();
			// End:0x58
			break;
		// End:0xFFFF
		default:
			GetCurrentRichlistCtrlHandle().GetSelectedRec(RowData);
			SetShowBuyDialogWindow(int(RowData.nReserved1));
			// End:0x58
			break;
			break;
	}
}

event OnScrollMove(string strID, int pos)
{
	switch(strID)
	{
		// End:0x19
		case "List_RichList":
		// End:0x3E
		case "List_RichLIstAdena":
			HandleScrollMove(pos);
			// End:0x41
			break;
	}
}

function initGroupButton()
{
	TopGroupButtonAsset = class'UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".UIControlGroupButtonAsset1"));
	TopGroupButtonAsset._SetStartInfo("L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected_Over", True);
	SubGroupButtonAsset = class'UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".SubUIControlGroupButtonAsset"));
	SubGroupButtonAsset._SetStartInfo("L2UI_ct1.RankingWnd.RankingWnd_SubTabButton", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Over", True);	
}

function SetMainCategoryButtons()
{
	local UIControlGroupButtons mainGroupBtnScr;

	mainGroupBtnScr = TopGroupButtonAsset._GetGroupButtonsInstance();
	mainGroupBtnScr._setButtonText(0, "");
	mainGroupBtnScr._setButtonValue(0, 7);
	mainGroupBtnScr._setButtonText(1, GetSystemString(5216));
	mainGroupBtnScr._setButtonValue(1, 0);
	mainGroupBtnScr._setButtonText(2, GetSystemString(116));
	mainGroupBtnScr._setButtonValue(2, 1);
	mainGroupBtnScr._setButtonText(3, GetSystemString(2066));
	mainGroupBtnScr._setButtonValue(3, 3);
	mainGroupBtnScr._setButtonText(4, GetSystemString(13891));
	mainGroupBtnScr._setButtonValue(4, 4);
	mainGroupBtnScr._setButtonText(5, GetSystemString(13476));
	mainGroupBtnScr._setButtonValue(5, 6);
	mainGroupBtnScr._setShowButtonNum(6);
	mainGroupBtnScr._setAutoWidth(958, 0);
	mainGroupBtnScr._setButtonTexture(mainGroupBtnScr._FindButtonIndexByValue(6), "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected_Over");
	GetMeTexture("TabIcon01_Tex").ShowWindow();
	GetMeTexture("TabIcon02_Tex").ShowWindow();
	GetMeTexture("TabIcon03_Tex").ShowWindow();
	GetMeTexture("TabIcon04_Tex").ShowWindow();
	GetMeTexture("TabIcon05_Tex").ShowWindow();
	GetMeTexture("TabIcon06_Tex").ShowWindow();
	GetMeTexture("TabIcon07_Tex").HideWindow();
	GetMeTexture("TabIcon02_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_Adena");
	GetMeTexture("TabIcon03_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EquipIcon");
	GetMeTexture("TabIcon04_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EnchantIcon");
	GetMeTexture("TabIcon05_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EtcIcon");
	GetMeTexture("TabIcon06_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_CollectionIcon");
	mainGroupBtnScr._setTextureLoc(0, GetMeTexture("TabIcon01_Tex"), 0, 6, "center");
	mainGroupBtnScr._setTextureLoc(1, GetMeTexture("TabIcon02_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(2, GetMeTexture("TabIcon03_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(3, GetMeTexture("TabIcon04_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(4, GetMeTexture("TabIcon05_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(5, GetMeTexture("TabIcon06_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(5, GetMeTexture("TabIconRibbon_Tex"), 0, 0, "left");	
}

function SetMainCategoryButtonsLive()
{
	local UIControlGroupButtons mainGroupBtnScr;

	mainGroupBtnScr = TopGroupButtonAsset._GetGroupButtonsInstance();
	mainGroupBtnScr._setButtonText(0, GetSystemString(5216));
	mainGroupBtnScr._setButtonValue(0, 0);
	mainGroupBtnScr._setButtonText(1, GetSystemString(116));
	mainGroupBtnScr._setButtonValue(1, 1);
	mainGroupBtnScr._setButtonText(2, GetSystemString(3877));
	mainGroupBtnScr._setButtonValue(2, 2);
	mainGroupBtnScr._setButtonText(3, GetSystemString(1532));
	mainGroupBtnScr._setButtonValue(3, 3);
	mainGroupBtnScr._setButtonText(4, GetSystemString(3935));
	mainGroupBtnScr._setButtonValue(4, 4);
	mainGroupBtnScr._setButtonText(5, GetSystemString(49));
	mainGroupBtnScr._setButtonValue(5, 5);
	mainGroupBtnScr._setButtonText(6, GetSystemString(13476));
	mainGroupBtnScr._setButtonValue(6, 6);
	mainGroupBtnScr._setShowButtonNum(7);
	mainGroupBtnScr._setAutoWidth(958, 0);
	GetMeTexture("TabIcon01_Tex").ShowWindow();
	GetMeTexture("TabIcon02_Tex").ShowWindow();
	GetMeTexture("TabIcon03_Tex").ShowWindow();
	GetMeTexture("TabIcon04_Tex").ShowWindow();
	GetMeTexture("TabIcon05_Tex").ShowWindow();
	GetMeTexture("TabIcon06_Tex").ShowWindow();
	GetMeTexture("TabIcon07_Tex").ShowWindow();
	GetMeTexture("TabIcon01_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_Adena");
	GetMeTexture("TabIcon02_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EquipIcon");
	GetMeTexture("TabIcon03_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EnchantIcon");
	GetMeTexture("TabIcon04_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_CollectionIcon");
	GetMeTexture("TabIcon05_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EtcIcon");
	GetMeTexture("TabIcon06_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_EtcIcon");
	GetMeTexture("TabIcon07_Tex").SetTexture("L2UI.WorldExchangeWnd.WorldExchange_CollectionIcon");
	mainGroupBtnScr._setTextureLoc(0, GetMeTexture("TabIcon01_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(1, GetMeTexture("TabIcon02_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(2, GetMeTexture("TabIcon03_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(3, GetMeTexture("TabIcon04_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(4, GetMeTexture("TabIcon05_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(5, GetMeTexture("TabIcon06_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(6, GetMeTexture("TabIcon07_Tex"), 8, 6, "left");
	mainGroupBtnScr._setTextureLoc(6, GetMeTexture("TabIconRibbon_Tex"), 0, 0, "left");
	mainGroupBtnScr._setButtonTexture(mainGroupBtnScr._FindButtonIndexByValue(6), "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected_Over");	
}

private function AddSubCategoryData(int mainType, int Key, int stringNum)
{
	local int subIndex;
	local categoryStruct Data;

	Data = categoryArray[mainType];
	subIndex = Data.subCategoryKeyArray.Length;
	Data.subCategoryKeyArray[subIndex] = Key;
	Data.subCategoryStringArray[subIndex] = stringNum;
	categoryArray[mainType] = Data;
}

private function SetSubCategoryData()
{
	AddSubCategoryData(0, 24, 144);
	categoryArray[0].subCategoryDotShow.Length = 1;
	AddSubCategoryData(1, 0, 2520);
	AddSubCategoryData(1, 1, 2532);
	AddSubCategoryData(1, 2, 2537);
	AddSubCategoryData(1, 3, 49);
	categoryArray[1].subCategoryDotShow.Length = 4;
	AddSubCategoryData(2, 0, 0);
	categoryArray[2].subCategoryDotShow.Length = 0;
	AddSubCategoryData(3, 8, 1532);
	AddSubCategoryData(3, 17, 2554);
	AddSubCategoryData(3, 15, 2553);
	AddSubCategoryData(3, 16, 25);
	AddSubCategoryData(3, 18, 2558);
	AddSubCategoryData(3, 19, 49);
	categoryArray[3].subCategoryDotShow.Length = 6;
	AddSubCategoryData(4, 20, 13848);
	AddSubCategoryData(4, 21, 5834);
	AddSubCategoryData(4, 22, 13892);
	AddSubCategoryData(4, 25, 49);
	categoryArray[4].subCategoryDotShow.Length = 4;
	AddSubCategoryData(5, 0, 0);
	categoryArray[5].subCategoryDotShow.Length = 0;
	AddSubCategoryData(6, 1, 116);
	AddSubCategoryData(6, 3, 13846);
	AddSubCategoryData(6, 5, 49);
	categoryArray[6].subCategoryDotShow.Length = 3;	
}

private function SetSubCategoryDataLive()
{
	AddSubCategoryData(0, 24, 144);
	AddSubCategoryData(1, 0, 2520);
	AddSubCategoryData(1, 1, 2532);
	AddSubCategoryData(1, 2, 2537);
	AddSubCategoryData(2, 4, 3891);
	AddSubCategoryData(2, 5, 3892);
	AddSubCategoryData(2, 6, 3893);
	AddSubCategoryData(2, 7, 3894);
	AddSubCategoryData(3, 8, 2611);
	AddSubCategoryData(3, 9, 13841);
	AddSubCategoryData(3, 10, 13842);
	AddSubCategoryData(3, 11, 13843);
	AddSubCategoryData(4, 12, 2545);
	AddSubCategoryData(4, 13, 2544);
	AddSubCategoryData(4, 14, 13318);
	AddSubCategoryData(5, 15, 3349);
	AddSubCategoryData(5, 16, 25);
	AddSubCategoryData(5, 23, 13844);
	AddSubCategoryData(5, 25, 49);	
}

function SetGroupButtonCategorySub(int mainType)
{
	local int i, Len;
	local UIControlGroupButtons subGroupBtnScr;

	subGroupBtnScr = SubGroupButtonAsset._GetGroupButtonsInstance();
	Len = categoryArray[mainType].subCategoryStringArray.Length;
	subGroupBtnScr._setShowButtonNum(Len);
	subGroupBtnScr._fixedWidth(110, 5);
	// End:0xCD [Loop If]
	for( i = 0; i < Len; i++ )
	{
		subGroupBtnScr._setButtonText(i, GetSystemString(categoryArray[mainType].subCategoryStringArray[i]));
		subGroupBtnScr._setButtonValue(i, categoryArray[mainType].subCategoryKeyArray[i]);
	}
}

function ReselectCategorySub(int mainType)
{
	SubGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(categoryArray[mainType].subSelectedIndex);	
}

private function DelegateOnClickButtonSub(string parentWndName, string strName, int subIndex)
{
	local int mainType;

	mainType = _GetCurrentMainType();
	// End:0x1C
	if( mainType == 7 )
	{
		return;
	}
	categoryArray[mainType].subSelectedIndex = subIndex;
	Debug("-- RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST "@"DelegateOnClickButtonSub");
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
}

private function DelegateOnClickButtonTop(string parentWndName, string strName, int mainIndex)
{
	local int mainType;

	mainType = _GetCurrentMainType();
	SetGroupButtonCategorySub(mainType);
	ReselectCategorySub(mainType);
	TransformByMainType();
}

function bool GetCategoryIndex(int ClassID, out int mainCategoryIndex, out int subCategoryIndex)
{
	local int i, j, subCategoryKey, mainType;
	local UIControlGroupButtons mainGroupBtnScr;

	subCategoryKey = API_GetServerPrivateStoreSearchItemSubType(ClassID);
	Debug("mainCategoryType"@string(subCategoryKey));
	// End:0x43
	if( subCategoryKey == -1 )
	{
		return False;
	}

	if (mainCategoryIndex == 0 || mainCategoryIndex == 1)
	{
		CoinSelection_Wnd.HideWindow();
	}
	else
	{
		if (!CoinSelection_Wnd.IsShowWindow())
		{
			CoinSelection_Wnd.ShowWindow();
		}
	}

	mainGroupBtnScr = TopGroupButtonAsset._GetGroupButtonsInstance();

	// End:0x11F [Loop If]
	for( i = 1; i < mainGroupBtnScr._getShowButtonNum(); i++ )
	{
		mainType = GetMainCategoryType(i);
		Debug(" -- MainCategoryIndex :"@string(i));

		// End:0x115 [Loop If]
		for( j = 0; j < categoryArray[mainType].subCategoryKeyArray.Length; j++ )
		{
			// End:0x10B
			if( categoryArray[mainType].subCategoryKeyArray[j] == subCategoryKey )
			{
				mainCategoryIndex = i;
				subCategoryIndex = j;
				return True;
			}
		}
	}
	return False;
}

function _SetCategoryIndexByClassID(int ClassID)
{
	local int mainCategoryIndex, subCategoryIndex, mainType;
	local ItemInfo iInfo;

	// End:0x1C
	if( !GetCategoryIndex(ClassID, mainCategoryIndex, subCategoryIndex) )
	{
		return;
	}
	// End:0x42
	if( !class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(ClassID), iInfo) )
	{
		return;
	}
	uicontrolTextInputScr.SetString(lastFindString);
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd.BtnFind").DisableWindow();
	lastFindString = GetItemNameAll(iInfo);
	CheckFindString(lastFindString, ItemList);
	mainType = GetMainCategoryType(mainCategoryIndex);
	categoryArray[mainType].subSelectedIndex = subCategoryIndex;
	TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(mainCategoryIndex);
}

function _DotTextureAllHide()
{
	local int i, j;

	TopGroupButtonAsset._DotTextureAllShow(False);
	SubGroupButtonAsset._DotTextureAllShow(False);

	// End:0x85 [Loop If]
	for( i = 0; i < categoryArray.Length; i++ )
	{
		// End:0x7B [Loop If]
		for( j = 0; j < categoryArray[i].subCategoryDotShow.Length; j++ )
		{
			categoryArray[i].subCategoryDotShow[j] = 0;
		}
	}	
}

function _DotAdd(int ClassID)
{
	local int mainCategoryIndex, subCategoryIndex, mainCategoryType;

	// End:0x1C
	if( !GetCategoryIndex(ClassID, mainCategoryIndex, subCategoryIndex) )
	{
		return;
	}
	mainCategoryType = GetMainCategoryType(mainCategoryIndex);
	categoryArray[mainCategoryType].subCategoryDotShow[subCategoryIndex]++;
	Debug("_DotAdd"@string(mainCategoryType)@string(subCategoryIndex)@string(categoryArray[mainCategoryType].subCategoryDotShow[subCategoryIndex]));
	TopGroupButtonAsset._DotTextureShow(mainCategoryIndex, True);
	TopGroupButtonAsset._DotTextureColorModify(mainCategoryIndex, GetColor(0, 255, 0, 255));	
}

function _DotSubCurrentSet()
{
	local int mainCategoryType, i;

	mainCategoryType = _GetCurrentMainType();
	Debug("_DotSubCurrentSet"@string(mainCategoryType)@string(categoryArray[mainCategoryType].subCategoryDotShow.Length));

	// End:0xD8 [Loop If]
	for( i = 0; i < categoryArray[mainCategoryType].subCategoryDotShow.Length; i++ )
	{
		// End:0xB9
		if( categoryArray[mainCategoryType].subCategoryDotShow[i] > 0 )
		{
			SubGroupButtonAsset._DotTextureShow(i, True);
			SubGroupButtonAsset._DotTextureColorModify(i, GetColor(0, 255, 0, 255));
			// [Explicit Continue]
			continue;
		}
		SubGroupButtonAsset._DotTextureShow(i, False);
	}	
}

private function TransformToHome()
{
	FindDisable_Wnd.HideWindow();
	List_RichList.HideWindow();
	List_RichListAdena.HideWindow();
	CoinSelection_Wnd.HideWindow();
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd").HideWindow();
	SubGroupButtonAsset._GetGroupButtonsInstance()._HideAllButtons();
	GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ListDeco_Tex").HideWindow();
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".Refresh_Btn").HideWindow();
	class'WorldExchangeBuyHome'.static.Inst()._Show();	
}

private function TransformByMainType()
{
	switch(_GetCurrentMainType())
	{
		// End:0x18
		case 7:
			TransformToHome();
			// End:0x1E5
			break;
		// End:0x106
		case 0:
			class'WorldExchangeBuyWnd'.static.Inst()._DotTextureAllHide();
			List_RichList.HideWindow();
			List_RichListAdena.ShowWindow();
			GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd").HideWindow();
			GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ListDeco_Tex").ShowWindow();
			SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_ASCE/*8*/);
			class'WorldExchangeBuyHome'.static.Inst()._Hide();
			GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".Refresh_Btn").ShowWindow();
			// End:0x1E5
			break;
		// End:0xFFFF
		default:
			class'WorldExchangeBuyWnd'.static.Inst()._DotTextureAllHide();
			List_RichList.ShowWindow();
			List_RichListAdena.HideWindow();
			CoinSelection_Wnd.ShowWindow();
			GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd").ShowWindow();
			GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ListDeco_Tex").ShowWindow();
			class'WorldExchangeBuyHome'.static.Inst()._Hide();
			GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".Refresh_Btn").ShowWindow();
			break;
	}
}

function HandleClear()
{
	lastFindString = "";
	ItemList.Length = 0;
	Debug("-- RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST "@"HandleClear");
	_DotTextureAllHide();
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
}

function DelegateESCKey()
{
	OnReceivedCloseUI();
}

function DelegateOnClear()
{
	HandleClear();
}

function DelegateOnChangeEdited(string Text)
{
	// End:0x49
	if( lastFindString == Text )
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd.BtnFind").DisableWindow();		
	}
	else
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd.BtnFind").EnableWindow();
	}
}

function bool CheckFindString(string Text, out array<int> _itemList)
{
	// End:0x0E
	if( Text == "" )
	{
		return True;
	}
	API_GetStringMatchingItemList(Text, " ", EStringMatchingItemFilter.SMIF_WorldExchangeItem, GetCurrentRichlistCtrlHandle().IsAscending(0), _itemList);
	return _itemList.Length > 0;
}

function DelegateOnCompleteEditBox(string Text)
{
	SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_ASCE/*8*/);
	RQWorldExchangeItemList(Text);	
}

function RQWorldExchangeItemList(string Text)
{
	local array<int> _itemList;

	// End:0x54
	if( !CheckFindString(Text, _itemList) )
	{
		class'L2Util'.static.Inst().showGfxScreenMessage("&#34;"$Text$"&#34;"$GetSystemMessage(4356));
		return;
	}
	// End:0x87
	if( _itemList.Length > 300 )
	{
		class'L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13767));
		return;
	}
	lastFindString = Text;
	ItemList = _itemList;
	Debug("-- RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST "@"RQWorldExchangeItemList");
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
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

private function HandleBtnSwap()
{
	_Hide();
	class'WorldExchangeRegiWnd'.static.Inst()._Show();
	getInstanceL2Util().syncWindowLoc(m_hOwnerWnd.m_WindowNameWithFullPath, "WorldExchangeRegiWnd");
}

private function HandleBtnRefresh()
{
	Debug("-- RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST "@"HandleBtnRefresh");
	RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST();
}

private function HandleBtnFind()
{
	SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_ASCE/*8*/);
	RQWorldExchangeItemList(uicontrolTextInputScr.GetString());	
}

private function HandleScrollMove(optional int pos)
{
	scrollPos = pos;
	// End:0x16
	if( bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST )
	{
		return;
	}
	Debug("HandleScrollMove"@string(pos)@string(GetCurrentRichlistCtrlHandle().GetRecordCount())@string(GetCurrentRichlistCtrlHandle().GetShowRow())@string(lastLoadedPage)@string(nMaxPage));
	// End:0xEB
	if( pos == (GetCurrentRichlistCtrlHandle().GetRecordCount() - GetCurrentRichlistCtrlHandle().GetShowRow()) )
	{
		Debug("-- RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST "@"HandleScrollMove");
		RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST(lastLoadedPage + 1);
	}
}

private function SetDisablbRefresh()
{
	local int i;

	bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST = True;
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".Refresh_btn").DisableWindow();
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd.BtnFind").DisableWindow();
	uicontrolTextInputScr.SetDisable(True);
	TopGroupButtonAsset._SetDisable();
	SubGroupButtonAsset._SetDisable();
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".MoveWnd_Btn").DisableWindow();

	// End:0x195 [Loop If]
	for( i = 1; i <= TopGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum(); i++ )
	{
		// End:0x148
		if( TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex() + 1 != i )
		{
			GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".TabIcon0"$string(i)$"_Tex").SetAlpha(100, 0.50f);
			// [Explicit Continue]
			continue;
		}
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".TabIcon0"$string(i)$"_Tex").SetAlpha(180, 0.50f);
	}
	tObjectListAdd._Reset();
}

private function SetEnableRefresh()
{
	local int i;

	bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST = False;
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".Refresh_btn").EnableWindow();
	// End:0x86
	if( lastFindString != uicontrolTextInputScr.GetString() )
	{
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd.BtnFind").EnableWindow();
	}
	uicontrolTextInputScr.SetDisable(False);
	TopGroupButtonAsset._SetEnable();
	SubGroupButtonAsset._SetEnable();
	GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".MoveWnd_Btn").EnableWindow();

	// End:0x142 [Loop If]
	for( i = 1; i <= TopGroupButtonAsset._GetGroupButtonsInstance()._getShowButtonNum(); i++ )
	{
		GetTextureHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".TabIcon0"$string(i)$"_Tex").SetAlpha(255, 0.50f);
	}
}

private function bool IsAscending(int HeaderIndex)
{
	return GetCurrentRichlistCtrlHandle().IsAscending(HeaderIndex);	
}

private function bool IsAscendingCurrent()
{
	return IsAscending(GetCurrentHeaderIndex());	
}

private function HEADER_TYPE GetCurrentHeaderType()
{
	return GetHeaderType(GetCurrentHeaderIndex());	
}

private function int GetCurrentHeaderIndex()
{
	// End:0x18
	if( _GetCurrentMainType() == 0 )
	{
		return ShowHeaderIndexAdena;		
	}
	else
	{
		return ShowHeaderIndex;
	}	
}

private function HEADER_TYPE GetHeaderType(int HeaderIndex)
{
	// End:0x32
	if( _GetCurrentMainType() == 0 )
	{
		switch(HeaderIndex)
		{
			// End:0x1D
			case 0:
				return HEADER_TYPE.ItemName/*0*/;
			// End:0x24
			case 1:
				return HEADER_TYPE.totalprice/*2*/;
			// End:0x2C
			case 2:
				return HEADER_TYPE.perPrice/*3*/;
		}
	}
	return HEADER_TYPE(HeaderIndex);	
}

private function int GetHeaderIndex(HEADER_TYPE Type)
{
	// End:0x32
	if( _GetCurrentMainType() == 0 )
	{
		switch(Type)
		{
			// End:0x1D
			case HEADER_TYPE.ItemName/*0*/:
				return 0;
			// End:0x24
			case HEADER_TYPE.totalprice/*2*/:
				return 1;
			// End:0x2C
			case HEADER_TYPE.perPrice/*3*/:
				return 2;
		}
	}
	return Type;	
}

private function int GetCurrentSortType()
{
	switch(GetCurrentHeaderType())
	{
		// End:0x23
		case HEADER_TYPE.ItemName/*0*/:
			// End:0x1E
			if( IsAscendingCurrent() )
			{
				return 2;				
			}
			else
			{
				return 3;
			}
		// End:0x3E
		case HEADER_TYPE.ItemNum/*1*/:
			// End:0x39
			if( IsAscendingCurrent() )
			{
				return 6;				
			}
			else
			{
				return 7;
			}
		// End:0x59
		case HEADER_TYPE.totalprice/*2*/:
			// End:0x54
			if( IsAscendingCurrent() )
			{
				return 4;				
			}
			else
			{
				return 5;
			}
		// End:0x74
		case HEADER_TYPE.perPrice/*3*/:
			// End:0x6F
			if( IsAscendingCurrent() )
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

private function bool SetSortByHeaderIndex(int HeaderIndex)
{
	local bool bAscending;

	// End:0x22
	if( GetCurrentHeaderIndex() == HeaderIndex )
	{
		bAscending = IsAscending(HeaderIndex);
	}
	switch(GetHeaderType(HeaderIndex))
	{
		// End:0x53
		case HEADER_TYPE.ItemName/*0*/:
			// End:0x48
			if( bAscending )
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_ENCHANT_DESC/*3*/);				
			}
			else
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_ENCHANT_ASCE/*2*/);
			}
			// End:0xC4
			break;
		// End:0x77
		case HEADER_TYPE.ItemNum/*1*/:
			// End:0x6C
			if( bAscending )
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_AMOUNT_DESC/*7*/);				
			}
			else
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_AMOUNT_ASCE/*6*/);
			}
			// End:0xC4
			break;
		// End:0x9B
		case HEADER_TYPE.totalprice/*2*/:
			// End:0x90
			if( bAscending )
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_DESC/*5*/);				
			}
			else
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_ASCE/*4*/);
			}
			// End:0xC4
			break;
		// End:0xBF
		case HEADER_TYPE.perPrice/*3*/:
			// End:0xB4
			if( bAscending )
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_DESC/*9*/);				
			}
			else
			{
				SetSortType(E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_ASCE/*8*/);
			}
			// End:0xC4
			break;
		// End:0xFFFF
		default:
			return False;
	}
	return True;	
}

private function SetSortType(WorldExchangeBuyWnd.E_WORLD_EXCHANGE_SORT_TYPE sortType)
{
	local bool bAscend;
	local int HeaderIndex;
	local HEADER_TYPE headerType;
	local RichListCtrlHandle List;

	switch(sortType)
	{
		// End:0x1F
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_ENCHANT_ASCE/*2*/:
			headerType = HEADER_TYPE.ItemName/*0*/;
			bAscend = True;
			// End:0xDD
			break;
		// End:0x37
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_ENCHANT_DESC/*3*/:
			headerType = HEADER_TYPE.ItemName/*0*/;
			bAscend = False;
			// End:0xDD
			break;
		// End:0x4F
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_AMOUNT_ASCE/*6*/:
			headerType = HEADER_TYPE.ItemNum/*1*/;
			bAscend = True;
			// End:0xDD
			break;
		// End:0x67
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_AMOUNT_DESC/*7*/:
			headerType = HEADER_TYPE.ItemNum/*1*/;
			bAscend = False;
			// End:0xDD
			break;
		// End:0x7F
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_ASCE/*4*/:
			headerType = HEADER_TYPE.totalprice/*2*/;
			bAscend = True;
			// End:0xDD
			break;
		// End:0x97
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_DESC/*5*/:
			headerType = HEADER_TYPE.totalprice/*2*/;
			bAscend = False;
			// End:0xDD
			break;
		// End:0xAF
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_ASCE/*8*/:
			headerType = HEADER_TYPE.perPrice/*3*/;
			bAscend = True;
			// End:0xDD
			break;
		// End:0xC7
		case E_WORLD_EXCHANGE_SORT_TYPE.EWEST_PRICE_PER_PIECE_DESC/*9*/:
			headerType = HEADER_TYPE.perPrice/*3*/;
			bAscend = False;
			// End:0xDD
			break;
		// End:0xFFFF
		default:
			headerType = HEADER_TYPE.ItemName/*0*/;
			bAscend = True;
			// End:0xDD
			break;
	}
	HeaderIndex = GetHeaderIndex(headerType);
	// End:0x116
	if( (_GetCurrentMainType()) == 0 )
	{
		List = List_RichListAdena;
		ShowHeaderIndexAdena = HeaderIndex;		
	}
	else
	{
		List = List_RichList;
		ShowHeaderIndex = HeaderIndex;
	}
	Debug("SetSortType"@string(HeaderIndex)@string(headerType)@List.GetWindowName());
	List.SetAscend(HeaderIndex, bAscend);
	List.ShowSortIcon(HeaderIndex);
}

private function RichListCtrlHandle GetCurrentRichlistCtrlHandle()
{
	// End:0x18
	if( (_GetCurrentMainType()) == 0 )
	{
		return List_RichListAdena;		
	}
	else
	{
		return List_RichList;
	}	
}

delegate int OnSortCompareByName(int classIDA, int classIDB)
{
	// End:0x42
	if(class'UIDATA_ITEM'.static.GetItemName(GetItemID(classIDA)) < class'UIDATA_ITEM'.static.GetItemName(GetItemID(classIDB)))
	{
		return - 1;		
	}
	else
	{
		return 0;
	}
}

function int API_GetServerPrivateStoreSearchItemSubType(int ClassID)
{
	return GetServerPrivateStoreSearchItemSubType(ClassID);	
}

function WorldExchangeUIData API_GetWorldExchangeData()
{
	return GetWorldExchangeData();
}

function int API_GetServerNo()
{
	return GetServerNo();
}

function API_GetStringMatchingItemList(string a_str, string a_delim, EStringMatchingItemFilter a_filter, bool a_bAscend, out array<int> o_ItemList)
{
	class'UIDATA_ITEM'.static.GetStringMatchingItemList(a_str, a_delim, a_filter, a_bAscend, o_ItemList);
}

function RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST(optional int Page)
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_ITEM_LIST packet;

	// End:0x0B
	if( bRQ_C_EX_WORLD_EXCHANGE_ITEM_LIST )
	{
		return;
	}
	Debug("RQ_C_EX_WORLD_EXCHANGE_ITEM_LIST 첫 페이지 :"@string(Page)@string(GetCurrentSubType())@string(GetCurrentSortType()));
	// End:0x78
	if( Page > 0 )
	{
		// End:0x78
		if( nMaxPage < Page )
		{
			return;
		}
	}
	requestedScrollPos = scrollPos;
	// End:0x91
	if( _itemDatas.Length > 0 )
	{
		return;
	}
	uicontrolTextInputScr.SetString(lastFindString);
	SetDisablbRefresh();
	lastLoadedPage = Page;
	packet.nCategory = GetCurrentSubType();
	packet.cSortType = GetCurrentSortType();
	packet.nPage = Page;
	// End:0x10B
	if( packet.nCategory != 24 )
	{
		packet.vItemIDList = ItemList;
	}
	packet.cType = int(eCurrCoinType);
	// End:0x12B
	if( !class'UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_ITEM_LIST(stream, packet) )
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLD_EXCHANGE_ITEM_LIST, stream);
}

function RT_S_EX_WORLD_EXCHANGE_ITEM_LIST()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_ITEM_LIST packet;

	// End:0x16
	if( !m_hOwnerWnd.IsShowWindow() )
	{
		return;
	}
	// End:0x31
	if( !class'UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_ITEM_LIST(packet) )
	{
		return;
	}
	// End:0x69
	if( lastLoadedPage == 0 )
	{
		// End:0xB1
		if( ItemList.Length > 0 )
		{
			class'WorldExchangeBuyHome'.static.Inst()._RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST_WithInfos(ItemList);
		}
		_itemDatas.Length = 0;
		GetCurrentRichlistCtrlHandle().DeleteAllItem();
		FindDisable_Wnd.ShowWindow();
		nMaxPage = 0;
	}
	// End:0x85
	if( packet.vItemDataList.Length == 100 )
	{
		++nMaxPage;		
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

	Debug("Handle_S_EX_WORLD_EXCHANGE_ITEM_LIST"@string(packet.vItemDataList.Length));
	tObjectListAdd._Reset();
	// End:0x63
	if( packet.vItemDataList.Length == 0 )
	{
		SetEnableRefresh();
		return;
	}
	FindDisable_Wnd.HideWindow();

	// End:0xAF [Loop If]
	for( i = 0; i < packet.vItemDataList.Length; i++ )
	{
		_itemDatas[_itemDatas.Length] = packet.vItemDataList[i];
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

	// End:0x3B
	if( _itemDatas.Length == 0 )
	{
		// End:0x39
		if( tObjectListAdd._curCount >= refreshMinCount )
		{
			tObjectListAdd._Stop();
			TInserDelayCheck();
		}
		return;
	}
	Cnt = Min(10, _itemDatas.Length);
	// End:0xAA
	if( _GetCurrentMainType() == 0 )
	{
		// End:0xA7 [Loop If]
		for( i = 0; i < Cnt; i++ )
		{
			// End:0x9D
			if( _MakeRowDataAdena(_itemDatas[i], RowData) )
			{
				List_RichListAdena.InsertRecord(RowData);
			}
		}		
	}
	else
	{
		// End:0xF7 [Loop If]
		for( i = 0; i < Cnt; i++ )
		{
			// End:0xED
			if( MakeRowData(_itemDatas[i], RowData) )
			{
				List_RichList.InsertRecord(RowData);
			}
		}
	}
	_itemDatas.Remove(0, Cnt);	
}

function TInserDelayCheck()
{
	Debug("타이머 종료");
	SetEnableRefresh();
	// End:0x33
	if( requestedScrollPos != scrollPos )
	{
		HandleScrollMove(scrollPos);
	}
}

function RQ_C_EX_WORLD_EXCHANGE_BUY_ITEM()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_BUY_ITEM packet;

	packet.nWEIndex = nWEIndex;
	// End:0x30
	if( !class'UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_BUY_ITEM(stream, packet) )
	{
		return;
	}
	Debug("RQ_C_EX_WORLD_EXCHANGE_BUY_ITEM");
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_WORLD_EXCHANGE_BUY_ITEM, stream);
}

function RT_S_EX_WORLD_EXCHANGE_BUY_ITEM()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_BUY_ITEM packet;

	Debug("RT_S_EX_WORLD_EXCHANGE_BUY_ITEM");
	// End:0x42
	if( !class'UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_BUY_ITEM(packet) )
	{
		return;
	}
	Debug(string(packet.nItemClassID)@string(packet.nAmount)@string(packet.cSuccess));
	switch(packet.cSuccess)
	{
		// End:0x89
		case 1:
			ShowBuyResultPopup();
			// End:0xD4
			break;
		// End:0xAB
		case 0:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13681));
			// End:0xD4
			break;
		// End:0xD1
		case -1:
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13687));
			// End:0xD4
			break;
	}
}

function int _GetCurrentMainType()
{
	local int topSelectedIndex;

	topSelectedIndex = TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex();
	return GetMainCategoryType(topSelectedIndex);
}

function int GetCurrentSubType()
{
	local int subSelectedIndex;

	subSelectedIndex = SubGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex();
	return GetSubCategoryType(subSelectedIndex);
}

private function int GetMainCategoryType(int mainCategoryIndex)
{
	return TopGroupButtonAsset._GetGroupButtonsInstance()._getButtonValue(mainCategoryIndex);
}

private function int GetSubCategoryType(int subCategoryIndex)
{
	return SubGroupButtonAsset._GetGroupButtonsInstance()._getButtonValue(subCategoryIndex);
}

private function int GetSimpleRound(INT64 _adena, INT64 _unit)
{
	return int(_adena / _unit);	
}

function string MakeAdenaStringNew(INT64 adena)
{
	return MakeCostString(string(adena)) @ GetSystemString(469);
}

function string _MakeAdenaString(INT64 adena)
{
	local int hundredMillion, tenMillion, million;
	local string adenaString;

	if(adena == 0)
	{
		return "";
	}
	hundredMillion = GetSimpleRound(adena, 100000000);
	tenMillion = int(float(GetSimpleRound(adena, 10000000)) % 10);
	million = int(float(GetSimpleRound(adena, 1000000)) % 10);
	
	if(hundredMillion > 0)
	{
		adenaString = string(hundredMillion) $ GetSystemString(14189);
	}
	if(tenMillion > 0)
	{
		// End:0xCD
		if(adenaString != "")
		{
			adenaString = adenaString @ string(tenMillion) $ GetSystemString(14188);			
		}
		else
		{
			adenaString = string(tenMillion) $ GetSystemString(14188);
		}
	}
	if(million > 0)
	{
		// End:0x122
		if(adenaString != "")
		{
			adenaString = adenaString @ string(million) $ GetSystemString(14426);			
		}
		else
		{
			adenaString = string(million) $ GetSystemString(14426);
		}
	}
	return adenaString @ GetSystemString(469);
}

function bool _MakeAdenaitemInfo(out ItemInfo iInfo)
{
	// End:0x17
	if( !IsAdena(iInfo.Id) )
	{
		return False;
	}
	// End:0x5E
	if( iInfo.ItemNum < 100000000 )
	{
		iInfo.IconName = "Icon.bm_lcoin_box_i00";		
	}
	else if(iInfo.ItemNum < 100000000)
	{
		iInfo.IconName = "L2UI.WorldExchangeWnd.Icon_Adena";			
	}
	else if(iInfo.ItemNum < 1000000000)
	{
		iInfo.IconName = "L2UI.WorldExchangeWnd.Icon_AdenaBag";	
	}
	else if(iInfo.ItemNum < 6056184812580896770)
	{
		iInfo.IconName = "L2UI.WorldExchangeWnd.Icon_AdenaBox";				
	}
	else
	{
		iInfo.IconName = "L2UI.WorldExchangeWnd.Icon_AdenaBox2";
	}

	return True;
}

function _SetFindString(string Str, optional array<int> _itemList)
{
	// End:0x1A
	if( _itemList.Length == 0 )
	{
		RQWorldExchangeItemList(Str);		
	}
	else
	{
		lastFindString = Str;
		uicontrolTextInputScr.SetString(Str);
		GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".ItemFind_Wnd.BtnFind").DisableWindow();
		ItemList = _itemList;
	}
}

function bool _MakeRowDataAdena(UIPacket._WorldExchangeItemData _itemData, out RichListCtrlRowData outRowData)
{
	local RichListCtrlRowData RowData;
	local ItemInfo iInfo;
	local string strcom, itemParam;
	local float unitPrice;

	RowData.cellDataList.Length = 4;
	// End:0x20
	if( _itemData.nItemClassID < 1 )
	{
		return False;
	}
	RowData.nReserved1 = _itemData.nWEIndex;
	iInfo = GetItemInfoByClassID(57);
	iInfo.ItemNum = _itemData.nAmount;
	iInfo.Price = _itemData.nPrice;
	strcom = MakeCostStringINT64(iInfo.Price);
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 8, 1);
	_MakeAdenaitemInfo(iInfo);
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, MakeAdenaStringNew(iInfo.ItemNum), GetNumericColor(string(iInfo.ItemNum)), False, 5, 7, "hs10");
	addRichListCtrlString(RowData.cellDataList[1].drawitems, class'WorldExchangeRegiWnd'.static.Inst().strLCoinName, GetColor(147, 136, 112, 255), False, 18, 0);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, strcom, GetNumericColor(strcom), False, 5, 0);
	unitPrice = float(iInfo.Price) / (float(iInfo.ItemNum) / float(ADENA_BASIC_UNIT));
	strcom = MakeCostStringINT64(iInfo.Price / (iInfo.ItemNum / ADENA_BASIC_UNIT));
	addRichListCtrlString(RowData.cellDataList[2].drawitems, "."$GetDecimalNnmStr(unitPrice), GetColor(123, 123, 123, 255), False, 0, 1, "hs7");
	addRichListCtrlString(RowData.cellDataList[2].drawitems, strcom, GetNumericColor(strcom), False, 0, -2);
	addRichListCtrlButton(RowData.cellDataList[3].drawitems, "btnBuy_"$string(_itemData.nWEIndex), 0, 0, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Down", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Over", 32, 32, 32, 32);
	ItemInfoToParam(iInfo, itemParam);
	RowData.szReserved = itemParam;
	outRowData = RowData;
	return True;
}

private function bool MakeRowData(UIPacket._WorldExchangeItemData _itemData, out RichListCtrlRowData outRowData)
{
	local RichListCtrlRowData RowData;
	local ItemInfo iInfo, iCurrencyInfo;
	local string strcom, itemParam;
	local float unitPrice;

	RowData.cellDataList.Length = 5;
	// End:0x20
	if( _itemData.nItemClassID < 1 )
	{
		return False;
	}
	// End:0x4B
	if( !class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nItemClassID), iInfo) )
	{
		return False;
	}
	if (!class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nCurrencyId), iCurrencyInfo))
	{
		return False;
	}

	RowData.nReserved1 = _itemData.nWEIndex;
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
	// End:0x205
	if( _itemData.nShapeShiftingClassId > 0 )
	{
		iInfo.LookChangeIconPanel = "BranchSys3.Icon.pannel_lookChange";
	}
	iInfo.EnsoulOption[1 - 1].OptionArray[0] = _itemData.nEsoulOption[0];
	iInfo.EnsoulOption[1 - 1].OptionArray[1] = _itemData.nEsoulOption[1];
	iInfo.EnsoulOption[2 - 1].OptionArray[0] = _itemData.nEsoulOption[2];
	iInfo.IsBlessedItem = _itemData.nBlessOption == 1;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 0, 1);
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), GTColor().White, False, 4, 9);
	addRichListCtrlString(RowData.cellDataList[1].drawitems, string(_itemData.nAmount), GTColor().White, False);
	iInfo.Price = _itemData.nPrice;
	strcom = MakeCostStringINT64(iInfo.Price);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, iCurrencyInfo.Name, GetColor(147, 136, 112, 255), False, 18, 0);
	addRichListCtrlString(RowData.cellDataList[2].drawitems, strcom, GetNumericColor(strcom), False, 5, 0);
	unitPrice = float(iInfo.Price) / float(iInfo.ItemNum);
	strcom = MakeCostStringINT64(iInfo.Price / iInfo.ItemNum);
	addRichListCtrlString(RowData.cellDataList[3].drawitems, "."$GetDecimalNnmStr(unitPrice), GetColor(123, 123, 123, 255), False, 0, 1, "hs7");
	addRichListCtrlString(RowData.cellDataList[3].drawitems, strcom, GetNumericColor(strcom), False, 0, -2);
	addRichListCtrlButton(RowData.cellDataList[4].drawitems, "btnBuy_"$string(_itemData.nWEIndex), 0, 0, "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Down", "L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Buy_Button_Over", 32, 32, 32, 32);
	ItemInfoToParam(iInfo, itemParam);
	RowData.szReserved = itemParam;
	RowData.nReserved2 = iCurrencyInfo.Id.ClassId;
	outRowData = RowData;
	return True;
}

function bool CheckOpenCondition()
{
	// End:0x26
	if( IsPlayerOnWorldRaidServer() )
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		return False;
	}
	// End:0x5C
	if( !ChkUseableLevel() )
	{
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(113), GetSystemString(14063)));
		return False;
	}
	// End:0x92
	//if(! ChkUseableServerID())
	//{
	//	getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(113), GetSystemString(14063)));
	//	return false;
	//}
	// End:0xD8
	if( GetWindowHandle("PrivateShopWndReport").IsShowWindow() )
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4217));
		return False;
	}
	return True;
}

function bool ChkUseableServerID()
{
	local int i, ServerID;
	local array<int> UseableServerIDs;

	UseableServerIDs = API_GetWorldExchangeData().UseableServerIDs;
	ServerID = API_GetServerNo();

	// End:0x55 [Loop If]
	for( i = 0; i < UseableServerIDs.Length; i++ )
	{
		// End:0x4B
		if( UseableServerIDs[i] == ServerID )
		{
			return True;
		}
	}
	return False;
}

function bool ChkUseableLevel()
{
	local UserInfo uInfo;

	// End:0x12
	if( !GetPlayerInfo(uInfo) )
	{
		return False;
	}
	return uInfo.nLevel >= API_GetWorldExchangeData().UseableLevel;
}

function ChckBtnName(string btnName)
{
	local array<string> names;

	Split(btnName, "_", names);
	switch(names[0])
	{
		// End:0x39
		case "btnBuy":
			SetShowBuyDialogWindow(int(names[1]));
			// End:0x3C
			break;
	}
}

function SetShowBuyDialogWindow(int _nWEIndex)
{
	local string popupPath;
	local RichListCtrlRowData RowData;
	local ItemInfo iInfo;
	local ItemId iPriceId;
	local ItemInfo iPriceInfo;
	local INT64 lcoinCount;
	local float unitPrice;

	popupPath = ItemBuyPopUp_Wnd.m_WindowNameWithFullPath;
	GetCurrentRichlistCtrlHandle().GetSelectedRec(RowData);
	// End:0x42
	if( RowData.nReserved1 != _nWEIndex )
	{
		return;
	}
	ParamToItemInfo(RowData.szReserved, iInfo);
	GetItemWindowHandle(popupPath$".Item_ItemWnd").Clear();
	// End:0x189
	if( IsAdena(iInfo.Id) )
	{
		GetTextBoxHandle(popupPath$".ItemName_Txt").SetTextColor(GetNumericColor(string(iInfo.ItemNum)));
		GetTextBoxHandle(popupPath$".ItemName_Txt").SetText(MakeAdenaStringNew(iInfo.ItemNum));
		GetTextBoxHandle(popupPath$".ItemNum_Txt").SetText("x1");
		// Адены тока за мульты
		GetTextureHandle(popupPath$".TotalPiceIcon_Tex").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		GetTextureHandle(popupPath$".MyLcoinIcon_Tex").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		GetTextBoxHandle(popupPath$".MyLcoinTitle_Txt").SetText("MultCoin");
		unitPrice = float(iInfo.Price) / float(iInfo.ItemNum / ADENA_BASIC_UNIT);
		if( class'WorldExchangeBuyWnd'.static.Inst()._IsNewServer() )
		{
			GetTextBoxHandle(popupPath$".UnitPriceTitle_Txt").SetText(GetSystemString(14424));			
		}
		else
		{
			GetTextBoxHandle(popupPath$".UnitPriceTitle_Txt").SetText(GetSystemString(14192));
		}	
	}
	else
	{
		GetTextBoxHandle(popupPath$".ItemName_Txt").SetTextColor(GetColor(153, 153, 153, 255));
		GetTextBoxHandle(popupPath$".ItemName_Txt").SetText(GetItemNameAll(iInfo));
		GetTextBoxHandle(popupPath$".ItemNum_Txt").SetText("x"$string(iInfo.ItemNum));
		unitPrice = float(iInfo.Price) / float(iInfo.ItemNum);
		GetTextBoxHandle(popupPath$".UnitPriceTitle_Txt").SetText(GetSystemString(14088));
	}
	
	lcoinCount = GetInventoryItemCount(GetItemID(RowData.nReserved2));
	GetItemWindowHandle(popupPath$".Item_ItemWnd").AddItem(iInfo);
	GetTextBoxHandle(popupPath$".UnitPriceCount_txt").SetText(MakeUintString(unitPrice));
	GetTextBoxHandle(popupPath$".TotalPiceCount_txt").SetText(MakeCostString(string(iInfo.Price)));
	
	if ( RowData.nReserved2 == int64(57) ) 
	{
		GetTextureHandle(popupPath$".TotalPiceIcon_Tex").SetTexture("L2UI_CT1.Icon.Icon_DF_Common_Adena");
		GetTextureHandle(popupPath$".MyLcoinIcon_Tex").SetTexture("L2UI_CT1.Icon.Icon_DF_Common_Adena");
		GetTextBoxHandle(popupPath$".MyLcoinTitle_Txt").SetText(GetSystemString(5216));
	}
	else
	{
		GetTextureHandle(popupPath$".TotalPiceIcon_Tex").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		GetTextureHandle(popupPath$".MyLcoinIcon_Tex").SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
		GetTextBoxHandle(popupPath$".MyLcoinTitle_Txt").SetText("MultCoin");
	}
	
	GetTextBoxHandle(popupPath$".MyLcoinPiceCount_txt").SetText(MakeCostString(string(lcoinCount)));
	// End:0x3E2
	if( lcoinCount < iInfo.Price )
	{
		GetButtonHandle(popupPath$".Ok_Btn").DisableWindow();
		GetTextBoxHandle(popupPath$".MyLcoinPiceCount_txt").SetTextColor(GTColor().Red);		
	}
	else
	{
		GetButtonHandle(popupPath$".Ok_Btn").EnableWindow();
		GetTextBoxHandle(popupPath$".MyLcoinPiceCount_txt").SetTextColor(GTColor().BLUE01);
		nWEIndex = _nWEIndex;
	}
	ShowBuyDialog();
}

function string GetDecimalNnmStr(float Num)
{
	local string floatString;
	local array<string> nums;

	floatString = ConvertFloatToString(Num, 2, False);
	Split(floatString, ".", nums);
	return nums[1];
}

function string GetInt64NumStr(float Num)
{
	local array<string> nums;

	Split(string(Num), ".", nums);
	return nums[0];
}

function string MakeUintString(float unitPrice)
{
	local string int64numStr, unitPricStr;

	int64numStr = MakeCostString(GetInt64NumStr(unitPrice));
	unitPricStr = GetDecimalNnmStr(unitPrice);
	return (int64numStr$".")$unitPricStr;
}

function ShowBuyDialog()
{
	itemBuyDialog_Wnd.ShowWindow();
	ItemBuyPopUp_Wnd.ShowWindow();
	ItemBuyResultPopUp_Wnd.HideWindow();
	uicontrolTextInputScr.SetDisable(True);
}

function showDisable()
{
	itemBuyDialog_Wnd.ShowWindow();
	ItemBuyPopUp_Wnd.HideWindow();
	ItemBuyResultPopUp_Wnd.HideWindow();
	uicontrolTextInputScr.SetDisable(True);
}

function ShowBuyResultPopup()
{
	local int SelectedIndex;
	local string popupPath;
	local ItemWindowHandle Result_ItemWnd;
	local RichListCtrlRowData RowData;
	local ItemInfo iInfo;
	local RichListCtrlHandle List;

	List = GetCurrentRichlistCtrlHandle();
	SelectedIndex = List.GetSelectedIndex();
	List.GetSelectedRec(RowData);
	ParamToItemInfo(RowData.szReserved, iInfo);
	List.DeleteRecord(SelectedIndex);
	popupPath = m_hOwnerWnd.m_WindowNameWithFullPath$".ItemBuyDialog_Wnd.ItemBuyResultPopUp_Wnd";
	Result_ItemWnd = GetItemWindowHandle(popupPath$".Result_ItemWnd");
	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem(iInfo);
	GetTextBoxHandle(popupPath$".ItemName_Txt").SetText(GetItemNameAll(iInfo)@"("$string(iInfo.ItemNum)$")");
	itemBuyDialog_Wnd.ShowWindow();
	ItemBuyPopUp_Wnd.HideWindow();
	ItemBuyResultPopUp_Wnd.ShowWindow();
	uicontrolTextInputScr.SetDisable(True);
	// End:0x220
	if( iInfo.Id.ClassID == 57 )
	{
		class'WorldExchangeBuyHome'.static.Inst()._RQ_COININFO();
	}	
}

function HideBuyDialog()
{
	itemBuyDialog_Wnd.HideWindow();
	uicontrolTextInputScr.SetDisable(False);
}

function HideDisable()
{
	itemBuyDialog_Wnd.HideWindow();
	uicontrolTextInputScr.SetDisable(False);
}

function bool _IsNewServer()
{
	local UserInfo uInfo;
	local ServerInfoUIData ServerInfo;

	GetPlayerInfo(uInfo);
	// End:0x52
	if( class'UIDataManager'.static.GetServerInfo(uInfo.nWorldID, ServerInfo) )
	{
		// End:0x52
		if( ServerInfo.ServerID == 96 || ServerInfo.ServerID == 97 )
		{
			return True;
		}
	}
	return False;
}

private function HandleOnGameStart()
{
	// End:0x0B
	if(bFormSetting)
	{
		return;
	}

	ADENA_BASIC_UNIT = 1000000;
	List_RichListAdena.SetColumnString(2, 14424);

	ADENA_MIN = ADENA_BASIC_UNIT;
	ADENA_MAX = 1000000000;
	LCOIN_MAX = 1000000000;
	LCOIN_MIN = 1;
	bFormSetting = true;
	class'WorldExchangeRegiWnd'.static.Inst()._OnLoadEachServer();
	class'WorldExchangeBuyHome'.static.Inst()._OnLoadEachServer();	
}

private function OnLoadEachServer()
{
	GetMeTexture("ItemBuyDialog_Wnd.ItemBuyPopUp_Wnd.TotalPiceIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
	GetMeTexture("ItemBuyDialog_Wnd.ItemBuyPopUp_Wnd.MyLcoinIcon_Tex").SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
	SetMainCategoryButtons();
	SetSubCategoryData();
}

event OnReceivedCloseUI()
{
	// End:0x1B
	if( itemBuyDialog_Wnd.IsShowWindow() )
	{
		HideBuyDialog();
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
