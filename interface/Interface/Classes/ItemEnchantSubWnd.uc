class ItemEnchantSubWnd extends UICommonAPI;

enum SortOrder 
{
	non,
	up,
	Down
};

var TextureHandle SlotBg1_Texture;
var ItemWindowHandle ItemWnd;
var ItemEnchantSubWnd.SortOrder currentSortOrder;

static function ItemEnchantSubWnd Inst()
{
	return ItemEnchantSubWnd(GetScript("ItemEnchantSubWnd"));
}

function Initialize()
{
	ItemWnd = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".itemEnchantSubWndItemWnd");
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd.descTextBox").SetText(GetSystemMessage(4222));
	currentSortOrder = SortOrder.Down/*2*/;
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
	Refresh();
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo iInfo;

	ItemWnd.GetItem(Index, iInfo);
	class'ItemEnchantWnd'.static.Inst().RequestInputItemInfo(iInfo);
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		// End:0x2A
		case EV_AdenaInvenCount:
			// End:0x27
			if(m_hOwnerWnd.IsShowWindow())
			{
				Refresh();
			}
			// End:0x2D
			break;
	}
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		// End:0x1D
		case "sort_btn":
			ToggleSort();
			// End:0x20
			break;
	}
}

function ToggleSort()
{
	switch(currentSortOrder)
	{
		// End:0x17
		case SortOrder.up/*1*/:
			currentSortOrder = SortOrder.Down/*2*/;
			// End:0x25
			break;
		// End:0xFFFF
		default:
			currentSortOrder = SortOrder.up/*1*/;
			// End:0x25
			break;
	}
	Refresh();
}

function Refresh()
{
	switch(class'ItemEnchantWnd'.static.Inst().GetStateName())
	{
		// End:0x2C
		case class'ItemEnchantWnd'.const.STATE_NONE:
			// End:0xB8
			break;
		// End:0x57
		case class'ItemEnchantWnd'.const.STATE_READY_SCROLL:
			SetTitle(GetSystemString(1532));
			SetScrollItemWnds();
			// End:0xB8
			break;
		// End:0x68
		case class'ItemEnchantWnd'.const.STATE_READY_EQUIPMENT:
		// End:0x79
		case class'ItemEnchantWnd'.const.STATE_READY_SUPPORT:
		// End:0x8A
		case class'ItemEnchantWnd'.const.STATE_READY_SUPPORT_STONE:
		// End:0xB5
		case class'ItemEnchantWnd'.const.STATE_READY_SUPPORT_SYSTEM:
			SetTitle(GetSystemString(13846));
			SetEnchantableItems();
			// End:0xB8
			break;
	}
	SetDescTextBox();
}

function SetScrollItemWnds()
{
	local int i;
	local array<ItemInfo> iInfos;

	ItemWnd.Clear();
	class'UIDATA_INVENTORY'.static.GetAllItem(iInfos);

	// End:0xA1 [Loop If]
	for(i = 0; i < iInfos.Length; i++)
	{
		// End:0x97
		if(IsEnchantScroll(EEtcItemType(iInfos[i].EtcItemType)))
		{
			iInfos[i].bShowCount = IsStackableItem(EEtcItemType(iInfos[i].ConsumeType));
			ItemWnd.AddItem(iInfos[i]);
		}
	}
}

function SetEnchantableItems()
{
	local int i, enchantMax, enchantMin;
	local ItemInfo iInfo;
	local array<ItemInfo> iInfos;
	local array<ItemInfo> allItemInfos;
	
	enchantMax = class'ItemEnchantWnd'.static.Inst().GetEnchantMax();
	enchantMin = class'ItemEnchantWnd'.static.Inst()._GetEnchantMin();
	ItemWnd.Clear();
	class'UIDATA_INVENTORY'.static.GetAllEnchantableInvenItem(GetIteminfoScroll().Id.ClassID, iInfos);
	
	if (GetIteminfoScroll().Id.ClassID == 90995) {
		class'UIDATA_INVENTORY'.static.GetAllItem(allItemInfos);
		for (i = 0; i < allItemInfos.Length; i++) {
			if (allItemInfos[i].Id.ClassID == 90993 || allItemInfos[i].Id.ClassID == 90994 || allItemInfos[i].Id.ClassID == 91006 || allItemInfos[i].Id.ClassID == 141055 || allItemInfos[i].Id.ClassID == 141056 || allItemInfos[i].Id.ClassID == 141057) {
				iInfos[iInfos.Length] = allItemInfos[i];
			}
		}
		enchantMax = 10;
	}	
	
	Debug(" 강화 가능 아이템 수량 SetEnchantableItems" @ string(GetIteminfoScroll().Id.ClassID) @ string(iInfos.Length) @ string(enchantMax) @ string(enchantMin));
	iInfo = GetItemInfoEquipment();
	iInfos.Sort(OnSortProbCompare);
	iInfos.Sort(OnSortNameCompare);

	// End:0x12A [Loop If]
	for(i = 0; i < iInfos.Length; i++)
	{
		// End:0xB0
		if(iInfo.Id == iInfos[i].Id)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0xDE
		if((iInfos[i].Enchanted > enchantMax) && enchantMax > -1)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x18D
		if((iInfos[i].Enchanted < enchantMin) && enchantMin > -1)
		{
			// [Explicit Continue]
			continue;
		}
		iInfos[i].bShowCount = IsStackableItem(iInfos[i].ConsumeType);
		ItemWnd.AddItem(iInfos[i]);
	}
}

function array<ItemInfo> GetSupportItems()
{
	local int i, supportClassID;
	local array<ItemInfo> iInfos, iInfosSupport;

	supportClassID = GetScrollInfoSupport().Id.ClassID;
	class'UIDATA_INVENTORY'.static.GetAllItem(iInfos);

	// End:0xC5 [Loop If]
	for(i = 0; i < iInfos.Length; i++)
	{
		// End:0x61
		if(! IsIncPropItem(EEtcItemType(iInfos[i].EtcItemType)))
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x81
		if(! CheckMatchSupportItem(EEtcItemType(iInfos[i].EtcItemType)))
		{
			// [Explicit Continue]
			continue;
		}
		// End:0xA3
		if(iInfos[i].Id.ClassID == supportClassID)
		{
			// [Explicit Continue]
			continue;
		}
		iInfosSupport[iInfosSupport.Length] = iInfos[i];
	}
	return iInfosSupport;
}

function SetSupportItems(ItemWindowHandle supportItemWnd)
{
	local int i;
	local array<ItemInfo> iInfos;

	supportItemWnd.Clear();
	// End:0x2F
	if(! class'ItemEnchantWnd'.static.Inst().UseSupportSlot())
	{
		return;
	}
	iInfos = GetSupportItems();

	// End:0x9E [Loop If]
	for(i = 0; i < iInfos.Length; i++)
	{
		iInfos[i].bShowCount = IsStackableItem(iInfos[i].ConsumeType);
		supportItemWnd.AddItem(iInfos[i]);
	}
}

function SetDescTextBox()
{
	// End:0x4C
	if(ItemWnd.GetItemNum() == 0)
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd").ShowWindow();		
	}
	else
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd").HideWindow();
	}
}

function SetTitle(string Title)
{
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMaterialTitle_Txt").SetText(Title);
}

function bool IsEnchantableItem(EItemParamType Type)
{
	return Type == ITEMP_WEAPON || Type == ITEMP_ARMOR || Type == ITEMP_ACCESSARY || Type == ITEMP_SHIELD;
}

function bool IsIncPropItem(EEtcItemType Type)
{
	return Type == ITEME_ENCHT_ATTR_INC_PROP_ENCHT_AM || Type == ITEME_ENCHT_ATTR_INC_PROP_ENCHT_WP || Type == ITEME_BLESS_INC_PROP_ENCHT_WP || Type == ITEME_BLESS_INC_PROP_ENCHT_AM || Type == ITEME_MULTI_INC_PROB_ENCHT_WP || Type == ITEME_MULTI_INC_PROB_ENCHT_AM || Type == ITEME_POLY_INC_ENCHANT_PROP_WP || Type == ITEME_POLY_INC_ENCHANT_PROP_AM;
}

function bool IsEnchantScroll(EEtcItemType Type)
{
	return Type == ITEME_ENCHT_WP || Type == ITEME_ENCHT_AM || Type == ITEME_BLESS_ENCHT_WP || Type == ITEME_BLESS_ENCHT_AM || Type == ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_AM || Type == ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_WP || Type == ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM || Type == ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP || Type == ITEME_MULTI_ENCHT_WP || Type == ITEME_MULTI_ENCHT_AM || Type == ITEME_ENCHT_AG || Type == ITEME_BLESS_ENCHT_AG || Type == ITEME_MULTI_ENCHT_AG || Type == ITEME_ANCIENT_CRYSTAL_ENCHANT_AG || Type == ITEME_CURSED_ENCHANT_AM || Type == ITEME_CURSED_ENCHANT_WP || Type == ITEME_POLY_ENCHANT_WP || Type == ITEME_POLY_ENCHANT_AM || Type == ITEME_SPECIAL_ENCHT_WP || Type == ITEME_SPECIAL_ENCHT_AM;
}

function bool CheckMatchSupportItem(EEtcItemType supportSubType)
{
	local EEtcItemType scrollSubType;

	return true;
	scrollSubType = EEtcItemType(GetIteminfoScroll().EtcItemType);
	switch(supportSubType)
	{
		// End:0x2F
		case ITEME_BLESS_INC_PROP_ENCHT_WP:
			return scrollSubType == ITEME_BLESS_ENCHT_WP;
		// End:0x42
		case ITEME_BLESS_INC_PROP_ENCHT_AM:
			return scrollSubType == ITEME_BLESS_ENCHT_AM;
		// End:0x55
		case ITEME_MULTI_INC_PROB_ENCHT_WP:
			return scrollSubType == ITEME_MULTI_ENCHT_WP;
		// End:0x68
		case ITEME_MULTI_INC_PROB_ENCHT_AM:
			return scrollSubType == ITEME_MULTI_ENCHT_AM;
		// End:0x7B
		case ITEME_POLY_INC_ENCHANT_PROP_WP:
			return scrollSubType == ITEME_POLY_ENCHANT_WP;
		// End:0x8E
		case ITEME_POLY_INC_ENCHANT_PROP_AM:
			return scrollSubType == ITEME_POLY_ENCHANT_AM;
		// End:0xFFFF
		default:
			return false;
	}
}

function ItemInfo GetIteminfoScroll()
{
	local ItemInfo scrollItem;

	class'ItemEnchantWnd'.static.Inst().scrollItemWindow.GetItem(0, scrollItem);
	return scrollItem;
}

function ItemInfo GetItemInfoEquipment()
{
	local ItemInfo equipmentItem;

	class'ItemEnchantWnd'.static.Inst().equipmentItemWindow.GetItem(0, equipmentItem);
	return equipmentItem;
}

function ItemInfo GetScrollInfoSupport()
{
	local ItemInfo supportiInfo;

	class'ItemEnchantWnd'.static.Inst().supportItemWindow.GetItem(0, supportiInfo);
	return supportiInfo;
}

delegate int OnSortNameCompare(ItemInfo A, ItemInfo B)
{
	switch(currentSortOrder)
	{
		// End:0x0E
		case SortOrder.non/*0*/:
			return 0;
		// End:0x46
		case SortOrder.up/*1*/:
			// End:0x43
			if(float(A.Id.ClassID) > float(B.Id.ClassID))
			{
				return -1;				
			}
			else
			{
				// End:0x81
				break;
			}
		// End:0x7E
		case SortOrder.Down/*2*/:
			// End:0x7B
			if(float(A.Id.ClassID) < float(B.Id.ClassID))
			{
				return -1;				
			}
			else
			{
				// End:0x81
				break;
			}
	}
	return 0;
}

delegate int OnSortProbCompare(ItemInfo A, ItemInfo B)
{
	switch(currentSortOrder)
	{
		// End:0x0E
		case SortOrder.non/*0*/:
			return 0;
		// End:0x3C
		case SortOrder.up/*1*/:
			// End:0x39
			if(float(A.Enchanted) > float(B.Enchanted))
			{
				return -1;				
			}
			else
			{
				// End:0x6D
				break;
			}
		// End:0x6A
		case SortOrder.Down/*2*/:
			// End:0x67
			if(float(A.Enchanted) < float(B.Enchanted))
			{
				return -1;				
			}
			else
			{
				// End:0x6D
				break;
			}
	}
	return 0;
}

defaultproperties
{
}
