class L2PassAdvanceListDrawer extends UICommonAPI;

var WindowHandle Me;
var RichListCtrlHandle advanceItemInfoRichList;
var ButtonHandle CloseBtn;

function Initialize()
{
	Me = GetWindowHandle("L2PassAdvanceListDrawer");
	advanceItemInfoRichList = GetRichListCtrlHandle(Me.m_WindowNameWithFullPath $ ".List_ListCtrl");
	CloseBtn = GetButtonHandle(Me.m_WindowNameWithFullPath $ "CloseButton");
	advanceItemInfoRichList.SetSelectedSelTooltip(false);
	advanceItemInfoRichList.SetAppearTooltipAtMouseX(true);
	advanceItemInfoRichList.SetSelectable(false);
}

function _SetAdvanceItemInfo(array<int> EnableList)
{
	local array<L2PassAdvanceData> advanceInfoList;
	local string titleStr;
	local L2PassAdvanceData advanceInfo;
	local RichListCtrlRowData RowData;
	local ItemInfo advanceItemInfo;
	local int i, j, iconWidth, iconHeight, textOffsetX, textOffsetY;

	local Color titleTextColor;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	titleTextColor = util.Yellow;
	iconWidth = 32;
	iconHeight = 32;
	textOffsetX = 4;
	textOffsetY = 10;
	advanceItemInfoRichList.DeleteAllItem();
	GetL2PassAdvanceInfo(EnableList, advanceInfoList);
	RowData.cellDataList.Length = 1;

	// End:0x1DF [Loop If]
	for(i = 0; i < advanceInfoList.Length; i++)
	{
		advanceInfo = advanceInfoList[i];
		titleStr = advanceInfo.AdvanceTypeName;
		util.GetEllipsisString(titleStr, 185);
		advanceItemInfoRichList.InsertRecord(MakeTitleRecord(titleStr, titleTextColor, advanceInfo.Desc));

		// End:0x1D5 [Loop If]
		for(j = 0; j < advanceInfo.arrTargetItem.Length; j++)
		{
			RowData.cellDataList[0].drawitems.Length = 0;
			advanceItemInfo = GetItemInfoByClassID(advanceInfo.arrTargetItem[j]);
			util.GetEllipsisString(advanceItemInfo.Name, 190);
			AddRichListCtrlItem(RowData.cellDataList[0].drawitems, advanceItemInfo);
			addRichListCtrlString(RowData.cellDataList[0].drawitems, advanceItemInfo.Name, util.White, false, textOffsetX, textOffsetY);
			RowData.nReserved1 = 1;
			RowData.nReserved2 = advanceInfo.arrTargetItem[j];
			advanceItemInfoRichList.InsertRecord(RowData);
		}
	}
}

function RichListCtrlRowData MakeTitleRecord(string titleStr, Color TextColor, string tooltipStr)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 1;
	addRichListCtrlString(Record.cellDataList[0].drawitems, titleStr, TextColor, false, 10, 0, "hs11");
	Record.szReserved = tooltipStr;
	Record.nReserved1 = 0;
	Record.sOverlayTex = "L2UI_EPIC.LCoinShopWnd.CraftListInHeader";
	Record.OverlayTexU = 258;
	Record.OverlayTexV = 50;
	return Record;
}

event OnLoad()
{
	Initialize();
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x29
		case "CloseButton":
			Me.HideWindow();
			// End:0x2C
			break;
	}
}
