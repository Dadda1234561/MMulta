class InfoWnd extends UICommonAPI;

// 2015-06-25 
// http://wallis-devsub/redmine/issues/1792
// ?? ??? ?? ?? ?? 
//var int m_DailyPoint;		//CT26P4_0323

// ?? ?? ??
struct ElementalInfo
{
	var int CurrSpiritType;
	var int SpiritClassID;
	var INT64 Exp;
	var INT64 NextExp;
	var INT64 MaxExp;
	var int CurrLevel;
	var int MaxLevel;
	var int EvolLevel;
	var int NpcID;
};
// ?? ?? ??

var string m_ToppingWndName;
var string m_VPWndName;
var string m_PCCafeWndwName;
var string m_MysteriousMansionWaitingWndName;
var string m_ElementalExpViewerWndName;
var string m_BloodyCoinWndName;


var string m_MagicLampWndName;
var string m_RandomCraftInfoWndName;

var string m_WindowName;


var TextureHandle windowBackground;

//Handle
var WindowHandle Me;

/***************
 * **NP ??
 * *************/
var WindowHandle ToppingWnd;
var array<StatusIconHandle> toppingStatusIcons;
var array<TextureHandle> toppingDisableTextures;
var array<ToppingSkillExtraInfo> toppingDefaultInfos;

/***************
 * **??? ??
 * *************/
var WindowHandle VPWnd;
var TextureHandle VpIcon;
var StatusBarHandle VpDetailBar;
var TextBoxHandle VPDetailGaugeMax_Txt;
var TextBoxHandle VPTitleTextBox;

var int nVitalityBonus;
var int nVitalityExtraBonus;
var int nVitalityItemMaxRestoreCount;
var bool isAfterStatusNormaEvent;
var bool isVPApply;//??? ?? ?? ???? 

/****************
 * **PC ? ???
 * **************/
var WindowHandle PCCafeEventWnd;
var WindowHandle HelpButton;
var int m_TotalPoint;
var int m_AddPoint;
var int m_PeriodType;
var int m_RemainTime;
var int m_PointType;

/***************
 * **??? ??
 * *************/
var WindowHandle MysteriousMansionWaitingWnd;
var WindowHandle MHelpButton;
var ButtonHandle MCancelButton;

/***************
 * ** ?? ???
 * *************/
var WindowHandle ElementalExpViewerWnd;
var StatusBarHandle ElementalExpBar;
var TextureHandle ElementalIcon;
var TextBoxHandle ElementalGrandNameText;
var TextBoxHandle ElementalLevelText;

var ElementalInfo currentemelentalInfo;

/***************
 * ** BC ?
 * *************/
var WindowHandle BloodyCoinWnd;
var AnimTextureHandle BloodCoinAddAnim;
var ButtonHandle HelpBCButton;
var TextureHandle BloodyCoin_shopIcon;
var TextBoxHandle BloodCoinTitleTextBox;
var INT64 bloodCoin;

/***************
 * ** ?? ?? ?
 * *************/
var WindowHandle MagicLampEventWnd;
var ButtonHandle MagicLampHelp_Btn;
var ButtonHandle GameStart_Btn;

var TextBoxHandle MagicLampNum_Txt;
var TextBoxHandle MagicLampGaugeMax_Txt;
var StatusBarHandle MagicLampNum_StatusBar;

var WindowHandle RandomCraftInfoWnd;
var StatusBarHandle RandomCraftNum_StatusBar;
var AnimTextureHandle RandomCraftSmallIcon_Ani;
var TextureHandle RandomCraftNoticeIcon_Tex;
var TextBoxHandle RandomCraftNum_Txt;
var TextBoxHandle RandomCraftMax_Txt;
var ButtonHandle RandomCraftCharging_Btn;
var ButtonHandle RandomCraftRandom_Btn;
var ButtonHandle RandomCraftMaterial_Btn;

/***************
 * ** ??? ???
 * *************/
var array<WindowHandle> allWindow;

const TOPPING_MAX = 6;
const TOPPING_ICON_WH = 22;
//////

// ??? ??
const WINDOW_H_MIN = 2;
const WINDOW_H_GAP = 2;
 
//branch : gorillazin 10. 04. 14. - pc cafe event
var bool m_bIsPCCafeEvent;
//end of branch

//branch GD35_0828 2013-12-06 luciper3 - ?? ???? ??? ???? ???.
var bool bIsOptionValue;
//end of branch

//branch EP1.0 2014-3-6 luciper3 - ???? ? Show??? ????.
var bool bIsShowBackup;
//end of branch

const WINDOWS_MAX = 5;

var bool isEnterState;

var bool isShowInfoWnd;

function OnRegisterEvent()
{
	return;

	//branch EP1.0 2014-3-6 luciper3 - ????? ???? Show ?????? ??
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_GamingStatePreExit);
	//end of branch

	/*
	 * ?? ?? ?? ??? 
	 * ??? VP ??? ???? ?? ??? 
	 * */
	RegisterEvent(EV_AbnormalStatusNormalItem);

	/*
	 * ??? VP ?? ?? ?? 
	 * */	
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_VitalityEffectInfo);	

	/*
	 * PC cafe ???
	 * */
	RegisterEvent(EV_PCCafePointInfo);
	RegisterEvent(EV_ToggleShowPCCafeEventWnd);	

	/*
	 * ??? ?? ? ?? ??? 
	 * */
	RegisterEvent(EV_CuriousHouseWaitState);
	RegisterEvent(EV_CuriousHouseEnter);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_NeedResetUIData);


	/*
	* ?? 
	*/
	RegisterEvent(EV_ElementalSpiritGetExp);
	// ?? ??? ?? ?? 10860
	RegisterEvent(EV_ElementalSpiritSimpleInfo); 

	/*
	* BC 
	*/
	RegisterEvent(EV_BloodyCoinCount);	

	/**
	 *  ?? ??(???)
	 **/
	
	RegisterEvent(EV_MagicLamp_ExpInfo);	 // 11080
}
	

function OnLoad()
{
	local int i;

	/***************
	 * ??? ??
	 * */
	VPWnd = GetWindowHandle(m_VPWndName);
	VpDetailBar = GetStatusBarHandle(m_VPWndName $ ".VpDetailBar");
	VPDetailGaugeMax_Txt = GetTextBoxHandle(m_VPWndName $ ".VPDetailGaugeMax_Txt");
	VPTitleTextBox = GetTextBoxHandle(m_VPWndName $ ".TitleTextBox");
	
	VpIcon = GetTextureHandle(m_VPWndName $ ".VPIcon");
	//VpIcon = GetTextureHandle("");
    //VpDetailBar = GetStatusBarHandle(""); 

	/***************
	 * PC? ??? 
	 * */
	PCCafeEventWnd = GetWindowHandle(m_PCCafeWndwName);
	HelpButton = GetWindowHandle(m_PCCafeWndwName $ ".HelpButton");
	
	/***************
	 * ??
	 * */
	ToppingWnd = GetWindowHandle(m_ToppingWndName);
	

	toppingStatusIcons.Length = TOPPING_MAX;
	for(i = 0; i < TOPPING_MAX ; i ++) 
	{
		toppingStatusIcons[i] = GetStatusIconHandle(m_ToppingWndName $ ".StatusIcon" $(i + 1));
		toppingStatusIcons[i].Clear();
		toppingDisableTextures[i] = GetTextureHandle(m_ToppingWndName $ ".toppingDisable" $(i + 1));
	}

	/***************
	 * ??? ?? 
	 * */
	MysteriousMansionWaitingWnd = GetWindowHandle(m_MysteriousMansionWaitingWndName);
	MHelpButton = GetWindowHandle(m_MysteriousMansionWaitingWndName $ ".MHelpButton");
	MHelpButton.SetTooltipCustomType(getCustomToolTip(GetSystemString(2812)));
	MCancelButton = GetButtonHandle(m_MysteriousMansionWaitingWndName $ ".MCancelButton");


	/***************
	 * ?? ??? 
	 * */
	ElementalExpViewerWnd = GetWindowHandle(m_ElementalExpViewerWndName);
	ElementalExpBar = GetStatusBarHandle(m_ElementalExpViewerWndName $ ".ElementalExpBar");
	ElementalIcon = GetTextureHandle(m_ElementalExpViewerWndName $ ".ElementalIcon");
	ElementalGrandNameText = GetTextBoxHandle(m_ElementalExpViewerWndName $ ".TitleTextBox");
	ElementalLevelText = GetTextBoxHandle(m_ElementalExpViewerWndName $ ".NumberTextBox");
	/***************
	 * BC ??? , ??? ???? ?? ?? ?? ??? ??? ??? ?? ?? ???..
	 * */
	BloodyCoinWnd = GetWindowHandle(m_BloodyCoinWndName);
	BloodCoinAddAnim = GetAnimTextureHandle(m_BloodyCoinWndName $ ".BloodCoinAddAnim");
	BloodCoinTitleTextBox = GetTextBoxHandle(m_BloodyCoinWndName $ ".TitleTextBox");
	BloodyCoin_shopIcon = GetTextureHandle(m_BloodyCoinWndName $ ".BloodyCoin_shopIcon");

	BloodCoinAddAnim.Stop();
	HelpBCButton = GetButtonHandle(m_BloodyCoinWndName $ ".HelpBCButton");
	bloodCoin = -1;

	/***
	 *  ?? ??
	 **/
	MagicLampEventWnd = GetWindowHandle(m_MagicLampWndName);
	MagicLampHelp_Btn = GetButtonHandle(m_MagicLampWndName $ ".MagicLampHelp_Btn");
	GameStart_Btn = GetButtonHandle(m_MagicLampWndName $ ".GameStart_Btn");

	MagicLampNum_Txt = GetTextBoxHandle(m_MagicLampWndName $ ".MagicLampNum_Txt");
	MagicLampGaugeMax_Txt = GetTextBoxHandle(m_MagicLampWndName $ ".MagicLampGaugeMax_Txt");
	MagicLampNum_StatusBar = GetStatusBarHandle(m_MagicLampWndName $ ".MagicLampNum_StatusBar");

	RandomCraftInfoWnd = GetWindowHandle(m_RandomCraftInfoWndName);
	RandomCraftNum_StatusBar = GetStatusBarHandle(m_RandomCraftInfoWndName $ ".RandomCraftNum_StatusBar");
	RandomCraftSmallIcon_Ani = GetAnimTextureHandle(m_RandomCraftInfoWndName $ ".RandomCraftSmallIcon_Ani");
	RandomCraftNoticeIcon_Tex = GetTextureHandle(m_RandomCraftInfoWndName $ ".RandomCraftNoticeIcon_Tex");
	RandomCraftNum_Txt = GetTextBoxHandle(m_RandomCraftInfoWndName $ ".RandomCraftNum_Txt");
	RandomCraftMax_Txt = GetTextBoxHandle(m_RandomCraftInfoWndName $ ".RandomCraftMax_Txt");
	RandomCraftCharging_Btn = GetButtonHandle(m_RandomCraftInfoWndName $ ".RandomCraftCharging_Btn");
	RandomCraftRandom_Btn = GetButtonHandle(m_RandomCraftInfoWndName $ ".RandomCraftRandom_Btn");
	RandomCraftMaterial_Btn = GetButtonHandle(m_RandomCraftInfoWndName $ ".RandomCraftMaterial_Btn");
	RandomCraftNoticeIcon_Tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon_dis");

	/***************
	 * ?? 
	 * */
	Me = GetWindowHandle(m_WindowName);
	windowBackground = GetTextureHandle(m_WindowName $ ".CTextureCtrl939");

	setWindowOrder();

	//branch : gorillazin 10. 04. 14. - pc cafe event
	m_bIsPCCafeEvent = false;	
	//end of branch	
	
	setWindowShowHide(MagicLampEventWnd, false);

	setWindowShowHide(RandomCraftInfoWnd, false);
}

// ??? ?? ??
function setWindowOrder()
{
	local int i;

	allWindow.Length = WINDOWS_MAX;
	allWindow[i++] = ToppingWnd;
	allWindow[i++] = VPWnd;
	allWindow[i++] = ElementalExpViewerWnd;
	allWindow[i++] = BloodyCoinWnd;
	allWindow[i++] = PCCafeEventWnd;
	allWindow[i++] = MysteriousMansionWaitingWnd;
	allWindow[i++] = MagicLampEventWnd;
	allWindow[i++] = RandomCraftInfoWnd;

}

function OnEvent(int a_EventID, String a_Param)
{
	// Debug("OnEvent" @ a_EventID);
	return;

	switch(a_EventID)
	{
		//branch EP1.0 2014-3-6 luciper3 - OnEnter, OnExit ??? ????? ??? ?? ???????.. ?????? ???? ???
		case EV_GamingStateEnter:
	//		Debug("EV_GamingStateEnter");
			handleOnGamingStateEnter();
			break;
		case EV_GamingStatePreExit:
	//		Debug("EV_GamingStatePreExit");
			//??? ??? ?? ???? ??? ?? ??.
			bIsShowBackup = PCCafeEventWnd.IsShowWindow();
			break;
			//end of branch
		/******************************************
		 * ?? ??, ??? ??? ?? ??? 
		 */
		case EV_AbnormalStatusNormalItem :	
			handleBuffEvent(a_Param);

			// ?? ???, ?? % ??? ? ??? ?? ????? ?? ? ??.
			if(getInstanceUIData().getIsClassicServer()) 
			{
				if(!isAfterStatusNormaEvent) 
				{
					isAfterStatusNormaEvent = true;
					showVPSystemMsg();
				}
			}
			break;

		/******************************************
		 * ??? ??? ?? ??? 
		 */
		case EV_UpdateUserInfo:
			handleVPPoint();
			break;
		case EV_VitalityEffectInfo:		
			// End:0xB8
			if(getInstanceUIData().getIsClassicServer())
			{
				HandleVitalityEffectInfo(a_Param);
			}
			break;

		/*********************************************
		 * PC ??? ?? ??? 
		 */
		case EV_PCCafePointInfo:
			HandlePCCafePointInfo(a_Param);
			break;
		case EV_ToggleShowPCCafeEventWnd:
			HandleToggleShowPCCafeEventWnd();
			break;

		/*********************************************
		 * ??? ??? ?? ??? ? 
		 */
		case EV_Restart :
			setWindowShowHide(MysteriousMansionWaitingWnd, false);
			setWindowShowHide(MagicLampEventWnd, false);
			setWindowShowHide(RandomCraftInfoWnd, false);
			bloodCoin = -1;
			RandomCraftNoticeIcon_Tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon_dis");
			break;
		case EV_CuriousHouseEnter :     //9320
			setWindowShowHide(MysteriousMansionWaitingWnd, false);		
			break;	
		case EV_CuriousHouseWaitState:  //9310
			CuriousHouseHandle(a_Param);
			break;
		case EV_NeedResetUIData :    
			MHelpButton.SetTooltipCustomType(getCustomToolTip(GetSystemString(2812)));
			break;

		/*********************************************
		 * ?? ??? ?
		 */
		case EV_ElementalSpiritGetExp :
			HandleSpriteExp(a_Param);
			// Debug("EV_ElementalSpiritGetExp" @ a_Param);
			break;
		
		/*********************************************
		 * BC ?
		 */
		case EV_BloodyCoinCount :
			HandleBloodyCoin(a_Param);			
			break;

		case EV_MagicLamp_ExpInfo :
			HandleMagicLamp(a_Param);	
			break;
	
		case EV_ElementalSpiritSimpleInfo :			
			HandleSpriteInfo(a_Param);
			break;
	}
}

function ParsePacket_S_EX_CRAFT_INFO(UIPacket._S_EX_CRAFT_INFO packet)
{
	local float fPer;
	local float maxPoint;
	local int currentCharge;
	local int maxGauge;

	maxPoint = Class'RandomCraftAPI'.static.GetMaxItemPoint();
	maxGauge = Class'RandomCraftAPI'.static.GetMaxGaugeValue();
	setWindowShowHide(RandomCraftInfoWnd,True);
	RandomCraftNum_Txt.SetText("x" $ string(packet.nPoint));
	if(packet.nPoint >= maxPoint && packet.nCharge >= maxGauge - 1)
	{
		RandomCraftMax_Txt.SetText("Max");
	}
	else
	{
		
		currentCharge = int(getInstanceL2Util().Get9999Percent(packet.nCharge, maxGauge));
		fPer = currentCharge / maxGauge * 100;
		RandomCraftMax_Txt.SetText(cutFloat(fPer));
	}
	if(packet.bGiveItem > 0)
	{
		RandomCraftNoticeIcon_Tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon");
	}
	else
	{
		RandomCraftNoticeIcon_Tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon_dis");
	}
	RandomCraftNum_StatusBar.SetPoint(packet.nCharge, maxGauge);
}

function OnClickButton(String a_ButtonID)
{
	Debug("a_ButtonID" @ a_ButtonID);
	switch(a_ButtonID)
	{
		// PC ? ??? ?? ??
		case "CloseButton":	HandleToggleShowPCCafeEventWnd();    
			break;
		case "BloodyCoinBtn" : HandleToggleShowShopDailyWnd();
			break;	
		case "PCCafeBtn":	HandleToggleShowPCCafeCommuniWnd();    
			break;
		// ??? ?? ?? ??	
		case "MCancelButton":	RequestCancelCuriousHouse();
			break;
		// ?? ?? ? ??
		case "GameStart_Btn": toggleWindow("MagicLampWnd", true, true);
			break;
		case "RandomCraftItemPointCharge_Btn":
			toggleWindow("RandomCraftChargingWnd",True,True);
			break;
		case "RandomCraftRandom_Btn":
			toggleWindow("RandomCraftWnd",True,True);
			break;
		case "RandomCraftMaterial_Btn":
			if(GetWindowHandle("MultiSellWnd").IsShowWindow())
				GetWindowHandle("MultiSellWnd").HideWindow();
			else
				API_C_EX_MULTI_SELL_LIST(915);
			break;
	}
}

function API_C_EX_MULTI_SELL_LIST(int nMultiSellID)
{
	local array<byte> stream;
	local UIPacket._C_EX_MULTI_SELL_LIST packet;

	packet.nGroupID = nMultiSellID;
	if(!Class'UIPacket'.static.Encode_C_EX_MULTI_SELL_LIST(stream,packet))
		return;

	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_MULTI_SELL_LIST,stream);
	Debug("----> Api Call : C_EX_MULTI_SELL_LIST ∏÷∆??? »?√‚ ");
}

/*********************************************************************************************************
 *
 * ?? ?? ??
 * 
 ********************************************************************************************************/

// ?? ?? ?? ??.
function getToppingDefault()
{
	local int i ;
	local ToppingSkillExtraInfo tmpSkillExtraInfo;
//	Debug("getToppingDefault");
	toppingDefaultInfos.Remove(0, toppingDefaultInfos.Length);
	toppingDefaultInfos.Length = TOPPING_MAX;
	
	class'UIDATA_SKILL'.static.GetFirstDefaultToppingSkillExtraInfo(toppingDefaultInfos[0]);		
	
	while(class'UIDATA_SKILL'.static.GetNextDefaultToppingSkillExtraInfo(tmpSkillExtraInfo)) 
	{
		i ++ ;
		toppingDefaultInfos[ i ] = tmpSkillExtraInfo;
	}
}

// ?? ???? ???? ???? ??
function setToppingBuffIcon(int slotIndex, StatusIconInfo toppingInfo, bool bActive)
{	
	local StatusIconInfo  tmpInfo;
	
//	Debug("setToppingBuffIcon" @ slotIndex);
	toppingStatusIcons[ slotIndex -1 ].GetItem(0, 0, tmpInfo);

	if(bActive)  toppingDisableTextures[ slotIndex -1 ].hideWindow();
	else toppingDisableTextures[ slotIndex -1 ].showWindow();

	if(tmpInfo == toppingInfo) return;

//	Debug("setToppingBuffIcon add " @ slotIndex);

	toppingStatusIcons[ slotIndex -1 ].Clear();
	toppingStatusIcons[ slotIndex -1 ].AddRow();
	toppingStatusIcons[ slotIndex -1 ].AddCol(0, toppingInfo);
}

// ?? ???? ??
function handleBuffEvent(string param) 
{
	local int i;
	local int Max;
	local StatusIconInfo info ;	
	local ToppingSkillExtraInfo toppingSkillInfo;
	local array<int> bActivedSlot ;

	bActivedSlot.Length = TOPPING_MAX;

	//info ???
	info.Size = TOPPING_ICON_WH;
	info.BackTex = "l2ui_ct1.Ntopping_Lock";
	info.bShow = true;
	info.bEtcItem = false;
	info.bShortItem = false;	

	ParseInt(param, "ServerID", info.ServerID);
	ParseInt(param, "Max", Max);
	 
	//GetFirstToppingSkillExtraInfo(toppingSkillInfo);

	for(i = 0 ; i < Max ; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "SkillLevel_" $ i, info.Level);
		ParseInt(param, "SkillSubLevel_" $ i, info.SubLevel);
		ParseInt(param, "RemainTime_" $ i, info.RemainTime);
		ParseString(param, "Name_" $ i, info.Name);
		ParseString(param, "IconName_" $ i, info.IconName);
		ParseString(param, "IconPanel_" $ i, info.IconPanel);
		ParseString(param, "Description_" $ i, info.Description);

		// ??? ? ?? ???? ??
		if(class'UIDATA_SKILL'.static.IsToppingSkill(info.ID, info.Level, info.SubLevel)) 
		{			
			class'UIDATA_SKILL'.static.GetToppingSkillExtraInfo(info.ID, info.Level, info.SubLevel, toppingSkillInfo);
			bActivedSlot[ toppingSkillInfo.slotIndex -1 ] = 1;
			//Debug("setActiveToppingBuff index :" @ toppingSkillInfo.ID @ bActivedSlot[ toppingSkillInfo.slotIndex -1 ] @ toppingSkillInfo.Level @ info.SubLevel @ toppingSkillInfo.slotIndex -1);
			setToppingBuffIcon(toppingSkillInfo.slotIndex, info, true);
			//Debug("GetToppingSkillExtraInfo" @  toppingSkillInfo.ID @ toppingSkillInfo.Level @ toppingSkillInfo.subLevel @ toppingSkillInfo.slotIndex @ toppingSkillInfo.bIsDefault);
		}
	}

	setDefaultToppingBuff(bActivedSlot);
}

// ??? ?? ??? ??
function setDefaultToppingBuff(array<int> bActivedSlot)
{
	local int i;
	local StatusIconInfo info;
	local bool isActived;
	local bool isActivedTopping;

		//info ???
	info.Size = TOPPING_ICON_WH;
	info.BackTex = "l2ui_ct1.Ntopping_Lock";
	info.bShow = true;
	info.bEtcItem = false;
	info.bShortItem = false;
	
	for(i = 0 ; i < TOPPING_MAX ; i++)
	{
		isActived = bActivedSlot[i] == 1 ;
		if(isActived)
			isActivedTopping = True;

		//Debug("setDefaultToppingBuff index :"  @ i @ isActived @ bActivedSlot[i]);
		// ?? ??? ?? ??? ??? ? ??? ??? ??? default ??? ??? ?? ?.
		// ?? ?? default ?? ?? ?? ?.
		if(!isActived)
		{			
			//Debug("setDefaultToppingBuff index :"  @ i);
			info.ID = GetItemID(toppingDefaultInfos[i].ID);
			info.Level = toppingDefaultInfos[i].Level;
			info.SubLevel = toppingDefaultInfos[i].SubLevel;
			info.RemainTime = -1;
			info.Name = class'UIDATA_SKILL'.static.GetName(info.ID, info.Level, info.SubLevel);
			info.Description = class'UIDATA_SKILL'.static.GetDescription(info.ID, info.Level, info.SubLevel);
			info.IconName = class'UIDATA_SKILL'.static.GetIconName(info.ID, info.Level, info.SubLevel);
			info.IconPanel = class'UIDATA_SKILL'.static.GetIconPanel(info.ID, info.Level, info.SubLevel);

			setToppingBuffIcon(i + 1, info, false); 			
		}
	}
	setWindowShowHide(ToppingWnd,isActivedTopping);
}


/**************************************************************************
 * 
 * ??? ?? 
 * 
 * ******************************************************************************/

function handleVPPoint()
{
	local UserInfo UserInfo;
	local int vitality, VitalNum, VitalityPer, VitalityPerText, oneline, MaxVitality;

	MaxVitality = GetMaxVitality();
	oneline = MaxVitality / 25;
	// End:0x1A2
	if(GetPlayerInfo(UserInfo))
	{
		vitality = UserInfo.nVitality;
		// End:0x81
		if(vitality == 0)
		{
			VitalityPer = 0;
			VPDetailGaugeMax_Txt.SetText("0%");
			VPTitleTextBox.SetText(GetSystemString(2492) @ "x0");
		}
		else if(vitality == MaxVitality)
		{
			VitalityPer = oneline;
			VPDetailGaugeMax_Txt.SetText(GetSystemString(3451));
			VPTitleTextBox.SetText(GetSystemString(2492) @ "x24("$ GetSystemString(3451) $ ")");
		}
		else
		{
			VitalNum = (vitality - 1) / oneline;
			VitalityPer = vitality - (VitalNum * oneline);
			VitalityPerText = VitalityPer * 100 / oneline;
			// End:0x142
			if(VitalityPerText == 0)
			{
				VitalityPerText = 1;
			}
			VPDetailGaugeMax_Txt.SetText(string(VitalityPerText) $ "%");
			VPTitleTextBox.SetText(GetSystemString(2492) @ "x" $ VitalNum);
		}

		VpDetailBar.SetPoint(VitalityPer, oneline);
	}
}

// ?????? ?? ???? ???? ??.
function HandleVitalityEffectInfo(string param)
{
	local CustomTooltip t;
	local int nVitality, nVitalityItemRestoreCount;
	local string sBonusString, sExtraBonusString;
	local L2Util util;

	ParseInt(param, "vitalityPoint", nVitality);
	ParseInt(param, "vitalityBonus", nVitalityBonus);
	ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
	ParseInt(param, "maxRestoreCount", nVitalityItemMaxRestoreCount);

	// ?? ?? ??? ?? 2015.05
	ParseInt(param, "vitalityExtraBonus", nVitalityExtraBonus);
	sBonusString = nVitalityBonus $ "%";
	// End:0xD7
	if(nVitalityExtraBonus > 0)
	{
		sExtraBonusString = "(+" $ nVitalityExtraBonus $ "%)";
	}	
	
	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);

	// ?? ???:
	util.ToopTipInsertText(GetSystemString(2494), true, false);
	
	// ??? 0 ? ?? ??? ??
	if(nVitality <= 0)
	{		
		util.ToopTipInsertText(GetSystemString(2496), true, false, util.ETooltipTextType.COLOR_GRAY);			
		util.ToopTipInsertText(", ", true, false);
		VpIcon.SetTexture("L2UI_CT1.Icon.InfoWnd_VPIcon_dis");
	}
	// ?? 0 ??? ?? 
	else
	{
		util.ToopTipInsertText(sBonusString, true, false);
		util.ToopTipInsertText(sExtraBonusString, true, false, util.ETooltipTextType.COLOR_YELLOW03);		
		util.ToopTipInsertText(" " $ GetSystemString(2495) $ ". " , true, false);
		VpIcon.SetTexture("L2UI_CT1.Icon.InfoWNd_VPIcon");
	}

	VpDetailBar.SetTooltipCustomType(util.getCustomToolTip());	
	// End:0x27A
	if((isVPApply && nVitality == 0) || ! isVPApply && nVitality > 0)
	{
		showVPSystemMsg();
	}
}

function showVPSystemMsg()
{
	local string sBonusString, sExtraBonusString, sSysMsgParamString;
	local UserInfo UserInfo;
	local int nVitality;
	local string sMessage;

	// End:0x12
	if(! GetPlayerInfo(UserInfo))
	{
		return;
	}

	nVitality = UserInfo.nVitality;

	sBonusString = nVitalityBonus $ "%";
	if(nVitalityExtraBonus > 0) 
	{
		sExtraBonusString = "(+" $ nVitalityExtraBonus $ "%)";
	}
	
	// ?? ??? ?? ??? ??
	// ??? ? ?? ??, ?? ?? ???? ?? ? ? ??? ?.
	if(isAfterStatusNormaEvent)
	{
		isVPApply = nVitality > 0;

		// ?? ???? 0?? ? ?? ?? ??
		if(isVPApply)
		{
			//AddSystemMessage(3525);
			ParamAdd(sSysMsgParamString, "Type", string(int(ESystemMsgParamType.SMPT_STRING)));
			ParamAdd(sSysMsgParamString, "param1", sBonusString$sExtraBonusString);
			AddSystemMessageParam(sSysMsgParamString);
			sSysMsgParamString="";
			ParamAdd(sSysMsgParamString, "Type", string(int(ESystemMsgParamType.SMPT_NUMBER)));
			ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
			AddSystemMessageParam(sSysMsgParamString);
			sMessage = EndSystemMessageParam(6067, true);
			if(!getInstanceUIData().getIsClassicServer()) AddSystemMessageString(sMessage);			
			isVPApply = true;
		}
		// ??? ??
		else 
		{
			//AddSystemMessage(3526);
			ParamAdd(sSysMsgParamString, "Type", string(int(ESystemMsgParamType.SMPT_NUMBER)));
			ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
			AddSystemMessageParam(sSysMsgParamString);
			sMessage = EndSystemMessageParam(6068, true);
			AddSystemMessageString(sMessage);
			isVPApply = false;
		}
	}
}

/*********************************************************************************************************
 *
 * ?? ??? ??
 * 
 ********************************************************************************************************/
function HandleSpriteInfo(string param)
{
	ParseInt(param, "SpiritClassID", currentemelentalInfo.SpiritClassID);
	ParseInt(param, "CurrLevel", currentemelentalInfo.CurrLevel);
	ParseInt(param, "MaxLevel", currentemelentalInfo.MaxLevel);
	ParseInt(param, "CurrSpiritType", currentemelentalInfo.CurrSpiritType);
	ParseInt(param, "EvolLevel", currentemelentalInfo.EvolLevel);
	ParseInt(param, "NpcID", currentemelentalInfo.NpcID);
	ParseINT64(param, "Exp", currentemelentalInfo.Exp);
	ParseINT64(param, "MaxExp", currentemelentalInfo.MaxExp);
	ParseINT64(param, "NextExp", currentemelentalInfo.NextExp);

	// ???
	SetElemantalTexture();	
	SetElemantalTitle();	
	//Debug("HandleSpriteInfo Name" @ class'UIDATA_NPC'.static.GetNPCNickName(currentemelentalInfo.SpiritClassID) @ currentemelentalInfo.SpiritClassID);
	// ??
	setElemantalLevel();
	// Exp ??? 
	//Debug("HandleSpriteInfo" @ expValue @ "/" @(float(currentemelentalInfo.Exp - expValue) /(currentemelentalInfo.NextExp - expValue)));
	SetElementalExp();
}

function HandleSpriteExp(string param) 
{
	local int64 Exp;
	local int Type;

	//Debug("HandleSpriteExp" @  param);

	parseInt64(param, "Exp", Exp);
	parseInt(param, "Type", Type);

	if(currentemelentalInfo.CurrSpiritType == Type) 
	{
		currentemelentalInfo.Exp = Exp ;
		SetElementalExp();
	}
}

function SetElementalExp() 
{
	local INT64 expValue ;

	//expValue = 0 ;
	//if(currentemelentalInfo.CurrLevel > 1) 
	GetElementalSpiritExpData(currentemelentalInfo.CurrSpiritType, currentemelentalInfo.EvolLevel, currentemelentalInfo.CurrLevel - 1, expValue);
	//Debug("HandleSpriteInfo" @ currentemelentalInfo.Exp @ currentemelentalInfo.NextExp @ currentemelentalInfo.MaxExp @ expValue);

	ElementalExpBar.SetPointExpPercentRate(float(currentemelentalInfo.Exp - expValue) / float(currentemelentalInfo.NextExp - expValue));
}

function SetElemantalTitle() 
{
	local string nickName, ellipsedNickName ;
	nickName = class'UIDATA_NPC'.static.GetNPCNickName(currentemelentalInfo.NpcID);
	// nickName = nickName @ "abcd efghijkl mn";
	ellipsedNickName = GetEllipsisString(nickName, 120);

	// ?? ?? 
	if(nickName != ellipsedNickName) 
		ElementalGrandNameText.SetTooltipString(nickName);
	else 
		ElementalGrandNameText.SetTooltipString("");
	
	ElementalGrandNameText.SetText(ellipsedNickName);
	//ElementalGrandNameText.SetText(class'UIDATA_NPC'.static.GetNPCName({	GetCurrentSpiritNpcID()));
}

function SetElemantalTexture() 
{
	local string textureName ;
	
	switch(currentemelentalInfo.CurrSpiritType) 
	{
		case 0 : 
			setWindowShowHide(ElementalExpViewerWnd, false);		
			break;
		case 1 :textureName = "L2UI_CT1.Icon.InfoWnd_FireIcon";
		break;
		case 2 :textureName = "L2UI_CT1.Icon.InfoWnd_WaterIcon";
		break;
		case 3 :textureName = "L2UI_CT1.Icon.InfoWnd_WindIcon";
		break;
		case 4 :textureName = "L2UI_CT1.Icon.InfoWnd_EarthIcon";
		break;
	}
	ElementalIcon.SetTexture(textureName);
}

function setElemantalLevel() 
{	
	//if(currentemelentalInfo.CurrLevel == currentemelentalInfo.MaxLevel) 
	//	ElementalLevelText.SetText(GetSystemString(88) @ GetSystemString(3451));
	//else 
	//ElementalLevelText.SetText(GetSystemString(88) @ String(currentemelentalInfo.CurrLevel));
	ElementalLevelText.SetText(String(currentemelentalInfo.CurrLevel));
}

/**************************************************************************
 * 
 * ?? ?? ??
 * 
 * ******************************************************************************/
function HandleMagicLamp(String a_Param)
{
	local int nIsOpen, nCount;
	local Int nCurrExp, nMaxExp;
	local float expPer;
	
	ParseInt(a_Param, "Count", nCount);
	ParseInt(a_Param, "IsOpen", nIsOpen);

	ParseInt(a_Param, "CurrExp", nCurrExp);
	ParseInt(a_Param, "MaxExp", nMaxExp);

	//Debug(" --> EV_MagicLamp_ExpInfo" @ a_Param);
	/*
	"CurrExp"   // ?????
	"MaxExp"   // ?????
	"Count" // ?? ??
	"IsOpen" // 1:Open 0:Close
	*/

	MagicLampNum_Txt.SetText("x" $ string(nCount));

	MagicLampGaugeMax_Txt.ShowWindow();
	// ??????? MAX ?? 
	if(nCount >= 99 && nCurrExp >= nMaxExp)
		MagicLampGaugeMax_Txt.SetText("Max");
	else 
	{
		expPer =(float(nCurrExp) / float(nMaxExp)) * 100f;
		MagicLampGaugeMax_Txt.SetText(cutFloat(expPer));
	}
		
	MagicLampNum_StatusBar.SetPoint(nCurrExp, nMaxExp);

	if(nIsOpen == 1)
	{
		// ??? ??
		// ??? ?? ?? ???? ???? ?? ? ???, ???? ?? ?? ?? ?? 1?? ?? ? ????.
		//MagicLampHelp_Btn.SetTooltipCustomType(getCustomToolTip(GetSystemString(3939)));

		MagicLampHelp_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3939), 200));

		//MagicLampEventWnd.ShowWindow();
		setWindowShowHide(MagicLampEventWnd, true);
	}
	else
	{
		setWindowShowHide(MagicLampEventWnd, false);
	}
}

// ???, ???? ???
function string cutFloat(float probability)
{
	local string probabilityStr;
	local array<string>	arrSplit;

	// ??? 99.00 ??? ? ????..
	Split(string(probability), ".", arrSplit);

	if(probability >= 100)
	{
		probabilityStr = "100%";		
	}
	else
	{
		if(arrSplit.Length == 2)
		{
			if(Len(arrSplit[1]) >= 2)
			{
				probabilityStr = arrSplit[0] $ "." $ Mid(arrSplit[1],0,2) $ "%";
			}
			else 
			{
				
				probabilityStr = string(probability) $ "%";
			}
		}
		else
		{
			probabilityStr = string(probability) $ "%";
		}

	}

	return probabilityStr;
}


/**************************************************************************
 * 
 * BC ??
 * 
 * ******************************************************************************/
function HandleBloodyCoin(string param) 
{
	local int64 currentCoin ;
	parseInt64(param, "CoinCount" ,currentCoin);
	// Debug("HandleBloodyCoin" @ param);
	RefreshBCInfo(currentCoin);
}

function RefreshBCInfo(int64 currentCoin)
{
	local Color TextColor;
	local String AddPointText;
	
	local int64 coinAdded ;
	local bool isFirstLoad ;

	isFirstLoad = bloodCoin == -1;
	coinAdded = currentCoin - bloodCoin;	

	 //Debug("RefreshBCInfo " @ currentCoin @ bloodCoin @ coinAdded @ class'UIAPI_TEXTBOX'.static.GetText(m_BloodyCoinWndName $ ".PointTextBox"));
	// ?? ? ??
	
	class'UIAPI_TEXTBOX'.static.SetText(m_BloodyCoinWndName $ ".PointTextBox", MakeCostString(String(currentCoin)));
	// ? ?? ??? ??? ???? ???.
	// ??? ?? BC ? ???? ??.
	
	bloodCoin = currentCoin;

	if(isFirstLoad) return;

	// class'UIAPI_WINDOW'.static.SetAlpha(m_BloodyCoinWndName $ ".PointAddTextBox", 0);

	if(0 != coinAdded)
	{
		// ???? ??
		if(0 < coinAdded)
		{
			AddPointText = "+" $ MakeCostString(String(coinAdded));
			TextColor.R = 255;
			TextColor.G = 255;
			TextColor.B = 0;
			BloodCoinAddAnim.SetLoopCount(1);
			// BloodCoinAddAnim.Stop();
			BloodCoinAddAnim.Play();
		}
		// ?? ?? ??
		else if(0 > coinAdded)
		{
			AddPointText = MakeCostString(String(coinAdded));
			TextColor.R = 255;
			TextColor.G = 0;
			TextColor.B = 0;
		}
		else return;

		class'UIAPI_TEXTBOX'.static.SetText(m_BloodyCoinWndName $ ".PointAddTextBox", AddPointText);
		class'UIAPI_TEXTBOX'.static.SetTextColor(m_BloodyCoinWndName $ ".PointAddTextBox", TextColor);
        class'UIAPI_WINDOW'.static.SetAnchor(m_BloodyCoinWndName $ ".PointAddTextBox", m_BloodyCoinWndName, "TopRight", "TopRight", -5, 41);
        class'UIAPI_WINDOW'.static.ClearAnchor(m_BloodyCoinWndName $ ".PointAddTextBox");
        class'UIAPI_WINDOW'.static.Move(m_BloodyCoinWndName $ ".PointAddTextBox", -5, -18, 0f);
        class'UIAPI_WINDOW'.static.Move(m_BloodyCoinWndName $ ".PointAddTextBox", 0, -25, 0.3f);
        class'UIAPI_WINDOW'.static.SetAlpha(m_BloodyCoinWndName $ ".PointAddTextBox", 255);
        class'UIAPI_WINDOW'.static.SetAlpha(m_BloodyCoinWndName $ ".PointAddTextBox", 0, 0.3f);

	    GetButtonHandle(m_BloodyCoinWndName $ ".BloodyCoinBtn").SetAlpha(0);
        GetButtonHandle(m_BloodyCoinWndName $ ".BloodyCoinBtn").SetAlpha(255,0.4f);
	}
}


function HandleToggleShowShopDailyWnd()
{
	//RequestPurchaseLimitShopHtmlOpen();

	if(IsAdenServer() || getInstanceUIData().getIsClassicServer())
	{
		Debug("??? ??? ??");
		RequestOpenWndWithoutNPC(OPEN_LCOINSHOP_HTML);
	}
	else
	{
		Debug("??? ??? ??");
		RequestOpenWndWithoutNPC(OPEN_PLSHOP_HTML); 
	}

	//ShopDailyWnd(GetScript("ShopDailyWnd")).API_RequestPurchaseLimitShopItemList();	 
}


/**************************************************************************
 * 
 * PC? ??? ??
 * 
 * ******************************************************************************/

function HandleToggleShowPCCafeCommuniWnd()
{
	if(getInstanceL2Util().getIsPrologueGrowType()) AddSystemMessage(4533);
	else RequestOpenWndWithoutNPC(OPEN_PCCAFE_HTML); 

	//else class'PCCafeAPI'.static.RequestOpenWndWithoutNPC();	
}

function HandlePCCafePointInfo(String a_Param)
{
	local int Show;
	local bool bOption;

	ParseInt(a_Param, "TotalPoint", m_TotalPoint);
	ParseInt(a_Param, "AddPoint", m_AddPoint);
	ParseInt(a_Param, "PeriodType", m_PeriodType);
	ParseInt(a_Param, "RemainTime", m_RemainTime);
	ParseInt(a_Param, "PointType", m_PointType);
	ParseInt(a_Param, "Show", Show);
	// 2015-06-25 
	// http://wallis-devsub/redmine/issues/1792
	// ?? ??? ?? ?? ?? 
	// ParseInt(a_Param, "DailyPoint", m_DailyPoint);		//CT26P4_0323
	
	//branch : gorillazin 10. 04. 14. - pc cafe event
	// EV_PCCafePointInfo ???? ???? PC Cafe ???? ???? ??? ???? ?? ???? ??.
	// ? function? Show ??? ?? ??? ?? ?? ??.
 	if(Show > 0 && !m_bIsPCCafeEvent)
 	{		
		// PC ?? ????? ???? ? ??? ? ?? ? ????
		bOption = GetOptionBool("ScreenInfo", "IsPcRoomBox");
 		if(!bOption) setWindowShowHide(PCCafeEventWnd, true);
 		m_bIsPCCafeEvent = true;
 	}
	//end of branch	
	RefreshPcCafeInfo(Show);
}

function bool IsPCCafeEventOpened()
{
	if(0 < m_PeriodType)
		return true;

	return false;
}

function RefreshPcCafeInfo(int nShow)
{
	local Color TextColor;
	local String AddPointText;
	local String FullPointText;		//CT26P4_0323

	if(nShow == 0)
	{
		//PCCafeEventWnd.HideWindow();
		setWindowShowHide(PCCafeEventWnd);		
	}
	
	//HelpButton.SetTooltipCustomType(SetTooltip(GetHelpButtonTooltipText()));

	HelpButton.SetTooltipCustomType(getCustomToolTip(GetSystemString(2256)));

	FullPointText = MakeCostString(String(m_TotalPoint));

	//CT26P4_0323
	/*
	if(m_DailyPoint > 0) {
		nDailyMin = m_DailyPoint / 20;
		nDailyHour = nDailyMin / 60;
		nDailyMin = nDailyMin - nDailyHour * 60;
		FullPointText = FullPointText $ " [" $ GetFormattedTimeStrMMHH(nDailyHour, nDailyMin) $ "]";
	}*/
	
	class'UIAPI_TEXTBOX'.static.SetText(m_PCCafeWndwName $ ".PointTextBox", FullPointText);
	class'UIAPI_WINDOW'.static.SetAlpha(m_PCCafeWndwName $ ".PointAddTextBox", 0);
	if(0 != m_AddPoint && nShow != 0)
	{
		if(0 < m_AddPoint)
			AddPointText = "+" $ MakeCostString(String(m_AddPoint));
		else
			AddPointText = MakeCostString(String(m_AddPoint));

		class'UIAPI_TEXTBOX'.static.SetText(m_PCCafeWndwName $ ".PointAddTextBox", AddPointText);

		switch(m_PointType)
		{
		case 0:	// Normal
			TextColor.R = 255;
			TextColor.G = 255;
			TextColor.B = 0;
			break;
		case 1:	// Bonus			
			TextColor.R = 0;
			TextColor.G = 255;
			TextColor.B = 255;
			break;
		case 2:	// Decrease			
			TextColor.R = 255;
			TextColor.G = 0;
			TextColor.B = 0;
			break;
		}

		//class'UIAPI_TEXTBOX'.static.SetTextColor(m_PCCafeWndwName $ ".PointAddTextBox", TextColor);
		//class'UIAPI_WINDOW'.static.SetAnchor(m_PCCafeWndwName $ ".PointAddTextBox", m_PCCafeWndwName, "TopRight", "TopRight", -5, 41);
		//class'UIAPI_WINDOW'.static.ClearAnchor(m_PCCafeWndwName $ ".PointAddTextBox");
		//class'UIAPI_WINDOW'.static.Move(m_PCCafeWndwName $ ".PointAddTextBox", 0, -18, 1.f);
		//class'UIAPI_WINDOW'.static.SetAlpha(m_PCCafeWndwName $ ".PointAddTextBox", 255);
		//class'UIAPI_WINDOW'.static.SetAlpha(m_PCCafeWndwName $ ".PointAddTextBox", 0, 0.8f);

		class'UIAPI_TEXTBOX'.static.SetTextColor(m_PCCafeWndwName $ ".PointAddTextBox", TextColor);
       class'UIAPI_WINDOW'.static.SetAnchor(m_PCCafeWndwName $ ".PointAddTextBox", m_PCCafeWndwName, "TopRight", "TopRight", -5, 41);
       class'UIAPI_WINDOW'.static.ClearAnchor(m_PCCafeWndwName $ ".PointAddTextBox");
       class'UIAPI_WINDOW'.static.Move(m_PCCafeWndwName $ ".PointAddTextBox", -5, -18, 0f);
       class'UIAPI_WINDOW'.static.Move(m_PCCafeWndwName $ ".PointAddTextBox", 0, -25, 0.3f);
       class'UIAPI_WINDOW'.static.SetAlpha(m_PCCafeWndwName $ ".PointAddTextBox", 255);
       class'UIAPI_WINDOW'.static.SetAlpha(m_PCCafeWndwName $ ".PointAddTextBox", 0, 0.3f);

	   GetButtonHandle(m_PCCafeWndwName $ ".PCCafeBtn").SetAlpha(0);
       GetButtonHandle(m_PCCafeWndwName $ ".PCCafeBtn").SetAlpha(255,0.4f);
		m_AddPoint = 0;
	}
}

/** ?? ???? ??? ???? */
function String GetHelpButtonTooltipText()
{
	local String TooltipSystemMsg;

	if(1 == m_PeriodType)
		TooltipSystemMsg = GetSystemMessage(1705);
	else if(2 == m_PeriodType)
		TooltipSystemMsg = GetSystemMessage(1706);
	else
		return "";

	return MakeFullSystemMsg(TooltipSystemMsg, string(m_RemainTime), "");
}


// ?? ???? ?? ?? ??? ???? ??
function HandleToggleShowPCCafeEventWnd(optional bool bIsForceSet, optional bool bIsHide)
{	
	//local bool bIsHideOption;
	// ?? ??? ?? ????? ???? ? ?? ???.
	//bIsHideOption = GetOptionBool("ScreenInfo", "IsPcRoomBox");
	
	//log("===== Toggle Show Func ===== IsPCCafeEvent() : "$m_bIsPCCafeEvent $ " === Force : "$bIsForceSet $ " === bIsHide : "$bIsHide);

	//branch GD35_0828 2013-12-9 luciper3 - ???? ???? ??????.
	if(bIsForceSet)
	{
		SetOptionValue(bIsHide);
		setWindowShowHide(PCCafeEventWnd, !bIsHide && IsPCCafeEvent());
		/*
		if(!bIsHide && IsPCCafeEvent())
			
			//PCCafeEventWnd.ShowWindow();
		else
//			PCCafeEventWnd.HideWindow();
			setWindowShowHide(PCCafeEventWnd);
*/
		
		//setWindowSize();
		return;
	}
	//end of branch

	if(PCCafeEventWnd.isShowWindow())
	{
		setWindowShowHide(PCCafeEventWnd);		
	}
	else if(IsPCCafeEvent())
	{
//		Debug("HandleToggleShowPCCafeEventWnd");
		setWindowShowHide(PCCafeEventWnd, true);
		//PCCafeEventWnd.ShowWindow();
	}	
}

//branch : gorillazin 10. 04. 14. - pc cafe event
function bool IsPCCafeEvent()
{
	//brancg GD35_0828 2013-12-06 luciper3 - ??????? ???? ??????? ?????.
	if(m_bIsPCCafeEvent && bIsOptionValue)
		return false;
	//end of branch

	return m_bIsPCCafeEvent;
}
//end of branch

/*********************************************************************************************************
 *
 * ??? ?? ??
 * 
 ********************************************************************************************************/

function CuriousHouseHandle(string a_Param)
{	
	local int HouseState;
	ParseInt(a_Param, "State", HouseState);
	switch(HouseState){
	case 0 : //?? ??? ????? ?? ?  ?? ???? ? ?? 		
	case 1 : //?? ??		
		setWindowShowHide(MysteriousMansionWaitingWnd, false);
		break;
	case 2 : //?? ??
		AddSystemMessage(3732);//?? ?? ???
		MCancelButton.EnableWindow();		
		setWindowShowHide(MysteriousMansionWaitingWnd, true);
		Me.SetFocus();
		break;
	case 3 : //?? ???? ??
		MCancelButton.disableWindow();
		break;		
	}
}

/*******************************************************
 * ??? ??? 
 ********************************************************/

// ?? ???? ???? ? ?? 
function handleOnGamingStateEnter()
{
	// 1 ?? ??? ?? ??.
	local int useToppingType;
	local bool bOption;

	// PC ?? ????? ???? ? ??? ? ?? ? ????
	bOption = GetOptionBool("ScreenInfo", "IsPcRoomBox");
	
	if(bOption) {
		//PCCafeEventWnd.HideWindow();
		setWindowShowHide(PCCafeEventWnd);
	} else 
	{
//		Debug("handleOnGamingStateEnter" @ PCCafeEventWnd @ bIsShowBackup);
		setWindowShowHide(PCCafeEventWnd, bIsShowBackup);
	}	
	
	// ??? ?? ? ????
	if(!GetINIBool("L2UI", "UseTopping", useToppingType, "L2.ini")) useToppingType = 0;

//	Debug("handleOnGamingStateEnter" @ useToppingType @ GetINIBool("L2UI", "UseTopping", useToppingType, "L2.ini"));
	if(useToppingType == 1) 
	{
		getToppingDefault();
	}
	setWindowShowHide(ToppingWnd,False);


	// ??? ?? ??? ? ??	
	setWindowShowHide(MysteriousMansionWaitingWnd);

	// ??? ??(???), ??? ??(???) ??? ?? ??
	if(IsBloodyServer())
	{
		// ???
		// ??? ??? ?? ???, PVP? ?? ??? ? ???,\n?? ??? ??? ??? ??? ??? ? ????.\n?? ???? ??? ??? ? ?? ?? ??? ???\n??? ?? ??? ??? ???.
		HelpBCButton.SetTooltipCustomType(getCustomToolTip(GetSystemString(3920)));
		BloodyCoin_shopIcon.SetTexture("L2UI_ct1.Icon.BloodyCoin_shopIcon");

		BloodCoinTitleTextBox.SetText(GetSystemString(3915)); // ??? ?? 
	}
	// ???, ????, ??? ?? ??
	else if(getInstanceUIData().getIsClassicServer())
	{
		// ???? ??? ?? ??? ? ???, ??? ??? ??? ??? ??? ??? ? ????.
		HelpBCButton.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3933), 200));
		

		BloodyCoin_shopIcon.SetTexture("L2UI_ct1.Icon.LCoin_shopIcon");

		BloodCoinTitleTextBox.SetText(GetSystemString(3931)); // ???
	}
}

function OnEnterState(name a_CurrentStateName)
{	
	local int nShow;
	local bool bShowCoinShop;

	return;
	/*
	 * ??
	 * */	
	isAfterStatusNormaEvent = false;

	//branch EP3.0 2016-3-16 luciper3 - ????? ??????

	setWindowShowHide(VPWnd, getInstanceUIData().getIsClassicServer());
	//setWindowShowHide(VPWnd, getInstanceUIData().getIsClassicServer());
	//end of branch
	
	//Debug("IsAdenServer()" @ IsAdenServer());
	//Debug("IsBloodyServer()" @ IsBloodyServer());
	/* 
	 * ??? ??, ??? ?, ?? ?? ??, ???, ???? ??
	 * */	
	// ? ?? ? -1 ? ???, ??? ???? ???.
	// OnLoade, Restart? ?? ?? 
	//class'UIAPI_TEXTBOX'.static.SetText(m_BloodyCoinWndName $ ".PointTextBox", "-1");
	// ?? ?? ??? ?? ?? ?? ??? 
	if(IsBloodyServer() || getInstanceUIData().getIsClassicServer())
	{
		bShowCoinShop = true;
		setWindowShowHide(BloodyCoinWnd, bShowCoinShop);
	}
	else
	{
		setWindowShowHide(BloodyCoinWnd, bShowCoinShop);
	}

	/* 
	 * Pc ? ??? 
	 * */
	if(IsPCCafeEvent())
		nShow = 1;
	else 
		nShow = 0;

	//branch : gorillazin 10. 04. 14. - pc cafe event
	RefreshPcCafeInfo(nShow);
	//end of branch	
	

	isEnterState = true;
	//Refresh(1);

	Me.ShowWindow();
}

function OnExitState(name a_CurrentStateName)
{
	//Debug("OnExitState" @ a_NextStateName);
	RefreshPcCafeInfo(0);
	// ??? ?? ??? ? ??
	//setWindowShowHide(MysteriousMansionWaitingWnd);
	isEnterState = false;
	Me.HideWindow();
	
}

function OnShow()
{
	if(!isShowInfoWnd) Me.HideWindow();
	//	Debug("onShow");
	//onShow ? setWindowShowHide ??? ?? ? ?. ?? ???? ? ?? ?? ??? ? ??? ?? ??.
	// OnEnterState ? ? ? 
}

function OnHide()
{
	//PlayConsoleSound(IFST_WINDOW_CLOSE);	
}

function CustomTooltip getCustomToolTip(string Text)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	
	Tooltip.MinimumWidth = 144;
	
	Tooltip.DrawList.Length = 1;
	info.eType = DIT_TEXT;
	info.t_bDrawOneLine = true;
	info.t_color.R = 178;
	info.t_color.G = 190;
	info.t_color.B = 207;
	info.t_color.A = 255;
	info.t_strText = Text;
	Tooltip.DrawList[0] = info;

	return Tooltip;
}


/*
 * 1. ???? show, hide 
 * 2. ? ?? ????? ??? ??.
 * 3. ? ??? ?? ?? ??? ???? ?? ?.
 * ?? ?? ??? ?? ???? ?? ?? ??? 
 */
function setWindowShowHide(WindowHandle tmpWnd, optional bool isShow)
{
	local int nWndWidth, nWndHeight, i;	
	local int nWndHMax;
	local Rect rectWnd;	
	
	if(isShow == tmpWnd.IsShowWindow()) return;	

	///if(tmpWnd == PCCafeEventWnd) Debug("setWindowShowHide" @ isShow);
	if(isShow) tmpWnd.ShowWindow();	
	else tmpWnd.hideWindow();	
	
	rectWnd = Me.GetRect();

	isShowInfoWnd = false ;

	// ?? ?? ?? ??? ??? ??? ?? ??.
	for(i = 0 ; i < allWindow.Length ; i++)
	{		
		if(allWindow[i].IsShowWindow())
		{
			//Debug("???? ??" @ allWindow[i].GetWindowName());
			allWindow[i].GetWindowSize(nWndWidth, nWndHeight);
			allWindow[i].MoveTo(rectWnd.nX, rectWnd.nY + nWndHMax);
			nWndHMax = nWndHMax + nWndHeight;
			isShowInfoWnd = true;
		}
	}	
	
	Me.SetWindowSize(rectWnd.nWidth, nWndHMax + WINDOW_H_MIN);
	windowBackground.SetWindowSize(rectWnd.nWidth, nWndHMax + WINDOW_H_MIN);
	
//	Debug("setWindowShowHide" @ isEnterState);
	if(isShowInfoWnd  && isEnterState)
	{
		//Debug("????");
		Me.ShowWindow();
	}
	else 
	{
		//Debug("??? ");
		Me.HideWindow();		
	}

//	Debug("setWindowShowHide" @ tmpWnd.GetWindowName() @ isShowInfoWnd  @ Me.IsShowWindow());
}

// branch GD35_0828 2013-12-9 luciper3 - ?? ???? ??? ????.
// ?? ?? ?? ? ?.
function SetOptionValue(bool bValue)
{
	bIsOptionValue = bValue;
}
//end of branch

/*******************************************************
 * Util
 ********************************************************/
// ??? ... ??
function String GetEllipsisString(string str, int maxWidth)
{
	local string fixedString;
	local int nWidth, nHeight, textWidth;

	textWidth = maxWidth;
	//str = str @ "123456789";
	GetTextSizeDefault(str $ "...", nWidth, nHeight);
	// End:0x3C
	if(nWidth < textWidth)
	{
		return str;
	}

	fixedString = DivideStringWithWidth(str, textWidth);
	// End:0x73
	if(fixedString != Str)
	{
		fixedString = fixedString $ "...";
	}

	return fixedString;
}

defaultproperties
{
     m_ToppingWndName="InfoWnd.ToppingWnd"
     m_VPWndName="InfoWnd.VPWnd"
     m_PCCafeWndwName="InfoWnd.PCCafeEventWnd"
     m_MysteriousMansionWaitingWndName="InfoWnd.MysteriousMansionWaitingWnd"
     m_ElementalExpViewerWndName="InfoWnd.ElementalWnd"
     m_BloodyCoinWndName="InfoWnd.BloodyCoinWnd"
     m_MagicLampWndName="InfoWnd.MagicLampEventWnd"
     m_RandomCraftInfoWndName="InfoWnd.RandomCraftInfoWnd"
     m_WindowName="InfoWnd"
}
