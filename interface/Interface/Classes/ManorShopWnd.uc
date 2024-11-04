class ManorShopWnd extends SeedShopWnd;

var InventoryWnd InventoryWndScript;

function OnRegisterEvent()
{
	registerEvent( EV_ManorShopWndOpen );
	registerEvent( EV_ManorShopWndAddItem );
	registerEvent( EV_DialogOK );
}

function OnLoad()
{
	SetClosingOnESC();

	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	InventoryWndScript = InventoryWnd(GetScript( "InventoryWnd" ));
}

function onShow()
{
	// ������ �����츦 ������ �ݱ� ��� 
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)));
} 

function OnEvent(int Event_ID,string param)
{
	// Debug("Event_ID:" @ Event_ID);
	// Debug("param: " @ param);

	switch( Event_ID )
	{
	case EV_ManorShopWndOpen:
		HandleOpenWindow(param);
		updateInventoryItemCountText();
		break;
	case EV_ManorShopWndAddItem:
		HandleAddItem(param);
		updateInventoryItemCountText();
		break;
	case EV_DialogOK:
		HandleDialogOK();	
		updateInventoryItemCountText();
		break;
	default:
		break;
	}
}

function MoveItemTopToBottom( int index, bool bAllItem )
{
	local int bottomIndex;
	local ItemInfo info, bottomInfo;
	if( class'UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName$".TopList", index, info) )
	{
		// 1�ϰ�� ������ �Է��ϴ� ���̾�α״� ������� �ʴ´�.
//		debug("info.ConsumeType:"$info.ConsumeType$", ����:"$info.ItemNum);
		if( !bAllItem && IsStackableItem( info.ConsumeType ) && (info.ItemNum!=1) )		// stackable?
		{
			DialogSetID( DIALOG_TOP_TO_BOTTOM );
			DialogSetReservedItemID( info.ID );
			
			if( m_shopType == ShopSell || m_shopType == ShopBuy )
				DialogSetParamInt64( info.ItemNum );
			else
				DialogSetParamInt64(-1);

			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg( GetSystemMessage(72), info.Name, "" ), string(Self) );
		}
		else
		{
			info.bShowCount = false;

			if( m_shopType == ShopSell )
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".BottomList", info.ID );
				if( bottomIndex >= 0 && IsStackableItem( info.ConsumeType ) )
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
					bottomInfo.ItemNum += info.ItemNum;
					class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo);
				}
				else
				{
					class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );
				}
				class'UIAPI_ITEMWINDOW'.static.DeleteItem( m_WindowName$".TopList", index );		// ������ �� ��� �ڽ��� �κ��丮 ��Ͽ��� �������� ����
			}
			else if( m_shopType == ShopBuy )												// ���� �ٿ� �߰��Ǵ� ���Ը�ŭ ���� �ش�.
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".BottomList", info.ID );
				if( bottomIndex >= 0 && IsStackableItem( info.ConsumeType ) )
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
					bottomInfo.ItemNum += info.ItemNum;
					class'UIAPI_ITEMWINDOW'.static.SetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo);
				}
				else
				{
					class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );
					class'UIAPI_INVENWEIGHT'.static.AddWeight( m_WindowName$".InvenWeight", info.Weight * info.ItemNum );
				}
				
				if(bAllItem)
				{
					class'UIAPI_ITEMWINDOW'.static.DeleteItem( m_WindowName$".TopList", index );		// ������ �ǸŸ���Ʈ�� �ִ� ��� �������� ������� ������ ����.
				}
			}
			else if( m_shopType == ShopPreview)	//�̸�����
			{
				bottomIndex = class'UIAPI_ITEMWINDOW'.static.FindItem( m_WindowName$".BottomList", info.ID );
				info.ItemNum = 1;
				class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".BottomList", info );				
			}
			AddPrice( info.Price * info.ItemNum );
		}
	}
}

function HandleOpenWindow(string param)
{
	//ParseInt(param, "inventoryItemCount", inventoryItemCount);
	Super.HandleOpenWindow(param);

	// ���� Ÿ��Ʋ ���� - lancelot 2006. 11. 1.
	setWindowTitleBySysStringNum(738);
	class'UIAPI_WINDOW'.static.SetTooltipType(m_WindowName$".TopList", "InventoryPrice1HideEnchant");
}

function HandleAddItem(string param)
{
	local ItemInfo info;

	ParamToItemInfo( param, info);
	info.bShowCount=false;
	class'UIAPI_ITEMWINDOW'.static.AddItem( m_WindowName$".TopList", info );
}

function HandleOKButton()
{
	local string	param;
	local int		topCount, bottomCount, topIndex, bottomIndex;
	local ItemInfo	topInfo, bottomInfo;
	local INT64		limitedItemCount;

	bottomCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".BottomList" );
//	debug("ShopWnd m_shopType:" $ m_shopType $ ", bottomCount:" $ bottomCount);
	if( m_shopType == ShopBuy )
	{
		// limited item check
		topCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".TopList" );
		for( topIndex=0 ; topIndex < topCount ; ++topIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".TopList", topIndex, topInfo );
			if(	topInfo.ItemNum > 0 )		// this item can be purchased only by limited number
			{
				limitedItemCount = 0;
				// search in BottomList for same classID
				bottomCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".BottomList" );
				for( bottomIndex=0; bottomIndex < bottomCount ; ++bottomIndex )		// match found, then check whether the number exceeds limited number
				{
					class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
					if( IsSameClassID(bottomInfo.ID, topInfo.ID) )
						limitedItemCount += bottomInfo.ItemNum;
				}

				//debug("limited Item count " $ limitedItemCount );
				if( limitedItemCount > topInfo.ItemNum )
				{
					// warning dialog
					DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1338), string(Self) );
					return;
				}
			}
		}
		// pack every item in BottomList
		ParamAdd( param, "merchant", string(m_merchantID) );
		ParamAdd( param, "num", string(bottomCount) );
		for( bottomIndex=0 ; bottomIndex < bottomCount; ++bottomIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
			ParamAddItemIDWithIndex( param, bottomInfo.ID, bottomIndex );
			ParamAdd( Param, "Count_" $ bottomIndex, string(bottomInfo.ItemNum) );
		}
		RequestBuySeed( param );
	}
	else if( m_shopType == ShopSell )
	{
		// pack every item in BottomList
		ParamAdd( param, "merchant", string(m_merchantID) );
		ParamAdd( param, "num", string(bottomCount) );
		for( bottomIndex=0 ; bottomIndex < bottomCount; ++bottomIndex )
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( m_WindowName$".BottomList", bottomIndex, bottomInfo );
			ParamAddItemIDWithIndex( param, bottomInfo.ID, bottomIndex);
			ParamAdd( Param, "Count_" $ bottomIndex, string(bottomInfo.ItemNum) );
		}

		// ��������� SELL �� ������ ���� �����Ǿ� �־ �������� - lancelot 2006. 11. 1.
		// RequestProcureCrop( param );
	}
	else if( m_shopType == ShopPreview )
	{
		if( bottomCount > 0 )
		{
			DialogSetID( DIALOG_PREVIEW );
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1157), string(Self) );
		}
	}


	HideWindow(m_WindowName);
}

/**
 * 
 *  ������Ʈ �κ��丮 ���� , ���� ����/�ִ���� 
 **/
function updateInventoryItemCountText()
{
	local int count, invenCount;

	count = InventoryWndScript.getCurrentInventoryItemCount();
	invenCount = class'UIAPI_ITEMWINDOW'.static.GetItemNum( m_WindowName$".BottomList" );
	
	GetTextBoxHandle(m_WindowName $ ".ItemCount").SetText("(" $ invenCount $ "/" $ count $ ")");
}

/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	Clear();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_WindowName="ManorShopWnd"
}
