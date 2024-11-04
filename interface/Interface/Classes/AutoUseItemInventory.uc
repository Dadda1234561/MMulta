/**
 *  �Ҹ�ǰ �ڵ� ���, �����κ��丮
 **/
class AutoUseItemInventory extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle CloseButton;
var TextBoxHandle Inventory_Title_TextBox;
var ItemWindowHandle InventoryItem_ItemWnd;
var InventoryWnd inventoryWndScript;

var WindowHandle     ParentWindow;

function OnRegisterEvent()
{
	//RegisterEvent(  );
	//RegisterEvent( EV_GameStart );

	//RegisterEvent(EV_InventoryAddItem);
	//RegisterEvent(EV_InventoryUpdateItem);
	//RegisterEvent(EV_InventoryItemListEnd);

	RegisterEvent(EV_InventoryUpdateItem);
	RegisterEvent(EV_InventoryAddItem);

	RegisterEvent(EV_Restart);
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(String(self)));
	syncInventoryByAll();
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
}

function Initialize()
{
	Me = GetWindowHandle( "AutoUseItemInventory" );
	CloseButton = GetButtonHandle( "AutoUseItemInventory.CloseButton" );
	Inventory_Title_TextBox = GetTextBoxHandle( "AutoUseItemInventory.Inventory_Title_TextBox" );
	InventoryItem_ItemWnd = GetItemWindowHandle( "AutoUseItemInventory.InventoryItem_ItemWnd" );
	inventoryWndScript = inventoryWnd(GetScript("inventoryWnd"));

}

function Load()
{
}

function OnClickItem (string strID, int Index)
{
	local ItemInfo SelectItemInfo;
	local int SlotNum;

	InventoryItem_ItemWnd.GetItem(Index, SelectItemInfo);
	if ( SelectItemInfo.Id.ClassID > 0 )
	{
		SlotNum = AutoUseItemWnd(GetScript("AutoUseItemWnd")).getEmptySlotNum();
		Debug("slotNum" @ string(SlotNum));
		if ( SlotNum > 0 )
		{
			Class'ShortcutWndAPI'.static.RequestRegisterShortcut(SlotNum,SelectItemInfo);
		}
	}
}

function OnClickButton( string Name )
{
	switch( Name )
	{
		case "CloseButton":
			OnCloseButtonClick();
			break;
	}
}

function OnCloseButtonClick()
{
	Me.HideWindow();
}

/**
 * OnEvent 
 **/
function OnEvent(int Event_ID, string param)
{	
	switch( Event_ID )
	{	
		case EV_GameStart : 
			 //Me.ShowWindow(); 
			 break;

		case EV_InventoryUpdateItem:
		case EV_InventoryAddItem    :       //2070
			 syncInventory(param);

			 break;

		case EV_Restart:
			 InventoryItem_ItemWnd.Clear();
			 break;

		//case EV_InventoryAddItem:
		//	 break;

		//case EV_InventoryUpdateItem:
		//	 break;

		//case EV_InventoryItemListEnd:
		//	 break;
	}
}


function showWindowByParentWindow(WindowHandle pWnd, optional bool bToggleShow)
{	
	ParentWindow = pWnd;
	//getInstanceL2Util().windowMoveToSide(pWnd, Me);	
	getInstanceL2Util().windowAnchorToSide(pWnd, Me, 2, 0);	

	if (!Me.IsShowWindow())
	{
		Me.ShowWindow();
		Me.SetFocus();
		pWnd.SetFocus();
	}
	else 
	{
		if(bToggleShow) Me.HideWindow();
	}
}

function syncInventory (string param)
{
	local ItemInfo updatedItemInfo;
	local string Type;
	local int Index;

	if (!Me.IsShowWindow()) return;

	ParamToItemInfo(param,updatedItemInfo);
	ParseString(param,"type",Type);
	if ( Class'UIDATA_ITEM'.static.GetAutomaticUseItemType(updatedItemInfo.Id.ClassID) == 1)
	{
		Index = InventoryItem_ItemWnd.FindItemByClassID(updatedItemInfo.Id);
		if ( Type == "delete" )
		{
			if ( Index > -1 )
				InventoryItem_ItemWnd.DeleteItem(Index);
		}
		else
		{
			setShowItemCount(updatedItemInfo);
			if ( Index > -1 )
				InventoryItem_ItemWnd.SetItem(Index,updatedItemInfo);
			else
				InventoryItem_ItemWnd.AddItem(updatedItemInfo);
		}
	}
}

// ����, ��ȥ�� ���� ������ ������ ������Ʈ
function syncInventoryByAll()
{
	local array<ItemInfo> itemArray;
	local int i;//, totalLen;
	//local ItemInfo kClearItem;


	if (!Me.IsShowWindow()) return;

	//kClearItem.IconName = "L2ui_ct1.emptyBtn";
	//ClearItemID( kClearItem.ID );

	///getInstanceL2Util().ItemboxUpdate ( totalInven_ItemWnd , limit + artifactItemArray.Length);

	// �κ�����, ������ ���, ������ ��� ����� ���� ������
	itemArray = inventoryWndScript.getInventoryAllItemArray(true);
	
	InventoryItem_ItemWnd.Clear();

	// �Ϲ� ������ �߰�
	for(i = 0; i < itemArray.Length ; i++) 
	{
		//Debug("-->"@ itemArray[i].Name);

		//setShowItemCount(itemArray[i]);
		//InventoryItem_ItemWnd.SetItem(i, itemArray[i]);
		// �ڵ���� ���� 
		if(class'UIDATA_ITEM'.static.GetAutomaticUseItemType(itemArray[i].Id.ClassID) == 1)
		{
			setShowItemCount(itemArray[i]);
			InventoryItem_ItemWnd.AddItem(itemArray[i]);
		}
	}
	//for ( i = itemArray.Length; i < inventoryWndScript.GetMyInventoryLimit(); i ++ ) 
	//{
	//	//Debug ("syncInventory" @  i );
	//	InventoryItem_ItemWnd.SetItem( i,  kClearItem ) ;
	//}
}	
	// �� ������ �߰�
//	for ( i = itemArray.Length; i < inventoryWndScript.GetMyInventoryLimit(); i ++ ) 
//	{
//		//Debug ("syncInventory" @  i );
//		InventoryItem_ItemWnd.SetItem( i,  kClearItem ) ;
//	}
//}


/**
 * ������ ESC Ű�� �ݱ� ó�� 
 * "Esc" Key
 ***/
function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle( getCurrentWindowName(string(Self))).HideWindow();
}

defaultproperties
{
}
