class ClanSubMenuManageContainer extends UIData;

const DIALOG_TARGET_PATH = "Transient.ClanWndClassicNew";

enum TYPE_SUBMENU_STATE {
	non,
	ClanMemberInfoState,
	ClanMemberAuthState,
	ClanAuthManageWndState,
	ClanEmblemManageWndState,
	ClanAuthEditWndState
};

const NUMOFOPTIONS_CASTLE= 8;
const NUMOFOPTIONS_AGIT= 5;
const NUMOFOPTIONS_SYSTEM= 10;
const ACADEMY_INDEX=7;
const DISABLE_ALPHA=100;
const changelineval1= 23;
const c_maxranklimit= 100;
const DIALOG_AskClanEnemyCancel= 487;

var string m_WindowName;
var WindowHandle Me;
var ClanWndClassicNew clanWndClassicScript;
var int m_clanType;
var int m_currentEditGradeID;
var string m_currentName;
var string m_myName;
var int m_currentMaster;
var string m_WindowName_ClanMemberInfoWnd;
var string m_WindowName_ClanMemberAuthWnd;
var string m_WindowName_ClanAuthManageWnd;
var string m_WindowName_ClanAuthEditWnd;
var string m_WindowName_ClanEmblemManageWnd;
var ListCtrlHandle m_hClanDrawerWndClan8_DeclaredListCtrl;
var ListCtrlHandle m_hClanDrawerWndClan5_AuthListCtrl;
var FileRegisterWnd fileRegisterWndHandle;
var TYPE_SUBMENU_STATE CurrentState;
var UIControlTilelist scrollTesterV;
var private bool isInitScrollPanel;

function InitDefaultSetting()
{
	m_WindowName = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_WindowName);
	m_WindowName = class'L2Util'.static.GetFullPath(Me);
	clanWndClassicScript = ClanWndClassicNew(GetScript("ClanWndClassicNew"));
	clanWndClassicScript.clanSubMenuManageContainerScr = self;
}

private function InitScrollPanel()
{
	// End:0x0B
	if(isInitScrollPanel)
	{
		return;
	}
	scrollTesterV = class'UIControlTilelist'.static.InitScript(GetWindowHandle(m_WindowName_ClanEmblemManageWnd $ ".ScrollAreaWndV"), 5, 6, true);
	scrollTesterV.DelegateOnItemRenderer = HandleDelegateOnItemRenderer;
	scrollTesterV.DelegateOnRendererClick = HandleDelegateOnRenderClickV;
	scrollTesterV._SetUseSelect(true);
	scrollTesterV._SetUseOver(true);
	scrollTesterV._SetTileListItemNumTotal(30);
	scrollTesterV._Refresh();
	isInitScrollPanel = true;	
}

function InitHandle()
{
	m_WindowName_ClanMemberInfoWnd = m_WindowName $ ".ClanMemberInfoWnd";
	m_WindowName_ClanMemberAuthWnd = m_WindowName $ ".ClanMemberAuthWnd";
	m_WindowName_ClanAuthManageWnd = m_WindowName $ ".ClanAuthManageWnd";
	m_WindowName_ClanAuthEditWnd = m_WindowName $ ".ClanAuthEditWnd";
	m_WindowName_ClanEmblemManageWnd = m_WindowName $ ".ClanEmblemManageWnd";
	fileRegisterWndHandle = FileRegisterWnd(GetScript("FileRegisterWnd"));
	m_hClanDrawerWndClan5_AuthListCtrl = GetListCtrlHandle(m_WindowName_ClanAuthManageWnd $ ".Clan5_AuthListCtrl");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check105");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check108");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check109");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check110");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check302");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check307");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check105");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check108");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check109");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check110");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check302");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check307");
}

event OnRegisterEvent()
{
	RegisterEvent(EV_ClanAuthGradeList);
	RegisterEvent(EV_ClanCrestChange);
	RegisterEvent(EV_ClanAuth);
	RegisterEvent(EV_ClanAuthMember);
	RegisterEvent(EV_ClanMemberInfo);
	RegisterEvent(EV_GamingStateExit);
}

event OnLoad()
{
	InitDefaultSetting();
	InitHandle();
	InitializeGradeComboBox();
	InitClanEmbleManageWndState();
	InitScrollPanel();
	HideAll();
}

private function Clear()
{
	CurrentState = TYPE_SUBMENU_STATE.non;
	m_clanType = -1;
	m_currentEditGradeID = -1;
	m_currentName = "";
}

event OnHide()
{
	// End:0x22
	if(DialogIsMineCheck())
	{
		class'DialogBox'.static.Inst().HideDialog();
	}
	FileRegisterWndHide();
	Clear();
}

event OnShow()
{
	class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
	class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
	class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
	// End:0x176
	if(clanWndClassicScript.m_bClanMaster == 0)
	{
		// End:0xED
		if(clanWndClassicScript.m_bNickName == 0)
		{
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
		}
		// End:0x134
		if(clanWndClassicScript.m_bGrade == 0)
		{
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
		}
		// End:0x176
		if(clanWndClassicScript.m_bOustMember == 0)
		{
			class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
		}
	}
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		// End:0x27
		case "Clan5_AuthListCtrl":
			EditAuthGrade();
			break;
	}
}

event OnClickButton(string strID)
{
	if(strID == "ClanMemAuthBtn")
	{
		if(ToggleWindowByType(TYPE_SUBMENU_STATE.ClanMemberAuthState))
		{
			SetState(TYPE_SUBMENU_STATE.ClanMemberAuthState);
		}
	}
	else if(strID == "Clan1_ChangeMemberNameBtn")
	{
		Class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd");
		Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd");
		Class'UIAPI_EDITBOX'.static.SetString(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd.Clan1_ChangeNameTextEditbox","");
	}
	else if(strID == "Clan1_ChangeMemberGradeBtn")
	{
		Class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd");
		Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd");
	}
	else if(strID == "Clan1_ChangeBanishBtn")
	{
		Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd");
		Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd");
		RequestClanExpelMember(m_clanType,Class'UIAPI_TEXTBOX'.static.GetText(m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName"));
	}
	else if(strID == "Clan1_ChangeNameAssignBtn")
	{
		RequestClanChangeNickName(Class'UIAPI_TEXTBOX'.static.GetText(m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName"),Class'UIAPI_EDITBOX'.static.GetString(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd.Clan1_ChangeNameTextEditbox"));
		Class'UIAPI_EDITBOX'.static.SetString(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd.Clan1_ChangeNameTextEditbox","");
		Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd");
		RecallCurrentMemberInfo();
	}
	else if(strID == "Clan1_ChangeNameDeleteBtn")
	{
		RequestClanChangeNickName(Class'UIAPI_TEXTBOX'.static.GetText(m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName"),"");
		Class'UIAPI_EDITBOX'.static.SetString(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd.Clan1_ChangeNameTextEditbox","");
		Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd");
		RecallCurrentMemberInfo();
	}
	else if(strID == "Clan1_ChangeMemberGradeAssignBtn")
	{
		if(Class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd.Clan1_MemberGradeList")< 5)
		{
			RequestClanChangeGrade(Class'UIAPI_TEXTBOX'.static.GetText(m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName"),Class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd.Clan1_MemberGradeList")+ 1);
		} else {
			RequestClanChangeGrade(Class'UIAPI_TEXTBOX'.static.GetText(m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName"),getCurrentGradebyClanType());
		}
		Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd");
		RecallCurrentMemberInfo();
	}
	else if(strID == "Clan1_Cancel1")
	{
		Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd");
	}
	else if(strID == "Clan1_Cancel2")
	{
		Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd");
	}
	else if(strID == "Clan7_RegEmbBtn")
	{
		HandleBtnClickClan7_RegEmbBtn();
	}
	else if(strID == "Clan7_RmEmbBtn")
	{
		API_RequestClanUnregisterCrestByPledgeID();
		scrollTesterV._SetSelect(-1);
		// End:0x74F
		if(DialogIsMineCheck())
		{
			class'DialogBox'.static.Inst().HideDialog();
		}
		FileRegisterWndHide();
	}
	else if(strID == "Clan1_OKBtn")
	{
		HideClanWindow();
	}
	else if(strID == "Clan2_OKBtn")
	{
		SetState(TYPE_SUBMENU_STATE.ClanMemberInfoState);
	}
	else if(strID == "Clan3_OKBtn")
	{
		HideClanWindow();
	}
	else if(strID == "Clan4_OKBtn")
	{
		HideClanWindow();
	}
	else if(strID == "Clan5_OKBtn")
	{
		HideClanWindow();
	}
	else if(strID == "Clan7_OKBtn")
	{
		HideClanWindow();
	}
	else if(strID == "ClanEnemy_OKBtn")
	{
		HideClanWindow();
	}
	else if(strID == "Clan5_ManageBtn")
	{
		EditAuthGrade();
	}
	else if(strID == "Clan6_ApplyBtn")
	{
		ApplyEditGrade();
		SetState(TYPE_SUBMENU_STATE.ClanAuthManageWndState);
	}
	else if(strID == "Clan6_CancelBtn")
	{
		SetState(TYPE_SUBMENU_STATE.ClanAuthManageWndState);
	}
	else if(strID == "Clan1_NobCancel1")
	{
		HideClanWindow();
	}
	else if(strID == "Clan1_ChangeNameDeleteNobBtn")
	{
		RequestClanChangeNickName(clanWndClassicScript.m_myName,"");
	}
	else if(strID == "ClanQuitBtn")
	{
		RequestClanLeave(clanWndClassicScript.m_clanName,clanWndClassicScript.m_myClanType);
	}
}

event OnClickCheckBox(string CheckBoxID)
{
	HandleOnClickCheckBoxClanAuthEditWnd(CheckBoxID);
}

event OnEvent(int a_EventID, string a_Param)
{
	if(getInstanceL2Util().isClanV2())
	{
		return;
	}
	switch(a_EventID)
	{
		case EV_ClanAuthGradeList:
			HandleClanAuthGradeList(a_Param);
			break;
		case EV_ClanCrestChange:
			HandleCrestChange(a_Param);
		case EV_ClanMemberInfo:
			HandleClanMemberInfo(a_Param);
			break;
		case EV_ClanAuth:
			HandleClanAuth(a_Param);
			break;
		case EV_ClanAuthMember:
			HandleClanAuthMember(a_Param);
			break;
		case EV_GamingStateExit:
			Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName);
			break;
		default:
			break;
	}
}

function SetState(TYPE_SUBMENU_STATE Type)
{
	HideAll();
	Debug("SetState" @ string(Type));
	switch(Type)
	{
		case ClanMemberInfoState:
			SetState_ClanMemberInfoState();
			break;
		case ClanMemberAuthState:
			SetState_ClanMemberAuthState();
			break;
		case ClanAuthManageWndState:
			SetState_ClanAuthManageWndState();
			break;
		case ClanEmblemManageWndState:
			SetState_ClanEmblemManageWndState();
			break;
		case ClanAuthEditWndState:
			SetState_ClanAuthEditWndState();
			break;
		case non:
			Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName);
			break;
	}
	CurrentState = Type;
	if(CurrentState != TYPE_SUBMENU_STATE.non)
	{
		Class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName);
	}
	Me.SetFocus();
}

function SetState_ClanMemberInfoState()
{
	Debug("SetState_ClanMemberInfoState");
	clanWndClassicScript.clanSubInfoContainerScr.RequestCurrentSelectedClanMemberInfo();
	Class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanMemberInfoWnd");
	Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameWnd");
	Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd");
}

function SetState_ClanMemberAuthState()
{
	local int i;

	clanWndClassicScript.clanSubInfoContainerScr.RequestCurrentSelectedClanMemberAuth();
	class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName_ClanMemberAuthWnd);

	// End:0x7C [Loop If]
	for(i = 0;i <= 10;++i)
	{
		class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check1" $ Int2Str2(i), true);
	}
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check1" $ Int2Str2(24), true);

	for(i = 0;i <= 5;++i)
	{
		Class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check20" $ string(i), true);
	}

	for(i = 0;i <= 8;++i)
	{
		Class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check30" $ string(i), true);
	}
}

function SetState_ClanAuthManageWndState()
{
	Class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName_ClanAuthManageWnd);
}

function SetState_ClanEmblemManageWndState()
{
	class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName_ClanEmblemManageWnd);
	InitScrollPanel();
	scrollTesterV._SetSelect(-1);
}

function SetState_ClanAuthEditWndState()
{
	Class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName_ClanAuthEditWnd);
}

function InitClanEmbleManageWndState()
{
	local string string1;
	local string string2;

	string1 = Left(GetSystemMessage(211),23);
	string2 = Right(GetSystemMessage(211),Len(GetSystemMessage(211))- 23);
	Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName_ClanEmblemManageWnd $ ".Clan7_ManageEmb1Text1",string1);
	Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName_ClanEmblemManageWnd $ ".Clan7_ManageEmb1Text2",string2);
}

function HandleCrestChange(string param)
{
	if(CurrentState == TYPE_SUBMENU_STATE.ClanEmblemManageWndState)
	{
		Class'UIAPI_TEXTURECTRL'.static.SetTextureWithClanCrest(m_WindowName $ ".ClanCrestTextureCtrl",clanWndClassicScript.m_clanID);
	}
}

private function HandleBtnClickClan7_RegEmbBtn()
{
	local array<string> fileextarr;

	// End:0x98
	if(class'UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false)
	{
		fileextarr.Length = 1;
		fileextarr[0] = "bmp";
		ClearFileRegisterWndFileExt();
		AddFileRegisterWndFileExt(GetSystemString(2811), fileextarr);
		FileRegisterWndShow(_FileHandler.FH_PLEDGE_CREST_UPLOAD/*1*/);
		// End:0x81
		if(DialogIsMineCheck())
		{
			class'DialogBox'.static.Inst().HideDialog();
		}
		scrollTesterV._SetSelect(-1);		
	}
	else
	{
		FileRegisterWndHide();
	}	
}

private function int GetSelectedPresetEmblemID()
{
	local array<PledgeCrestPresetUIData> presetDatas;
	local int Id;

	API_GetPledgeCrestPresetData(presetDatas);
	Id = presetDatas[scrollTesterV._GetSelectedIndex()].Id;
	if(Id == 0)
	{
		return (2000000 + scrollTesterV._GetSelectedIndex()) + 1;
	}
	return presetDatas[scrollTesterV._GetSelectedIndex()].Id;	
}

private function string GetCrestTexName(int itemIndex)
{
	local array<PledgeCrestPresetUIData> presetDatas;
	local string TexName;

	API_GetPledgeCrestPresetData(presetDatas);
	if(itemIndex < presetDatas.Length)
	{
		TexName = presetDatas[itemIndex].CrestTexName;
	}
	if(TexName == "")
	{
		TexName = "L2UI_EPIC.ClanWnd.Preset" $ string(itemIndex + 1);
	}
	return TexName;	
}

private function HandleDelegateOnItemRenderer(string itemRendererID, int rendererIndex, int itemIndex)
{
	if(itemIndex >= scrollTesterV._GetItemNumTotal())
	{
		GetTextureHandle(itemRendererID $ ".emblem").HideWindow();		
	}
	else
	{
		GetTextureHandle(itemRendererID $ ".emblem").ShowWindow();
		GetTextureHandle(itemRendererID $ ".emblem").SetTexture(GetCrestTexName(itemIndex));
		GetTextureHandle(itemRendererID $ ".emblem").SetUV(0, 4);
	}	
}

private function HandleDelegateOnRenderClickV(string BTNID, int rendererIndex, int itemIndex)
{
	FileRegisterWndHide();
	DialogSetID(77668899);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13802), DIALOG_TARGET_PATH, 294);
	class'DialogBox'.static.Inst().AnchorToOwner(-320, -4);
	class'DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	class'DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
	class'DialogBox'.static.Inst().DelegateOnHide = HandleDialogHide;
	class'DialogBox'.static.Inst().SetReservedInt(GetSelectedPresetEmblemID());	
}

private function HandleDialogHide()
{
	scrollTesterV._SetSelect(-1);	
}

private function HandleDialogOK()
{
	API_RequestClanRegisterCrestPreset(class'DialogBox'.static.Inst().GetReservedInt());	
}

function HandleClanAuthGradeList(string a_Param)
{
	local int Count;
	local int Id;
	local int members;
	local int i;
	local LVDataRecord Record;
	local LVData Data;

	Record.LVDataList.Length = 2;
	m_hClanDrawerWndClan5_AuthListCtrl.DeleteAllItem();
	ParseInt(a_Param,"Count",Count);
	
	for(i = 0;i < 5;++i)
	{
		ParseInt(a_Param,"GradeID" $ string(i),Id);
		ParseInt(a_Param,"GradeMemberCount" $ string(i),members);
		Data.szData = GetStringByGradeID(Id);
		Record.LVDataList[0] = Data;
		Data.szData = string(members);
		Record.LVDataList[1] = Data;
		Record.nReserved1 = Id;
		m_hClanDrawerWndClan5_AuthListCtrl.InsertRecord(Record);
	}
	m_hClanDrawerWndClan5_AuthListCtrl.SetSelectedIndex(0,True);
}

function HandleOnClickCheckBoxClanAuthEditWnd(string CheckBoxID)
{
	local bool checkState;
	local int i;
	local string CheckboxName;
	local string CheckboxNum;
	local string checkBoxGroupNum;
	local int totalNum;

	CheckboxName = Left(CheckBoxID,12);
	CheckboxNum = Right(CheckBoxID,2);
	checkBoxGroupNum = Right(CheckboxName,1);
	switch(checkBoxGroupNum)
	{
		case "1":
			totalNum = 10;
			break;
		case "2":
			totalNum = 5;
			break;
		case "3":
			totalNum = 8;
			break;
	}
	if(CheckboxNum == "00")
	{
		checkState = Class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName_ClanAuthEditWnd $ "." $ CheckBoxID);
		
		for(i = 0;i <= totalNum;++i)
		{
			Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ "." $ CheckboxName $ Int2Str2(i),checkState);
		}
		// End:0x12E
		if(checkBoxGroupNum == "1")
		{
			class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ "." $ CheckboxName $ Int2Str2(24), checkState);
		}
	}
	else
	{
		Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ "." $ CheckboxName $ "00",count_all_check(checkBoxGroupNum,totalNum,6));
	}
}

function HandleClanAuth(string a_Param)
{
	local int gradeID;
	local int Command;
	local array<int> powers;
	local int i;
	local int Index;

	ParseInt(a_Param,"GradeID",gradeID);
	ParseInt(a_Param,"Command",Command);
	powers.Length = 32;
	
	for(i = 0;i < 32;++i)
	{
		ParseInt(a_Param,"PowerValue" $ string(i),powers[i]);
	}
	Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName_ClanAuthEditWnd $ ".Clan6_CurrentSelectedRankName",GetStringByGradeID(gradeID)$ GetSystemString(1376));
	Index = 1;
	
	for(i = 1;i <= 10;++i)
	{
		Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check1" $ Int2Str2(i),bool(powers[Index++ ]));
	}
	class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check1" $ Int2Str2(24), bool(powers[24]));

	for(i = 1;i <= 5;++i)
	{
		Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check20" $ string(i),bool(powers[Index++ ]));
	}

	for(i = 1;i <= 8;++i)
	{
		Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check30" $ string(i),bool(powers[Index++ ]));
	}
	Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check100",count_all_check("1",10,6));
	Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check200",count_all_check("2",5,6));
	Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check300",count_all_check("3",8,6));
	if(gradeID == 9)
	{
		disableAcademyAuth();
	} else {
		resetAcademyAuth();
	}
}

function disableAcademyAuth()
{
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check100", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check101", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check102", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check106", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check104", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check105", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check107", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check124", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check200", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check203", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check204", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check205", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check300", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check303", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check305", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check306", true);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check308", true);
}

function resetAcademyAuth()
{
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check100", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check101", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check102", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check106", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check104", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check105", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check107", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check124", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check200", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check203", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check204", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check205", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check300", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check303", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check305", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check306", false);
	class'UIAPI_CHECKBOX'.static.SetDisable(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check308", false);
}

function RecallCurrentMemberInfo()
{
	SetState(TYPE_SUBMENU_STATE.ClanMemberInfoState);
}

function HandleClanMemberInfo(string a_Param)
{
	local string nickname;
	local int gradeID, nNickColor;
	local CustomTooltip cTooltip;

	ParseInt(a_Param, "ClanType", m_clanType);
	ParseString(a_Param, "Name", m_currentName);
	ParseString(a_Param, "NickName", nickname);
	ParseInt(a_Param, "GradeID", gradeID);
	ParseInt(a_Param, "NickColor", nNickColor);
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberName", m_currentName);
	GetTextBoxHandle(m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberSName").SetFormatString(nickname);
	GetTextBoxHandle(m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberSName").SetTextColor(getInstanceL2Util().IntToColor(nNickColor));
	addToolTipDrawList(cTooltip, addDrawItemFormatText(nickname, getInstanceL2Util().IntToColor(nNickColor), ""));
	GetTextBoxHandle(m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberSName").SetTooltipCustomType(cTooltip);
	class'UIAPI_TEXTBOX'.static.SetText(m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberGrade", GetStringByGradeID(gradeID));
	// End:0x269
	if(clanWndClassicScript.m_CurrentclanMasterReal == m_currentName)
	{
		// End:0x269
		if(clanWndClassicScript.m_currentShowIndex == 0)
		{
			class'UIAPI_TEXTBOX'.static.SetText(m_WindowName_ClanMemberInfoWnd $ ".Clan1_CurrentSelectedMemberGrade", GetSystemString(342));
		}
	}
	clanWndClassicScript.resetBtnShowHide();
	CheckandCompareMyNameandDisableThings();
}

function CheckandCompareMyNameandDisableThings()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	m_myName = UserInfo.Name;
	if(clanWndClassicScript.m_bClanMaster > 0)
	{
		Class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
	}
	else
	{
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
		Proc_AuthValidation();
		if(clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)< clanWndClassicScript.m_myClanType)
		{
			Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
			Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
			if(m_clanType == -1)
			{
				return;
			}
			Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
		}
		if(clanWndClassicScript.m_myClanType > 1)
		{
			if(clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)!= 0)
			{
				if(clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)== 1)
				{
					Proc_AuthValidation();
				}
				if(clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)== 1000)
				{
					Proc_AuthValidation();
				}
				if(clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)== 100)
				{
					Proc_AuthValidation();
				}
				if(clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)== 999)
				{
					Proc_AuthValidation();
				}
				if(clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)== 1001)
				{
					Proc_AuthValidation();
				}
			}
		}
		if(clanWndClassicScript.m_CurrentclanMasterReal == m_currentName)
		{
			Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
			Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
			Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
		}
	}
	if(m_currentName == m_myName)
	{
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
	}
	if(m_clanType == -1)
	{
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
	}
}

function Proc_AuthValidation()
{
	if(clanWndClassicScript.m_bNickName == 0)
	{
		if((clanWndClassicScript.G_IamHero == True)||(clanWndClassicScript.G_IamNobless > 0))
		{
			Class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
		} else {
			Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
		}
	} else {
		Class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberNameBtn");
	}
	if(clanWndClassicScript.m_bGrade == 0)
	{
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
	} else {
		Class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeBtn");
	}
	if(clanWndClassicScript.m_bOustMember == 0)
	{
		Class'UIAPI_WINDOW'.static.DisableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
	} else {
		Class'UIAPI_WINDOW'.static.EnableWindow(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeBanishBtn");
	}
}

function InitializeGradeComboBox()
{
	local int i;

	Class'UIAPI_COMBOBOX'.static.Clear(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd.Clan1_MemberGradeList");
	
	for(i = 1;i < 6;++i)
	{
		Class'UIAPI_COMBOBOX'.static.AddString(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd.Clan1_MemberGradeList",GetStringByGradeID(i));
	}
	Class'UIAPI_COMBOBOX'.static.AddString(m_WindowName_ClanMemberInfoWnd $ ".Clan1_ChangeMemberGradeNameWnd.Clan1_MemberGradeList",GetSystemString(1451));
}

function HandleClanAuthMember(string a_Param)
{
	local int gradeID;
	local string sName;
	local array<int> powers;
	local int i;
	local int Index;

	ParseInt(a_Param,"Grade",gradeID);
	ParseString(a_Param,"Name",sName);
	if(clanWndClassicScript.m_CurrentclanMasterReal == sName)
	{
		Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName_ClanMemberAuthWnd $ ".Clan2_CurrentSelectedMemberName",sName @ "-" @ GetSystemString(342));

		for(i = 0;i <= 10;++i)
		{
			Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check1" $ Int2Str2(i),True);
		}
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ ".Clan2_Check1" $ Int2Str2(24), true);

		for(i = 0;i <= 5;++i)
		{
			Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check20" $ string(i),True);
		}

		for(i = 0;i <= 8;++i)
		{
			Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check30" $ string(i),True);
		}
	}
	else
	{
		powers.Length = 32;

		for(i = 0;i < 32;++i)
		{
			ParseInt(a_Param,"PowerValue" $ string(i),powers[i]);
		}
		Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName_ClanMemberAuthWnd $ ".Clan2_CurrentSelectedMemberName",sName @ "-" @ GetStringByGradeID(gradeID));
		Index = 1;
		
		for(i = 1;i <= 10;++i)
		{
			Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check1" $ Int2Str2(i),bool(powers[Index++ ]));
		}
		class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanAuthEditWnd $ ".Clan2_Check1" $ Int2Str2(24), bool(powers[24]));


		for(i = 1;i <= 5;++i)
		{
			Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check20" $ string(i),bool(powers[Index++ ]));
		}

		for(i = 1;i <= 8;++i)
		{
			Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check30" $ string(i),bool(powers[Index++ ]));
		}
	}
	Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check100",count_all_check("1",10,2));
	Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check200",count_all_check("2",5,2));
	Class'UIAPI_CHECKBOX'.static.SetCheck(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check300",count_all_check("3",8,2));
	if(clanWndClassicScript.m_myName == sName)
	{
		if(Class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check101")== True)
		{
			clanWndClassicScript.m_bJoin = 1;
		} else {
			clanWndClassicScript.m_bJoin = 0;
		}
		if(Class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName_ClanMemberAuthWnd $ ".Clan2_Check107")== True)
		{
			clanWndClassicScript.m_bCrest = 1;
		} else {
			clanWndClassicScript.m_bCrest = 0;
		}
		clanWndClassicScript.resetBtnShowHide();
	}
}

function ApplyEditGrade()
{
	local array<int> powers;
	local int i;
	local int Index;

	powers.Length = 32;
	powers[0] = 0;
	Index = 1;

	for(i = 1;i <= 10;++i)
	{
		if(Class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName_ClanMemberAuthWnd $ ".Clan6_Check1" $ Int2Str2(i)))
		{
			powers[Index] = 1;
		}
		++Index;
	}

	// End:0xBB
	if(class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName_ClanAuthEditWnd $ ".Clan6_Check1" $ Int2Str2(24)))
	{
		powers[24] = 1;
	}

	for(i = 1;i <= 5;++i)
	{
		if(Class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName_ClanMemberAuthWnd $ ".Clan6_Check20" $ string(i)))
		{
			powers[Index] = 1;
		}
		++Index;
	}

	for(i = 1;i <= 8;++i)
	{
		if(Class'UIAPI_CHECKBOX'.static.IsChecked(m_WindowName_ClanMemberAuthWnd $ ".Clan6_Check30" $ string(i)))
		{
			powers[Index] = 1;
		}
		++Index;
	}
	RequestEditClanAuth(m_currentEditGradeID,powers);
}

function EditAuthGrade()
{
	local int Index;
	local LVDataRecord Record;

	Index = m_hClanDrawerWndClan5_AuthListCtrl.GetSelectedIndex();
	if(Index >= 0)
	{
		m_hClanDrawerWndClan5_AuthListCtrl.GetRec(Index,Record);
		RequestClanAuth(int(Record.nReserved1));
		m_currentEditGradeID = int(Record.nReserved1);
		SetState(TYPE_SUBMENU_STATE.ClanAuthEditWndState);
	}
	else
		SetState(TYPE_SUBMENU_STATE.ClanAuthManageWndState);
}

function string GetEllipsisString(string Str, int MaxWidth)
{
	local string fixedString;
	local int nWidth;
	local int nHeight;
	local int textWidth;

	textWidth = MaxWidth;
	GetTextSizeDefault(Str $ "...",nWidth,nHeight);
	if(nWidth < textWidth)
	{
		return Str;
	}
	fixedString = DivideStringWithWidth(Str,textWidth);
	if(fixedString != Str)
	{
		fixedString = fixedString $ "...";
	}
	return fixedString;
}

function int getCurrentGradebyClanType()
{
	local int GradeNum;

	switch(m_clanType)
	{
		case CLAN_MAIN:
			GradeNum = 6;
			break;
		case CLAN_KNIGHT1:
			GradeNum = 7;
			break;
		case CLAN_KNIGHT2:
			GradeNum = 7;
			break;
		case CLAN_KNIGHT3:
			GradeNum = 8;
			break;
		case CLAN_KNIGHT4:
			GradeNum = 8;
			break;
		case CLAN_KNIGHT5:
			GradeNum = 8;
			break;
		case CLAN_KNIGHT6:
			GradeNum = 8;
			break;
		case CLAN_ACADEMY:
			GradeNum = 9;
			break;
	}
	return GradeNum;
}

function int GetClanTypeFromIndex(int Index)
{
	local int Type;

	if(Index == 0)
	{
		Type = CLAN_MAIN;
	}
	else if(Index == 1)
	{
		Type = CLAN_KNIGHT1;
	}
	else if(Index == 2)
	{
		Type = CLAN_KNIGHT2;
	}
	else if(Index == 3)
	{
		Type = CLAN_KNIGHT3;
	}
	else if(Index == 4)
	{
		Type = CLAN_KNIGHT4;
	}
	else if(Index == 5)
	{
		Type = CLAN_KNIGHT5;
	}
	else if(Index == 6)
	{
		Type = CLAN_KNIGHT6;
	}
	else if(Index == 7)
	{
		Type = CLAN_ACADEMY;
	}
	return Type;
}

function string GetStringByGradeID(int gradeID)
{
	local int stringIndex;

	stringIndex = -1;
	if(gradeID == 1)
	{
		stringIndex = 1406;
	}
	else if(gradeID == 2)
	{
		stringIndex = 1407;
	}
	else if(gradeID == 3)
	{
		stringIndex = 1408;
	}
	else if(gradeID == 4)
	{
		stringIndex = 1409;
	}
	else if(gradeID == 5)
	{
		stringIndex = 1410;
	}
	else if(gradeID == 6)
	{
		stringIndex = 1411;
	}
	else if(gradeID == 7)
	{
		stringIndex = 1412;
	}
	else if(gradeID == 8)
	{
		stringIndex = 1413;
	}
	else if(gradeID == 9)
	{
		stringIndex = 1414;
	}

	if(stringIndex != -1)
	{
		return GetSystemString(stringIndex);
	}
	else
	{
		return "";
	}
}

function bool count_all_check(string numString, int totalNum, int contentID)
{
	local int i;
	local string WindowName;
	local string CheckBoxPath;

	switch(contentID)
	{
		case 2:
			WindowName = m_WindowName_ClanMemberAuthWnd;
			break;
		case 6:
			WindowName = m_WindowName_ClanAuthEditWnd;
			break;
	}

	for(i = 1;i <= totalNum;++i)
	{
		CheckBoxPath = WindowName $ ".Clan" $ string(contentID)$ "_Check" $ numString $ Int2Str2(i);
		if(!GetWindowHandle(CheckBoxPath).IsShowWindow())
		{
			continue;
		}
		if(Class'UIAPI_CHECKBOX'.static.IsChecked(CheckBoxPath))
		{
			return True;
		}
	}
	// End:0x11F
	if(numString == "1")
	{
		CheckBoxPath = WindowName $ ".Clan" $ string(contentID) $ "_Check" $ numString $ Int2Str2(24);
		// End:0x11F
		if(class'UIAPI_CHECKBOX'.static.IsChecked(CheckBoxPath))
		{
			return true;
		}
	}
	return False;
}

function HideClanWindow()
{
	SetState(TYPE_SUBMENU_STATE.non);
}

function HideAll()
{
	Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberAuthWnd);
	Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanMemberInfoWnd);
	Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanAuthManageWnd);
	Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanAuthEditWnd);
	Class'UIAPI_WINDOW'.static.HideWindow(m_WindowName_ClanEmblemManageWnd);
}

function string Int2Str2(int i)
{
	if(i < 10)
	{
		return "0" $ string(i);
	}
	return string(i);
}

function bool ToggleWindowByType(TYPE_SUBMENU_STATE Type)
{
	local bool isWindowShow;

	if(!ChkDrawerState(Type))
	{
		SetState(Type);
		isWindowShow = True;
	} else {
		SetState(TYPE_SUBMENU_STATE.non);
		isWindowShow = False;
	}
	return isWindowShow;
}

function bool ChkDrawerState(TYPE_SUBMENU_STATE Type)
{
	return CurrentState == Type;
}

private function API_GetPledgeCrestPresetData(out array<PledgeCrestPresetUIData> o_arrData)
{
	GetPledgeCrestPresetData(o_arrData);	
}

private function API_RequestClanRegisterCrestPreset(int presetID)
{
	RequestClanRegisterCrestPreset(presetID);	
}

private function API_RequestClanUnregisterCrestByPledgeID()
{
	RequestClanUnregisterCrestByPledgeID(clanWndClassicScript.m_clanID);	
}

private function bool DialogIsMineCheck()
{
	// End:0x0B
	if(DialogIsMine())
	{
		return true;
	}
	return class'DialogBox'.static.Inst().GetTarget() == DIALOG_TARGET_PATH;	
}

defaultproperties
{
}
