class CostumePreviewWnd extends UICommonAPI;

var string m_WindowName;
var string boughtCostumeList;
var string armorCostumeList;
var string weaponCostumeList;
var string shieldCostumeList;
var string cloakCostumeList;

var string m_currCostume;
var int m_MeshType;

var int nCurrTexture;

var int m_selectedCostumeId;
var ItemInfo m_selectedCostume;
var ItemWindowHandle InventoryItem;
var UIControlNeedItemList m_needItemScript;

var	ItemWindowHandle	m_invenItem;
var	ItemWindowHandle	m_invenItem_1;
var	ItemWindowHandle	m_invenItem_2;
var	ItemWindowHandle	m_invenItem_3;
var	ItemWindowHandle	m_invenItem_4;

var ItemWindowHandle 	m_selectedItemWnd;

var	CharacterViewportWindowHandle m_ObjectViewport;
var WindowHandle Me;

var ButtonHandle resetBtn;
var ButtonHandle wearBtn;
var ButtonHandle buyBtn;
var TabHandle		CostumeTab;

const COSTUME_TAB_ARMOR = 0;
const COSTUME_TAB_WEAPON = 1;
const COSTUME_TAB_SHIELD = 2;
const COSTUME_TAB_CLOAK = 3;
const COSTUME_TAB_BOUGHT = 4;

var int  m_selectedItemTab;
var bool  bShowRemove;

var array<int> coinList;


function OnRegisterEvent()
{
	RegisterEvent(EV_ChangeCharacterPawn);
	RegisterEvent(EV_NPCDialogWndLoadHtmlFromString);
	RegisterEvent(EV_InventoryUpdateItem);
	RegisterEvent(EV_Restart);
}
	
function OnEvent(int Event_ID, string param)
{	
	switch(Event_ID)
	{
		case EV_Restart:
			UpdateCharacterDisplay();
			break;
		case EV_NPCDialogWndLoadHtmlFromString:
			HandleHtmlString(param);
			break;
		case EV_ChangeCharacterPawn:
			HandleChangeCharacterPawn(param);
			break;
		case EV_InventoryUpdateItem:
			RefreshPriceItem(param);
			break;
	}
}

function OnLoad()
{	
	SetClosingOnESC();
	Initialize();
}

function OnShow()
{
	RequestBoughtCostumeList();
	if ( !m_ObjectViewport.IsShowWindow() )
	{
		m_ObjectViewport.ShowWindow();
	}
	UpdateCharacterDisplay();
	// move to front
	Me.BringToFront();
}

function UpdateCharacterDisplay()
{
	local UserInfo currUser;
	if ( GetPlayerInfo(currUser) )
	{
		HandleChangeCharacterPawn("MeshType="$string(currUser.Race));
	}
}

function Initialize()
{
	Me = GetWindowHandle(m_WindowName);
	
	resetBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".Reset_Btn");
	wearBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".Wear_Btn");
	wearBtn.HideWindow();

	buyBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".Buy_Btn");
	CostumeTab = GetTabHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".CostumeTab");

	m_invenItem = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".InventoryItem");
	m_invenItem_1 = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".InventoryItem_1");
	m_invenItem_2 = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".InventoryItem_2");
	m_invenItem_3 = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".InventoryItem_3");
	m_invenItem_4 = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath$".InventoryItem_4");

	InventoryItem = GetItemWindowHandle( "InventoryWnd.InventoryItem");	

	m_ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName$".CostumePreviewViewport");
	m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.CostumeWnd.CostumeWnd_DetailCharacter1");
	m_ObjectViewport.SetDragRotationRate(300);
	m_ObjectViewport.SetSpawnDuration(0.0);
	m_ObjectViewport.SetUISound(False);

	m_needItemScript = class'UIControlNeedItemList'.static.InitScript(GetWindowHandle(m_WindowName$".NeedItemWnd"));
	m_needItemScript._SetUseAnimation(True);
	m_needItemScript.DelegateOnUpdateItem = OnItemUpdateItem;
	m_needItemScript._SetAnimationRate(0.50f);

	coinList.Length = 3;
	coinList[0] = 57;
	coinList[1] = 4037;
	coinList[2] = 97145;

	LoadItems();

	if ( !m_ObjectViewport.IsShowWindow() )
	{
		m_ObjectViewport.ShowWindow();
	}
}

function bool IsCoin(ItemId nItemId)
{
	local int i;

	if ( nItemID.ClassID == -1 ) 
	{
		return False;
	}

	for ( i = 0; i < coinList.Length; i++ )
	{
		if ( coinList[i] == nItemID.ClassID )
		{
			return True;
		}
	}

	return False;
}


function HandleHtmlString(string param)
{
	local int i, ItemId;
	local ItemInfo CostumeItem;
	local string htmlString, boughtCostumeList;
	local array<string> costumeList;
	local array<int> costumes;
	local array<ItemInfo> EquippedItemsArray;

	ParseString(param, "HTMLString", htmlString);
	ParseString(htmlString, "CostumeList", boughtCostumeList);

	EquippedItemsArray.Length = 0;
	class'UIDATA_INVENTORY'.static.GetAllEquipItem(EquippedItemsArray);

	m_invenItem_4.Clear();

	Split(boughtCostumeList, ",", costumeList);
	
	// If list is empty...
	if ( Len(boughtCostumeList) == 0 ) 
	{
		return;
	}

	// iterate over the list
	for ( i = 0; i < costumeList.length; i++ )
	{
		ItemId = int(costumeList[i]);
		CostumeItem = GetItemInfoByClassID(ItemId);
		// apply look change icon panel
		if ( IsItemEquippedAsVisual(EquippedItemsArray, CostumeItem) )
		{
			if( CostumeItem.BodyPart == 28 )
			{
				CostumeItem.LookChangeIconPanel = "BranchSys3.Icon.pannel_lookChange_All";
			}
			else
			{
				CostumeItem.LookChangeIconPanel = "BranchSys3.Icon.pannel_lookChange";
			}
		}
		m_invenItem_4.AddItem(CostumeItem);
	}
}

function bool IsItemEquippedAsVis(ItemInfo CostumeItem)
{
	local int i;
	local ItemInfo CurrentItem;
	local array<ItemInfo> EquippedItemsArray;
	local bool bIsEquipped;
	
	class'UIDATA_INVENTORY'.static.GetAllEquipItem(EquippedItemsArray);
	bIsEquipped = False;
	if ( EquippedItemsArray.Length == 0 ) 
	{
		return False;
	}	

	for ( i = 0; i < EquippedItemsArray.Length; i++ ) 
	{
		CurrentItem = EquippedItemsArray[i];
		// skip non-existing item
		if ( CurrentItem.ID.ServerID == 0 ) 
		{
			continue;
		}
		// check if equipped and vis item id is equal to our
		if ( CurrentItem.bEquipped && (CurrentItem.LookChangeItemID == CostumeItem.ID.ClassID) )
		{
			bIsEquipped = True;
			break;
		} 
	}

	return bIsEquipped;
}

function bool IsItemEquippedAsVisual(array<ItemInfo> EquippedItemsArray, ItemInfo CostumeItem)
{
	local int i;
	local ItemInfo CurrentItem;
	local bool bIsEquipped;
	
	bIsEquipped = False;

	for ( i = 0; i < EquippedItemsArray.Length; i++ ) 
	{
		CurrentItem = EquippedItemsArray[i];
		// skip non-existing item
		if ( CurrentItem.ID.ServerID == 0 ) 
		{
			continue;
		}
		// check if equipped and vis item id is equal to our
		if ( CurrentItem.bEquipped && (CurrentItem.LookChangeItemID == CostumeItem.ID.ClassID) )
		{
			bIsEquipped = True;
			break;
		} 
	}

	return bIsEquipped;
}

function bool IsItemAlreadyOwnded(ItemID itemId) 
{
	local int index;	
	index = m_invenItem_4.FindItem(itemId);
	if ( index == -1 ) 
	{
		return False;
	}
	return True;
}

function bool IsItemEquipped(ItemInfo Item)
{
	local int index;
	local bool isEquipped;
	local array<ItemInfo> EquippedItemsArray;
	
	class'UIDATA_INVENTORY'.static.GetAllEquipItem(EquippedItemsArray);

	index = InventoryItem.FindItem( Item.ID );
	
	if ( index == -1 ) 
	{
		return False;
	}

	return True;
}

function bool CheckItemType(ItemInfo Item)
{
	local ItemInfo EquippedItem;
	local int index;
	local string itemType;
	// index = InventoryItem.FindItem(Item.Id);
	// if (index == -1) {
	// 	return false;
	// }
	// InventoryItem.GetItem(index, EquippedItem);
	// if is item

	class'InventoryWnd'.static.Inst().GetEquippedWeaponItem(EquippedItem);

	
	if ( Item.WeaponType == 11 || EquippedItem.WeaponType == 11 ) 
	{
		if ( EquippedItem.WeaponType == Item.WeaponType ) 
		{
			return True;
		}
		else
		{
			return False;
		}
	}
	return True;
}

private function ParseCostumeData(String costumeDataStr, ItemWindowHandle a_ItemHndl)
{
	local array<String> costumeListArray, costumeInfoArray;
	local int i, ItemId, nPriceId;
	local INT64 nPriceCnt;
	local ItemInfo CostumeItem;

	// weapons
	costumeListArray.Length = 0;
	Split( costumeDataStr, ",", costumeListArray);
	for ( i = 0 ; i < costumeListArray.Length ; i++ ) 
	{	
		costumeInfoArray.Length = 0;
		Split( costumeListArray[i], ";", costumeInfoArray);
		
		ItemId = int(costumeInfoArray[0]);
		nPriceId = int(costumeInfoArray[1]);
		nPriceCnt = INT64(costumeInfoArray[2]);

		// parse
		CostumeItem = GetItemInfoByClassID(ItemId);
		CostumeItem.Reserved = nPriceId;
		CostumeItem.Reserved64 = nPriceCnt;

		// add
		a_ItemHndl.AddItem(CostumeItem);
	}
}

function LoadItems()
{
	local int i;

	// load ini file
	for ( i = 0; i < 9; i++ )
	{
		if ( GetINIString( "Costumes", "WeaponList"$i, weaponCostumeList, "costumes.ini") )
		{
			 // weapons
			ParseCostumeData(weaponCostumeList, m_invenItem);
		}

		if ( GetINIString( "Costumes", "ArmorList"$i, armorCostumeList, "costumes.ini") )
		{
			// armors
			ParseCostumeData(armorCostumeList, m_invenItem_1);
		}

		if ( GetINIString( "Costumes", "ShieldList"$i, shieldCostumeList, "costumes.ini") )
		{
			// shields
			ParseCostumeData(shieldCostumeList, m_invenItem_2);
		}

		if ( GetINIString( "Costumes", "CloakList"$i, cloakCostumeList, "costumes.ini") )
		{
			// cloaks
			ParseCostumeData(cloakCostumeList, m_invenItem_3);
		}
	}
}

function bool CheckIfItemIsEquippable(ItemInfo m_selectedCostume)
{
	local ItemInfo EquippedItem;

	class'InventoryWnd'.static.Inst().GetEquippedWeaponItem(EquippedItem);

	// If Weapon is equipped
	if ( EquippedItem.ID.ServerID == 0 ) 
	{
		getInstanceL2Util().showGfxScreenMessage("Item is not equipped");
		return False;
	}

	return True;
}


function OnItemUpdateItem() 
{
	if( m_needItemScript.GetCanBuy() == False )
	{
		buyBtn.DisableWindow();
	} 
	else 
	{
		buyBtn.EnableWindow();
	}
}

function RefreshPriceItem(string param)
{
	local ItemID ID;
	local ItemInfo ItemInfo;
	local string Type;

	local int itemId;
	local INT64 itemCnt;
	
	if ( !Me.IsShowWindow() ) return;

	ParseItemID(param, ID);
	ParseString(param, "type", Type);

	if ( IsCoin(ID) ) 
	{
		m_needItemScript.refresh();
	}

}

function HandleBtnBuy()
{
	local ItemInfo m_selectedItemInfo;
	
	if ( m_selectedCostumeId != 0 ) 
	{
		m_selectedItemInfo = GetItemInfoByClassID(m_selectedCostumeId);
		DialogSetReservedItemID(m_selectedItemInfo.Id);
		DialogSetID(111);
		DialogShow(DialogModalType_Modalless,DialogType_OKCancel, GetSystemMessage(798), string(Self));
		class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOKBuy;
	}
}

function HandleBtnSet()
{
	local ItemInfo m_selectedItemInfo;
	
	if ( m_selectedCostumeId != 0 ) 
	{
		m_selectedItemInfo = GetItemInfoByClassID(m_selectedCostumeId);
		DialogSetReservedItemID(m_selectedItemInfo.Id);
		DialogSetID(222);
		DialogShow(DialogModalType_Modalless,DialogType_OKCancel, GetSystemMessage(798), string(Self));
		class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOKSet;
	}
}

function SetNextTexture()
{
	if ( nCurrTexture < 1 )
	{
		nCurrTexture = 1;
	}
	else if ( nCurrTexture > 5 )
	{
		nCurrTexture = 1;
	}

	m_ObjectViewport.SetBackgroundTex("L2UI_EPIC.CostumeWnd.CostumeWnd_DetailCharacter"$nCurrTexture);
	nCurrTexture++;
}

function OnClickButton( string Name )
{
	HideRemoveButton();

	switch( Name )
	{
		case "Reset_Btn":
			// SetNextTexture();
			RequestBypassToServer("multimperia?costume_preview reset");
			break;
		case "Wear_Btn":
			if ( m_selectedCostumeId != 0 ) 
			{
				RequestBypassToServer( "multimperia?costume_preview remove "$string(m_selectedCostumeId));
			}
			break;
		case "Buy_Btn":
			// if (!IsItemEquipped(m_selectedCostume))
			// {
			// 	getInstanceL2Util().showGfxScreenMessage(GetSystemString(14431));
			// 	return;
			// }
			if ( !CheckItemType(m_selectedCostume) )
			{
				getInstanceL2Util().showGfxScreenMessage("It is impossible to apply to this weapon");
				return;
			}
			if ( IsItemAlreadyOwnded(m_selectedCostume.Id) ) 
			{
				HandleBtnSet();
			}
			else
			{
				HandleBtnBuy();
			}
			break;
		case "CostumeTab0": // Armor
			buyBtn.SetButtonName(1119);
			buyBtn.SetTooltipText(GetSystemMessage(1119));
			m_invenItem.SetScrollPosition(0);
			break;
		case "CostumeTab1": // Weapon
			buyBtn.SetButtonName(1119);
			buyBtn.SetTooltipText(GetSystemMessage(1119));
			m_selectedItemTab = COSTUME_TAB_WEAPON;
			m_selectedItemWnd = m_invenItem_1;
			m_invenItem_1.SetScrollPosition(0);
			break;
		case "CostumeTab2": // Shield
			buyBtn.SetButtonName(1119);
			buyBtn.SetTooltipType("Text");
			buyBtn.SetTooltipText(GetSystemMessage(1119));
			m_selectedItemTab = COSTUME_TAB_SHIELD;
			m_selectedItemWnd = m_invenItem_2;
			m_invenItem_2.SetScrollPosition(0);
			break;
		case "CostumeTab3": // Cloak
			buyBtn.SetButtonName(1119);
			buyBtn.SetTooltipType("Text");
			buyBtn.SetTooltipText(GetSystemMessage(1119));
			m_selectedItemTab = COSTUME_TAB_CLOAK;
			m_selectedItemWnd = m_invenItem_3;
			m_invenItem_3.SetScrollPosition(0);
			break;
		case "CostumeTab4": // Bought
			buyBtn.SetButtonName(5907);
			buyBtn.SetTooltipType("Text");
			buyBtn.SetTooltipText(GetSystemMessage(5907));
			RequestBoughtCostumeList();
			m_selectedItemTab = COSTUME_TAB_BOUGHT;
			m_selectedItemWnd = m_invenItem_4;
			m_invenItem_4.SetScrollPosition(0);
			break;
	}
}

function HideRemoveButton()
{
	if ( wearBtn.IsShowWindow() ) 
	{
		wearBtn.HideWindow();
	}
	
	wearBtn.DisableWindow();
}

function ShowRemoveButton()
{
	if ( !wearBtn.IsShowWindow() ) 
	{
		wearBtn.ShowWindow();
	}

	wearBtn.EnableWindow();
}

function RequestBoughtCostumeList()
{
	RequestBypassToServer( "multimperia?costume_preview list");
}

// Preview Costume.
event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo	SelItemInfo;
	local ItemWindowHandle selectedTab;

	if ( ControlName != "InventoryItem_4" ) 
	{
		HideRemoveButton();
	}

	switch (ControlName)
	{
		case "InventoryItem":
			selectedTab = m_invenItem;
			buyBtn.SetButtonName(1119);
			buyBtn.SetTooltipType("Text");
			buyBtn.SetTooltipText(GetSystemMessage(1119));
			break;
		case "InventoryItem_1":
			selectedTab = m_invenItem_1;
			buyBtn.SetButtonName(1119);
			buyBtn.SetTooltipType("Text");
			buyBtn.SetTooltipText(GetSystemMessage(1119));
			break;
		case "InventoryItem_2":
			selectedTab = m_invenItem_2;
			buyBtn.SetButtonName(1119);
			buyBtn.SetTooltipType("Text");
			buyBtn.SetTooltipText(GetSystemMessage(1119));
			break;
		case "InventoryItem_3":
			selectedTab = m_invenItem_3;
			buyBtn.SetButtonName(1119);
			buyBtn.SetTooltipType("Text");
			buyBtn.SetTooltipText(GetSystemMessage(1119));
			break;
		case "InventoryItem_4":
			selectedTab = m_invenItem_4;
			buyBtn.SetButtonName(5907);
			buyBtn.SetTooltipType("Text");
			buyBtn.SetTooltipText(GetSystemMessage(5907));
			break;
	}

	// if is valid item info
	if( selectedTab.GetItem(Index, SelItemInfo) )
	{
		if ( ControlName == "InventoryItem_4" )
		{
			m_needItemScript.CleariObjects();
			// check if selected item is equipped
			if ( IsItemEquippedAsVis(SelItemInfo) ) 
			{
				ShowRemoveButton();
			} 
			else 
			{
				HideRemoveButton();
			}
		}
		else
		{
			m_needItemScript.StartNeedItemList(1);
			m_needItemScript.AddNeedItemClassID(SelItemInfo.Reserved, SelItemInfo.Reserved64);
			m_needItemScript.SetBuyNum(1);
		}
		
		m_selectedCostumeId = SelItemInfo.Id.ClassId;
		m_selectedCostume = SelItemInfo;
		m_ObjectViewport.ApplyPreviewCostumeItem(SelItemInfo.Id.ClassId);
		// SetNextTexture();
		RequestBypassToServer( "multimperia?costume_preview wear "$string(SelItemInfo.Id.ClassId));
	}
}

function HandleDialogOKBuy()
{
	RequestBypassToServer( "multimperia?costume_preview buy "$string(m_selectedCostume.Id.ClassId));
}

function HandleDialogOKSet()
{
	RequestBypassToServer( "multimperia?costume_preview set "$string(m_selectedCostume.Id.ClassId));
}
	
/********************************************************************************************
 * pawn 
 * ******************************************************************************************/
function HandleChangeCharacterPawn(string param)
{
	local UserInfo uInfo;
	ParseInt (param, "MeshType", m_MeshType);

	switch (m_MeshType)
	{
		case 0:
		  // �޸�_����_��
			m_ObjectViewport.SetCharacterScale(1.f);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-3);                                       
			break;
		case 1:
		  // �޸�_����_��
			m_ObjectViewport.SetCharacterScale(1.03f);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-5);                                       
			break;
		case 8:
		  // �޸�_����_��
			m_ObjectViewport.SetCharacterScale(1.047f);
			m_ObjectViewport.SetCharacterOffsetX(2);
			m_ObjectViewport.SetCharacterOffsetY(-5);                                       
			break;
		case 9:
		  // �޸�_����_��
			m_ObjectViewport.SetCharacterScale(1.07f);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-6);                                       
			break;
		case 6:
		  // ����_����_��
			m_ObjectViewport.SetCharacterScale(0.98f);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-4);                                       
			break;
		case 7:
		  // ����_����_��
			m_ObjectViewport.SetCharacterScale(1.04f);
			m_ObjectViewport.SetCharacterOffsetX(-4);
			m_ObjectViewport.SetCharacterOffsetY(-5);                                       
			break;
		  // case q
		  // ����_����_��
		  // SetCharacterOffsetX(-2);
		  // SetCharacterOffsetY(-4);
		  // ����_����_��
		  // SetCharacterOffsetX(-4);
		  // SetCharacterOffsetY(-5);
		case 2:
		  // �ٿ�_����_��
			m_ObjectViewport.SetCharacterScale(0.99f);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-4);                                       
			break;
		case 3:
		  // �ٿ�_����_��
			m_ObjectViewport.SetCharacterScale(1.015f);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		  // �ٿ�_����_��
		  // SetCharacterOffsetX(-1);
		  // SetCharacterOffsetY(-4);
		  // �ٿ�_����_��
		  // SetCharacterOffsetX(-1);
		  // SetCharacterOffsetY(-4);
		case 10:
			 // ��ũ_����_��                             
			 // End:0x2CF
			if( GetPlayerInfo(uInfo) )
			{
				 // End:0x297
				if( uInfo.Class == 217 )
				{
					m_ObjectViewport.SetCharacterScale(0.8030f);
					m_ObjectViewport.SetCharacterOffsetX(0);
					m_ObjectViewport.SetCharacterOffsetY(1);					
				}
				else
				{
					m_ObjectViewport.SetCharacterScale(0.9530f);
					m_ObjectViewport.SetCharacterOffsetX(0);
					m_ObjectViewport.SetCharacterOffsetY(-6);
				}
			}                                    
			break;
		case 11:
		  // ��ũ_����_��
			m_ObjectViewport.SetCharacterScale(0.97f);
			m_ObjectViewport.SetCharacterOffsetX(2);
			m_ObjectViewport.SetCharacterOffsetY(-5);                                       
			break;
		case 12:
		  // ��ũ_����_��
			m_ObjectViewport.SetCharacterScale(0.955f);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-5);                                       
			break;
		case 13:
		  // ��ũ_����_��
			m_ObjectViewport.SetCharacterScale(0.985f);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-5);                                       
			break;
		case 4:
		  // �����??_��
			m_ObjectViewport.SetCharacterScale(1.043f);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(1);                                       
			break;
		case 5:
		  // �����??_��
			m_ObjectViewport.SetCharacterScale(1.09f);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-3);                                       
			break;
		case 14:
			 // ī����_��
			m_ObjectViewport.SetCharacterScale(0.993f);
			m_ObjectViewport.SetCharacterOffsetX(-5);
			m_ObjectViewport.SetCharacterOffsetY(-4);                                       
			break;
		case 15:
			 // ī����_��
			m_ObjectViewport.SetCharacterScale(1.01f);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-3);                                       
			break;
		case 17:
			 // �Ƹ����̾�
			m_ObjectViewport.SetCharacterScale(1.015f);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			 // End:0x510
			break;
		case 18:
			m_ObjectViewport.SetCharacterScale(1.0150f);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			 // End:0x510
			break;
		 // End:0x50D
		case 19:
			m_ObjectViewport.SetCharacterScale(1.0150f);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			 // End:0x510
			break;
		default:
			m_ObjectViewport.SetCharacterScale(1.f);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);    
			break;       
	}
}

defaultproperties
{
	m_WindowName="CostumePreviewWnd"
}