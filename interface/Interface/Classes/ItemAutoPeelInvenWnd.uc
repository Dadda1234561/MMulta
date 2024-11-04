class ItemAutoPeelInvenWnd extends UICommonAPI
	dependson(ItemAutoPeelWnd);

var WindowHandle Me;
var ItemWindowHandle ItemWnd;

static function ItemAutoPeelInvenWnd Inst()
{
	return ItemAutoPeelInvenWnd(GetScript("ItemAutoPeelInvenWnd"));
}

function Initialize()
{
	InitControls();
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	ItemWnd = GetItemWindowHandle(ownerFullPath $ ".ItemEnchantSubWndItemWnd");
}

function UpdateInventoryWnd()
{
	local int i;
	local INT64 RemainItemNum;
	local ItemInfo tempInfo;
	local array<ItemInfo> itemInfos;
	local ItemAutoPeelWnd.ItemAutoPeelInfo ItemAutoPeelInfo;

	ItemAutoPeelInfo = class'ItemAutoPeelWnd'.static.Inst().GetItemAutoPeelInfo();
	// End:0x36
	if(Me.IsShowWindow() == false)
	{
		return;
	}
	ItemWnd.Clear();
	class'UIDATA_INVENTORY'.static.GetAllDefaultActionPeelItem(itemInfos);

	// End:0x114 [Loop If]
	for(i = 0; i < itemInfos.Length; i++)
	{
		tempInfo = itemInfos[i];
		// End:0xDD
		if(tempInfo.Id.ServerID == ItemAutoPeelInfo.targetItemSId)
		{
			RemainItemNum = tempInfo.ItemNum - ItemAutoPeelInfo.totalPeelCnt;
			// End:0xCD
			if(RemainItemNum <= 0)
			{
				// [Explicit Continue]
				continue;
			}
			tempInfo.ItemNum = RemainItemNum;
		}
		tempInfo.bShowCount = true;
		tempInfo.bDisabled = 0;
		ItemWnd.AddItem(tempInfo);
	}
}

event OnRegisterEvent()
{
	RegisterEvent(EV_AdenaInvenCount);
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
				UpdateInventoryWnd();
			}
			// End:0x2D
			break;
	}
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
}

event OnShow()
{
	UpdateInventoryWnd();
}

event OnDBClickItem(string strID, int Index)
{
	local ItemInfo targetItemInfo;

	// End:0x5B
	if(Index >= 0)
	{
		ItemWnd.GetItem(Index, targetItemInfo);
		class'ItemAutoPeelWnd'.static.Inst().RegisterItem(targetItemInfo.Id.ServerID, class'InputAPI'.static.IsAltPressed());
	}
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
}

event OnReceivedCloseUI()
{
	class'ItemAutoPeelWnd'.static.Inst().CloseWindow();
}

defaultproperties
{
}
