/**
 *   Ŭ���� ������ ���� (���̺��)
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
// ��ü ���� üũ �ڽ� 
var CheckBoxHandle ListOption_CheckBox;
// ��ǰ ����Ʈ
//var ListCtrlHandle ShopDaily_ListCtrl;


//�ʿ� ������ ������
var ItemWindowHandle NeededItem_Item1Num_Item;
//������ �̸�
var TextBoxHandle NeededItem_Item1_Title;
// �ʿ� ������ �� 
var TextBoxHandle NeededItem_Item1Num_text;
// �ʿ� ������ �� ��
var TextBoxHandle NeededItem_Item1MyNum_text;

//�ʿ� ������ ������
var ItemWindowHandle NeededItem_Item2Num_Item;
//������ �̸�
var TextBoxHandle NeededItem_Item2_Title;
// �ʿ� ������ �� 
var TextBoxHandle NeededItem_Item2Num_text;
// �ʿ� ������ �� ��
var TextBoxHandle NeededItem_Item2MyNum_text;

//�ʿ� ������ ������
var ItemWindowHandle NeededItem_Item3Num_Item;
//������ �̸�
var TextBoxHandle NeededItem_Item3_Title;
// �ʿ� ������ �� 
var TextBoxHandle NeededItem_Item3Num_text;
// �ʿ� ������ �� ��
var TextBoxHandle NeededItem_Item3MyNum_text;

var TextureHandle CostItem01_Sale;
var TextureHandle CostItem02_Sale;
var TextureHandle CostItem03_Sale;

var TextBoxHandle CostItem01Sale_TextBox;
var TextBoxHandle CostItem02Sale_TextBox;
var TextBoxHandle CostItem03Sale_TextBox;


// ������ �� �Է� â
var EditBoxHandle ItemCount_EditBox;
// �ʱ�ȭ ��ư
var ButtonHandle Reset_Btn;
// ���� ��ư???
var ButtonHandle Buy_Btn;
// �� ��ư
var ButtonHandle MultiSell_Up_Button;
// �Ʒ� ��ư
var ButtonHandle MultiSell_Down_Button;
// �Է� ��ư
var ButtonHandle MultiSell_Input_Button;
// ���� ��ư
var ButtonHandle FrameHelp_BTN;


// ��Ȱ�� ������
var WindowHandle DisableWnd;

// �������� ��ư
var ButtonHandle Refresh_Button;

// ������ ��
var TextBoxHandle ItemNum_TextBox;

// ��� â ��
var WindowHandle ShopDailyConfirm_ResultWnd;
var WindowHandle ShopDailySuccess_ResultWnd;
var WindowHandle ShopDailyFails_ResultWnd;

//�� ������
var	TabHandle			LcoinShopList_Tab;
var TextureHandle       tabbgLine;

var string m_WindowName ;

const DIALOG_ASK_PRICE                     = 10111;		

const MAX_CATEGORY                         = 6;		

var int shopIndexCurrent ;

var int64 bloodCoinCount ;

// ���� ī�װ�, �� ��ȣ ~ 1,2,3 4, ���, �Ҹ�ǰ, �Ⱓ��, ��Ÿ

var int currentShopCategory;

var array<SelectedCategoryInfo> selectedCategoryInfoArray;


//struct ShopDailyItemInfo
//{
//	var LVDataRecord        record;
//	//var int			        sort0;
//	//var int			        sort1;	
//};

// pc�� ����Ʈ
var int   pcCafePoint;


//����Ʈ ���� �迭 ( üũ ���¿� ���� �������ų� �Ⱥ��� �� �� �����Ƿ�, 
var array<LimitShopItemInfo> itemListArray;

var L2Util util;

//var ItemInfo SelectItemInfo;


//��� ���ſ� Ÿ�̸� ID
const TIMER_CLICK       = 99902;
//��� ���ſ� Ÿ�̸� ������ 3��
const TIMER_DELAYC       = 3000;

const TIMER_FOCUS       = 99903;

const TIMER_FOCUS_DELAY = 100;

// ���� �ʿ� ������ ������ �������� �ִ� ������ ID
//var int itemInfosClassID ;

// ���� �� �� �ִ� �ִ� ũ�� 
const MAXITEMNUM  = 99999;

// ���� ����� ä�ﶧ ���� ���� 
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
	
	// int (0��ü(������) 1=���, 2=��ȭ, 3=�Ҹ�ǰ, 4=��Ÿ)
	// ---> 0 =���, 1=�Ⱓ��, 2=�Ҹ�ǰ, 3=��Ÿ)

	
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
// ������ ���� ��û API
function API_RequestPurchaseLimitShopItemBuy (int nSlotNum, int nItemAmount)
{	Debug ( "API_RequestPurchaseLimitShopItemBuy" @ shopIndexCurrent @ nSlotNum @ nItemAmount  );
	RequestPurchaseLimitShopItemBuy ( shopIndexCurrent, nSlotNum, nItemAmount);
}

// ������ ����Ʈ ��û API
function API_RequestPurchaseLimitShopItemList ( ) 
{	
	RequestPurchaseLimitShopItemList ( shopIndexCurrent ) ;
}

/***************************************************************************************************************
 * On
 * *************************************************************************************************************/
function OnRegisterEvent()
{
	/* �Ǹ� ������ ��� ���� */
	// ������ ��� ���� �̺�Ʈ
	RegisterEvent( EV_PurchaseLimitShopListBegin );
	// ������ ���� �̺�Ʈ
	RegisterEvent( EV_PurchaseLimitShopItemInfo );
	// ������ ���� �̺�Ʈ
	RegisterEvent( EV_PurchaseLimitShopListEnd );

	// ������ ���� ���
	RegisterEvent ( EV_PurchaseLimitShopItemBuy ) ;

	// ���̾� �α� �̺�Ʈ
	registerEvent( EV_DialogOK );
	registerEvent( EV_DialogCancel );   
	// BC ���� ����
	RegisterEvent ( EV_BloodyCoinCount ) ;
	RegisterEvent ( EV_AdenaInvenCount ) ;
	registerEvent ( EV_UpdateUserInfo ) ;
	
	//PC �� ����Ʈ
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

	// �� �Ǹ��� ���õǾ� �ִ� ������ ���̵�
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

	//Debug("������ " @ Event_ID @ param);
	//Debug("IsAdenServer " @ IsAdenServer());

	switch ( Event_ID ) 
	{	
		/******************* ����Ʈ ���� ********************************/
		// ������ ���� �̺�Ʈ
		case EV_PurchaseLimitShopListBegin :
			parseInt ( param, "ShopIndex", shopIndexCurrent );	
			ClearAll();			
			break;

			//Debug("EV_PurchaseLimitShopListBegin" @ param);
		// ������ ���� �̺�Ʈ
		case EV_PurchaseLimitShopItemInfo : 
			if ( !IsMyShopIndex (param) ) return;
			HandleItemList( param );

			//Debug("EV_PurchaseLimitShopItemInfo" @ param);

			break;
		// ������ ���� �̺�Ʈ
		case EV_PurchaseLimitShopListEnd :
			if ( !IsMyShopIndex (param) ) return;
			ItemListInfoEnd();
			//Debug("EV_PurchaseLimitShopListEnd" @ param);

			break;

		/******************* ���� �Ϸ� ********************************/
		case EV_PurchaseLimitShopItemBuy :
			Debug ( "EV_PurchaseLimitShopItemBuy" @ param  );
			if ( !IsMyShopIndex (param) ) return;
			HandleBuyResult ( param ) ;
			break;

		/******************* ���� ���� ********************************/
		case EV_BloodyCoinCount :
			//HandleBloodCoinCount ( param ) ;
			// ���� ����
			break;

		case EV_AdenaInvenCount :
			//HandleAdenaCount();
			break;

		case EV_UpdateUserInfo :
			if ( Me.IsShowWindow() ) HandleUserInfo ();
			break;

		/******************* ���̾�α� ********************************/
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
		//	//Debug("��Ŀ��!");
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
		//Ȱ��ȭ ��ư Ŭ��
		case "Buy_Btn":
			OnBuy_ButtonClick();
			break;
		case "ListRefesh_Btn":
			OnRefresh_ButtonClick();
			break;		
		//Ȱ��ȭ �˾�
		case "OK_Button":
			OnOK_ButtonClick();
			break;
		case "Cancel_Button":
			OnCancel_ButtonClick();
			break;
		//���� �˾� ��ư
		case "Success_Button":
			OnSuccess_ButtonClick();
			break;
		//���� �˾� ��ư
		case "Fail_Button":
			OnFail_ButtonClick();
			break;
		//���� Ŭ�� ��
		case "MultiSell_Input_Button":
			OnPriceEditBtnHandler();
			break;	
		//UP Ŭ�� ��
		case "MultiSell_Up_Button":
			OnMultiSell_Up_ButtonClick();
			break;
		//UP Ŭ�� ��
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

	//�ǹ�ư Ŭ��
	//
	if (Left(Name, len("LcoinShopList_Tab")) == "LcoinShopList_Tab")
	{
		strID = Mid(Name, len("LcoinShopList_Tab"));

		// ���� 0~3 �̴ϱ� +1�� ���ش�. 
		currentShopCategory = int(strID) + 1;
		//Debug("strID" @ strID);

		showCategoryList(currentShopCategory);
	}
}
function OnClickHelp()
{
	local string strParam;

	// Ŭ���İ� ���̺꿡 �ٸ� ���� ���
	if(getInstanceUIData().getIsClassicServer())
	{
		ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "lcoinshop_helper001.htm");
		ExecuteEvent(EV_ShowHelp, strParam);
	}
}

//���ڵ带 Ŭ���ϸ�....
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
 * �ð� Ÿ�̸� && ��� ���� Ÿ�̸� �̺�Ʈ
 ***/
function OnTimer(int TimerID) 
{
	//��ϰ��� ��ư Ȱ��ȭ
	switch ( TimerID )
	{		
		// Request Ȱ��ȭ Ÿ��
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
 *   ����Ʈ Ŭ��
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

	// ������ ���� 
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

	// ������ �ڽ� �������� ����Ʈ�� ��Ŀ���� �Ȱ��� 0.1�� �����̸� �ְ� ��Ŀ��
	Me.KillTimer(TIMER_FOCUS);
	Me.SetTimer(TIMER_FOCUS, TIMER_FOCUS_DELAY );
}

/** 
 *  üũ �ڽ� Ŭ�� ��
 **/
function OnClickCheckBox( String strID )
{
	switch( strID )
	{
		//"��ü �̼� ����" üũ �ڽ� Ŭ�� ��
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
// ��Ʈ�ѷ� ����
//-----------------------------------------------------------------------------------------------------------
function OnRefresh_ButtonClick()
{
	API_RequestPurchaseLimitShopItemList();
	//��� ���ſ� Ÿ�̸� ����
	Me.SetTimer( TIMER_CLICK, TIMER_DELAYC );
	//��ư ��Ȱ��
	Refresh_Button.DisableWindow();
}


/** ���� �Ǹ� ���� �Է� ���� */
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
	// ���Ű����� �Է����ּ���.
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362), string(Self) );
}

//���� ��ư Ŭ��
function OnBuy_ButtonClick()
{
	DisableWnd.ShowWindow();
	// �����Ϳ��� ��Ŀ���� ���� �� ��
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
 * �ʱ�ȭ
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
 * ����Ÿ ���� 
 * *************************************************************************************************************/
/*
// ���� ���� ī��Ʈ ���� �� 
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

// �Ƶ��� ī��Ʈ ���� �� 
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

// ���� ���� �� ( ���� ���� ���� ��� ) 
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

// ��� ����Ʈ�� ������ ����
function ModifyRecords () 
{
	local int i, index ;	
	local LVDataRecord Record;

	for ( i = 0 ; i < itemListArray.Length ; i ++ ) 
	{		
		Record = MakeRecord (itemListArray[i]);

		// ��ü ����Ʈ���� ����
		//index = FindItemIndex (0, itemListArray[i].ItemClassID ) ;
		//if ( index != -1 ) getListCtrlByCategory(0).ModifyRecord( index, Record ) ; 

		// ī�װ��� ����Ʈ���� ����
		index = FindItemIndex (getListCtrlIndexSellCategory(itemListArray[i].SellCategory), itemListArray[i].SlotNum);

		if (index != -1) getListCtrlByCategory(getListCtrlIndexSellCategory(itemListArray[i].SellCategory)).ModifyRecord( index, Record );
	}
}


// List_ListCtrl0, List_ListCtrl1 List_ListCtrl2 List_ListCtrl3 �̷������� ����Ʈ�� ������ �ִ�.
// �������� ī�װ� ��ȣ�� �ָ� �׿� �´� ����Ʈ ��Ʈ���� ��Ī ��ų�� ���
function int getListCtrlIndexSellCategory(int nSellCategory)
{
	// ��ġ�� �ٲ� ���ɼ��� �־ �̷������� ���� �����ϵ���..
	// �ϴ� ����. ���� ��ȣ�� ��Ī ���شٰ� �ؼ�.. Ȥ�� �𸣴�.
	switch(nSellCategory)
	{
		case 1: return 1; break;
		case 2: return 2; break;
		case 3: return 3; break;
		case 4: return 4; break;
		default: return nSellCategory; break;
	}
	
	Debug("!!!!! ���� ShopDailyLcoinWnd -> getListCtrlIndexSellCategory ����nSellCategory ���� �߸��Ǿ����ϴ� :  " @ nSellCategory);

	return -1;
}

// ���� �� ���ڵ�� ��� �ִ°�?
function bool CanBuyByRecord ( LVDataRecord Record ) 
{
	return GetCountCanBuy ( Record ) > 0 ;
}

// �Ƶ��� ����
function int64 GetNeedAdena( LVDataRecord record ) 
{
	local LVDataRecord nullRecord ;
	if ( record == nullRecord ) return 0 ; 
	return Record.nReserved1;
}

// BC ����
function int64 GetNeedCoin( LVDataRecord record ) 
{
	local LVDataRecord nullRecord ;
	if ( record == nullRecord ) return 0 ; 
	return Record.nReserved2;
}

// ���� ����
function int GetNeedLevel( LVDataRecord record ) 
{	
	local LVDataRecord nullRecord ;
	if ( record == nullRecord ) return 0 ; 
	return Record.LVDataList[1].nReserved1;
}

// ���� ����
function int GetCurrentAmount( LVDataRecord record ) 
{
	local LVDataRecord nullRecord ;
	if ( record == nullRecord ) return 0 ; 

	// ������ �� ��� ��� �� �� �� ���� �Ѱ��� 99999 �� return �Ѵ�.
	if ( record.LVDataList[2].nReserved2 == PLSHOP_RESET_TYPE.PLSHOP_RESET_ALWAYS  ) 
		return MAXITEMNUM;
	
	return Record.LVDataList[2].nReserved1;
}

// ���ڵ弭 ������ ���� �ޱ�
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

// �� �� �ִ� ����
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
	// ���� üũ 
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
	// ���� üũ 
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
 * ����Ʈ ���� 
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
		/* PC �� ����Ʈ �׽�Ʈ��
		if( _limitShopItemInfo.CostItemId[i] != 0 )
		{
			_limitShopItemInfo.CostItemId[i] = -100;
		}*/
		parseInt64 ( param, "CostItemAmount_"$i, _limitShopItemInfo.CostItemAmount[i]);
		parseInt64 ( param, "CostItemSaleAmount_"$i, _limitShopItemInfo.CostItemSaleAmount[i]);
		ParseFloat ( param, "CostItemSaleRate_"$i, _limitShopItemInfo.CostItemSaleRate[i]);
	}

	parseInt ( param, "RemainItemAmount", _limitShopItemInfo.RemainItemAmount );
	// ī�װ� �߰�
	parseInt ( param, "SellCategory", _limitShopItemInfo.SellCategory );
	parseInt ( param, "EventType", _limitShopItemInfo.EventType );
	parseInt ( param, "EventRemainSec", _limitShopItemInfo.EventRemainSec );

	//������ ���� �迭�� insert
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

	// �� ����
	bConditionLevel = _limitShopItemInfo.ConditionLevel <= playerInfo.nLevel;
	bConditionAmount = _limitShopItemInfo.RemainItemAmount > 0 ;
	//bConditionAdena = _limitShopItemInfo.SellCostAdena <= GetAdena();
	//bConditionCoinCount = _limitShopItemInfo.SellCostCoin <= bloodCoinCount;

	/*************************************** ������ ���� *****************************************************************/
	info = GetItemInfoByClassID ( _limitShopItemInfo.ItemClassID ) ;
	fullNameString = GetItemNameAll ( info );

	//Debug (limitShopItemInfo.ConditionLevel @ playerInfo.nLevel @ fullNameString  @ bConditionLevel ) ;

	// ������ �����ϱ� ���� param���� ���� ���
	ItemInfoToParam(info, tooltipParam);
	// ���� ����
	Record.szReserved = tooltipParam;	
	// ù��° �ʿ� ������ ���
	Record.nReserved1 = _limitShopItemInfo.CostItemAmount[0];
	// �ι�° �ʿ� ������ ���
	Record.nReserved2 = _limitShopItemInfo.CostItemAmount[1];
	// ����° �ʿ� ������ ���
	Record.nReserved3 = _limitShopItemInfo.CostItemAmount[2];

	Record.LVDataList.length = 5;

	// ù��° �ʿ� ������
	Record.LVDataList[3].nReserved1 = _limitShopItemInfo.CostItemId[0];
	// �ι�° �ʿ� ������
	Record.LVDataList[3].nReserved2 = _limitShopItemInfo.CostItemId[1];
	// ����° �ʿ� ������
	Record.LVDataList[3].nReserved3 = _limitShopItemInfo.CostItemId[2];

	// ������ ������ index ��
	//Record.nReserved3 = index;		

	//Debug ( "MakeRecord" @  limitShopItemInfo.ItemClassID @ info.ID.classID );
	/*************************************** ���� �ʿ� ���� *****************************************************************/
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

	// ������ �׵θ� (�⺻ ����.pvp �����)
	Record.LVDataList[0].iconPanelName = info.iconPanel;
	Record.LVDataList[0].panelOffsetXFromIconPosX=0;
	Record.LVDataList[0].panelOffsetYFromIconPosY=0;
	Record.LVDataList[0].panelWidth=32;
	Record.LVDataList[0].panelHeight=32;
	Record.LVDataList[0].panelUL=32;
	Record.LVDataList[0].panelVL=32;	

	// ��ȭ ǥ��
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

	// Sale & Event ���
	if (_limitShopItemInfo.EventType != 0)
	{
		Record.LVDataList[0].arrTexture.Insert(Record.LVDataList[0].arrTexture.Length, 1);

		/*
		if (_limitShopItemInfo.EventType == PLSHOP_SALE)
		{
			lvTextureAdd(Record.LVDataList[0].arrTexture[Record.LVDataList[0].arrTexture.Length - 1], "L2UI_CT1.ShopWnd.ShopDailyLcoinWnd_SaleIcon_02", 0, -1, 39, 39);
		}*/
		//Event �Ⱓ ���� �� ���
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
	

	/*************************************** ���� ���� *****************************************************************/
	Record.LVDataList[1].textAlignment=TA_Center;

	if ( _limitShopItemInfo.ConditionLevel <= 1 ) Record.LVDataList[1].szData = "-" ;	
	else Record.LVDataList[1].szData = _limitShopItemInfo.ConditionLevel @ GetSystemString ( 859 ) ;	

	/*************************************** ���� ���� *****************************************************************/
	
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
	/*************************************** �ǸűⰣ *****************************************************************/
	Record.LVDataList[3].textAlignment=TA_Center;
	if ( _limitShopItemInfo.EventRemainSec == 0 ) 
	{
		Record.LVDataList[3].szData = GetSystemString(3979);
	}
	else
	{
		Record.LVDataList[3].szData = util.getTimeStringBySec3( _limitShopItemInfo.EventRemainSec );
	}

	/*************************************** Ȱ�� ��Ȱ�� ó�� *****************************************************************/

	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[2].bUseTextColor = true;
	Record.LVDataList[3].bUseTextColor = true;

	// ��� �ִ��� ���� 	
	if (  GetCountCanBuyBuStruct(   _limitShopItemInfo.ConditionLevel,
									_limitShopItemInfo.CostItemNum,
									_limitShopItemInfo.CostItemId,
									_limitShopItemInfo.CostItemAmount,
									_limitShopItemInfo.RemainItemAmount) > 0
		
		) 
	{
		//���� ���(������ �̸�)
		colorItemName.R= 225;
		colorItemName.G= 225;
		colorItemName.B= 225;
		colorItemName.A= 255;
	}
	else 
	{
		Record.LVDataList[0].foreTextureName = "L2UI_CT1.ItemWindow.ItemWindow_IconDisable";
		// ��Ȱ�� �ؽ��� ���̰� ó�� 
		//��ο� ȸ��(������ �̸�)
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
 *  ���� �̼� ����Ʈ ���� �Ϸ�
 **/
function ItemListInfoEnd()
{	
	local int i;
	local int n;	

	//ShopDaily_ListCtrl.DeleteAllItem();
	for (i = 1; i < MAX_CATEGORY; i++) getListCtrlByCategory(i).DeleteAllItem();

	//���� ���� ����
	//itemListArray.Sort( OnSortCompare );

	for( i = 0 ; i < itemListArray.Length ; i++ )
	{
		//"��ü �̼� ����" üũ �� ���� ������
		if( ListOption_CheckBox.IsChecked() )
		{	
			
			if ( GetCountCanBuyBuStruct  (  itemListArray[ i ].ConditionLevel, 
											itemListArray[ i ].CostItemNum,
											itemListArray[ i ].CostItemId,
											itemListArray[ i ].CostItemAmount,
											itemListArray[ i ].RemainItemAmount ) > 0 )
			{

				//  "SellCategory" : int (1=���, 2=�Ҹ�ǰ, 3=�Ⱓ��, 4=��Ÿ, 5=�̺�Ʈ)
				
				// ��ü
				//getListCtrlByCategory(0).InsertRecord( MakeRecord( itemListArray[ i ] ) );

				// �� ī�װ���
				getListCtrlByCategory(getListCtrlIndexSellCategory(itemListArray[ i ].SellCategory)).InsertRecord( MakeRecord( itemListArray[ i ] ) );
			}
		}
		else 
		{
			// ��ü
			//getListCtrlByCategory(0).InsertRecord( MakeRecord( itemListArray[ i ] ) );
			// �� ī�װ���
			getListCtrlByCategory(getListCtrlIndexSellCategory(itemListArray[ i ].SellCategory)).InsertRecord( MakeRecord( itemListArray[ i ] ) );
		}

		//Debug("itemListArray[ i ].SellCategory" @currentShopCategory @"_"@ itemListArray[ i ].SellCategory);
	}

	// Debug ( "ItemListInfoEnd" @  n  @ itemInfosClassID );

	for (i = 1; i < MAX_CATEGORY; i++)
	{
		//������ ���õ� ���� �ִٸ� ����
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
 * Ŭ�� �� ���� ����  ���� ( ���� �� ) 
 * *************************************************************************************************************/
// ���� ��Ȳ ���� �Ͽ�, ��ư ��Ʈ�ѷ��� ���� ��.
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

	// ���� ���� ������ 0�� ���	
	if ( canBuyCount > 0 ) 
	{
		// ������ ���� �� �� ���� ���.
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
		
		// ���̻� �ø� �� ���� ���
		if ( canBuyCount == count ) 
			MultiSell_Up_Button.DisableWindow();
		else 
			MultiSell_Up_Button.EnableWindow();

		// ���� ���� 1�� ���( ���� �� ����. 
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
		// ������� �������̶��..
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
// ���� ���� �ؽ�Ʈ ����
function SetBloodCoinText ( int64 bloodCoin, int count ) 
{
	// ���� ���� ����
	if ( count == 0 ) count = 1;
	
	NeededItem_Item1Num_text.SetText( "x" @ MakeCostString( string( bloodCoin * count )));

	// �� ���� ����
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
		// ������
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
		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "Title_TextBox" ).HideWindow();    // ������ �̸�
		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "NumTitle_TextBox" ).HideWindow(); // �ʿ� ������
		GetTextBoxHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "MyNumTitle_TextBox" ).HideWindow(); // �� ���� �����ۼ�
		GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "_Texture").HideWindow();  // ������
		GetTextureHandle( m_WindowName $ ".ItemInfo_Wnd.CostItem0" $ index $ "SlotBg_Texture").HideWindow(); // ������ BG
	}
}

// �Ƶ��� ī��Ʈ �ؽ�Ʈ ����
function SetAdenaText ( int64 adena, int count ) 
{	
	local int64 totalAdena;
	// �Ƶ��� ����
	if ( count == 0 ) count = 1;

	totalAdena = adena * count;

	// �ʿ� �������� 0�̸� hide
	if (totalAdena > 0) ShowNeedItem(2, true);
	else ShowNeedItem(2, false);

	NeededItem_Item2Num_text.SetText( "x" @ MakeCostString( string( totalAdena  ) ) );

	// �� �Ƶ��� 
	if ( GetAdena() < totalAdena ) 
		NeededItem_Item2MyNum_text.SetTextColor( util.DRed );
	else 
		NeededItem_Item2MyNum_text.SetTextColor( util.BLUE01 );

	NeededItem_Item2MyNum_text.SetText( "(" $ MakeCostString( GetAdenaStr() ) $ ")" );	
}
*/

////���� ����� ���, 1,2, ���̰�, ����� 
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

// ������ �ڽ� ���� ����
function SetItemCountEditBox ( int num ) 
{	
	local LVDataRecord Record, nullRecord;
	local int n;

	Record = GetSelectedRecord() ;

	if ( Record == nullRecord  ) num = 0;
	else if ( num < 1 ) num = 0;

	num = Min ( GetCountCanBuy( Record ), num );

	// �ٸ� ���� �ؽ�Ʈ �Է��� ���� ������ ���� �ݺ� �ȴ�.
	if ( num != int ( ItemCount_EditBox.GetString() ) ) 
		ItemCount_EditBox.SetString( String( num ) );

	//SetBloodCoinText ( GetNeedCoin( Record ), num ) ;
	//SetAdenaText ( GetNeedAdena( Record ), num ) ;
	
	//Debug("Record.LVDataList[0].nReserved1------>"@Record.LVDataList[0].nReserved1);
	n = FindItemIndexArray(GetSlotNumByRecord(Record));
	//Debug("itemListArray[num].ItemClassID------>"@itemListArray[n].ItemClassID);
	//���� ����� 3���� �ƹ��ų� ��� �ü� ����
	SetBuyCostText(itemListArray[n], num);
	SetControlerBtns();
}

//���� ���� ���� ��� Max 3
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


// ��ư ���� ���� ���� ������ �������� ������
function SetBuyButtonTooltio () 
{
	local LVDataRecord Record, nummRecord ;	 
	local userInfo info;
	local int i,n;
	local ItemInfo itemInfo;
	local LimitShopItemInfo arr;
	local CustomTooltip T;
	local int64 haveItem;

	util.setCustomTooltip(T);//bluesun Ŀ���͸����� ����	
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
		// 3931 ������
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

// �Է� �� 0�� �ߺ� ���� �ʵ��� üũ
function HandleEditBox( ) 
{
	local string editBoxString;
	editBoxString = ItemCount_EditBox.GetString() ;	
	// �� ���ڸ��� 0���� ���� �ϴ� ��� 0�� ���� �Ѵ�. 		
	if ( Left( editBoxString, 1 ) == "0" && Len( editBoxString )  > 1 )  
		ItemCount_EditBox.SetString ( Right ( editBoxString, Len( editBoxString )  - 1 )) ;
}

/***************************************************************************************************************
 * ���̾�α�
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
 * ��� ó�� 
 * *************************************************************************************************************/
// ���� Ȯ�� ó��
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

	// ������ 
	Result_ItemWnd = GetItemWindowHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.Result_ItemWnd" );
	ItemName_TextBox = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.ItemName_TextBox" );
	
	if (getInstanceUIData().getIsClassicServer()) 
		GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox" ).SetText(GetSystemString(3931)); // ������
	else  
		GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox" ).SetText(GetSystemString(3915)); // ����
	
	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem( info );
	ItemName_TextBox.SetText( Record.LVDataList[0].szData );
	textBoxShortStringWithTooltip(ItemName_TextBox,True);

	// ù��° ��	
	ItemName_TextBox1 = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.BCTitle_TextBox");
	ItemName_TextBox1.SetText( NeededItem_Item1_Title.GetText() );
	BCNum_TextBox = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.BCNum_TextBox" );
	BCNum_TextBox.SetText( NeededItem_Item1Num_text.GetText() );

	// �Ƶ��� 
	ItemName_TextBox2 = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.AdenaTitle_TextBox");
	ItemName_TextBox2.SetText( NeededItem_Item2_Title.GetText() );
	AdenaNum_TextBox = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.AdenaNum_TextBox" );
	AdenaNum_TextBox.SetText( NeededItem_Item2Num_text.GetText() );

	ItemName_TextBox3 = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.CostTitle_TextBox");
	ItemName_TextBox3.SetText( NeededItem_Item3_Title.GetText() );
	CostNum_TextBox = GetTextBoxHandle( m_WindowName $ ".ShopDailyConfirm_ResultWnd.CostNum_TextBox" );
	CostNum_TextBox.SetText( NeededItem_Item3Num_text.GetText() );

	// ������ ����
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

// ���� 
// �� �̺�Ʈ ���� ����� �ٽ� ��� �ɴϴ�.
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

// ���� 
// �⺻ ������, �� �� ���� ��� ��ư�� ��Ȱ�� ��Ű�Ƿ�, ��Ÿ �ý��� ������ �� ħ.
function SetFailWnd( int SystemMsg )
{
	local TextBoxHandle Discription_TextBox;
	
	Discription_TextBox = GetTextBoxHandle( m_WindowName $ ".ShopDailyFails_ResultWnd.Discription_TextBox" );	

	Discription_TextBox.SetText( GetSystemMessage( SystemMsg ) );
	ShopDailyFails_ResultWnd.ShowWindow();
}


/***************************************************************************************************************
 * ���� üũ 
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

//������ �ε��� ã��
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


//������ �ε��� ã��
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

// ���� �Ǿ� �ִ� ���� ���ٸ�, ���� �� ������ ������ �����, �����ֵ��� �Ѵ�.
function LVDataRecord GetSelectedRecord () 
{
	local LVDataRecord Record, nullRecord;

	getListCtrlByCategory(currentShopCategory).GetSelectedRec( Record ) ;

	// ���� �� ���ڵ尡 ���� ��� 
	if (  Record == nullRecord ) 
		if ( selectedCategoryInfoArray[currentShopCategory].SlotNum > -1 ) 
			getListCtrlByCategory(currentShopCategory).GetRec( FindItemIndex(currentShopCategory, selectedCategoryInfoArray[currentShopCategory].SlotNum )  , Record ) ;

	// Debug ( "GetSelectedRecord" @ Record.LVDataList[0].szData ) ;

	return Record;
}
/*-----------------------------------------------------------------------------------------------------------
// �⺻ �� ó��
/-----------------------------------------------------------------------------------------------------------*/

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}



//delegate int OnSortCompare( ClanItemInfo a, ClanItemInfo b )
//{
//    if (a.sort0 < b.sort0) // ���� ����. ���ǹ��� < �̸� ��������.
//    {
//        return -1;  // �ڸ��� �ٲ���Ҷ� -1�� ���� �ϰ� ��.
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
