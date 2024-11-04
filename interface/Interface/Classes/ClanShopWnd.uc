class ClanShopWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle EditBtnImg_texture;
var ButtonHandle ClanShopEdit_Button;
var WindowHandle ClanShopListWnd;
var CheckBoxHandle LockVeiw_checkBox;
var TextureHandle ClanShopListListDeco_texture;
var ListCtrlHandle ClanShop_ListCtrl;
var TextureHandle ClanShopListWndBG_Texture;
var TextureHandle ClanShopListBG_Texture;
var WindowHandle ClanShopItemInfoWnd;
var TextBoxHandle ItemInfo_Text;
var TextBoxHandle NeedItem_Text;
var TextBoxHandle ExchangeNum_Text;
var TextBoxHandle ClanItemName_text;
var TextBoxHandle ClanItemDescription_text;
var WindowHandle NeededItem_Wnd;
var TextureHandle NeededItem_SlotBg1_Texture;
var TextureHandle NeededItem_SlotBg2_Texture;
var ItemWindowHandle NeededItem_Item1_ItemWnd;
var ItemWindowHandle NeededItem_Item2_ItemWnd;
var TextBoxHandle NeededItem_Item1Title_text;
var TextBoxHandle NeededItem_Item1Num_text;
var TextBoxHandle NeededItem_Item1MyNum_text;
var TextBoxHandle NeededItem_Item2Title_text;
var TextBoxHandle NeededItem_Item2Num_text;
var TextBoxHandle NeededItem_Item2MyNum_text;
var EditBoxHandle ItemCount_EditBox;
var TextureHandle ItemInfoBg_Texture;
var TextureHandle NeededItemBg_Texture;
var TextureHandle ExchangeItemBg_Texture;
var TextureHandle ExchangeItemBg_Divider1;
var TextureHandle ExchangeItemBg_Divider2;
var ButtonHandle Clear_Button;
var ButtonHandle ExChange_Button;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var WindowHandle DisableWnd;
var WindowHandle DescriptionMsgWnd;
var TextBoxHandle DescriptionMsg_Text;
var ButtonHandle Refresh_Button;
var ButtonHandle Close_Button;
var TextBoxHandle ItemNum_TextBox;

var WindowHandle ClanShopConfirm_ResultWnd;
var WindowHandle ClanShopSuccess_ResultWnd;
var WindowHandle ClanShopFails_ResultWnd;

const DIALOG_ASK_PRICE                         = 10111;		

//����Ʈ �� ����
var int listTotalCount;
//����Ʈ ������ �̺�Ʈ ���
var int endCount;

//������ ���� struct �� sort0, sort1�� ������.
struct ClanItemInfo
{
	var LVDataRecord        record;
	var int			        sort0;
	var int			        sort1;	
};

//����Ʈ ���� �迭
var array<ClanItemInfo> itemListArray;

var L2Util util;

var ItemInfo SelectItemInfo;


//��� ���ſ� Ÿ�̸� ID
const TIMER_CLICK       = 99902;
//��� ���ſ� Ÿ�̸� ������ 3��
const TIMER_DELAYC       = 3000;




function OnRegisterEvent()
{
	RegisterEvent( EV_PledgeItemList );
	RegisterEvent( EV_PledgeItemInfo );
	RegisterEvent( EV_PledgeItemBuy );
	registerEvent( EV_DialogOK );
	registerEvent( EV_DialogCancel );   
}

function OnLoad()
{
	Initialize();
	Load();
	SetClosingOnESC(); 
}

function Initialize()
{
	local ButtonHandle OK_Button;

	OK_Button = GetButtonHandle( "ClanShopWnd.ClanShopConfirm_ResultWnd.OK_Button");
	OK_Button.SetNameText( GetSystemString( 2517 ) );

	Me = GetWindowHandle( "ClanShopWnd" );
	EditBtnImg_texture = GetTextureHandle( "ClanShopWnd.EditBtnImg_texture" );
	ClanShopEdit_Button = GetButtonHandle( "ClanShopWnd.ClanShopEdit_Button" );
	ClanShopListWnd = GetWindowHandle( "ClanShopWnd.ClanShopListWnd" );
	LockVeiw_checkBox = GetCheckBoxHandle( "ClanShopWnd.ClanShopListWnd.LockVeiw_checkBox" );
	ClanShopListListDeco_texture = GetTextureHandle( "ClanShopWnd.ClanShopListWnd.ClanShopListListDeco_texture" );
	ClanShop_ListCtrl = GetListCtrlHandle( "ClanShopWnd.ClanShopListWnd.ClanShop_ListCtrl" );
	ClanShopListWndBG_Texture = GetTextureHandle( "ClanShopWnd.ClanShopListWnd.ClanShopListWndBG_Texture" );
	ClanShopListBG_Texture = GetTextureHandle( "ClanShopWnd.ClanShopListWnd.ClanShopListBG_Texture" );
	ClanShopItemInfoWnd = GetWindowHandle( "ClanShopWnd.ClanShopItemInfoWnd" );
	ItemInfo_Text = GetTextBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.ItemInfo_Text" );
	NeedItem_Text = GetTextBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeedItem_Text" );
	ExchangeNum_Text = GetTextBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.ExchangeNum_Text" );
	ClanItemName_text = GetTextBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.ClanItemName_text" );
	ClanItemDescription_text = GetTextBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.ClanItemDescription_text" );
	NeededItem_Wnd = GetWindowHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd" );
	NeededItem_SlotBg1_Texture = GetTextureHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_SlotBg1_Texture" );
	NeededItem_SlotBg2_Texture = GetTextureHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_SlotBg2_Texture" );
	NeededItem_Item1_ItemWnd = GetItemWindowHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1_ItemWnd" );
	NeededItem_Item2_ItemWnd = GetItemWindowHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2_ItemWnd" );
	NeededItem_Item1Title_text = GetTextBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1Title_text" );
	NeededItem_Item1Num_text = GetTextBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1Num_text" );
	NeededItem_Item1MyNum_text = GetTextBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1MyNum_text" );
	NeededItem_Item2Title_text = GetTextBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2Title_text" );
	NeededItem_Item2Num_text = GetTextBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2Num_text" );
	NeededItem_Item2MyNum_text = GetTextBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2MyNum_text" );
	ItemCount_EditBox = GetEditBoxHandle( "ClanShopWnd.ClanShopItemInfoWnd.ItemCount_EditBox" );
	ItemInfoBg_Texture = GetTextureHandle( "ClanShopWnd.ClanShopItemInfoWnd.ItemInfoBg_Texture" );
	NeededItemBg_Texture = GetTextureHandle( "ClanShopWnd.ClanShopItemInfoWnd.NeededItemBg_Texture" );
	ExchangeItemBg_Texture = GetTextureHandle( "ClanShopWnd.ClanShopItemInfoWnd.ExchangeItemBg_Texture" );
	ExchangeItemBg_Divider1 = GetTextureHandle( "ClanShopWnd.ClanShopItemInfoWnd.ExchangeItemBg_Divider1" );
	ExchangeItemBg_Divider2 = GetTextureHandle( "ClanShopWnd.ClanShopItemInfoWnd.ExchangeItemBg_Divider2" );
	Clear_Button = GetButtonHandle( "ClanShopWnd.ClanShopItemInfoWnd.Clear_Button" );
	ExChange_Button = GetButtonHandle( "ClanShopWnd.ClanShopItemInfoWnd.ExChange_Button" );
	MultiSell_Up_Button = GetButtonHandle( "ClanShopWnd.ClanShopItemInfoWnd.MultiSell_Up_Button" );
	MultiSell_Down_Button = GetButtonHandle( "ClanShopWnd.ClanShopItemInfoWnd.MultiSell_Down_Button" );
	MultiSell_Input_Button = GetButtonHandle( "ClanShopWnd.ClanShopItemInfoWnd.MultiSell_Input_Button" );
	DisableWnd = GetWindowHandle( "ClanShopWnd.DisableWnd" );
	DescriptionMsgWnd = GetWindowHandle( "ClanShopWnd.DescriptionMsgWnd" );
	DescriptionMsg_Text = GetTextBoxHandle( "ClanShopWnd.DescriptionMsgWnd.DescriptionMsg_Text" );
	Refresh_Button = GetButtonHandle( "ClanShopWnd.Refresh_Button" );
	Close_Button = GetButtonHandle( "ClanShopWnd.Close_Button" );

	ClanShopConfirm_ResultWnd = GetWindowHandle( "ClanShopWnd.ClanShopConfirm_ResultWnd" );
	ItemNum_TextBox = GetTextBoxHandle( "ClanShopWnd.ClanShopConfirm_ResultWnd.ItemNum_TextBox" );



	ClanShopSuccess_ResultWnd = GetWindowHandle( "ClanShopWnd.ClanShopSuccess_ResultWnd" );
	ClanShopFails_ResultWnd = GetWindowHandle( "ClanShopWnd.ClanShopFails_ResultWnd" );

	util                       = L2Util(GetScript("L2Util"));
	

	ClanShop_ListCtrl.SetSelectedSelTooltip(FALSE);	
	ClanShop_ListCtrl.SetAppearTooltipAtMouseX(true);
}

function Load()
{
}

function OnShow()
{	
	RequestPledgeItemList();
	ItemCount_EditBox.SetString("1");
}
function OnHide()
{
	ClearAll();
}
function OnEvent(int Event_ID, string param)
{
	local int nResult;
	//Debug( "debuftest OnEvent------>>>>> " @ Event_ID);	
	//���� ������ ����Ʈ ���� ����
	if( Event_ID == EV_PledgeItemList )
	{	
		ClearAll();
		ParseInt( param, "nCount", listTotalCount );			
	}
	//���� ������ ����
	else if (Event_ID == EV_PledgeItemInfo)
	{
		ItemListInfo( param );
	}
	//������ ���� ��� �̺�Ʈ
	else if( Event_ID == EV_PledgeItemBuy )
	{
		//Debug( "debuftest OnEvent " @ Event_ID  @ param);
		ParseInt( param, "nResult", nResult );
		if( nResult == 0 )
		{			
			SetSuccessWnd();				
		}
		else
		{
			SetFailWnd( nResult );
			
		}
	}
	else if( Event_ID == EV_DialogOK )
	{
		HandleDialogOK(true);
	}
	else if( Event_ID == EV_DialogCancel )
	{
		HandleDialogOK(false);
	}
}

function SetSuccessWnd()
{
	local ItemWindowHandle Result_ItemWnd;
	local TextBoxHandle	ItemName_TextBox, Discription_TextBox;

	Result_ItemWnd = GetItemWindowHandle( "ClanShopWnd.ClanShopSuccess_ResultWnd.Result_ItemWnd" );
	ItemName_TextBox = GetTextBoxHandle( "ClanShopWnd.ClanShopSuccess_ResultWnd.ItemName_TextBox" );
	Discription_TextBox = GetTextBoxHandle( "ClanShopWnd.ClanShopSuccess_ResultWnd.Discription_TextBox" );

	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem( SelectItemInfo );
	ItemName_TextBox.SetText( GetItemNameAll ( SelectItemInfo ) );
	Discription_TextBox.SetText( GetSystemMessage( 4570 ) );

	ClanShopSuccess_ResultWnd.ShowWindow();
}

function SetFailWnd( int n )
{
	local TextBoxHandle Discription_TextBox;

	Discription_TextBox = GetTextBoxHandle( "ClanShopWnd.ClanShopFails_ResultWnd.Discription_TextBox" );

	if( n == 2 )
	{
		//�ش� ������ �����ϴ�.
		Discription_TextBox.SetText( GetSystemMessage( 3721 ) );
	}
	else if( n == -2  || n == 3 )
	{
		//���� ����� �����մϴ�.
		Discription_TextBox.SetText( GetSystemMessage( 4692 ) );
	}
	else if(  n == 4 )
	{
		//��� �����մϴ�
		Discription_TextBox.SetText( GetSystemMessage( 1285 ) );
	}
	else	
	//if( n == 1 || n == -1 || n == -3 )
	{
		//�ý��� ������ ������ �� �����ϴ�. ��� �� �ٽ� �õ��� �ּ���.
		Discription_TextBox.SetText( GetSystemMessage( 4559 ) );
	}
	ClanShopFails_ResultWnd.ShowWindow();
}

function ClearAll()
{
	endCount = 0;
	itemListArray.Remove(0, itemListArray.Length);
	ClanShop_ListCtrl.DeleteAllItem();
	ClanShopConfirm_ResultWnd.hideWindow();
	ClanShopSuccess_ResultWnd.hideWindow();
	ClanShopFails_ResultWnd.hideWindow();	
	DisableWnd.hideWindow();
	ItemCount_EditBox.showWindow();
}

/**
 * ���� ������ ����
 * ItemInfo (skip...)
 * int Status  //(0: locked, 1: inactivated, 2: activated)
 * int64 SellPrice // ���� ����(adena)
 * int SellNameValue // ���� ���� ��ġ
 * int ActivatePledgeLevel // Ȱ��ȭ �ʿ� ���� ����
 * int ActivateMasteryID //Ȱ��ȭ �ʿ� Ư��
 * int64 ActivatePrice // Ȱ��ȭ ����(adena)
 * int ActivateNameValue //Ȱ��ȭ ��ġ
 * int RemainActivateTime //Ȱ��ȭ ���� �ð� (��)
 * int RemainResetTime //���� �ʱ�ȭ ���� �ð� (��)
 * int MaxQuantity // �ִ� ����
 */
function ItemListInfo( string param )
{	
	makeRecord( param );
	endCount++;
	if( endCount == listTotalCount )
	{
		ItemListInfoEnd();
	}
}

/**
 *  ���� �̼� ����Ʈ ���� �Ϸ�
 **/
function ItemListInfoEnd()
{
	local int i;
	local int n;

	ClanShop_ListCtrl.DeleteAllItem();

	//���� ���� ����
	itemListArray.Sort( OnSortCompare );

	for( i = 0 ; i < itemListArray.Length ; i++ )
	{
		//"��ü �̼� ����" üũ �� ���� ������
		if( LockVeiw_checkBox.IsChecked() )
		{	
			ClanShop_ListCtrl.InsertRecord( itemListArray[ i ].record );
		}
		//"��ü �̼� ����" ���� �� ��� ���� ���� ���� ����
		else
		{
			if( itemListArray[i].sort0 != 0 )
			{
				ClanShop_ListCtrl.InsertRecord( itemListArray[ i ].record );
			}
		}
	}

	//������ ���õ� ���� �ִٸ� ����
	n = findItemIndex( SelectItemInfo );

	if( n > 0 )
	{
		ClanShop_ListCtrl.SetSelectedIndex( n, true );
	}
	else
	{
		ClanShop_ListCtrl.SetSelectedIndex( 0, true );
	}
	OnClickListCtrlRecord("ClanShop_ListCtrl");
}

//������ �ε��� ã��
function int findItemIndex( ItemInfo info )
{
	local int i, n;

	n = -1;

	for( i = 0 ; i < itemListArray.Length ; i++ )
	{
		if( info.Id.ServerID == itemListArray[ i ].record.nReserved1 )
		{
			n = i;
		}		
	}
	return n;
}

//����Ʈ�� ����� ���ô�..����
function makeRecord( string param )
{
	local LVDataRecord Record;
	local string fullNameString;
	local itemInfo Info;

	local string MaxQuantity;
	local int RemainQuantity;
	local int RemainResetTime;
	local int Status;
	local int RemainActivateTime; 

	ParseString( param, "MaxQuantity", MaxQuantity);
	ParseInt( param, "RemainQuantity", RemainQuantity);
	ParseInt( param, "RemainResetTime", RemainResetTime);
	ParseInt( param, "RemainActivateTime", RemainActivateTime);
	ParseInt( param, "Status", Status);

	ParamToItemInfo( param, info );

	fullNameString = GetItemNameAll ( info );

	// ������ �����ϱ� ���� param���� ���� ���
	//ItemInfoToParam(info, param);
	
	// ���� ����
	Record.szReserved = param;	
	// ������ ���� ���̵�
	Record.nReserved1 = Int64(info.Id.ServerID);
	// ������ �ִ� ��
	Record.nReserved2 = info.ItemNum;
	// ������ ������ index ��
	//Record.nReserved3 = index;

	Record.LVDataList.length = 4;

	Record.LVDataList[0].szData = fullNameString;

	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth=32;
	Record.LVDataList[0].nTextureHeight=32;
	Record.LVDataList[0].nTextureU=32;
	Record.LVDataList[0].nTextureV=32;
	Record.LVDataList[0].szTexture = info.IconName; 
	Record.LVDataList[0].IconPosX=10;
	Record.LVDataList[0].FirstLineOffsetX=6;
	Record.LVDataList[0].HiddenStringForSorting = string( Status );

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

	Record.LVDataList[0].bUseTextColor = true;	

	Record.LVDataList[0].attrIconTexArray.Length=1;
	Record.LVDataList[0].attrIconTexArray[0].X=0;
	Record.LVDataList[0].attrIconTexArray[0].Y=2;
	Record.LVDataList[0].attrIconTexArray[0].Width=14;
	Record.LVDataList[0].attrIconTexArray[0].Height=14;
	Record.LVDataList[0].attrIconTexArray[0].U=0;
	Record.LVDataList[0].attrIconTexArray[0].V=0;
	Record.LVDataList[0].attrIconTexArray[0].UL=14;
	Record.LVDataList[0].attrIconTexArray[0].VL=14;

	//�ð� ������
	Record.LVDataList[0].attrIconTexArray[0].objTex = GetTexture("L2UI_CT1.SkillWnd.SkillWnd_DF_ListIcon_Use");

	if( Status == 0)
	{
		//��ο� ȸ��(������ �̸�)
		Record.LVDataList[0].TextColor = util.DarkGray;		

		//ȸ�� getColor(182, 182, 182, 255 );
		Record.LVDataList[0].attrColor = util.ColorGray;
		//���
		Record.LVDataList[0].attrStat[0] = GetSystemMessage( 4566 );
		Record.LVDataList[0].foreTextureName = "L2UI_CT1.Icon.ItemLock";
	}
	else if( Status == 1)
	{
		//��ο� ȸ��(������ �̸�)
		Record.LVDataList[0].TextColor = util.DarkGray;
		//
		Record.LVDataList[0].attrColor = util.DRed;
		//Ȱ��ȭ �ʿ�
		Record.LVDataList[0].attrStat[0] = GetSystemMessage( 4564 );
	}
	else
	{
		//���� ���(������ �̸�)
		Record.LVDataList[0].TextColor = util.BWhite;
		//Ȱ��ȭ
		Record.LVDataList[0].attrColor = util.DRed;
		if( RemainActivateTime <= 0 )
		{
			Record.LVDataList[0].attrColor = getColor(119, 255, 178, 255 );
			Record.LVDataList[0].attrStat[0] = GetSystemMessage( 4565 );
		}
		else
		{
			Record.LVDataList[0].attrColor = util.Yellow03;
			Record.LVDataList[0].attrStat[0] = getTimeStringBySec( RemainActivateTime );
		}
	}
	
	Record.LVDataList[1].hasIcon = true;
	Record.LVDataList[1].bUseTextColor = true;

	Record.LVDataList[1].TextColor = util.DarkGray;
	Record.LVDataList[1].attrColor = util.DarkGray;

	if( MaxQuantity == "0" )
	{
		if( Status == 2 )
		{
			Record.LVDataList[1].TextColor = getColor(119, 255, 178, 255 );			
			Record.LVDataList[1].attrColor = getColor(211, 211, 211, 255 );
		}

		//"���Ѿ���";
		Record.LVDataList[1].szData = GetSystemMessage( 4565 );
		
		Record.LVDataList[1].attrStat[0] = "-";
	}
	else
	{
		if( Status == 2 )
		{
			Record.LVDataList[1].TextColor = getColor(170, 153, 119, 255 );
			Record.LVDataList[1].attrColor = getColor(211, 211, 211, 255 );
		}
		
		Record.LVDataList[1].szData = string(RemainQuantity) $ "/" $ MaxQuantity;
		
		Record.LVDataList[1].attrStat[0] = getTimeStringBySec2(RemainResetTime);
	}
	
	//������ �ֱ�
	Record.LVDataList[1].attrIconTexArray.Length=1;	

	Record.LVDataList[1].attrIconTexArray[0].X=0;
	Record.LVDataList[1].attrIconTexArray[0].Y=2;
	Record.LVDataList[1].attrIconTexArray[0].Width=14;
	Record.LVDataList[1].attrIconTexArray[0].Height=14;
	Record.LVDataList[1].attrIconTexArray[0].U=0;
	Record.LVDataList[1].attrIconTexArray[0].V=0;
	Record.LVDataList[1].attrIconTexArray[0].UL=14;
	Record.LVDataList[1].attrIconTexArray[0].VL=14;
	Record.LVDataList[1].attrIconTexArray[0].objTex = GetTexture("L2UI_CT1.SkillWnd.SkillWnd_DF_ListIcon_Reuse");	

	//������ ���� �迭�� insert
	itemListArray.Insert( itemListArray.Length, 1 );
	itemListArray[ itemListArray.Length - 1].record = record;
	itemListArray[ itemListArray.Length - 1].sort0 = Status;
}


/**  
 *   ����Ʈ Ŭ��
 **/
function OnClickListCtrlRecord( string ListCtrlID )
{
	local string param;
	local string ActivatePledgeLevel;
	local itemInfo Info;
	
	local int SellNameValue, ActivateNameValue, ActivateMasteryID;	

	local UserInfo infoPlayer;
	local int64 ActivatePrice, SellPrice;

	local int Status;

	GetPlayerInfo(infoPlayer);
		
	param = getParam();
	//Debug(param);
	ParamToItemInfo( param, info );
	SelectItemInfo = info;
	
	ParseInt(param, "SellNameValue", SellNameValue);
	ParseInt(param, "ActivateMasteryID", ActivateMasteryID);
	ParseInt(param, "ActivateNameValue", ActivateNameValue );
	ParseInt64( param, "ActivatePrice", ActivatePrice );
	ParseInt64( param, "SellPrice", SellPrice );
	ParseInt(param, "Status", Status );
	ParseString( param, "ActivatePledgeLevel", ActivatePledgeLevel );

	class'UIAPI_MULTISELLITEMINFO'.static.Clear("ClanShopWnd.multiSellItemInfo");
	if( param != "" )
	{
		class'UIAPI_MULTISELLITEMINFO'.static.SetItemInfo( "ClanShopWnd.multiSellItemInfo", 0, info );
	}
	
	//���� ���� ��ġ
	NeededItem_Item1Num_text.SetText( "x" @ MakeCostString( string(SellNameValue) ) );
	//������ �ִ� ���� ��ġ
	NeededItem_Item1MyNum_text.SetTextColor( util.BLUE01 );
	NeededItem_Item1MyNum_text.SetText( "(" $ MakeCostString( string(infoPlayer.PvPPoint) ) $ ")" );

	//���� �Ƶ���
	NeededItem_Item2Num_text.SetText( "x" @ MakeCostString( string(SellPrice) ) );
	//���� ���� �Ƶ���
	NeededItem_Item2MyNum_text.SetTextColor( util.BLUE01 );
	NeededItem_Item2MyNum_text.SetText( "(" $ MakeCostString( GetAdenaStr() ) $ ")" );	
	
	setEditStateItemCount();
	itemCountTextEditEnable( IsStackableItem( info.ConsumeType ) );	

	updateListData();
}


function updateListData()
{
	local CustomTooltip T;
	local string param;
	local int Status;
	local int SellNameValue;	
	local int64 SellPrice;
	local UserInfo infoPlayer;
	local bool bLine;

	bLine = false;

	GetPlayerInfo(infoPlayer);

	param = getParam();
	ParseInt(param, "SellNameValue", SellNameValue);
	ParseInt64( param, "SellPrice", SellPrice );
	ParseInt(param, "Status", Status );

	util.setCustomTooltip(T);//bluesun Ŀ���͸����� ����	
	util.ToopTipMinWidth(10);

	if( Status == 2 )
	{
		ExChange_Button.EnableWindow();
	}
	else if( Status == 1 )
	{
		util.ToopTipInsertText( GetSystemString(3753), true, false, util.ETooltipTextType.COLOR_YELLOW03 );
		bLine = true;
		ExChange_Button.disableWindow();
		itemCountTextEditEnable( false );
	}
	else if( Status == 0 )
	{
		util.ToopTipInsertText( GetSystemString(3754), true, false, util.ETooltipTextType.COLOR_YELLOW03 );
		bLine = true;
		ExChange_Button.disableWindow();
		itemCountTextEditEnable( false );
	}

	if( SellNameValue * int( ItemCount_EditBox.GetString() ) > infoPlayer.PvPPoint )
	{		
		NeededItem_Item1MyNum_text.SetTextColor( util.DRed );
		if( bLine )
		{
			util.TooltipInsertItemBlank(2);	
			util.TooltipInsertItemLine();
			util.TooltipInsertItemBlank(4);
			bLine = false;
		}
		util.ToopTipInsertText( GetSystemString(3672) $ " ", true, true, util.ETooltipTextType.COLOR_GRAY );
		util.ToopTipInsertText( MakeCostString( String( (SellNameValue * int( ItemCount_EditBox.GetString() ) ) - infoPlayer.PvPPoint ) ) @ GetSystemString(3752), true, false, util.ETooltipTextType.COLOR_RED );
	}
	else
	{
		NeededItem_Item1MyNum_text.SetTextColor( util.BLUE01 );
	}

	if( (SellPrice * int( ItemCount_EditBox.GetString() ) ) > GetAdena() )
	{
		NeededItem_Item2MyNum_text.SetTextColor( util.DRed );
		if( bLine )
		{
			util.TooltipInsertItemBlank(2);	
			util.TooltipInsertItemLine();
			util.TooltipInsertItemBlank(4);
			bLine = false;
		}
		util.ToopTipInsertText( GetSystemString(469) $ " ", true, true, util.ETooltipTextType.COLOR_GRAY );
		util.ToopTipInsertText( MakeCostString( String( ( SellPrice * int( ItemCount_EditBox.GetString() ) ) - GetAdena() ) ) @ GetSystemString(3752), true, false, util.ETooltipTextType.COLOR_RED );
	}
	else
	{
		NeededItem_Item2MyNum_text.SetTextColor( util.BLUE01 );
	}
	ExChange_Button.SetTooltipCustomType(util.getCustomToolTip());
}

// ���� �Է� ������ , Ȱ�� ��Ȱ��
function itemCountTextEditEnable(bool bEnable)
{
	if (bEnable)
	{
		ItemCount_EditBox.EnableWindow();

		MultiSell_Up_Button.EnableWindow();
		MultiSell_Down_Button.EnableWindow();
		MultiSell_Input_Button.EnableWindow();
		Clear_Button.EnableWindow();
	}
	else
	{
		ItemCount_EditBox.DisableWindow();

		MultiSell_Up_Button.DisableWindow();
		MultiSell_Down_Button.DisableWindow();
		MultiSell_Input_Button.DisableWindow();
		Clear_Button.DisableWindow();
	}
}

// ������ 
function setEditStateItemCount()
{
	ItemCount_EditBox.SetString("1");	
}

/** 
 *  üũ �ڽ� Ŭ�� ��
 **/
function OnClickCheckBox( String strID )
{
	switch( strID )
	{
		//"��ü �̼� ����" üũ �ڽ� Ŭ�� ��
		case "LockVeiw_checkBox": 
			ItemListInfoEnd();
			break;
	}
}

function OnClickButton( string Name )
{
	//Debug( "name--->"$ Name );
	switch( Name )
	{
		//Ȱ��ȭ ��ư Ŭ��
		case "ExChange_Button":
			OnExChange_ButtonClick();
			break;
		case "Refresh_Button":
			OnRefresh_ButtonClick();
			break;
		case "Close_Button":
			OnClose_ButtonClick();
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
		//���� ���� ����â ����
		case "ClanShopEdit_Button":
			OnClanShopEdit_ButtonClick();   
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

		case "Clear_Button":
			ItemCount_EditBox.SetString("1");
			updateCost();
			break;
	}
}

//���� ��ư Ŭ��
function OnExChange_ButtonClick()
{
	DisableWnd.ShowWindow();
	DisableWnd.SetFocus();

	ClanShopConfirm_ResultWnd.ShowWindow();
	setResultWnd();
	ItemCount_EditBox.HideWindow();
}

function setResultWnd()
{
	local String param, fullNameString;
	local ItemInfo info;
	local ItemWindowHandle Result_ItemWnd;
	local TextBoxHandle	ItemName_TextBox, FameNum_TextBox, AdenaNum_TextBox, Discription_TextBox, FameTitle_TextBox;
	local int SellNameValue;	
	local int64  SellPrice;

	param = getParam();
	ParamToItemInfo( param, info );
	ParseInt(param, "SellNameValue", SellNameValue );
	ParseInt64( param, "SellPrice", SellPrice );

	fullNameString = GetItemNameAll ( info );

	Result_ItemWnd = GetItemWindowHandle( "ClanShopWnd.ClanShopConfirm_ResultWnd.Result_ItemWnd" );
	ItemName_TextBox = GetTextBoxHandle( "ClanShopWnd.ClanShopConfirm_ResultWnd.ItemName_TextBox" );
	FameNum_TextBox = GetTextBoxHandle( "ClanShopWnd.ClanShopConfirm_ResultWnd.FameNum_TextBox" );
	AdenaNum_TextBox = GetTextBoxHandle( "ClanShopWnd.ClanShopConfirm_ResultWnd.AdenaNum_TextBox" );
	Discription_TextBox = GetTextBoxHandle( "ClanShopWnd.ClanShopConfirm_ResultWnd.Discription_TextBox" );
	FameTitle_TextBox = GetTextBoxHandle( "ClanShopWnd.ClanShopConfirm_ResultWnd.FameTitle_TextBox" );

	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem( info );
	ItemName_TextBox.SetText( fullNameString );
	FameNum_TextBox.SetText( MakeCostString( string( SellNameValue * int( ItemCount_EditBox.GetString() ) ) ) );
	AdenaNum_TextBox.SetText( MakeCostString( string( SellPrice * int( ItemCount_EditBox.GetString() ) ) ) );
	FameTitle_TextBox.SetText( GetSystemString( 3672 ) );
	Discription_TextBox.SetText( GetSystemMessage( 4569 ) );
	ItemNum_TextBox.SetText( "x" $ ItemCount_EditBox.GetString() );
}							 

function OnRefresh_ButtonClick()
{
	RequestPledgeItemList();
	//��� ���ſ� Ÿ�̸� ����
	Me.SetTimer( TIMER_CLICK, TIMER_DELAYC );
	//��ư ��Ȱ��
	Refresh_Button.DisableWindow();
}

/**
 * �ð� Ÿ�̸� && ��� ���� Ÿ�̸� �̺�Ʈ
 ***/
function OnTimer(int TimerID) 
{
	//��ϰ��� ��ư Ȱ��ȭ
	if( TimerID == TIMER_CLICK )
	{
		Refresh_Button.EnableWindow();
		Me.KillTimer( TIMER_CLICK );
	}
}

function OnClose_ButtonClick()
{
	OnReceivedCloseUI();
}

function OnOK_ButtonClick()
{
	local ItemInfo info;
	local LVDataRecord Record;
	local String param;

	ClanShop_ListCtrl.GetSelectedRec( Record );

	param = Record.szReserved;
	ParamToItemInfo( param, info );

	//��������
	//Debug( "��������---->" @ ItemCount_EditBox.GetString() );	
	RequestPledgeItemBuy( info.Id.ClassID, int( ItemCount_EditBox.GetString() ) );
	ClanShopConfirm_ResultWnd.hideWindow();
}

function OnCancel_ButtonClick()
{
	DisableWnd.hideWindow();
	ItemCount_EditBox.showWindow();
	ClanShopConfirm_ResultWnd.hideWindow();	

}
function OnSuccess_ButtonClick()
{
	DisableWnd.hideWindow();
	ClanShopSuccess_ResultWnd.hideWindow();
	ItemCount_EditBox.showWindow();
	RequestPledgeItemList();
}

function OnFail_ButtonClick()
{
	DisableWnd.hideWindow();
	ClanShopFails_ResultWnd.hideWindow();
	ItemCount_EditBox.showWindow();
	RequestPledgeItemList();
}

function OnClanShopEdit_ButtonClick()
{
	//GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
	ShowWindow("ClanShopEditWnd");
	GetWindowHandle("ClanShopEditWnd").SetFocus();
	
}

function OnMultiSell_Up_ButtonClick()
{
	local string numStr;
	local int count;

	numStr = ItemCount_EditBox.GetString();
	count = int(numStr);

	if (checkEnableExchange(count + 1))
	{
		// �߰� ���ɿ��� üũ�ؾ���		
		count++;
		ItemCount_EditBox.SetString(String(count));
		updateCost();
	}
}

function OnMultiSell_Down_ButtonClick()
{
	local string numStr;
	local int count;

	numStr = ItemCount_EditBox.GetString();
	count = int(numStr);

	if (count > 1)
	{
		count--;
		ItemCount_EditBox.SetString(String(count));
		updateCost();
	}	
}

// ��ȯ ������ ���� �ΰ�? 
function bool checkEnableExchange(int tryExchangeCount)
{
	local bool bHasItem;
	/*
	local int i, index;
	local bool bHasItem;

	local ItemInfo rItemInfo, info;

	getCurrentSelectedItemInfo(rItemInfo);

	index = rItemInfo.Reserved;

	// Ư�� �������� ���õ��� �ʾҴ�.
	if (index <= -1) return false;

	bHasItem = true;

	if( index >= 0 && index < m_MultiSellInfoList.Length )
	{
		for( i=0 ; i < m_MultiSellInfoList[index].InputItemInfoList.Length ; i++ )
		{
			info = m_MultiSellInfoList[index].InputItemInfoList[i];
			
			if (info.ItemNum * tryExchangeCount > getHasItemOrPointCount(m_MultiSellInfoList[index].InputItemInfoList[i]))
			{
				bHasItem = false;
			}
		}
	}*/
	bHasItem = true;
	return bHasItem;
}


/** ���� �Ǹ� ���� �Է� ���� */
function OnPriceEditBtnHandler()
{
	local ItemInfo info;
	
	DisableWnd.ShowWindow();
	DisableWnd.SetFocus();
	// Ask price
	DialogSetID( DIALOG_ASK_PRICE );
	
	DialogSetEditBoxMaxLength(6);
	DialogSetCancelD(DIALOG_ASK_PRICE);
	DialogSetReservedItemID( info.ID );				// ServerID
	//DialogSetReservedInt3( int(bAllItem) );		// ��ü�̵��̸� ���� ���� �ܰ踦 �����Ѵ�
	DialogSetEditType("number");
	DialogSetParamInt64( -1 );
	DialogSetDefaultOK();
	// ���Ű����� �Է����ּ���.
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362), string(Self) );
}

//-----------------------------------------------------------------------------------------------------------
// HandleDialogOK
//-----------------------------------------------------------------------------------------------------------
function HandleDialogOK(bool bOK)
{
	local int id;
	local INT64 inputNum;
		
	if( DialogIsMine() )
	{
		DisableWnd.HideWindow();
		
		id = DialogGetID();
		// ok�� �������� 
		if (bOK)
		{
			if (id == DIALOG_ASK_PRICE)
			{
				inputNum = INT64( DialogGetString() );
				// 0�� �Է� ���ϵ���..
				if (inputNum <= 0) inputNum = 1;
				ItemCount_EditBox.SetString(String(inputNum));
				updateCost();
			}
		}
		else
		{
			DisableWnd.HideWindow();
		}
	}
}

//-----------------------------------------------------------------------------------------------------------
// OnKeyUp
//-----------------------------------------------------------------------------------------------------------
function OnKeyUp( WindowHandle a_WindowHandle, EInputKey nKey )
{
    if (ItemCount_EditBox.IsFocused())
	{	
		if (ItemCount_EditBox.GetString() == "0") 
		{
			ItemCount_EditBox.SetString("1");
		}
		updateCost();
	}
}

/**
 * ���õ� List ���� Record ����
 **/
function LVDataRecord getSelectRecord()
{
	local LVDataRecord Record;	
	ClanShop_ListCtrl.GetSelectedRec(Record);
	return Record;
}
/**
 *  ���õ� List ���� Param ����
 **/
function String getParam()
{
	local LVDataRecord Record;
	local string param;
	Record = getSelectRecord();			
	param = Record.szReserved;
	return param;
}

/**
 * ���� ��� ���
 **/
function updateCost()
{
	local string param;
	local int SellNameValue;
	local int64  SellPrice;

	param = getParam();

	ParseInt(param, "SellNameValue", SellNameValue);
	ParseInt64(param, "SellPrice", SellPrice );

	//���� ���� ��ġ
	NeededItem_Item1Num_text.SetText( "x" @ MakeCostString( string(SellNameValue * int( ItemCount_EditBox.GetString() ) ) ) );

	//���� �Ƶ���
	NeededItem_Item2Num_text.SetText( "x" @ MakeCostString( string(SellPrice * int( ItemCount_EditBox.GetString() ) ) ) );

	updateListData();
}

/**
 * ��/�ð�/�� || �ð�/�� || //�� || //1�й̸� ���� �ð� �ٲ���
 **/
function string getTimeStringBySec(int sec)
{
	local int timeTemp, timeTemp0, timeTemp1;
	local string returnStr;

	if( sec < 0 ) sec = 0;

	returnStr = "";
	timeTemp = ((sec / 60) / 60 / 24);
	timeTemp0 = ((sec / 60) / 60);
	timeTemp1 = ((sec / 60));

	if( timeTemp > 0 )
	{
		//��/�ð�/��
		returnStr =  MakeFullSystemMsg(GetSystemMessage(4466), string(timeTemp), string(int( (sec / 60) / 60 % 24 ) ), string(int((sec / 60) % 60)));
	}
	else if( timeTemp0 > 0 )
	{
		//�ð�/��
		returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int((sec / 60) % 60)));
	}
	else if( timeTemp1 > 0 )
	{
		//��
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
	}
	else
	{
		//1�й̸�
		returnStr = MakeFullSystemMsg( GetSystemMessage(4360), string (1) );
	}
	return returnStr;	 
}

function string getTimeStringBySec2(int sec )
{
	local int timeTemp, timeTemp0;
	local string returnStr;

	if( sec < 0 ) sec = 0;

	returnStr = "";

	timeTemp = ((sec / 60) / 60);
	timeTemp0 = ((sec / 60));

	 if( timeTemp > 0 )
	{
		//�ð�/��
		returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp), string(int((sec / 60) % 60)));
	}
	else if( timeTemp0 > 0 )
	{
		//��
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp0));
	}
	else
	{
		//1�й̸�
		returnStr = MakeFullSystemMsg( GetSystemMessage(4360), string (1) );
	}
	return returnStr;	 
}



/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}

delegate int OnSortCompare( ClanItemInfo a, ClanItemInfo b )
{
    if (a.sort0 < b.sort0) // ���� ����. ���ǹ��� < �̸� ��������.
    {
        return -1;  // �ڸ��� �ٲ���Ҷ� -1�� ���� �ϰ� ��.
    }
    else
    {
        return 0;
    }
}

defaultproperties
{
}
