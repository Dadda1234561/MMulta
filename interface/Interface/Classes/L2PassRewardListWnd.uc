class L2PassRewardListWnd extends UICommonAPI;

var WindowHandle Me;
var RichListCtrlHandle rewardNormalRichList;
var RichListCtrlHandle rewardPremiumRichList;
var ButtonHandle confirmBtn;
var L2PassWnd parentWnd;
var TextBoxHandle TitleTextBox;
var L2PassData _l2PassData;

function Init(WindowHandle Owner, L2PassWnd Parent)
{
	local string ownerFullPath;

	ownerFullPath = Owner.m_WindowNameWithFullPath;
	parentWnd = Parent;
	Me = GetWindowHandle(ownerFullPath);
	_l2PassData = new class'L2PassData';
	rewardNormalRichList = GetRichListCtrlHandle(ownerFullPath $ ".List0_ListCtrl");
	rewardPremiumRichList = GetRichListCtrlHandle(ownerFullPath $ ".List1_ListCtrl");
	confirmBtn = GetButtonHandle(ownerFullPath $ ".Confirm_Btn");
	TitleTextBox = GetTextBoxHandle(ownerFullPath $ ".Title_text");
	rewardNormalRichList.SetSelectedSelTooltip(false);
	rewardPremiumRichList.SetSelectedSelTooltip(false);
	rewardNormalRichList.SetSelectable(false);
	rewardPremiumRichList.SetSelectable(false);
	rewardNormalRichList.SetAppearTooltipAtMouseX(true);
	rewardPremiumRichList.SetAppearTooltipAtMouseX(true);
}

function _SetTotalRewardInfo(L2PassData.EL2PassType PassType, int rewardStep, int premiumRewardStep, bool isPremiumActivated)
{
	local array<L2PassRewardTotalData> normalRewardList, premiumRewardList;
	local RichListCtrlRowData normalRewardRowData, premiumRewardRowData;
	local ItemInfo rewardIteminfo;
	local int nPassType, i, iconWidth, iconHeight, textOffsetX, textOffsetY;

	local Color curCntTextColor, defaultTextColor;
	local string toolTipParam;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	iconWidth = 32;
	iconHeight = 32;
	textOffsetX = 4;
	textOffsetX = 4;
	curCntTextColor = util.Yellow;
	defaultTextColor = util.White;
	normalRewardRowData.cellDataList.Length = 1;
	premiumRewardRowData.cellDataList.Length = 1;
	nPassType = PassType;
	// End:0xBE
	if(PassType == _l2PassData.EL2PassType.Hunt)
	{
		TitleTextBox.SetText(GetSystemString(5939));		
	}
	else if(PassType == _l2PassData.EL2PassType.Advance)
	{
		TitleTextBox.SetText(GetSystemString(5940));
	}
	rewardNormalRichList.DeleteAllItem();
	rewardPremiumRichList.DeleteAllItem();
	GetL2PassRewardTotalList(nPassType, false, rewardStep, normalRewardList);
	GetL2PassRewardTotalList(nPassType, true, premiumRewardStep, premiumRewardList);

	// End:0x292 [Loop If]
	for(i = 0; i < normalRewardList.Length; i++)
	{
		normalRewardRowData.cellDataList[0].drawitems.Length = 0;
		rewardIteminfo = GetItemInfoByClassID(normalRewardList[i].ItemID);
		util.GetEllipsisString(rewardIteminfo.Name, 210);
		ItemInfoToParam(rewardIteminfo, toolTipParam);
		normalRewardRowData.szReserved = toolTipParam;
		AddRichListCtrlItem(normalRewardRowData.cellDataList[0].drawitems, rewardIteminfo);
		addRichListCtrlString(normalRewardRowData.cellDataList[0].drawitems, rewardIteminfo.Name, defaultTextColor, false, textOffsetX);
		addRichListCtrlString(normalRewardRowData.cellDataList[0].drawitems, string(normalRewardList[i].ItemCurrCnt), curCntTextColor, true, iconWidth + textOffsetX, textOffsetY);
		addRichListCtrlString(normalRewardRowData.cellDataList[0].drawitems, " /" @ string(normalRewardList[i].ItemMaxCnt));
		rewardNormalRichList.InsertRecord(normalRewardRowData);
	}

	// End:0x3E9 [Loop If]
	for(i = 0; i < premiumRewardList.Length; i++)
	{
		premiumRewardRowData.cellDataList[0].drawitems.Length = 0;
		rewardIteminfo = GetItemInfoByClassID(premiumRewardList[i].ItemID);
		util.GetEllipsisString(rewardIteminfo.Name, 210);
		ItemInfoToParam(rewardIteminfo, toolTipParam);
		premiumRewardRowData.szReserved = toolTipParam;
		AddRichListCtrlItem(premiumRewardRowData.cellDataList[0].drawitems, rewardIteminfo);
		addRichListCtrlString(premiumRewardRowData.cellDataList[0].drawitems, rewardIteminfo.Name, defaultTextColor, false, textOffsetX);
		addRichListCtrlString(premiumRewardRowData.cellDataList[0].drawitems, string(premiumRewardList[i].ItemCurrCnt), curCntTextColor, true, iconWidth + textOffsetX, textOffsetY);
		addRichListCtrlString(premiumRewardRowData.cellDataList[0].drawitems, " /" @ string(premiumRewardList[i].ItemMaxCnt));
		rewardPremiumRichList.InsertRecord(premiumRewardRowData);
	}
}

function _ScrollToStart()
{
	rewardNormalRichList.SetScrollPosition(0);
	rewardPremiumRichList.SetScrollPosition(0);
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		// End:0x29
		case "Confirm_Btn":
			Me.HideWindow();
			// End:0x2C
			break;
	}
}

event OnShow()
{
	parentWnd._ShowDisalbeWnd(true);
}

event OnHide()
{
	parentWnd._ShowDisalbeWnd(false);
}
