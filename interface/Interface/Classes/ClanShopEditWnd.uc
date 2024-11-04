class ClanShopEditWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle EditBtnImg_texture;
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
var WindowHandle LockCancel_Wnd;
var TextBoxHandle clanLVTitle_text;
var TextBoxHandle clanLVNum_text;
var TextBoxHandle clanAttributeTitle_text;
var TextBoxHandle clanAttributeNum_text;
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
var TextureHandle ItemInfoBg_Texture;
var TextureHandle LockCancelBg_Texture;
var TextureHandle NeededItemBg_Texture;
var ButtonHandle ExChange_Button;
var WindowHandle DisableWnd;
var WindowHandle DescriptionMsgWnd;
var TextBoxHandle DescriptionMsg_Text;
var ButtonHandle Refresh_Button;
var ButtonHandle Close_Button;

var WindowHandle ClanShopConfirm_ResultWnd;
var WindowHandle ClanShopSuccess_ResultWnd;
var WindowHandle ClanShopFails_ResultWnd;

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
const TIMER_CLICK       = 99904;
//��� ���ſ� Ÿ�̸� ������ 3��
const TIMER_DELAYC       = 3000;

function OnRegisterEvent()
{
	RegisterEvent( EV_PledgeItemList );
	RegisterEvent( EV_PledgeItemInfo );
	RegisterEvent( EV_PledgeItemActivate );
}

function OnLoad()
{
	Initialize();
	Load();
	SetClosingOnESC(); 
}

function Initialize()
{
	Me = GetWindowHandle( "ClanShopEditWnd" );
	EditBtnImg_texture = GetTextureHandle( "ClanShopEditWnd.EditBtnImg_texture" );
	ClanShopListWnd = GetWindowHandle( "ClanShopEditWnd.ClanShopListWnd" );
	LockVeiw_checkBox = GetCheckBoxHandle( "ClanShopEditWnd.ClanShopListWnd.LockVeiw_checkBox" );
	ClanShopListListDeco_texture = GetTextureHandle( "ClanShopEditWnd.ClanShopListWnd.ClanShopListListDeco_texture" );
	ClanShop_ListCtrl = GetListCtrlHandle( "ClanShopEditWnd.ClanShopListWnd.ClanShop_ListCtrl" );
	ClanShopListWndBG_Texture = GetTextureHandle( "ClanShopEditWnd.ClanShopListWnd.ClanShopListWndBG_Texture" );
	ClanShopListBG_Texture = GetTextureHandle( "ClanShopEditWnd.ClanShopListWnd.ClanShopListBG_Texture" );
	ClanShopItemInfoWnd = GetWindowHandle( "ClanShopEditWnd.ClanShopItemInfoWnd" );
	ItemInfo_Text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.ItemInfo_Text" );
	NeedItem_Text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeedItem_Text" );
	ExchangeNum_Text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.ExchangeNum_Text" );
	ClanItemName_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.ClanItemName_text" );
	ClanItemDescription_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.ClanItemDescription_text" );
	LockCancel_Wnd = GetWindowHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.LockCancel_Wnd" );
	clanLVTitle_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.LockCancel_Wnd.clanLVTitle_text" );
	clanLVNum_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.LockCancel_Wnd.clanLVNum_text" );
	clanAttributeTitle_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.LockCancel_Wnd.clanAttributeTitle_text" );
	clanAttributeNum_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.LockCancel_Wnd.clanAttributeNum_text" );
	NeededItem_Wnd = GetWindowHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd" );
	NeededItem_SlotBg1_Texture = GetTextureHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_SlotBg1_Texture" );
	NeededItem_SlotBg2_Texture = GetTextureHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_SlotBg2_Texture" );
	NeededItem_Item1_ItemWnd = GetItemWindowHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1_ItemWnd" );
	NeededItem_Item2_ItemWnd = GetItemWindowHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2_ItemWnd" );
	NeededItem_Item1Title_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1Title_text" );
	NeededItem_Item1Num_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1Num_text" );
	NeededItem_Item1MyNum_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1MyNum_text" );
	NeededItem_Item2Title_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2Title_text" );
	NeededItem_Item2Num_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2Num_text" );
	NeededItem_Item2MyNum_text = GetTextBoxHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2MyNum_text" );
	ItemInfoBg_Texture = GetTextureHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.ItemInfoBg_Texture" );
	LockCancelBg_Texture = GetTextureHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.LockCancelBg_Texture" );
	NeededItemBg_Texture = GetTextureHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.NeededItemBg_Texture" );
	ExChange_Button = GetButtonHandle( "ClanShopEditWnd.ClanShopItemInfoWnd.ExChange_Button" );
	DisableWnd = GetWindowHandle( "ClanShopEditWnd.DisableWnd" );
	DescriptionMsgWnd = GetWindowHandle( "ClanShopEditWnd.DescriptionMsgWnd" );
	DescriptionMsg_Text = GetTextBoxHandle( "ClanShopEditWnd.DescriptionMsgWnd.DescriptionMsg_Text" );
	Refresh_Button = GetButtonHandle( "ClanShopEditWnd.Refresh_Button" );
	Close_Button = GetButtonHandle( "ClanShopEditWnd.Close_Button" );
	
	ClanShopConfirm_ResultWnd = GetWindowHandle( "ClanShopEditWnd.ClanShopConfirm_ResultWnd" );
	ClanShopSuccess_ResultWnd = GetWindowHandle( "ClanShopEditWnd.ClanShopSuccess_ResultWnd" );
	ClanShopFails_ResultWnd = GetWindowHandle( "ClanShopEditWnd.ClanShopFails_ResultWnd" );

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
}
function OnHide()
{
	ClearAll();
}
function OnEvent(int Event_ID, string param)
{
	//Debug( "debuftest OnEvent " @ Event_ID  @ param);
	local int nResult;
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
	//������ Ȱ��ȭ ��� �̺�Ʈ
	else if( Event_ID == EV_PledgeItemActivate )
	{
		Debug( "debuftest OnEvent " @ Event_ID  @ param);
		ParseInt( param, "nResult", nResult );
		if( nResult == 0 )
		{
			Debug("����!~~~~~~~~~~~~~~~~~~~~~~~!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!");
			SetSuccessWnd();				
		}
		else
		{
			SetFailWnd( nResult );
			ClanShopFails_ResultWnd.ShowWindow();
		}
	}
}

function SetSuccessWnd()
{
	local ItemWindowHandle Result_ItemWnd;
	local TextBoxHandle	ItemName_TextBox, Discription_TextBox;

	Result_ItemWnd = GetItemWindowHandle( "ClanShopEditWnd.ClanShopSuccess_ResultWnd.Result_ItemWnd" );
	ItemName_TextBox = GetTextBoxHandle( "ClanShopEditWnd.ClanShopSuccess_ResultWnd.ItemName_TextBox" );
	Discription_TextBox = GetTextBoxHandle( "ClanShopEditWnd.ClanShopSuccess_ResultWnd.Discription_TextBox" );

	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem( SelectItemInfo );
	ItemName_TextBox.SetText( GetItemNameAll ( SelectItemInfo ) );
	Discription_TextBox.SetText( GetSystemMessage( 4568 ) );

	ClanShopSuccess_ResultWnd.ShowWindow();
}

function SetFailWnd( int n )
{
	local TextBoxHandle Discription_TextBox;
	Discription_TextBox = GetTextBoxHandle( "ClanShopEditWnd.ClanShopFails_ResultWnd.Discription_TextBox" );
	
	if( n == 3 )
	{
		//��ų ���� �߿��� �ش� ����� ����� �� �����ϴ�.
		Discription_TextBox.SetText( GetSystemMessage( 4690 ) );
	}
	else if( n == 4)
	{
		//�ش� ������ �����ϴ�.
		Discription_TextBox.SetText( GetSystemMessage( 3721 ) );
	}
	else if( n == -3 || n == -4 )
	{
		//Ȱ��ȭ ����� �����մϴ�.
		Discription_TextBox.SetText( GetSystemMessage( 4691 ) );
	}
	else
	{
		//1, -1, -2, -5, 2
		//�ý��� ������ ������ �� �����ϴ�. ��� �� �ٽ� �õ��� �ּ���.
		Discription_TextBox.SetText( GetSystemMessage( 4559 ) );
	}
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
	//Debug(param);
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

		Record.LVDataList[0].attrColor = getColor(255, 102, 102, 255 );
		//Ȱ��ȭ �ʿ�
		Record.LVDataList[0].attrStat[0] = GetSystemMessage( 4564 );
	}
	else
	{
		//���� ���(������ �̸�)
		Record.LVDataList[0].TextColor = util.BWhite;
		//Ȱ��ȭ
		Record.LVDataList[0].attrColor = util.DRed;
		if( RemainActivateTime == 0 )
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

/*
function array<itemInfo> pushItemInfoArray( array<itemInfo> itemList, ItemInfo pushList )
{
	//local int i ;
	local int itemListRen;
	itemListRen = itemList.Length;
	itemList.Length = itemListRen + 1;
	
	itemList[ itemListRen ] = pushList;
	
	return itemList;
}*/


/**  
 *   ����Ʈ Ŭ��
 **/
function OnClickListCtrlRecord( string ListCtrlID )
{
	local LVDataRecord Record;
	local string param;
	local string ActivatePledgeLevel;
	local itemInfo Info;
	
	local int SellPrice, SellNameValue, ActivateNameValue, ActivateMasteryID;	

	local UserInfo infoPlayer;
	local int64 iPlayerSP, ActivatePrice;

	local int Status;

	GetPlayerInfo(infoPlayer);

	iPlayerSP = INT64(GetClanNameValue(infoPlayer.nClanID));

	ClanShop_ListCtrl.GetSelectedRec(Record);
		
	param = Record.szReserved;

	debug(param);

	ParamToItemInfo( param, info );
	SelectItemInfo = info;
	
	ParseInt(param, "SellPrice", SellPrice);
	ParseInt(param, "SellNameValue", SellNameValue);
	ParseInt(param, "ActivateMasteryID", ActivateMasteryID);
	ParseInt(param, "ActivateNameValue", ActivateNameValue );
	ParseInt64( param, "ActivatePrice", ActivatePrice );
	ParseInt(param, "Status", Status );
	ParseString( param, "ActivatePledgeLevel", ActivatePledgeLevel );	

	class'UIAPI_MULTISELLITEMINFO'.static.Clear("ClanShopEditWnd.multiSellItemInfo");
	if( param != "" )
	{
		class'UIAPI_MULTISELLITEMINFO'.static.SetItemInfo( "ClanShopEditWnd.multiSellItemInfo", 0, info );
	}

	//Ȱ��ȭ �ʿ� ���� ����
	clanLVNum_text.SetText( ActivatePledgeLevel @ GetSystemString(859) );
	//Ȱ��ȭ �ʿ� Ư��
	if( ActivateMasteryID == 0 )
	{
		//���Ǿ���
		clanAttributeNum_text.SetText( GetSystemString(3744) );
	}
	else
	{
		//??Ưȭ Lv ? �̻�
		clanAttributeNum_text.SetText( GetPledgeMasteryName( ActivateMasteryID ) @ GetSystemString(859) );
	}

	//���� ���� ��ġ
	NeededItem_Item1Num_text.SetText( "x" @ MakeCostString( string(ActivateNameValue) ) );
	//���� �Ƶ���
	NeededItem_Item2Num_text.SetText( "x" @ MakeCostString( string(ActivatePrice) ) );

	if( Status == 1 )
	{
		ExChange_Button.EnableWindow();
	}
	else
	{
		ExChange_Button.disableWindow();
	}

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
	Debug( "name--->"$ Name );
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

			
	}
}

//Ȱ��ȭ ��ư Ŭ��
function OnExChange_ButtonClick()
{
	DisableWnd.ShowWindow();
	DisableWnd.SetFocus();

	ClanShopConfirm_ResultWnd.ShowWindow();
	setResultWnd();
}



function setResultWnd()
{
	local String param, fullNameString;
	local LVDataRecord Record;
	local ItemInfo info;
	local ItemWindowHandle Result_ItemWnd;
	local TextBoxHandle	ItemName_TextBox, FameNum_TextBox, AdenaNum_TextBox, Discription_TextBox;
	local int ActivateNameValue;	
	local int64  ActivatePrice;

	//RequestPledgeItemActivate(int nItemClassId);
	ClanShop_ListCtrl.GetSelectedRec( Record );

	param = Record.szReserved;
	ParamToItemInfo( param, info );
	ParseInt(param, "ActivateNameValue", ActivateNameValue );
	ParseInt64( param, "ActivatePrice", ActivatePrice );

	fullNameString = GetItemNameAll ( info );

	Result_ItemWnd = GetItemWindowHandle( "ClanShopEditWnd.ClanShopConfirm_ResultWnd.Result_ItemWnd" );
	ItemName_TextBox = GetTextBoxHandle( "ClanShopEditWnd.ClanShopConfirm_ResultWnd.ItemName_TextBox" );
	FameNum_TextBox = GetTextBoxHandle( "ClanShopEditWnd.ClanShopConfirm_ResultWnd.FameNum_TextBox" );
	AdenaNum_TextBox = GetTextBoxHandle( "ClanShopEditWnd.ClanShopConfirm_ResultWnd.AdenaNum_TextBox" );
	Discription_TextBox = GetTextBoxHandle( "ClanShopEditWnd.ClanShopConfirm_ResultWnd.Discription_TextBox" );

	Result_ItemWnd.Clear();
	Result_ItemWnd.AddItem( info );
	ItemName_TextBox.SetText( fullNameString );
	FameNum_TextBox.SetText( MakeCostString( string(ActivateNameValue) ) );
	AdenaNum_TextBox.SetText( MakeCostString( string(ActivatePrice) ) );
	Discription_TextBox.SetText( GetSystemMessage( 4567 ) );	
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

	RequestPledgeItemActivate( info.Id.ClassID );
	ClanShopConfirm_ResultWnd.hideWindow();
}

function OnCancel_ButtonClick()
{
	DisableWnd.hideWindow();
	ClanShopConfirm_ResultWnd.hideWindow();	

}
function OnSuccess_ButtonClick()
{
	DisableWnd.hideWindow();
	ClanShopSuccess_ResultWnd.hideWindow();	
	RequestPledgeItemList();
}

function OnFail_ButtonClick()
{
	DisableWnd.hideWindow();
	ClanShopFails_ResultWnd.hideWindow();	
	RequestPledgeItemList();
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
