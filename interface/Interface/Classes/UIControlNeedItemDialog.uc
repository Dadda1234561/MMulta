//================================================================================
// UIControlNeedItemDialog.
//================================================================================

class UIControlNeedItemDialog extends UIControlBasicDialog;

var RichListCtrlHandle NeedItemRichListCtrl;
var bool bEnoughItems;

function SetWindow(string WindowName, optional string DisableWindowName)
{
	util = L2Util(GetScript("L2Util"));

	if(DisableWindowName != "")
	{
		DisableWindow = GetWindowHandle(DisableWindowName);
	}
	m_WindowName = WindowName;
	Me = GetWindowHandle(m_WindowName);
	OKButton = GetButtonHandle(m_WindowName $ ".OkButton");
	CancleButton = GetButtonHandle(m_WindowName $ ".CancleButton");
	DescriptionTextBox = GetTextBoxHandle(m_WindowName $ ".DescriptionTextBox");
	DescriptionHtmlCtrl = GetHtmlHandle(m_WindowName $ ".DescriptionHtmlCtrl");
	NeedItemRichListCtrl = GetRichListCtrlHandle(m_WindowName $ ".NeedItemRichListCtrl");
}

function OnShow()
{
	NeedItemRichListCtrl.DeleteAllItem();
	OKButton.DisableWindow();
}

function OnHide()
{
}

function Show()
{
	if(! isNullWindow(DisableWindow))
	{
		DisableWindow.ShowWindow();
	}
	Me.ShowWindow();
	Me.SetFocus();
}

function Hide()
{
	if(! isNullWindow(DisableWindow))
	{
		DisableWindow.HideWindow();
	}
	Me.HideWindow();
}

event OnLoad()
{
	NeedItemRichListCtrl.SetUseStripeBackTexture(false);
	NeedItemRichListCtrl.SetSelectedSelTooltip(false);
	NeedItemRichListCtrl.SetAppearTooltipAtMouseX(true);
	NeedItemRichListCtrl.SetSelectable(false);
}

function RichListCtrlRowData MakeRowDataStatusResetNeedItemInfo(ItemInfo iInfo, INT64 Amount, INT64 inventoryItemCount)
{
	local RichListCtrlRowData RowData;
	local Color itemNumColor;
	local string toolTipParam;

	RowData.cellDataList.Length = 1;
	ItemInfoToParam(iInfo, toolTipParam);
	RowData.szReserved = toolTipParam;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
	AddRichListCtrlItem(RowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 1);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), util.BrightWhite, false, 5, 0);

	if(inventoryItemCount < Amount)
	{
		bEnoughItems = false;
		itemNumColor = GetColor(255, 0, 0, 255);
	}
	else
	{
		itemNumColor = GetColor(0, 176, 255, 255);
	}
	addRichListCtrlString(RowData.cellDataList[0].drawitems, "x" $ MakeCostStringINT64(Amount), util.White, true, 40, 5);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, (" (" $ MakeCostStringINT64(inventoryItemCount)) $ ")", itemNumColor, false);
	return RowData;
}

function RichListCtrlRowData MakeRowDataStatusResetNeedItem(int ClassID, INT64 Amount)
{
	local RichListCtrlRowData RowData;
	local Color itemNumColor;
	local string toolTipParam;
	local ItemID cID;
	local InventoryWnd inventoryWndScript;
	local INT64 ItemCount;
	local ItemInfo Info;

	RowData.cellDataList.Length = 1;
	cID.ClassID = ClassID;
	Info = GetItemInfoByClassID(ClassID);
	ItemInfoToParam(Info, toolTipParam);
	RowData.szReserved = toolTipParam;
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
	addRichListCtrlTexture(RowData.cellDataList[0].drawitems, class'UIDATA_ITEM'.static.GetItemTextureName(cID), 32, 32, -34, 1);
	addRichListCtrlString(RowData.cellDataList[0].drawitems, class'UIDATA_ITEM'.static.GetItemName(cID), util.BrightWhite, false, 5, 0);
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	ItemCount = inventoryWndScript.getItemCountByClassID(ClassID);

	if(ItemCount < Amount)
	{
		bEnoughItems = false;
		itemNumColor = GetColor(255, 0, 0, 255);
	}
	else
	{
		itemNumColor = GetColor(0, 176, 255, 255);
	}
	addRichListCtrlString(RowData.cellDataList[0].drawitems,("x" $ MakeCostStringINT64(Amount)), util.White, true, 40, 5);
	addRichListCtrlString(RowData.cellDataList[0].drawitems," (" $ MakeCostStringINT64(ItemCount) $ ")", itemNumColor, false);
	return RowData;
}

function StartNeedItemList()
{
	bEnoughItems = true;
	NeedItemRichListCtrl.DeleteAllItem();
}

function AddNeedItem (int nClassID, INT64 ItemCount)
{
	NeedItemRichListCtrl.InsertRecord(MakeRowDataStatusResetNeedItem(nClassID, ItemCount));
}

function AddNeeItemInfo(ItemInfo iInfo, INT64 Amount, INT64 inventoryItemCount)
{
	NeedItemRichListCtrl.InsertRecord(MakeRowDataStatusResetNeedItemInfo(iInfo, Amount, inventoryItemCount));
}

function EndNeedItemList()
{
	if(bEnoughItems)
	{
		OKButton.EnableWindow();
	}
	else
	{
		OKButton.DisableWindow();
	}
}

defaultproperties
{
}
