//================================================================================
// UnionDetailWnd.
// emu-dev.ru
//================================================================================

class UnionDetailWnd extends UICommonAPI
	dependson(UnionWnd);

var int m_MasterID;

//Handle List
var WindowHandle	Me;
var TextBoxHandle	txtMasterName;
var ListCtrlHandle	lstPartyMember;
var string          m_WindowName;

function OnRegisterEvent()
{
	RegisterEvent(EV_CommandChannelPartyMember);
}

function OnLoad()
{
	Me = GetWindowHandle(m_WindowName);
	txtMasterName = GetTextBoxHandle(m_WindowName $ ".txtMasterName");
	lstPartyMember = GetListCtrlHandle(m_WindowName $ ".lstPartyMember");
}

function OnEvent(int Event_ID, string param)
{
	if(Event_ID == EV_CommandChannelPartyMember)
	{
		HandleCommandChannelPartyMember(param);
	}
}

function SetMasterInfo(string MasterName, int MasterID)
{
	txtMasterName.SetText(MasterName);
	m_MasterID = MasterID;
}

function int GetMasterID()
{
	return m_MasterID;
}

//�ʱ�ȭ
function Clear()
{
	lstPartyMember.DeleteAllItem();
	txtMasterName.SetText("");
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnClose":
			OnCloseClick();
			break;
	}
}

//[�ݱ�]
function OnCloseClick()
{
	Me.HideWindow();
}

//��Ƽ�� Ŭ��
function OnDBClickListCtrlRecord(string strID)
{
	local UserInfo UserInfo;
	local LVDataRecord Record;
	local int ServerID;

	if(strID == "lstPartyMember")
	{
		lstPartyMember.GetSelectedRec(Record);
		ServerID = int(Record.nReserved1);

		if(ServerID > 0)
		{
			if(GetPlayerInfo(UserInfo))
			{
				if(IsPKMode())
				{
					RequestAttack(ServerID, UserInfo.Loc);
				}
				else
				{
					RequestAction(ServerID, UserInfo.Loc);
				}
			}
		}
	}
}

//��Ƽ���������� ����Ʈ
function HandleCommandChannelPartyMember(string param)
{
	local LVDataRecord Record;

	local int idx;
	local int MemberCount;

	local string Name;
	local int ClassID;
	local int ServerID;

	local UnionWnd Script;

	lstPartyMember.DeleteAllItem();

	ParseInt(param, "MemberCount", MemberCount);

	for(idx=0; idx < MemberCount; idx++)
	{
		ParseString(param, "Name_" $ idx, Name);
		ParseInt(param, "ClassID_" $ idx, ClassID);
		ParseInt(param, "ServerID_" $ idx, ServerID);

		if(Len(Name) > 0)
		{
			Record.LVDataList.Length = 2;
			Record.nReserved1 = ServerID;
			Record.LVDataList[0].szData = Name;
			Record.LVDataList[1].nTextureWidth = 11;
			Record.LVDataList[1].nTextureHeight = 11;
			Record.LVDataList[1].szData = string(ClassID);
			Record.LVDataList[1].szTexture = GetClassRoleIconName(ClassID);

			lstPartyMember.InsertRecord(Record);
		}
	}

	//����â�� ��Ƽ���� ����
	Script = UnionWnd(GetScript("UnionWnd"));
	Script.UpdatePartyMemberCount(m_MasterID, MemberCount);
}

defaultproperties
{
	m_WindowName="UnionDetailWnd"
}
