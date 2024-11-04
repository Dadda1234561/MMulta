class UnionWnd extends UICommonAPI;

var bool m_bChOpened;

//Handle List
var WindowHandle Me;
var WindowHandle PartyMemberWnd;

var TextBoxHandle txtOwner;
var TextBoxHandle txtRoutingType;
var TextBoxHandle txtCountInfo;
var ButtonHandle banBtn;
var ButtonHandle quitBtn;
var ListCtrlHandle lstParty;

var ButtonHandle btnadenacalculate;

var string m_UserName;
var int m_PartyNum;
var int m_PartyMemberNum;
var int m_SearchedMasterID;

function OnRegisterEvent()
{
	//RegisterEvent(EV_HandOverPartyMaster);
	//RegisterEvent(EV_RecvPartyMaster);

	RegisterEvent(EV_CommandChannelStart);
	RegisterEvent(EV_CommandChannelEnd);
	RegisterEvent(EV_CommandChannelInfo);
	RegisterEvent(EV_CommandChannelPartyList);
	RegisterEvent(EV_CommandChannelPartyUpdate);
	RegisterEvent(EV_CommandChannelRoutingType);
}

function OnLoad()
{
	Me = GetWindowHandle("UnionWnd");

	setPartyMemberWnd();
	//PartyMemberWndClassic = GetWindowHandle( "UnionDetailWndClassic" );

	txtOwner = GetTextBoxHandle("UnionWnd.txtOwner");
	txtRoutingType = GetTextBoxHandle("UnionWnd.txtRoutingType");
	txtCountInfo = GetTextBoxHandle("UnionWnd.txtCountInfo");
	lstParty = GetListCtrlHandle("UnionWnd.lstParty");

	banBtn = GetButtonHandle("UnionWnd.btnBan");
	quitBtn = GetButtonHandle("UnionWnd.btnOut");
	btnadenacalculate = GetButtonHandle("UnionWnd.btnadenacalculate");

	m_bChOpened = false;
	m_PartyNum = 0;
	m_PartyMemberNum = 0;
	m_SearchedMasterID = 0;
}

function setPartyMemberWnd()
{
	PartyMemberWnd = getUnionDetailWnd();
}

function WindowHandle getUnionDetailWnd()
{
	if(getInstanceUIData().getIsClassicServer())
		return GetWindowHandle("UnionDetailWndClassic");
	else
		return GetWindowHandle("UnionDetailWnd");
}

function OnShow()
{
	local UserInfo a_UserInfo;

	setPartyMemberWnd();
	GetPlayerInfo(a_UserInfo);
	m_UserName = a_UserInfo.Name;
	PartyMemberWnd.HideWindow();
}

function OnEnterState(name a_CurrentStateName)
{
	if(a_CurrentStateName == 'LoadingState')
	{
		HandleCommandChannelEnd();
	}

	if(m_bChOpened)
	{
		Me.ShowWindow();
	}
	else
	{
		Me.HideWindow();
	}
}

function OnEvent(int Event_ID, string param)
{
	//Debug( "UnionWnd" @ Event_ID @ param);

	if(Event_ID == EV_CommandChannelStart)
	{
		HandleCommandChannelStart();
	}
	else if(Event_ID == EV_CommandChannelEnd)
	{
		HandleCommandChannelEnd();
	}
	else if(Event_ID == EV_CommandChannelInfo)
	{
		HandleCommandChannelInfo(param);
	}
	else if(Event_ID == EV_CommandChannelPartyList)
	{
		HandleCommandChannelPartyList(param);
	}
	else if(Event_ID == EV_CommandChannelPartyUpdate)
	{
		HandleCommandChannelPartyUpdate(param);
	}
	else if(Event_ID == EV_CommandChannelRoutingType)
	{
		HandleCommandChannelRoutingType(param);
	}
}

//��Ƽ�� ����Ŭ��
function OnDBClickListCtrlRecord(string strID)
{
	if(strID == "lstParty")
		RequestPartyMember(true);
}

//�ʱ�ȭ
function Clear()
{
	MemberClear();
	txtOwner.SetText("");
	txtRoutingType.SetText(GetSystemString(1383));
	txtCountInfo.SetText("");
}

//��Ƽ��� �ʱ�ȭ
function MemberClear()
{
	lstParty.DeleteAllItem();
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnRefresh":
			OnRefreshClick();
			break;
		case "btnBan":
			OnBanClick();
			break;
		case "btnOut":
			OnOutClick();
			break;
		case "btnMemberInfo":
			OnMemberInfoClick();
			break;
		case "btnadenacalculate":
			OnAdenaDistribution();
			break;
	}
}

function OnAdenaDistribution()
{
	CallGFxFunction("AdenaDistributionWnd", "RequestDivideAdenaStart", "");
}

//[���ΰ�ħ]
function OnRefreshClick()
{
	RequestNewInfo();
}

function RequestNewInfo()
{
	class'CommandChannelAPI'.static.RequestCommandChannelInfo();
}

//[�߹�]
function OnBanClick()
{
	local int idx;
	local LVDataRecord Record;
	local string PartyMasterName;

	idx = lstParty.GetSelectedIndex();

	if(idx>-1)
	{
		lstParty.GetRec(idx, Record);
		PartyMasterName = Record.LVDataList[0].szData;

		if(Len(PartyMasterName)>0)
		{
			class'CommandChannelAPI'.static.RequestCommandChannelBanParty(PartyMasterName);
		}
	}
}

//[Ż��]
function OnOutClick()
{
	class'CommandChannelAPI'.static.RequestCommandChannelWithdraw();
}

//[��Ƽ����]
function OnMemberInfoClick()
{
	if(PartyMemberWnd.IsShowWindow())
		PartyMemberWnd.HideWindow();
	else
		RequestPartyMember(true);
}

function RequestPartyMember(bool bShowWindow)
{
	local LVDataRecord Record;
	local string PartyMasterName;
	local int MasterID;

	local UnionDetailWnd Script;
	local UnionDetailWndClassic ScriptClassic;

	Script = UnionDetailWnd(GetScript("UnionDetailWnd"));
	ScriptClassic = UnionDetailWndClassic(GetScript("UnionDetailWndClassic"));

	m_SearchedMasterID = 0;
	lstParty.GetSelectedRec(Record);
	PartyMasterName = Record.LVDataList[0].szData;
	MasterID = int(Record.nReserved1);

	if(Len(PartyMasterName) > 0 && MasterID > 0)
	{
		if(bShowWindow)
		{
			if(!PartyMemberWnd.IsShowWindow())
				PartyMemberWnd.ShowWindow();
		}

		m_SearchedMasterID = MasterID;
		Script.SetMasterInfo(PartyMasterName, MasterID);
		ScriptClassic.SetMasterInfo(PartyMasterName, MasterID);
		class'CommandChannelAPI'.static.RequestCommandChannelPartyMembersInfo(MasterID);
	}
}

//����ä�� ����
function HandleCommandChannelStart()
{
	Me.ShowWindow();
	Me.SetFocus();
	m_bChOpened = true;

	RequestNewInfo();

	if(!IsPlayerOnWorldRaidAdenServer())
	{
		class'UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnBan");
		class'UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnOut");
	}
	class'UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnadenacalculate");
}

//����ä�� ����
function HandleCommandChannelEnd()
{
	Me.HideWindow();
	Clear();
	m_bChOpened = false;
}

//����ä�� ����
function HandleCommandChannelInfo(string param)
{
	local string	OwnerName;
	local int		RoutingType;
	local int		PartyNum;
	local int		PartyMemberNum;

	MemberClear();

	ParseString(param, "OwnerName", OwnerName);
	ParseInt(param, "RoutingType", RoutingType);
	ParseInt(param, "PartyNum", PartyNum);
	ParseInt(param, "PartyMemberNum", PartyMemberNum);

	m_PartyNum = PartyNum;
	m_PartyMemberNum = PartyMemberNum;

	txtOwner.SetText(OwnerName);
	UpdateRoutingType(RoutingType);
	UpdateCountInfo();

//	Debug("HandleCommandChannelInfo" @ OwnerName );

	if(OwnerName == m_UserName)
	{
		class'UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnBan");
		class'UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnadenacalculate");
	}
	else
	{
		if(!IsPlayerOnWorldRaidAdenServer())
			class'UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnBan");
		class'UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnadenacalculate");
	}
}

//��Ƽ��� ����Ʈ
function HandleCommandChannelPartyList(string param)
{
	local LVDataRecord Record;

	local string MasterName;
	local int MasterID;
	local int PartyNum;
	local int TotalCount;

	ParseString(param, "MasterName", MasterName);
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "PartyNum", PartyNum);

	Record.LVDataList.Length = 2;
	Record.nReserved1 = MasterID;
	Record.LVDataList[0].szData = MasterName;
	Record.LVDataList[1].szData = string(PartyNum);

	lstParty.InsertRecord(Record);

	//�ֱ� �˻��� ��Ƽ��ID�� ��ġ�ϰ� ��Ƽ������â�� �������� ������
	//�߰��� ���ڵ带 ���ý�Ű��, ����� �������ش�.
	if(m_SearchedMasterID > 0 && m_SearchedMasterID == MasterID)
	{
		if(PartyMemberWnd.IsShowWindow())
		{
			TotalCount = lstParty.GetRecordCount();

			if(TotalCount > 0)
				lstParty.SetSelectedIndex(TotalCount - 1, false);
			RequestPartyMember(false);
		}
	}

	if(MasterName == m_UserName)
		class'UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnOut");
}

//��Ƽ���� ����
function HandleCommandChannelPartyUpdate(string param)
{
	local LVDataRecord Record;
	local int SearchIdx;

	local string MasterName;
	local int MasterID;
	local int MemberCount;
	local int Type;

	local UnionDetailWnd Script;
	local UnionDetailWndClassic ScriptClassic;

	ParseString(param, "MasterName", MasterName);
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "MemberCount", MemberCount);
	ParseInt(param, "Type", Type);

	if(MasterID < 1)
		return;

	switch(Type)
	{
		case 0:	//leave
			SearchIdx = FindMasterID(MasterID);

			if(SearchIdx > -1)
			{
				lstParty.GetRec(SearchIdx, Record);
				MemberCount = int(Record.LVDataList[1].szData);

				lstParty.DeleteRecord(SearchIdx);

				m_PartyNum--;
				m_PartyMemberNum = m_PartyMemberNum - MemberCount;

				if(PartyMemberWnd.IsShowWindow())
				{
					Script = UnionDetailWnd(GetScript("UnionDetailWnd"));
					ScriptClassic = UnionDetailWndClassic(GetScript("UnionDetailWndClassic"));

					if(MasterID == Script.GetMasterID())
					{
						Script.Clear();
						ScriptClassic.Clear();
						PartyMemberWnd.HideWindow();
					}
				}
			}
			break;
		case 1: //join
			Record.LVDataList.Length = 2;
			Record.nReserved1 = MasterID;
			Record.LVDataList[0].szData = MasterName;
			Record.LVDataList[1].szData = string(MemberCount);

			lstParty.InsertRecord(Record);
			m_PartyNum++;
			m_PartyMemberNum = m_PartyMemberNum + MemberCount;
			break;
	}

	UpdateCountInfo();

	if(MasterName == m_UserName)
		class'UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnOut");
}

function HandleCommandChannelRoutingType(string param)
{
	local int RoutingType;

	ParseInt(param, "RoutingType", RoutingType);
	UpdateRoutingType(RoutingType);
}

//����Ÿ�� ����
function UpdateRoutingType(int Type)
{
	if(Type == 0)
	{
		txtRoutingType.SetText(GetSystemString(1383));
	}
	else if(Type == 1)
	{
		txtRoutingType.SetText(GetSystemString(1384));
	}
}

function int FindMasterID(int MasterID)
{
	local int idx;
	local LVDataRecord Record;
	local int SearchIdx;

	SearchIdx = -1;

	for(idx=0; idx < lstParty.GetRecordCount(); idx++)
	{
		lstParty.GetRec(idx, Record);

		if(int(Record.nReserved1) == MasterID)
		{
			SearchIdx = idx;
			break;
		}
	}

	return SearchIdx;
}

//��Ƽ�ο� ����
function UpdateCountInfo()
{
	txtCountInfo.SetText(string(m_PartyNum) $ GetSystemString(440) $ " / " $ m_PartyMemberNum $ GetSystemString(1013));
}

//��Ƽ�� �� ����
function UpdatePartyMemberCount(int MasterID, int MemberCount)
{
	local int idx;
	local LVDataRecord Record;

	idx = FindMasterID(MasterID);

	if(idx > -1)
	{
		lstParty.GetRec(idx, Record);
		m_PartyMemberNum = m_PartyMemberNum - int(Record.LVDataList[1].szData);
		m_PartyMemberNum = m_PartyMemberNum + MemberCount;
		Record.LVDataList[1].szData = string(MemberCount);
		lstParty.ModifyRecord(idx, Record);
	}
	UpdateCountInfo();
}

function bool IsPlayerOnWorldRaidAdenServer()
{
	return IsPlayerOnWorldRaidServer() && IsAdenServer();
}

defaultproperties
{
}
