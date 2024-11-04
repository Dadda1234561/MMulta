class UIControlNeedItem extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var ItemWindowHandle item;
var TextBoxHandle text0;
var TextBoxHandle text1;
var TextBoxHandle text2;
var INT64 numItem;
var INT64 numNeed;
var INT64 numMine;
var L2UIInventoryObjectSimple iObject;

delegate DelegateItemUpdate (UIControlNeedItem script);

function Init(string WindowName)
{
	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	Me.ShowWindow();
	item = GetItemWindowHandle(WindowName $ ".item");
	text0 = GetTextBoxHandle(WindowName $ ".text0");
	text1 = GetTextBoxHandle(WindowName $ ".text1");
	text2 = GetTextBoxHandle(WindowName $ ".text2");
	item.Clear();
	text2.SetAnchor(WindowName $ ".text1", "TopRight", "TopLeft", 0, 0);
	text0.SetText("");
	text1.SetText("");
	text2.SetText("");
	numItem = 1;
}

function HandleItemListner(array<ItemInfo> iInfos, optional int Index)
{
	SetNumMine(iInfos[0].ItemNum);
	DelegateItemUpdate(self);
}

function ItemID GetID()
{
	local ItemInfo iInfo;

	iInfo = GetItemInfo();
	return iInfo.Id;
}

function ItemInfo GetItemInfo()
{
	local ItemInfo iInfo;

	item.GetItem(0, iInfo);
	return iInfo;
}

function setId(ItemID iID)
{
	local ItemInfo iInfo;
	local array<ItemInfo> iInfos;

	class'UIDATA_ITEM'.static.GetItemInfo(iID, iInfo);
	item.Clear();
	item.AddItem(iInfo);
	if ( iObject == None )
	{
		iObject = AddItemListenerSimple(iID.ClassID, iID.ServerID);
		iObject.DelegateOnUpdateItem = HandleItemListner;
	} else {
		iObject.setId(iID);
	}
	text0.SetText(class'UIDATA_ITEM'.static.GetItemName(iID));
	class'UIDATA_INVENTORY'.static.FindItemByClassID(iID.ClassID, iInfos);
	SetNumMine(iInfos[0].ItemNum);
}

function SetNumItem (INT64 Num)
{
	if ( Num < 1 )
	{
		Num = 1;
	}
	numItem = Num;
	SetNumNeed(Num * numNeed);
}

function SetNumNeed(INT64 Num)
{
	numNeed = Num;
	text1.SetText("x" $ MakeCostStringINT64(numNeed * numItem));
	HandleTextColor();
}

function SetNumMine(INT64 Num)
{
	numMine = Num;
	text2.SetText("(" $ MakeCostStringINT64(numMine) $ ")");
	HandleTextColor();
}

function HandleTextColor()
{
	if ( canBuy() )
	{
		text2.SetTextColor(getInstanceL2Util().BLUE01);
	} else {
		text2.SetTextColor(getInstanceL2Util().DRed);
	}
}

function bool canBuy()
{
	return numMine >= numNeed * numItem;
}

defaultproperties
{
}
