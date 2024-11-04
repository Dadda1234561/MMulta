class HennaListWndLive extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// ���̺�� ���� ����Ʈ
//////////////////////////////////////////////////////////////////////////////
//const FEE_OFFSET_Y_EQUIP = -13;
//const FEE_OFFSET_Y_UNEQUIP = -12;
const FEE_OFFSET_Y_EQUIP = -23;
const FEE_OFFSET_Y_UNEQUIP = -21;

// ���� ����� �������� ����
const HENNA_EQUIP=1;		// ��������
const HENNA_UNEQUIP=2;		// ���������

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle btnHenna;

var RichListCtrlHandle listCtrl;

var int m_iState;
var int m_iRootNameLength;
var bool m_bDrawBg;

var L2Util util;

struct AddHennaStruct
{
	var String  Name ;
	var String  Description;
	var String  IconName ;
	var int     HennaID;
	var int     ClassID;	
	var int64   NumberOfItem ;
	var int64   Fee;
	// EV_HennaListWndAddHennaEquip ��
	var int		NeedCount;
	// EV_HennaListWndAddHennaUnEquip ��
	// ���� �޴� ��
	var int		CancelCount;
};

function OnRegisterEvent()
{
	RegisterEvent( EV_HennaListWndShowHideEquip );
	RegisterEvent( EV_HennaListWndAddHennaEquip );

	RegisterEvent( EV_HennaListWndShowHideUnEquip );
	RegisterEvent( EV_HennaListWndAddHennaUnEquip );

	RegisterEvent( EV_HennaListWndClose ); //branch GD35_0828 2014-5-23 luciper3 - �������� Ư����Ȳ�� ���� ���â�� �ݱ����� -1�� ������ ���â�� �ݴ´�.
}

function OnLoad()
{
	SetClosingOnESC();
	
	m_bDrawBg = true;
	
	Me = GetWindowHandle ( m_WindowName ) ;

	btnHenna = GetButtonHandle( m_WindowName $ ".btnHenna") ;

	listCtrl = GetRichListCtrlHandle( m_WindowName $ ".HennaListLc");
	listCtrl.SetUseHorizontalScrollBar(true);
	// listCtrl.SetColumnMinimumWidth( true ) ;

	util = L2Util ( GetScript ( "L2Util" ));

	listCtrl.SetSelectedSelTooltip(false);	
	listCtrl.SetAppearTooltipAtMouseX(true);

	
}

// Ʈ�� ����
function Clear()
{
	listCtrl.DeleteAllItem();
	btnHenna.DisableWindow();
	//listCtrl.InitListCtrl();
	// class'UIAPI_TREECTRL'.static.Clear("HennaListWnd.HennaListTree");
}

function OnEvent(int Event_ID, string param)
{
	local INT64 iAdena;

	//Debug ( "HennaListWnd" @ Event_ID @ param ) ;

	if ( !getInstanceUIData().getIsClassicServer() ) return;

	switch(Event_ID)
	{
	// 1640
	case EV_HennaListWndShowHideEquip :
		m_iState=HENNA_EQUIP;
		Clear();
		ParseINT64(param, "Adena", iAdena);
		ShowHennaListWnd(iAdena);
		break;
	case EV_HennaListWndAddHennaEquip :
	case EV_HennaListWndAddHennaUnEquip :
		AddHennaListItem ( param ) ;
		// AddHennaListItem(strName, strIconName, strDescription, iFee, iHennaID);
		break;
	case EV_HennaListWndShowHideUnEquip :
		m_iState=HENNA_UNEQUIP;
		Clear();
		ParseINT64(param, "Adena", iAdena);
		ShowHennaListWnd(iAdena);
		break;

	//branch GD35_0828 2014-5-23 luciper3 - �������� Ư����Ȳ�� ���� ���â�� �ݱ����� -1�� ������ ���â�� �ݴ´�.
	case EV_HennaListWndClose :
		OnReceivedCloseUI();
		break;
	//end of branch
	}
}

function OnDBClickListCtrlRecord( string ListCtrlID )
{
	if(ListCtrlID == "HennaListLc")
	{
		 RequestSelectedHennaItemInfo();
	}
}

function OnClickListCtrlRecord( String strID )
{
	local int Idx;
	local RichListCtrlRowData RowData;	
	
	if( strID == "HennaListLc")
	{
		Idx = listCtrl.GetSelectedIndex();

		if (Idx <= -1)
		{
			btnHenna.DisableWindow();
			return;
		}
		
		listCtrl.GetRec( Idx, RowData );
		
		// ���� â�� Ȯ�� �� �� �־�� �ϹǷ�, ����â���� �Ÿ���.
		btnHenna.EnableWindow();
		//if ( RowData.nReserved3 == 1 ) 
		//	btnHenna.EnableWindow();
		//else 
		//	btnHenna.DisableWindow();
		

		// Debug ( "OnClickListCtrlRecord" @ Idx  @ RowData.nReserved3 ) ;
		// Debug("API CALL ---> RequestGoodsInventoryItemDesc(" @ Idx @ ")");

		//selectedProductListIndex = Idx;
	}
}

function OnClickButton( string Name )
{
	switch ( Name ) 
	{
		case "btnHenna": 
			// Debug ( "OnClickButton" @ name ) ;
			RequestSelectedHennaItemInfo ();
		break;
	}
}

function OnShow () 
{
	GetWindowHandle ( "HennaInfoWndLive" ).HideWindow() ;
}

// ���� �� �� ��û
function RequestSelectedHennaItemInfo () 
{
	local int Idx;
	local RichListCtrlRowData RowData;
	
	Idx = listCtrl.GetSelectedIndex();

	if (Idx <= -1) return;
	
	listCtrl.GetRec( Idx, RowData );
	 
	// Debug ( "RequestSelectedHennaItemInfo" @ m_iState );
	if(m_iState==HENNA_EQUIP)
	{	
		HennaInfoWndLive (GetScript("HennaInfoWndLive")).needCount = RowData.nReserved2 ;
		RequestHennaItemInfo( int( RowData.nReserved1 ));
	}
	else if(m_iState==HENNA_UNEQUIP)
		RequestHennaUnequipInfo( int( RowData.nReserved1)) ;
	
}

// ���� ����� ������� �ʱ�ȭ ��Ŵ
function ShowHennaListWnd(INT64 iAdena)
{	
	if(m_iState==HENNA_EQUIP)		// �������� �����ϰ��
	{
		// Ÿ��Ʋ ����
		setWindowTitleByString(GetSystemString(651));
		// Ÿ��Ʋ �Ʒ� ���� ���� - ������
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName $".txtList", GetSystemString(659));
		// ��ư �̸� ���� 
		btnHenna.SetButtonName( 651 ) ;		
	}
	else if(m_iState==HENNA_UNEQUIP)	// ���� ����� ������ ���
	{
		// Ÿ��Ʋ - "���������"
		setWindowTitleByString(GetSystemString(652));
		// Ÿ��Ʋ �Ʒ� ���� ���� - "������"
		class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".txtList", GetSystemString(660));
		// ��ư �̸� ���� 
		btnHenna.SetButtonName( 652 ) ;
	}

	//���� �Ƶ��� 
	class'UIAPI_TEXTBOX'.static.SetText( m_WindowName$".txtAdena", MakeCostString(string(iAdena)));
	class'UIAPI_TEXTBOX'.static.SetTooltipString( m_WindowName$".txtAdena", ConvertNumToText(string(iAdena)));

	
	Me.ShowWindow();
	//ShowWindow("HennaListWnd");
	Me.SetFocus( );
}

function AddHennaStruct ParmaToStruct ( string param )  
{
	local AddHennaStruct hennaData ; 

	ParseString(param, "Name", hennaData.Name);				    // �̸�
	ParseString(param, "Description", hennaData.Description);	// 
	ParseString(param, "IconName", hennaData.IconName);		    // IconName;
	ParseInt(param, "HennaID", hennaData.HennaID);				//
	ParseInt(param, "ClassID", hennaData.ClassID ) ;    		//
	ParseINT64(param, "NumberOfItem", hennaData.NumberOfItem );	// ����
	ParseINT64(param, "Fee", hennaData.Fee);					// ���

	if ( m_iState==HENNA_EQUIP ) 
		ParseInt(param, "NeedCount", hennaData.NeedCount);			// �ʿ� ������ ����

	else if ( m_iState==HENNA_UNEQUIP ) 
		ParseInt(param, "CancelCount", hennaData.CancelCount);		// ȸ�� ������ ����
	return hennaData ;
}

function String GetItemTooltipString ( int classID )  
{
	local string tooltipParam;
	local itemInfo Info;

	info = GetItemInfoByClassID ( classID ) ;
	ItemInfoToParam(info, tooltipParam);

//	Debug ( "GetItemTooltipString:" @ tooltipParam ) ;

	return tooltipParam ; 
}

function AddHennaListItem(string param)
{
	local ItemInfo iInfo;
	local AddHennaStruct hennaData;
	local RichListCtrlRowData RowData;
	local string strAdenaComma;
	local Color itemNumColor;
	local bool canBuy;
	local int gabTextY;

	RowData.cellDataList.Length = 2;

	hennaData = ParmaToStruct(param);	

	canBuy = ( hennaData.NeedCount <= hennaData.NumberOfItem ) ; 

	RowData.szReserved = GetItemTooltipString ( hennaData.ClassID ) ;
	RowData.nReserved1 = hennaData.HennaID;
	RowData.nReserved2 = hennaData.NeedCount;	
	if ( canBuy ) 
	{
		RowData.nReserved3 = 1;
	}
	else 
	{
		RowData.nReserved3 = 0;
	}
	class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(hennaData.ClassID), iInfo);
	// ������ ������
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36,36, 0, 0);	
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, iInfo, 32,32, -34, 2 );	

	// ����� �ΰ� ����
	if(m_iState==HENNA_UNEQUIP)
	{
		gabTextY = 1;
		// ������ �̸� 
		AddEllipsisString(RowData.cellDataList[0].drawitems, hennaData.Name, 236, util.BrightWhite, false, true, 5, -7);
		addRichListCtrlString(RowData.cellDataList[0].drawitems, hennaData.Description, util.BrightWhite, true, 45, gabTextY );
	}
	else
	{
		gabTextY = 5;
		AddEllipsisString(RowData.cellDataList[0].drawitems, hennaData.Name, 236, util.BrightWhite, false, true, 5, 0);
	}
	
	// ������ : 
	addRichListCtrlString( RowData.cellDataList[0].drawitems, GetSystemString ( 637 ) @ ":", GetColor( 163, 163, 163, 255 ) ,true ,45, gabTextY);

	// "���ۺ�(�Ƶ���)"
	strAdenaComma = MakeCostString(string(hennaData.Fee));
	addRichListCtrlString( RowData.cellDataList[0].drawitems, strAdenaComma, GetNumericColor(strAdenaComma),false,5,0);
	addRichListCtrlString( RowData.cellDataList[0].drawitems, GetSystemString(469), util.Yellow ,false,5,0);
	
	/** �ι�° �� ***/ 
	if ( canBuy ) 
		itemNumColor = GetColor( 0, 176, 255, 255 );        // ����		
	else
		itemNumColor = GetColor( 255, 0, 0, 255 );          // ����		

	if(m_iState==HENNA_UNEQUIP)
	{
		// ���� �޴� ��
		addRichListCtrlString( RowData.cellDataList[1].drawitems, GetSystemString(3386), util.White ,false,0,0);
		addRichListCtrlString( RowData.cellDataList[1].drawitems, String( hennaData.CancelCount ), itemNumColor ,true ,0,5) ;
	}
	else 
	{
		// �ʿ� ��
		addRichListCtrlString( RowData.cellDataList[1].drawitems, GetSystemString(2380), util.White ,false,0,0);
		addRichListCtrlString( RowData.cellDataList[1].drawitems, "/"$ hennaData.NeedCount, util.White ,true, 0, 5) ;
		addRichListCtrlString( RowData.cellDataList[1].drawitems, String(hennaData.NumberOfItem), itemNumColor ,false ,0,0) ;
	}
	
	listCtrl.InsertRecord(RowData);
}


/** Į�� �� �����Ѵ�. */
function Color GetColor (int r, int g, int b, int a  )
{
	local Color tColor;
	tColor.R = r;
	tColor.G = g;
	tColor.B = b;	
	tColor.A = a;	

	return tColor;
}


/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
}

defaultproperties
{
     m_WindowName="HennaListWndLive"
}
