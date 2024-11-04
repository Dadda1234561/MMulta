//================================================================================
// SideBarVPWnd.
//================================================================================

class SideBarVPWndWindowTooltip extends SideBarWndBase;

const TIMER_ID_LIMIT = 5;
const TIMER_ID_LUCK = 6;

var string m_WindowName;
var WindowHandle Me;
var StatusBarHandle VpDetailBar;
var TextBoxHandle VPDetailGaugeMax_Txt;
var TextBoxHandle VPTitleTextBox;
var TextBoxHandle SayhasNum_Txt;
var TextBoxHandle SayhasMaxNum_TxT;
var int nVitalityBonus;
var int nVitalityExtraBonus;
var int nVitalityItemMaxRestoreCount;
var bool isAfterStatusNormaEvent;
var bool isVPApply;
var bool bNoticeVitalityZero;
var bool bNoticeUseVitalityItem;
var TextureHandle VpIcon;
var int VitalLimitEndTime;
var int VitalLuckyEndTime;
var int VitalLimitBonusExp;
var int VitalLimitBonusAdena;
var int nVitality;
var string sBonusString;
var string sExtraBonusString;

function OnRegisterEvent()
{
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_VitalityEffectInfo);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_VitalExInfo);
}

function OnLoad()
{
	InitSideBarWndDefaultOnLoad();
	Me = GetWindowHandle(m_WindowName);
	VpDetailBar = GetStatusBarHandle(m_WindowName $ ".SideBarVPDetailBar_StatusBar");
	VPDetailGaugeMax_Txt = GetTextBoxHandle(m_WindowName $ ".SideBarVPDetailGaugeMax_Txt");
	VPTitleTextBox = GetTextBoxHandle(m_WindowName $ ".SideBarVPTitle_Txt");
	SayhasNum_Txt = GetTextBoxHandle(m_WindowName $ ".SayhasNum_Txt");
	SayhasMaxNum_TxT = GetTextBoxHandle(m_WindowName $ ".SayhasMaxNum_TxT");
	VpIcon = GetTextureHandle(m_WindowName $ ".SideBarVPIcon_Tex");
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		// End:0x15
		case EV_UpdateUserInfo:
			handleVPPoint();
			// End:0x6F
			break;
		// End:0x3E
		case EV_VitalityEffectInfo:
			// End:0x3B
			if(getInstanceUIData().getIsClassicServer())
			{
				HandleVitalityEffectInfo(a_Param);
			}
			// End:0x6F
			break;
		// End:0x56
		case EV_Restart:
			bNoticeVitalityZero = false;
			bNoticeUseVitalityItem = false;
			// End:0x6F
			break;
		// End:0x6C
		case EV_VitalExInfo:
			HandleVitalExInfo(a_Param);
			// End:0x6F
			break;
	}
}

function OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "SideBarVPClose_Btn":
			HandleOnClickClose("Close_Btn");
			break;
	}
}

function handleVPPoint()
{
	local UserInfo UserInfo;
	local int MaxVitality;

	MaxVitality = GetMaxVitality();
	// End:0x18C
	if(GetPlayerInfo(UserInfo))
	{
		nVitality = UserInfo.nVitality;
		SetLimit();
		// End:0x6B
		if(nVitality == 0)
		{
			VPDetailGaugeMax_Txt.SetText("0%");
			VPTitleTextBox.SetText(GetSystemString(2492));
		}
		else if (nVitality == MaxVitality)
		{
			VPDetailGaugeMax_Txt.SetText(GetSystemString(3451));
			VPTitleTextBox.SetText(GetSystemString(2492));
		}
		else
		{
			VPDetailGaugeMax_Txt.SetText(ConvertFloatToString((float(nVitality) / float(MaxVitality)) * 100, 0, false) $ "%");
			VPTitleTextBox.SetText(GetSystemString(2492));
		}
		SayhasNum_Txt.SetText(MakeCostString(string(nVitality)));
		SayhasMaxNum_TxT.SetText("/" @ MakeCostString(string(GetMaxVitality())) $ " (MAX)");
		ChkVpPointAlarm();
		VpDetailBar.SetPoint(nVitality, MaxVitality);
		SideBarScript.SetPointByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_VP, nVitality, MaxVitality);
	}
}

private function ChkVpPointAlarm()
{
	local INT64 MaxValue, CurValue;

	// End:0x0D
	if(nVitality > 0)
	{
		return;
	}
	VpDetailBar.GetPoint(CurValue, MaxValue);
	// End:0x3A
	if(CurValue > 0)
	{
		API_PlayIndexedNotifySound();
	}	
}

function HandleVitalityEffectInfo(string param)
{
	local int nVitalityItemRestoreCount;
	local string sSysMsgParamString;

	ParseInt(param, "vitalityPoint", nVitality);
	ParseInt(param, "vitalityBonus", nVitalityBonus);
	ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
	ParseInt(param, "maxRestoreCount", nVitalityItemMaxRestoreCount);
	SetLimit();
	ParseInt(param, "vitalityExtraBonus", nVitalityExtraBonus);
	sBonusString = string(nVitalityBonus) $ "%";
	// End:0xDC
	if(nVitalityExtraBonus > 0)
	{
		sExtraBonusString = " +" $ string(nVitalityExtraBonus) $ "%";
	}
	if ((nVitality <= 0) && bNoticeVitalityZero == false)
	{
		ParamAdd(sSysMsgParamString, "Type", string(1));
		ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
		AddSystemMessageParam(sSysMsgParamString);
		if (getInstanceUIData().getIsLiveServer() && (GetLanguage() == LANG_Russia || GetLanguage() == LANG_Euro))
		{
			AddSystemMessageString(EndSystemMessageParam(6841, true));
		}
		else
		{
			AddSystemMessageString(EndSystemMessageParam(6068, true));
		}
		bNoticeVitalityZero = true;
	}
	else if ((nVitality > 0) && (bNoticeUseVitalityItem == false))
	{
		bNoticeUseVitalityItem = true;
	}
	MakeTooltip();
}

function MakeTooltip()
{
	local CustomTooltip t;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	util.ToopTipInsertText(GetSystemString(14187) $ " ", true, true);
	// End:0xA0
	if(nVitality <= 0)
	{
		util.ToopTipInsertText(GetSystemString(2496), true, false, util.ETooltipTextType.COLOR_GRAY);
		util.ToopTipInsertText(", ", true, false);
		bNoticeUseVitalityItem = false;
	}
	else
	{
		util.ToopTipInsertText(sBonusString, true, false);
		util.ToopTipInsertText(sExtraBonusString, true, false, util.ETooltipTextType.COLOR_YELLOW03);
		bNoticeVitalityZero = false;
	}
	// End:0x2FE
	if(GetLanguage() != LANG_Korean)
	{
		util.ToopTipMinWidth(300);
		util.ToopTipInsertText(GetSystemString(5926), true, true);
		if (VitalLimitEndTime > 0)
		{
			util.ToopTipInsertText(string(VitalLimitEndTime), true, false);
			ParamAdd(util.tooltipText.DrawList[util.tooltipText.DrawList.Length - 1].Condition, "Type", "VitalTimeLimit");
		}
		else
		{
			util.ToopTipInsertText(GetSystemString(2496), true, false, util.ETooltipTextType.COLOR_GRAY);
		}
		util.ToopTipInsertText(MakeFullSystemMsg(GetSystemMessage(6872), string(VitalLimitBonusExp), string(VitalLimitBonusAdena)), false, true);
		util.ToopTipInsertText(GetSystemString(5927), true, true);
		if(VitalLuckyEndTime > 0)
		{
			util.ToopTipInsertText(string(VitalLuckyEndTime), true, false);
			ParamAdd(util.tooltipText.DrawList[util.tooltipText.DrawList.Length - 1].Condition, "Type", "VitalTimeLucky");
		}
		else
		{
			util.ToopTipInsertText(GetSystemString(2496), true, false, util.ETooltipTextType.COLOR_GRAY);
		}
	}
	VpDetailBar.SetTooltipCustomType(util.getCustomToolTip());
}

event OnEnterState(name a_CurrentStateName)
{
	isAfterStatusNormaEvent = false;
	SideBarScript.GetEffectAniTextureByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_VP, 0).HideWindow();
	SideBarScript.GetEffectViewportByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_VP, 0).HideWindow();
}

event OnTimer (int TimerID)
{
	switch (TimerID)
	{
		case TIMER_ID_LIMIT:
			VitalLimitEndTime = 0;
			Me.KillTimer(TIMER_ID_LIMIT);
			MakeTooltip();
			break;
		case TIMER_ID_LUCK:
			VitalLuckyEndTime = 0;
			Me.KillTimer(TIMER_ID_LUCK);
			MakeTooltip();
			SetLuck();
		break;
	}
}

function SetLimit()
{
	local StatusRoundHandle statusBarRound;
	local TextureHandle mainIconTexture;
	local bool isOn, IsActive;

	isOn = VitalLimitEndTime > 0;
	IsActive = isOn && nVitality == 0;
	statusBarRound = SideBarScript.GetStatusBarByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_VP);
	mainIconTexture = SideBarScript.GetMainIconByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_VP);
	Me.KillTimer(TIMER_ID_LIMIT);
	// End:0x21A
	if(isOn)
	{
		GetTextureHandle(m_WindowName $ ".CTextureCtrl939").SetTexture("L2UI_NewTex.SideBar.SideBar_Drawer_Gold_Bg");
		statusBarRound.SetGaugeTexture(statusBarRound.StatusRoundSplitType.SRST_Back, "L2UI_NewTex.SideBar.SideBar_GreenSlot_BgCircle");
		VpDetailBar.SetGaugeTexture(VpDetailBar.StatusBarSplitType.SBST_BackLeft, "L2UI_NewTex.Gauge.Gauge_DF_VP_Left");
		VpDetailBar.SetGaugeTexture(VpDetailBar.StatusBarSplitType.SBST_BackCenter, "L2UI_NewTex.Gauge.Gauge_DF_VP_Center");
		VpDetailBar.SetGaugeTexture(VpDetailBar.StatusBarSplitType.SBST_BackRight, "L2UI_NewTex.Gauge.Gauge_DF_VP_Right");
		// End:0x217
		if(VitalLimitEndTime < 604800)
		{
			Me.SetTimer(TIMER_ID_LIMIT, VitalLimitEndTime * 1000);
		}
	}
	else
	{
		GetTextureHandle(m_WindowName $ ".CTextureCtrl939").SetTexture("L2UI_NewTex.SideBar.SideBar_Drawer_Bg");
		statusBarRound.SetGaugeTexture(statusBarRound.StatusRoundSplitType.SRST_Back, "L2UI_NewTex.SideBar_Slot_BgCircle");
		VpDetailBar.SetGaugeTexture(VpDetailBar.StatusBarSplitType.SBST_BackLeft, "L2UI_CT1.Gauges.Gauge_DF_Large_CP_bg_Left");
		VpDetailBar.SetGaugeTexture(VpDetailBar.StatusBarSplitType.SBST_BackCenter, "L2UI_CT1.Gauges.Gauge_DF_Large_CP_bg_Center");
		VpDetailBar.SetGaugeTexture(VpDetailBar.StatusBarSplitType.SBST_BackRight, "L2UI_CT1.Gauges.Gauge_DF_Large_CP_bg_Right");
	}
	if (IsActive)
	{
		mainIconTexture.SetTexture("L2UI_NewTex.SideBar.SideBar_VPGreenIcon");
		VpIcon.SetTexture("L2UI_NewTex.SideBar.SideBar_VPGreenSmallIcon");
	}
	else
	{
		if(nVitality == 0)
		{
			SideBarScript.SetIconTexture(SideBarScript.SIDEBAR_WINDOWS.TYPE_VP, "L2UI_CT1.Icon.InfoWnd_VPIcon_dis");
		}
		else
		{
			mainIconTexture.SetTexture("L2UI_NewTex.SideBar.SideBar_VPIcon");
		}
		VpIcon.SetTexture("L2UI_NewTex.SideBar.SideBar_VPSmallIcon");
	}
}

function SetLuck()
{
	local AnimTextureHandle Anim;
	local EffectViewportWndHandle Viewport;
	local bool isOn;

	isOn = VitalLuckyEndTime > 0;
	Viewport = SideBarScript.GetEffectViewportByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_VP, 0);
	Me.KillTimer(TIMER_ID_LUCK);
	// End:0x109
	if(isOn)
	{
		Anim = SideBarScript.GetEffectAniTextureByIndex(SideBarScript.SIDEBAR_WINDOWS.TYPE_VP, 0);
		Anim.ShowWindow();
		Anim.Stop();
		Anim.SetLoopCount(1);
		Anim.Play();
		Viewport.SpawnEffect("LineageEffect2.ui_star_circle");
		Viewport.ShowWindow();
		Me.SetTimer(TIMER_ID_LUCK,VitalLuckyEndTime * 1000);
	}
	else
	{
		Viewport.SpawnEffect("");
		Anim.Stop();
		Anim.HideWindow();
	}
}

function HandleVitalExInfo(string param)
{
	ParseInt(param, "VitalLimitEndTime", VitalLimitEndTime);
	ParseInt(param, "VitalLuckyEndTime", VitalLuckyEndTime);
	ParseInt(param, "VitalLimitBonusExp", VitalLimitBonusExp);
	ParseInt(param, "VitalLimitBonusAdena", VitalLimitBonusAdena);
	SetLimit();
	SetLuck();
	MakeTooltip();
}

private function API_PlayIndexedNotifySound()
{
	local int NOTIFYMUTEFLAG, notifySoundIndex;

	notifySoundIndex = 5;
	NOTIFYMUTEFLAG = GetOptionInt("Audio", "NOTIFYMUTEFLAG");
	// End:0x4A
	if((NOTIFYMUTEFLAG & ExpInt(2, notifySoundIndex - 1)) != 0)
	{
		return;
	}
	class'AudioAPI'.static.PlayIndexedNotifySound("13790", notifySoundIndex, true);	
}

defaultproperties
{
     m_WindowName="SideBarVPWndWindowTooltip"
}
