//------------------------------------------------------------------------------------------------------------------------
//
// ����         : PrivateShopWnd  (���� ����) 
//
// ���� ������  : Flagoftiger, Elsacred
//------------------------------------------------------------------------------------------------------------------------
class PrivateShopWnd extends UICommonAPI;
 
//------------------------------------------------------------------------------------------------------------------------
// const
//------------------------------------------------------------------------------------------------------------------------
const DIALOG_TOP_TO_BOTTOM          = 111;
const DIALOG_BOTTOM_TO_TOP          = 222;
const DIALOG_ASK_PRICE	            = 333;
const DIALOG_CONFIRM_PRICE          = 444;
const DIALOG_EDIT_SHOP_MESSAGE      = 555;		// �޽��� ����
const DIALOG_CONFIRM_PRICE_FINAL    = 666;		// Ȯ�� ��ư �������� ������ Ȯ��
const DIALOG_EDIT_BULK_SHOP_MESSAGE = 888;		// ��ũ�� �޽���. �ϰ��Ǹ� �޽���.


//const DIALOG_OVER_PRICE = 777;				// ���� ������ 20���� ������� ���� �޼���, 
												// Ư���� ���̵� �Ҵ��� �ʿ�� ����δ�. 

//------------------------------------------------------------------------------------------------------------------------
// Variables  
//------------------------------------------------------------------------------------------------------------------------
enum PrivateShopType
{
	PT_None,			// dummy
	PT_Buy,				// �ٸ� ����� ���� �������� ������ ������ ��
	PT_Sell,			// �ٸ� ����� ���� �������� ������ �Ǹ��� ��
	PT_BuyList,			// �ڽ��� ���� ���� ���� ����Ʈ
	PT_SellList,		// �ڽ��� ���� ���� �Ǹ� ����Ʈ
};

var string          m_WindowName;
var PrivateShopType m_type;
var bool			m_bBulk;			 // �ϰ� �������� ��Ÿ��. PT_Buy�� ��쿡�� �ǹ̰� �ִ�.
var int				m_merchantID;
var int				m_buyMaxCount;
var int				m_sellMaxCount;
var int				m_curInventoryCount;	// Added by JoeyPark 2010/09/13
var int				m_maxInventoryCount;	// Added by JoeyPark 2010/09/13
var int             m_numPossibleSlotCount;

var PrivateShopType lastPrivateShopTypeSave;  // ������ ���� Ÿ���� �����Ѵ�.
var bool            lastPrivateShopTypemBulk; // ������ �ϰ��Ǹ� Ÿ���� �����Ѵ�.

// ���λ��� ����Ʈ���� �� â�� �ݴ� ������ edit �� ������ ����
var bool stopSellFlag ;
//------------------------------------------------------------------------------------------------------------------------
// Control Handle
//------------------------------------------------------------------------------------------------------------------------
var ItemWindowHandle	m_hPrivateShopWndTopList;
var ItemWindowHandle	m_hPrivateShopWndBottomList;



//------------------------------------------------------------------------------------------------------------------------
//
// Event Functions.
//
//------------------------------------------------------------------------------------------------------------------------
function OnRegisterEvent()
{
	registerEvent( EV_PrivateShopOpenWindow );
	registerEvent( EV_PrivateShopAddItem );
	registerEvent( EV_SetMaxCount );
	registerEvent( EV_DialogOK );
}

/** Desc : OnLoad */
function OnLoad()
{
	SetClosingOnESC();

	m_hPrivateShopWndTopList=GetItemWindowHandle("PrivateShopWnd.TopList");
	m_hPrivateShopWndBottomList=GetItemWindowHandle("PrivateShopWnd.BottomList");

	m_merchantID = 0;
	m_buyMaxCount = 0;
	m_sellMaxCount = 0;
}

/** Desc : OnSendPacketWhenHiding */
function OnSendPacketWhenHiding()
{
	RequestQuit();
}

function onShow ()
{
	// ������ �����츦 ������ �ݱ� ��� 
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)));
	GetWindowHandle ("PrivateShopWndReport").HideWindow();
}

/** Desc : OnHide */
function OnHide()
{
	local DialogBox DialogBox;
     
	lastPrivateShopTypeSave = m_type;
	lastPrivateShopTypemBulk = m_bBulk;

	DialogBox = DialogBox(GetScript("DialogBox"));
	if (class'UIAPI_WINDOW'.static.IsShowWindow("DialogBox"))
	{
		if ( DialogIsMine() ) 
			DialogBox.HandleCancel();
	}
	Clear();

	if(GetWindowHandle("InventoryViewer").IsShowWindow()) GetWindowHandle("InventoryViewer").HideWindow();
}

function contextMenuQuit()
{	
	//Debug( "contextMenuQuit" );
	if( lastPrivateShopTypeSave == PT_BuyList )
	{
		//Debug("����");
		ExecuteCommandFromAction("buy");		
	}
	else if( lastPrivateShopTypeSave == PT_SellList && !lastPrivateShopTypemBulk)
	{
		//Debug("�Ǹ�");
		ExecuteCommandFromAction("vendor");				

	}
	else if( lastPrivateShopTypeSave == PT_SellList && lastPrivateShopTypemBulk)
	{
		//Debug("�ϰ�");
		ExecuteCommandFromAction("packagevendor");				
	}
}

/** Desc : �̺�Ʈ ó�� */
function OnEvent(int Event_ID,string param)
{
	switch( Event_ID )
	{
		case EV_PrivateShopOpenWindow:
			Clear();
//			Debug ( "onEvent EV_PrivateShopOpenWindow" 	);
			HandleOpenWindow(param);
//			debug("!!1  PrivateShopWnd OnEvent" @ Event_ID @ m_type );
			
			//debug("!!2  PrivateShopWnd OnEvent" @ Event_ID @ m_type);
			break;
		case EV_PrivateShopAddItem:
			HandleAddItem(param);
			break;
		case EV_SetMaxCount:
			HandleSetMaxCount(param);
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		default:
			break;
	}
}

/** Desc : ��ư�� Ŭ�� ������ */
function OnClickButton( string ControlName )
{
	local int index;
	//debug("OnClickButton " $ ControlName );
	if( ControlName == "UpButton" )
	{
		index = m_hPrivateShopWndBottomList.GetSelectedNum();
		MoveItemBottomToTop( index, false );
	}
	else if( ControlName == "DownButton" )
	{
		index = m_hPrivateShopWndTopList.GetSelectedNum();
		MoveItemTopToBottom( index, false );
	}
	else if( ControlName == "OKButton" )
	{
		HandleOKButton( true );
		//getInstanceL2Util().SortItem(m_hPrivateShopWndTopList);
	}
	else if( ControlName == "StopButton" )
	{
		RequestQuit();
		HideWindow("PrivateShopWnd");
	}
	else if( ControlName == "MessageButton" )
	{
		DialogSetDefaultOK();	
		//���� 25�� ����! ���� 25�� �����̾��µ� ������ �����Ͽ� 29�ڷ� �ø�
		DialogSetEditBoxMaxLength(29);	
		
		DialogSetID( DIALOG_EDIT_SHOP_MESSAGE  );

		DialogShow(DialogModalType_Modalless, DialogType_OKCancelInput, GetSystemMessage( 334 ), string(Self) );

		// ���̾�α� â�� �� ���� ��Ʈ���� ���� ��Ų��.
		// �������� edit �ؽ�Ʈ�� ������ ����� ���� ���� ���� ���¿��� ��Ʈ���� �־ ������ ���ܼ� 
		// ���� ��ģ ���̴�.

		if( m_type == PT_SellList && !m_bBulk)
		{ 
			DialogSetString( GetPrivateShopMessage("sell") );
		}
		else if (m_type == PT_SellList && m_bBulk)
		{
			DialogSetString( GetPrivateShopMessage("bulksell") );
			//~ debug ("�ϰ��Ǹ� - �޽��� ����" @ GetPrivateShopMessage("bulksell") );
		}
		else if( m_type == PT_BuyList )
		{
			DialogSetString( GetPrivateShopMessage("buy") );
		}
	}
	else if (ControlName == "SortButton")
	{
		//�ڽ��� ������ ���� 
		getInstanceL2Util().SortItem(m_hPrivateShopWndTopList);
	}
	else if (ControlName == "InventoryViewerCall_Button")
	{
		getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle( getCurrentWindowName(string(Self))), true);
	}
	else if ( ControlName == "history_Btn" ) 
	{
		if ( class'UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWndHistory") ) 
			class'UIAPI_WINDOW'.static.HideWindow("PrivateShopWndHistory");
		else
			class'UIAPI_WINDOW'.static.ShowWindow("PrivateShopWndHistory");

	}
}

/** Desc : ���� ���� ����, ������ ����� �������� "���� Ŭ��"  */
function OnDBClickItem( string ControlName, int index )
{
	local ItemInfo info;

//	Debug( "OnDBClickItem" @ ControlName @ m_type  );
	if(ControlName == "TopList")
	{
		m_hPrivateShopWndTopList.GetSelectedItem(info);

		//Debug ( "OnDBClickItem" @ m_bBulk @ m_type @  m_hPrivateShopWndTopList.GetItemNum() @  m_numPossibleSlotCount);

		// Ÿ���� �ϰ� ���� â
		if (m_type == PT_Buy && m_bBulk == true)
		{
			if (m_hPrivateShopWndTopList.GetItemNum() <= m_numPossibleSlotCount || IsStackableItem( info.ConsumeType )) 
			{
				MoveItemTopToBottom( index, false );
			}
			else
			{
				// �� ������ �򰥸��� �ϴ� �� �̹� m_type == PT_Buy �� ���Դµ� �ʿ� ���� �� ��.
				if (m_type == PT_Sell || m_type == PT_SellList) AddSystemMessage(3676);
				// ���� 
				else 
				{
					//�κ��丮 ���� ����
					AddSystemMessage(3675);
				}
			}
		}
		//Ÿ���� ����, �ڽ��� ����, �Ǹ�, �ϰ��Ǹ�
		else
		{			
			
			//ttp 67463 ���� ���� �߰� StackableItem �� PT_SellList Ÿ���� �ƴ� ��쿡��
			if (m_numPossibleSlotCount > m_hPrivateShopWndBottomList.GetItemNum() || ( IsStackableItem( info.ConsumeType ) && m_type != PT_SellList)) 
			{
				// ���λ���-���� �� ��� alt ��ü �̵��� ������� �ʴ´�.
				if (IsStackableItem( info.ConsumeType ) && m_type != PT_Sell)
				{
					// Debug("���Ÿ���Ʈ true");
					MoveItemTopToBottom( index, class'InputAPI'.static.IsAltPressed() );
				}
				else 
				{
					// Debug("���Ÿ���Ʈ false");
					MoveItemTopToBottom( index, false);
				}
			}		
			else 
			{
				//[ttp 64764, 64748 ����
				if ( m_type == PT_BuyList ) 
				{
					//���� ������ �ʰ��ؿ����ϴ�.
					AddSystemMessage(3676);		
				}

				// ������
				else  if (m_type == PT_Sell || m_type == PT_SellList) 
				{
					AddSystemMessage(3676);				
				}
				// ���� 
				else 
				{	
					AddSystemMessage(3675);
				}
			}
		}		
	}
	else if(ControlName == "BottomList")
	{
		// MoveItemBottomToTop( index, false );		
		MoveItemBottomToTop( index, class'InputAPI'.static.IsAltPressed() );
	}

}

/** Desc : ���� ���� ����, ������ ����� �������� "Ŭ��"  */
function OnClickItem( string ControlName, int index )
{
	local WindowHandle m_dialogWnd;
	
	m_dialogWnd = GetWindowHandle( "DialogBox" );

	if(ControlName == "TopList")
	{
		if( DialogIsMine() && m_dialogWnd.IsShowWindow())
		{
			DialogHide();
			m_dialogWnd.HideWindow();
		}		
	}
}


/** Desc : ���� ���� ����, �������� "���"  */
function OnDropItem( string strID, ItemInfo info, int x, int y)
{
	local int index;

	// debug("OnDropItem strID " $ strID $ ", src=" $ info.DragSrcName);
	
	index = -1;
	if( strID == "TopList" && info.DragSrcName == "BottomList" )
	{
		if( m_type == PT_Buy || m_type == PT_SellList  )
			index = m_hPrivateShopWndBottomList.FindItem( info.ID );        	// Find With ServerID
		else if( m_type == PT_Sell || m_type == PT_BuyList )
			index = m_hPrivateShopWndBottomList.FindItemWithAllProperty(info);	// Find With ClassID

		if( index >= 0 )
			MoveItemBottomToTop( index, info.AllItemCount > 0 );
	}
	else if( strID == "BottomList" && info.DragSrcName == "TopList" )
	{
		if( m_type == PT_Buy || m_type == PT_SellList  )
			index = m_hPrivateShopWndTopList.FindItem(info.ID );	        	//Find With ServerID
		else if( m_type == PT_Sell || m_type == PT_BuyList )
			index = m_hPrivateShopWndTopList.FindItemWithAllProperty( info);	//Find With ClassID

		if( index >= 0 )
		{
			// �ִ� �ֱ� ������ ���� 
			if (m_type == PT_Buy && m_bBulk == true)
			{				 
				//  �������� ������ �̵� �ϵ��� ���� ó�� 
				if (m_hPrivateShopWndTopList.GetItemNum() <= m_numPossibleSlotCount || IsStackableItem( info.ConsumeType ) )  
				{					
					MoveItemTopToBottom( index, info.AllItemCount > 0 );
				}
				else
				{
					// ������
					if (m_type == PT_Sell || m_type == PT_SellList) AddSystemMessage(3676);
					// ���� 
					else 
					{						
						AddSystemMessage(3675);
					}
				}
			}
			else
			{
				if (m_numPossibleSlotCount > m_hPrivateShopWndBottomList.GetItemNum() || ( IsStackableItem( info.ConsumeType ) && m_type != PT_SellList)) 
				{  
					// ���λ���-���� �� ��� alt ��ü �̵��� ������� �ʴ´�.
					if (IsStackableItem( info.ConsumeType ) && m_type != PT_Sell)
					{
						MoveItemTopToBottom( index, class'InputAPI'.static.IsAltPressed() );
					}
					else 
					{
						MoveItemTopToBottom( index, false);
					}
				}
				else 
				{
					//[ttp 64764, 64748 ����
					if ( m_type == PT_BuyList ) 
					{
						//���� ������ �ʰ��Ͽ����ϴ�.
						AddSystemMessage(3676);
					}
					// ������
					else if (m_type == PT_Sell || m_type == PT_SellList) AddSystemMessage(3676);
					// ���� 
					else 
					{						
						AddSystemMessage(3675);
					}
				}
			}
		}
	}
}

//------------------------------------------------------------------------------------------------------------------------
//
// General Functions.
//
//------------------------------------------------------------------------------------------------------------------------

/** Desc : ������ ������ �ʱ�ȭ  */
function Clear()
{
	m_type = PT_None;
	m_merchantID = -1;
	m_bBulk = false;

	m_hPrivateShopWndTopList.Clear();
	m_hPrivateShopWndBottomList.Clear();

	class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.PriceText", "");

	class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.AdenaText", "0");
	class'UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.AdenaText", "");
}

/** Desc : RequestQuit  */
function RequestQuit()
{
	if( m_type == PT_BuyList )
	{
		RequestQuitPrivateShop("buy");
	}
	else if( m_type == PT_SellList && !m_bBulk)
	{
		RequestQuitPrivateShop("sell");
	}
	else if( m_type == PT_SellList && m_bBulk)
	{
		RequestQuitPrivateShop("bulksell");
	}
}

/** Desc : MoveItemTopToBottom  */
function MoveItemTopToBottom( int index, bool bAllItem )
{
	local ItemInfo info, bottomInfo;
	local int		num, i, bottomIndex;

	if( m_hPrivateShopWndTopList.GetItem(index, info) )
	{
		if( m_type == PT_SellList )
		{
			// Ask price
			DialogSetID( DIALOG_ASK_PRICE );
			DialogSetReservedItemID( info.ID );				// ServerID
			DialogSetReservedInt3( int(bAllItem) );			// ��ü�̵��̸� ���� ���� �ܰ踦 �����Ѵ�
			DialogSetEditType("number");
			DialogSetParamInt64( -1 );
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(322), string(Self) );
		}
		else if( m_type == PT_BuyList )
		{
			// Ask price
			DialogSetID( DIALOG_ASK_PRICE );
			// DialogSetReservedItemID( info.ID );				// ClassID delete by elsacred
			// DialogSetReservedInt( info.Enchanted );			// Enchant �� ���� delete by elsacred
			DialogSetReservedItemInfo(info);			    	// info ��ü�� �Ѱ��� edit by elsacre
			DialogSetEditType("number");
			DialogSetParamInt64( -1 );
			DialogSetDefaultOK();	
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(585), string(Self) );
		}
		else if( m_type == PT_Sell || m_type == PT_Buy )
		{
			if( m_type == PT_Sell && info.bDisabled > 0 )			// ������ ���� �����̰� �� ������ ���� �� �׳� ����
				return;

			if( m_type == PT_Buy && m_bBulk )					// ������ �ϰ� ���� �� ���. ��� �������� �̵����Ѿ� �Ѵ�.
			{
				num = m_hPrivateShopWndTopList.GetItemNum();
				for( i=0 ; i<num ; ++i )
				{
					m_hPrivateShopWndTopList.GetItem(i, info); 
					m_hPrivateShopWndBottomList.AddItem(info);
				}
				m_hPrivateShopWndTopList.Clear();
		
				AdjustPrice();
				AdjustCount();
			}
			else
			{
				// ���λ��� , ���Ŵ� ������ ������ ���� ����� ����
				if( !bAllItem && IsStackableItem( info.ConsumeType ) && info.ItemNum > 1)		// ���� �����				
				{
					DialogSetID( DIALOG_TOP_TO_BOTTOM );
					if( m_type == PT_Sell )
					{
						//	DialogSetReservedItemID( info.ID );	// ClassID
						//	DialogSetReservedInt(Info.Enchanted); // Enchant �� ����
						// ItemInfo
						DialogSetReservedItemInfo( info );	
					}
					else if( m_type == PT_Buy )
					{
						// ServerID
						DialogSetReservedItemID( info.ID );	
					}
					
					//���� ���� (������ ���� �Ѵٰ� �� �����ۼ�)
					if( m_type == PT_Sell ) 
					{
						if (info.ItemNum >= info.Reserved64)
						{
							DialogSetParamInt64(info.Reserved64);
						}
						else
						{
							DialogSetParamInt64( info.ItemNum );
						}
					}
					else 
					{
						DialogSetParamInt64( info.ItemNum );
					}
					DialogSetDefaultOK();	
					DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name, "" ), string(Self) );
				}
				else
				{
					if( m_type == PT_Buy )
					{
						// ServerID
						bottomIndex = m_hPrivateShopWndBottomList.FindItem(info.ID );		
					}
					else if( m_type == PT_Sell )
					{
						// ClassID
						bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty( info );		
					}

					// �Ʒ��ʿ� �̹� �ִ� �������̰� ������ �������̶�� ������ �����ش�.
					if( bottomIndex >= 0 && IsStackableItem( info.ConsumeType ) )
					{
						m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );
						bottomInfo.ItemNum += info.ItemNum;
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
					}
					else
					{
						m_hPrivateShopWndBottomList.AddItem( info );
					}

					m_hPrivateShopWndTopList.DeleteItem( index );

					AdjustPrice();
					AdjustCount();
				}
			}

			if( m_type == PT_Buy || m_type == PT_BuyList )
			{
				AdjustWeight();
			}
		}
	}
}

/** Desc : MoveItemBottomToTop  */
function MoveItemBottomToTop( int index, bool bAllItem )
{
	local ItemInfo info, topInfo;
	local int		stringIndex, num, i, topIndex;

//	Debug("m_type" @ m_type);
	if( m_hPrivateShopWndBottomList.GetItem( index, info) )
	{
		// ������ �ϰ� ���� �� ���. ��� �������� �̵����Ѿ� �Ѵ�.
		if( m_type == PT_Buy && m_bBulk )		
		{
			num = m_hPrivateShopWndBottomList.GetItemNum();
			for( i=0 ; i<num ; ++i )
			{
				m_hPrivateShopWndBottomList.GetItem(i, info); 
				m_hPrivateShopWndTopList.AddItem( info );
			}
			m_hPrivateShopWndBottomList.Clear();

			AdjustPrice();
			AdjustCount();
		}
		// ���� ���Ÿ� ���� ����� ��� �ٸ� ó���� �ʿ��� �� �Ͽ�
		else	
		{
			// � �ű���� �����
			if( !bAllItem && IsStackableItem( info.ConsumeType ) && info.ItemNum > 1 )		
			{
				DialogSetID( DIALOG_BOTTOM_TO_TOP );
				if( m_type == PT_Buy || m_type == PT_SellList )
				{
					// ServerID
					DialogSetReservedItemID( info.ID );			
				}
				else if( m_type == PT_Sell || m_type == PT_BuyList )
				{
					// DialogSetReservedItemID( info.ID );			// ClassID
					// DialogSetReservedInt( info.Enchanted );		// Enchant �ѹ�
					DialogSetReservedItemInfo( info );		     	// info
				}

				//DialogSetParamInt64( info.ItemNum );
				
				//DialogSetParamInt64(info.Reserved64)

				switch( m_type )
				{
					case PT_SellList:
						stringIndex = 72;
						
						break;
					case PT_BuyList:
						stringIndex = 571;
						
						break;
					case PT_Sell:
						stringIndex = 72;
						//���� ���� (������ ���� �Ѵٰ� �� �����ۼ�)
						
						break;
					case PT_Buy:
						stringIndex = 72;
						break;
					default:
						break;
				}

				DialogSetParamInt64(info.ItemNum);

				// Debug("info.Reserved64" @ info.Reserved64);

				DialogSetDefaultOK();	
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(stringIndex), info.Name, "" ), string(Self) );
			}
			else
			{
				m_hPrivateShopWndBottomList.DeleteItem( index );

				if( m_type != PT_BuyList )
				{
					if( m_type == PT_Buy || m_type == PT_SellList )
						topindex = m_hPrivateShopWndTopList.FindItem(info.ID );		                // ServerID
					else if( m_type == PT_Sell )
						topindex = m_hPrivateShopWndTopList.FindItemWithAllProperty( info );		// ClassID

					if( topIndex >=0 && IsStackableItem( info.ConsumeType ) )	                	// ������ �������̸� ������ ������Ʈ
					{
						m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
						topInfo.ItemNum += info.ItemNum;
						m_hPrivateShopWndTopList.SetItem( topIndex, topInfo );
					}
					else
					{
						m_hPrivateShopWndTopList.AddItem( info );
					}
				}

//				Debug("info.Reserved64" @ info.Reserved64);

				AdjustPrice();
				AdjustCount();
			}
		}
		// Debug("m_type ==>" $ m_type);
		if( m_type == PT_Buy || m_type == PT_BuyList )
		{
			AdjustWeight();
		}
	}
}

/** Desc : ���̾�α� �����츦 ���� OK ��ư ���� ��� */
function HandleDialogOK()
{
	local int id, bottomIndex, topIndex, i, allItem;
	local ItemInfo bottomInfo, topInfo;
	local ItemID scID;
	local ItemInfo scInfo;
	local INT64 inputNum;

	local int currentItemNum;
	local bool enableAddCurrentItemFlag;

	currentItemNum = 0;

	if( DialogIsMine() )
	{
		id = DialogGetID();
	
		inputNum = INT64( DialogGetString() );
		scID = DialogGetReservedItemID();
		DialogGetReservedItemInfo(scInfo);
		
		// ���̾�α״� ���ʴ�� ���� ����(DIALOG_ASK_PRICE)-> 
		// ������ �⺻ ���ݰ� ���̰� �� ��� ���� Ȯ��(DIALOG_CONFIRM_PRICE)->
		// �������̵�(DIALOG_TOP_TO_BOTTOM)�� ������� ���ȴ�
		
		// PT_SellList�� PT_BuyList�� �⺻������ �����ϴ�.
		if( m_type == PT_SellList )
		{
			// ������� �������� �ű��.
			if( id == DIALOG_TOP_TO_BOTTOM && inputNum > 0 )			         
			{
				// <- ServerID ->
				topIndex = m_hPrivateShopWndTopList.FindItem( scID );        	 
				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
					// <- ServerID ->
					bottomIndex = m_hPrivateShopWndBottomList.FindItem( scID );
					m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );
					
					// �Ʒ��ʿ� �̹� �ִ� �������̰� ������ �������̶�� ������ ����� ������ �����ش�.
					if( bottomIndex >= 0 && IsStackableItem( bottomInfo.ConsumeType ) )			
					{
						bottomInfo.Price = DialogGetReservedInt2();
						bottomInfo.ItemNum += Min64( inputNum, topInfo.ItemNum );
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
					}
					// ���ο� �������� �ִ´�
					else					
					{
						bottomInfo = topInfo;
						bottomInfo.ItemNum = Min64( inputNum, topInfo.ItemNum );
						bottomInfo.Price = DialogGetReservedInt2();
						m_hPrivateShopWndBottomList.AddItem( bottomInfo );
					}

					// ���� �������� ó��
					topInfo.ItemNum -= inputNum;
					if( topInfo.ItemNum <= 0 )
						m_hPrivateShopWndTopList.DeleteItem( topIndex );
					else
						m_hPrivateShopWndTopList.SetItem( topIndex, topInfo );
				}
				AdjustPrice();
				AdjustCount();
			}
			// �Ʒ��� ���� ���� ���� �Ű��ش�.
			else if( id == DIALOG_BOTTOM_TO_TOP && inputNum > 0 )		
			{

				// <- ServerID ->
				bottomIndex = m_hPrivateShopWndBottomList.FindItem( scID );
				if( bottomIndex >= 0 )
				{
					m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );

					// <- ServerID ->
					topIndex = m_hPrivateShopWndTopList.FindItem( scID );

					if( topIndex >=0 && IsStackableItem( bottomInfo.ConsumeType ) )
					{
						m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
						topInfo.ItemNum += Min64( inputNum, bottomInfo.ItemNum );
						m_hPrivateShopWndTopList.SetItem( topIndex, topInfo );
					}
					else
					{
						topInfo = bottomInfo;
						topInfo.ItemNum = Min64( inputNum, bottomInfo.ItemNum );
						m_hPrivateShopWndTopList.AddItem( topInfo );
					}

					bottomInfo.ItemNum -= inputNum;
					if( bottomInfo.ItemNum > 0 )
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
					else 
						m_hPrivateShopWndBottomList.DeleteItem( bottomIndex );
				}
				AdjustPrice();
				AdjustCount();
			}
			else if( ID == DIALOG_CONFIRM_PRICE )
			{
				// <- ServerID ->
				topIndex = m_hPrivateShopWndTopList.FindItem( scID );
				if( topIndex >= 0 )
				{
					allItem = DialogGetReservedInt3();
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );

					// stackable?	1���϶��� ������ ���� �ʽ��ϴ�. -innowind
					if( allItem == 0 && IsStackableItem( topInfo.ConsumeType ) && topInfo.ItemNum != 1)		
					{
						DialogSetID( DIALOG_TOP_TO_BOTTOM );
						//������ �Է����� �ʾҴٸ� 1�� �������ش�. 
						if(topInfo.ItemNum  == 0) topInfo.ItemNum  = 1;	
						DialogSetParamInt64( topInfo.ItemNum );
						DialogSetDefaultOK();	
						DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), topInfo.Name, "" ), string(Self) );
					}
					else
					{
						if( allItem == 0 )
							topInfo.ItemNum = 1;
						topInfo.Price = DialogGetReservedInt2();
						// <- ServerID ->
						bottomIndex = m_hPrivateShopWndBottomList.FindItem( topInfo.ID );
						if( bottomIndex >= 0 && IsStackableItem( topInfo.ConsumeType ) )
						{
							// ��ü!
							m_hPrivateShopWndBottomList.GetItem(  bottomIndex, bottomInfo );		
							topInfo.ItemNum += bottomInfo.ItemNum;
							m_hPrivateShopWndBottomList.SetItem(  bottomIndex, topInfo );
						}
						else
						{
							m_hPrivateShopWndBottomList.AddItem( topInfo );
						}
						m_hPrivateShopWndTopList.DeleteItem( topIndex );

						AdjustPrice();
						AdjustCount();
					}
				}
			}
			else if( id == DIALOG_ASK_PRICE && inputNum > 0 )
			{
				// <- ServerID ->
				topIndex = m_hPrivateShopWndTopList.FindItem( scID );
				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
					
					//debug("DIALOG_ASK_PRICE defaultPrice : " $ topInfo.DefaultPrice $ ", entered price: " $ inputNum );
					// if specified price is unconventional, ask confirm

					//10000�ﰡ ������ ���� �ʰ� ������ �ѷ��ش�.
					if( inputNum >= INT64("1000000000000") )	
					{
						//DialogSetID( DIALOG_OVER_PRICE );
						DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1369), string(Self) );					
					}
					else if( !IsProperPrice( topInfo, inputNum ) )
					{
						//debug("strange price warning");
						DialogSetID( DIALOG_CONFIRM_PRICE );
						// <- ServerID ->
						DialogSetReservedItemID( topInfo.ID );
						// price
						DialogSetReservedInt2( inputNum );				
						DialogSetDefaultOK();	
						DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(569), string(Self) );
					}
					else
					{
						allItem = DialogGetReservedInt3();

						// stackable?
						if( allItem == 0 && IsStackableItem( topInfo.ConsumeType ) )		
						{
							//debug("stackable item");
							DialogSetID( DIALOG_TOP_TO_BOTTOM );
							// <- ServerID ->
							DialogSetReservedItemID( topInfo.ID );
							// price
							DialogSetReservedInt2( inputNum );				
							DialogSetReservedInt3( allItem );
							DialogSetParamInt64( topInfo.ItemNum );
							DialogSetDefaultOK();	
							DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), topInfo.Name, "" ), string(Self) );
						}
						else
						{
							//debug("nonstackable item");
							if( allItem == 0 )
								topInfo.ItemNum = 1;
							topInfo.Price = inputNum;
							bottomIndex = m_hPrivateShopWndBottomList.FindItem( topInfo.ID );	// ServerID
							if( bottomIndex >= 0 && IsStackableItem( topInfo.ConsumeType ) )
							{
								m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );		// ��ü!-_-
								topInfo.ItemNum += bottomInfo.ItemNum;
								m_hPrivateShopWndBottomList.SetItem( bottomIndex, topInfo );
							}
							else
							{
								m_hPrivateShopWndBottomList.AddItem( topInfo );
							}
							m_hPrivateShopWndTopList.DeleteItem( topIndex );

							AdjustPrice();
							AdjustCount();
						}
					}
				}
			}
			else if( id == DIALOG_EDIT_SHOP_MESSAGE )
			{
				if (!m_bBulk)
				{
					SetPrivateShopMessage( "sell", DialogGetString() );
				}
				else
				{					
					//~ debug ("�޽��� ����- �ϰ��Ǹ�");
					SetPrivateShopMessage( "bulksell", DialogGetString() );
				}
			}
		}
		// PT_BuyList
		else if( m_type == PT_BuyList )
		{
			// ������� �������� �ű��.
			if( id == DIALOG_TOP_TO_BOTTOM && inputNum > 0 )					
			{
				
				// ClassID
				topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty( scInfo );	
				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
					// ClassID
					bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty( scInfo );	

					m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );
					// �Ʒ��ʿ� �̹� �ִ� �������̰� ������ �������̶�� ������ ����� ������ �����ش�.
					if( bottomIndex >= 0 && IsStackableItem( bottomInfo.ConsumeType ) )			
					{
						//debug("BuyList StackableItem addnum:" $ inputNum $ ", set price to : " $ DialogGetReservedInt2());
						bottomInfo.Price = DialogGetReservedInt2();
						bottomInfo.ItemNum += inputNum;
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
							
						AdjustPrice();

						// �̰ɷ� ��.
						return;		
					}
					i = m_hPrivateShopWndBottomList.GetItemNum();

					if( bottomIndex >= 0 )					
					{	
						// �ߺ��Ǵ� �������� ��� �����.
						i = m_hPrivateShopWndBottomList.GetItemNum();
						//debug("BuyList Removing Items");
						while( i >= 0 )
						{
							m_hPrivateShopWndBottomList.GetItem( i, bottomInfo );
							if( IsSameClassID(bottomInfo.ID, scID) )
								m_hPrivateShopWndBottomList.DeleteItem( i );
							--i;
						};
					}
					currentItemNum = i;
					enableAddCurrentItemFlag = false;

					// ���� ������ (��: ����ź)
					if( IsStackableItem( topInfo.ConsumeType ) )
					{
						if (currentItemNum + 1 <= m_buyMaxCount)
						{
							//debug("BuyList Add stackable Item");
							bottomInfo = topInfo;
							bottomInfo.ItemNum = inputNum;
							bottomInfo.Price = DialogGetReservedInt2();
							m_hPrivateShopWndBottomList.AddItem( bottomInfo );
							enableAddCurrentItemFlag = true;
						}
					}
					// ���� ������ (��: ��)
					else
					{
						// Debug("currentItemNum : " $ currentItemNum);
						// Debug("inputNum       : " $ inputNum);
						// Debug("m_buyMaxCount  : " $ m_buyMaxCount);

						// currentItemNum �� -1�� ������ ��찡 �ִ�.
						if (currentItemNum < 0)
						{
							currentItemNum = m_hPrivateShopWndBottomList.GetItemNum();
						}
						if ((currentItemNum + inputNum) <= m_buyMaxCount)
						{														
							//debug("BuyList Add non-stackable Item");
							// ���ο� �������� ������ŭ �ִ´�
							// ���� ������ �ִ� ���� �ʰ� �Ѵٸ� ���� ��� ��Ͽ� ���� �ʴ´�.
								bottomInfo = topInfo;
								bottomInfo.ItemNum = 1;
								bottomInfo.Price = DialogGetReservedInt2();
								for( i=0 ; i < inputNum ; ++i )
								{
									if (m_hPrivateShopWndBottomList.GetItemNum() < m_buyMaxCount)
									{

										m_hPrivateShopWndBottomList.AddItem( bottomInfo );
										enableAddCurrentItemFlag = true;
									}
								}
						}
					}

					// ���� �߰� �Ǵ� ������ ������ �ʰ� �Ǿ� �߰� �ȵǴ� ��� �˶� �޼��� ���
					// "�����Ϸ��� ������ ������ �߸��Ǿ����ϴ�."
					if (enableAddCurrentItemFlag == false)
					{
						DialogShow( DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(351), string(Self) );
					}

					// Debug("====> ������ ���� ��� ��Ͽ� �ִ� ������ �� : " $ m_hPrivateShopWndBottomList.GetItemNum());
					// Debug("====> ���� �Է��� �� : " $ inputNum);
					
				}
				// ����. ���ϴ� �������� ���� ���� ǥ�ñ� ����
				AdjustWeight();

				AdjustPrice();
				AdjustCount();
			}
			else if( id == DIALOG_BOTTOM_TO_TOP && inputNum > 0 )		// �Ʒ��� ���� ��������.
			{
				bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty( scInfo );	// ClassID
				if( bottomIndex >= 0 )
				{
					m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );
					bottomInfo.ItemNum -= inputNum;
					if( bottomInfo.ItemNum > 0 )
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
					else 
						m_hPrivateShopWndBottomList.DeleteItem( bottomIndex );
				}
			}
			else if( ID == DIALOG_CONFIRM_PRICE )			// � ������ ������ ���´�.
			{
				topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty( scInfo );	// ClassID
				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );

					DialogSetID( DIALOG_TOP_TO_BOTTOM );
					DialogSetReservedItemID( topInfo.ID );
					DialogSetParamInt64( topInfo.ItemNum );
					DialogSetDefaultOK();	
					DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(570), topInfo.Name, "" ), string(Self) );
				}
				// ����. ���ϴ� �������� ���� ���� ǥ�ñ� ����
				// AdjustWeight();

				AdjustPrice();
				AdjustCount();
			}
			else if( id == DIALOG_ASK_PRICE && inputNum > 0 )
			{
				topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty( scInfo );	// ClassID
				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
					// if specified price is unconventional, ask confirm
					if( inputNum >= INT64("1000000000000") )	//10000���� ������ ���� �ʰ� ������ �ѷ��ش�. 
					{
						//DialogSetID( DIALOG_OVER_PRICE );
						DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1369), string(Self) );					
					}
					else if( !IsProperPrice( topInfo, inputNum ) )
					{
						DialogSetID( DIALOG_CONFIRM_PRICE );
						DialogSetReservedItemID( topInfo.ID );
						DialogSetReservedInt2( inputNum );				// price
						DialogSetDefaultOK();	
						DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(569), string(Self) );
					}
					else
					{
						DialogSetID( DIALOG_TOP_TO_BOTTOM );
						DialogSetReservedItemID( topInfo.ID );
						DialogSetReservedInt2( inputNum );				// price
						DialogSetParamInt64( topInfo.ItemNum );
						DialogSetDefaultOK();	
						DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(570), topInfo.Name, "" ), string(Self) );
					}
				}
			}
			else if( id == DIALOG_EDIT_SHOP_MESSAGE )
			{
				SetPrivateShopMessage( "buy", DialogGetString() );
			}
		}
		// PT_Buy and PT_Buy
		else if( m_type == PT_Buy || m_type == PT_Sell )
		{
			// �� ���̾�αװ� �ҷȴٴ� ���� ������ �������̶�� ���� �ǹ��Ѵ�.(�ƴϾ����� 
			// MoveItemTopToBottom() �Լ����� �̹� ������ �̵��� ó������ ���̴�)
			if( id == DIALOG_TOP_TO_BOTTOM && inputNum > 0 )		
			{
				topIndex = -1;
				if( m_type == PT_Buy )
					topIndex = m_hPrivateShopWndTopList.FindItem( scID );	                              // ServerID
				else if( m_type == PT_Sell )
					topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty( scInfo );                // ClassID

				if( topIndex >= 0 )
				{
					m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
					
					if( m_type == PT_Buy )
						bottomIndex = m_hPrivateShopWndBottomList.FindItem( scID );	                  // ServerID
					else if( m_type == PT_Sell )
						bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty( scInfo );  // ClassID	

					m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );

					//����� �纸�� �Է��� ���� ���ٸ� �˾��� ���� ����. 
					if(m_type == PT_Sell  && topInfo.Reserved64 < inputNum + bottomInfo.itemNum)	
					{
						DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(1036), string(Self) );
					}
					else
					{
						//if( m_type == PT_Buy )
						//	bottomIndex = m_hPrivateShopWndBottomList.FindItem( scID );	                  // ServerID
						//else if( m_type == PT_Sell )
						//	bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty( scInfo );  // ClassID	

						//m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );

						// ������ ������ �ߺ�
						if( bottomIndex >= 0  )			
						{
							// ������ �����ش�
							bottomInfo.ItemNum += Min64( inputNum, topInfo.ItemNum );		
							m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
						}
						// ���ο� �������� �ִ´�
						else					
						{
							bottomInfo = topInfo;
							bottomInfo.ItemNum = Min64( inputNum, topInfo.ItemNum );
							m_hPrivateShopWndBottomList.AddItem( bottomInfo );
						}
	
						// ���� �������� ó��
						topInfo.ItemNum -= inputNum;

						if( topInfo.ItemNum <= 0 )
							m_hPrivateShopWndTopList.DeleteItem( topIndex );
						else
							m_hPrivateShopWndTopList.SetItem( topIndex, topInfo );
					}
				}
				AdjustPrice();
				AdjustCount();
			}
			// �Ʒ��� ���� ���� ���� �Ű��ش�. ���������� �� ���̾�αװ� �ҷȴٴ� ���� ������ ���������� �ǹ�.
			else if( id == DIALOG_BOTTOM_TO_TOP && inputNum > 0 )
			{
				bottomIndex = -1;
				if( m_type == PT_Buy )
					bottomIndex = m_hPrivateShopWndBottomList.FindItem( scID );                  	// ServerID
				else if( m_type == PT_Sell )
					bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty( scInfo );	// ClassID

				if( bottomIndex >= 0 )
				{
					m_hPrivateShopWndBottomList.GetItem( bottomIndex, bottomInfo );

					topIndex = -1;

					// ���ʿ� �������� ����
					if( m_type == PT_Buy )
						topIndex = m_hPrivateShopWndTopList.FindItem( scID );	                    // ServerID
					else if( m_type == PT_Sell )
						topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty( scInfo );	    // ClassID

					if( topIndex >=0 )
					{
						m_hPrivateShopWndTopList.GetItem( topIndex, topInfo );
						topInfo.ItemNum += Min64( inputNum, bottomInfo.ItemNum );
						m_hPrivateShopWndTopList.SetItem( topIndex, topInfo );
					}
					else
					{
						topInfo = bottomInfo;
						topInfo.ItemNum = Min64( inputNum, bottomInfo.ItemNum );
						m_hPrivateShopWndTopList.AddItem( topInfo );
					}

					// �Ʒ����� ������ ������ �ش�.
					bottomInfo.ItemNum -= inputNum;
					if( bottomInfo.ItemNum > 0 )
						m_hPrivateShopWndBottomList.SetItem( bottomIndex, bottomInfo );
					else 
						m_hPrivateShopWndBottomList.DeleteItem( bottomIndex );
				}
				AdjustPrice();
				AdjustCount();
			}
			else if( id == DIALOG_CONFIRM_PRICE_FINAL)
			{
				HandleOKButton( false );
			}

		}

		if( m_type == PT_Buy || m_type == PT_BuyList )
		{
			AdjustWeight(); 			
			AdjustPrice();  //  2009.08.27 �� ������ �������� �Ʒ����� ���� �ø��� �������� ��� ���� ������ ���ϴ� �� ����.
		}
	}
} 

function OnLButtonUp(WindowHandle a_WindowHandle, int nX, int nY)
{
	 if(GetWindowHandle("InventoryViewer").IsShowWindow())
	 {
		GetWindowHandle("InventoryViewer").SetFocus();
		GetWindowHandle(getCurrentWindowName(string(Self))).SetFocus();
		if(GetWindowHandle("DialogBox").IsShowWindow()) GetWindowHandle("DialogBox").SetFocus();
	 }
}

/** Desc : HandleOpenWindow */
function HandleOpenWindow( string param )
{
	local string type;
	local int bulk;
	local string adenaString;
	local UserInfo	user;
	//local WindowHandle m_inventoryWnd;
	local INT64 adena;
	
//	m_inventoryWnd = GetWindowHandle( "InventoryWnd" );	//�κ��丮�� ������ �ڵ��� ���´�.

	Clear();

	ParseString( param, "type", type );
	ParseInt64( param, "adena", adena );
	ParseInt( param, "userID", m_merchantID );
	ParseInt( param, "bulk", bulk );		 	            // �ϰ� �Ǹ�(����)?
	ParseInt( param, "nInventoryItemCount", m_curInventoryCount);	// Added by JoeyPark 2010/09/13
	
	if( bulk > 0 )
	{
		m_bBulk = true;
		GetTextureHandle("PrivateShopWnd.Arrow").SetTexture("L2UI_CT1.PrivateShop_DF_Arrow");
		GetTextureHandle("PrivateShopWnd.BottomListBg").SetTexture("L2UI_CT1.PrivateShop_DF_GroupBox");
		SwithBulkOnlyShop();
	}
	else
	{
		m_bBulk = false;
		GetTextureHandle("PrivateShopWnd.Arrow").SetTexture("L2UI_CT1.ShopWnd_DF_Arrow");
		GetTextureHandle("PrivateShopWnd.BottomListBg").SetTexture("L2UI_CT1.GroupBox.GroupBox_DF");
		ResetBulkOnlyShop();
	}

	class'UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.MessageButton", 2331);	

	switch( type )
	{
	case "buy":
		m_type = PT_Buy;
		if ( !stopSellFlag ) getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle( getCurrentWindowName(string(Self))));
		//class'UIAPI_WINDOW'.static.SetWindowTitle("PrivateShopWnd", 1216);
		break;
	case "sell":
		m_type = PT_Sell;
		if ( !stopSellFlag ) getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle( getCurrentWindowName(string(Self))));
		//class'UIAPI_WINDOW'.static.SetWindowTitle("PrivateShopWnd", 1217);
		break;
	case "buyList":
		m_type = PT_BuyList;
		//class'UIAPI_WINDOW'.static.SetWindowTitle("PrivateShopWnd", 1218);
		break;
	case "sellList":
		m_type = PT_SellList;
		//class'UIAPI_WINDOW'.static.SetWindowTitle("PrivateShopWnd", 131);
		break;
	default:
		break;
	};

	if ( stopSellFlag ) 
	{
		stopSellFlag = false; 
		RequestQuit();
		return;
	}		

	adenaString = MakeCostString( string(adena) );
	class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.AdenaText", adenaString);
	class'UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.AdenaText", ConvertNumToText(string(adena)) );
	

	/*
	if( m_inventoryWnd.IsShowWindow() && m_type == PT_Sell )			//�κ��丮 â�� ���������� �ݾ��ش�. 
	{
		m_inventoryWnd.HideWindow();
	}
	*/

	if (param!="")
	{
		ShowWindow( "PrivateShopWnd" );
		class'UIAPI_WINDOW'.static.SetFocus("PrivateShopWnd");
	}

	// ���� ���â
	if( m_type == PT_BuyList )
	{
		// set tooltip
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.TopList", "Inventory" );
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.BottomList","InventoryStackableUnitPrice" );

		// Set strings
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.TopText", GetSystemString(1) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.BottomText", GetSystemString(502) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.PriceConstText", GetSystemString(142) );
		class'UIAPI_BUTTON'.static.SetButtonName( "PrivateShopWnd.OKButton", 428 );

		ShowWindow( "PrivateShopWnd.BottomCountText" );
		ShowWindow( "PrivateShopWnd.StopButton" );
		Showwindow( "PrivateShopWnd.MessageButton" );
		ShowWindow( "PrivateShopWnd.OKButton" );
		HideWindow( "PrivateShopWnd.CheckBulk" );

		// �����丮 ��ư ���� ����
		ShowWindow( "PrivateShopWnd.history_Btn" );		
		
		// ���� ���� , ���� ����
		class'UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.StopButton", 2328);
		class'UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 2327);
		setWindowTitleByString(GetSystemString(498) $ "(" $ GetSystemString(1434) $ ")");
	}
	// �Ǹ� ���â 
	else if( m_type == PT_SellList )
	{		
		// set tooltip
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.TopList", "Inventory" );
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.BottomList","InventoryStackableUnitPrice" );

		if( bulk > 0 )
			class'UIAPI_CHECKBOX'.static.SetCheck( "PrivateShopWnd.CheckBulk", true );
		else
			class'UIAPI_CHECKBOX'.static.SetCheck( "PrivateShopWnd.CheckBulk", false );

		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.TopText", GetSystemString(1) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.BottomText", GetSystemString(137) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.PriceConstText", GetSystemString(143) );
		class'UIAPI_BUTTON'.static.SetButtonName( "PrivateShopWnd.OKButton", 428 );

		ShowWindow( "PrivateShopWnd.BottomCountText" );
		ShowWindow( "PrivateShopWnd.StopButton" );
		Showwindow( "PrivateShopWnd.MessageButton" );
		ShowWindow( "PrivateShopWnd.OKButton" );
		ShowWindow( "PrivateShopWnd.CheckBulk" );

		// �����丮 ��ư ���� ����
		ShowWindow( "PrivateShopWnd.history_Btn" );		

		// �Ǹ� ����, �Ǹ� ����
		if( bulk > 0 )
		{
			// �ϰ� ���� ����, �ϰ� ���� ����
			class'UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.StopButton", 2330);
			class'UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 2329);
		}
		else 
		{
			class'UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.StopButton", 2326);
			class'UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 2325);
		}
		setWindowTitleByString(GetSystemString(498) $ "(" $ GetSystemString(1157) $ ")");
	}
	// �����ڰ� �����Ǹ� ������ �� ���
	else if( m_type == PT_Buy )
	{
		// set tooltip
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.TopList", "InventoryStackableUnitPrice" );
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.BottomList","InventoryStackableUnitPrice" );

		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.TopText", GetSystemString(137) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.BottomText", GetSystemString(139) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.PriceConstText", GetSystemString(142) );
		class'UIAPI_BUTTON'.static.SetButtonName( "PrivateShopWnd.OKButton", 140 );

		ShowWindow( "PrivateShopWnd.BottomCountText" );	// Changed by JoeyPark 2010/09/13
		HideWindow( "PrivateShopWnd.StopButton" );
		HideWindow( "PrivateShopWnd.MessageButton" );
		ShowWindow( "PrivateShopWnd.OKButton" );
		HideWindow( "PrivateShopWnd.CheckBulk" );

		// �����丮 ��ư ���� ����
		HideWindow( "PrivateShopWnd.history_Btn" );		

		GetUserInfo( m_merchantID, user );
		if( bulk > 0 )
			setWindowTitleByString(GetSystemString(498) $ "(" $ GetSystemString(1198) $ ") - " $ User.Name);
		else
			setWindowTitleByString(GetSystemString(498) $ "(" $ GetSystemString(1157) $ ") - " $ User.Name);		
	}
	// �Ǹ��ڰ� ���α��� ������ �� ���
	else if( m_type == PT_Sell )
	{
		// set tooltip
		// TTS_INVENTORY|TTS_PRIVATE_BUY(2050), TTES_SHOW_PRICE2(8)
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.TopList", "InventoryPrice2PrivateShop" );
		class'UIAPI_WINDOW'.static.SetTooltipType( "PrivateShopWnd.BottomList","InventoryStackableUnitPrice" );

		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.TopText", GetSystemString(503) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.BottomText", GetSystemString(137) );
		class'UIAPI_TEXTBOX'.static.SetText( "PrivateShopWnd.PriceConstText", GetSystemString(143) );
		class'UIAPI_BUTTON'.static.SetButtonName( "PrivateShopWnd.OKButton", 140 );

		ShowWindow( "PrivateShopWnd.BottomCountText" );	// Changed by JoeyPark 2010/09/13
		HideWindow( "PrivateShopWnd.StopButton" );
		HideWindow( "PrivateShopWnd.MessageButton" );
		ShowWindow( "PrivateShopWnd.OKButton" );
		HideWindow( "PrivateShopWnd.CheckBulk" );

		// �����丮 ��ư ���� ����
		HideWindow( "PrivateShopWnd.history_Btn" );		

		GetUserInfo( m_merchantID, user );
		setWindowTitleByString(GetSystemString(498) $ "(" $ GetSystemString(1434) $ ") - " $ User.Name);
	}

	// �ϰ��Ǹ��ΰ�?
	if( m_bBulk )
	{
		SwithBulkOnlyShop();
	}
	// �ϰ��ǸŰ� �ƴѰ��
	else
	{
		ResetBulkOnlyShop();	
	}
}

/** Desc : HandleAddItem */
function HandleAddItem( string param )
{
	local ItemInfo info;
	local string target;
	local int EnchantOption1, EnchantOption2;

	ParseString( param, "target", target );
	
	ParamToItemInfo( param, info );

	ParseInt(param, "refineryOp1", EnchantOption1);	
	ParseInt(param, "refineryOp2", EnchantOption2);

	if( target == "topList" )
	{
		if( m_type == PT_Sell && info.ItemNum == 0 )
			info.bDisabled = 1;
		// End:0xDE
		if(isCollectionItem(info))
		{
			Info.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
		}
		m_hPrivateShopWndTopList.AddItem( info );
	}
	else if( target == "bottomList" )
	{
		// End:0x143
		if(isCollectionItem(info))
		{
			Info.ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
		}
		m_hPrivateShopWndBottomList.AddItem( info );
	}
	AdjustPrice();
	AdjustCount();

	// �����찡 ���� �ɶ� ���԰� ���Ӱ� ����, �� ���Žÿ��� �����ϸ� �ȴ�.
	if( m_type == PT_BuyList || m_type == PT_Buy)
	{
		AdjustWeight();
	}

}

/** Desc : HandleAddItem */
function AdjustPrice()
{
	local string adena;
	local int count;
	//local int addPrice;
	local int64 price;		//�����÷ο�� �������� �����ֱ� ���� �����Ͽ����ϴ�. - innowind
	local int64 addPrice64;		
	local ItemInfo info;

	count = m_hPrivateShopWndBottomList.GetItemNum();
	
	while( count > 0 )
	{		
		// �Ʒ��ʿ� �ִ� ���ǵ��� ������ �� �����ش�.
		m_hPrivateShopWndBottomList.GetItem( count - 1, info );
		//addPrice = info.Price * info.ItemNum;	//���⼭ �����÷ο찡 ���� ����������. ���ϴ� �Լ� ��
		addPrice64 = info.Price * info.ItemNum;
		price = price + addPrice64;	// Int64Add( price ,  Int64Add( price , addPrice64 ));  �ٷ� ��������� �ɰ��� ������ ;;
		//price += info.Price * info.ItemNum;

		--count;
	}

	adena = MakeCostStringInt64( price );
	class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceText", adena);
	class'UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.PriceText", ConvertNumToText( string( price ) ) );
}

// ��Ͽ� ���Ե� �����۵� ��ü������ ���� ����
function int64 getAdjustPrice()
{
	local int count;
	local int64 price;		//�����÷ο�� �������� �����ֱ� ���� �����Ͽ����ϴ�. - innowind
	local int64 addPrice64;		
	local ItemInfo info;

	count = m_hPrivateShopWndBottomList.GetItemNum();
	
	while( count > 0 )
	{		
		// �Ʒ��ʿ� �ִ� ���ǵ��� ������ �� �����ش�.
		m_hPrivateShopWndBottomList.GetItem( count - 1, info );
		//addPrice = info.Price * info.ItemNum;	//���⼭ �����÷ο찡 ���� ����������. ���ϴ� �Լ� ��
		addPrice64 = info.Price * info.ItemNum;
		price = price + addPrice64;	// Int64Add( price ,  Int64Add( price , addPrice64 ));  �ٷ� ��������� �ɰ��� ������ ;;
		//price += info.Price * info.ItemNum;

		--count;
	}

	return price;
}

/** Desc: AdjustCount */
function AdjustCount()
{
	local int num, maxNum;

	if( m_type == PT_SellList )
	{
		maxNum = m_sellMaxCount;
		num = m_hPrivateShopWndBottomList.GetItemNum();
		class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomCountText", "(" $ string(num) $ "/" $ string(maxNum) $ ")");
		// debug("AdjustCount SellList num " $ num $ ", maxCount " $ maxNum );
	}
	else if( m_type == PT_BuyList )
	{
		maxNum = m_buyMaxCount;
		num = m_hPrivateShopWndBottomList.GetItemNum();
		class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomCountText", "(" $ string(num) $ "/" $ string(maxNum) $ ")");
		// debug("AdjustCount BuyList num " $ num $ ", maxCount " $ maxNum );
	}
	// Added by JoeyPark 2010/09/13
	else if( m_type == PT_Buy || m_type == PT_Sell )
	{
		num = m_hPrivateShopWndBottomList.GetItemNum();
		maxNum = m_maxInventoryCount - m_curInventoryCount;		
		class'UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomCountText", "(" $ string(num) $ "/" $ string(maxNum) $ ")");
	}

	m_numPossibleSlotCount = maxNum;
	// End adding
}

/** Desc: �Ʒ� ����Ʈ�� �ִ� ���ǵ��� ���Ը� ��� ���ؼ� InvenWeight �� �����ش� */
function AdjustWeight()
{
	local int count;
	local INT64 weight;
	local ItemInfo info;
	class'UIAPI_INVENWEIGHT'.static.ZeroWeight( "PrivateShopWnd.InvenWeight" );

	count = m_hPrivateShopWndBottomList.GetItemNum();

	weight = 0;

	while( count > 0 )
	{		// �Ʒ��ʿ� �ִ� ���ǵ��� ���Ը� �� �����ش�.

		m_hPrivateShopWndBottomList.GetItem( count - 1, info );
		// Debug("===> info.Weight  " @ info.Weight);
		// Debug("===> info.ItemNum " @ info.ItemNum);

		weight += (info.Weight * info.ItemNum);

		--count;
	}

	class'UIAPI_INVENWEIGHT'.static.AddWeight( "PrivateShopWnd.InvenWeight", weight );
	
	// Debug("======>" $ String(weight));
}

/*
 // ��ȥ �۾����� �߰���.
 
 UI -> Client
 native function SendPrivateShopList(string type, string param)
 "EnsoulOptionNum_%d_%d" : ù ��° %d�� ������ �ε���, �� ��° %d ���� Ÿ��(1�� �Ϲ�, 2�� BM)
 "EnsoulOptionID_%d_%d_%d" : ù ��°, �� ��° %d ���� ����, �� ��° %d�� ���� �ε���(���� ��ȣ 1)
 */
function addParamEnSoul(ItemInfo info, int itemIndex,  out string param)
{
	local int i, n;
	local int cnt;

	// ��ȥ �ý��� ���� (2015-02-09 �߰�)
	for(i=EIST_NORMAL; i<EIST_MAX; i++)
	{
		cnt = info.EnsoulOption[i - EIST_NORMAL].OptionArray.Length;

		ParamAdd(param, "EnsoulOptionNum_" $ itemIndex $ "_" $ String(i), String(cnt));

		for(n=EISI_START; n<EISI_START + cnt; n++)
		{
			ParamAdd(param, "EnsoulOptionID_" $ String(itemIndex) $ "_" $ String(i) $ "_" $ string(n), 
					 String(info.EnsoulOption[i - EIST_NORMAL].OptionArray[n - EISI_START]));
		}
	}
}

/** 
 *  
 *  Desc: HandleOKButton
 *  
 *  bPriceCheck :check abnormal price before sending packet if bPriceCheck is true.
 *  
 **/

function HandleOKButton( bool bPriceCheck )		
{
	local string	param;
	local int		itemCount, itemIndex;
	local ItemInfo	itemInfo;
	local PrivateShopWndReport report;
	
	local Int64 nPriceAdena;
	
	report = PrivateShopWndReport ( GetScript ( "PrivateShopWndReport"));

	//debug("HandleOKButton m_type : " $ m_type );

	itemCount = m_hPrivateShopWndBottomList.GetItemNum();
	// Debug("Ȯ�� ��ư üũ " $ String(m_type));	
	// Debug("itemCount" $ String(itemCount));

	// �ϰ� �Ǹ� 
	if( m_type == PT_SellList )
	{
		// �ǸŸ�� ���� + ���� �Ƶ����� �Ƶ��� �ִ� ���� �ѱ�� ���� ó��
		nPriceAdena = getAdjustPrice();
		//Debug ( getInstanceUIData().getMaxAdena() @ GetAdena() @ nPriceAdena );
		if (getInstanceUIData().getMaxAdena() < GetAdena() + nPriceAdena)
		{			
			AddSystemMessage(4470);
			return;
		}

		// push bulk mode
		if( class'UIAPI_CHECKBOX'.static.IsChecked( "PrivateShopWnd.CheckBulk" ) )
			ParamAdd( param, "bulk", "1" );
		else 
			ParamAdd( param, "bulk", "0" );

		// pack every item in BottomList
		ParamAdd( param, "num", string(itemCount) );
		for( itemIndex=0 ; itemIndex < itemCount; ++itemIndex )
		{
			m_hPrivateShopWndBottomList.GetItem(itemIndex, itemInfo);
			ParamAddItemIDWithIndex(param, itemInfo.ID, itemIndex);
			ParamAdd(param, "Count_" $ itemIndex, string(itemInfo.ItemNum));
			ParamAdd(param, "Price_" $ itemIndex, string(itemInfo.Price));
			ParamAdd(param, "ItemName_" $ string(itemIndex), ItemInfo.Name);
			report.externalAddItem(itemInfo);
		}

		// Send packet
		if ( itemCount > 0 ) report.startOpenPrivateShop ( param ) ;
		SendPrivateShopList("sellList", param);
	}
	else if( m_type == PT_Buy )
	{
		// Debug("üũ: PT_BUY");

		// push merchantID(other user)
		ParamAdd( param, "merchantID", string(m_merchantID) );

		// pack every item in BottomList
		ParamAdd( param, "num", string(itemCount) );
		for( itemIndex=0 ; itemIndex < itemCount; ++itemIndex )
		{
			m_hPrivateShopWndBottomList.GetItem( itemIndex, itemInfo );
			if( bPriceCheck && !IsProperPrice( itemInfo, itemInfo.Price ) )
				break;
			ParamAddItemIDWithIndex( param, itemInfo.ID, itemIndex);
			ParamAdd( param, "Count_" $ itemIndex, string(itemInfo.ItemNum) );
			ParamAdd( param, "Price_" $ itemIndex, string(itemInfo.Price) );
		}

		// there's some problem about price...
		if( bPriceCheck && ( itemIndex < itemCount ) )		
		{
			DialogSetID( DIALOG_CONFIRM_PRICE_FINAL );
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(569), string(Self) );
			return;
		}
		// send packet
		else					
		{
			SendPrivateShopList("buy", param);
		}
	}
	else if( m_type == PT_BuyList )
	{
		// ���� ���� �������� 
		// "���� ������ �κ��丮 �ִ���� ���� ��� ������ ���� ���� �ʰ� "������ ������ �߸��Ǿ����ϴ�" �� ����ϰ� ������.
		// pack every item in BottomList

		ParamAdd( param, "num", string(itemCount) );
		
		for( itemIndex=0 ; itemIndex < itemCount; ++itemIndex )
		{
			m_hPrivateShopWndBottomList.GetItem( itemIndex, itemInfo );
			ParamAddItemIDWithIndex( param, itemInfo.ID, itemIndex);
			ParamAdd( param, "Enchanted_" $ itemIndex, string(itemInfo.Enchanted) );
			ParamAdd( param, "Damaged_" $ itemIndex, string(itemInfo.Damaged) );
			ParamAdd( param, "Count_" $ itemIndex, string(itemInfo.ItemNum) );
			ParamAdd( param, "Price_" $ itemIndex, string(itemInfo.Price) );
			ParamAdd( param, "RefineryOp1_" $ itemIndex, string(itemInfo.RefineryOp1) );
			ParamAdd( param, "RefineryOp2_" $ itemIndex, string(itemInfo.RefineryOp2) );
			ParamAdd( param, "LookChangeItemID_" $ itemIndex, string(itemInfo.LookChangeItemID) );
			
			ParamAdd( param, "AttrAttackType_" $ itemIndex, string(itemInfo.AttackAttributeType) );
			ParamAdd( param, "AttrAttackValue_" $ itemIndex, string(itemInfo.AttackAttributeValue) );
			ParamAdd( param, "AttrDefenseValueFire_" $ itemIndex, string(itemInfo.DefenseAttributeValueFire) );
			ParamAdd( param, "AttrDefenseValueWater_" $ itemIndex, string(itemInfo.DefenseAttributeValueWater) );
			ParamAdd( param, "AttrDefenseValueWind_" $ itemIndex, string(itemInfo.DefenseAttributeValueWind) );
			ParamAdd( param, "AttrDefenseValueEarth_" $ itemIndex, string(itemInfo.DefenseAttributeValueEarth) );
			ParamAdd( param, "AttrDefenseValueHoly_" $ itemIndex, string(itemInfo.DefenseAttributeValueHoly) );
			ParamAdd( param, "AttrDefenseValueUnholy_" $ itemIndex, string(itemInfo.DefenseAttributeValueUnholy) );
			ParamAdd(param, "ItemName_" $ string(itemIndex), ItemInfo.Name);
			addParamEnSoul(itemInfo, itemIndex, param);
			ParamAdd(param, "IsBlessedItem_" $ string(itemIndex), string(boolToNum(ItemInfo.IsBlessedItem)));
			report.externalAddItem( itemInfo );
		}

		// Send packet
		if ( itemCount > 0 ) report.startOpenPrivateShop ( param ) ;
		SendPrivateShopList("buyList", param);
	}
	else if( m_type == PT_Sell )
	{
		// pack every item in BottomList
		ParamAdd( param, "merchantID", string(m_merchantID) );
		ParamAdd( param, "num", string(itemCount) );
		for( itemIndex=0 ; itemIndex < itemCount; ++itemIndex )
		{
			m_hPrivateShopWndBottomList.GetItem( itemIndex, itemInfo );
			if( bPriceCheck && !IsProperPrice( itemInfo, itemInfo.Price ) )
				break;
			ParamAddItemIDWithIndex( param, itemInfo.ID, itemIndex);
			ParamAdd( param, "Enchanted_" $ itemIndex, string(itemInfo.Enchanted) );
			ParamAdd( param, "Damaged_" $ itemIndex, string(itemInfo.Damaged) );
			ParamAdd( param, "Count_" $ itemIndex, string(itemInfo.ItemNum) );
			ParamAdd( param, "Price_" $ itemIndex, string(itemInfo.Price) );
			ParamAdd( param, "RefineryOp1_" $ itemIndex, string(itemInfo.RefineryOp1) );
			ParamAdd( param, "RefineryOp2_" $ itemIndex, string(itemInfo.RefineryOp2) );
			ParamAdd( param, "LookChangeItemID_" $ itemIndex, string(itemInfo.LookChangeItemID) );
			addParamEnSoul(itemInfo, itemIndex, param);
		}

		if( bPriceCheck && ( itemIndex < itemCount ) )		// there's some problem about price...
		{
			DialogSetID( DIALOG_CONFIRM_PRICE_FINAL );
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(569), string(Self) );
			return;
		}
		else					// send packet
		{			
			SendPrivateShopList("sell", param);
		}
	}

	HideWindow("PrivateShopWnd");
	Clear();
}

/** Desc: HandleSetMaxCount */ 
function HandleSetMaxCount( string param )
{
	ParseInt (param, "Inventory", m_maxInventoryCount);	// Added by JoeyPark 2010/09/13
	ParseInt( param, "privateShopSell", m_sellMaxCount );
	ParseInt( param, "privateShopBuy", m_buyMaxCount );
}

/** Desc: IsProperPrice */
function bool IsProperPrice( out ItemInfo info, INT64 price )
{
	if( info.DefaultPrice > 0 && ( price <= info.DefaultPrice / 5 || price >= info.DefaultPrice * 5 )  )
		return false;

	return true;
}

/** Desc: SwithBulkOnlyShop */
function SwithBulkOnlyShop()
{
	//~ local WindowHandle Me;
	//~ local CheckBoxHandle CheckBulk;
	
	//~ debug("BulkSale");
	
	//~ Me = GetHandle("PrivateShopWnd");
	//~ CheckBulk = CheckBoxHandle(GetHandle("CheckBulk"));
	//~ Me.SetWindowTitle(GetSystemString(596) $ "(" $ GetSystemString(1198) $ ")");
	setWindowTitleByString(GetSystemString(596) $ "(" $ GetSystemString(1198) $ ")");
	//~ CheckBulk.HideWindow();
	HideWindow( "PrivateShopWnd.CheckBulk" );
}

/** Desc: ResetBulkOnlyShop */
function ResetBulkOnlyShop()
{
	//~ local CheckBoxHandle CheckBulk;
	
	//~ debug("BulkSale Over");
	//~ CheckBulk = CheckBoxHandle(GetHandle("CheckBulk"));
	//~ CheckBulk.ShowWindow();
	HideWindow("PrivateShopWnd.CheckBulk");
}




/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	RequestQuit();
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="PrivateShopWnd"
}
