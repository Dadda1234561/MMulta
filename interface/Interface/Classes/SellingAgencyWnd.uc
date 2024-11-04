////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
//  Program ID  : �ǸŴ��� �ý��� 
//  ��Ű ����   : http://lineage2:8080/wiki/moin.cgi/_c0_a7_c5_b9_c6_c7_b8_c5#line5
//
//  �� ���� ��ȹ�� ���
//   UI ��ȹ��
//	 VSS/GameDesign/UI/GD10 ��ȹ��/GD1_UI_�������ǸŴ���ý���.ppt
//	
//  �ý��� ��ȹ��
//	 VSS/GameDesign/�ý��۵�������/GD1/��ȹ��/GD1_UI_�������ǸŴ���ý���.doc
// 	 VSS/GameDesign/�ý��۵�������/GD1/��ȹ��/GD1_UI_�������ǸŴ���ý���.ppt
//	 VSS/GameDesign/�ý��۵�������/GD1.1/111019/��ȹ��/GD1.1_�Ǹ� ���� �ý���.docx
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class SellingAgencyWnd extends UICommonAPI;

const TIMER_SEARCH_ID               = 2001001;
const TIMER_CATEGORYTREE_SEARCH_ID  = 2001002; 
// TTP #59728 - gorillazin 13.01.09.
const TIMER_RE_SEARCH_ID			= 2001003;
//

const TIMER_SEARCH_DELAY  = 700;                                // ������ 0.7�� �������� �˻� ����� �۵� �ϵ��� �Ѵ�.
// TTP #59728 - gorillazin 13.01.09.
const TIMER_Re_SEARCH_DELAY = 350;
const SEARCH_FAIL_REASON_DELAY = -1;
//
 
const DIALOG_STACKABLE_ITEM_ACCOMPANY_TO_INVEN = 200000;		// ACCOMPANY ���� INVEN���� �ű涧 ����Ŀ���Ѱ� ���� �����
const DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY = 200001;		// INVEN ���� ACCOMPANY���� �ű涧 ����Ŀ���Ѱ� ���� �����
const DIALOG_RECEIVE_ADENA                     = 200002;		// ���� �ݾ� ����
const DIALOG_NOTIFY_SEND_POST                  = 200003;	  	// ������ ������ ������ ����� ���̾�α�
const DIALOG_ONLY_NOTICE                       = 200004;	  	// �ƹ����۵� ���ϴ� �˷��ִ� ����
const DIALOG_ASK_PRICE                         = 200005;
const DIALOG_ASK_REGISTITEM                    = 200006;
const DIALOG_ASK_BUY                           = 200007;
const DIALOG_ASK_DELETE                        = 200008;

//��� ������ 0831
const DIALOG_FREEUSER_ONREGISTE                = 200009;


// 1)	��� ������ = (�Ǹ� ������ 1���� ����)*(�Ǹż���)*0.0001 * (��ϱⰣ) 
//  2)	�Ǹ� ������ = (�Ǹ� ������ 1���� ����)*(�Ǹż���)*0.005 * (��ϱⰣ)

// const COMMISSION_RATE                          = 1;             // ��� ������ �� ( �Ϸ�� 0.0001% ), (COMMISSION_RATE / 10000) => 0.0001
// const COMMISSION_RATE_SELLCOMPLETE             = 5;             // �Ǹ� ������ (COMMISSION_MIN_PRICE / 1000) => 0.005

const COMMISSION_MIN_PRICE                     = 10000;         // ��� ������ 1�� ���� ������ �ּ� ��� ������ ����
const COMMISSION_REGISTER_MIN_PRICE            = 1000;          // �ּ� ��� ������
const COMMISSION_REGISTER_MIN_PRICE_30         = 700;          // �ּ� ��� ������ 30%

const MAX_SELLINGITEM_NUM                      = 10;            // �Ǹ� ������ �ִ� �����ۼ�
const MAX_SELLING_AMOUNT                       = 99999;         // ������ ������ �ִ� ��� ���ɼ� : �ڸ����� ���� DialogSetEditBoxMaxLength�� �����ؾ���

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  XML UI 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var WindowHandle   Me;
var WindowHandle   DisableWnd;
var TabHandle      TabCtrl;
var TextureHandle  TabLineBg;
var TextureHandle  TabBg;

var WindowHandle   SellingListWnd;
var WindowHandle   DescriptionMsgWnd;
var TextBoxHandle  DescriptionMsg;
var TextBoxHandle  Type_Title;

var ComboBoxHandle Type_Combobox;
var TextBoxHandle  Grade_Title;
var ComboBoxHandle Grade_Combobox;
var TextBoxHandle  SearchWord_Title;
var EditBoxHandle  SearchWord_Editbox;
var ButtonHandle   SearchBtn;
var ButtonHandle   ResetBtn;
var TextureHandle  SearchGroupBox;
var TextBoxHandle  Sort_Title;

var TreeHandle     SortListTree;
var TextureHandle  SortGroupbox;
var WindowHandle   HelpHtmlWnd;
var TextBoxHandle  HelpHtmlWnd_Title;
var HtmlHandle     HtmlViewer;

var WindowHandle   SellingItemListWnd;
var TextBoxHandle  SellingItemList_Title;
var TextBoxHandle  SellingItemNumber;
var ListCtrlHandle SellingItemListCtrl;
var TextureHandle  SellingItemListCtrlDeco;
var TextureHandle  SellingItemListGroupbox;
var TextureHandle  SellingItemListCtrlGroupboxDivider;

var ButtonHandle   RefreshBtn;
var ButtonHandle   BuyBtn;
var WindowHandle   MyListWnd;
var TextBoxHandle  MyList_Title;
var TextBoxHandle  MySellingItemList_Title;
var TextBoxHandle  MySellingItemNumber;
var ListCtrlHandle MySellingItemListCtrl;
var TextureHandle  MySellingItemListCtrlDeco;
var ButtonHandle   SellCancelBtn;
var ButtonHandle   SellBtn;

var TextureHandle  MySellingItemListGroupbox;
var WindowHandle   SellingItemRegistrationWnd;
var TextBoxHandle  SellingItemRegistrationWind_Title;
var TextBoxHandle  SellingPossibItem_Title;

var ItemWindowHandle MySellingPossibItem;
var TextureHandle    MySellingPossibItembg;
var TextureHandle    MySellingPossibItemGroupbox;
var TextBoxHandle    MySellingItem_Title;
var ItemWindowHandle MySellingItemIcon;
var TextureHandle    MySellingItemSlotBg;
var NameCtrlHandle   MySellingItemName;
var TextureHandle    MySellingItemPropertyIcon_01;
var TextureHandle    MySellingItemPropertyIcon_02;
var TextureHandle    MySellingItemPropertyIcon_03;
var TextureHandle    MySellingItemPropertyIcon_04;
var TextBoxHandle    MySellingItemPropertyValue_01;
var TextBoxHandle    MySellingItemPropertyValue_02;
var TextBoxHandle    MySellingItemPropertyValue_03;
var TextBoxHandle    MySellingItemPropertyValue_04;
var TextureHandle    MySellingItemGroupbox;
var TextBoxHandle    MySellingItemUnitPrice_Title;
var ButtonHandle     MySellingItemUnitPriceEditBtn;
var TextureHandle    MySellingItemUnitPriceAdenaIcon;
var EditBoxHandle    MySellingItemUnitPriceEdit;

var TextBoxHandle    MySellingItemUnitPrice_ReadingText;
var TextBoxHandle    MySellingItemAmount_Title;
var TextBoxHandle    MySellingItemAmount;

var TextureHandle    GroupboxDivider_01;
var TextBoxHandle    MySellingItemRegistPeriod_Title;
var ComboBoxHandle   MySellingItemRegistPeriodComboBox;

var TextureHandle    GroupboxDivider_02;
var TextBoxHandle    MySellingItemTotalPrice_Title;

var TextureHandle    MySellingItemTotalPriceAdenaIcon;
var TextBoxHandle    MySellingItemTotalPrice;
var TextBoxHandle    MySellingItemTotalPrice_ReadingText;
					
var TextureHandle    GroupboxDivider_03;
var TextBoxHandle    MySellingItemCharge_Title;
var ButtonHandle     MySellingItemChargeEditBtn;
var TextureHandle    MySellingItemChargeAdenaIcon;

// ��� ������  (2011, 09, 08 �߰�)
var TextBoxHandle    MySellingItemSellCharge;

// �Ǹ� ������ 
var TextBoxHandle    MySellingItemCharge;
var TextureHandle    MySellingItemChargeTextBoxBg;
//var TextBoxHandle    MySellingItemCharge_ReadingText;
var TextureHandle    GroupboxDivider_04;
var ButtonHandle     RegistBtn;
var ButtonHandle     CancelBtn;
var TextureHandle    MySellingItemInfoGroupbox;

var TextBoxHandle    MyAdena;
var TextBoxHandle    MyAdena2; 

var WindowHandle     m_inventoryWnd;

var int              maxSellingItemNum;

var string           saveTreePath;
var bool             disableCurrentWindowFlag;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ���� ����
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var L2Util           util;

// Ʈ�� �޴� ���� 
var array<string>	titleNameArray;
var array<string>	categoryTypeNameArray;
var array<string>	item1Array, item2Array, item3Array, item4Array, item5Array, item6Array;
//branch 110706
var array<CommissionPremiumItemInfo>	sellPremiumitemArray;
//end of branch

// ��ü Ʈ���� ��� ��Ʈ���� �ִ´�.
var string treeParam;
var string openTreeParam;

// ���� ���� �Ǿ��� Ʈ�����
var string currentTreeNodeSelected;
var string beforeTreeNodeSelected;
var bool   beforeTreeNodeSelectedFlag;
// ���� �˻��� ȣ���� ���
var string beforeTreeNodeCalled;


// Combo ���� ��
var int nCurrentTypeCombo;
var int nCurrentGradeCombo;

// ���� �Ǹŵ���Ϸ��� �ϴ� �������� �ӽ÷� �����س��� , ������ ������ �÷ȴ� ����� ��ȸ �Ͽ� ������ �޾�
// �ö� ����ϴ� ������
var ItemInfo saveTempItemInfo;
var int nSaveTempItemIndex;
var int nItemCheckState;

// ���� ��Ͽ� ���� ����Ʈ ��ȣ
var int listCommissionStatus;

// �κ� -> �Ǹŵ��, �Ǹŵ��-> �κ�  �� ù��° ������ �̸����� ����.
var string startItemWIndowName; 

// ������ ���� ����� ����Ʈ�� �ε���
var int deleteIndexMySellingItemListCtrl;

// ���� �Ǹ� ���� ����
var INT64 beforeAmount, beforePrePrice;
var int beforePeriod;
var int beforeDiscountType; //branch 110824

var Rect MySellingItemListCtrlRect;

// �巡�� �ؼ� ��ü �������� �־���? 
var bool allItemCountFlag;
var ItemInfo beforeDropItemInfo;

// ������
var string commissionStr, commissionSellCompleteStr;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// �ʱ�ȭ ���� 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnRegisterEvent()
{
	// â ����
	RegisterEvent(EV_ItemCommissionWndShow );
	
	//branch 110706
	//�ؿܿ� ���ξ����� ����Ʈ �߰�
	RegisterEvent( EV_ItemCommissionWndSellingPremiumItemRegisterReset );
	RegisterEvent( EV_ItemCommissionWndSellingPremiumItemRegister );
	//end of branch

	// �� �Ǹ��� ������ ����Ʈ ���
	RegisterEvent(EV_ItemCommissionWndListStart);
	RegisterEvent(EV_ItemCommissionWndEachItem);

	// �Ǹ� ������ ������ ����Ʈ 
	RegisterEvent(EV_ItemCommissionWndRegistrableItemCnt);
	RegisterEvent(EV_ItemCommissionWndRegistrableItemList);

	// ���� �Ѵٰ� ���� ��� 
	RegisterEvent(EV_ItemCommissionWndBuyInfo);
	// ���� ���  
	RegisterEvent(EV_ItemCommissionWndBuyResult);

	// ��� �Ϸ��� �������� �巡��,  ����Ŭ�������� 
	RegisterEvent(EV_ItemCommissionWndResponseInfo);

	// �Ǹ��� ������ ��� ���
	RegisterEvent(EV_ItemCommissionWndRegisterResult);

	// �Ǹ��� ������ ���� ��� 
	RegisterEvent(EV_ItemCommissionWndDeleteResult);

	RegisterEvent(EV_ItemCommissionWndSearchFail);


	// npc���� �Ÿ��� �־����� â�� �ݴ´�.
	RegisterEvent(EV_ItemCommissionWndCloseCauseOfLongDistance);

	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_DialogCancel);

	RegisterEvent(EV_Restart);
	
	RegisterEvent(EV_ItemCommissionRegisterWndCloseCauseOfFreeUser);



	//const EV_ItemCommissionWndShow = 5490;
	//const EV_ItemCommissionWndRegistrableItemCnt=5492;
	//const EV_ItemCommissionWndRegistrableItemList=5495;

	//const EV_ItemCommissionWndResponseInfo = 5500;
	//const EV_ItemCommissionWndListStart = 5510;
	//const EV_ItemCommissionWndEachItem = 5520;
	//const EV_ItemCommissionWndListEnd = 5530;

	//const EV_ItemCommissionWndBuyInfo = 5540;
	//const EV_ItemCommissionWndBuyResult = 5550;
	//const EV_ItemCommissionWndDeleteResult = 5560;
	//const EV_ItemCommissionWndRegisterResult = 5570;
}

/** onShow */
function OnShow()
{	
	PlayConsoleSound(IFST_WINDOW_OPEN);
	util.ItemRelationWindowHide("SellingAgencyWnd");
		

	// getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)));
	updateRecordItemCount();
	resetUI();
}


/** OnLoad */
function OnLoad()
{
	SetClosingOnESC();
	// util �ʱ�ȭ 
	util = L2Util(GetScript("L2Util"));	
	Initialize();
	categoryTreeInit();
	//resetUI();
}

/** UI�� ���� �Ѵ�. */
function resetUI()
{
	// ��� ���� , ���߸��̸� 99999 , �ƴϸ� 10�� 
	if (IsBuilderPC() ) maxSellingItemNum = 99999;
	else maxSellingItemNum = 10;
	
	//branch 110706
	//�����̾������� ����
	sellPremiumitemArray.Length = 0;
	//end of branch

	DisableCurrentWindow(false);
	TabCtrl.SetTopOrder(0, false);
	// �Ǹ� ����Ʈ ��� ����
	SellingItemListCtrl.DeleteAllItem();
	// ���� ����� �Ǹ� ����Ʈ ����
	MySellingItemListCtrl.DeleteAllItem();

	Type_Combobox.SetSelectedNum(0);
	Grade_Combobox.SetSelectedNum(0);

	SearchWord_Editbox.SetString("");
	MySellingItemNumber.SetText("");
	// ��� �� �ʱ�ȭ 
	MySellingPossibItem.Clear();
	MySellingItemIcon.Clear(); 
	comboInit();
	initRegistItemForm();
	// "��ü" �ʿ��� ���� �ϵ��� �ʱ�ȭ �Ѵ�.
	clickTreeState("root.list1");

	updateAdenaText();

	// SellingItemListCtrl.EnablePageBrowser(false);
	MySellingItemListCtrl.EnablePageBrowser(false);
}

/** Initialize */
function Initialize()
{
	Me = GetWindowHandle( "SellingAgencyWnd" );
	DisableWnd = GetWindowHandle( "SellingAgencyWnd.DisableWnd" );

	TabCtrl = GetTabHandle( "SellingAgencyWnd.TabCtrl" );
	TabLineBg = GetTextureHandle( "SellingAgencyWnd.TabLineBg" );
	TabBg = GetTextureHandle( "SellingAgencyWnd.TabBg" );
	SellingListWnd = GetWindowHandle( "SellingAgencyWnd.SellingListWnd" );
	DescriptionMsgWnd = GetWindowHandle( "SellingAgencyWnd.SellingListWnd.DescriptionMsgWnd" );
	DescriptionMsg = GetTextBoxHandle( "SellingAgencyWnd.SellingListWnd.DescriptionMsgWnd.DescriptionMsg" );
	Type_Title = GetTextBoxHandle( "SellingAgencyWnd.SellingListWnd.Type_Title" );

	// ���� (�޺�)
	Type_Combobox = GetComboBoxHandle( "SellingAgencyWnd.SellingListWnd.Type_Combobox" );
	Grade_Title = GetTextBoxHandle( "SellingAgencyWnd.SellingListWnd.Grade_Title" );
	// ������ ��� (�޺�)
	Grade_Combobox = GetComboBoxHandle( "SellingAgencyWnd.SellingListWnd.Grade_Combobox" );
	SearchWord_Title = GetTextBoxHandle( "SellingAgencyWnd.SellingListWnd.SearchWord_Title" );
	// �˻��� �Է� ������ �ڽ�
	SearchWord_Editbox = GetEditBoxHandle( "SellingAgencyWnd.SellingListWnd.SearchWord_Editbox" );

	SearchBtn = GetButtonHandle( "SellingAgencyWnd.SellingListWnd.SearchBtn" );
	ResetBtn = GetButtonHandle( "SellingAgencyWnd.SellingListWnd.ResetBtn" );
	SearchGroupBox = GetTextureHandle( "SellingAgencyWnd.SellingListWnd.SearchGroupBox" );
	Sort_Title = GetTextBoxHandle( "SellingAgencyWnd.SellingListWnd.Sort_Title" );

	// ������ 
	MyAdena  = GetTextBoxHandle( "SellingAgencyWnd.SellingListWnd.MyAdena" );
	MyAdena2 = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MyAdena2" );

	// �з� (�Ǹ� ��� Ʈ��)
	SortListTree = GetTreeHandle( "SellingAgencyWnd.SellingListWnd.SortListTree" );

	SortGroupbox = GetTextureHandle( "SellingAgencyWnd.SellingListWnd.SortGroupbox" );
	HelpHtmlWnd = GetWindowHandle( "SellingAgencyWnd.SellingListWnd.HelpHtmlWnd" );
	HelpHtmlWnd_Title = GetTextBoxHandle( "SellingAgencyWnd.SellingListWnd.HelpHtmlWnd.HelpHtmlWnd_Title" );
	HtmlViewer = GetHtmlHandle( "SellingAgencyWnd.SellingListWnd.HelpHtmlWnd.HtmlViewer" );
	//SortGroupbox = GetTextureHandle( "SellingAgencyWnd.SellingListWnd.HelpHtmlWnd.SortGroupbox" );

	// �Ǹ� ����Ʈ ������
	SellingItemListWnd = GetWindowHandle( "SellingAgencyWnd.SellingListWnd.SellingItemListWnd" );
	SellingItemList_Title = GetTextBoxHandle( "SellingAgencyWnd.SellingListWnd.SellingItemListWnd.SellingItemList_Title" );
	SellingItemNumber = GetTextBoxHandle( "SellingAgencyWnd.SellingListWnd.SellingItemListWnd.SellingItemNumber" );
	SellingItemListCtrl = GetListCtrlHandle( "SellingAgencyWnd.SellingListWnd.SellingItemListWnd.SellingItemListCtrl" );
	SellingItemListCtrlDeco = GetTextureHandle( "SellingAgencyWnd.SellingListWnd.SellingItemListWnd.SellingItemListCtrlDeco" );
	SellingItemListGroupbox = GetTextureHandle( "SellingAgencyWnd.SellingListWnd.SellingItemListWnd.SellingItemListGroupbox" );
	SellingItemListCtrlGroupboxDivider = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemListCtrlGroupboxDivider" );
	
	RefreshBtn = GetButtonHandle( "SellingAgencyWnd.SellingListWnd.RefreshBtn" );
	BuyBtn = GetButtonHandle( "SellingAgencyWnd.SellingListWnd.BuyBtn" );
	MyListWnd = GetWindowHandle( "SellingAgencyWnd.MyListWnd" );
	MyList_Title = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.MyList_Title" );
	MySellingItemList_Title = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.MySellingItemList_Title" );
	MySellingItemNumber = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.MySellingItemNumber" );
	// ���� ����� ������ ��� 
	MySellingItemListCtrl = GetListCtrlHandle( "SellingAgencyWnd.MyListWnd.MySellingItemListCtrl" );
	MySellingItemListCtrlDeco = GetTextureHandle( "SellingAgencyWnd.MyListWnd.MySellingItemListCtrlDeco" );
	SellCancelBtn = GetButtonHandle( "SellingAgencyWnd.MyListWnd.SellCancelBtn" );
	SellBtn = GetButtonHandle( "SellingAgencyWnd.MyListWnd.SellBtn" );
	MySellingItemListGroupbox = GetTextureHandle( "SellingAgencyWnd.MyListWnd.MySellingItemListGroupbox" );
	SellingItemRegistrationWnd = GetWindowHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd" );
	SellingItemRegistrationWind_Title = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.SellingItemRegistrationWind_Title" );
	SellingPossibItem_Title = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.SellingPossibItem_Title" );

	MySellingPossibItem = GetItemWindowHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingPossibItem" );
	MySellingPossibItembg = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingPossibItembg" );
	MySellingPossibItemGroupbox = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingPossibItemGroupbox" );
	MySellingItem_Title = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItem_Title" );
	MySellingItemIcon = GetItemWindowHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemIcon" );
	MySellingItemSlotBg = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemSlotBg" );
	MySellingItemName = GetNameCtrlHandle(   "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemName" );
	
	MySellingItemPropertyIcon_01 = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyIcon_01" );
	MySellingItemPropertyIcon_02 = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyIcon_02" );
	MySellingItemPropertyIcon_03 = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyIcon_03" );
	MySellingItemPropertyIcon_04 = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyIcon_04" );
	MySellingItemPropertyValue_01 = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyValue_01" );
	MySellingItemPropertyValue_02 = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyValue_02" );
	MySellingItemPropertyValue_03 = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyValue_03" );
	MySellingItemPropertyValue_04 = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemPropertyValue_04" );
	MySellingItemGroupbox = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemGroupbox" );
	MySellingItemUnitPrice_Title = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemUnitPrice_Title" );
	MySellingItemUnitPriceEditBtn = GetButtonHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemUnitPriceEditBtn" );
	MySellingItemUnitPriceAdenaIcon = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemUnitPriceAdenaIcon" );
	MySellingItemUnitPriceEdit = GetEditBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemUnitPriceEdit" );
	MySellingItemUnitPrice_ReadingText = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemUnitPrice_ReadingText" );
	MySellingItemAmount_Title = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemAmount_Title" );
	MySellingItemAmount = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemAmount" );
	GroupboxDivider_01 = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.GroupboxDivider_01" );
	MySellingItemRegistPeriod_Title = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemRegistPeriod_Title" );
	MySellingItemRegistPeriodComboBox = GetComboBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemRegistPeriodComboBox" );
	GroupboxDivider_02 = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.GroupboxDivider_02" );
	MySellingItemTotalPrice_Title = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemTotalPrice_Title" );
	//MySellingItemTotalPriceEditBtn = GetButtonHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemTotalPriceEditBtn" );
	MySellingItemTotalPriceAdenaIcon = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemTotalPriceAdenaIcon" );
	MySellingItemTotalPrice = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemTotalPrice" );
	MySellingItemTotalPrice_ReadingText = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemTotalPrice_ReadingText" );
	GroupboxDivider_03 = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.GroupboxDivider_03" );
	MySellingItemCharge_Title = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemCharge_Title" );
	MySellingItemChargeEditBtn = GetButtonHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemChargeEditBtn" );
	MySellingItemChargeAdenaIcon = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemChargeAdenaIcon" );

	MySellingItemCharge = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemCharge" );
	MySellingItemSellCharge = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemSellCharge" );
	
	MySellingItemChargeTextBoxBg = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemChargeTextBoxBg" );
	//MySellingItemCharge_ReadingText = GetTextBoxHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemCharge_ReadingText" );

	GroupboxDivider_04 = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.GroupboxDivider_04" );
	RegistBtn = GetButtonHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.RegistBtn" );
	CancelBtn = GetButtonHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.CancelBtn" );
	MySellingItemInfoGroupbox = GetTextureHandle( "SellingAgencyWnd.MyListWnd.SellingItemRegistrationWnd.MySellingItemInfoGroupbox" );

	m_inventoryWnd = GetWindowHandle( "InventoryWnd" );	//�κ��丮�� ������ �ڵ��� ���´�.

	MySellingItemListCtrlRect = MySellingItemListCtrl.GetRect();

	// ���� Ŭ�� ���ص� ��������..
	SellingItemListCtrl.SetSelectedSelTooltip(false);
	SellingItemListCtrl.SetAppearTooltipAtMouseX(true);

	MySellingItemListCtrl.SetSelectedSelTooltip(false);
	MySellingItemListCtrl.SetAppearTooltipAtMouseX(true);
}

/***
 * �Ƶ��� ������Ʈ 
 **/
function updateAdenaText()
{
	local string adenaString;
	
	adenaString = MakeCostString(string(GetAdena()));

	MyAdena.SetText(adenaString);
	MyAdena.SetTooltipString(ConvertNumToText(string(GetAdena())));

	MyAdena2.SetText(adenaString);
	MyAdena2.SetTooltipString(ConvertNumToText(string(GetAdena())));
}

/***
 * �޺� �ڽ� �ʱ� ����
 **/
function comboInit ()
{
	// ����
	Type_Combobox.Clear();
	Type_Combobox.SYS_AddString(144);
	Type_Combobox.SYS_AddString(2611);
	Type_Combobox.SYS_AddString(2621);
	Type_Combobox.SetSelectedNum(0);

	// ���
	Grade_Combobox.Clear();
	Grade_Combobox.SYS_AddString(144);  // ��ü
	Grade_Combobox.SYS_AddString(2622); // ����

	Grade_Combobox.SYS_AddString(2613); // D
	Grade_Combobox.SYS_AddString(2614); // C
	Grade_Combobox.SYS_AddString(2615); // B
	Grade_Combobox.SYS_AddString(2616); // A
	Grade_Combobox.SYS_AddString(2617); // S

	Grade_Combobox.SYS_AddString(2682); // S80
	//branch 110706_110804
	//Grade_Combobox.SYS_AddString(2683); // S84
	//end of beanch

	Grade_Combobox.SYS_AddString(2618); // R
	Grade_Combobox.SYS_AddString(2619); // R95
	Grade_Combobox.SYS_AddString(2620); // R99
	Grade_Combobox.SYS_AddString(3919); // R110
	Grade_Combobox.SetSelectedNum(0);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// �̺�Ʈ -> �ش� �̺�Ʈ ó�� �ڵ鷯
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnEvent( int Event_ID, string param )
{
	//Debug("==========================================================================");
	//Debug("Event_ID : " @ Event_ID);
	//Debug("param    : " @ param);

	switch (Event_ID)
	{
		// â ����
	    case EV_ItemCommissionWndShow               : updateAdenaText(); itemCommissionWndShowHandler(param); break;
	    //branch110706
	    case EV_ItemCommissionWndSellingPremiumItemRegisterReset : debug("�ǸŴ��� ���ξ����� ����" ); updateAdenaText(); SellingPremiumItemRegisterReset(param); break;
	    case EV_ItemCommissionWndSellingPremiumItemRegister : debug("�ǸŴ��� ���ξ�����" @ param); updateAdenaText(); SellingPremiumItemRegisterAdd(param); break;
	    //end of branch	    
		// ������ ��� �ޱ� 
		case EV_ItemCommissionWndListStart          : updateAdenaText(); startListHandler(param); break;
		case EV_ItemCommissionWndEachItem           : updateAdenaText(); addElementAtList(param); break;

		// �Ǹ� ������ ������ ����Ʈ �ޱ� 
		case EV_ItemCommissionWndRegistrableItemCnt : updateAdenaText(); itemCommissionWndListStartHandler(param); break;
		// ��� ���� �����ۿ� �ϳ��� �߰�
		case EV_ItemCommissionWndRegistrableItemList: updateAdenaText(); registrableItemAdd(param); break;

		// ���� �÷ȴٸ� ���ݰ� ������ ���� �޴´�.		
		case EV_ItemCommissionWndResponseInfo       : updateAdenaText(); itemCommissionWndResponseInfoHandler(param); break;

		// ��� ���
		case EV_ItemCommissionWndRegisterResult     : updateAdenaText(); itemCommissionWndRegisterResultHandler(param); break;		

		// ��� �� �� ����
		case EV_ItemCommissionWndDeleteResult       : updateAdenaText(); ItemCommissionWndDeleteResultHandler(param); break;

		// ���Կ�û�Լ� �̺�Ʈ
		case EV_ItemCommissionWndBuyInfo            : updateAdenaText(); askDialogBuyItem(param);  break;
  
		// ���� ���
		case EV_ItemCommissionWndBuyResult          : updateAdenaText(); ItemCommmissionWndBuyResultHandler(param);  break;

		// �ǸŴ��� npc�� ���� �Ÿ��� �������� , â�� �ݴ´�.
		case EV_ItemCommissionWndCloseCauseOfLongDistance : OnReceivedCloseUI(); break;

		// TTP #59728 - gorillazin 13.01.09.
		//case EV_ItemCommissionWndSearchFail         : updateAdenaText(); itemCommissionWndSearchFailHandler(); break;
		case EV_ItemCommissionWndSearchFail         : updateAdenaText(); itemCommissionWndSearchFailHandler(param); break;
		//
		case EV_DialogOK                            : updateAdenaText(); HandleDialogOK(); break;
		case EV_DialogCancel                        : updateAdenaText(); HandleDialogCancel(); break;

		case EV_Restart: break;

		//���� �̿��ڰ� �Ǹ� ����� ���� ��
		case EV_ItemCommissionRegisterWndCloseCauseOfFreeUser:		
			DialogSetID( DIALOG_FREEUSER_ONREGISTE  );
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage( 4049 ), string(Self) );
		break;


	}
}

function OnHide()
{
	if( DialogIsMine() )
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		DialogHide();
	}
	// ��� �õ���, ������ ��� �ִ� �������� ������ ��� ��Ų��.
	callRequestCommissionCancel();
	resetUI();
}

/**  ������ �Ǹ� ���� ������ ���� */
function itemCommissionWndShowHandler(string param)
{
	local int Result;
	
	ParseInt(param, "Result", Result);

	if (Result == 1)
	{
		resetUI(); 
		Me.ShowWindow();
	}
}

/** ������ ����� ����� ���� ó�� */
function itemCommissionWndListStartHandler(string param)
{
	local int cnt;
	
	ParseInt(param, "cnt", cnt);

	if (cnt <= 0) 
	{
		if (SellingListWnd.IsShowWindow())
		{
			DescriptionMsgWnd.ShowWindow();
			DescriptionMsg.SetText(GetSystemMessage(3369));
		}
	}
	MySellingPossibItem.Clear();
	MySellingItemIcon.Clear();
	updateSellRegisterForm();
}

/** �˻� ���� */
// TTP #59728 - gorillazin 13.01.09.
//function itemCommissionWndSearchFailHandler()
function itemCommissionWndSearchFailHandler(string param)
//
{
	//Debug("--> �˻� ���� �̺�Ʈ �߻�" @ currentTreeNodeSelected);
	// TTP #59728 - gorillazin 13.01.09.
	local int failReason;
	ParseInt(param, "ErrorMsg", failReason);
	//

	// �� ������ ��� ����
	if (TabCtrl.GetTopIndex() == 1) MySellingItemListCtrl.DeleteAllItem();	

	// TTP #59728 - gorillazin 13.01.09.
	if (failReason == SEARCH_FAIL_REASON_DELAY)
	{
		startReSearchDelay();

		return;
	}
	//

	if (currentTreeNodeSelected != "root.list0")
	{
		SellingItemListCtrl.DeleteAllItem();

		DescriptionMsgWnd.ShowWindow();

		// ���� ����� ������ ��� ī��Ʈ 
		MySellingItemNumber.SetText( "(" $ String(MySellingItemListCtrl.GetRecordCount()) $ "/" $ maxSellingItemNum $ ")");

		//DescriptionMsg.SetText(GetSystemMessage(3372));

		if (SearchWord_Editbox.GetString() == "")
		{
			DescriptionMsg.SetText(GetSystemMessage(3372));
		}
		else
		{
			// DescriptionMsg.SetText("\"" $ SearchWord_Editbox.GetString() $ "\"" @ "\\n �� �Ǹ� ��Ͽ� �������� �ʽ��ϴ�.");
			DescriptionMsg.SetText(MakeFullSystemMsg(GetSystemMessage(3502), SearchWord_Editbox.GetString()));
		}
		
		// 3502 // $1 �������� �Ǹ� ��Ͽ� �������� �ʽ��ϴ�.

		// �Ǹ� ���� ������ ����Ʈ
		SellingItemNumber.SetText( "(" $ String(SellingItemListCtrl.GetRecordCount()) $ ")");
	}
}

/***
 *  ���� �Ϸ� 
 **/
function ItemCommmissionWndBuyResultHandler(string param)
{
	local int Result, Enchant, ClassId;
	local ItemID mItemID;
	local INT64 Amount;

	local ItemInfo targetItemInfo;

	ParseInt(param, "Result" , Result);
	ParseInt(param, "Enchant", Enchant);
	ParseINT64(param, "Amount" , Amount);

	ParseInt(param, "ClassId", ClassId);

	mItemID.ClassID = ClassId;

	class'UIDATA_ITEM'.static.GetItemInfo(mItemID, targetItemInfo );
	
	if (Result == 1)
	{
		// Debug("���� �Ϸ� " @ param );
		targetItemInfo.Enchanted = Enchant;
		targetItemInfo.AllItemCount = Amount;

		AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(3530), getItemNameForSellingAgency(targetItemInfo), String(Amount))); 
	}

	else
	{
//		Debug("���� �� ���� " @ param );
	}

	Me.EnableWindow();
	// �ٽ� ���� ����Ʈ�� ����.
	sellListSearch();
}

/** ���� ����� ����Ʈ ���� ItemCommissionWndDeleteResult   */
function ItemCommissionWndDeleteResultHandler(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);

	// Debug("deleteIndexMySellingItemListCtrl:" @ deleteIndexMySellingItemListCtrl);

	if (Result == 1)
	{
		
		// if (deleteIndexMySellingItemListCtrl >= 0) { Debug("deleteIndexMySellingItemListCtrl" @ deleteIndexMySellingItemListCtrl); };
		// MySellingItemListCtrl.DeleteRecord(deleteIndexMySellingItemListCtrl);
	}
	else
	{
		//Debug("�Ǹ� ���! ���� ");
	}

	// ������ ī��Ʈ
	if (listCommissionStatus == 2)
	{
		// ���� �Ǹ� ����� ������ ����Ʈ
		MySellingItemNumber.SetText( "(" $ String(MySellingItemListCtrl.GetRecordCount()) $ "/" $ maxSellingItemNum $ ")");
		
	}
	else
	{
		// �Ǹ� ���� ������ ����Ʈ
		SellingItemNumber.SetText( "(" $ String(SellingItemListCtrl.GetRecordCount()) $ ")");
	}

	// ���� 
	clickTabButton("TabCtrl1");
}

/** �ǸŴ��� ����Ʈ�� ��� �� ������ ���, ���� ����� ������ ����� �޾� �´�. */
function startListHandler(string param)
{
	local int moreThanMax, listType, continuousList;

	// TTP #59728 - gorillazin 13.01.09.
	DescriptionMsgWnd.HideWindow();
	DescriptionMsg.SetText("");
	//

	// 1000�� ������..
	ParseInt(param, "MoreThanMax", moreThanMax);

	ParseInt(param, "ListType", listType);
	ParseInt(param, "ContinuousList", continuousList);

	// �˻� ����� ��� ������ �ִ� ������ �ʰ��Ͽ����ϴ�.
	if(moreThanMax != 0) AddSystemMessage(3489);

	listCommissionStatus = listType;
	// ���� ������ ��� ������ ����Ÿ ����. 1�� ��� ���� �����ؼ� ��� ���� ���̱� ������ ���� ���� ���� ���� ���� ����.
	if (continuousList == 0)
	{
		// Debug(CommissionStatus.CsRegisteredOk);

		//  namespace CommissionStatus 
		//	enum Enum 
		//	{ 
		//	CsRegisteredFail = -2, 
		//	CsSearchFail = -1, 
		//	CsFail = 0, 
		//	CsOk, 
		//	CsRegisteredOk, 
		//	CsSearchOk, 
		//	CsStatusMAX 
		//	}; 

		switch(listType)
		{
			case 1 : SellingItemListCtrl.DeleteAllItem();   break;
			case 2 : MySellingItemListCtrl.DeleteAllItem(); break;
			case 3 : SellingItemListCtrl.DeleteAllItem();   break;
			case 4 : break;

			default : Debug("ListStart Error:" @ param);
		}
	}
}

/** �̺�Ʈ : ��� �������� ���,   */
function itemCommissionWndResponseInfoHandler (string param)
{
	local int Result, ClassID, Period;

	local INT64 prePrice, Amount;
	local itemInfo initInfo;

	ParseInt( param, "Result", Result );
	ParseInt( param, "ClassID", ClassID );
	ParseInt( param, "Period", Period );
	
	ParseINT64( param, "Amount", Amount );
	ParseINT64( param, "prePrice", prePrice );

	// Debug("Result: "@ Result);
	// Debug("ClassID: "@ ClassID);
	// Debug("prePrice: "@ prePrice);
	
	// Debug("startItemWIndowName: " @ startItemWIndowName);
	// Debug("nSaveTempItemIndex : " @ nSaveTempItemIndex);
	// Debug("MySellingPossibItem: " @ MySellingPossibItem);

	if (startItemWIndowName == "MySellingItemIcon")
	{
		MoveItemTopToBottom( nSaveTempItemIndex, false );
	}
	else if (startItemWIndowName == "MySellingPossibItem")
	{
		MoveItemBottomToTop( nSaveTempItemIndex, false );
	}

	if (Result == 1)
	{	
		// Debug("beforeDropItemInfo.itemNum" @ beforeDropItemInfo.itemNum);
		if (beforeDropItemInfo.AllItemCount > 0 ) 
		{
			// 4�ڸ� �ִ� �� 
			if (beforeDropItemInfo.itemNum > MAX_SELLING_AMOUNT)
			{
				// ���� �� �ִ� �ִ� ������ ���� 99999�� �ִ´�.
				DialogSetString(String(MAX_SELLING_AMOUNT));
			}
			else
			{
				// ���� ���� ��� �����ۼ�
				DialogSetString(String(beforeDropItemInfo.itemNum));
			}
		}
		else
		{
			// ������ ���� �ߴ� ���� ���
			// 1���� ũ�ٸ� ���������� ���
			if (Amount >= 1) DialogSetString(String(Amount));
		}

		//debug("beforeDropItemInfo.AllItemCount" @ beforeDropItemInfo.AllItemCount);
		//debug("beforeDropItemInfo.itemNum---> " @ beforeDropItemInfo.itemNum);
		//debug("Amount---> " @ Amount);
		//debug("beforeDropItemInfo.ConsumeType : " @ beforeDropItemInfo.ConsumeType);
		//debug("IsStackableItem( beforeDropItemInfo.ConsumeType ): " @ IsStackableItem( beforeDropItemInfo.ConsumeType ));

		// ������ �������� �ƴϸ� �������� ��Ŀ�� �ѱ�
		if (beforeDropItemInfo.itemNum > 1 || Amount > 1 || IsStackableItem( beforeDropItemInfo.ConsumeType ))
		{
			// empty �ƹ��͵� ����
		}
		else
		{
			MySellingItemUnitPriceEdit.SetFocus();
		}

		if (Period >= 0) MySellingItemRegistPeriodComboBox.SetSelectedNum(Period);
		if (prePrice > 0) MySellingItemUnitPriceEdit.SetString(string(prePrice));

		beforeAmount   = Amount;
		beforePeriod   = Period;
		beforePrePrice = prePrice;

		updateSellRegisterForm();
	}
	else
	{
		startItemWIndowName = "";
	}

	// ���� ��� �ߴ� ������ �ʱ�ȭ
	beforeDropItemInfo = initInfo;
}

/** �̺�Ʈ : ������ ��� �Ϸ� ��� */
function itemCommissionWndRegisterResultHandler (string param)
{
	local int Result, Ok;

	ParseInt( param, "Result", Result );
	ParseInt( param, "Ok", Ok );

	if (Result == 1 || Ok == 1)
	{
		//Debug("������ ��� �Ϸ� -> RequestCommissionRegisteredItem ���� ");
		// ����� ������ ����
		// class'consignmentSaleAPI'.static.RequestCommissionRegisteredItem(); 
	}
	else
	{
		//Debug("������ ��� ����");
	}

	// ������ ��� ����, ���� ���� ���� �ٽ� "��ϰ����� ������" ����
	//class'consignmentSaleAPI'.static.RequestCommissionRegisteredItem(); 
	
	// �Ǹ� ���� ������ �ö� ���� ����
	// MySellingItemIcon.Clear();
	// �Ǹ� ���࿡ �÷��� �������� ���ٸ�.. �ʱ�ȭ
	//initRegistItemForm();

	// ��� �� ��ȸ �κ� ��ü �ʱ�ȭ
	OnClickButton("TabCtrl1");
}


/***
 *  ��� ���� ������ 
 *  �� �������� �߰� �Ѵ�.  
 **/
function registrableItemAdd(string param)
{
	local ItemInfo info;
	
	ParamToItemInfo( param, info );	
	MySellingPossibItem.AddItem(info);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ������ �����츦 ���� Ŭ�� �̺�Ʈ (�������� ���Ϸ� �̵�)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/** Desc :  ����, ������ ����� �������� "���� Ŭ��"  */
function OnDBClickItem( string ControlName, int index )
{
	local ItemInfo info;
	// local int nSelect; //, itemType;

	// Debug("ControlName:" @ControlName);
	if(ControlName == "MySellingPossibItem")
	{
		// MySellingItemIcon.GetItem(0, info);

		MySellingPossibItem.GetItem(index, info);
		nSaveTempItemIndex = index; // MySellingPossibItem.FindItem(info.ID );

		// debug("index:" @ index);
		// debug("info.name:" @ info.name);
		// Debug("info.AllItemCount  : "  @ info.AllItemCount);
		// Debug("nSaveTempItemIndex : "  @ nSaveTempItemIndex);

		saveTempItemInfo = info;
		beforeDropItemInfo = info;
		startItemWIndowName = "MySellingItemIcon";
		callRequestCommissionInfo(info);
	}
	else if(ControlName == "MySellingItemIcon")
	{		
		MySellingItemIcon.GetItem(index, info);
		if(index >= 0) MoveItemBottomToTop(index, false);
	}
}

//���ڵ带 ����Ŭ���ϸ�....
function OnDBClickListCtrlRecord( string ListCtrlID)
{
	//local LVDataRecord	record;	

	if (ListCtrlID == "SellingItemListCtrl")
	{
		OnBuyBtnClick();
	}
	if (ListCtrlID == "MySellingItemListCtrl")
	{
		// ��� ���� ���°� �ƴҶ� �Ǹ� ��� �����ϴϱ�..
		OnSellCancelBtnClick();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ������ ������ -> �巡�� �̺�Ʈ
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/** Desc : ����, �������� "���"  */
function OnDropItem( string strID, ItemInfo info, int x, int y)
{
	local int index;
	local itemInfo initInfo;

	// debug("OnDropItem strID " $ strID $ ", src=" $ info.DragSrcName);
	
	index = -1;
	
	if(info.DragSrcName == "MySellingPossibItem") //&& strID == "MySellingItemIcon")
	{
		index = MySellingPossibItem.FindItem(info.ID );
		nSaveTempItemIndex = index;
		saveTempItemInfo = info;
		startItemWIndowName = strID;

		beforeDropItemInfo = info;
		//if (info.AllItemCount > 0 ) allItemCountFlag = true;
		// else allItemCountFlag = false;

		callRequestCommissionInfo(info);
	}
	else if(info.DragSrcName == "MySellingItemIcon") // && strID == "MySellingPossibItem")
	{
		beforeDropItemInfo = initInfo;
		//Find With ServerID
		index = MySellingItemIcon.FindItem(info.ID );
		if( index >= 0 ) MoveItemBottomToTop( index, info.AllItemCount > 0 );
	}
}

/**
 * 
 *  �κ��丮 -> �Ǹ� ���� ��� ������ ���������� �̵�
 *  (���� ���� �ʿ��� �ۿ��� -_-;)
 *  
 **/
function MoveItemTopToBottom(int index, bool bAllItem)
{
	local ItemInfo info, topInfo;
	local int topIndex;

	if(MySellingPossibItem.GetItem(index, info))
	{
		// debug("info.ConsumeType" @ info.ConsumeType);
		// debug("info.ItemNum" @ info.ItemNum);
		// � �ű���� �����
		if(!bAllItem && IsStackableItem( info.ConsumeType ) && info.ItemNum >= 1)
		{

			DisableCurrentWindow(true);
			DialogSetID( DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY  );
			DialogSetEditBoxMaxLength(6);
			// ServerID
			DialogSetReservedItemID( info.ID );
			DialogSetParamInt64( info.ItemNum );
			DialogSetDefaultOK();

			// getItemNameForSellingAgency(targetItemInfo, targetItemInfo.name, targetItemInfo.AdditionalName, Enchant)

			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(3496), info.Name, "" ), string(Self) );
		}
		else
		{
			// ����� �����۰� ���� �巡�� �� �������� �ٸ� ������ �̶��..
			if (mysellingitemicon.finditem( info.id ) == -1 && mysellingitemicon.getItemNum() > 0)
			{
				// ��ü�� �̵�
				moveItembottomtotop(0, true);
			}

			// debug("mysellingitemicon.finditem( info.id )" @ mysellingitemicon.finditem( info.id ));

			MySellingPossibItem.DeleteItem( index );

			topindex = MySellingItemIcon.FindItem(info.ID );			// ServerID

			if( topIndex >=0 && IsStackableItem( info.ConsumeType ) )	// ������ �������̸� ������ ������Ʈ
			{
				MySellingItemIcon.GetItem( topIndex, topInfo );
				topInfo.ItemNum += info.ItemNum;
				MySellingItemIcon.SetItem( topIndex, topInfo );
			}
			else
			{
				MySellingItemIcon.AddItem( info );
			}

			// �Ӽ� ������Ʈ 
			updateAttributeRegistItemForm(info);
		}
	}

	updateSellRegisterForm();
}

/**
 * 
 *   �Ǹ� ���� ��� ������ ������ -> �κ��丮���� �̵�
 *  
 **/
function MoveItemBottomToTop(int index, bool bAllItem)
{	
	local ItemInfo info, topInfo;
	local int topIndex;

	if(MySellingItemIcon.GetItem(index, info))
	{
		// � �ű���� �����
		if(!bAllItem && IsStackableItem(info.ConsumeType) && info.ItemNum > 1)
		{
			DisableCurrentWindow(true);
			DialogSetID(DIALOG_STACKABLE_ITEM_ACCOMPANY_TO_INVEN);
			DialogSetEditBoxMaxLength(6);
			// ServerID
			DialogSetReservedItemID( info.ID );
			DialogSetParamInt64( info.ItemNum );

			DialogSetDefaultOK();	
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(3496), info.Name, "" ), string(Self) );
		}
		else
		{
			//callRequestCommissionCancel();
			MySellingItemIcon.DeleteItem( index );

			topindex = MySellingPossibItem.FindItem(info.ID );		                // ServerID

			if( topIndex >=0 && IsStackableItem( info.ConsumeType ) )	           	// ������ �������̸� ������ ������Ʈ
			{
				MySellingPossibItem.GetItem( topIndex, topInfo );
				topInfo.ItemNum += info.ItemNum;
				MySellingPossibItem.SetItem( topIndex, topInfo );
			}
			else
			{
				MySellingPossibItem.AddItem( info );
			}
		}	
	}
	updateSellRegisterForm();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ���̾�α� �ڽ� ó�� 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/** Desc : ���̾�α� �����츦 ���� OK ��ư ���� ��� */
function HandleDialogOK()
{
	local int id, bottomIndex, topIndex;
	local ItemInfo bottomInfo, topInfo;
	local ItemID scID;
	local ItemInfo scInfo;
	local INT64 inputNum;

	if(DialogIsMine())
	{
		id = DialogGetID();

		inputNum = INT64(DialogGetString());
		scID = DialogGetReservedItemID();
		DialogGetReservedItemInfo(scInfo);

		// ���̾�α״� ���ʴ�� ���� ����(DIALOG_ASK_PRICE)->
		// ������ �⺻ ���ݰ� ���̰� �� ��� ���� Ȯ��(DIALOG_CONFIRM_PRICE)->
		// �������̵�(DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY)�� ������� ���ȴ�

		// ������� �������� �ű��.
		if(id == DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY && inputNum > 0)
		{
			MoveItemBottomToTop(0, true);
			// <- ServerID ->
			topIndex = MySellingPossibItem.FindItem (scID);
			if( topIndex >= 0 )
			{
				MySellingPossibItem.GetItem(topIndex, topInfo);
				// <- ServerID ->
				bottomIndex = MySellingItemIcon.FindItem(scID);
				MySellingItemIcon.GetItem(bottomIndex, bottomInfo);

				// �Ʒ��ʿ� �̹� �ִ� �������̰� ������ �������̶�� ������ ����� ������ �����ش�.
				//if( bottomIndex >= 0 && IsStackableItem(bottomInfo.ConsumeType))
				//{
				//	bottomInfo.Price = DialogGetReservedInt2();
				//	bottomInfo.ItemNum += Min64(inputNum, topInfo.ItemNum);
				//	MySellingItemIcon.SetItem(bottomIndex, bottomInfo);
				//}
				//// ���ο� �������� �ִ´�
				//else
				//{
				//	if (MySellingItemIcon.FindItem( bottomInfo.ID ) == -1 && MySellingItemIcon.GetItemNum() > 0)
				//	{
				//		// ��ü�� �̵�
				//		MoveItemBottomToTop(0, true);
				//	}
				//	bottomInfo = topInfo;
				//	bottomInfo.ItemNum = Min64( inputNum, topInfo.ItemNum );
				//	bottomInfo.Price = DialogGetReservedInt2();
				//	MySellingItemIcon.AddItem( bottomInfo );
				//}

				if (MySellingItemIcon.GetItemNum() > 0)
				{
					// ��ü�� �̵�
					MoveItemBottomToTop(0, true);
				}
				bottomInfo = topInfo;
				bottomInfo.ItemNum = Min64( inputNum, topInfo.ItemNum );
				bottomInfo.Price = DialogGetReservedInt2();
				MySellingItemIcon.AddItem( bottomInfo );

				// ���� �������� ó��
				topInfo.ItemNum -= inputNum;
				if( topInfo.ItemNum <= 0 )
					MySellingPossibItem.DeleteItem( topIndex );
				else
					MySellingPossibItem.SetItem( topIndex, topInfo );
			}

			//if (beforeAmount > 1) DialogSetString(String(beforeAmount));
			if (beforePeriod >= 0) MySellingItemRegistPeriodComboBox.SetSelectedNum(beforePeriod);
			if (beforePrePrice > 0) MySellingItemUnitPriceEdit.SetString(string(beforePrePrice));

			updateSellRegisterForm();
		}
		// �Ʒ��� ���� ���� ���� �Ű��ش�.
		else if(id == DIALOG_STACKABLE_ITEM_ACCOMPANY_TO_INVEN && inputNum > 0)
		{

			// <- ServerID ->
			bottomIndex = MySellingItemIcon.FindItem(scID);
			if( bottomIndex >= 0 )
			{
				MySellingItemIcon.GetItem(bottomIndex, bottomInfo);

				// <- ServerID ->
				topIndex = MySellingPossibItem.FindItem( scID );

				if( topIndex >=0 && IsStackableItem(bottomInfo.ConsumeType))
				{
					MySellingPossibItem.GetItem( topIndex, topInfo );
					topInfo.ItemNum += Min64( inputNum, bottomInfo.ItemNum );
					MySellingPossibItem.SetItem( topIndex, topInfo );
				}
				else
				{
					topInfo = bottomInfo;
					topInfo.ItemNum = Min64( inputNum, bottomInfo.ItemNum );
					MySellingPossibItem.AddItem( topInfo );
				}

				bottomInfo.ItemNum -= inputNum;
				if( bottomInfo.ItemNum > 0 )
				{
					MySellingItemIcon.SetItem( bottomIndex, bottomInfo );
				}
				else 
				{
					//callRequestCommissionCancel();
					MySellingItemIcon.DeleteItem( bottomIndex );
				}
			}
			updateSellRegisterForm();
		}
		else if (id == DIALOG_ASK_PRICE)
		{
			MySellingItemUnitPriceEdit.SetString(String(inputNum));
		}
		else if (id == DIALOG_ASK_REGISTITEM)
		{
			// ���� �������� ��� �Ѵ�.
			callRequestCommissionRegister();
		}
		else if (id == DIALOG_ASK_BUY)
		{
			callRequestCommissionBuyItem();
		}
		else if (id == DIALOG_ASK_DELETE)
		{
			callRequestCommissionDelete();
			// callRequestCommissionBuyItem();
		}
		else if ( id == DIALOG_FREEUSER_ONREGISTE ) 
		{
			TabCtrl.SetTopOrder(0, false);
		}

		///////////////////
		updateSellRegisterForm();
	}
	DisableCurrentWindow(false);
} 

/** Desc : ���̾�α� �����츦 ���� Cancel ��ư ���� ��� */
function HandleDialogCancel() //��Ƽ���ú��� ����â 
{
	if( DialogIsMine() )
	{
		// empty
	}

	// �ٸ� ���̾�αװ� ĵ�� �Ǿ������� ��Ȱ��ȭ�� Ǯ��� �Ѵ�.
	DisableCurrentWindow(false);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// OnComboBoxItemSelected  �޺��ڽ��� ����
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnComboBoxItemSelected( string comboName, int index ) 
{
	/// local PartyWnd script;

	//  Debug("comboName" @ comboName);
	//	Debug("index" @ index);
	switch( comboName )
	{
		case "Type_Combobox": 
			 // nCurrentTypeCombo = Type_Combobox.GetSelectedNum();
			 OnSearchBtnClick();
			 break;

		case "Grade_Combobox":	
			 OnSearchBtnClick();
			 // nCurrentGradeCombo = Grade_Combobox.GetSelectedNum();
			 break;
		case "MySellingItemRegistPeriodComboBox" : updateSellRegisterForm(); // ��� �Ⱓ ����, �� ������Ʈ
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  ����Ʈ Ŭ�� (������ ��û)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnClickListCtrlRecord( string ListCtrlID)
{
	local LVDataRecord Record;

	local string param;
	local int nSelect; //, itemType;

	nSelect = SellingItemListCtrl.GetSelectedIndex();

	if (nSelect >= 0) 
	{
		SellingItemListCtrl.GetSelectedRec(record);

		param = Record.szReserved;
		// Debug("Click Item param=>" @ param);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ��ư Ŭ�� - ���� ��ư Ŭ�� �ڵ鷯
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnClickButton( string Name )
{
	// Debug("OnClickButton" @ Name);
	switch( Name )
	{
		case "SearchBtn":
			OnSearchBtnClick();
			break;
		case "ResetBtn":
			OnResetBtnClick();
			break;
		case "RefreshBtn":
			OnRefreshBtnClick();
			break;
		case "BuyBtn":
			OnBuyBtnClick();
			break;
		case "SellBtn" :
			// �Ǹ� ��� ��ư�� Ŭ���Ͽ� �Ǹ� ������ ��� â�� ����.
			SellingItemRegistrationWndShow();
			break;
		case "SellCancelBtn":
			//����Ʈ���� �׸��� �ϳ� �����ؼ� �Ǹ� ��� ��ư Ŭ���ϸ� �ش� ������ ��� ���
			OnSellCancelBtnClick();
			break;
		case "MySellingItemUnitPriceEditBtn":
			// ���� ���� ���� �������� 
			OnMySellingItemUnitPriceEditBtnClick();
			break;
		case "RegistBtn":
			// ������ �Ǹ� ����� �������� �ø���.
			// callRequestCommissionInfo();
			askDialogRegisterItem();
			// callRequestCommissionRegister();
			break;
		case "CancelBtn":
			callRequestCommissionCancel();
			// MySellingItemListCtrlExtend(true);
			break;
		case "TabCtrl0"  : 
		case "TabCtrl1"  : updateAdenaText(); clickTabButton(Name); break;
	}

	// Ʈ�� Ŭ�� 
	clickTreeState (Name);
	
}

/** �� ��ư�� Ŭ���� ��� ó�� */
function clickTabButton(string tabName)
{
	// Debug("GetTopIndex()" @ GetTabHandle("TabCtrl").GetTopIndex());
	switch(tabName)
	{
		case "TabCtrl0" : 
			// callRequestCommissionCancel();
			// DisableCurrentWindow(false);
			// Me.KillTimer( TIMER_SEARCH_ID );
			//// clickTreeState(currentTreeNodeSelected);
			OnSearchBtnClick();
			break;

		case "TabCtrl1" : // ����� ������ ����Ʈ ��� ����
			callRequestCommissionCancel();
			SellingItemRegistrationWndShow();
			class'consignmentSaleAPI'.static.RequestCommissionRegisteredItem();

			// ���� �Ȱ� �ִ� ������ ��� Ȯ��
			// MySellingItemListCtrlExtend(true);
			// ������ Ÿ�̸Ӱ� ���� ���� �ִ°� �ִٸ� �۵��� ���߰� �Ѵ�.
			// Me.KillTimer( TIMER_SEARCH_ID );
			DisableCurrentWindow(false);
			Break;
	}
}

/** �˻� ��ư Ŭ�� */
function OnSearchBtnClick()
{
	// ���� ���°� �ƴ϶��..
	if (currentTreeNodeSelected != "root.list0" && disableCurrentWindowFlag == false)
	{
		if (currentTreeNodeSelected == "root.list1")
		{
			SellingItemListWnd.ShowWindow();
			// ��ü
			HelpHtmlWnd.HideWindow();
			if (SearchWord_Editbox.GetString() == "")
			{
				SellingItemListCtrl.DeleteAllItem();
				DescriptionMsgWnd.ShowWindow();
				DescriptionMsg.SetText(GetSystemMessage(3444));
				SellingItemNumber.SetText("");
			}
			else
			{
				SellingItemListWnd.ShowWindow();
				SellingItemNumber.SetText("");
				sellListSearch();
			}
			//SearchWord_Editbox.EnableWindow();
		}
		else
		{
			sellListSearch();
		}
	}	

	SearchWord_Editbox.SetFocus();
}

/** �ʱ�ȭ ��ư Ŭ�� */
function OnResetBtnClick()
{
	// ����, ���, �˻��� �ʱ�ȭ 
	SearchWord_Editbox.SetString("");
	Type_Combobox.SetSelectedNum(0);
	Grade_Combobox.SetSelectedNum(0);

	OnSearchBtnClick();
}

/** ������ ��� (���Ÿ��) ���� ��ư */
function OnRefreshBtnClick()
{
	sellListSearch();
}

/** ���� ��ư�� Ŭ�� (�ش� ������ Ȯ�� �� ���� ���μ���) */
function OnBuyBtnClick()
{
	local int nSelect; //, itemType;

	nSelect = SellingItemListCtrl.GetSelectedIndex();

	if (nSelect >= 0)
	{
		callRequestCommissionBuyInfo();
	}
	else
	{
		// ������ ��Ͽ��� ��ǰ�� �������ֽʽÿ�.
		AddSystemMessage(3443);
	}
}

/** �Ǹ� ��� */
function OnSellCancelBtnClick()
{
	local int nSelect;

	nSelect = MySellingItemListCtrl.GetSelectedIndex();

	if (nSelect >= 0)
	{
		askDialogDeleteItem();
	}
	else
	{
		// ������ ��Ͽ��� ��ǰ�� �������ֽʽÿ�.
		AddSystemMessage(3443);
	}
}

/** ���� �Ǹ� ���� �Է� ���� */
function OnMySellingItemUnitPriceEditBtnClick()
{
	local ItemInfo info;

	if (MySellingItemIcon.GetItemNum() > 0)
	{
		MySellingItemIcon.GetItem(0, info);

		// Ask price
		DialogSetID( DIALOG_ASK_PRICE );
		DialogSetReservedItemID( info.ID );				// ServerID
		//DialogSetReservedInt3( int(bAllItem) );		// ��ü�̵��̸� ���� ���� �ܰ踦 �����Ѵ�
		DialogSetEditType("number");
		DialogSetParamInt64( -1 );
		DialogSetDefaultOK();
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(322), string(Self) );
		DisableCurrentWindow(true);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ŭ���̾�Ʈ - ���� ���� API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/***
 * ������ ������ Ȯ�� API 
 **/
function callRequestCommissionBuyInfo()
{
	local LVDataRecord Record;
	local INT64  commissionDBId, commissionItemType;

	local string param;
	local int nSelect; //, itemType;

	nSelect = SellingItemListCtrl.GetSelectedIndex();

	if (nSelect >= 0) 
	{
		SellingItemListCtrl.GetSelectedRec(record);

		param = Record.szReserved;

		ParseINT64(param, "CommissionItemType", commissionItemType);
		ParseINT64(param, "CommissionDBId", commissionDBId);

		// ParseInt(param, "itemType", itemType);

		// �����۱��� API ����
		//Debug("������ ���� RequestCommissionBuyInfo -> ");
		//Debug("CommissionDBId " @ CommissionDBId);
		//Debug("commissionItemType " @ commissionItemType);
		// Debug("itemType " @ itemType);

		class'consignmentSaleAPI'.static.RequestCommissionBuyInfo(commissionDBId, Int(commissionItemType)); 
	}
}

/**
 * ������ ���� API
 **/
function callRequestCommissionBuyItem()
{
	local LVDataRecord Record;
	local INT64 commissionItemType, commissionDBId;

	local string param;
	local int nSelect; //, itemType;

	nSelect = SellingItemListCtrl.GetSelectedIndex();

	if (nSelect >= 0) 
	{ 
		SellingItemListCtrl.GetSelectedRec(record);

		param = Record.szReserved;

		ParseINT64(param, "CommissionDBId"    , commissionDBId);
		ParseINT64(param, "CommissionItemType", commissionItemType);

		//Debug("���� �õ� ! consignmentSaleAPI()-> ");
		//Debug("CommissionDBId !" @ CommissionDBId );
		//Debug("commissionItemType !" @ commissionItemType );

		class'consignmentSaleAPI'.static.RequestCommissionBuyItem(commissionDBId, Int(commissionItemType)); 
	}
}

/** 
 *  class'consignmentSaleAPI'.static.RequestCommissionInfo(int serverID); 
 *  parameter  ����  
 *	serverID  ����Ϸ���Item�� serverID 
 *  
 **/
function callRequestCommissionInfo(ItemInfo info)
{
	// Debug("RequestCommissionInfo ������ ���� ID: info.Id.ServerID -> " @ info.Id.ServerID );		
	class'consignmentSaleAPI'.static.RequestCommissionInfo(info.Id.ServerID); 
}

/***
 *
 *  �Ǹ��� ������ ������ ��� 
 *  function registerItem (ItemInfo info, string itemName, INT64 pricePerUnit, INT amount, int period)
 **/
function callRequestCommissionRegister()
{
	//branch 110706
	local int sellpremiumitemID;
	local CommissionPremiumItemInfo sellPremiumIteminfo;
	//end of branch

	local ItemInfo info;
	local INT64 pricePerUnit, amount;

	// ����, �Ⱓ CommissionExpired::Enum ����  
	local int nPeriod;
	
	if (MySellingItemIcon.GetItemNum() > 0)
	{
		MySellingItemIcon.GetItem(0, info);

		pricePerUnit = INT64(MySellingItemUnitPriceEdit.GetString());

		amount = info.ItemNum;
		
		nPeriod = MySellingItemRegistPeriodComboBox.GetSelectedNum();
		//branch110706
		if( nPeriod > 3 )
		{
			sellPremiumIteminfo = sellPremiumitemArray[ nPeriod - 4 ];
			sellpremiumitemID = sellPremiumIteminfo.commissionItemId;
//			Debug("sellpremiumitem:" @ sellpremiumitemID);	
		}
		else
		{
			sellpremiumitemID = 0;
		}
		//end of branch

		//Debug("��� ���� -> RequestCommissionRegister ");
		//Debug("info.Name -> " @ info.Name);
		//Debug("pricePerUnit -> " @ pricePerUnit);
		//Debug("amount -> " @ amount);
		//Debug("nPeriod -> " @ nPeriod);
		// call �Ǹ� ���

		class'consignmentSaleAPI'.static.RequestCommissionRegister(info.Id.ServerID, info.Name, pricePerUnit, amount, nPeriod, sellpremiumitemID); 
	}
}

/** �������� ���� ��� �ִ� �������� ĵ�� �Ѵ�. */
function callRequestCommissionCancel()
{
	if (MySellingItemIcon.GetItemNum() > 0) 
	{
		class'consignmentSaleAPI'.static.RequestCommissionCancel();
	}
}

/***
 * ���� �Ǹ��ϰ� �ִ� �������� ���� �Ѵ�.(�Ǹ����)
 * callRequestCommissionDelete
 **/
function callRequestCommissionDelete()
{
	local INT64  commissionDBId;
	local int    periodType, commissionItemType;

	local LVDataRecord Record;
	local string param;
	local int nSelect;

	nSelect = MySellingItemListCtrl.GetSelectedIndex();
	
	if (nSelect >= 0)
	{  
		MySellingItemListCtrl.GetSelectedRec(record);
		param = Record.szReserved;

		ParseINT64(param, "CommissionDBId"    , commissionDBId);
		ParseInt(param,   "CommissionItemType", commissionItemType);
		ParseInt(param,   "PeriodType"        , periodType);

		//Debug("================================================================");
		//Debug("commissionDBId:" @ commissionDBId);
		//Debug("commissionItemType:" @ commissionItemType);
		//Debug("periodType:" @ periodType);
 
		class'consignmentSaleAPI'.static.RequestCommissionDelete(commissionDBId, commissionItemType, periodType); 
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ���̾�α� �ڽ� -  ���� ���� ����
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/** �������� ���� �Ҳ���?  */
function askDialogBuyItem (string param)
{
	local LVDataRecord Record;

	local INT64 commissionDBId, commissionItemType, commissionPrice, amount;

	local int nSelect; //, itemType;

	local int    consumeType;
	local string itemName;

	nSelect = SellingItemListCtrl.GetSelectedIndex();

	if(nSelect >= 0)
	{
		//callRequestCommissionBuyInfo();
		SellingItemListCtrl.GetSelectedRec(record);

		// param = Record.szReserved;

		ParseString(param, "name", itemName);

		ParseINT64(param, "CommissionItemType", commissionItemType);
		ParseINT64(param, "CommissionDBId", commissionDBId);
		ParseINT64(param, "CommissionPrice"   , commissionPrice);

		ParseInt(param, "ConsumeType", consumeType);

		itemName = Record.LVDataList[0].szData;
		amount = INT64(Record.LVDataList[2].szData);

		DialogSetID(DIALOG_ASK_BUY);

		// ������ �������̶��..
		if (IsStackableItem(consumeType))
		{
			DialogShowWithResize(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3425), deleteRightSpeceString(itemName), String(amount), ConvertNumToText(String(CommissionPrice)), ConvertNumToText(String(CommissionPrice * amount))), -1, 300, string(Self));	
		}
		// ������ �������� �ƴ϶��..
		else
		{
			DialogShowWithResize(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3424), deleteRightSpeceString(itemName), ConvertNumToText(String(CommissionPrice))), -1, 224, string(Self));	
		}
		DisableCurrentWindow(true);
	}
}

/** ���� ��� ���� ���� ���� ���̾�α� ���� */
function askDialogRegisterItem ()
{
	local ItemInfo info;

	local INT64 pricePerUnit;
	local INT64 amount;
	// local int period;

	//class'consignmentSaleAPI'.static.RequestCommissionRegister(itemName, pricePerUnit, amount, period); 
	// local ItemInfo info;

	// �������� �ϳ��� ��ϵǾ� �ְ�, ������ 0���� ũ�� �ԷµǾ� �ִٸ�..
	if (MySellingItemIcon.GetItemNum() > 0 && Int(MySellingItemUnitPriceEdit.GetString()) > 0 )
	{
		MySellingItemIcon.GetItem(0, info);
		pricePerUnit = INT64(MySellingItemUnitPriceEdit.GetString());
		// period = MySellingItemRegistPeriodComboBox.GetSelectedNum();
		amount = info.ItemNum;

		// Ask price
		DialogSetID( DIALOG_ASK_REGISTITEM );
		// DialogSetReservedItemInfo(info);

		// ������ �������̶��..
		if (IsStackableItem( info.ConsumeType ))
		{
			// �Ǹ� ����Ͻ� �������� $s1, $s2���̸� ���� �Ǹ� ������ $s3, �� �Ǹ� ������ $s4�Ƶ����Դϴ�. ������ ����Ͻðڽ��ϱ�? 
			DialogShowWithResize(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3422), deleteRightSpeceString(info.Name), String(amount), ConvertNumToText(String(pricePerUnit)), ConvertNumToText(String(amount * pricePerUnit)), ConvertNumToText(commissionStr)), -1, 352, string(Self));	
		}
		// ������ �������� �ƴ϶��..
		else
		{
			DialogShowWithResize(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3421), deleteRightSpeceString(getItemNameForSellingAgency(info)), ConvertNumToText(String(pricePerUnit)),ConvertNumToText(commissionStr)), -1, 288, string(Self));	
		}

		DisableCurrentWindow(true);
	}
	updateSellRegisterForm();
}

/** ���� ���� ���� ���� ���̾�α� ���� */
function askDialogDeleteItem ()
{
	local LVDataRecord Record;
	local int nSelect, consumeType;
	local string param, itemName;
	local INT64 itemNum, CommissionPrice;
	local int PeriodType;

	nSelect = MySellingItemListCtrl.GetSelectedIndex();
	
	if (nSelect >= 0) 
	{ 
		MySellingItemListCtrl.GetRec(nSelect, Record);
		param =	Record.szReserved;

		ParseInt  ( param, "ConsumeType"    , consumeType );
		ParseInt  ( param, "PeriodType"     , PeriodType );
		ParseINT64( param, "CommissionPrice", CommissionPrice);
		ParseINT64( param, "itemNum"        , itemNum);

		itemName = Record.LVDataList[0].szData;
		// itemNum = INT64(Record.LVDataList[3].szData);

		// Ask price
		DialogSetID(DIALOG_ASK_DELETE);
		// DialogSetReservedItemInfo(info);

		// ������ �������̶��..
		if (IsStackableItem(consumeType))
		{	
			// 2012.08.17 ���� �����
			DialogShowWithResize(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3429), deleteRightSpeceString(itemName), String(itemNum), ConvertNumToText(String(CommissionPrice)), ConvertNumToText(String(CommissionPrice * itemNum)), ConvertNumToText( getCommisionNum(itemNum, CommissionPrice, PeriodType) )), -1,352, string(Self));
		}
		// ������ �������� �ƴ϶��..
		else
		{
			// 2012.08.17 ���� �����
			DialogShowWithResize(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3428), deleteRightSpeceString(itemName), ConvertNumToText(String(CommissionPrice)), ConvertNumToText( getCommisionNum(1, CommissionPrice, PeriodType) )), -1, 288, string(Self));
		}	
		DisableCurrentWindow(true);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ���� ��ƿ 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/** �Ǹ� ������ ��� â �������� ���� */
function MySellingItemListCtrlExtend(bool bOpen)
{
	if (bOpen)
	{
		// ����� �Ǹ� ����Ʈ ��Ʈ�� ����� ũ�� �Ѵ�.
		// �⺻ 520, 448
		// MySellingItemListCtrl.SetResizable(true);

		// �Ǹ� ���, �Ǹ� ��� ��ư ���̵��� �Ѵ�.
		SellBtn.EnableWindow();
		SellCancelBtn.EnableWindow();

		MySellingItemListCtrl.SetWindowSize(MySellingItemListCtrlRect.nWidth + 248, MySellingItemListCtrlRect.nHeight);

		MySellingItemListCtrl.SetColumnWidth(0, 220 + 200 - 1);
		MySellingItemListCtrl.SetColumnWidth(4,  74 +  47);

		MySellingItemListCtrlDeco.SetWindowSize(522 + 247, 19);
		MySellingItemListGroupbox.SetWindowSize(524 + 247, 459);

		SellingItemListCtrlGroupboxDivider.SetWindowSize(771, 1);
		//// ��� â �Ⱥ��̰� ���� 
		SellingItemRegistrationWnd.HideWindow();
	}
	else
	{
		// �Ǹ� ���, �Ǹ� ��� ��ư �Ⱥ��̵��� �Ѵ�.
		SellBtn.DisableWindow();
		SellCancelBtn.DisableWindow();

		// MySellingItemListCtrl.SetResizable(true);
		MySellingItemListCtrl.SetWindowSize(MySellingItemListCtrlRect.nWidth, MySellingItemListCtrlRect.nHeight);

		MySellingItemListCtrl.SetColumnWidth(0, 220 - 10);
		MySellingItemListCtrl.SetColumnWidth(4,  84);

		MySellingItemListCtrlDeco.SetWindowSize(522, 19);
		MySellingItemListGroupbox.SetWindowSize(524, 459);

		SellingItemListCtrlGroupboxDivider.SetWindowSize(523, 1);

		//// ��� â ���̰� ���� 
		SellingItemRegistrationWnd.ShowWindow();
	}
}

/**
 *  "�Ǹ� ���" �����츦 ���̰� �ϰ� �ʱ�ȭ
 **/ 
function SellingItemRegistrationWndShow()
{	
	// ����� �Ǹ� ����Ʈ ��Ʈ�� ����� ũ�� �Ѵ�.	 
	// MySellingItemListCtrl.SetResizeFrameSize(520, 448);
	// ������ �׸�
	// MySellingItemListCtrl.AdjustColumnWidth(0, 220);
	// ���� �Ⱓ �׸� 
	// MySellingItemListCtrl.AdjustColumnWidth(4, 74);
	// ��� â �Ⱥ��̰� ���� 

	SellingItemRegistrationWnd.ShowWindow();

	// �Ǹ� ������ �κ��丮 ������ ����Ʈ ���
	class'consignmentSaleAPI'.static.RequestCommissionRegistrableItemList();

	// �Ǹ� ���� ������ �÷� ������ �ʱ�ȭ 
	MySellingItemIcon.Clear();

	// ��������� ���̰� �ϰ�, ������ ��� ����Ʈ ���
	// MySellingItemListCtrlExtend(false);

	// ��� �Ⱓ �޺� ����
	// 1, ,3 , 5, 7 �� 
	MySellingItemRegistPeriodComboBox.Clear();
	
	MySellingItemRegistPeriodComboBox.AddString(MakeFullSystemMsg(GetSystemMessage(3418), "1"));
	MySellingItemRegistPeriodComboBox.AddString(MakeFullSystemMsg(GetSystemMessage(3418), "3"));
	MySellingItemRegistPeriodComboBox.AddString(MakeFullSystemMsg(GetSystemMessage(3418), "5"));
	MySellingItemRegistPeriodComboBox.AddString(MakeFullSystemMsg(GetSystemMessage(3418), "7"));

	// ù��° 1���� �⺻���� ����.
	MySellingItemRegistPeriodComboBox.SetSelectedNum(3);
	//branch 110706
	//�κ��丮�� �ǸűⰣ ���ξ����� üũ
	class'consignmentSaleAPI'.static.RequestCommissionSellingPremiumItemList();
	//end of branch

	initRegistItemForm();
}

function SellingPremiumItemRegisterReset(string param)
{
	sellPremiumitemArray.Length = 0;
}

function SellingPremiumItemRegisterAdd(string param)
{
	local CommissionPremiumItemInfo info;	

	ParseInt(param, "ID", info.commissionItemId);
	ParseString(param, "Name", info.commissionItemName);	
	ParseInt(param, "Period", info.commissionPeriod);
	ParseInt(param, "Expired", info.commissionExpired);
	ParseInt(param, "Discount", info.commissionDiscountInfo);
	ParseInt(param, "DiscountType", info.commissionDiscountInfoType);

	//Debug("ID:" @ info.commissionItemId);
	//Debug("Name:" @ info.commissionItemName);
	//Debug("Expired:" @ info.commissionExpired);
	//Debug("Discount:" @ info.commissionDiscountInfo);

	sellPremiumitemArray.Length = sellPremiumitemArray.Length + 1;
	sellPremiumitemArray[ sellPremiumitemArray.Length - 1 ] = (info);
	//����������� �ִ��� �����´�.	
	MySellingItemRegistPeriodComboBox.AddString( info.commissionItemName );
}

function MySellingItemRegistPeriodComboBoxSelectNum(int Period, int DiscountType)
{
	local int i, check;

	Debug("SelectNum: Period" @ Period);
	Debug("SelectNum: DiscountType" @ DiscountType);

	check = 0;
	if( Period >= 3 && DiscountType >= 0 )
	{
		for( i =0 ; i < sellPremiumitemArray.Length ;i++)
		{
			if( sellPremiumitemArray[i].commissionPeriod == Period && sellPremiumitemArray[i].commissionDiscountInfoType == DiscountType )
			{
				Debug("SelectNum: OK");
				MySellingItemRegistPeriodComboBox.SetSelectedNum( 4 + i );
				check = 1;
				break;
			}
		}
		if( check == 0 )
		{
			Debug("SelectNum: FALE");
			MySellingItemRegistPeriodComboBox.SetSelectedNum(3);
		}
	}
	else
	{
		Debug("SelectNum: FALE");
		MySellingItemRegistPeriodComboBox.SetSelectedNum(Period);
	}
}

//end of branch
/**
 *  Ʈ������ Ŭ�� �� ���
 **/
function clickTreeState (string Name)
{
	local array<string> nodeArray;
	local string tempStr;
	// debug("GetExpandedNode " @ SortListTree.GetExpandedNode(Name));
	// Debug("currentTreeNodeSelected: " @ currentTreeNodeSelected);

	// ���� Ŭ���� ������ �˻�..
	//local bool beforeSameNodeFlag;

	//beforeSameNodeFlag = false;
	// Debug("Name" @ Name);

	// ���� Ʈ��
	if (Left(Name, 4) == "root") 
	{
		tempStr = Right(Name, 13);
		tempStr = Left(tempStr, 12);

		//if (disableCurrentWindowFlag && tempStr == "categoryType") { saveTreePath = Name; return; }
		/*
		if (disableCurrentWindowFlag && )
		{
			return;
		}
		*/
		//SellingItemNumber.SetText("");

		currentTreeNodeSelected = Name;
		Split(Name, ".", nodeArray);

		if (SortListTree.GetExpandedNode(Name) != "") beforeTreeNodeSelectedFlag = false;

		if (beforeTreeNodeSelected == Name)
		{ 
			beforeTreeNodeSelectedFlag = !beforeTreeNodeSelectedFlag;
		}
		else 
		{ 
			if (SortListTree.GetExpandedNode(Name) != "") beforeTreeNodeSelectedFlag = false;
			else beforeTreeNodeSelectedFlag = true; 
		}
		// ���� ���� �ߴ� ��带 �ݴ´�.
		setTreeNode(beforeTreeNodeSelected, false);
		
		// ���� Ŭ���ߴ� ��带 �����Ͽ� ���� Ŭ�� �Ҷ� �ݴ� ����
		beforeTreeNodeSelected = Name;

		// ���� Ʈ�� ��带 ���� �ش�.
		setTreeNode(Name, true);

		// ��Ȱ��ȭ ���¸� ������ ����
		if (disableCurrentWindowFlag) { saveTreePath = Name; return; }
		else { saveTreePath = ""; }

		// ���� ����
		if (Name == "root.list0")
		{
			openHtmlHelp();
			SellingItemListWnd.HideWindow();
			
			DescriptionMsgWnd.HideWindow();
			DescriptionMsg.SetText("");
			SellingItemNumber.SetText("");
			// SearchWord_Editbox.DisableWindow();
		}
		else if (Name == "root.list1")
		{
			// ��ü 
			HelpHtmlWnd.HideWindow();
			SellingItemListWnd.ShowWindow();

			if (SearchWord_Editbox.GetString() == "") 
			{
				SellingItemListCtrl.DeleteAllItem();
				DescriptionMsgWnd.ShowWindow();
				DescriptionMsg.SetText(GetSystemMessage(3444));
				SellingItemNumber.SetText("");
			}
			else
			{
			//	if (beforeTreeNodeSelectedFlag == true)
			//	{
					SellingItemListWnd.ShowWindow();
					SellingItemNumber.SetText("");
					sellListSearch();
			//	}
			}
			//SearchWord_Editbox.EnableWindow();
			//ttp 58620 ���� ���ӽ��� �� �ǸŴ��� ����Ʈ�ڽ��� ��Ŀ���� ���� ���� ������ ä��â�� �Է��� ���� �ʴ´�.
			//�׷��� â�� �������� ��쿡�� ��Ŀ�� ������ ����. ����� 2013-03-11
			if(Me.IsShowWindow())
			{
				SearchWord_Editbox.SetFocus();
			}

			// ��ü������ Ʈ���� Ŭ�������� �˻��� ���� �ʴ´�.
		}
		// ������ ��� ������ �κ� ����
		else
		{
			//if (beforeTreeNodeSelectedFlag == true)
			//{
				HelpHtmlWnd.HideWindow();
				SellingItemListWnd.ShowWindow();
				sellListSearch();
			//}
			//SearchWord_Editbox.EnableWindow();

			SearchWord_Editbox.SetFocus();
		}
	}
}

/**
 *  �Ǹ� ����Ʈ ��ġ
 **/
function sellListSearch ()
{	
	local array<string> nodeArray;
	local string Name;
	local string searchString, tempStr;

	local int depth;
	local int depthType;
	local int nameClass;
	local int grade;

	tempStr = Right(currentTreeNodeSelected, 13);
	tempStr = Left(tempStr, 12);

	// Debug("tempStr :" @tempStr);

	//if (disableCurrentWindowFlag && tempStr == "categoryType") { saveTreePath = Name; return; }

	// TTP #59728 - gorillazin 13.01.09.
	//DescriptionMsgWnd.HideWindow();
	//DescriptionMsg.SetText("");
	SellingItemListCtrl.DeleteAllItem();
	DescriptionMsgWnd.ShowWindow();
	DescriptionMsg.SetText(GetSystemMessage(3107));
	// ���� Ʈ�����
	Name = currentTreeNodeSelected;
	// ���� Ʈ�� 

	// ���� Ŭ���� ������ ������ �ƴ� ��� 
	if (Left(Name, 4) == "root" && "root.list0" != name) 
	{
		Split(Name, ".", nodeArray);
		// Debug("Name " @ Name);
		// Debug("nodeArray.Length" @ nodeArray.Length);

		// ��ü -> ���� -> �Ѽհ� ���� ������ 0, 1, 2 ����
		depth = nodeArray.Length - 2;

		depthType = 0;

		// depth�� 0�� ��� 0, 1�ϰ�� (WEAPON=1, ARMOR=20, ACCESSARY=31, GOODS=38, PET=46, ETC=49, �߿� �ϳ�), 
		if (depth <= 0)
		{
			depthType = 0;
		}
		else if (depth == 1) 
		{
			// categoryType0~..  ���ڸ��� �ڸ���.
			// ����, ��, �Ǽ��縮... 
			// WEAPON=1, ARMOR=20, ACCESSARY=31, GOODS=38, PET=46, ETC=49, �߿� �ϳ�
			depthType = int(Right(Name, 1)); //getDepthTypeNum(int(Right(Name, 1)));
		}
		// 2�ϰ�� Commission::Enum�� ItemType
		else if (depth == 2) 
		{
			depthType = getDepthTypeNum(int(Right(nodeArray[2], 1)), Int(Mid(nodeArray[3], 4)));

			//debug("Int(Mid(nodeArray[3], 4))" @ Int(Mid(nodeArray[3], 4)));
			//debug("nodeArray[2]" @ nodeArray[2]);
			//debug("int(Right(Name, 1)" @ int(Right(Name, 1)));
		}

		// ��ü, �Ϲ�, ���
		nameClass = getItemType();
		// �׷��̵� -1 ��ü ����.. 11���� R97
		grade = getSerachGrade();

		searchString = SearchWord_Editbox.GetString();
		
		//Debug("���� ! class'ConsignmentSaleAPI'.static.RequestCommissionList()..");
		//Debug("depth         :" @ depth);
		//Debug("depthType     :" @ depthType);
		//Debug("nameClass     :" @ nameClass);
		//Debug("grade         :" @ grade);
		//Debug("searchString  :" @ searchString);
		
		// getSystemStringArray().length		
		class'ConsignmentSaleAPI'.static.RequestCommissionList(depth, depthType, nameClass, grade, searchString);
		beforeTreeNodeCalled = currentTreeNodeSelected;

		if (tempStr == "categoryType") startCategoryTreeSearchDelay();
		else startSearchDelay();
	}
}

/**
 * depthType ��� (������ ���� ��)
 * WEAPON=1, ARMOR=20, ACCESSARY=31, GOODS=38, PET=46, ETC=49, �߿� �ϳ�
 * 
 *  ���� �Ǿ���. 
	enum Enum 
	{ 
		Weapon = 0, Armor, Accessary, Goods, Pet, Etc, FirstMAX, 
	}; 
* 
 **/ 
function int getDepthTypeNum(int depthType, int targetIndex)
{
	local int nReturn;
	nReturn = -1;

	//Debug("depthType" @ depthType);
	//Debug("targetIndex" @ targetIndex);

	switch(depthType)
	{
		case 0 : nReturn = 1  + targetIndex; break;
		case 1 : nReturn = 19 + targetIndex; break;
		case 2 : nReturn = 29 + targetIndex; break;
		case 3 : nReturn = 35 + targetIndex; break;
		case 4 : nReturn = 42 + targetIndex; break;
		case 5 : nReturn = 44 + targetIndex; break;
	}

	//Debug ( "getDepthTypeNum" @ targetIndex @ nReturn );

	// depthType �� �׼����� �� ���
	if ( depthType == 2 ) 
	{
		// UI�ε��� ��ȣ�� 34���� ��� ( �ư��ÿ� ) 62������ ��û
		if ( nReturn == 34 ) return 62;
		// UI�ε��� ��ȣ�� 35 ���� ��� 34������ ��û
		else if ( nReturn == 35 ) return 34;
		// 2017-11-10 ���� �߰�
		else if ( nReturn == 36 ) return 63;

		// 2018-05-08 ��Ƽ��Ʈ �߰�
		else if ( nReturn == 37 ) return 64;
	}

	return nReturn;
}

/***
 * ���� �˻��� �׷��̵带 �����Ѵ�.
 **/
function int getSerachGrade ()
{
	// ��ü, ����, D��, C��, B��, A��, S��, S80, S84, R, R90, R95, R110
	//return Grade_Combobox.GetSelectedNum() - 1;
	local int gradeindex;
	gradeindex = Grade_Combobox.GetSelectedNum() - 1;
	//branch 110804 //s84�� ����� ����� �밡�� �ڵ� ����
	if( gradeindex < 7 )
	{
		return gradeindex;
	}
	return gradeindex + 1;
	//end of beanch	
}

/***
 * ���� �˻��� ������ Ÿ���� �����Ѵ�.
 **/
function int getItemType ()
{
	// nameCalss  ��ü�� �˻��Ұ�� -1, �Ϲݸ� �˻��ϸ� 0, ��͸� �˻��ϸ� 1  
	return Type_Combobox.GetSelectedNum() - 1;
}

/**
 * ������ ��Ʈ���� ��带 ���� �ش�. 
 **/
function setTreeNode(string nodeStr,bool bOpen)
{
	local array<string> nodeArray;
	local string targetNodeStr;
	local int i;
	
	Split(nodeStr, ".", nodeArray);
	
	targetNodeStr = "";

	for (i = 0; i < nodeArray.Length; i++)
	{
		targetNodeStr = targetNodeStr $ nodeArray[i];

		if (bOpen == false)
		{
			// ������ �� �ݱ�
			SortListTree.SetExpandedNode(targetNodeStr, false);
		}
		else
		{
			if (i == (nodeArray.Length - 1)) 
			{
				// [+] Ȯ�� ����� ���� ������ ���ȴ�..
				switch (Left(nodeArray[i], 4))
				{
					case "list"         : 
					case "cate"         : SortListTree.SetExpandedNode(targetNodeStr, beforeTreeNodeSelectedFlag); break;			
					default             : SortListTree.SetExpandedNode(targetNodeStr, true);
				}
			}
			else 
			{
				// ������ ����
				SortListTree.SetExpandedNode(targetNodeStr, true);
			}
		}
		
		targetNodeStr = targetNodeStr $ ".";
	}
}

/**
 *  ����Ʈ�� ������ �߰� 
 *  addElementAtList
 **/
function addElementAtList(string param)
{
	local ItemInfo info;

	local ListCtrlHandle targetList;
	local LVDataRecord Record;

	local int k, itemAttributeCount;

	local string itemName, iconName, iconPanel, additionalName, LookChangeiconPanelName; //branch 110824
	local INT64  commissionPrice, commissionDBId,  commissionItemType;
	local int    expireTime, periodType, itemNum, itemType, crystalType, enchanted, consumeType, etcItemType;

	local int AttackAttributeType, AttackAttributeValue,
			  DefenseAttributeValueFire, DefenseAttributeValueWater, 
			  DefenseAttributeValueWind, DefenseAttributeValueEarth, 
			  DefenseAttributeValueHoly, DefenseAttributeValueUnholy;


	local color TextColor;

	itemAttributeCount = 0;
	// �ڱⰡ ����� �Ǹ� ������ ���
	if (listCommissionStatus == 2)
	{
		// ���� �Ǹ� ����� ������ ����Ʈ
		targetList = MySellingItemListCtrl;
	}
	else
	{
		// �Ǹ� ���� ������ ����Ʈ
		targetList = SellingItemListCtrl;
	}

	// Debug("------------");
	// Debug("param" @ param);
	ParseString(param, "iconName", iconName);
	ParseString(param, "name", itemName);
	ParseString(param, "iconPanel", iconPanel);
	ParseString(param, "LookChangeIconPanel", LookChangeiconPanelName);//branch 110824

	ParseString(param, "additionalName", additionalName);

	ParseINT64(param, "CommissionPrice"   , commissionPrice);
	ParseINT64(param, "CommissionDBId"    , commissionDBId);
	ParseINT64(param, "CommissionItemType", commissionItemType);

	ParseInt(param, "ExpireTime", expireTime);
	ParseInt(param, "PeriodType", periodType);

	ParseInt(param, "itemNum", itemNum);
	ParseInt(param, "itemType", itemType);
	ParseInt(param, "EtcItemType", etcItemType);
	
	ParseInt(param, "crystalType", crystalType);
	ParseInt(param, "enchanted", enchanted);
	ParseInt(param, "consumeType", consumeType);

	ParseInt(param, "AttackAttributeType"        , AttackAttributeType);
	ParseInt(param, "AttackAttributeValue"       , AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire"  , DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater" , DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind"  , DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth" , DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly"  , DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", DefenseAttributeValueUnholy);

	// �ش� ������ ���� ����Ʈ�� �����������ü� �ֵ��� ���
	Record.szReserved = param;

	// ���ڵ� ����
	Record.LVDataList.length = 7;

	info.name           = itemName;
	info.additionalName = additionalName;
	info.enchanted      = enchanted;
	info.EtcItemType    = etcItemType;

	// �ű� ��ȥ ���� ������Ʈ
	addEnsoulInfoToItemInfoByParamString(param, info);

	// ������
	Record.LVDataList[0].szData = getItemNameForSellingAgency(info);

	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth=32;
	Record.LVDataList[0].nTextureHeight=32;
	Record.LVDataList[0].nTextureU=32;
	Record.LVDataList[0].nTextureV=32;
	Record.LVDataList[0].szTexture = iconName;
	Record.LVDataList[0].IconPosX=10;
	Record.LVDataList[0].FirstLineOffsetX=6;

	Record.LVDataList[0].HiddenStringForSorting = itemName $ util.makeZeroString(3, enchanted);

	// back texture 
	Record.LVDataList[0].iconBackTexName="l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	Record.LVDataList[0].backTexOffsetXFromIconPosX=-2;
	Record.LVDataList[0].backTexOffsetYFromIconPosY=-1;
	Record.LVDataList[0].backTexWidth=36;
	Record.LVDataList[0].backTexHeight=36;
	Record.LVDataList[0].backTexUL=36;
	Record.LVDataList[0].backTexVL=36;

	// panel texture 
	// �⺻ ������ ��� icon.low_tab �ؽ�����.
	//if (iconPanel == "icon.low_tab")
	//{
	//	Record.LVDataList[0].iconPanelName = "icon.low_tab";
	//}
	//else
	//{
	//	Record.LVDataList[0].iconPanelName = ""; //"icon.low_tab";
	//}

	// ������ �׵θ� (�⺻ ����.pvp �����)
	Record.LVDataList[0].iconPanelName = iconPanel;
	Record.LVDataList[0].LookChangeiconPanelName = LookChangeiconPanelName; //branch 110824

	Record.LVDataList[0].panelOffsetXFromIconPosX=0;
	Record.LVDataList[0].panelOffsetYFromIconPosY=0;
	Record.LVDataList[0].panelWidth=32;
	Record.LVDataList[0].panelHeight=32;
	Record.LVDataList[0].panelUL=32;
	Record.LVDataList[0].panelVL=32;

	// ��ȭ ǥ��
	if (info.enchanted > 0)
	{
		record.LVDataList[0].arrTexture.Length = 3;
		lvTextureAddItemEnchantedTexture(info.enchanted, record.LVDataList[0].arrTexture[0], record.LVDataList[0].arrTexture[1],record.LVDataList[0].arrTexture[2], 9, 11);
	}

	// �Ӽ� ���� 3��~ 4��.. 
	// �� 3�� �Ӽ�.. 1���� �׿�.. �� �ִٴ� ���� �˸��� �ؽ��� ������
	Record.LVDataList[0].attrIconTexArray.Length=4;
	// Į��
	Record.LVDataList[0].attrColor.R=200;
	Record.LVDataList[0].attrColor.G=200;
	Record.LVDataList[0].attrColor.B=200;

	for(k=0; k<4; ++k)
	{
		Record.LVDataList[0].attrIconTexArray[k].X=0;
		Record.LVDataList[0].attrIconTexArray[k].Y=2;
		Record.LVDataList[0].attrIconTexArray[k].Width=14;
		Record.LVDataList[0].attrIconTexArray[k].Height=14;
		Record.LVDataList[0].attrIconTexArray[k].U=0;
		Record.LVDataList[0].attrIconTexArray[k].V=0;
		Record.LVDataList[0].attrIconTexArray[k].UL=14;
		Record.LVDataList[0].attrIconTexArray[k].VL=14;
	}

	// Record.LVDataList[0].attrIconTexArray[0].objTex = GetTexture("L2UI_CT1.EmptyBtn");
	// Record.LVDataList[0].attrStat[itemAttributeCount]= "";

	// �׿� �Ⱥ��̰� �ϴ� �س���..
	Record.LVDataList[0].attrIconTexArray[0].objTex = GetTexture("L2UI_CT1.EmptyBtn");
	Record.LVDataList[0].attrStat[3]= "";

	// ���� �Ӽ� : ���� �Ӽ��� 1���̴�.
	if ( AttackAttributeType >= 0)
	{
		Record.LVDataList[0].attrIconTexArray[0].objTex = GetTexture(attributeTypeToTextureString(AttackAttributeType, itemType));
		Record.LVDataList[0].attrStat[0]= String(AttackAttributeValue);
		itemAttributeCount++;
	}
	else
	{
		if ((DefenseAttributeValueUnholy + DefenseAttributeValueHoly + DefenseAttributeValueEarth + 
			 DefenseAttributeValueWind + DefenseAttributeValueWater + DefenseAttributeValueFire) > 0)
		{
			// �� : �Ӽ� �ִ� 3��������.. �Ӽ� 6�� ¥�� ���䰡 �߰� �Ǿ ���� ó���� �ϱ�� ����. ���� 6��¥�� �Ӽ��� ���� 
			// �������� ������ �ʱ�� ������ �̹� Ǯ�� �����۶����� ����� �ϱ�� ����.
			// ��, ��, �ٶ�, ��, �ż�, ���� 
			if (DefenseAttributeValueWater > 0 && itemAttributeCount < 3)
			{
				Record.LVDataList[0].attrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(1, itemType));
				Record.LVDataList[0].attrStat[itemAttributeCount]= String(DefenseAttributeValueWater);
				itemAttributeCount++;
			}

			if (DefenseAttributeValueFire > 0 && itemAttributeCount < 3) 
			{
				Record.LVDataList[0].attrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(0, itemType));
				Record.LVDataList[0].attrStat[itemAttributeCount]= String(DefenseAttributeValueFire);			
				itemAttributeCount++;
			}

			if (DefenseAttributeValueWind > 0 && itemAttributeCount < 3)
			{   
				Record.LVDataList[0].attrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(2, itemType));
				Record.LVDataList[0].attrStat[itemAttributeCount]= String(DefenseAttributeValueWind);
				itemAttributeCount++;
			}

			if (DefenseAttributeValueEarth > 0 && itemAttributeCount < 3)
			{
				Record.LVDataList[0].attrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(3, itemType));
				Record.LVDataList[0].attrStat[itemAttributeCount]= String(DefenseAttributeValueEarth);
				itemAttributeCount++;
			}

			if (DefenseAttributeValueHoly > 0 && itemAttributeCount < 3)
			{ 
				Record.LVDataList[0].attrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(4, itemType));
				Record.LVDataList[0].attrStat[itemAttributeCount]= String(DefenseAttributeValueHoly);
				itemAttributeCount++;
			}

			if (DefenseAttributeValueUnholy > 0 && itemAttributeCount < 3)
			{ 
				Record.LVDataList[0].attrIconTexArray[itemAttributeCount].objTex = GetTexture(attributeTypeToTextureString(5, itemType));
				Record.LVDataList[0].attrStat[itemAttributeCount]= String(DefenseAttributeValueUnholy);
				itemAttributeCount++;
			}

			itemAttributeCount = 0;
			if (DefenseAttributeValueWater  > 0) itemAttributeCount++;
			if (DefenseAttributeValueFire   > 0) itemAttributeCount++;
			if (DefenseAttributeValueWind   > 0) itemAttributeCount++;
			if (DefenseAttributeValueEarth  > 0) itemAttributeCount++;
			if (DefenseAttributeValueHoly   > 0) itemAttributeCount++;
			if (DefenseAttributeValueUnholy > 0) itemAttributeCount++;

			// 3�� �̻�.. �Ӽ��� �ִٸ�.. 
			// �׿�.. ó��
			if (itemAttributeCount > 3) 
			{
				Record.LVDataList[0].attrIconTexArray[3].objTex = GetTexture("l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_add");
				Record.LVDataList[0].attrStat[3]= GetSystemString(2672);
				//Debug("�׿� ó��!!! " @ itemAttributeCount);
			}
		}
	}
	if (itemAttributeCount > 0)
	{
		Record.LVDataList[0].attrIconTexArray[0].X=0;
		Record.LVDataList[0].attrIconTexArray[1].X=30;
		Record.LVDataList[0].attrIconTexArray[2].X=30;
		Record.LVDataList[0].attrIconTexArray[3].X=30;
	}
	// Debug("itemType->" @ itemType);
	// debug("util.getItemGradeSystemString(crystalType); " @ util.getItemGradeSystemString(crystalType));

	// ����, ��, �Ǽ��縮 �� ����� ǥ�����ش�.(ȥ���� �Ǹ��� �ܰ� �̷���.. ITEM_ETCITEM ���� ���ͼ�.. )
	if (itemType == EItemType.ITEM_WEAPON || itemType == EItemType.ITEM_ACCESSARY || itemType == EItemType.ITEM_ARMOR) // || itemType == EItemType.ITEM_ETCITEM)
	{
		// ��� ���
		Record.LVDataList[1].szData = util.getItemGradeSystemString(crystalType);
	}
	else
	{
		// ������ �ƴ� ��� ����� ��� �Ѵ�.
		if (crystalType != 0)
			Record.LVDataList[1].szData = util.getItemGradeSystemString(crystalType);
		else
			Record.LVDataList[1].szData = "-";
	}

	Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(6, crystalType);
	Record.LVDataList[1].textAlignment=TA_Center;

	// ���� 

	Record.LVDataList[2].szData = String(itemNum);
	Record.LVDataList[2].HiddenStringForSorting = util.makeZeroString(6, itemNum);

	Record.LVDataList[2].textAlignment=TA_Center;

	Record.LVDataList[3].buseTextColor = True;
	TextColor = GetNumericColor(MakeCostString(String(commissionPrice)));
	Record.LVDataList[3].TextColor = TextColor;
	// 2013.01.14 �� ���ݴ����� �ٲ۴�.
	Record.LVDataList[3].szData = ConvertNumToTextNoAdena(String(commissionPrice));
	Record.LVDataList[3].HiddenStringForSorting = util.makeZeroString(20, commissionPrice);
	
	// ������ ������
	if ( IsStackableItem( consumeType ) )
	{
		// 2�ٷ� ǥ��
		// ���� ����

		//Record.LVDataList[3].szData = ConvertNumToTextNoAdena(string(commissionPrice)); //MakeFullSystemMsg(GetSystemMessage(3442), );

		// Record.LVDataList[2].attrIconTexArray.Length = 1;
		Record.LVDataList[3].hasIcon = true;

		Record.LVDataList[3].attrColor.R = 200;
		Record.LVDataList[3].attrColor.G = 200;
		Record.LVDataList[3].attrColor.B = 200;
		//TextColor = GetNumericColor(MakeCostString( String(commissionPrice * itemNum)));
		//Record.LVDataList[3].attrColor = TextColor;
		// 2013.01.14 �������� �ٲ۴�.
		Record.LVDataList[3].attrStat[0] = MakeFullSystemMsg(GetSystemMessage(3657), ConvertNumToTextNoAdena(String(commissionPrice * itemNum)));
		//Record.LVDataList[3].attrStat[0] = "(�հ�:" $ ConvertNumToTextNoAdena(String(commissionPrice * itemNum)) $ ")";
		//Record.LVDataList[3].HiddenStringForSorting = util.makeZeroString(20, commissionPrice * itemNum);
		// ���� �������� ���� �ǵ��� �Ѵ�. �߰� ��û : UI��ȹ - ��̿�
	}

	// ������ �������� �ƴ϶��..
	//else
	//{	
		//Record.LVDataList[3].TextColor = TextColor;
		//Record.LVDataList[3].szData = ConvertNumToTextNoAdena(String(commissionPrice));
	//	Record.LVDataList[3].HiddenStringForSorting = util.makeZeroString(20, commissionPrice); // String(commissionPrice);
	//}
	// Debug("commissionPrice:" @ commissionPrice * itemNum);
	// Debug("String         :" @ Record.LVDataList[3].HiddenStringForSorting);

	Record.LVDataList[3].textAlignment=TA_Right;

	Record.LVDataList[4].szData = ConvertTimeToString(expireTime);
	Record.LVDataList[4].textAlignment=TA_RIGHT;
	Record.LVDataList[4].HiddenStringForSorting = util.makeZeroString(20, expireTime);

	targetList.InsertRecord( Record );	

	// ������ ī��Ʈ
	if (listCommissionStatus == 2)
	{
		// ���� �Ǹ� ����� ������ ����Ʈ
		MySellingItemNumber.SetText( "(" $ String(MySellingItemListCtrl.GetRecordCount()) $ "/" $ maxSellingItemNum $ ")");
	}
	else
	{
		// �Ǹ� ���� ������ ����Ʈ
		SellingItemNumber.SetText( "(" $ String(SellingItemListCtrl.GetRecordCount()) $ ")");
	}

	updateRecordItemCount();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ��ƿ �Լ� 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/***
 * 
 *   ���� Ʈ�� ī�װ� �׸��� �ʱ�ȭ �Ѵ�.
 *   (Ʈ�� �޴� ����)
 *   
 **/
function categoryTreeInit()
{
	local string treeName, rootName;

	local int maxtitle;
	local int titleCount, categoryTypeCount, itemTypeCount;

	local string listName, itemName;

	local CustomTooltip T;
	local bool bDrawBgTree1;

	// "tree1_1_1 , �ܰ� ����..
	treeParam = "";
	beforeTreeNodeSelected = "";
	beforeTreeNodeSelectedFlag = false;
	bDrawBgTree1 = false;
	// ��ü, ����..	
	util.setSystemStringArrayByNumStr("145,144", titleNameArray);

	// ����, ��, �׼��縮... ���� ī�װ� ��Ʈ�� 
	util.setSystemStringArrayByNumStr("2520,2532,2537,5006,2547,49", categoryTypeNameArray);

	util.setSystemStringArrayByNumStr("2521,2522,45,1648,2523,1650,2524,1970,2525,2526,2527,2528,2529,48,1649,2530,46,2531", item1Array);

	util.setSystemStringArrayByNumStr("2533,2534,2535,2536,37,40,231,1987,28,234", item2Array);

	// 3638 �ư��ÿ� �߰�,3187 ����, 3877 ��Ƽ��Ʈ
	util.setSystemStringArrayByNumStr("239,237,238,2538,2539,3638,1024,3187,3877", item3Array);

	util.setSystemStringArrayByNumStr("2540,2541,2542,2543,2544,2545,2546", item4Array);

	util.setSystemStringArrayByNumStr("2548,2549", item5Array);

	util.setSystemStringArrayByNumStr("2550,2551,2552,2553,2554,2555,2556,2557,2558,2559,2560,2561,2562,2563,25,2564", item6Array);

	treeName = "SellingAgencyWnd.SellingListWnd.SortListTree";
	rootName = "root";

	SortListTree.Clear();
	maxtitle = 5;

	ParamAdd(treeParam, "tree" $ "_" $ "length", string(titleNameArray.Length));

	// root ����
	util.TreeInsertRootNode(treeName,  rootName, "", 0, 4);

	// ���� ����, �ɹ� ����Ʈ ���� ���
	for (titleCount = 0; titleCount < titleNameArray.Length; titleCount++)
	{
		listName = "list" $ string(titleCount);

		if (titleCount == 0)
		{
			// util.TreeInsertItemTooltipNode( treeName, listName, rootName, -7, 0, 15, 0, 20, 15, util.getCustomTooltip());

			// util.TreeInsertTextureNodeItem( treeName, rootName $ "." $ listName, "L2UI_CH3.BloodHoodWnd.BloodHood_Logon", 15, 15, 0, 0);

			util.TreeInsertExpandBtnNode( treeName, listName, rootName, 14, 14, "L2UI_CT1.SellingAgencyWnd_df_HelpBtn", "L2UI_CT1.SellingAgencyWnd_df_HelpBtn_Over", "L2UI_CT1.SellingAgencyWnd_df_HelpBtn", "L2UI_CT1.SellingAgencyWnd_df_HelpBtn_Over", 0, -2);

			// ������..���� �κп� ���� ���õǾ���
			currentTreeNodeSelected = rootName $ "." $ listName;
		}
		else 
		{
			util.TreeInsertExpandBtnNode(treeName, listName, rootName);
		}

		// treeCategoryTypeArray
		// treeItemTypeArray

		listName = rootName $ "." $ listName;
		ParamAdd(treeParam, "tree" $ titleCount, (listName));

		// �ؽ�Ʈ
		util.TreeInsertTextNodeItem( treeName, listName, titleNameArray[titleCount], 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true );

		// ����, ��, �׼��縮, �Ҹ�ǰ, �� ��ǰ, ŰŸ (ī�װ� �����)
		if (titleCount == 1)
		{
			// ī�װ� �� ����
			ParamAdd( treeParam, "tree" $ titleCount $ "_" $ "length", string(categoryTypeNameArray.Length) );

			for(categoryTypeCount = 0; categoryTypeCount < categoryTypeNameArray.Length; categoryTypeCount++)
			{
				util.TreeInsertExpandBtnNode( treeName, "categoryType" $ categoryTypeCount, rootName $ "." $ "list" $ titleCount,,,,,,,15);

				// ��� ����
				listName = rootName $ "." $ "list" $ string(titleCount) $ "." $ "categoryType" $ categoryTypeCount;

				ParamAdd( treeParam, "tree" $ titleCount $ "_" $ categoryTypeCount, (listName) );

				ParamAdd( treeParam, "tree" $ titleCount $ "_" $ categoryTypeCount $ "_" $ "length"     , string(getSystemStringArray(categoryTypeCount).Length) );

				util.TreeInsertTextNodeItem( treeName, listName, categoryTypeNameArray[categoryTypeCount], 5, 0, util.ETreeItemTextType.COLOR_DEFAULT, true );

				// Debug("getSystemStringArray(categoryTypeCount).Length" @ getSystemStringArray(categoryTypeCount).Length);
				
				for (itemTypeCount = 0; itemTypeCount < getSystemStringArray(categoryTypeCount).Length; itemTypeCount++)
				{
					// 3�ܰ� (�Ѽ� �����б�..���� �� Ÿ��)
					// ��ü-����-[�Ѽհ�,�Ѽո�����....] <- �̺κ�
					itemName = TreeInsertItemTooltipNodeWithTexBackHighlight( treeName, "item" $ itemTypeCount, listName, 10, 0, 15, 0,  1, 15, T);
					//util.TreeInsertExpandBtnNode( treeName, "items", listName,,,,,,,15);
					//strRetName = util.TreeInsertItemTooltipNode( TREENAME, ""$ ID $","$ Level, setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomTooltip() );
					ParamAdd( treeParam, "tree" $ titleCount $ "_" $ categoryTypeCount $ "_" $ itemTypeCount, (itemName) );

					// Debug("itemName :" @ itemName);
					if( bDrawBgTree1 )
					{
						//Insert Node Item - ������ ���?
						util.TreeInsertTextureNodeItem( TREENAME, itemName, "L2UI_CH3.etc.textbackline",160,15,10,,,,);
					}
					else
					{
						util.TreeInsertTextureNodeItem( TREENAME, itemName, "L2UI_CT1.EmptyBtn", 161, 15, 10 );
					}

					bDrawBgTree1 = !bDrawBgTree1;

					util.TreeInsertTextNodeItem( treeName, itemName, getSystemStringArray(categoryTypeCount)[itemTypeCount], -159, 0, util.ETreeItemTextType.COLOR_DEFAULT, true );
				} 
			}
		}
	}
}

/** Ʈ�� Ȯ��ɶ� ��� ������ �׸��� ���� �߰� - L2Util ������ ���� �ʰ� �̰� ��� */
function string TreeInsertItemTooltipNodeWithTexBackHighlight( string TreeName, string NodeName, string ParentName, 
									int nTexExpandedOffSetX, int nTexExpandedOffSetY, 
									int nTexExpandedHeight, int nTexExpandedRightWidth, 
									int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight, 
									CustomTooltip TooltipText, optional string strTexExpandedLeft, optional int offSetX, optional int offSetY )
{
	//Ʈ�� ��� ����
	local XMLTreeNodeInfo infNode;

	if( strTexExpandedLeft == "" ) strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";

	infNode.strName = NodeName;
	infNode.Tooltip = TooltipText;
	infNode.nOffSetX = offSetX;
	infNode.nOffSetY = offSetY;
	infNode.bFollowCursor = true;
	//Expand�Ǿ������� BackTexture����
	//��Ʈ��ġ�� �׸��� ������ ExpandedWidth�� ����. ������ -2��ŭ ����� �׸���.
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;
	infNode.nTexExpandedHeight = nTexExpandedHeight;
	infNode.nTexExpandedRightWidth = nTexExpandedRightWidth;
	infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth;
	infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	infNode.strTexExpandedLeft = strTexExpandedLeft;

	infNode.bDrawBackground = 1;
	infNode.bTexBackHighlight = 0;
	infNode.nTexBackHighlightHeight = 14;
	infNode.nTexBackWidth = 160; 
	infNode.nTexBackUWidth = 160;
	infNode.nTexBackOffSetX = 10;
	infNode.nTexBackOffSetY = -1;
	infNode.nTexBackOffSetBottom = 1;

	return class'UIAPI_TREECTRL'.static.InsertNode( TreeName, ParentName, infNode );
}

/** 
 * ��� ���� ������ �����츦 ��Ȱ��
 * �ʴ� ��� ���� ������ ���� ���� ���� �� �̻� ��� ���ϵ��� ������ ������ ��Ȱ��ȭ
 **/
function updateRecordItemCount()
{
	//Debug("MySellingItemListCtrl.GetRecordCount()->" $ MySellingItemListCtrl.GetRecordCount() $ ", " $ maxSellingItemNum);
	if(MySellingItemListCtrl.GetRecordCount() >= maxSellingItemNum)
	{	
		MySellingPossibItem.DisableWindow();
	}
	else
	{
		MySellingPossibItem.EnableWindow();
	}
}

/**
 *  ���� Ʈ�� ��� �ݱ�
 **/
function allCloseTreeNode()
{
	local int i, m, n, array1Count, array2Count, array3Count;
	local int max1, max2, max3;

	local string target;
	local array<string> node1Array, node2Array, node3Array;

	array1Count = 0;
	array2Count = 0;
	array3Count = 0;

	ParseInt(treeParam, "tree_length", max1);

	for (i = 0; i < max1; i++)
	{
		ParseInt(treeParam, "tree" $ i $ "_length", max2);
		ParseString(treeParam, "tree" $ i, target);
		node1Array[array1Count] = target;
		array1Count++;
		// SortListTree.SetExpandedNode(target, false );
		for (m = 0; m < max2; m++)
		{
			ParseInt(treeParam, "tree" $ i $ "_" $ m $ "_" $ "length", max3);
			ParseString(treeParam, "tree" $ i $ "_" $ m, target);
			
			// SortListTree.SetExpandedNode(target, false );
			node2Array[array2Count] = target;
			array2Count++;

			for (n = 0; n < max3; n++)
			{
				ParseString(treeParam, "tree" $ i $ "_" $ m $ "_" $ n, target);
				node3Array[array3Count] = target;
				array3Count++;

				// SortListTree.SetExpandedNode(target, false );
			}
		}
	}

	for (i = 0; i < node3Array.Length; i++)
	{
		SortListTree.SetExpandedNode(node3Array[i], false );
	}
	for (i = 0; i < node2Array.Length; i++)
	{
		SortListTree.SetExpandedNode(node2Array[i], false );
	}
	for (i = 0; i < node1Array.Length; i++)
	{
		SortListTree.SetExpandedNode(node1Array[i], false );
	}
	//currentTreeNodeSelected
}

/***
 *  ���� ���� 
 **/
function openHtmlHelp()
{
	if(!HelpHtmlWnd.IsShowWindow())
	{
		HelpHtmlWnd.ShowWindow();
		HtmlViewer.LoadHtml(GetLocalizedL2TextPathNameUC() $ "help_consignment.htm");
	}
}

/**
 *  Ʈ�� �޴� ������ ���
 *  �ý��� ��Ʈ�� ����� �迭�� Ÿ�Կ� ���� �����Ѵ�.
 **/ 
function array<string> getSystemStringArray(int type)
{
	local array<string> tempArray;

	switch (type)
	{
		case 0 : return item1Array; break;
		case 1 : return item2Array; break;
		case 2 : return item3Array; break;
		case 3 : return item4Array; break;
		case 4 : return item5Array; break;
		case 5 : return item6Array; break;

		default : Debug("Error SellingAgencyWnd : Ʈ�� �޴� ���� ������ �߸� �Ǿ����ϴ�. type: " @ type); return tempArray;
	}
}

/***
 *  �� ����� ���� �� �Ѵ�.
 *  �ܰ� indexDepth �� �� �ܰ躰�� ������ �˻� 
 **/
function bool compareNode(string node1, string node2, int indexDepth)
{
	local bool bReturn;
	local array<string> node1Array, node2Array;

	bReturn = false;
	Split(node1, ".", node1Array);
	Split(node2, ".", node2Array);
		
	// �Ѵ� �迭�� �ʰ� ���� �ʾҴٸ�..
	if (isArrayStringCheckIndexOver(node1Array, indexDepth) && isArrayStringCheckIndexOver(node2Array, indexDepth))
	{
		if (node1Array[indexDepth] == node2Array[indexDepth])
		{
			bReturn = true;
			// Debug("����.");
		}
	}
	return bReturn;
}

/**
 *   �迭�� ������ �Ѿ����� üũ �Ѵ�. true�� ����, false �̸� ���� �� ���� 
 **/
function bool isArrayStringCheckIndexOver(out array<string> tempArray, int index)
{
	if (tempArray.Length <= index) return false;
	else return true;
}

/** �Ǹ� ������ ��� �� �ʱ�ȭ */
function initRegistItemForm()
{	
	// Debug("----initRegistItemForm--------");
	// �Ǹ� ���࿡ �÷� ������ �ϳ��� ���ٸ�..
	if (MySellingItemIcon.GetItemNum() <= 0)
	{
		MySellingItemUnitPriceEdit.DisableWindow();
		MySellingItemUnitPriceEditBtn.DisableWindow();
		// �Ǹ� ����
		MySellingItemAmount.SetText("");
	}
	
	MySellingItemName.SetName("",NCT_Normal,TA_LEFT);

	// �Ӽ� �� �ʱ�ȭ
	//MySellingItemPropertyIcon_01.SetTexture("");
	//MySellingItemPropertyIcon_02.SetTexture("");
	//MySellingItemPropertyIcon_03.SetTexture("");

	getAttributeTextureHandle(1).SetTexture("L2UI_CT1.EmptyBtn");
	getAttributeTextureHandle(2).SetTexture("L2UI_CT1.EmptyBtn");
	getAttributeTextureHandle(3).SetTexture("L2UI_CT1.EmptyBtn");
	getAttributeTextureHandle(4).HideWindow();

	MySellingItemPropertyValue_01.SetText("");
	MySellingItemPropertyValue_02.SetText("");
	MySellingItemPropertyValue_03.SetText("");

	// �׿� (4�� �̻� �Ӽ��� ������.. �� �ִٰ�..�� �˷��ش�.)
	MySellingItemPropertyValue_04.HideWindow();

	// ���� �Ǹ� ���� 
	MySellingItemUnitPriceEdit.SetString("");

	MySellingItemUnitPrice_ReadingText.SetText("");

	// �� �Ǹ� ����
	MySellingItemTotalPrice_ReadingText.SetText("");
	MySellingItemTotalPrice.SetText("");

	// ��� �Ⱓ 7�Ϸ� �ʱ�ȭ
	MySellingItemRegistPeriodComboBox.SetSelectedNum(3);
	// ��Ȱ��
	MySellingItemRegistPeriodComboBox.DisableWindow();

	// ���� ��� ������ 
	MySellingItemCharge.SetText("");
	// MySellingItemCharge_ReadingText.SetText("");

	// �Ǹ� ������ 
	MySellingItemSellCharge.SetText("");

	MySellingItemCharge.SetTooltipCustomType(commissionRateToolTip("", getSystemString(2514), getSystemString(2777)));
	MySellingItemSellCharge.SetTooltipCustomType(commissionRateToolTip("", getSystemString(2776), getSystemString(2778)));

	// ��� ��ư ��Ȱ��ȭ
	RegistBtn.DisableWindow();
}

/** �Ǹ� ������ ����� �ؽ�Ʈ ������ ���� �Ѵ�. */
function updateSellRegisterForm()
{
	local ItemInfo info;
	
	local INT64 commission, commissionSellComplete;
	local string textValue;

	local Color tcolor;

	tcolor.R = 200;
	tcolor.G = 200;
	tcolor.B = 200;
	tcolor.A = 255;

	// Debug("----updateSellRegisterForm--------");
	if(MySellingItemIcon.GetItemNum() > 0)
	{
		// ��Ȱ��ȭ �Ǿ��� ���� Ȱ��ȭ
		MySellingItemUnitPriceEdit.EnableWindow();
		MySellingItemUnitPriceEditBtn.EnableWindow();
		MySellingItemRegistPeriodComboBox.EnableWindow();
		
		MySellingItemIcon.GetItem(0, info);

		textValue = MySellingItemUnitPriceEdit.GetString();

		// ���� �Ǹ� ���� �ѱ۷� (ex) 10�� 5000��)
		if(textValue == "")
		{
			textValue = "0";
		}
		// ��� ��ư ���� 
		if (INT64(textValue) > 0)
		{
			RegistBtn.EnableWindow();
		}
		else
		{
			RegistBtn.DisableWindow();
		}

		// ���� �Ǹ� ����
		MySellingItemUnitPrice_ReadingText.SetText(ConvertNumToTextNoAdena(textValue));
		
		// �� �Ǹ� ����
		MySellingItemTotalPrice.SetText(MakeCostString(string(info.ItemNum * INT64(textValue))));
		MySellingItemTotalPrice_ReadingText.SetText(ConvertNumToTextNoAdena(string(info.ItemNum * INT64(textValue))));
		
		/////////////////
		// ������ ���
		/////////////////

		// ��� ������ 
		commission = info.ItemNum * INT64(textValue) * getComboPeriod(MySellingItemRegistPeriodComboBox.GetSelectedNum());
		commission = (commission * 1) / 10000; // 0.0001 ������ 
		commissionStr = String(commission);

		// �Ǹ� ������
		commissionSellComplete = info.ItemNum * INT64(textValue) * getComboPeriod(MySellingItemRegistPeriodComboBox.GetSelectedNum());
		commissionSellComplete = (commissionSellComplete * 5) / 1000; // 0.005 ������
		commissionSellCompleteStr = String(commissionSellComplete);

		// Debug("-->" @  (info.ItemNum * INT64(textValue) * getComboPeriod(MySellingItemRegistPeriodComboBox.GetSelectedNum())) );

		// Debug("commission" @ commission);
		// Debug("commissionStr" @ commissionStr);

		// ��� ������
		// �ּ� �����ᰡ 1�� �Ƶ��� ���� �۴ٸ� �ּҼ������ 1�� �Ƶ����� ������.
		if (commission < COMMISSION_MIN_PRICE)
		{
			// 1000�Ƶ� ������ ���� 
			commission = COMMISSION_REGISTER_MIN_PRICE;
			commissionStr = string(commission);
		}

		// �Ǹ� �Ϸ� ������  
		if (commissionSellComplete < COMMISSION_MIN_PRICE)
		{				
			// 1000�Ƶ� ������ ���� 
			commissionSellComplete = COMMISSION_REGISTER_MIN_PRICE;
			commissionSellCompleteStr = string(commissionSellComplete);
		}

		// ���� ��� ������ 
		MySellingItemCharge.SetText(MakeCostString(commissionStr));
		//MySellingItemCharge_ReadingText.SetText(ConvertNumToTextNoAdena(commissionStr));
		MySellingItemCharge.SetTooltipCustomType(commissionRateToolTip(ConvertNumToTextNoAdena(commissionStr) $ " " $ GetSystemString(469), getSystemString(2514), getSystemString(2777)));

		// �Ǹ� ������ 
		MySellingItemSellCharge.SetText(MakeCostString(commissionSellCompleteStr));
		MySellingItemSellCharge.SetTooltipCustomType(commissionRateToolTip(ConvertNumToTextNoAdena(commissionSellCompleteStr) $ " " $ GetSystemString(469), getSystemString(2776), getSystemString(2778)));

		// ������ �̸� 
		MySellingItemName.SetNameWithColor( getItemNameForSellingAgency(info), NCT_Normal, TA_LEFT, tcolor );

		// �Ǹ� ����
		MySellingItemAmount.SetText(String(info.ItemNum));
	}
	else
	{
		// �Ǹ� ���� ������ �ö� ���� ����
		MySellingItemIcon.Clear();

		// �Ǹ� ���࿡ �÷��� �������� ���ٸ�.. �ʱ�ȭ
		initRegistItemForm();
	}
}

/**
 * ������ �κ�, �Ƶ��� ǥ�� ���� 
 **/
function CustomTooltip commissionRateToolTip (string adenaStr, string title, string desc)
{
	local CustomTooltip T;
	util.setCustomTooltip(T);
	
	util.ToopTipMinWidth(300);
	util.ToopTipInsertText(title $ " : " $ adenaStr, true, false,util.ETooltipTextType.COLOR_DEFAULT );
	util.TooltipInsertItemBlank(2);	
	util.TooltipInsertItemLine();
	util.TooltipInsertItemBlank(4);
	util.ToopTipInsertText(desc, false, false );
	
	return util.getCustomTooltip();
}

/** �Ӽ� �ʵ� ������Ʈ */
function updateAttributeRegistItemForm(ItemInfo info)
{
	local int itemAttributeCount;
	local int ItemType;
	local Color tcolor;

	tcolor.R = 200;
	tcolor.G = 200;
	tcolor.B = 200;
	tcolor.A = 255;

	ItemType = info.ItemType;
	
	if (MySellingItemIcon.GetItemNum() > 0)
	{
		MySellingItemIcon.GetItem(0, info);

		MySellingItemName.SetNameWithColor( getItemNameForSellingAgency(info), NCT_Normal, TA_LEFT, tcolor );
	}
	else 
	{
		MySellingItemName.SetNameWithColor( "", NCT_Normal, TA_LEFT, tcolor );
	}
	
    //(1) �Ӽ�������
    //  - �÷� CenterLeft����  x 40  / y 2
    //  - �� �Ӽ� ������ �� ���� : 30px
    //  - ���ҽ� ������ : w 14 / h 14
    //     * �� : l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Water
    //     * �� : l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Fire
    //     * �ٶ� : l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Wind
    //     * ����:l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Earth
    //     * ����:l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Dark
    //     * �ż�:l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Divine
	itemAttributeCount = 0;

	getAttributeTextureHandle(1).SetTexture("L2UI_CT1.EmptyBtn");
	getAttributeTextureHandle(2).SetTexture("L2UI_CT1.EmptyBtn");
	getAttributeTextureHandle(3).SetTexture("L2UI_CT1.EmptyBtn");

	MySellingItemPropertyValue_01.SetText("");
	MySellingItemPropertyValue_02.SetText("");
	MySellingItemPropertyValue_03.SetText("");

	//Debug("info.DefenseAttributeValueFire" @ info.DefenseAttributeValueFire);
	//Debug("info.DefenseAttributeValueWater" @ info.DefenseAttributeValueWater);
	//Debug("info.DefenseAttributeValueWind" @ info.DefenseAttributeValueWind);
	//Debug("info.DefenseAttributeValueEarth" @ info.DefenseAttributeValueEarth);
	//Debug("info.DefenseAttributeValueHoly" @ info.DefenseAttributeValueHoly);
	//Debug("info.DefenseAttributeValueUnholy" @ info.DefenseAttributeValueUnholy);

	//Debug("info.AttackAttributeType  :" @ info.AttackAttributeType);
	//Debug("info.AttackAttributeValue :" @ info.AttackAttributeValue);
	
	// ���� �Ӽ� : ���� �Ӽ��� 1���̴�.
	if ( info.AttackAttributeType >= 0)
	{
		getAttributeTextureHandle(1).SetTexture(attributeTypeToTextureString(info.AttackAttributeType, itemType));
		getAttributeTextBoxHandle(1).SetText(String(info.AttackAttributeValue));
	}
	else
	{
		// �� �Ӽ�  : �� �Ӽ��� �ִ� 3�� ����
		// 6���� �Ӽ� ��, �ؽ��� ä���
		if (info.DefenseAttributeValueWater > 0 && itemAttributeCount < 3) 
		{   
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(1, itemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(String(info.DefenseAttributeValueWater));
		}
		
		if (info.DefenseAttributeValueFire > 0 && itemAttributeCount < 3) 
		{ 
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(0, itemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(String(info.DefenseAttributeValueFire));
		}
		
		if (info.DefenseAttributeValueWind > 0 && itemAttributeCount < 3)
		{   
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(2, itemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(String(info.DefenseAttributeValueWind));
		}

		if (info.DefenseAttributeValueEarth > 0 && itemAttributeCount < 3)
		{
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(3, itemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(String(info.DefenseAttributeValueEarth));
		}
		
		if (info.DefenseAttributeValueHoly > 0 && itemAttributeCount < 3)
		{ 
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(4, itemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(String(info.DefenseAttributeValueHoly));
		}
		
		if (info.DefenseAttributeValueUnholy > 0 && itemAttributeCount < 3)
		{ 
			itemAttributeCount++;
			getAttributeTextureHandle(itemAttributeCount).SetTexture(attributeTypeToTextureString(5, itemType));
			getAttributeTextBoxHandle(itemAttributeCount).SetText(String(info.DefenseAttributeValueUnholy));
		}

		itemAttributeCount = 0;
		if (info.DefenseAttributeValueWater  > 0) itemAttributeCount++;
		if (info.DefenseAttributeValueFire   > 0) itemAttributeCount++;
		if (info.DefenseAttributeValueWind   > 0) itemAttributeCount++;
		if (info.DefenseAttributeValueEarth  > 0) itemAttributeCount++;
		if (info.DefenseAttributeValueHoly   > 0) itemAttributeCount++;
		if (info.DefenseAttributeValueUnholy > 0) itemAttributeCount++;

		// 3�� �̻�.. �Ӽ��� �ִٸ�.. 
		// �׿�.. ó��
		if (itemAttributeCount > 3) 
		{							
			getAttributeTextureHandle(4).ShowWindow(); 
			getAttributeTextBoxHandle(4).ShowWindow();
			//Debug("�׿� ó��!!! " @ itemAttributeCount);
		}
		// debug("---> �׿� ó�� itemAttributeCount: " @ itemAttributeCount);

		
	}
}

/** �Ӽ� �ؽ��� �ڵ� ����*/
function TextureHandle getAttributeTextureHandle(int num)
{
	local TextureHandle tempTextureHandle;

	switch(num)
	{
		case 1 : tempTextureHandle = MySellingItemPropertyIcon_01; break;
		case 2 : tempTextureHandle =  MySellingItemPropertyIcon_02; break;
		case 3 : tempTextureHandle =  MySellingItemPropertyIcon_03;	break;
		case 4 : tempTextureHandle =  MySellingItemPropertyIcon_04;	break;
	}

	return tempTextureHandle;
}

/** �Ӽ� �ؽ�Ʈ�ڽ� �ڵ� */
function TextBoxHandle getAttributeTextBoxHandle(int num)
{
	local TextBoxHandle tempTextBoxHandle;

	switch(num)
	{
		case 1 : tempTextBoxHandle =  MySellingItemPropertyValue_01; break;
		case 2 : tempTextBoxHandle =  MySellingItemPropertyValue_02; break;
		case 3 : tempTextBoxHandle =  MySellingItemPropertyValue_03; break;	
		case 4 : tempTextBoxHandle =  MySellingItemPropertyValue_04; break;	
	}

	return tempTextBoxHandle;
}

/** �.. ��� �Ⱓ�� ���� �ߴ°�.. 1,3,5,7 �Ⱓ �޺� �ڽ��� ���� */
function int getComboPeriod(int index)
{
	local int returnDay;

	switch (index)
	{
		case 0 : returnDay = 1; break;
		case 1 : returnDay = 3; break;
		case 2 : returnDay = 5; break;
		case 3 : returnDay = 7; break;
	}
	return returnDay;
}

/** ���� �ð� ����*/
function startSearchDelay()
{
	// TIMER_ID
	Me.SetTimer(TIMER_SEARCH_ID, TIMER_SEARCH_DELAY);
	DisableCurrentWindow(true);
	disableCurrentWindowFlag = true;
	// saveTreePath
}
function startCategoryTreeSearchDelay()
{
	// TIMER_ID
	Me.SetTimer(TIMER_CATEGORYTREE_SEARCH_ID, TIMER_SEARCH_DELAY);
	DisableCurrentWindow(true);
	disableCurrentWindowFlag = true;
	// saveTreePath
}

// TTP #59728 - gorillazin 13.01.09.
function startReSearchDelay()
{
	Me.SetTimer(TIMER_RE_SEARCH_ID, TIMER_SEARCH_DELAY);
	DisableCurrentWindow(true);
	disableCurrentWindowFlag = true;
}
//

/** ���� �ð� ó�� */
function OnTimer(int TimerID)
{
	// Debug("saveTreePath:" @ saveTreePath);

	// ������ 0.5�� ���Ŀ� �˻��� �޵��� ���� �Ǿ� �ִ�(GD1.0)
	if(TimerID == TIMER_CATEGORYTREE_SEARCH_ID)
	{
		Me.KillTimer(TIMER_CATEGORYTREE_SEARCH_ID);
		DisableCurrentWindow(false);
	}

	else if(TimerID == TIMER_SEARCH_ID)
	{
		Me.KillTimer(TIMER_SEARCH_ID);
	}
	
	if (TimerID == TIMER_SEARCH_ID || TimerID == TIMER_CATEGORYTREE_SEARCH_ID)
	{
		DisableCurrentWindow(false);				
		disableCurrentWindowFlag = false;
		if (saveTreePath != "")
		{
			// if (currentTreeNodeSelected != beforeTreeNodeSelected)
			if (beforeTreeNodeCalled != saveTreePath)
			{
				clickTreeState(saveTreePath);
			}

			saveTreePath = "";
		}
	}

	// TTP #59728 - gorillazin 13.01.09.
	if (TimerID == TIMER_RE_SEARCH_ID)
	{
		DisableCurrentWindow(false);
		disableCurrentWindowFlag = false;

		Me.KillTimer(TIMER_RE_SEARCH_ID);
		sellListSearch();
	}
	//
}

/** 
 * ���� �����츦 ��Ȱ��ȭ �Ѵ�.
 * ������ �ֻ�ܿ� ū �����츦 �ΰ� �װɷ� �Ʒ� �ִ� ��ҵ��� Ŭ������ �ȵǵ��� �Ѵ�.
 **/
function DisableCurrentWindow(bool bFlag)
{
	// disableCurrentWindowFlag = bFlag; 
	if (bFlag)
	{
		DisableWnd.EnableWindow();
		DisableWnd.ShowWindow();
	}
	else 
	{
		DisableWnd.DisableWindow();
		DisableWnd.HideWindow();
	}
}

/**
 *  ������ ���� �Ӽ� -> �ؽ��� ��� 
 **/
function string attributeTypeToTextureString(int attType, int itemType)
{
	local string returnStr;

	if (itemType == EItemType.ITEM_WEAPON)
	{
		// �����
		switch(attType)
		{
			case 0  : returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Fire";   break;
			case 1  : returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Water";  break;
			case 2  : returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Wind";   break;
			case 3  : returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Earth";  break;
			case 4  : returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Divine"; break;
			case 5  : returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Dark";   break;
			default : returnStr = "L2UI_CT1.EmptyBtn";
		}
	}
	else 
	{
		// ��
		switch(attType)
		{
			case 0 :returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Water";  break;
			case 1 :returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Fire";   break;
			case 2 :returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Earth";  break;
			case 3 :returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Wind";   break;
			case 4 :returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Dark";   break;
			case 5 :returnStr = "l2ui_ct1.SellingAgencyWnd_df_ItemPropertyIcon_Divine"; break;
			default : returnStr = "L2UI_CT1.EmptyBtn";
		}
	}

	return returnStr;
}

/** �Ǹ� ����� ������ �̸� ���ϱ� */
function string getItemNameForSellingAgency (itemInfo mItemInfo)
{
	local EEtcItemType eEtcItemType;
	local String itemNameString;

	itemNameString = "";

	eEtcItemType = EEtcItemType(mItemInfo.EtcItemType);

	if (eEtcItemType == ITEME_PET_COLLAR)
	{
		// LV50 �����Ÿ� (50��¥�� ������)
		itemNameString = "Lv" $ String(mItemInfo.Enchanted) $ " " $ mItemInfo.name;
	}
	else
	{
		// �Ϲ� �����۵�
		// ��æƮ ���� �ִٸ�..

		itemNameString = GetItemNameAll(mItemInfo);
	}

	return itemNameString;
}

/**
 *  ���� space�� ���� �Ѵ�.
 * ex)  "*  ����� "  ===> "�����"  , "������ �Դ� ����̰� �ִ�.   " => ������ �Դ� ����̰� �ִ�."
 **/
function string deleteRightSpeceString(string tempStr)
{
	//tempStr

	local int i;

	if ( Len(tempStr) == 0 ) return tempStr;

	i = Len(tempStr);

	while ( Mid(tempStr,i - 1, 1) == " " || Mid(tempStr,i,1) == "\t" )
	{
		--i;
		tempStr = Left(tempStr, i);
	}

	return tempStr;
}


function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
	local string MainKey;
	
	// Ű���� �������� üũ
	if (MySellingItemUnitPriceEdit.IsFocused())
	{
		updateSellRegisterForm();
	}
	else if (SearchWord_Editbox.IsFocused())
	{	
		// ���ͷ� �˻��� �Է� ���� �ϵ���..
		MainKey = class'InputAPI'.static.GetKeyString(nKey);
		if(MainKey == "ENTER")
		{
			// ��Ȱ�� ��尡 �ƴ� ��Ȳ�̶�� �˻� ����
			//if (!DisableWnd.IsEnableWindow())
			if (!disableCurrentWindowFlag)
			{
				
				// Debug("MainKey" @ MainKey);
				OnSearchBtnClick();	
			}
		}
	}
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "SellingAgencyWnd" ).HideWindow();
}

//�Ǹ� ��� �� ������ ��� - 2012.08.17 ���� �����
function string getCommisionNum(INT64 itemNum, INT64 price, int PeriodType)
{
	local INT64 _commission;
	// ��� ������ 
	_commission = itemNum * price * getComboPeriod( PeriodType ); //MySellingItemRegistPeriodComboBox.GetSelectedNum());
	_commission = (_commission * 1) / 10000; // 0.0001 ������
	// �ּ� �����ᰡ 1�� �Ƶ��� ���� �۴ٸ� �ּҼ������ 1�� �Ƶ����� ������.
	if (_commission < COMMISSION_MIN_PRICE)
	{
		// 1000�Ƶ� ������ ���� 
		_commission = COMMISSION_REGISTER_MIN_PRICE;
	} 
	return String(_commission);
}

defaultproperties
{
}
