class ItemMultiEnchantSubWnd extends UICommonAPI;

enum SortOrder 
{
	non,
	up,
	Down
};

var ItemWindowHandle ItemWnd;
var SortOrder currentSortOrder;

static function ItemMultiEnchantSubWnd Inst()
{
	return ItemMultiEnchantSubWnd(GetScript("ItemMultiEnchantSubWnd"));
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
	switch(class'ItemMultiEnchantWnd'.static.Inst().GetStateName())
	{
		// End:0x63
		case class'ItemMultiEnchantWnd'.const.STATE_READY_SCROLL:
			class'ItemMultiEnchantWnd'.static.Inst().RQ_C_EX_REQ_START_MULTI_ENCHANT_SCROLL(iInfo);
			// End:0x98
			break;
		// End:0x95
		case class'ItemMultiEnchantWnd'.const.STATE_READY_EQUIPMENT:
			class'ItemMultiEnchantWnd'.static.Inst().SetSlotEmpty(iInfo);
			// End:0x98
			break;
	}
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
	switch(class'ItemMultiEnchantWnd'.static.Inst().GetStateName())
	{
		// End:0x2C
		case class'ItemMultiEnchantWnd'.const.STATE_NONE:
			// End:0x85
			break;
		// End:0x57
		case class'ItemMultiEnchantWnd'.const.STATE_READY_SCROLL:
			SetTitle(GetSystemString(1532));
			SetScrollItemWnds();
			// End:0x85
			break;
		// End:0x82
		case class'ItemMultiEnchantWnd'.const.STATE_READY_EQUIPMENT:
			SetTitle(GetSystemString(13846));
			SetEnchantableItems();
			// End:0x85
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
		if(IsNormalEnchantScroll(EEtcItemType(iInfos[i].EtcItemType)))
		{
			iInfos[i].bShowCount = IsStackableItem(iInfos[i].ConsumeType);
			ItemWnd.AddItem(iInfos[i]);
		}
	}
}

function Show()
{
	m_hOwnerWnd.ShowWindow();
	Refresh();
}

function Hide()
{
	m_hOwnerWnd.HideWindow();
}

function SetEnchantableItems()
{
	local int i, enchantMax;
	local array<ItemInfo> iInfos;

	local array<ItemInfo> allItemInfos;

	enchantMax = Min(class'ItemMultiEnchantWnd'.static.Inst().GetEnchantMax(), class'ItemMultiEnchantWnd'.static.Inst().const.MAX_TRY);

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
	
	Debug(" 강화 가능 아이템 수량 SetEnchantableItems" @ string(GetIteminfoScroll().Id.ClassID) @ string(iInfos.Length) @ string(Min(class'ItemMultiEnchantWnd'.static.Inst().GetEnchantMax(), class'ItemMultiEnchantWnd'.static.Inst().const.MAX_TRY)));
	iInfos.Sort(OnSortProbCompare);
	iInfos.Sort(OnSortNameCompare);

	// End:0x1EB [Loop If]
	for(i = 0; i < iInfos.Length; i++)
	{
		Debug(("뭐지??? 뭐가 문제냐? " @ string(i)) @ iInfos[i].Name);
		// End:0x157
		if(class'ItemMultiEnchantWnd'.static.Inst().FindIndexEquipmentWithServerID(iInfos[i].Id.ServerID) > -1)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x19F
		if(iInfos[i].Enchanted > enchantMax)
		{
			// [Explicit Continue]
			continue;
		}
		iInfos[i].bShowCount = IsStackableItem(iInfos[i].ConsumeType);
		ItemWnd.AddItem(iInfos[i]);
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

function bool IsNormalEnchantScroll(EEtcItemType Type)
{
	return Type == ITEME_ENCHT_WP || Type == ITEME_ENCHT_AM || Type == ITEME_ENCHT_AG;
}

function ItemInfo GetIteminfoScroll()
{
	local ItemInfo scrollItem;

	class'ItemMultiEnchantWnd'.static.Inst().scrollItemWindow.GetItem(0, scrollItem);
	return scrollItem;
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
