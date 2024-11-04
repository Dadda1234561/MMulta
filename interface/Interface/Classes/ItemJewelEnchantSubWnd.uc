/**
 *  ЗХјє UI єёБ¶Гў
 **/
class ItemJewelEnchantSubWnd extends UICommonAPI;

var TextureHandle SlotBg1_Texture;
var ItemWindowHandle itemJewelEnchantSubWnd_ItemWnd;
var array<ItemInfo> itemInfoArray;
var ButtonHandle ItemAddBtn;
var ItemJewelEnchantWnd itemJewelEnchantWndScript;

static function ItemJewelEnchantSubWnd Inst()
{
	return ItemJewelEnchantSubWnd(GetScript("ItemJewelEnchantSubWnd"));
}

function Initialize()
{
	itemJewelEnchantSubWnd_ItemWnd = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemJewelEnchantSubWnd_ItemWnd");
	ItemAddBtn = GetButtonHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemAddBtn");
	ItemAddBtn.DisableWindow();
	itemJewelEnchantWndScript = ItemJewelEnchantWnd(GetScript("ItemJewelEnchantWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(EV_AdenaInvenCount);
}

event OnLoad()
{
	Initialize();
}

event OnShow()
{
	_Refresh();
}

event OnHide()
{
	itemJewelEnchantSubWnd_ItemWnd.Clear();
	SetDescTextBox();
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x1F
		case "itemAddBtn":
			MoveAll();
			// End:0x22
			break;
	}	
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;

	// End:0x14
	if(itemJewelEnchantWndScript._IsWorkingEnchant())
	{
		return;
	}
	itemJewelEnchantSubWnd_ItemWnd.GetItem(Index, Info);
	// End:0x57
	if(Info.Id.ClassID > 0)
	{
		itemJewelEnchantWndScript._DropProcess(Info, 0);
	}
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x3E
		case EV_AdenaInvenCount:
			// End:0x3B
			if(m_hOwnerWnd.IsShowWindow())
			{
				// End:0x46
				if(itemJewelEnchantWndScript.GetStateName() != itemJewelEnchantWndScript.const.STATE_RESULT)
				{
					_Refresh();
				}
			}
			// End:0x4C
			break;
	}
}

function _Refresh()
{
	local int i;
	local INT64 nCommissionAdena;
	local CombinationItemUIData o_data;

	// End:0x1F
	if(! itemJewelEnchantWndScript.m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	itemJewelEnchantSubWnd_ItemWnd.Clear();
	SetDescTextBox();
	ItemAddBtn.DisableWindow();
	// End:0xA6
	if(IsAutoMode())
	{
		// End:0xA6
		if(GetOwnerStateName() == class'ItemJewelEnchantWnd'.const.STATE_ALLREADY)
		{
			ItemAddBtn.EnableWindow();
			// End:0xA6
			if(API_GetCombinationItemData(o_data))
			{
				// End:0xA6
				if(o_data.AutomaticType == 0)
				{
					ItemAddBtn.DisableWindow();
					return;
				}
			}
		}
	}
	// End:0x15F
	if(_GetCanEnchantItemCurrent(nCommissionAdena, itemInfoArray))
	{
		// End:0x119
		if((GetOwnerStateName()) == itemJewelEnchantWndScript.const.STATE_READY)
		{
			// End:0x119
			if(class'ItemJewelEnchantWnd'.static.Inst().currentEnchantType == class'ItemJewelEnchantWnd'.static.Inst().EnchantType.dye)
			{
				itemInfoArray = GetDyeCombines(itemInfoArray);
			}
		}
		itemInfoArray.Sort(DelegateSortCompare);

		// End:0x15F [Loop If]
		for(i = 0; i < itemInfoArray.Length; i++)
		{
			itemJewelEnchantSubWnd_ItemWnd.AddItem(itemInfoArray[i]);
		}
	}
	SetDescTextBox();	
}

function bool _GetCanEnchantItemCurrent(out INT64 nCommissionAdena, out array<ItemInfo> MaterialItems)
{
	local int slot1_ClassID, slot2_ClassID, slot1_Enchanted, slot2_Enchanted;

	slot1_ClassID = itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(1);
	slot1_Enchanted = itemJewelEnchantWndScript._GetEnchantedBySlotItemIndex(1);
	slot2_ClassID = itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(2);
	slot2_Enchanted = itemJewelEnchantWndScript._GetEnchantedBySlotItemIndex(2);
	switch(GetOwnerStateName())
	{
		// End:0xA5
		case class'ItemJewelEnchantWnd'.const.STATE_READY:
			API_GetMaterialItemForEnchantFromInven(-1, -1, -1, -1, nCommissionAdena, MaterialItems);
			CheckNDisableItemInfo(MaterialItems);
			// End:0x148
			break;
		// End:0xDD
		case class'ItemJewelEnchantWnd'.const.STATE_ONEREADY:
			API_GetMaterialItemForEnchantFromInven(slot1_ClassID, slot1_Enchanted, -1, -1, nCommissionAdena, MaterialItems);
			// End:0x148
			break;
		// End:0x145
		case class'ItemJewelEnchantWnd'.const.STATE_ALLREADY:
			// End:0x11E
			if(IsAutoMode())
			{
				API_GetMaterialItemForEnchantFromInven(slot1_ClassID, slot1_Enchanted, slot2_ClassID, slot2_Enchanted, nCommissionAdena, MaterialItems);				
			}
			else
			{
				API_GetMaterialItemForEnchantFromInven(slot1_ClassID, slot1_Enchanted, -1, -1, nCommissionAdena, MaterialItems);
			}
			// End:0x148
			break;
	}
	return MaterialItems.Length > 0;	
}

private function CheckNDisableItemInfo(out array<ItemInfo> MaterialItems)
{
	local int i;
	local INT64 nCommissionAdenaSlot2;
	local array<ItemInfo> materialItemSlot2;

	// End:0x75 [Loop If]
	for(i = 0; i < MaterialItems.Length; i++)
	{
		materialItemSlot2.Length = 0;
		// End:0x6B
		if(! _CanEnchatItem(MaterialItems[i].Id.ClassID, MaterialItems[i].Enchanted, nCommissionAdenaSlot2, materialItemSlot2))
		{
			MaterialItems[i].bDisabled = 1;
		}
	}	
}

function bool _CheckCanEnchatItem(int ClassID, int Enchanted)
{
	local array<ItemInfo> MaterialItems;
	local INT64 nCommissionAdena;

	return _CanEnchatItem(ClassID, Enchanted, nCommissionAdena, MaterialItems);	
}

function bool _CanEnchatItem(int slot1ClassID, int Enchanted, out INT64 nCommissionAdena, out array<ItemInfo> MaterialItems)
{
	local array<ItemInfo> iInfos;

	MaterialItems.Length = 0;
	nCommissionAdena = 0;
	// End:0x54
	if(slot1ClassID != 0)
	{
		// End:0x3D
		if(class'UIDATA_INVENTORY'.static.FindItemByClassID(slot1ClassID, iInfos) < 1)
		{
			return false;
		}
		// End:0x54
		if(iInfos[0].ItemNum < 1)
		{
			return false;
		}
	}
	API_GetMaterialItemForEnchantFromInven(GetSlotClassID(slot1ClassID), Enchanted, -1, -1, nCommissionAdena, MaterialItems);
	// End:0x99
	if(slot1ClassID == 0)
	{
		CheckNDisableItemInfo(MaterialItems);
		return false;		
	}
	else
	{
		CheckNRemoveSameClassid(slot1ClassID, Enchanted, MaterialItems);
	}
	return MaterialItems.Length > 0;	
}

// desc јіён
private function SetDescTextBox()
{
	local CombinationItemUIData o_data;

	// End:0x61
	if(itemJewelEnchantSubWnd_ItemWnd.GetItemNum() == 0)
	{
		ItemAddBtn.DisableWindow();
		GetWindowHandle("ItemJewelEnchantSubWnd.DescriptionMsgWnd").ShowWindow();		
	}
	else
	{
		GetWindowHandle("ItemJewelEnchantSubWnd.DescriptionMsgWnd").HideWindow();
	}
	// End:0x10F
	if(API_GetCombinationItemData(o_data))
	{
		// End:0x10F
		if(o_data.AutomaticType == 0)
		{
			GetTextBoxHandle("ItemJewelEnchantSubWnd.DescriptionMsgWnd.descTextBox").SetText(GetSystemMessage(13729));
			return;
		}
	}
	GetTextBoxHandle("ItemJewelEnchantSubWnd.DescriptionMsgWnd.descTextBox").SetText(GetSystemMessage(4222));	
}

private function int API_GetEnchantCandidateMaterialList(int ClassID, out array<int> CandidateMaterials)
{
	class'NewEnchantAPI'.static.GetEnchantCandidateMaterialList(ClassID, CandidateMaterials);
	return CandidateMaterials.Length;	
}

private function bool API_GetCombinationItemData(out CombinationItemUIData o_data)
{
	// End:0x1C
	if(itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(1) == -1)
	{
		return false;
	}
	// End:0x39
	if(itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(2) == -1)
	{
		return false;
	}
	return class'NewEnchantAPI'.static.GetCombinationItemData(itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(1), itemJewelEnchantWndScript._GetEnchantedBySlotItemIndex(1), itemJewelEnchantWndScript._GetClassIDBySlotItemIndex(2), itemJewelEnchantWndScript._GetEnchantedBySlotItemIndex(2), o_data);	
}

private function API_GetMaterialItemForEnchantFromInven(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out INT64 Commission, out array<ItemInfo> MaterialItems)
{
	local int i;

	MaterialItems.Length = 0;
	// End:0x4C
	if(getInstanceUIData().getIsClassicServer())
	{
		class'NewEnchantAPI'.static.GetMaterialItemForEnchantFromInven(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems, 1);		
	}
	else
	{
		class'NewEnchantAPI'.static.GetMaterialItemForEnchantFromInven(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems);
	}
	CheckNRemoveSlots(MaterialItems);
	CheckNRemoveSameAutoInventory(MaterialItems);

	// End:0xD8 [Loop If]
	for(i = 0; i < MaterialItems.Length; i++)
	{
		MaterialItems[i].bShowCount = IsStackableItem(MaterialItems[i].ConsumeType);
	}	
}

private function API_GetMaterialItemForEnchantFromEquip(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out INT64 Commission, out array<ItemInfo> MaterialItems)
{
	// End:0x44
	if(getInstanceUIData().getIsClassicServer())
	{
		class'NewEnchantAPI'.static.GetMaterialItemForEnchantFromEquip(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems, 1);		
	}
	else
	{
		class'NewEnchantAPI'.static.GetMaterialItemForEnchantFromEquip(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems);
	}
}

private function int GetSlotClassID(int nClassID)
{
	// End:0x11
	if(nClassID > 0)
	{
		return nClassID;
	}
	return -1;
}

private function name GetOwnerStateName()
{
	return class'ItemJewelEnchantWnd'.static.Inst().GetStateName();	
}

private function array<ItemInfo> GetDyeCombines(array<ItemInfo> iInfos)
{
	local int i;
	local DyeCombinationUIData o_data;
	local array<ItemInfo> dyeCombines;

	// End:0x171 [Loop If]
	for(i = 0; i < iInfos.Length; i++)
	{
		// End:0x167
		if(class'UIDATA_HENNA'.static.GetDyeCombinationData(iInfos[i].Id.ClassID, o_data))
		{
			dyeCombines[dyeCombines.Length] = iInfos[i];
		}
	}
	return dyeCombines;
}

private function CheckNRemoveSlotSlotIndex(int SlotIndex, out array<ItemInfo> MaterialItems)
{
	local int i, ServerID, Enchanted;

	ServerID = itemJewelEnchantWndScript._GetServerIDBySlotItemIndex(SlotIndex);
	Enchanted = itemJewelEnchantWndScript._GetEnchantedBySlotItemIndex(SlotIndex);
	// End:0x45
	if(ServerID == -1)
	{
		return;
	}

	// End:0xEF [Loop If]
	for(i = 0; i < MaterialItems.Length; i++)
	{
		// End:0xE5
		if(MaterialItems[i].Id.ServerID == ServerID && MaterialItems[i].Enchanted == Enchanted)
		{
			MaterialItems[i].ItemNum = MaterialItems[i].ItemNum - 1;
			// End:0xE3
			if(MaterialItems[i].ItemNum == 0)
			{
				MaterialItems.Remove(i, 1);
			}
			return;
		}
	}	
}

private function CheckNRemoveSlots(out array<ItemInfo> MaterialItems)
{
	switch(GetOwnerStateName())
	{
		// End:0x28
		case class'ItemJewelEnchantWnd'.const.STATE_ONEREADY:
			CheckNRemoveSlotSlotIndex(1, MaterialItems);
			// End:0x85
			break;
		// End:0x55
		case class'ItemJewelEnchantWnd'.const.STATE_ALLREADY:
			CheckNRemoveSlotSlotIndex(1, MaterialItems);
			CheckNRemoveSlotSlotIndex(2, MaterialItems);
			// End:0x85
			break;
		// End:0x82
		case class'ItemJewelEnchantWnd'.const.STATE_PROCESS:
			CheckNRemoveSlotSlotIndex(1, MaterialItems);
			CheckNRemoveSlotSlotIndex(2, MaterialItems);
			// End:0x85
			break;
	}	
}

private function CheckNRemoveSameClassid(int ClassID, int Enchanted, out array<ItemInfo> MaterialItems)
{
	local int i;

	// End:0xAA [Loop If]
	for(i = 0; i < MaterialItems.Length; i++)
	{
		// End:0xA0
		if((MaterialItems[i].Id.ClassID == ClassID) && MaterialItems[i].Enchanted == Enchanted)
		{
			MaterialItems[i].ItemNum = MaterialItems[i].ItemNum - 1;
			// End:0x9E
			if(MaterialItems[i].ItemNum == 0)
			{
				MaterialItems.Remove(i, 1);
			}
			return;
		}
	}
}

private function CheckNRemoveSameAutoInventory(out array<ItemInfo> MaterialItems)
{
	local int i, j, Len;
	local ItemInfo iInfo;

	Len = class'ItemJewelEnchantWnd'.static.Inst().InventoryItem.GetItemNum();

	// End:0x131 [Loop If]
	for(j = 0; j < Len; j++)
	{
		// End:0x127
		if(class'ItemJewelEnchantWnd'.static.Inst().InventoryItem.GetItem(j, iInfo))
		{
			// End:0x127 [Loop If]
			for(i = 0; i < MaterialItems.Length; i++)
			{
				// End:0x11D
				if(iInfo.Id == MaterialItems[i].Id && iInfo.Enchanted == MaterialItems[i].Enchanted)
				{
					MaterialItems[i].ItemNum = MaterialItems[i].ItemNum - iInfo.ItemNum;
					// End:0x11A
					if(MaterialItems[i].ItemNum < 1)
					{
						MaterialItems.Remove(i, 1);
					}
					// [Explicit Break]
					break;
				}
			}
		}
	}	
}

function int GetIndexSubIvenItem(int ClassID)
{
	local ItemInfo Info;
	local int ItemNum, i;

	ItemNum = itemJewelEnchantSubWnd_ItemWnd.GetItemNum();

	// End:0x6D [Loop If]
	for(i = 0; i < ItemNum; i++)
	{
		itemJewelEnchantSubWnd_ItemWnd.GetItem(i, Info);
		// End:0x63
		if(Info.Id.ClassID == ClassID)
		{
			return i;
		}
	}
	return -1;
}

delegate int DelegateSortCompare(ItemInfo A, ItemInfo B)
{
	// End:0x2C
	if(A.Id.ClassID > B.Id.ClassID) // їАё§ Вчјш. Б¶°З№®їЎ < АМёй і»ёІВчјш.
	{
		return -1; // АЪё®ё¦ №ЩІгѕЯЗТ¶§ -1ё¦ ё®ЕП ЗП°Ф ЗФ.
	}
	else
	{
		return 0;
	}	
}

function MoveAll()
{
	local int i, Len;
	local ItemInfo iInfo;

	Len = itemJewelEnchantSubWnd_ItemWnd.GetItemNum();

	// End:0x62 [Loop If]
	for(i = 0; i < Len; i++)
	{
		itemJewelEnchantSubWnd_ItemWnd.GetItem(i, iInfo);
		itemJewelEnchantWndScript._AddInventoryItem(iInfo);
	}
	itemJewelEnchantWndScript._SortItemInventory();
	itemJewelEnchantSubWnd_ItemWnd.Clear();
	SetDescTextBox();	
}

function bool _MoveToOwner(ItemInfo iInfo, optional INT64 ItemNum)
{
	local int i, idx, Len;
	local ItemInfo iiInfo;

	// End:0xCC
	if(IsStackableItem(iInfo.ConsumeType))
	{
		idx = itemJewelEnchantSubWnd_ItemWnd.FindItem(iInfo.Id);
		// End:0x43
		if(idx == -1)
		{
			return false;
		}
		// End:0x6F
		if(iInfo.ItemNum == ItemNum)
		{
			itemJewelEnchantSubWnd_ItemWnd.DeleteItem(idx);			
		}
		else
		{
			iInfo.ItemNum = iInfo.ItemNum - ItemNum;
			itemJewelEnchantSubWnd_ItemWnd.SetItem(idx, iInfo);
		}
		iInfo.ItemNum = ItemNum;
		itemJewelEnchantWndScript._AddInventoryItem(iInfo);		
	}
	else
	{
		Len = itemJewelEnchantSubWnd_ItemWnd.GetItemNum();

		// End:0x1A3 [Loop If]
		for(i = Len - 1; i >= 0; i--)
		{
			itemJewelEnchantSubWnd_ItemWnd.GetItem(i, iiInfo);
			// End:0x199
			if(iInfo.Id.ClassID == iiInfo.Id.ClassID)
			{
				// End:0x199
				if(iInfo.Enchanted == iiInfo.Enchanted)
				{
					itemJewelEnchantSubWnd_ItemWnd.DeleteItem(i);
					itemJewelEnchantWndScript._AddInventoryItem(iiInfo);
					ItemNum = ItemNum - 1;
					// End:0x199
					if(ItemNum == 0)
					{
						// [Explicit Break]
						break;
					}
				}
			}
		}
	}
	itemJewelEnchantWndScript._SortItemInventory();
	SetDescTextBox();
	return true;	
}

function bool _GetSlot1ItemInfo(out ItemInfo iInfo)
{
	return itemJewelEnchantWndScript._GetSlot1ItemInfo(iInfo);	
}

function bool _GetSlot2ItemInfo(out ItemInfo iInfo)
{
	return itemJewelEnchantWndScript._GetSlot2ItemInfo(iInfo);	
}

function INT64 _GetIneventoryItemNum(ItemInfo iInfo)
{
	local int i, idx;
	local INT64 ItemNum;
	local ItemInfo iiInfo;

	// End:0x71
	if(IsStackableItem(iInfo.ConsumeType))
	{
		idx = itemJewelEnchantSubWnd_ItemWnd.FindItem(iInfo.Id);
		// End:0x45
		if(idx == -1)
		{
			return 0;
		}
		itemJewelEnchantSubWnd_ItemWnd.GetItem(idx, iiInfo);
		ItemNum = iiInfo.ItemNum;		
	}
	else
	{
		// End:0x117 [Loop If]
		for(i = 0; i < itemJewelEnchantSubWnd_ItemWnd.GetItemNum(); i++)
		{
			// End:0xB9 [Loop If]
			while(! itemJewelEnchantSubWnd_ItemWnd.GetItem(i, iiInfo))
			{
				idx++;
			}
			idx++;
			// End:0x10D
			if(iInfo.Id.ClassID == iiInfo.Id.ClassID)
			{
				// End:0x10D
				if(iInfo.Enchanted == iiInfo.Enchanted)
				{
					ItemNum = ItemNum + 1;
				}
			}
		}
	}
	return ItemNum;	
}

private function bool IsAutoMode()
{
	return class'ItemJewelEnchantWnd'.static.Inst()._IsAutoMode();	
}

defaultproperties
{
}
