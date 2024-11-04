class GMInventoryWnd extends InventoryWnd;

struct GMHennaInfo
{
	var int HennaID;
	var int IsActive;	
	var int Period;
};

var bool bShow;	// GMâ���� ��ư�� �ѹ� �� ������ ������� �ϱ� ���� ����
var int m_ObservingUserInvenLimit;
var INT64 m_Adena;
var bool m_HasLEar;
var bool m_HasLFinger;
var array<GMHennaInfo> m_HennaInfoList;
var GMHennaInfo m_PremiumHennaInfo;

function OnRegisterEvent()
{
	RegisterEvent(EV_GMObservingInventoryAddItem);
	RegisterEvent(EV_GMObservingInventoryClear);
	RegisterEvent(EV_GMAddHennaInfo);
	RegisterEvent(EV_GMAddPremiumHennaInfo); //branch121212
	RegisterEvent(EV_GMUpdateHennaInfo);
	RegisterEvent(EV_NeedResetUIData);
}

function OnLoad()
{
	local WindowHandle hCrystallizeButton;
	local WindowHandle hTrashButton;
	local WindowHandle hInvenWeight;

	InitHandleCOD();

	//������ �ޱ�
	SetEquipWindowHandle();
	SetHandles();

	hCrystallizeButton = GetWindowHandle( "GMInventoryWnd.CrystallizeButton" );
	hTrashButton = GetWindowHandle( "GMInventoryWnd.TrashButton" );
	hInvenWeight = GetWindowHandle( "GMInventoryWnd.InvenWeight" );
	
	
	bShow = false;
	m_hOwnerWnd.SetWindowTitle( GetSystemString(138) );

	hCrystallizeButton.HideWindow();
	hTrashButton.HideWindow();
	hInvenWeight.HideWindow();

	// �κ��丮 Ȯ�� ���� ��� 
	InitScrollBar();
	
	m_bCurrentState = false;
	m_selectedItemTab = INVENTORY_ITEM_TAB;

	//currentInvenCol = GetOptionInt( "Game", "ItemInventoryCol");
	//debug("option " @ currentInvenCol);

	// ������ĭ ���� 6~12, option.ini ���� �� : ���ʷ� ���� �Ǿ��ų� ���� �Ǿ��ٸ� ������ 6���� ����
	//if (currentInvenCol != 9 && currentInvenCol != 12)
	//{
	//	currentInvenCol = 9;
	//}
}
function OnShow()
{
	CheckShowCrystallizeButton();
	SetAdenaText();
	SetItemCount();

	UpdateHennaInfo();

	//if (currentInvenCol == 9)
	//{
	//	//extendInventory(false);
	//	m_InventoryItembg.ShowWindow();
	//	m_InventoryItembg_expand.HideWindow();
	//}   
	//else if (currentInvenCol == 12)
	//{
	//	// 12 �� Ȯ��
	//	extendInventory(true);
	//}
}

function OnHide()
{
	//GM�� SaveInventoryOrder�� ���� �ʴ´�.
	
}

function ShowInventory( String a_Param )
{
	if( a_Param == "" )
		return;

	if(bShow)	//â�� �������� �����ش�.
	{
		HandleClear();
		m_hOwnerWnd.HideWindow();
		bShow = false;
	}
	else	
	{
		class'GMAPI'.static.RequestGMCommand( GMCOMMAND_InventoryInfo, a_Param );
		bShow = true;
	}
	
}

function OnEvent(int a_EventID, String a_Param)
{
	switch(a_EventID)
	{
		case EV_GMObservingInventoryAddItem:
			HandleGMObservingInventoryAddItem( a_Param );
			break;
		case EV_GMObservingInventoryClear:
			HandleGMObservingInventoryClear( a_Param );
			break;
		case EV_GMAddHennaInfo:
			HandleGMAddHennaInfo( a_Param );
			break;
		case EV_GMUpdateHennaInfo:
			HandleGMUpdateHennaInfo( a_Param );
			break;
		case EV_GMAddPremiumHennaInfo:
			HandleGMAddPremiumHennaInfo( a_Param );
			break;
		case EV_NeedResetUIData:
			checkClassicForm();
			break;
	}
}

function HandleGMObservingInventoryAddItem( String a_Param )
{
	HandleAddItem( a_Param );
	SetItemCount();
}

function HandleAddItem(string param)
{
	local ItemInfo info;
	
	ParamToItemInfo( param, info );

	if( IsEquipItem(info) )
		EquipItemUpdate( info );
	else if( IsQuestItem(info) )
		m_questItem.AddItem( info );
	else
	{
		if( IsAdena(info.ID) )
			SetAdena( info.ItemNum );
			
		//ParseInt( param, "Order", Order );
		//NormalInvenAddItem( info, Order );
		NormalInvenAddItem( info );
	}
}

function SetAdena( INT64 a_Adena )
{
	m_Adena = a_Adena;
	SetAdenaText();
}

function SetAdenaText()
{
	local string adenaString;
	
	adenaString = MakeCostString( string( m_Adena ) );

	m_hAdenaTextBox.SetText( adenaString );
	m_hAdenaTextBox.SetTooltipString( ConvertNumToText( string( m_Adena ) ) );
}

function int GetMyInventoryLimit()
{
	return m_ObservingUserInvenLimit;
}

function HandleGMObservingInventoryClear( String a_Param )
{
	HandleClear();

	ParseInt( a_Param, "InvenLimit", m_ObservingUserInvenLimit );

	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
}

function HandleGMAddHennaInfo( String a_Param )
{
	m_HennaInfoList.Length = m_HennaInfoList.Length + 1;

	ParseInt( a_Param, "ID", m_HennaInfoList[ m_HennaInfoList.Length - 1 ].HennaID );
	ParseInt( a_Param, "bActive", m_HennaInfoList[ m_HennaInfoList.Length - 1 ].IsActive );

	UpdateHennaInfo();
	
}

function HandleGMAddPremiumHennaInfo( String a_Param )
{	
	ParseInt( a_Param, "ID", m_PremiumHennaInfo.HennaID );
	ParseInt( a_Param, "bActive", m_PremiumHennaInfo.IsActive );
	ParseInt( a_Param, "Period", m_PremiumHennaInfo.Period );

	GMUpdatePremiumHennaInfo();
	
}

function HandleGMUpdateHennaInfo( String a_Param )
{
	m_HennaInfoList.Length = 0;
	
	m_PremiumHennaInfo.HennaID = 0;
	m_PremiumHennaInfo.IsActive = 0;
	m_PremiumHennaInfo.Period = 0;
}

// Disabling inherited function - NeverDie
function OnDropItem( String strTarget, ItemInfo info, int x, int y )
{
}

// Disabling inherited function - NeverDie
function OnDropItemSource( String strTarget, ItemInfo info )
{
}

// Disabling inherited function - NeverDie
function OnDBClickItem( String strID, int index )
{
}

// Disabling inherited function - NeverDie
function OnRClickItem( String strID, int index )
{
}

function EquipItemUpdate( ItemInfo a_info, optional bool bSwitchExpandEquipBox )
{
	local ItemWindowHandle hItemWnd;

	Super.EquipItemUpdate( a_info );

	switch( a_Info.SlotBitType )
	{
	case 2:		// SBT_REAR
	case 4:		// SBT_LEAR
	case 6:		// SBT_RLEAR
		if( 0 == m_equipItem[ EQUIPITEM_REar ].GetItemNum() )
			hItemWnd = m_equipItem[ EQUIPITEM_REar ];
		else
			hItemWnd = m_equipItem[ EQUIPITEM_LEar ];
		break;
	case 16:	// SBT_RFINGER
	case 32:	// SBT_LFINGER
	case 48:	// SBT_RLFINGER
		if( 0 == m_equipItem[ EQUIPITEM_RFinger ].GetItemNum() )
			hItemWnd = m_equipItem[ EQUIPITEM_RFinger ];
		else
			hItemWnd = m_equipItem[ EQUIPITEM_LFinger ];
		break;
	}

	if( None != hItemWnd )
	{
		hItemWnd.Clear();
		hItemWnd.AddItem( a_Info );
	}

}

function int IsLOrREar( ItemID sID )
{
	return 0;
}

function int IsLOrRFinger( ItemID sID )
{
	return 0;
}

function UpdateHennaInfo()
{
	local int i;
	local ItemInfo HennaItemInfo;

	for( i = 0; i < m_HennaInfoList.Length; ++i )
	{
		if( !class'UIDATA_HENNA'.static.GetItemName( m_HennaInfoList[i].HennaID, HennaItemInfo.Name ) )
			break;
		if( !class'UIDATA_HENNA'.static.GetDescription( m_HennaInfoList[i].HennaID, HennaItemInfo.Description ) )
			break;
		if( !class'UIDATA_HENNA'.static.GetIconTex( m_HennaInfoList[i].HennaID, HennaItemInfo.IconName ) )
			break;

		if( 0 == m_HennaInfoList[i].IsActive )
			HennaItemInfo.bDisabled = 1;
		else
			HennaItemInfo.bDisabled = 0;
	}
}

//branch121212
function GMUpdatePremiumHennaInfo()
{
	local int HennaID;
	local ItemInfo HennaItemInfo;
	local bool hennacheck;

	HennaID = m_PremiumHennaInfo.HennaID;
	
	hennacheck = class'UIDATA_HENNA'.static.GetItemCheck(HennaID);
	if( hennacheck )
	{
		HennaItemInfo.Name = class'UIDATA_HENNA'.static.GetItemNameS( HennaID );
		HennaItemInfo.Description = class'UIDATA_HENNA'.static.GetDescriptionS( HennaID );
		HennaItemInfo.IconName = class'UIDATA_HENNA'.static.GetIconTexS( HennaID );
		HennaItemInfo.CurrentPeriod = m_PremiumHennaInfo.Period;
	}
	
	if( 0 == m_PremiumHennaInfo.IsActive )
		HennaItemInfo.bDisabled = 1;
	else
		HennaItemInfo.bDisabled = 0;
}
//end of branch

defaultproperties
{
}
