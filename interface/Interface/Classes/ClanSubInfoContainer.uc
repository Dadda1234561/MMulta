class ClanSubInfoContainer extends UIData;

const DIALOG_AskClanEnemyCancel = 487;

enum CONTEXT_MENU_INDEX
{
	ClanMemInfoBtn,
	AddParty,
	AddFriend,
	whisperToUser,
	Clan1_ChangeMemberNameBtn,
	Clan1_ChangeMemberGradeBtn
};

enum TAB_TYPE
{
	CLANMEMBER,
	ENEMYINFOS,
	CLANSKILLS
};

var string m_WindowName;
var WindowHandle Me;
var RichListCtrlHandle ClanMemberList_ListCtrl;
var ListCtrlHandle Clan8_DeclaredListCtrl;
var RichListCtrlHandle ClanSkillList_ListCtrl;
var TextBoxHandle noSkillText;
var TabHandle tab;
var int m_currentShowIndex;
var ClanWndClassicNew clanWndClassicScr;
var ClanSubMenuManageContainer clanSubMenuManageContainerScr;
var string withEnemyPledgeNameStr;

var array<UIPacket._L2PledgeEnemyInfo> L2PledgeEnemyInfoList;
var array<UIPacket._PkPledgeContribution> contributionList;

function InitDefaultSetting()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	clanWndClassicScr = ClanWndClassicNew(GetScript("ClanWndClassicNew"));
	clanWndClassicScr.clanSubInfoContainerScr = self;
	tab = TabHandle(Me.GetChildWindow("ClanReward_TabCtrl"));
	tab.InitTabCtrl();
	Me.SetFocus();
}

function InitHandleCOD()
{
	ClanMemberList_ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".ClanMemberList_Wnd.ClanMemberList_ListCtrl");
	Clan8_DeclaredListCtrl = GetListCtrlHandle(m_WindowName $ ".ClanWarList_Wnd.Clan8_DeclaredListCtrl");
	ClanSkillList_ListCtrl = GetRichListCtrlHandle(m_WindowName $ ".ClanSkillList_Wnd.ClanSkillList_ListCtrl");
	clanSubMenuManageContainerScr = ClanSubMenuManageContainer(GetScript("ClanWndClassicNew.ClanSubMenuManageContainer"));
	noSkillText = GetTextBoxHandle(m_WindowName $ ".ClanSkillList_Wnd.noSkillText");
	ClanMemberList_ListCtrl.SetAppearTooltipAtMouseX(true);
	ClanMemberList_ListCtrl.SetSelectedSelTooltip(false);
	ClanSkillList_ListCtrl.SetAppearTooltipAtMouseX(true);
	ClanSkillList_ListCtrl.SetSelectedSelTooltip(false);
	ClanSkillList_ListCtrl.SetSelectable(false);
}

event OnLoad()
{
	InitDefaultSetting();
	InitHandleCOD();
}

event OnRegisterEvent()
{
	RegisterEvent(EV_DialogOK);
	RegisterEvent(EV_ClanSkillList);
	RegisterEvent(EV_ClanSkillListRenew);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_ENEMY_INFO_LIST);
	RegisterEvent(EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_CONTRIBUTION_LIST);
	RegisterEvent(EV_RequestEnemyPledgeRegister);
}

event OnShow()
{
	Me.SetFocus();
}

function HandleOnShow()
{
	switch(GetTopIndex())
	{
		// End:0x12
		case 0:
			// End:0x35
			break;
		// End:0x22
		case 1:
			API_C_EX_PLEDGE_ENEMY_INFO_LIST();
			// End:0x35
			break;
		// End:0x32
		case 2:
			API_RequestClanSkillList();
			// End:0x35
			break;
	}
}

event OnEvent(int a_EventID, string a_Param)
{
	if(getInstanceL2Util().isClanV2())
	{
		return;
	}
	switch(a_EventID)
	{
		case EV_ClanSkillList:
			HandleSkillList(a_Param);
			break;
		case EV_ClanSkillListRenew:
			HandleSkillRenew(a_Param);
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_ENEMY_INFO_LIST:
			Handle_S_EX_PLEDGE_ENEMY_INFO_LIST();
			break;
		case EV_RequestEnemyPledgeRegister:
			HandleEV_RequestEnemyPledgeRegister(a_Param);
			break;
		case EV_ProtocolBegin + class'UIPacket'.const.S_EX_PLEDGE_CONTRIBUTION_LIST:
			Handle_S_EX_PLEDGE_CONTRIBUTION_LIST();
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		default:
			break;
	}
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle)
	{
		case Clan8_DeclaredListCtrl:
			SwitchingEnemyCancelButton();
			break;
	}
}

event OnClickRichListButton(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle)
	{
		case ClanMemberList_ListCtrl:
			// End:0x26
			if(ClanMemberList_ListCtrl.GetSelectedIndex() < 0)
			{
				return;
			}
			ShowContextMenu(X, Y);
			break;
	}
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 10;
	switch(ListCtrlID)
	{
		case "Clan8_DeclaredListCtrl":
			HandleClickCancelEnemy();
			break;
		case "ClanMemberList_ListCtrl":
			clanSubMenuManageContainerScr.SetState(clanSubMenuManageContainerScr.TYPE_SUBMENU_STATE.ClanMemberInfoState);
			break;
	}
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 10;
	switch(ListCtrlID)
	{
		case "Clan8_DeclaredListCtrl":
			SwitchingEnemyCancelButton();
			break;
		case "ClanMemberList_ListCtrl":
			switch(clanSubMenuManageContainerScr.CurrentState)
			{
				case clanSubMenuManageContainerScr.TYPE_SUBMENU_STATE.ClanMemberInfoState:
					RequestCurrentSelectedClanMemberInfo();
					break;
				case clanSubMenuManageContainerScr.TYPE_SUBMENU_STATE.ClanMemberAuthState:
					RequestCurrentSelectedClanMemberAuth();
					break;
			}
			break;
	}
}

event OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle.GetWindowName())
	{
		case "ClanMemberList_ListCtrl":
			if(ClanMemberList_ListCtrl.GetSelectedIndex() < 0)
			{
				return;
			}
			ShowContextMenu(X, Y);
			break;
	}
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "ClanReward_TabCtrl0":
			GetWindowHandle(m_WindowName $ ".OnOffBtns").ShowWindow();
			API_C_EX_PLEDGE_CONTRIBUTION_LIST();
			// End:0x1CF
			break;
		case "ClanReward_TabCtrl1":
			if(clanWndClassicScr.m_clanID > 0)
			{
				GetButtonHandle(m_WindowName $ ".ClanWarList_Wnd.ClanWar_OKBtn").EnableWindow();
			}
			else
			{
				GetButtonHandle(m_WindowName $ ".ClanWarList_Wnd.ClanWar_OKBtn").DisableWindow();
			}
			GetWindowHandle(m_WindowName $ ".OnOffBtns").HideWindow();
			API_C_EX_PLEDGE_ENEMY_INFO_LIST();
			break;
		case "ClanReward_TabCtrl2":
			GetWindowHandle(m_WindowName $ ".OnOffBtns").HideWindow();
			API_RequestClanSkillList();
			break;
		case "ClanWar_OKBtn":
			API_RequestEnemyPledgeRegister();
			break;
		case "Clan8_CancelWar1Btn":
			HandleClickCancelEnemy();
			break;
		case "PledgePCOnline_Btn":
		case "PledgePCOffline_Btn":
			TogglePledgePCOnOffLine_Btn();
			break;
	}
}

function bool RequestCurrentSelectedClanMemberAuth()
{
	local RichListCtrlRowData Record;

	if(! GetSelectedListCtrlItem(Record))
	{
		return false;
	}
	API_RequestClanMemberAuth(int(Record.nReserved1), Record.cellDataList[0].szData);
	return true;
}

function API_RequestClanMemberAuth(int clanType, string memberName)
{
	RequestClanMemberAuth(clanType, memberName);
}

function bool RequestCurrentSelectedClanMemberInfo()
{
	local RichListCtrlRowData Record;

	if(! GetSelectedListCtrlItem(Record))
	{
		return false;
	}
	API_RequestClanMemberInfo(int(Record.nReserved1), Record.cellDataList[0].szData);
	return true;
}

function API_RequestClanMemberInfo(int clanType, string memberName)
{
	RequestClanMemberInfo(clanType, memberName);
}

function API_C_EX_PLEDGE_CONTRIBUTION_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_CONTRIBUTION_LIST packet;

	// End:0x20
	if(! class'UIPacket'.static.Encode_C_EX_PLEDGE_CONTRIBUTION_LIST(stream, packet))
	{
		return;
	}
	class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PLEDGE_CONTRIBUTION_LIST, stream);
}

function API_RequestEnemyPledgeRegister()
{
	RequestEnemyPledgeRegister();
}

function API_C_EX_PLEDGE_ENEMY_REGISTER()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_ENEMY_REGISTER packet;

	if(withEnemyPledgeNameStr != "")
	{
		packet.sEnemyPledgeName = API_ConvertWorldStrToID(withEnemyPledgeNameStr);
		if( !Class'UIPacket'.static.Encode_C_EX_PLEDGE_ENEMY_REGISTER(stream,packet))
		{
			return;
		}
		Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PLEDGE_ENEMY_REGISTER,stream);
	}
	withEnemyPledgeNameStr = "";
}

function string API_ConvertWorldStrToID(string PledgeName)
{
	return ConvertWorldStrToID(PledgeName);
}

function API_C_EX_PLEDGE_ENEMY_INFO_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_ENEMY_INFO_LIST packet;

	packet.nPledgeSId = clanWndClassicScr.m_clanID;
	if ( !Class'UIPacket'.static.Encode_C_EX_PLEDGE_ENEMY_INFO_LIST(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PLEDGE_ENEMY_INFO_LIST, stream);
}

function API_C_EX_PLEDGE_ENEMY_DELETE(int EnemyPledgeSID)
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_ENEMY_DELETE packet;

	packet.nEnemyPledgeSID = EnemyPledgeSID;
	if ( !Class'UIPacket'.static.Encode_C_EX_PLEDGE_ENEMY_DELETE(stream,packet) )
	{
		return;
	}
	Class'UIPacket'.static.RequestUIPacket(class'UIPacket'.const.C_EX_PLEDGE_ENEMY_DELETE, stream);
}

function Handle_S_EX_PLEDGE_ENEMY_INFO_LIST()
{
	local UIPacket._S_EX_PLEDGE_ENEMY_INFO_LIST packet;
	local int i;

	if (!Class'UIPacket'.static.Decode_S_EX_PLEDGE_ENEMY_INFO_LIST(packet))
	{
		return;
	}
	L2PledgeEnemyInfoList = packet.L2PledgeEnemyInfoList;
	Clan8_DeclaredListCtrl.DeleteAllItem();
	
	for ( i = 0;i < L2PledgeEnemyInfoList.Length;i++ )
	{
		HandleClanEnelyList(L2PledgeEnemyInfoList[i]);
	}
	SwitchingEnemyCancelButton();
}

function Handle_S_EX_PLEDGE_CONTRIBUTION_LIST()
{
	local UIPacket._S_EX_PLEDGE_CONTRIBUTION_LIST packet;
	local int i;

	// End:0x1B
	if(! class'UIPacket'.static.Decode_S_EX_PLEDGE_CONTRIBUTION_LIST(packet))
	{
		return;
	}
	contributionList = packet.contributionList;

	for(i = 0; i < contributionList.Length; i++)
	{
		ModiFyRecordByPkPledgeContribution(contributionList[i]);
	}
}

function API_RequestClanSkillList()
{
	class'UIDATA_CLAN'.static.RequestClanSkillList();
}

function ClearList()
{
	local UIControlContextMenu ContextMenu;

	ContextMenu = class'UIControlContextMenu'.static.GetInstance();
	if(ContextMenu.IsMine(string(self)))
	{
		ContextMenu.Hide();
	}
	ClanMemberList_ListCtrl.DeleteAllItem();
}

function ClearSkills()
{
	ClanSkillList_ListCtrl.DeleteAllItem();
}

function HandleEV_RequestEnemyPledgeRegister(string param)
{
	ParseString(param, "PledgeName", withEnemyPledgeNameStr);
	API_C_EX_PLEDGE_ENEMY_REGISTER();
}

function SwitchingEnemyCancelButton()
{
	local int SelectedIndex;

	SelectedIndex = Clan8_DeclaredListCtrl.GetSelectedIndex();
	if ( (SelectedIndex >= 0) && (clanWndClassicScr.m_clanID > 0) )
	{
		Class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarList_Wnd.Clan8_CancelWar1Btn");
	} else {
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarList_Wnd.Clan8_CancelWar1Btn");
	}
}

function HandleCancelEnemy()
{
	local LVDataRecord Record;
	local int Index;

	Index = Clan8_DeclaredListCtrl.GetSelectedIndex();
	if(Index >= 0)
	{
		Clan8_DeclaredListCtrl.GetRec(Index, Record);
		API_C_EX_PLEDGE_ENEMY_DELETE(int(Record.nReserved1));
	}
}

function HandleClickCancelEnemy()
{
	Class'UICommonAPI'.static.DialogSetID(DIALOG_AskClanEnemyCancel);
	Class'UICommonAPI'.static.DialogSetDefaultCancle();
	DialogShow(DialogModalType_Modalless,DialogType_OKCancel,MakeFullSystemMsg(GetSystemMessage(3883),""), string(self));
}

function HandleClanEnelyList (UIPacket._L2PledgeEnemyInfo pledgeEnemyInfo)
{
	local LVDataRecord Record;

	Record.nReserved1 = pledgeEnemyInfo.nEnemyPledgeSID;
	Record.LVDataList.Length = 2;
	Record.LVDataList[0].szData = ConvertWorldIDToStr(pledgeEnemyInfo.sEnemyPledgeName);
	Record.LVDataList[1].szData = pledgeEnemyInfo.sEnemyPledgeMasterName;
	Clan8_DeclaredListCtrl.InsertRecord(Record);
}

function HandleDialogOK()
{
	local int dialogID;

	if ( !DialogIsMine() )
	{
		return;
	}
	dialogID = DialogGetID();
	if ( dialogID == DIALOG_AskClanEnemyCancel )
	{
		HandleCancelEnemy();
	}
}

function AddToList(int idx)
{
	local RichListCtrlRowData Record;
	local int i;
	local int MyIndex;
	local int OnLineNum;

	OnLineNum = 0;
	
	for ( i = 0;i < clanWndClassicScr.m_memberList[idx].m_array.Length;i++ )
	{
		if ( clanWndClassicScr.m_memberList[idx].m_array[i].Id > 0 )
		{
			OnLineNum++;
		}
		else if ( IsOnlyOnline() )
			continue;
		Record = makeRecord(clanWndClassicScr.m_memberList[idx].m_array[i]);
		if ( Record.cellDataList[0].szData == clanWndClassicScr.m_myName )
		{
			MyIndex = i;
		}
		ClanMemberList_ListCtrl.InsertRecord(Record);
	}
	ClanMemberList_ListCtrl.SetSelectedIndex(MyIndex, true);
	Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".OnOffBtns.ClanCurrentNum","(" $ string(OnLineNum) $ "/" $ string(clanWndClassicScr.m_memberList[0].m_array.Length) $ ")");
}

function ClearCurrentNum()
{
	Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".OnOffBtns.ClanCurrentNum", "0/0");
}

function HandleSkillRenew(string a_Param)
{
	// End:0x32
	if(clanWndClassicScr.Me.IsShowWindow() && GetTopIndex() == 2)
	{
		API_RequestClanSkillList();
	}
}

function HandleSkillList(string a_Param)
{
	local int Count;
	local int i;
	local int Level;
	local ItemID cID;

	ClearSkills();
	ParseInt(a_Param, "Count", Count);

	for ( i = 0;i < Count;i++ )
	{
		ParseItemIDWithIndex(a_Param, cID, i);
		ParseInt(a_Param, "SkillLevel_" $ string(i), Level);
		ClanSkillList_ListCtrl.InsertRecord(MakeRecordSkill(cID, Level));
	}

	if(Count > 0)
	{
		noSkillText.HideWindow();
	}
	else
	{
		noSkillText.ShowWindow();
	}
}

function RichListCtrlRowData MakeRecordSkill(ItemID cID, int SkillLevel)
{
	local RichListCtrlRowData Record;
	local ItemInfo iInfo;
	local SkillInfo sInfo;
	local string Desc;
	local int wMax;

	Record.cellDataList.Length = 2;
	Record.nReserved1 = cID.ClassID;
	Record.nReserved2 = SkillLevel;
	Record.nReserved3 = 0;
	GetSkillInfo(cID.ClassID, SkillLevel, 0, sInfo);
	class'L2Util'.static.GetSkill2ItemInfo(sInfo, iInfo);
	AddRichListCtrlSkill(Record.cellDataList[0].drawitems, iInfo, 36, 36, 0, -1);
	addRichListCtrlString(Record.cellDataList[0].drawitems, sInfo.SkillName, getInstanceL2Util().BrightWhite, false, 4, 4);
	addRichListCtrlString(Record.cellDataList[0].drawitems, GetSystemString(88) $ string(sInfo.SkillLevel), getInstanceL2Util().Yellow03, true, 41, 2);
	addRichListCtrlString(Record.cellDataList[0].drawitems, getSkillTypeString(sInfo.IconType), GetColor(176, 155, 121, 255), false, 4);
	Desc = Substitute(sInfo.SkillDesc, "\\n", ", ", false);
	Desc = Substitute(Desc, ", , ", ", ", false);
	wMax = 267;
	class'L2Util'.static.GetEllipsisString(Desc, wMax);
	addRichListCtrlString(Record.cellDataList[1].drawitems, Desc, GetColor(178, 190, 207, 255));
	return Record;
}

function ShowContextMenu(int X, int Y)
{
	local UIControlContextMenu ContextMenu;

	ContextMenu = Class'UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	ContextMenu.MenuNew(GetSystemString(1322),0);
	if ( (GetCurrentSelectedName() != clanWndClassicScr.m_myName) && IsSelectedLogin() )
	{
		ContextMenu.MenuLineAdd();
		ContextMenu.MenuNew(GetSystemString(396), 1);
		ContextMenu.MenuNew(GetSystemString(3227), 2);
		ContextMenu.MenuNew(GetSystemString(398), 3);
	}
	ContextMenu.Show(X,Y,string(self));
}

function HandleOnClickContextMenu(int Index)
{
	switch(Index)
	{
		case 0:
			HandleClickContextClanInfo(Index);
			break;
		case 1:
			HandlePartyAskJoin(Index);
			break;
		case 2:
			HandleAddFriend(Index);
			break;
		case 3:
			HandleWhisper(Index);
			break;
		case 4:
			ChangeNickname(Index);
			break;
		case 5:
			ChangeChangeGrade(Index);
			break;
	}
}

function HandleClickContextClanInfo(int Index)
{
	clanSubMenuManageContainerScr.SetState(clanSubMenuManageContainerScr.TYPE_SUBMENU_STATE.ClanMemberInfoState);
}

function HandlePartyAskJoin(int Index)
{
	local string selectedName;

	selectedName = GetCurrentSelectedName();
	if ( selectedName == "" )
	{
		return;
	}
	RequestInviteParty(selectedName);
}

function HandleAddFriend(int Index)
{
	local string selectedName;

	selectedName = GetCurrentSelectedName();
	if ( selectedName == "" )
	{
		return;
	}
	Debug("HandleAddFriend" @ selectedName);
	Class'PersonalConnectionAPI'.static.RequestAddFriend(selectedName);
}

function HandleWhisper(int Index)
{
	local string selectedName;

	selectedName = GetCurrentSelectedName();
	if(selectedName == "")
	{
		return;
	}
	SetChatMessage("\"\" $ selectedName $ \" ");
}

function ChangeNickname(int Index)
{
	Debug("호칭 변경");
	clanSubMenuManageContainerScr.SetState(clanSubMenuManageContainerScr.TYPE_SUBMENU_STATE.ClanMemberInfoState);
	clanSubMenuManageContainerScr.OnClickButton("Clan1_ChangeMemberNameBtn");
}

function ChangeChangeGrade(int Index)
{
	Debug("µо±Ю єЇ°ж");
	clanSubMenuManageContainerScr.SetState(clanSubMenuManageContainerScr.TYPE_SUBMENU_STATE.ClanMemberInfoState);
	clanSubMenuManageContainerScr.OnClickButton("Clan1_ChangeMemberGradeBtn");
}

function bool IsOnlyOnline()
{
	return GetButtonHandle(m_WindowName $ ".OnOffBtns.PledgePCOnline_Btn").IsShowWindow();
}

function TogglePledgePCOnOffLine_Btn()
{
	if ( IsOnlyOnline() )
	{
		GetButtonHandle(m_WindowName $ ".OnOffBtns.PledgePCOnline_Btn").HideWindow();
		GetButtonHandle(m_WindowName $ ".OnOffBtns.PledgePCOffline_Btn").ShowWindow();
	}
	// End:0xE6
	else
	{
		GetButtonHandle(m_WindowName $ ".OnOffBtns.PledgePCOnline_Btn").ShowWindow();
		GetButtonHandle(m_WindowName $ ".OnOffBtns.PledgePCOffline_Btn").HideWindow();
	}
	ShowList(0);
}

function ShowList(int clanType)
{
	ClearList();
	AddToList(0);
	API_C_EX_PLEDGE_CONTRIBUTION_LIST();
}

function ModiFyRecordByPkPledgeContribution(UIPacket._PkPledgeContribution contribution)
{
	local int Index;

	Index = GetListIndexBycontribution(contribution);
	// End:0x30
	if(Index > -1)
	{
		InputContributionToRecord(Index, contribution);
	}
}

function bool GetContributionByName(string sName, out UIPacket._PkPledgeContribution contribution)
{
	local int i;

	// End:0x4E
	for(i = 0; i < contributionList.Length; i++)
	{
		// End:0x44
		if(sName == contributionList[i].sUserName)
		{
			contribution = contributionList[i];
			return true;
		}
	}
	return false;
}

function int GetListIndexBycontribution(UIPacket._PkPledgeContribution contribution)
{
	local int i;
	local RichListCtrlRowData Record;

	for(i = 0; i < ClanMemberList_ListCtrl.GetRecordCount(); i++)
	{
		ClanMemberList_ListCtrl.GetRec(i, Record);
		// End:0x5F
		if(Record.cellDataList[0].szData == contribution.sUserName)
		{
			return i;
		}
	}
	return -1;
}

function InputContributionToRecord(int Index, UIPacket._PkPledgeContribution contribution)
{
	local RichListCtrlRowData Record;
	local string sCurrentContribution, sTotalContribution;

	sCurrentContribution = string(contribution.nCurrentContribution);
	sTotalContribution = string(contribution.nTotalContribution);
	ClanMemberList_ListCtrl.GetRec(Index, Record);
	Record.cellDataList[3].szData = sCurrentContribution;
	Record.cellDataList[3].HiddenStringForSorting = getInstanceL2Util().makeZeroString(20, contribution.nCurrentContribution);
	Record.cellDataList[3].drawitems[0].strInfo.strData = MakeCostString(sCurrentContribution);
	Record.cellDataList[4].szData = sTotalContribution;
	Record.cellDataList[4].HiddenStringForSorting = getInstanceL2Util().makeZeroString(20, contribution.nTotalContribution);
	Record.cellDataList[4].drawitems[0].strInfo.strData = MakeCostString(sTotalContribution);
	ClanMemberList_ListCtrl.ModifyRecord(Index, Record);
}

function RichListCtrlRowData makeRecord(ClanMemberInfo _clanMemberInfo)
{
	local Color color_txt;
	local int i;
	local RichListCtrlRowData Record;
	local UIPacket._PkPledgeContribution contribution;

	Record.cellDataList.Length = 6;
	Record.nReserved1 = _clanMemberInfo.clanType;
	if ( _clanMemberInfo.sName == clanWndClassicScr.m_myName )
	{
		clanWndClassicScr.m_indexNum = i;
	}
	if ( _clanMemberInfo.sName == clanWndClassicScr.m_myName )
	{
		color_txt = getInstanceL2Util().Yellow;
	}
	else if ( _clanMemberInfo.Id > 0 )
	{
		color_txt = getInstanceL2Util().BrightWhite;
	}
	else
	{
		color_txt = getInstanceL2Util().Gray;
	}
	Record.cellDataList[0].szData = _clanMemberInfo.sName;
	Record.cellDataList[1].szData = string(_clanMemberInfo.Level);
	Record.cellDataList[2].szData = string(_clanMemberInfo.ClassID);
	// End:0x17A
	if(GetContributionByName(_clanMemberInfo.sName, contribution))
	{
		Record.cellDataList[3].szData = string(contribution.nCurrentContribution);
		Record.cellDataList[4].szData = string(contribution.nTotalContribution);
	}
	// End:0x1A6
	else
	{
		Record.cellDataList[3].szData = string(0);
		Record.cellDataList[4].szData = string(0);
	}
	Record.cellDataList[5].szData = string(_clanMemberInfo.Id);
	addRichListCtrlString(Record.cellDataList[0].drawitems, Record.cellDataList[0].szData, color_txt, false);
	addRichListCtrlString(Record.cellDataList[1].drawitems, Record.cellDataList[1].szData, color_txt, false);
	addRichListCtrlTexture(Record.cellDataList[2].drawitems, GetClassRoleIconName(_clanMemberInfo.ClassID), 11, 11);
	addRichListCtrlString(Record.cellDataList[3].drawitems, MakeCostString(Record.cellDataList[3].szData), color_txt, false);
	addRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostString(Record.cellDataList[4].szData), color_txt, false);
	addRichListCtrlButton(Record.cellDataList[5].drawitems, "btnInfo", 20, 0, "L2UI_EPIC.ClanWnd.ClanWnd_ListSetting", "L2UI_EPIC.ClanWnd.ClanWnd_ListSetting_Over", "L2UI_EPIC.ClanWnd.ClanWnd_ListSetting_Down", 16, 16, 16, 16);
	Record.cellDataList[0].HiddenStringForSorting = _clanMemberInfo.sName;
	Record.cellDataList[1].HiddenStringForSorting = string(_clanMemberInfo.Level);
	Record.cellDataList[2].HiddenStringForSorting = string(GetClassRoleType(_clanMemberInfo.ClassID));
	Record.cellDataList[3].HiddenStringForSorting = Record.cellDataList[3].szData;
	Record.cellDataList[4].HiddenStringForSorting = Record.cellDataList[4].szData;
	return Record;
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

function bool GetSelectedListCtrlItem(out RichListCtrlRowData Record)
{
	local int Index;

	Index = ClanMemberList_ListCtrl.GetSelectedIndex();
	// End:0x3B
	if(Index >= 0)
	{
		ClanMemberList_ListCtrl.GetRec(Index, Record);
		return true;
	}
	return false;
}

function bool IsSelectedLogin()
{
	local RichListCtrlRowData Record;

	// End:0x12
	if(! GetSelectedListCtrlItem(Record))
	{
		return false;
	}
	return int(Record.cellDataList[3].szData) > 0;
}

function string GetCurrentSelectedName()
{
	local RichListCtrlRowData Record;

	// End:0x13
	if(! GetSelectedListCtrlItem(Record))
	{
		return "";
	}
	return Record.cellDataList[0].szData;
}

function int GetTopIndex()
{
	return tab.GetTopIndex();
}

defaultproperties
{
}
