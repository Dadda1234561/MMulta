class WorldExchangeRegiSubWnd extends UICommonAPI;

var ItemWindowHandle ItemWnd;

static function WorldExchangeRegiSubWnd Inst()
{
	return WorldExchangeRegiSubWnd(GetScript("WorldExchangeRegiSubWnd"));
}

function Initialize()
{
	ItemWnd = GetItemWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".itemEnchantSubWndItemWnd");
	GetTextBoxHandle(m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd.descTextBox").SetText(GetSystemMessage(4222));
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

event OnRClickItem(string ControlName, int Index)
{
	OnDBClickItem(ControlName, Index);
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo iInfo;

	ItemWnd.GetItem(Index, iInfo);
	iInfo.DragSrcName = "itemEnchantSubWndItemWnd";
	class'WorldExchangeRegiWnd'.static.Inst().OnDropItem("", iInfo, 0, 0);
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
				RefreshItemNum();
			}
			// End:0x2D
			break;
	}
}

function _Show()
{
	m_hOwnerWnd.ShowWindow();
	Refresh();
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
}

private function Refresh()
{
	SetSellItems();
}

private function RefreshItemNum();

function _ResetSellItem()
{
	local int idx;
	local ItemInfo iInfo, inveniInfo, sellItemInfo;

	class'WorldExchangeRegiWnd'.static.Inst()._GetSellItemInfo(sellItemInfo);
	// End:0x62
	if(! class'UIDATA_INVENTORY'.static.HasItem(sellItemInfo.Id.ServerID))
	{
		class'WorldExchangeRegiWnd'.static.Inst().DelItemInfo();
		Refresh();
		return;
	}
	class'UIDATA_INVENTORY'.static.FindItem(sellItemInfo.Id.ServerID, inveniInfo);
	idx = ItemWnd.FindItem(sellItemInfo.Id);
	// End:0xBE
	if(idx == -1)
	{
		Refresh();
		return;		
	}
	else
	{
		ItemWnd.GetItem(idx, iInfo);
		Refresh();
		return;
	}
	iInfo.ItemNum = inveniInfo.ItemNum - sellItemInfo.ItemNum;
	ItemWnd.SetItem(idx, iInfo);
}

function SetSellItems()
{
	local int i;
	local ItemInfo sellItemInfo;
	local array<ItemInfo> iInfos;

	ItemWnd.Clear();
	iInfos = GetAllItemInfo();
	class'WorldExchangeRegiWnd'.static.Inst()._GetSellItemInfo(sellItemInfo);

	// End:0x151 [Loop If]
	for(i = 0; i < iInfos.Length; i++)
	{
		if(IsAdena(iInfos[i].Id))
		{			
		}
		else if(! iInfos[i].bIsAuctionAble)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0xB9
		if(sellItemInfo.Id == iInfos[i].Id)
		{
			iInfos[i].ItemNum = iInfos[i].ItemNum - sellItemInfo.ItemNum;
		}
		// End:0xD5
		if(iInfos[i].ItemNum == 0)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0xEC
		if(iInfos[i].bSecurityLock)
		{
			// [Explicit Continue]
			continue;
		}
		// End:0x105
		if(iInfos[i].CurrentPeriod > 0)
		{
			// [Explicit Continue]
			continue;
		}
		iInfos[i].bShowCount = IsStackableItem(iInfos[i].ConsumeType);
		ItemWnd.AddItem(iInfos[i]);
	}
	SetDescTextBox();
}

function array<ItemInfo> GetAllItemInfo()
{
	local array<ItemInfo> allItem;

	class'UIDATA_INVENTORY'.static.GetAllInvenItem(allItem);
	return allItem;
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

defaultproperties
{
}
