//================================================================================
// SiegeWnd.
//================================================================================

class SiegeWnd extends UICommonAPI;

const TAB_MAX = 2;
const TIMER_TAB_ENABLEREFRESH = 1000;
const TIMER_TAB_ENABLE = 2;
const TIMER_BTNRECURITREFRESH = 3000;
const TIMER_BTNRECURIT = 1;

enum SiegeType
{
	READY,
	Start,
	End
};

enum TYPE_TELEPORT
{
	Left,
	MIDDLE,
	Right
};

enum TYPE_CONFIRM
{
	RECRUIT,
	Teleport,
	OBSERVER
};

var string m_WindowName;
var WindowHandle Me;
var int typeConfirm;
var int typeTeleport;
var bool IsSiegeMember;
var bool IsOnTimer;
var bool IsOnTimerTabEnable;
var TextureHandle texturePledge;
var TextureHandle texturePledgeCrest;
var TextBoxHandle txtCastleName;
var TextBoxHandle txtSiegeState;
var TextBoxHandle txtPledgeName;
var TextBoxHandle txtPledgeMasterName;
var TextBoxHandle txtNumAttack;
var TextBoxHandle txtNumDefence;
var TextBoxHandle txtSiegeMercenaryConfirmDesc_Txt;
var WindowHandle SiegeMercenaryConfirmWnd;
var ButtonHandle btnRecruit;
var TextBoxHandle txtRecruit;
var int OwnerPledgeID;
var string OwnerPledgeName;
var string OwnerPledgeMasterName;
var int SiegeState;
var bool IsMercenaryRecruit;
var array<INT64> currentIncomes;
var TextBoxHandle txtRecruitOK;
var ButtonHandle per10Btn;
var ButtonHandle per20Btn;
var ButtonHandle per30Btn;
var ButtonHandle per40Btn;
var ButtonHandle per50Btn;
var ButtonHandle btnRecruitOK;
var ButtonHandle BtnRanking;
var WindowHandle SiegeMercenaryRecruitmentWnd;
var int selectedPer;
var RichListCtrlHandle SiegeMercenaryRecruitment_RichList;
var array<int> mySelectedCastleIDs;
var array<int> castleIDs;
var int SelectedIndex;

function Initialize()
{
	Me = GetWindowHandle(m_WindowName);
	texturePledge = GetTextureHandle(m_WindowName $ ".WndCastleInfo.texturePledge");
	texturePledgeCrest = GetTextureHandle(m_WindowName $ ".WndCastleInfo.texturePledgeCrest");
	txtCastleName = GetTextBoxHandle(m_WindowName $ ".WndCastleInfo.txtCastleName");
	txtSiegeState = GetTextBoxHandle(m_WindowName $ ".WndCastleInfo.txtSiegeState");
	txtPledgeName = GetTextBoxHandle(m_WindowName $ ".WndCastleInfo.txtPledgeName");
	txtPledgeMasterName = GetTextBoxHandle(m_WindowName $ ".WndCastleInfo.txtPledgeMasterName");
	txtNumAttack = GetTextBoxHandle(m_WindowName $ ".WndCastleInfo.txtNumAttack");
	txtNumDefence = GetTextBoxHandle(m_WindowName $ ".WndCastleInfo.txtNumDefence");
	txtSiegeMercenaryConfirmDesc_Txt = GetTextBoxHandle(m_WindowName $ ".SiegeMercenaryConfirmWnd.SiegeMercenaryConfirmDesc_Txt");
	btnRecruit = GetButtonHandle(m_WindowName $ ".WndCastleInfo.btnRecruit");
	BtnRanking = GetButtonHandle(m_WindowName $ ".WndCastleInfo.btnRanking");
	SiegeMercenaryConfirmWnd = GetWindowHandle(m_WindowName $ ".SiegeMercenaryConfirmWnd");
	txtRecruit = GetTextBoxHandle(m_WindowName $ ".WndCastleInfo.txtRecruit");
	SiegeMercenaryRecruitmentWnd = GetWindowHandle(m_WindowName $ ".SiegeMercenaryRecruitmentWnd");
	per10Btn = GetButtonHandle(m_WindowName $ ".SiegeMercenaryRecruitmentWnd.per" $ string(1) $ "0Btn");
	per20Btn = GetButtonHandle(m_WindowName $ ".SiegeMercenaryRecruitmentWnd.per" $ string(2) $ "0Btn");
	per30Btn = GetButtonHandle(m_WindowName $ ".SiegeMercenaryRecruitmentWnd.per" $ string(3) $ "0Btn");
	per40Btn = GetButtonHandle(m_WindowName $ ".SiegeMercenaryRecruitmentWnd.per" $ string(4) $ "0Btn");
	per50Btn = GetButtonHandle(m_WindowName $ ".SiegeMercenaryRecruitmentWnd.per" $ string(5) $ "0Btn");
	per10Btn.SetNameText("10%");
	per20Btn.SetNameText("20%");
	per30Btn.SetNameText("30%");
	per40Btn.SetNameText("40%");
	per50Btn.SetNameText("50%");
	SiegeMercenaryRecruitment_RichList = GetRichListCtrlHandle(m_WindowName $ ".SiegeMercenaryRecruitmentWnd.SiegeMercenaryRecruitment_RichList");
	SiegeMercenaryRecruitment_RichList.SetSelectedSelTooltip(false);
	SiegeMercenaryRecruitment_RichList.SetAppearTooltipAtMouseX(true);
	SiegeMercenaryRecruitment_RichList.SetUseStripeBackTexture(false);
	txtRecruitOK = GetTextBoxHandle(m_WindowName $ ".SiegeMercenaryRecruitmentWnd.txtRecruitOK");
	btnRecruitOK = GetButtonHandle(m_WindowName $ ".SiegeMercenaryRecruitmentWnd.btnRecruitOK");
	HideAllTabs();
	// End:0x5B6
	if(! IsAdenServer())
	{
		BtnRanking.HideWindow();		
	}
	else
	{
		BtnRanking.ShowWindow();
	}
}

function OnRegisterEvent()
{
	RegisterEvent(EV_MCW_CastleSiegeInfo);
	RegisterEvent(EV_MCW_CastleSiegeHUDInfo);
	RegisterEvent(EV_MCW_CastleInfo);
	RegisterEvent(EV_ObserverWndShow);
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
}

function OnEvent(int Event_ID, string param)
{
	switch (Event_ID)
	{
		case EV_MCW_CastleSiegeInfo:
			HandleMCW_CastleSiegeInfo(param);
			break;
		case EV_MCW_CastleSiegeHUDInfo:
			HandleMCW_CastleSiegeHUDInfo(param);
			break;
		case EV_MCW_CastleInfo:
			HandleEVMCW_CastleInfo(param);
			break;
		case EV_ObserverWndShow:
			Me.HideWindow();
			break;
		default:
	}
}

function OnClickButton(string btnName)
{
	switch (btnName)
	{
		case "btnTeleportLeft":
			HandleBtnClickHelpTeleport(TYPE_TELEPORT.Left);
			break;
		case "btnTeleportCenter":
			HandleBtnClickHelpTeleport(TYPE_TELEPORT.MIDDLE);
			break;
		case "btnTeleportRight":
			HandleBtnClickHelpTeleport(TYPE_TELEPORT.Right);
			break;
		case "btnAttend":
			GetWindowHandle("SiegeInfoMCWWnd").ShowWindow();
			GetWindowHandle("SiegeInfoMCWWnd").BringToFront();
			break;
		case "btnRecruit":
			if (IsMercenaryRecruit)
			{
				HandleBtnClickRecruit();
			}
			else
			{
				HandleShowRecruitWnd();
			}
			break;
		case "btnVolunteer":
			if (Class 'UIAPI_WINDOW'.static.IsShowWindow("SiegeMercenaryWnd"))
			{
				Class 'UIAPI_WINDOW'.static.HideWindow("SiegeMercenaryWnd");
			}
			else
			{
				Class 'UIAPI_WINDOW'.static.ShowWindow("SiegeMercenaryWnd");
			}
			break;
		case "SiegeMercenaryConfirmOK_Btn":
			HandleOK();
		case "btnRecruitCancel":
			SiegeMercenaryRecruitmentWnd.HideWindow();
			GetWindowHandle(m_WindowName $ ".TextuerDescVolunteerwnd").HideWindow();
			TabOnOff(True);
		case "SiegeMercenaryConfirmCancle_Btn":
			SiegeMercenaryConfirmWnd.HideWindow();
			break;
		case "btnRecruitOK":
			HandleBtnClickRecruit();
			break;
		case "per10Btn":
		case "per20Btn":
		case "per30Btn":
		case "per40Btn":
		case "per50Btn":
			HandleClickPerBtn(btnName);
			break;
		case "WindowHelp_BTN":
			HandleBtnClickHelp();
			break;
		case "btnObserver":
			HandleBtnClickObserver();
			break;
		// End:0x33B
		case "btnRanking":
			// End:0x317
			if(GetWindowHandle("SiegeRankingWnd").IsShowWindow())
			{
				GetWindowHandle("SiegeRankingWnd").HideWindow();				
			}
			else
			{
				GetWindowHandle("SiegeRankingWnd").ShowWindow();
			}
			// End:0x33E
			break;
	}
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int tabindex;

	switch (a_ButtonHandle.GetWindowName())
	{
		case "btnTab":
			tabindex = int(Right(a_ButtonHandle.GetParentWindowName(), 1));
			if (tabindex != SelectedIndex)
			{
				TabSetSelectedIndex(tabindex);
			}
			break;
		default:
	}
}

function OnTimer(int TimerID)
{
	switch (TimerID)
	{
		case TIMER_BTNRECURIT:
			IsOnTimer = False;
			Me.KillTimer(TimerID);
			SetbtnRecruitEnable();
			break;
		case TIMER_TAB_ENABLE:
			IsOnTimerTabEnable = False;
			Me.KillTimer(TimerID);
			TabOnOff(True);
			break;
		default:
	}
}

function OnShow()
{
	local SiegeInfoMCWWnd SiegeInfoMCWWndScript;
	local int i;

	SetbtnRecruitDisable();
	txtRecruit.SetText(GetSystemString(13058));
	SiegeInfoMCWWndScript = SiegeInfoMCWWnd(GetScript("SiegeInfoMCWWnd"));
	mySelectedCastleIDs.Length = 0;

	for (i = 0; i < castleIDs.Length; i++)
	{
		TabSetEntryOnOffByCatleID(castleIDs[i], False);
		SiegeInfoMCWWndScript.API_RequestMCWCastleSiegeAttackerList(castleIDs[i]);
		SiegeInfoMCWWndScript.API_RequestMCWCastleSiegeDefenderList(castleIDs[i]);
	}
	SiegeMercenaryRecruitmentWnd.HideWindow();
	TabOnOff(True);
	SiegeMercenaryConfirmWnd.HideWindow();
	GetWindowHandle(m_WindowName $ ".TextuerDescVolunteerwnd").HideWindow();
	Me.SetFocus();
	Class 'UIAPI_WINDOW'.static.HideWindow("SiegeMercenaryWnd");
	Class 'UIAPI_WINDOW'.static.HideWindow("SiegeInfoMCWWnd");
	IsSiegeMember = False;
}

function OnHide()
{
	// End:0x45
	if(GetWindowHandle("SiegeRankingWnd").IsShowWindow())
	{
		GetWindowHandle("SiegeRankingWnd").HideWindow();
	}	
}

function HandleOK()
{
	switch (typeConfirm)
	{
		case TYPE_CONFIRM.RECRUIT:
			if (IsMercenaryRecruit)
			{
				API_RequestPledgeMercenaryRecruitInfoSet(0, 0, 0);
			}
			else
			{
				API_RequestPledgeMercenaryRecruitInfoSet(1, 1, selectedPer);
			}
			Me.SetTimer(TIMER_BTNRECURIT, TIMER_BTNRECURITREFRESH);
			IsOnTimer = True;
			SetbtnRecruitDisable();
			break;
		case TYPE_CONFIRM.Teleport:
			Class 'TeleportListAPI'.static.RequestTeleport(GetCurrentTeleportID());
			break;
		case TYPE_CONFIRM.OBSERVER:
			API_C_EX_CASTLEWAR_OBSERVER_START();
			break;
		default:
	}
}

function int GetCurrentTeleportID()
{
	switch (typeTeleport)
	{
		case TYPE_TELEPORT.Left:
			return GetTeleportIDL();
			break;
		case TYPE_TELEPORT.MIDDLE:
			return GetTeleportIDMiddle();
			break;
		case TYPE_TELEPORT.Right:
			return GetTeleportIDR();
			break;
		default:
	}
	return -1;
}

function int GetTeleportIDL()
{
	switch (castleIDs[SelectedIndex])
	{
		case 3:
			return 421;
		case 7:
			return 427;
	}
}

function int GetTeleportIDMiddle()
{
	switch (castleIDs[SelectedIndex])
	{
		case 3:
			return 420;
		case 7:
			return 426;
	}
}

function int GetTeleportIDR()
{
	switch (castleIDs[SelectedIndex])
	{
		case 3:
			return 419;
		case 7:
			return 425;
	}
}

function HandleBtnClickHelp()
{
	local string strParam;

	if (getInstanceUIData().getIsClassicServer())
	{
		ParamAdd(strParam, "FilePath", GetLocalizedL2TextPathNameUC() $ "siege_help_aden001.htm");
		ExecuteEvent(EV_ShowHelp, strParam);
	}
	else
	{
		ExecuteEvent(EV_ShowHelp, "155");
	}
}

function HandleBtnClickRecruit()
{
	typeConfirm = TYPE_CONFIRM.RECRUIT;
	SetConfirm();
}

function HandleBtnClickHelpTeleport(int Type)
{
	typeConfirm = TYPE_CONFIRM.Teleport;
	typeTeleport = Type;
	SetConfirm();
}

function HandleBtnClickObserver()
{
	typeConfirm = TYPE_CONFIRM.OBSERVER;
	SetConfirm();
}

function SetbtnRecruitEnable()
{
	local UserInfo uInfo;

	if (IsOnTimer)
	{
		return;
	}
	if (!IsSiegeMember)
	{
		return;
	}
	if(ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_bClanMaster == 0)
	{
		return;
	}
	GetPlayerInfo(uInfo);
	if(ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_clanID != uInfo.nClanID)
	{
		return;
	}
	txtRecruit.SetTextColor(GetColor(230, 217, 190, 255));
	btnRecruit.EnableWindow();
}

function SetbtnRecruitDisable()
{
	txtRecruit.SetTextColor(GetColor(120, 120, 120, 255));
	btnRecruit.DisableWindow();
}

function SetRecruit(int tmpCastleID, int MercenaryRecruit)
{
	IsMercenaryRecruit = MercenaryRecruit > 0;
	IsSiegeMember = True;
	mySelectedCastleIDs.Length = mySelectedCastleIDs.Length + 1;
	mySelectedCastleIDs[mySelectedCastleIDs.Length - 1] = tmpCastleID;
	TabSetEntryOnOffByCatleID(tmpCastleID, True);
	SetbtnRecruitEnable();
	if (IsMercenaryRecruit)
	{
		txtRecruit.SetText(GetSystemString(13059));
	}
	else
	{
		txtRecruit.SetText(GetSystemString(13058));
	}
}

function SetConfirm()
{
	switch (typeConfirm)
	{
		case TYPE_CONFIRM.RECRUIT:
			if (IsMercenaryRecruit)
			{
				txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemString(13065));
			}
			else
			{
				txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemString(13064));
			}
			break;
		case TYPE_CONFIRM.Teleport:
			SetTeleportInfo();
			break;
		case TYPE_CONFIRM.OBSERVER:
			txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemMessage(13091));
			break;
		default:
	}
	SiegeMercenaryConfirmWnd.ShowWindow();
	SiegeMercenaryConfirmWnd.SetFocus();
}

function string GetTeleportPositionName()
{
	switch (typeTeleport)
	{
		case TYPE_TELEPORT.Left:
			return GetSystemString(13051);
		case TYPE_TELEPORT.MIDDLE:
			return GetSystemString(13053);
		case TYPE_TELEPORT.Right:
			return GetSystemString(13052);
	}
}

function SetTeleportInfo()
{
	txtSiegeMercenaryConfirmDesc_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13166), MakeCostStringINT64(getInstanceUIData().GetTeleportPriceByID(GetCurrentTeleportID()))) $ "\n\n(" $ GetCastleName(castleIDs[SelectedIndex]) @GetTeleportPositionName() $ ")");
}

function string GetMainTextureByClastleID(int castleID)
{
	switch (castleID)
	{
		case 3:
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleImg_Giran";
			break;
		case 7:
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleImg_Godard";
			break;
		default:
	}
}

function HandleMCW_CastleSiegeInfo(string param)
{
	local int castleID;
	local string numOfAttackerPledge;
	local string numOfDefenderPledge;
	local Texture PledgeCrestTexture;
	local Texture PledgeAllianceCrestTexture;
	local bool bPledge;
	local bool bAlliance;

	ParseInt(param, "CastleID", castleID);
	txtCastleName.SetText(GetCastleName(castleID));
	ParseInt(param, "OwnerPledgeID", OwnerPledgeID);
	texturePledge.SetTexture("");
	texturePledgeCrest.SetTexture("");
	bPledge = Class 'UIDATA_CLAN'.static.GetCrestTexture(OwnerPledgeID, PledgeCrestTexture);
	bAlliance = Class 'UIDATA_CLAN'.static.GetAllianceCrestTexture(
		OwnerPledgeID, PledgeAllianceCrestTexture);
	if (bPledge)
	{
		texturePledge.SetTextureWithObject(PledgeCrestTexture);
	}
	if (bAlliance)
	{
		texturePledgeCrest.SetTextureWithObject(PledgeAllianceCrestTexture);
	}
	GetTextureHandle(m_WindowName $ ".WndCastleInfo.textureMainImg")
		.SetTexture(GetMainTextureByClastleID(castleID));
	ParseInt(param, "SiegeState", SiegeState);
	switch (SiegeState)
	{
		case SiegeType.READY:
			txtSiegeState.SetText(GetSystemString(13048));
			break;
		case SiegeType.Start:
			txtSiegeState.SetText(GetSystemString(13049));
			break;
		case SiegeType.End:
			txtSiegeState.SetText(GetSystemString(13050));
			Me.HideWindow();
			break;
		default:
	}
	ParseString(param, "OwnerPledgeName", OwnerPledgeName);
	txtPledgeName.SetText(OwnerPledgeName);
	ParseString(param, "OwnerPledgeMasterName", OwnerPledgeMasterName);
	txtPledgeMasterName.SetText(OwnerPledgeMasterName);
	Debug("HandleMCW_CastleSiegeInfo" @param);
	ParseString(param, "NumOfAttackerPledge", numOfAttackerPledge);
	txtNumAttack.SetText(numOfAttackerPledge @GetSystemString(314));
	ParseString(param, "NumOfDefenderPledge", numOfDefenderPledge);
	txtNumDefence.SetText(numOfDefenderPledge @GetSystemString(314));
	Me.ShowWindow();
}

function HandleMCW_CastleSiegeHUDInfo(string param)
{
	local int tmpSiegeState;
	local int tmpCastleID;

	if (!Me.IsShowWindow())
	{
		return;
	}
	ParseInt(param, "SiegeState", tmpSiegeState);
	ParseInt(param, "CastleID", tmpCastleID);
	if (castleIDs[tmpCastleID] != tmpCastleID)
	{
		return;
	}
	if (tmpSiegeState == SiegeState)
	{
		return;
	}
	if (tmpSiegeState == SiegeType.End)
	{
		Me.HideWindow();
		return;
	}
	API_RequestMCWCastleSiegeInfo(tmpCastleID);
}

function RichListCtrlRowData MakeRowData(int castleID, int Num)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = TAB_MAX;
	rowData.cellDataList[0].nReserved1 = 1;
	return rowData;
}

function RichListCtrlRowData MakeRowDataTitle(int castleID)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 1;
	rowData.cellDataList[0].nReserved1 = castleID;
	rowData.sOverlayTex = "L2UI_ct1.SiegeWnd.SiegeWnd_CastleHeaderBg";
	rowData.OverlayTexU = 411;
	rowData.OverlayTexV = 25;
	addRichListCtrlString(rowData.cellDataList[0].drawitems, GetCastleName(castleID),
		GetColor(255, 221, 102, 255), False, 10, 0);
	return rowData;
}

function RichListCtrlRowData MakeRowDataTex(int castleID)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = TAB_MAX;
	rowData.cellDataList[0].nReserved1 = castleID;
	addRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(13113),
		GetColor(153, 153, 153, 255), False, 10, 0);
	rowData = MakeRowDataCommon(rowData);
	addRichListCtrlString(rowData.cellDataList[1].drawitems,
		MakeCostStringINT64(currentIncomes[TabIndexByCastleID(castleID)]),
		GetColor(187, 170, 136, 255), False, -204);
	return rowData;
}

function RichListCtrlRowData MakeRowDataReward(int castleID)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = TAB_MAX;
	rowData.cellDataList[0].nReserved1 = castleID;
	addRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(13112),
		GetColor(153, 153, 153, 255), False, 10, 0);
	rowData = MakeRowDataCommon(rowData);
	addRichListCtrlString(rowData.cellDataList[1].drawitems,
		MakeCostStringINT64((currentIncomes[TabIndexByCastleID(castleID)] * selectedPer) / 100),
		GetColor(153, 153, 153, 255), False, -204);
	return rowData;
}

function RichListCtrlRowData MakeRowDataCommon(RichListCtrlRowData rowData)
{
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems,
		"L2UI_ct1.SiegeWnd.SiegeWnd_Richlist_AdenaTextBg", 207, 20, 15, 3);
	addRichListCtrlTexture(
		rowData.cellDataList[1].drawitems, "L2UI_ct1.Icon.Icon_DF_Common_Adena", 18, 14, 207, 4);
	return rowData;
}

function HandleEVMCW_CastleInfo(string param)
{
	local int tmpCastleID;
	local int tabNum;

	ParseInt(param, "CastleID", tmpCastleID);
	tabNum = TabIndexByCastleID(tmpCastleID);
	ParseINT64(param, "CurrentIncome", currentIncomes[tabNum]);
	HandleTexByTabNum(tabNum);
}

function HandleShowRecruitWnd()
{
	local int i;

	SetPerBtnSelect(-1);
	SetRecords();
	currentIncomes.Length = castleIDs.Length;

	for (i = 0; i < castleIDs.Length; i++)
	{
		Class 'SiegeAPI'.static.RequestMCWCastleInfo(castleIDs[i]);
	}
	txtRecruitOK.SetTextColor(GetColor(120, 120, 120, 255));
	btnRecruitOK.DisableWindow();
	SiegeMercenaryRecruitmentWnd.ShowWindow();
	TabOnOff(False);
	SiegeMercenaryConfirmWnd.HideWindow();
	GetWindowHandle(m_WindowName $ ".TextuerDescVolunteerwnd").ShowWindow();
}

function SetRecords()
{
	local int i;

	SiegeMercenaryRecruitment_RichList.DeleteAllItem();

	for (i = 0; i < castleIDs.Length; i++)
	{
		SiegeMercenaryRecruitment_RichList.InsertRecord(MakeRowDataTitle(castleIDs[i]));
		SiegeMercenaryRecruitment_RichList.InsertRecord(MakeRowDataTex(castleIDs[i]));
		SiegeMercenaryRecruitment_RichList.InsertRecord(MakeRowDataReward(castleIDs[i]));
	}
}

function HandleReward()
{
	local int i;

	for (i = 0; i < castleIDs.Length; i++)
	{
		HandleRewardByTabNum(i);
	}
}

function HandleTexByTabNum(int tabNum)
{
	SiegeMercenaryRecruitment_RichList.ModifyRecord(
		tabNum * 3 + 1, MakeRowDataTex(castleIDs[tabNum]));
}

function HandleRewardByTabNum(int tabNum)
{
	SiegeMercenaryRecruitment_RichList.ModifyRecord(tabNum * 3 + 2, MakeRowDataReward(castleIDs[tabNum]));
}

function HandleClickPerBtn(string btnName)
{
	Debug("HandleClickPerBtn" @string(int(Right(btnName, 5))));
	SetPerBtnSelect(int(Right(btnName, 5)));
	switch (Right(btnName, 5))
	{
		case "10Btn":
			SetPerBtnSelect(1);
			break;
		case "20Btn":
			SetPerBtnSelect(2);
			break;
		case "30Btn":
			SetPerBtnSelect(3);
			break;
		case "40Btn":
			SetPerBtnSelect(4);
			break;
		case "50Btn":
			SetPerBtnSelect(5);
			break;
		default:
	}
}

function SetPerBtnSelect(int Index)
{
	SetPerBtn(per10Btn, False);
	SetPerBtn(per20Btn, False);
	SetPerBtn(per30Btn, False);
	SetPerBtn(per40Btn, False);
	SetPerBtn(per50Btn, False);
	if (Index > 0)
	{
		SetPerBtn(GetButtonHandle(m_WindowName $ ".SiegeMercenaryRecruitmentWnd.per" $ string(Index) $ "0Btn"), True);
		txtRecruitOK.SetTextColor(GetColor(230, 217, 190, 255));
		btnRecruitOK.EnableWindow();
		selectedPer = Index * 10;
		HandleReward();
	}
	else
	{
		selectedPer = 0;
	}
}

function SetPerBtn(ButtonHandle perBtn, bool Selected)
{
	if (Selected)
	{
		perBtn.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down",
			"l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
	}
	else
	{
		perBtn.SetTexture("l2ui_ct1.RankingWnd_SubTabButton",
			"l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
	}
}

function HideAllTabs()
{
	local int i;

	for (i = 0; i < 2; i++)
	{
		GetWindowHandle(GetTabWindowName(i)).HideWindow();
	}
}

function TabSetSelectedIndex(int tabNum)
{
	local int i;

	SelectedIndex = tabNum;

	for (i = 0; i < castleIDs.Length; i++)
	{
		TabSetDeSelect(i);
	}
	API_RequestMCWCastleSiegeInfo(castleIDs[SelectedIndex]);
	GetButtonHandle(GetTabWindowName(tabNum) $ ".btnTab")
		.SetTexture("L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton_Down",
			"L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton_Down",
			"L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton_Down");
	Me.SetTimer(TIMER_TAB_ENABLE, TIMER_TAB_ENABLEREFRESH);
	TabOnOff(False);
	SiegeMercenaryConfirmWnd.HideWindow();
}

function TabSetDeSelect(int tabNum)
{
	GetButtonHandle(GetTabWindowName(tabNum) $ ".btnTab")
		.SetTexture("L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton",
			"L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton_Over",
			"L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton_Down");
}

function TabOnOff(bool On)
{
	local int i;
	local string TabWindowName;

	if (On)
	{
		if (IsOnTimerTabEnable)
		{
			return;
		}
		if (SiegeMercenaryRecruitmentWnd.IsShowWindow())
		{
			return;
		}

		for (i = 0; i < castleIDs.Length; i++)
		{
			TabWindowName = GetTabWindowName(i);
			GetButtonHandle(TabWindowName $ ".btnTab").EnableWindow();
			GetTextBoxHandle(TabWindowName $ ".txtTab")
				.SetTextColor(GetTabColorByEntry(GetEntryByTabNum(i)));
		}
	}
	else
	{

		for (i = 0; i < castleIDs.Length; i++)
		{
			TabWindowName = GetTabWindowName(i);
			GetButtonHandle(TabWindowName $ ".btnTab").DisableWindow();
			GetTextBoxHandle(TabWindowName $ ".txtTab").SetTextColor(GetColor(120, 120, 120, 255));
		}
	}
}

function bool GetEntryByTabNum(int tabNum)
{
	local int i;


	for (i = 0; i < mySelectedCastleIDs.Length; i++)
	{
		if (mySelectedCastleIDs[i] == castleIDs[tabNum])
		{
			return True;
		}
	}
	return False;
}

function int TabIndexByCastleID(int castleID)
{
	local int i;


	for (i = 0; i < castleIDs.Length; i++)
	{
		if (castleIDs[i] == castleID)
		{
			return i;
		}
	}
	return -1;
}

function TabSetEntryOnOffByCatleID(int castleID, bool bEntry)
{
	Debug("---   --- TabSetEntryOnOffByCatleID ---   ---" @string(castleID) @string(bEntry));
	TabSetEntryOnOff(TabIndexByCastleID(castleID), bEntry);
}

function TabSetEntryOnOff(int tabNum, bool bEntry)
{
	local string WindowName;

	Debug("TabSetEntryOnOff" @string(tabNum) @string(bEntry));
	WindowName = GetTabWindowName(tabNum);
	GetTextureHandle(WindowName $ ".TextuerIconTab")
		.SetTexture(getInstanceL2Util().GetClastleButtonIconName(castleIDs[tabNum], bEntry));
	GetTextBoxHandle(WindowName $ ".txtTab").SetTextColor(GetTabColorByEntry(bEntry));
}

function Color GetTabColorByEntry(bool bEntry)
{
	if (bEntry)
	{
		return GetColor(255, 255, 0, 255);
	}
	return GetColor(230, 215, 190, 255);
}

function TabAdd(int tabNum, int castleID)
{
	TabSet(tabNum, castleID);
	castleIDs.Length = castleIDs.Length + 1;
	castleIDs[tabNum] = castleID;
}

function TabSet(int tabNum, int castleID)
{
	local string WindowName;
	local TextBoxHandle txtTab;
	local TextureHandle TextuerIconTab;

	WindowName = GetTabWindowName(tabNum);
	GetWindowHandle(GetTabWindowName(tabNum)).ShowWindow();
	txtTab = GetTextBoxHandle(WindowName $ ".txtTab");
	TextuerIconTab = GetTextureHandle(WindowName $ ".TextuerIconTab");
	TextuerIconTab.SetTexture(getInstanceL2Util().GetClastleButtonIconName(castleID));
	txtTab.SetText(GetCastleName(castleID));
}

function TabDel(int tabNum)
{
	local int i;

	Me.HideWindow();
	castleIDs.Remove(tabNum, 1);
	GetWindowHandle(GetTabWindowName(castleIDs.Length)).HideWindow();

	for (i = 0; i < castleIDs.Length; i++)
	{
		TabSet(i, castleIDs[i]);
	}
}

function string GetTabWindowName(int tabNum)
{
	return m_WindowName $ ".TabWnd0" $ string(tabNum);
}

function API_RequestMCWCastleSiegeInfo(int tmpCastleID)
{
	Class 'SiegeAPI'.static.RequestMCWCastleSiegeInfo(tmpCastleID);
}

function API_RequestPledgeMercenaryRecruitInfoSet(int Type, int IsMercenaryRecruit, INT64 MercenaryReward)
{
	if (mySelectedCastleIDs.Length < 1)
	{
		return;
	}
	class'SiegeAPI'.static.RequestPledgeMercenaryRecruitInfoSet(mySelectedCastleIDs[0], Type, IsMercenaryRecruit, MercenaryReward);
}

function API_C_EX_CASTLEWAR_OBSERVER_START()
{
	local array<byte> stream;
	local UIPacket._C_EX_CASTLEWAR_OBSERVER_START packet;

	packet.nCastleID = castleIDs[SelectedIndex];
	if (!Class 'UIPacket'.static.Encode_C_EX_CASTLEWAR_OBSERVER_START(stream, packet))
	{
		return;
	}
	Class 'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_CASTLEWAR_OBSERVER_START, stream);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if (SiegeMercenaryConfirmWnd.IsShowWindow())
	{
		SiegeMercenaryConfirmWnd.HideWindow();
	}
	else
	{
		Me.HideWindow();
	}
}

defaultproperties
{
     m_WindowName="SiegeWnd"
}
