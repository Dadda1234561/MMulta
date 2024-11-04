/**
 * 
 *   »уЗ° АОєҐЕдё® (2018-09) V2 
 *   
 **/

class ProductInventoryWnd extends UICommonAPI;

struct GoodsItem
{
	var int goodsType;
	var string goodsName;
	var int goodsCondition;
	var int goodsIconID;
	var int goodsIsGift;
	var int seqID;
	var INT64 goodsID;
	var INT64 goodsDeliveryDate;
	var string goodsIconTexture;
	var string sortingKey;
};

var WindowHandle Me;
var ButtonHandle HelpHtmlBtn;

var TextBoxHandle ProductItemListTitle;

var RichListCtrlHandle ProductItemList_Lc;

//var TextBoxHandle ProductItemDetailInfoTitle;


var TextBoxHandle ProductItemDetailListTitle;
var TextBoxHandle ProductItemDetailListCounter;

var RichListCtrlHandle ProductItemDetailListTitle_Lc;

// »уЗ° ѕЖАМЕЫ ѕЖАМДЬ
var TextureHandle ProductItem;

// »уЗ° ѕЖАМЕЫ АМё§ 
var TextBoxHandle ProductItemText;

// »уЗ° ѕЖАМЕЫ јіён
var HtmlHandle ProductItemDiscription;

var ButtonHandle RecieveBtn;
var ButtonHandle CloseBtn;

// ј±№° №ЮАє °жїм, ј±№° ѕЦґП ѕЖАМДЬ
var AnimTextureHandle ProductItem_Msg;

var AnimTextureHandle RecieveBtnAni;

var WindowHandle ProductInventoryConfirmWnd;
var WindowHandle DisableWndAll;
var WindowHandle DisableWndList;

var TextBoxHandle  ProductBuyInfo;

var TextBoxHandle  ProductItemListTotal;

// ј±ЕГ »уЕВ АъАе
var int SelectItemNum;
var int selectedGoodsCondition;
var int selectedProductListIndex;

var string selectedProductItemName;
var string selectedProductItemIcon;


var L2Util util;

var array<GoodsItem> GoodsItemArray;
var int lastResultGoodsItemNum;


//const DisableTimerID = 1010001;

function OnRegisterEvent()
{
	RegisterEvent(EV_GoodsInventoryItemList);
	RegisterEvent(EV_GoodsInventoryResult);
	RegisterEvent(EV_GoodsInventoryItemDesc);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);
}

function OnShow()
{
	Debug(">> OnShow 상품 인벤토리 열기");
	PlayConsoleSound(IFST_WINDOW_OPEN);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Refresh();
}

function Refresh()
{
	initUI();
	// End:0x2A
	if(ProductItemList_Lc.GetRecordCount() > 0)
	{
		ProductItemList_Lc.DeleteAllItem();
	}
	ProductItem_Msg.Stop();
	ProductItem_Msg.HideWindow();

	Debug("OnShow API CALL ---> RequestGoodsInventoryItemList()");
	RequestGoodsInventoryItemList();
}

function OnHide()
{
	initUI();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle("ProductInventoryWnd");
	HelpHtmlBtn = GetButtonHandle("ProductInventoryWnd.HelpHtmlBtn");
	ProductItemListTitle = GetTextBoxHandle("ProductInventoryWnd.ProductItemListTitle");
	ProductItemList_Lc = GetRichListCtrlHandle("ProductInventoryWnd.ProductItemList_Lc");
	ProductItem = GetTextureHandle("ProductInventoryWnd.ProductItem");
	ProductItemText = GetTextBoxHandle("ProductInventoryWnd.ProductItemText");
	ProductItemDiscription = GetHtmlHandle("ProductInventoryWnd.ProductItemDiscription");
	ProductItemDetailListTitle = GetTextBoxHandle("ProductInventoryWnd.ProductItemDetailListTitle");
	ProductItemDetailListCounter = GetTextBoxHandle("ProductInventoryWnd.ProductItemDetailListCounter");
	ProductItemListTotal = GetTextBoxHandle("ProductInventoryWnd.ProductItemListTotal");
	ProductBuyInfo = GetTextBoxHandle("ProductInventoryWnd.ProductBuyInfo");
	ProductItemDetailListTitle_Lc = GetRichListCtrlHandle("ProductInventoryWnd.ProductItemDetailListTitle_Lc");
	RecieveBtn = GetButtonHandle("ProductInventoryWnd.RecieveBtn");
	CloseBtn = GetButtonHandle("ProductInventoryWnd.CloseBtn");
	ProductItem_Msg = GetAnimTextureHandle("ProductInventoryWnd.ProductItem_Msg");
	RecieveBtnAni = GetAnimTextureHandle("ProductInventoryWnd.RecieveBtnAni");
	ProductInventoryConfirmWnd = GetWindowHandle("ProductInventoryWnd.ProductInventoryConfirmWnd");
	DisableWndAll = GetWindowHandle("ProductInventoryWnd.DisableWndAll");
	DisableWndList = GetWindowHandle("ProductInventoryWnd.DisableWndList");
}

//function OnTimer(int timerID)
//{   
//	if (DisableTimerID == timerID)
//	{
//		Me.KillTimer( DisableTimerID );
//	}	
//}

function Load()
{
	util = L2Util(GetScript("L2Util"));	

	ProductItemList_Lc.SetSelectedSelTooltip(false);
	ProductItemList_Lc.SetAppearTooltipAtMouseX(true);

	ProductItemDetailListTitle_Lc.SetSelectedSelTooltip(false);
	ProductItemDetailListTitle_Lc.SetAppearTooltipAtMouseX(true);
}

// АьГј ГК±вИ­
function initUI()
{
	ShowDisableWnd(false);

	ProductItemList_Lc.DeleteAllItem();
	ProductItemDetailListTitle_Lc.DeleteAllItem();

	ProductItemText.SetText("");
	ProductBuyInfo.SetText("");

	ProductItemDiscription.Clear();
	ProductItemDiscription.HideWindow();

	ProductItem_Msg.Stop();
	ProductItem_Msg.HideWindow();	

	ProductItem.HideWindow();
	
	ProductItemDetailListCounter.SetText("");

	selectedProductItemName = "";
	selectedProductItemIcon = "";

	selectedProductListIndex = -1;
	selectedGoodsCondition = -1;

	lastResultGoodsItemNum = 0;

	RecieveBtn.DisableWindow();	

	RecieveBtnAni.Stop();
	RecieveBtnAni.Pause();

	ProductInventoryConfirmWnd.HideWindow();

	ProductItemListTotal.SetText(GetSystemString(2512) $ " : " $ "0");
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
// OnEvent
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnEvent(int Event_ID, string param)
{
	// End:0x16
	if(! Me.IsShowWindow())
	{
		return;
	}
	switch(Event_ID)
	{
		case EV_GoodsInventoryItemList:
			//Me.ShowWindow();
			OnGoodsInventoryItemList(param);
			Debug("--- EV_GoodsInventoryItemList : " @ param);
			break;
		case EV_GoodsInventoryResult:
			OnGoodsInventoryResult(param);
			Debug("--- EV_GoodsInventoryResult : " @ param);
			break;
		case EV_GoodsInventoryItemDesc:
			Debug("--> EV_GoodsInventoryItemDesc" @ param);
			OnGoodsInventroyItemDesc( param );
			break;
		case EV_DialogOK:
			//HandleDialogOK();
			break;
		case EV_DialogCancel:
			//HandleDialogCancel();
			break;
	}
}
// -------------------------------------------------
//  »уЗ° ёс·П ѕчµҐАМЖ®
//  
//  Event : EV_GoodsInventoryItemList
// 	5601
//  goodsCount=3 goodsIconID_0=1 goodsName_0=АМё§0 goodsCondition_0=0 goodsIconID_1=2 goodsName_1=АМё§1 goodsCondition_1=1 goodsIconID_2=3 goodsName_2=АМё§2 goodsCondition_2=0 goodsIconID_3=4 goodsName_3=АМё§3 goodsCondition_3=1
// -------------------------------------------------
function OnGoodsInventoryItemList( string param )
{
 	local int i;
	local int goodsCount;  // ј­№ц°Ў ЗС№шїЎ єёіЅ ГЦґл 100°іАЗ »уЗ° јц·®.
	local int goodsType;
	local int goodsIconID;  

	local int goodsTotal;   // 2018-09-21 ё®ґєѕу, ЅЕ±Ф ГЯ°Ў,ЗШґз °иБ¤їЎ АЇАъ°Ў јТАЇЗС ГС »уЗ° јц·®
	local int goodsIsGift;  // 2018-09-21 ё®ґєѕу, ј±№°АО°Ў? 0, 1

	//0:ИЇєТєТ°Ў, 1:ИЇєТ °ЎґЙ
	local int goodsCondition;

	local string goodsName;
	local string goodsIconTexture;
	local ItemID cID;

	local INT64 goodsID;
	local INT64 goodsDeliveryDate;
	local bool bNoSelect;
	local array<GoodsItem> noDateGoodsItemArray;

	if ( GoodsItemArray.Length > 0 )
		GoodsItemArray.Remove (0,GoodsItemArray.Length);

	ParseInt(param, "goodsTotal", goodsTotal); // °иБ¤їЎ АЇАъ°Ў јТАЇЗС ГС »уЗ° јц
	ParseInt(param, "goodsCount", goodsCount); // ЗцАз ј­№цїЎј­ іС°ЬБШ »уЗ° јц

	// °иБ¤АЗ ГС јц·®А» єёї©БЬ
	// ГСјц·®:
	ProductItemListTotal.SetText(GetSystemString(2512) $ " : " $ goodsTotal);
	
	// ЖЛѕчАМ И¤ЅГ іІѕЖ АЦАёёй јы±в°н, ёс·ПА» »иБ¦ ЗСґЩ.
	if (ProductItemList_Lc.GetRecordCount() > 0) ProductItemList_Lc.DeleteAllItem();

	// ѕЖАМЕЫАМ 0°іёй, єсИ°јє »уЕВё¦ єёї©БЬ.
	if (goodsCount <= 0) 
	{
		initUI();
		NoticeWnd(GetScript("NoticeWnd"))._RemoveNoticButtonProductInventory();
		return;
	}

	// №ЮАє ѕЖАМЕЫА» ЗПіЄѕї »уЗ° ёс·П ё®ЅєЖ®їЎ ГЯ°Ў
	for( i = 0 ; i < goodsCount ; i++)
	{
		ParseInt(param, "goodsType_"$i			, goodsType );
		ParseInt(param, "goodsIconID_"$i		, goodsIconID );
		ParseInt(param, "goodsCondition_"$i		, goodsCondition );
		ParseInt(param, "goodsIsGift_"$i		, goodsIsGift );
		ParseINT64(param,"goodsID_"$i			, goodsID);
		ParseINT64(param,"goodsDeliveryDate_"$i	, goodsDeliveryDate);

		ParseString(param, "goodsName_"$i  , goodsName );

		goodsName = makeShortStringByPixel(goodsName, 290, "..");

		// Г»ѕа Г¶Иё °ЎґЙ ѕЖАМЕЫ 		
		if( goodsType == 0 )
		{
			cID = GetItemID( goodsIconID );
			goodsIconTexture = class'UIDATA_ITEM'.static.GetItemTextureName( cID );
		}
		// Г»ѕа Г¶Иё єТ°Ў ѕЖАМЕЫ
		else
		{
			goodsIconTexture = GetGoodsIconName( goodsIconID );
		}

		//-------------------
		// testcode
		//goodsCondition = 1;
		//goodsIsGift = 1;		
		//-------------------

		if ( goodsDeliveryDate > 0 )
		{
			GoodsItemArray.Insert( GoodsItemArray.Length, 1 );
			GoodsItemArray[GoodsItemArray.Length - 1].goodsName = goodsName;
			GoodsItemArray[GoodsItemArray.Length - 1].goodsType = goodsType;
			GoodsItemArray[GoodsItemArray.Length - 1].goodsIconID = goodsIconID;
			GoodsItemArray[GoodsItemArray.Length - 1].goodsCondition = goodsCondition;
			GoodsItemArray[GoodsItemArray.Length - 1].goodsIsGift = goodsIsGift;
			GoodsItemArray[GoodsItemArray.Length - 1].goodsID = goodsID;
			GoodsItemArray[GoodsItemArray.Length - 1].goodsDeliveryDate = goodsDeliveryDate;
			GoodsItemArray[GoodsItemArray.Length - 1].goodsIconTexture = goodsIconTexture;
			GoodsItemArray[GoodsItemArray.Length - 1].seqID = i;
		}
		else
		{
			noDateGoodsItemArray.Insert( noDateGoodsItemArray.Length, 1 );
			noDateGoodsItemArray[GoodsItemArray.Length - 1].goodsName = goodsName;
			noDateGoodsItemArray[GoodsItemArray.Length - 1].goodsType = goodsType;
			noDateGoodsItemArray[GoodsItemArray.Length - 1].goodsIconID = goodsIconID;
			noDateGoodsItemArray[GoodsItemArray.Length - 1].goodsCondition = goodsCondition;
			noDateGoodsItemArray[GoodsItemArray.Length - 1].goodsIsGift = goodsIsGift;
			noDateGoodsItemArray[GoodsItemArray.Length - 1].goodsID = goodsID;
			noDateGoodsItemArray[GoodsItemArray.Length - 1].goodsDeliveryDate = goodsDeliveryDate;
			noDateGoodsItemArray[GoodsItemArray.Length - 1].goodsIconTexture = goodsIconTexture;
			noDateGoodsItemArray[GoodsItemArray.Length - 1].seqID = i;
		}
	}

	if ( GoodsItemArray.Length > 0 )
		GoodsItemArray.Sort( OnSortCompare );

	if ( noDateGoodsItemArray.Length > 0 )
		noDateGoodsItemArray.Sort( OnSortCompareNoDate );

	for ( i = 0; i < noDateGoodsItemArray.Length; i++ )
		GoodsItemArray[GoodsItemArray.Length] = noDateGoodsItemArray[i];

	for ( i = 0; i < GoodsItemArray.Length; i++)
		addProductItemList(GoodsItemArray[i].goodsType,GoodsItemArray[i].goodsIconID,GoodsItemArray[i].goodsCondition,GoodsItemArray[i].goodsIsGift,GoodsItemArray[i].goodsIconTexture,GoodsItemArray[i].goodsName,GoodsItemArray[i].seqID);

	if (goodsCount > 0)
	{
		Debug("GoodsItemArray : "@string(GoodsItemArray.Length));
		Debug("ProductItemList_Lc.GetRecordCount()"@string(ProductItemList_Lc.GetRecordCount()));

		// ГіАЅ АМёй Г№№шВ° ѕЖАМЕЫ ёс·ПА» ј±ЕГЗПµµ·П ЗСґЩ.
		if (selectedProductListIndex == -1)
		{
			selectedProductListIndex = 0;
		}
		// ёЗ ЗПґЬ ѕЖАМЕЫАМ ј±ЕГµЗѕо АЦА»¶§, №ЮА» ѕЖАМЕЫ јц·®АМ БЩѕо µйёй ЗСД­ѕї А§·О єёБ¤.
		else if (selectedProductListIndex >= ProductItemList_Lc.GetRecordCount())
		{
			if ( lastResultGoodsItemNum <= ProductItemList_Lc.GetRecordCount() )
			{
				selectedProductListIndex = ProductItemList_Lc.GetRecordCount() - 1;
				Debug("아이템 수량이 넘은 경우:"@string(selectedProductListIndex));
			}
			else
			{
				bNoSelect = true;
				Debug("비정상적인 값 오는 경우 lastResultGoodsItemNum :"@string(lastResultGoodsItemNum));
			}
		}
		if ( bNoSelect == false )
		{
			ProductItemList_Lc.SetSelectedIndex(selectedProductListIndex,true);
			// АЪµїАё·О БцБ¤ЗС »уЗ° »ујј Б¤єёё¦ їдГ»
			RequestGoodsInventoryItemDesc(getSelectedItemSeqNum());
			Debug("API CALL ---> RequestGoodsInventoryItemDesc( " @ string(getSelectedItemSeqNum()) @ ")");
			Debug("selectedProductListIndex"@string(selectedProductListIndex));
		}
		hideDisableWnd();
	}
	else
	{
		ShowDisableWnd(false);
	}
}

delegate int OnSortCompare (GoodsItem A, GoodsItem B)
{
	if ( A.goodsDeliveryDate < B.goodsDeliveryDate )
		return -1;
	else
		return 0;
}

delegate int OnSortCompareNoDate (GoodsItem A, GoodsItem B)
{
	if ( A.goodsID < B.goodsID )
		return -1;
	else
		return 0;
}

// »уЗ° ёс·П, ё®ЅєЖ®їЎ ГЯ°Ў
function addProductItemList(int goodsType, int goodsIconID, int goodsCondition, int goodsIsGift, string goodsIconTexture, string goodsName, int seqID)
{
	local RichListCtrlRowData RowData;

	RowData.cellDataList.Length = 2;
	
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, goodsIconTexture, 32,32, 5);

	/// ИЇєТ °ЎґЙ
	if (goodsCondition == 1)
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, goodsName, util.Yellow,false,5,10);
	}
	// АП№Э »уЗ°
	else
	{
		addRichListCtrlString(RowData.cellDataList[0].drawitems, goodsName, util.White, false, 5,10);
	}

	// ј±№° ї©єО, ј±№° АМёй ёс·ПїЎ ѕЖАМДЬА» ±Чё°ґЩ.
	if (goodsIsGift > 0) addRichListCtrlTexture(RowData.cellDataList[1].drawitems, "L2UI_CT1.ProductInventory.ProductInventory_GiftIcon", 16, 16);

	rowData.nReserved1 = seqID;

	//  ItemInfoToParam(GetItemInfoByClassID(goodsIconID), RowData.szReserved);
	ProductItemList_Lc.InsertRecord(RowData);
}

//// Змґх °°Ає ё®ЅєЖ®ё¦ ГЯ°Ў ЗСґЩ.
//function addListWarningUCanGetMoreItem()
//{
//	//local RichListCtrlCellData Data;
//	local RichListCtrlRowData RowData;

//	RowData.cellDataList.length = 1;
//	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_CT1.List_HeadLineFrame", 450, 45,0,0, 32, 19);
//	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetSystemString(3922), util.BrightWhite, false, -330, 20);
//	ProductItemList_Lc.InsertRecord(RowData);
//}

// -------------------------------------------------
// »уЗ° АОєҐЕдё® ѕЖАМЕЫ °іє° »ујј Б¤єё 
//
// Event : EV_GoodsInventoryItemDesc
//
// 5602
// 
// -------------------------------------------------
function OnGoodsInventroyItemDesc( string param )
{
	local int i;

	local int index;
	//»уЗ° ЕёАФ(0:єсЕё№О,1:»уЗ°ѕЖАМДЬ)
	local int goodsType;	
	//»уЗ° IconIDc
	local int goodsIconID;
	//»уЗ°АМё§
	local string goodsName;

	//0:ИЇєТєТ°Ў, 1:ИЇєТ °ЎґЙ
	local int goodsCondition;

	//»уЗ°јіён
	local string goodsDesc;
	//0:ј±№° ѕЖАМЕЫ ѕЖґФ, 1:ј±№° ѕЖАМЕЫ
	local int goodsGift;
	//ј±№° єёіЅАМ
	local string goodsSender;
	//ј±№° ёЮЅГБц
	local string goodsSenderMessage;
	//»уЗ° ±ёёЕ АПЅГ
	local string goodsDate;

	//°ФАУ ѕЖАМЕЫ ё®ЅєЖ®АЗ °іјц
	local int gameItemCount;
	//°ФАУ ѕЖАМЕЫАЗ Е¬·ЎЅє ID( А§АЗ °№јц ёёЕ­ )
	local int gameItemClassID;
	//°ФАУ ѕЖАМЕЫ јц·®
	local int gameItemQuantity;
	local string goodsNameShort;
	local ItemID cID;

	local string pIconTexture;

	ParseInt(param, "index", index);

	Debug("ё®ЅєЖ® ј±ЕГ Б¤єё index :" @ index);
	
	if( index == -1 )
	{
		selectedProductItemName = "";
		selectedProductItemIcon = "";
		selectedGoodsCondition = -1;
		return;
	}

	SelectItemNum = index;

	// »уЗ° јіБ¤ °Є
	ParseInt(param, "gameItemCount"  ,gameItemCount);
	ParseInt(param, "goodsType"      ,goodsType);
	ParseInt(param, "goodsIconID"    ,goodsIconID);
	ParseInt(param, "goodsCondition" ,goodsCondition);
	ParseInt(param, "goodsGift"      ,goodsGift);

	// »уЗ° АМё§, јіён, іЇВҐ
	ParseString(param, "goodsName"         , goodsName);	
	ParseString(param, "goodsDesc"         , goodsDesc);
	ParseString(param, "goodsDate"         , goodsDate);

	// ј±№° єёіЅ »з¶ч, ј±№° ёЮјјБц
	ParseString(param, "goodsSender"       , goodsSender);	
	ParseString(param, "goodsSenderMessage", goodsSenderMessage);	
	
	// »уЗ° №ЪЅєѕИ ѕЖАМЕЫ ёс·П АьГј »иБ¦
	ProductItemDetailListTitle_Lc.DeleteAllItem();
	
	// »уЗ° ЕёАФ 0:єсЕё№О
	if( goodsType == 0 )
	{
		pIconTexture = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(goodsIconID));
		
	}
	// »уЗ° ЕёАФ 1:»уЗ°ѕЖАМДЬ
	else
	{
		pIconTexture = GetGoodsIconName(goodsIconID);		
	}

	ProductItem.ShowWindow();
	ProductItem.SetTexture(pIconTexture);

	 // »уЗ° АМё§
	// ±жёй ".." Гіё® 
	goodsNameShort = makeShortStringByPixel(goodsName, 300, "..");
	ProductItemText.SetText(goodsNameShort);

	// ±жёй ЕшЖБАМ іЄїАµµ·П ЗСґЩ.
	if (goodsName != goodsNameShort)
	{
		ProductItemText.SetTooltipType("text");
		ProductItemText.SetTooltipText(goodsName);
	}
	else 
	{
		ProductItemText.ClearTooltip();
	}

	//--------------------
	// testCode
	//goodsCondition = 1;
	//goodsSender = "ј±№°єёіЅАМ";
	//goodsSenderMessage = "АЯЅб¶у!";
	//--------------------
	
	// 1 :ИЇєТ °ЎґЙ
	if( goodsCondition == 1 )
	{
		ProductItemText.SetTextColor(util.Yellow);
	}
	// 0,2 :ИЇєТєТ°Ў  
	// goodsCondition == 2ґВ ј­№цВКїЎ №®АЗ ЗШєБµµ 0,1 АМ¶у°н ЗСґЩ. ±Ч·Ўј­ else ·О єЇ°ж ЗШіхґВґЩ.
	else
	{
		ProductItemText.SetTextColor(util.White);
	}
	
	selectedGoodsCondition = goodsCondition;

	//»уЗ° јіён	
	if (len(goodsDesc) > 0)
	{
		ProductItemDiscription.ShowWindow();

		// јіёнА» іЦґВґЩ.
		ProductItemDiscription.LoadHtmlFromString(htmlSetHtmlStart(htmlAddText(goodsDesc, "GameDefault", "afb9cd")));
	}
	else
	{
		// °ЄАМ ѕшАёёй јіён, html°ъ bgё¦ јы±дґЩ.
		ProductItemDiscription.HideWindow();
	}

	// ј±№° ѕЦґП И°јєИ­ ї©єО, ЕшЖБ јјЖГ (ј±№° єёіЅАМ, ёЮјјБц)
	if (Len(goodsSender) > 0)
	{
		// ј±№° »уАЪ ѕЦґПёЮАМјЗ ·зЗБ Аз»э
		ProductItem_Msg.ShowWindow();
		ProductItem_Msg.SetLoopCount(999999);
		ProductItem_Msg.Stop();
		ProductItem_Msg.Play();

		// ј±№° ѕЖАМДЬА» ·С їА№ц ЗПёй ЕшЖБ іЄїАµµ·П
   		ProductItem_Msg.SetTooltipCustomType(MakeTooltipMultiText("[" $ GetSystemString(2473) $ "]", util.White, "", true, GetSystemString(1740) $ goodsSender, util.Gold, "",true,goodsSenderMessage, util.ColorDesc, "",true,200));
	}
	else
	{
		ProductItem_Msg.Stop();
		ProductItem_Msg.Pause();
		ProductItem_Msg.HideWindow();
	}

	// »уЗ° ГЯ°Ў Б¤єё 
	ProductBuyInfo.SetText( goodsDate );

	// »уЗ°ѕЖАМЕЫА» ±оёй іЄїАґВ ѕЖАМЕЫ ёс·П
	for( i = 0; i < gameItemCount; i++ )
	{
		ParseInt( param, "gameItemClassID_" $ i, gameItemClassID );
		ParseInt( param, "gameItemQuantity_"$ i, gameItemQuantity );

		cID = GetItemID( gameItemClassID );
		
		//MakeTreeNode( cID, class'UIDATA_ITEM'.static.GetItemName( cID ) , i , gameItemClassID, gameItemQuantity );

		addProductBoxInsideItemList(cID, class'UIDATA_ITEM'.static.GetItemName( cID ) , i , gameItemClassID, gameItemQuantity );
	}

	selectedProductItemName = class'UIDATA_ITEM'.static.GetItemName( cID );
	selectedProductItemIcon = pIconTexture;
	
	// »уЗ° ѕЖАМЕЫ јц·® ЗҐЅГ 
	ProductItemDetailListCounter.SetText("("$string(gameItemCount)$")");

	// ґЩЅГ »уЗ° ёс·ПїЎ ЖчДїЅєё¦ БШґЩ. 
	ProductItemList_Lc.setFocus();

	RecieveBtn.EnableWindow();
}

// »уЗ° ёс·П №ЪЅєѕИїЎ ЖчЗФµИ ѕЖАМЕЫ ёс·П, ё®ЅєЖ®їЎ ГЯ°Ў
function addProductBoxInsideItemList(ItemID cID, string goodsName, int index, int gameItemClassID, int itemnum)
{
	local RichListCtrlRowData RowData;
	local ItemInfo tmItemInfo;

	RowData.cellDataList.Length = 1;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, class'UIDATA_ITEM'.static.GetItemTextureName(cID), 32,32, 5);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, goodsName $ " (" $ String(itemnum) $ ")", util.White, false, 5,10);
	tmItemInfo = GetItemInfoByClassID(gameItemClassID);

	if (itemnum > 0) tmItemInfo.ItemNum = itemnum;

	// ЕшЖБ Б¤єёё¦ іЦ±в
	ItemInfoToParam(tmItemInfo, RowData.szReserved);

	// »уЗ° ±ёјєїЎ ѕЖАМЕЫ ГЯ°Ў
	ProductItemDetailListTitle_Lc.InsertRecord(RowData);
}

/**
 * ї№їЬ Гіё® №Ч °б°ъ Гіё®.
 */
function OnGoodsInventoryResult( string param )
{
	local int Result;

	ParseInt(param, "Result", Result);
	
	// И¤ЅГ¶уµµ »уЗ° јц·Й ЖЛѕчАМ ґЭИчБц ѕКѕТА» °жїм ґЭ±в
	if(ProductInventoryConfirmWnd.IsShowWindow()) ProductInventoryConfirmWnd.HideWindow();

	// 1 Б¶Иёјє°ш, -7 °ијУ БшЗа (ґЭ±в ѕИЗФ)
	if( Result == 1 || Result == -7)
	{
		//»уЗ°Б¶Иё јє°ш	
		return;
	}	
	else if( Result == 2 )
	{
		lastResultGoodsItemNum = GoodsItemArray.Length - 1;
		//»уЗ° јц·Й јє°ш
		AddSystemMessage( 3412 );
		RequestGoodsInventoryItemList();
		Debug("API CALL ---> RequestGoodsInventoryItemList()");
		
		ShowDisableWnd(true);
		return;

		//DescHide();
	}

	Debug("result --> selectedProductListIndex" @ selectedProductListIndex);

	/**
	 * Server Error
	 */
	if( Result < 0 )
	{
		// Me.HideWindow();
		//DescHide();

		if( Result == -1 )
		{
			//АЯёшµИ їдГ» (°ўБѕ їА·щ)
			//3377 : їдГ»АМ АЯёшµЗѕъЅАґПґЩ.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3377), string(self) );
		}
		else if( Result == -2 )
		{
			//ѕЛ јц ѕшґВ ЅГЅєЕЫ їА·щ
			//3385 : ЅГЅєЕЫ їА·щ·О »уЗ° АОєҐЕдё®ё¦ АМїлЗПЅЗ јц ѕшЅАґПґЩ. АбЅГ ИД ґЩЅГ ЅГµµЗШБЦјјїд.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3385), string(self) );
		}
		else if( Result == -3 )
		{
			//°ФАУ АОєҐЕдё® їл·® ГК°ъ
			//3386 : °ФАУ АОєҐЕдё®АЗ №«°Ф/јц·® Б¦ЗСА» ГК°ъЗПї© »уЗ°А» №ЮА» јц ѕшЅАґПґЩ. АОєҐЕдё®АЗ №«°Ф/јц·®АМ 80ЖЫјѕЖ® №МёёАП ¶§ёё №ЮА» јц АЦЅАґПґЩ.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3386), string(self) );
		}
		else if( Result == -4 )
		{
			//SA ј­№ц БўјУ єТ°Ў
			//3411 : ЗцАз »уЗ° °ьё® ј­№цїЎ БўјУЗТ јц ѕшЅАґПґЩ. АбЅГ ИД ґЩЅГ ЅГµµЗШБЦјјїд.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3411), string(self) );
		}
		else if( Result == -5 )
		{
			//ЗцАз °Е·Ў БЯ
			//3413 : °Е·Ў БЯ, °іАО »уБЎ №Ч °ш№ж °іјі БЯїЎґВ »уЗ° АОєҐЕдё®ё¦ АМїлЗПЅЗ јц ѕшЅАґПґЩ.
			//AddSystemMessage( 3413 );
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3413), string(self) );
		}
		else if( Result == -6 )
		{
			//јц·Й ЗТ »уЗ° БёАзЗПБц ѕКАЅ
			//3417 : ЗцАз »уЗ° АОєҐЕдё® і»їЎ јц·ЙЗТ »уЗ°АМ БёАзЗПБц ѕКЅАґПґЩ.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3417), string(self) );
		}

		else if( Result == -8 )
		{
			// ѕЖЖјЖСЖ® АОєҐЕдё® їл·® ГК°ъ
			// ѕЖЖјЖСЖ® АОєҐЕдё® °ш°ЈАМ єОБ·ЗХґПґЩ. АОєҐЕдё®АЗ јц·®АМ 80ЖЫјѕЖ® №МёёАП ¶§ёё БшЗаЗТ јц АЦЅАґПґЩ.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(5213), string(self) );
		}
		else if( Result == -9 )
		{
			//јц·Й ЗТ »уЗ° БёАзЗПБц ѕКАЅ
			//АП№Э АОєҐЕдё® №Ч ѕЖЖјЖСЖ® АОєҐЕдё® °ш°ЈАМ єОБ·ЗХґПґЩ. АОєҐЕдё®АЗ №«°Ф/јц·®АМ 80ЖЫјѕЖ® №МёёАП ¶§ёё БшЗаЗТ јц АЦЅАґПґЩ.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(5212), string(self) );
		}

		/**
		 * SA Error
		 */
		else if( Result == -101 )
		{
			//ЗцАз Гіё® БЯАО АЫѕчАМ ё№ѕЖ »уЗ° АОєҐЕдё®ё¦ °»ЅЕЗТ јц ѕшАЅ. (-101)
			//ЗцАз АМїлАЪ°Ў ё№ѕЖ »уЗ° АОєҐЕдё®ё¦ Б¶ИёЗТ јц ѕшЅАґПґЩ. АбЅГ ИД ґЩЅГ ЅГµµЗШБЦјјїд.
			//DialogShow( DIALOG_Modalless, DIALOG_Notice, "ЗцАз АМїлАЪ°Ў ё№ѕЖ »уЗ° АОєҐЕдё®ё¦ Б¶ИёЗТ јц ѕшЅАґПґЩ. АбЅГ ИД ґЩЅГ ЅГµµЗШБЦјјїд." );
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3378), string(self) );
		}
		else if( Result == -102 )
		{
			//јц·Й ЅГ SA ј­№ц »зїлАЪ ё№АЅ
			//3410 : ЗцАз АМїлАЪ°Ў ё№ѕЖ »уЗ°А» јц·ЙЗПЅЗ јц ѕшЅАґПґЩ. АбЅГ ИД ґЩЅГ ЅГµµЗШБЦјјїд.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3410), string(self) );
		}
		else if( Result == -103 )
		{
			//АМАь АЫѕч БшЗа БЯ
			//3379 : АМАь їдГ»АМ ѕЖБч їП·бµЗБц ѕКѕТЅАґПґЩ. АбЅГ ±вґЩ·ББЦјјїд.
			//AddSystemMessage( 3379 );
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3379), string(self) );
		}
		else if( Result == -104 )
		{
		}
		else if( Result == -105 )
		{
			//їд±ё »уЗ° АМ№М Г»ѕаГ¶Иё
			//3381 : »уЗ°АМ АМ№М Г»ѕаГ¶Иё Гіё®µЗѕъЅАґПґЩ.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3381), string(self) );
		}
		else if( Result == -106 )
		{
			//їд±ё »уЗ° АМ№М јц·Й
			//3382 : »уЗ°А» АМ№М јц·ЙЗПјМЅАґПґЩ.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3382), string(self) );
		}
		else if( Result == -107 )
		{
			//»уЗ°А» јц·ЙЗТ јц ѕшґВ їщµе
			//3383 : АМ ј­№цїЎј­ґВ ј±ЕГЗПЅЕ »уЗ°А» јц·ЙЗПЅЗ јц ѕшЅАґПґЩ.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3383), string(self) );
		}
		else if( Result == -108 )
		{
			//»уЗ°А» јц·ЙЗТ јц ѕшґВ ДіёЇЕН
			//3384 : АМ ДіёЇЕН·ОґВ ј±ЕГЗПЅЕ »уЗ°А» јц·ЙЗПЅЗ јц ѕшЅАґПґЩ.
			DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3384), string(self) );
		}

		// -- Вь°н --
		// їЎ·Ї°Ў ЗС№шёё µйѕо їАёй Гў °»ЅЕµоА» ЕлЗШј­ ґЩАМѕу·О±Ч ёЮјјБц АМИД ґЩЅГ АЫѕч ЗПµµ·П ЗШµµ µЗґВµҐ
		// їЎ·ЇµйАМ ёо№шАМ µйѕо їГБц ёрёЈґВ »уИІАМ¶у ГўА» ґЭµµ·П ї№Аь ДЪµе ±Чґл·О іІ°ЬµТ.
		Me.HideWindow();
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
// OnClickButton
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnClickButton(string Name)
{
	local int itemSelectNum;

	switch(Name)
	{
		case "HelpHtmlBtn":
			if(GetWindowHandle("ProductInventoryHelpHtmlWnd").IsShowWindow())
			{
				GetWindowHandle("ProductInventoryHelpHtmlWnd").HideWindow();				
			}
			else
			{
				ProductInventoryHelpHtmlWnd(GetScript("ProductInventoryHelpHtmlWnd")).ShowHelp("..\\L2text\\product_inventory_help00.htm");
			}
			break;
		case "RecieveBtn":
			OnRecieveBtnClick();
			break;
		case "CloseBtn":
			OnCloseBtnClick();
			break;

		// і»єО ґЩАМѕу·О±Ч 
	    case "OK_Button":
			// Г»ѕаГ¶Иё °ЎґЙ ѕЖАМЕЫАє ЖЛѕчАё·О №°ѕо єё°н okё¦ ґ©ёЈёй БшЗа
			itemSelectNum = getSelectedItemSeqNum();
			if ( itemSelectNum > -1 )
			{
				RequestUseGoodsInventoryItem(itemSelectNum);
				Debug("API CALL ---> RequestUseGoodsInventoryItem( " @ itemSelectNum @ ")");
				ProductInventoryConfirmWnd.HideWindow();
				ShowDisableWnd(true);
			}
			break;
		case "Cancel_Button":
			ProductInventoryConfirmWnd.HideWindow();
			hideDisableWnd();
			break;
		case "GiftTab_Btn":
			Me.HideWindow();
			getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "GiftInventoryWnd");
			ShowWindow("GiftInventoryWnd");
			// End:0x223
			break;
	}
}

function int getSelectedItemSeqNum()
{
	local int idx;
	local RichListCtrlRowData RowData;

	idx = ProductItemList_Lc.GetSelectedIndex();
	// End:0x2A
	if(idx <= -1)
	{
		return -1;
	}
	ProductItemList_Lc.GetRec(idx, RowData);
	return int(RowData.nReserved1);	
}

function OnRecieveBtnClick()
{
	local int itemSelectNum;
	//selectedProductListIndex
	if( selectedProductListIndex != -1 )
	{
		if( selectedGoodsCondition == 1)
		{
			// GetSystemMessage(3387);
			//ј±ЕГЗПЅЕ »уЗ° ѕЖАМЕЫА» є»АО ДіёЇЕНАЗ АОєҐЕдё®їЎј­ јц·ЙЗП°Ф µЗёй ЗШґз ѕЖАМЕЫА» »зїлЗС °НАё·О °ЈБЦµЗѕо Г»ѕаГ¶Иё°Ў Б¦ЗСµЛґПґЩ.\\n\\nБ¤ё»·О ј±ЕГЗС ѕЖАМЕЫА» јц·ЙЗПЅГ°ЪЅАґП±о?"

			// јц·ЙЗТ ѕЖАМЕЫ ѕЖАМДЬ, АМё§ 
			GetTextureHandle("ProductInventoryWnd.ProductInventoryConfirmWnd.Result_ItemWnd").SetTexture(selectedProductItemIcon);
			GetTextBoxHandle("ProductInventoryWnd.ProductInventoryConfirmWnd.ItemName_TextBox").SetText(selectedProductItemName);
			ShowDisableWnd(true);
			ProductInventoryConfirmWnd.SetFocus();
			ProductInventoryConfirmWnd.ShowWindow();
		}
		else
		{
			RecieveBtnAni.Stop();
			RecieveBtnAni.SetLoopCount(1);
			RecieveBtnAni.Play();

			itemSelectNum = getSelectedItemSeqNum();
			if(itemSelectNum > -1)
			{
				RequestUseGoodsInventoryItem(itemSelectNum);
				Debug("API CALL ---> RequestUseGoodsInventoryItem( " @ itemSelectNum @ ")");
				ProductInventoryConfirmWnd.HideWindow();
				ShowDisableWnd(true);
			}
		}
	}
}

function OnCloseBtnClick()
{
	Me.HideWindow();
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
// CallBack Function
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
function OnClickListCtrlRecord(String strID)
{
	local int Idx;
	local RichListCtrlRowData RowData;

	Debug("strID : " @ strID);
	if( strID == "ProductItemList_Lc")
	{
		Idx = ProductItemList_Lc.GetSelectedIndex();

		if (Idx <= -1) return;

		// АМАьїЎ Е¬ёЇ ЗЯґш°Еёй ѕЖ№«°Нµµ ѕИЗФ
		if (selectedProductListIndex == Idx) return;

		ProductItemList_Lc.GetRec( Idx, RowData );

		////RowData.cellDataList[0].szData
		//loc.x = RowData.cellDataList[0].nReserved1;
		//loc.y = RowData.cellDataList[0].nReserved2;
		//loc.z = RowData.cellDataList[0].nReserved3;
		
		if ( rowData.nReserved1 > -1 )
		{
			selectedProductListIndex = idx;
			RequestGoodsInventoryItemDesc(int(rowData.nReserved1));
		}

	//	RequestGoodsInventoryItemDesc( Idx );
	//	Debug("API CALL ---> RequestGoodsInventoryItemDesc(" @ Idx @ ")");

		//selectedProductListIndex = Idx;
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------------------
// UTIL
//----------------------------------------------------------------------------------------------------------------------------------------------------------------

function ShowDisableWnd(bool bAllDisableType)
{
	if (bAllDisableType)
	{
		DisableWndAll.ShowWindow();
		DisableWndAll.SetFocus();
		DisableWndList.HideWindow();
	}
	else
	{
		DisableWndAll.HideWindow();
		DisableWndList.ShowWindow();
		DisableWndList.SetFocus();
	}
}

function hideDisableWnd()
{
	DisableWndAll.HideWindow();
	DisableWndList.HideWindow();
}


/**
 * А©µµїм ESC Е°·О ґЭ±в Гіё® 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{		
	GetWindowHandle(getCurrentWindowName (string(Self))).HideWindow();
}

defaultproperties
{
}
