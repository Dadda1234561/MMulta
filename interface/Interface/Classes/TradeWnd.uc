class TradeWnd extends UICommonAPI;

const DIALOG_ID_TRADE_REQUEST = 323;
const DIALOG_ID_ITEM_NUMBER = 324;

var string m_WindowName;
var L2Util util;
function OnRegisterEvent()
{
	registerEvent( EV_DialogOK );
	registerEvent( EV_DialogCancel );

	registerEvent( EV_TradeStart );
	registerEvent( EV_TradeAddItem );
	registerEvent( EV_TradeDone );
	registerEvent( EV_TradeOtherOK );
	registerEvent( EV_TradeUpdateInventoryItem );
	registerEvent( EV_TradeRequestStartExchange );
}

function OnLoad()
{	
	SetClosingOnESC();

//	if(CREATE_ON_DEMAND==0)
	OnRegisterEvent();
}

function onShow()
{ 
	// ������ �����츦 ������ �ݱ� ��� 
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)));
}

function OnSendPacketWhenHiding()
{
	RequestTradeDone( false );
}

function OnHide()
{
	Clear();
}

function OnEvent( int eventID, string param )
{
	//debug("eventID " $ eventID $ ", param : " $ param );
	switch( eventID )
	{
		case EV_TradeStart:
			HandleStartTrade(param);
			break;
		case EV_TradeAddItem:
			HandleTradeAddItem(param);
			break;
		case EV_TradeDone:
			HandleTradeDone(param);
			break;
		case EV_TradeOtherOK:
			HandleTradeOtherOK(param);
			break;
		case EV_TradeUpdateInventoryItem:
			HandleTradeUpdateInventoryItem(param);
			break;
		case EV_TradeRequestStartExchange:
			HandleReceiveStartTrade(param);
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_DialogCancel:
			// debug("-- DialogCancel DIALOG_ID_TRADE_REQUEST");
			HandleDialogCancel();
			break;
		default:
			break;
	};
}

function OnClickButton( string ControlName )
{
	//debug("ControlName : " $ ControlName);
	if( ControlName == "OKButton" )
	{
		// ��ȯ ����.
		class'UIAPI_ITEMWINDOW'.static.SetFaded( "TradeWnd.MyList", true );
		RequestTradeDone( true );
		DialogHide();
		//HideWindow( "TradeWnd" );
	}
	else if( ControlName == "CancelButton" )
	{
		RequestTradeDone( false );
		DialogHide();
		//HideWindow( "TradeWnd" );
	}
	else if( ControlName == "MoveButton" )
	{
		HandleMoveButton();
	}
}

function OnDBClickItem( string ControlName, int index )
{
	local ItemInfo info;
	if(ControlName == "InventoryList")	// remove the item from InventoryList and move it to MyList
	{
		if( class'UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList", index, info) )
		{
			if( IsStackableItem( info.ConsumeType ) &&  (info.ItemNum!=1))		// stackable? //1���� �����Է�â�� ����� �ʴ´�.
			{
				DialogSetID( DIALOG_ID_ITEM_NUMBER );
				DialogSetReservedItemID( info.ID );	// ServerID
				DialogSetParamInt64( info.ItemNum );
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name, "" ), string(Self) );
			}
			else
				RequestAddTradeItem( info.ID, 1 );
		}
	}
}

function OnDropItem( string strID, ItemInfo info, int x, int y)
{
	if( strID == "MyList" && info.DragSrcName == "InventoryList" )
	{
		if( IsStackableItem( info.ConsumeType ) )		// stackable?
		{
			if( info.AllItemCount > 0 )				// ��ü�̵�
			{
				RequestAddTradeItem( info.ID, info.AllItemCount );
			}
			else if( info.ItemNum==1)
			{
				RequestAddTradeItem( info.ID, 1);
			}
			else
			{
				DialogSetID( DIALOG_ID_ITEM_NUMBER );
				DialogSetReservedItemID( info.ID );	// ServerID
				DialogSetParamInt64( info.ItemNum );
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name, "" ), string(Self) );
			}
		}
		else
			RequestAddTradeItem( info.ID, 1 );
	}
}

function MoveToMyList( int index, INT64 num )
{
	local ItemInfo info;
	if( class'UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList", index, info) )	// success returns true
	{
		RequestAddTradeItem( info.ID, num );
	}
}

function HandleMoveButton()
{
	local int selected;
	local ItemInfo info;
	selected = class'UIAPI_ITEMWINDOW'.static.GetSelectedNum("TradeWnd.InventoryList");
	if( selected >= 0 )
	{
		class'UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList", selected, info);
		if( info.ItemNum == 1 )		// stackable??
			MoveToMyList(selected, 1);
		else 
		{
			DialogSetID( DIALOG_ID_ITEM_NUMBER );
			DialogSetReservedItemID( info.ID );	// ServerID
			DialogSetParamInt64( info.ItemNum );
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name, "" ), string(Self) );
		}
	}
}

function HandleStartTrade( string param )
{
	local int targetID, targetLevel, isFriend, isPledge, isMentoring, isAlliance, isGM;	
	local UserInfo targetInfo;
	local string clanName, colorString, addStr, levelString;
	local string Name;
	local Rect itemWindowRect;

	//���� ������ �ڵ��� ���´�.
	//if(CREATE_ON_DEMAND==0)
	//{
	//	m_inventoryWnd = GetHandle( "InventoryWnd" );	//�κ��丮
	//	m_warehouseWnd = GetHandle( "WarehouseWnd" );		//����â��, ����â��, ȭ��â��
	//	m_privateShopWnd = GetHandle( "PrivateShopWnd" );	//�����Ǹ�, ���α���
	//	m_shopWnd = GetHandle( "ShopWnd" );				//��������, �Ǹ�
	//	m_multiSellWnd = GetHandle( "MultiSellWnd" );			//��Ƽ��
	//}
	//else
	//{
	//	m_inventoryWnd = GetWindowHandle( "InventoryWnd" );	//�κ��丮
	//	m_warehouseWnd = GetWindowHandle( "WarehouseWnd" );		//����â��, ����â��, ȭ��â��
	//	m_privateShopWnd = GetWindowHandle( "PrivateShopWnd" );	//�����Ǹ�, ���α���
	//	m_shopWnd = GetWindowHandle( "ShopWnd" );				//��������, �Ǹ�
	//	m_multiSellWnd = GetWindowHandle( "MultiSellWnd" );			//��Ƽ��
	//}
	/*
	if( m_inventoryWnd.IsShowWindow() )			//�κ��丮 â�� ���������� �ݾ��ش�. 
	{
		m_inventoryWnd.HideWindow();
	}	
	if( m_warehouseWnd.IsShowWindow() )			//â�� â�� ���������� �ݾ��ش�. 
	{
		m_warehouseWnd.HideWindow();
	}	
	if( m_privateShopWnd.IsShowWindow() )		//���λ��� â�� ���������� �ݾ��ش�. 
	{
		m_privateShopWnd.HideWindow();
	}	
	if( m_shopWnd.IsShowWindow() )				//���� â�� ���������� �ݾ��ش�. 
	{
		m_shopWnd.HideWindow();
	}
	if( m_multiSellWnd.IsShowWindow() )			//��Ƽ�� â�� ���������� �ݾ��ش�. 
	{
		m_multiSellWnd.HideWindow();
	}
	*/
	
	class'UIAPI_WINDOW'.static.ShowWindow("TradeWnd");
	class'UIAPI_WINDOW'.static.SetFocus("TradeWnd");

	ParseInt( param, "targetId",            targetID );
	ParseInt( param, "targetLevel",         targetLevel );
	ParseInt( param, "IsFriend",			isFriend );
	ParseInt( param, "IsPledge",			isPledge );
	ParseInt( param, "IsMentoring",         isMentoring );
	ParseInt( param, "IsAlliance",          isAlliance );
	ParseInt( param, "IsGM",                isGM );
	
	if( targetID > 0 )
	{
		GetUserInfo( targetID, targetInfo );
		if( targetInfo.nClanID > 0 )
		{
			clanName = GetClanName( targetInfo.nClanID );
			if (targetInfo.WantHideName &&  targetInfo.JoinedDominionID >0)
			{
				Name = targetInfo.RealName;
			}
			else
			{
				Name = targetInfo.Name;
			}

			if(clanName != "")
			{
				addStr = " - ";
			}
			else
			{
				addStr = "";
			}

			// debug ("With Clan Name" @ Name);
			class'UIAPI_TEXTBOX'.static.SetText( "TradeWnd.Targetname", Name $ addStr $ clanName );
		}
		else
		{
			if (targetInfo.WantHideName &&  targetInfo.JoinedDominionID >0)
			{
				Name = targetInfo.RealName;
			}
			else
			{
				Name = targetInfo.Name;
			}
			// debug ("Without Clan Name" @ Name);
			class'UIAPI_TEXTBOX'.static.SetText( "TradeWnd.Targetname", Name);		//������ ��� �̸��� ǥ�����ش�.
		}

		itemWindowRect = GetItemWindowHandle("TradeWnd.InventoryList").GetRect();   

		// ���� ������������ ������� "..." �������� �ִ´�. 
		GetTextBoxHandle("TradeWnd.Targetname").SetTextEllipsisWidth(itemWindowRect.nWidth);

		// �������� ������, �������� �������� �Ѵ�. 
		GetTextBoxHandle("TradeWnd.Targetname").SetTooltipType("Text");
		GetTextBoxHandle("TradeWnd.Targetname").SetTooltipText(Name $ addStr $ clanName);

		//�ŷ� ��� ����.
		//Ÿ�� ������ �ִ´�. ģ������ ���Ͱ��� ���
		if(isFriend != 0 || isPledge != 0 || isMentoring != 0 || isAlliance != 0 || isGM != 0)
		{
			//�ڽŰ� ���谡 �ִ� ����̸� �ʷϻ����� ǥ��
			colorString = "Green";
		}
		else
		{
			//���� ������ ������
			colorString = "Red";
		}

		SetTooltipString(param);

		levelString = Left(colorString, 1) $ GetTargetLevelIconIndex( targetLevel );
		
		//������ ��� �ٸ� �������� ǥ���Ѵ� ��浵 �ʷϻ�
		if(isGM != 0)
		{
			levelString = "GM";
			colorString = "Green";
		}

		//���� �ؽ���
		GetTextureHandle( "TradeWnd.ChatLevel" ).SetTexture("L2UI_CT1.ChatWindow.ChatLevelIcon_"$ levelString);
		//��ư �ؽ��� ����
		GetButtonHandle("TradeWnd.ChatLevelIcon_Btn").SetTexture("L2UI_CT1.ChatWindow.ChatLevelIcon_Btn"$colorString, "L2UI_CT1.ChatWindow.ChatLevelIcon_Btn"$colorString$"_down", "L2UI_CT1.ChatWindow.ChatLevelIcon_Btn"$colorString$"_over");
	}
}

function SetTooltipString(string param)
{
	local CustomTooltip T;
	local string charName;
	local int isFriend, isGM, isPledge, isAlliance, isMentoring;
	
	T.MinimumWidth = 125;
	util = L2Util(GetScript("L2Util"));//bluesun Ŀ���͸����� ���� 
	util.setCustomTooltip(T);//bluesun Ŀ���͸����� ����


	ParseString(param, "CharName",      charName);
	ParseInt( param,   "IsFriend",		isFriend );
	ParseInt( param,   "IsPledge",		isPledge );
	ParseInt( param,   "IsMentoring",   isMentoring );
	ParseInt( param,   "IsAlliance",    isAlliance );
	ParseInt( param,   "IsGM",          isGM );
	
	//ģ��
	if(isFriend != 0)
	{
		util.ToopTipInsertTitleContents(GetSystemString(2273), GetSystemString(3175), 77, 255, 99, true, true, true);
	}
	else
	{
		util.ToopTipInsertTitleContents(GetSystemString(2273), GetSystemString(3176), 255, 66, 66, true, true, true);
	}
	
	//����
	if(isPledge != 0)
	{
		util.ToopTipInsertTitleContents(GetSystemString(314), GetSystemString(3179), 77, 255, 99, true, true, false);
	}
	else
	{
		util.ToopTipInsertTitleContents(GetSystemString(314), GetSystemString(3180), 255, 66, 66, true, true, false);
	}
		

	//����
	if(isMentoring != 0 && !getInstanceUIData().getIsClassicServer())
	{
		util.ToopTipInsertTitleContents(GetSystemString(2767), GetSystemString(3177), 77, 255, 99, true, true, false);
	}
	else if ( !getInstanceUIData().getIsClassicServer() )
	{
		util.ToopTipInsertTitleContents(GetSystemString(2767), GetSystemString(3178), 255, 66, 66, true, true, false);
	}
		
	
	//����
	if(isAlliance != 0)
	{
		util.ToopTipInsertTitleContents(GetSystemString(490), GetSystemString(3181), 77, 255, 99, true, true, false);
	}
	else
	{
		util.ToopTipInsertTitleContents(GetSystemString(490), GetSystemString(3182), 255, 66, 66, true, true, false);
	}

	GetButtonHandle("TradeWnd.ChatLevelIcon_Btn").SetTooltipCustomType(util.getCustomToolTip());
}

function string GetTargetLevelIconIndex(int userLevel)
{
	local int num;
	
	num = userLevel / 10;

	if(num == 0) { return "01"; }
	else { return num $ "0"; }
	
	return "01";
}

function HandleTradeAddItem( string param )
{
	local string	strDest;
	local ItemInfo	itemInfo;
	//local ItemInfo	tempInfo;
	local int		index;

	ParseString( param, "destination", strDest );

	ParamToItemInfo( param, itemInfo );
	if( strDest == "inventoryList" )
	{
		strDest = "TradeWnd.InventoryList";
	}
	else if( strDest == "myList" )
	{
		strDest = "TradeWnd.MyList";
		class'UIAPI_INVENWEIGHT'.static.ReduceWeight( "TradeWnd.InvenWeight", itemInfo.ItemNum * itemInfo.Weight );
		//debug("AddWeight " $ itemInfo.ItemNum * itemInfo.Weight );
	}
	else if( strDest == "otherList" )
	{
		strDest = "TradeWnd.OtherList";
		class'UIAPI_INVENWEIGHT'.static.AddWeight( "TradeWnd.InvenWeight", itemInfo.ItemNum * itemInfo.Weight );
		//debug("ReduceWeight " $ itemInfo.ItemNum * itemInfo.Weight );
	}

	index = class'UIAPI_ITEMWINDOW'.static.FindItem( strDest, itemInfo.ID );	// ServerID
	//debug( "HandleTradeAddItem " $ strDest $ ", index " $ index );
	if( index >= 0 )
	{
		if( IsStackableItem( ItemInfo.ConsumeType ) )
		{
			//class'UIAPI_ITEMWINDOW'.static.GetItem( strDest, index, tempInfo );
			//itemInfo.ItemNum += tempInfo.ItemNum;
			class'UIAPI_ITEMWINDOW'.static.SetItem( strDest, index, itemInfo );
		}
		// �������� �̹� �ְ� ������ �����۵� �ƴ϶�� �ƹ��͵� ���� �ʴ´�.
	}
	else
	{
		class'UIAPI_ITEMWINDOW'.static.AddItem( strDest, itemInfo );
	}
}

// ��ȯ�� ������
function HandleTradeDone( string param )
{
	class'UIAPI_WINDOW'.static.HideWindow("TradeWnd");
}

// �ٸ� �ʿ��� OK ��ư�� ������ ���̻� ������ �� ����. ������ ������ ����Ʈ�� ���� �Ұ� ���·� ����.
function HandleTradeOtherOK( string param )
{
	class'UIAPI_ITEMWINDOW'.static.SetFaded( "TradeWnd.OtherList", true );
}

// �������� �ű�ų� �Ҷ� �ڽ��� �κ��丮 ��Ȳ�� ������Ʈ �Ѵ�.
function HandleTradeUpdateInventoryItem( string param )
{
	local ItemInfo info;
	local string type;
	local int	index;

	ParseString( param, "type", type );
	ParamToItemInfo( param, info );
	if( type == "add" )
	{
		class'UIAPI_ITEMWINDOW'.static.AddItem( "TradeWnd.InventoryList", info );
	}
	else if( type == "update" )
	{
		index = class'UIAPI_ITEMWINDOW'.static.FindItem( "TradeWnd.InventoryList", info.ID );	// ServerID
		if( index >= 0 )
			class'UIAPI_ITEMWINDOW'.static.SetItem( "TradeWnd.InventoryList", index, info );
	}
	else if( type == "delete" )
	{
		index = class'UIAPI_ITEMWINDOW'.static.FindItem( "TradeWnd.InventoryList", info.ID );	// ServerID
		if( index >= 0 )
			class'UIAPI_ITEMWINDOW'.static.DeleteItem( "TradeWnd.InventoryList", index );
	}
}

function HandleReceiveStartTrade( string param )
{
	local int targetID;
	local UserInfo info;
	local string Name;
	local bool bOption;

	bOption = GetOptionBool( "Communication", "IsRejectingTrade" );
	ParseInt( param, "targetID", targetID );

	if (bOption == true)
	{
		// �ɼǿ��� �ź� ���¸� üũ �س����� ����� ������ ������.		
		AnswerTradeRequest( false );
	}
	else if( targetID > 0 && GetUserInfo( targetID, info ) )
	{
		if ( IsShowWindow("DialogBox"))
		{
			RequestTradeDone(false);
			return;
		}
		if (info.WantHideName &&  info.JoinedDominionID >0)
		{
			Name = info.RealName;
		}
		else
		{
			Name =  info.Name;
		}		
		DialogSetID( DIALOG_ID_TRADE_REQUEST );
		DialogSetCancelD(DIALOG_ID_TRADE_REQUEST);
		DialogSetParamInt64( 10*1000 );			// 10 seconds  
		DialogSetEnterDoNothing();
		DialogShow(DialogModalType_Modalless, DialogType_Progress, MakeFullSystemMsg(GetSystemMessage(100), Name, "" ), string(Self) );
	}
}

function HandleDialogOK()
{
	local ItemID sID;
	local INT64 num;
	if( DialogIsMine() )
	{
		if( DialogGetID() == DIALOG_ID_TRADE_REQUEST )
		{
			AnswerTradeRequest( true );
		}
		else if( DialogGetID() == DIALOG_ID_ITEM_NUMBER )
		{
			sID = DialogGetReservedItemID();
			num = INT64( DialogGetString() );
			RequestAddTradeItem( sID, num );
		}
	}
}



function HandleDialogCancel()
{
	//if(DialogIsMine())
	//{
	//	if (DialogIsProgressBarWorking())
	//	{			
	//		if(DialogProgressCancelDialogID() == DIALOG_ID_TRADE_REQUEST)
	//		{
	//			AnswerTradeRequest( false );
	//		}
	//	}
	//}

	if(DialogIsMine())
	{
		if(DialogCheckCancelByID(DIALOG_ID_TRADE_REQUEST))
		{
			AnswerTradeRequest( false );
		}
	}
}

function Clear()
{
	class'UIAPI_ITEMWINDOW'.static.Clear( "TradeWnd.InventoryList" );
	class'UIAPI_ITEMWINDOW'.static.Clear( "TradeWnd.MyList" );
	class'UIAPI_ITEMWINDOW'.static.Clear( "TradeWnd.OtherList" );
	class'UIAPI_TEXTBOX'.static.SetText( "TradeWnd.TargetName", "" );
	class'UIAPI_INVENWEIGHT'.static.ZeroWeight( "TradeWnd.InvenWeight" );
	DialogHide();
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	AnswerTradeRequest( false );
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName);		
}

defaultproperties
{
     m_WindowName="TradeWnd"
}
