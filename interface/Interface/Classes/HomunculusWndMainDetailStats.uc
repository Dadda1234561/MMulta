class HomunculusWndMainDetailStats extends UICommonAPI;

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var HomunculusWnd HomunculusWndScript;
var RichListCtrlHandle List_ListCtrl0;
var RichListCtrlHandle List_ListCtrl1;
var ButtonHandle btn0;
var ButtonHandle btn1;
var HomunculusWndMainDetailStatsEnchant homunculusWndMainDetailStatsEnchantScript;
var HomunculusWndEnchantCommunionChart homunculusWndEnchantCommunionChartScript;
var HomunculusWndEnchantCommunionInfo homunculusWndEnchantCommunionInfoScript;

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	List_ListCtrl0 = GetRichListCtrlHandle(m_WindowName $ ".List_ListCtrl0");
	List_ListCtrl1 = GetRichListCtrlHandle(m_WindowName $ ".List_ListCtrl1");
	util = L2Util(GetScript("L2Util"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	List_ListCtrl0.SetSelectable(false);
	List_ListCtrl0.SetUseStripeBackTexture(false);
	List_ListCtrl0.ShowScrollBar(false);
	List_ListCtrl0.SetAppearTooltipAtMouseX(true);
	List_ListCtrl0.SetSelectedSelTooltip(false);
	List_ListCtrl1.SetSelectable(false);
	List_ListCtrl1.SetUseStripeBackTexture(false);
	List_ListCtrl1.ShowScrollBar(false);
	List_ListCtrl1.SetAppearTooltipAtMouseX(true);
	List_ListCtrl1.SetSelectedSelTooltip(false);
	btn0 = GetButtonHandle(m_WindowName $ ".btn0");
	btn1 = GetButtonHandle(m_WindowName $ ".btn1");
	btn0.DisableWindow();
	btn1.DisableWindow();
	homunculusWndMainDetailStatsEnchantScript = HomunculusWndMainDetailStatsEnchant(GetScript("HomunculusWnd.HomunculusWndMainDetailStatsEnchant"));
	homunculusWndEnchantCommunionChartScript = HomunculusWndEnchantCommunionChart(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionChart"));
	homunculusWndEnchantCommunionInfoScript = HomunculusWndEnchantCommunionInfo(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionInfo"));
	GetButtonHandle(m_WindowName $ ".HomunHelp_btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13400)));
	GetButtonHandle(m_WindowName $ ".EnchantHelp_btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13401)));
}

function OnLoad()
{
	Initialize();
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btn0":
			HomunculusWndScript.SetState(HomunculusWndScript.type_State.EnchantHomunculus);
			homunculusWndMainDetailStatsEnchantScript.SetChangeHomunculusData();
			break;
		case "btn1":
			HomunculusWndScript.SetState(HomunculusWndScript.type_State.Communion);
			homunculusWndEnchantCommunionChartScript.SetChangeHomunculusData();
			homunculusWndEnchantCommunionInfoScript.SetChangeHomunculusData();
			break;
	}
}

function Show()
{
	Me.ShowWindow();
	Me.SetFocus();
}

function Hide()
{
	Me.HideWindow();
}

function ClearAll()
{
	List_ListCtrl0.DeleteAllItem();
	List_ListCtrl1.DeleteAllItem();
	btn0.DisableWindow();
	btn1.DisableWindow();
}

function SetChangeHomunculusData()
{
	SetHomunculusAbility();
	SetHomunculusCommunion();
}

function SetHomunculusAbility()
{
	List_ListCtrl0.DeleteAllItem();
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(90), MakeCostString(string(GetCurrHomunculusData().Hp)), false));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(55), MakeCostString(string(GetCurrHomunculusData().Attack)), false));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(54), MakeCostString(string(GetCurrHomunculusData().Defence)), false));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(113), MakeCostString(string(GetCurrHomunculusData().Critical)), false));
	btn0.EnableWindow();
}

function SetHomunculusCommunion()
{
	local int i;
	local array<string> descs;
	local string Desc;
	local ItemID Id;

	List_ListCtrl1.DeleteAllItem();
	Id.ClassID = GetCurrHomunculusData().SkillID[0];
	Desc = Class'UIDATA_SKILL'.static.GetDescription(Id, GetCurrHomunculusData().SkillLevel[0], 0);
	Split(Desc, "^", descs);
	List_ListCtrl1.InsertRecord(makeRecord(descs[0], descs[1], true));
	
	for ( i = 1;i < HomunculusWndScript.SKILLIDNUM;i++ )
	{
		if(GetCurrHomunculusData().SkillLevel[i] > 0)
		{
			Id.ClassID = GetCurrHomunculusData().SkillID[i];
			Desc = Class'UIDATA_SKILL'.static.GetDescription(Id, GetCurrHomunculusData().SkillLevel[i], 0);
			if(Desc != "")
			{
				descs.Length = 0;
				Split(Desc, "^", descs);
				List_ListCtrl1.InsertRecord(makeRecord(descs[0], descs[1], false));
			}
		}
	}
	btn1.EnableWindow();
}

function RichListCtrlRowData makeRecord(string Name, string numString, bool isBase)
{
	local RichListCtrlRowData Record;
	local Color tmpTextColor;

	Record.cellDataList.Length = 2;
	Record.szReserved = "ÅøÆÁ Á¤º¸µé";
	if(isBase)
	{
		tmpTextColor = GetColor(170, 153, 119, 255);
	}
	else
	{
		tmpTextColor = util.BrightWhite;
	}
	addRichListCtrlString(Record.cellDataList[0].drawitems, Name, tmpTextColor, false);
	addRichListCtrlString(Record.cellDataList[1].drawitems, numString, tmpTextColor, false, 20);
	return Record;
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData ()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}

defaultproperties
{
}
