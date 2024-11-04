class PartyMatchRoomWnd extends PartyMatchWndCommon;

var int RoomNumber;
var int CurPartyMemberCount;
var int MaxPartyMemberCount;
var int MinLevel;
var int MaxLevel;
var int LootingMethodID;

/* TT 77355 -1 �� ��� �߰�
 * EV_PartyMatchRoomMemberUpdate ���� MyMembershipType ������ �ޱ� ���� 
 * EV_PartyMatchRoomStart �̺�Ʈ�� updateData �� ���� �ʴ� ���� ������ ǥ�� �Ǵ� �� ����
 */
var int MyMembershipType;	//-1 Before PartyMatchRoomMemberUpdate, 0:Want to be party member, 1:Room Master, 2:Party member 

var string RoomTitle;

var bool m_bPartyMatchRoomStart;
var bool m_bRequestExitPartyRoom;

var string m_WindowName;
var ListCtrlHandle m_hPartyMatchRoomWndPartyMemberListCtrl;

function OnRegisterEvent()
{
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_PartyMatchRoomStart);
	RegisterEvent(EV_PartyMatchRoomClose);
	RegisterEvent(EV_PartyMatchRoomMember);
	RegisterEvent(EV_PartyMatchRoomMemberUpdate);
	RegisterEvent(EV_PartyMatchChatMessage);
	RegisterEvent(EV_PartyMatchCommand);
}

function OnLoad()
{
	m_bPartyMatchRoomStart = false;
	m_bRequestExitPartyRoom = false;

	m_hPartyMatchRoomWndPartyMemberListCtrl = GetListCtrlHandle(m_WindowName $ ".PartyMemberListCtrl");

	MyMembershipType = -1;
}

//X��ư�� ��������
function OnSendPacketWhenHiding()
{
	local PartyMatchWnd script;

	script = PartyMatchWnd(GetScript("PartyMatchWnd"));

	if(script != none)
	{
		script.CompletelyQuitPartyMatching = 1;
		script.SetWaitListWnd(false);
		script.ShowHideWaitListWnd();
	}

	ExitPartyRoom();
}

function OnEnterState(name a_CurrentStateName)
{
	if(m_bPartyMatchRoomStart)
	{
		class'UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
		class'UIAPI_WINDOW'.static.SetFocus("PartyMatchRoomWnd");
	}
}

function OnEvent(int a_EventID, string param)
{
	//Debug( "OnEvent" @ a_EventID @ param );
	switch(a_EventID)
	{
		case EV_PartyMatchCommand:
			if(class'UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
			{
				class'UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
			}
			class'UIAPI_WINDOW'.static.SetFocus("PartyMatchRoomWnd");
			break;
		case EV_PartyMatchRoomStart:
			HandlePartyMatchRoomStart(param); //��Ƽ ����� ���� �Ǵ� ���
			break;
		case EV_PartyMatchRoomClose:
			HandlePartyMatchRoomClose();
			break;
		case EV_PartyMatchRoomMember: //��Ƽ ����� ��� ���� ���
			HandlePartyMatchRoomMember(param);
			break;
		case EV_PartyMatchRoomMemberUpdate:
			HandlePartyMatchRoomMemberUpdate(param); //��Ƽ ����� ������Ʈ �Ǵ� ��� 
			break;
		case EV_PartyMatchChatMessage: //ä�� �޽����� ��� ���� ���
			HandlePartyMatchChatMessage(param);
			break;
		case EV_Restart:
			HandleRestart();
			break;
	}
}

function HandleRestart()
{
	m_bPartyMatchRoomStart = false;
}

function ExitPartyRoom()
{
	m_bRequestExitPartyRoom = true;

	switch(MyMembershipType)
	{
		case 0:
		case 2:
			class'PartyMatchAPI'.static.RequestWithdrawPartyRoom(RoomNumber);
			break;
		case 1:
			class'PartyMatchAPI'.static.RequestDismissPartyRoom(RoomNumber);
			break;
	}

	MyMembershipType = -1;
}

function OnShow()
{
	if(USE_XML_BOTTOM_BAR_UI)
	{
		class'BottomBar'.static.Inst().SetPartyOnOffState(true, false);		
	}
	else
	{
		CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onShow windowName=PartyMatchRoomWnd");
	}
}

function OnMinimize()
{
	if(USE_XML_BOTTOM_BAR_UI)
	{
		class'BottomBar'.static.Inst().SetPartyOnOffState(false, true);		
	}
	else
	{
		CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onMinimize");
	}
}

function HandlePartyMatchRoomStart(string param)
{
	local Rect rectWnd;
	local PartyMatchWnd script;

	script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	script.SetIsInParty(true);

	ParseInt(param, "RoomNum", RoomNumber);
	ParseInt(param, "MaxMember", MaxPartyMemberCount);
	ParseInt(param, "MinLevel", MinLevel);
	ParseInt(param, "MaxLevel", MaxLevel);
	ParseInt(param, "LootingMethodID", LootingMethodID);
	ParseString(param, "RoomName", RoomTitle);

	 //debug("����!!" @ MaxLevel);
	UpdateData();
	lootingMethodUpdate();
	m_bPartyMatchRoomStart = true;

	//ä��â �ʱ�ȭ
	class'UIAPI_TEXTLISTBOX'.static.Clear("PartyMatchRoomWnd.PartyRoomChatWindow");

	//Minimize�� ���¶��, �����ܸ� �����̰� �Ѵ�.
	if(class'UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
	{
		//class'UIAPI_WINDOW'.static.NotifyAlarm( "PartyMatchRoomWnd" );
		if(USE_XML_BOTTOM_BAR_UI)
		{
			class'BottomBar'.static.Inst().SetPartyAlarmOn(true);			
		}
		else
		{
			CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");
		}
	}
	else
	{
		//�������� ��ġ�� PartyMatchWnd�� ����
		rectWnd = class'UIAPI_WINDOW'.static.GetRect("PartyMatchWnd");
		class'UIAPI_WINDOW'.static.MoveTo("PartyMatchRoomWnd", rectWnd.nX, rectWnd.nY);
		
		//����ڸ���Ʈ ������Ʈ
		UpdateWaitListWnd();

		class'UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
		class'UIAPI_WINDOW'.static.SetFocus("PartyMatchRoomWnd");
	}
}

//����ڸ���Ʈ ������Ʈ
function UpdateWaitListWnd()
{
	local string strName;
	local int roleIndex;
	local PartyMatchWnd script;

	script = PartyMatchWnd(GetScript("PartyMatchWnd"));

	if(script != none)
	{
		if(script.IsShowWaitListWnd())
		{
			//class'PartyMatchAPI'.static.RequestPartyMatchWaitList(1, MinLevel, MaxLevel, JobFilterComboBox.GetSelectedNum() );
			strName = class'UIAPI_EDITBOX'.static.GetString("PartyMatchWaitListWnd.Name");
			roleIndex = GetComboBoxHandle("PartyMatchWaitListWnd.Job").GetSelectedNum();
			RequestPartyMatchWaitList(1, MinLevel, MaxLevel, roleIndex, strName);
		}
	}
}

function OnHide()
{
	if(USE_XML_BOTTOM_BAR_UI)
	{
		class'BottomBar'.static.Inst().SetPartyOnOffState(false, false);		
	}
	else
	{
		CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onHide");
	}
	class'UIAPI_WINDOW'.static.HideWindow("PartyMatchMakeRoomWnd");
}

function HandlePartyMatchRoomClose()
{
	local PartyMatchWnd script;
	local PartyMatchMakeRoomWnd script2;
	local PartyWnd Script3;

	script = PartyMatchWnd(GetScript("PartyMatchWnd"));
	script.SetIsInParty(false);

	Script3 = PartyWnd(GetScript("PartyWnd"));
	Script3.m_AmIRoomMaster = false;

	m_bPartyMatchRoomStart = false;

	class'UIAPI_WINDOW'.static.HideWindow("PartyMatchRoomWnd");
	
	//��ư�� ������ Request�� ���� ����, PartyMatchWnd�� ������ ���ش�.
	//�ֳ��ϸ�, ��Ƽ��Ī�߿� ����ŸƮ�� �ؼ� EV_PartyMatchRoomClose�� ������� ��, �����������ᰡ �Ǳ� �����̴�.
	if(m_bRequestExitPartyRoom)
	{
		script = PartyMatchWnd(GetScript("PartyMatchWnd"));

		if(script != none)
		{
			script.OnRefreshBtnClick();
		}

		script2 = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));

		if(script2 != none)
		{
			script2.OnCancelButtonClick();
		}
	}
	m_bRequestExitPartyRoom = false;
}

function UpdateMyMembershipType()
{
	local PartyWnd script;
	local PartyMatchWaitListWnd script2;

	script = PartyWnd(GetScript("PartyWnd"));
	script2 = PartyMatchWaitListWnd(GetScript("PartyMatchWaitListWnd"));
	switch(MyMembershipType)
	{
		case 0:
		case 2:
			class'UIAPI_BUTTON'.static.DisableWindow("PartyMatchRoomWnd.RoomSettingButton");
			class'UIAPI_BUTTON'.static.DisableWindow("PartyMatchRoomWnd.BanButton");
			class'UIAPI_BUTTON'.static.DisableWindow("PartyMatchRoomWnd.InviteButton");
			class'UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.ExitButton");
			break;
		case 1:
			script.m_AmIRoomMaster = true;
			class'UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.RoomSettingButton");
			class'UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.BanButton");
			class'UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.InviteButton");
			class'UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.ExitButton");
			break;
	}

	script2.UpdateMyMembershipType(MyMembershipType);
}

function HandlePartyMatchRoomMember(string param)
{
	local int i;
	local int ClassID;
	local int Level;
	local int MemberID;
	local string MemberName;
	local int MembershipType;
	local PartyMatchWaitListWnd script;

	local int RestrictZoneCnt;
	local string RestrictZoneID;
	local int temp;
	local int j;

	script = PartyMatchWaitListWnd(GetScript("PartyMatchWaitListWnd"));

	ParseInt(param, "MyMembershipType", MyMembershipType);
	UpdateMyMembershipType();

	class'UIAPI_LISTCTRL'.static.DeleteAllItem("PartyMatchRoomWnd.PartyMemberListCtrl");

	ParseInt(param, "MemberCount", CurPartyMemberCount);

	for(i = 0; i < CurPartyMemberCount; ++i)
	{
		ParseInt(param, "MemberID_" $ i, MemberID);
		ParseString(param, "MemberName_" $ i, MemberName);
		ParseInt(param, "ClassID_" $ i, ClassID);
		ParseInt(param, "Level_" $ i, Level);
		ParseInt(param, "MembershipType_" $ i, MembershipType);

		//���� ����(2010.03.05 ~ 08) �Ϸ�
		ParseInt(param, "RestrictZoneCnt_" $ i, RestrictZoneCnt);

		if(RestrictZoneCnt == 0)
		{
			RestrictZoneID = "";
		}

		for(j = 0; j < RestrictZoneCnt ; j++)
		{
			ParseInt(param, "RestrictZoneID_" $ i $ "_" $ j, temp);

			if(j != 0)
			{
				RestrictZoneID = RestrictZoneID $ "," $ GetInZoneNameWithZoneID(temp);
			}
			else
			{
				RestrictZoneID = GetInZoneNameWithZoneID(temp);
			}
		}

		//debug( "RestrictZoneCnt --> " @  RestrictZoneCnt );
		//debug( "RestrictZoneID PartyMatchRoom --> " @  RestrictZoneID );

		AddMember(MemberID, MemberName, ClassID, Level, MembershipType, RestrictZoneID);
	}

	UpdateData();

	//Minimize�� ���¶��, �������� �����̰� �Ѵ�.
	if(class'UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
	{
		if(USE_XML_BOTTOM_BAR_UI)
		{
			class'BottomBar'.static.Inst().SetPartyAlarmOn(true);			
		}
		else
		{
			CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");
		}
	}
	if(class'UIAPI_WINDOW'.static.IsShowWindow("PartyMatchRoomWnd.PartyMatchWaitListWnd") == true)
	{
		script.OnRefreshButtonClick();
	}
}

//���� ����(2010.03.05 ~ 08) �Ϸ�
function AddMember(int a_MemberID, string a_MemberName, int a_ClassID, int a_Level, int a_MembershipType, string a_RestrictZoneID)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 5;
	Record.LVDataList[0].nReserved1 = a_MemberID;
	Record.LVDataList[0].szData = a_MemberName;
	Record.LVDataList[1].szData = string(a_ClassID);
	Record.LVDataList[1].szTexture = GetClassRoleIconName(a_ClassID);
	Record.LVDataList[1].nTextureWidth = 11;
	Record.LVDataList[1].nTextureHeight = 11;
	Record.LVDataList[2].szData = GetAmbiguousLevelString(a_Level, true);

	switch(a_MembershipType)
	{
		case 0:
			Record.LVDataList[3].szData = GetSystemString(1061);
			break;
		case 1:
			Record.LVDataList[3].szData = GetSystemString(1062);
			break;
		case 2:
			Record.LVDataList[3].szData = GetSystemString(1063);
			break;
	}

	Record.LVDataList[4].szData = a_RestrictZoneID;

	class'UIAPI_LISTCTRL'.static.InsertRecord("PartyMatchRoomWnd.PartyMemberListCtrl", Record);
}

function RemoveMember(int a_MemberID)
{
	local int RecordCount;
	local int i;
	local LVDataRecord Record;

	RecordCount = m_hPartyMatchRoomWndPartyMemberListCtrl.GetRecordCount();

	for( i = 0; i < RecordCount; ++i )
	{
		m_hPartyMatchRoomWndPartyMemberListCtrl.GetRec(i, Record);

		if(Record.LVDataList[0].nReserved1 == a_MemberID)
		{
			m_hPartyMatchRoomWndPartyMemberListCtrl.DeleteRecord(i);
			break;
		}
	}
}

function HandlePartyMatchRoomMemberUpdate(string param)
{
	local int UpdateType;	// 0:Add, 1:Modify, 2:Remove
	local int MemberID;
	local string MemberName;
	local int ClassID;
	local int Level;	
	local int MembershipType;
	local UserInfo PlayerInfo;
	local PartyMatchWaitListWnd script;
	local int RestrictZoneCnt;
	local string RestrictZoneID;
	local int temp;
	local int i;

	script = PartyMatchWaitListWnd(GetScript("PartyMatchWaitListWnd"));

	ParseInt(param, "UpdateType", UpdateType);
	ParseInt(param, "MemberID", MemberID);

	switch(UpdateType)
	{
		case 0:
			ParseString(param, "MemberName", MemberName);
			ParseInt(param, "ClassID", ClassID);
			ParseInt(param, "Level", Level);
			ParseInt(param, "MembershipType", MembershipType);

			//���� ����(2010.03.05 ~ 08) �Ϸ�
			ParseInt(param, "RestrictZoneCnt", RestrictZoneCnt);

			if(RestrictZoneCnt == 0)
			{
				RestrictZoneID = "";
			}

			for(i = 0; i < RestrictZoneCnt ; i++)
			{
				ParseInt(param, "RestrictZoneID_" $ i, temp);

				if(i != 0)
				{
					RestrictZoneID = RestrictZoneID $ "," $ GetInZoneNameWithZoneID(temp);
				}
				else
				{
					RestrictZoneID = GetInZoneNameWithZoneID(temp);
				}
			}

			//debug( "RestrictZoneCnt --> " @  RestrictZoneCnt );
			//debug( "RestrictZoneID PartyMatchRoom --> " @  RestrictZoneID );

			AddMember(MemberID, MemberName, ClassID, Level, MembershipType, RestrictZoneID);

			CurPartyMemberCount = CurPartyMemberCount + 1;
			break;
		case 1:
			ParseString(param, "MemberName", MemberName);
			ParseInt(param, "ClassID", ClassID);
			ParseInt(param, "Level", Level);
			ParseInt(param, "MembershipType", MembershipType);

			//���� ����(2010.03.05 ~ 08) �Ϸ�
			ParseInt(param, "RestrictZoneCnt", RestrictZoneCnt);

			if(RestrictZoneCnt == 0)
			{
				RestrictZoneID = "";
			}

			for(i = 0; i < RestrictZoneCnt ; i++)
			{
				ParseInt(param, "RestrictZoneID_" $ i, temp);

				if(i != 0)
				{
					RestrictZoneID = RestrictZoneID $ "," $ GetInZoneNameWithZoneID(temp);
				}
				else
				{
					RestrictZoneID = GetInZoneNameWithZoneID(temp);
				}
			}

			//debug( "RestrictZoneCnt --> " @  RestrictZoneCnt );
			//debug( "RestrictZoneID PartyMatchRoom --> " @  RestrictZoneID );

			RemoveMember(MemberID);
			CurPartyMemberCount = CurPartyMemberCount - 1;
			AddMember(MemberID, MemberName, ClassID, Level, MembershipType, RestrictZoneID);
			CurPartyMemberCount = CurPartyMemberCount + 1;
			break;
		case 2:
			RemoveMember(MemberID);
			CurPartyMemberCount = CurPartyMemberCount - 1;
			break;
	}
	if(GetPlayerInfo(PlayerInfo))
	{
		if(PlayerInfo.nID == MemberID)
		{
			MyMembershipType = MembershipType;
			UpdateMyMembershipType();
		}
	}

	//Minimize�� ���¶��, �������� �����̰� �Ѵ�.
	if(class'UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
	{
		if(USE_XML_BOTTOM_BAR_UI)
		{
			class'BottomBar'.static.Inst().SetPartyAlarmOn(true);			
		}
		else
		{
			CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");
		}
	}

	// debug("���� : " @ UpdateType);

	UpdateData();

	if(class'UIAPI_WINDOW'.static.IsShowWindow("PartyMatchRoomWnd.PartyMatchWaitListWnd") == true)
	{
		script.OnRefreshButtonClick();
	}
}

function HandlePartyMatchChatMessage(string param)
{
	//~ local int Tmp;
	local Color ChatColor;
	local string ChatMessage;
	local int tmpType;

	ParseString(param, "Msg", ChatMessage);
	ParseInt(param, "SayType", tmpType);
	ChatColor = GetChatColorByType(tmpType);

	class'UIAPI_TEXTLISTBOX'.static.AddString("PartyMatchRoomWnd.PartyRoomChatWindow", ChatMessage, ChatColor);

	//Minimize�� ���¶��, �������� �����̰� �Ѵ�.
	if(class'UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
	{
		//class'UIAPI_WINDOW'.static.NotifyAlarm( "PartyMatchRoomWnd" );
		PlaySound("ItemSound3.Sys_party_matching"); //ldw 20120709 �߰� ����

		if(USE_XML_BOTTOM_BAR_UI)
		{
			class'BottomBar'.static.Inst().SetPartyAlarmOn(true);			
		}
		else
		{
			CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");
		}
	}
}

/** updateData ���� , bLootingMethodUpdate ��Ƽ ��ƾ�� ������Ʈ �� ���ΰ�? */
function UpdateData()
{
	local int minNum;
	local int maxNum;
	local PartyMatchMakeRoomWnd partyMatchMakeRoomWndHandle;

	partyMatchMakeRoomWndHandle = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));

	class'UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.RoomNumber", string(RoomNumber));
	class'UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.RoomTitle", RoomTitle);
	class'UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.PartyMemberCount", string(CurPartyMemberCount) $ "/" $ MaxPartyMemberCount);

	if(getInstanceUIData().getIsClassicServer())
	{
		class'UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LevelLimit", string(MinLevel) $ "-" $ string(MaxLevel));
	}
	else
	{
		switch(MyMembershipType)
		{
			case 0:
			case 2:
				//Ÿ��
				// �ƽ� ���� �̻��� ��� getInstanceUIData().MAXLV2DISPLAY �� ���� ��
				if(MinLevel >= getInstanceUIData().MAXLV) MinLevel = getInstanceUIData().MAXLV2DISPLAY;
				if(MaxLevel >= getInstanceUIData().MAXLV) MaxLevel = getInstanceUIData().MAXLV2DISPLAY;
				// getInstanceUIData().MAXLV2DISPLAY �̻��� ��� getInstanceUIData().MAXLV2DISPLAY �� ������
				//if ( MinLevel > getInstanceUIData().MAXLV2DISPLAY ) MinLevel = getInstanceUIData().MAXLV2DISPLAY;
				//if ( MaxLevel > getInstanceUIData().MAXLV2DISPLAY ) MaxLevel = getInstanceUIData().MAXLV2DISPLAY;
				class'UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LevelLimit", string(MinLevel) $ "-" $ string(MaxLevel));
				partyMatchMakeRoomWndHandle.SetMaxLevel(MaxLevel);
				partyMatchMakeRoomWndHandle.SetMinLevel(MinLevel);
				break;
			case 1:
				//����	
				// �漳���� �P���� ������ ������ ������Ʈ ���� �� ��.
				if(class'UIAPI_WINDOW'.static.IsShowWindow("PartyMatchMakeRoomWnd")) return;

				minNum = int(class'UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox"));
				maxNum = int(class'UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox"));

				if(minNum == 0) minNum = 1;
				if(maxNum == 0) maxNum = 1;
				if(minNum > maxNum) maxNum = minNum;
				class'UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LevelLimit", minNum $ "-" $ maxNum);
				break;
		}
	}
}

function lootingMethodUpdate()
{
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	class'UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LootingMethod", util.getLootingString(LootingMethodID));
}

function OnClickButton(string a_strButtonName)
{
	switch(a_strButtonName)
	{
		case "WaitListButton":
			OnWaitListButtonClick();
			break;
		case "RoomSettingButton":
			OnRoomSettingButtonClick();
			break;
		case "BanButton":
			OnBanButtonClick();
			break;
		case "InviteButton":
			OnInviteButtonClick();
			break;
		case "ExitButton":
			OnExitButtonClick();
			break;
	}
}

function OnWaitListButtonClick()
{
	local PartyMatchWnd script;

	script = PartyMatchWnd(GetScript("PartyMatchWnd"));

	if(script != none)
	{
		script.ToggleWaitListWnd();
		UpdateWaitListWnd();
	}
}

function OnRoomSettingButtonClick()
{
	local PartyMatchMakeRoomWnd script;
//	local UserInfo userinfo;
	local int minNum;
	local int maxNum;

	script = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));

	if(script != none)
	{
		script.InviteState = script.InviteStateType.SETTINGCHANGE;
		script.SetRoomNumber(RoomNumber);
		script.SetTitle(RoomTitle);
		script.SetMaxPartyMemberCount(MaxPartyMemberCount);
		//script.SetMinLevel(MinLevel);
		//script.SetMaxLevel(MaxLevel);

//		Debug("OnRoomSettingButtonClick" @ MaxLevel);
		if(getInstanceUIData().getIsClassicServer())
		{
			script.SetMinLevel(MinLevel);
			script.SetMaxLevel(MaxLevel);
		}
		else
		{
			minNum = int(class'UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox"));
			maxNum = int(class'UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox"));

			if(minNum == 0) minNum = 1;
			if(maxNum == 0) maxNum = 1;
			if(minNum > maxNum) maxNum = minNum;
			script.SetMinLevel(minNum);
			script.SetMaxLevel(maxNum);
			//class'UIAPI_EDITBOX'.static.GetString( "PartyMatchMakeRoomWnd.MaxLevelEditBox" );
			//GetPlayerInfo( userinfo) ;
			//Debug ( "OnRoomSettingButtonClick" @   class'UIAPI_EDITBOX'.static.GetString( "PartyMatchMakeRoomWnd.MaxLevelEditBox" ) );
			//Script.SetMaxLevel(  Script.inputedMaxLevel );
		}
	}

	class'UIAPI_WINDOW'.static.ShowWindow("PartyMatchMakeRoomWnd");
	class'UIAPI_WINDOW'.static.SetFocus("PartyMatchMakeRoomWnd");
}

function OnBanButtonClick()
{
	local LVDataRecord Record;

	m_hPartyMatchRoomWndPartyMemberListCtrl.GetSelectedRec(Record);
	class'PartyMatchAPI'.static.RequestBanFromPartyRoom(Record.LVDataList[0].nReserved1);
}

function OnInviteButtonClick()
{
	local LVDataRecord Record;

	m_hPartyMatchRoomWndPartyMemberListCtrl.GetSelectedRec(Record);
	RequestInviteParty(Record.LVDataList[0].szData);
}

function OnExitButtonClick()
{
	ExitPartyRoom();
	class'UIAPI_WINDOW'.static.HideWindow("PartyMatchRoomWnd");
}

function OnCompleteEditBox(string strID)
{
	local string ChatMsg;

	if(strID == "PartyRoomChatEditBox")
	{
		ChatMsg = class'UIAPI_EDITBOX'.static.GetString("PartyMatchRoomWnd.PartyRoomChatEditBox");
		ProcessPartyMatchChatMessage(SPT_PARTY_ROOM_CHAT, ChatMsg);
		class'UIAPI_EDITBOX'.static.SetString("PartyMatchRoomWnd.PartyRoomChatEditBox", "");
	}
}

function OnChatMarkedEditBox(string strID)
{
	local Color ChatColor;

	if(strID == "PartyRoomChatEditBox")
	{
		ChatColor.R = 176;
		ChatColor.G = 155;
		ChatColor.B = 121;
		ChatColor.A = 255;
		class'UIAPI_TEXTLISTBOX'.static.AddString("PartyMatchRoomWnd.PartyRoomChatWindow", GetSystemMessage(966), ChatColor);
	}
}

defaultproperties
{
	m_WindowName="PartyMatchRoomWnd"
}
