class InventoryViewer extends UICommonAPI;

var ItemWindowHandle totalInven_ItemWnd;

var int baseWidth, baseHeight;
var InventoryWnd inventoryWndScript;
var TextBoxHandle   InvenoryCount;
var TextBoxHandle   AdenaText;	

var WindowHandle     ParentWindow;

var ButtonHandle HelpButton;


event OnRegisterEvent()
{
	RegisterEvent(EV_InventoryClear);
	RegisterEvent(EV_AdenaInvenCount);
	RegisterEvent(EV_SetMaxCount);
}

event OnLoad()
{
	Initialize();
}

function Initialize()
{
	totalInven_ItemWnd = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$ ".InventoryItem_ItemWnd");
	InvenoryCount = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryCount_TextBox");
	AdenaText = GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenaText");
	HelpButton = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".HelpButton");
	inventoryWndScript = inventoryWnd(GetScript("inventoryWnd"));
}

event OnLButtonDown(WindowHandle a_WindowHandle, int nX, int nY)
{
	// Debug("a_WindowHandle-> " @ a_WindowHandle.GetWindowName() @ nX @ nY);
	ParentWindow.SetFocus();
	m_hOwnerWnd.SetFocus();
}

event OnEvent(int Event_ID, string param)
{
	//debug("Inven Event ID :" $string(Event_ID)$" "$param);
	switch( Event_ID )
	{
		//case EV_InventoryAddItem:         
		//case EV_InventoryUpdateItem:    
		//case EV_InventoryClear:    
		//case EV_UpdateUserEquipSlotInfo:
	 //   case EV_InventoryItemListEnd:

		//case EV_UpdateUserInfo:
		case EV_AdenaInvenCount:
		case EV_SetMaxCount    :       //2070

			//Me.ShowWindow();
			if (m_hOwnerWnd.IsShowWindow()) 
			{
				SetAdenaText();
				SetItemCount();
				syncInventory();
			}
	    break;
	    case EV_InventoryClear :
			totalInven_ItemWnd.Clear();
	    break;
	    //case EV_SetMaxCount:
//			handleSetMaxCount();
		//break;

	}
}

event OnShow()
{
	SetAdenaText();
	SetItemCount();
	syncInventory();
}

event onClickButton ( string StrID )
{
	if ( StrID == "CloseButton")  m_hOwnerWnd.HideWindow();
}

//function OnSetFocus( WindowHandle a_WindowHandle, bool bFocused )
//{
//	Debug("a_WindowHandle " @ a_WindowHandle.GetWindowName() @ bFocused);

//	if(a_WindowHandle.GetWindowName() == Me.getWin && bFocused == true)
//	{
//		if(ParentWindow.GetWindowName() != "")
//		{
//			ParentWindow.SetFocus();		
//			Me.SetFocus();
//		}
//	}   
//}

function SetItemCount()
{
	local int limit;
	local int count;
	
	count = inventoryWndScript.m_NormalInvenCount + inventoryWndScript.EquipNormalItemGetItemNum();
	limit = inventoryWndScript.GetMyInventoryLimit();
	//Debug ( "(" $ count $ "/" $ limit $ ")");
	InvenoryCount.SetText("(" $ count $ "/" $ limit $ ")");

	getInstanceL2Util().ItemboxUpdate ( totalInven_ItemWnd , limit);

	// End:0xA3
	if(HelpButton.IsShowWindow())
	{
		HelpButton.HideWindow();
	}
}

// 무기, 집혼석 관련 아이템 윈도우 업데이트
function syncInventory()
{
	local int i;//, totalLen;
	local ItemInfo kClearItem;

	local array<ItemInfo> itemarray, equipItemArray;

	kClearItem.IconName = "L2ui_ct1.emptyBtn";
	ClearItemID( kClearItem.ID );

	// 인벤에서, 아이템 목록, 착용한 장비 목록을 따로 얻어오기
	itemArray = getInstanceL2Util().SortItemArray ( inventoryWndScript.getInventoryAllItemArray(true)) ;
	equipItemArray = getInstanceL2Util().SortItemArray ( inventoryWndScript.getInventoryEquipItemArray() );			
	
	for(i = 0; i < equipItemArray.Length; i++) 
	{
		equipItemArray[i].ForeTexture = "L2UI_CT1.Icon.WearPanel";
		setShowItemCount(equipItemArray[i]);

		totalInven_ItemWnd.SetItem( i, equipItemArray[i]);
	}
	

	// 일반 아이템 추가
	for(i = 0; i < itemArray.Length ; i++) 
	{
		setShowItemCount(itemArray[i]);
		totalInven_ItemWnd.SetItem ( i + equipItemArray.Length, itemArray[i]);
	}
	
	// 빈 아이템 추가
	for ( i = equipItemArray.Length + itemArray.Length; i < inventoryWndScript.GetMyInventoryLimit(); i ++ ) 
	{
		//Debug ("syncInventory" @  i );
		totalInven_ItemWnd.SetItem( i,  kClearItem ) ;
	}
}

function showWindowByParentWindow(WindowHandle pWnd, optional bool bToggleShow)
{	
	ParentWindow = pWnd;
	//getInstanceL2Util().windowMoveToSide(pWnd, m_hOwnerWnd);	
	getInstanceL2Util().windowAnchorToSide(pWnd, m_hOwnerWnd, 2, 29);	

	if (!m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.ShowWindow();
		m_hOwnerWnd.SetFocus();
		pWnd.SetFocus();
	}
	else 
	{
		if(bToggleShow) m_hOwnerWnd.HideWindow();
	}
}

function SetAdenaText()
{
	local string adenaString;
	
	adenaString = MakeCostString( string(GetAdena()) );

	AdenaText.SetText(adenaString);
	AdenaText.SetTooltipString( ConvertNumToText(string(GetAdena())) );
}

defaultproperties
{
}
