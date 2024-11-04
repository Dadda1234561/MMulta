class ClanSubInfoContainerBenefit extends UIData;

var string m_WindowName;
var WindowHandle Me;
var string JoinWndPath;
var string HuntWndPath;
var RichListCtrlHandle m_ClanBenefitList_ListCtrl;
var ClanWndClassicNew clanWndClassicScr;

function InitDefaultSetting()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	clanWndClassicScr = ClanWndClassicNew(GetScript("ClanWndClassicNew"));
	clanWndClassicScr.clanSubInfoContainerBenefitScr = self;
	Me.SetFocus();
}

function Initialize()
{
	InitDefaultSetting();
	m_ClanBenefitList_ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".ClanBenefitList_Wnd.ClanBenefitList_ListCtrl");
	m_ClanBenefitList_ListCtrl.SetAppearTooltipAtMouseX(true);
	m_ClanBenefitList_ListCtrl.SetSelectedSelTooltip(false);
	m_ClanBenefitList_ListCtrl.SetSelectable(false);
}

event OnLoad()
{
	Initialize();
}

event OnEvent(int a_EventID, string param)
{
	// End:0x17
	if(! getInstanceUIData().getIsClassicServer())
	{
		return;
	}
}

function SetRecords()
{
	local int lv;
	local PledgeLevelData Data;

	ClearList();

	while(clanWndClassicScr.API_GetPledgeLevelData(lv, Data))
	{
		m_ClanBenefitList_ListCtrl.InsertRecord(makeRecord(Data));
		++ lv;
	}
	m_ClanBenefitList_ListCtrl.SetStartRow(clanWndClassicScr.m_clanLevel);
}

function RichListCtrlRowData makeRecord(PledgeLevelData Data)
{
	local RichListCtrlRowData Record;
	local ItemInfo iInfo;
	local int i, Len;

	Record.cellDataList.Length = 4;
	addRichListCtrlString(Record.cellDataList[0].drawitems, string(Data.PledgeLevel), getInstanceL2Util().Yellow, false);
	// End:0xB8
	if(Data.OpenContents.Length > 0)
	{
		Len = Min(Data.OpenContents.Length, 2);
		for(i = 0; i < Len; i++)
		{
			AddEllipsisString(Record.cellDataList[1].drawitems, Data.OpenContents[i], 90, GetColor(255, 255, 255, 255), i > 0);
		}
	}
	else
	{
		addRichListCtrlString(Record.cellDataList[1].drawitems, "-");
	}
	Record.cellDataList[2].szData = string(Data.NumGeneral);
	addRichListCtrlString(Record.cellDataList[2].drawitems, Record.cellDataList[2].szData, getInstanceL2Util().White, false);
	if(Data.SellingItemList.Length > 0)
	{
		for(i = 0; i < Data.SellingItemList.Length; i++)
		{
			class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(Data.SellingItemList[i]), iInfo);
			// End:0x1A3
			if(i == 0)
			{
				AddRichListCtrlItem(Record.cellDataList[3].drawitems, iInfo, 32, 32, 50);
				// [Explicit Continue]
				continue;
			}
			AddRichListCtrlItem(Record.cellDataList[3].drawitems, iInfo, 32, 32);
		}
	}
	if(Data.PledgeLevel == clanWndClassicScr.m_clanLevel && clanWndClassicScr.m_clanID > 0)
	{
		Record.sOverlayTex = "L2UI_EPIC.ClanWnd.ClanMyRankBg";
		Record.OverlayTexU = 597;
		Record.OverlayTexV = 43;
	}
	return Record;
}

function ClearList()
{
	m_ClanBenefitList_ListCtrl.DeleteAllItem();
}

defaultproperties
{
}
