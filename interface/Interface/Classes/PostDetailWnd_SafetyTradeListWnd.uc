class PostDetailWnd_SafetyTradeListWnd extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var RichListCtrlHandle ItemList;
var PostDetailWnd_SafetyTrade PostDetailWnd_SafetyTradeScript;

function OnLoad()
{
	InitializeCOD();
	Me.HideWindow();
}

function InitializeCOD()
{
	Me = GetWindowHandle(m_WindowName);
	ItemList = GetRichListCtrlHandle(m_WindowName $ ".ItemList");
	PostDetailWnd_SafetyTradeScript = PostDetailWnd_SafetyTrade(GetScript("PostDetailWnd_SafetyTrade"));
	ItemList.SetSelectedSelTooltip(false);
	ItemList.SetAppearTooltipAtMouseX(true);
}

function OnClickButton(string a_ButtonID)
{
	PostDetailWnd_SafetyTradeScript.OnClickButton(a_ButtonID);
}

function Clear()
{
	ItemList.DeleteAllItem();
}

function AddItem(string param)
{
	local ItemInfo Info;

	ParamToItemInfo(param, Info);
	ItemList.InsertRecord(makeRecord(Info));
	PostDetailWnd_SafetyTradeScript.totalWeight += (Info.Weight * int(Info.ItemNum));
}

function int GetItemListCount()
{
	return ItemList.GetRecordCount();
}

function RichListCtrlRowData makeRecord(ItemInfo Info)
{
	local RichListCtrlRowData Record;
	local string fullNameString;
	local Color tmpTextColor;
	local string toolTipParam;

	Record.cellDataList.Length = 1;
	fullNameString = GetItemNameAll(Info);
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.cellDataList[0].szData = fullNameString;
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconName, 32, 32, 10, 0);
	// End:0xB9
	if(Info.IconPanel != "")
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconPanel, 32, 32, -32, 0);
	}
	tmpTextColor = GetColor(170, 153, 119, 255);
	addRichListCtrlString(Record.cellDataList[0].drawitems, fullNameString, tmpTextColor, false, 5, 2);
	addRichListCtrlString(Record.cellDataList[0].drawitems, "x" $ MakeCostString(string(Info.ItemNum)), tmpTextColor, true, 47, 0);
	return Record;
}

function HandleShow()
{
	Me.ShowWindow();
}

function HandleHide()
{
	Me.HideWindow();
}

defaultproperties
{
     m_WindowName="PostDetailWnd_SafetyTradeListWnd"
}
