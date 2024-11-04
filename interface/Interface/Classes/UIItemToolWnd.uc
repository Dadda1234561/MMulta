/**
 *   UITool : ������ �˻� �� 
 *   
 *   Dongland �� ������ ����Ŷ�..�˾Ƽ�..������� ���� -��-;;
 *   
 *   �߱� �������� ������.
 *   
 **/

class UIItemToolWnd extends UICommonAPI;

var WindowHandle    Me;
var ListCtrlHandle  ItemListCtrl;
var ComboBoxHandle  ItemTypeComboBox;
var ComboBoxHandle  ItemGradeComboBox;
var ComboBoxHandle  ItemOptionComboBox;
var ComboBoxHandle  ItemOption2ComboBox;

var ButtonHandle    searchItemBtn;
var ButtonHandle    getItemBtn;

var EditBoxHandle   searchEditBox;
var EditBoxHandle   itemCountEditBox;
var EditBoxHandle	Create2EditBox;

//var TextBoxHandle   ItemDescTextBox;


var EditBoxHandle addInfoEditBox;

var ButtonHandle    InitBtn;

var L2Util          util;

var int iconPanelTotalCount;

var ItemInfo targetItemInfo;
const DELAY1_ID = 102001;
const DELAY2_ID = 102002;


var array<int> itemIds;
var ItemID cID;
var int searchItemID, filterItemType;
var ItemInfo tmItemInfo;
	
var String fullNameString;
var string modifiedString;
var string modifiedParam;

var int ItemCrystalType;
var bool useTick;
var bool switchBool;

var array < int > SLOTBITTYPE;
var string SearchString;

var CheckBoxHandle ChkBoxBless;
var CheckBoxHandle ChkBox64;

function OnRegisterEvent()
{	
	registerEvent( EV_ChatMessage );
}

function onShow()
{
	// �̰� ���� �ؾ���
	// searchEditBox.SetString(getInstanceGMWnd().m_hEditBox.GetString());

	Me.DisableTick();
	useTick = false;
	setWindowTitleByString("UIPowerTools [ ItemSearchTool ]");
	ChkBox64.HideWindow();
	//searchEditBox.EnableWindow();	
}

function OnLoad()
{
	SetClosingOnESC(); 
	// �ϰ� �ݱ�� �ε�.. �ѱ��� ���� ����
	// getInstanceUIData().addEscCloseWindow(getCurrentWindowName(string(Self)));
	// util �ʱ�ȭ 
	util = L2Util(GetScript("L2Util"));

	Initialize();
}

function Initialize()
{
	local int i;

	Me                = GetWindowHandle  ( "UIItemToolWnd" );
	itemListCtrl      = GetListCtrlHandle( "UIItemToolWnd.itemListCtrl" );
	searchItemBtn     = GetButtonHandle  ( "UIItemToolWnd.searchItemBtn" );
	getItemBtn        = GetButtonHandle  ( "UIItemToolWnd.getItemBtn" );
	ItemTypeComboBox  = GetComboBoxHandle( "UIItemToolWnd.ItemTypeComboBox" );
	ItemGradeComboBox = GetComboBoxHandle( "UIItemToolWnd.ItemGradeComboBox" );

	ItemOptionComboBox = GetComboBoxHandle( "UIItemToolWnd.ItemOptionComboBox" );
	ItemOption2ComboBox = GetComboBoxHandle( "UIItemToolWnd.ItemOption2ComboBox" );

	searchEditBox     = GetEditBoxHandle ( "UIItemToolWnd.searchEditBox" );
	itemCountEditBox  = GetEditBoxHandle ( "UIItemToolWnd.itemCountEditBox" );

	Create2EditBox		= GetEditBoxHandle("UIItemToolWnd.Create2EditBox");
	addInfoEditBox    = GetEditBoxHandle ( "UIItemToolWnd.addInfoEditBox" );

	ChkBoxBless = GetCheckBoxHandle("UIItemToolWnd.ChkBoxBless");
	ChkBox64 = GetCheckBoxHandle("UIItemToolWnd.ChkBox64");

	//ItemDescTextBox   = GetTextBoxHandle ( "UIItemToolWnd.ItemDescTextBox" );

	// �ʱ�ȭ 
	ItemTypeComboBox.Clear();
	ItemTypeComboBox.AddString("ITEM_WEAPON"   );  // 0
	ItemTypeComboBox.AddString("ITEM_ARMOR"    );  // 1
	ItemTypeComboBox.AddString("ITEM_ACCESSARY");  // 2
	ItemTypeComboBox.AddString("ITEM_QUESTITEM");  // 3
	ItemTypeComboBox.AddString("ITEM_ASSET"    );  // 4
	ItemTypeComboBox.AddString("ITEM_ETCITEM"  );  // 5	
	ItemTypeComboBox.AddString("Total"         );  // 6
	//ItemTypeComboBox.AddString("WEAPON + ARMOR");  // 7 -> FindNextID()������ ����

	// ��Ż�� �⺻����
	ItemTypeComboBox.SetSelectedNum(6);

	// �׷��̵� ���� ����,  R110 ����
	ItemGradeComboBox.Clear();
	for (i = 0; i < 12; i++)
	{
		ItemGradeComboBox.AddString(util.getItemGradeSystemString(i)); 
	}

	// 12�� ��ü ����
	ItemGradeComboBox.AddString("Total"); 
	ItemGradeComboBox.SetSelectedNum(12);

	itemCountEditBox.SetString("1");

	// ���� �������� �ִ� api , ���� ����
	ItemListCtrl.SetSelectedSelTooltip(false);	
	ItemListCtrl.SetAppearTooltipAtMouseX(true);
	
	inputSlotBitType (); 

	setOptionComboBoxString( ItemGradeComboBox.GetSelectedNum() );
	setOptionComboBox2String( ItemGradeComboBox.GetSelectedNum()  );

	setWindowTitleByString("UIPowerTools [ ItemTool ]");
}

function inputSlotBitType () 
{
	SLOTBITTYPE.Length = 28;

	SLOTBITTYPE[0] = 1;             // SBT_UNDERWEAR
	SLOTBITTYPE[1] = 2;             // SBT_REAR
	SLOTBITTYPE[2] = 4;             // SBT_LEAR
	SLOTBITTYPE[3] = 6;             // SBT_RLEAR
	SLOTBITTYPE[4] = 8;             // SBT_NECK
	SLOTBITTYPE[5] = 16;            // SBT_RFINGER
	SLOTBITTYPE[6] = 32;            // SBT_LFINGER
	SLOTBITTYPE[7] = 48;            // SBT_RLFINGER
	SLOTBITTYPE[8] = 64;            // SBT_HEAD
	SLOTBITTYPE[9] = 128;           // SBT_RHAND
	SLOTBITTYPE[10] = 256;          // SBT_LHAND
	SLOTBITTYPE[11] = 512;          // SBT_GLOVES
	SLOTBITTYPE[12] = 1024;         // SBT_CHEST
	SLOTBITTYPE[13] = 2048;         // SBT_LEGS
	SLOTBITTYPE[14] = 4096;         // SBT_FEET
	SLOTBITTYPE[15] = 8192;         // SBT_BACK
	SLOTBITTYPE[16] = 16384;        // SBT_RLHAND
	SLOTBITTYPE[17] = 32768;        // SBT_ONEPIECE
	SLOTBITTYPE[18] = 65536;        // SBT_HAIR
	SLOTBITTYPE[19] = 131072;       // SBT_ALLDRESS
	SLOTBITTYPE[20] = 262144;       // SBT_HAIR2
	SLOTBITTYPE[21] = 524288;       // SBT_HAIRALL
	SLOTBITTYPE[22] = 1048576;      // SBT_RBracelet
	SLOTBITTYPE[23] = 2097152;      // SBT_LBracelet
	SLOTBITTYPE[24] = 4194304;      // SBT_Deco1;	
	SLOTBITTYPE[25] = 268435456;    // ����?
	SLOTBITTYPE[26] = 536870912;    // Brooch �������� ���
	SLOTBITTYPE[27] = 1073741824;   // Brooch_Jewel1;	
}

/*
function OnEvent(int Event_ID, String param)
{
	

	switch( Event_ID )
	{
		case EV_ChatMessage:
			 
			 break;
	}
}

function handleChatMessage ( string param ) 
{
	local int nType, nSysMsgIndex;
	
	if (!Me.IsShowWindow()) return;

	ParseInt(param, "Type", nType);
	ParseInt(param, "SysMsgIndex", nSysMsgIndex);
		 // debug (param);

		 if (nSysMsgIndex == 378 && nType == 5)
		 {				
			// 54�� �������� ���������� ������ ������..
			if (InStr(param, targetItemInfo.name) > 0 && nSysMsgIndex == 54)
			{
				Debug("����");					
				Me.KillTimer(DELAY1_ID);
				Me.SetTimer(DELAY1_ID, 100);
			}
		 }
}
*/

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "searchItemBtn":
			OnsearchItemBtnClick();
			break;
	    case "getItemBtn" :
			OnGetItemBtnClick();
			break;
		case "InitBtn":
			Initialize();
			OnInitBtnClick();
			break;
		case "MultiSell_Up_Button":
			itemCountEditBox.SetString(string(int(itemCountEditBox.GetString()) + 1));
			break;
		case "MultiSell_Down_Button":
			if ( int(itemCountEditBox.GetString()) > 1 )
				itemCountEditBox.SetString(string(int(itemCountEditBox.GetString()) - 1));
			break;
		case "NumInitButton":
			itemCountEditBox.SetString("1");
			Create2EditBox.SetString("1");
			break;
		case "BuildCommandButton":
			Debug("BuildCommandButton");
			ExecuteCommand(addInfoEditBox.GetString());
			AddSystemMessageString("---> Execute " @ addInfoEditBox.GetString());
			break;
		case "bcBtn":
			ClipboardCopy(addInfoEditBox.GetString());
			AddSystemMessageString("---> ClipboardCopy " @ addInfoEditBox.GetString());
			break;
	}
}



function debugItem( int64 cID )
{
	//local string param;
	local iteminfo tmItemInfo;
	local ItemID citemID;

	citemID.classID = int( cID );

	if (class'UIDATA_ITEM'.static.GetItemInfo( citemID, tmItemInfo))
	{
		//ItemInfoToParam ( tmItemInfo, param );
		Debug ( "debugItem" @ tmItemInfo.slotBitType @ tmItemInfo.ArmorType @ tmItemInfo.BodyPart );
	}
}

function OnGetItemBtnClick()
{
	local LVDataRecord Record;

	local int nItemCount;
	
	nItemCount = 1;
	
	if ( int(itemCountEditBox.GetString())  > 1) nItemCount = int(itemCountEditBox.GetString());

	ItemListCtrl.GetSelectedRec(Record);

	ProcessChatMessage("//summon" @ String(record.nReserved1) $ " "$string(nItemCount));
}

function executeSearch(string searchKey)
{
	searchEditBox.SetString(searchKey);
	OnsearchItemBtnClick();
}

function OnsearchItemBtnClick()
{	
	FindAllItem(searchEditBox.GetString());
}


function OnClickListCtrlRecord( string ListCtrlID)
{
	local LVDataRecord Record;
	local ItemID citemID;
	local ItemInfo itemInfo;

	if (ListCtrlID == "itemListCtrl") 
	{
		if ( itemListCtrl.GetSelectedIndex() <= -1 )
			return;

		ItemListCtrl.GetSelectedRec(Record);
		citemID.classID = int(record.nReserved1);

		if (class'UIDATA_ITEM'.static.GetItemInfo(citemID, itemInfo))
		{
			if ( isEnableEnchant(ItemInfo) && int(Create2EditBox.GetString()) > 1 )
				addInfoEditBox.SetString(("//����2" @ Create2EditBox.GetString()) @ string(ItemInfo.Id.ClassID));
			else
				addInfoEditBox.SetString(("//����" @ string(ItemInfo.Id.ClassID)) @ itemCountEditBox.GetString());
		}
	}	
}

function string getItemTypeString(int EtcItemType)
{
	// EEtcItemType
	switch(EtcItemType)
	{
		case 0 : return "ITEME_NONE";
		case 1 : return "ITEME_SCROLL";
		case 2 : return "ITEME_ARROW";
		case 3 : return "ITEME_POTION";
		case 4 : return "ITEME_SPELLBOOK";
		case 5 : return "ITEME_RECIPE";
		case 6 : return "ITEME_MATERIAL";
		case 7 : return "ITEME_PET_COLLAR";
		case 8 : return "ITEME_CASTLE_GUARD";
		case 9 : return "ITEME_DYE";
		case 10 : return "ITEME_SEED";
		case 11 : return "ITEME_SEED2";
		case 12 : return "ITEME_HARVEST";
		case 13 : return "ITEME_LOTTO";
		case 14 : return "ITEME_RACE_TICKET";
		case 15 : return "ITEME_TICKET_OF_LORD";
		case 16 : return "ITEME_LURE";
		case 17 : return "ITEME_CROP";
		case 18 : return "ITEME_MATURECROP";
		case 19 : return "ITEME_ENCHT_WP";
		case 20 : return "ITEME_ENCHT_AM";
		case 21 : return "ITEME_BLESS_ENCHT_WP";
		case 22 : return "ITEME_BLESS_ENCHT_AM";
		case 23 : return "ITEME_COUPON";
		case 24 : return "ITEME_ELIXIR";
		case 25 : return "ITEME_ENCHT_ATTR";
		case 26 : return "ITEME_ENCHT_ATTR_CURSED";
		case 27 : return "ITEME_BOLT";
		case 28 : return "ITEME_ENCHT_ATTR_INC_PROP_ENCHT_WP";
		case 29 : return "ITEME_ENCHT_ATTR_INC_PROP_ENCHT_AM";
		case 30 : return "ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_AM";
		case 31 : return "ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_WP";
		case 32 : return "ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM";
		case 33 : return "ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP";
		case 34 : return "ITEME_ENCHT_ATTR_RUNE";
		case 35 : return "ITEME_ENCHT_ATTRT_RUNE_SELECT";
		case 36 : return "ITEME_TELEPORTBOOKMARK";
		case 37 : return "ITEME_CHANGE_ATTR";
		case 38 : return "ITEME_SOULSHOT";
		case 39 : return "ITEME_SHAPE_SHIFTING_WP";
		case 40 : return "ITEME_BLESS_SHAPE_SHIFTING_WP";
		case 41 : return "ITEME_SHAPE_SHIFTING_WP_FIXED";
		case 42 : return "ITEME_SHAPE_SHIFTING_AM";
		case 43 : return "ITEME_BLESS_SHAPE_SHIFTING_AM";
		case 44 : return "ITEME_SHAPE_SHIFTING_AM_FIXED";
		case 45 : return "ITEME_SHAPE_SHIFTING_HAIRACC";
		case 46 : return "ITEME_BLESS_SHAPE_SHIFTING_HAIRACC";
		case 47 : return "ITEME_SHAPE_SHIFTING_HAIRACC_FIXED";
		case 48 : return "ITEME_RESTORE_SHAPE_SHIFTING_WP";
		case 49 : return "ITEME_RESTORE_SHAPE_SHIFTING_AM";
		case 50 : return "ITEME_RESTORE_SHAPE_SHIFTING_HAIRACC";
		case 51 : return "ITEME_RESTORE_SHAPE_SHIFTING_ALLITEM";
		case 52 : return "ITEME_BLESS_INC_PROP_ENCHT_WP";
		case 53 : return "ITEME_BLESS_INC_PROP_ENCHT_AM";
		case 54 : return "ITEME_CARD_EVENT";
		case 55 : return "ITEME_SHAPE_SHIFTING_ALLITEM_FIXED";
		case 56 : return "ITEME_MULTI_ENCHT_WP";
		case 57 : return "ITEME_MULTI_ENCHT_AM";
		case 58 : return "ITEME_MULTI_INC_PROB_ENCHT_WP";
		case 59 : return "ITEME_MULTI_INC_PROB_ENCHT_AM";
		case 60 : return "ITEME_ENSOUL_STONE";
		case 61 : return "ITEME_NICK_COLOR_OLD";
		case 62 : return "ITEME_NICK_COLOR_NEW";
		case 63 : return "ITEME_ENCHT_AG";
		case 64 : return "ITEME_BLESS_ENCHT_AG";
		case 65 : return "ITEME_MULTI_ENCHT_AG";
		case 66 : return "ITEME_ANCIENT_CRYSTAL_ENCHANT_AG";
		case 67 : return "ITEME_INC_PROP_ENCHT_AG";
		case 68 : return "ITEME_BLESS_INC_PROP_ENCHT_AG";
		case 69 : return "ITEME_MULTI_INC_PROB_ENCHT_AG";
		case 70 : return "ITEME_LOCK_ITEM";
		case 71 : return "ITEME_UNLOCK_ITEM";
		case 72 : return "ITEME_BULLET";
	}

	return "������ Ÿ���� �����ϴ�.";
}

function OnDBClickListCtrlRecord( string ListCtrlID)
{
	if (ListCtrlID == "itemListCtrl") OnGetItemBtnClick();
}


function OnInitBtnClick()
{
	FindAllItem("Init");
	addInfoEditBox.SetString("");
	searchEditBox.SetString("");
}

/** �˻� */
function FindAllItem( String a_Param )
{	
	ItemListCtrl.DeleteAllItem();
	itemIds.Length = 0;
	if (a_Param == "Init") return;

	//trim(a_Param) == ""
	// ���� ������ ��ȣ�� �˻��� ���..
	searchItemID = int(a_Param);
	if (int(a_Param) > 0)
	{
		cID.ClassID = searchItemID;

		if (class'UIDATA_ITEM'.static.GetItemInfo(cID, tmItemInfo))
		{
			addItem(tmItemInfo);
			return;
		}
	}

	searchItemID = 0;

	SearchString = Substitute(a_Param," ","",False);

	cID = class'UIDATA_ITEM'.static.GetFirstID();
	//searchEditBox.DisableWindow();

	searchItemID = 0;
	useTick = true;

	// ƽ ����
	Me.EnableTick();
}

function int findMatchString (string modifiedString, string a_Param)
{
	local string delim;

	delim = " ";
	if ( StringMatching(modifiedString,a_Param,delim) )
		return 1;
	else
		return -1;
	return 1;
}

function bool CanBless (ItemInfo Info)
{
	return Info.EnchantBlessGroupID > 0;
}

function bool isEnableEnchant (ItemInfo Info)
{
	switch (Info.ItemType)
	{
		case 0:
		case 1:
		case 2:
			return True;
	}
	return False;
}

function bool compareSubType ( itemInfo info ) 
{	
	//local string tmpSlotTypeString , selectedString;
	local bool isTotal, isTotal2, condition, condition2;
	local int reserved, reserved2;	
	isTotal = ItemOptionComboBox.GetSelectedNum() == ItemOptionComboBox.GetNumOfItems() - 1 ;
	isTotal2 = ItemOption2ComboBox.GetSelectedNum() == ItemOption2ComboBox.GetNumOfItems() - 1 ;
	reserved = ItemOptionComboBox.GetReserved(ItemOptionComboBox.GetSelectedNum());
	reserved2 = ItemOption2ComboBox.GetReserved(ItemOption2ComboBox.GetSelectedNum());
	//SLOTBITTYPE
	//tmpSlotTypeString = GetSlotTypeString( info.itemType, info.SlotBitType, info.WeaponType );
	//selectedString = ItemOptionComboBox.GetString( ItemOptionComboBox.GetSelectedNum());        
	switch ( info.itemType ) 
	{
		case EItemType.ITEM_WEAPON:	
			condition = reserved == info.WeaponType;			
			condition2 = ItemOption2ComboBox.GetString(ItemOption2ComboBox.GetSelectedNum()) == GetSlotTypeString( info.itemType, info.SlotBitType, info.WeaponType );
		break;
		case EItemType.ITEM_ARMOR:
			//Debug ( "compareSubType" @ ItemOptionComboBox.GetString(ItemOptionComboBox.GetSelectedNum()) ==  GetSlotTypeString( info.itemType, info.SlotBitType, info.ArmorType ) ) ;
			//Debug ( "compareSubType" @ ItemOptionComboBox.GetSelectedNum() @ info.ArmorType );
			
			condition = ItemOptionComboBox.GetString(ItemOptionComboBox.GetSelectedNum()) == GetSlotTypeString( info.itemType, info.SlotBitType, info.ArmorType );			
			condition2 = reserved2 == info.ArmorType;
		break;
		case EItemType.ITEM_ACCESSARY:				
			condition = reserved == info.SlotBitType;
			condition2 = true;			
		break;
		case EItemType.ITEM_ETCITEM:	
			condition = reserved == EEtcItemType(info.EtcItemType);
			condition2 = true;	
		break;
		//case EItemType.ITEM_QUESTITEM:
		//case EItemType.ITEM_ASSET:


		default:	
			return true;
		break;
	}	
	return  (( isTotal || condition ) && ( isTotal2 || condition2 ));	
}

// ��� ���� ��Ʈ���� ����
function setWeaponOptionComboBox ( ComboBoxHandle comboBox ) 
{
	local int i;
	local string comboBoxString ;
	for ( i = 0 ; i < 100 ; i ++ )
	{
		comboBoxString = GetWeaponTypeString( i ) ;				
		chkNAddString( comboBoxString, comboBox , i );	
	}
}

// ��� �� ���� �̸��� ����
function setArmorOptionComboBox ( ComboBoxHandle comboBox ) 
{
	setSlotTypeStringByItemType ( EItemType.ITEM_ARMOR, comboBox );		
}

// ��� �׼����� ���� �̸��� ����
function setAccessaryComboBox ( ComboBoxHandle comboBox ) 
{
	setSlotTypeStringByItemType ( EItemType.ITEM_ACCESSARY, comboBox );	
}

// ������ Ÿ�Կ� ���� ������ comboBox�� ��Ʈ���� ä�� ����
function setSlotTypeStringByItemType( int itemType,  ComboBoxHandle comboBox  ) 
{
	local int i, k;
	local string comboBoxString ;
	for ( i = 0 ; i < 100 ; i ++ )
		for ( k = 0 ; k < SLOTBITTYPE.Length ; k ++ )			
		{			
			comboBoxString = GetSlotTypeString( itemType, SLOTBITTYPE[k], i );
			chkNAddString( comboBoxString, comboBox , SLOTBITTYPE[k] );			
		}
}

// etc ������ �ɼ� �׸� UIEventManager �� �ִ� EEtcItemType ����ü
function setEtcitemComboBox (  ComboBoxHandle comboBox ) 
{
	local int i;	
	chkNAddString("NONE", comboBox , i ++ );	
	chkNAddString("SCROLL", comboBox , i ++ );	
	chkNAddString("ARROW", comboBox , i ++ );	
	chkNAddString("POTION", comboBox , i ++ );	
	chkNAddString("SPELLBOOK", comboBox , i ++ );	
	chkNAddString("RECIPE", comboBox , i ++ );	
	chkNAddString("MATERIAL", comboBox , i ++ );	
	chkNAddString("PET_COLLAR", comboBox , i ++ );	
	chkNAddString("CASTLE_GUARD", comboBox , i ++ );	
	chkNAddString("DYE", comboBox , i ++ );	
	chkNAddString("SEED", comboBox , i ++ );	
	chkNAddString("SEED2", comboBox , i ++ );	
	chkNAddString("HARVEST", comboBox , i ++ );	
	chkNAddString("LOTTO", comboBox , i ++ );	
	chkNAddString("RACE_TICKET", comboBox , i ++ );	
	chkNAddString("TICKET_OF_LORD", comboBox , i ++ );	
	chkNAddString("LURE", comboBox , i ++ );	
	chkNAddString("CROP", comboBox , i ++ );	
	chkNAddString("MATURECROP", comboBox , i ++ );	
	chkNAddString("ENCHT_WP", comboBox , i ++ );	
	chkNAddString("ENCHT_AM", comboBox , i ++ );	
	chkNAddString("BLESS_ENCHT_WP", comboBox , i ++ );	
	chkNAddString("BLESS_ENCHT_AM", comboBox , i ++ );	
	chkNAddString("COUPON", comboBox , i ++ );	
	chkNAddString("ELIXIR", comboBox , i ++ );	
	chkNAddString("ENCHT_ATTR", comboBox , i ++ );	
	chkNAddString("ENCHT_ATTR_CURSED", comboBox , i ++ );	
	chkNAddString("BOLT", comboBox , i ++ );	
	chkNAddString("ENCHT_ATTR_INC_PROP_ENCHT_WP", comboBox , i ++ );	
	chkNAddString("ENCHT_ATTR_INC_PROP_ENCHT_AM", comboBox , i ++ );	
	chkNAddString("ENCHT_ATTR_CRYSTAL_ENCHANT_AM", comboBox , i ++ );	
	chkNAddString("ENCHT_ATTR_CRYSTAL_ENCHANT_WP", comboBox , i ++ );	
	chkNAddString("ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM", comboBox , i ++ );	
	chkNAddString("ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP", comboBox , i ++ );	
	chkNAddString("ENCHT_ATTR_RUNE", comboBox , i ++ );	
	chkNAddString("ENCHT_ATTRT_RUNE_SELECT", comboBox , i ++ );	
	chkNAddString("TELEPORTBOOKMARK", comboBox , i ++ );	
	chkNAddString("CHANGE_ATTR", comboBox , i ++ );	
	chkNAddString("SOULSHOT", comboBox , i ++ );	
	chkNAddString("SHAPE_SHIFTING_WP", comboBox , i ++ );	
	chkNAddString("BLESS_SHAPE_SHIFTING_WP", comboBox , i ++ );	
	chkNAddString("SHAPE_SHIFTING_WP_FIXED", comboBox , i ++ );	
	chkNAddString("SHAPE_SHIFTING_AM", comboBox , i ++ );	
	chkNAddString("BLESS_SHAPE_SHIFTING_AM", comboBox , i ++ );	
	chkNAddString("SHAPE_SHIFTING_AM_FIXED", comboBox , i ++ );	
	chkNAddString("SHAPE_SHIFTING_HAIRACC", comboBox , i ++ );	
	chkNAddString("BLESS_SHAPE_SHIFTING_HAIRACC", comboBox , i ++ );	
	chkNAddString("SHAPE_SHIFTING_HAIRACC_FIXED", comboBox , i ++ );	
	chkNAddString("RESTORE_SHAPE_SHIFTING_WP", comboBox , i ++ );	
	chkNAddString("RESTORE_SHAPE_SHIFTING_AM", comboBox , i ++ );	
	chkNAddString("RESTORE_SHAPE_SHIFTING_HAIRACC", comboBox , i ++ );	
	chkNAddString("RESTORE_SHAPE_SHIFTING_ALLITEM", comboBox , i ++ );	
	chkNAddString("BLESS_INC_PROP_ENCHT_WP", comboBox , i ++ );	
	chkNAddString("BLESS_INC_PROP_ENCHT_AM", comboBox , i ++ );	
	chkNAddString("CARD_EVENT", comboBox , i ++ );	
	chkNAddString("SHAPE_SHIFTING_ALLITEM_FIXED", comboBox , i ++ );	
	chkNAddString("MULTI_ENCHT_WP", comboBox , i ++ );	
	chkNAddString("MULTI_ENCHT_AM", comboBox , i ++ );	
	chkNAddString("MULTI_INC_PROB_ENCHT_WP", comboBox , i ++ );	
	chkNAddString("MULTI_INC_PROB_ENCHT_AM", comboBox , i ++ );	
	chkNAddString("ENSOUL_STONE", comboBox , i ++ );	
}


function setOptionComboBoxString (int selectedID )
{	
	ItemOptionComboBox.Clear();	
	switch ( selectedID ) 
	{
		case EItemType.ITEM_WEAPON:
			setWeaponOptionComboBox( ItemOptionComboBox );			
		break;
		case EItemType.ITEM_ARMOR:
			setArmorOptionComboBox(ItemOptionComboBox );			
		break;
		case EItemType.ITEM_ACCESSARY:
			setAccessaryComboBox( ItemOptionComboBox );			
			//comboBoxString = GetWeaponTypeString( Item.WeaponType );
		break;
		case EItemType.ITEM_QUESTITEM:					
		break;
		case EItemType.ITEM_ASSET:			
		break;			
		case EItemType.ITEM_ETCITEM:		
			setEtcitemComboBox( ItemOptionComboBox);
		break;
		default:			
		break;
		
	}
	
	ItemOptionComboBox.AddString ( "Total");
	ItemOptionComboBox.SetSelectedNum( ItemOptionComboBox.GetNumOfItems () - 1 );
}

// ��� ���� ���� �̸��� ����( �Ѽ� ��� ) 
function setWeaponOption2ComboBox ( ComboBoxHandle comboBox ) 
{
	setSlotTypeStringByItemType ( EItemType.ITEM_WEAPON , comboBox ); 	
}

function setArmorOption2ComboBox ( ComboBoxHandle comboBox )
{
	comboBox.AddStringWithReserved (GetSystemString(441), 0);
	comboBox.AddStringWithReserved (GetSystemString(245), 1);
	comboBox.AddStringWithReserved (GetSystemString(246), 2);
	comboBox.AddStringWithReserved (GetSystemString(244), 3);
	comboBox.AddStringWithReserved (GetSystemString(1987), 4);	
}


function setOptionComboBox2String ( int selectedID ) 
{
	ItemOption2ComboBox.Clear();	
	switch ( selectedID ) 
	{
		case EItemType.ITEM_WEAPON:
			setWeaponOption2ComboBox( ItemOption2ComboBox);						
		break;
		case EItemType.ITEM_ARMOR:					
			setArmorOption2ComboBox( ItemOption2ComboBox );												
		break;
		case EItemType.ITEM_ACCESSARY:
		case EItemType.ITEM_QUESTITEM:
		case EItemType.ITEM_ASSET:
		case EItemType.ITEM_ETCITEM:							
		break;
		default:
		break;
	}

	ItemOption2ComboBox.AddString ( "Total");
	ItemOption2ComboBox.SetSelectedNum( ItemOption2ComboBox.GetNumOfItems () - 1 );	
}

function chkNAddString ( string tmpString, ComboBoxHandle tmpCombox, int reversed  ) 
{
	local int i ;	
	if ( tmpString == "" ) return;
	for ( i = 0 ; i < tmpCombox.GetNumOfItems() ; i ++ )
	{
		if ( tmpCombox.GetString( i ) == tmpString ) return;
	}
	tmpCombox.AddStringWithReserved( tmpString, reversed );
}

function tickProcess()
{
	local int i;
	
	if (!IsValidItemID(cID))
	{
		// Debug("Tick ����");
		Me.DisableTick();
		// searchEditBox.EnableWindow();
		useTick = false;
		setWindowTitleByString("UIPowerTools [ ItemTool ]");
		for (i = 0; i < ItemIDs.Length; i++)
		{
			SetINIString("itemlist", "item[" $ i $ "]", string(ItemIDs[i]), "tests.ini");
		}
		SaveINI("tests.ini");
		return;
	}

	cID = class'UIDATA_ITEM'.static.GetNextID();
	
	fullNameString  = class'UIDATA_ITEM'.static.GetItemName( cID );
	modifiedString = Substitute(fullNameString, " ", "", FALSE);

	if ( (findMatchString(modifiedString,SearchString) != -1) || (SearchString == "") )
	{
		// Ŭ���� Ÿ��
		// ���
		ItemCrystalType = class'UIDATA_ITEM'.static.GetItemCrystalType(cID);

		// debug("GetItemCrystalType --> " @ class'UIDATA_ITEM'.static.GetItemCrystalType(cID));

		// 11�� ��� ���� 

		if (ItemGradeComboBox.GetSelectedNum() == ItemCrystalType || ItemGradeComboBox.GetSelectedNum() == 12)
		{
			/// ItemType
			class'UIDATA_ITEM'.static.GetItemInfo(cID, tmItemInfo);
			
			if ( ChkBoxBless.IsChecked() )
			{
				if ( !CanBless(tmItemInfo) )
				{
					searchItemID++;
					return;
				}
			}

			filterItemType = ItemTypeComboBox.GetSelectedNum();

			// �� Ÿ��
			if (filterItemType == tmItemInfo.itemType)
			{
				//Debug ( "tickProcess" @  compareSubType ( tmItemInfo )  ) ;
				if ( compareSubType ( tmItemInfo ) ) addItem(tmItemInfo);
			}
			// ����, �� 
			else if (filterItemType == 7)
			{
				if (tmItemInfo.itemType == EItemType.ITEM_WEAPON || tmItemInfo.itemType == EItemType.ITEM_ARMOR) if ( compareSubType ( tmItemInfo) ) addItem( tmItemInfo );
			}
			// ��ü
			else if (filterItemType == 6)
			{
				if ( compareSubType ( tmItemInfo ) ) addItem( tmItemInfo );
			}
		}
		
		searchItemID++;
	}
}

// ������� �ӵ� ������ �Ѵٰ� ���� �ڵ� ���µ� �˻� Ű���� �������̿��� ������.
//// ƽ�� �˻�
//function tickProcess()
//{
//	local int itemType;
//	local int crystalType;
//	if (!IsValidItemID(cID))
//	{
//		// Debug("Tick ����");
//		Me.DisableTick();
//		// searchEditBox.EnableWindow();
//		useTick = false;
//		Me.SetWindowTitle("UIPowerTools [ ItemTool ]");
//		return;
//	}

//	itemType = ItemTypeComboBox.GetSelectedNum();
//	if (itemType == 6) // ��ü
//		itemType = -1;
//	// 7 �� ����, ���� ����

//	crystalType = ItemGradeComboBox.GetSelectedNum();
//	if (crystalType == 11)	// ��� ����
//		crystalType = -1;

//	// �̸�, ItemType, CrystalType���� �˻� ��. type�� -1�� �����ϸ� ��ü
//	cID = class'UIDATA_ITEM'.static.FindNextID(modifiedParam, itemType, crystalType);
//	if(cID.ClassID >= 0)
//	{
//		class'UIDATA_ITEM'.static.GetItemInfo(cID, tmItemInfo);
//		if ( compareSubType ( tmItemInfo ) )
//			addItem(tmItemInfo);
//		searchItemID++;
//	}
//	/* FindNextID()�� ��ü
//	fullNameString  = class'UIDATA_ITEM'.static.GetItemName( cID );
//	modifiedString = Substitute(fullNameString, " ", "", FALSE);

//	if ( InStr( modifiedString  , modifiedParam ) != -1 )
//	{
//		// Ŭ���� Ÿ��
//		// ���
//		ItemCrystalType = class'UIDATA_ITEM'.static.GetItemCrystalType(cID);

//		// debug("GetItemCrystalType --> " @ class'UIDATA_ITEM'.static.GetItemCrystalType(cID));

//		// 11�� ��� ���� 

//		if (ItemGradeComboBox.GetSelectedNum() == ItemCrystalType || ItemGradeComboBox.GetSelectedNum() == 11)
//		{
//			/// ItemType
//			class'UIDATA_ITEM'.static.GetItemInfo(cID, tmItemInfo);

//			filterItemType = ItemTypeComboBox.GetSelectedNum();

//			// �� Ÿ��
//			if (filterItemType == tmItemInfo.itemType)
//			{
//				//Debug ( "tickProcess" @  compareSubType ( tmItemInfo )  ) ;
//				if ( compareSubType ( tmItemInfo ) ) addItem(tmItemInfo);
//			}
//			// ����, �� 
//			else if (filterItemType == 7)
//			{
//				if (tmItemInfo.itemType == EItemType.ITEM_WEAPON || tmItemInfo.itemType == EItemType.ITEM_ARMOR) if ( compareSubType ( tmItemInfo) ) addItem( tmItemInfo );
//			}
//			// ��ü
//			else if (filterItemType == 6)
//			{
//				if ( compareSubType ( tmItemInfo ) ) addItem( tmItemInfo );
//			}
//		}
		
//		searchItemID++;
//	}
//	*/
//}

function OnComboBoxItemSelected(string StrID, int IndexID)
{
	switch ( StrID ) 
	{
	case "ItemTypeComboBox":
		setOptionComboBoxString( IndexID );
		setOptionComboBox2String( IndexID );
		if ( ItemOptionComboBox.GetNumOfItems() > 1 ) 
			ItemOptionComboBox.ShowWindow();
		else 
			ItemOptionComboBox.HideWindow();

		if (ItemOption2ComboBox.GetNumOfItems() > 1 )  
		{
			ItemOptionComboBox.SetWindowSize( 107, 19 );
			ItemOption2ComboBox.ShowWindow();
		}
		else 
		{
			ItemOptionComboBox.SetWindowSize ( 180, 19) ;
			ItemOption2ComboBox.HideWindow();		
		}
		break;	
	}
}

function onTick()
{
	local int i;

	if(switchBool == false)
	{
		setWindowTitleByString("UIPowerTools [ ItemTool ]  - Searching.. ");
		switchBool = true;
	}
	else
	{
		setWindowTitleByString("UIPowerTools [ ItemTool ]  + Searching.... ");
		switchBool = false;
	}

	// tick�� 10��
	for(i = 0; i < 100; i++)
	{
		if (!useTick) break;
		tickProcess();
	}
}

/** �������� �߰� �Ѵ�. */
function addItem(itemInfo info)
{
	local LVDataRecord Record;
	local string param, additionalName, fullNameString;
	local int itemNameClass;
	local string iconStr;
	local EnchantValidateUIData EnchantData;

	// ParamToItemInfo(param, info);
	// ParamAdd(param, "ClassID", string(info.ID.ClassID));
	class'UIDATA_ITEM'.static.GetEnchantValidateValue(Info.Id.ClassID, Info.Enchanted, EnchantData);
	fullNameString = info.Name;

	itemNameClass  = class'UIDATA_ITEM'.static.GetItemNameClass( info.ID );			
	additionalName = class'UIDATA_ITEM'.static.GetItemAdditionalName( info.ID );
	// End:0xA5
	if(itemNameClass == 0)		 //������ ������ 
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);
	}
	else if (itemNameClass == 2) //����� ������
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
	}
	if (Len(additionalName) > 0 )
	{
		fullNameString = fullNameString $ "(" $ additionalName $ ")";
	}
	
	// �ش� ������ ���� ����Ʈ�� �����������ü� �ֵ��� ���  <- �߱��ʿ��� ���� api
	class'UIDATA_ITEM'.static.GetItemInfoString(info.Id.ClassID, param);  

	Record.szReserved = param;

	Record.nReserved1 = Int64(info.Id.ClassID);
	Record.LVDataList.length = 5;
	// ������ 

	Record.LVDataList[0].szData = fullNameString;
	
	
	if ( ChkBox64.IsChecked() )
	{
		iconStr = Caps(Info.IconName);
		ReplaceText(iconStr,"ICON.","ICON2.");
		Record.LVDataList[0].hasIcon = True;
		Record.LVDataList[0].nTextureWidth = 32;
		Record.LVDataList[0].nTextureHeight = 32;
		Record.LVDataList[0].nTextureU = 64;
		Record.LVDataList[0].nTextureV = 64;
		Record.LVDataList[0].szTexture = iconStr;
		Record.LVDataList[0].IconPosX = 10;
		Record.LVDataList[0].FirstLineOffsetX = 6;
	}
	else
	{
		Record.LVDataList[0].hasIcon = True;
		Record.LVDataList[0].nTextureWidth = 32;
		Record.LVDataList[0].nTextureHeight = 32;
		Record.LVDataList[0].nTextureU = 32;
		Record.LVDataList[0].nTextureV = 32;
		Record.LVDataList[0].szTexture = Info.IconName;
		Record.LVDataList[0].IconPosX = 10;
		Record.LVDataList[0].FirstLineOffsetX = 6;
	}

	// Record.LVDataList[0].HiddenStringForSorting = itemName $ util.makeZeroString(3, enchanted);
	
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

	if (info.iconPanel != "") iconPanelTotalCount++;

	// ������ �׵θ� (�⺻ ����.pvp �����)
	if(ChkBox64.IsChecked())
	{
		iconStr = Caps(Info.IconPanel);
		ReplaceText(iconStr, "ICON.", "ICON2.");
		Record.LVDataList[0].iconPanelName = iconStr;
		Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
		Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
		Record.LVDataList[0].panelWidth = 32;
		Record.LVDataList[0].panelHeight = 32;
		Record.LVDataList[0].panelUL = 64;
		Record.LVDataList[0].panelVL = 64;		
	}
	else
	{
		Record.LVDataList[0].iconPanelName = Info.IconPanel;
		Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
		Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
		Record.LVDataList[0].panelWidth = 32;
		Record.LVDataList[0].panelHeight = 32;
		Record.LVDataList[0].panelUL = 32;
		Record.LVDataList[0].panelVL = 32;
	}

	// ����, ��, �Ǽ��縮 �� ����� ǥ�����ش�.(ȥ���� �Ǹ��� �ܰ� �̷���.. ITEM_ETCITEM ���� ���ͼ�.. )
	if (info.itemType == EItemType.ITEM_WEAPON || info.itemType == EItemType.ITEM_ACCESSARY || info.itemType == EItemType.ITEM_ARMOR) // || itemType == EItemType.ITEM_ETCITEM)
	{
		// ��� ���
		Record.LVDataList[1].szData = util.getItemGradeSystemString(info.crystalType); 
	}
	else
	{
		// ������ �ƴ� ��� ����� ��� �Ѵ�.
		if (info.crystalType != 0) Record.LVDataList[1].szData = util.getItemGradeSystemString(info.crystalType);
		else Record.LVDataList[1].szData = "-";		
	}

	Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(6, info.crystalType);
	Record.LVDataList[1].textAlignment=TA_Left;

	switch ( info.itemType ) 
	{
		case EItemType.ITEM_WEAPON:				
			itemListCtrl.SetColumnString(2, 55);
			itemListCtrl.SetColumnString(3, 98);
			Record.LVDataList[2].szData = string(info.pAttack + EnchantData.EnchantValue[2]);
			Record.LVDataList[3].szData = string(info.mAttack + EnchantData.EnchantValue[3]);
		break;
		case EItemType.ITEM_ARMOR:
			itemListCtrl.SetColumnString(2, 54);
			itemListCtrl.SetColumnString(3, 99);	
			Record.LVDataList[2].szData = String(int (info.pDefense + info.ShieldDefense));
			Record.LVDataList[3].szData = String(int (info.mDefense));			
		break;
		case EItemType.ITEM_ACCESSARY:				
			itemListCtrl.SetColumnString(2, 54);
			itemListCtrl.SetColumnString(3, 99);	
			Record.LVDataList[2].szData = String(int (info.pDefense + info.ShieldDefense));
			Record.LVDataList[3].szData = String(int (info.mDefense));			
		break;
			case EItemType.ITEM_ETCITEM:			
			Record.LVDataList[2].szData = String(0);
			Record.LVDataList[3].szData = String(0);
		break;		
	}
	
	Record.LVDataList[2].textAlignment=TA_Right;	
	Record.LVDataList[3].textAlignment=TA_Right;

	Record.LVDataList[4].szData = String(info.Id.ClassID);
	Record.LVDataList[4].textAlignment=TA_Left;

	// ���� 

	// Debug("consumeType----------> " @ consumeType);
	// ������ ������
	// if (IsStackableItem( info.consumeType ) )
	
	
	// ����
	//Record.LVDataList[3].szData = 
	//Record.LVDataList[3].textAlignment=TA_Right;
	
	itemIds[itemIds.Length] = info.Id.ClassID;
	ItemListCtrl.InsertRecord( Record );	
}



/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( "UIItemToolWnd" ).HideWindow();
}


//function getItemAndUse()
//{
//	local LVDataRecord Record;
//	local ItemID citemID;
//	local ItemInfo itemInfo;

//	ItemListCtrl.GetSelectedRec(Record);
//	citemID.classID = int(record.nReserved1);

//	// �ʱ�ȭ.
//	targetItemInfo = itemInfo;

//	if (class'UIDATA_ITEM'.static.GetItemInfo(citemID, itemInfo))
//	{
//		descViewEditBox.SetString(itemInfo.Description $ "\n");
//		descViewEditBox.SetEditable(false);

//		targetItemInfo = itemInfo;

//		ProcessChatMessage("//destroy_all_inven_item", 0);
//		ProcessChatMessage("//summon" @ String(citemID.classID) $ " "$string(1), 0);
		
//		// RequestUseItem(citemID);
//		Me.KillTimer(DELAY1_ID);
//		Me.SetTimer(DELAY1_ID, 100);

//	}
//}

//function OnTimer(int timeID)
//{
//	local int itemIndex;
//	if (DELAY1_ID == timeID)
//	{
//		itemIndex = getInstanceInventoryWnd().useItemOutSide(targetItemInfo);
//		if (itemIndex >= 0) Me.KillTimer(DELAY1_ID);		
//	}
//}

/** OnKeyUp */
function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
	// local string MainKey;

	// Ű���� �������� üũ 	
	if (searchEditBox.IsFocused())
	{	
		// txtPath
		if (nKey == IK_Enter) 
		{
			// Ű���� �Է��� �ƹ��͵� �Է� ���� �ʾ����� ��ü �˻��� ������� �ʴ´�.
			// �Ǽ��� �ڲ� ������ ��찡 �־..
			if (trim(searchEditBox.GetString()) != "") OnsearchItemBtnClick();
		}
	}
	else if ( Create2EditBox.IsFocused() )
		OnClickListCtrlRecord("itemListCtrl");
		
	//MainKey = class'InputAPI'.static.GetKeyString(nKey);

	//// �̸� ������ 
	//if (MainKey == "SLASH" && Me.IsShowWindow() && !IsFinalRelease())
	//{		
	//	if (itemListCtrl.GetSelectedIndex()  < itemListCtrl.GetRecordCount())
	//	{
	//		itemListCtrl.SetSelectedIndex(itemListCtrl.GetSelectedIndex() + 1, true);
	//		OnClickListCtrlRecord("itemListCtrl");
			
	//		getItemAndUse();
	//	}
	//}
}
	
	

defaultproperties
{
}
