class ClanWndClassicNew extends UIData;

enum CONTEXT_MENU_INDEX {
	ClanPenaltyBtn,
	ClanAuthEditBtn,
	ClanTitleManageBtn
};

enum TAB_TYPE 
{
	SUBINFOCONTINER,
	PLEDGEBONUS,
	BENEFIT
};

const DIALOG_ASK_JOIN= 98899;
const MAX_CHAR_LENGTH= 3000;
const c_maxranklimit= 100;

var WindowHandle Me;
var int m_clanID;
var string m_clanName;
var int m_clanRank;
var int m_clanNameValue;
var int m_clanLevel;
var int m_bMoreInfo;
var int m_currentShowIndex;
var int G_IamNobless;
var bool G_IamHero;
var int G_ClanMember;
var string m_WindowName;
var string m_DrawerWindowName;
var string m_ClanPledgeBonusDrawerWndName;
var int m_myClanType;
var string m_myName;
var string m_myClanName;
var int m_indexNum;
var int m_bClanMaster;
var int m_bJoin;
var int m_bNickName;
var int m_bCrest;
var int m_bGrade;
var int m_bManageMaster;
var int m_bOustMember;
var TextBoxHandle TxtClanWar_Title;
var string m_CurrentclanMasterName;
var string m_CurrentclanMasterReal;
var int m_CurrentNHType;
var array<ClanInfo> m_memberList;
var int pledgeDelayTimerCount;
var PledgeLevelData pledgeLevelDataStru;
var int pledgeExp;
var WindowHandle ClanNoticeDialogBoxWnd;
var WindowHandle ClanNoiceDialogViewWnd;
var MultiEditBoxHandle dialogTextEditBox;
var CheckBoxHandle dialogTextCheck;
var ClanSubMenuManageContainer clanSubMenuManageContainerScr;
var ClanSubInfoContainer clanSubInfoContainerScr;
var ClanSubInfoContainerPledgeBonus clanSubInfoContainerPledgeBonusScr;
var ClanSubInfoContainerBenefit clanSubInfoContainerBenefitScr;

function InitHandleCOD()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	TxtClanWar_Title = GetTextBoxHandle(m_DrawerWindowName $ ".ClanWarManagementWnd.TxtClanWar_Title");
	ClanNoticeDialogBoxWnd = GetWindowHandle(m_WindowName $ ".ClanNoiceDialogBoxWnd");
	ClanNoiceDialogViewWnd = GetWindowHandle(m_WindowName $ ".ClanNoiceDialogViewWnd");
	dialogTextEditBox = GetMultiEditBoxHandle(m_WindowName $ ".ClanNoiceDialogBoxWnd.Dialogtext_EditBox");
	dialogTextCheck = GetCheckBoxHandle(m_WindowName $ ".ClanNoiceDialogBoxWnd.Dialogtext_Check100");
}

private function Load()
{
	pledgeDelayTimerCount = 0;
}

private function Clear()
{
	local int i;

	class'UIAPI_WINDOW'.static.HideWindow(m_DrawerWindowName);
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanNameText", "");
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanMasterNameText", "");
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", GetSystemString(27));
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".ClanLevelText", 0);
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanRankingInfo_Wnd.Clan3_ClanRanking", "");
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanRankingInfo_Wnd.Clan3_ClanNum", "0/0");
	GetHtmlHandle(m_WindowName $ ".ClanNoiceDialogViewWnd.ClanNotice_txt").Clear();
	GetHtmlHandle(m_WindowName $ ".ClanNotice_txt").Clear();
	m_clanID = 0;
	m_clanName = "";
	m_clanRank = 0;
	m_clanNameValue = 0;
	m_clanLevel = 0;
	m_bMoreInfo = 0;
	m_currentShowIndex = 0;
	m_bClanMaster = 0;
	m_bJoin = 0;
	m_bNickName = 0;
	m_bCrest = 0;
	m_bGrade = 0;
	m_bManageMaster = 0;
	m_bOustMember = 0;

	for(i = 0; i < CLAN_KNIGHTHOOD_COUNT; i++)
	{
		m_memberList[i].m_array.Remove(0, m_memberList[i].m_array.Length);
		m_memberList[i].m_sName = "";
		m_memberList[i].m_sMasterName = "";
	}
}

function SetmyClanInfo()
{
	local UserInfo UserInfo;

	if(GetPlayerInfo(UserInfo))
	{
		m_myName = UserInfo.Name;
		m_myClanType = findmyClanData(m_myName);
		G_IamNobless = UserInfo.nNobless;
		G_IamHero = UserInfo.bHero;
		G_ClanMember = UserInfo.nClanID;
	}
}

function OnRegisterEvent()
{
	RegisterEvent(EV_ClanInfo);
	RegisterEvent(EV_ClanInfoUpdate);
	RegisterEvent(EV_ClanDeleteAllMember);
	RegisterEvent(EV_ClanAddMember);
	RegisterEvent(EV_ClanMemberInfoUpdate);
	RegisterEvent(EV_ClanAddMemberMultiple);
	RegisterEvent(EV_ClanDeleteMember);
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_GamingStateExit);
	RegisterEvent(EV_ClanMyAuth);
	RegisterEvent(EV_ClanSubClanUpdated);
	RegisterEvent(EV_ResultJoinDominionWar);
	RegisterEvent(EV_SendIsActiveUnionInfoBtn);
	RegisterEvent(EV_PledgeBonusMarkReset);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_V3_INFO);
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_GameStart);
}

function OnLoad()
{
	SetClosingOnESC();
	InitHandleCOD();
	Load();
	m_memberList.Length = CLAN_KNIGHTHOOD_COUNT;
	m_currentShowIndex = 0;
	m_bMoreInfo = 0;
	Clear();
	GetStatusBarHandle(m_WindowName $ ".ClanLevel_StatusBar").SetDecimalPlace(4);
	InitUIControlDialogAsset();
}

event OnShow()
{
	GetWindowHandle(m_DrawerWindowName).SetFocus();
	SetmyClanInfo();
	resetBtnShowHide();
	ShowList(m_myClanType);
	clanSubInfoContainerScr.ClanMemberList_ListCtrl.SetSelectedIndex(m_indexNum, true);
	// End:0x7A
	if(m_myClanType == -1)
	{
		clanSubInfoContainerScr.ClanMemberList_ListCtrl.SetSelectedIndex(m_indexNum - 1, true);
	}
	clanSubInfoContainerScr.API_C_EX_PLEDGE_CONTRIBUTION_LIST();
	switch(GetTopIndex())
	{
		// End:0xAA
		case 0:
			clanSubInfoContainerScr.HandleOnShow();
			// End:0xC6
			break;
		// End:0xC3
		case 1:
			clanSubInfoContainerPledgeBonusScr.HandleOnShow();
			// End:0xC6
			break;
	}
	API_C_EX_PLEDGE_V3_INFO();
}

event OnHide()
{
	// End:0x22
	if(DialogIsMine())
	{
		class'DialogBox'.static.Inst().HideDialog();
	}
}

event OnEnterState(name a_CurrentStateName)
{
	// End:0x15
	if(getInstanceL2Util().isClanV2())
	{
		return;
	}
	SetmyClanInfo();
	ClearList();
	Clear();
	ClearCurrentNum();
	class'UIDATA_CLAN'.static.RequestClanInfo();
}

event OnClickButton(string strID)
{
	// End:0x3E
	if(strID == "ClanNotice_Button")
	{
		ClanNoticeDialogBoxWnd.ShowWindow();
		ClanNoticeDialogBoxWnd.SetFocus();
	}
	else if(strID == "ClanNotice_Read_Button")
	{
		ClanNoiceDialogViewWnd.ShowWindow();
		ClanNoiceDialogViewWnd.SetFocus();
	}
	else if(strID == "Dialogtext_Btn")
	{
		API_C_EX_PLEDGE_V3_SET_ANNOUNCE();
		ClanNoticeDialogBoxWnd.HideWindow();
	}
	else if(strID == "Dialogtext_CancelBtn")
	{
		ClanNoticeDialogBoxWnd.HideWindow();
	}
	else if(strID == "DialogtextView_Btn")
	{
		ClanNoiceDialogViewWnd.HideWindow();
	}
	else if(strID == "ClanAskJoinBtn")
	{
		askJoin();
	}
	else if(strID == "PledgeBonusWnd_Btn")
	{
		// End:0x17C
		if(IsShowWindow(m_ClanPledgeBonusDrawerWndName))
		{
			GetWindowHandle(m_ClanPledgeBonusDrawerWndName).HideWindow();									
		}
		else
		{
			PledgeBonusOpen();
		}
	}
	else if(strID == "ClanBoardBtn")
	{
		ShowBBS();
	}
	else if(strID == "ClanUnionBtn")
	{
		// End:0x1FA
		if(class'UIAPI_WINDOW'.static.IsShowWindow("ClanSearch"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("ClanSearch");											
		}
		else
		{
			class'UIAPI_WINDOW'.static.ShowWindow("ClanSearch");
		}
	}
	else if(strID == "ClanMissionBtn")
	{
		ToDoListWnd(GetScript("ToDoListWnd")).ToggleByClanMission();
	}
	else if(strID == "WindowHelp_BTN")
	{
		//class'HelpWnd'.static.ShowHelp(147);
	}
	else if(strID == "ClanShopBtn")
	{
		HandleShowHideClanShopWnd();
	}
	else
	{
		HandleBtnClick(strID);
	}
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	// End:0x3B
	if(a_WindowHandle == GetWindowHandle(m_WindowName $ ".ClanManagementBtn"))
	{
		ShowContextMenu(X, Y);
	}
}

function OnEvent(int a_EventID, string a_Param)
{
	// End:0x15
	if(getInstanceL2Util().isClanV2())
	{
		return;
	}
	switch(a_EventID)
	{
		// End:0x2A
		case EV_Restart:
			ClearAll();
			// End:0x201
			break;
		// End:0x38
		case EV_GamingStateExit:
			ClearList();
			Clear();
			ClearCurrentNum();
			// End:0x201
			break;
		// End:0x4E
		case EV_ClanInfo:
			HandleClanInfo(a_Param);
			// End:0x201
			break;
		// End:0x64
		case EV_ClanInfoUpdate:
			HandleClanInfoUpdate(a_Param);
			// End:0x201
			break;
		// End:0xAE
		case EV_ClanSubClanUpdated:
			HandleSubClanUpdated(a_Param);
			// End:0x201
			break;
		// End:0xBF
		case EV_ClanDeleteAllMember:
			ClearList();
			Clear();
			ClearCurrentNum();
			// End:0x18E
			break;
		// End:0xD5
		case EV_ClanAddMemberMultiple:
			HandleAddClanMemberMultiple(a_Param);
			// End:0x201
			break;
		// End:0xEB
		case EV_ClanMemberInfoUpdate:
			HandleMemberInfoUpdate(a_Param);
			// End:0x201
			break;
		// End:0x101
		case EV_ClanAddMember:
			HandleAddClanMember(a_Param);
			// End:0x201
			break;
		// End:0x117
		case EV_ClanDeleteMember:
			HandleDeleteMember(a_Param);
			// End:0x201
			break;
		// End:0x12D
		case EV_ClanMyAuth:
			HandleClanMyAuth(a_Param);
			// End:0x201
			break;
		// End:0x14E
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_V3_INFO:
			Handle_S_EX_PLEDGE_V3_INFO();
			// End:0x201
			break;
		// End:0x178
		case EV_PledgeBonusMarkReset:
			// End:0x175
			if(getInstanceUIData().getIsClassicServer())
			{
				ClearList();
				deleteAllBActive();
			}
			// End:0x201
			break;
		// End:0x189
		case EV_DialogOK:
			HandleDialogOK();
			// End:0x201
			break;
		// End:0x1FB
		case EV_GameStart:
			clanSubInfoContainerPledgeBonusScr.ShowDonaDisableWnd(true);
			clanSubInfoContainerBenefitScr.SetRecords();
			// End:0x201
			break;
		// End:0xFFFF
		default:
			break;
	}
}

function bool API_GetPledgeLevelData(int PledgeLevel, out PledgeLevelData Data)
{
	return GetPledgeLevelData(PledgeLevel, Data);
}

function API_C_EX_PLEDGE_V3_SET_ANNOUNCE()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_V3_SET_ANNOUNCE packet;
	local string noticeStrings;

	noticeStrings = dialogTextEditBox.GetString();
	packet.sAnnounceContent = noticeStrings;
	if(dialogTextCheck.IsChecked())
	{
		packet.bShowAnnounce = 1;
	}
	else
	{
		packet.bShowAnnounce = 0;
	}
	if(! Class'UIPacket'.static.Encode_C_EX_PLEDGE_V3_SET_ANNOUNCE(stream, packet))
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PLEDGE_V3_SET_ANNOUNCE, stream);
}

function API_C_EX_PLEDGE_V3_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_V3_INFO packet;

	if(!Class'UIPacket'.static.Encode_C_EX_PLEDGE_V3_INFO(stream, packet))
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PLEDGE_V3_INFO, stream);
}

function Handle_S_EX_PLEDGE_V3_INFO()
{
	local UIPacket._S_EX_PLEDGE_V3_INFO packet;
	local string announceContent;

	if(!Class'UIPacket'.static.Decode_S_EX_PLEDGE_V3_INFO(packet))
	{
		return;
	}
	m_clanRank = packet.nPledgeRank;
	pledgeExp = packet.nPledgeExp;
	SetPledgeLevelExp();
	SetClanRankStr();
	dialogTextEditBox.SetString(packet.sAnnounceContent);
	announceContent = packet.sAnnounceContent;
	announceContent = Substitute(announceContent, Chr(13) $ Chr(10) $ Chr(13) $ Chr(10), "<Br1><Br>", false);
	announceContent = Substitute(announceContent, Chr(13) $ Chr(10), "<Br1>", false);
	announceContent = htmlSetHtmlStart(announceContent);
	GetHtmlHandle(m_WindowName $ ".ClanNoiceDialogViewWnd.ClanNotice_txt").LoadHtmlFromString(announceContent);
	GetHtmlHandle(m_WindowName $ ".ClanNotice_txt").LoadHtmlFromString(announceContent);
	clanSubMenuManageContainerScr.m_hOwnerWnd.SetFocus();
	dialogTextCheck.SetCheck(bool(packet.bShowAnnounce));
}

function GetHtmlString(string sAnnounceContent)
{
	local HtmlHandle resultText;
	local string resultString, htmlAdd;
	local Rect rectWnd;

	resultText = GetHtmlHandle(m_WindowName $ ".resultTxt_textbox");
	resultString = GetSystemString(846);
	resultString = htmlAddText(resultString, "hs16", "DCDCDC");
	rectWnd = resultText.GetRect();
	htmlAdd = htmlAddTableTD(resultString, "center", "center", rectWnd.nWidth, 0, "", true);
	htmlSetTableTR(htmlAdd);
	htmlAdd = "<table width=" $ string(rectWnd.nWidth) $ " height=" $ string(rectWnd.nHeight) $ ">" $ htmlAdd $ "</table>";
	resultText.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
}

function deleteAllBActive()
{
	local int N;
	local int i;

	for(i = 0; i < m_memberList.Length; i++)
	{
		for(N = 0; N < m_memberList[i].m_array.Length; N++)
		{
			m_memberList[i].m_array[N].bActive = 0;
		}
	}
}

function resetBtnShowHide()
{
	IsNoblessToChangeMemberNameBtnEnabled();
	Class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanUnionBtn");
	if(m_clanID == 0)
	{
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanMemAuthBtn");
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanBoardBtn");
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAskJoinBtn");
		Class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn");
	}
	else
	{
		switch(m_clanLevel)
		{
			case 0:
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
				class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanBoardBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn");
				class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
				class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
				break;
			case 1:
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
				class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanBoardBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn");
				class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
				break;
			case 2:
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn");
				class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
				break;
			case 3:
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
				class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
				break;
			case 4:
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
				class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
				break;
			case 5:
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn");
				class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
				class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
				break;
			default:
				if(m_clanLevel > 5)
				{
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn");
					class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
					class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
				}
				break;
		}
		NoticeAuthByClanMaster(m_bClanMaster > 0);
		if(m_bClanMaster > 0)
		{
			class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn");
		}
		else
		{
			class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
			class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
			if(m_bJoin == 0)
			{
				class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAskJoinBtn");
			}
		}
		clanSubMenuManageContainerScr.CheckandCompareMyNameandDisableThings();
	}
	IsWorldRaidServer();
}

function NoticeAuthByClanMaster(bool isClanMaster)
{
	if(m_clanID <= 0)
	{
		GetButtonHandle(m_WindowName $ ".ClanNotice_Button").HideWindow();
		GetButtonHandle(m_WindowName $ ".ClanNotice_Read_Button").HideWindow();
	}
	else if(isClanMaster)
	{
		GetButtonHandle(m_WindowName $ ".ClanNotice_Button").ShowWindow();
		GetButtonHandle(m_WindowName $ ".ClanNotice_Read_Button").HideWindow();
	}
	else
	{
		GetButtonHandle(m_WindowName $ ".ClanNotice_Button").HideWindow();
		GetButtonHandle(m_WindowName $ ".ClanNotice_Read_Button").ShowWindow();
	}
}

function IsNoblessToChangeMemberNameBtnEnabled()
{
	if((G_IamHero == true)||(G_IamNobless > 0))
	{
		class'UIAPI_WINDOW'.static.EnableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
	}
	else
	{
		class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
	}
}

function HandleAddClanMemberMultiple(string a_Param)
{
	local ClanMemberInfo Info;
	local int Count;
	local int Index;

	ParseInt(a_Param, "ClanType", Info.clanType);
	Index = GetIndexFromType(Info.clanType);
	ParseString(a_Param, "Name", Info.sName);
	ParseInt(a_Param, "Level", Info.Level);
	ParseInt(a_Param, "Class", Info.ClassID);
	ParseInt(a_Param, "Gender", Info.gender);
	ParseInt(a_Param, "Race", Info.Race);
	ParseInt(a_Param, "ID", Info.Id);
	ParseInt(a_Param, "HaveMaster", Info.bHaveMaster);
	// End:0x126
	if(IsUsePledgeBonus())
	{
		ParseInt(a_Param, "MemberActive", Info.bActive);
	}
	Count = m_memberList[Index].m_array.Length;
	m_memberList[Index].m_array.Length = Count + 1;
	m_memberList[Index].m_array[Count] = Info;
	// End:0x192
	if(Index == m_currentShowIndex)
	{
		ShowList(Info.clanType);
	}
	SetPledgeNumGeneral();
}

function HandleAddClanMember(string a_Param)
{
	local int Count;
	local ClanMemberInfo Info;

	ParseString(a_Param, "Name", Info.sName);
	ParseInt(a_Param, "Level", Info.Level);
	ParseInt(a_Param, "Class", Info.ClassID);
	ParseInt(a_Param, "Gender", Info.gender);
	ParseInt(a_Param, "Race", Info.Race);
	ParseInt(a_Param, "ID", Info.Id);
	ParseInt(a_Param, "ClanType", Info.clanType);
	// End:0xEF
	if(IsUsePledgeBonus())
	{
		ParseInt(a_Param, "MemberActive", Info.bActive);
	}
	Info.bHaveMaster = 0;
	Count = m_memberList[GetIndexFromType(Info.clanType)].m_array.Length;
	m_memberList[GetIndexFromType(Info.clanType)].m_array.Length = Count + 1;
	m_memberList[GetIndexFromType(Info.clanType)].m_array[Count] = Info;
	if(GetIndexFromType(Info.clanType) == m_currentShowIndex)
	{
		ShowList(Info.clanType);
	}
	SetPledgeNumGeneral();
}

function HandleDeleteMember(string a_Param)
{
	local int i;
	local int j;
	local int k;
	local int Count;
	local string sName;

	ParseString(a_Param,"Name",sName);

	for(i = 0;i < CLAN_KNIGHTHOOD_COUNT; ++i)
	{
		Count = m_memberList[i].m_array.Length;
		for(j = 0;j < Count;++j)
		{
			if(m_memberList[i].m_array[j].sName == sName)
			{
				for(k = j;k < Count - 1; ++k)
				{
					m_memberList[i].m_array[k] = m_memberList[i].m_array[k + 1];
				}
				m_memberList[i].m_array.Length = Count - 1;
				break;
			}
		}
		if(j < Count)
			break;
	}
	if(i == m_currentShowIndex)
	{
		ShowList(i);
	}
}

function ClearList()
{
	clanSubInfoContainerScr.ClearList();
}

private function ClearCurrentNum()
{
	clanSubInfoContainerScr.ClearCurrentNum();	
}

function ClearAll()
{
	ClearList();
	Clear();
	ClearCurrentNum();
	clanSubInfoContainerScr.Clan8_DeclaredListCtrl.DeleteAllItem();
	clanSubInfoContainerScr.ClanSkillList_ListCtrl.DeleteAllItem();
	clanSubInfoContainerBenefitScr.ClearList();
	clanSubInfoContainerPledgeBonusScr.SetRemainCount(0);
}

function ShowList(int clanType)
{
	local int Index;

	Index = GetIndexFromType(clanType);
	m_currentShowIndex = Index;
	ClearList();
	clanSubInfoContainerScr.AddToList(Index);
}

function HandleMemberInfoUpdate(string a_Param)
{
	local ClanMemberInfo Info;
	local int i;
	local int j;
	local int Count;
	local bool bHaveMasterChanged;
	local bool bMemberChanged;
	local int process_length;
	local int process_clanindex;

	bHaveMasterChanged = false;
	bMemberChanged = false;
	ParseString(a_Param, "Name", Info.sName);
	ParseInt(a_Param, "Level", Info.Level);
	ParseInt(a_Param, "Class", Info.ClassID);
	ParseInt(a_Param, "Gender", Info.gender);
	ParseInt(a_Param, "Race", Info.Race);
	ParseInt(a_Param, "ID", Info.Id);
	ParseInt(a_Param, "ClanType", Info.clanType);
	ParseInt(a_Param, "HaveMaster", Info.bHaveMaster);
	ParseInt(a_Param, "MemberActive", Info.bActive);
	
	for(i = 0;i < CLAN_KNIGHTHOOD_COUNT;++i)
	{
		Count = m_memberList[i].m_array.Length;
		
		for(j = 0;j < Count;++j)
		{
			if(m_memberList[i].m_array[j].sName == Info.sName)
			{
				if(m_memberList[i].m_array[j].bHaveMaster != Info.bHaveMaster)
				{
					bHaveMasterChanged = true;
					m_memberList[i].m_array[j] = Info;
				}
				if(m_memberList[i].m_array[j].clanType != Info.clanType)
				{
					bMemberChanged = true;
					m_memberList[i].m_array.Remove(j, 1);
					process_clanindex = GetIndexFromType(Info.clanType);
					process_length = m_memberList[process_clanindex].m_array.Length;
					m_memberList[process_clanindex].m_array.Insert(process_length, 1);
					m_memberList[process_clanindex].m_array[process_length].sName = Info.sName;
					m_memberList[process_clanindex].m_array[process_length].clanType = Info.clanType;
					m_memberList[process_clanindex].m_array[process_length].Level = Info.Level;
					m_memberList[process_clanindex].m_array[process_length].ClassID = Info.ClassID;
					m_memberList[process_clanindex].m_array[process_length].gender = Info.gender;
					m_memberList[process_clanindex].m_array[process_length].Race = Info.Race;
					m_memberList[process_clanindex].m_array[process_length].Id = Info.Id;
					m_memberList[process_clanindex].m_array[process_length].bHaveMaster = Info.bHaveMaster;
					Class'UIAPI_TEXTBOX'.static.SetText(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberGrade", "");
					ShowList(Info.clanType);
				}
				else
				{
					m_memberList[i].m_array[j] = Info;
					ShowList(Info.clanType);
				}
				break;
			}
		}
		if(j < Count)
			break;
	}
	if(bHaveMasterChanged && class'UIAPI_WINDOW'.static.IsShowWindow(m_DrawerWindowName $ ".ClanMemberInfoWnd"))
	{
		if(clanSubMenuManageContainerScr.m_currentName == Info.sName)
		{
			RequestClanMemberInfo(Info.clanType, Info.sName);
		}
		if(GetIndexFromType(Info.clanType) == m_currentShowIndex)
		{
			ShowList(Info.clanType);
		}
		ShowList(m_currentShowIndex);
	}
	if(bMemberChanged && Class'UIAPI_WINDOW'.static.IsShowWindow(m_DrawerWindowName $ ".ClanMemberInfoWnd"))
	{
		ClearList();
		ShowList(Info.clanType);
		if(clanSubMenuManageContainerScr.m_currentName == Info.sName)
		{
			RequestClanMemberInfo(Info.clanType, Info.sName);
		}
	}
}

function HandleClanInfo(string a_Param)
{
	local string clanMasterName;
	local string ClanName;
	local int crestID;
	local int SkillLevel;
	local int bGuilty;
	local int allianceID;
	local string allianceName;
	local int AllianceCrestID;
	local int clanType;
	local int clanRank;
	local int clanNameValue;
	local int clanID;

	ParseInt(a_Param, "ClanID", clanID);
	ParseInt(a_Param, "ClanType", clanType);
	m_CurrentNHType = clanType;
	ParseString(a_Param, "ClanName", ClanName);
	ParseString(a_Param, "ClanMasterName", clanMasterName);
	ParseInt(a_Param, "CrestID", crestID);
	ParseInt(a_Param, "SkillLevel", SkillLevel);
	ParseInt(a_Param, "ClanRank", clanRank);
	ParseInt(a_Param, "ClanNameValue", clanNameValue);
	ParseInt(a_Param, "Guilty", bGuilty);
	ParseInt(a_Param, "AllianceID", allianceID);
	ParseString(a_Param, "AllianceName", allianceName);
	ParseInt(a_Param, "AllianceCrestID", AllianceCrestID);
	if(clanType == 0)
	{
		m_clanName = ClanName;
		m_clanRank = clanRank;
		m_clanNameValue = clanNameValue;
		m_clanLevel = SkillLevel;
		m_clanID = clanID;
		m_CurrentclanMasterReal = clanMasterName;
		SetClanName();
		SetClanmasterName();
		SetClanLevel();
		SetClanRankStr();
		SetAgitInfo(a_Param);
		SetPledgeLevelData();
		SetPledgeNumGeneral();
		SetPledgeLevelExp();
		HandleBenefitTooltip();
	}
	m_memberList[GetIndexFromType(clanType)].m_sName = ClanName;
	m_memberList[GetIndexFromType(clanType)].m_sMasterName = clanMasterName;
	SetmyClanInfo();
}

function HandleBenefitTooltip()
{
	local CustomTooltip t;
	local PledgeLevelData Data;

	getInstanceL2Util().setCustomTooltip(t);
	getInstanceL2Util().ToopTipMinWidth(10);
	GetPledgeLevelData(m_clanLevel, Data);
	getInstanceL2Util().ToopTipInsertColorText(Data.MeritDesc, true, true, getInstanceL2Util().Yellow);
	if(GetPledgeLevelData(m_clanLevel + 1, Data))
	{
		getInstanceL2Util().TooltipInsertItemBlank(0);
		getInstanceL2Util().TooltipInsertItemLine();
		getInstanceL2Util().TooltipInsertItemBlank(5);
		getInstanceL2Util().ToopTipInsertColorText(Data.MeritDesc, true, true, getInstanceL2Util().White);
	}
	getInstanceL2Util().TooltipInsertItemBlank(0);
	getInstanceL2Util().TooltipInsertItemLine();
	getInstanceL2Util().TooltipInsertItemBlank(5);
	getInstanceL2Util().ToopTipInsertColorText(GetSystemString(13473), true, true, getInstanceL2Util().Blue);
	GetButtonHandle(m_WindowName $ ".ClanManagementBtn").SetTooltipCustomType(getInstanceL2Util().getCustomToolTip());
}

function HandleClanInfoUpdate(string a_Param)
{
	local int PledgeCrestID;
	local int bGuilty;
	local int allianceID;
	local string sAllianceName;
	local int AllianceCrestID;
	local int LargePledgeCrestID;

	ParseInt(a_Param, "ClanID", m_clanID);
	ParseInt(a_Param, "CrestID", PledgeCrestID);
	ParseInt(a_Param, "SkillLevel", m_clanLevel);
	ParseInt(a_Param, "ClanRank", m_clanRank);
	ParseInt(a_Param, "ClanNameValue", m_clanNameValue);
	ParseInt(a_Param, "Guilty", bGuilty);
	ParseInt(a_Param, "AllianceID", allianceID);
	ParseString(a_Param, "AllianceName", sAllianceName);
	ParseInt(a_Param, "AllianceCrestID", AllianceCrestID);
	ParseInt(a_Param, "LargeCrestID", LargePledgeCrestID);
	SetClanLevel();
	SetPledgeLevelData();
	SetPledgeNumGeneral();
	SetPledgeLevelExp();
	SetClanRankStr();
	HandleBenefitTooltip();
	SetAgitInfo(a_Param);
	resetBtnShowHide();
	SetmyClanInfo();
	API_C_EX_PLEDGE_V3_INFO();
}

function HandleSubClanUpdated(string a_Param)
{
	local int Id;
	local int Type;
	local string sName;
	local string sMasterName;

	ParseInt(a_Param, "ClanID", Id);
	ParseInt(a_Param, "ClanType", Type);
	ParseString(a_Param, "ClanName", sName);
	ParseString(a_Param, "MasterName", sMasterName);
	m_memberList[GetIndexFromType(Type)].m_sName = sName;
	m_memberList[GetIndexFromType(Type)].m_sMasterName = sMasterName;
}

function AskJoinByName(string UserName)
{
	DialogSetID(DIALOG_ASK_JOIN);
	DialogBox(GetScript("DialogBox")).SetReservedString(UserName);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(13310),UserName),string(self));
}

function askJoin()
{
	local UserInfo User;

	if(GetTargetInfo(User))
	{
		if(User.nID > 0)
		{
			AskJoinByName(User.Name);
		}
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(7257));
	}
}

function HandleDialogOK()
{
	local string UserName;

	if(! DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		// End:0x52
		case DIALOG_ASK_JOIN:
			UserName = DialogBox(GetScript("DialogBox")).GetReservedString();
			RequestClanAskJoinByName(UserName, 0);
			// End:0x55
			break;
	}
}

function HandleShowHideClanShopWnd()
{
	local WindowHandle ClanShopWndClassicHandle;

	ClanShopWndClassicHandle = GetWindowHandle("ClanShopWndClassic");
	// End:0x44
	if(ClanShopWndClassicHandle.IsShowWindow())
	{
		ClanShopWndClassicHandle.HideWindow();		
	}
	else
	{
		ClanShopWndClassicHandle.ShowWindow();
		ClanShopWndClassicHandle.SetFocus();
	}
}

function HandleClanMyAuth(string a_Param)
{
	ParseInt(a_Param, "ClanMaster", m_bClanMaster);
	ParseInt(a_Param, "Join", m_bJoin);
	ParseInt(a_Param, "NickName", m_bNickName);
	ParseInt(a_Param, "ClanCrest", m_bCrest);
	ParseInt(a_Param, "Grade", m_bGrade);
	ParseInt(a_Param, "ManageMaster", m_bManageMaster);
	ParseInt(a_Param, "OustMember", m_bOustMember);
	resetBtnShowHide();
}

function IsWorldRaidServer()
{
	if((IsPlayerOnWorldRaidServer() == true) && !IsAdenServer())
	{
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanMemAuthBtn");
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanBoardBtn");
		Class'UIAPI_WINDOW'.static.DisableWindow(clanSubMenuManageContainerScr.m_WindowName_ClanMemberInfoWnd $ ".ClanQuitBtn");
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanUnionBtn");
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAskJoinBtn");
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
	}
}

function bool GetSelectedListCtrlItem(out RichListCtrlRowData Record)
{
	local int Index;

	Index = clanSubInfoContainerScr.ClanMemberList_ListCtrl.GetSelectedIndex();
	if(Index >= 0)
	{
		clanSubInfoContainerScr.ClanMemberList_ListCtrl.GetRec(Index,Record);
		return true;
	}
	return false;
}

function HandleBtnClick(string btnName)
{
	local string strID;

	if(GetStringIDFromBtnName(btnName, "ClanSubInfo_Tab", strID))
	{
		switch(strID)
		{
			case "0":
				clanSubInfoContainerScr.Me.ShowWindow();
				clanSubInfoContainerPledgeBonusScr.Me.HideWindow();
				clanSubInfoContainerBenefitScr.Me.HideWindow();
				break;
			case "1":
				clanSubInfoContainerScr.Me.HideWindow();
				clanSubInfoContainerPledgeBonusScr.Me.ShowWindow();
				clanSubInfoContainerBenefitScr.Me.HideWindow();
				break;
			case "2":
				clanSubInfoContainerScr.Me.HideWindow();
				clanSubInfoContainerPledgeBonusScr.Me.HideWindow();
				clanSubInfoContainerBenefitScr.Me.ShowWindow();
				break;
		}
	}
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	// End:0x17
	if(! CheckBtnName(btnName, someString))
	{
		return false;
	}
	strID = Mid(btnName, Len(someString));
	return true;
}

function bool CheckBtnName(string btnName, string someString)
{
	return Left(btnName, Len(someString)) == someString;
}

function ShowBBS()
{
	local string strParam;

	strParam = "";
	ParamAdd(strParam, "Index", "3");
	ExecuteEvent(1190, strParam);
}

function SetClanName()
{
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanNameText", m_clanName);
}

function SetClanmasterName()
{
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanMasterNameText", m_CurrentclanMasterReal);
}

function SetClanLevel()
{
	class'UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".ClanLevelText", m_clanLevel);
}

function SetAgitInfo(string a_Param)
{
	local int AgitID;
	local int AgitType;
	local int castleID;
	local int fotressID;

	ParseInt(a_Param,"AgitID",AgitID);
	ParseInt(a_Param,"AgitType",AgitType);
	ParseInt(a_Param,"CastleID",castleID);
	ParseInt(a_Param,"FortressID",fotressID);
	if(AgitID > 0)
	{
		if(AgitType == 0)
		{
			class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText",GetCastleName(AgitID));
		}
		else if(AgitType == 1)
		{
			class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText",GetInZoneNameWithZoneID(AgitID));
		}
	}
	else if(castleID > 0)
	{
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText",GetCastleName(castleID));
	}
	else if(fotressID > 0)
	{
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText",GetCastleName(fotressID));
	}
	else
	{
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText",GetSystemString(27));
	}
}

function SetClanRankStr()
{
	local string ClanRankStr;

	// End:0xAA
	if(m_clanID > 0)
	{
		// End:0x20
		if(IsPlayerOnWorldRaidServer())
		{
			ClanRankStr = "-";
		}
		else
		{
			ClanRankStr = GetSystemString(1374);
		}
		// End:0x64
		if((m_clanRank > 0)&&(m_clanRank <= c_maxranklimit))
		{
			ClanRankStr = string(m_clanRank)@ GetSystemString(1375);
		}
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanRankingInfo_Wnd.Clan3_ClanRanking", ClanRankStr);
	}
	else
	{
		class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanRankingInfo_Wnd.Clan3_ClanRanking", "");
	}
}

function ShowContextMenu(int X, int Y)
{
	local UIControlContextMenu ContextMenu;
	local bool isClanMaster;
	local bool bCanCrest;

	ContextMenu = class'UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	ContextMenu.MenuNew(GetSystemString(1446), 0);
	ContextMenu.MenuAddIcon("L2UI_EPIC.ClanWnd.ClanWnd_Icon_penalty");
	isClanMaster = m_bClanMaster > 0;
	bCanCrest = (m_clanLevel > 0) && (isClanMaster ||(m_bCrest != 0));
	if(isClanMaster || bCanCrest)
	{
		ContextMenu.MenuLineAdd();
		if(isClanMaster)
		{
			ContextMenu.MenuNew(GetSystemString(668), 1);
			ContextMenu.MenuAddIcon("L2UI_EPIC.ClanWnd.ClanWnd_Icon_Authority");
		}
		if(bCanCrest)
		{
			ContextMenu.MenuNew(GetSystemString(3663), 2);
			ContextMenu.MenuAddIcon("L2UI_EPIC.ClanWnd.ClanWnd_Icon_Emblem");
		}
	}
	GetButtonHandle(m_WindowName $ ".ClanManagementBtn").ClearTooltip();
	ContextMenu.DelegateOnHide = HandleBenefitTooltip;
	ContextMenu.Show(X - 5, Y - 5, string(self));
}

function HandleOnClickContextMenu(int Index)
{
	switch(Index)
	{
		case 0:
			ExecuteCommandFromAction("pledgepenalty");
			break;
		case 1:
			if(clanSubMenuManageContainerScr.ToggleWindowByType(clanSubMenuManageContainerScr.TYPE_SUBMENU_STATE.ClanAuthManageWndState))
			{
				RequestClanGradeList();
			}
			break;
		case 2:
			clanSubMenuManageContainerScr.ToggleWindowByType(clanSubMenuManageContainerScr.TYPE_SUBMENU_STATE.ClanEmblemManageWndState);
			break;
	}
}

function SetPledgeLevelData()
{
	local PledgeLevelData tmpPledgeLvelData;

	if(! API_GetPledgeLevelData(m_clanLevel, tmpPledgeLvelData))
	{
		return;
	}
	pledgeLevelDataStru = tmpPledgeLvelData;
	clanSubInfoContainerBenefitScr.SetRecords();
	clanSubInfoContainerPledgeBonusScr.API_C_EX_PLEDGE_DONATION_INFO();
}

function SetPledgeNumGeneral()
{
	if(m_clanID > 0)
	{
		Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanRankingInfo_Wnd.Clan3_ClanNum", string(m_memberList[0].m_array.Length) $ "/" $ string(pledgeLevelDataStru.NumGeneral));
	}
	else
	{
		Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanRankingInfo_Wnd.Clan3_ClanNum", "0/0");
	}
}

function SetPledgeLevelExp()
{
	local StatusBarHandle clanLevel_StatusBar;
	local PledgeLevelData prevPledgeLevelData;
	local int NeedPledgeExp;
	local int currentPledgeExp;

	NeedPledgeExp = pledgeLevelDataStru.NeedPledgeExp;
	currentPledgeExp = pledgeExp;
	if(m_clanLevel >= 1)
	{
		if(API_GetPledgeLevelData(m_clanLevel - 1, prevPledgeLevelData))
		{
			currentPledgeExp = pledgeExp - prevPledgeLevelData.NeedPledgeExp;
			NeedPledgeExp = NeedPledgeExp - prevPledgeLevelData.NeedPledgeExp;
		}
	}
	clanLevel_StatusBar = GetStatusBarHandle(m_WindowName $ ".ClanLevel_StatusBar");
	clanLevel_StatusBar.SetPointExpPercentRate(float(currentPledgeExp) / float(NeedPledgeExp));
	clanLevel_StatusBar.SetTooltipText(string(currentPledgeExp) $ "/" $ string(NeedPledgeExp));
}

function int GetClanTypeFromIndex(int index)
{
	local int type;
	if(index == 0)
	{
		type = CLAN_MAIN;
	}
	if(index == 1)
	{
		type = CLAN_KNIGHT1;
	}
	if(index == 2)
	{
		type = CLAN_KNIGHT2;
	}
	if(index == 3)
	{
		type = CLAN_KNIGHT3;
	}
	if(index == 4)
	{
		type = CLAN_KNIGHT4;
	}
	if(index == 5)
	{
		type = CLAN_KNIGHT5;
	}
	if(index == 6)
	{
		type = CLAN_KNIGHT6;
	}
	if(index == 7)
	{
		type = CLAN_ACADEMY;
	}
	return type;
}

function string GetClanTypeNameFromIndex(int index)
{
	local string type;
	if(index == CLAN_MAIN)
	{
		type = GetSystemString(1399);
	}
	if(index == CLAN_KNIGHT1)
	{
		type = GetSystemString(1400);
	}
	if(index == CLAN_KNIGHT2)
	{
		type = GetSystemString(1401);
	}
	if(index == CLAN_KNIGHT3)
	{
		type = GetSystemString(1402);
	}
	if(index == CLAN_KNIGHT4)
	{
		type = GetSystemString(1403);
	}
	if(index == CLAN_KNIGHT5)
	{
		type = GetSystemString(1404);
	}
	if(index == CLAN_KNIGHT6)
	{
		type = GetSystemString(1405);
	}
	if(index == CLAN_ACADEMY)
	{
		type = GetSystemString(1452);
	}
	return type;
}

function int GetIndexFromType(int type)
{
	local int i;
	i = -1;
	if(type == CLAN_MAIN)
	{
		i = 0;
	}
	else if(type == CLAN_KNIGHT1)
	{
		i = 1;
	}
	else if(type == CLAN_KNIGHT2)
	{
		i = 2;
	}
	else if(type == CLAN_KNIGHT3)
	{
		i = 3;
	}
	else if(type == CLAN_KNIGHT4)
	{
		i = 4;
	}
	else if(type == CLAN_KNIGHT5)
	{
		i = 5;
	}
	else if(type == CLAN_KNIGHT6)
	{
		i = 6;
	}
	else if(type == CLAN_ACADEMY)
	{
		i = 7;
	}
	return i;
}

function int findmyClanData(string C_Name)
{
	local int i;
	local int j;
	local int clannum;

	for(i = 0; i < m_memberList.Length; ++i)
	{
		for(j = 0; j < m_memberList[i].m_array.Length; ++j)
		{
			if(m_memberList[i].m_array[j].sName == C_Name)
			{
				clannum = m_memberList[i].m_array[j].clanType;
			}
		}
	}
	return clannum;
}

function int GetTopIndex()
{
	return GetTabHandle(m_WindowName $ ".ClanSubInfo_Tab").GetTopIndex();
}

function InitUIControlDialogAsset()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle(m_WindowName $ ".UIControlDialogAsset");
	class'UIControlDialogAssets'.static.InitScript(poopExpandWnd);
}

function UIControlDialogAssets GetPopupScript()
{
	return UIControlDialogAssets(GetWindowHandle(m_WindowName $ ".UIControlDialogAsset").GetScript());
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_WindowName).HideWindow();
}

defaultproperties
{
     m_DrawerWindowName="ClanSubMenuManageContainer"
}
