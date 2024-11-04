class ItemAttributeChangeWnd extends UICommonAPI;

const ATTRIBUTE_FIRE 	= 0;
const ATTRIBUTE_WATER 	= 1;
const ATTRIBUTE_WIND 	= 2;
const ATTRIBUTE_EARTH 	= 3;
const ATTRIBUTE_HOLY 	= 4;
const ATTRIBUTE_UNHOLY 	= 5;

const TOTALLEN = 6;

var array<int> arrSystemString;

var Array<int> AttackAttLevel;
var Array<int> AttackAttCurrValue;
var Array<int> AttackAttMaxValue; //��� ���� �Ӽ��� ����, ���緹�������� ��, ���緹�������� �ִ밪�� ���⿡ �����Ѵ�.

var WindowHandle Me;
var TextBoxHandle InventoryItemListTitle;
var ItemWindowHandle InventoryItemList;
var TextureHandle InventoryItemListSlotBg;
var TextureHandle InventoryItemListBg;
var TextBoxHandle AttributeItemTitle;
var ItemWindowHandle AttributeItem;
var NameCtrlHandle AttributeItemName;
var TextBoxHandle AttributeItemtype;
var TreeHandle AttributeIteminfo;
var TextureHandle AttributeItemSlotBg;
var TextureHandle AttributeIteminfoLine;
var TextureHandle AttributeItemBg;
var TextBoxHandle ItemAttributeInfoTitle;
var TextBoxHandle ItemAttribute;
var BarHandle ItemAttributeGage;
var TextureHandle ItemAttributeInfoBg;
var TextBoxHandle AttributeListTitle;
var TextBoxHandle FireAttributeTitle;
var TextBoxHandle WaterAttributeTitle;
var TextBoxHandle WindAttributeTitle;
var TextBoxHandle EarthAttributeTitle;
var TextBoxHandle DivineAttributeTitle;
var TextBoxHandle DarkAttributeTitle;
var ButtonHandle FireAttributeBtn;
var ButtonHandle WaterAttributeBtn;
var ButtonHandle WindAttributeBtn;
var ButtonHandle EarthAttributeBtn;
var ButtonHandle DivineAttributeBtn;
var ButtonHandle DarkAttributeBtn;
var TextureHandle AttributeListBg;
var ButtonHandle ChangeBtn;
var ButtonHandle CancelBtn;

var WindowHandle   DisableWnd;

//���� ����ϴ� �׷� ���̵�
var int groupID;

var int indexItemList;

var int selectNum;

var int nItemAttribute;

var ItemInfo infItem;

//Utill ����
var L2Util util;

var int saveBeforeIndex;

	var int attr_fire;
	var int attr_water;
	var int attr_wind;
	var int attr_earth;
	var int attr_holy;
	var int attr_unholy;

const DIALOGID_NotSelect = 7010;
const DIALOGID_Change = 7020;


function OnRegisterEvent()
{
	RegisterEvent( EV_ChangeAttribute_CandidateListClear );
	RegisterEvent( EV_ChangeAttribute_CandidateItem );
	RegisterEvent( EV_ChangeAttribute_ItemDetail );
	RegisterEvent( EV_ChangeAttribute_ItemResult );

	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}

function OnLoad()
{
	SetClosingOnESC();

	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle( "ItemAttributeChangeWnd" );
	//InventoryItemListTitle = GetTextBoxHandle( "ItemAttributeChangeWnd.InventoryItemListTitle" );
	InventoryItemList = GetItemWindowHandle( "ItemAttributeChangeWnd.InventoryItemList" );
	//InventoryItemListSlotBg = GetTextureHandle( "ItemAttributeChangeWnd.InventoryItemListSlotBg" );
	//InventoryItemListBg = GetTextureHandle( "ItemAttributeChangeWnd.InventoryItemListBg" );
	//AttributeItemTitle = GetTextBoxHandle( "ItemAttributeChangeWnd.AttributeItemTitle" );
	AttributeItem = GetItemWindowHandle( "ItemAttributeChangeWnd.AttributeItem" );
	AttributeItemName = GetNameCtrlHandle( "ItemAttributeChangeWnd.AttributeItemName" );
	AttributeItemtype = GetTextBoxHandle( "ItemAttributeChangeWnd.AttributeItemtype" );
	AttributeIteminfo = GetTreeHandle( "ItemAttributeChangeWnd.AttributeIteminfo" );
	//AttributeItemSlotBg = GetTextureHandle( "ItemAttributeChangeWnd.AttributeItemSlotBg" );
	//AttributeIteminfoLine = GetTextureHandle( "ItemAttributeChangeWnd.AttributeIteminfoLine" );
	//AttributeItemBg = GetTextureHandle( "ItemAttributeChangeWnd.AttributeItemBg" );
	//ItemAttributeInfoTitle = GetTextBoxHandle( "ItemAttributeChangeWnd.ItemAttributeInfoTitle" );
	ItemAttribute = GetTextBoxHandle( "ItemAttributeChangeWnd.ItemAttribute" );
	ItemAttributeGage = GetBarHandle( "ItemAttributeChangeWnd.ItemAttributeGage" );
	//ItemAttributeInfoBg = GetTextureHandle( "ItemAttributeChangeWnd.ItemAttributeInfoBg" );
	//AttributeListTitle = GetTextBoxHandle( "ItemAttributeChangeWnd.AttributeListTitle" );
	FireAttributeTitle = GetTextBoxHandle( "ItemAttributeChangeWnd.FireAttributeTitle" );
	WaterAttributeTitle = GetTextBoxHandle( "ItemAttributeChangeWnd.WaterAttributeTitle" );
	WindAttributeTitle = GetTextBoxHandle( "ItemAttributeChangeWnd.WindAttributeTitle" );
	EarthAttributeTitle = GetTextBoxHandle( "ItemAttributeChangeWnd.EarthAttributeTitle" );
	DivineAttributeTitle = GetTextBoxHandle( "ItemAttributeChangeWnd.DivineAttributeTitle" );
	DarkAttributeTitle = GetTextBoxHandle( "ItemAttributeChangeWnd.DarkAttributeTitle" );
	FireAttributeBtn = GetButtonHandle( "ItemAttributeChangeWnd.FireAttributeBtn" );
	WaterAttributeBtn = GetButtonHandle( "ItemAttributeChangeWnd.WaterAttributeBtn" );
	WindAttributeBtn = GetButtonHandle( "ItemAttributeChangeWnd.WindAttributeBtn" );
	EarthAttributeBtn = GetButtonHandle( "ItemAttributeChangeWnd.EarthAttributeBtn" );
	DivineAttributeBtn = GetButtonHandle( "ItemAttributeChangeWnd.DivineAttributeBtn" );
	DarkAttributeBtn = GetButtonHandle( "ItemAttributeChangeWnd.DarkAttributeBtn" );
	AttributeListBg = GetTextureHandle( "ItemAttributeChangeWnd.AttributeListBg" );
	ChangeBtn = GetButtonHandle( "ItemAttributeChangeWnd.ChangeBtn" );
	CancelBtn = GetButtonHandle( "ItemAttributeChangeWnd.CancelBtn" );

	DisableWnd = GetWindowHandle( "ItemAttributeChangeWnd.DisableWnd" );
}

function Load()
{	
	arrSystemString.Length = TOTALLEN;
	arrSystemString[0] = 1622;
	arrSystemString[1] = 1623;
	arrSystemString[2] = 1624;
	arrSystemString[3] = 1625;
	arrSystemString[4] = 1626;
	arrSystemString[5] = 1627;

	util = L2Util(GetScript("L2Util"));	
}

function onShow()
{ 
	// ������ �����츦 ������ �ݱ� ��� 
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)), "InventoryWnd");
}

function onHide()
{
	DisableCurrentWindow(false);

	if( DialogIsMine() )
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		DialogHide();
	}
}

function OnEvent(int Event_ID, string param)
{
	local ItemInfo info;

	//���� ����.
	local int result;

	if( Event_ID == EV_ChangeAttribute_CandidateListClear )
	{
		ParseInt(param, "groupID", groupID);
		setClear();
	}
	else if( Event_ID == EV_ChangeAttribute_CandidateItem )
	{
		if( !Me.IsShowWindow() )
		{
			Me.ShowWindow();
			Me.SetFocus();
		}

		ParamToItemInfo( param, info );

		InventoryItemList.AddItem( info );
		indexItemList++;
		
		InventoryItemList.SetSelectedNum( 0 );
		OnClickItem( "InventoryItemList",  0 );
	}
	else if( Event_ID == EV_ChangeAttribute_ItemDetail )
	{
		ParseInt(param, "attr_fire", attr_fire);
		ParseInt(param, "attr_water", attr_water);
		ParseInt(param, "attr_wind", attr_wind);
		ParseInt(param, "attr_earth", attr_earth);
		ParseInt(param, "attr_holy", attr_holy);
		ParseInt(param, "attr_unholy", attr_unholy);

		setDefultButton();
	}
	//����, ���� Ȯ��
	else if( Event_ID == EV_ChangeAttribute_ItemResult )
	{
		ParseInt(param, "result", result);
		
		//�������� �ý��� �޽��� ������.
		if( result == 1 )
		{	
			Me.HideWindow();
			/*
			AddSystemMessageString("� �������� �����ߴٰ� �ؾ���.����");			
			AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(3530), 
					   getItemNameForSellingAgency(targetItemInfo), 
					   String(Amount))); */
		}
		else
		{
			Me.HideWindow();
			//AddSystemMessage(3661);		
		}
	}
	else if( Event_ID == EV_DialogOK )
	{
		HandleDialogOK();
	}
	else if( Event_ID == EV_DialogCancel )
	{
		DisableCurrentWindow(false);
	}
}

/** ���̾�α� �ڽ� OK Ŭ���� */
function HandleDialogOK()
{
	if (DialogIsMine())
	{
		if( DialogGetID() == DIALOGID_Change )
		{
			//�Ӽ� ���� 
			RequestChangeAttributeItem( groupID, infItem.Id.ServerID, selectNum );			
		}
		else if( DialogGetID() == DIALOGID_NotSelect )
		{
			DisableCurrentWindow(false);
		}
	}
}

/** �ʱ�ȭ */
function setClear()
{
	InventoryItemList.Clear();
	setDefultButton();
	indexItemList = 0;
	selectNum = -1;
	saveBeforeIndex = -1;
	DisableCurrentWindow(false);
}


function OnClickButton( string Str )
{
	switch( Str )
	{
	case "FireAttributeBtn":
		OnFireAttributeBtnClick();
		break;
	case "WaterAttributeBtn":
		OnWaterAttributeBtnClick();
		break;
	case "WindAttributeBtn":
		OnWindAttributeBtnClick();
		break;
	case "EarthAttributeBtn":
		OnEarthAttributeBtnClick();
		break;
	case "DivineAttributeBtn":
		OnDivineAttributeBtnClick();
		break;
	case "DarkAttributeBtn":
		OnDarkAttributeBtnClick();
		break;
	case "ChangeBtn":
		DisableCurrentWindow(true);
		OnChangeBtnClick();
		break;
	case "CancelBtn":
		//AddSystemMessage(3661);
		DisableCurrentWindow(false);
		OnHideMeWindow();
		break;
	}
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

function OnClickItem( string strID, int index )
{
	if (strID == "InventoryItemList" && index > -1)
	{
		if(	saveBeforeIndex == index )
			return;

		if ( InventoryItemList.GetItem( index, infItem ) )
		{ 
			if (infItem.ID.ClassID > 0 )
			{
				setDefultButton();
				selectNum = -1;
				AttributeItem.Clear();
				AttributeItem.AddItem( infItem );
				//SlotString = GetSlotTypeString(Item.ItemType, Item.SlotBitType, Item.ArmorType);
				AttributeItemName.SetNameUsingItem( infItem, NCT_Item, TA_Left );
				//AttributeItemName.SetName( "�׽�Ʈ��", NCT_Item, TA_Left );
				//Debug( GetWeaponTypeString( infItem.WeaponType ) );
				//Debug( GetSlotTypeString( infItem.ItemType, infItem.SlotBitType, infItem.ArmorType) );
				AttributeItemtype.SetText( GetWeaponTypeString( infItem.WeaponType ) $ " / "$ GetSlotTypeString( infItem.ItemType, infItem.SlotBitType, infItem.ArmorType) );

				setAttributeGage( infItem );

				SelectChangeAttributeItem( groupID, infItem.Id.ServerID );

				setAttributeIteminfo();

				saveBeforeIndex = index;
			}
		}		
	}
}

function setAttributeGage(ItemInfo Item)
{
	// ���� ������ �Ӽ�
	if (Item.AttackAttributeValue > 0)
	{
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_FIRE);
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_WATER);
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_WIND);
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_EARTH);
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_HOLY);
		SetAttackAttribute(Item.AttackAttributeValue,ATTRIBUTE_UNHOLY); //������ ���������� ���Ѵ�.		

		nItemAttribute = Item.AttackAttributeType;

		switch(Item.AttackAttributeType)
		{
			case ATTRIBUTE_FIRE:
				ItemAttribute.SetText( GetSystemString(1622) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_FIRE]) $ " ("$ GetSystemString(1622) $ " " $ GetSystemString(55) $ " " $ String(Item.AttackAttributeValue) $")" );
				ItemAttributeGage.SetTexture( 0, "L2UI_CT1.Gauge_df_attribute_Fire_Center" );
				ItemAttributeGage.SetTexture( 1, "L2UI_CT1.Gauge_df_attribute_Fire_Center" );
				ItemAttributeGage.SetTexture( 2, "L2UI_CT1.Gauge_df_attribute_Fire_Right" );
				ItemAttributeGage.SetTexture( 3, "L2UI_CT1.Gauge_df_attribute_Fire_Bg_Left" );
				ItemAttributeGage.SetTexture( 4, "L2UI_CT1.Gauge_df_attribute_Fire_Bg_Center" );
				ItemAttributeGage.SetTexture( 5, "L2UI_CT1.Gauge_df_attribute_Fire_Bg_Right" );
				break;

			case ATTRIBUTE_WATER:
				ItemAttribute.SetText( GetSystemString(1623) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_WATER]) $ " ("$ GetSystemString(1623) $ " " $ GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")" );
				ItemAttributeGage.SetTexture( 0, "L2UI_CT1.Gauge_df_attribute_Water_Left" );
				ItemAttributeGage.SetTexture( 1, "L2UI_CT1.Gauge_df_attribute_Water_Center" );
				ItemAttributeGage.SetTexture( 2, "L2UI_CT1.Gauge_df_attribute_Water_Right" );
				ItemAttributeGage.SetTexture( 3, "L2UI_CT1.Gauge_df_attribute_Water_Bg_Left" );
				ItemAttributeGage.SetTexture( 4, "L2UI_CT1.Gauge_df_attribute_Water_Bg_Center" );
				ItemAttributeGage.SetTexture( 5, "L2UI_CT1.Gauge_df_attribute_Water_Bg_Right" );
				break;

			case ATTRIBUTE_WIND:
				ItemAttribute.SetText( GetSystemString(1624) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_WIND]) $ " ("$ GetSystemString(1624) $ " " $ GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")" );
				ItemAttributeGage.SetTexture( 0, "L2UI_CT1.Gauge_df_attribute_Wind_Left" );
				ItemAttributeGage.SetTexture( 1, "L2UI_CT1.Gauge_df_attribute_Wind_Center" );
				ItemAttributeGage.SetTexture( 2, "L2UI_CT1.Gauge_df_attribute_Wind_Right" );
				ItemAttributeGage.SetTexture( 3, "L2UI_CT1.Gauge_df_attribute_Wind_Bg_Left" );
				ItemAttributeGage.SetTexture( 4, "L2UI_CT1.Gauge_df_attribute_Wind_Bg_Center" );
				ItemAttributeGage.SetTexture( 5, "L2UI_CT1.Gauge_df_attribute_Wind_Bg_Right" );
				break;

			case ATTRIBUTE_EARTH:
				ItemAttribute.SetText( GetSystemString(1625) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_EARTH]) $ " ("$ GetSystemString(1625) $ " " $ GetSystemString(55) $ " " $ String(Item.AttackAttributeValue) $")" );
				ItemAttributeGage.SetTexture( 0, "L2UI_CT1.Gauge_df_attribute_Earth_Left" );
				ItemAttributeGage.SetTexture( 1, "L2UI_CT1.Gauge_df_attribute_Earth_Center" );
				ItemAttributeGage.SetTexture( 2, "L2UI_CT1.Gauge_df_attribute_Earth_Right" );
				ItemAttributeGage.SetTexture( 3, "L2UI_CT1.Gauge_df_attribute_Earth_Bg_Left" );
				ItemAttributeGage.SetTexture( 4, "L2UI_CT1.Gauge_df_attribute_Earth_Bg_Center" );
				ItemAttributeGage.SetTexture( 5, "L2UI_CT1.Gauge_df_attribute_Earth_Bg_Right" );
				break;

			case ATTRIBUTE_HOLY:
				ItemAttribute.SetText( GetSystemString(1626) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_HOLY]) $ " ("$ GetSystemString(1626) $ " " $ GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")" );
				ItemAttributeGage.SetTexture( 0, "L2UI_CT1.Gauge_df_attribute_Divine_Left" );
				ItemAttributeGage.SetTexture( 1, "L2UI_CT1.Gauge_df_attribute_Divine_Center" );
				ItemAttributeGage.SetTexture( 2, "L2UI_CT1.Gauge_df_attribute_Divine_Right" );
				ItemAttributeGage.SetTexture( 3, "L2UI_CT1.Gauge_df_attribute_Divine_Bg_Left" );
				ItemAttributeGage.SetTexture( 4, "L2UI_CT1.Gauge_df_attribute_Divine_Bg_Center" );
				ItemAttributeGage.SetTexture( 5, "L2UI_CT1.Gauge_df_attribute_Divine_Bg_Right" );
				break;

			case ATTRIBUTE_UNHOLY:
				ItemAttribute.SetText( GetSystemString(1627) $ " Lv " $ String(AttackAttLevel[ATTRIBUTE_UNHOLY]) $ " ("$ GetSystemString(1627) $ " " $ GetSystemString(55) $ " " $String(Item.AttackAttributeValue) $ ")" );
				ItemAttributeGage.SetTexture( 0, "L2UI_CT1.Gauge_df_attribute_Dark_Left" );
				ItemAttributeGage.SetTexture( 1, "L2UI_CT1.Gauge_df_attribute_Dark_Center" );
				ItemAttributeGage.SetTexture( 2, "L2UI_CT1.Gauge_df_attribute_Dark_Right" );
				ItemAttributeGage.SetTexture( 3, "L2UI_CT1.Gauge_df_attribute_Dark_Bg_Left" );
				ItemAttributeGage.SetTexture( 4, "L2UI_CT1.Gauge_df_attribute_Dark_Bg_Center" );
				ItemAttributeGage.SetTexture( 5, "L2UI_CT1.Gauge_df_attribute_Darke_Bg_Right" );
				break;
		}
		ItemAttributeGage.SetValue( AttackAttMaxValue[0], AttackAttCurrValue[0] ); 
	}
}


function OnFireAttributeBtnClick()
{
	setDefultButton();
	selectNum = ATTRIBUTE_FIRE;
	FireAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_select");
}

function OnWaterAttributeBtnClick()
{
	setDefultButton();
	selectNum = ATTRIBUTE_WATER;
	WaterAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_select");
}

function OnWindAttributeBtnClick()
{
	setDefultButton();
	selectNum = ATTRIBUTE_WIND;
	WindAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_select");
}

function OnEarthAttributeBtnClick()
{
	setDefultButton();
	selectNum = ATTRIBUTE_EARTH;
	EarthAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_select");
}

function OnDivineAttributeBtnClick()
{
	setDefultButton();
	selectNum = ATTRIBUTE_HOLY;
	DivineAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_select");
}

function OnDarkAttributeBtnClick()
{
	setDefultButton();
	selectNum = ATTRIBUTE_UNHOLY;
	DarkAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_select");
}

function setDefultButton()
{
	if( attr_fire == 1 )
	{
		FireAttributeBtn.EnableWindow();
		FireAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_over");
		FireAttributeTitle.SetTextColor( util.BrightWhite );	
	}
	else
	{
		FireAttributeBtn.DisableWindow();
		FireAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_disable");
		FireAttributeTitle.SetTextColor( util.Gray );
	}

	if( attr_water == 1 )
	{
		WaterAttributeBtn.EnableWindow();
		WaterAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_over");
		WaterAttributeTitle.SetTextColor( util.BrightWhite );
	}
	else
	{
		WaterAttributeBtn.DisableWindow();
		WaterAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_disable");
		WaterAttributeTitle.SetTextColor( util.Gray );
	}

	if( attr_wind == 1 )
	{
		WindAttributeBtn.EnableWindow();
		WindAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_over");
		WindAttributeTitle.SetTextColor( util.BrightWhite );
	}
	else
	{
		WindAttributeBtn.DisableWindow();			
		WindAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_disable");
		WindAttributeTitle.SetTextColor( util.Gray );
	}

	if( attr_earth == 1 )
	{
		EarthAttributeBtn.EnableWindow();
		EarthAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_over");
		EarthAttributeTitle.SetTextColor( util.BrightWhite );
	}
	else
	{
		EarthAttributeBtn.DisableWindow();
		EarthAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_disable");
		EarthAttributeTitle.SetTextColor( util.Gray );
	}

	if( attr_holy == 1 )
	{
		DivineAttributeBtn.EnableWindow();
		DivineAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_over");
		DivineAttributeTitle.SetTextColor( util.BrightWhite );
	}
	else
	{
		DivineAttributeBtn.DisableWindow();
		DivineAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_disable");	
		DivineAttributeTitle.SetTextColor( util.Gray );
	}

	if( attr_unholy == 1 )
	{
		DarkAttributeBtn.EnableWindow();
		DarkAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_over");
		DarkAttributeTitle.SetTextColor( util.BrightWhite );
	}
	else
	{
		DarkAttributeBtn.DisableWindow();
		DarkAttributeBtn.SetTexture( "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_disable");
		DarkAttributeTitle.SetTextColor( util.Gray );
	}	
}

function OnChangeBtnClick()
{
	local string str;

	if( selectNum == -1 )
	{
		class'UICommonAPI'.static.DialogSetID( DIALOGID_NotSelect );
		class'UICommonAPI'.static.DialogShow( DialogModalType_Modalless, DialogType_OK, GetSystemMessage(3667), string(Self) );
	}
	else
	{
		str = MakeFullSystemMsg( GetSystemMessage(3666), infItem.name, GetSystemString(arrSystemString[nItemAttribute]), GetSystemString(arrSystemString[selectNum]) );

		class'UICommonAPI'.static.DialogSetID( DIALOGID_Change );
		class'UICommonAPI'.static.DialogShow( DialogModalType_Modalless, DialogType_OKCancel, str, string(Self) );
	}
}

function OnHideMeWindow()
{
	RequestChangeAttributeCancel();
	Me.HideWindow();
}



// �Ӽ��� �������� ���������� ����	//�ڷᰡ ���Ƽ� ���������� ����ִ´�. 
function SetAttackAttribute(int Attvalue, int type)
{
	if( AttValue >= 375)	// 9��	375 ~ 450
	{
		AttackAttLevel[type] = 9;
		AttackAttMaxValue[type] = 75;
		AttackAttCurrValue[type] = AttValue - 375;
	}
	else if( AttValue >= 325)	// 8��	325 ~ 375
	{
		AttackAttLevel[type] = 8;
		AttackAttMaxValue[type] = 50;
		AttackAttCurrValue[type] = AttValue - 325;
	}
	else if( AttValue >= 300)	// 7��	300 ~ 325
	{
		AttackAttLevel[type] = 7;
		AttackAttMaxValue[type] = 25;
		AttackAttCurrValue[type] = AttValue - 300;
	}
	else if( AttValue >= 225)	// 6��	225 ~ 300
	{
		AttackAttLevel[type] = 6;
		AttackAttMaxValue[type] = 75;
		AttackAttCurrValue[type] = AttValue - 225;
	}
	else if( AttValue >= 175)	// 5��	175 ~ 225
	{
		AttackAttLevel[type] = 5;
		AttackAttMaxValue[type] = 50;
		AttackAttCurrValue[type] = AttValue - 175;
	}
	else if( AttValue >= 150)	// 4��	150 ~ 175
	{
		AttackAttLevel[type] = 4;
		AttackAttMaxValue[type] = 25;
		AttackAttCurrValue[type] = AttValue - 150;
	}
	else if( AttValue >= 75)	// 3��	75 ~ 150
	{
		AttackAttLevel[type] = 3;
		AttackAttMaxValue[type] = 75;
		AttackAttCurrValue[type] = AttValue - 75;
	}
	else if( AttValue >= 25)	// 2��	25~ 75
	{
		AttackAttLevel[type] = 2;
		AttackAttMaxValue[type] = 50;
		AttackAttCurrValue[type] = AttValue - 25;
	}
	else	// else 0~ 25
	{
		AttackAttLevel[type] = 1;
		AttackAttMaxValue[type] = 25;
		AttackAttCurrValue[type] = AttValue;
	}	
}

/** ���� ���� Tree�� �ֱ� */
function setAttributeIteminfo()
{
	//��þƮ��.
	local EnchantValidateUIData EnchantData;
	local string treeName;
	local string tempStr;

	treeName = "ItemAttributeChangeWnd.AttributeIteminfo";

	class'UIDATA_ITEM'.static.GetEnchantValidateValue(infItem.Id.ClassID, infItem.Enchanted, EnchantData);

	//��ų ����	
	util.TreeClear( treeName );

	//Root ��� ����.
	util.TreeInsertRootNode( treeName, "root", "" );

	//Physical Damage
	//���ݷ� :10
	// End:0x140
	if(EnchantData.PropertyValue[2] != 0)
	{
		tempStr = string(infItem.pAttack + EnchantData.EnchantValue[2] + EnchantData.PropertyValue[2]);
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(94) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, true );
	}
	else
	{
		//���ݷ�[���� ������]
		tempStr = string(infItem.pAttack + EnchantData.EnchantValue[2]);
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(94) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}

	//Masical Damage
	//���� ���ݷ� : 10
	// End:0x27B
	if(EnchantData.PropertyValue[3] != 0)
	{	
		tempStr = string(infItem.mAttack + EnchantData.EnchantValue[3] + EnchantData.PropertyValue[3]);
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(98) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}
	else
	{
		//������[���� ������]
		tempStr = string(infItem.mAttack + EnchantData.EnchantValue[3]);
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(98) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}

	//Attack Speed
	tempStr = GetAttackSpeedString(infItem.pAttackSpeed);
	util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(111) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
	util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	
	//����[�������]
	if( infItem.pDefense > 0 )
	{
		tempStr = string( infItem.pDefense );
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(54) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}

	//�������[�������] ?????
	if( infItem.mDefense > 0 )
	{
		tempStr = string( infItem.mDefense );
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(99) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}

	//����
	if(infItem.pHitRate + EnchantData.PropertyValue[7] != 0)
	{
		tempStr = string(infItem.pHitRate + EnchantData.PropertyValue[7]);
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(96) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}

	//ũ��Ƽ��
	if(infItem.pCriRate + EnchantData.PropertyValue[9] > 0)
	{
		tempStr = string(infItem.pCriRate + EnchantData.PropertyValue[9]);
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(113) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}

	//�̵��ӵ�
	if(infItem.MoveSpeed + EnchantData.PropertyValue[11] != 0)
	{
		tempStr = string(infItem.MoveSpeed + EnchantData.PropertyValue[11]);
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(432) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}

	//����
	if( infItem.ShieldDefense > 0 )
	{
		tempStr = string( infItem.ShieldDefense );
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(95) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}

	//����
	if( infItem.ShieldDefenseRate > 0 )
	{
		tempStr = string( infItem.ShieldDefenseRate );
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(317) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}

	//����ȸ��
	if(infItem.pAvoid + EnchantData.PropertyValue[14] > 0)
	{
		tempStr = string(infItem.pAvoid + EnchantData.PropertyValue[14]);
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(2361) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}

	//����ȸ��
	if(infItem.mAvoid + EnchantData.PropertyValue[15] > 0)
	{
		tempStr = string(infItem.mAvoid + EnchantData.PropertyValue[15]);
		util.TreeInsertTextNodeItem( treeName, "root", GetSystemString(2364) $ " : ", 0, 0, util.ETreeItemTextType.COLOR_GRAY, true, true );
		util.TreeInsertTextNodeItem( treeName, "root", tempStr, 0, 0, util.ETreeItemTextType.COLOR_GOLD, false );
	}

	util.TreeInsertTextNodeItem( "ItemAttributeChangeWnd.AttributeIteminfo", "root", infItem.Description, 0,0, util.ETreeItemTextType.COLOR_DESC, false, true );
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);		
	OnHideMeWindow();
}

defaultproperties
{
}
