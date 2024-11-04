class ItemBlessWndSub extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var ItemWindowHandle SubWnd_Item1;
var TextBoxHandle descTextBox;
var WindowHandle DescriptionMsgWnd;
var ItemBlessWnd itemBlessWndScript;
var L2Util util;
var array<int> groupIDs;

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	SubWnd_Item1 = GetItemWindowHandle(m_WindowName $ ".ItemBlessWndSubWnd_Item1");
	util = L2Util(GetScript("L2Util"));
	itemBlessWndScript = ItemBlessWnd(GetScript("itemBlessWnd"));
	descTextBox = GetTextBoxHandle(m_WindowName $ ".descTextBox");
	DescriptionMsgWnd = GetWindowHandle(m_WindowName $ ".DescriptionMsgWnd");
}

event OnRegisterEvent()
{
	RegisterEvent(EV_InventoryUpdateItem);
	RegisterEvent(EV_InventoryAddItem);
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_InventoryUpdateItem:
			if (Me.IsShowWindow())
			{
				Refresh();
				SetState();
			}
			break;
	}
}

event OnLoad()
{
	Initialize();
}

event OnShow()
{
	Refresh();
	HandleDescriptionMsgWnd();
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID,Index);
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;

	SubWnd_Item1.GetItem(Index,Info);
	if ( Info.Id.ClassID > 0 )
	{
		itemBlessWndScript.SetItemInfo(Info);
	}
}

function Refresh()
{
	local int i;
	local array<ItemInfo> iInfos;

	SubWnd_Item1.Clear();
	GetObjectFindItemByCompare().DelegateCompare = Compare;
	iInfos = GetObjectFindItemByCompare().GetAllItemByCompare();
	iInfos = util.SortItemArray(iInfos);

	for ( i = 0;i < iInfos.Length;i++ )
	{
		SubWnd_Item1.AddItem(iInfos[i]);
	}
	if ( iInfos.Length > 0 )
	{
		DescriptionMsgWnd.HideWindow();
	} else {
		DescriptionMsgWnd.ShowWindow();
	}
}

function SetState()
{
	HandleDescriptionMsgWnd();
}

function HandleDescriptionMsgWnd()
{
	local bool canDropItem;
	local bool noneItems;

	noneItems = SubWnd_Item1.GetItemNum() == 0;
	switch(itemBlessWndScript.CurrentState)
	{
		case itemBlessWndScript.typeState.non:
		case itemBlessWndScript.typeState.READY:
			canDropItem = True;
			break;
		case itemBlessWndScript.typeState.Progress:
		case itemBlessWndScript.typeState.Result:
			canDropItem = False;
			break;
	}
	if ( canDropItem &&	!noneItems )
	{
		DescriptionMsgWnd.HideWindow();
	} else {
		DescriptionMsgWnd.ShowWindow();
	}
	if ( noneItems )
	{
		descTextBox.ShowWindow();
	} else {
		descTextBox.HideWindow();
	}
}

function SetGroupIDs(array<int> _groupIDs)
{
	groupIDs = _groupIDs;	
}

function bool Compare(ItemInfo iInfo)
{
	local int i;

	// End:0x10
	if(iInfo.IsBlessedItem)
	{
		return false;
	}

	// End:0x4D [Loop If]
	for(i = 0; i < groupIDs.Length; i++)
	{
		// End:0x43
		if(iInfo.EnchantBlessGroupID == groupIDs[i])
		{
			return true;
		}
	}
	return false;	
}

defaultproperties
{
}
