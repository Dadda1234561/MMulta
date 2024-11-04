class ClanSubInfoContainerPledgeBonus extends UIData;

const ACCESS_TYPE = 0;
const HUNT_TYPE = 1;

enum PledgeDonationType
{
	PDT_NORMAL,
	PDT_GREAT,
	PDT_EXCELLENT,
	PDT_MAX
};

enum tabIndex
{
	TAB_DONATION,
	TAB_RAID
};

var string m_WindowName;
var WindowHandle Me;
var ItemWindowHandle JoinYesterdayBonus_Item_ItemWnd;
var ItemWindowHandle HuntYesterdayBonus_Item_ItemWnd;
var string JoinWndPath;
var string HuntWndPath;
var string m_ClanPledgeRaidWindowName;
var int accessBonusMax;
var int huntBonusMax;
var ClanWndClassicNew clanWndClassicScr;
var UIControlNeedItemList needItemListNormalScr;
var UIControlNeedItemList needItemListFineScr;
var UIControlNeedItemList needItemListPremiumlScr;
var bool hasPledgeBonusList;
var string m_ClanPledgeDonationWnd;
var int donaRemainCount;
var PledgeDonationType DonationType;
var TabHandle tab;

function InitDefaultSetting()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	clanWndClassicScr = ClanWndClassicNew(GetScript("ClanWndClassicNew"));
	clanWndClassicScr.clanSubInfoContainerPledgeBonusScr = self;
	Me.SetFocus();
}

function Initialize()
{
	m_ClanPledgeRaidWindowName = "ClanPledgeRaid_Window";
	JoinWndPath = m_WindowName $ ".ClanPledgeBonus_Window.JoinBonusWnd";
	HuntWndPath = m_WindowName $ ".ClanPledgeBonus_Window.HuntBonusWnd";
	JoinYesterdayBonus_Item_ItemWnd = GetItemWindowHandle(m_WindowName $ ".ClanPledgeBonus_Window.JoinBonusWnd.JoinYesterdayBonus_Item_ItemWnd");
	HuntYesterdayBonus_Item_ItemWnd = GetItemWindowHandle(m_WindowName $ ".ClanPledgeBonus_Window.HuntBonusWnd.HuntYesterdayBonus_Item_ItemWnd");
	tab = GetTabHandle(m_WindowName $ ".ClanReward_TabCtrl");
	hasPledgeBonusList = false;
	m_ClanPledgeDonationWnd = "PledgeDonationWnd";
}

function OnLoad()
{
	InitDefaultSetting();
	Initialize();
	GetTextBoxHandle(m_WindowName $ "." $ m_ClanPledgeRaidWindowName $ ".ClanRaidStageTitle_Text").SetText((GetSystemString(898) @ GetSystemString(2980)) @ ":");
}

function OnRegisterEvent()
{
	RegisterEvent(EV_PledgeBonusOpen);
	RegisterEvent(EV_PledgeBonusList);
	RegisterEvent(EV_PledgeBonusUpdate);
	RegisterEvent(EV_PledgeBonusMarkReset);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_PledgeClassicRaidInfo);
	RegisterEvent(EV_GameStart);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_DONATION_INFO);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_DONATION_REQUEST);
}

function OnShow()
{
	API_C_EX_PLEDGE_DONATION_INFO();
}

function HandleOnShow()
{
	switch(GetTobIndex())
	{
		// End:0x29
		case 0:
			API_C_EX_PLEDGE_DONATION_INFO();
			// End:0x25
			break;
		// End:0x22
		case 1:
			// End:0x25
			break;
	}
}

function OnEvent(int a_EventID, string param)
{
	// End:0x17
	if(! getInstanceUIData().getIsClassicServer())
	{
		return;
	}
	switch(a_EventID)
	{
		// End:0x3F
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_DONATION_INFO:
			Handle_S_EX_PLEDGE_DONATION_INFO();
			// End:0x107
			break;
		// End:0x60
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_DONATION_REQUEST:
			Handle_S_EX_PLEDGE_DONATION_REQUEST();
			// End:0x107
			break;
		// End:0x76
		case EV_PledgeBonusOpen:
			PledgeBonusOpenHandler(param);
			// End:0x107
			break;
		// End:0x8C
		case EV_PledgeBonusList:
			PledgeBonusListHandler(param);
			// End:0x107
			break;
		// End:0xB7
		case EV_PledgeBonusMarkReset:
			hasPledgeBonusList = false;
			// End:0xB4
			if(Me.IsShowWindow())
			{
				HandleOnShow();
			}
			// End:0x107
			break;
		// End:0xCD
		case EV_PledgeBonusUpdate:
			PlegeBonusUpdate(param);
			// End:0x107
			break;
		// End:0xDD
		case EV_Restart:
			hasPledgeBonusList = false;
			// End:0x107
			break;
		// End:0xF3
		case EV_PledgeClassicRaidInfo:
			handleSetRaidSkillInfos(param);
			// End:0x107
			break;
		// End:0x104
		case EV_GameStart:
			InitDonationWnd();
			// End:0x107
			break;
		// End:0xFFFF
	}
}

function PlegeBonusUpdate(string param)
{
	local int missionType, currPoint;

	// End:0x192
	if(Me.IsShowWindow())
	{
		ParseInt(param, "MissionType", missionType);
		ParseInt(param, "CurrPoint", currPoint);
		// End:0xF5
		if(missionType == HUNT_TYPE)
		{
			// End:0xF2
			if(huntBonusMax > 0)
			{
				GetTextBoxHandle(HuntWndPath $ ".HuntBonus_MemberCount1_Text").SetText(string(currPoint));
				GetTextBoxHandle(HuntWndPath $ ".HuntBonus_MemberCount2_Text").SetText("/" $ string(huntBonusMax));
				setStateProgress(missionType, huntBonusMax, currPoint);
			}
		}
		else
		{
			// End:0x192
			if(accessBonusMax > 0)
			{
				GetTextBoxHandle(JoinWndPath $ ".JoinBonus_MemberCount1_Text").SetText(string(currPoint));
				GetTextBoxHandle(JoinWndPath $ ".JoinBonus_MemberCount2_Text").SetText("/" $ string(accessBonusMax));
				setStateProgress(missionType, accessBonusMax, currPoint);
			}
		}
	}
}

function PledgeBonusOpenHandler(string param)
{
	local int accessBonusCurr, accessRewardID, accessRewardSkillLV, accessBtnActive, huntBonusCurr, huntRewardID,
		huntRewardLV, huntBtnActive;

	local SkillInfo accessBonusSkillInfo, huntRewardSkillInfo;
	local ItemInfo accessBonusItemInfo, huntRewardItemInfo;
	local int AccessRewardType, HuntRewardType;

	ParseInt(param, "AccessRewardType", AccessRewardType);
	ParseInt(param, "AccessBonusMax", accessBonusMax);
	ParseInt(param, "AccessBonusCurr", accessBonusCurr);
	ParseInt(param, "AccessRewardID", accessRewardID);
	ParseInt(param, "AccessRewardLV", accessRewardSkillLV);
	ParseInt(param, "AccessBtnActive", accessBtnActive);
	ParseInt(param, "HuntRewardType", HuntRewardType);
	ParseInt(param, "HuntBonusMax", huntBonusMax);
	ParseInt(param, "HuntBonusCurr", huntBonusCurr);
	ParseInt(param, "HuntRewardID", huntRewardID);
	ParseInt(param, "HuntRewardLV", huntRewardLV);
	ParseInt(param, "HuntBtnActive", huntBtnActive);
	JoinYesterdayBonus_Item_ItemWnd.Clear();
	JoinYesterdayBonus_Item_ItemWnd.ClearTooltip();
	JoinYesterdayBonus_Item_ItemWnd.SetTooltipType("");
	// End:0x253
	if(accessRewardID > 0)
	{
		// End:0x211
		if(AccessRewardType == 1)
		{
			class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(accessRewardID), accessBonusItemInfo);
			JoinYesterdayBonus_Item_ItemWnd.AddItem(accessBonusItemInfo);
			JoinYesterdayBonus_Item_ItemWnd.SetTooltipType("Inventory");			
		}
		else
		{
			GetSkillInfo(accessRewardID, 1, 0, accessBonusSkillInfo);
			JoinYesterdayBonus_Item_ItemWnd.AddItem(getItemInfoBySkillInfo(accessBonusSkillInfo));
			JoinYesterdayBonus_Item_ItemWnd.SetTooltipType("Skill");
		}
	}
	GetTextBoxHandle(JoinWndPath $ ".JoinBonus_MemberCount1_Text").SetText(string(accessBonusCurr));
	GetTextBoxHandle(JoinWndPath $ ".JoinBonus_MemberCount2_Text").SetText("/" $ string(accessBonusMax));
	// End:0x3F1
	if(accessRewardID > 0)
	{
		// End:0x364
		if(AccessRewardType == 1)
		{
			GetTextBoxHandle(JoinWndPath $ ".JoinYesterdayBonusLV_Text").SetText("");
			GetNameCtrlHandle(JoinWndPath $ ".JoinYesterdaydayBonusName_Text").SetName(accessBonusItemInfo.Name, NCT_Normal, TA_Left);			
		}
		else
		{
			GetTextBoxHandle(JoinWndPath $ ".JoinYesterdayBonusLV_Text").SetText(GetSystemString(88) $ string(accessRewardSkillLV));
			GetNameCtrlHandle(JoinWndPath $ ".JoinYesterdaydayBonusName_Text").SetName(accessBonusSkillInfo.SkillName, NCT_Normal, TA_Left);
		}		
	}
	else
	{
		GetTextBoxHandle(JoinWndPath $ ".JoinYesterdayBonusLV_Text").SetText("");
		GetNameCtrlHandle(JoinWndPath $ ".JoinYesterdaydayBonusName_Text").SetName(GetSystemString(5852), NCT_Normal, TA_Left);
	}
	setStateProgress(0, accessBonusMax, accessBonusCurr);
	HuntYesterdayBonus_Item_ItemWnd.Clear();
	HuntYesterdayBonus_Item_ItemWnd.ClearTooltip();
	HuntYesterdayBonus_Item_ItemWnd.SetTooltipType("");
	// End:0x555
	if(huntRewardID > 0)
	{
		// End:0x513
		if(HuntRewardType == 1)
		{
			class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(huntRewardID), huntRewardItemInfo);
			HuntYesterdayBonus_Item_ItemWnd.AddItem(huntRewardItemInfo);
			HuntYesterdayBonus_Item_ItemWnd.SetTooltipType("Inventory");			
		}
		else
		{
			GetSkillInfo(huntRewardID, 1, 0, huntRewardSkillInfo);
			HuntYesterdayBonus_Item_ItemWnd.AddItem(getItemInfoBySkillInfo(huntRewardSkillInfo));
			HuntYesterdayBonus_Item_ItemWnd.SetTooltipType("Skill");
		}
	}
	GetTextBoxHandle(HuntWndPath $ ".HuntBonus_MemberCount1_Text").SetText(string(huntBonusCurr));
	GetTextBoxHandle(HuntWndPath $ ".HuntBonus_MemberCount2_Text").SetText("/" $ string(huntBonusMax));
	// End:0x66D
	if(huntRewardLV > 0)
	{
		GetTextBoxHandle(HuntWndPath $ ".HuntYesterdaydayBonusLV_Text").SetText(GetSystemString(88) $ string(huntRewardLV));
		GetNameCtrlHandle(HuntWndPath $ ".HuntYesterdaydayBonusName_Text").SetName(huntRewardItemInfo.Name, NCT_Normal, TA_Left);
	}
	else
	{
		GetTextBoxHandle(HuntWndPath $ ".HuntYesterdaydayBonusLV_Text").SetText("");
		GetNameCtrlHandle(HuntWndPath $ ".HuntYesterdaydayBonusName_Text").SetName(GetSystemString(5852), NCT_Normal, TA_Left);
	}
	setStateProgress(1, huntBonusMax, huntBonusCurr);
	// End:0x734
	if(accessBtnActive > 0)
	{
		GetButtonHandle(JoinWndPath $ ".Clan1_ManageBtn").EnableWindow();		
	}
	else
	{
		GetButtonHandle(JoinWndPath $ ".Clan1_ManageBtn").DisableWindow();
	}
	// End:0x794
	if(huntBtnActive > 0)
	{
		GetButtonHandle(HuntWndPath $ ".Clan2_ManageBtn").EnableWindow();		
	}
	else
	{
		GetButtonHandle(HuntWndPath $ ".Clan2_ManageBtn").DisableWindow();
	}
}

function setStateProgress(int bonusType, int nMax, int nCur)
{
	local string taretPath, arrowTexture, stateWnd;
	local float maxStep, fProgressStep;
	local int nLevel, nProgress;
	local float fProgress;
	local int i, N;

	// End:0x2D
	if(bonusType == 0)
	{
		stateWnd = JoinWndPath;
		arrowTexture = ".PledgeArrow";		
	}
	else
	{
		stateWnd = HuntWndPath;
		arrowTexture = ".HuntArrow";
	}
	maxStep = nMax / 4;
	nLevel = int(nCur / maxStep) + 1;
	fProgressStep = maxStep / 3;
	fProgress = (nCur % maxStep) / fProgressStep;
	nProgress = appCeil(fProgress);

	// End:0x2F2 [Loop If]
	for (i = 1; i < 5; i++)
	{
		// End:0x23E [Loop If]
		for(N = 1; N < 4; N++)
		{
			taretPath = stateWnd $ arrowTexture $ string(i) $ "_" $ string(N) $ "_disable_Texture";
			if ( (i == nLevel) && (N < nProgress) )
			{
				GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_normal");
			}
			else if ( i < nLevel )
			{
				GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_normal");
			}
			else if ( (i == nLevel) && (N == nProgress) )
			{
				GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_get");
			}
			else
			{
				GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_disable");
			}
		}
		taretPath = stateWnd $ "." $ "PledgeSelectPanel0" $ string(i) $ "_ani";
		GetAnimTextureHandle(taretPath).Stop();
		GetAnimTextureHandle(taretPath).Pause();
		GetAnimTextureHandle(taretPath).HideWindow();
		if ( nLevel > i )
		{
			setEnablePledgeBonus(bonusType, i, true);
		} else {
			setEnablePledgeBonus(bonusType, i, false);
		}
	}
	if ( nLevel > 1 )
	{
		taretPath = stateWnd $ "." $ "PledgeSelectPanel0" $ string(nLevel - 1) $ "_ani";
		GetAnimTextureHandle(taretPath).SetLoopCount(9999999);
		GetAnimTextureHandle(taretPath).ShowWindow();
		GetAnimTextureHandle(taretPath).Play();
	}
	if ( nCur > 0 )
	{
		setEnableFlagTexture(bonusType, true);
	} else {
		setEnableFlagTexture(bonusType, false);
	}
}

function setEnableFlagTexture(int bonusType, bool bFlag)
{
	local string stateWnd;

	if ( bonusType == 0 )
	{
		stateWnd = JoinWndPath;
	} else {
		stateWnd = HuntWndPath;
	}
	if ( bFlag )
	{
		GetTextureHandle(stateWnd $ ".PledgeflagIcon2_texture").SetTexture("L2UI_CT1.PledgeflagIcon3");
	} else {
		GetTextureHandle(stateWnd $ ".PledgeflagIcon2_texture").SetTexture("L2UI_CT1.PledgeflagIcon2");
	}
}

function bool hasPoint (float Num)
{
	local string temp;
	local array<string> Result;

	temp = string(Num);
	Split(temp,".",Result);
	return int(Result[1]) > 0;
}

function addItemSlot (ItemWindowHandle ItemWnd, ItemInfo pIteminfo)
{
	ItemWnd.Clear();
	ItemWnd.AddItem(pIteminfo);
}

function ItemInfo getItemInfoBySkillInfo (SkillInfo rSkilInfo)
{
	local ItemInfo infItem;

	infItem.Id.ClassID = rSkilInfo.SkillID;
	infItem.Level = 1;
	infItem.SubLevel = 0;
	infItem.Name = rSkilInfo.SkillName;
	infItem.IconName = rSkilInfo.TexName;
	infItem.IconPanel = rSkilInfo.IconPanel;
	infItem.Description = rSkilInfo.SkillDesc;
	infItem.ShortcutType = 2;
	infItem.ItemType = 1;
	return infItem;
}

function PledgeBonusListHandler (string param)
{
	local int accessReward;
	local int huntReward;
	local SkillInfo mSkillInfo;
	local SkillInfo tempSkillInfo;
	local ItemInfo mItemInfo;
	local ItemInfo tempItemInfo;
	local int i;
	local int accessType;
	local int huntType;

	ParseInt(param,"AccessType",accessType);
	ParseInt(param,"HuntType",huntType);
	hasPledgeBonusList = True;
	
	for ( i = 1;i < 5;i++ )
	{
		ParseInt(param,"AccessReward" $ string(i),accessReward);
		ParseInt(param,"HuntReward" $ string(i),huntReward);
		GetItemWindowHandle(JoinWndPath $ ".BonusItem" $ string(i) $ "_ItemWin").Clear();
		GetItemWindowHandle(JoinWndPath $ ".BonusItem" $ string(i) $ "_ItemWin").ClearTooltip();
		GetItemWindowHandle(JoinWndPath $ ".BonusItem" $ string(i) $ "_ItemWin").SetTooltipType("");
		GetItemWindowHandle(HuntWndPath $ ".BonusItem" $ string(i) $ "_ItemWin").Clear();
		GetItemWindowHandle(HuntWndPath $ ".BonusItem" $ string(i) $ "_ItemWin").ClearTooltip();
		GetItemWindowHandle(HuntWndPath $ ".BonusItem" $ string(i) $ "_ItemWin").SetTooltipType("");
		if ( accessType == 1 )
		{
			if ( accessReward > 0 )
			{
				mItemInfo = tempItemInfo;
				Class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(accessReward),mItemInfo);
				addItemSlot(GetItemWindowHandle(JoinWndPath $ ".BonusItem" $ string(i) $ "_ItemWin"),mItemInfo);
				GetItemWindowHandle(JoinWndPath $ ".BonusItem" $ string(i) $ "_ItemWin").SetTooltipType("Inventory");
			}
		}
		else if ( accessReward > 0 )
		{
			mSkillInfo = tempSkillInfo;
			GetSkillInfo(accessReward,1,0,mSkillInfo);
			addItemSlot(GetItemWindowHandle(JoinWndPath $ ".BonusItem" $ string(i) $ "_ItemWin"),getItemInfoBySkillInfo(mSkillInfo));
			GetItemWindowHandle(JoinWndPath $ ".BonusItem" $ string(i) $ "_ItemWin").SetTooltipType("Skill");
		}
		if ( huntType == 1 )
		{
			if ( huntReward > 0 )
			{
				mItemInfo = tempItemInfo;
				Class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(huntReward),mItemInfo);
				addItemSlot(GetItemWindowHandle(HuntWndPath $ ".BonusItem" $ string(i) $ "_ItemWin"),mItemInfo);
				GetItemWindowHandle(HuntWndPath $ ".BonusItem" $ string(i) $ "_ItemWin").SetTooltipType("Inventory");
			}
		}
		else if ( huntReward > 0 )
		{
			mSkillInfo = tempSkillInfo;
			GetSkillInfo(huntReward,1,0,mSkillInfo);
			addItemSlot(GetItemWindowHandle(HuntWndPath $ ".BonusItem" $ string(i) $ "_ItemWin"),getItemInfoBySkillInfo(mSkillInfo));
			GetItemWindowHandle(HuntWndPath $ ".BonusItem" $ string(i) $ "_ItemWin").SetTooltipType("Skill");
		}
	}
}

function setEnablePledgeBonus (int bonusType, int Index, bool bEnable)
{
	local ItemInfo Info;
	local string wndPath;

	if ( bonusType == 0 )
	{
		wndPath = JoinWndPath;
	} else {
		wndPath = HuntWndPath;
	}
	if ( GetItemWindowHandle(wndPath $ ".BonusItem" $ string(Index) $ "_ItemWin").GetItemNum() > 0 )
	{
		GetItemWindowHandle(wndPath $ ".BonusItem" $ string(Index) $ "_ItemWin").GetItem(0,Info);
		GetItemWindowHandle(wndPath $ ".BonusItem" $ string(Index) $ "_ItemWin").Clear();
		if ( bEnable )
		{
			Info.ForeTexture = "";
		} else {
			Info.ForeTexture = "L2UI_CT1.WindowDisable_BG";
		}
		GetItemWindowHandle(wndPath $ ".BonusItem" $ string(Index) $ "_ItemWin").AddItem(Info);
	}
}

function OnClickButton (string Name)
{
	switch (Name)
	{
		case "FrameCloseButton":
			OnFrameCloseButtonClick();
			break;
		case "FrameResetButton":
			OnFrameResetButtonClick();
			break;
		case "CloseBtn":
		case "ClanRaid_CloseBtn":
			OnCloseBtnClick();
			break;
		case "Clan1_ManageBtn":
			OnClan1_ManageBtnClick();
			break;
		case "Clan2_ManageBtn":
			OnClan2_ManageBtnClick();
			break;
		case "HelpButton":
			OnHelpBtnClick();
			break;
		case "Ok_btn_Result":
			HandleOnClickOk();
			// End:0xDF
			break;
	}
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	// End:0x26
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		return;
	}
	switch(a_ButtonHandle.GetWindowName())
	{
		// End:0x5E
		case "ok_btn_buy":
			HandleClickBuy(a_ButtonHandle.GetParentWindowName());
			// End:0x61
			break;
	}
}

function OnHelpBtnClick()
{
	local string strParam;

	ParamAdd(strParam,"FilePath", GetLocalizedL2TextPathNameUC() $ "Pledge_help001.htm");
	ExecuteEvent(EV_ShowHelp, strParam);
}

function OnFrameCloseButtonClick()
{
	Me.HideWindow();
}

function OnFrameResetButtonClick ()
{
	PledgeBonusOpen();
}

function OnCloseBtnClick ()
{
	Me.HideWindow();
}

function OnClan1_ManageBtnClick ()
{
	PlaySound("ItemSound3.sys_bonus_login");
	PledgeBonusReward(0);
}

function OnClan2_ManageBtnClick ()
{
	PlaySound("ItemSound3.sys_bonus_hunt");
	PledgeBonusReward(1);
}

function bool API_GetPledgeDonationData(PledgeDonationType _donationType, out PledgeDonationData Data)
{
	return GetPledgeDonationData(_donationType, Data);
}

function API_C_EX_PLEDGE_DONATION_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_DONATION_INFO packet;

	// End:0x0B
	if(IsPlayerOnWorldRaidServer())
	{
		return;
	}
	// End:0x2B
	if(! class'UIPacket'.static.Encode_C_EX_PLEDGE_DONATION_INFO(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PLEDGE_DONATION_INFO, stream);
}

function API_C_EX_PLEDGE_DONATION_REQUEST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_DONATION_REQUEST packet;

	packet.cDonationType = DonationType;
	if(! class'UIPacket'.static.Encode_C_EX_PLEDGE_DONATION_REQUEST(stream, packet))
	{
		return;
	}
	class 'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PLEDGE_DONATION_REQUEST, stream);
}

function Handle_S_EX_PLEDGE_DONATION_INFO()
{
	local UIPacket._S_EX_PLEDGE_DONATION_INFO packet;

	if(! class'UIPacket'.static.Decode_S_EX_PLEDGE_DONATION_INFO(packet))
	{
		return;
	}
	SetRemainCount(packet.nRemainCount);
	ShowDonaDisableWnd(packet.bNewbie == 1 || clanWndClassicScr.m_clanID < 1);
}

function Handle_S_EX_PLEDGE_DONATION_REQUEST()
{
	local UIPacket._S_EX_PLEDGE_DONATION_REQUEST packet;
	local string EffectName, donaName, successMsg, donationString;
	local ItemInfo iInfo;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PLEDGE_DONATION_REQUEST(packet))
	{
		return;
	}
	// End:0x4A
	if(packet.nResultType == 1)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4559));
		return;
	}
	else if(packet.nResultType == 2)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4217));
		return;
	}
	donationString = GetDonaTypeString(PledgeDonationType(packet.cDonationType));
	// End:0x2A6
	if(packet.bCritical == 1)
	{
		switch(packet.cDonationType)
		{
			// End:0xC7
			case 0:
				donaName = GetSystemString(441);
				EffectName = "LineageEffect.br_e_u014_turkey_atk4b";
				// End:0x152
				break;
			// End:0x108
			case 1:
				donaName = GetSystemString(13279);
				EffectName = "LineageEffect2.ui_upgrade_succ";
				// End:0x152
				break;
			// End:0x14F
			case 2:
				donaName = GetSystemString(13699);
				EffectName = "LineageEffect_br.br_e_firebox_fire_b";
				// End:0x152
				break;
		}
		GetWindowHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".DisableWnd").ShowWindow();
		GetWindowHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".CriticalResultWnd").ShowWindow();
		GetWindowHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".CriticalResultWnd").SetFocus();
		GetTextBoxHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".CriticalResultWnd.Title_txt").SetText(MakeFullSystemMsg(GetSystemMessage(13386), donaName));
		GetEffectViewportWndHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".CriticalResultWnd.EffectViewport").SpawnEffect(EffectName);
		successMsg = GetSystemMessage(13385);		
	}
	else
	{
		successMsg = GetSystemMessage(13383);
	}
	getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(successMsg, donationString));
	// End:0x36B
	if(packet.rewardItem.nAmount > 0)
	{
		class'UIDATA_ITEM'.static.GetItemInfo(GetItemID(packet.rewardItem.nItemClassID), iInfo);
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13384), iInfo.Name, string(packet.rewardItem.nAmount)));
		MakeFullSystemMsg(GetSystemMessage(13386), donationString);
	}
	SetRemainCount(packet.nRemainCount);
}

function setRaidSkill (int Index, int SkillID, int SkillLevel, int lastRaidPhase)
{
	local string WindowName;
	local SkillInfo SkillInfo;
	local ItemInfo Info;
	local ItemID cID;
	local int levelGap;
	local int viewLevel;

	if ( !GetSkillInfo(SkillID,SkillLevel,0,SkillInfo) )
	{
		return;
	}
	WindowName = m_WindowName $ "." $ m_ClanPledgeRaidWindowName $ "." $ "Stage0" $ string(Index) $ "_Window";
	cID.ClassID = SkillID;
	Info.Id = cID;
	Info.Level = SkillLevel;
	Info.Name = Class'UIDATA_SKILL'.static.GetName(Info.Id,Info.Level,0);
	Info.IconName = Class'UIDATA_SKILL'.static.GetIconName(Info.Id,Info.Level,0);
	Info.Description = Class'UIDATA_SKILL'.static.GetDescription(Info.Id,Info.Level,0);
	Info.AdditionalName = Class'UIDATA_SKILL'.static.GetEnchantName(Info.Id,Info.Level,0);
	if ( lastRaidPhase >= 10 )
	{
		viewLevel = (Index + 2) * 5;
	} else {
		viewLevel = (Index + 1) * 5;
	}
	GetTextBoxHandle(WindowName $ ".StageLvNum_text").SetText(string(viewLevel));
	GetTextBoxHandle(WindowName $ ".Skill_Name_text").SetText(Info.Name);
	GetTextBoxHandle(WindowName $ ".Skill_LvNum_text").SetText(string(SkillLevel));
	GetWindowHandle(WindowName).SetTooltipType("text");
	levelGap = lastRaidPhase - viewLevel;
	if ( levelGap >= 5 )
	{
		GetTextureHandle(WindowName $ ".FlagComplete_Icon").SetTexture("L2UI_EPIC.ClanWnd.ClanWnd_LvFlagCompleteIcon");
		GetTextureHandle(WindowName $ ".StageComplete_Icon").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeStageComplete_Icon");
		GetTextureHandle(WindowName $ ".PledgeSelectPanel").SetTexture("L2UI_CT1.EmptyBtn");
		GetWindowHandle(WindowName).SetTooltipText("");
		Info.bDisabled = 0;
	} else {
		if ( levelGap >= 0 )
		{
			GetTextureHandle(WindowName $ ".FlagComplete_Icon").SetTexture("L2UI_EPIC.ClanWnd.ClanWnd_LvFlagProcessingIcon");
			GetTextureHandle(WindowName $ ".StageComplete_Icon").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeStageProcessing_Icon");
			GetTextureHandle(WindowName $ ".PledgeSelectPanel").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeSelectPanel");
			GetWindowHandle(WindowName).SetTooltipText(GetSystemString(3351));
			Info.bDisabled = 0;
		} else {
			GetTextureHandle(WindowName $ ".FlagComplete_Icon").SetTexture("L2UI_EPIC.ClanWnd.ClanWnd_LvFlagLockIcon");
			GetTextureHandle(WindowName $ ".StageComplete_Icon").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeStageLock_Icon");
			GetTextureHandle(WindowName $ ".PledgeSelectPanel").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeCover");
			GetWindowHandle(WindowName).SetTooltipText(GetSystemString(2496));
		}
	}
	Class'UIAPI_ITEMWINDOW'.static.Clear(WindowName $ ".StageSkill_ItemWnd");
	Class'UIAPI_ITEMWINDOW'.static.AddItem(WindowName $ ".StageSkill_ItemWnd",Info);
}

function handleSetRaidSkillInfos (string param)
{
	local int i;
	local int skillCount;
	local int SkillID;
	local int skillLv;
	local int lastRaidPhase;
	local int addStep;

	ParseInt(param,"SkillCount",skillCount);
	ParseInt(param,"LastRaidPhase",lastRaidPhase);
	if ( lastRaidPhase >= 10 )
	{
		addStep = 1;
	} else {
		addStep = 0;
	}
	
	for ( i = 0;i < 4;i++ )
	{
		ParseInt(param,"SkillID_" $ string(i + addStep),SkillID);
		ParseInt(param,"SkillLV_" $ string(i + addStep),skillLv);
		setRaidSkill(i,SkillID,skillLv,lastRaidPhase);
	}
	if ( lastRaidPhase == 0 )
	{
		GetTextBoxHandle(m_WindowName $ "." $ m_ClanPledgeRaidWindowName $ "." $ "ClanRaidMyStage_Text").SetText(GetSystemString(27));
	} else {
		GetTextBoxHandle(m_WindowName $ "." $ m_ClanPledgeRaidWindowName $ "." $ "ClanRaidMyStage_Text").SetText(GetSystemString(88) @ string(lastRaidPhase));
	}
}

function SetRemainCount(int _donaRemainCount)
{
	donaRemainCount = _donaRemainCount;
	GetTextBoxHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".CriticalResultWnd.Help_txt").SetText((GetSystemString(13572) @ ":") @ string(donaRemainCount));
	HandleOnUpdateItemNormal();
	HandleOnUpdateItemFine();
	HandleOnUpdateItemPremium();
}

function InitDonationWnd()
{
	needItemListNormalScr = new class'UIControlNeedItemList';
	needItemListNormalScr.DelegateOnUpdateItem = HandleOnUpdateItemNormal;
	needItemListFineScr = new class'UIControlNeedItemList';
	needItemListFineScr.DelegateOnUpdateItem = HandleOnUpdateItemFine;
	needItemListPremiumlScr = new class'UIControlNeedItemList';
	needItemListPremiumlScr.DelegateOnUpdateItem = HandleOnUpdateItemPremium;
	SetDonationData(PDT_NORMAL, needItemListNormalScr);
	SetDonationData(PDT_GREAT, needItemListFineScr);
	SetDonationData(PDT_EXCELLENT, needItemListPremiumlScr);
	ShowDonaDisableWnd(true);
}

function SetDonationData(PledgeDonationType donaType, out UIControlNeedItemList itemNumListScr)
{
	local string donaWndNamePath;
	local RichListCtrlHandle RichListCtrl;
	local UIControlNeedItemList needItemList;
	local PledgeDonationData donaData;
	local int i;

	// End:0x17
	if(! API_GetPledgeDonationData(donaType, donaData))
	{
		return;
	}
	donaWndNamePath = GetDonationPath(donaType);
	RichListCtrl = GetRichListCtrlHandle(donaWndNamePath $ ".PrivateReward_List");
	needItemList = new class'UIControlNeedItemList';
	needItemList.SetRichListControler(RichListCtrl);
	needItemList.StartNeedItemList(3);
	needItemList.SetHideMyNum(true);

	// End:0xF5 [Loop If]
	for(i = 0; i < donaData.PersonalRewards.Length; i++)
	{
		needItemList.AddNeedItemClassID(donaData.PersonalRewards[i].ItemClassID, int64(donaData.PersonalRewards[i].ItemCount));
	}

	// End:0x156 [Loop If]
	for(i = 0; i < donaData.PledgeRewards.Length; i++)
	{
		needItemList.AddNeedItemClassID(donaData.PledgeRewards[i].ItemClassID, int64(donaData.PledgeRewards[i].ItemCount));
	}
	needItemList.SetBuyNum(1);
	RichListCtrl = GetRichListCtrlHandle(donaWndNamePath $ ".Cost_List");
	itemNumListScr.SetRichListControler(RichListCtrl);
	itemNumListScr.SetFormType(itemNumListScr.FORM_TYPE.nameSide);
	itemNumListScr.StartNeedItemList(1);
	itemNumListScr.AddNeedItemClassID(donaData.DonationItem, donaData.DonationItemAmount);
	itemNumListScr.SetBuyNum(1);
}

function HandleOnUpdateItemNormal()
{
	// End:0x49
	if(needItemListNormalScr.GetCanBuy() && donaRemainCount > 0)
	{
		GetButtonHandle(GetDonationPath(PDT_NORMAL) $ ".ok_btn_buy").EnableWindow();
	}
	// End:0x70
	else
	{
		GetButtonHandle(GetDonationPath(PDT_NORMAL) $ ".ok_btn_buy").DisableWindow();
	}
}

function HandleOnUpdateItemFine()
{
	// End:0x49
	if(needItemListFineScr.GetCanBuy() && donaRemainCount > 0)
	{
		GetButtonHandle(GetDonationPath(PDT_GREAT) $ ".ok_btn_buy").EnableWindow();
	}
	// End:0x70
	else
	{
		GetButtonHandle(GetDonationPath(PDT_GREAT) $ ".ok_btn_buy").DisableWindow();
	}
}

function HandleOnUpdateItemPremium()
{
	// End:0x49
	if(needItemListPremiumlScr.GetCanBuy() && donaRemainCount > 0)
	{
		GetButtonHandle(GetDonationPath(PDT_EXCELLENT) $ ".ok_btn_buy").EnableWindow();
	}
	// End:0x70
	else
	{
		GetButtonHandle(GetDonationPath(PDT_EXCELLENT) $ ".ok_btn_buy").DisableWindow();
	}
}

function HandleOnClickOk()
{
	GetWindowHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".CriticalResultWnd").HideWindow();
	GetWindowHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".DisableWnd").HideWindow();
}

function ShowDonaDisableWnd(bool Show)
{
	if(Show)
	{
		GetWindowHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".DisableWnd").ShowWindow();
		GetWindowHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".DisableWnd").SetFocus();
		GetTextBoxHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".DisableWnd.Desc_txt").ShowWindow();
	}
	else
	{
		GetWindowHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".DisableWnd").HideWindow();
		GetTextBoxHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".DisableWnd.Desc_txt").HideWindow();
	}
}

function OnClickPopupCancel()
{
	clanWndClassicScr.GetPopupScript().Hide();
}

function OnClickPopupBuy()
{
	clanWndClassicScr.GetPopupScript().Hide();
	API_C_EX_PLEDGE_DONATION_REQUEST();
}

function HandleClickBuy(string ParentName)
{
	local UIControlDialogAssets uicontrolDialogAssetScr;
	local PledgeDonationData donaData;

	uicontrolDialogAssetScr = clanWndClassicScr.GetPopupScript();
	uicontrolDialogAssetScr.SetDisableWindow(GetWindowHandle(m_WindowName $ "." $ m_ClanPledgeDonationWnd $ ".DisableWnd"));
	uicontrolDialogAssetScr.DelegateOnCancel = OnClickPopupCancel;
	uicontrolDialogAssetScr.DelegateOnClickBuy = OnClickPopupBuy;
	uicontrolDialogAssetScr.SetUseBuyItem(false);
	uicontrolDialogAssetScr.SetUseNeedItem(true);
	uicontrolDialogAssetScr.SetUseNumberInput(false);
	uicontrolDialogAssetScr.StartNeedItemList(1);
	switch(ParentName)
	{
		// End:0xDB
		case "PremiumDonationWnd":
			DonationType = PDT_EXCELLENT;
			// End:0x11E
			break;
		// End:0xFA
		case "FineDonationWnd":
			DonationType = PDT_GREAT;
			// End:0x11E
			break;
		// End:0x11B
		case "NormalDonationWnd":
			DonationType = PDT_NORMAL;
			// End:0x11E
			break;
	}
	uicontrolDialogAssetScr.SetDialogDesc(MakeFullSystemMsg(GetSystemMessage(13382), GetDonaTypeString(DonationType), string(donaRemainCount)));
	API_GetPledgeDonationData(DonationType, donaData);
	uicontrolDialogAssetScr.AddNeedItemClassID(donaData.DonationItem, donaData.DonationItemAmount);
	uicontrolDialogAssetScr.SetItemNum(1);
	uicontrolDialogAssetScr.Show();
}

function string GetDonationPath(PledgeDonationType donaType)
{
	switch(donaType)
	{
		case PDT_NORMAL:
			return (m_WindowName $ "." $ m_ClanPledgeDonationWnd) $ ".NormalDonationWnd";
		case PDT_GREAT:
			return (m_WindowName $ "." $ m_ClanPledgeDonationWnd) $ ".FineDonationWnd";
		case PDT_EXCELLENT:
			return (m_WindowName $ "." $ m_ClanPledgeDonationWnd) $ ".PremiumDonationWnd";
	}
	return "";
}

function string GetDonaTypeString(PledgeDonationType donaType)
{
	switch(donaType)
	{
		case PDT_NORMAL:
			return GetSystemString(13566);
		case PDT_GREAT:
			return GetSystemString(13567);
		case PDT_EXCELLENT:
			return GetSystemString(13568);
	}
	return "";
}

function int GetTobIndex()
{
	return tab.GetTopIndex();
}

defaultproperties
{
}
