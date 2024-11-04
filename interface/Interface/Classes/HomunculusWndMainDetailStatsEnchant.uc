class HomunculusWndMainDetailStatsEnchant extends UICommonAPI;

const TIMER_DISABLETIME= 5000;
const TIMERID_DISABLE= 1;

var WindowHandle Me;
var string m_WindowName;
var L2Util util;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndEnchantCommunionChart homunculusWndEnchantCommunionChartScript;
var HomunculusWndEnchantCommunionChartItem homunculusWndEnchantCommunionChartItemScript;
var RichListCtrlHandle List_ListCtrl0;
var TextBoxHandle text1;
var TextBoxHandle text2;
var StatusBarHandle statusBar0;
var StatusBarHandle statusBar1;
var StatusBarHandle statusbar2;
var ButtonHandle btn0;
var ButtonHandle btn1;
var ButtonHandle btn2;
var ButtonHandle btnHelp;
var HomunculusAPI.HomunEnchantData enchantData;

function ClearAll()
{
	btn0.DisableWindow();
	btn1.DisableWindow();
	btn2.DisableWindow();
	List_ListCtrl0.DeleteAllItem();
	statusBar0.SetPoint(0,100);
	statusBar1.SetPoint(0,100);
	statusbar2.SetPoint(0,100);
}

function SetTooltip()
{
	local CustomTooltip t;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(300);
	util.ToopTipInsertText(GetSystemMessage(13215));
	btn0.SetTooltipCustomType(util.getCustomToolTip());
}

function SetTooltipOnSelect()
{
	local CustomTooltip t;
	local HomunculusAPI.HomunculusNpcLevelData npcMaxLevelData;
	local HomunculusAPI.HomunculusData emptyHomunculusData, currHomunculusData;

	if(! HomunculusWndScript.ChkSerVer())
	{
		return;
	}

	currHomunculusData = GetCurrHomunculusData();
	// End:0x36
	if(currHomunculusData == emptyHomunculusData)
	{
		return;
	}

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(200);
	npcMaxLevelData = HomunculusWndScript.API_GetMaxHomunculusNpcLevelData(GetCurrHomunculusData().Id);
	util.ToopTipInsertText(GetSystemString(13391), true, true);
	util.TooltipInsertItemBlank(5);
	util.TooltipInsertItemLine();
	util.ToopTipInsertText(GetSystemString(90) @ MakeCostString(string(npcMaxLevelData.MaxHP)), true, true);
	util.ToopTipInsertText(GetSystemString(55) @ MakeCostString(string(npcMaxLevelData.MaxAtk)), true, true);
	util.ToopTipInsertText(GetSystemString(54) @ MakeCostString(string(npcMaxLevelData.MaxDef)), true, true);
	util.ToopTipInsertText(GetSystemString(113) @ MakeCostString(string(npcMaxLevelData.MaxCri)), true, true);
	btnHelp.SetTooltipCustomType(util.getCustomToolTip());
}

function Initialize()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	util = L2Util(GetScript("L2Util"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	List_ListCtrl0 = GetRichListCtrlHandle(m_WindowName $ ".List_ListCtrl0");
	text1 = GetTextBoxHandle(m_WindowName $ ".text1");
	text2 = GetTextBoxHandle(m_WindowName $ ".text2");
	statusBar0 = GetStatusBarHandle(m_WindowName $ ".statusbar0");
	statusBar1 = GetStatusBarHandle(m_WindowName $ ".statusbar1");
	statusbar2 = GetStatusBarHandle(m_WindowName $ ".statusbar2");
	btn0 = GetButtonHandle(m_WindowName $ ".btn0");
	btn1 = GetButtonHandle(m_WindowName $ ".btn1");
	btn2 = GetButtonHandle(m_WindowName $ ".btn2");
	btnHelp = GetButtonHandle(m_WindowName $ ".btnHelp");
	List_ListCtrl0.SetSelectable(false);
	List_ListCtrl0.SetUseStripeBackTexture(false);
	List_ListCtrl0.ShowScrollBar(false);
	List_ListCtrl0.SetAppearTooltipAtMouseX(true);
	List_ListCtrl0.SetSelectedSelTooltip(false);
	btn1.DisableWindow();
	btn2.DisableWindow();
	if(GetGameStateName() != "GAMINGSTATE")
	{
		return;
	}
	if(HomunculusWndScript.ChkSerVer())
	{
		enchantData = HomunculusWndScript.API_GetHomunEnchantData();
	}
}

function OnRegisterEvent()
{
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT);
}

function OnLoad()
{
	Initialize();
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT:
			Handle_S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT();
			break;
	}
}

function OnTimer (int TimerID)
{
	switch (TimerID)
	{
		case TIMERID_DISABLE:
			SetBtnEnable0();
			Me.KillTimer(TIMERID_DISABLE);
			break;
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btn0":
			HandlePlusButton(Name);
			break;
		case "btnMain0":
			HomunculusWndScript.SetState(HomunculusWndScript.type_State.Main);
			homunculusWndEnchantCommunionChartScript.SetChangeHomunculusData();
			break;
	}
}

function HandlePlusButton(string Name)
{
	btn0.DisableWindow();
	Me.SetTimer(TIMERID_DISABLE, TIMER_DISABLETIME);
	HomunculusWndScript.API_C_EX_HOMUNCULUS_ENCHANT_EXP(GetCurrHomunculusData().idx);
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

function SetChangeHomunculusData()
{
	local HomunculusAPI.HomunculusNpcLevelData npcLevelData;
	local int prevExp;
	local int currExp;

	npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id, GetCurrHomunculusData().Level);
	if ( GetCurrHomunculusData().Level == 1 )
	{
		prevExp = 0;
	} else {
		prevExp = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id, GetCurrHomunculusData().Level - 1).MaxExp;
	}
	currExp = npcLevelData.MaxExp - prevExp;
	statusBar0.SetPointExpPercentRate((GetCurrHomunculusData().Exp - prevExp) / currExp);
	List_ListCtrl0.DeleteAllItem();
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(90), MakeCostString(string(GetCurrHomunculusData().Hp))));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(55), MakeCostString(string(GetCurrHomunculusData().Attack))));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(54), MakeCostString(string(GetCurrHomunculusData().Defence))));
	List_ListCtrl0.InsertRecord(makeRecord(GetSystemString(113), MakeCostString(string(GetCurrHomunculusData().Critical))));
	btn0.DisableWindow();
	SetBtnEnable0();
	SetTooltip();
	SetTooltipOnSelect();
	//Debug(m_WindowName @ "SetChangeHomunculusData" @ string(GetCurrHomunculusData().Hp) @ string(List_ListCtrl0.GetRecordCount()));
}

function Handle_S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT()
{
	local UIPacket._S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT packet;
	local string Msg;

	if(!Class'UIPacket'.static.Decode_S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT(packet))
	{
		return;
	}
	//Debug("Handle_S_EX_HOMUNCULUS_ENCHANT_EXP_RESULT" @ string(packet.Type) @ string(packet.nID) @ string(packet.Type));
	if(packet.Type == 0)
	{
		AddSystemMessage(packet.nID);
		return;
	}
	Msg = MakeFullSystemMsg(GetSystemMessage(13218), MakeCostString(string(enchantData.EnchantExpPoint)));
	util.showGfxScreenMessage(Msg);
	AddSystemMessageString(Msg);
	HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(1);
	Me.KillTimer(TIMERID_DISABLE);
	SetBtnEnable0();
}

function SetBtnEnable0()
{
	local int MaxLevel;
	local int neePoint;

	MaxLevel = 6;
	neePoint = 1;
	if(GetCurrHomunculusData().Level < MaxLevel)
	{
		if(HomunculusWndScript.currentEnchantPoint >= neePoint)
		{
			btn0.EnableWindow();
		}
	}
}

function RichListCtrlRowData makeRecord(string Name, string numString)
{
	local RichListCtrlRowData Record;
	local Color tmpTextColor;

	Record.cellDataList.Length = 2;
	Record.szReserved = "ÅøÆÁ Á¤º¸µé";
	tmpTextColor = GetColor(170, 153, 119, 255);
	addRichListCtrlString(Record.cellDataList[0].drawitems, Name, tmpTextColor, false);
	addRichListCtrlString(Record.cellDataList[1].drawitems, numString, tmpTextColor, false, 20);
	return Record;
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}

defaultproperties
{
}
