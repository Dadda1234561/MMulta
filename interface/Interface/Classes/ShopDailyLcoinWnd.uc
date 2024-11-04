/**
 *   클래식 엘코인 상점 (라이브용)
 **/

class ShopDailyLcoinWnd extends UICommonAPI;

struct SelectedCategoryInfo
{
	var int ItemClassID;
	var int SlotNum;
};

struct LimitShopItemInfo
{
	var int ItemClassID;
	var int ReseetType;
	var int ConditionLevel;
	var int MaxItemAmount;
	var int CostItemNum;
	var array<int> CostItemId;
	var array<INT64> CostItemAmount;
	var array<INT64> CostItemSaleAmount;
	var array<float> CostItemSaleRate;
	var INT64 SellCostAdena;
	var INT64 SellCostCoin;
	var int RemainItemAmount;
	var int SellCategory;
	var int EventType;
	var int EventRemainSec;
	var int SlotNum;
};

// ShopDailyWnd
var WindowHandle Me;
// 전체 보기 체크 박스 
var CheckBoxHandle ListOption_CheckBox;
// 상품 리스트
//var ListCtrlHandle ShopDaily_ListCtrl;


//필요 아이템 아이콘
var ItemWindowHandle NeededItem_Item1Num_Item;
//아이템 이름
var TextBoxHandle NeededItem_Item1_Title;
// 필요 아이템 수 
var TextBoxHandle NeededItem_Item1Num_text;
// 필요 아이템 내 수
var TextBoxHandle NeededItem_Item1MyNum_text;

//필요 아이템 아이콘
var ItemWindowHandle NeededItem_Item2Num_Item;
//아이템 이름
var TextBoxHandle NeededItem_Item2_Title;
// 필요 아이템 수 
var TextBoxHandle NeededItem_Item2Num_text;
// 필요 아이템 내 수
var TextBoxHandle NeededItem_Item2MyNum_text;

//필요 아이템 아이콘
var ItemWindowHandle NeededItem_Item3Num_Item;
//아이템 이름
var TextBoxHandle NeededItem_Item3_Title;
// 필요 아이템 수 
var TextBoxHandle NeededItem_Item3Num_text;
// 필요 아이템 내 수
var TextBoxHandle NeededItem_Item3MyNum_text;

var TextureHandle CostItem01_Sale;
var TextureHandle CostItem02_Sale;
var TextureHandle CostItem03_Sale;

var TextBoxHandle CostItem01Sale_TextBox;
var TextBoxHandle CostItem02Sale_TextBox;
var TextBoxHandle CostItem03Sale_TextBox;


// 아이템 수 입력 창
var EditBoxHandle ItemCount_EditBox;
// 초기화 버튼
var ButtonHandle Reset_Btn;
// 충전 버튼???
var ButtonHandle Buy_Btn;
// 업 버튼
var ButtonHandle MultiSell_Up_Button;
// 아래 버튼
var ButtonHandle MultiSell_Down_Button;
// 입력 버튼
var ButtonHandle MultiSell_Input_Button;
// 도움말 버튼
var ButtonHandle FrameHelp_BTN;


// 비활성 윈도우
var WindowHandle DisableWnd;

// 리프래시 버튼
var ButtonHandle Refresh_Button;

// 아이템 수
var TextBoxHandle ItemNum_TextBox;

// 결과 창 들
var WindowHandle ShopDailyConfirm_ResultWnd;
var WindowHandle ShopDailySuccess_ResultWnd;
var WindowHandle ShopDailyFails_ResultWnd;

//탭 삭제용
var	TabHandle			LcoinShopList_Tab;
var TextureHandle       tabbgLine;

var string m_WindowName ;

const DIALOG_ASK_PRICE                     = 10111;		

const MAX_CATEGORY                         = 6;		

var int shopIndexCurrent ;

var int64 bloodCoinCount ;

// 현재 카테고리, 탭 번호 ~ 1,2,3 4, 장비, 소모품, 기간제, 기타

var int currentShopCategory;

var array<SelectedCategoryInfo> selectedCategoryInfoArray;


//struct ShopDailyItemInfo
//{
//	var LVDataRecord        record;
//	//var int			        sort0;
//	//var int			        sort1;	
//};

// pc방 포인트
var int   pcCafePoint;


//리스트 저장 배열 ( 체크 상태에 따라 보여지거나 안보여 질 수 있으므로, 
var array<LimitShopItemInfo> itemListArray;

var L2Util util;

//var ItemInfo SelectItemInfo;


//목록 갱신용 타이머 ID
const TIMER_CLICK       = 99902;
//목록 갱신용 타이머 딜레이 3초
const TIMER_DELAYC       = 3000;

const TIMER_FOCUS       = 99903;

const TIMER_FOCUS_DELAY = 100;

// 오른 쪽에 아이템 정보에 보여지고 있는 아이템 ID
//var int itemInfosClassID ;

// 구입 할 수 있는 최대 크기 
const MAXITEMNUM  = 99999;

// 구입 비용을 채울때 쓰는 변수 
//var int needItemCount;

function Initialize()
{	
	local int i;

	Me = GetWindowHandle( m_WindowName );

	ListOption_CheckBox = GetCheckBoxHandle( m_WindowName $ ".List_Wnd.ListOption_CheckBox" );

	//ShopDaily_ListCtrl = GetListCtrlHandle( m_WindowName $ ".List_Wnd.List_ListCtrl" );

	NeededItem_Item1Num_Item = GetItemWindowHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem01_ItemWindow" );
	NeededItem_Item1_Title = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem01Title_TextBox" );
	NeededItem_Item1Num_text = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem01NumTitle_TextBox" );
	NeededItem_Item1MyNum_text = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem01MyNumTitle_TextBox" );	

	NeededItem_Item2Num_Item = GetItemWindowHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem02_ItemWindow" );
	NeededItem_Item2_Title = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem02Title_TextBox" );
	NeededItem_Item2Num_text = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem02NumTitle_TextBox" );
	NeededItem_Item2MyNum_text = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem02MyNumTitle_TextBox" );

	NeededItem_Item3Num_Item = GetItemWindowHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem03_ItemWindow" );
	NeededItem_Item3_Title = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem03Title_TextBox" );
	NeededItem_Item3Num_text = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem03NumTitle_TextBox" );
	NeededItem_Item3MyNum_text = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem03MyNumTitle_TextBox" );	

	CostItem01Sale_TextBox = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem01Sale_TextBox" );
	CostItem02Sale_TextBox = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem01Sale_TextBox" );
	CostItem03Sale_TextBox = GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem01Sale_TextBox" );


	ItemCount_EditBox = GetEditBoxHandle( m_WindowName $ ".ItemInfo_Wnd.ItemCount_EditBox" );

	Reset_Btn = GetButtonHandle( m_WindowName $ ".ItemInfo_Wnd.Reset_Btn" );
	Buy_Btn = GetButtonHandle( m_WindowName $ ".ItemInfo_Wnd.Buy_Btn" );
	MultiSell_Up_Button = GetButtonHandle( m_WindowName $ ".ItemInfo_Wnd.MultiSell_Up_Button" );
	MultiSell_Down_Button = GetButtonHandle( m_WindowName $ ".ItemInfo_Wnd.MultiSell_Down_Button" );
	MultiSell_Input_Button = GetButtonHandle( m_WindowName $ ".ItemInfo_Wnd.MultiSell_Input_Button" );
	FrameHelp_BTN = GetButtonHandle( m_WindowName $ ".ItemInfo_Wnd.FrameHelp_BTN" );
	DisableWnd = GetWindowHandle( m_WindowName $ ".DisableWnd" );

	Refresh_Button = GetButtonHandle( m_WindowName $ ".ListRefesh_Btn" );

	ShopDailyConfirm_ResultWnd = GetWindowHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd" );
	ItemNum_TextBox = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.ItemNum_TextBox" );

	ShopDailySuccess_ResultWnd = GetWindowHandle( m_WindowName $ ".ShopDailySuccess_ResultWnd" );
	ShopDailyFails_ResultWnd = GetWindowHandle( m_WindowName $ ".ShopDailyFails_ResultWnd" );

	LcoinShopList_Tab = GetTabHandle( m_WindowName $ ".ItemInfo_Wnd.LcoinShopList_Tab" );
	tabbgLine = GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.tabbgLine" );

	util                       = L2Util(GetScript("L2Util"));
	

	//ShopDaily_ListCtrl.SetSelectedSelTooltip(FALSE);	
	//ShopDaily_ListCtrl.SetAppearTooltipAtMouseX(true);
	
	// int (0전체(삭제됨) 1=장비, 2=강화, 3=소모품, 4=기타)
	// ---> 0 =장비, 1=기간제, 2=소모품, 3=기타)

	
	for (i = 1; i < MAX_CATEGORY; i++)
	{
		getListCtrlByCategory(i).SetSelectedSelTooltip(FALSE);	
		getListCtrlByCategory(i).SetAppearTooltipAtMouseX(true);
	}

	FormChangeByServerType();
}

function FormChangeByServerType ()
{
	if (  !getInstanceUIData().getIsClassicServer() )
	{
		FrameHelp_BTN.HideWindow();
		LcoinShopList_Tab.RemoveTabControl(4);
		LcoinShopList_Tab.RemoveTabControl(3);
		LcoinShopList_Tab.RemoveTabControl(2);
		LcoinShopList_Tab.RemoveTabControl(1);
		LcoinShopList_Tab.SetButtonName(0,GetSystemString(144));
		tabbgLine.SetWindowSize(718,23);
	}
	else
	{
		if ( IsAdenServer() )
		{
			tabbgLine.SetWindowSize(270,23);
			LcoinShopList_Tab.SetTabControlTexture(0,"L2UI_ct1.tab.Tab_DF_Tab_LimitLarge_Unselected","L2UI_ct1.tab.Tab_DF_Tab_LimitLarge_Selected","L2UI_ct1.tab.Tab_DF_Tab_LimitLarge_Unselected_Over");
			LcoinShopList_Tab.SetButtonName(0,GetSystemString(13196));
			LcoinShopList_Tab.SetButtonName(1,GetSystemString(116));
			LcoinShopList_Tab.SetButtonName(2,GetSystemString(3963));
			LcoinShopList_Tab.SetButtonName(3,GetSystemString(5006));
			LcoinShopList_Tab.SetButtonName(4,GetSystemString(49));
		}
		else
		{
			LcoinShopList_Tab.RemoveTabControl(4);
			tabbgLine.SetWindowSize(382,23);
			LcoinShopList_Tab.SetTabControlTexture(0,"L2UI_ct1.tab.Tab_DF_Tab_Unselected","L2UI_ct1.tab.Tab_DF_Tab_Selected","L2UI_ct1.tab.Tab_DF_Tab_Unselected_Over");
			LcoinShopList_Tab.SetButtonName(0,GetSystemString(116));
			LcoinShopList_Tab.SetButtonName(1,GetSystemString(3963));
			LcoinShopList_Tab.SetButtonName(2,GetSystemString(5006));
			LcoinShopList_Tab.SetButtonName(3,GetSystemString(49));
		}
	}
}

function ListCtrlHandle getListCtrlByCategory(int nCategory)
{
	return GetListCtrlHandle( m_WindowName $ ".List_Wnd.List_ListCtrl" $ nCategory);

}

/***************************************************************************************************************
 * API
 * *************************************************************************************************************/
// 아이템 구매 요청 API
function API_RequestPurchaseLimitShopItemBuy (int nSlotNum, int nItemAmount)
{	Debug ( "API_RequestPurchaseLimitShopItemBuy" @ shopIndexCurrent @ nSlotNum @ nItemAmount  );
	RequestPurchaseLimitShopItemBuy ( shopIndexCurrent, nSlotNum, nItemAmount);
}

// 아이템 리스트 요청 API
function API_RequestPurchaseLimitShopItemList ( ) 
{	
	RequestPurchaseLimitShopItemList ( shopIndexCurrent ) ;
}

/***************************************************************************************************************
 * On
 * *************************************************************************************************************/
function OnRegisterEvent()
{
	/* 판매 아이템 목록 정보 */
	// 아이템 목록 시작 이벤트
	RegisterEvent( EV_PurchaseLimitShopListBegin );
	// 아이템 정보 이벤트
	RegisterEvent( EV_PurchaseLimitShopItemInfo );
	// 아이템 종료 이벤트
	RegisterEvent( EV_PurchaseLimitShopListEnd );

	// 아이템 구매 결과
	RegisterEvent ( EV_PurchaseLimitShopItemBuy ) ;

	// 다이얼 로그 이벤트
	registerEvent( EV_DialogOK );
	registerEvent( EV_DialogCancel );   
	// BC 소지 정보
	RegisterEvent ( EV_BloodyCoinCount ) ;
	RegisterEvent ( EV_AdenaInvenCount ) ;
	registerEvent ( EV_UpdateUserInfo ) ;
	
	//PC 방 포인트
	RegisterEvent(EV_PCCafePointInfo);
	//RegisterEvent( EV_Test_3 );	
}

function OnLoad()
{	
	Initialize();	
	SetClosingOnESC(); 
	//itemInfosClassID = -1;
	currentShopCategory = 1;
	initSelectedItemIDArray();
}

	// 각 탭마다 선택되어 있는 아이템 아이디
function initSelectedItemIDArray ()
{
	local SelectedCategoryInfo nullItemInfo;

	selectedCategoryInfoArray[0] = nullItemInfo;
	selectedCategoryInfoArray[1] = nullItemInfo;
	selectedCategoryInfoArray[2] = nullItemInfo;
	selectedCategoryInfoArray[3] = nullItemInfo;
	selectedCategoryInfoArray[4] = nullItemInfo;
	selectedCategoryInfoArray[5] = nullItemInfo;
}

function OnEvent(int Event_ID, string param)
{	
	//if (!getInstanceUIData().getIsClassicServer()) return;

	//Debug("엘코인 " @ Event_ID @ param);
	//Debug("IsAdenServer " @ IsAdenServer());

	switch ( Event_ID ) 
	{	
		/******************* 리스트 갱신 ********************************/
		// 아이템 시작 이벤트
		case EV_PurchaseLimitShopListBegin :
			parseInt ( param, "ShopIndex", shopIndexCurrent );	
			ClearAll();			
			break;

			//Debug("EV_PurchaseLimitShopListBegin" @ param);
		// 아이템 정보 이벤트
		case EV_PurchaseLimitShopItemInfo : 
			if ( !IsMyShopIndex (param) ) return;
			HandleItemList( param );

			//Debug("EV_PurchaseLimitShopItemInfo" @ param);

			break;
		// 아이템 종료 이벤트
		case EV_PurchaseLimitShopListEnd :
			if ( !IsMyShopIndex (param) ) return;
			ItemListInfoEnd();
			//Debug("EV_PurchaseLimitShopListEnd" @ param);

			break;

		/******************* 구입 완료 ********************************/
		case EV_PurchaseLimitShopItemBuy :
			Debug ( "EV_PurchaseLimitShopItemBuy" @ param  );
			if ( !IsMyShopIndex (param) ) return;
			HandleBuyResult ( param ) ;
			break;

		/******************* 정보 갱신 ********************************/
		case EV_BloodyCoinCount :
			//HandleBloodCoinCount ( param ) ;
			// 블러드 코인
			break;

		case EV_AdenaInvenCount :
			//HandleAdenaCount();
			break;

		case EV_UpdateUserInfo :
			if ( Me.IsShowWindow() ) HandleUserInfo ();
			break;

		/******************* 다이얼로그 ********************************/
		case EV_DialogOK :
			HandleDialogOK(true);
			break;

		case EV_DialogCancel :
			HandleDialogOK(false);
			break;

		case EV_PCCafePointInfo :
			 pcCafePointInfoHandler(param);
			 break;
		//case EV_Test_3:
		//	Me.GetParentWindowHandle().SetFocus();
		//	Me.SetFocus();
		//	//Debug("포커스!");
		//	break;
	}
}

function pcCafePointInfoHandler(string param)
{
	ParseInt( param, "TotalPoint", pcCafePoint );
}

function OnClickButton( string Name )
{
	local string strID;

	//Debug( "name--->"$ Name );
	switch( Name )
	{
		//활성화 버튼 클릭
		case "Buy_Btn":
			OnBuy_ButtonClick();
			break;
		case "ListRefesh_Btn":
			OnRefresh_ButtonClick();
			break;		
		//활성화 팝업
		case "OK_Button":
			OnOK_ButtonClick();
			break;
		case "Cancel_Button":
			OnCancel_ButtonClick();
			break;
		//성공 팝업 버튼
		case "Success_Button":
			OnSuccess_ButtonClick();
			break;
		//성공 팝업 버튼
		case "Fail_Button":
			OnFail_ButtonClick();
			break;
		//계산기 클릭 시
		case "MultiSell_Input_Button":
			OnPriceEditBtnHandler();
			break;	
		//UP 클릭 시
		case "MultiSell_Up_Button":
			OnMultiSell_Up_ButtonClick();
			break;
		//UP 클릭 시
		case "MultiSell_Down_Button":
			OnMultiSell_Down_ButtonClick();
			break;

		case "Reset_Btn":
			SetItemCountEditBox ( 1 ) ;
			break;

		case "FrameHelp_BTN":

			OnClickHelp();
			break;
	}

	//탭버튼 클릭
	//
	if (Left(Name, len("LcoinShopList_Tab")) == "LcoinShopList_Tab")
	{
		strID = Mid(Name, len("LcoinShopList_Tab"));

		// 탭은 0~3 이니까 +1을 해준다. 
		currentShopCategory = int(strID) + 1;
		//Debug("strID" @ strID);

		showCategoryList(currentShopCategory);
	}
}
function OnClickHelp()
{
	local string strParam;

	// 클래식과 라이브에 다른 도움말 사용
	if(getInstanceUIData().getIsClassicServer())
	{
		ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "lcoinshop_helper001.htm");
		ExecuteEvent(EV_ShowHelp, strParam);
	}
}

//레코드를 클릭하면....
function OnDBClickListCtrlRecord( string ListCtrlID )
{
	//Debug("ListCtrlID" @ ListCtrlID);
	if (Buy_Btn.IsEnableWindow()) OnBuy_ButtonClick();
}


function showCategoryList(int nCategory)
{
	local int i;

	for (i = 1; i < MAX_CATEGORY; i++)
	{
		if (i == nCategory)
		{
			getListCtrlByCategory(i).ShowWindow();
			//getListCtrlByCategory(i).SetFocus();
		}
		else
		{
			getListCtrlByCategory(i).HideWindow();
		}
	}

	OnClickListCtrlRecord("List_ListCtrl");
}

/**
 * 시간 타이머 && 목록 갱신 타이머 이벤트
 ***/
function OnTimer(int TimerID) 
{
	//목록갱신 버튼 활성화
	switch ( TimerID )
	{		
		// Request 활성화 타임
		case TIMER_CLICK :
			Refresh_Button.EnableWindow();
			Me.KillTimer( TIMER_CLICK );

		case TIMER_FOCUS :
			
			getListCtrlByCategory(currentShopCategory).SetFocus();
			Me.KillTimer( TIMER_FOCUS );
		break;		
	}
}

/**  
 *   리스트 클릭
 **/
function OnClickListCtrlRecord( string ListCtrlID )
{	
	local itemInfo Info;
	local UserInfo infoPlayer;
	local LVDataRecord record;	 

	record = GetSelectedRecord ();
	getListCtrlByCategory(currentShopCategory).GetSelectedRec( record ) ;	
	
	GetPlayerInfo(infoPlayer);	

	info = GetItemInfoByRecord( record ) ;

	// 아이템 정보 
	//Debug ( "OnClickListCtrlRecord" @ info.ID.classID) ;
	class'UIAPI_MULTISELLITEMINFO'.static.Clear(m_WindowName $ ".ItemInfo_MultiSell");	
	if ( info.ID.classID > -1 ) 
	{
		selectedCategoryInfoArray[currentShopCategory].ItemClassID = Info.Id.ClassID;
		selectedCategoryInfoArray[currentShopCategory].SlotNum = GetSlotNumByRecord(Record);

		class'UIAPI_MULTISELLITEMINFO'.static.SetItemInfo( m_WindowName $ ".ItemInfo_MultiSell", 0, info );	
		SetItemCountEditBox ( 1 ) ;
	}
	else SetItemCountEditBox ( 0 ) ;

	//Me.SetFocus();
	//getListCtrlByCategory(currentShopCategory).SetFocus();

	// 에디터 박스 때문인지 리스트에 포커스가 안가서 0.1초 딜레이를 주고 포커스
	Me.KillTimer(TIMER_FOCUS);
	Me.SetTimer(TIMER_FOCUS, TIMER_FOCUS_DELAY );
}

/** 
 *  체크 박스 클릭 시
 **/
function OnClickCheckBox( String strID )
{
	switch( strID )
	{
		//"전체 미션 보기" 체크 박스 클릭 시
		case "ListOption_CheckBox": 
			ItemListInfoEnd();
			break;
	}
}

function OnChangeEditBox( String strID )
{	
	switch ( strID ) 
	{
		case "ItemCount_EditBox" :
			//Debug ( "OnChangeEditBox" @ int ( ItemCount_EditBox.GetString()  @ ItemCount_EditBox.GetString()) );			
			HandleEditBox();
			SetItemCountEditBox( int ( ItemCount_EditBox.GetString() ));
		break;
	}	
}


function OnShow () 
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)));
}

//-----------------------------------------------------------------------------------------------------------
// 컨트롤러 제어
//-----------------------------------------------------------------------------------------------------------
function OnRefresh_ButtonClick()
{
	API_RequestPurchaseLimitShopItemList();
	//목록 갱신용 타이머 시작
	Me.SetTimer( TIMER_CLICK, TIMER_DELAYC );
	//버튼 비활성
	Refresh_Button.DisableWindow();
}


/** 개당 판매 가격 입력 계산기 */
function OnPriceEditBtnHandler()
{
	DisableWnd.ShowWindow();
	DisableWnd.SetFocus();
	// Ask price
	DialogSetID( DIALOG_ASK_PRICE );	
	DialogSetEditBoxMaxLength(6);
	DialogSetCancelD(DIALOG_ASK_PRICE);	
	DialogSetEditType("number");	
	DialogSetDefaultOK();
	// 구매개수를 입력해주세요.
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362), string(Self) );
}

//구매 버튼 클릭
function OnBuy_ButtonClick()
{
	DisableWnd.ShowWindow();
	// 에디터에서 포커스를 빼야 함 함
	DisableWnd.SetFocus();

	SetBuyConfirmWnd();
	ShopDailyConfirm_ResultWnd.ShowWindow();	
	ItemCount_EditBox.HideWindow();
}

function OnOK_ButtonClick()
{	
	local LVDataRecord record;	 

	record = GetSelectedRecord()  ; 

	API_RequestPurchaseLimitShopItemBuy(GetSlotNumByRecord(Record),int(ItemCount_EditBox.GetString()));
	ShopDailyConfirm_ResultWnd.hideWindow();
}

function OnCancel_ButtonClick()
{
	DisableWnd.hideWindow();
	ItemCount_EditBox.showWindow();	
	ShopDailyConfirm_ResultWnd.hideWindow();	

}
function OnSuccess_ButtonClick()
{
	DisableWnd.hideWindow();
	ShopDailySuccess_ResultWnd.hideWindow();        	
	ItemCount_EditBox.showWindow();
	API_RequestPurchaseLimitShopItemList();
}

function OnFail_ButtonClick()
{
	DisableWnd.hideWindow();
	ShopDailyFails_ResultWnd.hideWindow();
	ItemCount_EditBox.showWindow();
	API_RequestPurchaseLimitShopItemList();
}

function OnMultiSell_Up_ButtonClick()
{
	SetItemCountEditBox ( int ( ItemCount_EditBox.GetString() )  + 1 ) ;
}

function OnMultiSell_Down_ButtonClick()
{
	SetItemCountEditBox ( int ( ItemCount_EditBox.GetString() ) - 1 ) ;
}

/***************************************************************************************************************
 * 초기화
 * *************************************************************************************************************/
function ClearAll()
{	
	local int i;

	itemListArray.Remove(0, itemListArray.Length);
	//ShopDaily_ListCtrl.DeleteAllItem();

	for (i = 1; i < MAX_CATEGORY; i++) getListCtrlByCategory(i).DeleteAllItem();

	ShopDailyConfirm_ResultWnd.hideWindow();
	ShopDailySuccess_ResultWnd.hideWindow();
	ShopDailyFails_ResultWnd.hideWindow();	
	DisableWnd.hideWindow();
	ItemCount_EditBox.showWindow();
}

/***************************************************************************************************************
 * 데이타 정보 
 * *************************************************************************************************************/
/*
// 블러디 코인 카운트 변경 시 
function HandleBloodCoinCount ( string param)
{	
	local LVDataRecord Record;	
	local int minNum ; 
	
	Debug ( "HandleBloodCoinCount" @ param ) ;
	parseInt64 ( param, "CoinCount", bloodCoinCount) ;

	if ( !Me.IsShowWindow() ) return;

	ModifyRecords();	
	
	Record = GetSelectedRecord();
	minNum = int ( ItemCount_EditBox.GetString () ) ;
	if ( minNum == 0 ) 
		if ( CanBuyByRecord( Record ) ) 
		{
			ItemCount_EditBox.SetString ( "1") ;
			return;
		}

	SetBloodCoinText ( GetNeedCoin( Record ), int  ( ItemCount_EditBox.GetString () )  ) ;	
	SetControlerBtns();
} 

// 아데나 카운트 변경 시 
function HandleAdenaCount ( )
{	
	local LVDataRecord Record;		
	local int minNum ; 

	if ( !Me.IsShowWindow() ) return;

	ModifyRecords();
	Record = GetSelectedRecord();	

	minNum = int ( ItemCount_EditBox.GetString () ) ;
	
	if ( minNum == 0 ) 
		if ( CanBuyByRecord( Record ) ) 
		{
			ItemCount_EditBox.SetString ( "1") ;
			return;
		}

	SetAdenaText ( GetNeedAdena( Record ),  minNum  ) ;	
	SetControlerBtns();
}*/

// 정보 변경 시 ( 레벨 변경 됐을 경우 ) 
function HandleUserInfo()
{
	local LVDataRecord Record;	
	local int minNum ;

	// Debug ( "HandleUserInfo"  @ getInstanceUIData().isLevelUP()  );
	if ( getInstanceUIData().isLevelUP() ) 
	{
		ModifyRecords();

		Record = GetSelectedRecord();	

		minNum = int ( ItemCount_EditBox.GetString () ) ;
	
		if ( minNum == 0 ) 
			if ( CanBuyByRecord( Record ) ) 
			{
				ItemCount_EditBox.SetString ( "1") ;
				return;
			}

		SetControlerBtns();
	}
}

// 모든 리스트의 데이터 변경
function ModifyRecords () 
{
	local int i, index ;	
	local LVDataRecord Record;

	for ( i = 0 ; i < itemListArray.Length ; i ++ ) 
	{		
		Record = MakeRecord (itemListArray[i]);

		// 전체 리스트에서 수정
		//index = FindItemIndex (0, itemListArray[i].ItemClassID ) ;
		//if ( index != -1 ) getListCtrlByCategory(0).ModifyRecord( index, Record ) ; 

		// 카테고리별 리스트에서 수정
		index = FindItemIndex (getListCtrlIndexSellCategory(itemListArray[i].SellCategory), itemListArray[i].SlotNum);

		if (index != -1) getListCtrlByCategory(getListCtrlIndexSellCategory(itemListArray[i].SellCategory)).ModifyRecord( index, Record );
	}
}


// List_ListCtrl0, List_ListCtrl1 List_ListCtrl2 List_ListCtrl3 이런식으로 리스트가 여러가 있다.
// 서버에서 카테고리 번호를 주면 그에 맞는 리스트 컨트롤을 매칭 시킬때 사용
function int getListCtrlIndexSellCategory(int nSellCategory)
{
	// 위치가 바뀔 가능성이 있어서 이런식으로 변경 가능하도록..
	// 일단 나둠. 같이 번호를 매칭 해준다고 해서.. 혹시 모르니.
	switch(nSellCategory)
	{
		case 1: return 1; break;
		case 2: return 2; break;
		case 3: return 3; break;
		case 4: return 4; break;
		default: return nSellCategory; break;
	}
	
	Debug("!!!!! 오류 ShopDailyLcoinWnd -> getListCtrlIndexSellCategory 에서nSellCategory 값이 잘못되었습니다 :  " @ nSellCategory);

	return -1;
}

// 선택 된 레코드로 살수 있는가?
function bool CanBuyByRecord ( LVDataRecord Record ) 
{
	return GetCountCanBuy ( Record ) > 0 ;
}

// 아데나 조건
function int64 GetNeedAdena( LVDataRecord record ) 
{
	local LVDataRecord nullRecord ;
	if ( record == nullRecord ) return 0 ; 
	return Record.nReserved1;
}

// BC 조건
function int64 GetNeedCoin( LVDataRecord record ) 
{
	local LVDataRecord nullRecord ;
	if ( record == nullRecord ) return 0 ; 
	return Record.nReserved2;
}

// 레벨 조건
function int GetNeedLevel( LVDataRecord record ) 
{	
	local LVDataRecord nullRecord ;
	if ( record == nullRecord ) return 0 ; 
	return Record.LVDataList[1].nReserved1;
}

// 수량 조건
function int GetCurrentAmount( LVDataRecord record ) 
{
	local LVDataRecord nullRecord ;
	if ( record == nullRecord ) return 0 ; 

	// 무제한 인 경우 모두 살 수 있 구매 한계인 99999 를 return 한다.
	if ( record.LVDataList[2].nReserved2 == PLSHOP_RESET_TYPE.PLSHOP_RESET_ALWAYS  ) 
		return MAXITEMNUM;
	
	return Record.LVDataList[2].nReserved1;
}

// 레코드서 아이템 정보 받기
function itemInfo GetItemInfoByRecord ( LVDataRecord record ) 
{
	local itemInfo info ;

	ParamToItemInfo ( Record.szReserved, info ) ;
	return info;
}

function int GetSlotNumByRecord (LVDataRecord Record)
{
	return Record.LVDataList[2].nReserved3;
}

// 살 수 있는 수량
function int GetCountCanBuy ( LVDataRecord record ) 
{	
	local int count;
	local array<int> arrID;
	local array<int64> arrAmount;

	count = 0;
	
	if( record.nReserved1 != 0 )
	{
		count++;
		arrID.Insert(arrID.Length, 1);
		arrID[0] = record.LVDataList[3].nReserved1;
		arrAmount.Insert(arrID.Length, 1);
		arrAmount[0] = record.nReserved1;
	}
	if( record.nReserved2 != 0 )
	{
		count++;
		arrID.Insert(arrID.Length, 1);
		arrID[1] = record.LVDataList[3].nReserved2;
		arrAmount.Insert(arrID.Length, 1);
		arrAmount[1] = record.nReserved2;
	}

	if( record.nReserved3 != 0 )
	{
		count++;
		arrID.Insert(arrID.Length, 1);
		arrID[2] = record.LVDataList[3].nReserved3;
		arrAmount.Insert(arrID.Length, 1);
		arrAmount[2] = record.nReserved3; 
	}

	return GetCountCanBuyBuStruct( record.LVDataList[1].nReserved1, count, arrID, arrAmount, GetCurrentAmount(record));
	//return GetCountCanBuyBuStruct ( GetNeedLevel( record ), GetNeedAdena( record),  GetNeedCoin(record), GetCurrentAmount(record) ) ;
}

/*
function int GetCountCanBuyBuStruct ( int needLevel, int64 needAdena, int64 needCoin, int amount ) 
{
	local userinfo info;
	local int64 minNumByBlood, minNumByAdena, minNum; 	
	

	// Debug ( "GetCountCanBuyBuStruct" @ needLevel @ needAdena @ needCoin @ amount) ;
	// 레벨 체크 
	if ( !GetPlayerInfo ( info ) ) return 0 ;
	if ( info.nLevel < needLevel ) return 0 ;		

	if ( needAdena == 0 ) 
		minNumByBlood = amount;
	else 
		minNumByBlood = GetAdena() / needAdena ;		

	if ( needCoin == 0 ) 
		minNumByAdena = amount ;
	else 
		minNumByAdena = bloodCoinCount / needCoin;
	
	if ( minNumByBlood < minNumByAdena ) 
		minNum = minNumByBlood ;
	else
		minNum = minNumByAdena;

	minNum = Min( int(minNum), amount) ;

	return int( minNum );
}
*/
function int GetCountCanBuyBuStruct ( int needLevel, int CostItemNum, array<int> CostItemId, array<int64>CostItemAmount,int amount ) 
{
	local userinfo info;
	local int i;

	// Debug ( "GetCountCanBuyBuStruct" @ needLevel @ needAdena @ needCoin @ amount) ;
	// 레벨 체크 
	if ( !GetPlayerInfo ( info ) ) return 0;
	if ( info.nLevel < needLevel ) return 0;
	if ( amount == 0 ) return 0;

	for( i = 0 ; i < CostItemNum ; i++)
	{
		if ( CostItemId[i] == 0 )
			continue;

		switch (CostItemId[i])
		{
			case MSIT_PCCAFE_POINT:
				amount = Min(amount,GetCountCanByAmount(CostItemAmount[i],pcCafePoint));
				break;
			default:
				amount = Min(amount,GetCountCanByAmount(CostItemAmount[i],GetInventoryItemCount(GetItemID(CostItemId[i]))));
				break;
		}
	}

	//Debug ("minNum------------------------>"@minNum);
	return  amount ;
}

function int GetCountCanByAmount (INT64 CostItemAmount, INT64 currentItemAmount)
{
	return int(currentItemAmount / CostItemAmount);
}
/***************************************************************************************************************
 * 리스트 정보 
 * *************************************************************************************************************/

function HandleItemList ( string param ) 
{	
	local LimitShopItemInfo _limitShopItemInfo;
	local int i;

	parseInt ( param, "ItemClassID", _limitShopItemInfo.ItemClassID );
	parseInt ( param, "ReseetType", _limitShopItemInfo.ReseetType );
	parseInt ( param, "ConditionLevel", _limitShopItemInfo.ConditionLevel );
	parseInt ( param, "MaxItemAmount", _limitShopItemInfo.MaxItemAmount );
	parseInt ( param, "CostItemNum", _limitShopItemInfo.CostItemNum );
	parseInt ( param, "SlotNum", _limitShopItemInfo.SlotNum);

	_limitShopItemInfo.CostItemId.Length = _limitShopItemInfo.CostItemNum;
	_limitShopItemInfo.CostItemAmount.Length = _limitShopItemInfo.CostItemNum;
	_limitShopItemInfo.CostItemSaleAmount.Length = _limitShopItemInfo.CostItemNum;
	_limitShopItemInfo.CostItemSaleRate.Length = _limitShopItemInfo.CostItemNum;

	for( i = 0 ; i < _limitShopItemInfo.CostItemNum ; i++)
	{
		parseInt ( param, "CostItemId_"$i, _limitShopItemInfo.CostItemId[i]);
		/* PC 방 포인트 테스트용
		if( _limitShopItemInfo.CostItemId[i] != 0 )
		{
			_limitShopItemInfo.CostItemId[i] = -100;
		}*/
		parseInt64 ( param, "CostItemAmount_"$i, _limitShopItemInfo.CostItemAmount[i]);
		parseInt64 ( param, "CostItemSaleAmount_"$i, _limitShopItemInfo.CostItemSaleAmount[i]);
		ParseFloat ( param, "CostItemSaleRate_"$i, _limitShopItemInfo.CostItemSaleRate[i]);
	}

	parseInt ( param, "RemainItemAmount", _limitShopItemInfo.RemainItemAmount );
	// 카테고리 추가
	parseInt ( param, "SellCategory", _limitShopItemInfo.SellCategory );
	parseInt ( param, "EventType", _limitShopItemInfo.EventType );
	parseInt ( param, "EventRemainSec", _limitShopItemInfo.EventRemainSec );

	//정렬을 위해 배열에 insert
	itemListArray.Insert( itemListArray.Length, 1 );
	itemListArray[ itemListArray.Length - 1] = _limitShopItemInfo;
}

function LVDataRecord MakeRecord( LimitShopItemInfo _limitShopItemInfo )
{
	local LVDataRecord Record;
	local string fullNameString, tooltipParam;
	local itemInfo Info;	

	local bool bConditionLevel;
	local bool bConditionAmount;
	//local bool bConditionAdena;
	//local bool bConditionCoinCount;
	local userInfo playerInfo;
	local int i;

	local color colorItemName, colorLevel, colorAmount;

	GetPlayerInfo ( playerInfo ) ;

	// 각 조건
	bConditionLevel = _limitShopItemInfo.ConditionLevel <= playerInfo.nLevel;
	bConditionAmount = _limitShopItemInfo.RemainItemAmount > 0 ;
	//bConditionAdena = _limitShopItemInfo.SellCostAdena <= GetAdena();
	//bConditionCoinCount = _limitShopItemInfo.SellCostCoin <= bloodCoinCount;

	/*************************************** 아이템 정보 *****************************************************************/
	info = GetItemInfoByClassID ( _limitShopItemInfo.ItemClassID ) ;
	fullNameString = GetItemNameAll ( info );

	//Debug (limitShopItemInfo.ConditionLevel @ playerInfo.nLevel @ fullNameString  @ bConditionLevel ) ;

	// 툴팁을 저장하기 위해 param으로 분해 사용
	ItemInfoToParam(info, tooltipParam);
	// 툴팁 정보
	Record.szReserved = tooltipParam;	
	// 첫번째 필요 아이템 비용
	Record.nReserved1 = _limitShopItemInfo.CostItemAmount[0];
	// 두번째 필요 아이템 비용
	Record.nReserved2 = _limitShopItemInfo.CostItemAmount[1];
	// 세번째 필요 아이템 비용
	Record.nReserved3 = _limitShopItemInfo.CostItemAmount[2];

	Record.LVDataList.length = 5;

	// 첫번째 필요 아이템
	Record.LVDataList[3].nReserved1 = _limitShopItemInfo.CostItemId[0];
	// 두번째 필요 아이템
	Record.LVDataList[3].nReserved2 = _limitShopItemInfo.CostItemId[1];
	// 세번째 필요 아이템
	Record.LVDataList[3].nReserved3 = _limitShopItemInfo.CostItemId[2];

	// 아이템 정보의 index 값
	//Record.nReserved3 = index;		

	//Debug ( "MakeRecord" @  limitShopItemInfo.ItemClassID @ info.ID.classID );
	/*************************************** 각종 필요 정보 *****************************************************************/
	Record.LVDataList[0].nReserved1 = _limitShopItemInfo.ItemClassID ;
	Record.LVDataList[1].nReserved1 = _limitShopItemInfo.ConditionLevel;
	Record.LVDataList[2].nReserved1 = _limitShopItemInfo.RemainItemAmount;
	Record.LVDataList[2].nReserved2 = _limitShopItemInfo.ReseetType ;
	Record.LVDataList[2].nReserved3 = _limitShopItemInfo.SlotNum;


	Record.LVDataList[0].szData = fullNameString;
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth=32;
	Record.LVDataList[0].nTextureHeight=32;
	Record.LVDataList[0].nTextureU=32;
	Record.LVDataList[0].nTextureV=32;
	Record.LVDataList[0].szTexture = info.IconName; 
	Record.LVDataList[0].IconPosX=10;
	Record.LVDataList[0].FirstLineOffsetX=6;
	// Record.LVDataList[0].HiddenStringForSorting = string( Status );

	// back texture 
	Record.LVDataList[0].iconBackTexName="l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	Record.LVDataList[0].backTexOffsetXFromIconPosX=-2;
	Record.LVDataList[0].backTexOffsetYFromIconPosY=-1;
	Record.LVDataList[0].backTexWidth=36;
	Record.LVDataList[0].backTexHeight=36;
	Record.LVDataList[0].backTexUL=36;
	Record.LVDataList[0].backTexVL=36;

	// 아이콘 테두리 (기본 병기.pvp 무기등)
	Record.LVDataList[0].iconPanelName = info.iconPanel;
	Record.LVDataList[0].panelOffsetXFromIconPosX=0;
	Record.LVDataList[0].panelOffsetYFromIconPosY=0;
	Record.LVDataList[0].panelWidth=32;
	Record.LVDataList[0].panelHeight=32;
	Record.LVDataList[0].panelUL=32;
	Record.LVDataList[0].panelVL=32;	

	// 강화 표시
	if (info.enchanted > 0)
	{
		Record.LVDataList[0].arrTexture.Length = 3;
		lvTextureAddItemEnchantedTexture(info.enchanted, Record.LVDataList[0].arrTexture[0], Record.LVDataList[0].arrTexture[1],Record.LVDataList[0].arrTexture[2], 9, 11);
	}	
	
	for( i = 0 ; i < _limitShopItemInfo.CostItemNum ; i++)
	{
		if( _limitShopItemInfo.CostItemSaleRate[i] > 0 )
		{
			lvTextureAdd(Record.LVDataList[0].arrTexture[Record.LVDataList[0].arrTexture.Length - 1], "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_SaleIcon_02", 0, -1, 39, 39);
		}
	}

	// Sale & Event 출력
	if (_limitShopItemInfo.EventType != 0)
	{
		Record.LVDataList[0].arrTexture.Insert(Record.LVDataList[0].arrTexture.Length, 1);

		/*
		if (_limitShopItemInfo.EventType == PLSHOP_SALE)
		{
			lvTextureAdd(Record.LVDataList[0].arrTexture[Record.LVDataList[0].arrTexture.Length - 1], "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_SaleIcon_02", 0, -1, 39, 39);
		}*/
		//Event 기간 한정 일 경우
		if ( _limitShopItemInfo.EventType == PLSHOP_EVENT_TYPE.PLSHOP_LIMITED_PERIOD )
		{
			lvTextureAdd(Record.LVDataList[0].arrTexture[Record.LVDataList[0].arrTexture.Length - 1], "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_EventIcon_02", 0, -1, 39, 39);

			for( i = 0 ; i < _limitShopItemInfo.CostItemNum ; i++)
			{
				if( _limitShopItemInfo.CostItemSaleRate[i] > 0 )
				{
					
					lvTextureAdd(Record.LVDataList[0].arrTexture[Record.LVDataList[0].arrTexture.Length - 1], "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_EventSaleIcon_02", 0, -1, 39, 39);
				}
			}
		}
		
		

		
	}
	

	/*************************************** 레벨 정보 *****************************************************************/
	Record.LVDataList[1].textAlignment=TA_Center;

	if ( _limitShopItemInfo.ConditionLevel <= 1 ) Record.LVDataList[1].szData = "-" ;	
	else Record.LVDataList[1].szData = _limitShopItemInfo.ConditionLevel @ GetSystemString ( 859 ) ;	

	/*************************************** 수량 정보 *****************************************************************/
	
	if ( _limitShopItemInfo.ReseetType ==  PLSHOP_RESET_TYPE.PLSHOP_RESET_ALWAYS ) 
	{	
		Record.LVDataList[2].arrTexture.Length = 1;
		lvTextureAdd(Record.LVDataList[2].arrTexture[0], "L2UI_CT1.ShopDailyWnd.ShopDailyWnd_Icon_Infinity", 38, 4, 16, 16);
	}
	else 
	{		
		//Record.LVDataList[2].FirstLineOffsetX = 4;
		Record.LVDataList[2].textAlignment=TA_Center;
		Record.LVDataList[2].szData = _limitShopItemInfo.RemainItemAmount $ "/" $ _limitShopItemInfo.MaxItemAmount;
	}
	/*************************************** 판매기간 *****************************************************************/
	Record.LVDataList[3].textAlignment=TA_Center;
	if ( _limitShopItemInfo.EventRemainSec == 0 ) 
	{
		Record.LVDataList[3].szData = GetSystemString(3979);
	}
	else
	{
		Record.LVDataList[3].szData = util.getTimeStringBySec3( _limitShopItemInfo.EventRemainSec );
	}

	/*************************************** 활성 비활성 처리 *****************************************************************/

	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[2].bUseTextColor = true;
	Record.LVDataList[3].bUseTextColor = true;

	// 살수 있는지 여부 	
	if (  GetCountCanBuyBuStruct(   _limitShopItemInfo.ConditionLevel,
									_limitShopItemInfo.CostItemNum,
									_limitShopItemInfo.CostItemId,
									_limitShopItemInfo.CostItemAmount,
									_limitShopItemInfo.RemainItemAmount) > 0
		
		) 
	{
		//밝은 흰색(아이템 이름)
		colorItemName.R= 225;
		colorItemName.G= 225;
		colorItemName.B= 225;
		colorItemName.A= 255;
	}
	else 
	{
		Record.LVDataList[0].foreTextureName = "L2UI_CT1.ItemWindow.ItemWindow_IconDisable";
		// 비활성 텍스쳐 보이게 처리 
		//어두운 회색(아이템 이름)
		colorItemName.R= 182;
		colorItemName.G= 182;
		colorItemName.B= 182;
		colorItemName.A= 255;		
	}

	if ( bConditionLevel ) 
	{
		colorLevel.R = 187;
		colorLevel.G = 170;
		colorLevel.B = 136;
		colorLevel.A = 255;
	}
	else 
	{
		colorLevel.R = 182;
		colorLevel.G = 182;
		colorLevel.B = 182;
		colorLevel.A = 255;
	}

	if ( bConditionAmount ) 
	{
		colorAmount.R = 255;
		colorAmount.G = 255;
		colorAmount.B = 255;
		colorAmount.A = 255;		
	}
	else 
	{
		colorAmount.R = 255;
		colorAmount.G = 204;
		colorAmount.B = 0;
		colorAmount.A = 255;	
	}

	Record.LVDataList[0].TextColor = colorItemName;
	Record.LVDataList[1].TextColor = colorLevel;
	Record.LVDataList[2].TextColor = colorAmount;
	Record.LVDataList[3].TextColor = colorItemName;	

	return Record;
	// itemListArray[ itemListArray.Length - 1].sort0 = Status;
}

/**
 *  일일 미션 리스트 받음 완료
 **/
function ItemListInfoEnd()
{	
	local int i;
	local int n;	

	//ShopDaily_ListCtrl.DeleteAllItem();
	for (i = 1; i < MAX_CATEGORY; i++) getListCtrlByCategory(i).DeleteAllItem();

	//정렬 상태 기준
	//itemListArray.Sort( OnSortCompare );

	for( i = 0 ; i < itemListArray.Length ; i++ )
	{
		//"전체 미션 보기" 체크 시 전부 보여줌
		if( ListOption_CheckBox.IsChecked() )
		{	
			
			if ( GetCountCanBuyBuStruct  (  itemListArray[ i ].ConditionLevel, 
											itemListArray[ i ].CostItemNum,
											itemListArray[ i ].CostItemId,
											itemListArray[ i ].CostItemAmount,
											itemListArray[ i ].RemainItemAmount ) > 0 )
			{

				//  "SellCategory" : int (1=장비, 2=소모품, 3=기간제, 4=기타, 5=이벤트)
				
				// 전체
				//getListCtrlByCategory(0).InsertRecord( MakeRecord( itemListArray[ i ] ) );

				// 각 카테고리당
				getListCtrlByCategory(getListCtrlIndexSellCategory(itemListArray[ i ].SellCategory)).InsertRecord( MakeRecord( itemListArray[ i ] ) );
			}
		}
		else 
		{
			// 전체
			//getListCtrlByCategory(0).InsertRecord( MakeRecord( itemListArray[ i ] ) );
			// 각 카테고리당
			getListCtrlByCategory(getListCtrlIndexSellCategory(itemListArray[ i ].SellCategory)).InsertRecord( MakeRecord( itemListArray[ i ] ) );
		}

		//Debug("itemListArray[ i ].SellCategory" @currentShopCategory @"_"@ itemListArray[ i ].SellCategory);
	}

	// Debug ( "ItemListInfoEnd" @  n  @ itemInfosClassID );

	for (i = 1; i < MAX_CATEGORY; i++)
	{
		//이전에 선택된 것이 있다면 선택
		n = FindItemIndex(i, selectedCategoryInfoArray[i].SlotNum);

		if( n > 0 )
			getListCtrlByCategory(i).SetSelectedIndex( n, true );
		else if ( getListCtrlByCategory(i).GetRecordCount () > 0 ) 
			getListCtrlByCategory(i).SetSelectedIndex( 0, true );
	}

	showCategoryList(currentShopCategory);	

	ShowWindowWithFocus(m_WindowName);
	OnClickListCtrlRecord("List_ListCtrl");	

	//Me.ShowWindow();
	//Me.KillTimer(TIMER_FOCUS);
	//Me.SetTimer(TIMER_FOCUS, TIMER_FOCUS_DELAY );
}

/***************************************************************************************************************
 * 클릭 후 세부 정보  정보 ( 오른 쪽 ) 
 * *************************************************************************************************************/
// 여러 상황 감안 하여, 버튼 컨트롤러를 제어 함.
function SetControlerBtns()
{
	local int count, canBuyCount ;
	local LVDataRecord Record;	 
	local ItemInfo info;

	Record = GetSelectedRecord() ;	

	canBuyCount = GetCountCanBuy ( Record ) ;
	count = int ( ItemCount_EditBox.GetString() ) ;

	//Debug("canBuyCount------------------>"@canBuyCount);
	//Debug("count------------------>"@count);

	// 구입 가능 개수가 0인 경우	
	if ( canBuyCount > 0 ) 
	{
		// 수량을 변경 할 수 없는 경우.
		if ( canBuyCount == 1 ) 
		{
			MultiSell_Input_Button.DisableWindow();			
			ItemCount_EditBox.DisableWindow();		
		}
		else 
		{
			MultiSell_Input_Button.EnableWindow();			
			ItemCount_EditBox.EnableWindow();		
		}		
		
		// 더이상 올릴 수 없는 경우
		if ( canBuyCount == count ) 
			MultiSell_Up_Button.DisableWindow();
		else 
			MultiSell_Up_Button.EnableWindow();

		// 구입 수가 1인 경우( 내릴 수 없다. 
		if ( count <= 1 ) 
		{
			Reset_Btn.DisableWindow();	
			MultiSell_Down_Button.DisableWindow();
		}
		else 
		{
			Reset_Btn.EnableWindow();	
			MultiSell_Down_Button.EnableWindow();
		}

		info = GetItemInfoByRecord( record ) ;
		// 비수량성 아이템이라면..
		if (IsStackableItem( info.ConsumeType ) == false)
		{
			MultiSell_Up_Button.DisableWindow();
			Reset_Btn.DisableWindow();	
			MultiSell_Down_Button.DisableWindow();
			ItemCount_EditBox.DisableWindow();
			MultiSell_Input_Button.DisableWindow();
		}

		if ( count > 0 ) Buy_Btn.EnableWindow();		
		else Buy_Btn.DisableWindow();
		
	}
	else 
	{	
		MultiSell_Up_Button.DisableWindow();
		MultiSell_Down_Button.DisableWindow();
		MultiSell_Input_Button.DisableWindow();
		ItemCount_EditBox.DisableWindow();		
		Reset_Btn.DisableWindow();	
		Buy_Btn.DisableWindow();		
	}

	SetBuyButtonTooltio();
}

/*
// 블러드 코인 텍스트 세팅
function SetBloodCoinText ( int64 bloodCoin, int count ) 
{
	// 블러드 코인 가격
	if ( count == 0 ) count = 1;
	
	NeededItem_Item1Num_text.SetText( "x" @ MakeCostString( string( bloodCoin * count )));

	// 내 블러드 코인
	if ( bloodCoinCount < bloodCoin * count ) 
		NeededItem_Item1MyNum_text.SetTextColor( util.DRed );
	else 
		NeededItem_Item1MyNum_text.SetTextColor( util.BLUE01 );	

	NeededItem_Item1MyNum_text.SetText( "(" $ MakeCostString( string( bloodCoinCount ) ) $ ")" );
}

// index= 1,2
function ShowNeedItem(int index, bool bShow)
{
	if (bShow)
	{
		// 엘코인
		//GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "_Texture").SetTexture(class'UIDATA_ITEM'.static.GetItemTextureName( GetItemID(91663)));
		//Debug("---> " @ class'UIDATA_ITEM'.static.GetItemTextureName( GetItemID(91663)));

		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "Title_TextBox" ).ShowWindow();
		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "NumTitle_TextBox" ).ShowWindow();
		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "MyNumTitle_TextBox" ).ShowWindow();
		GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "_Texture").ShowWindow();		
		GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "SlotBg_Texture").ShowWindow();
	}
	else
	{
		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "Title_TextBox" ).HideWindow();    // 아이템 이름
		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "NumTitle_TextBox" ).HideWindow(); // 필요 아이템
		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "MyNumTitle_TextBox" ).HideWindow(); // 내 소유 아이템수
		GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "_Texture").HideWindow();  // 아이콘
		GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "SlotBg_Texture").HideWindow(); // 아이콘 BG
	}
}

// 아데나 카운트 텍스트 세팅
function SetAdenaText ( int64 adena, int count ) 
{	
	local int64 totalAdena;
	// 아데나 가격
	if ( count == 0 ) count = 1;

	totalAdena = adena * count;

	// 필요 아이템이 0이면 hide
	if (totalAdena > 0) ShowNeedItem(2, true);
	else ShowNeedItem(2, false);

	NeededItem_Item2Num_text.SetText( "x" @ MakeCostString( string( totalAdena  ) ) );

	// 내 아데나 
	if ( GetAdena() < totalAdena ) 
		NeededItem_Item2MyNum_text.SetTextColor( util.DRed );
	else 
		NeededItem_Item2MyNum_text.SetTextColor( util.BLUE01 );

	NeededItem_Item2MyNum_text.SetText( "(" $ MakeCostString( GetAdenaStr() ) $ ")" );	
}
*/

////구매 비용쪽 목록, 1,2, 보이고, 숨기기 
//function showNeedItem(int index, bool nShow)
//{
//	if (nShow)
//	{
//		GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "_Texture" ).ShowWindow();
//		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "Title_TextBox" ).ShowWindow();
//		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "NumTitle_TextBox" ).ShowWindow();
//		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "MyNumTitle_TextBox" ).ShowWindow();
//	}
//	else
//	{
//		GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "_Texture" ).HideWindow();
//		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "Title_TextBox" ).HideWindow();
//		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "NumTitle_TextBox" ).HideWindow();
//		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "MyNumTitle_TextBox" ).HideWindow();
//	}
//}

// 에디터 박스 숫자 세팅
function SetItemCountEditBox ( int num ) 
{	
	local LVDataRecord Record, nullRecord;
	local int n;

	Record = GetSelectedRecord() ;

	if ( Record == nullRecord  ) num = 0;
	else if ( num < 1 ) num = 0;

	num = Min ( GetCountCanBuy( Record ), num );

	// 다를 때만 텍스트 입력을 하지 않으면 무한 반복 된다.
	if ( num != int ( ItemCount_EditBox.GetString() ) ) 
		ItemCount_EditBox.SetString( String( num ) );

	//SetBloodCoinText ( GetNeedCoin( Record ), num ) ;
	//SetAdenaText ( GetNeedAdena( Record ), num ) ;
	
	//Debug("Record.LVDataList[0].nReserved1------>"@Record.LVDataList[0].nReserved1);
	n = FindItemIndexArray(GetSlotNumByRecord(Record));
	//Debug("itemListArray[num].ItemClassID------>"@itemListArray[n].ItemClassID);
	//구매 비용이 3종류 아무거나 들어 올수 있음
	SetBuyCostText(itemListArray[n], num);
	SetControlerBtns();
}

//새로 만든 구입 비용 Max 3
function SetBuyCostText( LimitShopItemInfo arr, int count)
{
	local int i;
	local ItemInfo itemInfo;
	local int64 haveItem;
	local string itemstring;

	if( count == 0 ) count =1;

	for( i = 0 ; i < 3 ; i++ )
	{
		GetItemWindowHandle (m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "_ItemWindow" ).Clear();
		
		itemInfo = GetItemInfoByClassID(arr.CostItemId[i]);	

		if( arr.CostItemId[i] == MSIT_PCCAFE_POINT )
		{				
			haveItem = pcCafePoint;
			itemInfo.Name = GetSystemString(1277);
			itemInfo.IconName = GetPcCafeItemIconPackageName();//"icon.etc_i.etc_pccafe_point_i00";
			itemInfo.Enchanted = 0;
			itemInfo.ItemType = -1;
			itemInfo.Id.ClassID = 0;

			if( haveItem >= arr.CostItemAmount[i] * count)
			{
				GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "MyNumTitle_TextBox" ).SetTextColor( util.BLUE01 );
			}
			else
			{
				GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "MyNumTitle_TextBox" ).SetTextColor( util.DRed );
			}

			if( arr.CostItemSaleRate[i] != 0 )
			{
				itemstring = "("$ util.cutFloat( arr.CostItemSaleRate[i] ) $ GetSystemString(3994) $")";
				GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "Sale_TextBox" ).SetText( itemstring );
				GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "_Sale" ).ShowWindow();
				GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "_Sale" ).SetTooltipCustomType(MakeTooltipSimpleText( GetSystemString(3995) $ " : " $ MakeCostString( string( arr.CostItemAmount[i] ) ) ) );
			}
			else
			{
				GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "Sale_TextBox" ).SetText( "" );
				GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "_Sale" ).HideWindow();
			}

			GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "Title_TextBox" ).SetText( itemInfo.Name );
			GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "NumTitle_TextBox" ).SetText( "x" @ MakeCostString( string(arr.CostItemSaleAmount[i] * count) ));
			GetItemWindowHandle ( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "_ItemWindow" ).AddItem( itemInfo );
			GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "SlotBg_Texture").ShowWindow();
			GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "MyNumTitle_TextBox" ).SetText( "(" $ MakeCostString( string( haveItem ) ) $ ")" );

		}
		else if( arr.CostItemId[i] != 0 )
		{	

			haveItem = GetInventoryItemCount( GetItemID( arr.CostItemId[i] ) );
			if( haveItem >= arr.CostItemAmount[i] * count)
			{
				GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "MyNumTitle_TextBox" ).SetTextColor( util.BLUE01 );
			}
			else
			{
				GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "MyNumTitle_TextBox" ).SetTextColor( util.DRed );
			}

			if( arr.CostItemSaleRate[i] != 0 )
			{
				itemstring = "("$ util.cutFloat( arr.CostItemSaleRate[i] ) $ GetSystemString(3994) $")";
				GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "Sale_TextBox" ).SetText( itemstring );
				GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "_Sale" ).ShowWindow();
				GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "_Sale" ).SetTooltipCustomType(MakeTooltipSimpleText( GetSystemString(3995) $ " : " $ MakeCostString( string( arr.CostItemAmount[i] ) ) ) );
			}
			else
			{
				GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "Sale_TextBox" ).SetText( "" );
				GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "_Sale" ).HideWindow();
			}

			GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "Title_TextBox" ).SetText( itemInfo.Name );
			GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "NumTitle_TextBox" ).SetText( "x" @ MakeCostString( string(arr.CostItemSaleAmount[i] * count) ));
			GetItemWindowHandle ( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "_ItemWindow" ).AddItem( itemInfo );
			GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "SlotBg_Texture").ShowWindow();
			GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "MyNumTitle_TextBox" ).SetText( "(" $ MakeCostString( string( haveItem ) ) $ ")" );
		}
		else
		{			
			GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "Sale_TextBox" ).SetText( "" );
			GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "Title_TextBox" ).SetText( "" );
			GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "NumTitle_TextBox" ).SetText( "" );
			GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "SlotBg_Texture").HideWindow();
			GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "MyNumTitle_TextBox" );
			GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "MyNumTitle_TextBox" ).SetText( "" );
			GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ i+1 $ "_Sale" ).HideWindow();
		}
	}
}


// 버튼 위에 현재 구입 제약을 툴팁으로 보여줌
function SetBuyButtonTooltio () 
{
	local LVDataRecord Record, nummRecord ;	 
	local userInfo info;
	local int i,n;
	local ItemInfo itemInfo;
	local LimitShopItemInfo arr;
	local CustomTooltip T;
	local int64 haveItem;

	util.setCustomTooltip(T);//bluesun 커스터마이즈 툴팁	
	util.ToopTipMinWidth(10);

	if ( !GetPlayerInfo ( info ) ) return;
	
	Record = GetSelectedRecord() ;	

	if ( Record == nummRecord ) 
	{
		Buy_Btn.SetTooltipCustomType(util.getCustomToolTip());
		return;
	}

	n = FindItemIndexArray(GetSlotNumByRecord(Record));
	arr = itemListArray[n];
	
	if ( GetNeedLevel ( Record ) > info.nLevel && GetNeedLevel ( Record ) > 0 ) 
	{	
		util.ToopTipInsertText( GetSystemString( 1030 ), true, true, util.ETooltipTextType.COLOR_RED );		
	}
	
	if ( GetCurrentAmount ( Record ) == 0 ) 
	{	
		util.ToopTipInsertText( GetSystemString(3725) $ " ", true, true, util.ETooltipTextType.COLOR_GRAY );
		util.ToopTipInsertText( "0", true, false, util.ETooltipTextType.COLOR_RED );
	}

	for( i = 0 ; i < 3 ; i++ )
	{
		
		if( arr.CostItemId[i] == MSIT_PCCAFE_POINT )
		{
			itemInfo.Name = GetSystemString(1277);
			itemInfo.IconName = GetPcCafeItemIconPackageName();//"icon.etc_i.etc_pccafe_point_i00";
			haveItem = pcCafePoint;
		}
		else
		{
			itemInfo = GetItemInfoByClassID(arr.CostItemId[i]);
			haveItem = GetInventoryItemCount( GetItemID( arr.CostItemId[i] ) );
		}

		if( haveItem < arr.CostItemAmount[i])
		{
			//util.ToopTipInsertText( class'UIDATA_ITEM'.static.GetItemName( itemInfo.id ) $ " ", true, true, util.ETooltipTextType.COLOR_GRAY );
			util.ToopTipInsertText(itemInfo.Name $ " ", true, true, util.ETooltipTextType.COLOR_GRAY );
			util.ToopTipInsertText( MakeCostString( String( arr.CostItemAmount[i]- haveItem )) @ GetSystemString(3752), true, false, util.ETooltipTextType.COLOR_RED );
		}
	}

	/*	
	if ( GetNeedCoin ( Record ) > bloodCoinCount && GetNeedCoin ( Record ) > 0 ) 
	{	
		// 3931 엘코인
		util.ToopTipInsertText( GetSystemString(3931) $ " ", true, true, util.ETooltipTextType.COLOR_GRAY );
		util.ToopTipInsertText( MakeCostString( String( GetNeedCoin ( Record ) - bloodCoinCount )) @ GetSystemString(3752), true, false, util.ETooltipTextType.COLOR_RED );
	}	
	if ( GetNeedAdena ( Record ) > GetAdena () && GetNeedAdena ( Record ) > 0 ) 
	{		
		util.ToopTipInsertText( GetSystemString(469) $ " ", true, true, util.ETooltipTextType.COLOR_GRAY );
		util.ToopTipInsertText( MakeCostString( String( GetNeedAdena ( Record ) - GetAdena () )) @ GetSystemString(3752), true, false, util.ETooltipTextType.COLOR_RED );
	}*/	
	
	Buy_Btn.SetTooltipCustomType(util.getCustomToolTip());
}

// 입력 시 0이 중복 되지 않도록 체크
function HandleEditBox( ) 
{
	local string editBoxString;
	editBoxString = ItemCount_EditBox.GetString() ;	
	// 맨 앞자리가 0으로 시작 하는 경우 0을 삭제 한다. 		
	if ( Left( editBoxString, 1 ) == "0" && Len( editBoxString )  > 1 )  
		ItemCount_EditBox.SetString ( Right ( editBoxString, Len( editBoxString )  - 1 )) ;
}

/***************************************************************************************************************
 * 다이얼로그
 * *************************************************************************************************************/
function HandleDialogOK(bool bOK)
{	
	if( !DialogIsMine() ) return;

	switch ( DialogGetID() ) 
	{
		case DIALOG_ASK_PRICE :
			DisableWnd.HideWindow();			
			SetItemCountEditBox ( int( DialogGetString()) ) ;
		break;
	}
}


/***************************************************************************************************************
 * 결과 처리 
 * *************************************************************************************************************/
// 구입 확인 처리
function SetBuyConfirmWnd()
{	
	local ItemInfo info;
	local ItemWindowHandle Result_ItemWnd;
	local TextBoxHandle	ItemName_TextBox, BCNum_TextBox, AdenaNum_TextBox, CostNum_TextBox;
	local TextBoxHandle	 ItemName_TextBox1, ItemName_TextBox2, ItemName_TextBox3;
	local LVDataRecord record;	 

	Record = GetSelectedRecord() ;

	// Debug ( "SetBuyConfirmWnd" @ Record.LVDataList[0].szData ) ;
	info = GetItemInfoByRecord ( record ) ;	

	// 아이템 
	Result_ItemWnd = GetItemWindowHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.Result_ItemWnd" );
	ItemName_TextBox = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.ItemName_TextBox" );
	
	if (getInstanceUIData().getIsClassicServer()) 
		GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox" ).SetText(GetSystemString(3931)); // 엘코인
	else  
		GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox" ).SetText(GetSystemString(3915)); // 블러디
	
	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem( info );
	ItemName_TextBox.SetText( Record.LVDataList[0].szData );
	textBoxShortStringWithTooltip(ItemName_TextBox,True);

	// 첫번째 줄	
	ItemName_TextBox1 = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox");
	ItemName_TextBox1.SetText( NeededItem_Item1_Title.GetText() );
	BCNum_TextBox = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.BCNum_TextBox" );
	BCNum_TextBox.SetText( NeededItem_Item1Num_text.GetText() );

	// 아데나 
	ItemName_TextBox2 = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.AdenaTitle_TextBox");
	ItemName_TextBox2.SetText( NeededItem_Item2_Title.GetText() );
	AdenaNum_TextBox = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.AdenaNum_TextBox" );
	AdenaNum_TextBox.SetText( NeededItem_Item2Num_text.GetText() );

	ItemName_TextBox3 = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.CostTitle_TextBox");
	ItemName_TextBox3.SetText( NeededItem_Item3_Title.GetText() );
	CostNum_TextBox = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.CostNum_TextBox" );
	CostNum_TextBox.SetText( NeededItem_Item3Num_text.GetText() );

	// 아이템 개수
	ItemNum_TextBox.SetText( "x" $ ItemCount_EditBox.GetString() );
}



function HandleBuyResult ( string param ) 
{	
	local int Result;
	ParseInt( param, "Result", Result );
	switch ( Result ) 
	{
		case PLSHOP_BUY_RESULT_TYPE.PLSHOP_BUY_SUCCESS :
			SetSuccessWnd ( param );
			break;
		case PLSHOP_BUY_RESULT_TYPE.PLSHOP_BUY_NOT_ALIVE:
			SetFailWnd( 13180 );
			break;
		case PLSHOP_BUY_RESULT_TYPE.PLSHOP_BUY_SYSTEM_FAIL:
		case PLSHOP_BUY_RESULT_TYPE.PLSHOP_BUY_NOT_ENOUGH_COST_ITEM :
		case PLSHOP_BUY_RESULT_TYPE.PLSHOP_BUY_NOT_ENOUGH_ITEM_AMOUNT :
		case PLSHOP_BUY_RESULT_TYPE.PLSHOP_BUY_NOT_ENOUGH_LEVEL:
		case PLSHOP_BUY_RESULT_TYPE.PLSHOP_BUY_NOT_EVENT_TIME :
			SetFailWnd( 4334 );
			break;
	}
}

// 성공 
// 이 이벤트 뒤이 목록이 다시 들어 옵니다.
function SetSuccessWnd( string param )
{
	local ItemWindowHandle Result_ItemWnd;
	local TextBoxHandle	ItemName_TextBox, Discription_TextBox;
	local int ItemClassId;
	local itemInfo info;	
	
	// ParseInt( param, "RemainItemAmount", RemainItemAmount );
	ParseInt( param, "ItemClassId_0", ItemClassId );

	Result_ItemWnd = GetItemWindowHandle( m_WindowName$".ShopDailySuccess_ResultWnd.Result_ItemWnd" );
	ItemName_TextBox = GetTextBoxHandle( m_WindowName$".ShopDailySuccess_ResultWnd.ItemName_TextBox" );
	Discription_TextBox = GetTextBoxHandle( m_WindowName$".ShopDailySuccess_ResultWnd.Discription_TextBox" );

	Result_ItemWnd.Clear();
	
	info = GetItemInfoByClassID(selectedCategoryInfoArray[currentShopCategory].ItemClassID);

	Result_ItemWnd.AddItem( info );
	ItemName_TextBox.SetText( GetItemNameAll ( info ) @ "x" $ ItemCount_EditBox.GetString( ) );
	Discription_TextBox.SetText( GetSystemMessage( 4570 ) );

	ShopDailySuccess_ResultWnd.ShowWindow();
}

// 실패 
// 기본 적으로, 살 수 없는 경우 버튼을 비활성 시키므로, 기타 시스템 오류로 퉁 침.
function SetFailWnd( int SystemMsg )
{
	local TextBoxHandle Discription_TextBox;
	
	Discription_TextBox = GetTextBoxHandle( m_WindowName $ ".ShopDailyFails_ResultWnd.Discription_TextBox" );	

	Discription_TextBox.SetText( GetSystemMessage( SystemMsg ) );
	ShopDailyFails_ResultWnd.ShowWindow();
}


/***************************************************************************************************************
 * 조건 체크 
 * *************************************************************************************************************/
function bool IsMyShopIndex ( string param ) 
{
	local int shopIndex;
	
	parseInt ( param, "ShopIndex", shopIndex );
	return shopIndexCurrent == shopIndex;
}

//-----------------------------------------------------------------------------------------------------------
// UTIL
//-----------------------------------------------------------------------------------------------------------

//아이템 인덱스 찾기
function int FindItemIndex(int category, int SlotNum )
{
	local int i;
	local LVDataRecord Record;

	for( i = 0 ; i < getListCtrlByCategory(category).GetRecordCount() ; i++ )
	{
		getListCtrlByCategory(category).GetRec( i, Record );
		if( SlotNum == GetSlotNumByRecord(Record) )
			return i;
	}
	return -1;
}


//아이템 인덱스 찾기
function int FindItemIndexArray(int SlotNum )
{
	local int i;	

	for( i = 0 ; i < itemListArray.Length ; i++ )
	{
		if( SlotNum == itemListArray[i].SlotNum )
			return i;
	}
	return -1;
}

// 선택 되어 있는 것이 없다면, 오른 쪽 아이템 정보에 기반해, 보여주도록 한다.
function LVDataRecord GetSelectedRecord () 
{
	local LVDataRecord Record, nullRecord;

	getListCtrlByCategory(currentShopCategory).GetSelectedRec( Record ) ;

	// 선택 된 레코드가 없는 경우 
	if (  Record == nullRecord ) 
		if ( selectedCategoryInfoArray[currentShopCategory].SlotNum > -1 ) 
			getListCtrlByCategory(currentShopCategory).GetRec( FindItemIndex(currentShopCategory, selectedCategoryInfoArray[currentShopCategory].SlotNum )  , Record ) ;

	// Debug ( "GetSelectedRecord" @ Record.LVDataList[0].szData ) ;

	return Record;
}
/*-----------------------------------------------------------------------------------------------------------
// 기본 값 처리
/-----------------------------------------------------------------------------------------------------------*/

/**
 * 윈도우 ESC 키로 닫기 처리 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}



//delegate int OnSortCompare( ClanItemInfo a, ClanItemInfo b )
//{
//    if (a.sort0 < b.sort0) // 오름 차순. 조건문에 < 이면 내림차순.
//    {
//        return -1;  // 자리를 바꿔야할때 -1를 리턴 하게 함.
//    }
//    else
//    {
//        return 0;
//    }
//}

defaultproperties
{
     m_WindowName="ShopDailyLcoinWnd"
}
